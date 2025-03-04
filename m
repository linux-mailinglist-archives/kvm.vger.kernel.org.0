Return-Path: <kvm+bounces-39969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F698A4D31D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E46B16D770
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D021F416B;
	Tue,  4 Mar 2025 05:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mCZvS2ld"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169FA1F427D;
	Tue,  4 Mar 2025 05:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741067104; cv=fail; b=RpGFi3HrjaLDqx5VSJIg74bYVT3NBqA4+j0nImOrps43Y6K4wSx523R8FP+sSQ4zD6u0ITftKGoRQgh3UnhRvdWuggeb7rlE3hdvsc+KjfxMfvxsjIzmXysjmNqPFFfMe49KqtX7u85A0XkdfaF/Mz/85g1zkUHGnh0NYr1pm+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741067104; c=relaxed/simple;
	bh=4+LD5ZqtxtdslGWHE6Yb6jabQntRpPyboyb+8EKdpgY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CRkOZMOiF9ZhFOzjKUQzC+2j9YThmlBBWvXPDYUb2Mz6TEjDZ5y3e0xJvMnNQGSAee0iOtMjLiBltj7wGPAZIGNprwwqGYuqXodFVzLM+IlEiM77y/9EE5iTh/sGlZD1IqX4xTLR0XPdWbOi1kiZ8JJRegWUjnWXt1NmFedIjbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mCZvS2ld; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741067102; x=1772603102;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=4+LD5ZqtxtdslGWHE6Yb6jabQntRpPyboyb+8EKdpgY=;
  b=mCZvS2ldhBzm5Wqwz2pPWrH6JLZL8QwveZcSgWpO6x1sbmtYAOYc4phx
   qgbT93Ins3WpY/t9xF9dmonoCz4awvGZsIq4tRvvW+kgk4BCQ4p9uUEbo
   qfG0IFN4goDLdiju1m55eMg55hLstByLQhvKKcHsG6dAp01f7Kn0wc51w
   p8QKQjJyZi4rvVX0dGLLA5UzHcUfxaZi4Fq8B3emWrSYn+t3Jjs6p4CVC
   LmH73gfyUvBVwH1OkFh4dnK6Ji/JYWgd2UsgbR0EhwCl3SMXGzon7Y7q5
   AIGWpfUAJbTLHpMqIXETa7FWrdmMUL0tDH/o9j5uIi5d5a6z39en4p5he
   w==;
X-CSE-ConnectionGUID: xB+iRQeaQmeO8OEe7QUwSw==
X-CSE-MsgGUID: ahryUMOKT7uRrr69PS6o5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="52948432"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="52948432"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 21:45:02 -0800
X-CSE-ConnectionGUID: 4W3Gg6cKTiqlJNzDfgmxAA==
X-CSE-MsgGUID: xQVgnhdRSDKUgcTvYAbTkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="123288262"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Mar 2025 21:45:01 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 3 Mar 2025 21:45:00 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 3 Mar 2025 21:45:00 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 3 Mar 2025 21:45:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nmc7wF3xGTHrDWDrdy5F80bj6ZpNikAASH3wYsfApqs0JDR1KPMutBlab/9TUzufbjDhEhRKxOTWtvXW1OzNa2zZd0iSLgDKH4uoeDGclSp5ikKa/nkn51Gebjb4kb2WIF+rp7FeS4iVpEiFergBRAjwYIHLgoxCOBaKoN50Fr4CsF6DP/cuHmkVUVqsc72X7oExbLyM31Kw4nnTe61qRJK5IJxp9mqrm8gczCJNHGQUKEIjndxmVao14g0s3PE0mt/i3WQf+R+DREXnhcA57HPzb36NC2OK3fpEmW2LsRJ038EdfeqIGRDxvF/nplWxN5Tgeq0cXQo+Dw+YEqFlfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwfqSsIZ9dAOe8t3Rhn2S+1Yy7SlOZRrKGiIcvvko6A=;
 b=Z956gCPinwUpJUH9l9VfznRRQzqoqHXiIeMsE+SP1Z25+TOFOJXbINdjRVywmm6GyYyC5ALuWHOKw0eec66uMXY5+wx8An3NSQ4YzcI/Z60j9TUx42NABAM79EYbxrNpV7+yrv25JBvr/bsEekxfjiv7RQs7LJt1rdPhOmzoPqR0lVowfF77/vgYCx+KaXwleCK7UPK23Ta3uMu4OCWLMq1NbrIkRXg1eYkOMukxKwmMMVuVbvaiAV46r3iBpJhZvweVR+Wr1ZbOLkoU84Vhb+5ru7T9dxO3PKDkk5xP5NrkL0wY+0LdWArCjTWgJ8/IWb64OMvOa776s/vQ4zO+Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7763.namprd11.prod.outlook.com (2603:10b6:610:145::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Tue, 4 Mar
 2025 05:44:58 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 05:44:58 +0000
Date: Tue, 4 Mar 2025 13:43:37 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kevin.tian@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: x86: Introduce quirk
 KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
Message-ID: <Z8aTCaL9YgGi/D1p@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250224070716.31360-1-yan.y.zhao@intel.com>
 <ecbc1c50-fad2-4346-a440-10fbc328162b@redhat.com>
 <Z8UBpC76CyxCIRiU@yzhao56-desk.sh.intel.com>
 <1e077351-6fc4-4106-b4fe-a36b8be75233@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1e077351-6fc4-4106-b4fe-a36b8be75233@redhat.com>
X-ClientProxiedBy: SG2PR01CA0116.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cdbbf97-1aca-44c4-a9cf-08dd5adfb31a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?u3pCJV9DgrOTa6fEJcsZthY2UaB3aD6yvixVJRukee9HAjhISBowbtPixOyf?=
 =?us-ascii?Q?ZV/QgCZUNEhBabvVcAUPXG6PXKqT9Qfvoe8hf+8nQNuCdbVrG0WhjvQBJ60U?=
 =?us-ascii?Q?89WrOoMsO8PYmSt79y7xrtbNC/cXLz9pxSHymYdaFcGG6R5rWeb5M8GlIGxb?=
 =?us-ascii?Q?Bl+O/u1MtGQ4cO3RSW84Z19l0KzfzGUdIZk+elDvhs795//+uxlx8ERqT669?=
 =?us-ascii?Q?8mCevqXgM6v2XOas5KxYo89RCHxc8EXQnR17yFTlcjazJcjds48mK45tqy9J?=
 =?us-ascii?Q?zHtF5SAfwrSYl/sHH6ZQm/BYqNHnZ6/oAe71ewdRwPRBRCfv+kkJxR7fA0wO?=
 =?us-ascii?Q?g9JW/NQCrdEvi+4d7yA5ovzfBBQAMFUODGGiRiKtiXMDAOAuYlFmplGVs467?=
 =?us-ascii?Q?U0NqAWx7jO1HR9HTpkm15P7Kj0Md63fEkYpmkjXWHirPzj4HebQYzjyl+woo?=
 =?us-ascii?Q?SRkPp701YQ4E9h89XVEL3q3RkUVqRhabrk3uYXhU4p3aO4YBjSEb9ahrweRC?=
 =?us-ascii?Q?ApQ05/BgIPMfdiNNP2ktfRPosPYIOebRlgGYXirX3yK283+gSHTBYPIeNITb?=
 =?us-ascii?Q?JLVgLxuuPwVZo4fmmeRivrNPTLIfOUKvk9uvJFPlcrFI8GJw2nwGzlb5OTB4?=
 =?us-ascii?Q?tHWxZMR52S81OVabLuAJFBveOha/CUUWp0KZEJAMuzXM8U24e756L6fcQ8bz?=
 =?us-ascii?Q?rlV/IEqPEiGNPerpXpII1aPEIMQ01oE49hsdgDUe1F3LSRXoSDd95VgS8r8i?=
 =?us-ascii?Q?ZV9n9pHI/t/N9caLicxne6XggAv2pGjwX1+j6f4MNFSOD/v38K2CkCLLTmK1?=
 =?us-ascii?Q?R7BSxBEu+H+IWcDgxxkfmSBRmbfuJVMza5LoM0IR5R3Wv8gkPBMr2F56IU0h?=
 =?us-ascii?Q?a9BnhEszX9WUYoztlT14BBfMES0vnC33GWSF2ydUUTBm14cq6cN+GtAwrt4j?=
 =?us-ascii?Q?I8cGf3bt3+58H7uZxqtPcEsyXBV/KVLE9z4VKQ/BRzmFkp1h48cVIWhrljP2?=
 =?us-ascii?Q?3JqOIuOTFUh0X6b3TNxfxEsQsl6n5WPkaL4CBIK/nnTF/dWDJzfZE/rgFetw?=
 =?us-ascii?Q?7rnOvhPsN0O+tYXnvSoOODl8iKX9uBirL1I9oIWGGO6jlMCLDQDhUukRM378?=
 =?us-ascii?Q?SbZwK9hdYLSHbYMfrwIZ7e1dw2z4kGF64pZZ/RO+hrWBSQ8kQzNGYxlXE/3A?=
 =?us-ascii?Q?JhMQWy87RQ23xyneMtAVGodql4KbARoCIMBXJusN8KKDIO50EwI1XEnMVQHN?=
 =?us-ascii?Q?JjeSBaKFx0jDYiaej2+jVp9LSh+MQsTIjYNmVaP3KKzIDFsLSDBtjpZqaUeA?=
 =?us-ascii?Q?Sysq+SafUjstFpsHDESjMA1/UT8HvgJXq/wStfVhzqXJtTrmYX5J9znGLRx1?=
 =?us-ascii?Q?UM6jL9Bnfhn/5b5UIhGckMNaKFWo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tOq9yP4G0CTEkPr2qXEF9Fwq30mYZwOe+HXU+tIbMMcj/nF+X+XUQJ+9E4cX?=
 =?us-ascii?Q?FZvV+uzL8Htjnxe98GYCacscyXCfvQISKjZy5WcQ/XK4kvaiGZv2G6Lalyth?=
 =?us-ascii?Q?v3hSBISS4T4kY+JHvQ+M3jN9XmWF7rJleV5+2ul9MK3p+tNsTcVTvYLaMaG/?=
 =?us-ascii?Q?AlmMs27Z8Erg9vO93HgoL4WbAxRwMu0J7LvJXZDWc9PKmu7PimQE5Czh2rjQ?=
 =?us-ascii?Q?nzKC/0nsBgKIuyKCSxXB5uQVlOjMCWr2Ixre0jbDtkCS+TElBkME5e6aFYuv?=
 =?us-ascii?Q?X+B/O+KTivWqWwadO6BIBMsxoeOyXdQI8oaT9QDGsRmMP4wVet4RvmxJRnjI?=
 =?us-ascii?Q?Q2cWWtuvB+56jHcwHl+8a/NvUMi1NOO0avFvxzrIMYOxTaz3a1Go9Q5YTMuN?=
 =?us-ascii?Q?IaXfpBPBRKT71bNsVx7OtQj/mzVztEsocdv1oRIrYhFqOk3rBv1c3Z+iDS7J?=
 =?us-ascii?Q?pRgpNaygQzJDsP/0oY28XBj6UK1Us3/T1H1I0WcHVwsr39oDarsuCUIv80OY?=
 =?us-ascii?Q?gHmWj/0QwY0B5C+zzEwgP5OZ6EFA1V1If7a/0DvEbhOMJ6hqUk918/QwFtVf?=
 =?us-ascii?Q?K1XhDrbVsOwLevca42m9BF8X6ovLxJaDzoyNYaJ3rYeGlTXZCxruI02l9L/a?=
 =?us-ascii?Q?e2XjNlr9dFp/vmKd8yP/5zE9F+/pz206kuExU99bc5u/jMNzBnsVOAV6XsoC?=
 =?us-ascii?Q?Dj0NK0lX+GP7S0LLXEWIqjTvm8+vPudLD6wafGY7WJ7a7w/vE9kcC74/lsRe?=
 =?us-ascii?Q?FC9yYjlMg4hTdxnwWCprAIm01CCR8RIRLDoYGjTcX43HLz7yCqZx5e+0lwh8?=
 =?us-ascii?Q?G76zX7eyJgYja/OxlFwkP2qjT01p/Mo1Ntv1rJecKDDdKLxOPmyay/ZGWTLU?=
 =?us-ascii?Q?utG86r1kNBAw5VlLYZXgj0+HGqrfwfD5MI0wqNcJinX1eGrXNZBrAY81PwqV?=
 =?us-ascii?Q?+7gxKtW3WaMfkjeHn1l50z0XECIF/b+Yt5QYZf6vP9Ltve+fqRHPS3T/7czP?=
 =?us-ascii?Q?f8I+a5IOlYBlL6JyFvwN13/10mJn5TunC0Pl0mOH68fi7OI1Epgy6hKJS3yE?=
 =?us-ascii?Q?CZ+26IVF+SD9d0nFL6BqOpyV8pZdX6UWZh4qsrN6S4EwWWHupva0ugccxrLf?=
 =?us-ascii?Q?tUlQs2g6OLwY6XigvSoMrsJoEi/sBzK7iQKHp2klhXXl+nnNepih3901KCmG?=
 =?us-ascii?Q?CVQCaFL+f70BrZBnC2Hd7MIBE57ZD+nkUJ3uxQiQ1/chzJ3Qn347zCC+CFSl?=
 =?us-ascii?Q?qUcwWi9/UnMABgYgVe+XLgriYphhcf4KDU8h4QNQr2SnHqEsb9HPgTV0MuM9?=
 =?us-ascii?Q?3NzTZyN3h31nb4GcgVO+iyJreiMoW71p1vg8IwJlvGqzjFJwfm1v0TzOnNdz?=
 =?us-ascii?Q?Q8ySXtr8pejat4y5iv8mx9AxrNvvNsy/ju1VCNRSk7xbVJ8ZyFKGwNlaiWOS?=
 =?us-ascii?Q?Rn2abmJpf6/jXVyYVUXtz0VdioK746k9jmH6yxNuhm3uxClcSjHVuYtkkcb5?=
 =?us-ascii?Q?px8pypDlWFZ9mE1kqEM/oAGi7fIrbeymM0kyicFf9RqebHjvgf/mo0HrJsfZ?=
 =?us-ascii?Q?4vSKW74R9P70FMqk+t70xqk+orV+UIM8n4rR4m6d?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cdbbf97-1aca-44c4-a9cf-08dd5adfb31a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 05:44:58.6707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: re0KYULsPqOYxRhRdhJmkqkzgTVKmtLhb8FBZ/k79EZRI6aR8wiw4djK4bATbFHKXU7rskloLjKVh2vFQSWrUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7763
X-OriginatorOrg: intel.com

On Mon, Mar 03, 2025 at 11:25:08AM +0100, Paolo Bonzini wrote:
> On 3/3/25 02:11, Yan Zhao wrote:
> > > the main issue with this series is that the quirk is not disabled only for
> > > TDX VMs, but for *all* VMs if TDX is available.
> > Yes, once TDX is enabled, the quirk is disabled for all VMs.
> > My thought is that on TDX as a new platform, users have the option to update
> > guest software to address bugs caused by incorrect guest PAT settings.
> > 
> > If you think it's a must to support old unmodifiable non-TDX VMs on TDX
> > platforms, then it's indeed an issue of this series.
> 
> Yeah, unfortunately I think we need to keep the quirk for old VMs.  But I
> think the code changes needed to do so are small and good to have anyway.
> 
> > > There are two concepts here:
> > > 
> > > - which quirks can be disabled
> > > 
> > > - which quirks are active
> > > 
> > > I agree with making the first vendor-dependent, but for a different reason:
> > > the new KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT must be hidden if self-snoop is
> > > not present.
> > 
> > I think it's a good idea to make KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT out of
> > KVM_CAP_DISABLE_QUIRKS2, so that the quirk is always enabled when self-snoop is
> > not present as userspace has no way to disable this quirk.
> > 
> > However, this seems to contradict your point below, especially since it is even
> > present on AMD platforms.
> > 
> > "we need to expose the quirk anyway in KVM_CAP_DISABLE_QUIRKS2, so that
> > userspace knows that KVM is *aware* of a particular issue",  "even if disabling
> > it has no effect, userspace may want to know that it can rely on the problematic
> > behavior not being present".
> 
> There are four cases:
> 
> * quirk cannot be disabled: example, "ignore guest PAT" on non-self-snoop
> machines: the quirk must not be in KVM_CAP_DISABLE_QUIRKS2
> 
> * quirk can be disabled: the quirk must be in KVM_CAP_DISABLE_QUIRKS2
> 
> * quirk is always disabled: right now we're always exposing those in
> KVM_CAP_DISABLE_QUIRKS2, so we should keep that behavior.  If desired we
> could add a capability like KVM_CAP_DISABLED_QUIRKS
> 
> * for some VMs, quirk is always disabled: this is the case also for the
> zap_all quirk that you have previously introduced.  Right now there's no way
> to query it, but KVM_CAP_DISABLED_QUIRKS would also cover this.  If
> KVM_CAP_DISABLED_QUIRKS was introduced, zap_all could be added too.
> 
> > So, could we also expose KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT in
> > KVM_CAP_DISABLE_QUIRKS2 on Intel platforms without self-snoop, but ensure that
> > disabling the quirk has no effect?
> 
> To keep the API clear, disabling the quirk should *always* have the effect
> of going to the non-quirky behavior.  Which may be no effect at all if the
> non-quirky behavior is the only one---but the important thing is that you
> don't want the quirky/buggy/non-architectural behavior after a successful
> KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2).
Thanks for this clarification!

> 
> There is a pre-existing bug in that I think
> KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2) should be cumulative, i.e. should
> not allow re-enabling a previously-disabled quirk.  I think we can change
> that without worrying about breaking userspace there, as the current
> behavior is the most surprising.
That would be better.

> > > As to the second, we already have an example of a quirk that is also active,
> > > though we don't represent that in kvm->arch.disabled_quirks: that's
> > > KVM_X86_QUIRK_CD_NW_CLEARED which is for AMD only and is effectively always
> > > disabled on Intel platforms.  For those cases, we need to expose the quirk
> > I also have a concern about this one. Please find my comments in v2.
> 
> Ok, I'll reply there too.
> 
> > > anyway in KVM_CAP_DISABLE_QUIRKS2, so that userspace knows that KVM is
> > > *aware* of a particular issue.  In other words, even if disabling it has no
> > > effect, userspace may want to know that it can rely on the problematic
> > > behavior not being present.
> > > 
> > > I'm testing an alternative series and will post it shortly.
> > Thanks a lot for helping with refining the patches!
> 
> Thanks to you and sorry that the patches weren't of the best quality - I
> mostly wanted to start the discussion on the userspace API side before the
> beginning of the week in your time zone.
No problem.

I realized the problem in my implementation of excluding quirk IGNORE_GUEST_PAT
from KVM_CAP_DISABLE_QUIRKS2 on TDX platforms.
This could lead to confusion for userspace, which wouldn't be able to determine
whether:
- it's an old KVM that does not support quirk IGNORE_GUEST_PAT, meaning KVM will
  ignore guest PAT, or
- it's a new KVM that supports IGNORE_GUEST_PAT, meaning KVM will honor guest
  PAT on TDX platforms.

Looking back, I was too KVM-centric. I just thought users wouldn't need to invoke
KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2) on AMD or TDX, but that was wrong --
I did not consider the issue from the user's perspective.

