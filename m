Return-Path: <kvm+bounces-68757-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJv7A8sfcWmodQAAu9opvQ
	(envelope-from <kvm+bounces-68757-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:49:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 840585B86F
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 19:49:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E54C2A0DB51
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D7A378D91;
	Wed, 21 Jan 2026 17:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IeJypeR5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0946234EF1C;
	Wed, 21 Jan 2026 17:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769015890; cv=fail; b=BeQG+Oy9yuVepVWNqseaWvA06tuwGCj4KJ56ZV8wVuomOWknBdfo1ZlUIPH2f3TKyw5YoMRJfeVMPvXyvxG9l2FapgokmrA/hAwHnHJ6IT17HULJNcLgUyEdGf7jCCaYLdNKn1i/U3xhtuBoCYSRy72lAqX8pRzu6Q65t0Y2/hA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769015890; c=relaxed/simple;
	bh=lwL1qv8BFrOUrq7fJbLbRqbPtPfipubEoOj6C40GtAM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uhDA6k6UAV++KAg4i3vhcMKenbVHifbKabzBROQIXk6RxW6NGZqlwxGT5KXEEHA31YiUi5N2S8p60ieN2o+iVMd/V7KNhts1v5T1uve8mrCEiIByLwDRmTR09d4PhYb4tGMMQuAkdN3vyDacjLCPUl3iXjzcyPbq44tbpbinx4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IeJypeR5; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769015888; x=1800551888;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=lwL1qv8BFrOUrq7fJbLbRqbPtPfipubEoOj6C40GtAM=;
  b=IeJypeR5yCP2uQ+fZYvPeWIniiHZnVJmuOCtyOCOHwMeCU/j4foUUa3h
   i0mvHAdM6ms0GYLCKgvIFrdgMfAKFITSRx8tAHwxUi4CO/33ArmCXCB/f
   lPWdnjxC0jdQ74YK2I0hkqMQXhK0QitkKjHIPnBRyTm97J1DqTd/PpTV4
   1fyUar0xGGiChJDO6OAQxFcmop9557xkwi3u+YE489+8QFdB8kgNh/9dy
   YC7o7ZNRtEmxGHLazKx2c8+bnbDBlXR21qZO4/wsNw89fs+SehmSf/qWJ
   vtTQ9BiuG+zks2rE+MCAsgVw1xt0CPVLpdgZfG91jqKllrp3oUJJ1ZiZ5
   g==;
X-CSE-ConnectionGUID: 1JxIreSEQTiN9aoPQrB5KA==
X-CSE-MsgGUID: KI82tIDdR2+zE2VgJSKziQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="74111603"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="74111603"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 09:18:07 -0800
X-CSE-ConnectionGUID: //V6y56UReCQRE+Lk/xWKQ==
X-CSE-MsgGUID: VfE/fjMaRSyJCU+qCinUWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="205756618"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 09:18:07 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 09:18:06 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 09:18:06 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.63) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 09:18:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qU6g5KD+eUmhJvIWTPukcCasV0VvAiZjRGV96NEfiY4u10pqIJGQFSyn54KEH7UtwMQSJqkJrV2U25I/vQouMttIppiqhbD6UIZzw53Jwxv/cf9aQeRx/xMXBU8AkWRYrutYVHHS0lwAXvL/474l7CErZioTHRFnzqQgQfbiS4T9CUPit5wdNNTmwL+hx3gMytRHIYZgez3ZhpPs7NM8OFMogXQJgrgrHghAYr3A4eGvjDanPD8Z6MTxHybZcN58hT+f3eLcBjzyvd48yZsqMreG51EZaeG2SD93LZz15pis8cuAVgdovGfKnP/TulwTBJttkvMP9swZnmmSU4lalQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSrw0juhLsxCgUPMHv7Geyq9KNZP6HIzd62D2rgpQSA=;
 b=M14SzGpR6eawrRSZ9sPrn5aNG8GhZFEded4YTw1rRN85oHeu4sKVoob3PQNG+6KY5I6LU+ZN7RqmI8M2kgL2cw3+6irbLLGcGN5zCWhWjKCeAaSp3w/EO4cQ5JBZphfXEP9eWvI28E3NKf+WE6pTa6R2xmcXFx2B83PXQxuiNsGiluI9GoBNQBPSWtf+TDmMPYSxTr7mZZ4v0Io9x8GJ2aFdTUkGSXen5+xpLD3+iA6N5sLAOzkEK/UweT44mlg8ntQ9/DtSZofZsDXzIu42g78W2xmZnv2c89urUFlLjixtKrhLWSMCH38LaimQx8jdilltJMSxd2mdpXmhI71wMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by PH3PPF179F31853.namprd11.prod.outlook.com (2603:10b6:518:1::d0b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 17:18:03 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Wed, 21 Jan 2026
 17:18:03 +0000
Date: Wed, 21 Jan 2026 09:18:00 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Leon Romanovsky <leon@kernel.org>
CC: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Gerd
 Hoffmann" <kraxel@redhat.com>, Dmitry Osipenko
	<dmitry.osipenko@collabora.com>, Gurchetan Singh
	<gurchetansingh@chromium.org>, Chia-I Wu <olvaffe@gmail.com>, "Maarten
 Lankhorst" <maarten.lankhorst@linux.intel.com>, Maxime Ripard
	<mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, "Lucas De
 Marchi" <lucas.demarchi@intel.com>, Thomas =?iso-8859-1?Q?Hellstr=F6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, "Joerg
 Roedel" <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, Felix Kuehling <Felix.Kuehling@amd.com>, "Alex
 Williamson" <alex@shazbot.org>, Ankit Agrawal <ankita@nvidia.com>, "Vivek
 Kasireddy" <vivek.kasireddy@intel.com>, <linux-media@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, <linaro-mm-sig@lists.linaro.org>,
	<linux-kernel@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<virtualization@lists.linux.dev>, <intel-xe@lists.freedesktop.org>,
	<linux-rdma@vger.kernel.org>, <iommu@lists.linux.dev>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] vfio: Wait for dma-buf invalidation to complete
Message-ID: <aXEKSKOwUk3soU3k@lstrano-desk.jf.intel.com>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-6-b7e0b07b8214@nvidia.com>
 <aW/pQmOO8komCgOK@lstrano-desk.jf.intel.com>
 <015b25e6-cfe1-4110-963f-5f8dc4720d1b@amd.com>
 <20260121104451.GB13201@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260121104451.GB13201@unreal>
X-ClientProxiedBy: PH1PEPF0001330A.namprd07.prod.outlook.com
 (2603:10b6:518:1::19) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|PH3PPF179F31853:EE_
X-MS-Office365-Filtering-Correlation-Id: 9faf0def-f07d-42d9-9263-08de59110913
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VFF4d0l6NEZSKzc1RUN4L2FLTFVCcmU1ckpzQmk4bml0NjBGQzd0RkYveVBl?=
 =?utf-8?B?enJ6ZnhPU1ZYdm1iWGZhUXIwcmNwcERvd1R4U2pMSzZhallsWmE5c3owL05n?=
 =?utf-8?B?aG82TVpZMmVUY0ZwNlF3dVdqaXludC85YzZQMGtrQTl1Y3NXalJCek9DMkUz?=
 =?utf-8?B?QTYzOVZFZmhqczlBSE8yVkFaN21sdzZSTWlteFJCdlRCaloxTWI2UC83U1pO?=
 =?utf-8?B?NjMzMHlpMmdZRTF5UFQzejduRk9weWZYYTlQTXRSWEd2NkpFZ0ZIaG5PN1Ru?=
 =?utf-8?B?T3NPOTZlV0RkT1QrOXh3UHJJeGhHTHVoNTRJdkNEa2g1UXhEcnNKUkJTS3VL?=
 =?utf-8?B?OWFIMDBZMmRpa0dnSlgyS3QxTWJPaTYzOVZTa3ZXU1FvY05ZcVJqTmtBdnJF?=
 =?utf-8?B?S1dMOTMzQ3RkRWZEdVNvUlpORTliQlVTVkdZTW9VU3ZvTFNWMmUyeXZZYUlx?=
 =?utf-8?B?OWVhMXIvelY0VzdIZFdFYmpYdzNhWVpYaW8vc0FuSzJwekkrVVAzVzEyYWlI?=
 =?utf-8?B?Q1RVbEd3WVZXaVZ1dGd0UFE5RUlGTjhTa3hNRTU1VmVkQWV3WHhWVnJzMVV4?=
 =?utf-8?B?akdSdjg5WExFTHdYem9JUndDZEhCUHJ4Vmc4NE4rL2lFQldjTE1ha1NuNWlM?=
 =?utf-8?B?OEhwdnVWQ0lPZTEweFBBeDJ4dkUrdDE3ZzZwY3c1RHFsWGJlLzlyK2s2UGNP?=
 =?utf-8?B?YUk0ekhBMUNMbjk1Q2x6WnJ4YXhnU0hPSk5vUE1kemVvMDRnVWxtTTIxZU5k?=
 =?utf-8?B?c1NvemJJaDhDYUlOSDF6RVpJUUZCZVRkTGxROGJ5MXNScURRMTN3Ym1ib0FG?=
 =?utf-8?B?WmttM0VyNFQwejNGa3owZXY4ZTZOY29UZHpjaHdLWUJoVytNNUNvYUVaL0RZ?=
 =?utf-8?B?VGdGNHhibkcxZ2RiR2pvc1liT09CTXBXaFlOb1p4Z3kwU3k5cFJ0NkkvNmNW?=
 =?utf-8?B?ckltUGlLLzdCdnlZaEw5V3JkazdDemhaU2Z2Y3hzQk9wWHI3ZGh5QUNxTGVS?=
 =?utf-8?B?MVJMN3RIOTlhNFBROHErb0VFVWdhNXdObXBwT2VuSk53NTRDVE92cE5QVWdk?=
 =?utf-8?B?MU9uTTN2VEYvTmZzNnptNjlmaGFvTFUvN3gxYkRrb2xJekJEcVp4aHBlNmll?=
 =?utf-8?B?WEFYZ2llMFU1WE1CZ1ozaE5kT1l3ekpTM3RVTG8wNnFCeXhxN1k2SDVZYUxS?=
 =?utf-8?B?dzh4RjREQmxMQW9GUTQwYmRtSDV0c1NCeEE5enNIb0FGTGNHZ0FWcTEybS8w?=
 =?utf-8?B?ZHJvY0E3c1FPRGxuUExFdEVGN0hCaHljb0pDMVFYdEZST0lDV2h5YTFHZjVH?=
 =?utf-8?B?YngvWnB5dEl0b0RocEtZN1NwZC91eG5WVURzYkQ3Q2toa3BGQWxva3BRYzhj?=
 =?utf-8?B?YzZUZkZTeGlNRm9zSVhQbitmd3MrVHhtaWluWXpHTFhma3dCcGJPcm5weEhL?=
 =?utf-8?B?V0NacGtUcmc2aHRqL0NaOHJyU3ZWZGtNZWRmMkxOaFdiOWl0K3ZqOW1hZmVQ?=
 =?utf-8?B?YVRwakwxV0laa0JidUVXZFR1ZFVKYW1sZUJncWRVYmZKcWJyQ2JrVkZ3Vyt3?=
 =?utf-8?B?ZHBzU1piM244dTk2WVJSUkdQYmN0Z1pTQUM1eGdQcW5Uakc0blFvVFZIaW9i?=
 =?utf-8?B?MllZd0dNT1p0QmFDaTUrUS9NR05Nazg1MzBaRGQrVVQ2ZWFxamZNR3l0OVUy?=
 =?utf-8?B?YUxSVG5OMmZvUjNGYXduaU9kMGJ5YndBNHJlL1NwR1NFd0FxeVJCTDNxaEVM?=
 =?utf-8?B?cjVPVHF1NDQ5cnExaVpvejhZMlBPU2tSYkV3TG5NRjd4TEZTUlN0cE1pSlVI?=
 =?utf-8?B?ek1iN25aSU5QQXNoWmowQy9XeURRK3R0SktzVHBpcFBpTjArVjFObXJLanZO?=
 =?utf-8?B?aGpQMmk1ekJnb0dVNklIa283ZDdiN05SQTVYREh3bXI4clFBTVhFdVlHTjdj?=
 =?utf-8?B?ZUcyVStEd1M3OHNxSjFOdE92d0pjMnlQMWlLQk45aXp3cmZMaU9ldG9XQUhN?=
 =?utf-8?B?RXlIUG15R1Z4UDUwYTQ5Sy80WXdWclZTYnhLbkhqZFcwQVNOSUNEdTJNNUEz?=
 =?utf-8?B?azRmQ3N1Um5weGRDRkR4VkpRUVplK3htSnZ3OE14Z0JqSzgwTlpmcEVBM2di?=
 =?utf-8?Q?PV6M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVRpOFNvcmVOVElzc01aSnlQUGEzd0VVendsa2FPZithSXpKaUJuTmcrQnBH?=
 =?utf-8?B?WXpQME00TXN3YTF5ZGJiaG9NejVyVlp4V3RxeHNSSmIxOVd4cTZFRVZqVGlX?=
 =?utf-8?B?TFBEay9YZXFzZVVtRk5zc0dzWTV3eTB1aEhLbVZ2SEdKL3UrdmJYUUlMRFc0?=
 =?utf-8?B?ZlljTWVvTlROMkpQbVpld2NlNzlZSkVyY2o5ZWs5dTFsSys3MXR0Uk9mUnJ6?=
 =?utf-8?B?d2ZML2thWGRSdDAyUWxSNFdQY1ZoUVF6TnNUdWt3SVRkVkkzV1ZoVlBaaGtC?=
 =?utf-8?B?Rnk5bktKUnY1NnI0Q3JuWWZ4MUxYRExzZWZyampOWktCOVF4SXU1NGxYM2VK?=
 =?utf-8?B?MDExTzl0Q2YrOGFaK3BDSkZBWXppMFMxMWNWWEp5NkJvTC9RNk1Iak0ybDJJ?=
 =?utf-8?B?WGlVdTdwb2V2TW1sNWY5VFlHbk1ERGdSSXozdDZkYS83SWxqejJqSjA2bDBD?=
 =?utf-8?B?cit1WEhkdWVlY0JVZDFsVUc1Zy9ZWGVxbGxiaHdJWTRQTjJFWlQrbU1JUTMy?=
 =?utf-8?B?S3FEVHd4Z21aR2E0RFIrZE5NQ05EMWlib3BjeVBtbUNrUWJGamhnbXhhaitB?=
 =?utf-8?B?YnRiNXRVd2tJclB2aFZlQ09tU2lnNkJvNzlyTDJXMUk4WDFHNnlsWmpSQ0Qy?=
 =?utf-8?B?UmtSQXhvdDM4QTNGekpOQTNrbWpaa3R0cDd5cXRycFRBK0tJelNXS3pYWFVq?=
 =?utf-8?B?d2VoU0RJZWtTY0tpbllrUlJoY0s4U29mWExiamIzTUtsWGNCMkUvZ1JVeUZR?=
 =?utf-8?B?M2ZBZkl5aTZjV2hFY2pGRnBqREhaL3k0TzlVUzZQVWppWXpsZHpwV2NKT3ZX?=
 =?utf-8?B?MWN6ZGQzSGFncmVnN1Y4UjBjN2VOQ3AwcjNXK0dMUThwcTFYOU9xa2VIOXV0?=
 =?utf-8?B?MU56TXJlellTeHkyQkgxOXgrWXZRa2phcTBkS0VEMXNRTFBDNVhCd2JMdGxN?=
 =?utf-8?B?Z2VobHJMRDRnTGZ3cllqQzRyclBtaWVmanhMMHlLWDVwK3lGc3pHbDM5WE4w?=
 =?utf-8?B?enh4cW5GQmJ5UVhlMFFaU2FnWU52cEVGbGJZdkJrRmZ3dFVUWWtMVCtBLzlt?=
 =?utf-8?B?S0FnWEE4VmltYmZtS3NidFNiZHo2Vnp2T3ZwR3QwVVBQNkRPaWVPMmJrT0ts?=
 =?utf-8?B?M0FYRFc5U3YwY0VBUlhYendxNmUwYmJkQ3hBUHYrai93WFhVdmIyOThhVHQ0?=
 =?utf-8?B?LzFmOXRlbFkvQ0oxRDhCTlF1V2NMRzVvZ0l2QVhPbUdKdGl2clV0MngzS3Fn?=
 =?utf-8?B?OEFqUGE1eGlzR3lTTmJ3ek14NnJ1WjVrZmExSlR6SEg2cEQwRExOMnlrYnda?=
 =?utf-8?B?RXR3QmhqbC9hU291V2VRZmQ0L2RzWFE3QmVYWkZCTUN2Nyt3OVRaVGFQT2du?=
 =?utf-8?B?U1Bqem90VW9tU2I1djhGQVFCSnN0d2g0b3BLTFRKeTR1a1YrZG56LzUvUkdE?=
 =?utf-8?B?RGFqUnJQUGRRVkRmVm1VRWFiemdNU3FKSnRHMCtmeXh4NEV3SFpCOTRPbVJG?=
 =?utf-8?B?c2lVUkhvTXVCNmRsc1pydzRDdTBFdnUrVFUwTThHUFBxZzFVWlR0bWVUMjV4?=
 =?utf-8?B?Q0tJLzJoaWxPMU9yTzZSTEx3cmV4dlhTN3RiY1hwd3c4U1VmMkNXU3N4aGs2?=
 =?utf-8?B?ZVUwaVdjcFFwSW5EUEZYQjY1N1VVY0x2VldXbG5URTU1cUwvcnpTUEs1b2xB?=
 =?utf-8?B?V3MyWW50YlQyRi9CZ3l0UkF6YWZmclh5WDk5TkhlYm0vdHVMWGIvSVkyYXBi?=
 =?utf-8?B?cG82VFlIclh0cHBXZ20rS2tCdU9UTnd1MUVvdWt3N1BpeXJDUHlxNERwaGhW?=
 =?utf-8?B?K2kwUDVRNzlVajVQMHNaZ1gxTlNOWVIwdDZQZ1B1ZmNYeE9SSTNjdWVKbktJ?=
 =?utf-8?B?WGNxVGg5SWhhRnpqNHpXeXE4N3NiUVN3UHhyeE9tRW9qYWpSeUo1UjMrSHZI?=
 =?utf-8?B?SDJmK3JpN3EwMHB1K0I5bFBtK1kxVFZNVkJsRExZQnRQYkVWdENBY0Myd1dw?=
 =?utf-8?B?eGdDdDl0aXVHZ1hJaE9kU2hiLzhGTjVqcWk4U1pGWVhoT1dnYUlpbVQ5SzB5?=
 =?utf-8?B?QzFVN25Uemh1MEZoaFN1bHdnbUpQendCY2w0L096Wm1YdlZKMURwaTJTNFM1?=
 =?utf-8?B?WitZTFpXSUJVMXRwTDdBYkFpVnNFUUk5amNFczFqOUFjQTErYndVbU0zcDgy?=
 =?utf-8?B?aVM1SWxVMzZ2anhmRk9iWjBUcEVUWEszZjNjTDhXbThOcW1waHRvaVpaWVFF?=
 =?utf-8?B?NUJyeFBwNm1Gc29UZ1d2eFY3TGRVUnVXL0NnZ1hTQmdGeDlsT1liMTM5cThR?=
 =?utf-8?B?cmdIa0FNSE9JOS9XK2dIajNKQUtJejVib1ZxcCtlSnBoNDNueUkrRTAxN1dR?=
 =?utf-8?Q?UN0S5f2Pl8HUBwIE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9faf0def-f07d-42d9-9263-08de59110913
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 17:18:03.6257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mr0YAPsl985aV9gCmQPLpuLY5e7oG6gwshVz9HqRmvH0W0x1mj01uGs9Ok4C8L2HsUSu+hgbhJTPrAWhta48oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF179F31853
X-OriginatorOrg: intel.com
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68757-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[amd.com,linaro.org,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[matthew.brost@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 840585B86F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 12:44:51PM +0200, Leon Romanovsky wrote:
> On Wed, Jan 21, 2026 at 11:41:48AM +0100, Christian König wrote:
> > On 1/20/26 21:44, Matthew Brost wrote:
> > > On Tue, Jan 20, 2026 at 04:07:06PM +0200, Leon Romanovsky wrote:
> > >> From: Leon Romanovsky <leonro@nvidia.com>
> > >>
> > >> dma-buf invalidation is performed asynchronously by hardware, so VFIO must
> > >> wait until all affected objects have been fully invalidated.
> > >>
> > >> Fixes: 5d74781ebc86 ("vfio/pci: Add dma-buf export support for MMIO regions")
> > >> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > >> ---
> > >>  drivers/vfio/pci/vfio_pci_dmabuf.c | 5 +++++
> > >>  1 file changed, 5 insertions(+)
> > >>
> > >> diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > >> index d4d0f7d08c53..33bc6a1909dd 100644
> > >> --- a/drivers/vfio/pci/vfio_pci_dmabuf.c
> > >> +++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
> > >> @@ -321,6 +321,9 @@ void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev, bool revoked)
> > >>  			dma_resv_lock(priv->dmabuf->resv, NULL);
> > >>  			priv->revoked = revoked;
> > >>  			dma_buf_move_notify(priv->dmabuf);
> > >> +			dma_resv_wait_timeout(priv->dmabuf->resv,
> > >> +					      DMA_RESV_USAGE_KERNEL, false,
> > >> +					      MAX_SCHEDULE_TIMEOUT);
> > > 
> > > Should we explicitly call out in the dma_buf_move_notify() /
> > > invalidate_mappings kernel-doc that KERNEL slots are the mechanism
> > > for communicating asynchronous dma_buf_move_notify /
> > > invalidate_mappings events via fences?
> > 
> > Oh, I missed that! And no that is not correct.
> > 

+1 on DMA_RESV_USAGE_BOOKKEEP, I reasoned we have to wait for all fences
after I typed the original response. For example preempt fences GPU
drivers are in BOOKKEEP which you'd certainly have to wait on for move
notify to called complete. Likewise a user issued unbind or TLB
invalidation fence would typically be in BOOKKEEP as well, which again
would need to be waited on.

Matt

> > This should be DMA_RESV_USAGE_BOOKKEEP so that we wait for everything.
> 
> Will change.
> 
> > 
> > Regards,
> > Christian.
> > 
> > > 
> > > Yes, this is probably implied, but it wouldn’t hurt to state this
> > > explicitly as part of the cross-driver contract.
> > > 
> > > Here is what we have now:
> > > 
> > >  	 * - Dynamic importers should set fences for any access that they can't
> > > 	 *   disable immediately from their &dma_buf_attach_ops.invalidate_mappings
> > >  	 *   callback.
> > > 
> > > Matt
> > > 
> > >>  			dma_resv_unlock(priv->dmabuf->resv);
> > >>  		}
> > >>  		fput(priv->dmabuf->file);
> > >> @@ -342,6 +345,8 @@ void vfio_pci_dma_buf_cleanup(struct vfio_pci_core_device *vdev)
> > >>  		priv->vdev = NULL;
> > >>  		priv->revoked = true;
> > >>  		dma_buf_move_notify(priv->dmabuf);
> > >> +		dma_resv_wait_timeout(priv->dmabuf->resv, DMA_RESV_USAGE_KERNEL,
> > >> +				      false, MAX_SCHEDULE_TIMEOUT);
> > >>  		dma_resv_unlock(priv->dmabuf->resv);
> > >>  		vfio_device_put_registration(&vdev->vdev);
> > >>  		fput(priv->dmabuf->file);
> > >>
> > >> -- 
> > >> 2.52.0
> > >>
> > 
> > 

