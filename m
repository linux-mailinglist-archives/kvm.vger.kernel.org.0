Return-Path: <kvm+bounces-33700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B8E29F05CB
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB5F2283F95
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957FF199FBA;
	Fri, 13 Dec 2024 07:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dhTXO53g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECE31F95E
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 07:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734076365; cv=fail; b=Av3CvqdCx7PerLl2GwnrW80USy6Y3EUf2u4W2TUZgowQlWq25kIETXyHCWoX7fvV7jfBCuPasn80hQWPH72UcjttjqEFRePWk1OetY4D0c1kr2mqxYdf/Xb/P1HbIh+63+RCXh79xsMvKrHPZrljw35UOiZPVG2ZgQWE3duyI8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734076365; c=relaxed/simple;
	bh=TphHxo6yLiIOHjjOwQtNS56J98/+4TmgvX5Z4yPIoUE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VyENJz5gRG3MJmA+TPgKfbvN2GAQieOQF7KooGt5iIN9tR+eqdT2QfYXNytHmjsfDMDobf6kNwYjmMvPB5TG8AUhEf9aqU3MckO/L9sTHhxOhsNVQm2dJb97DQcdmqcRLbdXaARonP9IOjQMB75G5V3amkEQdKa/y8lN2pDE5yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dhTXO53g; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734076363; x=1765612363;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TphHxo6yLiIOHjjOwQtNS56J98/+4TmgvX5Z4yPIoUE=;
  b=dhTXO53gbjg6YstFBE5gwHFpluBcyf/MQyizOyckgVu6TDEmq0nX2QSV
   ZboyCQdrES0zB830gVmtQh/N7mI7wDc49BnlDYcMIAIKdRNIUYsMLc2Xm
   hQpu5j3gk/HNrYPUritkIjT75HzujdupS+oOyzeShmmnqqkqD5ctuwFCe
   jYinZJR8tBUGAtfqT2GdxbtzB6hNQBPzJ09tF4Z90JwHxJM45CVDiXdUm
   y+7shtq0gEl94FcurgFSGK2uHlDWEyREiB0pOyXEFw2mOHyakBse7XVmx
   3+TBER8OAqbNcniv/zWNDlDJ/5to5e/evqBO2FNLTLVrQbjbB8WEjD4Q1
   Q==;
X-CSE-ConnectionGUID: AbFYjt1VRJ+GrmfxSzgiSQ==
X-CSE-MsgGUID: /lM5uU1SR+eiQvMd9L2Gtg==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="33822675"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="33822675"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:52:43 -0800
X-CSE-ConnectionGUID: 0OhBEb2eRGG23ptHWV77EQ==
X-CSE-MsgGUID: MSW7a1XLS6edVb0FimIVQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="101319709"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Dec 2024 23:52:42 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 12 Dec 2024 23:52:42 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 12 Dec 2024 23:52:42 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 12 Dec 2024 23:52:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ebidhf5sR/Wi1zDX/MS5AayRffIoJPOcI21vfNVN12Wzqp6qJpLJ2Td5KhCrbCYLTtGzhZeeilY4Qn1AjaHl01db1NKQgwaAlYaDomLbc28xpQ1Q7FAkiWp0CE44TPjCynFMsJMGpn9k3AhJclEJhehvu6+1r97PRF7SkD4qfNvGBIHOXyA/1eEuQjWuSxu+bt7mDjxTbSuee7iZv+tR5VAmiuwkDJxJrgGfUnjAYvP9faZZi1lay6AIFQPJxkb7hjx/tceRDN7XTrB8xV9k6+6jgEbUwIcXgOE1o47/uCxHPcEmiFmKFswQR8gEwMHH1Tq2wvvgHo+n4vX4BbbWDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TphHxo6yLiIOHjjOwQtNS56J98/+4TmgvX5Z4yPIoUE=;
 b=DIS1fqdJzIfTPpXmY3/PpeRoFzLoumjevAgKfLDW+TaKwnpBossSX9wemp4AUcxLYnYoMzyo5cgJ2VkYiKnfe1nOvgvCuuLQCnJis+Q0PCDfXkQyKksY7GT/9LLx9mdHRfJstBW63gXjPLXaGNPQOnh4yB6AiATgxDtWNmPL12FfGko3YW8HPOCkoX9srZofSZdLvFJLQT0M9gijWugbFPFt1mgI2M893LTCQcIJqHXuOE9J3MDUS+EN7msC4/N7sJNt+lU+zy2A2SvOqp/edNRIayP0c29zYjA8lYoefQKivyBCpioqxMuFwHSfwj/i72BRUo77ixb22+dQ63zmrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB7581.namprd11.prod.outlook.com (2603:10b6:806:31b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Fri, 13 Dec
 2024 07:52:40 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8251.008; Fri, 13 Dec 2024
 07:52:40 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
Subject: RE: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Thread-Topic: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Thread-Index: AQHbLr0MyG3oX7KdYkCnpIbZw3bHE7LZC5CAgACnwQCAARp4AIADagUAgADOLICAAe0wYIABN4YAgAAqgnCAABfyAIABQn8AgABRs4CAAAYGcA==
Date: Fri, 13 Dec 2024 07:52:40 +0000
Message-ID: <BN9PR11MB5276655399B4523F4CEEA63D8C382@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
 <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
 <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
 <BN9PR11MB5276E01F29F76F38BE4909828C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c91ea47c-ca71-4b37-b66c-821c92e3d191@intel.com>
In-Reply-To: <c91ea47c-ca71-4b37-b66c-821c92e3d191@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB7581:EE_
x-ms-office365-filtering-correlation-id: cccd1d40-e04e-49cc-3b37-08dd1b4b1e51
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZW50SHg1SVRad2s1THA2dEdHUHpNRXVpR2hGMnJmV2w0Z2RMdFdPNXVvSDVB?=
 =?utf-8?B?cXNFQ1VPdk9Bd0VYV203dzZRTm1SOE5WQ2NVWkdLNTdkWld1VzRabE5aQldm?=
 =?utf-8?B?NFhKVXMzejZpckU2Rk5ibWJCYXV6SUxielVOb2ZWalFMdndaZWJ0eXNoVDFq?=
 =?utf-8?B?UEpteE1nZlhtUFI5dGxSQkg3UlBLVzhkQUdWZW9ta3ZMVHhKZUhCdmxZbkZL?=
 =?utf-8?B?eHRDaVFRV05xRkJDVVNiWXFraXgxc2h4NERaYngvcE9RdkpXdXJHTm1LQVo3?=
 =?utf-8?B?ZlQwbGRKVWREUmZ0TXhBOTRKQUV2OC8vRkNHQjJwUXUyNFprcjRSaWFaQ1R5?=
 =?utf-8?B?QTJvOG9kVCsyNjBRR3ZoTVZIQWFTTDlmY0JBSUE1MndZaXpPaHF1RHZoS1g1?=
 =?utf-8?B?Wm81SWEyNmg0YjZNazJYQnVONDVBK3pFNWVtNzJOUEI4bmt6Wm1TWUhiZElW?=
 =?utf-8?B?d3ZCam1JYUNFeExIZStXZkNVWXA4NzI0S2tRbkpGY2dUTDA2cVV4MEpkb1VX?=
 =?utf-8?B?VEdBUm9MMjhpL3hqU1RmUXdVUUZ6NGxWSDc2S3ZUMzcxMmdPWmh3OXg2YmJk?=
 =?utf-8?B?b3FxUGN1eWhpNWRtV3J4V01CYWRrWVBGR09UeWJ6UmpyNXVYN1ZVWm54MEVO?=
 =?utf-8?B?MzVWZnFxYUpjYnpMcnZXVDdEM1dSdnJ2RS9MNzBWNC9QNWNyZ1A5VjAvSTlm?=
 =?utf-8?B?ZmhYZW1KdlF3WDVldm0wUnRnbGkzLzdRT1BicVFlV3pRNW5SYUxXenNjZmlJ?=
 =?utf-8?B?T2ZkYXI3T1Q0N2gvOFp2SlJBYVBOdDVsRUhMcFBCU3VQaVVIMDE5ZHJGRUZZ?=
 =?utf-8?B?Y0RrTUN0U1B1bU9KcE8raXBqV0xCVkdLT0ljMHRXTVNSMDV4VTVkSWJ6b1Nr?=
 =?utf-8?B?RXNacTIzUXV0bzNoQTRraC9rMHV1TXVyQ1JHVGlpL28vZE1ReTBJejZreTg4?=
 =?utf-8?B?N1RpYWlVdmRhdWpyclpnRzA5eWRUdmNKYkxaSkxnY2I4MDBxcjBTOFVncDhU?=
 =?utf-8?B?RGRLcWZyTFdPc3BRSWlRcHJZNFc3WjEybElzcXc3dHYxa1dOZnRUcy9CSWFx?=
 =?utf-8?B?OXdIVisyeFJLWjByUUkyY0tsLzBCWk1kUFdLdVRhNXZEZXRUMVdLV2pvSndC?=
 =?utf-8?B?dkphZFFEZ251UzQ5VE9uMTVFdUtYTWNOZjZQbTVsT3RtS3NGMFN4V0JWL2RC?=
 =?utf-8?B?UklMNFBpOU01OXZZaEtpYnI3VDlBQWJSTVZNbitwdEphajZ5TURYUUVaZEZk?=
 =?utf-8?B?ckl5VmVlSEg1NHlyeTM2SEJUZXZaYkRZU29jMGg5SkVMY2hVaXNhRnp0emMr?=
 =?utf-8?B?SzZXNUlOWWcvcFZxa3RlS2s5NVVYd2FaK2hXVjl5YU9MTnI4M3pTdXdlZWhi?=
 =?utf-8?B?U3VsVkxnaEFsb3NENGRDT0FEc3l1Vm9KVVEvMXlQandGbTYrZGg0WEtQWE9W?=
 =?utf-8?B?RW5LdHpheFNHSmFIWS9lU1hRai92UHR1dWVkQ1BHaFdJUHA4Y2ZLWURXZDhI?=
 =?utf-8?B?NGRteVlzeWRudDh4TDB2NDVkdFZjaU1JemNnUDlHaHFnWVdwaVNyNkJpUHFH?=
 =?utf-8?B?ZEJNYVJEb0d0QnhWZ0xRSER4dk4rSjJ4OVd1aUp5cDhHSjBpdEg5TmtuWWpP?=
 =?utf-8?B?d0lWdjUzVVczam5KcFBxeHJpdjRIR0p4RHZKdVJPeWVRRVk0YjZpV0Z4TmpM?=
 =?utf-8?B?VUhTeEtHZy9kOTNSV094SDhJUzdhbll5OGtsTDZHcCsrOEQ2c285ejJ6NC8x?=
 =?utf-8?B?WFlUMDFuc0p5RmdCWVVNM2IzRko3KzNwY012cm5QbGdZVXpFdW10ZC80dGZJ?=
 =?utf-8?B?b1dmbXdMTFB2M0I5QjJyeC9UMUNrbWZxektWaEhXNnVZSDU3dnl2ZktBTnE2?=
 =?utf-8?B?LzBZRnNTRGg2cW15UkwzWU5ZczIrdWVWTzREQnMveVBmbWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXE1S1pVNThEbHltc2RsS2FvUlV3YW95VWF0YW5lbnRTb1JHNEt0UTNid2Zm?=
 =?utf-8?B?MjVDekNLZXNDMFgva21UOWtGS1pnRkN4MWl3WXBEckNZbzlza3phajhrSGh2?=
 =?utf-8?B?MStlSWM1SEJzb3g3bEIrbUl6dnB2bUpFczVoWEhjVzBKRVpPdlAwSFdWVDZO?=
 =?utf-8?B?a1FMUmkrbFhFM3BVbkFLVytLNE1iTjFRbmd2Y2VkT3Jjb3lzU3B1TGRQVElT?=
 =?utf-8?B?VHVFUTRrWmduRWdRSlg2dm55eGhVNU9rOFJIYlhLeko0ek0vTUdrbHUxY3BW?=
 =?utf-8?B?bDd3M3VCYk8yaG9rNWg5SkErM3pGaVhIU2F5WmhFNUJyRmo3RTdjRVB5NWNZ?=
 =?utf-8?B?dm02TEx4dk14M2RTNk1vWXhzWWJ1VDVtd0ZGVGl5ZTlUOFZVWlNSWFJXTWZj?=
 =?utf-8?B?Z09hWGY2bTBIZVBzSk1sdUtiQ0RLdzlwa0dKeVFOQWZkcUdkU2I0aHBoN1h6?=
 =?utf-8?B?c2JDY1V4NUt1Tmo1RWdTWHBjbmpBcnNrV0xMckgwNDZOaTMxN0FLdEVYRkhv?=
 =?utf-8?B?U0Zac1dUT0NtQjBTNHp1MnlPbzZFQlhaMDN1aXFVMmRXYnEyc1AzL0l1eTYz?=
 =?utf-8?B?Rkk5ZjJ4eG5kdnF3cVBjaFo3ZjlJWlpEdUNLL2hqa2grdXNzQSsxUVk5S1l6?=
 =?utf-8?B?bUROM3Z6UU1BRWJXRXZ0UkhWL0twMjRpSS9Sb0ZoajFOWGVOdWtPU1lKV0hO?=
 =?utf-8?B?dWZEdkhtVUNIWWxjaGMzZkp1Q1J4RHFsbm9LVkc3WkVvekhFRCtadXI2cUlz?=
 =?utf-8?B?c3VRYy9ndzY4RG82Vjh0akNySTRRRzQwMmJWNTNwd1hMYjFUb0VrcEhlbmVC?=
 =?utf-8?B?eGFJVXlKVXJ5WlNRdkJLWW9XbENncG02dUsxZ3lvZmlqNDZ3KysvbkZrNCtY?=
 =?utf-8?B?T0xMYlRna1RjMmpiV0w1L0NsemRKbEdRT3FLT3o4ZXc1bzJvaG9KRUpJYlJp?=
 =?utf-8?B?cDYzelZ2cGNLYkU3Vkl4dTh4cnNZejB3M25Ba0Q5OXdLbityc29EcnM5cDNW?=
 =?utf-8?B?d2FwQU1OQUNxc1R2ZGlROHYxSDdNT2RhdGI1c3hYdVl2VzluTVl4eG51dXZi?=
 =?utf-8?B?U201UFZSQ3REQ1FmTGdUSFJkaXdCaHFiNUhoZ3A5NWtlSmRNNVdFN2dMT0xB?=
 =?utf-8?B?TXVZVUNVWXd1NHBBM1A4VkhOQTBaZGxlQnRoMXl2K2VTbHgzbWl6SUxjRHoy?=
 =?utf-8?B?cnpRTXpNMSs5N0FWT05vWFliWFU0NWxaUkZhWnl0bXhWSnVCdlpLekhMMnQ5?=
 =?utf-8?B?dnJ6QlNJQ0VYV3h0YSsrUjN1R3R3Vm5kajNEb2dyNTlQaXBWZnNISnZYZ1Zx?=
 =?utf-8?B?MVBsYzNiYklZTzdwKzg5UWE3ZVFPRzZmMERoTjNEa0pBS3dOaCs5Wm1iclUy?=
 =?utf-8?B?UmZPRlYvZFVVR2dGUWlXRkRheWFndjZ5TjU5M1hINFBBdVhIZDMzZk5VSHdJ?=
 =?utf-8?B?RUhKeHNZWjhEdEp0ejY1TU9JMnpzbHZXbGdYOEoveTRoTDBoRjVFWUlmTko3?=
 =?utf-8?B?NFdvRUlORU5uSWY5ZjY4ZE5ITUs0eVVNSU5aU1Z4OXlZUUs3VW1QSzd6aitS?=
 =?utf-8?B?Szg1NzNJK084Zmh3N3k2U1hRc01nN09hMkFEazNvSm1XOUNIU2Z4eElxc1NW?=
 =?utf-8?B?WUluNTdaVVY4RGI1TW0reTQzM3JVQ0VFaG9QSmZsdUJ5clAxeFJRK3pjZThu?=
 =?utf-8?B?ZFFTWXNYREFkck8yY0J2S2prcTJ5eU14WCtzQkZ2a09qdmJqYTdnRVFGOE1n?=
 =?utf-8?B?bkdBYmhFWGxCTndwUGMzV0xWQnlIZVk1ZncrcVQzbll3RzYxV0QwbVBDdjFz?=
 =?utf-8?B?alBwTjFsM3hKbG04L3F6NWlIYjd0d01LQTV4OS9Hc1RPNWYrR0JpR1B1Szda?=
 =?utf-8?B?R25FdzNZRkQxR0MrMzBPOHYxdUQyazg4b0ZOcnlaelNWS1ZyaG5mZ0pST1lL?=
 =?utf-8?B?aVJ4eHpUOXVRVTFzRmViK0RWMUhiNDZnR0xWVDlidHo1SXpFbGYydlZ3R0x5?=
 =?utf-8?B?MlNtYW1wZEJKVXNhNjJ1L2d3ZWdOc0hndFR3cHF5eHo1K2RXTm1BRUNKbGlX?=
 =?utf-8?B?MDhreWl5ZEp4enpKRTBubDI0RkFXMTgralRtV1ZsNmNWNldtZ0xkejVHVVRD?=
 =?utf-8?Q?rfrNPzxsVb2kJOkDhF6A7aXEa?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cccd1d40-e04e-49cc-3b37-08dd1b4b1e51
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2024 07:52:40.1223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8O/2uND/NKGJd9q+rR+j+KDn65SEast3jWgW76SQsYIFT6DWWxvQJ1vRjvjNFJGKnSm56j/XsBsrb+vi0NVyuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7581
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBE
ZWNlbWJlciAxMywgMjAyNCAzOjIwIFBNDQo+IA0KPiBPbiAyMDI0LzEyLzEzIDEwOjQzLCBUaWFu
LCBLZXZpbiB3cm90ZToNCj4gPg0KPiA+IEhlcmUgaXMgbXkgZnVsbCBwaWN0dXJlOg0KPiA+DQo+
ID4gQXQgZG9tYWluIGFsbG9jYXRpb24gdGhlIGRyaXZlciBzaG91bGQgZGVjaWRlIHdoZXRoZXIg
dGhlIHNldHRpbmcgb2YNCj4gPiBBTExPQ19QQVNJRCBpcyBjb21wYXRpYmxlIHRvIHRoZSBnaXZl
biBkb21haW4gdHlwZS4NCj4gPg0KPiA+IElmIHBhZ2luZyBhbmQgaW9tbXUgc3VwcG9ydHMgcGFz
aWQgdGhlbiBBTExPQ19QQVNJRCBpcyBhbGxvd2VkLiBUaGlzDQo+ID4gYXBwbGllcyB0byBhbGwg
ZHJpdmVycy4gQU1EIGRyaXZlciB3aWxsIGZ1cnRoZXIgc2VsZWN0IFYxIHZzLiBWMiBhY2NvcmRp
bmcNCj4gPiB0byB0aGUgZmxhZyBiaXQuDQo+ID4NCj4gPiBJZiBuZXN0aW5nLCBBTVIvQVJNIGRy
aXZlcnMgd2lsbCByZWplY3QgdGhlIGJpdCBhcyBhIENEL1BBU0lEIHRhYmxlDQo+ID4gY2Fubm90
IGJlIGF0dGFjaGVkIHRvIGEgUEFTSUQuIEludGVsIGRyaXZlciBhbGxvd3MgaXQgaWYgcGFzaWQg
aXMgc3VwcG9ydGVkDQo+ID4gYnkgaW9tbXUuDQo+IA0KPiBGb2xsb3dpbmcgeW91ciBvcGluaW9u
LCBJIHRoaW5rIHRoZSBlbmZvcmNlbWVudCBpcyBzb21ldGhpbmcgbGlrZSB0aGlzLA0KPiBpdCBv
bmx5IGNoZWNrcyBwYXNpZF9jb21wYXQgZm9yIHRoZSBQQVNJRCBwYXRoLg0KPiANCj4gKwlpZiAo
aWRldi0+ZGV2LT5pb21tdS0+bWF4X3Bhc2lkcyAmJiBwYXNpZCAhPSBJT01NVV9OT19QQVNJRA0K
PiAmJg0KPiAhaHdwdC0+cGFzaWRfY29tcGF0KQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCg0Kc2hv
dWxkbid0IGl0IGJlOg0KDQoJaWYgKCFpZGV2LT5kZXYtPmlvbW11LT5tYXhfcGFzaWRzIHx8DQoJ
ICAgICBwYXNpZCA9PSBJT01NVV9OT19QQVNJRCB8fA0KCSAgICAgIWh3cHQtPnBhc2lkX2NvbXBh
dCkNCgkJcmV0dXJuIC1FSU5WQUw7DQoNCj8NCg0KPiANCj4gVGhpcyBtZWFucyB0aGUgUklEIHBh
dGggaXMgbm90IHN1cmVseSBiZSBhdHRhY2hlZCB0byBwYXNpZC1jb21hcHQgZG9tYWluDQo+IG9y
IG5vdC4gZWl0aGVyIGlvbW11ZmQgb3IgaW9tbXUgZHJpdmVyIHNob3VsZCBkbyBhY3Jvc3MgY2hl
Y2sgYmV0d2VlbiB0aGUNCj4gUklEIGFuZCBQQVNJRCBwYXRoLiBJdCBpcyBmYWlsaW5nIGF0dGFj
aGluZyBub24tcGFzaWQgY29tcGF0IGRvbWFpbiB0byBSSUQNCj4gaWYgUEFTSUQgaGFzIGJlZW4g
YXR0YWNoZWQsIGFuZCB2aWNlIHZlcnNhLCBhdHRhY2hpbmcgUEFTSURzIHNob3VsZCBiZQ0KPiBm
YWlsZWQgaWYgUklEIGhhcyBiZWVuIGF0dGFjaGVkIHRvIG5vbiBwYXNpZCBjb21hcHQgZG9tYWlu
LiBJIGRvdWJ0IGlmIHRoaXMNCj4gY2FuIGJlIGRvbmUgZWFzaWx5IGFzIHRoZXJlIGlzIG5vIGxv
Y2sgYmV0d2VlbiBSSUQgYW5kIFBBU0lEIHBhdGhzLiANCg0KSSdtIG5vdCBzdXJlIHdoZXJlIHRo
YXQgcmVxdWlyZW1lbnQgY29tZXMgZnJvbS4gRG9lcyBBTUQgcmVxdWlyZSBSSUQNCmFuZCBQQVNJ
RCB0byB1c2UgdGhlIHNhbWUgZm9ybWF0IHdoZW4gbmVzdGluZyBpcyBkaXNhYmxlZD8gSWYgeWVz
LCB0aGF0J3MNCnN0aWxsIGEgZHJpdmVyIGJ1cmRlbiB0byBoYW5kbGUsIG5vdCBpb21tdWZkJ3Mu
Li4NCg0K

