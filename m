Return-Path: <kvm+bounces-25405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21CE896503C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 21:56:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE75128B050
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC321BE225;
	Thu, 29 Aug 2024 19:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HlwsWN5T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5351B86F2;
	Thu, 29 Aug 2024 19:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724960810; cv=fail; b=o4IPyZpUive0EUPG5iD4/PyTGWAHx82QHxAOnlgXq8NxCFrEB7E4alvsYJFT5Pbx5a+c4jgoAKVCKRieLdq5xvr0jagkipfyLk66+ntZmY5Yys+JZKH3qJbmggTzZE2Hcv9/e6G/fWbI+xaiXZkvcEg1PbUIdh00/mf87rbFo3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724960810; c=relaxed/simple;
	bh=6rMJC56p8NyBGtHYvgd7PJ0AYgZ6QdS229MshAluvfc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t/p11brEA0HhHvr5sMsyaoKvYxBTbgJggSFwLkX+ZFA0toVM0nIaRn9xRvW6mu0QORGHU5XY0ZQEemLSgp4qrC4YSoyP7EOQrywUQSyt50vW2CNSARXJj2gh1t5fXPdI7c5vZ+HPAp1SD7CpiDDZwpDkNTBAvR7hCjO2+k4dGcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HlwsWN5T; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724960809; x=1756496809;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6rMJC56p8NyBGtHYvgd7PJ0AYgZ6QdS229MshAluvfc=;
  b=HlwsWN5TFCTf61uerLhSeg7H64C2DOGEWVbJ08pH8VcMLYitnlSxO3/W
   xr8N2ieyp92pQ3OYgoeK1IjoqcnHQbEOnmkUVtU8rXEsPlXlIkAOY0Aho
   UwQZUjcpToXwhztlqcH4YgXaaKT4SCVo2fAkod3cwzpWfl6yMz5RvpkrB
   JLPBbnP/GM3TkKrlUpQkDQyhxsZG5whT8ENBg5vzj9uznj+Qof01z5q0n
   i/q4Ba64Zyy8OywPGdEt9+Jg0nTWnActSXoj+ZKvHo2FzJF/9TGYoIxB7
   rZmy+4EPw+sD2AeHVJVAumevn7pU0MMx3JdQn16pH2MyW9k3jdGLcToGs
   w==;
X-CSE-ConnectionGUID: l1csiIONSsKj2dKttxUsHw==
X-CSE-MsgGUID: 0JZNqwl6T7iKLdQfXqtrcA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="27374747"
X-IronPort-AV: E=Sophos;i="6.10,186,1719903600"; 
   d="scan'208";a="27374747"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 12:46:48 -0700
X-CSE-ConnectionGUID: 9sENTy01Smu/DgkdPphmLw==
X-CSE-MsgGUID: VdHEHTC6So2xMPEI8caktQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,186,1719903600"; 
   d="scan'208";a="101200110"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 12:46:48 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 12:46:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 12:46:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 12:46:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZvNz3jpOBhrXfRcj5+22PYP3hcaoZtQOawF2iNiwDuD7pHuROYpCRYnGFZxY6SFO+M93CXMa5CkZDGhM0jBhgrqAX+te/nPVXFdv4X7M14suP6pnk9dnvWxqsh42vCfKfEwdbKd/IdPrhkFOxWrdY4blq7nZ3PC6Zl87ZVlP/odEb8XvN+E2JZ2eclu0QlXyLCYjPd7hUrniQJugSiRtKeslqSjUORCv8AVdL8nkPwvueHROcIgm13zmhhD1sWgLHcoGRDKRMclFYRIQczbY0B5ko30FiZ1xJSgIFE85RKDET9noqh1sQjoTlp0F6OFrfkvSSQGmwD2o7RDwCove+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6rMJC56p8NyBGtHYvgd7PJ0AYgZ6QdS229MshAluvfc=;
 b=OwJQLLewWnPHB5bgp6j+ELSSwlNNpPKMuRSu2F9ibryTFme+nrUKf9U4UBaa6FGv52c0sj/MWrxitqA61Otbhy5qpFdP6k292dVvSft3/yQEPwVy0rQnjBecnIX+iuA0Uy1uArvhdHmjBuNZZ3MGpY5t1q9mMVnYkCXa328bye5lfTcjgREw79+8WHK6TlHVO1vDOjo9Uzu/TZoPZYFlQpYuqpEuLSkv03Dzn7bHyfEWJTW8WGey4O1W3C8zw/Ztxt96vFrfozqB8ea29/dj/j9/a5aCvrxxTUqE787eUpxBMuSc5efgcb7LdU/djey7juBHYikbyPDmBf/yfDliMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB7991.namprd11.prod.outlook.com (2603:10b6:510:25a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Thu, 29 Aug
 2024 19:46:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 19:46:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/25] KVM: TDX: Define TDX architectural definitions
Thread-Topic: [PATCH 02/25] KVM: TDX: Define TDX architectural definitions
Thread-Index: AQHa7QnPgwNd+/nY60OEkk3r0AFwhLI+U6uAgABqZYA=
Date: Thu, 29 Aug 2024 19:46:00 +0000
Message-ID: <4de6d1fa5f72274af51d063dc17726625de535ac.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-3-rick.p.edgecombe@intel.com>
	 <4eb4a26e-ebad-478e-9635-93f7fbed103b@intel.com>
In-Reply-To: <4eb4a26e-ebad-478e-9635-93f7fbed103b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB7991:EE_
x-ms-office365-filtering-correlation-id: a931b76b-eeea-4828-f086-08dcc86335a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VFVvUHB4d2Y0L3NFRFR1Q2Nma0Jka2JOQ2hOcmVrbXJGc3pGcFMxR2RlU0Rt?=
 =?utf-8?B?TDhOT3EzYVY4M21CR01hQ25wU0tDTCtvS05WK2hPQkJudmt0RFM1d0RDZE1w?=
 =?utf-8?B?cHhUS3JyMFFRS3hsMTVDbkQrb2Q1OHpSSHE2Nm9mc3BVdk9YTmoxRytUSWhW?=
 =?utf-8?B?ak5rNVBQdlV6VVNUbjFncnkxTVZydi9zSjR4OEEvb0crN0Vjb1piL3krSmtv?=
 =?utf-8?B?K1FNdTlUZFBCZTN6Mk9Mb0trUXFNTUdBUjhBUHZheFFnYzQxRkVTRFkzNk5i?=
 =?utf-8?B?cHpUeVZ0YVRabVVjN0x6SmlCRm0yaEI2YU9Fb2xySUVMbDRucmswY2lZa3pu?=
 =?utf-8?B?UHVhcjRibTN1djNpNmY1eStKZnd5V3RyU2Y4YUZrV2wxRWcrL2hnVHpLN3pz?=
 =?utf-8?B?T0hFNjlOTUtvS2JDQ0kyNHljZElqMnpQLytwVzgyZURlQnFoYVhYSm5wZCtP?=
 =?utf-8?B?Y0xSVW4yRVZvcnBYb2xNblZzeWNwZGtxejZvc3F6V3pTWHVvMEN3VFFoZkZW?=
 =?utf-8?B?MWhTNUNGU1BTVlBEbGloVUxmd2VBWW94MGdHZjBwRUZaN3FoTmdOMy9PYVlt?=
 =?utf-8?B?UW1reVUwbGh1ZU5mK0Y5dEpsd3M4b1l0RlBWQWNnWE8wejFxTVFMcS9ONUlX?=
 =?utf-8?B?OWtCYUs2cjY3aDFDSTVyY2FJT2xpdmhSN05ZQ0VHRytoZVRTdzY4cUo5UCtP?=
 =?utf-8?B?elV0ZG1uZ1NUNTcyWUVTbUFScHZIamEzaFkwRjhKL2xCMkpFSTdzdHczdGlJ?=
 =?utf-8?B?SUgrZUF2aVFOeEE3NEwzMmNJUkdsRWxGS0pCN01zWkhJcXNUd2NMWkxNaVEv?=
 =?utf-8?B?M3J5Nllpb0hIeWRzczd2VlIrVXZWK1c3SFpSOC9jWEV6QlEra3pJbm41ZVkr?=
 =?utf-8?B?Q1lmZkVGbDJPWFV2a3drbjZoanBpbDkyOXhwdGEyU1dKQ1ZXaGdqZWZCM3Vo?=
 =?utf-8?B?Zk4ybUhoUDFUS2FjRFFLUUNBZktoelhvSlR2c2hsdXdqQldrMCttQ3l5Tis0?=
 =?utf-8?B?bVlHd2ZwaTd5MFo2MkFpeDJ2S3NNbzlMcEc3S3pNNlgyN29SUzA5NWZZSFlm?=
 =?utf-8?B?TUxNVmNqckkvc1g0VDRibWVXcU5EL0p5VXR1SUtES21pbGwreWFvYVNYdW9O?=
 =?utf-8?B?L1oyaEVOdTA4QThxQTV5TnRaVFNCM2JQUzkvdWtJQ2QrRlAya3d1eE9BS1Ey?=
 =?utf-8?B?UDd5VUdmK2E1L0s2THFJaERUV3R0ZUtwVitiZVBhd2dublRjVkVmM0hjdEZR?=
 =?utf-8?B?dHVucmlqK1I5Z2REdlRnWFhEWERMNThBMmtpTi9OMHJ5ME4rY2F3OVBzSmdM?=
 =?utf-8?B?TE5KOVRxM0F2SEt6WDB0RDNyZGRTT3FJdm1WQWEvREU0N29KNTA3eHJTSy9h?=
 =?utf-8?B?Vkp3d2Z0dnBtNWFma1BEb2dmcGsxRlY3bVdEckZmZmtNUkZXRDFmMkwxQjha?=
 =?utf-8?B?NnZXTUFDNE9DZ2t1MmMrQXp6M010eWtyMllCazBCOUxOQnpzdkJaZXorTk1Q?=
 =?utf-8?B?amhaUVh0cHkrVG9lZDZQTEhaSGN2N01ydFdnM1NmdC9RUCswUTFmVGRzMUxB?=
 =?utf-8?B?OCs4Z1oyTjBxK0NuVWtOdUpKbWlTNGFwdlhvdUxjK2t2RVBDTVd5eG1GM1lQ?=
 =?utf-8?B?REcwUUpIUzhRMjgzbVNWc3ZrclQ1SE5LLzdYL2lGYURQYzJ3ZktqSmQvV09n?=
 =?utf-8?B?Ui9RbXFGS0E5ZitWQ3kxTEVoSDZ3MjM5V1pONkNITjh2UjIvZ2dHU01OdEZK?=
 =?utf-8?B?dkp4UEZGaFc3d1lOeXpJOG56bjBsaGJHUHNtUVBIb0YrRWdVZDNwWUs3d1c2?=
 =?utf-8?B?SWUySUlCODlDZWtHOFhnVlI5K1JLdEtvV2V3OHNvSmlZRkNnSVZDYkMvZFVo?=
 =?utf-8?B?TDlUbWpidi85NUNBQ1hTSXRKYjYwTEIrNG5NWk02a2JEZHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UUJZMkJveGdjYloxWThRVlJtZ3dmWUxMRzVZVWF0dzVoSjFRSndQQm4rcDRk?=
 =?utf-8?B?WGNITmpIWFk4cXNONkJQUHVXOUNCMjN2am04SUYwWHFidW5hOFAxaDAzVk1t?=
 =?utf-8?B?c0l0VkhmYVRCVXlBOEw5MUM3WCtMRTBZVFRZQ0lnOG5BaVNCZ0ZRUnQzemF2?=
 =?utf-8?B?Mzh2M1orcEN5dm1Td24vLzVNd2NSNnpTamQxNkk1S2NmRHgwdVNBdTAxRnpm?=
 =?utf-8?B?M25YWkl6aEMzaEoxaTdIUG9RMEdXYk9veVZta21DdklsV0pJRWVaVXd6OWlw?=
 =?utf-8?B?a3lIMjBOTmJrY3lreHVLNVlPSVdhRHRhQTdFZnpuZmtnV0tqMHR3RW40MVNq?=
 =?utf-8?B?T3ladTdrRFpPSlJneGgvV0FHODJWZ3ZGLzA2ZW1GN0ROUjlMaHR4VEI0Qmpi?=
 =?utf-8?B?dGh2N0hmMUhmdDYxWnJ6QU5jdEZaOEZWQUhHSnhBMlJDa3RYN0ZqVktkNGlt?=
 =?utf-8?B?VGxYdHllbDRjSHFOZS90NEVLSEFKcmd3SEhOVWRTN2ZKYkg4NW1TOTZEdGpw?=
 =?utf-8?B?NFUxSlBYeEVOSGFpTWJCcGxzNEJPOEttc3JkNjhaVktWOFRlUkhjZU9pMVlN?=
 =?utf-8?B?d0JSMld2Y0lad0dDMUdKamJUM2ZiajVYTHZ3YUJEN1JsOFBFK1BnRit2NVNq?=
 =?utf-8?B?ajdyWWZqeDFvVDFZYm9pY25qdFlhMXhnQVNabkNpc2Q5MGI5TWhWL0VIb1h4?=
 =?utf-8?B?UzE2V3dyUHQ4dkxqaGtjMXQrZExLZ05wNVdqRmpSYUZTMUcwNlRVY0FKUlNz?=
 =?utf-8?B?RkFFTEU2VXY0UWROQ0ovWStlak5NVnF2TVdhRDExTmt6WVN4U1JRc1AwT3Vm?=
 =?utf-8?B?RnVZN0FhNUJpSUo5bEQ3TlNhL0VQT29YcGN1VVdCMHg0aUw1RnhqRnI2bHU4?=
 =?utf-8?B?RXR6VUM1ektFTHBIRVkyVERWUUhwa3R4aDJ6dVlScktMQmZzSTY4SkxtRXlE?=
 =?utf-8?B?Nm9ORWlMZmdtNzlSWGVNdTU2NW1YQ213TSszaDI4am55OUlyRFRTa3pibFNm?=
 =?utf-8?B?L2pYbS9Pc0RFNS9pNVhFTmVRSU0yb3BIYnRHZUY5WC9UUDMwbFpRZXl1Rnor?=
 =?utf-8?B?ME9hbUxXNkdwZUhKVnYzSDJJcmE3TWNHbFYvTGZZeWFDTmMxaUhlS2c0VWM3?=
 =?utf-8?B?Tk9haUIxOEI2K05YZWtsNDJKSlJuTWlJamxuLzRYbG5CbGU3ZDNWWlFqdlZp?=
 =?utf-8?B?dmdJSnI4aUozZlFsdktyUm9VZllpc1ZYRXBKcFZMUzg0VGlMM0xQNFpOckl4?=
 =?utf-8?B?UnI3Ym5aV3BPcHQrRW5XRy94dHp0SWpzMU5zOFVEN2RBNDZ3RzhzdlREMEtM?=
 =?utf-8?B?RGYzTENNMERoZEJldEJwU2l4TzlkOC8yOUxObXVjWmt5UXk5NURZRlJXRnRv?=
 =?utf-8?B?aTVMcEl0V1RnNFk3WmV5RFVBV0dxZWFBME8ra294Vkl1V1V3RXJidHJZQUhx?=
 =?utf-8?B?UXc0Z1g2Vk9FSTBNcXlSSUptTjlRaUVLSzY3ZHRIMWxyQjB3b2k1OWNJaEl1?=
 =?utf-8?B?cGVHN0pxbXQ1Q3JpQlpiNjFpQXNPT0wrZnhURU41cWxMdGd3b0ZoeFh6QjY4?=
 =?utf-8?B?R0lPVlVWN2JkKzRPVGk2N3kwZE1XZ01RTjJPMnBmSzhEZmh2cEJQYjVnVXYr?=
 =?utf-8?B?Nks5OGc1blB2clpVTjRvQmU4dnMvc290MVBUeDBLT3NhZ0hnanZKUjZoM21T?=
 =?utf-8?B?dkRKY3F0UDdWS1gxaXhaM28zcktRQWo0UWM0amZUd1gvanZPY0V0MWV5UVRu?=
 =?utf-8?B?YkovSjMwQkFvZDFrU204WFVnSC9aSTRTYjQ0VlZoTGQzV1phMlgzUS80UFU2?=
 =?utf-8?B?cGtIdUxhT1FheXExNjl0LzQ0bkxmNmFwcXFmWXJ3d2ZIVHV6c1g1SitKdHRm?=
 =?utf-8?B?QUUwNWExWXdPWC9VNWJSbkpYYXo1aHdtQTBYUCtERjIxYnVxSUlWY0VzMEdq?=
 =?utf-8?B?QjJkb2NDbjVxRncwK3QxNE5FU2dLOWtHa0I2aGwrU2V5VHd3Qm5jQU1oSjdq?=
 =?utf-8?B?ZTltZC9MMk5hcm02am9POHBZTHRUTEdGYlZsK1lGQVBpN1ptWUlOMmt3YkJE?=
 =?utf-8?B?R092SElRY3kxZXVoczdDMVJETVJzZC9qSm5CR0lhRUZUYVNVSm1ST0RmdUFK?=
 =?utf-8?B?ZyszZzYyeEVFSXBGREc2cjR6WG1mMWwwVzhwS3BXWUpXU0lSdG1jVlJKZVQx?=
 =?utf-8?B?bWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD313FECBA0E1C429B935D38CC805786@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a931b76b-eeea-4828-f086-08dcc86335a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2024 19:46:00.6155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ZiAAZ88WY8PzYBxxf7LwYxfHVnsyC1d1WnJeE84SXg3uVb0+U+inDkajyaXQuqea0BGC/T8J74m7EiUnykdUr6YuROIrR/PTiUa+WnTu48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7991
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA4LTI5IGF0IDIxOjI1ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBP
biA4LzEzLzIwMjQgNjo0NyBBTSwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4gKy8qDQo+ID4g
KyAqIFREX1BBUkFNUyBpcyBwcm92aWRlZCBhcyBhbiBpbnB1dCB0byBUREhfTU5HX0lOSVQsIHRo
ZSBzaXplIG9mIHdoaWNoIGlzDQo+ID4gMTAyNEIuDQo+ID4gKyAqLw0KPiA+ICtzdHJ1Y3QgdGRf
cGFyYW1zIHsNCj4gPiArwqDCoMKgwqDCoMKgwqB1NjQgYXR0cmlidXRlczsNCj4gPiArwqDCoMKg
wqDCoMKgwqB1NjQgeGZhbTsNCj4gPiArwqDCoMKgwqDCoMKgwqB1MTYgbWF4X3ZjcHVzOw0KPiA+
ICvCoMKgwqDCoMKgwqDCoHU4IHJlc2VydmVkMFs2XTsNCj4gPiArDQo+ID4gK8KgwqDCoMKgwqDC
oMKgdTY0IGVwdHBfY29udHJvbHM7DQo+ID4gK8KgwqDCoMKgwqDCoMKgdTY0IGV4ZWNfY29udHJv
bHM7DQo+IA0KPiBURFggMS41IHJlbmFtZXMgJ2V4ZWNfY29udHJvbHMnIHRvICdjb25maWdfZmxh
Z3MnLCBtYXliZSB3ZSBuZWVkIHVwZGF0ZSANCj4gaXQgdG8gbWF0Y2ggVERYIDEuNSBzaW5jZSB0
aGUgbWluaW11bSBzdXBwb3J0ZWQgVERYIG1vZHVsZSBvZiBsaW51eCANCj4gc3RhcnRzIGZyb20g
MS41Lg0KDQpBZ3JlZWQuDQoNCj4gDQo+IEJlc2lkZXMsIFREWCAxLjUgZGVmaW5lcyBtb3JlIGZp
ZWxkcyB0aGF0IHdhcyByZXNlcnZlZCBpbiBURFggMS4wLCBidXQgDQo+IG1vc3Qgb2YgdGhlbSBh
cmUgbm90IHVzZWQgYnkgY3VycmVudCBURFggZW5hYmxpbmcgcGF0Y2hlcy4gSWYgd2UgdXBkYXRl
IA0KPiBURF9QQVJBTVMgdG8gbWF0Y2ggd2l0aCBURFggMS41LCBzaG91bGQgd2UgYWRkIHRoZW0g
YXMgd2VsbD8NCg0KWW91IG1lYW4gY29uZmlnX2ZsYWdzIG9yIHN1cHBvcnRlZCAiZmVhdHVyZXMw
Ij8gRm9yIGNvbmZpZ19mbGFncywgaXQgc2VlbXMganVzdA0Kb25lIGlzIG1pc3NpbmcuIEkgZG9u
J3QgdGhpbmsgd2UgbmVlZCB0byBhZGQgaXQuDQoNCj4gDQo+IFRoaXMgbGVhZHMgdG8gYW5vdGhl
ciB0b3BpYyB0aGF0IGRlZmluaW5nIGFsbCB0aGUgVERYIHN0cnVjdHVyZSBpbiB0aGlzIA0KPiBw
YXRjaCBzZWVtcyB1bmZyaWVuZGx5IGZvciByZXZpZXcuIEl0IHNlZW1zIGJldHRlciB0byBwdXQg
dGhlIA0KPiBpbnRyb2R1Y3Rpb24gb2YgZGVmaW5pdGlvbiBhbmQgaXRzIHVzZXIgaW4gYSBzaW5n
bGUgcGF0Y2guDQoNClllYS4NCg==

