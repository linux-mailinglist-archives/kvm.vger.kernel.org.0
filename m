Return-Path: <kvm+bounces-17543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C0F58C7A71
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 18:37:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E53A31F22216
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 16:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73734522E;
	Thu, 16 May 2024 16:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZMnSlTG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977BB4691;
	Thu, 16 May 2024 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715877415; cv=fail; b=gau+ZcfLvI0rHe8ZLrf6d75IEWnq/WCLT14g1QTnAr2LNYdyVeEWHZE6nKkvwx771Kw2mLDZ8+RcYiJrj7A7zwzL92XVHJTSHABxXAc1Lk5lzv18G52APFQJnGlUkZVeSPeCEKGADP0TNz/5Iv4zqNx1Q9bXwnQr+iXOTIe0PYc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715877415; c=relaxed/simple;
	bh=95qccVmvZ0xPqs1Dx7nPJ1wT2EODE6d9szIBMXbQ5QQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XuM/YNoEzXqhdkEICja2y6MMM7R5Yait6lOeAWGe2o+rQyzN05bSDlegpNKy+QgVSAoPysntZ30U0LaE0KBHI9eiedvsnfWa/Us9Ve4sg6SV5ROELbE9umE/C3vPG01o31d7XubCPCCrVQMndIWvXMwk9WXwlz3gPMBG+yVCLoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZMnSlTG; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715877413; x=1747413413;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=95qccVmvZ0xPqs1Dx7nPJ1wT2EODE6d9szIBMXbQ5QQ=;
  b=gZMnSlTGMzNu4Sou9l0ZQyNsa4Zy/tTldFqhobHBK4knuYyC915qzJZP
   Y1clpN+IorCVZtmq0xVqDjevevwZg49CjTcxzlQVUAmHEeQM07+C42YDI
   wQp2gDLKVLJDXsnN/Es5yNuAqTHFfKlpnU+JzMngsUEwI7GEYF2+9Y5aA
   wHRe5tS7o8jEiDo2TwogSsGEYriFBmRqTz6wCcnlKXxAMu9UAle97/Asc
   ZEP5v/BCk7OiLEPrmDdv007EAs3HpE6VHkYLm9iQAeNjSmS4pzT3z9wyl
   nht2BHABAAr27zNIj9CsL3LLhzl2fbSWV0gft0VBQIRUwQqwB9z/ApypD
   Q==;
X-CSE-ConnectionGUID: a0k+/tMNTtixTHlvhOVAhg==
X-CSE-MsgGUID: 32KKpm7xRLK8Lwv5i98jIg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="29523868"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="29523868"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 09:36:53 -0700
X-CSE-ConnectionGUID: ODZFnU0nRRGizTYNrTWJcA==
X-CSE-MsgGUID: KZKSlQqLRNa0pYH9ISYjfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="31590917"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 09:36:53 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 09:36:52 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 09:36:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 09:36:52 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 09:36:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7awtAELHf0f9iQwqvB/Ol39pxJ9rrBkSSknlZY2R2WOer3qDw1gV3ppAmVyRci1Qck23IXx6AywYx6Ugl4dFEAalDhwu6RdHL6p12rcxYEpKNNIZCJAhiIjaQbnDR+X3n8rsiyHqlYEpy7Cp5/0U5igTgU/DZlBcP7JHeXphFevK+Qp7gGjPjGrsPn34hZuudMmxkbdODFeUbkdMBXUWtrZpEMGlTZUkhauliInmrezp6TeSdQ6MtbjexGAp+i0bfZO0Cju/D0kiInSy1vK884WdYs0NWQL/2NF1dbEBw076V88hnLIvr7ojsu4pd29hCLoQCL0RYB2CHUdG4GXSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95qccVmvZ0xPqs1Dx7nPJ1wT2EODE6d9szIBMXbQ5QQ=;
 b=lqt9QSxJxtFtgBbEUxo6oIjG90A0RADpL/rqHpHVIovtqB/dLypIAaVryVvVFXsFbtq1Tt/+eT/NvflIwjBmaMxNEg+hushIN4Rm+iUoEogM9zd/v9N0Enk3OWg8puNuZUvkNXZKEaVG2FPZTcjfhl1RgRSnh6AtlUdc4AquUjmPP0fEacg/nHfZhfQwxE9rPhILBJykvAFSuEuOHrO42gIhKhQa2N2gZQEaaRquPsqy/KE5tF5IWCsIc39SXVioIbgqjzKG4jgldnJIugBun6kWel+oJoHw3Iin9CDbeV8suxd91aH+bBfWSBWM8Vits3pDEJk86PIUWYqMsfABjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6604.namprd11.prod.outlook.com (2603:10b6:806:270::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 16:36:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 16:36:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "sagis@google.com"
	<sagis@google.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GZCeQAgAAJxQCAAAs0AIAADfKAgACpkgCAADtVgA==
Date: Thu, 16 May 2024 16:36:48 +0000
Message-ID: <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
	 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
	 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
	 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
	 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
In-Reply-To: <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6604:EE_
x-ms-office365-filtering-correlation-id: aace243e-ecad-4c1c-2a28-08dc75c661d1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TGM5MTByWWh4bm9vYlNlQ3FBMXVwNFNqaFRMYis4Syt3RUhjU1JvYXFZQmhj?=
 =?utf-8?B?OHB3T1RockNLM2VnSUc5ZmVaSWxBazZIdW13VWs2NVpOOG0xbzdlZDNFRThw?=
 =?utf-8?B?a0dKbkpsVWp0RVNtYlpWVG1HbHIxQWhnb1EyZ09NbVdRKzBFZXlteUNJSjJ1?=
 =?utf-8?B?OUtaVTl6cVZ3TUJpS2Y5T2ROejgzczFqY3g0RCsyemFHdGZsclI3L2lQbEUv?=
 =?utf-8?B?U1pQLy9IUjZmNEd0enlDL1VkUkMrdDFkRFVEUmNlNk10eXpPTUE5YysxMjFl?=
 =?utf-8?B?RUdLWUY1SkNlRUJLMzloVVZURVlRVENON09xWjRSbVJua1pPYW5UTWFJenA3?=
 =?utf-8?B?dUlhbDVaQk5GQzZoNUpqdmo4c0JFaVIrdGlqQXBGTGYvL2tObWhBQmkxNGIy?=
 =?utf-8?B?MjM5dVp6ZjhHQkJheUF5QVB5bkxzRzlBTHJPdGF5dkZUZlZYcmo1OEw2Y0ZC?=
 =?utf-8?B?ZnVoaEZ4QnZoSTJPTHFBSis5a3BMNEhEeEdkU3djdkJ3MlVMbWJVNkFVbDUz?=
 =?utf-8?B?dm85dDhjb0ZGRzlkVnliUS8zeUZCR2N6dXU5MzEzSmZJUHFpOFRSblpWWGtp?=
 =?utf-8?B?TkdYWmYySTc2VkgrbmtlZXkzdlRlZDdYemcwVk94MjBZbzVsc0hkTW43eU1W?=
 =?utf-8?B?RmJWQnZXYXl5SUNGeG9NM0FqRW5kc3NQWlhuSEJUWm9pVXNlRWJqNnhicUsw?=
 =?utf-8?B?NHF1SExQOHhJL3N3SU01eG1IQlBUWW9FZ0NYRHpWTUtvKzNkbUZrV0dwRWxt?=
 =?utf-8?B?VkRRdjJYaUFmWmFpNjNmekxTVWsvdDlVZzJidzIrSUU2ell2T0M4SUk4OXMz?=
 =?utf-8?B?ZGszUmhMU296N2ZpQzJlZUF5ckNWVFAxOW42N2k3bmRBYVFFeGtPdjNTWGo2?=
 =?utf-8?B?RnBFSFREVllKR1hjK1lJdkVicEJldE5Hd1ZzcWpZUnZibkw5Z2ZLRkZ6Kzlk?=
 =?utf-8?B?QkxKZUhzUHBTNlJLYmpNRUNrRFlGRlVQZkp2RU4wSUJ0YldIWnF0VmZpK1lY?=
 =?utf-8?B?b3NrN0lGUThEd2w3TXNhTnRnQlNkVUdNYlpjWU9kSVFIa3V1aTJNZVpuRmxl?=
 =?utf-8?B?eFpwdkxuU3Rtay9objJ5UDFDcnpYaFpZRlhmKzNJWW03T2ljVURkT0JmUDZz?=
 =?utf-8?B?RG91MkZaNnhiMHBKSU15WjNYSjhKK1k3R0pBZXUrTk1XNHFlTEdxMDRYZDdD?=
 =?utf-8?B?cjIzY1BFUFo5Q21nRWdQNTFNNWZCK0U1akhHQWhHWVVWcWIvSHR3ZDlkeDRG?=
 =?utf-8?B?ak9hN2cxaUdNSUovVlArWVBBRVBDeno3cHU3Z1hLY01QNWQ4R2wrSkUwQTQw?=
 =?utf-8?B?dG5tcGVWVkVMSkM1WFlPMFlXYVFkbDdFWmtqOWFHbVlBdDB4MllxTmdZRk9s?=
 =?utf-8?B?cm1rdlZFOGd4YjlhMVZlZFIvRVFxaDRxbElTM1JzRkhmT2hBajRyNWUxM1pC?=
 =?utf-8?B?cUNWeElyUkFFRUxQc1ZnU0ZmUnNDbGp2Q0p2Q002emRBbjBtMUw0Ujk0bGVi?=
 =?utf-8?B?WCs1VGZ0UEE0aURqaVRCSHgxem0zU3gzM21LT1BFRXhTeWxsUmxJVmcxY05P?=
 =?utf-8?B?WDFUcndUYUdQcEp3UFRONlU1MFlrOFluRElEbjdSY05SQXBxM3M2K1BYdGZn?=
 =?utf-8?B?VENMRkJ4ZjZRZjV3eGxVRjkxVDlMdEhMcm9nMWJqeWxPcG0ya1J6T0hKTnh1?=
 =?utf-8?B?RkpBUUk5VGdCTllWMzVlRXBZWmxUSytKWUNrK1hIaloxcktIUjZPaXhaSkFD?=
 =?utf-8?B?cE8rMUp3Kzk2b3NYanlGVmw1VXJhY2NxbDVGS3BjWFhSblJKTEw3TkpOUDFw?=
 =?utf-8?B?Uk0wbVg3ejhwbTZjUlZ1Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czFod01MdUFnb0VTbmMxY0I0SGIvSndyZkJNWS9XT0plWit0eDVzVWxrS2gr?=
 =?utf-8?B?emF1UTRKZUlFTXpYcUtoZTNrRVg0bVFDenF6TkVIVUtJbDhUTmZqM0dQT0kx?=
 =?utf-8?B?NURJeXNkQ1ByeUlINzlOZzRxRnRhUkV3aFI5T0lCNTJrRm5WdmdMK3MwaTRP?=
 =?utf-8?B?d2tQcCtPREJma1pmdWp5WXArM2RYbFR3MFNEd2Zpai95ejNMUFRMNDVwNWxk?=
 =?utf-8?B?Q3NNT3ZTY2pITitIQ3JhQXozZGsxYVdkc2hoUEE0YlpCVDJCSGczWXRKTUJ2?=
 =?utf-8?B?V0Ztdld4WnpoS256K1FyNGNMdENHN0F1R2Noc0JJUWZabWU2a3dhMXFtbkFD?=
 =?utf-8?B?aHZ3NVYyL0J1NTlnVnQrQjBTWUtwMGx5WE5qVk9ZUk5WUTdjSUJtTFViYktJ?=
 =?utf-8?B?b0NKU3ZPZWFBN3E4V01tc0tuUVAyaGhNU2JJMVZ4VGxZdGpranEvdEhreTR0?=
 =?utf-8?B?WWs1WUlZVFBIMENHc1c3TlNEMVdQMit5MXo1RzNjYWs2ek9HOWtvdDFaOFh5?=
 =?utf-8?B?N0toQXNZdWRLclBhbDBPQXNueFdqb1MrV1FUTFZCSjcxZzFVQ0k0WTA1Nkdh?=
 =?utf-8?B?Q3lVMHRYVldBTFhDUElHYW5aUHAzaVpEWUtxZWZnRGN2ZlIzQXgvMGRtU296?=
 =?utf-8?B?dEFlek9ORG1MTWhEZ0JCUHl1UFBKU1BRZ3loSllCQ3hOZlZVMG13YmRnTk9M?=
 =?utf-8?B?N25halRBKzNiaXRTS29aNndDWWFWSzF6VnBTdEQvVXVlbTJUck1XbHZnZC9a?=
 =?utf-8?B?Y3BzaUpyZDVHdkJaTjVCdjR3NFdiamRhSlFsRlVxRElyYS9UYWw4L2VLakF4?=
 =?utf-8?B?RkNGcit1Nm9tZXFwem9XV29uc04yTkhCTy9rNDJ6Q1RCSUw5T0dMVFRscDQ1?=
 =?utf-8?B?ZlU5UjUveU1iK1NocEw4UVlsaTgwK0FoUGpxa0plNFdaK1pnMG81U0s3WndC?=
 =?utf-8?B?V29EUE02MFVHV2JHMytFWEJDaVlON200d2wvK2p4dy9XNDhCMXljWjYvdHVF?=
 =?utf-8?B?bmFKSTdZWER2QXhkMDF3ZUg5Q2dTVWZFWGt1RHJiRzIxQUJYeXpUVHFLMm1x?=
 =?utf-8?B?cHZNdlYvcFVPNGx5bDNkQS9kS2Q4TjZLMFBFTWpOeVlxNEx5U3o0Z3pJaWFi?=
 =?utf-8?B?NFZFbkQyNEJtMVZtQUQzQUlxMXMrc29rWTQ0bXZGUXhlTUk3SnN0ZVhYUWRM?=
 =?utf-8?B?aFVnOFVrKzRJNXdaU21ndU9OV2g1eGd1STNNTk1YcFNHZWlKYklWdU5ZREd2?=
 =?utf-8?B?UW1yNnFDTlRhbllubXczV21acXFjNjBmWlpRVnBqMlJyN2ROam50MkNwbXdW?=
 =?utf-8?B?S2V2cVRmcFFlNTV5dS9jOS9odDlCeEdjUHpielFtYVRtaDhNN2NJK1lWb3dP?=
 =?utf-8?B?STljNUlFOVNUUDhMNlBSSVJSUklHdE14K0N1djRITGdyeWtacG5CUmtIUEZp?=
 =?utf-8?B?a25hMkVRTjd5ZzdMY3lZeDltalFVUWtvaHh3RDJpa0ppRlZQeHJkMXYxcGdN?=
 =?utf-8?B?ZEoxcHd2dExhSXFkNEJtbkhxdldkWUMwT1hzWFNncU1heHJ5NEE2TVR4T01T?=
 =?utf-8?B?eDhPL0EzeDBXWisxSkhPOU5QdkNLUCttRjN2K1h6Q1JxL2RQVnBUek5KNkZX?=
 =?utf-8?B?Y01nNTVqdUFtcEFrVW05UDlXaElWLzgwb0d4OTc5d1hJMW5adm1VUGt5SElk?=
 =?utf-8?B?dGN2Tmt1QUZVUHpVOXpsZzBaTTF4QU1MS0VwbWNTeTc4ZUI1Mk5hV3lXaGdG?=
 =?utf-8?B?bEs0V1hxVnNmcytrcm03elFmNGVWeVkySFFoWG1maDI0KzBzSExkdzA4UE5u?=
 =?utf-8?B?UVNoNFJDUlZXS0tBQTE4OUJXVWRjZDYvdFMrdDVGSW1mdzI0U0l6eE5zYjRi?=
 =?utf-8?B?b0NvNTJTVTMvRW5QaTh3Wkl4MUxSTzVzeVJjZmQ0Q2FMQ0VwM1N0ZzlOSk9J?=
 =?utf-8?B?U01VenZEM245NHkyWjFvKy9CNnZVNWFaU1VPb1Z3ZWxKd250T0ZGOVJ6MWd3?=
 =?utf-8?B?eFk0Vm9sTVhMREozR3QzYWJ0RzlsaUdNN3g0UC9SemU5MVg5bWxOYnJtb0ov?=
 =?utf-8?B?Mjg2ODZKVTR2SCt3c3Q3ZUVnM2Y5dnFDZno4WXpIRVEzb212VVNDU2xraGVW?=
 =?utf-8?B?ZHNCQWF1UEE3WGlGYWlONXlVaVZPUkFibEo3Z08xVFZoSGdTeUU3Y2gvNlNw?=
 =?utf-8?Q?xPc6oSN9UNd6GCS9PEM8TYU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F47D82CE41C46948A45461F3429562D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aace243e-ecad-4c1c-2a28-08dc75c661d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 16:36:48.4587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zwK9RiJr/rhMh23z9rBDMcevepBa+hQgVfH6HmcHxc91PV0cNC0oo4BUktNVRgy9dvvPrJpnKh1hFaqe+HM+/0p6M8OgCE7U80tEGCaiET0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6604
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDEzOjA0ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBUaHUsIDIwMjQtMDUtMTYgYXQgMDI6NTcgKzAwMDAsIEVkZ2Vjb21iZSwgUmljayBQIHdyb3Rl
Og0KPiA+IE9uIFRodSwgMjAyNC0wNS0xNiBhdCAxNDowNyArMTIwMCwgSHVhbmcsIEthaSB3cm90
ZToNCj4gPiA+IA0KPiA+ID4gSSBtZWFudCBpdCBzZWVtcyB3ZSBzaG91bGQganVzdCBzdHJpcCBz
aGFyZWQgYml0IGF3YXkgZnJvbSB0aGUgR1BBIGluIA0KPiA+ID4gaGFuZGxlX2VwdF92aW9sYXRp
b24oKSBhbmQgcGFzcyBpdCBhcyAnY3IyX29yX2dwYScgaGVyZSwgc28gZmF1bHQtPmFkZHIgDQo+
ID4gPiB3b24ndCBoYXZlIHRoZSBzaGFyZWQgYml0Lg0KPiA+ID4gDQo+ID4gPiBEbyB5b3Ugc2Vl
IGFueSBwcm9ibGVtIG9mIGRvaW5nIHNvPw0KPiA+IA0KPiA+IFdlIHdvdWxkIG5lZWQgdG8gYWRk
IGl0IGJhY2sgaW4gInJhd19nZm4iIGluIGt2bV90ZHBfbW11X21hcCgpLg0KPiANCj4gSSBkb24n
dCBzZWUgYW55IGJpZyBkaWZmZXJlbmNlPw0KPiANCj4gTm93IGluIHRoaXMgcGF0Y2ggdGhlIHJh
d19nZm4gaXMgZGlyZWN0bHkgZnJvbSBmYXVsdC0+YWRkcjoNCj4gDQo+IMKgwqDCoMKgwqDCoMKg
wqByYXdfZ2ZuID0gZ3BhX3RvX2dmbihmYXVsdC0+YWRkcik7DQo+IA0KPiDCoMKgwqDCoMKgwqDC
oMKgdGRwX21tdV9mb3JfZWFjaF9wdGUoaXRlciwgbW11LCBpc19wcml2YXRlLCByYXdfZ2ZuLCBy
YXdfZ2ZuKzEpIHsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAuLi4NCj4gwqDC
oMKgwqDCoMKgwqDCoH0NCj4gDQo+IEJ1dCB0aGVyZSdzIG5vdGhpbmcgd3JvbmcgdG8gZ2V0IHRo
ZSByYXdfZ2ZuIGZyb20gdGhlIGZhdWx0LT5nZm4uwqAgSW4NCj4gZmFjdCwgdGhlIHphcHBpbmcg
Y29kZSBqdXN0IGRvZXMgdGhpczoNCj4gDQo+IMKgwqDCoMKgwqDCoMKgIC8qDQo+IMKgwqDCoMKg
wqDCoMKgwqAgKiBzdGFydCBhbmQgZW5kIGRvZXNuJ3QgaGF2ZSBHRk4gc2hhcmVkIGJpdC7CoCBU
aGlzIGZ1bmN0aW9uIHphcHMNCj4gwqDCoMKgwqDCoMKgwqDCoCAqIGEgcmVnaW9uIGluY2x1ZGlu
ZyBhbGlhcy7CoCBBZGp1c3Qgc2hhcmVkIGJpdCBvZiBbc3RhcnQsIGVuZCkgaWYNCj4gwqDCoMKg
wqDCoMKgwqDCoCAqIHRoZSByb290IGlzIHNoYXJlZC4NCj4gwqDCoMKgwqDCoMKgwqDCoCAqLw0K
PiDCoMKgwqDCoMKgwqDCoCBzdGFydCA9IGt2bV9nZm5fZm9yX3Jvb3Qoa3ZtLCByb290LCBzdGFy
dCk7DQo+IMKgwqDCoMKgwqDCoMKgIGVuZCA9IGt2bV9nZm5fZm9yX3Jvb3Qoa3ZtLCByb290LCBl
bmQpOw0KPiANCj4gU28gdGhlcmUncyBub3RoaW5nIHdyb25nIHRvIGp1c3QgZG8gdGhlIHNhbWUg
dGhpbmcgaW4gYm90aCBmdW5jdGlvbnMuDQo+IA0KPiBUaGUgcG9pbnQgaXMgZmF1bHQtPmdmbiBo
YXMgc2hhcmVkIGJpdCBzdHJpcHBlZCBhd2F5IGF0IHRoZSBiZWdpbm5pbmcsIGFuZA0KPiBBRkFJ
Q1QgdGhlcmUncyBubyB1c2VmdWwgcmVhc29uIHRvIGtlZXAgc2hhcmVkIGJpdCBpbiBmYXVsdC0+
YWRkci7CoCBUaGUNCj4gZW50aXJlIEBmYXVsdCBpcyBhIHRlbXBvcmFyeSBzdHJ1Y3R1cmUgb24g
dGhlIHN0YWNrIGR1cmluZyBmYXVsdCBoYW5kbGluZw0KPiBhbnl3YXkuDQoNCkkgd291bGQgbGlr
ZSB0byBhdm9pZCBjb2RlIGNodXJuIGF0IHRoaXMgcG9pbnQgaWYgdGhlcmUgaXMgbm90IGEgcmVh
bCBjbGVhcg0KYmVuZWZpdC4NCg0KT25lIHNtYWxsIGJlbmVmaXQgb2Yga2VlcGluZyB0aGUgc2hh
cmVkIGJpdCBpbiB0aGUgZmF1bHQtPmFkZHIgaXMgdGhhdCBpdCBpcw0Kc29ydCBvZiBjb25zaXN0
ZW50IHdpdGggaG93IHRoYXQgZmllbGQgaXMgdXNlZCBpbiBvdGhlciBzY2VuYXJpb3MgaW4gS1ZN
LiBJbg0Kc2hhZG93IHBhZ2luZyBpdCdzIG5vdCBldmVuIHRoZSBHUEEuIFNvIGl0IGlzIHNpbXBs
eSB0aGUgImZhdWx0IGFkZHJlc3MiIGFuZCBoYXMNCnRvIGJlIGludGVycHJldGVkIGluIGRpZmZl
cmVudCB3YXlzIGluIHRoZSBmYXVsdCBoYW5kbGVyLiBGb3IgVERYIHRoZSBmYXVsdA0KYWRkcmVz
cyAqZG9lcyogaW5jbHVkZSB0aGUgc2hhcmVkIGJpdC4gQW5kIHRoZSBFUFQgbmVlZHMgdG8gYmUg
ZmF1bHRlZCBpbiBhdA0KdGhhdCBhZGRyZXNzLg0KDQpJZiB3ZSBzdHJpcCB0aGUgc2hhcmVkIGJp
dCB3aGVuIHNldHRpbmcgZmF1bHQtPmFkZHIgd2UgaGF2ZSB0byByZWNvbnN0cnVjdCBpdA0Kd2hl
biB3ZSBkbyB0aGUgYWN0dWFsIHNoYXJlZCBtYXBwaW5nLiBUaGVyZSBpcyBubyB3YXkgYXJvdW5k
IHRoYXQuIFdoaWNoIGhlbHBlcg0KZG9lcyBpdCwgaXNuJ3QgaW1wb3J0YW50IEkgdGhpbmsuwqBE
b2luZyB0aGUgcmVjb25zdHJ1Y3Rpb24gaW5zaWRlDQp0ZHBfbW11X2Zvcl9lYWNoX3B0ZSgpIGNv
dWxkIGJlIG5lYXQsIGV4Y2VwdCB0aGF0IGl0IGRvZXNuJ3Qga25vdyBhYm91dCB0aGUNCnNoYXJl
ZCBiaXQgcG9zaXRpb24uDQoNClRoZSB6YXBwaW5nIGNvZGUncyB1c2Ugb2Yga3ZtX2dmbl9mb3Jf
cm9vdCgpIGlzIGRpZmZlcmVudCBiZWNhdXNlIHRoZSBnZm4gY29tZXMNCndpdGhvdXQgdGhlIHNo
YXJlZCBiaXQuIEl0J3Mgbm90IHN0cmlwcGVkIGFuZCB0aGVuIGFkZGVkIGJhY2suIFRob3NlIGFy
ZQ0Kb3BlcmF0aW9ucyB0aGF0IHRhcmdldCBHRk5zIHJlYWxseS4NCg0KSSB0aGluayB0aGUgcmVh
bCBwcm9ibGVtIGlzIHRoYXQgd2UgYXJlIGdsZWFuaW5nIHdoZXRoZXIgdGhlIGZhdWx0IGlzIHRv
IHByaXZhdGUNCm9yIHNoYXJlZCBtZW1vcnkgZnJvbSBkaWZmZXJlbnQgdGhpbmdzLiBTb21ldGlt
ZXMgZnJvbSBmYXVsdC0+aXNfcHJpdmF0ZSwNCnNvbWV0aW1lcyB0aGUgcHJlc2VuY2Ugb2YgdGhl
IHNoYXJlZCBiaXRzLCBhbmQgc29tZXRpbWVzIHRoZSByb2xlIGJpdC4gSSB0aGluaw0KdGhpcyBp
cyBjb25mdXNpbmcsIGRvdWJseSBzbyBiZWNhdXNlIHdlIGFyZSB1c2luZyBzb21lIG9mIHRoZXNl
IHRoaW5ncyB0byBpbmZlcg0KdW5yZWxhdGVkIHRoaW5ncyAobWlycm9yZWQgdnMgcHJpdmF0ZSku
DQoNCk15IGd1ZXNzIGlzIHRoYXQgeW91IGhhdmUgbm90aWNlZCB0aGlzIGFuZCBzb21laG93IHpl
cm9lZCBpbiBvbiB0aGUgc2hhcmVkX21hc2suDQpJIHRoaW5rIHdlIHNob3VsZCBzdHJhaWdodGVu
IG91dCB0aGUgbWlycm9yZWQvcHJpdmF0ZSBzZW1hbnRpY3MgYW5kIHNlZSB3aGF0IHRoZQ0KcmVz
dWx0cyBsb29rIGxpa2UuIEhvdyBkb2VzIHRoYXQgc291bmQgdG8geW91Pw0K

