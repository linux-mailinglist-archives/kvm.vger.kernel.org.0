Return-Path: <kvm+bounces-64581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D13C7C87AF6
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B15794E2237
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F1E2F659C;
	Wed, 26 Nov 2025 01:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mPpLFqIY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876072459D7;
	Wed, 26 Nov 2025 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764120074; cv=fail; b=WVLXliCEwYOn0hl7qAdZtmzcT/vHFVstr1/EWpcNXIgEiL3X7HnYCFl2Pab9svTnddvuqRhSfxXW8biZ3NNzifW//8GQQKUEkIE/mZiGyYwfzMTTtShMbsBOwnOvN60nfr5NHfEqDRmNeLnYk84gVFd8r+svQ2nhVU6qXJPeJCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764120074; c=relaxed/simple;
	bh=MFeYEsLm5f+N+wabsxSJasK1Qh6hbl1nqknjW0pJdn8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RTavzZpSKZYisrvXtiRep2OOWY0KF7w3G+ZwjVtaxMcBSL+a6m7o3OPSi83dBzDCHIUjKPdJnWMnGsNTyUNQ5lAUEqYsSXMCRqNTKx4ZJc47OI38t6cgdXukSKLjnbN2L5zhaQRJAqJ3bCd/pubLk9jlinhNwOGs5P3nPXXq5SY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mPpLFqIY; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764120072; x=1795656072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MFeYEsLm5f+N+wabsxSJasK1Qh6hbl1nqknjW0pJdn8=;
  b=mPpLFqIYocrJvT0gA6+MshHUXG9IQ5iTFOoxNdnmnU6IWMBPI6hWyK+S
   SbbzxO6wc1IEn5QMLHKs5xemIv6UA85+IyKVikuY/1UP8nfmEBT7qAH0V
   6glCy1HK582ZFZ9xNBCWd+LZY0sf+FqcWCyb8D/Ui9DnHX2/9Z3bM6jZP
   Tzmhyo+EGiNVKQEb0ogu/s3z8rLOJ9FYCoALDNMTfMD0BihuXRIrn3/oi
   HvtOpsJQ+PJL/s9xoXAJ5gJkO8jyNsybAdVnFS8RWGBot24uZ0nQbKYSu
   ppDJ1zViOVveMvkSmlxoiZME38IltrgakorMjuXl+kvxmgBWPuCobs2Bk
   g==;
X-CSE-ConnectionGUID: NLj3tdSJTJurWfuJJpUGLA==
X-CSE-MsgGUID: O00Oz2TAQsGLN7nBStAPDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="83538822"
X-IronPort-AV: E=Sophos;i="6.20,227,1758610800"; 
   d="scan'208";a="83538822"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 17:21:12 -0800
X-CSE-ConnectionGUID: U267vRonTiSTaDYMhHjupA==
X-CSE-MsgGUID: cnsQLMKySD2WgF/q5OdiSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,227,1758610800"; 
   d="scan'208";a="223494900"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 17:21:12 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 17:21:10 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 25 Nov 2025 17:21:10 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.36) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 17:21:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WarUYGsFttBj9bC95TfC1tu1DLrI52IBLcIsU6XuWFL2KmaD5h09nW/kR48nfASG0L9RgiTPD5kHZVgO4ZyvL+8dDOa5U5YF5XjqzTGS68NOsLCRj8qGNhAdjjyy9vpycMMsgUtUBXvpmbkk4e5/wYqv3HSN8Cgua/T191AA2R3Mle5zt1NlDa+MZxYhDVcAH8ixbq1paFzYghljZa8hca/sXcIhi6bPdAPwESmgjcUBxbfyobp+O/8cpMJSYPzWAoj5IVWOz76rcMj9fWDx+6L7lVIVfw0/XJEiU4QQWgvjJzvoIgHhhTtAGSClhiSQDnHHnZuw8ZQK6Iidzm7KIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFeYEsLm5f+N+wabsxSJasK1Qh6hbl1nqknjW0pJdn8=;
 b=M5PQvqZ7R6HP+tRJtUGiH7snvBJ/GvqUwJkY3QYPQGv1q9Z+fu2EWTrRL4I/zNt+0J5C9dhBbO+vqEojOxE7d0BEW7Wf7HlTX9yGmKiKsSjb5xSlGYLbVlQdG8CTu1NbDZCLQuruugSWFjRMJonnG2bBK4FajtOQgwjprDq5n2fl0JIKiyVsmNfO0Wlnx8F6W1D5RO1UZCJm0O6kRmdHIRtlOdEXxwmEwSq1rcEyXDG6U9t/nO4YqPS2vCeQVKVY8r1dIJTuO7jO9INQ18dGSx8Z7ldGFEOFznQrSz2djXtXONh4VvDfX5iSNbpOLiCELIne6MUzwkOB4tpQYoZJ/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by CY8PR11MB6843.namprd11.prod.outlook.com (2603:10b6:930:60::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 01:21:08 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%4]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 01:21:08 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu,
 Binbin" <binbin.wu@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIYV12AShtSkCJFJOo8oKvCLUEMNqA
Date: Wed, 26 Nov 2025 01:21:07 +0000
Message-ID: <c345d734e111eb0c3a98dbc517ed25071852106b.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
In-Reply-To: <20251121005125.417831-8-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|CY8PR11MB6843:EE_
x-ms-office365-filtering-correlation-id: c408d70d-2312-44fb-d6c0-08de2c8a13c9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aGN0akhCdTc5ZytMSkVnQzRPbjdtVm5uL0swSEtOc3pEZXBlMXo1Y0RNNXhR?=
 =?utf-8?B?NkZlN3lvbENLV3NFdVpoV1ozdUVGd3IyaXd2d29JeTBRTmpHSFE3VkdKTmtx?=
 =?utf-8?B?RTY4Z0V2ckdqbFdaRTBjalFDSldqWFQzZ1I1SFlLVjliOFpDQ2dGVTNtL2hF?=
 =?utf-8?B?dGFOS3ROWW5sUVRtUU1vckpNa2pmVFdkSmxXVHV4UEdoVVpTY2R4K0hCNCt5?=
 =?utf-8?B?dW9HTEtaMk9TVTZGTmt1eW9aM01PWS9ndXFTK0c2ZHJSMzk3MFNjNUN0anB5?=
 =?utf-8?B?YmhrWUs4TE0vK3UzQkFlbmwzMWR5TjkxWHZKN0pKSGMvcHNyMXFGcUpJZXFy?=
 =?utf-8?B?L0VjQi8vdUdmaCtqL1JkTmZmNjRyN01TZkw4em1GZWlnYk1wc1VvVDFtRVlm?=
 =?utf-8?B?enk0UVI4dFJsb2xFSU1FeDdCcnV0Z2syN3UvM3VpZ0tPbXNxYldUcitlQytl?=
 =?utf-8?B?YTdxZ1VwMDZ3OXNyRzBDVS9nRnFKaGNGbWRJNDdRSVk4VTk5ZFd2b0hZTE5m?=
 =?utf-8?B?WjhzRjdHK04yRVliMGhWY3NKY1FERnh4MGpSRlRsT3FYRTlHVGJVdHJtR2hQ?=
 =?utf-8?B?SkpueFVHY1lqcUZFU09kdjNVcGtCelQ2aDk2M3ovVW5kOUQvbUtqQUFta2Ro?=
 =?utf-8?B?K1FtNmlsZmN3UERYZVdEc2Q2ZEpvc3IyeWFhdlZDOC8wZEdwclRYTWNHUFgr?=
 =?utf-8?B?T2ZucWtsOFF0b2ZzaGFXdUVXWUxSNmY4ZmsvY0IvQTJVeUROTDY1UXJoMzlv?=
 =?utf-8?B?QXB6aVNVRFNOMnJQTGRMU1hTc0syeXh1VWtBZ3hLamNQMUFMSlV4alhsekhY?=
 =?utf-8?B?allRSmRUbW5rcExZVldKYmlTOGpBekVrNmdzS1FDR1RQTEk0QmNVek1JaXlT?=
 =?utf-8?B?MU84RjAwNEJTMGVQQWlnUHNsOVVER2s2elVqMzY3ZFZscm1Ed2NzUHIydzM3?=
 =?utf-8?B?T0tPTGZJalRrVHI1clpReVcxRHFRbzEzdHRqeEZvZVpQYmZtUnR2Zkp4YTlX?=
 =?utf-8?B?L3Z0YTlEOEtuVmQzN0FTMnNjRGdpR0JWMHpxVXVpSVl4RjFMRFNVN0lvMEJD?=
 =?utf-8?B?YXpVVkM4WGkrVkZsOWNhcytvOWR2aUh1WE95RnYrbWtERTFKR2hwYTdPZDlS?=
 =?utf-8?B?Y1h2ZlRKemlUaUM3dVdvK0hoYnpGUkdPeHIxREY5Y0FjdDF5UkUvdHRPS3VZ?=
 =?utf-8?B?SjZKUVFQMktLZUp4ek9EWkovZFN2TmdBZ3VLKzFKQkVjS1pDUGdBRW5jK3Q0?=
 =?utf-8?B?MnE2b3g4ZWNRbUsrb3ZyaithOExsRDFIMTZDdDV1SFg0cmlIWkU0LzVpMmJQ?=
 =?utf-8?B?TWoxejkxWUtDanZhWm55aFRnU3R1Nkk2THdxSE9jNXRvd09ydU05SlhvbWlj?=
 =?utf-8?B?VHlJelJQVWhCSmRwZlZRZDVCWW5GMXFYVEMzdXZGaDd4THZLWkFwOG5zM1ho?=
 =?utf-8?B?T21VaGkzdE1Ga0JqdDRqd3V3b21rTVc2R1dnVzRFN3NuU0NTUWFXSk9vWWds?=
 =?utf-8?B?cnVvSUNoTUJ0ckhZRU8zYkZmM1JRUmN3WFhjSWFQclhBdDd0S1hENENUV2Uy?=
 =?utf-8?B?RzJtVjYvdW1FRkVyOUVjWFdsbEdldkdLRjQrWDZhOUFvVVZ0Y2ZtV1I4Rk9v?=
 =?utf-8?B?Z01tK2lNQWw1MnFmVGpRaDJybmJNNGlrNjBjdVpjbWUvNDNNVlQ1Uk11UkQy?=
 =?utf-8?B?TkxLY3dRVzY4ZEVBeTFDQmhScUpZTWd0ZDdsclhiTmtRRzNnd05LTTF1Zk9r?=
 =?utf-8?B?T0FUQnhpREpvRUx0OWFWajU3eXNVdEJhdnhDRENyUGVEWTFlM21FTm51dWF2?=
 =?utf-8?B?MnZvTGtaOXQvQlRxOUFCaEt0S0d4UVo0Zmhaamx4b3VKQTNJSDZiay9zMVA5?=
 =?utf-8?B?V1FDdjZCOGVYREI2Z3U5dEVNTFM2TGtrMUNWOVhiMWJiU0hibFZvUlpFM1Rl?=
 =?utf-8?B?ZzdsNnoxbjMrQjNpSVlaWEVXVXYvSkZwZzB2cWd5RjhBdVE3RStHZThLbjlu?=
 =?utf-8?B?QWtRRysyWFN6d2kxdW1DR2hHTGVxM3pTSWVRZ0ZxYmhsTWxvcjZBcWV6N1k0?=
 =?utf-8?B?ZElxSTNQdFNXQU1pM2cxLzB4K0dDUTc0OW9xUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmU0UzhrTW9aRld2bU1qOUthQ25sK1hlQXl2cHRoYXNoNktGenU1NzNyVXFi?=
 =?utf-8?B?NFBFZFpsRDRIblBCTlZiS3BCMGtuYjMxRnhWYkFvNDBiNXovWW8wUjVNZEdj?=
 =?utf-8?B?K3ZRMkt4eGVTV2xWRkxGdUNGSGdaNU9zaGUvVmdUclU0UXdReUFyQWx2T0t6?=
 =?utf-8?B?b2pySXp1TDYwL0ZQaCsxTyt6VktpM1dOdGZpcTN2K3dRUmpyTzhTc1VPN1hE?=
 =?utf-8?B?QnM1VnJ2Q1JiWDdqZzJUTWRZUkNEbFBCVUpTN1I0dGcvWVR0WWphUFhDTkl3?=
 =?utf-8?B?QUZnd3pOUUNWQWcvcVdRY0NJMnVkQmxoNFE1Um5CeWxpQm5pbDFmQVg0N3hv?=
 =?utf-8?B?OXZWRURVZWVybnZiajB2VGN4Q2VFRmdUeXJRZWZneUhqV1lNN3VBYW5DdDdU?=
 =?utf-8?B?eDdmNzY0bDBEMUYyNEpxMmdvZXNTY2c4Z1lvaklYWlFjeEg3WVU2bE9UTnd0?=
 =?utf-8?B?aDcyWHVQc1NjQklnNm15d3pRMTNKNVZJT21keVQxREQxeGQ0c1VPUnVQcjFZ?=
 =?utf-8?B?UEZaQ05RSDFDcjJsenFCV2QwYUdhVVF5NUtzS3JhdDN2eGJWcHdUbTFETGJ1?=
 =?utf-8?B?Y3FQbzNmdVA0RDAxOEJVR0RHZnhYcTdWeXhnRjY4aFZRYmNDY0lvSzVMcWRa?=
 =?utf-8?B?TXQ0TmsvekVtdWNlVVVJUEpwVVFEQTdiTmRpVTlMSUxhQ0xCejQ0WGNrNmdk?=
 =?utf-8?B?T1I2SDdsNXU5SHE2Y0pGT0ZTMmp2TlBqTXlVUExPQTdYcFBscjJ4Tmt3MHVn?=
 =?utf-8?B?WEFzcG5zOVo1VjZTM0EySVY2U3JTalF1dVRjV25UZjdCdHZtUGFFUUdaVFcr?=
 =?utf-8?B?RlIwWHNOVUYvUTQydllsT0U4S3EzWmQ1d214dWgwV0thUDl2a002aUVzNFFP?=
 =?utf-8?B?N0p0WGt0NENGbWJYY1NLYUlDVjNWWG0yVDdnWklxT1o3ZUFWYUFybHpEWGI1?=
 =?utf-8?B?cHNkS2l2RFA1bkJJdmE5TU40eXlpVFM0T28rcUVwTFVPbzdLbGRhU0tqVmhC?=
 =?utf-8?B?STZpYmpDOTlLcmZ3OG1oQit0ZjFGM2loOWQwOWE3WHJZYlYxRFFXbUlCaGsv?=
 =?utf-8?B?S1hFY2ZjYmsrRTYvaDZUMUVMRWdqdjY3a0YwWDRGSzNhYzRaMUxiVmlHNmRk?=
 =?utf-8?B?VXJ3RVMvT3hqbHdQSnRiQW5hd3lLeWlTTWNNV1dUSEhwWG0vRy9nOTlvVng0?=
 =?utf-8?B?c3NZOGdJVFdRb2pLc052VDNjL0NuMFhRM3hmdXVWTkpGYjErR21IVkNnRzVU?=
 =?utf-8?B?V1FWb1NaTE1YanFPNUR2Wi8ydEZ5UDRCeEs1emZxZTFQZ05iUkFrQUZkdndV?=
 =?utf-8?B?N3hKZDVhelJiYytybDV1elcwWEhxQWxESzdKcnlOSFRGcE1WbkJxajMvTUp0?=
 =?utf-8?B?L2VWUkYrMC9LeU5WVzJzOGhiR2hoZzdDaXcwZUlWT0tOeVNQdWVEVENqZGJC?=
 =?utf-8?B?TEVVSFVJTHlKeTZlamNUUWlRcFM5Qm1PMmJRa0ltSGJ2R082MXlLdXNGdTBY?=
 =?utf-8?B?RVlQVXI2Y0RtaUVFWDM3NTdEeHcxNWJ3alVxbGdRSGhJWFd0MWtQbTc4SHlW?=
 =?utf-8?B?TjlrZFRNelB3ZmVCTkl6MnJCT21NZnlyeENMb1ZyZ0wrWHYweTJIcDk2NkN3?=
 =?utf-8?B?cmZQVTMwbWhWQkwwNHBFVTZXakhFajhYT0toSHhyUmM1M1YwWFlSQnBCYWp5?=
 =?utf-8?B?eUc1QlVGRkJSN0dZUitic2pQa25NaTdKQWdMKy81NFhpYXdUNHg0T1dscnZ4?=
 =?utf-8?B?amdUNFpzUFpWYlNyeWt2QjRCSnU1UkIybWFuZURNaVNQaDB3eTlabkY1QnJ3?=
 =?utf-8?B?bWNrYXhjMDVhMmxsWEt0Nm5kc05WMThjQSs0UHhuM2E3djA3UEFvNUJyK1pL?=
 =?utf-8?B?eERKZVU1WUo2bmVpci9IeCtLS0tFN0tGYWFYK2F6L0xWbVlaSFA2bGJ1TGdu?=
 =?utf-8?B?UGx2QmZZaCtBTFg0U2xQQ01LWVgrZ2xHSWVEMGFBdWdXVzc0ekliZzE5Ylk4?=
 =?utf-8?B?MndvM1FhelZCampNdkFrbG41VXQwR04xVCtabHRLTnVJc05OTlNORS8wS0ky?=
 =?utf-8?B?ODdKRXpGcngxMnZUUUFJU0E3OWg2VVFKdUdCbURVVjYxd1JzT2p5N3hhREY2?=
 =?utf-8?Q?NP2gFs40myQdLeOqZSjg5G/TS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C8A4BD198A3D147A6EEB3E5C3B010ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c408d70d-2312-44fb-d6c0-08de2c8a13c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 01:21:08.1731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9imklzCVlwE/TtENywgbD6W0nFZkgcPuFJAtdA9jPJAPG7/pUj4vKQLnyZiPqUw/hCidoE2s0kDIhecptGUtDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6843
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTExLTIwIGF0IDE2OjUxIC0wODAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oIGIvYXJjaC94ODYvaW5j
bHVkZS9hc20vdGR4LmgNCj4gaW5kZXggY2Y1MWNjZDE2MTk0Li45MTQyMTMxMjNkOTQgMTAwNjQ0
DQo+IC0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+ICsrKyBiL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL3RkeC5oDQo+IEBAIC0xMzUsMTEgKzEzNSwxNyBAQCBzdGF0aWMgaW5saW5lIGJv
b2wgdGR4X3N1cHBvcnRzX2R5bmFtaWNfcGFtdChjb25zdCBzdHJ1Y3QgdGR4X3N5c19pbmZvICpz
eXNpbmZvKQ0KPiDCoAlyZXR1cm4gZmFsc2U7IC8qIFRvIGJlIGVuYWJsZWQgd2hlbiBrZXJuZWwg
aXMgcmVhZHkgKi8NCj4gwqB9DQo+IMKgDQo+ICt2b2lkIHRkeF9xdWlya19yZXNldF9wYWdlKHN0
cnVjdCBwYWdlICpwYWdlKTsNCj4gKw0KPiDCoGludCB0ZHhfZ3Vlc3Rfa2V5aWRfYWxsb2Modm9p
ZCk7DQo+IMKgdTMyIHRkeF9nZXRfbnJfZ3Vlc3Rfa2V5aWRzKHZvaWQpOw0KPiDCoHZvaWQgdGR4
X2d1ZXN0X2tleWlkX2ZyZWUodW5zaWduZWQgaW50IGtleWlkKTsNCj4gwqANCj4gLXZvaWQgdGR4
X3F1aXJrX3Jlc2V0X3BhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UpOw0KDQpJIGRvbid0IHRoaW5rIGl0
J3MgbWFuZGF0b3J5IHRvIG1vdmUgdGhlIGRlY2xhcmF0aW9uIG9mIHRkeF9xdWlya19yZXNldF9w
YWdlKCk/DQo=

