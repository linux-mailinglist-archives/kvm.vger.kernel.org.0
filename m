Return-Path: <kvm+bounces-17524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D9628C72EE
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 10:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A18FB1C22626
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 08:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E3714198E;
	Thu, 16 May 2024 08:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O1M2MUP4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF8E13C826;
	Thu, 16 May 2024 08:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715848466; cv=fail; b=b+POD6fqYGC+Z9aE25Yf7c6g6/V9dJTn2hHcfG3x+U5UZKEzQpn2AtwmCUk5Sq1+G1V8qz62brGnWh8RrIkq7yiqwJGaO6qWaHmUev/YUXhcNx7KC1/o8KNMTDFc2/vTqrpiaimb8PMeTFt8ab1rWqbuGNpdQiWDReh4/OL5bM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715848466; c=relaxed/simple;
	bh=QVhUqDRI1ixB436sEW1Od5suQurTifTbYW5q+thXjkM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CMikuEBtV70S8EuNPR2xpgnmtO/WdZv13tRM+IsLDNoN+2EH7rmpqYpSe9l1xJocnZ4VN5jGohultvB6fY28O6Asp5rpMEM/fZygXUgcZ8qU8zKgDtwLwxCBSqR0wmWik1Fe7cqQlU7WQczooFbS6UJcRvvqCqyMi0fnW5SheHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O1M2MUP4; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715848464; x=1747384464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QVhUqDRI1ixB436sEW1Od5suQurTifTbYW5q+thXjkM=;
  b=O1M2MUP4fibfQFz7PSdNBJdJFFE8vflS+abAb8Y7dykfbW+9whaQETiP
   jExO3moSnP7JoZfIL7cDCq74JyNO7zx+O4Lq1KstjHK96AJpah9dqS6v2
   XCxtqSNS0xjqo1lfpe0oJmg1E/+2DP2L1kfrbCMfZByEQctIuOYJSRnSk
   4uzu/cU6M3KbSKdM67BvdQV0X7tjes4c/XIxWGQCKr++x7dnD8gecbiAd
   pIsjB6/oQsr2C0UTYUUsUJd6JQHh5iyixvrxa+kH8elkqxw5DLDNtkLcD
   km2arnRo7huv8AfN22V0dw0EtfIfpuBu7XyMM13XMzCGmWmi1RyERxTbu
   Q==;
X-CSE-ConnectionGUID: dmVd8HMbTEy9Wd1rQS348w==
X-CSE-MsgGUID: gdJRq/3KRFCb/mVyrFWZdQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15767841"
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="15767841"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 01:34:23 -0700
X-CSE-ConnectionGUID: +SOGufTmSz6v0OsA+CLhNA==
X-CSE-MsgGUID: ttNmXe8JSTCkVu9bDjx89g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="36227572"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 01:34:24 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 01:34:22 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 01:34:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 01:34:22 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 01:34:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fjXWzmKqZPu5ajW9PweoChQDwzP1XiWt3LVjeudcDsLm0NjHNFiRqV4TVw6R8DXG4u5iEUfoyzrcoHR/jla4JcDpQ4jmbrVmabrO9OPA9gdXqnjrsQMWi/gWFydiiHlWaT9oCjth9LCXGBpk5tXJA5exGSLqozWl2sxrW6tjSQEduGplNRAdUkx1boEK2R2FMtjOBAlHR0BkxR/YQrD3MYWEvzyiPPt4d8iO2p/Ol6Bym7BOq4/Bvcgpv7ufCPsDBI2e/96o79a0NfTxR6kDShxItZa+5Qjfpy2op4dfAKdQKiIV9MZ3LXEM2BC2aB1y/4srU0etrOYuMqW3DA9yPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QVhUqDRI1ixB436sEW1Od5suQurTifTbYW5q+thXjkM=;
 b=c3Gbt7NIIqSG7NUKZRszU/OKaxB98JIG+jSYdLNdRGtyyO6kKRiKxK3sw2APN9bTPmEEeqcqaYVMymFf41H1sYtc1ghSvC4gooBFKO/MHG33FzZSM+xZIe+Gi7MNQnspkhS0YCqKEyVa7pJ8PRnecfePMW4ZZjt3GJfL9naCmLLwMFy2Efjc/kzldZi6hQzX5ctcb1ivfmTUpcvVpvBFrqzSnm4EIxCf22U/L+FjKzQcWZSCL5+4e4ORPKTcHR1Lg9jW3Tq5cP3I0F9uJDam47BsVzzEkgcK9VTnNQW5+VnOu6NznJGMjaVi4CNYwv/QjRAnbGP0DpQnpDAcgU2C6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7417.namprd11.prod.outlook.com (2603:10b6:806:345::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 08:34:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7587.026; Thu, 16 May 2024
 08:34:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
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
Thread-Index: AQHaoEb1yTw+2+R5T02uRFeJZuQMNbGPN+OAgAER64CAAGvrAIAEE0QAgATCszA=
Date: Thu, 16 May 2024 08:34:20 +0000
Message-ID: <BN9PR11MB52766D78684F6206121590B98CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062138.20465-1-yan.y.zhao@intel.com>
 <20240509121049.58238a6f.alex.williamson@redhat.com>
 <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
 <20240510105728.76d97bbb.alex.williamson@redhat.com>
 <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZkG9IEQwi7HG3YBk@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7417:EE_
x-ms-office365-filtering-correlation-id: 7bf5f259-2054-4249-4ade-08dc7582fb7a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?U0o4Ukt0eGpqRjhGdEV0UnVId1M2VlJVWkwvcFpiRUF1U3kxNGlScll1Zml4?=
 =?utf-8?B?ZkNpZVR5cHZoTUdIcnh2VWxhMFJMMGpxMnZvKzVSZWZZM3N5bVFyMEdNakJB?=
 =?utf-8?B?clY3WHdwLzEvTjZpS09nemtkbk00UENLb1hxNVhxOGpKL28zYVdLd1VDZk55?=
 =?utf-8?B?T2xXbTlmMEo0MWQ2YWdyZk12ZVdIVnlkQlhCWWUvZS9NWHp3NlJpZ2tQWnM3?=
 =?utf-8?B?ajVtdHg0eFAyZUE3UXEzejExVmw2d1FTeEx6UktLTkt1NVB2Nnh3TGI1NTFM?=
 =?utf-8?B?Q2xSL21GTW0venRFUVNuTjlHYlp6RWlyUjhYbSt5YndjaG5zbnR3WXloTGlk?=
 =?utf-8?B?OU5pbTZwdkFKOCtJTm41N2tHOUtCenpvMTFhNDc5QjdFZlFmdE44UDhlTEdY?=
 =?utf-8?B?VUlVcWt4bVh5dG1hNTUrV1NRSDdVNERKMWZMVzhuakM5U0tPK2xLbFl4SGll?=
 =?utf-8?B?Vkd3TlR1WXh4S2NBdmFXNlhiOCtjcE1FNmR6YlFwRkZka1NUN0JzQWhta2xZ?=
 =?utf-8?B?L2gwUFk5WnQxQjVhZHBLZjl2VlFGdGFwNjNYOTAyc3owOXZkSGdTakhlMGtz?=
 =?utf-8?B?NUc1NXRrdXEzaTNXSGNKV3hPU0d6RUlQK0JqOUw5QlV3QmtyMWl0MU9OQ2xs?=
 =?utf-8?B?d3M2YTFpZE5NdXNOV1lVeEdZclBzQm50Nm9yV0dIaGNwaEpzc2lkRnFObUhB?=
 =?utf-8?B?ekNZc3JZVm5DTlpIbW4yWXNKMWxjT3N0S2tJYVlwbTUyRTgrMVNUVStpQ29O?=
 =?utf-8?B?YVZKdWxUR29jMWI1TTBjdk5sUmNDcWdsUVA4L1VDTTZ4VWpxaUtFYnA4T0Fu?=
 =?utf-8?B?RlAvUndsV1hmMFNzM3NiWkRndlErM05hK1pnYkI4Vk9uOXlOcjRWOXRaQlpB?=
 =?utf-8?B?RUw4Q1R3UGExRFA5WkNKWUhhSStQYVUrc0lZam16empPak54bUFodEtkem5a?=
 =?utf-8?B?R3NOM1cyd1pPVnV2aENubnNpWFpXejNBQjVjWGo5dU1Ga3hwZEJqaTVPeFRF?=
 =?utf-8?B?ZHdUNUdUdG1OQ2FqV2tvNXVvWnlzV3BwS2ZqeVdUcXd3UmdJWEJLNE10d3FD?=
 =?utf-8?B?NlBWdEdXYXFSVm9RQmVKZE1jcDZNMVdEOG9Edy9aUExOcnlqZ01iZnJZbzl4?=
 =?utf-8?B?SEQ0Vzg4c0JQZUNGM09rSnNFTFV4eHVUejZCRHNqSzRURzBqbGxYQ1VKZm8r?=
 =?utf-8?B?SHNkRDN2RTlhT1VFeGh6andsMVM3YjloSDdneFdhbWd0bnNjem1uQjFKTjBh?=
 =?utf-8?B?bTJnV3RRMWxiVEtYTTdacEpHTEJINkFWV3RnZ1cvQ3E4WFNQL0p4TFhFemVr?=
 =?utf-8?B?Ky9LZktqbFpnRklwcHY2S2EyVUFwTXhhNjBkT2k2RmJ2NFFUUXM4cHhCOEJh?=
 =?utf-8?B?b2NmR2Z5ZldVK0FNelRwejBvSFp2RVNia1k5MTFvanoyaElnU00rSnZDTWVQ?=
 =?utf-8?B?L2F1ejZCM3pSK0RaMWZsWWw5ZVFFQllrenZMTE13QVBmMjBYQ05rSGFGQXJO?=
 =?utf-8?B?SmMyRTczck1yT0FxaXJmT1U3UTNpNnhUTWxKeUlDVzE4OUEwZmFnTDl3cC9a?=
 =?utf-8?B?M3htaUtjNUppcHFnQ2tmRi9Cb2lHZlptSWIrSWtWT1ovb2RGK2MraE13QmJw?=
 =?utf-8?B?YmozZ1hOa1pnWTNGYVFwT0cvc0Y1cldSV0ZkelBiVkkrb1BBSG5ZYkRXLzU2?=
 =?utf-8?B?aWk5aXJJeUZUbUQ4Wm9OVHkvNGZzRjVnYkd1NjltalJ5eTI2TWl3MVZUNXpC?=
 =?utf-8?B?d3JDTjNnaEx0UUwrYXpqUE81RFdZOUk0RkJYNWQ5UTA2NXBSa0lwcHBNSGxa?=
 =?utf-8?B?cTdGYWpvQlYzdVhwRFliQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXp6UGdDOUIvbjdxcFNlb2pVSWlMSzBub05ySkttR1k0S2pUZWVVMk9ENmhV?=
 =?utf-8?B?eTVPMnBBR2Y1VS9UV2l3Q3lPekl4WXU5akJ2WGtEdjQ3UnFYemllQy9rY2Yv?=
 =?utf-8?B?SnRBUTZSb1YydVNkT21kcmVjUnBjZU9FQ0RaREVRSDBmdGFtTXBmUjZ2SitS?=
 =?utf-8?B?cW9qNUY2ekxXSUdMdXlqdkF6Q244c1NnbklUU2hIek53bENtMk9waUFkdks3?=
 =?utf-8?B?RXRNZ2NLdkFPMVRTemlvZzBjbzV4Q0pSdTRTYkxqRXhPOUlkYjR1YVpFbGlz?=
 =?utf-8?B?OEhQb3lOSEJQdnhFRkJhRmplSE13d0htOXl0QVQ2OXUyRk9qWHpRZXZ3bVNS?=
 =?utf-8?B?amQrWG5JRUMxdk1ZQTI3bHZadzJQdGhHTWFuYjRQd2JBc0hhSWJUV3dNTWw5?=
 =?utf-8?B?aWJsMVkyWkt2MU1pdTFsc2J1UEI2aUt6UmU2eDhMZHFXY2lMRnRuZ2xVU3lk?=
 =?utf-8?B?WDQwL3NNaDhtZGI0OElid0taMjlST3RLcklJTWNUQzNUVkh5WUFSUjltNStv?=
 =?utf-8?B?RmRDMlNBekJjbFJZWDB4OFNQcVg4akowbzhFTkJscUwzRlNKQ0hzcWJwb0pz?=
 =?utf-8?B?NTJiZXNheE9EMkpMUnY5cmRvWWZvY0dURm5UVFVNU1N0MW4vTVgyZDYwQVhx?=
 =?utf-8?B?cGNBUzNueGJqaE4wNnZoN0NtVXlzVTN1am0xbGovOWdpLytEdEhmeUhHSys4?=
 =?utf-8?B?R2xaVHpVYVZZQ2dJRmJidjRGQkJ0NUdqdkNyWVl4NlBvUkIyZkdTR011R0Ru?=
 =?utf-8?B?TVNtdmlaclErVGZPMzZyYy9ueEE3Nm1hSEd0Q2VCSWFWVjZpaG9MSWRYazli?=
 =?utf-8?B?Y3p4K0pMZHdxMVo1b09tamFzWWtXQ2RxbjA0citEWWQ1VnJZRkJ2TUdxSTJk?=
 =?utf-8?B?VFlISUlNRlRkYzgvTmgvVmhheEw2d3hab3NSR0NYOTBwajFITXYyNzFtZ0kv?=
 =?utf-8?B?aGpRUUxYclgxT3BTZkFmb1NFRVNVWGsvSXR2bzlUcVk1WlVEa0JxcWhTYlhD?=
 =?utf-8?B?VytMUXJNUWR3OWpFOGpZWU5rem11c3d6cEVrc2tKWDlmNmNJYlQySTRHS0ps?=
 =?utf-8?B?cFVBUFBoTDE3R3hhd3I0cXBmWStDd2ZoNzNRSHBPZWZDVTBCdjBrNkZFdllH?=
 =?utf-8?B?R2VJdFdZYk1wQW9LS1VqSHdvdGtka3J5c1FWNmIzUVJKOFFpSzQwRGJ1czdP?=
 =?utf-8?B?M1FhOFpHSXZWbkZ4cmI4ZDd6RDVqZytkd3BiWHpwK1ZDL2VlOXI0VDVIUWNl?=
 =?utf-8?B?VWdNL0VnRmh6VTl1enJrWExhSzJ5bVJRQTdjbk1sRCtNZFVJVnlPU3psQ3pn?=
 =?utf-8?B?NG1CdER2aU52MzlZU0NlYVhCdTlMenNKY2FXRDdxcEVtUDBvZmlEWEZpOS90?=
 =?utf-8?B?cWNGTzU2QWxYeDJoeFpoVUdvOWxUamRiTmZwQnNrZkdEdkZVcnRTMTIrYk1N?=
 =?utf-8?B?U1V1eG9obHFZT3dVT0xsdXZPdEZYNG5Ycm94eW1XQW1ML1pmOFpPcTROT05L?=
 =?utf-8?B?NDVoSVlHTk0yOVk3SVFndjYxQy9SNGhKY0FnOG50ZVNPdk5xdFBkMVAvVm9Z?=
 =?utf-8?B?cGZJai9qaG1xTThyRURUVHBCaGs5akFIZEgvUHlNNXVmWUxzSkJCOVhURE02?=
 =?utf-8?B?VW8xUzl0SGFNcTZkdWFnWFlIejNtbDl5ZUhDT1p2QlVpTUxLMy9LTHFGTVV2?=
 =?utf-8?B?UnZHK2FjNEhVeFdaeVg1MFNHK3llZjU0VGdQejQ0ZnZxdmE4Z3M4ZS96Q1VU?=
 =?utf-8?B?QU9JS2hrZ1orOUh2ZFE2amVaTHIzcDZ0a25XUFFRMXJ5RnRLODJIejd4UGxP?=
 =?utf-8?B?Tk9EV1F6Mm5iZHROc3haY0Zzc1BqNndpQjZnbHNtTjNSNVpJWm0yMi9FUkNu?=
 =?utf-8?B?bnFmdWhydnBERXRQN2ZKa2VMakt3NXNZRy9yRmVYdTZjMjMyTDdVQng0KzY5?=
 =?utf-8?B?QkZBTWJrcER0OUN3WjVzZGU4V2tET3dFREVWby8vRFI4ZUR3TFpFTFAzTEFu?=
 =?utf-8?B?Um1tNW5hclEvelROS2QwQlNhTnMzUEt5Zm9STFJCeWdTTkVSRHJGeWNQOVpr?=
 =?utf-8?B?RkFUVFJuL1ptbGkrWTJYQ1F2UnhLT0xIL0pGcXB3WFdnVXJkSnlmWk5aRldZ?=
 =?utf-8?Q?4g5fEd/0uKdztbL7lgVFTh8nc?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bf5f259-2054-4249-4ade-08dc7582fb7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 08:34:20.5006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 91ftKmRR6aGHqPZMyaONei4pXPrMtKquPBZul2qkohe7uwns09xqep8KEs13qpGKWxLT+mne1QoPVe9wy1w8fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7417
X-OriginatorOrg: intel.com

PiBGcm9tOiBaaGFvLCBZYW4gWSA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+IFNlbnQ6IE1vbmRh
eSwgTWF5IDEzLCAyMDI0IDM6MTEgUE0NCj4gT24gRnJpLCBNYXkgMTAsIDIwMjQgYXQgMTA6NTc6
MjhBTSAtMDYwMCwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiA+IE9uIEZyaSwgMTAgTWF5IDIw
MjQgMTg6MzE6MTMgKzA4MDANCj4gPiBZYW4gWmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+IHdy
b3RlOg0KPiA+DQo+ID4gPiBPbiBUaHUsIE1heSAwOSwgMjAyNCBhdCAxMjoxMDo0OVBNIC0wNjAw
LCBBbGV4IFdpbGxpYW1zb24gd3JvdGU6DQo+ID4gPiA+IE9uIFR1ZSwgIDcgTWF5IDIwMjQgMTQ6
MjE6MzggKzA4MDANCj4gPiA+ID4gWWFuIFpoYW8gPHlhbi55LnpoYW9AaW50ZWwuY29tPiB3cm90
ZToNCj4gPiA+ID4gPiBAQCAtMTg0Nyw2ICsxODkxLDkgQEAgc3RhdGljIHZvaWQgdmZpb190ZXN0
X2RvbWFpbl9mZ3NwKHN0cnVjdA0KPiB2ZmlvX2RvbWFpbiAqZG9tYWluLCBzdHJ1Y3QgbGlzdF9o
ZWFkICoNCj4gPiA+ID4gPiAgCQlicmVhazsNCj4gPiA+ID4gPiAgCX0NCj4gPiA+ID4gPg0KPiA+
ID4gPiA+ICsJaWYgKCFkb21haW4tPmVuZm9yY2VfY2FjaGVfY29oZXJlbmN5KQ0KPiA+ID4gPiA+
ICsJCWFyY2hfY2xlYW5fbm9uc25vb3BfZG1hKHBhZ2VfdG9fcGh5cyhwYWdlcyksDQo+IFBBR0Vf
U0laRSAqIDIpOw0KPiA+ID4gPiA+ICsNCj4gPiA+ID4NCj4gPiA+ID4gU2VlbXMgbGlrZSB0aGlz
IHVzZSBjYXNlIGlzbid0IHN1YmplY3QgdG8gdGhlIHVubWFwIGFzcGVjdCBzaW5jZSB0aGVzZQ0K
PiA+ID4gPiBhcmUga2VybmVsIGFsbG9jYXRlZCBhbmQgZnJlZWQgcGFnZXMgcmF0aGVyIHRoYW4g
dXNlcnNwYWNlIHBhZ2VzLg0KPiA+ID4gPiBUaGVyZSdzIG5vdCBhbiAib25nb2luZyB1c2Ugb2Yg
dGhlIHBhZ2UiIGNvbmNlcm4uDQo+ID4gPiA+DQo+ID4gPiA+IFRoZSB3aW5kb3cgb2Ygb3Bwb3J0
dW5pdHkgZm9yIGEgZGV2aWNlIHRvIGRpc2NvdmVyIGFuZCBleHBsb2l0IHRoZQ0KPiA+ID4gPiBt
YXBwaW5nIHNpZGUgaXNzdWUgYXBwZWFycyBhbG1vc3QgaW1wb3NzaWJseSBzbWFsbC4NCj4gPiA+
ID4NCj4gPiA+IFRoZSBjb25jZXJuIGlzIGZvciBhIG1hbGljaW91cyBkZXZpY2UgYXR0ZW1wdGlu
ZyBETUFzIGF1dG9tYXRpY2FsbHkuDQo+ID4gPiBEbyB5b3UgdGhpbmsgdGhpcyBjb25jZXJuIGlz
IHZhbGlkPw0KPiA+ID4gQXMgdGhlcmUncmUgb25seSBleHRyYSBmbHVzaGVzIGZvciA0IHBhZ2Vz
LCB3aGF0IGFib3V0IGtlZXBpbmcgaXQgZm9yIHNhZmV0eT8NCj4gPg0KPiA+IFVzZXJzcGFjZSBk
b2Vzbid0IGtub3cgYW55dGhpbmcgYWJvdXQgdGhlc2UgbWFwcGluZ3MsIHNvIHRvIGV4cGxvaXQN
Cj4gPiB0aGVtIHRoZSBkZXZpY2Ugd291bGQgc29tZWhvdyBuZWVkIHRvIGRpc2NvdmVyIGFuZCBp
bnRlcmFjdCB3aXRoIHRoZQ0KPiA+IG1hcHBpbmcgaW4gdGhlIHNwbGl0IHNlY29uZCB0aGF0IHRo
ZSBtYXBwaW5nIGV4aXN0cywgd2l0aG91dCBleHBvc2luZw0KPiA+IGl0c2VsZiB3aXRoIG1hcHBp
bmcgZmF1bHRzIGF0IHRoZSBJT01NVS4NCg0KVXNlcnNwYWNlIGNvdWxkIGd1ZXNzIHRoZSBhdHRh
Y2tpbmcgcmFuZ2VzIGJhc2VkIG9uIGNvZGUsIGUuZy4gY3VycmVudGx5DQp0aGUgY29kZSBqdXN0
IHRyaWVzIHRvIHVzZSB0aGUgMXN0IGF2YWlsYWJsZSBJT1ZBIHJlZ2lvbiB3aGljaCBsaWtlbHkg
c3RhcnRzDQphdCBhZGRyZXNzIDAuDQoNCmFuZCBtYXBwaW5nIGZhdWx0cyBkb24ndCBzdG9wIHRo
ZSBhdHRhY2suIEp1c3Qgc29tZSBhZnRlci10aGUtZmFjdCBoaW50DQpyZXZlYWxpbmcgdGhlIHBv
c3NpYmlsaXR5IG9mIGJlaW5nIGF0dGFja2VkLiDwn5iKDQoNCj4gPg0KPiA+IEkgZG9uJ3QgbWlu
ZCBrZWVwaW5nIHRoZSBmbHVzaCBiZWZvcmUgbWFwIHNvIHRoYXQgaW5maW5pdGVzaW1hbCBnYXAN
Cj4gPiB3aGVyZSBwcmV2aW91cyBkYXRhIGluIHBoeXNpY2FsIG1lbW9yeSBleHBvc2VkIHRvIHRo
ZSBkZXZpY2UgaXMgY2xvc2VkLA0KPiA+IGJ1dCBJIGhhdmUgYSBtdWNoIGhhcmRlciB0aW1lIHNl
ZWluZyB0aGF0IHRoZSBmbHVzaCBvbiB1bm1hcCB0bw0KPiA+IHN5bmNocm9uaXplIHBoeXNpY2Fs
IG1lbW9yeSBpcyByZXF1aXJlZC4NCj4gPg0KPiA+IEZvciBleGFtcGxlLCB0aGUgcG90ZW50aWFs
IEtTTSB1c2UgY2FzZSBkb2Vzbid0IGV4aXN0IHNpbmNlIHRoZSBwYWdlcw0KPiA+IGFyZSBub3Qg
b3duZWQgYnkgdGhlIHVzZXIuICBBbnkgc3Vic2VxdWVudCB1c2Ugb2YgdGhlIHBhZ2VzIHdvdWxk
IGJlDQo+ID4gc3ViamVjdCB0byB0aGUgc2FtZSBjb25kaXRpb24gd2UgYXNzdW1lZCBhZnRlciBh
bGxvY2F0aW9uLCB3aGVyZSB0aGUNCj4gPiBwaHlzaWNhbCBkYXRhIG1heSBiZSBpbmNvbnNpc3Rl
bnQgd2l0aCB0aGUgY2FjaGVkIGRhdGEuICBJdCdzIGVhc3kgdG8NCg0KcGh5c2ljYWwgZGF0YSBj
YW4gYmUgZGlmZmVyZW50IGZyb20gdGhlIGNhY2hlZCBvbmUgYXQgYW55IHRpbWUuIEluIG5vcm1h
bA0KY2FzZSB0aGUgY2FjaGUgbGluZSBpcyBtYXJrZWQgYXMgZGlydHkgYW5kIHRoZSBDUFUgY2Fj
aGUgcHJvdG9jb2wNCmd1YXJhbnRlZXMgY29oZXJlbmN5IGJldHdlZW4gY2FjaGUvbWVtb3J5Lg0K
DQpoZXJlIHdlIHRhbGtlZCBhYm91dCBhIHNpdHVhdGlvbiB3aGljaCBhIG1hbGljaW91cyB1c2Vy
IHVzZXMgbm9uLWNvaGVyZW50DQpETUEgdG8gYnlwYXNzIENQVSBhbmQgbWFrZXMgbWVtb3J5L2Nh
Y2hlIGluY29uc2lzdGVudCB3aGVuIHRoZQ0KQ1BVIHN0aWxsIGNvbnNpZGVycyB0aGUgbWVtb3J5
IGNvcHkgaXMgdXAtdG8tZGF0ZSAoZS5nLiBjYWNoZWxpbmUgaXMgaW4NCmV4Y2x1c2l2ZSBvciBz
aGFyZWQgc3RhdGUpLiBJbiB0aGlzIGNhc2UgbXVsdGlwbGUgcmVhZHMgZnJvbSB0aGUgbmV4dC11
c2VyDQptYXkgZ2V0IGRpZmZlcmVudCB2YWx1ZXMgZnJvbSBjYWNoZSBvciBtZW1vcnkgZGVwZW5k
aW5nIG9uIHdoZW4gdGhlDQpjYWNoZWxpbmUgaXMgaW52YWxpZGF0ZWQuDQoNClNvIGl0J3MgcmVh
bGx5IGFib3V0IGEgYmFkIGluY29uc2lzdGVuY3kgc3RhdGUgd2hpY2ggY2FuIGJlIHJlY292ZXJl
ZCBvbmx5DQpieSBpbnZhbGlkYXRpbmcgdGhlIGNhY2hlbGluZSAoc28gbWVtb3J5IGRhdGEgaXMg
dXAtdG8tZGF0ZSkgb3IgZG9pbmcNCmEgV0ItdHlwZSBzdG9yZSAodG8gbWFyayBtZW1vcnkgY29w
eSBvdXQtb2YtZGF0ZSkgYmVmb3JlIHRoZSBuZXh0LXVzZS4NCg0KPiA+IGZsdXNoIDIgcGFnZXMs
IGJ1dCBJIHRoaW5rIGl0IG9ic2N1cmVzIHRoZSBmdW5jdGlvbiBvZiB0aGUgZmx1c2ggaWYgd2UN
Cj4gPiBjYW4ndCBhcnRpY3VsYXRlIHRoZSB2YWx1ZSBpbiB0aGlzIGNhc2UuDQoNCmJ0dyBLU00g
aXMgb25lIGV4YW1wbGUuIEphc29uIG1lbnRpb25lZCBpbiBlYXJsaWVyIGRpc2N1c3Npb24gdGhh
dCBub3QgYWxsDQpmcmVlIHBhZ2VzIGFyZSB6ZXJvLWVkIGJlZm9yZSB0aGUgbmV4dCB1c2UgdGhl
biBpdCdkIGFsd2F5cyBnb29kIHRvDQpjb25zZXJ2YXRpdmVseSBwcmV2ZW50IGFueSBwb3RlbnRp
YWwgaW5jb25zaXN0ZW50IHN0YXRlIGxlYWtlZCBiYWNrIHRvDQp0aGUga2VybmVsLiBUaG91Z2gg
SSdtIG5vdCBzdXJlIHdoYXQnZCBiZSBhIHJlYWwgdXNhZ2UgaW4gd2hpY2ggdGhlIG5leHQNCnVz
ZXIgd2lsbCBkaXJlY3RseSB1c2UgdGhlbiB1bmluaXRpYWxpemVkIGNvbnRlbnQgdy9vIGRvaW5n
IGFueSBtZWFuaW5nZnVsDQp3cml0ZXMgKHdoaWNoIG9uY2UgZG9uZSB0aGVuIHdpbGwgc3RvcCB0
aGUgYXR0YWNraW5nIHdpbmRvdykuLi4NCg0KPiA+DQo+IEkgYWdyZWUgdGhlIHNlY29uZCBmbHVz
aCBpcyBub3QgbmVjZXNzYXJ5IGlmIHdlIGFyZSBjb25maWRlbnQgdGhhdCBmdW5jdGlvbnMgaW4N
Cj4gYmV0d2VlbiB0aGUgdHdvIGZsdXNoZXMgZG8gbm90IGFuZCB3aWxsIG5vdCB0b3VjaCB0aGUg
cGFnZSBpbiBDUFUgc2lkZS4NCj4gSG93ZXZlciwgY2FuIHdlIGd1YXJhbnRlZSB0aGlzPyBGb3Ig
aW5zdGFuY2UsIGlzIGl0IHBvc3NpYmxlIGZvciBzb21lDQo+IElPTU1VDQo+IGRyaXZlciB0byBy
ZWFkL3dyaXRlIHRoZSBwYWdlIGZvciBzb21lIHF1aXJrcz8gKE9yIGlzIGl0IGp1c3QgYSB0b3Rh
bGx5DQo+IHBhcmFub2lkPykNCj4gSWYgdGhhdCdzIG5vdCBpbXBvc3NpYmxlLCB0aGVuIGVuc3Vy
aW5nIGNhY2hlIGFuZCBtZW1vcnkgY29oZXJlbmN5IGJlZm9yZQ0KPiBwYWdlIHJlY2xhaW1pbmcg
aXMgYmV0dGVyPw0KPiANCg0KSSBkb24ndCB0aGluayBpdCdzIGEgdmFsaWQgYXJndW1lbnQuDQo=

