Return-Path: <kvm+bounces-18261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC4C8D2B8D
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 05:46:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 07602B222B5
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 03:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E565815B133;
	Wed, 29 May 2024 03:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sxx3fAOl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43AC10F4;
	Wed, 29 May 2024 03:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716954361; cv=fail; b=LTSCWa7ZSZ+8DOMGofoL1VzeOfl0RpUdWdILQX7kwGYdHj2QerpfmlH6cgphsL8t8jIapI8Ia4jN3rd4UYSRbadkOPZ49Xlbz99vCa+FG4VtmLMAqjyqikywFG1+NmuCuRTh7SbnjCkAnWou6EUPShtXF7S57vHzY4bj03qXaIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716954361; c=relaxed/simple;
	bh=K8wtBwhH2W9aCXQoyq5ON25cFmyEFHEuhlZGGDB1VEA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VIsX2DzWByYgh9dOEhPJ+2MPqNjgKBL6RrqbkAezaOAAbLqMMry+CqXk4jM0O/63biywrigh8NQ1glxtHvvYhUvelBLDk4MoqozEBMA59i0b/PFNMIpoSoXhuFM4GAV+LgJC87w5CJ8LJ6lMgPrLt80fBnjwNHFI/bwgai1wheU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sxx3fAOl; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716954360; x=1748490360;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K8wtBwhH2W9aCXQoyq5ON25cFmyEFHEuhlZGGDB1VEA=;
  b=Sxx3fAOlY/fZNFOAPvqy2NI2wXyXTYzpl92jjred6m6n4kMjxJ8cUW8X
   D3lgKNgl1c7tN+LiHV83crjOCUy0RrQ9tmUCNGcs20uG4UDSGs/DbM+yJ
   bS0t69vdUws+RCH4GXLZmw32Gnrrbr8D8JOIAXjMbV5jizxLqAaqZL/6n
   I80AzXKqIfW3z6JKtXMbPXygba8QR2G6dJwcRNGeWIqVDHsAFkZJgNaiP
   WwsCjlNEcZ7d4CZsM3Vf34qUH8GJNpWPuGUjtAsLP6yHhWXURblkQDrMl
   G4TDe7+tmefJ1agXtWhficoZgLg/t2zHak8EhdQZI9+bW87F/IkUi7Tuc
   Q==;
X-CSE-ConnectionGUID: SotOmXY3RYGrE8pLLXlqKA==
X-CSE-MsgGUID: u2Hnhqk2RDOpy8cm3amncA==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13466738"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="13466738"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 20:45:48 -0700
X-CSE-ConnectionGUID: yXIlW1ahT/O6FzMdXl8EwA==
X-CSE-MsgGUID: ARI66Q/iRiq6A/yK7B+wcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="72736701"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 20:45:47 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 20:45:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 20:45:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 20:45:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZuMSvOwYlwJsNfn4I3uuxqGale0k2dkY/CcW9fkRjBdeL29v7HMhPh2T+LRS2wB3uPgeu4AR5x8AT3R8FnfCwW+47HDMu7DyKXsdG4AiFqeaDhaOdSVZud/HoiZRwWZYT2eh2GqDxbItQsCfYUcZ5lDWK/DzEj4a6RVL9oJ6qOElI2cTKYn6g/sTB6a93u7WZgumgSETYtHHOuwQ4h7nR54TlNonLOcU3gCfRT1MmJdeuzP8syUBDr0E8vQbjr0vf8rQElLqTKPjSuz3qxTL6cWJtxCptpdWntW6uu/L4oJyeNW/Ow+3daF//m0jLk7lzGrZhx5eZMGfFlg1Ly541A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrbs1EqcP+PE0K1FZZCwQisgED3c9dzE6wbxUAcDFwA=;
 b=XZVCKcl19nDRk+LgyUQWMTw0RHnMlJMu+aMFALd+kY3HxIksrk1pM6IPzSp3dFwsHcUIfg/xN41ziFsh3Yp2/1eCHNgUJTr9XGi2TvZdA8kpi72K8ytO40V5xj4LBdZX6cUEwZJ5xJITJsT528JOleALxGe3k+jiBm+yLEoMFSYOXXJOB7XXe2WFnJAY6oeS17UlCD89bc+bnzMbqrpt91l5HrY4qo4p05VIZRJeyzZ8kn+33aLavQwiKkGKT0PbuSvL5l1/UTKtcv2qaLf88K29l9r37glm34oZm0Yu7o0HoF/jIRkSqaYHHEfhozZ/OKAI2pGSysmj3lIgroj2eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by CH3PR11MB8591.namprd11.prod.outlook.com (2603:10b6:610:1af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 03:45:43 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%6]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 03:45:42 +0000
Message-ID: <795079ac-d288-4a60-813b-dce10e95e92d@intel.com>
Date: Tue, 28 May 2024 20:45:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] vfio/pci: Support 8-byte PCI loads and stores
To: Gerd Bayer <gbayer@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
	<schnelle@linux.ibm.com>
CC: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
	<pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>, Ben Segal
	<bpsegal@us.ibm.com>, "Tian, Kevin" <kevin.tian@intel.com>
References: <20240522150651.1999584-1-gbayer@linux.ibm.com>
 <20240522150651.1999584-3-gbayer@linux.ibm.com>
 <2b6e91c2-a799-402f-9354-759fb6a5a271@intel.com>
 <b1ee705ee3309405273ed1914a4326b9b024edf8.camel@linux.ibm.com>
 <8675abf2-00ca-4140-93be-8b45b04a5b7b@intel.com>
 <b0a5bf684bc264dd4bc1a13657c51db5ee006b59.camel@linux.ibm.com>
Content-Language: en-US
From: Ramesh Thomas <ramesh.thomas@intel.com>
In-Reply-To: <b0a5bf684bc264dd4bc1a13657c51db5ee006b59.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW2PR16CA0046.namprd16.prod.outlook.com
 (2603:10b6:907:1::23) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|CH3PR11MB8591:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fa18b89-438f-432a-3434-08dc7f91d09b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aThqK1M5WlFmZ2FZQitVemZLdnhzOHVmUG9ybjZ6YlRNTkkrcFRRM2JoSWJh?=
 =?utf-8?B?NmhCV0lQRiswWDZLY3FaY3ZvTWF0NzcxS2FmV1NGQWd4TGt5YW03Q2VBZHRq?=
 =?utf-8?B?ZnlCL2l0KzU0ZGxCUVNoYU1IWUJTTlJYb1RHTGF2QlBQV1J5eENDbHc1Y3A5?=
 =?utf-8?B?ZG1pODNNVW9ueHBzT0VpM2MrRFFvTmZjRGQ3bzJyeXhPWXRmN3U1KyswRE9H?=
 =?utf-8?B?ZWFZQkxERm90cUlsc1VDejRrNU11VkVYRG05OE1ZQ09VTUpXMXVxU1VycE1W?=
 =?utf-8?B?NWduYm5lb2JFZW05YmtCcXNDd1NCbGg5NEJVdm1OUzN3aFBYOFBMRVd1QzM3?=
 =?utf-8?B?R05OVXR5N0oxRnVmcTlMdHo1MTZ1SU05LzRwM3pidHZBRFJ6K2VaOEpBOGxa?=
 =?utf-8?B?ZkZMNFU5c3pIKzJqWEhmTHF3VzBJSkQ0Q1FUdE5MblM2bEtkbDJhNTFmM0xO?=
 =?utf-8?B?b2JtRFlpTXVVeHF6RVB6alNIZS9WYlUydHRBOFZuWHVybnZaVitnVEJiZ0ox?=
 =?utf-8?B?MVhvQ2ZuQ3M3Z1MxbHdVZDhCcjVaTml1dnlxMlRxak9TaXY1L1JYa3ArcFpR?=
 =?utf-8?B?RldDYzZHYnpoYjk0QzRUTU40UTJ2ckdOd3dYZkFKRThmYU1RdlZNaXNVQTBL?=
 =?utf-8?B?R2w1VnRwblZTUG1yZkRlNDdxSjFYd2xrdFk0OTFwQmlvTWpVRHl4YWZlVnBO?=
 =?utf-8?B?UTJEejc0TU9VWHhTa0NnNU9zcjZ4bldsK3ZUMktXTkx3TFZ0NmVOTGkzU0dh?=
 =?utf-8?B?WVdXWjZ4cUtzbUxoR2pwbTArckluT1V2WWNqTFoyY3B0WVpWU2JnNm5ScEls?=
 =?utf-8?B?YlZYck54MFU2Y2FNQ2tBejJjaGlwWUkwc21GV01DS1I0V3l2NTFsaDFYRGVw?=
 =?utf-8?B?b2I3R3ltdjVLNUJReWZYUGdWMmVsNUVHYnRtWjZUQy9aRC9mTDJQcTEydEYw?=
 =?utf-8?B?R0lHVC82TmNiZHJ3bEpXYVYwM1NmdHJzMkxIaWV0UHM0K2NOall0ZEJxNXVz?=
 =?utf-8?B?NkN1VFQzOFlhVnpKVVR1d0NRMnYwZ1RpdnZKVjFCbDJkODFZN3ZtY3ROa2NV?=
 =?utf-8?B?SkFqVDNQaEF4ejdQWXFZdWhuUzVWL0xScjJWYVE1U3dQYXVDbWlTb3J5NWtk?=
 =?utf-8?B?cG1UVnhGZjkrbVFXT0dDOW85SkR3V2docXQ5cUZtamRibjdSU3BjZUpvN0dj?=
 =?utf-8?B?V2ZXNHU5a3hHWWJOMEJPZG9NMjlqRFd0eGZOaUJyM0ZQdXJEdHY0OXBHVnRo?=
 =?utf-8?B?TVlwYlhEUWswRGZNK1B4RGtQbjJ4eW1yWGxrQ3ZXNGdKTFgvdUZxcGgvb0VJ?=
 =?utf-8?B?eW4xbUtMUzdndEtaNTBtNkcwaGxUVE9QKyt4NUVCek5JNklmM0dHVmlGbkFz?=
 =?utf-8?B?bXErTHZ5NjhQdm8yVHFMM0dnZXcvSDExemZBYncra1ZJNXNCLzdIYUJjS0dY?=
 =?utf-8?B?SVVTUVI2OW82Vi9NMGR0RU1oZGFrT3d2NEgzdFk4Y0p2Zk9teWlVTmpTbUxo?=
 =?utf-8?B?cXBVNzZ1SXc1QTF6YTgwMWhVRjMwVHI5UkhXK3ZBKzdpWk15NC81TjZsR1Vz?=
 =?utf-8?B?ZjBpb2F5dDVJWk9jd2lZR0lIMkp2enRZOTU4Sys2a3JMUTFic1BZR0g0dXFr?=
 =?utf-8?Q?lmXp2y7oP+hipVaJeCeWde+D6piOFEb/nPAZGEPPSzZg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGF6WU1nR1VzMlBBaXIzaEFBNG1ySm15WjY3VzBpTWZHcGtDWHNFVlZabmY3?=
 =?utf-8?B?MXp0NWVrVU4ySnZWd09kN1Bzdnphc1E4bDk0U05rU3RYSXZ1c0paWG5rV2Jk?=
 =?utf-8?B?ZnlPcmlocEswUUdVMDh5SWdkT1hzVURvcW1DY1RhdUhwU1Ntd3V5c21pbmhK?=
 =?utf-8?B?b0hWSll0dm54SU9iOXJqWHdTOTc5dTkyLy9QWUlQdzVpVzU0Y3VGR2tDemwx?=
 =?utf-8?B?RmlzVG4yNXpqNFd0V01zeXEyR1hVeDVNVFBkOUxaeVViVWdhVmdsaXlZQVE2?=
 =?utf-8?B?akUrOU13Z3NNVGJrMG9SdGdtaXhjNTR5RDI0NVlSUksrdkErK2ZTa0JnSVdR?=
 =?utf-8?B?VHVKaStSYU8yMVdWakJRam9nOGY0allEYXQyY3ZVS0RwaVZpY1lSTmxEQnZl?=
 =?utf-8?B?b3RpV0Fpa1VYWEoxUTgwK3pwM2Z2ZHNrNm9mVUFvU3ltNUwzS0kyWEkrbnY2?=
 =?utf-8?B?dVovQXdzdkNnK0tTMzduNndqY1lJdmpiTFV6QWRRTkpzVVRMT1oxMlRPaW9q?=
 =?utf-8?B?dEtTWm5NTUpYZTA2bmlrMWk2TDFmMFpSQ2JRL2l5WFdxQ1h0L2VObStQNlFy?=
 =?utf-8?B?TXlIRkxpMFpJWjJvNi9aNHZ3WmhqSndJME9vc2lEaTAwUjRpM0VtMG50ZW5m?=
 =?utf-8?B?RHdhNmlnYjBTb1RZUTMveFVOUVhUZ2Z2N3k2Qlo1WkZ0aUlIQUFJSHRKVTlq?=
 =?utf-8?B?aVZUN3ZrUXEwVVJsNDEySGszY2Y4d3FEMEY1MlNWaGRvdGdMdnNwZ3V2b1VY?=
 =?utf-8?B?UXp4aDFvazFWQnFGditvVFdKS3hoNk9BRE42dHVHWDVJME83YzFZUlBkeGpi?=
 =?utf-8?B?R0dIQVU3MlB4V09aOUJxQmVtOHA1OEZORExjK3cxMU5EQkJTaWpQUmhjRElJ?=
 =?utf-8?B?czNuUFN0SkRkV2l0dXZJWkZJYS9ocFY2elIxSW1lSlhTclpHeFl5YVVvUnll?=
 =?utf-8?B?WnlHT3hCcUxhN1psNzUzOW5XbHpjejlMelJjajAybW9ldzV2K3BIdDVCMDdB?=
 =?utf-8?B?bHcrOXdQOHg2UnRaWGVzd3Vyc3FWekhVNUlTNnZwNm95T3hmRWRUY0RFemww?=
 =?utf-8?B?Sk9OVXlla09wcG5VaUp6b3AxRnJkTjVJaHpQWlJlQXVON3IzR3g0WkVFSTho?=
 =?utf-8?B?UzRoNmRFWXJZNmZKUlVCcEs4UjJlb0ZZSkxMV0pncEJnSnM5UUl2S3l4ZFVC?=
 =?utf-8?B?YTgzcTVMV0lvTDBKc09YUnd4Vnp3VHduOXZDNThNRWE0d2xZNmZNMit2bVhU?=
 =?utf-8?B?OFJUM1JJQ25JZ0VPR2wrcWtTcVRsYWI5WERCUnBWQ0xSNGc5Q1h2a2wwSjVp?=
 =?utf-8?B?VnIyY3N4dytodVNGb0wvRlRCOFhjdXVGalF2OTNsWXl3MzlqVzUyM0VpL3RG?=
 =?utf-8?B?NTRMeWppeCtUc05DRTdOdWtpUzdUQ2VQNWx6T1EwTk5PbTlLVDMvdDdWYTlH?=
 =?utf-8?B?disvWFNlcVowZThOdkF4TjRRcnVYemJ4Wi9BM25sdkw0YWZGd3NLM243YUtC?=
 =?utf-8?B?cXhPS0o4NmQvbFZZcjhuTGt0WUpucDdiNzJXVzkrOTVkdC9wditBemJLaHc1?=
 =?utf-8?B?ZGd3R3U4R2wreXBDd1pMMHVxTXRsTVhtOWxaV3RCcG1ObFVlUitxWmZKL3Uz?=
 =?utf-8?B?bHF0dDZtYkE2dExqdDZWN3dsdUF4Q3ZCc1RoZWM3UmJKZ1NnYXJzRy9tbFJC?=
 =?utf-8?B?QWdnNVhSbXVCbW0wUERIZlk2Yys1NmMvZ0t4b29UR2RkUFExcFArR0pmUC9i?=
 =?utf-8?B?V2E5LzhRK0IwK1JXdGhlSEd0YWVEVUg0bGVsa3FlRkZCWGE3YllsSXdYdnM4?=
 =?utf-8?B?TkZJTFM1QzNlRTk1aGFYWWYvUzlpdkRSWVFmYzJKWFBLeEhQU1pObUdVd0RC?=
 =?utf-8?B?dnJjcllnenVLc3lGRmlCdjRtTWptdkpKN2JjRktUUkZKOGJpNDVlQ2lVc3Jz?=
 =?utf-8?B?KzVFSEZGN1JPcjJoM2FHYk1pejlFeG5HNmdxZEtMM0hsai9mQjJNRERlMXVU?=
 =?utf-8?B?c25kVDdFVm5BMWlaOS94M0JLUWVObnB4L2FwekFYWVkwdkF2UjB6Q0MvYjFD?=
 =?utf-8?B?NWZaeGNJQjd3RnB1YVh4RFJQUWlzMnBPcGM0ZDFVcElkTCtPck9EN3RoVUQ1?=
 =?utf-8?Q?uf1VRd5GKXciQbXkGQqbyiGXf?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fa18b89-438f-432a-3434-08dc7f91d09b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 03:45:42.8236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WyVmFbtWVCGua6rOjnEC1UHMFjM2Qj+5PGZUfuYN6IbuT578KF1qfCHi6do30NqGwoh81kGuSWhpEfFr9BKnIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8591
X-OriginatorOrg: intel.com

On 5/24/2024 6:42 AM, Gerd Bayer wrote:
> On Thu, 2024-05-23 at 14:47 -0700, Ramesh Thomas wrote:
>> On 5/23/2024 8:01 AM, Gerd Bayer wrote:
>>> Hi Ramesh,
>>>
>>> On Wed, 2024-05-22 at 16:38 -0700, Ramesh Thomas wrote:
>>>> The removal of the check for iowrite64 and ioread64 causes build
>>>> error because those macros don't get defined anywhere if
>>>> CONFIG_GENERIC_IOMAP is not defined. However, I do think the
>>>> removal of the checks is correct.
>>>
>>> Wait, I believe it is the other way around. If your config *is*
>>> specifying CONFIG_GENERIC_IOMAP, lib/iomap.c will provide
>>> implementations for back-to-back 32bit operations to emulate 64bit
>>> accesses - and you have to "select" which of the two types of
>>> emulation (hi/lo or lo/hi order) get mapped onto ioread64(be) or
>>> iowrite64(be) by including linux/io-64-nonatomic-lo-hi.h (or -hi-
>>> lo.h).
>>
>> Sorry, yes I meant to write they don't get defined anywhere in your
>> code path if CONFIG_GENERIC_IOMAP *is defined*. The only place in
>> your code path where iowrit64 and ioread64 get defined is in
>> asm/io.h. Those definitions are surrounded by #ifndef
>> CONFIG_GENERIC_IOMAP. CONFIG_GENERIC_IOMAP gets defined for x86.
> 
> Now I got it - I think. And I see that plain x86 is aleady affected by
> this issue.
> 
>>>> It is better to include linux/io-64-nonatomic-lo-hi.h which
>>>> define those macros mapping to generic implementations in
>>>> lib/iomap.c.
>>>> If the architecture does not implement 64 bit rw functions
>>>> (readq/writeq), then  it does 32 bit back to back. I have sent a
>>>> patch with the change that includes the above header file. Please
>>>> review and include in this patch series if ok.
>>>
>>> I did find your patch, thank you. I had a very hard time to find a
>>> kernel config that actually showed the unresolved symbols
>>> situation:
>>> Some 64bit MIPS config, that relied on GENERIC_IOMAP. And with your
>>> patch applied, I could compile successfully.
>>> Do you have an easier way steer a kernel config into this dead-end?
>>
>> The generic implementation takes care of all conditions. I guess some
>> build bot would report error on build failures. But checks like
>> #ifdef iowrite64 would hide the missing definitions error.
> 
> Yes definitely, we need to avoid this.
> 
>>>
>>>> Thanks,
>>>> Ramesh
>>>
>>> Frankly, I'd rather not make any assumptions in this rather generic
>>> vfio/pci layer about whether hi-lo or lo-hi is the right order to >
>>> emulate a 64bit access when the base architecture does not support
>>> 64bit accesses naturally. So, if CONFIG_64BIT is no guarantee that
>>> there's a definitive implementation of ioread64/iowrite64, I'd
>>> rather
>>
>> There is already an assumption of the order in the current
>> implementation regardless e.g. vfio_pci_core_do_io_rw(). If there is
>> no iowrite64 found, the code does back to back 34 bit writes without
>> checking for any particular order requirements.
>>
>> io-64-nonatomic-lo-hi.h and io-64-nonatomic-hi-lo.h would define
>> ioread64/iowrite64 only if they are not already defined in asm/io.h.
>>
>> Also since there is a check for CONFIG_64BIT, most likely a 64 bit
>> readq/writeq will get used in the lib/iomap.c implementations. I
>> think we can pick either lo-hi or hi-lo for the unlikely 32 bit fall
>> through when CONFIG_64BIT is defined.
> 
> I dug into lib/iomap.c some more today and I see your point, that it is
> desireable to make the 64bit accessors useable through vfio/pci when
> they're implemented in lib/iomap.c. And I follow your argument that in
> most cases these will map onto readq/writeq - only programmed IO (PIO)
> has to emulate this with 2 32bit back-to-back accesses.
> 
> If only the code in lib/iomap.c was structured differently - and made
> readq/writeq available under ioread64/iowrite64 proper and only fell
> back to the nonatomic hi-lo or lo-hi emulation with 32bit accesses if
> PIO is used.

It determines if it is PIO or MMIO based on the address. If the address 
is >= PIO_RESERVED then it calls readq/writeq. PIO_RESERVED is arch 
dependent.

Looks like if asm/io.h didn't define ioread64/iowrite64 already, then 
the intention is to use the generic implementation, especially when it 
defines CONFIG_GENERIC_IOMAP. lib/iomap.c and 
io-64-nonatomic-{lo-hi|-hi-lo}.h include linux/io.h which includes asm/io.h.

> 
> As much as I'd like to have it differently, it seems like it was a
> lengthy process to have that change accepted at the time:
> https://lore.kernel.org/all/20181106205234.25792-1-logang@deltatee.com/
> 
> I'm not sure if we can clean that up, easily. Plus there are appear to
> be plenty of users of io-64-nonatomic-{lo-hi|-hi-lo}.h in tree already
> - 103 and 18, resp.
> 
>>> revert to make the conditional compiles depend on those
>>> definitions. But maybe Alex has an opinion on this, too?
>>>
>>> Thanks,
>>> Gerd
> 
> So I'd like to hear from Alex and Tian (who was not a big fan) if we
> should support 64bit accessors in vfio/pci (primarily) on x86 with this
> series, or not at all, or split that work off, maybe?
> 
> Thanks,
> Gerd
> 


