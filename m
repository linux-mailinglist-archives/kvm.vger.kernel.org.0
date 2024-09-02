Return-Path: <kvm+bounces-25642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E42A967D77
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 03:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44B67281C01
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 01:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E176422309;
	Mon,  2 Sep 2024 01:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N8s8vJm7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B318DBA34;
	Mon,  2 Sep 2024 01:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725241566; cv=fail; b=iaLF+lhwQznsSFocQ52IaDxHhpzktFM9YsgSQnHu+EL3HbHywL/AEIFeUKCKyHHrL+spJtuN156h478+kGY6blP+aiUSRMWTpuUbDqcYLYerkrEoSPjd4sNTLC9WkVUVDHnt/XQwrRgqfpRMtPvizNiuHEWWQZ2HbRyWPcCRR1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725241566; c=relaxed/simple;
	bh=uQjYG9hKmuRDxPS8tysQEV2O0hK9TZsjswQoDECD1ng=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XeKzYz5c6/Hk5427uVoqy6WEzeaPkyHiDcwCizppcOkSiPcq5SsxM43ahtrcb/a3F2vBXujuRxV7BsP70IkqYKNvSsOqiGLWSQMwCePK3/go2V5YouCeuJa3lbtT8EECDYybC9PcpZyyTwZbxPNGifRJLeSAJYFkrh6od6YgWes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N8s8vJm7; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725241564; x=1756777564;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uQjYG9hKmuRDxPS8tysQEV2O0hK9TZsjswQoDECD1ng=;
  b=N8s8vJm73++jsOtQbaEaI2RtYpCAWArgzRCT6KvE1BmxbX9qeu7BecwL
   BzQyZigTT6S5s3Sd2Gek852exfh/zFASVnupD3uVXQNQd2PVHIOW2Z9MO
   LwxAbRnjf5L2x1wKaECbeksOoCh+qyXQHKr2CS/Cyv8ztMlCe1u3kpLqD
   9C/+04M5nhtbnweVPqyIXymXNjWmNJq2SRnMvTQASn18daIkw8awVIMqV
   WFv/fsFGu34wKZylMOABcwVyHPra0eOvktwUZm59ZGRa06s1qi0v1jgGq
   GWgV1dMjSwKs2ph9E26xLRf3z63UulENYiQkhxL4XZnArnMIUhfHis1BK
   A==;
X-CSE-ConnectionGUID: zG2N9ORIStaREIjaWmG85A==
X-CSE-MsgGUID: ApPMdrUmRVahtfENGF9thw==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="23616633"
X-IronPort-AV: E=Sophos;i="6.10,194,1719903600"; 
   d="scan'208";a="23616633"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2024 18:46:03 -0700
X-CSE-ConnectionGUID: 1qJFGsO2SwKxGJQsR/UZIA==
X-CSE-MsgGUID: sJ2F4L+2SsCHaBs+LTIO/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,194,1719903600"; 
   d="scan'208";a="87703506"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Sep 2024 18:46:03 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 1 Sep 2024 18:46:02 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 1 Sep 2024 18:46:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 1 Sep 2024 18:46:02 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 1 Sep 2024 18:46:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lN57KtMCH9w4qK93J0T9kOKrEl6REQyITRCPvkG/vmJZqEvxzFe+fDflfy7c1iGdzH0L9FItCx4SHnDZ3dUKm31xtmycYg4MfBAsSVbmL0ON5hHuITTa4YYifD/UWmTBVVRyH4j+GEImPUgkPggvW9Q5PiIcXmjPIk9FGFD0vp+6Zk42s0JLUQ76D0duJBxLYj05X4XE454GDJhIeh4F22lSlVb/3ENBbihk+V0YkngArnM3cMDGcAOFimbsWJHDWL0vPHipI7eT8tExugZMa7uV7DR3qK4qkW83njKNvAvBMWvVvSCaa33MzdBHQXoyngNZTm27JdevvV+ySMLFMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j8k2m8mrfyMtNtAAuep+jSkkxInyovZPePlzmhiDZB0=;
 b=X0Qp07yYgGM/m2/oIhynIE3sVUTTnvEg5qKF+JWXtxEb+RudT6jLz5s44cL9ov6V5T/ugbfR6e/JdOLKYt/YwwpqR7OmICZ+UvJCJWY/8X+j+Je//s3212OlePc+i2fOJCTqxW0zCba1FFjl9Spu2zUQ0GPLS7l+rwf68MewVRD2r/w/h/2U0Wi+WaVe8RzZhaAewZuvbZIDKqaPl86QDYLedf5wbUh1xo2zzZtK5rwIBHbwwr2eDVEvL5JQCFj5pgeQmWbxOWWThLrhzVug6jVNhdIPyaOjuebW4OLzPWvmUeLuR2L71yGqpfme4L3g+gATmXaZrp/rlNbYpkRT4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7186.namprd11.prod.outlook.com (2603:10b6:208:442::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Mon, 2 Sep
 2024 01:46:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 01:45:59 +0000
Date: Mon, 2 Sep 2024 09:44:04 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, Gerd Hoffmann
	<kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Kevin Tian <kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>, "Lai
 Jiangshan" <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <ZtUYZE6t3COCwvg0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <877cbyuzdn.fsf@redhat.com>
 <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <871q26unq8.fsf@redhat.com>
X-ClientProxiedBy: SI2P153CA0017.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7186:EE_
X-MS-Office365-Filtering-Correlation-Id: 7deb58a5-9811-4505-4046-08dccaf0fe97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MH9KmqmspnEZkfY/sQS5WdGyp6y8cmlCug/4HUx7IEEJTHOE51TB7grN/4Ta?=
 =?us-ascii?Q?kg9rx8OYTVGfONgRENDCdeIz8YaXwIBSzFpK4shHbaQmw7N1Dyrd6X6XhjSB?=
 =?us-ascii?Q?LSnSs7h+F1PXUMSmZyvrEUc4zbl5t80hjgV3OkQNU8cnOgoayitXpZiMIkuC?=
 =?us-ascii?Q?euCtHX9WFNJaf397XKhoGrOvSvX3ighn5oUUebko4MjQMefL9b8i4uBdp1+s?=
 =?us-ascii?Q?eudzoGqY0vduxnb9EIJfZUhmVVw+paQp8TEgBoDJF1ulbRmaGi36YkdohM4y?=
 =?us-ascii?Q?68moFQ1M64NGyyBDANCcmjHqxYXJu0CvUJzXhwSM009NG1MNQ7zOKPzh18LC?=
 =?us-ascii?Q?j7r4LdPCIFZVHyjEd3izZHCu9Ll/bbRALy3OjLJgYUjaaQJZQbdGO30vGKK+?=
 =?us-ascii?Q?NXj+KpgPrSGI+ZVG8uCPzaDWqC8xU/S/loAK6yy9Sjr1gUIju/cAkhfI4CLM?=
 =?us-ascii?Q?6pJWU9PSAEd2fNK7ypZXwrOOAxf6yXs5kKUremWQ6+v2r3kAYtligT/8++xf?=
 =?us-ascii?Q?YAJybNsT1dWR3YZ/bzZVjgiaYTEtoLH0pJoUIyeYR7CMuYqJFdY22krup0OI?=
 =?us-ascii?Q?CUXzx2B6l647HfxX0Fqc+MyBZSF4xyPVFFxJcT1qUwYQTsduSFzQKfRKtH71?=
 =?us-ascii?Q?YTNH6aBm/JkQ5J5Jx4/s4rPvE4QS05tmrWkK67TTXID9+ryYtIJZjanzkFgv?=
 =?us-ascii?Q?DIOkWix9NKnKFr+VaZvTT8bu4pj4uE28cOJilQXxHrF+dgYL5kSXv43nvPri?=
 =?us-ascii?Q?AR0+ZryL1duRHlqbp4Yyor9AeQoxjNdfmAgfUGBerW3h8hNoKD0C7H9hkfnr?=
 =?us-ascii?Q?W/mg4x9mbfOSS6O/gsNvjyUJbySQNQEFI1ikiuyB5P+GXIzBP/AEV3I0PswW?=
 =?us-ascii?Q?IGUCq57hR8kMVlD04GsaEF1OVS56RVENcnHLuF0yFcvJmOLRIuAvjro9R/+1?=
 =?us-ascii?Q?DK1jhL7uFG8QIX28qJBb/iaHJMffrXrf3HpfKxiB1ZyrhBhzq6lJcOnGihkg?=
 =?us-ascii?Q?jsbMl4KRZkmJeIuOTzuMTSp42RJYYWd5AQr7KKzoaZK1hZwKXuKXc0sE5NL0?=
 =?us-ascii?Q?1mMPB+qQEgIiIwX1PYOh9AVRTQAB3JMhqjxAKypRF7szoFhVhq8qX3IHB6bQ?=
 =?us-ascii?Q?QJ7oiyAZsgmM3PM9aX9Ow0aURiyl2lasrIwD2JVeKHZPH/Z52RRMFHN74QJc?=
 =?us-ascii?Q?gbB17jnelNErG3cobCEvzkxRAbI8525aasI6F8K/mzxuio9283N6PenuG6D5?=
 =?us-ascii?Q?N1b2hH7+ZX8uW+YHssyOhJEZ9TLAaSPepsmVH7iuKt+RXKzudzCuSSje8y5t?=
 =?us-ascii?Q?9+fR9FHl1igssGqxgnQVxfPCNvOQOgx6qi8Xvsxhw4hXyw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wBpoUBkn1MowKHuG8BPXJ00GelLdYfWGMkEsa3bfEqQ0Ei/cxa+Pl0knXyiX?=
 =?us-ascii?Q?K28doTNSZwmF72bT8Mu9YdsZ2aWN/b40nqVV2z2qf8rznlmgXKzzGAAIx/zz?=
 =?us-ascii?Q?Y7Xxx7lag7pKQGcC9T1qSkSwdnCKn7GGKDyME3C2f9rMtwkrboXkYKEAhhtU?=
 =?us-ascii?Q?l6gaa2jllvt4nQ4AMmQGrx19nIxdTc7fFOAa8lGv3L58Wa4enQzHioKVEHCQ?=
 =?us-ascii?Q?VdXXcVdnbs9FAfIXDmeZ3eIROMDYsOo/josiKdh0fZIphDXa3OlnhcjVLhtX?=
 =?us-ascii?Q?18ypPoE8RB/lp5vY3DJuTzgZYajBleE2OvIXERPFiFIifw68qwlGeVbEngCn?=
 =?us-ascii?Q?tWzlV3sv6PAnQJwkXqANuKn3e10p7yH3ChAqMpCPI7dIlDrwRIdsmoHDzw2c?=
 =?us-ascii?Q?t0xf1YtDulfseS0bSRJOIQm/A6HYLtTE/5xMfMDlfZYyjkRYiOWnUujy17qU?=
 =?us-ascii?Q?qERMGvjdIlAFXd0SCrc7dZHaNPcdZqBwTH1XYbXPPQP+0b1qDMO4CRXhuAe9?=
 =?us-ascii?Q?bzMPldth0vUrALBqMZ4Vv/BlXNclcshg4AIQljlAGuCrG3nQOVog4BKXJbVZ?=
 =?us-ascii?Q?v8G3YW4tCFE4rBvFkGFRov9mCR5y7gKFxO520r+JFQLsM/XDAFh/vW3UWtNd?=
 =?us-ascii?Q?73Blkm+TLAAKg8AbzLQRRwdytyzxWGwrWYVySAwKiVRAA/BBeAJ+81AKkWEH?=
 =?us-ascii?Q?bqJqYNjfD8XoCWKwfHfDSG4L+D6NIhK1uq+aHT7Fv1TXQRgRP5tW641IwWK5?=
 =?us-ascii?Q?QaD86JWu7S0gwmXhxf6fXnE4kbtvfrQ9LYM8cYf31uY6Ux6Q1MIJKx9wSEXY?=
 =?us-ascii?Q?1HeHqA9Ep0L7dPjDMHmEdFZvFBUJR2lFazLMGX0nf7NPaZT6zECkPISxeeKM?=
 =?us-ascii?Q?dZiGx8JYaInN1Lz4haeHcG1ahqsidGKj1qm8Gb5XL3VvslM+GBZxgnXWrhAY?=
 =?us-ascii?Q?Sf/zF15NZscp50Lm4Qscs9EP2JYTgWpF4EvOa3h8n0QNPlsLPV5klVEKEbQM?=
 =?us-ascii?Q?ijsZmfLT6POkhTG7swhfE6zFd4URnQWDZyWnoonxbtGd65l9cVrDSCIHotgI?=
 =?us-ascii?Q?PSKsxNb6SfrVf51eJFBSI0FzOMsAJ6ELYSwMM5ISBtbDXa2OnoV27BWry/ZW?=
 =?us-ascii?Q?l6ll7dMQF9FCtsRL2xf3GBqnSMl29vHTPWRpQqsRu5Fu/4sazOGQk5Bvgzmz?=
 =?us-ascii?Q?xod0mTvN6sLUx0JV8ABbFdvrvN/Nczku6vP6SfMqJ8smRrUFbM8pbch1fXL0?=
 =?us-ascii?Q?1E9LdipMhW5K69d8CrAxZqKP00vr0ZEwQTRh2QUvUY9RFK9Z6JXOWrMs1Vde?=
 =?us-ascii?Q?VxgYAgHFT+E42yc8ZVOKdMP4zIWDFnLZ0h0QWw7+x7oFhFUbCV/eYn0xSEtE?=
 =?us-ascii?Q?hYfHkMmqs4FwEDtkrc1eExsWO9iS2SxfUBHNmGUB+sJY69DV46WTG5JjUxzJ?=
 =?us-ascii?Q?PZRV6vTm1VBWHH2nY4/iRz3f1igJ3VZ9QBedVNw7haFCJvqB1y7kvujZ1PWW?=
 =?us-ascii?Q?9xe5+SxcqqRrJoiLLaWMo6owl6EgREmunjopDpugQ3SOINdifbmGS/+8rSqO?=
 =?us-ascii?Q?k8TRUSGTFHuiD/Rvy7C3F0tw/aZg+va/78Jg1bFi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7deb58a5-9811-4505-4046-08dccaf0fe97
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 01:45:59.4038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8J5zVT1D4lb8eIbTUPbbv9Q0tguwxajf9/CRuUehGlIYQqXCpj8aXaMSG4Elc6jz+TUMaAUY26EjsIGPP08w8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7186
X-OriginatorOrg: intel.com

On Fri, Aug 30, 2024 at 03:47:11PM +0200, Vitaly Kuznetsov wrote:
> Gerd Hoffmann <kraxel@redhat.com> writes:
> 
> >> Necroposting!
> >> 
> >> Turns out that this change broke "bochs-display" driver in QEMU even
> >> when the guest is modern (don't ask me 'who the hell uses bochs for
> >> modern guests', it was basically a configuration error :-). E.g:
> >
> > qemu stdvga (the default display device) is affected too.
> >
> 
> So far, I was only able to verify that the issue has nothing to do with
> OVMF and multi-vcpu, it reproduces very well with
> 
> $ qemu-kvm -machine q35,accel=kvm,kernel-irqchip=split -name guest=c10s
> -cpu host -smp 1 -m 16384 -drive file=/var/lib/libvirt/images/c10s-bios.qcow2,if=none,id=drive-ide0-0-0
> -device ide-hd,bus=ide.0,unit=0,drive=drive-ide0-0-0,id=ide0-0-0,bootindex=1
> -vnc :0 -device VGA -monitor stdio --no-reboot
> 
> Comparing traces of working and broken cases, I couldn't find anything
> suspicious but I may had missed something of course. For now, it seems
> like a userspace misbehavior resulting in a segfault.
Could you please share steps launch the broken guest desktop?
(better also with guest kernel version, name of desktop processes,
 name of X server)

Currently, I couldn't reproduce the error with "-device bochs-display" or
"-device VGA" locally on a "Coffee Lake-S" test machine. 

Qemu cmd as below:
qemu-system-x86_64 -m 4096 -smp 1 -M q35 -name guest-01
-hda ubuntu22-1.qcow2 -bios /usr/bin/bios.bin -enable-kvm -k en-us
-serial stdio -device bochs-display -machine kernel_irqchip=on
-cpu host -usb -usbdevice tablet

The guest can see a VGA device
    00:02.0 Display controller: Device 1234:1111 (rev 02)
with driver
    # readlink /sys/bus/pci/devices/0000\:00\:02.0/driver
    ../../../bus/pci/drivers/bochs-drm

I have tried hardcoding several fields as below:

(1)  hardcoded the fb_map to wc in the guest driver

--- a/drivers/gpu/drm/tiny/bochs.c
+++ b/drivers/gpu/drm/tiny/bochs.c
@@ -261,7 +261,9 @@ static int bochs_hw_init(struct drm_device *dev)
        if (pci_request_region(pdev, 0, "bochs-drm") != 0)
                DRM_WARN("Cannot request framebuffer, boot fb still active?\n");

-       bochs->fb_map = ioremap(addr, size);
+       bochs->fb_map = ioremap_wc(addr, size);
+       printk("bochs wc fb_map=%lx, addr=%lx, size=%lx\n", (unsigned long)bochs->fb_map, (unsigned long)addr, (unsigned long)size);
        if (bochs->fb_map == NULL) {
                DRM_ERROR("Cannot map framebuffer\n");
                return -ENOMEM;

With dmesg as below:

[    7.565840] ioremap wc phys_addr fd000000 size 1000000 to wc
[    7.565856] bochs wc fb_map=ffffc90004000000, addr=fd000000, size=1000000
[    7.565859] [drm] Found bochs VGA, ID 0xb0c5.
[    7.565861] [drm] Framebuffer size 16384 kB @ 0xfd000000, mmio @ 0xfebd9000.
[    7.591995] [drm] Found EDID data blob.
[    7.603956] [drm] Initialized bochs-drm 1.0.0 20130925 for 0000:00:02.0 on minor 1
[    7.614263] bochs-drm 0000:00:02.0: [drm] fb1: bochs-drmdrmfb frame buffer device

(2) hardcoded the memory type to WC in KVM intel driver.
+       if (gfn >= 0xfd000 && gfn < 0xfe000)
+               return (MTRR_TYPE_WRCOMB << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;


(3) hardcoded mmap flags to WC for some bo objects for Xorg.

