Return-Path: <kvm+bounces-49210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1AF1AD6581
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 04:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 528E33AD00D
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 02:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF42A1C07C3;
	Thu, 12 Jun 2025 02:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B7eQCNNI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A9C1C8629;
	Thu, 12 Jun 2025 02:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749694857; cv=fail; b=MdE2tnYwSRJjqh/jOlRYoLGSIG1Ykkac8JhCVJK0ohu5AhBeG2PRhHj4jNHofU+o8OxX47w1pvMT6a0ySnB9zO5G6n+v7gJiajndheXhvcwmKi/psFZEikKxIsnHE6Ot2SBjcjleP+1nAtgFdXiD2MTUODzh3jM7Cc9S0mwlFRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749694857; c=relaxed/simple;
	bh=Q14QwL5e//LXhY3lqGInX8MMK2XAdoCBmcz5Wvmuk9w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G0I0mCLlwMPagaWV8a9QO/hGTT0RpsbyWs6US5TNktAOOC0hd1cyqttfASt2YtLP2UcbRQITIzf1Y3oehzM+2cqSuq2WyyZtv+XWIURVCQwow2EgZGXIgprxXv7ZJ64PFovFQ3wXXMTQXukge/lW2X6Lp//JyMf0DMIRuwkbKDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B7eQCNNI; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749694856; x=1781230856;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q14QwL5e//LXhY3lqGInX8MMK2XAdoCBmcz5Wvmuk9w=;
  b=B7eQCNNI5f62yzdpJLMAR3wd/NFf4ecaw5SHHg0DcXtg6A/RkaW20luT
   V7trlzXgpq83yCzJDVEoaY/LcWCkHncllB1V7Zs5AoiA+6ZDyS/C2rAwL
   zoX5ReU6fe0j46jrOh/BmP1CZUHB9D9vX6K6B99nIvJP4+GVUAvOCDCZg
   Zt3n+uhEUQvpS1cbv2Mt/AMLsjDAYuI8h1agW4sIuOg9768TSvK+aaW7r
   F8qbZoZQqXfmPYvRT/Mf+hRVZOIOe3QXwu6HlMzQMOlEd8ReOn3qBVS42
   ev/m68+FVw22Yr2ReRqIiKg1NzGOtdV437aCXNWBdUQDuJffRyER8uPiR
   g==;
X-CSE-ConnectionGUID: SpibjrMQRpayFktzWh4ZPg==
X-CSE-MsgGUID: NN+SDAOkTGu4cxmHsizffQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="50963067"
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="50963067"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:20:55 -0700
X-CSE-ConnectionGUID: qYjL/kCVTUigBBclSKkZ5g==
X-CSE-MsgGUID: t/BtQLBtTbmQhaCTU8GdMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,229,1744095600"; 
   d="scan'208";a="147921961"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 19:20:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:20:53 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 19:20:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.89)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 19:20:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZCySck5ZFQ8g87OH+N00pOp2co7P7tcwcGQBJAA02TzQTEboWgZDDn819/4Br/zZFIBXC6BBFfMGS7Yvvm1D1fqp7SWswI+FmbG8MlQdqPAuc0JEU5/WXYORltdiQd90aZvh6jGXJp5DGaC+5oe1E9SE4hz2rWcrg9J8Tku82XBjVZ22mVt6VBjWPQ/+3URKBd3AcKLFZ3dXkNuKcxgbry0jj2s9yJpcJQCv9ftlayGgivzhyb1oIICRnJx5988pwWj4d84KQ5Sl7CbiDaE/jDYEt58oqJ01+QUKSGLkDGUm5+JKESuioqT6hOvK49YRr1xtSxZeWC0A7VIWuMjNAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q14QwL5e//LXhY3lqGInX8MMK2XAdoCBmcz5Wvmuk9w=;
 b=IubiDfLrxYjIJR4F2JGhDJX+SWLz2oPG+x9b/TqRVTMJeF8AQPIpo8vQ9/FnhQ0BOzRrQ7PrStjlaF+bDPtkAdU+VWTvLA970E7KscOwA3a8rDEWhvq9nqEJNKjezXlpeGVl44VyMThrH+i/O4TiD32WyxBzlalQf/4f2YJEHna8XttVp0hgViUfCzxoUr9qCOWDjiORfOtduSSRJACFOgh2wr0YQU8UD59+2rg418YJcQu8wuYB9+fWWoEqTmx/4ZWpsUKzN2Dlo47ZgBXabQM5OfOfk5gHMI+gzm4KJHIe41UmM1279Fg/oXHi23Bepj7JBelM30s+f7YnlkQEyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB5969.namprd11.prod.outlook.com (2603:10b6:8:5c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.31; Thu, 12 Jun 2025 02:20:51 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 02:20:51 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 06/18] KVM: x86: Move KVM_{GET,SET}_IRQCHIP ioctl
 helpers to irq.c
Thread-Topic: [PATCH v2 06/18] KVM: x86: Move KVM_{GET,SET}_IRQCHIP ioctl
 helpers to irq.c
Thread-Index: AQHb2xjjLsNHcqhEr0a7eKNC0+s1gbP+ywKA
Date: Thu, 12 Jun 2025 02:20:51 +0000
Message-ID: <ec9cf2ed3f2db01fccf9a01e2739623297b3ca9d.camel@intel.com>
References: <20250611213557.294358-1-seanjc@google.com>
	 <20250611213557.294358-7-seanjc@google.com>
In-Reply-To: <20250611213557.294358-7-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB5969:EE_
x-ms-office365-filtering-correlation-id: fa68b58d-d510-4ec4-0116-08dda957c077
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b1p5aDRhbWxERHNySG5XczRSRG5MVnBPd1lyVmZ6YWg4OEhlQnhjUXVLeUly?=
 =?utf-8?B?UkFEdWw3Z3d1ejllQm8yZkRPaWZUeSs0VW5xSy92SVk0MXVxdEw3cURLMEov?=
 =?utf-8?B?bFc0RnVOL3ZMNGhDZVdkWjBSbkVobXVLMVlOQ3BQZG8wRFM5cEwrb3NaZlk3?=
 =?utf-8?B?Q0h5cXFmQ1JITEZnWjJwTURpL28zK2ZqNmhDdmU0YkxqdURVM1hGaXdlSTRC?=
 =?utf-8?B?bDNhSGVxN29xb0l6QmdVN3N1VkE2UnhheEpZWWUvVEcvK3Z4QldZZU4xQWNi?=
 =?utf-8?B?Sm40dzdMNkdXT3N0OE8ydnVhcUJrRU5aTnJMNXdXYzY5dnEzWXhCak9EelJM?=
 =?utf-8?B?VDZGMmd6MHNjVVVaVHZPS0xJUDdTTDJSOTV5ZlgzUE9EVlB5VkY1TlhWeTVH?=
 =?utf-8?B?VFFBM0pSU2g3RWdVSE9MUzc2cXpTeUMwdUNLYWRlLzZEU1ViVEpxOEJjVVRP?=
 =?utf-8?B?ZVhwMHdFNEo3YjVEelFDQVdOUVIzVWQrSlJEQXp1cXVLRGFnTFJDU0tRc25u?=
 =?utf-8?B?UjJJNFdaK0R4cWlLVy9OLzU0ejJyQkNieFRFV21HZGxiRlVDY1NOaWpnL1Ns?=
 =?utf-8?B?elpnSG5JV01mRjVTV1pDcDEzT2pjbGY5a0dQTnB5aFF1eGMwWUYxalh1dnhi?=
 =?utf-8?B?Q2c4clFsdGRDZjVEOU13SkNqd1Mvc05USGVmb2tFck11Q1h5UFZLbDVudU53?=
 =?utf-8?B?c0M2L0ZEa2NGcmx4b1g4bEtHVWZ6amM1RlkxTFpiZDBUSUFKa3dZRFIzMnJI?=
 =?utf-8?B?UVZ2VlFLaTBWSm1sVVkzeDV0QTJ4UHpzb2NzdGgwRVYxL2JLdkxZN0lLYWhZ?=
 =?utf-8?B?Z2JzbGRtWkp2WkdFUUhFYktGeDF4UW9qWnVvaE04bFhQSUFrMDVKTEI5WDJt?=
 =?utf-8?B?cEdiS09kZEJkNkR6UlV3WGdscVdpd3RhL0VKSGdpT2JEVGszUXpIVG9lVWty?=
 =?utf-8?B?RGlJdHY3bThVNXlqaXdPRGxQdFNmN0RyRXFQZkxzNHd2T1g0eG81UEpDR2ZU?=
 =?utf-8?B?cVZBNU5zVzRXOGZrK3c3VzA2K2hWbjY2S044LzBSQWhyUy9zTXNubEVXZ3lv?=
 =?utf-8?B?anh0WUJUc05wUGNFcGJJend0em1oY2FjZlRnZ1V0cTN4TTdvZ2dYUGd6SjhU?=
 =?utf-8?B?b1VMVmtkL05sOVJaMVFNWFoybm92dFBiUEtMeEg0YjJ4V1FydXhHNmRzWkNT?=
 =?utf-8?B?YXM0ZDNDc2R4eHV5YUh0c1RBQzV0R3pTVVNDVERoenZ0cHFPb0JhZTM1MDNp?=
 =?utf-8?B?eDFoWkZXRWxEaUtQclNjQnlkOHhmdzN3dDJsbll6TTlDeWo1VktxbHltWkZl?=
 =?utf-8?B?M2w5UjBwNVJzeTdGb2RtTnVPSGNJYnR2ZE00MmxxSGcySlp2eHZweEU3NW85?=
 =?utf-8?B?RXZoNWYvcjRxYWFoeHVzclBFRzF2NWVKNndBUUo3QzlOaUZ6RmhmSmo5N0FC?=
 =?utf-8?B?QUVwbFRYNXBYK29ZQ2hwVm5QNzgvVXA5MjY2YUFQOCt1MHZLOVF1eUhUV1JH?=
 =?utf-8?B?Wm4veVNVbytMbHhkWG9IRzBkU1prVUVnaDhLTE56Z2ZsbmFBdlMyN2M0TjhY?=
 =?utf-8?B?Ukh2Yy9CTWJwczNSbHFZQzQzaWp6Q1g1dmxYNGZrRmMrWFowSGRKckQyaElp?=
 =?utf-8?B?YUpaekpydDIxZHI2RTl1TE9PVERBbEdpRWhQQ2p6eS85ZEt6Zno5b1dEQ05Z?=
 =?utf-8?B?OEVmcGZ6bmpNSWM2TkVPOElVcEVZMElxMHV2dnByMTVhbEttNXhYQzF1Y0ps?=
 =?utf-8?B?UWJsb3VIRHJmQXpyTUs0eks2MnB6amZpcWo0VFl2cTBrenFodGNiRkRmYnlE?=
 =?utf-8?B?aTgxd2NmTy9iY1ZnVkFRU2dSMGY2UUFEOW01QXBkdXFwcEp6TFhNcXVJQmRv?=
 =?utf-8?B?aTM4bDE4VHJiMlloZXBIOGNEbTM4RURlQkR5RmhOZ0NIMkM3WW5jNzZvM01S?=
 =?utf-8?B?aDNEVUwvRDJrNlMxb01vTTRkYTdwaFRSVWdxbW1ENERYN3NrVWxIdXZvV3Vo?=
 =?utf-8?Q?0Bxr8Hy9VQVVGudJqIwnxuMU9/3tPo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmxDZ1RydTBXbEJnellza0NlbGpNYVdHbjdCTVAyNlpFT3RoVFozVlk5WVBD?=
 =?utf-8?B?K29waXQ1Wmd6SkdxNFlIVllWdFFncks2YlpNcnNtaytyM2M3SnJVWFNRd2dP?=
 =?utf-8?B?MithN3RLN1h1aGtDZ003d0I3enYyaHlsL3NjQ3kyV3YramR2RytlQXNyUGFW?=
 =?utf-8?B?VG83Y2tWUnpEa0ZXOG00dHc2SGlHYzRmZnJMZUMrMjFTcExuMGdDYjRwWW5F?=
 =?utf-8?B?RHFTd3BaaWg0SVpOK0k0NmpwWUF3ZVR4SGxzQm5KN1FiaU5VbWljajZIWTBV?=
 =?utf-8?B?SlRyd2R3MytVTUgxbU5HSWdrR3VJeUgzaWdxTDJ0Q3B1QmtvalpucXZPb2o5?=
 =?utf-8?B?cVpuemNUZk1NSHBhT3I4U3plRlhLb3M5Q2U1Tkh0Mm5Ed0cyd0NxWkN1THpy?=
 =?utf-8?B?ZE83TTk1TkY0VW1rUDlJd0hLM01SaGJobkFMYWxxMGV0bG9vT0I1aWJvaEFi?=
 =?utf-8?B?Nm9ZbEt1dWZDWXc2Y09VV3hLaU04M1RHRFV1Qjdna094WXU1K0pJSEVINnRr?=
 =?utf-8?B?MXJndUgzNFQ0RnZpb2ZNNDhmZmM5TWhXcytabnVQZ1UyaVdxbDViK3U5bzRU?=
 =?utf-8?B?MnpIT0FBYkZqRXo3RU5ZOHRHNE9nL3hkZW4yMkNwbEh3SS85UGN6R0lvNGc2?=
 =?utf-8?B?a1c2N2hiNWdFTFl5RXRhbU90K3ArZTcrWkpTSGY0V0pZYlRudDM5WElSeGp2?=
 =?utf-8?B?WVVxZGJDZFRSL1RqOFYxVlNvQjhqaVBqTHFTQ3E4b0EzdlZMWm4rT29LUnVu?=
 =?utf-8?B?WWIzQ2oraDAxVXlmYW9ZMUlzVmhFb1VjNzZNUzhXSW9RWEl0Q1luZjZXM29M?=
 =?utf-8?B?bWY3aU1pN0NjWXo2WERpYVkvN2djR29DS3dkc3VFRDFJMWxVTEJsYWo2SCtn?=
 =?utf-8?B?eEJPTmlmNmVMUU5PSjEyd3BPaFdSVHFyTDdodlBYMXVzdXlYLzQvZUFlRklk?=
 =?utf-8?B?SjRLbkk5TWtIblpOTWlHbzcrSVlTbVVQV2RVNnUvQy9EdmRPRWcvY3hrNngx?=
 =?utf-8?B?WklwNURBdGNPZG9CWEZWbm05cWI4bEpBZHM3NkxVeFVmQjBwUmJOTDAyMm9t?=
 =?utf-8?B?YWlwNTJheFd6UUp0eGl2akdQTThwUDBEd3g0OElBWUJqdjhyMkRGVUpkbTRY?=
 =?utf-8?B?TE56dnB5cFpsU1pRT2V2RTBMaGVyT1laMDZuY3A2emlhNm5PRzlvVFNLbnMv?=
 =?utf-8?B?TGRmVW5nRUdnQnB1eml5eVQvamRhZk1QWkNCMUQ3Mk54OGc3ZFpYOHVrSkk0?=
 =?utf-8?B?Vk9ydXNGZjNmZUNnbmdEUFkwNGVnYVRQNE81RnRUSExGYk5GTHp4Z2dQU1Zv?=
 =?utf-8?B?TGp3L1Q2Yk5FUVNyeFcxSitCdlRsN3hXeFFMV29oZ3lTclFjckJueTVsbEJq?=
 =?utf-8?B?MjduSGlJVXJYZTFQOE5HcjI3OHMydXFPb0pUOGhlYi92OElDUExMbWxLTDJa?=
 =?utf-8?B?TytXUGw4NkxpTHFPd3U3cWx0d0VjR2dQSlpkSkhHVVRVWStiWUV1bGNLU1oy?=
 =?utf-8?B?NHZXTElMQ21UajJ5L3Bzc28veGlNd1pMbnZhL0pQckp4aGxDKzBEUmRMSDh0?=
 =?utf-8?B?N0RiUFNibnlZaXRvVXI2L0tCOTYxOGNRNnNNT0VKQytZZE9iMWRmbmZRYmlm?=
 =?utf-8?B?ZFRac0ZIa01oK01lZEp0TTh4REhDbEpYU1pTMnlzWDhLNW9DUHpPM2UyWHo4?=
 =?utf-8?B?YjZNanZhVDlNeHFSc1RvNEt6ZmpjQjlzY1NYM2h3L25oRWdPNWw3NmJSRita?=
 =?utf-8?B?SmxGb1Ayc1RHT3UrWHNBQmV6cnhDTTU3K2ZrYnpvZGxHK3dweTdzaFVLcngx?=
 =?utf-8?B?TFN2b3A0MzZFSE9CbjJscktDeHBzSU1idlJ4ZjdpQ0tyWWJRQ3JvKzFXR1Qr?=
 =?utf-8?B?UG0rZ1VWSmNyK1FrZEViNnZkdm0wVVYyY3dZdk5tVmg3UklCMGFUbHpsUTNX?=
 =?utf-8?B?Z041T3c0YUdEb2x1eVBOTkRhQlhNQXk0T2RpVHordlgydGVicitrRzRvcFli?=
 =?utf-8?B?UEFSSHJadDg3c0hXcnhnNXdCc2hVOENaNU92ZUNMK2VmUlJVZ2Y1d0R5V1cx?=
 =?utf-8?B?VjRoQUQzM2p5WHZyWm83bVB6YTlMVXl2TWdPZTFpakpMeWNINWo5TzA5NTdO?=
 =?utf-8?Q?8mRKczaA51dLXguwrGbm8fomY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <862C82A6843AD64DA6A83C4BC8E53498@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa68b58d-d510-4ec4-0116-08dda957c077
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 02:20:51.2716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kt/4weXy0EXtHKwUBLMSzv9bCLmL9dMwiwwrDsEVPbFb09RnnViRGAwZTgCiR52bAb7DF7lHnzgDgQfm5olGhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5969
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDE0OjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIHRoZSBpb2N0bCBoZWxwZXJzIGZvciBnZXR0aW5nL3NldHRpbmcgZnVsbHkg
aW4ta2VybmVsIElSUSBjaGlwIHN0YXRlDQo+IHRvIGlycS5jLCBwYXJ0bHkgdG8gdHJpbSBkb3du
IHg4Ni5jLCBidXQgbW9zdGx5IGluIHByZXBhcmF0aW9uIGZvciBhZGRpbmcNCj4gYSBLY29uZmln
IHRvIGNvbnRyb2wgc3VwcG9ydCBmb3IgaW4ta2VybmVsIEkvTyBBUElDLCBQSUMsIGFuZCBQSVQN
Cj4gZW11bGF0aW9uLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4N
Cj4gLS0tDQoNCkFja2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQoNClsu
Li5dDQoNCj4gLS0tIGEvYXJjaC94ODYva3ZtL2lycS5oDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9p
cnEuaA0KPiBAQCAtNjYsNiArNjYsOSBAQCB2b2lkIGt2bV9waWNfdXBkYXRlX2lycShzdHJ1Y3Qg
a3ZtX3BpYyAqcyk7DQo+ICBpbnQga3ZtX3BpY19zZXRfaXJxKHN0cnVjdCBrdm1fa2VybmVsX2ly
cV9yb3V0aW5nX2VudHJ5ICplLCBzdHJ1Y3Qga3ZtICprdm0sDQo+ICAJCSAgICBpbnQgaXJxX3Nv
dXJjZV9pZCwgaW50IGxldmVsLCBib29sIGxpbmVfc3RhdHVzKTsNCj4gIA0KPiAraW50IGt2bV92
bV9pb2N0bF9nZXRfaXJxY2hpcChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1faXJxY2hpcCAq
Y2hpcCk7DQo+ICtpbnQga3ZtX3ZtX2lvY3RsX3NldF9pcnFjaGlwKHN0cnVjdCBrdm0gKmt2bSwg
c3RydWN0IGt2bV9pcnFjaGlwICpjaGlwKTsNCj4gKw0KDQpJIHRoaW5rIHdlIG5lZWQgdG8gaW5j
bHVkZSA8dWFwaS9saW51eC9rdm0uaD4gZm9yICdzdHJ1Y3Qga3ZtX2lycWNoaXAnLCBqdXN0DQps
aWtlIHlvdSBkaWQgZm9yICJpODI1NC5oIiBpbiBwcmV2aW91cyBwYXRjaD8NCg0KSSBjaGVja2Vk
IHRoZSAiaXJxLmgiIGFuZCBpdCBkb2Vzbid0IHNlZW0gdG8gYmUgb2J2aW91cyB0aGF0IHdlIGRv
bid0IG5lZWQNCml0Lg0K

