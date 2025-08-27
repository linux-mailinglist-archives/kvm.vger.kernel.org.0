Return-Path: <kvm+bounces-55857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C480EB37DED
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 10:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 876DD461038
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 08:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEAAA33A023;
	Wed, 27 Aug 2025 08:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S3p5lQ+e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C92A2F1FED;
	Wed, 27 Aug 2025 08:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756283635; cv=fail; b=QfnJlji6MYYn9wjEUBv1sFBoTuXTTWnWbfR+PiVzTkhBRllilCy4GQvnHpUOZKZz9SQTy11SHA/p37wxoioBCtpEarvsqkfNcJd+PPDs7gbYWXJZwujvt8SpUkGh2WzQSBn1g0v81gvQOejOPpa/1Si5/ScBH6Ckp75gwAr0R5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756283635; c=relaxed/simple;
	bh=WmORm6t4NgWyBom6l7MDx4YsCENHTODUWEBXi3jhuwE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sdFHY3OE0chnNmHt89DhIW4yw+1h76aaRozFJyNCoVG2yPQatr4MVqEfkiyykRh7X/SFe2rDujI+PJTKp/8AWfJvYQTWlilYOGbbAsBo7sMcZ5c6Qp9XVLS2HX02/nPoXxlYH9f3FOMxLG3rvrZtHBWZw+Oy7azz1eQFMKbeoQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S3p5lQ+e; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756283635; x=1787819635;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=WmORm6t4NgWyBom6l7MDx4YsCENHTODUWEBXi3jhuwE=;
  b=S3p5lQ+e4KlflQ76+xlf9GO88/F1hxLtvhF8xqbjAEQdpl5OzUfPL8JJ
   n0BYCROzmpVVVtZpQgNTXJ0W/XCS5OprQukNJ24hriCXsW4xoRZE2f/Mk
   jifMKlmiyFI9ZW72llQ2tWWSDI6OdcrWxbMVvX8d2ROZJ2mJOcBMy6dGw
   dZ4yxlT+O7WpdyfJt/KxncurfMiN6gFDlb8Z0TYkgsG6VN03RrN4EaT7L
   nlCvgPOEe8tKyxhZD6SgCibRMB9fmmi26j16Z2OQTrSlZ7+Ui2oKT1UkS
   /q0K0pzNcsqzcCQiIa4uNGhGT+ZWNwOirxAZiX2Av/x7P5qVRXOqGK2q1
   Q==;
X-CSE-ConnectionGUID: zGzU/JC2TwOasHxKf/KIRg==
X-CSE-MsgGUID: kQxmmj+cTFCwYDu7tilR6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58589319"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58589319"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 01:33:54 -0700
X-CSE-ConnectionGUID: ZL1TSvewRKewUlmVdo62fw==
X-CSE-MsgGUID: f8ztkvaLTvOEn53uYpGm6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169031412"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 01:33:53 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 01:33:52 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 01:33:52 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.85) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 01:33:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WY0e3eaIO6b9REupLojT2aHYVW6nnHXWqX0HHN4ElRQSfW7pcxXUmLrBAGdhrgNj3ud59iYao81XNxtjEcChEXsOQIHosDDimenkiKChU3UrEBQfm7KwqJv6LBP7eRwzOGcEpZxAslvl1lBHrGpJiXLI1D6I7epauXAUWsE86r22sDXSgWW1KUcYZnj2caLEOR3OGTrNeYyO4pmfHamm/NVsqB82d0uSKYlFF0QKcixzDNKo9eH0gBtTETRwlRwfP1yGkoPXauhKoLcACYzYwuZ3z0GVaJym1BzR9rIKxPJXgjI/3NywK1xSp3wD2uFHSVnt5Q/vaf6kTnrjpfUZmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oneKtwdL+jhYY3XLhtkCUd41iEIa2e0bmbtjWdN5slI=;
 b=x4aQsRWhb9I4bGmDHJV1UokRzRuWqIZvOLFkNSbOOiSdyjsJ7n39NSB0LhNrtcj/b3/lxD/sycWD5y8YFKDwOI1zqTpAw/+TOjEEDaoNLFQ4QLoYPdA82mvsKAvO6xyrW4yz1I+lpObqbX+lqXrKpmUKhlLjN5NZUax3BoZOmgasJpAw1Y/u3qspp1VsRPePYsdywLG9pKmyTENXhLc/KIq5sCeaIsmT5BgRwvhwhp15WdnQRs/06MhSawCpWcwHu+uygWmH0GHxxPsWo7iQSBNdM9ooCD5YfH9qpvwn58ayMbow+cmCDsSv6A8Xn9dCFsCqehAlpB23OQdg5nDaCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6649.namprd11.prod.outlook.com (2603:10b6:510:1a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Wed, 27 Aug
 2025 08:33:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Wed, 27 Aug 2025
 08:33:48 +0000
Date: Wed, 27 Aug 2025 16:33:00 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 05/12] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Message-ID: <aK7CvEcYXhr/p2wY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-6-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0020.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: 7269e21f-fdba-4265-b33c-08dde544718e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?YGu47jZBW/f48tYw9SIlayvLTmMjrNatqGydWNMacNz9eVENz/QcSuG4z4p5?=
 =?us-ascii?Q?4UZ7H2cCdHt3q7DcJRYPwsdXiUVWYhF8kuDyCj1scKBGmyiut+6FgsgOHwI1?=
 =?us-ascii?Q?v0CfZIcb/6SbwRzxm8Zenu5KI+nU1rEVcqk1Gqn9L+Ecpntray71y+nRS+gz?=
 =?us-ascii?Q?IC1H+fMv1JM5JyIFZGX11rpdYe8DuP+h/MYGvstDXVcmoOAEvtaDJw2Eu5+W?=
 =?us-ascii?Q?A0CNFT7MD6cn9qURmojsl5OpUcjJgsNYy3goRIedneTkf2RjvDH4S4HrGyjE?=
 =?us-ascii?Q?8qlggzKAzGq+kgCWbGLvBH/rZD1kRt9R3V6TzpB8SU1C3VKIpYk+BIYI5VhW?=
 =?us-ascii?Q?crhKJiSpYBT6/7x5FSd/3684KArxwJewZLSXPJNP2jQw3wT+xrFS1Cn2ZA/b?=
 =?us-ascii?Q?Ll+Vos6P604pa+ZtgAcJeot7/l22EpOVKwri4uCgywlcug2dX5T+Sa/dkPsC?=
 =?us-ascii?Q?hNUHxRaPVXDB7mgVbF0NjV1o/RioD76eId/8iHfKiUbmHe6b7avsohk/ANCP?=
 =?us-ascii?Q?+1WvYfaVdvvD/Qj5AyWac0UUpUHrZhlADa6gyTAP1wIEjPm8Gfjif8MflbV1?=
 =?us-ascii?Q?COHaWI3mcbxKFQKoOE9SfEpyrQtXLmP1ZeHs6um6lYk4gxI3GeFfBfPlVmnh?=
 =?us-ascii?Q?9vSoRZZFHdqtJmDuspCHcCnihlQ4l0M28OZfslT+uUIH1as/4JyhXkIN38le?=
 =?us-ascii?Q?ZY6qE1J+g/061e76VnGafcVHPCGrnPlZ8BwX5sYTEKJvxpF4GkKxmrJrYWKX?=
 =?us-ascii?Q?IbIiceaqnvctiz10bJqKGXvh8yV4EzRawIt8UKIr6dHPy0/544riCRt6P5zV?=
 =?us-ascii?Q?Ukf8wbfJPc4MitT1fkJ5NBIIqe++mn88F+zjRfuXw5vBPt5lZh9614jf5Xh7?=
 =?us-ascii?Q?xfBBm3+mjx/HAXiHZztaeuJyq3bDAZAsbPWTGmF3GePUPH4pk0eVskkyrfef?=
 =?us-ascii?Q?XW8gf/yAXeDlZZoIFnUW9lM0WUOFKZ1jITzdxp7xrqNIMumxQZ9oYgdnonb6?=
 =?us-ascii?Q?0EW7bbKW1ausalUQQN+/ruriOJn/N8Omb7F/Grabq41vxoJqXwu0VUbFiUZ8?=
 =?us-ascii?Q?bWhc7hqi//F52p+xE0d9DlYj7NT6QfnFMwDtzKryhX8HZDtjvLm1WCVDIRZi?=
 =?us-ascii?Q?v0tLfHsrUSVRWUNWuRTbslQ3V1Sq986/lP22x7a1QtEpbP5NccK0v3qS4SCA?=
 =?us-ascii?Q?rqQGhgKE5DIuonFStPv/I6hpi2NvlUbv0Ef+169FzAbrWFtDB1mRxArN0Rr4?=
 =?us-ascii?Q?T13beLkT2F0mKDd/VC6usW9XyiKy7biQ6OGb7N0+6s5+JAD0NIrcI7curN13?=
 =?us-ascii?Q?TRdJQEpYuT1lZL2IlCA47y89hhSNr4Ub6lDpjQVVdlt82sxOCyfT7Jd+0XXJ?=
 =?us-ascii?Q?VDzAarsWwlIxeqBo9NJxeJqfuJjhMzskjSo4KbIa30lQdp0DV5mxGFBXCg2k?=
 =?us-ascii?Q?kM3WVG+QA48=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l+2e6GMr74f/qWO8pBUZ1GsmwZj/zb+1DxtoDXWVEbjrJDAj3XSQM+ghM38s?=
 =?us-ascii?Q?fvnG+QZH92epBz43+9OVacNtcIwkSYmt6E89pp9ZFkxxhBxcp8vSnMdVIqhP?=
 =?us-ascii?Q?WYJxd+bMyqgbTVrCqrCNwkHdtJSH2G8TFny0Us/mDLnUz2YHyBzBWU0Ufr+a?=
 =?us-ascii?Q?Z27ps+mDuw4iWSp96A548/XW/jZ4Y6FWn1iVpt9xz5JGX7XeQKuNhzl81glH?=
 =?us-ascii?Q?+nJYmKBxEEwOEZyJIKnXyWlXv3DiSdWwKbNCU0x+fDMdWRHkgjF/j+Jk6RiT?=
 =?us-ascii?Q?ba/1sZNEoke84k4m7e3ZRSSUtS56I/E+C6+zK7DgjYSp9Yhw1Acv0WRCZvcL?=
 =?us-ascii?Q?8lXG/ASZ0+2uXbtkv5o2zCwsCI8ikYJJ3hB2phTLtr3fl3ZJbIr5njhLaA0b?=
 =?us-ascii?Q?Iwc1v/RYv+2ioZWgbSDxTG6GlnqLTmq/fN8zlr6mvFC4tPTSPBz/L++kfHIv?=
 =?us-ascii?Q?S8sQ2UlWlpAHBErx310FVy9HSozHdA6mxxVAghdu5faIVge2eXJx2s0/ZRM/?=
 =?us-ascii?Q?lFqumftGhFV+Vy2q2OEMb1YGZvzy37uU677cD22PKVi7ASfAOsh3cYsMyaRT?=
 =?us-ascii?Q?fIopILT2JtU0FqSlTOU6gEIDWZCR9mnbq9Cjl8gATVmgHbYFt6NRNCVlRiUQ?=
 =?us-ascii?Q?2qUWxTQHFe/RyZXcml/Uuikwwvkx1Wo9ICovg0LaUdEqpHDmqNFu5xrXNNpH?=
 =?us-ascii?Q?vzB2HecJ6BRYXt7+/+a7Gy0T4+Gvv8mayTzz2fzvHfAEBAfyeLZanBaWl2bn?=
 =?us-ascii?Q?tjm2buhtE6QkD5wQ+zKcJhQGX353Alq6LPOdwxzazAe00Ce3ItXjO6r66PIq?=
 =?us-ascii?Q?WgqL+rNoqbHQIvb1iAxevECMtwl/zKrTtCDYr6Fckf0Bw8dRak48EfhKVIpp?=
 =?us-ascii?Q?twX/kRClVlgYdeX1N8rBR2QpPadDPbKxlz1DK5doRgWxb+Wkf+M3tOKZvaPB?=
 =?us-ascii?Q?xueTjJe3z/i2keiHFfdL06BfDpYLFrnPPHcb/LQ3KOoSBDDoazLI6AJgTVKF?=
 =?us-ascii?Q?R8XeCoeYlkWS4C9muFxDU6ypK6kA5rdrwC0AJQJOSZ0cU7dZSdjm1LKhPn8/?=
 =?us-ascii?Q?DTHot3HDzYrpp/0GMyCbqDLgreMNm4cxKtCUvNx6Q+VR7xBGI025W5LtQeI1?=
 =?us-ascii?Q?pSARDXZce46Ze8iOOHG/qqz8imj2M7kHfQN+ABW+xYUYHI0u07jKOFj4vB4Z?=
 =?us-ascii?Q?l+fyL53ZJY28m4x4oCrsmVjiULHZTFMSPjvL8+DrjQu21uqBshzCcmHPdVnb?=
 =?us-ascii?Q?jfQwCjZhRPwopM1WFdsOaYv7To35lRyzPxA01rgWb3W2LyMqgQZmMTLbLcsx?=
 =?us-ascii?Q?ypeiPgZcDGuAyBoQy/4iDKShlpkpiJIJuLWxkVvUDt7u+Vlr2VXA0inK2upN?=
 =?us-ascii?Q?+6SHFM6jz/MrSI/2a/c3VHI2/I5UFHWX88wtElWf8ETMOnWqrr2niy4jF+UF?=
 =?us-ascii?Q?vzI6jlJzq/b1v18KSK2iD59n4gmal5wJhfHgRRKhszHvrshBS0UfmzjQRwPK?=
 =?us-ascii?Q?8G81iIdJU9hd4rqPF4L38bY9VczH4a65N3UpPrIQ4R8aFGiv60mWMmbpqFkg?=
 =?us-ascii?Q?ZUxhgxJlu05ds3hWbtUs+AMPHS/QDZA/5qVbS0kk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7269e21f-fdba-4265-b33c-08dde544718e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 08:33:48.3862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ShsjoLBRSWBcVhPECDMT7FF5BgCztdwq1JN6b016O99F2P2NmXN4twC41aq8s4Uzp7NYwvRCsl2Mvtz1A5SAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6649
X-OriginatorOrg: intel.com

On Tue, Aug 26, 2025 at 05:05:15PM -0700, Sean Christopherson wrote:
> Don't explicitly pin pages when mapping pages into the S-EPT, guest_memfd
> doesn't support page migration in any capacity, i.e. there are no migrate
> callbacks because guest_memfd pages *can't* be migrated.  See the WARN in
> kvm_gmem_migrate_folio().
Hmm, we implemented exactly the same patch at [1], where we explained the
potential problems of not holding page refcount, and the explored various
approaches, and related considerations.

[1] https://lore.kernel.org/all/20250807094241.4523-1-yan.y.zhao@intel.com/

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 28 ++++------------------------
>  1 file changed, 4 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 1724d82c8512..9fb6e5f02cc9 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1586,29 +1586,22 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>  	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
>  }
>  
> -static void tdx_unpin(struct kvm *kvm, struct page *page)
> -{
> -	put_page(page);
> -}
> -
>  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> -			    enum pg_level level, struct page *page)
> +			    enum pg_level level, kvm_pfn_t pfn)
>  {
>  	int tdx_level = pg_level_to_tdx_sept_level(level);
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct page *page = pfn_to_page(pfn);
>  	gpa_t gpa = gfn_to_gpa(gfn);
>  	u64 entry, level_state;
>  	u64 err;
>  
>  	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
> -	if (unlikely(tdx_operand_busy(err))) {
> -		tdx_unpin(kvm, page);
> +	if (unlikely(tdx_operand_busy(err)))
>  		return -EBUSY;
> -	}
>  
>  	if (KVM_BUG_ON(err, kvm)) {
>  		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
> -		tdx_unpin(kvm, page);
>  		return -EIO;
>  	}
>  
> @@ -1642,29 +1635,18 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  				     enum pg_level level, kvm_pfn_t pfn)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> -	struct page *page = pfn_to_page(pfn);
>  
>  	/* TODO: handle large pages. */
>  	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
>  		return -EINVAL;
>  
> -	/*
> -	 * Because guest_memfd doesn't support page migration with
> -	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
> -	 * migration.  Until guest_memfd supports page migration, prevent page
> -	 * migration.
> -	 * TODO: Once guest_memfd introduces callback on page migration,
> -	 * implement it and remove get_page/put_page().
> -	 */
> -	get_page(page);
> -
>  	/*
>  	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
>  	 * barrier in tdx_td_finalize().
>  	 */
>  	smp_rmb();
>  	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> -		return tdx_mem_page_aug(kvm, gfn, level, page);
> +		return tdx_mem_page_aug(kvm, gfn, level, pfn);
>  
>  	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
>  }
> @@ -1715,7 +1697,6 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>  		return -EIO;
>  	}
>  	tdx_clear_page(page);
> -	tdx_unpin(kvm, page);
>  	return 0;
>  }
>  
> @@ -1795,7 +1776,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>  	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
>  	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
>  		atomic64_dec(&kvm_tdx->nr_premapped);
> -		tdx_unpin(kvm, page);
>  		return 0;
>  	}
>  
> -- 
> 2.51.0.268.g9569e192d0-goog
> 

