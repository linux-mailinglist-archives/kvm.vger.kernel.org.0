Return-Path: <kvm+bounces-20197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D05EB9117F7
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 03:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F40B61C20EB9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 01:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891B251C45;
	Fri, 21 Jun 2024 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e++IJ0vk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BAC4EB45;
	Fri, 21 Jun 2024 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718932710; cv=fail; b=vGsJ6hBWIgXR+raH+Vmky8Lm1pzQCAuj5x/E8wIPAWQpo9rlDOdXxt+Fgcs5MZj791jEjWg8LiD78CO7XA4yIFHANDvkFEfn3LmLf9pBokud21k/LCjSHSe0Sb5kF3K8rFfs+bWYQjKDWySvJsJFYFrPEot0MxCf4l+Fjp7KChw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718932710; c=relaxed/simple;
	bh=YpwAgzBbLfiXYwUUxz/jP6fBk3GhZfN9sdODnAzvlcw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BId1KrnZpjrKSjf/Oc+YxKYVWgdPBw/Wuhs4cvKVA0rKTruC0OrqgUfNBi+0Pn2epDp3P3LN8K2qMaSU3GVm9w26CdzzSYWZVx17CHiwdXRKBvAnlvGNZdaWHtKIedD1H+75uuyOiBkkRJP24OgZ0ZSnF/lMYXBBNi4xSasOcEw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e++IJ0vk; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718932710; x=1750468710;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YpwAgzBbLfiXYwUUxz/jP6fBk3GhZfN9sdODnAzvlcw=;
  b=e++IJ0vk8b7DHTg62x1OnkMyzUXX0WY0EVPawtLIi0fwpf080Aqn4YNV
   HyWuSemaeMFd+89UhIn46YqS78odlBaJP64T+o8HBrJ7C78TdTsla/8Ux
   s9WWkZpoxE7MQu9scuDeSycxU34fvn+3CCSLwYrIT2ofYbQorRRDy7dd4
   y/7NDY3BgypNiEMv73tVEAvNfUsSoZbxrmqd0W/q9O1n3u317/I6hiitP
   23VIHd8Q+yJJ5jTRySpoOUKtL/AoFZ9MEmLHdoZ7r/epyTAzeN7YY32BD
   Wysk+6UrjoRWUDnQUMNOXSrAp9OA9sqD4Zx4Ezh5zQBEWE4bEPsJU65V0
   w==;
X-CSE-ConnectionGUID: kYVURVcpSbCeXP/CTRQwwA==
X-CSE-MsgGUID: PhnFDtD+SYecsw4oymytsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16096727"
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="16096727"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 18:18:29 -0700
X-CSE-ConnectionGUID: OyXf2MtqSjaz3ZrWi/LiZg==
X-CSE-MsgGUID: jnOB28V7SAiWUWvJyUiTnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,253,1712646000"; 
   d="scan'208";a="42394900"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 18:18:27 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 18:18:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 18:18:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 18:18:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 18:18:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvEg2AJYjYyvmUPx/jCcTF9lz7zRLaPgwx6VEuSiWRjSc/ygkAEQVV7Rny4RU5J272hcvJxVMH+w6EFAhfi8TeG+19thfPjubR+RL2aauOQTlL/T9L9BnYBMJAfbhvOEU/u21MNbFTb9NhwrDwCSL2XZPzzN/zn23nKexzpd8ntT3EZL+EHNimXKXoctnHze875kSRAz4TTpHZ/pcAVQv+qln1CVqZDx1Kk9QPORYoxtrh8ybuBt8DNEfB3SQ5uf2iWMwOj8/4nI1JrswEwJvozRSyk6udSK1UiIYiwdmk6PGKeV5Vn5mgmYy+7pk9Ju3shpb8SB/RYvm4qP4Jwuqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpwAgzBbLfiXYwUUxz/jP6fBk3GhZfN9sdODnAzvlcw=;
 b=krWzmh6je1WwHe5cj4JAuD7pjlvoHaJ0cgKUw8CYUY2YFbmFKNMug/Wt8+Ng8ISenHVjlGyJlCIfWwahZ1rJymykvPztrMcVPeDXCxKYCUAdPnR6zldO4ab6I+QlZEAKhgW/bwO4UIKyYkIVBtxNq9A4U3EyIhElZLChZKWKHzO55kq2kDCGlM4x9sJLx81ET9dgI/mibVTBh86aJNV741lBARh38FWlHcyUjo+RApMGnb5t6AoDt3cdbIhBqIMx6vdvw9Qqks5hR2RTPZ+xH6lyA3PIPni6CsfCE1LlsDipWZFAyhKkejbimRZR4MAw+qfsLjTl1bWL2RQcPdX82A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM6PR11MB4738.namprd11.prod.outlook.com (2603:10b6:5:2a3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Fri, 21 Jun
 2024 01:17:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.017; Fri, 21 Jun 2024
 01:17:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Implement memslot deletion for TDX
Thread-Topic: [PATCH] KVM: x86/mmu: Implement memslot deletion for TDX
Thread-Index: AQHaw0lDpap4PCJZJESxstQmwV3uIbHRV8CAgAATXAA=
Date: Fri, 21 Jun 2024 01:17:55 +0000
Message-ID: <a57ecabb57de9cd808257e0da7d93169fb12e8d4.camel@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
	 <20240620193701.374519-1-rick.p.edgecombe@intel.com>
	 <ZnTEhQo2r3Uz9rDY@google.com>
In-Reply-To: <ZnTEhQo2r3Uz9rDY@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM6PR11MB4738:EE_
x-ms-office365-filtering-correlation-id: 3f639bcf-f293-4d55-1a63-08dc918ffad2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?Si9peldYV2ltNUNuQndnMmpCSkdJdXI1SjR4L0VmenVmeVlDWThZMXE0SWlW?=
 =?utf-8?B?WGRJUEFKQXZzVEdRVE84RUs5ZGtUdDV1VnRBMUs4ZWFleFlvRGIwS1cyUi8z?=
 =?utf-8?B?c1NjOElCVUhFejNtMExvZUdRVHhUMWNyb0x1cFh6NEd0SGQvMVVuUkhQcGhY?=
 =?utf-8?B?Y3JZVjFBeGlyZFIxUzhob0V6UnZtenl0NE5pVVdsSlJoVitSbmYycDEyeURa?=
 =?utf-8?B?S01aT1JlWHFvcEtTZmN3bEkzQkRXNmZXRGR3T1d2c1A3Nmk5N0kxekRHMjlm?=
 =?utf-8?B?NXZPQUtSVEhEc2MxVlNkVG04QStrZmlCd3NBdERUS3VOdUEraUVkd0ordUhT?=
 =?utf-8?B?VDVaU0xoUEVKWkdmWlVNZ1k4SjNid29zRS93a2xESHphdkJpd1Z4b1BUUUNt?=
 =?utf-8?B?R0todHVNd2ZjYmNmbk10Nm5ONHN1cHN2S3hQZkZPNzJXMVJXWktYWWo1RitX?=
 =?utf-8?B?UWJKNTZHUTdZMDFTVEVaQlFXRTlSajNoZTBtWENtREpURXF6c20zT2ZtalN1?=
 =?utf-8?B?YmRheGp3emt5UE0rNlQvV0JXNWpiYTJ4QkxEREdZN3lPTTg0UDFZdU9aUDRo?=
 =?utf-8?B?LzljSW9oSTJFd2liTitJZVJvQVhqV1dyRGhiZ29saVJtTjQyY0FINmpOVks4?=
 =?utf-8?B?aW0weTBCdWxDMEZXZXpRUVNGYXFrNXNITVRYRHdQVmNlK3hrcHdXMUZwY1ZL?=
 =?utf-8?B?TWJNT3ZwTHpYbkUrSWNLSG84YlZoQVZ2dGRFNXR1QlFmdFpia296aWRHUXhs?=
 =?utf-8?B?MFdzRTRaSmRGcVMwSzhNZHRHaGNQMWxxL0t3M0QrdTdnSW00cTJ6UDl2cnJa?=
 =?utf-8?B?QkVqYXQwczJQbkd3TzR2WU5sdXJ2dTF5TmQ0TFpSYVRKQnVRNFlWeUdqdDY5?=
 =?utf-8?B?SDJhaTZZZlhHMnk1OHZuN24rNDI3Zy9xcjUyaXd2alZPdVhwblZ3aU9CZG5H?=
 =?utf-8?B?QjVvbE05SFhmZWZwY1ZkeTl3NjJqN2ZzK2JXNXV1R29nSlZ4N1VwaUo2Ukho?=
 =?utf-8?B?Z01KMnVHWDR0dnhNdDJNZE9mb2ROZE1MR2ZvcmY0bXdVaktCUTVCaEpkMkZo?=
 =?utf-8?B?V0JWd3gwK0RQQ0NLVHpiMTI3akNLRzk1UmI4RG9rS2JqSnY1am91QlhueGIw?=
 =?utf-8?B?UnJOb0JuMVFZT01nQ2JBTGFLZnlTZ05DRk5mdDFSUmhhQ3VJMm8yNmQrVmtx?=
 =?utf-8?B?NDNIODRKZmhkaHhsaittL3FyalpIdDRFWWMwem1rK1FEcGM0TU5WRGREY1du?=
 =?utf-8?B?THBqS2RQWVR1TFBUMjEyNGV5Y0ZLU3VqLzJnaFZ5TFgrZmFTcDBQV3U4THNh?=
 =?utf-8?B?NUYzMGk3aEFWYlVER1FPSkF0a0M3WURuQjFFM1NnNXpYcXlZbStqa3dJL1Fk?=
 =?utf-8?B?ZzVNME5palluMDNNUzBqTStOMnFRTDVRbmNUNnJWVW92clJZOEJHamtZbFVS?=
 =?utf-8?B?MjVoWjAyVkNiS2NoOEJRYTcxcnJ3ZUFNc3UyV25DZDJhNlUwTmZ1dzVNTU05?=
 =?utf-8?B?R0cyOUpXZkc5NHlQUjJEM0xzckZXU0UzeEpkWEdndlVld2VQcFQ2ZjA2TjZY?=
 =?utf-8?B?azdhVHp2a2FXeEhVc2ZoRWRHcVRNZnZzNW00MDFmMmJJdHdFb3dXV0ErN1Vm?=
 =?utf-8?B?d2dpblNZMDFnR2IvR0xEZitQZEZSajRsdDkxMVFhU3dQdS9CWDFVQ09uY1Fj?=
 =?utf-8?B?N0tkVGI0VFl5WGNEYjQ4T0kreE8wanlFYndjSXY5bnRmSlora0pjTnhONjI4?=
 =?utf-8?B?dTAvM05FMTNCbnl6REpmb1B2K01XWnFvQWQ3WFNHRWZDTkRUSzgrV1Q2QmVk?=
 =?utf-8?Q?OI1aLm4UI/jSPOxEzRwWFKC7cNwz95jJ3mFNU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1JhWjJXT3Z4K1NyV0kxUTk5TVNMWGF6TEpoMXoyVVh3bGRWaEN5aGdsT2Rp?=
 =?utf-8?B?ZEY3UlAxZlR3SVd3dFRMb0JVck0yM2VJSFBvU3ZNWjNrMW53cHNvUUZ6Q2x2?=
 =?utf-8?B?anh1eTZRYkFkTUsyNEhuZVBKR3FTRy9raWxtVzNEaFBFU0VNSGxYRFRlWWln?=
 =?utf-8?B?RnlCZzA1N3hpRFQ1L1lIdFV4MlpCT21RMDZJRXp5blB6ck5xeElBNmRRR2Jv?=
 =?utf-8?B?TjN3VmZCZVhHc3lBSnUxQ0VXOVhDdThQY21Wa3cxT0FOUHFJVDZvRFN2VS8x?=
 =?utf-8?B?SXVIdDR5ZlYySVFHaUNxOU9GRkpkUkNXWW1jdGZPaDIwZExXaWNtV0crNXY1?=
 =?utf-8?B?bUpVNXV1N1F2MzZKcEkyaUZhV0hLSnpTVDhNSm5zVTR4cGNVd1NzZGxIcEdB?=
 =?utf-8?B?TTQrZ3J6RkZnaElpNi9qV0MwbzkwR3QwM1FSSTZPMkhDNm5pWTNRTExnT3Uw?=
 =?utf-8?B?cm9HSTcrczF5TEl5Y2Q4d1FlKzRNVEJteEVsVUtMUFNaRkhRdFBTZHkzZnhI?=
 =?utf-8?B?ZE9CWG56UW9Mdkc1K3ZCaGJaNlUzT2MyVXFVak00S0ZMRy9aeFY0QS9sMVFS?=
 =?utf-8?B?eUUrM2I3QllHOXFCR041MkFodnc0S0hSbUt4eU1zdTFpb1JOOFg2SDRxRGxw?=
 =?utf-8?B?QjZRQkdDQ1h4NjF4RVp5YUZzc3pSU3VBVGRBSEtJVzVlQmpqQ2JuQjJkdk5F?=
 =?utf-8?B?SDE1MDBFVG56WFRXMSt3Nit1N0hjS05jTmNETlRVNjBKLzUxbkZ3MEFMcVFz?=
 =?utf-8?B?c1NzNmFtU3hpckxPREJpTlI4MmZlUzRIc1hYb1Q5SmFhY2N6Ull6ZDQ4a3hE?=
 =?utf-8?B?UXFuWXJGbDM5MCtCNmM3Y2psT04zTTFEMi9yRkRzV09IcjZzRjNZcXpYNUVN?=
 =?utf-8?B?MVY5U004NzZWMHo1dVhwVzVyZkpackFicm56WXRSZWlaWXFJc1VPcVd3UHpK?=
 =?utf-8?B?LzdIWjdxM2U1NGMyLzBmZ0RNelFuVDR2eWlMdTVLQkh5TmFJVU5yVTVFWG14?=
 =?utf-8?B?ajdWQUpoRWpZU2JHcmhMMWVlY0poUmhWYWdhRXlhblJob1JNQ1NibUVwSWdz?=
 =?utf-8?B?Vkt6Rk5Lek5sa3o3eDN6NVB2T1h5Zkx5OWMwM3J3OWY3ZCsvNnVpdEViaThF?=
 =?utf-8?B?QjljUzZJSFNjbWxiY3RXS3lTeGVONXNlaldHKzA2empxbGlEdXVOck4zSUJI?=
 =?utf-8?B?Ni8wUEFtVDFVbVcrcXhCWFl4UlRMbUxGSUhlNDA3cERJMVZtUlFwWlJpMlBl?=
 =?utf-8?B?QnlLREJMMUR6aGcxNWIrOStjamRLSWFYSnNqbXUwbm1xVVhEYUxIYkoyVEo4?=
 =?utf-8?B?bERXTUx3eXVkZ1VJa2xsRUR1SkY4dUpuZmlKTjRmZWdJZmNjekVuTWs5SC9j?=
 =?utf-8?B?M1dPdWxORi96NnB5SjBXY2dNVE4xM1BEckFJRFBaZ1JBN1NlWXVPQnlwckRI?=
 =?utf-8?B?RW9SZzdKZ2lnQ1RNVmNmbys3RkEzLzRBMzVxQ3JwNVYwNk9CVWF3NGN3d1Nn?=
 =?utf-8?B?cGJ0QlRCNDJwd043VXBmQ2lCVk0zKzdTcUk4TjBDRjh2VFgrNnJremMxK0lJ?=
 =?utf-8?B?UU9uUk9tYjJqcUlMQkhRRmxvMjZBamZVczRzeUhSYllodXJIa2VFYWhpSkRV?=
 =?utf-8?B?dk9xbGk1bWs3cHpOT1pRT2hPVmZ6d1FUNk5UWHBYcWhwU0ZYQkdpQnBCSjA3?=
 =?utf-8?B?cHVuL201bWJLZS8wNG0ycDNEMTVON0N1clNGTCthempHOXZRdjdjZTVUMzYz?=
 =?utf-8?B?d09QYUo1V1FacHpTeDREeG1jekxwSzRmbTBDaUdEakxiWmFFc1FzNzBCOUd5?=
 =?utf-8?B?Nll6bzJMS2NZN2xoSnpSRytpYldmUTVBemgxd2dseTFxTU5FaGhRbUF4b0ov?=
 =?utf-8?B?bStXTEl1VnFMa21ZMVRNUS9EUkhWQnN2dnhxeXd3NjNScHFKV2xuQjdXNS9N?=
 =?utf-8?B?Mmd3cDc1bnZVQUNsaHhNSjFoUy9neGhiUHpuREljTGpWdlFHUGJqK2h1Nlg3?=
 =?utf-8?B?RDV0ckl6dWJTK2UyRDJYekxwU2FSOGgxKzhVem9VWEtrOTZub0k0VWt1K2Vv?=
 =?utf-8?B?Z2RYQ0Y3K29JVlNWTXVhZHNYOWEwbVhGcHE3VDdZV1RaUDA1RHczeXVtblFv?=
 =?utf-8?B?YmxkdzFHZkE0L2ZIYVZlVVVteTM2a1MrYmlwNkUzY3Z2eW9SYVFPVmV6VGoz?=
 =?utf-8?Q?a6RSWJZLrdq5O+ZhqwlpXC4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E8560143A5FD184ABE76B3B8FDF1BAD6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f639bcf-f293-4d55-1a63-08dc918ffad2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2024 01:17:55.3919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kJ1oJhU7NjfASXTby+qvH5ej6wA04W3GjxbMncn6I8OQFFy7v3czJrAlONHI1hOrad6M2HbwDfZl2iHzntxLp/R/2zSrjj3QQ5Jr9tm8OuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4738
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA2LTIwIGF0IDE3OjA4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEp1biAyMCwgMjAyNCwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4g
Rm9yY2UgVERYIFZNcyB0byB1c2UgdGhlIEtWTV9YODZfUVVJUktfU0xPVF9aQVBfQUxMIGJlaGF2
aW9yLg0KPiA+IA0KPiA+IFREcyBjYW5ub3QgdXNlIHRoZSBmYXN0IHphcHBpbmcgb3BlcmF0aW9u
IHRvIGltcGxlbWVudCBtZW1zbG90IGRlbGV0aW9uIGZvcg0KPiA+IGEgY291cGxlIHJlYXNvbnM6
DQo+ID4gMS4gS1ZNIGNhbm5vdCB6YXAgVERYIHByaXZhdGUgUFRFcyBhbmQgcmUtZmF1bHQgdGhl
bSB3aXRob3V0IGNvb3JkaW5hdGluZw0KPiANCj4gVWJlciBuaXQsIHRoaXMgaXNuJ3Qgc3RyaWN0
bHkgdHJ1ZSwgZm9yIEtWTSdzIGRlZmluaXRpb24gb2YgInphcCIgKHdoaWNoIGlzDQo+IGZ1enp5
DQo+IGFuZCBvdmVybG9hZGVkKS7CoCBLVk0gX2NvdWxkXyB6YXAgYW5kIHJlLWZhdWx0ICpsZWFm
KiBQVEVzLCBlLmcuDQo+IEJMT0NLK1VOQkxPQ0suDQo+IEl0J3Mgc3BlY2lmaWNhbGx5IHRoZSBm
dWxsIHRlYXJkb3duIGFuZCByZWJ1aWxkIG9mIHRoZSAiZmFzdCB6YXAiIHRoYXQgZG9lc24ndA0K
PiBwbGF5IG5pY2UsIGFzIHRoZSBub24tbGVhZiBTLUVQVCBlbnRyaWVzICptdXN0KiBiZSBwcmVz
ZXJ2ZWQgZHVlIHRvIGhvdyB0aGUNCj4gVERYDQo+IG1vZHVsZSBkb2VzIGlzIHJlZmNvdW50aW5n
Lg0KDQpIbW0sIHllYS4gVGhhdCBpcyBwcm9iYWJseSB3b3J0aCBhbiB1cGRhdGUuIEknbGwgY2hh
bmdlIGl0IGZvciB3aGVuIEkgcG9zdA0KYW5vdGhlciB2ZXJzaW9uIG9mIHRoaXMgcGF0Y2guDQoN
Ckkgd2FzIGltYWdpbmcgdGhpcyBzZXJpZXMgbWlnaHQgZ28gdXAgYWhlYWQgb2YgdGhlIHJlc3Qg
b2YgdGhlIE1NVSBwcmVwIHN0dWZmLg0KSW4gd2hpY2ggY2FzZSBJIGNhbiBqdXN0IHBvc3QgYSBu
ZXcgdmVyc2lvbiBvZiB0aGlzIHBhdGNoIG9uIHRvcCBvZiBrdm0tY29jby0NCnF1ZXVlIG9uY2Ug
dGhpcyBzZXJpZXMgYXBwZWFycyBpbiB0aGUgYmFzZSBvZiB0aGF0IGJyYW5jaC4gQXNzdW1pbmcg
dGhlcmUgaXMgbm8NCnByb2JsZW1zIHdpdGggdGhhdCwgSSB3b24ndCBwb3N0IGEgdjIgcmlnaHQg
YXdheS4NCg==

