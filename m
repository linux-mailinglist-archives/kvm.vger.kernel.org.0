Return-Path: <kvm+bounces-60030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE89EBDB4B6
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 22:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA2B719A2AD2
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 20:41:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E88306B32;
	Tue, 14 Oct 2025 20:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i7iLEqSe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9A22C17A0
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 20:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760474460; cv=fail; b=AeQLiD7ictzrnj2ydS2khiJzfIKC0HhDhQoGgrs3bVFjx8h7PG49MMH8m1zCOjCbEVONvG3fjql720ghMJ4XQmSiD1RW3zQgko8xbIvGWMDVsnmb3dsJL2kah4yIO7GBkivRR3XGl2NsNDWXPtOv2SRsXSrLKLTiRg9VmPKjDGU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760474460; c=relaxed/simple;
	bh=NfXRzS+CXAdoKCf5Y44rqOnqQpCzMUd7+jHRZR5wn40=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bvqBNMMf2DR32A4qEKCnl0y46IS/2+0D0oj0oEONyElZKQyw0IwBtmu70Fs0Ibub7skRWjmUIV6iYzNpnTY7tp4bD387iYNKABnxisZ3OxtlyDqXdVGRjDhSvCtfLNh0nyHB2IkG1Y4wo7qbVOUoeqotSu40CdC+nYPqKgiQSs0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i7iLEqSe; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760474459; x=1792010459;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NfXRzS+CXAdoKCf5Y44rqOnqQpCzMUd7+jHRZR5wn40=;
  b=i7iLEqSepZWpH5kyd6jLmNf1GdgLR0JCPPpp1oUVUfI365mXg46IW2Qp
   Q09dGkOr9m4CpL/0g1trWbou8dvMtIlbaliqfeIPejFxmD5xOHdKTEKHU
   wtai7V6rsJ5YUHeotITcreVhZDEQEVJME8sVGXRoAoCHHrnqirFdLMOLG
   MoPuTXNvB/rsBB8Oa4+gcUv1NGNsTNA+lZ4+JAkRECVuQ6Bzi1A0cZTes
   lpn1m7stI3prebRxLBOZ9bBYonwDWgls259YvjjNW87okcX3Q2NB3zunl
   /VDpHC5nAUTqRUoAyfE8zJN7Pwm6oIKEAZ3RZH2uCYkQMgBxVcuiabpQe
   Q==;
X-CSE-ConnectionGUID: z9kZOWGSS9C+S0U3xrrlOQ==
X-CSE-MsgGUID: BTWujbh8R5OQ7Il5wjP63Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="62685427"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="62685427"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 13:40:59 -0700
X-CSE-ConnectionGUID: CwPkAikrSweVy+xrhHHzXg==
X-CSE-MsgGUID: dSAncxa9RuuqUbMyWjATLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="187077630"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 13:40:58 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 13:40:57 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 13:40:57 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.8) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 13:40:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MWGBccKDuA+Yd7wuisUko8o1TfpoYF40v2TB9N+HguGeA7pn3olxUNZ8Gpks12JUztajmrtAU80o5ZXGMk7UTH059DEslEbV+zjhMpE4iQ4WBoq8ceLwOxBLpiWSFQIK7slgX01MKKNIdA+tisYXDyzcq0SE5DC87JbKAArsBUaHIgWJr1ffla8GHI6DuOt1wqnqsOTADUPKYyDmWNlg9M6aow42Ia96K6wMeHn+wkUr/GixLF/cr+Ns86saNDj0KEVCFnLBeSAbZ32SEEu+mkO3XmIShjv7eqEt7Svpzb6hoIKOHg7jOVAzm3Q2BbJehQTYwx8rKwFolJ9OrhcJsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NfXRzS+CXAdoKCf5Y44rqOnqQpCzMUd7+jHRZR5wn40=;
 b=nAwaxHKOAtvNu6opkghRnCDBjCmCBmOlBUjcTaC9y0AbC6ptfirZlhM93IevQnGW6r+YOkVihD81zo2F+C4eVsOGh+Z4CZEHJJoj863W/xaP/4KKfICGPW3uiXA5gzXw3OtqfalZAoKWGHb3lyXFUefVNLV2Wo5ylOu8fahEiZI6OddWTQNty+S3itiYM6xr2upudQPHUMNEUpW7/8EuCHWmAF5GfnE/fs/cPN4HHzKDI69BlhuvMg1c7H11xviximUvUkRFqALsVXx8ziLYcvPlSGd8NnupjwkO8/+MGzqDn5S4a6BeHTpE+oLIXoEpzpI4jkcv5X4NGvf04mLA8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6722.namprd11.prod.outlook.com (2603:10b6:510:1ae::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Tue, 14 Oct
 2025 20:40:55 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 20:40:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Topic: [PATCH v4 4/7] KVM: x86: Move nested CPU dirty logging logic to
 common code
Thread-Index: AQHcPApHQq5GYUzMbUWZEhHpuKXxubTBhNuAgACYtoA=
Date: Tue, 14 Oct 2025 20:40:55 +0000
Message-ID: <8b1f31fec081c7e570ddec93477dd719638cc363.camel@intel.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
		 <20251013062515.3712430-5-nikunj@amd.com>
	 <30dd3c26d3e3f6372b41c0d7741abedb5b51d57d.camel@intel.com>
In-Reply-To: <30dd3c26d3e3f6372b41c0d7741abedb5b51d57d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6722:EE_
x-ms-office365-filtering-correlation-id: ce72ecfd-51de-4337-4bef-08de0b61f90c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QWxQM09TcTZGdGEyY0QvZ1d4L1RGSHpjcitYaGVlYzBSSkJnZGx0aUUwYlNi?=
 =?utf-8?B?Y1Zxcmd2Nnd4QUVoT3NtbEY4cDZKY2tCYU8rQVF4bGdzdXF1bXFpaFpQUmRN?=
 =?utf-8?B?UllKa05GbWVoSHRHcm45a3d6ZnVsZkljdE02eDBhSkd6T0YxOFo0ektHVmVa?=
 =?utf-8?B?d2MvK05vcjk4aEtDUXp3cHB5ODFJRzU1NTVueEwrWHFqc2liYUlWM1dOelZH?=
 =?utf-8?B?blVBeFl6aGxFbUMvYkhkdzBrU1lXd0NoeTVSbzY3a3REaU8vVGI4c2RhTXFD?=
 =?utf-8?B?TWVTWEhkZ1ZvdGVGVHRjZXdtc09RYW5JY0xESlk2cEErV0VhRGErdUxUd1Jl?=
 =?utf-8?B?ZEE5cmIwblJqS0c3NURTN0E0WnQ0eWdodGF5VTFjM2R4REk4emlxNi94ZTY5?=
 =?utf-8?B?YU9rMlo1aUE0bnZNNnNSMC9aUGRSVlk1WGhtSFFmVThHNkQ3eXlGanh3R1FL?=
 =?utf-8?B?RGxPL0x2YjVmQ25XT3dlaVZpT1lxWllDVGVabmZDK3pjOTNGZU5PRnpSbGVt?=
 =?utf-8?B?RjNMdHA5NEdMalQzSlRRWWdWSzRtRnRGWHkwdFZ3TzdMT3AvSzNyNlpjOGdV?=
 =?utf-8?B?N2pMbHBKRVg3WWtoSmVxR3dnRjJzKzgzNVV6elZKQmVCMThVNFhOOTZTNVp5?=
 =?utf-8?B?Q01DaHdwaUNsOHMzaVcyQU9kUEU2bE1EWm1BL2MyR3Z0eCtWV0FvZnZzYkFQ?=
 =?utf-8?B?Y3hIL2ZFSEJ0b2xFTk9oblcyeWt3MERzYU9yRGl2UjQydU5sRWQvaGc2Yk9X?=
 =?utf-8?B?clVOM21jdnFQWkxkeHJJYXoxNmllTkMvVkdTb1Y5VGt3TjYzTEt6L2VqemFp?=
 =?utf-8?B?bC9weCtvZ0kyYzR6Z2VPSDk2anFJbklrR05BcWxuSDNFQWcvRXBkaFd0T2Q2?=
 =?utf-8?B?dzZBM2c5NDBEc3hzaGtWUmRkVlZ2bGdFdTN3cE9BMGo3eDF1VWFzaEVSNHRu?=
 =?utf-8?B?U3FES0NFRTZRWSs4Z3k0Q2kzakZqanF4SkFxQ29vakl2NmVXOFBvb0xibmkv?=
 =?utf-8?B?bXgwMWxCUktzVURMd1FhZlNOSG5iempvMVFTR1ljRmw3cUxMTldYeTFTa2Q0?=
 =?utf-8?B?QlNBU1U5TXNDdllxQWpia25ZbnBtUXo3THAxRGRFbmF1ckJGRGQ5dDFyYmI3?=
 =?utf-8?B?U0ZFOTVxdm5kb01LL2xpeDNtbk5mRWFpOHAzOU9nZXNxNXpTVEp2OXpyNVRW?=
 =?utf-8?B?VmpXbGZoRmZzdTl3THFwWk1xOUduaUVvV2RJc0QvMWd2TmRLaGlTLzQvcVFt?=
 =?utf-8?B?K1Z2alpDK2NYYzc5RW42bXIwQWxtUlBqOXJRWEJielhlVkpTMUZHeUp5UldP?=
 =?utf-8?B?T2d5RHJ2VURIVXlvVGJkQlpzZitUdkxYd0F1TXlHY1lzWG1yQnR0UjYvNUF3?=
 =?utf-8?B?R3lBOGE5V01ObS95NXNHS2c4VFo0anFRdU1RS041SExSbWx0OTJTTjZIYnlm?=
 =?utf-8?B?ZUtzeFk4MDZyRWJtQ3V5YnpiZWVMdUNIRWR6VVprdm5LcHhxbDNLNjFTVnJN?=
 =?utf-8?B?V3BXeXpocWZkN0FLRGJmbHFTd2dYbzhhYnVRc01YeVVhZmFWVFg3TkREdmhG?=
 =?utf-8?B?dFlSNTJ4dnlTcHd5S090ZG5IRmtYdXdneVJnU3lVQml1b1N3UnJYNzZXbU55?=
 =?utf-8?B?UWIrdElpZjduQ1ZQa1d0ZWFTWVl6QTZPam5XdytWYWVzU1hZeFl2dDBLRzlz?=
 =?utf-8?B?ajNlQm5xNXJReVNpL2J4aTBKOHpqWHFmVjEwY0U5Z3dYc2phS2ZBMk52MmJQ?=
 =?utf-8?B?UW40ZlBYdVI2TktZV1dXMURRY21pVFh5NGQ4Vk9wUnl1L2VScUh4VWxsZjly?=
 =?utf-8?B?VTRlV1pPQm9uOWwwdVp4NVhlVUNtYjBobk01QU9HOUJRSHQ4MHF3cWt5NXJp?=
 =?utf-8?B?QVp2eDlJQzlQS2RhNk9uN2dUcWliOEdkNUpDcExPQzBwaTdGbHo2RHJJSmZJ?=
 =?utf-8?B?eU1GaVdtT1NEYXM3RFZUNENRSUlQTkxuWlhwbGZUbWVlL0xCUFVUUytpNXhZ?=
 =?utf-8?B?R2RvQ0MrNTFRUzdTc2dFREk5Um1heW9NdWRkUVNVb3JkUklBSncwMk5nVkNq?=
 =?utf-8?Q?sQ0rTf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qzg3RWQvaWRueXlWZnA3UVNBcmNIakNHRDR1dE5ZU3NkWkJqNnpmNzQvbzdU?=
 =?utf-8?B?NWVIeUFJalJpTnF2Tk9oc2ZZVm9kYittTUl2N0ZDVEdFcWoxeURCNzBDb3Qy?=
 =?utf-8?B?K3lEclNlTHR4UG1DNW5hNUlmckc2NkZXVHZwRE5Mb2Iva00vTEdMM3BGSXlS?=
 =?utf-8?B?TStGYmJnSk42NzU2MFFxOXc4WnV0emZ2UE1DeTdGenNVRDFQQWJaeGZwZ3hF?=
 =?utf-8?B?cExueUxGR1hpdUtaOXpKQzVVSldwWWVqZWZ2RlZ1UFhyNGtPcUJabmJNL01B?=
 =?utf-8?B?TDU0ZXM2OWNyTnJPYm1jbFRJRCtxRnBsdElyMnkxYXJ3WlYyZ0VFNE1WbXpU?=
 =?utf-8?B?ZDBob3Y4aG83WUJYRXEvcUEwcWo2dFNvTTRjc051OTZFTXVKaGRkQWJkMGl1?=
 =?utf-8?B?VFIxZUgyY1F1cUgvTndUa1ZsUjFqQlZwTVZ6MVpZcU0rTlZSaXpZMk5TMER0?=
 =?utf-8?B?VE5NUU5pbFc1RTJkRWJqTmIxVWkvZmwxQlpzSU05K21IWUtqWGdJajRwVzVP?=
 =?utf-8?B?ZVl5RHdCNFp0UmY5M21VU2tTRlV1cGxPSUJYVWFJZXYramNWMVNKMmFhWWFU?=
 =?utf-8?B?cXRPcThJVEswWlBDUWtZbzlKZ2hLdVVLTVdHcUk2SGEyV3V5eHBPOE8vV3hZ?=
 =?utf-8?B?WE8reW5PdlB4VWp1a2s3Y2lLR2J3ZWV3WWZ4SGhOaUJwQWNBWFVqMXZNb1A3?=
 =?utf-8?B?VDFqR2R6QjNvMWh3Mlh1V2hxMW04YVFOTUJWOC81a1Bhb1BrUzk0ZHdBWmts?=
 =?utf-8?B?VmdjU3d4RE9zSllueVM3dkdFcUhKd3pwWld3alhDNERGOHM1a1U4dnJtNTNF?=
 =?utf-8?B?S2Jid1VwOFZINFh2TU9VQnFZK0dJRlFYS1RoUDJFNWpvd0VsUk5QTC9xYW0r?=
 =?utf-8?B?VUprZkMzemtWV05RZk9iTDJrMHhpMkNGb1IyOFNram5lN2hGaU05Z3pyemlu?=
 =?utf-8?B?VmYwWU9wQ2swNzFyNkp2SkxscVZHMWNhRWtHYWRNY1FsRGNiVGpLRnBPVjhv?=
 =?utf-8?B?ZWhreXVkb0tGSG9LUVc4MmRBOGdkWno4d1NPUjNGczFLU2lwb3FSbWo3WFdp?=
 =?utf-8?B?ZEx0cm5QTzJJZkJadjU3cDgvbEMvOXgzRkVHV3BsdEEwUnFUSGdxajZlQzRh?=
 =?utf-8?B?Q05WNzZRZGpBVWIvZnF2Z3g2SUYzUWY2NnM2RnFDN2xvNENpSFhYcVg5d3pX?=
 =?utf-8?B?enBKSHA2cHJOd3BCSnBnS0lIVU00ZDFibUdndHRPZks2STZhbjg2Z1NuZ2dC?=
 =?utf-8?B?SFVrVlVqVk1zeGJwOWxYdERXTHhPY2dONTV4dXhhUE1CbmN4ZThOTUQrV3Vm?=
 =?utf-8?B?Q2YyakJob09PdlkyaW4vdURDVEswQ3ZkTXcvbTZ4UmlhOGt1U0FXbUpKL0la?=
 =?utf-8?B?cDBQeEx0WE91UmJEZ2lUZmVBZXllNStOL3lEMVBSQzc2U2p5NVFlaEJwVmU1?=
 =?utf-8?B?dGtXM1ZndkF1NUlSYjduRHFldFVYaVFqMGY0amVLK2QvR0VEUGpmZGdRZnBY?=
 =?utf-8?B?VE1Ha2x1Vkgra3ZGRSthTWQ2SDRRa21TK1c0VU1rR0dVdFdVbVYzRVdYYUVI?=
 =?utf-8?B?RU5CWDE4aEVDVXFzVDJ3UzhYdzdhc0NLMjJlZ0Z5S1B6NTBLTjFuVVF6emtW?=
 =?utf-8?B?c2ZOV0VzSE5weE1VYmVQL0VhRnI3MnJQQ1NCK2RZaFVYT24zamJrRUZzZ3Rl?=
 =?utf-8?B?QnN4VWtJaGVtV2xKTTVOY2VnK3NnZkR6TVpoUnZtclNMRG5zV0ZlVS9lM2g3?=
 =?utf-8?B?Mk5JTDFyT2ZkZXBNYVlQd1BiS0ZVOWFWNWRzM3dOYVNQVHRaRkxIUXR1aVBu?=
 =?utf-8?B?ZjBMZkdVbFNobDFpV1J6UDZ3VGY3cXJ1UG1nZDlJeWxWeW80TU9OMDVOeTlR?=
 =?utf-8?B?aW1nTmI4ejFVRVlmWXlsR2h4NVA2NGlXaldxRXRJTTBkaDlJNVp2RTJETVlw?=
 =?utf-8?B?bllnUnVBek9tMm85b2lmYjJCR2VtdE9uUDFnbUxFQm9XczJUci9RWUpaQTdV?=
 =?utf-8?B?M3IzM0pWT1lzRWcxVUVnWlllMjYycUJyOVgyaDNhMEQyZmora1hLbXhKSkd4?=
 =?utf-8?B?VW1MbnRLbjlRRm1ZTTZmcG9lc1JINWZNS1E4bnhFeFlYdjVGc3BUT05YRExs?=
 =?utf-8?Q?Tw5hCNaJIEcop1lRNCeistwOj?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD9F5A8652781E44AD1F3A12832409D4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce72ecfd-51de-4337-4bef-08de0b61f90c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 20:40:55.1050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cmeXeL3EgPaR+bqTmGXZhSoMW2ztNPbFMdCe2T6voftgw6P14/drUOqt4sYB6moCvCg5a1IAr1F6r6krpnKk4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6722
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDExOjM0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IMKgIA0KPiA+ICtzdGF0aWMgdm9pZCBrdm1fdmNwdV91cGRhdGVfY3B1X2RpcnR5X2xvZ2dpbmco
c3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+ICt7DQo+ID4gKwlpZiAoV0FSTl9PTl9PTkNFKCFl
bmFibGVfcG1sKSkNCj4gPiArCQlyZXR1cm47DQo+IA0KPiBOaXQ6wqAgDQo+IA0KPiBTaW5jZSBr
dm1fbW11X3VwZGF0ZV9jcHVfZGlydHlfbG9nZ2luZygpIGNoZWNrcyBrdm0tDQo+ID4gYXJjaC5j
cHVfZGlydHlfbG9nX3NpemUgdG8gZGV0ZXJtaW5lIHdoZXRoZXIgUE1MIGlzIGVuYWJsZWQsIG1h
eWJlIGl0J3MNCj4gYmV0dGVyIHRvIGNoZWNrIHZjcHUtPmt2bS5hcmNoLmNwdV9kaXJ0eV9sb2df
c2l6ZSBoZXJlIHRvbyB0byBtYWtlIHRoZW0NCj4gY29uc2lzdGVudC4NCg0KQWZ0ZXIgc2Vjb25k
IHRob3VnaHQsIEkgdGhpbmsgd2Ugc2hvdWxkIGp1c3QgY2hhbmdlIHRvIGNoZWNraW5nIHRoZSB2
Y3B1LQ0KPmt2bS5hcmNoLmNwdV9kaXJ0eV9sb2dfc2l6ZS4NCg0KVGhlIHJlYXNvbiBpcyB0aGlz
IGNwdV9kaXJ0eV9sb2dfc2l6ZSBpcyBwZXItVk0gYW5kICdlbmFibGVfcG1sJyBpcyBLVk0NCmds
b2JhbCwgYnV0IG5vdyBmb3IgVERYIGd1ZXN0cyBldmVuIHdoZW4gJ2VuYWJsZV9wbWwgPSAxJyB3
ZSBkb24ndCBzZXQNCmNwdV9kaXJ0eV9sb2dfc2l6ZSAod2UgbWFkZSBpdCBwZXItVk0gZm9yIFRE
WCBhY3R1YWxseSkuwqANCg0KU28gd2hpbGUgdGhlIGN1cnJlbnQgdm14X3VwZGF0ZV9jcHVfZGly
dHlfbG9nZ2luZygpIGNoZWNrcyAnZW5hYmxlX3BtbCcNCih3aGljaCBpcyBmaW5lIHNpbmNlIGl0
J3Mgb25seSBmb3IgVk1YIGd1ZXN0cyksIGNoZWNraW5nICdlbmFibGVfcG1sJyBpbg0Ka3ZtX3Zj
cHVfdXBkYXRlX2NwdV9kaXJ0eV9sb2dnaW5nKCkgaW4geDg2IGNvbW1vbiBsb2dpY2FsbHkgaXNu
J3QgY29ycmVjdA0KYmVjYXVzZSBpdCBkb2Vzbid0IGNvdmVyIGFsbCB0eXBlcyBvZiBWTXMuDQoN
CkkgYW0gbm90IHN1cmUgYXQgQU1EIHNpZGUgd2hldGhlciBQTUwgd29ya3MgZm9yIFNFVi9TRVYt
U05QIGd1ZXN0cz8gIE1heWJlDQp0aGV5IG5lZWQgc2ltaWxhciB0cmVhdG1lbnQgYXMgVERYIGd1
ZXN0cyB3aGVuIHNldHRpbmcgdXAgdGhlIHBlci1WTQ0KY3B1X2RpcnR5X2xvZ19zaXplLg0KDQpB
bnl3YXksIEkgdGhpbmsgY2hlY2tpbmcgdGhlIHBlci1WTSBjcHVfZGlydHlfbG9nX3NpemUgaXMg
bW9yZSBjb3JyZWN0DQpoZXJlLg0KDQo+IA0KPiBBbnl3YXksIHRoZSBpbnRlbnRpb24gb2YgdGhp
cyBwYXRjaCBpcyBtb3ZpbmcgY29kZSBvdXQgb2YgVk1YIHRvIHg4Niwgc28NCj4gaWYgbmVlZGVk
LCBwZXJoYXBzIHdlIGNhbiBkbyB0aGUgY2hhbmdlIGluIGFub3RoZXIgcGF0Y2guDQo+IA0KPiBC
dHcsIG5vdyB3aXRoICdlbmFibGVfcG1sJyBhbHNvIGJlaW5nIG1vdmVkIHRvIHg4NiBjb21tb24s
IGJvdGgNCj4gJ2VuYWJsZV9wbWwnIGFuZCAna3ZtLT5hcmNoLmNwdV9kaXJ0eV9sb2dfc2l6ZScg
Y2FuIGJlIHVzZWQgdG8gZGV0ZXJtaW5lDQo+IHdoZXRoZXIgS1ZNIGhhcyBlbmFibGVkIFBNTC7C
oCBJdCdzIGtpbmRhIHJlZHVuZGFudCwgYnV0IEkgZ3Vlc3MgaXQncyBmaW5lLg0KDQpJZiB3ZSBj
aGFuZ2UgdG8gY2hlY2sgY3B1X2RpcnR5X2xvZ19zaXplIGhlcmUsIHRoZSB4ODYgY29tbW9uIGNv
ZGUgd29uJ3QNCnVzZSAnZW5hYmxlX3BtbCcgYW55bW9yZSBhbmQgSSB0aGluayB3ZSBjYW4ganVz
dCBnZXQgcmlkIG9mIHRoYXQgcGF0Y2guDQoNClNlYW4sIGRvIHlvdSBoYXZlIGFueSBwcmVmZXJl
bmNlPw0KDQo+IA0KPiA+ICsNCj4gPiArCWlmIChpc19ndWVzdF9tb2RlKHZjcHUpKSB7DQo+ID4g
KwkJdmNwdS0+YXJjaC51cGRhdGVfY3B1X2RpcnR5X2xvZ2dpbmdfcGVuZGluZyA9IHRydWU7DQo+
ID4gKwkJcmV0dXJuOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBOb3RlLCBu
cl9tZW1zbG90c19kaXJ0eV9sb2dnaW5nIGNhbiBiZSBjaGFuZ2VkIGNvbmN1cnJlbnRseSB3aXRo
IHRoaXMNCj4gPiArCSAqIGNvZGUsIGJ1dCBpbiB0aGF0IGNhc2UgYW5vdGhlciB1cGRhdGUgcmVx
dWVzdCB3aWxsIGJlIG1hZGUgYW5kIHNvIHRoZQ0KPiA+ICsJICogZ3Vlc3Qgd2lsbCBuZXZlciBy
dW4gd2l0aCBhIHN0YWxlIFBNTCB2YWx1ZS4NCj4gPiArCSAqLw0KPiA+ICsJa3ZtX3g4Nl9jYWxs
KHVwZGF0ZV9jcHVfZGlydHlfbG9nZ2luZykodmNwdSwNCj4gPiArCQkJYXRvbWljX3JlYWQoJnZj
cHUtPmt2bS0+bnJfbWVtc2xvdHNfZGlydHlfbG9nZ2luZykpOw0KPiA+ICt9DQo=

