Return-Path: <kvm+bounces-30895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54CBF9BE303
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:48:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1126E284DF2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A3C1DAC92;
	Wed,  6 Nov 2024 09:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C8+nhNFr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 215233211
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730886496; cv=fail; b=SQ5Uak6Exgiw8xL49AxW1BV6QUqhg880Xe96BbyEBegrqTHfi+PYw27aCkVOjy9tpcL7XQM11pTM+8Nv1OxwoOlzTrt2aByLUBw+O04AhPuilkJuUxuCvAxe9t/COwVmWDKDBpuGOBEA3wmpHS/Tq0LOIlaP1H7NALeHJYDG+Dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730886496; c=relaxed/simple;
	bh=KeJXxp0Vh7Spd2sy4RdKKXB5RIpWyFhKmvwP2QHBzzA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IJhvZb0QSJ7bMSJLidFtDTK292wKVuh4vMdO9eWSH55oy3JHjqutGvnLOq9qhhPgynt3iETpcndi7xsVj/DUDMJrlXivGXLmYPm3tU1dqrDLkczuDmnNqOw9U+qNji9QKUQVcsllHqOXiYduhDDp1olEiLhjE7OgIUyas1Wi0M4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C8+nhNFr; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730886495; x=1762422495;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KeJXxp0Vh7Spd2sy4RdKKXB5RIpWyFhKmvwP2QHBzzA=;
  b=C8+nhNFrpfkueNRqzEfkNHMI1UWYvfdCdBJL3DhFNskUt2/k3wWF+fR1
   Jm2tNpfbAqvPBeZnIirVLbOysLBrA4jd+7MUQCPTeYoU1M2ml8VQikRFX
   WR6/FlhafPvDn7rnTSUp4zl+8XxRugFV6Yi3cpVvI+2Q2ERYMgPv9PkNF
   zjCKiA9JyKW9RtKqqhVyFw5fwSihiGPO9M+EF9nWG0Hid7zHveP47Ocfd
   D4x6MZ/uANdtwu7ATfFtEkedFG6yTETFu3u3ipA5qdnMpcBvux2B+2haM
   I8uUxFVOoq1kEyVd5OOYZ2AWhFt9TiuP8BNakUIddkpyFVsYNovBtdhmQ
   Q==;
X-CSE-ConnectionGUID: nkcZNP+eRGSljUI6R0377A==
X-CSE-MsgGUID: 0nbNvEoETTe0D9qR4Bs9EA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30855935"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30855935"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 01:48:15 -0800
X-CSE-ConnectionGUID: qr8rKHPBTZuGWZjblFnUpA==
X-CSE-MsgGUID: nTfxDypEQKKXp1Sz58u+YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84587513"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 01:48:14 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 01:48:14 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 01:48:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 01:48:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+1QrjcXmItwClZZyHSifIje6/HgIzOuyCbSrBpP6/oztslPocUwfrNQV3Lhls41XchZGH5T8Nivyryq8gLMIz3tKee0rSsdagRp+COHejLRKXVqffGrbV00m7F/xB1JXJCylKRz6/vLQuJ15hj3F58F7FWQ/k342oQdIeLxTT/tiBGW3xhidnxgPKo346/8HqWP6m9e+SZIhYM07g+tXfL8JUAtWVcl5wXnR1dZNrj291LeWEt8z8ZUm+nqnH3viD+H5i/1cCSAtRX3PTn69/6H9ywA3mCf7kWptd7rpl5YvLCkQquN0HSf9dp7moGYDPg1YYlAGDtp4cBz7eCmQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KeJXxp0Vh7Spd2sy4RdKKXB5RIpWyFhKmvwP2QHBzzA=;
 b=tdG4soEvwfMIC0m0nXMyIauc4VgaCnuZMsDmRdgwpMQKxsN2dYFlgRdlBKg6ZPx3hcr2rGVPkgOAWgZE6AWyJ8FFXoJGRiOsDiEPuVdMVmbKFuam5ge4/VN1mvYUk/cTynDZM1gU8w+K4Ff57M2AQJKp9JcPJpN7xqJZM+LRS0rLA4Xu09t/hO0hjf+UjwcjiSj6NYGlJtp8gc4xvi/AOf/LO80rCmzeM4fbIrWtrc3L6PwhrfQiRFiD7jdPOTE08dYL4Sc9iW2ZsaXAp7n+qHQM2uov1cxwH00eLqUg3gW+gsicQzT5lR6S71dH/uBkZFIYyoK3sNHbCCQlne5MAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB6173.namprd11.prod.outlook.com (2603:10b6:8:9b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Wed, 6 Nov
 2024 09:48:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:48:06 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 03/13] iommu/vt-d: Refactor the pasid setup helpers
Thread-Topic: [PATCH v4 03/13] iommu/vt-d: Refactor the pasid setup helpers
Thread-Index: AQHbLrwa9EFYQit3aUKvMmAWrrsQqrKp2PMwgAAkfoCAAAWcEA==
Date: Wed, 6 Nov 2024 09:48:06 +0000
Message-ID: <BN9PR11MB5276444C7430DE54634483A08C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-4-yi.l.liu@intel.com>
 <BN9PR11MB5276A33DEC84EE55B4E6DA9D8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f6acf1f7-ec6a-4e70-859b-a562327a176b@intel.com>
In-Reply-To: <f6acf1f7-ec6a-4e70-859b-a562327a176b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB6173:EE_
x-ms-office365-filtering-correlation-id: 1dec2ae9-80a9-49f4-11e9-08dcfe481d2e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VFZ5NlBZbktQblM0TXNuV01KSmhFUFlJRENhNlNxSFdPVDZlOTR1YzlzWEZm?=
 =?utf-8?B?V3YzZCtmN2Z5dkllRkVjVWN4aFh0Umhud3lKUEtxUkJtTDFubkxnSmR5c3Rx?=
 =?utf-8?B?MVd5ckVaRi9yUkhlNnBGRjV0RkE0K1k4UzJOTWNWM1ZFdHZ4bjJ4bVYrdmhi?=
 =?utf-8?B?bklyS1ZGZjdkL2tpVmxSN2ZFUmhRUWlvVFFYVUFkS1BBTHY0ZGkyczBrSFdK?=
 =?utf-8?B?TWJ2Z3YyOGNGenVoWXlOdVl2ZVhjd3ZhS3JuV2lDUEl0OUxwQnFkNWhNNlp6?=
 =?utf-8?B?RUNWcFVrTlhicFJWVmRkMW1Zd1U0ZDVzd05EVm1OM0ZJcnhId3RaYlNqQWs3?=
 =?utf-8?B?TytvVUJiYVZIM1BjVVhiV09lQ1dxb1hQN1U3ZmZTV1J6MnA4ejVudnJCT3cy?=
 =?utf-8?B?ZEYyRUt4bDhLaU9EUEtSQUk3UzRpQmw4K1o2ZXp2WmxBcUVHYWNyOEt6dnNR?=
 =?utf-8?B?ajNOREZraHB3aW0zYmg3andIT0tqK2hjN2ZPQzN0K3Mrb1krNElKYWM2bTFs?=
 =?utf-8?B?S2ZkY2ZKYWd5ZmpEcUY3WDJPRDdRblR1T3F2ZmVDOGRKdVRmZkZHU1h4ZTBl?=
 =?utf-8?B?c1NVdjhiSytYc1ZWdzBJdlkzUWZPMXpwak9yREdWN2gxcXQxM212b0tiUXJW?=
 =?utf-8?B?OEg3aW5uWkVSUWdvdUhCNnhDb3NGdEpaWmNFdlI3M0J4Z0ljRTZNZUZ6UGV4?=
 =?utf-8?B?YjlXcXRuNktUb0hmRnBzZ0dLaU1rSGZVa3RPZWFoMlNMK1VZWkRSL1NabVNF?=
 =?utf-8?B?YnIzTHU0Mmlnb0FpbXhGTXlCV1RlK3R5dHR0RW51SW5QTkpkZEtnYy8yYWNN?=
 =?utf-8?B?WTlpUnFBY3FxSHhkOUdvK3dScjA2ZWJTQVVSU25OenducUVBdlh5aHhaL0hS?=
 =?utf-8?B?dHZQV1dGWGNIL1BlRFlKd1FZUDd0dVFZOU5zbzROc2F3L2JYRlpQZkY4VC8r?=
 =?utf-8?B?RG96a0dpNVFYaWdockNTdmJiZU5sQm1xdHNVaG40Q3g1YUNEeG4rTHl6ZXNC?=
 =?utf-8?B?U3hja3VYV0owdDRCVEJ6UGltbG5xMUlHZUsxSjdRU05HVUNHM05xejVWcWdz?=
 =?utf-8?B?dCswMm5raXphNXYvYTFjdnpSV1ZWd1JpNm9tRTZ5VG1kVjZ4dVlCWGR6Z0lY?=
 =?utf-8?B?dk9BTUFibEtCelBNbjA5N2pZNVR1dS9HVjU4UFVsVWxYMlAxQzlGOXNya1Fw?=
 =?utf-8?B?QlIwZ0k0QXFDcTFOMlRRNzFqM0pENE13aVBFSjljMzkyWVV5V1NCZll2VXBj?=
 =?utf-8?B?ZTQ0aHhrVnhNTHQraXR0cXRsbzhqQTZ1L0prS3p0eUdpR1BOYlB5L29iRzlw?=
 =?utf-8?B?YTV0NGlmaXNJT2daV1dyZ2JBRlVaTGhzNVlQVVZSdFhqRCtMY1lnOEU0d01L?=
 =?utf-8?B?NVQyMzF2c3RiZWoxL2JOV2R0d3ROZm53Y3pweVdUaUpGRXdsNGtmWit2Q294?=
 =?utf-8?B?NnRUT0FMNXJmZkJwV3lVZmlCWGg1N080RklQWUJPbC9sNy90Q2dMbmNhaUZH?=
 =?utf-8?B?Nlk1VFJIVGxUS1orOUVReTRJZnNuSmczVGlFNjBjODdubVJ5OFJsc0RFa0JW?=
 =?utf-8?B?U3dGT2RlMEJrcGxZYjRuMElJUFlISnJxSlZocC9UM0Q5WmlaR04rTC82d09K?=
 =?utf-8?B?bHltc25TM2RWcnVWVU42RkI0eDdrWFQrdDYwaUVYN25wblg1RnFtaFU0R2pN?=
 =?utf-8?B?N0h3ZHU5bUg3M1JDZVpZNzladjhId3JSTlFyV2pNUzU3eDFlekxpZTBLdnNK?=
 =?utf-8?B?bC9VRkN3SVlNcWJkcDRzNWJGMzRlVmZwRDFnVU5PU0Rua09wV2lMbzNtUVlX?=
 =?utf-8?Q?JykyOrPCqnFHJZH/aXbDnG4ER3pl+6FVWfRbg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzM2NEMxdHJZbWhCSVFWLyszeFlLODhyWkNNWUVuRDFFczJwZE9BTkpjbDQ2?=
 =?utf-8?B?NS9CYVdHSlZyTW1zOWR2S3YzL0pSNERXajNWNkZEbnFHYTZkMldPOGNpUXJt?=
 =?utf-8?B?UEpONUFrZUtWRTRJMGhXU1lJVStsR2h4NW4rS3BUc3l4Zys0czdYR0JzRVV5?=
 =?utf-8?B?SnQvR21Mei9CUU9GcWQzZ2pHRDZqV0oxNVJuRHpFdjdsSDJ2UStSWHZLU1lR?=
 =?utf-8?B?MWowTEIzM1Z6RHo4NldjYWQ1TEdNeHpKYWlROHFqSExZRnBIRU1QTUxkZERw?=
 =?utf-8?B?TmF0WHVRWjhmay82dlBnUjBIVEMvVFcweGo0d1E0Q3VlNkl2WWE0bjF4bVFa?=
 =?utf-8?B?cDBlckxWWEhxVUpJaWxKWkNQY1NZL0ZKSFQ5c1VUZnQvbTdaRTZZWlpNZTFJ?=
 =?utf-8?B?ejJXTmFSZktuYVlJdnE1UGVUZU9HVW9GcEc0K05uNll2ZUltaWNZRi9mdlpu?=
 =?utf-8?B?WFhQYVpyZjR6RlY5RVdIZ2pYMWFnOUxicTIvN3JSdFcxWkZHU1ZwbDgvQWVK?=
 =?utf-8?B?eDIrZG11REpuSmtjcmNSZ01hREJSRWd2RHZWTDkxdWtSVE9ORlJjSVRMMFlh?=
 =?utf-8?B?Z29ZV1R4N0VyU1FRZ1Rhai9HQmx3M2c5eUFqZWtLODhJL0J5VmxxVHJtTGtZ?=
 =?utf-8?B?c2JsSFZoaFlocXlicEFrcDNlUFN1ckxxWDJTRVplaEROYmhIUlEzaFAraUlj?=
 =?utf-8?B?ZzBIOVR6RThOTkwwYzNLTXNKKzkzN3gxaWpqbG9LbG1WZ1oxVUgvTVFNUmJR?=
 =?utf-8?B?U1NrVlRCVlZVQmNRWExubzBoL0hITFRwMVcveXh6bmh4cDdDUGs5aXJlSlVU?=
 =?utf-8?B?Q2thd3RmeVoycUVNVTJqZ3hXWWRtMlNPQS8zOWZ2eXJidHlMb2hwbS9KNGUz?=
 =?utf-8?B?ZUdiOVBXUm5nZmNVeFB4TUptdm5ab2VTZkl0OGlxbFJhUzFMVmtEWE5RK2NB?=
 =?utf-8?B?YW00ZGF1R09GQ1JFM2lvRGplb3F2QzFwTGxCLzdMV1dNRnhnKzhvZzZwaERK?=
 =?utf-8?B?SzltQll3UGNxa0VtUnlRRlBVWGw2VEhzQTNpak55NGYrQnB2MWxVTUtST1E3?=
 =?utf-8?B?NlJtZUZLNC84bGVMRFUxYnoxUWw4eXlPMEhpOFRhQldSSStFbDJ1SXZadS9M?=
 =?utf-8?B?emJ0VWpLOVVCbFpiMlF4UEYxcWpkNUNCWWtJdGsyKzgyYjdQZkdNd1dxM1Nn?=
 =?utf-8?B?MkRCekQ3bTFneFdoLy90cXRqaHZpNUZKSGMvcXdVZHc2WE5UV2kxdmhtOE9m?=
 =?utf-8?B?L3pJMHRscHdqclAzeXRyM1NkTjNBZGZGdTR4ekFibWtEZDBKSlZlb1dra25h?=
 =?utf-8?B?TER3K3J2MWNVTW5KVzZOS0FOK2hTeE9oRkFBWTlIUXJGdkh6QXRyRzYzUzN0?=
 =?utf-8?B?cEpRd0Z0TlNGd1gwdVpYd2M2ZXdBRmFrMmZTdlcrYW0vT2JIUTdBYzFDMG5B?=
 =?utf-8?B?RUR1RmZ1cFlKUmRyV2FTY2lSNjlpMWxEd2lXUlAxZU02VnpHMzg5dVZpQkRR?=
 =?utf-8?B?bjl1bDBJSHRYb0ZrcHBDYWJqM1lWVHhZUm4zY3ZoUUwvWjRkTFI3RVEzWFRC?=
 =?utf-8?B?K2FMd2dIbjExa0d4eGZha2ZlOEROaUIrVmNVREE0R0ltYWJqT1M4RDM4dXpG?=
 =?utf-8?B?cU1XY1djWkFVSG5BcnNNVWM1KzNZQ0t0ekp0MG9TQzIwUUs0LzBabUJTZVRh?=
 =?utf-8?B?QUdyZmlRbDl5SnR3MHRrMld2MENlajVIK2I3U001cFJ6Nmtac2FiZGx6TVZ4?=
 =?utf-8?B?djBiWTI4VTI0c0RQTDNJcG1OaFJTdEhKYzBxMmhpVkhvU2NjZVNkNzNoS0I0?=
 =?utf-8?B?cmo0SFY0Yy85N1lPMFdHWXRWSE5JaWRSVzFueC9hTHlUS3NicDBsNWgrQ3da?=
 =?utf-8?B?dEREaFpRa2xOb21mUHF4RHZRWFU1K1h4SFZrQXZMNHRwYWk1bTR6L2FKSFlw?=
 =?utf-8?B?bmZqWkE0VGV6RWFzbW1Vc3A3ci9nbFd3dThDdC9CVjZKejlWcHIxaDlGTnYx?=
 =?utf-8?B?N0drOXE3dDZlaXZtRlBPUHV1REppZlM3bEgvVTc1UnlOU1VYcGlUWkJzcm43?=
 =?utf-8?B?eHJUWDBhWnNFYUdUeEU1azFGbWs2WjFRY0hOemtpR3l5UlBTejA5eEF5NWk5?=
 =?utf-8?Q?ixUQhzBjr2CwxmJXZM3nclPxH?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dec2ae9-80a9-49f4-11e9-08dcfe481d2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 09:48:06.0323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uSlNC8mwDqDSA/k8D4/ViNRdq9XuoeADES4da1JxejZqFQxnlJ7eM/zwM4d+IBsh3JZrflXYfqUTX2l9itiYyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6173
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBOb3ZlbWJlciA2LCAyMDI0IDU6MjMgUE0NCj4gDQo+IE9uIDIwMjQvMTEvNiAxNToxNCwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29t
Pg0KPiA+PiBTZW50OiBNb25kYXksIE5vdmVtYmVyIDQsIDIwMjQgOToxOSBQTQ0KPiA+Pg0KPiA+
PiBBcyBpb21tdSBkcml2ZXIgaXMgZ29pbmcgdG8gc3VwcG9ydCBwYXNpZCByZXBsYWNlbWVudCwg
dGhlIG5ldyBwYXNpZA0KPiA+PiByZXBsYWNlDQo+ID4+IGhlbHBlcnMgbmVlZCB0byBjb25maWcg
dGhlIHBhc2lkIGVudHJ5IGFzIHdlbGwuIEhlbmNlLCB0aGVyZSBhcmUgcXVpdGUgYQ0KPiBmZXcN
Cj4gPj4gY29kZSB0byBiZSBzaGFyZWQgd2l0aCBleGlzdGluZyBwYXNpZCBzZXR1cCBoZWxwZXJz
LiBUaGlzIG1vdmVzIHRoZSBwYXNpZA0KPiA+PiBjb25maWcgY29kZXMgaW50byBoZWxwZXJzIHdo
aWNoIGNhbiBiZSB1c2VkIGJ5IGV4aXN0aW5nIHBhc2lkIHNldHVwDQo+IGhlbHBlcnMNCj4gPj4g
YW5kIHRoZSBmdXR1cmUgbmV3IHBhc2lkIHJlcGxhY2UgaGVscGVycy4NCj4gPg0KPiA+IGhtbSBw
cm9iYWJseSB5b3UgY2FuIGFkZCBhIGxpbmsgdG8gdGhlIGRpc2N1c3Npb24gd2hpY2ggc3VnZ2Vz
dGVkDQo+ID4gdG8gaGF2ZSBzZXBhcmF0ZSByZXBsYWNlL3NldHVwIGhlbHBlcnMuIEl0J3Mgbm90
IGludHVpdGl2ZSB0byByZXF1aXJlDQo+ID4gdGhpcyBpZiBqdXN0IHRhbGtpbmcgYWJvdXQgInRv
IHN1cHBvcnQgcGFzaWQgcmVwbGFjZW1lbnQiDQo+IA0KPiB0aGlzIGNhbWUgZnJvbSB0aGUgb2Zm
bGluZSBjaGF0IHdpdGggQmFvbHUuIEhlIHNoYXJlZCB0aGlzIGlkZWEgdG8gbWUNCj4gYW5kIGl0
IG1ha2VzIHNlbnNlIHRoYXQgd2UgdXNlIHBhc2lkIHJlcGxhY2UgaGVscGVycyBpbnN0ZWFkIG9m
IGV4dGVuZGluZw0KPiB0aGUgc2V0dXAgaGVscGVycy4gSG93IGFib3V0Og0KPiANCj4gVGhpcyBk
cml2ZXIgaXMgZ29pbmcgdG8gc3VwcG9ydCBwYXNpZCByZXBsYWNlbWVudC4gQSBjaG9pY2UgaXMg
dG8gZXh0ZW5kDQo+IHRoZSBleGlzdGluZyBwYXNpZCBzZXR1cCBoZWxwZXJzIHdoaWNoIGlzIGZv
ciBjcmVhdGluZyBhIHBhc2lkIGVudHJ5Lg0KPiBIb3dldmVyLCBpdCBtaWdodCBjaGFuZ2Ugc29t
ZSBhc3N1bXB0aW9uIG9uIHRoZSBzZXR1cCBoZWxwZXJzLiBTbyBhZGRpbmcNCj4gc2VwYXJhdGUg
cGFzaWQgcmVwbGFjZSBoZWxwZXJzIGlzIGNob3Nlbi4gVGhlbiB3ZSBuZWVkIHRvIHNwbGl0IHRo
ZSBjb21tb24NCj4gY29kZSB0aGF0IG1hbmlwdWxhdGUgdGhlIHBhc2lkIGVudHJ5IG91dCBmcm9t
IHRoZSBzZXR1cCBoZWxwZXJzLCBoZW5jZSBpdA0KPiBjYW4gYmUgdXNlZCBieSB0aGUgcmVwbGFj
ZSBoZWxwZXJzIGFzIHdlbGwuDQo+IA0KDQpKdXN0IHB1dCBpdCBzaW1wbGUgZS5nLiAiSXQgaXMg
Y2xlYXJlciB0byBoYXZlIGEgbmV3IHNldCBvZiBwYXNpZA0KcmVwbGFjZW1lbnQgaGVscGVycyBv
dGhlciB0aGFuIGV4dGVuZGluZyB0aGUgZXhpc3Rpbmcgb25lcw0KdG8gY292ZXIgYm90aCBpbml0
aWFsIHNldHVwIGFuZCByZXBsYWNlbWVudC4gVGhlbiBhYnN0cmFjdCBvdXQgDQpjb21tb24gY29k
ZSBmb3IgbWFuaXB1bGF0aW5nIHRoZSBwYXNpZCBlbnRyeSBhcyBwcmVwYXJhdGlvbi4iDQo=

