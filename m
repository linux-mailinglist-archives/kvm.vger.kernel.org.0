Return-Path: <kvm+bounces-53047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CC04B0CE54
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 01:42:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 674C63B3CB4
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D48324676B;
	Mon, 21 Jul 2025 23:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SWuBIWUw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D0424888A;
	Mon, 21 Jul 2025 23:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753141348; cv=fail; b=sdkLpoamslbWFSlA64N8vqN0E0M1ZIKElzlc7LPMJCMpj5jMJDUyqcUSGYTl9JCcygKScoU9BPy7FkoFaSmZI9rjlj0B1kx40cBAZGpN/9OYan2VMlXbga1v03qSvISff2221+nKw878LU0DeiSehewTUVJOHEDcqpzKaBFb1jw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753141348; c=relaxed/simple;
	bh=bbYMJ0p9bWpMBQBsv+LXqRLutp05mM8G7KFfHss4LWw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fYi9Rc9MvTO1lxuW4yQ3pewlJueg/0nAV9SkQ027cVSHlVf5KxbA09GFB4ifqlMsBgBauRX7d0y6KtU0nWDCDtyu5NiP0+u+aNFj2zJZedMZHhyrG0KzVjjlD9Fp50P4EI+KOq/n4bR2z5jiCxPspHFCUNungpvmui6i6T4pakc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SWuBIWUw; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753141347; x=1784677347;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bbYMJ0p9bWpMBQBsv+LXqRLutp05mM8G7KFfHss4LWw=;
  b=SWuBIWUwAHmTdROumY/5yrSn6KnCVO4TLXNQJ5DmhDVL/p7UbB5uChe9
   qD5CV/ONAGiTK6G3mCCvQs1Ahde/miAilGGdd1DiyNf4XtOXlMabz0TKM
   7TPBABaSkLKCsRxMxbKtO0qgnlhT5GgZ69xvzR3wDOoeg2tXstI6U5FDw
   7mFsyIu+D+KpPrPs9TMgY3oqEbKa7JD1h20IroRJ7UsT+6ORYLhr33oZv
   y5AcAv/8+Qa1xqRk5YfqS/XMFxrJcjCRTXGZQN3wUby9U451iWrqu7+Td
   +n+9u3JyD1BxU54eZXN0+pszGcgzkKwSw1mNM0zgiXF8D3NQ6sbYEvx2c
   A==;
X-CSE-ConnectionGUID: 1nM8Nf0mSfql64cfDt8N0Q==
X-CSE-MsgGUID: MBmr/9/sSVq7+2FKm7+OrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55486305"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="55486305"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 16:42:27 -0700
X-CSE-ConnectionGUID: ldQIRfAvT6WiLtMZvqhW6Q==
X-CSE-MsgGUID: uAX+dVvySSqXRaC6FviZUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="189924761"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 16:42:25 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 16:42:24 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 16:42:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.78)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 16:42:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lrNyFQIGLHk8Sc0pv1QOcbi/qvzssFFovYwl+0l8SLOzDPo4W99VSTXtgIC2uQYOifeunn+oeqcAqW3PtDM5emTjpimdL1WtgGbkJVz0fGtJUMnqoxOqP0U80iZYfaEYLdktpa9p2aSksHIXw3l1+dRQKvdQmIXJzcnol8LfplZJNbc46tpUnkdTBC27UP/WoJb7oA9G5INeIvB9EeIqQlETsQkDaOOAe2OkBe6Ov574Dn3pKxje+yCzQJ3rGthgsBZOKNUiFq2F8z1lx8jar+eQV//yABstBWTwo/qpi/jBYGPLQfeySoHzy6i+c6YOdWfs9+rwmTuGX5XEK4CqgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbYMJ0p9bWpMBQBsv+LXqRLutp05mM8G7KFfHss4LWw=;
 b=BjGZoibC+WfzuspzJ9X9Gy1txvQ78D7343ENb13o+eXgu+7L9tNjZjoDKEDGscS0vDO+lwGyXLkSEGlfYwr1kwsWeGxhF1vJZVf/GddlcnQALFxSd8ugkB4XdKaGNeY0Iyn8Z0NWTIAW+Ynsyg4jenPZHCvC8+JLnTsPRlgmxlh48zbpNzwWx/1ExCf9t5ve3zy3tJ4Oer7vWkKJnga454tPyJJbmnrop8m/ny69lOaE8esS6nmKb2wmn+JOs98oE3WbHSdSFy1iu3BzjDCSfD2eyPNvYlvSjHY3Xhc+4mppZ2Hn6/LA0rkso7Jbu+WtFb9OPRG9oFmpd+lFShqlkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA4PR11MB9059.namprd11.prod.outlook.com (2603:10b6:208:560::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.28; Mon, 21 Jul
 2025 23:42:22 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 23:42:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "hpa@zytor.com" <hpa@zytor.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Hansen, Dave"
	<dave.hansen@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Topic: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Index: AQHb92MJH4Vi4bs6uUOSkG2OAWH7LbQ8rCmAgABvgwCAAAIgAIAAAokAgAAYrgCAAAYskIAABDyA
Date: Mon, 21 Jul 2025 23:42:22 +0000
Message-ID: <c494ea025188c6b1dcf7ef97a49fcd1cf2dab501.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
	 <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
	 <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
	 <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com>
	 <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com>
	 <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com>
	 <38C8C851-8533-4F1E-B047-5DD55C123CD1@zytor.com>
	 <BL1PR11MB5525BEC30C6B9587C2DF23A0F75DA@BL1PR11MB5525.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB5525BEC30C6B9587C2DF23A0F75DA@BL1PR11MB5525.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA4PR11MB9059:EE_
x-ms-office365-filtering-correlation-id: 743455b8-db91-4350-1754-08ddc8b03d49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ODN3K2hoS1Q4V3FHanE0dEp4WFVrTDJFNm9WUUtURTJmY0Q5V3lFRnJaR01h?=
 =?utf-8?B?alF1UjBYT0ZMNk43ZVdaMi9ld1JhVi90YndkWlRieE9kMVZWMFB0cTZzTWY0?=
 =?utf-8?B?Z3lIV0IyMWRGblNpb3g1VUlKcThaajMxOVRLVjhGMXRNTVRzWmlHM0hZekl0?=
 =?utf-8?B?cmNOUWl0M0ZQc1BiRFdFZ2VkOUZqbklvS2ZsR1UwaUZmWFhYQng0YUJZWEFB?=
 =?utf-8?B?UnFFUzBVajAwek9CMXMyY2pDVFF1elR0MzhuMFNDdHhaYjdKQWVqdFFLam9w?=
 =?utf-8?B?bGt4ZjRQRlRCK0MycnVCR1FkRk85V09zSmNFOXhNL1ZBN2lZMzFGQWFkaXdE?=
 =?utf-8?B?bkR0YUtEVEgzZ292ZFV5RE9FeEJPb3oxUXRTYzRmR3pBMjI0VnNRQ0UwVCtx?=
 =?utf-8?B?cmhNUk1mWXkvYWZDZTdWSzU4RlkyK1BBZUovdDdPaWdkbE5Zdk1Zb0plelN1?=
 =?utf-8?B?VzlndHAvVHh6L2lKcTFKOHRkWnFHajVIeEhrODB3L0pRcmNaOG0rL0xjU25a?=
 =?utf-8?B?blc2bkt4YTI0alFFdENJeTA4eTJzc0ZmcEQyNWRDS0V2S01helAxV3IyT0Jj?=
 =?utf-8?B?d0lmdFd0dWVCbGRyVFBWZ1NCZjJqUlFZQ0hsVTdFY1RNSlZOWWx3TDUxSTE5?=
 =?utf-8?B?RjFZbnhoNDE4RmVBNm50Lyt3U1ZQUkV0NWNJeGJWTkxXdTRTaStHWVlGOUxq?=
 =?utf-8?B?Q2NyRE1EZmdQaGEyKzlrbzZRZ1E1UUVOQXpxdkQ5NWFqZ3RjcGFSaXVLV0JK?=
 =?utf-8?B?bi9xWVRycWlDTTRLVlc4ZlBKY2FCSDFBV0E2aGYyUWFZUER6dG1DTmRKL21L?=
 =?utf-8?B?S0tmVGVuYlFWNkpWY2JGV3Vpd0NETmQ3RVRMbGYyU2J5WG1hcFluSEFoNVYw?=
 =?utf-8?B?ZWV6dnlWajh6a3NJcHNqaHZSRkpGRURmbXJRSS83eXBKdm5LVHZhY0FxbjV6?=
 =?utf-8?B?WWRhVFpCMnk0a2Q3U1hOSDJZSVp6bEU3MER5eFh6Vmw5Ui9QMUFNaEtwNk5S?=
 =?utf-8?B?Q1hrd0RlVWtsa3V5K24wZCttaTJMOE9GMXh2WTJKNjJTMndkYUdZeUtwUmJY?=
 =?utf-8?B?QWhsVkE5OEFyL1FpRHBVU3pTaVlBdzdtQ0FRNHVOLzVOSmkxMHd6a2RjWnFl?=
 =?utf-8?B?VGNWQ2ROUjU5QUh5R1lhK0d3SklCK0RMK29RenFFOUhQR1Jlbk9xeVJ3Mjg1?=
 =?utf-8?B?QjBUR2ZOMjV6K1ZSeHAxR0U4TS9DR1UrcEd0ckRGc2NxTGZ5NDhnNUxUb2hF?=
 =?utf-8?B?RFlLOVVxY0xIMjFTZkhFRDhtbE5PQW95Sy9zY256dk4vUXdrSWt3bTlpOVNM?=
 =?utf-8?B?UUZEL25EdW1NWDA4VjNmdGtaK0xpUDVSTGdFVEh6dTI5eWQ0anlUZEZhZHpQ?=
 =?utf-8?B?NUxFOTNGcUdJeThKR3JzeCtZQittV2gwZlIwZGw5c2xMdys2UXBhME5MYm53?=
 =?utf-8?B?ZmdraXc0WVpJaFZleUpDdzJKVDBRMy9xWG9SaHc4ZjdaYjkvdmplWFNvNC9I?=
 =?utf-8?B?T1dzUTUrQ2xtYldoeXhPSUtMQUYrYmRDMjc2YldTakpUdWdrYkVtOG1yYU9p?=
 =?utf-8?B?Nm5hMWpEWkplZUUyMGRhSXJxQWFsQ0VPRVcyUlBTcVZFMUV4ZVdLRWdvZmZl?=
 =?utf-8?B?MUI0cmxVNi9jeXBMTm9WbmI4MENYUGZxMGc5OHBTS0YyQzk2NnFUMUNreHdO?=
 =?utf-8?B?V2wybWhCaU9lbjVLQnZ3Wk5uVERXNC9BajlSUUwrMFR6bU5weC9pN05ORHFY?=
 =?utf-8?B?eDF1cHlzQkhWblVFTWc2RjhzOVJNdk45K0gvNm9leEZNUXpGWHF3amR1Z3NO?=
 =?utf-8?B?TGtVZDRvVGZQQW5XRkY2UStNaWpiTzZtcDZhUGZhV0d2RjBSaGw5QmtlUktV?=
 =?utf-8?B?N1dsWkh2ZTh2aXlZMUkxR29tRjBLa00wbEVXc08wYlF6cW11R1ZCODVabERH?=
 =?utf-8?B?RjA2dmVkazVvYUZway84b1F6WjUwc0FMNER3Rm1QZGJtTmdkOWtsYW1SOHlh?=
 =?utf-8?Q?88y7wS8izrkKGLr76ygNwJjtB5EXRg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rnp2Qm9aYjNBdkJ3SENrWllIZ2Q3bjdjdXQydTFuR3RzQ0RjcllBQTZaVEVB?=
 =?utf-8?B?ejYxbHB5NW1QRG03dDBseVp3Y3UzTjRNN2x2dGFya29INmhOTkh5SHZsL1p5?=
 =?utf-8?B?YzRCQXFKYWhXczZBWUpyODN4RnZJVHhwZXZ0RWdaZXZIYkd1MmNiM0xkNm8r?=
 =?utf-8?B?MWIzRE0vNUhldDJCd0J4TnE1RG5zRFpEcWkyU3d4NUNmbWI3TFM3L0FVQkZk?=
 =?utf-8?B?WUYvVkpFZXhrRDNoRWVCMHNzSlVqem5MZkI3ZnV5WHJ5WGFpMk51VHNINnBy?=
 =?utf-8?B?MDU2NlorTTIwQWFRVldub0d3dTBZOUQ3NGViVHVLWHZUb2Y0Z1lzWVdzMjha?=
 =?utf-8?B?UXU0YXRwQTRWdGo4V3BlTitlay9pV2tRQWppcklUQ1FZbnlhcHRKMkVqT3Zl?=
 =?utf-8?B?YmFFZWhtK0NGemJydDVpQWtJellJanl4UzRDL3hlYzRnU3BoYllheGovTUZK?=
 =?utf-8?B?RGRRK0hBWExKS2Y0WWNzRUU1eDFqUU82QktsN1hZNmU1eFk5SStyTkd6VVcw?=
 =?utf-8?B?ZmJGMlUvbEQzNlJ3TzZMY0pUWkMvQTU5c2toMVNGSVpnQ2VDQ1kzc0tBYUhN?=
 =?utf-8?B?YWlhQkdrYmwrQmU2VFM3VE9icGppNUpkd2k4d1QwZFpieC9JLytFMUN0MEpj?=
 =?utf-8?B?dUVVOU1nSi81dVlGK0JhNSs4YW8rRER6dW9LTllHcXBoSnk1Y20vZmwwYVZH?=
 =?utf-8?B?UnZUa2tlTHE4d3d0UGM5cVpJTXN6eDVqY2xTUGNGNTRNVmRlaU1adHE2a1J5?=
 =?utf-8?B?QnFkNGtaVGlydEdnSTE3bnZPR2JaMjJ0c1l4eTBJcm1BVTNmd1BJMi9DSzgy?=
 =?utf-8?B?Slk1aDNEa2w3Z09sSjdNcElKOFFvWWNkcExlbnFUMzFVY0FGY09UZzNXQ1pw?=
 =?utf-8?B?cEVLODIzVmNpQkt1RkNXenlKVllMb2kya1JSTXVEN05NUDFVMkhjeThTengw?=
 =?utf-8?B?T3pjaUFPN0F0SnpJVVQvbUdOUUxUQktmcDdzR0N3dnFQWlFSdzgvREswUTQw?=
 =?utf-8?B?dDY3MDhzciszS0IvT3FVL0VRVk1yMC81djNkcXRMZjVONFJFWmFhU0dIVmh3?=
 =?utf-8?B?VzBJSmVBUmlJMWNUUjJBT05iTEU5YXF1K1gvRFZwWC9ZckhQSDdGU3U3Njh6?=
 =?utf-8?B?SlZZVmZpTGpTclRtUEY4RzZ2UjhablhPa2dVYTdicjJrUENZMHlLVkFZbXQ3?=
 =?utf-8?B?N1p1VmYvcDdrc1h4cWdkT0taOVVWRFJkUDlaYzE0ODlXcUpkTXZqM0RHL2l4?=
 =?utf-8?B?a0dFbUxGQW15UnljMmliTllSQ251aUxmQzQrcXdYTWtobTZBQzlJVWlWa0Vu?=
 =?utf-8?B?RVdSdGlSOEhCcXFKV1A5OFhFK3VKZ3BXZ1Y0cnRuWmxpV2pCTEdaQWY2TjBW?=
 =?utf-8?B?dTJpSVBnTUQ3L1FkbWMzcW5haGg4dUhaaGZQL05PMEZ3MHhqSjJDN3VGeU5L?=
 =?utf-8?B?UFFSMUF1M2UwbmExQ0FxVnE0RUR1MDBYVjRxZENtV3ZlTjgrN2xFWXE5eHBL?=
 =?utf-8?B?akRLL085MDRqRGJkVVlqdEZSNHhwZ0JxaGlXZ0VCWTNCVno2eXVwb1NMZnkw?=
 =?utf-8?B?QWV4YWpCWjRnTHdoOVhDMDBiaEd5eHdySWRFbDU0c3hFZk5Sait2SzQrRVNP?=
 =?utf-8?B?WWxCWDF4UkRjU2pRcVQzSTFZQmJpWjM3Y3RHTjdtRlNmVTg3STdmQ0hBZHd6?=
 =?utf-8?B?MVl2amFSNTZhV3l5M2o0TkFUdzRFTlhYZTRuUjRsWUVEYWNDUVlqc1VMTDE4?=
 =?utf-8?B?R2E5dFppSXh2MTNmWHM0NGN6cVRBbzhSMVl2MENKdldZcUFFZWlSc25ySS9S?=
 =?utf-8?B?dzBXNEZJOFVVTmRicHJxWkFiaU9jbytQdm5ZRzhGd0ExMFJ6MnZXVXF4R08x?=
 =?utf-8?B?SSthalo1Mkh5QmVnYVMxQ3RlQjc1T3RaL2Y5NVpwMWdtV0JxNnYwaHA3MDZG?=
 =?utf-8?B?UUxxZXpDSlN2M1RsQjlkQ0pNV0JPN0RWakd6OU1LRXBZN0NXOHVVWmR5N2c2?=
 =?utf-8?B?Y05aVDVLRDcwM1pGZ25kYkhBSXUwOU02R3hjWDUvM2dWcFUwK1liZmhJc3Ja?=
 =?utf-8?B?dFlZNFhjT1JsNHdkOTlGenNMU1RYNGlpb0VvZ3JEeGRhais2cnNJRC9MQWp4?=
 =?utf-8?Q?jZNiFuy5tNcZPmZ7XTrZSouL9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <37C376CC3E4531469E1DB462CF1BC6AA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 743455b8-db91-4350-1754-08ddc8b03d49
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2025 23:42:22.4423
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kj9k2uyVHN3eZgvsOxupF/Z8P4rYpOrfsbrPeKJ9XaXHh42/HS0A5Smku7g1ueJzeww+BDQH5QcxE6jCVDadQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9059
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTIxIGF0IDIzOjI5ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IE9uIEp1bHkgMjEsIDIwMjUgMjozNjo0OCBQTSBQRFQsICJIdWFuZywgS2FpIiA8a2FpLmh1YW5n
QGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPiBPbiBNb24sIDIwMjUtMDctMjEgYXQgMTY6MjcgLTA1
MDAsIFRvbSBMZW5kYWNreSB3cm90ZToNCj4gPiA+ID4gPiA+ID4gQEAgLTIwNCw3ICsyMDIsNyBA
QA0KPiA+IFNZTV9DT0RFX1NUQVJUX0xPQ0FMX05PQUxJR04oaWRlbnRpdHlfbWFwcGVkKQ0KPiA+
ID4gPiA+ID4gPiDCoMKgCSAqIGVudHJpZXMgdGhhdCB3aWxsIGNvbmZsaWN0IHdpdGggdGhlIG5v
dyB1bmVuY3J5cHRlZCBtZW1vcnkNCj4gPiA+ID4gPiA+ID4gwqDCoAkgKiB1c2VkIGJ5IGtleGVj
LiBGbHVzaCB0aGUgY2FjaGVzIGJlZm9yZSBjb3B5aW5nIHRoZSBrZXJuZWwuDQo+ID4gPiA+ID4g
PiA+IMKgwqAJICovDQo+ID4gPiA+ID4gPiA+IC0JdGVzdHEJJXI4LCAlcjgNCj4gPiA+ID4gPiA+
ID4gKwl0ZXN0cQkkUkVMT0NfS0VSTkVMX0hPU1RfTUVNX0FDVElWRSwgJXIxMQ0KPiA+ID4gPiA+
ID4gDQo+ID4gPiA+ID4gPiBIbW1tLi4uIGNhbid0IGJvdGggYml0cyBiZSBzZXQgYXQgdGhlIHNh
bWUgdGltZT8gSWYgc28sIHRoZW4gdGhpcw0KPiA+ID4gPiA+ID4gd2lsbCBmYWlsLiBUaGlzIHNo
b3VsZCBiZSBkb2luZyBiaXQgdGVzdHMgbm93Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFRFU1Qg
aW5zdHJ1Y3Rpb24gcGVyZm9ybXMgbG9naWNhbCBBTkQgb2YgdGhlIHR3byBvcGVyYW5kcywNCj4g
PiA+ID4gPiB0aGVyZWZvcmUgdGhlIGFib3ZlIGVxdWFscyB0bzoNCj4gPiA+ID4gPiANCj4gPiA+
ID4gPiDCoAlzZXQgWkYgaWYgIlIxMSBBTkQgQklUKDEpID09IDAiLg0KPiA+ID4gPiA+IA0KPiA+
ID4gPiA+IFdoZXRoZXIgdGhlcmUncyBhbnkgb3RoZXIgYml0cyBzZXQgaW4gUjExIGRvZXNuJ3Qg
aW1wYWN0IHRoZSBhYm92ZSwgcmlnaHQ/DQo+ID4gPiA+ID4gDQo+ID4gPiA+IA0KPiA+ID4gPiBE
b2ghIE15IGJhZCwgeWVzLCBub3Qgc3VyZSB3aGF0IEkgd2FzIHRoaW5raW5nIHRoZXJlLg0KPiA+
ID4gPiANCj4gPiA+IA0KPiA+ID4gTnAgYW5kIHRoYW5rcyEgSSdsbCBhZGRyZXNzIHlvdXIgb3Ro
ZXIgY29tbWVudHMgYnV0IEknbGwgc2VlIHdoZXRoZXINCj4gPiA+IEJvcmlzIGhhcyBhbnkgb3Ro
ZXIgY29tbWVudHMgZmlyc3QuDQo+ID4gPiANCj4gPiANCj4gPiBZb3UgY2FuIHVzZSB0ZXN0YiBp
biB0aGlzIGNhc2UgdG8gc2F2ZSAzIGJ5dGVzLCB0b28uDQo+IA0KPiBZZWFoIEkgY2FuIGRvIHRo
YXQsIHRoYW5rcyBmb3IgdGhlIGluZm8hDQoNCkkganVzdCB0cmllZC4gIEkgbmVlZCB0byBkbzoN
Cg0KCXRlc3RiCSRSRUxPQ19LRVJORUxfSE9TVF9NRU1fQUNUSVZFLCAlcjExYg0KDQppbiBvcmRl
ciB0byBjb21waWxlLCBvdGhlcndpc2UgdXNpbmcgcGxhaW4gJXIxMSBnZW5lcmF0ZXM6DQoNCmFy
Y2gveDg2L2tlcm5lbC9yZWxvY2F0ZV9rZXJuZWxfNjQuUzoyMTI6IEVycm9yOiBgJXIxMScgbm90
IGFsbG93ZWQgd2l0aA0KYHRlc3RiJw0KDQpJJ2xsIGRvIHNvbWUgdGVzdCBhbmQgaWYgdGhlcmUn
cyBubyBwcm9ibGVtIEknbGwgc3dpdGNoIHRvIHVzZSB0aGlzIHdheSwNCmFzc3VtaW5nIGl0IHN0
aWxsIHNhdmVzIHVzIDMtYnl0ZXMuDQo=

