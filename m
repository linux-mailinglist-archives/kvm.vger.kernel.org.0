Return-Path: <kvm+bounces-53716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D63B5B158B5
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 08:06:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C8757AF9CF
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 06:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9EFD1EF38F;
	Wed, 30 Jul 2025 06:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dtGeGZ3c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED5D1E5711;
	Wed, 30 Jul 2025 06:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753855550; cv=fail; b=V8xCwpSXquFmBTQjxNQpnBoy7v4/dIojiTjbY+LePDqvArEjbHTceAchhuBN1E8PXdPFlp+cY5ALJp+E9rOXYN8eTsDGvK2emXG8E8gWofuiQrIiHi+uJ/VCE2mzlTChLmKXKZbec1GlDDLsuujAF80/lYiHj7eygKGehO4bQKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753855550; c=relaxed/simple;
	bh=ocOIb2jfPEWez1FX8dGyoBRIlGQxhm/O/p390wsEWs0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ptep2wrjHMgVySgHUF4k981NJb5WYxkrPV17TnGmhSdr5psKv0fLGz3JUs+9BAxE1RpAv3jX860mvoP8vF6jrmgjRzkk6BQsomYy+LCoY9BLNGAHdErzESZyykhkeBv5T9mFqWNbeOdQpQVQCl7+Q8p9TvxRKgVU2EC1ohy6A2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dtGeGZ3c; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753855547; x=1785391547;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ocOIb2jfPEWez1FX8dGyoBRIlGQxhm/O/p390wsEWs0=;
  b=dtGeGZ3ceHqKwb2SbIyPx1mnzb7cfkRU1FCLvhR2qPa8I4sVpChvWiO7
   TdW0AugcMHXGUdhsDQa0Oga6T98CHeHZ0EFnGUAYs277XqUjyqcbjPWqo
   oHhpWurAV74h9JLzd9+EeSmVYh2SYRBxrd/aCv9qDqFU8v93Zv2o8Htpz
   s70swCs19ViYjKwp+woGP9Eb2g8bBseN6vf7YkbMWYXlyFlA30nBSF8A9
   UranXRFls4D7ALlkybfSwxXUfOzAdU1Ob0Hfz8Lsku8+4Ob5tFV7t1ajt
   gEQALQADLBStaiPDEXUB7+WwmWs98ObmXhwxazPAvnEp5hs0gwvvlQxvk
   g==;
X-CSE-ConnectionGUID: HLRf3ojsQO6b+sZFgRbCrg==
X-CSE-MsgGUID: Rg1dizdTTp+5JTJTiqMWLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="43747864"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="43747864"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 23:04:57 -0700
X-CSE-ConnectionGUID: beWNylJQTbq8TO8MV92NJg==
X-CSE-MsgGUID: CC7ZEvAmQLOQDak/YOmPBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="167080689"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 23:04:56 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 23:04:56 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 29 Jul 2025 23:04:56 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.89)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 29 Jul 2025 23:04:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yCz0uf97KVEl3d9cwyCouKkmYP/Jy3jA8kzg5HjR6V8udn9CG3Z/PO+DN96Ft+8jg6qg8t/s1X+5RX/3FJa92daQLMwNv/3XwQ71So3LPnqSVohZGkLphBZqN1Mrc9JoGkVUMynN8iZFd395LMJfmUZ6tlgF8Cj5FqnTU4M68j5rGK445qGEY9B+2CPX1AMC2f8AOXp+UFex6OBGkA+mAa7tMV5OawBSunESF8tnX086zFtBC9zaqWxQsK66B3c1Zx3f4i3aq6O+e9A5TabShkWQCYae1xHbU5kFzpyQznxAG7kv9nMCKjX4+bw1nxGxyKlvVSD1i0lMjYIw7/Np1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qHOxrxNXm3HOZNN7/UCyNwtfbt5iz+ZDyawY2+bGFk=;
 b=Ea8uRvtpW09+XW/j9e/CIlX96AQ1tAM4qXMQkBNv+VBqFt5ZWexhKGcXzCPoRi44CDLSgSZZ6TeekMCbx+fBQLPlVY7+6BuICy8MCcoi6WBbaqjPHomH+ldpnkdkGZxH0zxubgcywDxaUFsP7bggTQ0VzO6QFYF3LmO+IP2aszKiNgBxUeHXIy5WSW2Ye3AJdZ6ynXy717UMQzR65STxD8vZQ1yMu1bE0HVupWaS4lHbrcgPYNiHtG0d3hu4xw5Dh0i2d29Uo9Kklb+uoBuWL0yFVqW5b7i7DbiXNKqU1q8u2zZdL6wC/bAKRyqE/CBXnWVu13wxZfNRPS3pavtplg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6426.namprd11.prod.outlook.com (2603:10b6:510:1f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Wed, 30 Jul
 2025 06:04:46 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 06:04:46 +0000
Date: Wed, 30 Jul 2025 14:04:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Adrian Hunter
	<adrian.hunter@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, Nikolay Borisov
	<nik.borisov@suse.com>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Message-ID: <aIm13dDJf4/jGxKv@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
 <20250729193341.621487-3-seanjc@google.com>
 <1b0ea352-c645-461b-9e19-5202791f8e2d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1b0ea352-c645-461b-9e19-5202791f8e2d@intel.com>
X-ClientProxiedBy: SI2P153CA0021.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: a9a25ea9-3dd7-41c9-6df6-08ddcf2efc56
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?l90mjnPdjScvXt64dWx076+xpuYPX2SCVq3zqfvFM8XaVY/S3k7EuOe3ljSu?=
 =?us-ascii?Q?vasHYCRfDTHuY4vWyQIZZIsUvZjfIT0pI5r/wkzSYGV+9p3LKnsD1Gol0OlY?=
 =?us-ascii?Q?1+6zElXyC8xxxMghXKAu1cxy5sBAy67lUPiC61KP+MLpJ4Ypjv6Ja1ElWwht?=
 =?us-ascii?Q?gtAJlxwcCWmx/XRN61UuuHHUF71rZD2zUl5m2mG0fEHi+IyEfLVEhJ45jalO?=
 =?us-ascii?Q?LnRIhdh7xS2t3gF6CGtUad3tjXOR7yB//syVapxHFlVDlKpy8BAWcyuHeX8m?=
 =?us-ascii?Q?2axFZpaRKdQe8YuF3pSeL47IR52MP7Qb31Y69Hk9ODbx3bw3jdmkxC3CcM41?=
 =?us-ascii?Q?u55/omMl4klXDjrmXKa5U9VSyT3S6G8X/auZDN8jt7JlSIRznHNGok5iw41V?=
 =?us-ascii?Q?UvduLiKCO2YQC3rqHB35uIjGMozZe9tqJnwFdNy04XRxtsd5CkTbhmXPzc3d?=
 =?us-ascii?Q?3hCOu9cWbleTVXhU9K7pF0+r+5UHgOhzzn41vtgbNm6JvMJELSU1OwBXsVoq?=
 =?us-ascii?Q?xE+9QGF/gRu1FwUymIJrDAsYAYcVmMPMX3V5Aa9rygqSwXNBVhvmcWCnL6Fl?=
 =?us-ascii?Q?WYX67hWVAspoarMM2fPL/Q+buokk1GbYaeXr2ITCi+6EEG0kGnb8/LHbCkB3?=
 =?us-ascii?Q?7xwkCZ6qLIodmhOCcQi1yYyahXoh40nOeaHh/Bv5g1I5fCc/3BLrkMGbpn0n?=
 =?us-ascii?Q?Ty5TKswSqmHRXXZoOvTnYDlBE2ONe9yZroCccmgnvGniLSpjOlMA98WY42mC?=
 =?us-ascii?Q?M+mgpbOMm0iyhgOQymOnxIM7F7JRDz5mm/XmOH9S9e5KA7nP2CTqi/ESSZbf?=
 =?us-ascii?Q?lX0NwmKkqt/7szzkECejnJnGxCVzTDDqu6Su/DZUNlt4ojVSREcSaXH9+4io?=
 =?us-ascii?Q?72ItQm9/NHkZif1Gr96esqzgeiPZKCE1dvKzdKtX/C4Ipo/KGhXyWRAoNXyJ?=
 =?us-ascii?Q?eQWMcACX+CYgx+kUjA19n1Rxv3086+bSXJfL/3DJcBbebden9kYZhAAymtZl?=
 =?us-ascii?Q?lPYXKEBi0bbdMc2iX9Y5Yk8gpwOzGrtavqh+KmNyhdflLeI0vp4jN4bQ8Onr?=
 =?us-ascii?Q?g4POZBYE+11jFzWY893bSGP2jI+cwSlXV3JgJm/SbY27lCJwQy3c7cpJwTAG?=
 =?us-ascii?Q?9BekcOPno5hBbPLBqcu7+ArD0kcILPvnFh/EwhEeAxzFNbHyXvm/V/8VEP0z?=
 =?us-ascii?Q?d3q0NBewLJfna4JMcxBqgouob/VE7LaL4UWMj5JbGTgY5/bRlj9udqa6grj7?=
 =?us-ascii?Q?J4aEpt4y7X2WnmNnLdafAohSiCAUGMHIUKOe1sgPe8P1aQxD4a4LUbJlzM91?=
 =?us-ascii?Q?Fh7WjM3zemmdBNSr2lQuNk/USiVg5k8gDqovvKlj2IyBluQDv7az/UdVmLOB?=
 =?us-ascii?Q?gd5t33tUaEuBFzK8GhreylBvwBAaR2B5ChpDYqFTG/rYBIO74r9DNqvxbJVF?=
 =?us-ascii?Q?XozscQxDsb8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qeH5KUlGpEKoahCkSh5LX/ucya3f7dpoAz+w6SE6C3Ks8M/FBnqwap5Ds7c+?=
 =?us-ascii?Q?UFJBXa233TDYzqHZ4ZlZKndnPDXhwoKicokhxCi8bDO7Zqtbtw39iZmGA/1c?=
 =?us-ascii?Q?T/1azY5NV6ckmb1EN6jGM3p6Ky7257KtiozmAjoRSlz1n4iZnvOSy7hFTZJJ?=
 =?us-ascii?Q?be0ui5bXQUfK1MZFnoqAq1MwnzwrBmTj/I+88IxVnbUb3Og1oTKbLVlc+Zcr?=
 =?us-ascii?Q?lxiHt4ic9fjEE6lAtJyQsdOSuYiPmGLtmvT0mrSXU2XJB+BJ7xzcEmITD96I?=
 =?us-ascii?Q?G2NS7aYQfj5wX9p8jeWuhq4m1sGmED0NdQRH/h6oylJK132niQTYPhvglWIP?=
 =?us-ascii?Q?BUOmw1JZOgLHD7ymS9pIkTKtWe+uWgb8+TVxrB107/MvYWRn/mvRphAevu4t?=
 =?us-ascii?Q?bmZ7YAdS/0rezXjBRa8KMarGJl51pATqhQY4ORpK3RZ/BwFd4aAOayP60dkg?=
 =?us-ascii?Q?Gj7ia/ozsJdWgaXqwYGRF5mcG4LZm2uhnZK/9Aq0agbyFjYOS+abASYi1RrQ?=
 =?us-ascii?Q?kxG86hKAotjwjcVeHu2RDDpkbhC6CmtKQ2jEymNof39rWWs50EM5R7Arkhv4?=
 =?us-ascii?Q?chKKH3GhPnzE+VAP1nIXbtDLfBA8f867z6IMMOulcVldtPpwmuUntFiCfnPu?=
 =?us-ascii?Q?ah/UD+TBUDzIy9lPvHf+Q/ij9n1bpNc5qR7ES9SN+l9dxVv5FcyHirpQtKL8?=
 =?us-ascii?Q?lWQ5TbHvXaAwCZQIQGVbRGhWGOaniJkVdeFT94Fygu2R2SpYtRBTnIfKH+ou?=
 =?us-ascii?Q?aLlzzNvpRklrTGHbcUSpn+tp++TCYj0Ye6JOvxlJPajSG4MM2+8ToT4Pdx+j?=
 =?us-ascii?Q?7noeJcsSZ8OaxFAtT7fekugYYYs27lESKrF2zobLML+ExmY8WTrT6iNxPPRv?=
 =?us-ascii?Q?T+omcocstFnu76y+v4BKvjAwAIewLjiEOiau9u1zEDSX6C501I0Wqd5wXpwi?=
 =?us-ascii?Q?2S9L5kgWxLr0doH601Hi5X2Tqo7SRBHS7kZTpk140lIYUnmY8nDet5Zzc+Sm?=
 =?us-ascii?Q?WF8kPsSAo8VghXATuiIFSkbzf/QTnV7+jwu7f7LaIT5tw/06dCDmrBfceyEr?=
 =?us-ascii?Q?sJIqdcm8Db8AfuNBRjCazsgqyuWlXFOgB/a5YM0jfHXu/QB/q+Q31xgNA7/h?=
 =?us-ascii?Q?pY8Sb5wdLT1V5oSYeh564WaL91zGIakhCcI2BZlazKFgrsbrwcPkKxkJlSOG?=
 =?us-ascii?Q?OHJc9kPhN53kfcMYb7ZrZvOCMdxGAWGVemcPTBKr7c3MLgkZBJaIHSwXxEWS?=
 =?us-ascii?Q?jjiDoD5V8LjE1p9soInTuKL+E+5yj8F2Ve/QW+5/HBNNP/0w62rZtE/tK8WS?=
 =?us-ascii?Q?hqZdSWn7PU0v4x6WjXzujRfKSCJGuu2VrwS0Cr3aq93KnmgNydcufVyEyKUw?=
 =?us-ascii?Q?9426Tl59amTk0gWVpz9CtLBmhmVc7fLFNt4Ox1d854ltdZkY/k908kt09kl7?=
 =?us-ascii?Q?8frvDhsl+oGWYjnlmEc7OkNjY+VSgyTb3wUU9fppuKuiXg0sBX0/sT8Cz+/d?=
 =?us-ascii?Q?lcTtl76H361MMcQezpgk32jXGy+3kdhmjLpbEtAyf6shSM+o7+S2FS3bcUDJ?=
 =?us-ascii?Q?BCNbwEyLdLof1crgJe2Jz6QDR/pQ4RKCNcYG41VM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a25ea9-3dd7-41c9-6df6-08ddcf2efc56
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 06:04:46.6802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9uegpWwz7azO8M/J9jsn9EU/cCyhppMoY5cNKGF5Vgj/oifaRDNwjCy1eWXmX5S6rHh9O9woanatvBBJvqAc1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6426
X-OriginatorOrg: intel.com

On Wed, Jul 30, 2025 at 10:07:36AM +0800, Xiaoyao Li wrote:
> On 7/30/2025 3:33 AM, Sean Christopherson wrote:
> > Exit to userspace with -EFAULT and a valid MEMORY_FAULT exit if a vCPU
> > hits an unexpected pending S-EPT Violation instead of marking the VM dead.
> > While it's unlikely the VM can continue on, whether or not to terminate
> > the VM is not KVM's decision to make.
> > 
> > Set memory_fault.size to zero to communicate to userspace that reported
> > fault is "bad", and to effectively terminate the VM if userspace blindly
> > treats the exit as a conversion attempt (KVM_SET_MEMORY_ATTRIBUTES will
> > fail with -EINVAL if the size is zero).
> 
> This sets a special contract on size zero.
+1.

Or would it be good to use pr_warn_once() to indicate that the VM termination
reason is "Guest access before accepting" if a new exit type is not specified?

This info is straightforward and helpful in cases when a TD is accidentally
killed.

> I had a patch internally, which introduce a new exit type:
> 
> +               /* KVM_EXIT_GUEST_ERROR */
> +               struct {
> +  #define KVM_GUEST_ERROR_TDX_ACCESS_PENDING_PAGE      0
> +                       __u32 error_type;
> +                       __u32 ndata;
> +                       __u64 data[16];
> +               } guest_error;
> 
> how about it?
> 
> > Opportunistically delete the pr_warn(), which could be abused to spam the
> > kernel log, and is largely useless outside of interact debug as it doesn't
> > specify which VM encountered a failure.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/vmx/tdx.c | 6 ++----
> >   1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 3e0d4edee849..c2ef03f39c32 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1937,10 +1937,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >   	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
> >   		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
> > -			pr_warn("Guest access before accepting 0x%llx on vCPU %d\n",
> > -				gpa, vcpu->vcpu_id);
> > -			kvm_vm_dead(vcpu->kvm);
> > -			return -EIO;
> > +			kvm_prepare_memory_fault_exit(vcpu, gpa, 0, true, false, true);
> > +			return -EFAULT;
> >   		}
> >   		/*
> >   		 * Always treat SEPT violations as write faults.  Ignore the
> 
> 

