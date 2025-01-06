Return-Path: <kvm+bounces-34624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E533EA0300E
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FB6F3A4427
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 19:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D42131DF984;
	Mon,  6 Jan 2025 18:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XHBnUtUY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8A71DED79;
	Mon,  6 Jan 2025 18:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736189994; cv=fail; b=WoBHEO/UQyW2BdppYDucxtSDoD8htn/HuCZjChfk28uDu/LecLvZ0WW8TsfsE9BFLXlgs4LIsi424ywU063RNjhnjcw7YllaxTuqUW6FsvekgeUEzeCIU7WPAYiOn+qRH7cNEyGyWAyjFcHH8UsbwMYTYyMcWBiT/U48PwPw7TQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736189994; c=relaxed/simple;
	bh=VdnADqwsNxvtCec4RW/s39gK1sgBKuI5XM5eN8NNaYw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TFwU8pgcFTkaJ+om+9vGZ1ufPC2FgDG080+Vfmi+IGTFN548HCrYTQCDp2VTras2CpsNCqubtuG7daxt7zCI6s5TkSyHxQQj7ZmDngcr1hGlM6iHgWxGrKLjaDC6UTwQOf2pFeAAsN4ZNfz4xawSj9Dw1o8CHALWTF0n4+gORJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XHBnUtUY; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736189993; x=1767725993;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VdnADqwsNxvtCec4RW/s39gK1sgBKuI5XM5eN8NNaYw=;
  b=XHBnUtUYBBJPm874deHSEiBAOW6wWAkdonZDyAdl06I9DMYlzYLsSQ+k
   McOicPexMx3ayakXY2HnQCEASEzmYbe26FjizUgg4XXrWTU9ZtRnqdFEn
   HXu5w4rtR4+hzGptaZEXnHg8j4Bz2mANXTI7klhOgPGezWA5N/SHJHwTe
   i28tK+XH9yNpKSV37wI6LWu9z+hOgoWSNoPKh69Ct6kTHZRvMpeMddNl6
   JKSg1dHILM77HfJ5p8gyzyrvNIwRWmurZ6SG7peuTQRgo3NBN7yJgmWfu
   7gPPT8eKI5RN9loAo3Nc30sE+P8U0yU/9kCoLb2vXXdb29Z8XuworN1Ry
   g==;
X-CSE-ConnectionGUID: 4W3yzAH7Q0CiI6Hytf5A0w==
X-CSE-MsgGUID: DicIEY03RxOI1mPC1QETtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11307"; a="47704135"
X-IronPort-AV: E=Sophos;i="6.12,293,1728975600"; 
   d="scan'208";a="47704135"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2025 10:59:52 -0800
X-CSE-ConnectionGUID: qQlmPvGTSWqftpxLPrHrXA==
X-CSE-MsgGUID: /+nJNLkYTlW4dOP0lHM8rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="139871054"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jan 2025 10:59:53 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 6 Jan 2025 10:59:52 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 6 Jan 2025 10:59:52 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 6 Jan 2025 10:59:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tVpX8RvZqkPjWWDgMDs0dNVBFv3pAzgp7AwfRo4o48xYG0Lnd3tdI+B5TUXsvj7JeiDqN3S+ApbKXEHQOVabfdOZvT9lpBzJNDOk0fRaLYojKMiXNe8BWFWPyif2WAbNm1b9x+7Ui5k3KGu3X7IAFhKxbEGZyVUk31pRhqomPJKXzYH/E6OsuRWvhKjKCx0gnTnexnnqnv+JpleLSu5xm1Z2Ap1IFcK6WoeJF++hP8JjA3x0HziUtfoDSMQLVtAoahDth8jx+dQAgtbBawHpq4BMNZgM/l2fJ91uXm+vnDrThbyoAL1F/xVtd/KmEDWNEfpKZ04f7TG81BijKCagkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VdnADqwsNxvtCec4RW/s39gK1sgBKuI5XM5eN8NNaYw=;
 b=OLC1TJ17QcdlYnAwgfJxzPz1/DhShQhZBw2UFaWCC8K1qWNCO3RHFLZBSZxn1mU4x1B1JCyfVKwtb2I+nIQVFJi+XCbaP7689L14APTuUvsyrYIJFV23g9JmKRfuxxDjfJOebvwi0Xdgzi34Z6+/B+ZJTHOL99eY7abt6x//uQ1hySIBA1r+NHJzgrNNw0n24MMlFc6L0SlX9IKzGET+5aBTmUKA0rRMw8PkT3Gm5F9PyiOQpEPc47uzKEerV7fGixmb/x083MPkKzQ/AH1oeAHNuZqCHktJx9l3SIoGATat/9XC19XLKGPZE0YXVJiL084taf6xwmtZEagY4P4uJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8811.namprd11.prod.outlook.com (2603:10b6:806:467::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 18:59:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 18:59:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "yuan.yao@intel.com"
	<yuan.yao@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 09/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 VM/vCPU field access
Thread-Topic: [PATCH v2 09/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX
 VM/vCPU field access
Thread-Index: AQHbKv4rJmj4uQhudE699l4QQqhWyrMIV0IAgAItDQA=
Date: Mon, 6 Jan 2025 18:59:46 +0000
Message-ID: <bd2f6f4e84e15421093f92c5a745bf138d98abf6.camel@intel.com>
References: <710a55a508d4fb3da5aa57667fe03f5b5dd5896f.camel@gmail.com>
In-Reply-To: <710a55a508d4fb3da5aa57667fe03f5b5dd5896f.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8811:EE_
x-ms-office365-filtering-correlation-id: edd27aac-d9d7-4037-6ef0-08dd2e8449ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eTIxSlhKVk1KQkFzYmFTeVk1UldodTgya3ExZUMyQkQyZ0V6N1FxVGdCVEp5?=
 =?utf-8?B?dm1vbUFCL0hQUHZNdkVudnk3TFNzTDUwZzVVcno3Nms1T2xaWWJ1aWs4cU9K?=
 =?utf-8?B?bDkwTERkUkdLYll6ektIM0tBaE9uV3RaRmRacm1sNjNZSU5LVXhISzhWQkJ6?=
 =?utf-8?B?Q0NoL3VRY3BlSUR2dnp1L1J3SHAzSlV4S2ZySHFtVU9nOUVYWHlCK2s3dkpG?=
 =?utf-8?B?Qlc5bVczRUR5RXFuWHFCZEVJM2ZiSFM1TFU4QjRLRXJ2MS9Qc3VWTUdkYzlC?=
 =?utf-8?B?dGorT3d1ancrc2pPdEpBdmNrSzd1SVZBQ0g1YjRHMWdOdUdNVzYrOW1SK2ww?=
 =?utf-8?B?Z0hpc2ZxYVB4bnJsTy8wUXF5TktoTktQbDRQWnMwRGJLZGV5a24zUlFvU1pz?=
 =?utf-8?B?VWlYRmFpUTVFa3hBd0VpdmJoZStwQ2tCaUZSUXRCeEpnNWUzbURyMzFPVDlY?=
 =?utf-8?B?azdoVTI0RWpteTJaS2tuS25WRnY5MUEvVy9TTzdva1Q5b3kxb1hXd1NsUldo?=
 =?utf-8?B?Njl4ZWZwYjlJbEJRa0FucXNtZ1V4Rk13dGdRTkNHWll4QmxRT1JhTTVZaXJE?=
 =?utf-8?B?ZGlDRWRMdGt5N2lNUUlEeDU1bkpjVmxDUVB3Z2szMVdvbit1Rk5YN0h5U0lP?=
 =?utf-8?B?bHRRZHBheXdWMmFnZXV2MFlEMlM2czJwQ0RvbEpSazVJalE5ZXBZNlEyeEVM?=
 =?utf-8?B?RjZ2bjdPUk5ZQnZpRW8vTndvMmdibHRrUDZyZHlhdGNOU1gxNVNERGIzNHdT?=
 =?utf-8?B?Zk1meFRBRDhxMERLYkZZYTFxUkNwYWt3Y0YrdXFqajBFemtXaUtVRGE5ZnJW?=
 =?utf-8?B?TEZZMkZUMVNoS29tczgvM05aeERwYzlRKzFSR2FUeER5VERtdXJtNnlSWGVo?=
 =?utf-8?B?Y1lETHF1Z3RoeGhnd0R3bTViODVsdlphZHJ3dWgyWGp6UFM4QUV5bGk5RnBU?=
 =?utf-8?B?dzdpL05jbGFlcGFnaEpiT1BoQTQyQ1dIREt3UVE5a2JlaVlyVG14TktFN2ZT?=
 =?utf-8?B?RDdFQzBvZlpHeTYyeFZDK0FoSkZ0Yy9SMlRraEQrM0hUWkZXSVJnZ0p5Rm80?=
 =?utf-8?B?VllYaGlJZWxIanc0WjgyQ0tJTTdXR1RwdWJocUR0VUp6Qm8xMmhLOWZjWWVW?=
 =?utf-8?B?a2lNd1FDbDBYWUNDczIxRWZPSTd3RXlORTRZaC9EQ25TY1cvdlphR2RJZ2VS?=
 =?utf-8?B?VkxjcE0vVjdhU2RVR1dEakNLL3JNTVVIeDh1NzFqcVBVc3JnVzBOSFFlN0lE?=
 =?utf-8?B?djd5WHBBMlhvWjc5M1kxbENUbUxrekNWckFwWitGeUpDZlhyNjZTalkrNjNJ?=
 =?utf-8?B?cXFlcFVhVW9OVk5EaTBVbUNOcG5xYmx1U2t5Rm9uT2JERFZlTlR0Q2lSTWdK?=
 =?utf-8?B?NkVJY0xPTENEWmhoVFhGQzZKL1MvazFUNzVUSzE0WkVNTUh6WUdVUU9lZWZk?=
 =?utf-8?B?VTFLc21ETVVnTFc1VGcyc1ppOFh1UmJxMTRFaWJ4NTYzRUFiaWdNWVNhcEpG?=
 =?utf-8?B?WStCWTF2ZnZtdWViKzNNT05HTHFWeWpVMDBMaERHZWVHeEpRa1UxTGhMc3V0?=
 =?utf-8?B?UFQzODdlRkhoYzJ2UVh3ZG40V25YT21Hbk9lOW9mY00ydTZ4Z0RrRzFmRjQ1?=
 =?utf-8?B?dlZ6TDlMY2hSbFhrR2xzM1lkU1E2akxzTnUrckN0RVUrbnNBMXZwUGlOdjZE?=
 =?utf-8?B?eVlmNCt2R0tTWjMrYzhSRDVGRU1PS09adERnNDlMTVpKNEdiNHRpNVJVcFQv?=
 =?utf-8?B?VzRya0d1SlBKUUlZTlN1ekttUDZzTnMzWHhLMFFySlBhS0FNV1A3R1Y2Z2F5?=
 =?utf-8?B?cDU2TnRKWXk0emk3NWxQbmthMDJwNXh5dWJETnpsNHV0OTk5T0d6ZEpCNlRN?=
 =?utf-8?B?elZEV1NTUGgxU0EzMXl5MGYzbS96NFJqWktOZUdKeG4vS0dwZEpBekpGaVAw?=
 =?utf-8?Q?Nl536eBQ8RECzDVymIlzIhxk8zxJsEqf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnVKemtvc2svU3hNQ3VyaFpBNm9TY0d1QVl1TFkwY2lPTi9RV3dLdW53OEtt?=
 =?utf-8?B?M04rMFFlT3B0Qk5ldk9ldGZOdzBBZzAyaldoOFA3aDBmSDEvL3dwYjNPTWdJ?=
 =?utf-8?B?L21DcHhuVXEvNmJwQjVKdEVRTm45Z283VkVTOHpjL1RMMUxGcG01bUd4TEtq?=
 =?utf-8?B?Y2VjckFQeGMwMHVQNlM4RWlWa2ZDdmF4VFJhM3Q3NzV4cEhzdmloZDdPTVpR?=
 =?utf-8?B?cDRWYmRhenlFSS9aVTBwWE5XN0tnNlF3RkIzMTMzZmplSk5vckVTZ3J3YS9w?=
 =?utf-8?B?RG4xVklPZFFEQ0M0ai9Cb3BnT2NXNEhiYXFBU09CN3c0cE1IZnJNV01SUFFp?=
 =?utf-8?B?eWNMNjhiUTdRaWRmblMybXUwRlpyb2pVbGtkRFpNMlprNURmVmVJVGJWKzN2?=
 =?utf-8?B?UHVqZmRraDZCVWxqazJxMC91b1BVaWFCTTRPSFByT2o3VkdiVVVEbkpEWWVM?=
 =?utf-8?B?b29YMGpkZXI5VWZ2aUY3d1FSL0MrS2ExZkNCTkRhdGFmSTFkZkZRWmUvbVlR?=
 =?utf-8?B?YmpLZDlvNmJXWm1RTXI1TllnckthTGpoMU44dTh1VUUzRGw2bFR1d1V3WVNH?=
 =?utf-8?B?RVRqTlpibXVHazMwc3JtQkZaNGt6NlV4cS9zM2ptbGxEb1pxYzJCWnVGU0Zl?=
 =?utf-8?B?RWFuZUFVc0xrTEtZNW8zRFhJMUl6SzVqUGF6V1YyQVJQTVZ3VERHVzFzQk5I?=
 =?utf-8?B?SlA3S2hhRExZREJFR3UrSUJ6eUFReFNPdG92UStucC81dkhlVWZnTEF2NDYr?=
 =?utf-8?B?L1UyT3VrWVZXTmtVK1pURGozREw3V3ZlalBNc3dPQXBqL2hzWm53SnhSRXU2?=
 =?utf-8?B?UERtNGRkYmxLVkpXRy9xQ1E0cVZTcjF3NHFlRU9KU1RmeW1kQ3FaMVc3dU5p?=
 =?utf-8?B?YXN3KzIza1pEL0NRY0FBbEwvSGZiS04xcWlUMkY1TXg4end6NmdTUVlDQjBn?=
 =?utf-8?B?NWdveUI0MUpRRXEwZWFmcTZPc1grbWEvUkhWNExDT25GbDg3Um42dStHSlU3?=
 =?utf-8?B?ZVJ5Yzh6Z3dZWEJhazZod3ViZ01NaGRQaS9TWW5YYkVjOFdpU0hRL05OZGtL?=
 =?utf-8?B?S21XZEkyTThROTZySENMN3hJQXhpWVROdmpTMU1FR2x0cytFeDlONzNPS1RL?=
 =?utf-8?B?SU9URDdHQVY2Sk50YUptRzd2T2kxN2VKZEx6d2VQTVhWOXZ1MU05MGJxOHJZ?=
 =?utf-8?B?M0JNMHQ0cEsxZzRqSjBSYzdwSGdac2xybCsyWHRTL0paRjVDenlQVmxlWTZw?=
 =?utf-8?B?Yk9KSy96clpEdW1wZWZNcHZZYytoeEphM2JQV0hJQXhXOFAzZzdqSTE1WmFi?=
 =?utf-8?B?RXlnL3E4YnlOclo2QWJDOW9KUW55eThhTXBKOTZyV3hzMzlKZHFWNktqaTJK?=
 =?utf-8?B?Ri9lSjB5WGpTeFhzOUZqV0doVjhNSWNYNzc5S1cxcTJVYmNtdUdVaEpoMTFT?=
 =?utf-8?B?YVBqeDhvVUN4THB3d08rQ3BRVUZKUHIxTnA2NUhYd0w3U0QzN0NJaWlnT1pN?=
 =?utf-8?B?VmlqRzhRWW9BTnk4NEt2UElnV3FscjVQQ1BVeGxOWm5pNmNzYlRGWUpuNjhr?=
 =?utf-8?B?N3lqbFF5REtkcnZOc3ZIQjVQanZjL2xkd0J5b21BWkljR01sUmhUZElOSk1W?=
 =?utf-8?B?SWFlbi9sU2lQQkVQYTlBQ0hzRUYyd0lIdkdWQXRSRmpwdUxxT3ZBdlRGNE0v?=
 =?utf-8?B?ZlVHR2JQazJQWjVKbGZ2ZlV1aWpuN29BVk5YNjVudC8vOU0xRWFIMXhkU0FQ?=
 =?utf-8?B?eEc2ZVVRdGZxYW5jOXBnWUtCaEpYaFVGWFcwVzVaa3cwQ2FPZmhjRlJteVRL?=
 =?utf-8?B?RWNZc0U2Smh4MEs4V0RVSXdJeWJkYllZeGFrRittZUtTa01rRitUSmhXV3BP?=
 =?utf-8?B?SzhRTFdNSlAxRVl0Z3dnTmtrc1NmbFFyYmhhN0poNE1BaWx5d0xycktQU05p?=
 =?utf-8?B?U1hnMFcwa3d0djM0T0NQODBsK0RWRkgvdjljWjRrdVc5WnlPVzNMWURJdkhN?=
 =?utf-8?B?bk5HSGZMS1Y4YU11eUk2WXBET1k1WWRKL0pxaUo3TVNJdDF4V2k1ZzVxaEtE?=
 =?utf-8?B?eDBpazJUb29OTXBqZjcwODJPUHk0KzFQd084ODFGUjNnZHdadnVaWTdXcXcx?=
 =?utf-8?B?cytIQ0dpTTdHR1J3VTU1Q3QvTDUvNU1QZDc4dGlGak9EbW1FMnovR2ltUDJS?=
 =?utf-8?B?d3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4BAD2C0100ABD4FA2B0401079C1CA10@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edd27aac-d9d7-4037-6ef0-08dd2e8449ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2025 18:59:46.2828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DS41i34UMSaLrsQ0Tt2ydeZpMsJ0Z99tREBM8KQEWRbb7Mi/6SgqwwcTyzhTVypSeLsN6R0KLoVFNpK5HHHcnut2cpwTLWktZ6fVAy6ErbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8811
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI1LTAxLTA1IGF0IDEwOjQ1ICswMTAwLCBGcmFuY2VzY28gTGF2cmEgd3JvdGU6
DQo+ID4gTWFrZSB0ZGhfbW5nX3JkKCkgdXNlIE1ORy5WUC5SRCB0byByZWFkIHRoZSBURCBzY29w
ZWQgbWV0YWRhdGEuDQo+IA0KPiBzL01ORy5WUC5SRC9UREguTU5HLlJELw0KDQpPb3BzLCB5ZXAu
IFRoYW5rcy4NCg==

