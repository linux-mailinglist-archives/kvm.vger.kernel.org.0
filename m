Return-Path: <kvm+bounces-17525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 788E48C72FA
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 10:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEF751F22932
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 08:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C58F1411F6;
	Thu, 16 May 2024 08:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CFjGoOls"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D31E6D1AF;
	Thu, 16 May 2024 08:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715848697; cv=fail; b=HbQjvz3ltfeZH2BYCsvHm6rZeLJEQxlLZ7+Dg4sF03k5VXX983jLTKpYHgDBEC7vZ91MlH+dvtBI4m/J103ykDjIciN2Iheol8P5GA8EP0zSP+jNWct/KDdgUOBp8mYZSIRzlU61Yxm1EDi/Vu9sp1aeAjYnrs6qkxe+jT+GGjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715848697; c=relaxed/simple;
	bh=RpuAp4vNY3X8u9JC+8sEtsNEuX4n0GaRIjChBycX53M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rEY6ZV63ggMi2eas7iLI8DtGd3X4ehLn0q6SYV0i532lE8di7CXDLMiauqLCGgdC4i1mFfe3aXL4jS2Yf5zjnpkZWc8GCeF0/wqxeRcsv1ywmExuxo2UqIrvmQcF09Kh8ltAjw1KvEa/zLWllJ0rhsG3BU7908u7IR+6my5dR/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CFjGoOls; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715848696; x=1747384696;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RpuAp4vNY3X8u9JC+8sEtsNEuX4n0GaRIjChBycX53M=;
  b=CFjGoOlsWg6Biggwb5luA3XEQEP3uQjLqwgwam0PU62u32VdnO5ViCZ1
   cCkVumyFhtCSeQf23+J/XK7U0CWOt8HPlhlSytrjrg25aaLN4Kf6hqmTU
   uRDs9c2d+CPoVruuQpr+QpIcKT/1r/kwlbhQrRA9vctwm/Hix0NT7hc0H
   A6a0qjz7aEzdBfhD4Bw77h0FrFk27+Q8SGljZ0IMA1zDtUqqdh9esaSaL
   67KWHok2RgjEe/1O8r9KIA5iWw3QUanZQ1NhLbAigvfrzqGgbDmV8mIoB
   eyoMdbP+ef1UfXox2gs50xtLgTnmY+BwQel4QbfvMDdfkI9fahHywegQ0
   A==;
X-CSE-ConnectionGUID: yzWZzJmKRKuMg43kNhjg5g==
X-CSE-MsgGUID: YvQ8SYOrR1a4z1rAYj/bSg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15768406"
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="15768406"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 01:38:15 -0700
X-CSE-ConnectionGUID: 0e4iKy4uQ72+FEwkpEF8Uw==
X-CSE-MsgGUID: OaA3RuKATwOSfQXxybc5iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="36228456"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 01:38:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 01:38:14 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 01:38:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 01:38:14 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 01:38:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdcOeLjLjv6ZQ99FVghJRv0CU/psJgw3SbYwxLs2LDsNQhaiv+w/+bapatzbKWJECm3jgdQ5+r4vfbW9qyYCiW4ehfGgqKRA+hL/p50CPlS+gv4m9kl64WkWts+IduGKsNpT6JxV5dJXiYEnaAgMTiWovXHMFLduT6DbUa8/AeIRHU/5EbYaZrNDYL+I9HFu1HjrQTvYQerPMt9wMCQa+klCEEFoOVtLRNsGLWhjhtWKJzT1eZB3tdsTZUnhA8sQBzngEhiY5lFVMtPgC755prcxiWqKYxCKsznyGeN9ICAArPdvM4Wq3sKckJ9OpSAZc0Vdy50sFD/P2MrftthdmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJhlAm5PCk21JoJ6qSdh4cWP1/ZDPW75le4Mm8gytI0=;
 b=drsDTNscDkl4SfZWJEl6g5m/jFXMaOkvFmZo0Nrq+qsyMB6f/JCeKApbz0dUxKCXhLmuzH2HD4vSHWIZu9uvvsg1uLZAGuU568pVGB2WZmzPbRDSgtMIPJUFzqBCiV6K98imDQrJ1Wh+6CK0kIKbtLfrx35zeqiPFo0HvUvDwHeIttLh0LDAlo1q75AcmGpS85QXiTnjPN81vu+MpNE1oiHwKO1jlSVfQ5ueVUrufpRu1amtMOcQDjI1tEuuIXt1aSinTvKEgmHhcGxRPta+k+mGbX3+3tleEMUdBpOCL0tL3q9RydMCbIHfLzpdg/RAbKAivWNCrNATobGwDJ3cWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7417.namprd11.prod.outlook.com (2603:10b6:806:345::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 08:38:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7587.026; Thu, 16 May 2024
 08:38:12 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org"
	<will@kernel.org>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>
Subject: RE: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Topic: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Thread-Index: AQHaoEcDoWZ4XBbpTkCRP2AjSpAxzLGO9ZcAgAEq0wCAAFsyAIAEVmaAgAIPYoCAAQrnAIAA5B4AgABhsYCAAGX4EA==
Date: Thu, 16 May 2024 08:38:12 +0000
Message-ID: <BN9PR11MB5276C9F1281F689B32440B558CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com> <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com> <ZkUeWAjHuvIhLcFH@nvidia.com>
 <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7417:EE_
x-ms-office365-filtering-correlation-id: d0d79b2d-ff88-471a-013c-08dc7583858c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?1nypPIkyzph82nTEIBUzuLuE17oizkTtGmlCcjEuvZ+A2fCM98K4ndwBI05/?=
 =?us-ascii?Q?7Dh1yOldkxwr17xEWHGCfGN1Stu85kn3Q16RA6r863/A/a1g3Yr7DJROeoGQ?=
 =?us-ascii?Q?E2jI7iJCmjlicR2sxMR8F73uGUyRwSXqIGbRzop77MYARkVPqGEm6ckGFZl8?=
 =?us-ascii?Q?fFpB3yFAbtqp20ZViduB498zXnIwmRay8IrFhHR954GCsqvoT7voawB/1dY3?=
 =?us-ascii?Q?+5ndrsKOzG2BQGHpL0J6jqfb6u0fSUVwVVEO/giOTBNrgNIT57Ac1e20qUbm?=
 =?us-ascii?Q?vrsuCIZ7lzFeTzr6fQgkDN6TXPHWa8/Yp5nWL+/Ic4UZ3f7rKgc2iL0UxrBx?=
 =?us-ascii?Q?OtXLes+RHlZvJet2mhbZ6UH0FamQ5o7SZrKYeH6ZC528fgjxR11zI9gsLVNc?=
 =?us-ascii?Q?JMTw1OyKdQwr/P82g5jE6GCJXa4imbUl3iSwKGtGvwbEaNc/7HpgxpOVKz0Z?=
 =?us-ascii?Q?GYDK/wMEzMTm9GuEuhLC2EIIUGzbcZzIei2MIKTQq+gWZO8XFoD1H8x94lL6?=
 =?us-ascii?Q?NYbPqRYqf3FN9yvG8hc/Ewtlw0PxnV/b+4BvVtSk89wQ22fE11FCVJ9q9PBB?=
 =?us-ascii?Q?cAL8MrKQc9S1b7rzFdb6+Tp0uhsUfQgoxSlo6j/wFdjN1/yoPLS3ae7+nqFp?=
 =?us-ascii?Q?0yAMWmOALsWyu29mS4GsrSGEO1o3V4aPIGm4IrlFydshq80KRuUWBbCIyV9G?=
 =?us-ascii?Q?Uo76Yys62VLsUJdTzz9R7xAKN3ROq94oEsr3qR/YQOQHqNGx7LWok+5/gBsL?=
 =?us-ascii?Q?UhtnfZlcs7nD9XCClf1s9bhTL9wuERDdvXaGZmh2SfH+zG87i9zjwzyOCpe4?=
 =?us-ascii?Q?5wddbgKFpxnMY8H73ukIFJnBnDo6wrqtjWG+QMMKdtvkn1GmJIzErfCBT5nW?=
 =?us-ascii?Q?qwh+h1k42yM8vD8TLpZMHYAWthIX7RRCWEq+pE6pvILYu4DNgv35KO9/zkMH?=
 =?us-ascii?Q?gyq7dHunaoWTY31UB677TysMpu7BCJ+lHwjbA1HDsElSi0KQ3gxgZc/YdCo8?=
 =?us-ascii?Q?PaR+6PTT9HBfqoHwSgLOkP4dRVOnLvDRTiU6TOejj/5euQ+oW9GPC3qgClEQ?=
 =?us-ascii?Q?aJvNOhiH2OU82NJJVPD4fsNm72btO3GsjCToh7OXLHQmU6JRkIXs7dpAIu7f?=
 =?us-ascii?Q?dyRZnS2WQ3sQ+CqSMugW+1ZeHybzqWTbHzZFsEQhN7wBJ5AiL24u2FX3B2YW?=
 =?us-ascii?Q?q2pJicbv8IQ8lTOvYIlsx9TvMJpxSMwExseOkgA+h/ojzNMLHVUWH6d8SFmh?=
 =?us-ascii?Q?cpcA7V2O+DqXoMKy+5j8/FsAlIb1NFaAyNRZa2w7+JhVjMNflX3GkQ8HdM6R?=
 =?us-ascii?Q?fPy9aWZPG2JgH2U37yjv3L4+0UjJWipxPwn1LDnPqHGD3Q=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/pJ50FedzGUidmQWqPl8HCQhk4wBoOLbAcQqmbQzym72MJPiV/BO5tiLVN8/?=
 =?us-ascii?Q?L2ExjQzbOw31+Byjy5zALPxkrIlMmZAp2CLwPoSq5Y32FcNVcyUNCaGooGrw?=
 =?us-ascii?Q?kMLTrjKmu1FfEZQEBv6QdRlQxvPR5cI0Yj6akQWKpK/jxnQ1pv3MX7ftp3yJ?=
 =?us-ascii?Q?YT/DWoOwVkubY8lohJSgm9azNsJHItL7uZDWZZAlb+yCpX6ds6eVIvCe49jv?=
 =?us-ascii?Q?g5bdOT1914nbVhW0gI4EUoHjGYOXYV4mBRJV3We1szMFIfGl9Ckyr8TXJyP4?=
 =?us-ascii?Q?ag0Rf6RizyX2NDrBVakjVjPYMPiID0XGjctt3OI7vb170gM2MiC1iQSkYnma?=
 =?us-ascii?Q?TOQusdlj8uZZfhaKBcSM8MbeatJDQGId/3MmSxL2aZw34e0HZhgrsxHCT5gx?=
 =?us-ascii?Q?gTGT40gm8knhXBEl2R5R25J/B8cUS4BG+3RDFt/Y5uQbfyaXnT2DXRjG50yC?=
 =?us-ascii?Q?W2CDy8ShPVv0NTSXH9cRvfTBT+jtEh+DTbUfy5xDvj6lZNXv70zGBei3WC4u?=
 =?us-ascii?Q?+W8otC0g1NvAk1w9iDEl5UZDx61DK1sfLLrbejBbNTKptjLXK2ecmXgYwcuV?=
 =?us-ascii?Q?xfQOwsh3fWzX+d6KuiBxebWNMRUxtiPwInjKmXMztvP09jQiqMS6OXC6Pt0s?=
 =?us-ascii?Q?EXW4S/ZlbPdv7K8HR+E5GXvN2nR64nUtLEXu1zHbpQtNG/6b6MmkBPAQVHOJ?=
 =?us-ascii?Q?+FClurw04hdkfy1gCdDt7vFakkpSYdkwTfm0Irm/bCObQRlo/9jXlLyPA4lj?=
 =?us-ascii?Q?MJoO5szS1XhW8x6hI5dKlzOen3D1g1QNCa3GoED/1uwdjBAjJvCFPrfT4J7K?=
 =?us-ascii?Q?PTD+Nsvj9H/6C8z1T3gJXYjO7HBO6NV46MO2zlFrfF9F0C8/YdeGocGV5hvT?=
 =?us-ascii?Q?BYUGJTug96o6aQqjuFIRNvBkHLxhQLWppxS2clwiwbw14qPQ7rI9RLFkRgQ3?=
 =?us-ascii?Q?aA1Odq1wX7DAASvJZQosFE+JOf6PQW+AWpudN7Rt2whBPm4R65BXr/Gf9Dez?=
 =?us-ascii?Q?njRv8r19QBzJWboqj3yp3wXUTVxKaVM+6IP1uHH9v7bPVZY/EEQ4nos0ZYln?=
 =?us-ascii?Q?2n3RZxFaN9y5WynEFnjVRqaUQdqlIcIs792EcrgmlEMQsMzK9pArsUHGi1Em?=
 =?us-ascii?Q?Dd5FWxLJijJ9j7UhEwUeZumbRTIrBq9n66AaiDAepOkyUaxOBT5IZkOScQoA?=
 =?us-ascii?Q?IB3FTLkZXdTpWtt+59yxhWdy7I5Yu06r2oXcrCUcszsEjJM92HXCzYWVNNqN?=
 =?us-ascii?Q?MIE2OHAN1CVYRAOO969nX4VwUKS3+rLn0NpHSi3OSj0ZZxmDQMKfaylHwmnm?=
 =?us-ascii?Q?Tzv+D0bls0etRBS6BeNNU+ewJaC5Qf7ItakrK7q4H6UPe00hb+5ElUCmx6AS?=
 =?us-ascii?Q?ZkQKDeG4p7deY7ah9QTNmKJenRJpWYOLr4OCJTU18f44q46e36aRS4CUPi30?=
 =?us-ascii?Q?SYWAUXzbq3VYlxEEskYHtMkYXWU/sxA7N80vgLXu12bq1ML61IK0BgHa1BX9?=
 =?us-ascii?Q?hNVlkM+wcVRuCYgkY9eHmIjX6kig0ZrrZpO6kcIbBUOk3vhevxFw7zbkirdH?=
 =?us-ascii?Q?t0j04+MgYZ+CpsV5SXiCnB4JF40DvIGDwkcGR5Zp?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d79b2d-ff88-471a-013c-08dc7583858c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 08:38:12.1436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ul+BgK+4NTI/W//Y/WMuHoGmRNIYoDMn5/7WcMIPHmDH0kxxnOZz/frQY2rs/CUyn+8xzIlA7YCCqFdKdWrCiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7417
X-OriginatorOrg: intel.com

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Thursday, May 16, 2024 10:33 AM
>=20
> On Wed, May 15, 2024 at 05:43:04PM -0300, Jason Gunthorpe wrote:
> > On Wed, May 15, 2024 at 03:06:36PM +0800, Yan Zhao wrote:
> >
> > > > So it has to be calculated on closer to a page by page basis (reall=
y a
> > > > span by span basis) if flushing of that span is needed based on whe=
re
> > > > the pages came from. Only pages that came from a hwpt that is
> > > > non-coherent can skip the flushing.
> > > Is area by area basis also good?
> > > Isn't an area either not mapped to any domain or mapped into all
> domains?
> >
> > Yes, this is what the span iterator turns into in the background, it
> > goes area by area to cover things.
> >
> > > But, yes, considering the limited number of non-coherent domains, it
> appears
> > > more robust and clean to always flush for non-coherent domain in
> > > iopt_area_fill_domain().
> > > It eliminates the need to decide whether to retain the area flag duri=
ng a
> split.
> >
> > And flush for pin user pages, so you basically always flush because
> > you can't tell where the pages came from.
> As a summary, do you think it's good to flush in below way?
>=20
> 1. in iopt_area_fill_domains(), flush before mapping a page into domains
> when
>    iopt->noncoherent_domain_cnt > 0, no matter where the page is from.
>    Record cache_flush_required in pages for unpin.
> 2. in iopt_area_fill_domain(), pass in hwpt to check domain non-coherency=
.
>    flush before mapping a page into a non-coherent domain, no matter wher=
e
> the
>    page is from.
>    Record cache_flush_required in pages for unpin.
> 3. in batch_unpin(), flush if pages->cache_flush_required before
>    unpin_user_pages.

so above suggests a sequence similar to vfio_type1 does?

