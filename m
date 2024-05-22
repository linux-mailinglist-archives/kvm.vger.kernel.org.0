Return-Path: <kvm+bounces-17999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 76C398CC993
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A03391C21DDB
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1011614B958;
	Wed, 22 May 2024 23:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RCc/7vKM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6950C149E0F;
	Wed, 22 May 2024 23:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716420387; cv=fail; b=A6c9r1lrUx+6D/2A4WJVDr+uuocQOomZtQ/KSM1Soud6/FVdeWoKqubEiT5hYKPagCXkuywVAVB01aUw7mnCjXY9Pmo/aa/W/fc4IFujea3VqMzVdl+ol6DioCFgnrL9QvDC5nNctOiP6eomOy6AJGRi3hDKVh+yB/JeKmx4rTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716420387; c=relaxed/simple;
	bh=1vking+mCKbcPcLaYHMSVLxvURwEKV1Fy8dugRwsNIc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ma10q50wzMINBkR96p+qu2XH/uAH+PvAJzYbbl3DaVmXcbi5tcwg8ylWN2eoiKw8LuJ1V6bEJvc5SSlOFsIfZaJkdW5zzTKIDWL7MyNGMgIT3fhaoLifDsvQwxwkN1VFG2n3rURQUG6yvnKWVPBvXoWV6XzvLCjVt57WV9tc9FQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RCc/7vKM; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716420385; x=1747956385;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1vking+mCKbcPcLaYHMSVLxvURwEKV1Fy8dugRwsNIc=;
  b=RCc/7vKMyAz4l6+FerUCUTRiFDQWKAaM6H9mEwuF1N/GS3dyl6jpMXvv
   ewRIs1xWu4r9Hdws3vtjsOAwo0YuJCtfnpxbeAFfpfx14MxZtyc+kElAG
   YB/A54zyH2pOnn0gGWRzTzuxLLCsxZKpensaq/sKZVVpZrFv63D9oinzb
   EAgMSw5vAI+CCwJIaF6IOYHIXZd4svkUsh9S4GWEQwy6DMl+vxiuE79Wv
   x5y9UDtAdrtGCsrFn9zebxRqqRSoA8yAgbOKBO+U2RDusGwCM4Zbbo8MG
   039JDj4b2Zt1V2+F+UZtaAVjCCNi80NPZQNIdafboU6Q4sU1dgu8kUzKM
   g==;
X-CSE-ConnectionGUID: h4P8XdkPQiWSe//kxmwtbQ==
X-CSE-MsgGUID: gKoVgpoJSYytwpk4+iIV9g==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12936851"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12936851"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:26:25 -0700
X-CSE-ConnectionGUID: r5PftoPJTaW6YUHSS8Gs7g==
X-CSE-MsgGUID: /Jycigb1ReeZj+o3A3cUAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="33435266"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 16:26:24 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 16:26:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 16:26:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 16:26:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vv4xmODr13HIxzolNYGlmXlQei+qAh08R2jwKU2vUcO7v7966nZ72RzgkEAg1QDuSR0kyTwV8VrNsxv9hEbox9E2jJX8fmqA/3UfcCJTxI3xBlpDxZey7gBkFZdURxRjCJ7s5CBEDJxi4Vuh5lER/nyDGgpFokZzEqkOr7Y6WmtNy/6wHw45hqSm175CI6Rj/s3lhSSrrCCzzUde8ii4wDoO3sasr8kyvF6OYscIQvnDzPJCIQ/ztkjqZTYG5MpLekogHddD8ywsizq6fDxMa3DBS5uwD7JfU5ooG6YztaLf+bQdEjf1ieZg4+pOUszrMtm3pIw4eNWpsv2pyXW3pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vking+mCKbcPcLaYHMSVLxvURwEKV1Fy8dugRwsNIc=;
 b=D9x34NSZUnwI795LQRiKPg/3FHs/I1Zfe5pgQcFQWsYbBqNIAR+vbAo0dD+beZvtw9a1TzknUTAtGTAqdrGS2dIOMYcCYN6Lw09gj1fKSkDquqOqTLhlyHC8fEtYMI9OiQMJc2dDsionjIlKKSzyO9Y+6kB9bhc16OQpmwiqrjdOxTmHFkYE6nssn+z1AVjLtqeT7vhcEadNfE8DTw+uq/i2ecJvNcCpr0/WEr8rfiFGPY2QMu3+KFaLPWyV5wq0S4AJYMP6ohiacjq1azL+9io+UEQreFYygM1RNLzumjjGnLKGIHoDQiDzhX0IQW9qTuMmRd5o9iyTSLe2ZxCSLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7334.namprd11.prod.outlook.com (2603:10b6:8:11d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Wed, 22 May
 2024 23:26:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 23:26:21 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "Vetter, Daniel"
	<daniel.vetter@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Topic: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Index: AQHaoEb1yTw+2+R5T02uRFeJZuQMNbGPN+OAgAER64CAAGvrAIAEE0QAgATCszCAANP1gIABWkKAgAPDRsCAAnQoAIAAA/SAgAADhwCAAB2LgIAABQiAgAC9HuCAAG5egIAAtd9Q
Date: Wed, 22 May 2024 23:26:21 +0000
Message-ID: <BN9PR11MB527604CDF2E7FA49176200028CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240516143159.0416d6c7.alex.williamson@redhat.com>
 <20240517171117.GB20229@nvidia.com>
 <BN9PR11MB5276250B2CF376D15D16FF928CE92@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240521160714.GJ20229@nvidia.com>
 <20240521102123.7baaf85a.alex.williamson@redhat.com>
 <20240521163400.GK20229@nvidia.com>
 <20240521121945.7f144230.alex.williamson@redhat.com>
 <20240521183745.GP20229@nvidia.com>
 <BN9PR11MB52769E209C5B978C7094A5C08CEB2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240522122939.GT20229@nvidia.com>
In-Reply-To: <20240522122939.GT20229@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7334:EE_
x-ms-office365-filtering-correlation-id: 704c3a6b-1871-48a9-f3e3-08dc7ab69728
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Y25rbUdQeFp3T3BvS1czREFoVE9iRUpLY2NqWFZoSGRHbm5ISkY0MUh1QktS?=
 =?utf-8?B?OXQ0NXVxcUVncDZnU3VJVUh0bHdscVRwMWJYR2ZuL2JyWkhOaFV2Qm1VWEJp?=
 =?utf-8?B?THFQczNXamdMMmpNM0pSUUpmdmxoZld0ZmZydzdLeEtMNHRZY2lrTFJnTHV4?=
 =?utf-8?B?N2pOK3I4OXhNUHQxUXFpMjdOSEwrWnBuN3NycFlsQjZvbmRvUWxKa3VDUlNr?=
 =?utf-8?B?U3UrT2xuRC85ZHptZjJhd2tWQ3J0RTk4OXdNc0d2MjBqUVlDYU9FVWVDTVV2?=
 =?utf-8?B?TXhCSHZrbVlETWwrMnlacXVRS1R1SEFwUHdQc3pQWURDSEZjeURhZzI0Wkkz?=
 =?utf-8?B?N28yL2h4ZzV0YUVzMzlRT1RyRUZTdzk3VWVZZ01wbjhWM2VHK2lYTjA3Rjky?=
 =?utf-8?B?Y1NueHlac1ZnNXJaTVpiTFptbG1heGdtbXM5cTRpeXZSU0ZPZGErQTZZdGdh?=
 =?utf-8?B?TUZuQjRTcDRHdUFKYWtrT21aRzBXUElmRk5mRzdPQmJrZjJBOWR2N1F3Nlo2?=
 =?utf-8?B?UFFIY1NFSmZVT1E3OER6b1pHMmFwVHJXM3RMZkxpdmZsWERMbzlRa0llT2Jq?=
 =?utf-8?B?bXpPRjRYY1JObm53RFloZmFRaUUzVXExOHFVK2JGcWVyQ0lQQWRYc2ZGOEZB?=
 =?utf-8?B?bS9SQVIwYy9MM2cvaGc3Qml0THdVc29HakhBaFlJUW1FQU9RK3JGODQ5a2NS?=
 =?utf-8?B?SEdsUzJiUVBJK245L0xpeUhCWEFreWtWSFcyTGlvMm52VVRYYnZCcldseWY5?=
 =?utf-8?B?czl6NnFlaEN0ZlVrenZzbWYxSGNib1ZBOFptak5YV1Rta3ZVb21QRy81c3ZP?=
 =?utf-8?B?ckY2U2t3UzFTS0YwSnhVOVRZVlVTRXR2SzdmaGVFaXIxNlNiZ090UkFDOWgy?=
 =?utf-8?B?d0F3KzFLVHBJTnkrT0dNYitneFY0TVJJV0JxRHlWYkFUU3JGTEdGeWZIRW9t?=
 =?utf-8?B?UG02UlM4TnQvZmp0REQ2SjhkeEkyYlk0SDloZzE2WE9jS1JYK3UwaUpqcW5J?=
 =?utf-8?B?NFFmVUZHcTNUZlZqNWh0THdqYXEzb2RFd1F5WVZaQTRjcCtqMk9WRm5Yb3Nh?=
 =?utf-8?B?bjdvME9XbkM0bnhEZktKa3FoYSt2Z3FqN3JoeDRHbVE0Um1Bb0doRnhjUmF3?=
 =?utf-8?B?MG83ZHkzWjZNd1BtVVp2dHNncDVPZzU5NVVwK1dWWDJHRFJFeTZ3VXlTSDF6?=
 =?utf-8?B?VC9SUHo0d3Z1OXJhK2hPUFVvcmIyazFyMFNidnU1WnBoaVgrbmFSamFlaTVq?=
 =?utf-8?B?bDBwQXJTOWpmb2RpZjdYOG82T29lTDF4UEtHRXBzcVN3ZitXYStFbHd0ZkhD?=
 =?utf-8?B?OWREYnQ1dWRmQlRMSm5VYk5tYklIRldIWHZpc25LWjA0M3MyemxxZUVHT3JK?=
 =?utf-8?B?c0FMOGtKdXBqQzJzRzZZanplbXIyL0p5YUNibHVjUEMraXMxVUxXT2xMU0Fm?=
 =?utf-8?B?Yit2UVo2cEJPSHZBWjIyZWJvT2h0endFVGNVcHNWY0JHU05hK1dJQXBCVllv?=
 =?utf-8?B?c05zN01iMHFlVXVZT0cwM2hSUzd4RkliWVNjS3BEZUM2NklRZlVpRjdxWXgv?=
 =?utf-8?B?dXcyUmN4ZERTeEwyUkczS2ZZZ3krMzBBOUhBaFRiNUZkOFBLZFQ5b2pVVEMy?=
 =?utf-8?B?d0xwQnRSUklmTGlzWk9pUWVqRHFPS3dSWDVwZi9TSjJ3d0dBd3oyZXdTSGJy?=
 =?utf-8?B?aExSUThwSjl2aWEvd2NMZ1FJc2Q5K1VDVWNMbGovdnpTemJzcldpT3ZWVTdC?=
 =?utf-8?B?emtha2xWYjkwUGdzMCszejlxeUQ4aUp2Nm5xQ1hrbFpycUhybzlLYXB0MENh?=
 =?utf-8?B?T0ZBNml2OXh2MWlFREV3dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TldQaXFzUWxRd1NKNjdVMlZDZWZlSTd0V1VlVWhuMDluU1ZicENDWWM5QVZv?=
 =?utf-8?B?TURDcVlkRXRXS2Y1L0xoQkZjRmhlS3VYL2lyUEx0ZmJoeG00SmE1MUp3RXE2?=
 =?utf-8?B?R01idHlhSXU3dEFKeXB3c21nK3VjajRuWStGZVY5dUhleEVJVlJGS3h3enZv?=
 =?utf-8?B?VitDeTNwNkZjMFZvRGtkT2JTcmZpYnpNSTN4L3RGdE9BUjlKQUFOTnR5TXNz?=
 =?utf-8?B?dzZpWmtxYlI4M0JFMGI2akRHUFhJWHJiVi9MZk5lUDBNYmFpMjdvVDBRV2c1?=
 =?utf-8?B?c1orOVpVRzkreWVaMnFDeG0yY0NHVllzcGtGUEpEWFhRNkhvd3M2RjJXdW5v?=
 =?utf-8?B?Z25mbk1kTS9TSGI0eEUxY1pkMjIrMFRLYWxUR2l0RlNVcER1NE9HS044RitP?=
 =?utf-8?B?bVNHWS83QlVRVTY0L0RZcElub0NQREJWV1o1amFMZVpBcFJVZ0VOMllqalBY?=
 =?utf-8?B?SncrYjgzR0FiSjFkeUNObW9uc2tJa1hnWWt6TXM0cDVCckZWVVpUWWNjN0Fs?=
 =?utf-8?B?b0t5MXdtWm1JSTI2d1N3VENKSXA2NWFZNUpvVVNLMEpleGg4KzlyOHJBenU0?=
 =?utf-8?B?dDNoRFhVaGlGRUx0TzN2QTdsMTNaV1FlTXVrMjh6RmZPZ1BGdEJyTjBBU1Fx?=
 =?utf-8?B?OGxBdkpVS0UwaTJjWDZLdlRLZmdmNS83VW12TnZ1QXE0b1FtMDR3RUwwaEZC?=
 =?utf-8?B?Rm5tZXYyK1JxRkVWV2U5QlRKaHZlN2l2VjJqMDk4amxoRmVXWlRYaWgxQkhh?=
 =?utf-8?B?TWFIc3U3NU1ab3ZCQ1g3bFRoRVN2cXpoR3QwYkNGRS81Ujd2SXR2dDJKWWE4?=
 =?utf-8?B?bEJuU1JHN2Y2cjlhRVRVUE1EREd3YTgzWVBHSm84N3RGYlNqZVFpb2hCQUNa?=
 =?utf-8?B?SzNDcVgvOXR5TE0yazdiOXZXZFFqZ2w1MUtkV25Pbi9wdit6N0o5VFU1YzF3?=
 =?utf-8?B?b3o3Nzd1aFR0Ry8zcEJBVWx6b3FzM2s0d1FWVnc3czVIZlBkUVFCcUJQR1pv?=
 =?utf-8?B?UnMxQzdJM2hiUXdvSjBCYlM5MTFqTDYwMHQvcEpGRjJ4cU0wWEFPbmFOUFMx?=
 =?utf-8?B?dlROYnpIaTl2eGxNbTZXREd1R0pRcjFsWkIxakttU0Rqbis4RktVWE1WZHZm?=
 =?utf-8?B?ME5LNXYya2s0T2xKMlRib2F5TUxicTRQbjZxRFZzNThGeFVYdDk1cUtnTkE2?=
 =?utf-8?B?ei9QWmxueWtxV0dKNlBwdHN0aVlDc0ZxeUwxUlZ3OHVCZmhUSEk3SDZWWTh2?=
 =?utf-8?B?ZS9hTFFpRUR4aGNhNFQrRlAyU1YxZXB0UzE3b0J3RE1zRXRpeFN1cjNFRzB3?=
 =?utf-8?B?dExkeFFvMUlvcVdaWGNJUVNvUGh3NUhJeXVwdVZuNFJRd1N2ZzUxcGgwMU1i?=
 =?utf-8?B?aDNOZ0xIQjArYk03U3pRMmpOY3FiMVJPRFNuOU9vUW9RUkpNWVB2UG9CU3J0?=
 =?utf-8?B?ajJ6MWphQlpOcWtHQmovMy9BdW1kWk90VDNBSzVZZ25yakh5UGxhNjR1Mlpy?=
 =?utf-8?B?TXhnWmNPZjJ4d01rS2hVa2xyT001dTZmSlJZVEdIYUh5VWV3bUpTZU9FQU9a?=
 =?utf-8?B?alJ4Ui9kUEE3MG5zYkFPR1BkdkRORU82VkxDNGNXa3NZRjZkbXl3MTNHQzVW?=
 =?utf-8?B?Qm0zZWVaMFh4MG13RFpiWXY3a1ZNYTQzR2NuZU9TNENIa05YZXd5VExwZ0x5?=
 =?utf-8?B?QU9aNk51elJUNzU5b1VmMTRSRDFWQjR5Z0czNnlEbkdiaVNvTUVqdlA0UWNT?=
 =?utf-8?B?Z25BVktCT0FhMjA2djJIdGh0QkRzZGVaSGlScW1MODc3WGV2V2dCUlZJOFEx?=
 =?utf-8?B?NFRxM2pnT21jVUJtSnB3R3BwRElRRkdJYSt1ODFUMVFxVGliUGxFa0szUHhp?=
 =?utf-8?B?bW1NNWl3djFSYVJQdHZCeUZMcm5MZ1R3WW51M1orOUVzOEYxVEk0NHFXb2Np?=
 =?utf-8?B?dG1WdmZzQXo2dWpadE1LcDhuOXJvWnhRMDZud1JZRnFoRERJd2hPNDBYUE9R?=
 =?utf-8?B?Y1l3RnVkb2lzSVVzMjduZXJIOHlRZlE0UDB3UDEvNDNqd1VVMXdxTm9YK3Ar?=
 =?utf-8?B?S2ljTm9PU0djQzFGS0NUdkhsV3VPZzRGYzVCNVhXRDZhMzg3Vm1Na0RWd2x4?=
 =?utf-8?Q?EXXKOc5zXkzccnkNkXvLpeOHw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 704c3a6b-1871-48a9-f3e3-08dc7ab69728
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2024 23:26:21.8290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KF7+Jshoz0QDfL6Fgp5b4kh6NdZZB0xWGfKG7HnamhT9K2WWvR5Lrc11vt0ZDvEf4VJXZ1hjmzjgWotCYWMkCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7334
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIE1heSAyMiwgMjAyNCA4OjMwIFBNDQo+IA0KPiBPbiBXZWQsIE1heSAyMiwgMjAyNCBhdCAw
NjoyNDoxNEFNICswMDAwLCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPiBJJ20gZmluZSB0byBkbyBh
IHNwZWNpYWwgY2hlY2sgaW4gdGhlIGF0dGFjaCBwYXRoIHRvIGVuYWJsZSB0aGUgZmx1c2gNCj4g
PiBvbmx5IGZvciBJbnRlbCBHUFUuDQo+IA0KPiBXZSBhbHJlYWR5IGVmZmVjdGl2ZWx5IGRvIHRo
aXMgYWxyZWFkeSBieSBjaGVja2luZyB0aGUgZG9tYWluDQo+IGNhcGFiaWxpdGllcy4gT25seSB0
aGUgSW50ZWwgR1BVIHdpbGwgaGF2ZSBhIG5vbi1jb2hlcmVudCBkb21haW4uDQo+IA0KDQpJJ20g
Y29uZnVzZWQuIEluIGVhcmxpZXIgZGlzY3Vzc2lvbnMgeW91IHdhbnRlZCB0byBmaW5kIGEgd2F5
IHRvIG5vdA0KcHVibGlzaCBvdGhlcnMgZHVlIHRvIHRoZSBjaGVjayBvZiBub24tY29oZXJlbnQg
ZG9tYWluLCBlLmcuIHNvbWUNCkFSTSBTTU1VIGNhbm5vdCBmb3JjZSBzbm9vcC4NCg0KVGhlbiB5
b3UgYW5kIEFsZXggZGlzY3Vzc2VkIHRoZSBwb3NzaWJpbGl0eSBvZiByZWR1Y2luZyBwZXNzaW1p
c3RpYw0KZmx1c2hlcyBieSB2aXJ0dWFsaXppbmcgdGhlIFBDSSBOT1NOT09QIGJpdC4NCg0KV2l0
aCB0aGF0IGluIG1pbmQgSSB3YXMgdGhpbmtpbmcgd2hldGhlciB3ZSBleHBsaWNpdGx5IGVuYWJs
ZSB0aGlzDQpmbHVzaCBvbmx5IGZvciBJbnRlbCBHUFUgaW5zdGVhZCBvZiBjaGVja2luZyBub24t
Y29oZXJlbnQgZG9tYWluDQppbiB0aGUgYXR0YWNoIHBhdGgsIHNpbmNlIGl0J3MgdGhlIG9ubHkg
ZGV2aWNlIHdpdGggc3VjaCByZXF1aXJlbWVudC4NCg0KRGlkIEkgbWlzdW5kZXJzdGFuZCB0aGUg
Y29uY2VybiBoZXJlPw0KDQo=

