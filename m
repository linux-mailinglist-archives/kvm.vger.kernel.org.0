Return-Path: <kvm+bounces-30894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76AA99BE2DD
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:41:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3670A281F8D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950F51DA624;
	Wed,  6 Nov 2024 09:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="anQBYPSv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA27F1D2B1A
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730886088; cv=fail; b=ujsoO2Ukg9BMq1UYCJY5WZBtzpJUqvbQon9w3ilMfvw8QvfV8mSZZqBayeVVL1SB4x2Y8RUP8Arqt/h72EVhlJKkyREdskpyrvjYSgjaaAF5QVZe1jAKfhdJulu+2clSWFyHWoDA1MEdW5j2g8absNYP6VRhKfF/4wSEEv5IH0Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730886088; c=relaxed/simple;
	bh=Ba3heUgPnNcWYAarZdjDU8WRtLK7fCRu0P6pd7VWS7g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jcNcrY60p1fgQzwDG/DCK/B7lgd0BpTBQav4xRIbh0coS0suJZNx+ii157Ufqxx6dsEAK7ReU/jLsHcnM75bn8FgRfiO5z9A2W/TBw4SkBHH9dn85FZ61f1Ek24KSWATKOzwdk0C/BLpFnSi9hFVH4Xa92cAquR9dvCL7vE/Q2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=anQBYPSv; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730886087; x=1762422087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ba3heUgPnNcWYAarZdjDU8WRtLK7fCRu0P6pd7VWS7g=;
  b=anQBYPSvzzYdca48fHS7+YrpsfagDjQtGuN2HhF78Lu22b5V17nxQsBj
   x4IHRlgVO6pp7/uz2T8lSx37jCeLUybOx+E7Rh5TdCxtOdVOPUFDmx+Hx
   atmJcnC6dx0DTc4D7W3AVuHlzn4qXcbYFQtbju7zGmNG/vwEhyQs9XLPo
   /fq6/uzcrJrj052ScxTzAuhFBAk3aXZQ0yRs2I/oMZFe2my5BWYnSvePE
   44CK3/G4+jzCSqNmTnoruaVYfyG5ISGVN65uUFYMcmkmks8M4eyazHugm
   ZkkKA4e8UhO9NrY9FoK1QBhajkgmH/hObHmw4yI281wno9+pR1tpm/u6J
   w==;
X-CSE-ConnectionGUID: bkG1KC5rQjuWPYz0IQtXCQ==
X-CSE-MsgGUID: Lpg2nA+2S8SajuYcMP9WxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41776179"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41776179"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 01:41:27 -0800
X-CSE-ConnectionGUID: 83MSJERmSnKCcF2dS0Sp1Q==
X-CSE-MsgGUID: +zJ78ZYmRSKO55+goZGgog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="121952393"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 01:40:56 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 01:40:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 01:40:55 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 01:40:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PaEkZ464BtMlYZOiTx3l/kRTilMUu5Zmo9Hx6OlpzbbvLMM/G1uEIDVTIjdeSehy3KrOAhq2Wqo0d+Ax0yv7ZeeiyE46fyZA5NdtJi4xP+x0tYgOWWJxjAVMOx2hZ1wATnJC6LG69YQX/CgyHKFeOBNHdZIz45Xj4FklzhmZz2XhWHyxKYkC84Wc/hmEZBT28PlEd1Q4WHShbL+fs/bvHZzH0mZkN9vK3+GVpXIig2ZDp0xzAqzpeWj0fMFae4D29IldBcif3LUStp+ENpbC5X6ilXeN0UyRMEDW6Z36N7PQZixGYn4M2okZrnse0nNkBdr/G+rnA0THQ9ozaHrL5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ba3heUgPnNcWYAarZdjDU8WRtLK7fCRu0P6pd7VWS7g=;
 b=ar/9RlWzwZJY/dKSXZivB4qXV2iHvui2zGwoWAfHLE+9815k1MwH97Ly26j9o6NQjloQq8TBhbv7B+rO2c36FLCj5UoaR9811gwCN3HqKUujpdrJrxU9l0niUs1yhjciJslnzIstMPjiEcCUteivecnR/WzCy4V/HFHsuxrtUea5MhJ2RRiPBh/DURQbMC9cmMbZZwaWoajDzRqPw0v/v9v0ZNeoS5x9H1s5DGX7K7KwVse1Dbr650WxiOXZA47xAeFjCL2kcjD1Auie5GF4Gk3yxSlv2LD7bBQ8dkOjKasmuZmLAccVzCYqRYsnZCMePORa3w79oaaNGJCFxPzZVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 09:40:53 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:40:53 +0000
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
Subject: RE: [PATCH v4 02/13] iommu/vt-d: Add a helper to flush cache for
 updating present pasid entry
Thread-Topic: [PATCH v4 02/13] iommu/vt-d: Add a helper to flush cache for
 updating present pasid entry
Thread-Index: AQHbLrwctIjgbShWBEe3vvkahqtBGLKp111AgAAbtoCAAA6R0A==
Date: Wed, 6 Nov 2024 09:40:52 +0000
Message-ID: <BN9PR11MB5276DC217F91F706C0100A738C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-3-yi.l.liu@intel.com>
 <BN9PR11MB5276D12FF07A6066CEAAF4308C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <b6442ba7-7979-4619-8b47-87ee90792517@intel.com>
In-Reply-To: <b6442ba7-7979-4619-8b47-87ee90792517@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4952:EE_
x-ms-office365-filtering-correlation-id: 0d4659ca-6654-4f2d-1818-08dcfe471b1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZDFUVWtrY2FFaXUrMHFQaTZiNE1NNDgzakF2QklGYUFVY1FIVFd1bFlqclBt?=
 =?utf-8?B?RjNDL0pzRlV0RTEyZktEbjJOMGI3V3BLUDg1RjIrRUNSWGFRenZoZDU4SjhK?=
 =?utf-8?B?L2VKeEJzQWwybks5d0xUQ25ENUx1d0ltOU1OdHlRRHhZQjExTDhPTWxHMUEw?=
 =?utf-8?B?L2tZVHVXVkM2SWoxcWdzekhtSzExZWdVTTlRQjlVTitHY29kRFlwMXJDY2ZK?=
 =?utf-8?B?LzNFZW14bGRVY3ErTjF5UFc2aGc5L3dUVG5mRW1OUnNzdHQ3UFBma2pxd2pv?=
 =?utf-8?B?OWRDbi92Z1RtbUJWaUcvaEovZnFoZ0ZSSHFpN0poN0t5cWRabFlkc3Eyd1JS?=
 =?utf-8?B?M21teGwrUkViT2o5bk5xSzV6NEVjK01wcVhkaTlhOUlET3V3OWpCQ1hTL0dt?=
 =?utf-8?B?S2VheW5jeTNSMnoxaWthWndTc2FaR1Q4VEJPVFBTYllMSnJock0zRTJxaUIx?=
 =?utf-8?B?RjRSbFE3dVB1aXVKS3FKUFp3c3VQQmRYeFdsa1hMVzlmVUIwcUU3OGw2WE91?=
 =?utf-8?B?WXhMRk9OYWVsbk9qMjNpUE9MT0IvbURIOHFqcjdjc1JYNjBaOFYrY2NhNVRy?=
 =?utf-8?B?dnBzZnlvNXpFOEJ2S1o2aVRHWmYyNkdudTF4bnlpaHhlOWsvY0VYZ3RaMmhO?=
 =?utf-8?B?Nm80TGNSRVJnRzJML2ZYSDFkdWtqd2NKNUY4alVIWDE3dWxLb0JEMDc0R3lC?=
 =?utf-8?B?RjFFNlJ4a1ZGWDNvZTNwR0UwSGVwNzNWVm1BWUNIY2Y5MzFHa3gwdm9rS0th?=
 =?utf-8?B?YWc4RnBMcjd4TVozbXN1bUdsVEhtenNGSWlIaUs4cWFMbERmTmhBZUpmbnVR?=
 =?utf-8?B?cEo1OVlORm1ndjVCS29vdFQvRTNKcU1UQ3FrbVVRNlNGMktnL3EwVVdmV0k3?=
 =?utf-8?B?Y1hweU1NcFFRMlV3cDh0cEFsQVc5V0ZLZFBMeEZKUG0xbnZKVnZhWUI5VUFp?=
 =?utf-8?B?TmhHZDN6UG5rRURVQnFERmVib3pvdGYrdVVCUjlMUUVsUE4vUkxuNERZYVpE?=
 =?utf-8?B?QVQzR1ByMzVtWUJxaFB5VzFLMlJHeVFiNXJmdGVkUStIVCs3bzhqUXAxa0Nm?=
 =?utf-8?B?b1pzWk9LSkJoNlF5N3NqQlJrd2tzc3FYMFBvL3c1MGNic2ExRS9paWtLU1l5?=
 =?utf-8?B?clJQekduNXNiVXZFY0dSdnN1WCtldjZleDAyTzRkOE9ZTmI4MWpkTVQ0S0ZM?=
 =?utf-8?B?ZUd4QkhpV0pYc2tCeE1TTHpGWEJBSzNXcEI2d3NrSU5lQjJ5cm5RbWZiTXZl?=
 =?utf-8?B?KzZtbnF3bVkrcHhPaVVrdzU1KzAxMTRYQm9hRVJFRWRZYmhBNndmWWxEVUUr?=
 =?utf-8?B?MHZHT1pUTFo4bit5eUF2ang1UkhWTkpJRVhmZGNjaUZKeGt2VmpLVTBwNjhU?=
 =?utf-8?B?a1gzWktKa25ZTXhmeWpaeXZiWGM1U3RaQ3pCWGRocmFOOVNnc3FFUDFtSThz?=
 =?utf-8?B?WUJacXRJMnE3cFMyTFVpWjFYS2t4U0hWdlJWamJlSWtyc2pBWHhnOXdXVDlz?=
 =?utf-8?B?c1Fjb1p3TTNsZUttY2lxYUFVUWJOeE9Za0NnS3BuYkw1Lzl1MStkamxxZWc5?=
 =?utf-8?B?M1Rkck1oYnhESVRiSnNqeWs1Myt0ZHphWlpBT1BMdWNBamdwajM5aWFvU3Y4?=
 =?utf-8?B?b0N4YkUyM0d6Q1Y5RnJIRmZBNkh3UjhDeGhtRURyMGl2MG5pT1RrM2trd3BS?=
 =?utf-8?B?anR3aEdLcG95bWtXaVc1NVg5SGpSOG5nLzhCdWRVM2l4b1JlZzZsV1B6aWpY?=
 =?utf-8?B?WHNtWEtIQ0tIMnc3WnRuSVB6VHY3dG93V2Z1K3plK2Fzai90OENwcHd6MUJM?=
 =?utf-8?Q?OMO/dCyRICdT2KR1yK2usQ3oifTdTfHYmYyfc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djJxMkRocHJTTmFlOG9aWUdrVkRhbUNiTUc2S1VyNmdRNzU3Z0cyeE50dGNF?=
 =?utf-8?B?RytUaUNZa3l2M2ozWXdudWhGT29wRW5zN2hXNHVlVi9lVGlNUDJ2L1hJZnFw?=
 =?utf-8?B?Sjc1Si9QMDBLRlhnYzdBYk5HbEpBMGRyUzAxYWdHL0pVRWhSTW5uSjNyb2Ju?=
 =?utf-8?B?UHNkUERhZVZ4Mjkzay9oYy9sZzJzNXhyTTlYT2J3MkZQbFUxdmp6VjR0dEd1?=
 =?utf-8?B?L0Z2TFhCRHExandqWkFtZVYvYmNXWnh2Smk5dUU4M2dsMGtnWjFNZVlwVVNH?=
 =?utf-8?B?bThvVGZuZGJha2pnTzVwTnordUZ6OVJic09QZE92cW0vM2tpUytleGJJR3E5?=
 =?utf-8?B?QUpIS0didmNZdCtPcG1zVy9kelU5cE5BV3hqeHFTdjltaVpRNHRhcHArR0g3?=
 =?utf-8?B?T2pkSGtvT2RCRHNtRlZ1NFNQQTFPQ3hRaEJqbWRMY1ptbXgwNFdtaTQ4S0k0?=
 =?utf-8?B?S05SUnE5Z1B0MjljeW94RmwwUGd1dFhsR3hOVmxrUDZBQ09oKzNzSDJ3T1NB?=
 =?utf-8?B?ODF5WXA5R3VvbkFKSEhXOHZmVkJXRWtmTngrVDQzZCtIZlhrcDZZNzhkVHFT?=
 =?utf-8?B?QmxxYUx2NkdLcEw3bnBqcTdJTUdwOHA4Ui83d0E1ZjIwMW1sWHlORkFQV2Jj?=
 =?utf-8?B?ZmJCSmNIWmQyV3cwMnQwSXYzMDViZnNLMWQ3dWdleG1VbDRMTEFEbjdIdFZY?=
 =?utf-8?B?UmJLbXpKQXNEdHJhV1FwT0hMN1FYdVpPVWRzNDhTcHRmSnJ6UFNOa1c1bnNn?=
 =?utf-8?B?OGhielB6UnZKT00yZnhKNjVubU4yT3ZrYVV1Tjd0anZ3Ni9XWnAxNzZDdmx2?=
 =?utf-8?B?RHozbnR0bVlaQTFmUWc5SWMyb3l0NXk3SkNCbjFOY2hGTjZiUS9UZlNSSWtK?=
 =?utf-8?B?NUdLWTJVd0FlWDVQZnA4NVY1eDNaV1hMQzJvNTVhSTA0WmNhM29Keno1Vk95?=
 =?utf-8?B?eDZGQnBhZ1JDcTZBeXp6MS9mUC9La1ZYbkdMMEtZNUlwQVN2ZkpWemRyb2ZO?=
 =?utf-8?B?NjRMaXNPOHo5NEdVV1pvb0xsTWlrdnlrbnpPOGVzS2FSRUVRL2ZWR2NlSVZm?=
 =?utf-8?B?RlVBN3ZHU1JpZ2grU0FPUENLMmRoWDdtZndGTlhJc0xvcGpzcDdlRWFzVDNK?=
 =?utf-8?B?SmJ5UGlzZWV5Y29OSVhSSHhrSHkxZjN5NEY5akk0VTg2Q0ZqRXMvS1pHcVhu?=
 =?utf-8?B?MjJ0Z3J0WFhSQXBQeFBVS1lCM1BXUytLV3ZBVFNCbGZOS21FSFNiT1dBajlZ?=
 =?utf-8?B?ZVN3czc4SjNxTi9wN2lSWHRWeDcvQ2FzY01ibldvell5Ulc4d2Y0TG53d2FC?=
 =?utf-8?B?djh4Z0x6aXhjR2RXYkhudXR2ZFFUejIvUGRta2FLOUE5OTEzNjVwbjVZdncz?=
 =?utf-8?B?RGxoQS9ibzIwMTJWbjhjaVI2RUVLNUs2YWVPSUNObjJuTVVCZEk4eWpCbXh2?=
 =?utf-8?B?SG9HWGovR3lReXdIUFkyZkxTSDkxR2Jwd0ZYTlJSeFJHL1NJVVFmVTZnTkla?=
 =?utf-8?B?dk05NHJEWU9reGZGU2FvcW94NE14WjBqWnZPNm5mdTQ2bkhUcmtFMkRHVjdv?=
 =?utf-8?B?OFIzZ2lxZlIwTGVCZTgwR2NVYlVyN2xxa09UQmQzdndDQ3ZCc2pMNTNkYXR1?=
 =?utf-8?B?NlgvRFdFQm9SYW9BS1lrRVNJUVRRcVZrcjNoUWJXR29lb2dnTWhYNFFwZ3pL?=
 =?utf-8?B?eDdENFhkMnBjN1JmSEFCSmFxVWZTZ3RlS3VGY0xWcTZnWGVIRW9RUVRtUE9z?=
 =?utf-8?B?Uk9BcGJFMFVmbFNZMHYvOHR0Z1lpbWJ3SWV5ckJKOXhSMC91aUpCQVdBZG53?=
 =?utf-8?B?dGxOZ2l3VlVsTFEvY1k4ZTdWV2FwcDI0b01WVEpXUXlvUGk0QVE1bVlneVhM?=
 =?utf-8?B?dDRIOUZpVjBkRVVnY0FmcUsyOVZySTdPUHFyL0R6S3dzSEhUYzVucFBRSWNV?=
 =?utf-8?B?cEd2ZjZYVDFTZllmLzZ6c3pobDFVMVhHUVp3d3REMTJyM1JjVjRtTUtyYXlZ?=
 =?utf-8?B?U1daaTA5VUdMVVVSQ2VlbUZ1Z2Q3ZFlsZVhOeU0yYlIxTTN5REE0eERDaDRn?=
 =?utf-8?B?VWhzdmtBQXNVdU1SZlo0b0o0Q3B0VUlKTzR5bG9FR2Fib2dlSE44UU42RmVy?=
 =?utf-8?Q?8mB0A0GoXApnO+csM0gmVSprC?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d4659ca-6654-4f2d-1818-08dcfe471b1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 09:40:53.0158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uLXXGUFDRXRKlVR5ADfHLoVSOsVjSsxh/wRBs/dL07saYwAtyG0a/PQxzVZTgtJmRg8EqzdArSjoDKVaXj0DFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4952
X-OriginatorOrg: intel.com

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5
LCBOb3ZlbWJlciA2LCAyMDI0IDQ6NDYgUE0NCj4gDQo+IE9uIDIwMjQvMTEvNiAxNToxMSwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4+IEZyb206IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29t
Pg0KPiA+PiBTZW50OiBNb25kYXksIE5vdmVtYmVyIDQsIDIwMjQgOToxOSBQTQ0KPiA+Pg0KPiA+
PiBUaGVyZSBhcmUgbW9yZSBwYXRocyB0aGF0IG5lZWQgdG8gZmx1c2ggY2FjaGUgZm9yIHByZXNl
bnQgcGFzaWQgZW50cnkNCj4gPj4gYWZ0ZXIgYWRkaW5nIHBhc2lkIHJlcGxhY2VtZW50LiBIZW5j
ZSwgYWRkIGEgaGVscGVyIGZvciBpdC4gUGVyIHRoZQ0KPiA+PiBWVC1kIHNwZWMsIHRoZSBjaGFu
Z2VzIHRvIHRoZSBmaWVsZHMgb3RoZXIgdGhhbiBTU0FERSBhbmQgUCBiaXQgY2FuDQo+ID4+IHNo
YXJlIHRoZSBzYW1lIGNvZGUuIFNvIGludGVsX3Bhc2lkX3NldHVwX3BhZ2Vfc25vb3BfY29udHJv
bCgpIGlzIHRoZQ0KPiA+PiBmaXJzdCB1c2VyIG9mIHRoaXMgaGVscGVyLg0KPiA+DQo+ID4gTm8g
aHcgc3BlYyB3b3VsZCBldmVyIHRhbGsgYWJvdXQgY29kaW5nIHNoYXJpbmcgaW4gc3cgaW1wbGVt
ZW50YXRpb24uDQo+IA0KPiB5ZXMsIGl0J3MganVzdCBzdyBjaG9pY2UuDQo+IA0KPiA+IGFuZCBh
Y2NvcmRpbmcgdG8gdGhlIGZvbGxvd2luZyBjb250ZXh0IHRoZSBmYWN0IGlzIGp1c3QgdGhhdCB0
d28gZmxvd3MNCj4gPiBiZXR3ZWVuIFJJRCBhbmQgUEFTSUQgYXJlIHNpbWlsYXIgc28geW91IGRl
Y2lkZSB0byBjcmVhdGUgYSBjb21tb24NCj4gPiBoZWxwZXIgZm9yIGJvdGguDQo+IA0KPiBJJ20g
bm90IHF1aXRlIGdldHRpbmcgd2h5IFJJRCBpcyByZWxhdGVkLiBUaGlzIGlzIG9ubHkgYWJvdXQg
dGhlIGNhY2hlDQo+IGZsdXNoIHBlciBwYXNpZCBlbnRyeSB1cGRhdGluZy4NCg0KdGhlIGNvbW1l
bnQgc2F5czoNCg0KKwkgKiAtIElmIChwYXNpZCBpcyBSSURfUEFTSUQpDQorCSAqICAgIC0gR2xv
YmFsIERldmljZS1UTEIgaW52YWxpZGF0aW9uIHRvIGFmZmVjdGVkIGZ1bmN0aW9ucw0KKwkgKiAg
IEVsc2UNCisJICogICAgLSBQQVNJRC1iYXNlZCBEZXZpY2UtVExCIGludmFsaWRhdGlvbiAod2l0
aCBTPTEgYW5kDQorCSAqICAgICAgQWRkcls2MzoxMl09MHg3RkZGRkZGRl9GRkZGRikgdG8gYWZm
ZWN0ZWQgZnVuY3Rpb25zDQoNCnNvIHRoYXQgaXMgdGhlIG9ubHkgZGlmZmVyZW5jZSBiZXR3ZWVu
IHR3byBpbnZhbGlkYXRpb24gZmxvd3M/DQoNCj4gDQo+ID4+DQo+ID4+IE5vIGZ1bmN0aW9uYWwg
Y2hhbmdlIGlzIGludGVuZGVkLg0KPiA+Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBZaSBMaXUgPHlp
LmwubGl1QGludGVsLmNvbT4NCj4gPj4gLS0tDQo+ID4+ICAgZHJpdmVycy9pb21tdS9pbnRlbC9w
YXNpZC5jIHwgNTQgKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLQ0KPiA+PiAg
IDEgZmlsZSBjaGFuZ2VkLCAzNiBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlvbnMoLSkNCj4gPj4N
Cj4gPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW9tbXUvaW50ZWwvcGFzaWQuYyBiL2RyaXZlcnMv
aW9tbXUvaW50ZWwvcGFzaWQuYw0KPiA+PiBpbmRleCA5NzdjNGFjMDBjNGMuLjgxZDAzODIyMjQx
NCAxMDA2NDQNCj4gPj4gLS0tIGEvZHJpdmVycy9pb21tdS9pbnRlbC9wYXNpZC5jDQo+ID4+ICsr
KyBiL2RyaXZlcnMvaW9tbXUvaW50ZWwvcGFzaWQuYw0KPiA+PiBAQCAtMjg2LDYgKzI4Niw0MSBA
QCBzdGF0aWMgdm9pZCBwYXNpZF9mbHVzaF9jYWNoZXMoc3RydWN0DQo+IGludGVsX2lvbW11DQo+
ID4+ICppb21tdSwNCj4gPj4gICAJfQ0KPiA+PiAgIH0NCj4gPj4NCj4gPj4gKy8qDQo+ID4+ICsg
KiBUaGlzIGZ1bmN0aW9uIGlzIHN1cHBvc2VkIHRvIGJlIHVzZWQgYWZ0ZXIgY2FsbGVyIHVwZGF0
ZXMgdGhlIGZpZWxkcw0KPiA+PiArICogZXhjZXB0IGZvciB0aGUgU1NBREUgYW5kIFAgYml0IG9m
IGEgcGFzaWQgdGFibGUgZW50cnkuIEl0IGRvZXMgdGhlDQo+ID4+ICsgKiBiZWxvdzoNCj4gPj4g
KyAqIC0gRmx1c2ggY2FjaGVsaW5lIGlmIG5lZWRlZA0KPiA+PiArICogLSBGbHVzaCB0aGUgY2Fj
aGVzIHBlciB0aGUgZ3VpZGFuY2Ugb2YgVlQtZCBzcGVjIDUuMCBUYWJsZSAyOC4NCj4gPg0KPiA+
IHdoaWxlIGF0IGl0IHBsZWFzZSBhZGQgdGhlIG5hbWUgZm9yIHRoZSB0YWJsZS4NCj4gDQo+IHN1
cmUuDQo+IA0KPiA+DQo+ID4+ICsgKiAgIOKAnUd1aWRhbmNlIHRvIFNvZnR3YXJlIGZvciBJbnZh
bGlkYXRpb25z4oCcDQo+ID4+ICsgKg0KPiA+PiArICogQ2FsbGVyIG9mIGl0IHNob3VsZCBub3Qg
bW9kaWZ5IHRoZSBpbi11c2UgcGFzaWQgdGFibGUgZW50cmllcy4NCj4gPg0KPiA+IEknbSBub3Qg
c3VyZSBhYm91dCB0aGlzIHN0YXRlbWVudC4gQXMgbG9uZyBhcyB0aGUgY2hhbmdlIGRvZXNuJ3QN
Cj4gPiBpbXBhY3QgaW4tZmx5IERNQXMgaXQncyBhbHdheXMgdGhlIGNhbGxlcidzIHJpZ2h0IGZv
ciB3aGV0aGVyIHRvIGRvIGl0Lg0KPiA+DQo+ID4gYWN0dWFsbHkgYmFzZWQgb24gdGhlIG1haW4g
aW50ZW50aW9uIG9mIHN1cHBvcnRpbmcgcmVwbGFjZSBpdCdzDQo+ID4gcXVpdGUgcG9zc2libGUu
DQo+IA0KPiBUaGlzIGNvbW1lbnQgaXMgbWFpbmx5IGR1ZSB0byB0aGUgY2xmbHVzaF9jYWNoZV9y
YW5nZSgpIHdpdGhpbiB0aGlzDQo+IGhlbHBlci4gSWYgY2FsbGVyIG1vZGlmaWVzIHRoZSBwdGUg
Y29udGVudCwgaXQgd2lsbCBuZWVkIHRvIGNhbGwNCj4gdGhpcyBhZ2Fpbi4NCj4gDQoNCklzbid0
IGl0IG9idmlvdXMgYWJvdXQgdGhlIGxhdHRlciBwYXJ0Pw0K

