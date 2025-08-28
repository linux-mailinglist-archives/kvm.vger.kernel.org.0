Return-Path: <kvm+bounces-56034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E67B394C1
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02B673B86FA
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 07:10:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A7628C84C;
	Thu, 28 Aug 2025 07:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UYFHioZd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445B72222AA;
	Thu, 28 Aug 2025 07:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756364959; cv=fail; b=GZ8RBCNsMNoYFx9ceFcfTJ/RVZOMUauWk1lWpc4EdddEAEw0X+/JMx21K8hEUHMAtu7OaJGNnRzGd1PuDLgYJmRjisBt4npHyMKrubgn/Ad8PZXqRqc+oTF9lokFgy8EQizC2M5KNGBayu+CDTyFphaU0u3/+libhFbEcl650nI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756364959; c=relaxed/simple;
	bh=MklS8zBoVXryn36ZwKh3VwhHvAxOYlXAM/x8Ouh4zQU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S0E2tcWg2YSsINkgLZ3Mjg4Dw/TtG6QFyWm5nvuUyegxneReXPvBEdYnu8i1UOpGQepCsjp+LuSzZHwb+SreJ8yqlySh7Fnc+nzyf3GnxWQI2DLfBW8Og7fZz0zzdlpbjtn+d84Jh9eWucWrRQXVIwbPHBzZITq7OaU4wfxhsxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UYFHioZd; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756364958; x=1787900958;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=MklS8zBoVXryn36ZwKh3VwhHvAxOYlXAM/x8Ouh4zQU=;
  b=UYFHioZdtxr/LVQB7JHr8tv8c2YMSvJyOwW9jAHzWK/ZXtxWS+Ln8OkT
   sJMH1Gh5GmI/NMwfV8cLEq78qKwNI/VailTVK5khQj0++djxYU1qfnIac
   1YUfBExhEuGVm38+V8GKyWkBfpSHqPFkEE9dcHKrewDD7Hgu2KS0K8Int
   08O43YmHLFIISHOeNYJBLpXYmzNX4WObjz2pDV8nIG7bu1TQmguz8L9V4
   bfHuQOztZ392YQgcFKYeDCxWvLpIcv9pJA2rG8ZUEsL+CUsK/9rvzf3ia
   +8GzpPsNzmlbiJiAGarhgwSbeGNm/W8sbDd1VXLy2sIXs3e57qQJn6ret
   Q==;
X-CSE-ConnectionGUID: Jy2zA+G+SpqIXK5yO2OeCA==
X-CSE-MsgGUID: fWbwql+ETdaucQNE/TVfkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="76223157"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="76223157"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 00:09:15 -0700
X-CSE-ConnectionGUID: qrsZhU9mTOudpEpHgs5vqQ==
X-CSE-MsgGUID: sgImPlz+TDK5x94RT9FgkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="207186103"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 00:09:14 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 00:09:12 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 00:09:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 00:09:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T2wxEzlQJzmBWlQKZR6rw1k8+dpTJVzJwf2F1ccTVjz5Caroc4MnlL/U9+SUIsH2rDpyDghVHZzlB79mzDdurvJe0IETabx/8BhYK4p05YBnfop5eOYpwiUPPY0UQe5wZkFYeYjBw9VZmXQJHp0YT+NgZC+MrDBg/KwOP+/rNfAZgK03C7r02v4j94RRINuuizcV4KE6XbDFDR3dmA32qTQ6Pvb15vH+qrW/pRg8N5iOtDMT+feK3r/U8iM0VWXFys1maUIKT8zHnySOW9ifl8ywxnoU+9gSSB1ul3gg6YbsNGhx+47WjKHuhcLIWPAWoouuOlJArQYa7fNn6MmL0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwrX8wwE4wHDUmIF2QIMpw+pJDUWdzh+32ZyKCkia2c=;
 b=uytf8I4877Nq5rLZ9mjDLiK8GUUhvjeKykubaygz51GMuyp5sgen7qMbWaTqTnyJnbJrhbCe0wKtUZkZnnzJ2b/hWygsa7IhHGRTbFhYmf/EP0zv831Z189NQwhyIREeMzMl7FDMm0+32ryK5HKMBPHLydOaDHwtGSfhNVsHUXwaGNlP0R4qmCQXddmiiiXxAHk4hQusGdrpCxAFTV8RC7To+UBTKIuQ/TbtkMuexZcO19Lj840n6BnpOh/W9bCtk1Sl43cNETTwb+q6xEk7T49Y1RBvfUsPW6a02/5GdV3CGlAwYsqZFQdHH08Wy91PFzss+qeIatnLADd+sFYukg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB8415.namprd11.prod.outlook.com (2603:10b6:610:17b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 07:09:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Thu, 28 Aug 2025
 07:09:04 +0000
Date: Thu, 28 Aug 2025 15:08:15 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve
	<vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 05/12] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Message-ID: <aLAAX2fQFZh51ONY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-6-seanjc@google.com>
 <68afa49e235c9_31552945a@iweiny-mobl.notmuch>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <68afa49e235c9_31552945a@iweiny-mobl.notmuch>
X-ClientProxiedBy: SG2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:3:17::35) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB8415:EE_
X-MS-Office365-Filtering-Correlation-Id: bf0fd76b-71e4-4920-e3ce-08dde601c5dd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cEQdeehScj1veN+vnbm/MflqckXrVD6rmm5zJylkSNOzKvb6bTRqL1lysmRE?=
 =?us-ascii?Q?1vu6Kcqib2otX9KOzCWHbNnvON1nSjm/c6YGKQUHDKDGHYRK3gxfs3MXUhzA?=
 =?us-ascii?Q?5zcaoVARPJPBp0mevPG7FmRC95KrGsb7vw7v8yM5eQ9qAcasNrmIBB8FGuP5?=
 =?us-ascii?Q?ew8UEwQaXIq/GOZ2xct2kYYFN91TqWjoJCSXsu/wPp8k1NfC22/+Xvq6ufi9?=
 =?us-ascii?Q?u0KF1onjUqktuVhvWb9QiXdIuGTnEfD+PxcHDvJNOKKKVrUqmbEgHidtSaGW?=
 =?us-ascii?Q?993iTmaJt+oCkL+4Y5ELiJlwhY0Li+BnYZu2p8Tn+79bqmv/N/kGRuXLDOTV?=
 =?us-ascii?Q?S4IEWjVvmxoXvbmsU60Xzk56KwfWHKB0cJAVPaM4dnLAbKyuO0FJ1PoflQ62?=
 =?us-ascii?Q?w+X4WKK+nBL0nlY2yGg63klMfysdkP3oTp3hhxUJPO4MDzMIcHb3GsfZorGN?=
 =?us-ascii?Q?lXR3TnfTUavVgwzQ5ChsvkawYMabPyVNPSmcJzh1z2uMWXUYwNdcM6AoZqe6?=
 =?us-ascii?Q?F3CCeovnT0R7SATliqHTR7eiGXMAlRJBCQ/yy5A70V8oQCMSJFI3oi00sXPq?=
 =?us-ascii?Q?hmXnhy18/qVeNEHamiNBf/5waq7b7N983FDjpW20v6/MINzOMLsRaDyrBsWJ?=
 =?us-ascii?Q?ICSjDCz7e5mPHXQaYjIHEQObPvyq8aEWAbF7rRel0A/Vad4TUF/IKpxiLGy5?=
 =?us-ascii?Q?jScWUTNOenzWSI+HdLayzlNBegD2nZyooUTo861jkgB9ma2VYiVLF2f2400d?=
 =?us-ascii?Q?3GIesc4Z7sWgqTfCyGvADAkd1efa1cFma9S6oneYGulyoik4+jaDZCQq3FsE?=
 =?us-ascii?Q?5Ot/ecNgHShzzZ70RgeakXFwolHDhnW3JLnBrtS62mcVCi+fu3yGYLNd9qUR?=
 =?us-ascii?Q?6tZ/O3QvZ6oXZ5oej7tdXR87h2IyfhAXSkfbsSLlIC4oTzbda9oXfI/GcU/y?=
 =?us-ascii?Q?xMXaOOfxQjNa6MRYwIJnY0HXkmKNO+Awi/O84hsOQlYCPNachfSSTLgNYyGV?=
 =?us-ascii?Q?0jiJbIeQ03k+BFQDgoJo4cBtkSUI3dP8No9q9aDIrkB4qGvgYWz3/t1vjMxj?=
 =?us-ascii?Q?4Pxlk1NZFF+MZoEpQbLdxf2UDxdZiHn2N+elNRxFyETQsV8TPjZU0zT49c/+?=
 =?us-ascii?Q?qHehSIZNvNVbzVtUAULyBmstrXx6NbaDCQGR2WKnYYaSzdYQH3CLMLVpSJei?=
 =?us-ascii?Q?dYiYWXwsvZ/zdaT0pZggnqVKarD3xG2Yrf2mPY7d8yPYMYXBlwe1iPd+/yLb?=
 =?us-ascii?Q?XoBj/1Ct8XVhjWKKajtIItuC7F/s+tgoGW987WV4sPKi7e+sqmxIvJP2gTvV?=
 =?us-ascii?Q?bLDGAAfUh5ZXa1EJhplleQ+FZKCQOkS76ae2ocDf6S0/uRunh+J2040gPqVF?=
 =?us-ascii?Q?a3YEBKQNvkZgZNQr1+8u7Zb54kcsT+pZtrTObv7aAbjCAL2uu+TBAdYK720M?=
 =?us-ascii?Q?XImQm56Jaxg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1FzVMJBBhPVEafVsU4TH0U10snDkLOhryq9tS0gw+iDOR6WbO/7BjYlzG6hg?=
 =?us-ascii?Q?sIpePiZGPeUKfqfLik6Yzm50V0b+vlqgvyxBwWaQWacz4HRgHWnC0WvZU1EB?=
 =?us-ascii?Q?sSt5PhVOrONlJeAcL1lPcAnqscxhulWBylQ6qn4yNnKaDTIQX0T2GkzW1LqZ?=
 =?us-ascii?Q?LUubPFe7ZVMNk6/uV/8dJmGvYVw462l+X8l3SMoux3wqjh3da8l1uXhPk2di?=
 =?us-ascii?Q?GiHrxz1yFpyyAyZOzZY/T5WZP40yruxkz2lIJaup1miU4ANg3E6dy+jNkyeg?=
 =?us-ascii?Q?QU3md9TFC/rodnlhd+C9jHJk+Ph4U9SNpDGYX8TDg6tppZ9BGjGa5UFYr6kj?=
 =?us-ascii?Q?rt5nWJrTsliNxoW5Mhk1yy7wnZLgeJWZy8uZozuAk8PReqsfaUI9TYA5thA+?=
 =?us-ascii?Q?F+/2REnizEE9lntv6Pg9QtMt7/qylz8ybbLr3301POmLQL9QwsuNq/UvYFnI?=
 =?us-ascii?Q?dsEVAZCydqYcH4OSgOx8uVG/OGiX6ueVCSqzPn9sMHGjDUTYsM+Qn/KUVlua?=
 =?us-ascii?Q?o82jg4STn7xCP7mOkSQo8M0YiF/BuPmSBHhLKzxTHBGvWUGuIF3L79WIEGix?=
 =?us-ascii?Q?nRIpBCfwbJmBqI7jxBnAbQ7K/YWZE5wGkiBtZ9OMg76wb0snCy8eQH5iNcEt?=
 =?us-ascii?Q?9nW4hajcoQl75kSDiwLjiJpFWI7viBgEriidX0hVU0YlZGomY2Q/KG8uKxoH?=
 =?us-ascii?Q?ikNGyisIA8M1pSaNsKF+wwndwZ2LVEdVAAjbgQDe14emqH1RUXnJc/EQ407S?=
 =?us-ascii?Q?xsM211OvZTikIA7GK5fZ+44Y8uvaFCFqcaixy+MxWHJ5gGUDLR2ty7pTZr5O?=
 =?us-ascii?Q?QycTyrhLdEVQcLpja/3HzCqWrMc4OfygCY5qUo4syc3UeVn9HjNLPyxDbhZd?=
 =?us-ascii?Q?6nqeyICzXC4lP9YEM2B4Vn+tQIj47TjYVRawN9sAeiQMG03ORN74BFNln1il?=
 =?us-ascii?Q?Ka9flKRbVuHsAdn9qvQFEd91HEZ2A7AAZqm3kJfoqKTMp62Kj3+UZuqsGHCk?=
 =?us-ascii?Q?CnumWIEL59cn8Gtp8k7o8A2pVZRXJZA1q4AC6vE/6TfxKWnLuAVlGUiflZuA?=
 =?us-ascii?Q?MpbWA4CmdHHQKQZhj3XPia7UVSPl7s2CTRW6hLxmQFUF17TI1R4I3lz/Ud2p?=
 =?us-ascii?Q?RTZOAZ2saP2UP6rWSxaGvEI4wB3gGdhefbaV1mu8aqcz0eovRsNWJxjVCasr?=
 =?us-ascii?Q?dlM5YphpbVy8Dd11dKhjLHhSyNUE9ZjE6Ah7mLRTH+c6dDPfHZo2gNZ8fqSi?=
 =?us-ascii?Q?xtbkoI+kTQbJsfLvk0kfKjahMuUACBC6s3/EsAJevyP0oYR8yqkc+4oKBXVo?=
 =?us-ascii?Q?tfzSJ0u9cMXbxpBHBI91gTTk8dhWfI/emdxT7DpqzRkSOW/1PQDfu/smrERy?=
 =?us-ascii?Q?4ri+ng+Wbu94NyOYbMIe8LEKsy0uVkH6XbVMnsm9CcV52RygvLbYP0+GTQFp?=
 =?us-ascii?Q?2XmhnHYsgiKBAMZkcTh3Ktb6lDjWu6Z7v03ksbUuXZzC/G2R19IKdYXpDLEw?=
 =?us-ascii?Q?+su4u+hIrHbfoLqc1gafZG3FOJdbmaVH09XWQqVlzhtV+uDwcCGcxpxMCvzQ?=
 =?us-ascii?Q?7dc1y45S+5nb/kSmCOhRo2uNnCWtoJYitlADtRrn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bf0fd76b-71e4-4920-e3ce-08dde601c5dd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 07:09:04.7029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GlfaEWCmY6zhcv4rvGA9Y+5KQS+HJHJp56Vl4RXGctxPKLx5rVC11KYhgMUNKvDRkMpPtGgRO2SjouJTbmHKZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8415
X-OriginatorOrg: intel.com

On Wed, Aug 27, 2025 at 07:36:46PM -0500, Ira Weiny wrote:
> Sean Christopherson wrote:
> > Don't explicitly pin pages when mapping pages into the S-EPT, guest_memfd
> > doesn't support page migration in any capacity, i.e. there are no migrate
> > callbacks because guest_memfd pages *can't* be migrated.  See the WARN in
> > kvm_gmem_migrate_folio().
> 
> I like the fact this removes a poorly named function tdx_unpin() as well.
> 
> That said, concerning gmem tracking page reference, I have some questions.
> In the TDX.PAGE.AUG path, [via kvm_gmem_get_pfn()] gmem takes a folio
kvm_mmu_finish_page_fault() will decrease the folio refcount.

> reference whereas the TDX.PAGE.ADD path [via kvm_gmem_populate()] does not
> take a folio reference.
> 
> Why are these paths different?
> 
> For this patch.
> 
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> 
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 28 ++++------------------------
> >  1 file changed, 4 insertions(+), 24 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 1724d82c8512..9fb6e5f02cc9 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1586,29 +1586,22 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
> >  	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
> >  }
> >  
> > -static void tdx_unpin(struct kvm *kvm, struct page *page)
> > -{
> > -	put_page(page);
> > -}
> > -
> >  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> > -			    enum pg_level level, struct page *page)
> > +			    enum pg_level level, kvm_pfn_t pfn)
> >  {
> >  	int tdx_level = pg_level_to_tdx_sept_level(level);
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	struct page *page = pfn_to_page(pfn);
> >  	gpa_t gpa = gfn_to_gpa(gfn);
> >  	u64 entry, level_state;
> >  	u64 err;
> >  
> >  	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
> > -	if (unlikely(tdx_operand_busy(err))) {
> > -		tdx_unpin(kvm, page);
> > +	if (unlikely(tdx_operand_busy(err)))
> >  		return -EBUSY;
> > -	}
> >  
> >  	if (KVM_BUG_ON(err, kvm)) {
> >  		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
> > -		tdx_unpin(kvm, page);
> >  		return -EIO;
> >  	}
> >  
> > @@ -1642,29 +1635,18 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  				     enum pg_level level, kvm_pfn_t pfn)
> >  {
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > -	struct page *page = pfn_to_page(pfn);
> >  
> >  	/* TODO: handle large pages. */
> >  	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> >  		return -EINVAL;
> >  
> > -	/*
> > -	 * Because guest_memfd doesn't support page migration with
> > -	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
> > -	 * migration.  Until guest_memfd supports page migration, prevent page
> > -	 * migration.
> > -	 * TODO: Once guest_memfd introduces callback on page migration,
> > -	 * implement it and remove get_page/put_page().
> > -	 */
> > -	get_page(page);
> > -
> >  	/*
> >  	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> >  	 * barrier in tdx_td_finalize().
> >  	 */
> >  	smp_rmb();
> >  	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
> > -		return tdx_mem_page_aug(kvm, gfn, level, page);
> > +		return tdx_mem_page_aug(kvm, gfn, level, pfn);
> >  
> >  	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
> >  }
> > @@ -1715,7 +1697,6 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >  		return -EIO;
> >  	}
> >  	tdx_clear_page(page);
> > -	tdx_unpin(kvm, page);
> >  	return 0;
> >  }
> >  
> > @@ -1795,7 +1776,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
> >  	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
> >  	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
> >  		atomic64_dec(&kvm_tdx->nr_premapped);
> > -		tdx_unpin(kvm, page);
> >  		return 0;
> >  	}
> >  
> > -- 
> > 2.51.0.268.g9569e192d0-goog
> > 
> 
> 

