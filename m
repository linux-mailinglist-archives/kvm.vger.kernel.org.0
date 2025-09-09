Return-Path: <kvm+bounces-57087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C020FB4A8E7
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2E72361F45
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBB72D1F4A;
	Tue,  9 Sep 2025 09:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ne4D/Yjy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4081E28C87C;
	Tue,  9 Sep 2025 09:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757411590; cv=fail; b=K8ixmuTWc8IiL7jG0S5jkCtLqc7nhISuoGTSkUBe5Hjexku98WTEvOxpYzF5rgL3swaYixBZnnnOXjkeUU02uSevkj+cfZ5ZSueNVr23skKwv+lGUd26qTMV7Fz2hMUgan4NU+blZwDDxcptlbdx2FO7sr90xqicfTt9xoOSkUw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757411590; c=relaxed/simple;
	bh=pSn6PXnh1Mz+AjL5euHZuwXMsLRpneUjB9UAUWCtCaY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p9j+ekt7fSJnSw0X2S3S8ig0iintL42IvG+v0nope1d/kx4R4Ug7o+k5HtEWFYEmu2bpsd8Ael5s1Z/522jepJsIfB8L7HACfg+eWtAhSb7Je4amREAvRHrMs3jjYlL7Qvz+JtAqQlAHF88UT5kdWSkFw29xUV3LsbeHDDUx5L0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ne4D/Yjy; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757411588; x=1788947588;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pSn6PXnh1Mz+AjL5euHZuwXMsLRpneUjB9UAUWCtCaY=;
  b=Ne4D/Yjy2qrmLZ/+vfY+uVb9kAj1/2+H9cgRGYTLNw8JW4G+Ft5asyQ9
   /F7dWSnO0m+toqQ/GDi/F9Qmhcp6n/vyih08ira/bMvTKI5ZGhHahVaTM
   Fecw+Ce2o1XUAAAttpLnLf0oKzjlHEiNF1DXDJPn86zSGX+isq7ptCMHD
   /E4N6LNA/UkRzNXxb+cpRkXLzBjVpnvbESqtc7jZ3fFgsrSlHG+apXva5
   vfIqWVEgzj6S/NQ19oiggYSzi8WUB3VHAL0zSwXIKh8fy7dpQ9mH6THsh
   jU0GwVILHDabxKtOB12asvMSQPDXHOt3J3a7gJehMtPC9VT4PCsDpvbf+
   w==;
X-CSE-ConnectionGUID: gAClgc02TxuYO8v9+3lInQ==
X-CSE-MsgGUID: n11OEc9DTY23Ank6bio9eQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="59762195"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="59762195"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:53:02 -0700
X-CSE-ConnectionGUID: RumisWDEQkCP9qp43hJQdA==
X-CSE-MsgGUID: Fgb0C7ptReK/tWpL2a47Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="173427442"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:53:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 02:53:00 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 02:53:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.85)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 02:53:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x4Xl30Mx01nZ1TpjQyQlFp6uR8tr5W8igs/IVDvuWiCterxGzVbzB7v7oFNISCOmGNnpGBpomN8ypWxf1FwST7KrMJ0pS5kAx3Pj7uDBh2iO0YWpNOzXn411AZt9U7ZD9LZ1T6/eeF1y91EfNAla+m/mmMfG+ky4DifeKOmCGgU8BtLuHI4cRpRcWdPgbfQI0xUR9inDXG361s8P7aixnlzSkHOE7KU/SvMvuMelIqC2roD7ARwyFx0p8ayakWJDGyXycNiCSkDGaNhx5ZmDB2HmWvVMPUZrANy4v6t3X92+XnqCQJO1wxCpJU/g2oa6JZLdLqlJhsUBCLtPzQRVcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxU/BzsXjahtta7HL5/IogQVa6IX4l5YmKhQhmmDhBU=;
 b=l6rAPKcDCx8CMve1SPyfIqf1Us0iLcBKYS8Fbdlr4kEhJ8NPL+ysCBi0daVYsmMge9GhiC4VROhyYmFS5lOlMa2j55zZkBLbI1hObUL/cUKDkaNrcZp1bA7ypeyh5uuAdOhp0sdeQ2Gxi6QctdQvPrFeCZbOgxlwfB7VF4yrcA2kOHGTUKlyuRCH8Z4WtgVZ1e4OjhiQFUNQSUPEeQ3gjPhksFyHIgtVk5Jv8aiWtAJQtTdsUSs3ufOIhCR7+KY/8qG2ME5sAhEvUzSrJ5bzzmI62XWd4fYaPq4trVNSOWgwPdYz6ZnJXpM/dC3FJ6x6IS2vxGKwl9VWSl/7Dgc+JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB6500.namprd11.prod.outlook.com (2603:10b6:510:213::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 09:52:53 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 09:52:53 +0000
Date: Tue, 9 Sep 2025 17:52:39 +0800
From: Chao Gao <chao.gao@intel.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <acme@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <john.allen@amd.com>, <mingo@kernel.org>,
	<mingo@redhat.com>, <minipli@grsecurity.net>, <mlevitsk@redhat.com>,
	<namhyung@kernel.org>, <pbonzini@redhat.com>, <prsampat@amd.com>,
	<rick.p.edgecombe@intel.com>, <seanjc@google.com>, <shuah@kernel.org>,
	<tglx@linutronix.de>, <x86@kernel.org>, <xin@zytor.com>,
	<xiaoyao.li@intel.com>
Subject: Re: [PATCH v14 00/22] Enable CET Virtualization
Message-ID: <aL/4548thhQFylmp@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB6500:EE_
X-MS-Office365-Filtering-Correlation-Id: 0709c623-06f1-4a3e-efbe-08ddef86a4c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VwQMvw5NZISemwK5SnVgXHRK7ZTpe/+MbOhHI7XjJ3t4Es5DSvY0imVdCp3/?=
 =?us-ascii?Q?oOWpkHpqPWOmyErKFB6geVoN4mffv3aOVJq/mQomRFHAGJM9vbtjk61x2kob?=
 =?us-ascii?Q?FMj5A4sTUD9JINqsB5QokYE0JlxLcChhHDWnFOfbyD8/nONLs+KYVG2+uJqZ?=
 =?us-ascii?Q?m4qImFeD6pVFAUIXBgD7mJEaDbQzDXdJq/7E/hlM/tCcNz4eIA5a8+lApOqg?=
 =?us-ascii?Q?kmpaYhFsBt+/aYaUrwFhMHb+LjmRDypiA1ZIBy9wowiWtTE6Yz8TpwmBe4aG?=
 =?us-ascii?Q?saWDz5+SdQIO4q3MwxdbAQCvcXLp3GxLBYPiVmmpbBauyaGhkydTnizJ9G8b?=
 =?us-ascii?Q?3caWlwZoHuN+yCRLi9pOLOzlqr7YszcgQ/xtIvI00fcKmqi80ADlGwyWhK2R?=
 =?us-ascii?Q?DLwKHErEDn5TwyH+kgGsHnrav4ZGHm/4gYEP2AzKHNJtdOfhB3+uefcyzFOd?=
 =?us-ascii?Q?qdzyJj4VlvCZ20DjCg7lManeTHn+sQ/Ws0/cwI0xPAiO9hLSYsJ5Rgse68cG?=
 =?us-ascii?Q?bExnSbEgioDGztfVTsHiM6hnsKKDlQ2oMyDVlzLurKGmjrUONilEEbDo7Y3l?=
 =?us-ascii?Q?ETmXhJasLBq++hvMWNOlx0Yf1WTgIDRCiV9BdqVF2RdZUDC57WIqsiL6Dc9A?=
 =?us-ascii?Q?rpCHOsBSW8yUatXF9XmYhyP/HKKtYTrce4QA13oEqKcgPIeeEEuwEREgvtJ/?=
 =?us-ascii?Q?tBp63JQ+3gz6bDOykJ7Y7XCVeeuJrua8velDlqg1iNS055oda+f62196VgOS?=
 =?us-ascii?Q?GXLwfQjWC0yD/R35W4PN0p3mIXjGN7vVzNnIMFzONKJI9MeZhUvtGFzKAccU?=
 =?us-ascii?Q?sR/SV5599q5pG0YqtBy54s0Pa5YUf2046VzymEO6Xbb4khKIsHihhy6Lp2yN?=
 =?us-ascii?Q?6BpADyaQfZ/U3sxhX6tLeMtgXtvTFchPpseP4sVXeWyyKrGYn/kxc4M1YC4/?=
 =?us-ascii?Q?5GoqpraFnzfOi6kzgixgApPcbUn/MqNW1rcuFX51HFyiGSMXsbY87LA/3e/G?=
 =?us-ascii?Q?J32t5Em5qx5qQtwpoC9UQgq1WCDjdet+K2rov/DYQh5Q69bZLipdeUWC5Aot?=
 =?us-ascii?Q?a3ISsIiantaiWWLcw24YJjFtvsljHHoYHKZuPj+WHjwspOd8pYJRMYRt0n7k?=
 =?us-ascii?Q?aBaXckXZ2QXxVZsre3ypyGyk4ZYSgKQsvuhJS+vt8sTM6wuvo4+F828I+gut?=
 =?us-ascii?Q?mbhWeYEOSG0+vjZy59kfMFSdqu2aXiwzlJzLgVuYFNRIzlqxiVnuAd9sKw26?=
 =?us-ascii?Q?51Z/hxT+83z3r9LstPOd+v972BPrZWafz8VDTE6JZG32ujUeUq2uxJqDRx9q?=
 =?us-ascii?Q?lqEvX8rj8gfktMH/ZTE3hOfiGx1bl7tFyrzttbKO69dpcNcoVbavgw98lUyR?=
 =?us-ascii?Q?RvT2dCWJa0WcCN5tls1+mFLIrZHp7pE5zIOZ+BaEvDib02BdturTy/yQXhSB?=
 =?us-ascii?Q?1fYEDQov+Xg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?97zXG/rzkxtTjvGyEjvoOf7Z4J91YEHziau5ztWoItMAwHC+HjpqZ8JgEZ/5?=
 =?us-ascii?Q?uN5vTV3P3fsh2hxbo2s9sAtvPHVrmiz2tjdVOMKFnEjYtCBXwvKyDtBy3jzV?=
 =?us-ascii?Q?cmJrjX5+svrRBvZ8F6+IVGSUlX/UiMv8tKTDDvpLp2RgvYkMizuHa+3daVTO?=
 =?us-ascii?Q?RVCavY6Fdt7TvdIALDdtQRzjZ9lP60LpFfVNSlw+S0bsyMzwfYH2K8dYFCYc?=
 =?us-ascii?Q?Pgupa5Rap3WmITjPZKlW4QHsAqRg3V4iOJWy18nUTNV3GjAeoBPfOrR80s7u?=
 =?us-ascii?Q?wfoDo635t7xH/L+5eiEHtpG7lI2k3qD1QQdD+TdlBs4bfs/jbnFphrkcHAEj?=
 =?us-ascii?Q?BWS8MLs0m+mbN038WZLL6i2vcFHnPI1Hsylg/EvQAqSDBgZ+4gBYde/BHmi2?=
 =?us-ascii?Q?VQg0Y8giyQtlIzjmMGtZXTY3mbGlL5RbqBWtI+jRerZvNtKr4JTCE7kpjT5q?=
 =?us-ascii?Q?3SPr67WUrGzHaMj2SBE7U+ryjk5DDRb+1Lr0KkNHgBgMi7BdsoJJNt7HVF9N?=
 =?us-ascii?Q?+kFu0+B5olw6yXQI/T30PVsqzxwn5A7Q/kRq/lVZHVl4xq/s+7tvfgkQUD9/?=
 =?us-ascii?Q?d7qLJeE0Z0mOLx1AbX2dPYNoj/Ikda85nalcYg0UaDcH1vBgfUbx4jYxyo81?=
 =?us-ascii?Q?JMEh+4gZcg+DOZC2kgEZlTt4OrsEhWEbMk2WlYIfZb4hojCd9/YLnse1xvV3?=
 =?us-ascii?Q?gSzKPHc9EISbcy6l4MYxz/aeAtf+oHY4+WadAyQEsbEOC9V0ZnPMTbEtmO1E?=
 =?us-ascii?Q?VdbfR2G0rhHk5fGyX2c0P7HhNMMC5az+9j4tmIxeClOf5wYwyYfarp1kG5uG?=
 =?us-ascii?Q?6EQO+hu06541iBxXErSNisj/HZdIITcDNPhZyiztv+CLENwnmBx0/hY1xnhw?=
 =?us-ascii?Q?RcM5Qk4gamHhUL+/O7bPyWDqGrbsh9DCmWqEq8jGs69WpMxT9ZsNYCjzrLJj?=
 =?us-ascii?Q?kcB+hwOUdlIXyoQ/O7Ks/cfoh5NUooum7lGvcJmZN1mZJPSE1oR/t22MlF98?=
 =?us-ascii?Q?IngbKkicTMncwMLQhaOal+OkmV4n3OqYdP1kWMZ+JrqqHUddB6Zpw1eTMIeW?=
 =?us-ascii?Q?sLuyo8HZ5Xtme2swnCcZHs1/dpoeUE04Y92AZ18yVrBC71f60l30oXgKD13G?=
 =?us-ascii?Q?8G4+T5pd/k6G7yYBXTXbKX+vEK8J64m+fvHGNErhbp/NBnctVFZZawQ2f/Ip?=
 =?us-ascii?Q?lrTTgIn0k+xV15pOoDjR1KuVeF8WS+KLqWANiaxXV2plKUAcAtqx+mS/cDpn?=
 =?us-ascii?Q?ny4GyDwMCwXrqQUescaQ37zg5t2f9yQKCaT6/BWZUAzBI8ovZ44T1gUqr/Uv?=
 =?us-ascii?Q?Mutyey/wERTR2Vfae5YMl8Ei69qWnEIXmFh9t/XcuH319EEY29IUh+BhbwlN?=
 =?us-ascii?Q?i0I/gpNYGnXWooxb7Dm0B9C0OMtSdLowH4JZLzf7eHQ1GSwbPVhTtqwHsDGq?=
 =?us-ascii?Q?kjuRccaxetIPCGoEwJhM18USnxGVYsuN2VZPtSsPCwiSfUnhGkw5QLF3oA2x?=
 =?us-ascii?Q?//AxVgCZ0m4GXBLUhCBbzBZ91Z2MlTuZJgcZ5e4OhalEiSyNYzTEFBHJVjwt?=
 =?us-ascii?Q?fwfLBvEfXYpYVyjypJBjdSwVk63JaGfB878RmCn6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0709c623-06f1-4a3e-efbe-08ddef86a4c1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 09:52:52.9181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LH/aL+zr006ct/IPoQfo16cTkS1swmE1k22kK341xXxMuZ9NSU3YxdALlk0nqap8lwR3aBicNwbKEwrL3F7Mig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6500
X-OriginatorOrg: intel.com

On Tue, Sep 09, 2025 at 02:39:31AM -0700, Chao Gao wrote:
>The FPU support for CET virtualization has already been merged into 6.17-rc1.
>Building on that, this series introduces Intel CET virtualization support for
>KVM.
>
>Changes in v14
>1. rename the type of guest SSP register to KVM_X86_REG_KVM and add docs
>   for register IDs in api.rst (Sean, Xiaoyao)
>2. update commit message of patch 1
>3. use rdmsrq/wrmsrq() instead of rdmsrl/wrmsrl() in patch 6 (Xin)
>4. split the introduction of per-guest guest_supported_xss into a
>separate patch. (Xiaoyao)
>5. make guest FPU and VMCS consistent regarding MSR_IA32_S_CET
>6. collect reviews from Xiaoyao.

(Removed Weijiang's Intel email as it is bouncing)

Below is the diff between v13 and v14:

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6aa40ee05a4a..2b999408a768 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2908,6 +2908,15 @@ such as set vcpu counter or reset vcpu, and they have the following id bit patte
 
   0x9030 0000 0002 <reg:16>
 
+x86 MSR registers have the following id bit patterns::
+  0x2030 0002 <msr number:32>
+
+Following are the KVM-defined registers for x86:
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x2030 0003 0000 0000 SSP       Shadow Stack Pointer
+======================= ========= =============================================
 
 4.69 KVM_GET_ONE_REG
 --------------------
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 061c0cd73d39..e947204b7f21 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -875,8 +875,8 @@ struct kvm_vcpu_arch {
 
	u64 xcr0;
	u64 guest_supported_xcr0;
-	u64 guest_supported_xss;
	u64 ia32_xss;
+	u64 guest_supported_xss;
 
	struct kvm_pio_request pio;
	void *pio_data;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 478d9b63a9db..8cc79eca34b2 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -412,28 +412,33 @@ struct kvm_xcrs {
 };
 
 #define KVM_X86_REG_TYPE_MSR		2
-#define KVM_X86_REG_TYPE_SYNTHETIC_MSR	3
+#define KVM_X86_REG_TYPE_KVM		3
 
-#define KVM_X86_REG_TYPE_SIZE(type)						\
+#define KVM_X86_KVM_REG_SIZE(reg)						\
+({										\
+	reg == KVM_REG_GUEST_SSP ? KVM_REG_SIZE_U64 : 0;			\
+})
+
+#define KVM_X86_REG_TYPE_SIZE(type, reg)					\
 ({										\
	__u64 type_size = (__u64)type << 32;					\
										\
	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
-		     type == KVM_X86_REG_TYPE_SYNTHETIC_MSR ? KVM_REG_SIZE_U64 :\
+		     type == KVM_X86_REG_TYPE_KVM ? KVM_X86_KVM_REG_SIZE(reg) :	\
		     0;								\
	type_size;								\
 })
 
 #define KVM_X86_REG_ENCODE(type, index)				\
-	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type) | index)
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type, index) | index)
 
 #define KVM_X86_REG_MSR(index)					\
	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
-#define KVM_X86_REG_SYNTHETIC_MSR(index)			\
-	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_SYNTHETIC_MSR, index)
+#define KVM_X86_REG_KVM(index)					\
+	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_KVM, index)
 
-/* KVM synthetic MSR index staring from 0 */
-#define KVM_SYNTHETIC_GUEST_SSP 0
+/* KVM-defined registers starting from 0 */
+#define KVM_REG_GUEST_SSP	0
 
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 989008f5307e..92daf63c9487 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2435,6 +2435,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
		break;
	case MSR_IA32_S_CET:
		vmcs_writel(GUEST_S_CET, data);
+		kvm_set_xstate_msr(vcpu, msr_info);
		break;
	case MSR_KVM_INTERNAL_GUEST_SSP:
		vmcs_writel(GUEST_SSP, data);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9930678f5a3b..6f64a3355274 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4647,6 +4647,7 @@ EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 static bool is_xstate_managed_msr(u32 index)
 {
	switch (index) {
+	case MSR_IA32_S_CET:
	case MSR_IA32_U_CET:
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
		return true;
@@ -6051,16 +6052,16 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 struct kvm_x86_reg_id {
	__u32 index;
	__u8  type;
-	__u8  rsvd;
-	__u8  rsvd4:4;
+	__u8  rsvd1;
+	__u8  rsvd2:4;
	__u8  size:4;
	__u8  x86;
 };
 
-static int kvm_translate_synthetic_msr(struct kvm_x86_reg_id *reg)
+static int kvm_translate_kvm_reg(struct kvm_x86_reg_id *reg)
 {
	switch (reg->index) {
-	case KVM_SYNTHETIC_GUEST_SSP:
+	case KVM_REG_GUEST_SSP:
		reg->type = KVM_X86_REG_TYPE_MSR;
		reg->index = MSR_KVM_INTERNAL_GUEST_SSP;
		break;
@@ -6201,18 +6202,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
			break;
 
		id = (struct kvm_x86_reg_id *)&reg.id;
-		if (id->rsvd || id->rsvd4)
-			break;
-
-		if (id->type != KVM_X86_REG_TYPE_MSR &&
-		    id->type != KVM_X86_REG_TYPE_SYNTHETIC_MSR)
+		if (id->rsvd1 || id->rsvd2)
			break;
 
-		if ((reg.id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
-			break;
-
-		if (id->type == KVM_X86_REG_TYPE_SYNTHETIC_MSR) {
-			r = kvm_translate_synthetic_msr(id);
+		if (id->type == KVM_X86_REG_TYPE_KVM) {
+			r = kvm_translate_kvm_reg(id);
			if (r)
				break;
		}
@@ -6221,6 +6215,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
		if (id->type != KVM_X86_REG_TYPE_MSR)
			break;
 
+		if ((reg.id & KVM_REG_SIZE_MASK) != KVM_REG_SIZE_U64)
+			break;
+
		value = u64_to_user_ptr(reg.addr);
		if (ioctl == KVM_GET_ONE_REG)
			r = kvm_get_one_msr(vcpu, id->index, value);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d6b21ba41416..728e01781ae8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -726,7 +726,7 @@ static inline void kvm_get_xstate_msr(struct kvm_vcpu *vcpu,
 {
	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
	kvm_fpu_get();
-	rdmsrl(msr_info->index, msr_info->data);
+	rdmsrq(msr_info->index, msr_info->data);
	kvm_fpu_put();
 }
 
@@ -735,7 +735,7 @@ static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
 {
	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
	kvm_fpu_get();
-	wrmsrl(msr_info->index, msr_info->data);
+	wrmsrq(msr_info->index, msr_info->data);
	kvm_fpu_put();
 }
 
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 590762820a61..59ac0b46ebcc 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -412,28 +412,33 @@ struct kvm_xcrs {
 };
 
 #define KVM_X86_REG_TYPE_MSR		2
-#define KVM_X86_REG_TYPE_SYNTHETIC_MSR	3
+#define KVM_X86_REG_TYPE_KVM		3
 
-#define KVM_X86_REG_TYPE_SIZE(type)						\
+#define KVM_X86_KVM_REG_SIZE(reg)						\
+({										\
+	reg == KVM_REG_GUEST_SSP ? KVM_REG_SIZE_U64 : 0;			\
+})
+
+#define KVM_X86_REG_TYPE_SIZE(type, reg)					\
 ({										\
	__u64 type_size = (__u64)type << 32;					\
										\
	type_size |= type == KVM_X86_REG_TYPE_MSR ? KVM_REG_SIZE_U64 :		\
-		     type == KVM_X86_REG_TYPE_SYNTHETIC_MSR ? KVM_REG_SIZE_U64 :\
+		     type == KVM_X86_REG_TYPE_KVM ? KVM_X86_KVM_REG_SIZE(reg) :	\
		     0;								\
	type_size;								\
 })
 
 #define KVM_X86_REG_ENCODE(type, index)				\
-	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type) | index)
+	(KVM_REG_X86 | KVM_X86_REG_TYPE_SIZE(type, index) | index)
 
 #define KVM_X86_REG_MSR(index)					\
	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_MSR, index)
-#define KVM_X86_REG_SYNTHETIC_MSR(index)			\
-	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_SYNTHETIC_MSR, index)
+#define KVM_X86_REG_KVM(index)					\
+	KVM_X86_REG_ENCODE(KVM_X86_REG_TYPE_KVM, index)
 
-/* KVM synthetic MSR index staring from 0 */
-#define KVM_SYNTHETIC_GUEST_SSP 0
+/* KVM-defined registers starting from 0 */
+#define KVM_REG_GUEST_SSP	0
 
 #define KVM_SYNC_X86_REGS      (1UL << 0)
 #define KVM_SYNC_X86_SREGS     (1UL << 1)
diff --git a/tools/testing/selftests/kvm/x86/get_set_one_reg.c b/tools/testing/selftests/kvm/x86/get_set_one_reg.c
index 8b069155ddc7..8a4dbc812214 100644
--- a/tools/testing/selftests/kvm/x86/get_set_one_reg.c
+++ b/tools/testing/selftests/kvm/x86/get_set_one_reg.c
@@ -12,7 +12,6 @@ int main(int argc, char *argv[])
	struct kvm_vcpu *vcpu;
	struct kvm_vm *vm;
	u64 data;
-	int r;
 
	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ONE_REG));
 
@@ -22,12 +21,8 @@ int main(int argc, char *argv[])
	TEST_ASSERT_EQ(__vcpu_set_reg(vcpu, KVM_X86_REG_MSR(MSR_EFER), data), 0);
 
	if (kvm_cpu_has(X86_FEATURE_SHSTK)) {
-		r = __vcpu_get_reg(vcpu, KVM_X86_REG_SYNTHETIC_MSR(KVM_SYNTHETIC_GUEST_SSP),
-				   &data);
-		TEST_ASSERT_EQ(r, 0);
-		r = __vcpu_set_reg(vcpu, KVM_X86_REG_SYNTHETIC_MSR(KVM_SYNTHETIC_GUEST_SSP),
-				   data);
-		TEST_ASSERT_EQ(r, 0);
+		TEST_ASSERT_EQ(__vcpu_get_reg(vcpu, KVM_X86_REG_KVM(KVM_REG_GUEST_SSP), &data), 0);
+		TEST_ASSERT_EQ(__vcpu_set_reg(vcpu, KVM_X86_REG_KVM(KVM_REG_GUEST_SSP), data), 0);
	}
 
	kvm_vm_free(vm);


