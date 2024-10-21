Return-Path: <kvm+bounces-29249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3827A9A5A63
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:32:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E852528124C
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6729DDDA8;
	Mon, 21 Oct 2024 06:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RuA9JXlt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CB3195385
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 06:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729492320; cv=fail; b=gRspvTIXvFNlmcavVGw7PhCtHUf9XRKWvJoDvcIdK+SbSYBIGvpw0NTb8+l62ZKYtVOhXPWx3BxkOquWV5AOCZlAUVe6ddywS9QLAgS1KQfHJAbqqxXYbirP/3Pv2X33cBr1e9BZd7tOna06GaznuiEMKE7Sygf3YrB+byPf2x4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729492320; c=relaxed/simple;
	bh=b26XM9oB9p+C+mXBy/j/dHrRMElaMMcaiPaO22GXTKM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OhmrxnTySLmNdBuWy4IvR3hb5JdTFAxpfeOP7a44CazcuL7lqTTFLUUwyIDGAVFkmyBdeNcUf6uwD3SpCKa8gA+XQ+4boAVp1Jwyy3Nux7gXp08/nbM8CG/SYPQxbJZk1MsUDwtwXA1wpUJF/aNb3sifV7hehuqBQsdyMEC2uhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RuA9JXlt; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729492318; x=1761028318;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b26XM9oB9p+C+mXBy/j/dHrRMElaMMcaiPaO22GXTKM=;
  b=RuA9JXltPZgI/ATYmERSY79P/jNLnqUd4yteJe/S1WvalYKSCQDZDcDF
   /KBHSd+ybZUJgUHrh35xcosMffBurMQg7iu16q7BBXlfNNS062wZXWAph
   le/PqNkXkwZ45vvJovqJdMOCjasMBK0z2ECYWxtw7kicusLTp/Q0Ud4XM
   b0vVPGa5EAAaZipnn/LOwKcmnzk9H3A7wiC3gAnInyQh1YK2T614pb/bf
   WctOgqci46yU9yxjwkfkgw8rIFs3FqZaNjGuep+uigWAeNdYJqjPWv2tz
   GOjCVeilxTA5LZY6NrXkWam5wUiL60RPdDnu04PhKM9OTyBcTUuSn0eQy
   g==;
X-CSE-ConnectionGUID: JTl3dDGNQIWQFAbnUQNmNg==
X-CSE-MsgGUID: hL7MQALuQ1eBMDqLYwcmUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28910311"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28910311"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2024 23:31:57 -0700
X-CSE-ConnectionGUID: EAm8OEFcRl6mJ5dZhVoqjg==
X-CSE-MsgGUID: jifYj5XLRASpmVtadsABjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="83425392"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Oct 2024 23:31:50 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 20 Oct 2024 23:31:50 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 20 Oct 2024 23:31:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 20 Oct 2024 23:31:49 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 20 Oct 2024 23:31:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qyLa2ZJwPOMYEkIDrQvIbecwcJBTyMGy3jJwNLNBcuL0A3D1S6f06/6tzak3VVidQYfME+QG6+MbOFkDnyFbnM2sRRHQsPwWzBupmUGnfaRL75/pIJDywz/jmqxHD0itMyoinCj4hd/CIjLi+WF6ZuIwppDaXlWKfnKgmwxBzWamJIGiAo60ZDVq2IzTZ8lfDXdOA/K/eVU8KNu7/RlRvkJ5knCPm68T24XYh2GVsTVrqCkfj03+at+r16CAIwVVqFw24IdpHS4vHAVhbCQAm4jBYqthd/nEQGrqYp3EvnJbxB3bWWEsanKSMcYLX3CZn3UKrU7G9Qeb1PZYEo++Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mz4DoeUQGkp/CUmm9r0xzHbqhJ6F4IAQ7oFU2y49TxI=;
 b=EL7KFN/lrjzGeyjZ57Nqwp1Y2f8ZGQBWwHvOJldsFywOkd7Pfwl5WrPviwdcq66loFJ9PFmYk+sGlMYe5bSWh+oeX56fRZqQd0BbFdsYBSyGnEGNGqe3iER7jbSR9Zb80lz1nL7qWVp2UNyOK8y73YETElSMSpgqEemAFLnpgrdeLv/60OukGn36sG43lXQ+zCCHlHBa4oHSi5cRhrqkpxjrn5EeOsa2f/h3p8rzmn8h8hf+ToTWwrUYT4rgqUOewJxERrdnrC1UkJXNQMZAjXh3MTuB118/UUcIcOyjIsNtVqhOWIoBYz1/20pFJsc8FGU2hdXjD+r0IvLK2arZGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB7255.namprd11.prod.outlook.com (2603:10b6:8:10d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 06:31:47 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8069.024; Mon, 21 Oct 2024
 06:31:47 +0000
Message-ID: <791d2e9b-962b-4bc9-8153-f9488ae60140@intel.com>
Date: Mon, 21 Oct 2024 14:36:21 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] iommu/vt-d: Rename prepare_domain_attach_device()
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>, <will@kernel.org>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241018055402.23277-1-yi.l.liu@intel.com>
 <20241018055402.23277-6-yi.l.liu@intel.com>
 <e93c0d44-957c-4569-aa33-807b3eada079@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <e93c0d44-957c-4569-aa33-807b3eada079@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR0401CA0027.apcprd04.prod.outlook.com
 (2603:1096:820:e::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM4PR11MB7255:EE_
X-MS-Office365-Filtering-Correlation-Id: 576609c1-c461-4327-86e1-08dcf19a09b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VTI2T0tsTk9CK1pmSEZvaUVEVTMrSllMNE5DNkxsbGdWUTNhUXBQcGFQeVJ1?=
 =?utf-8?B?cG5xM3JKTVBTUXY4NW9ZWFhYNGh1czc2K2g4TE9DOTVMSDJMR1VZR2ZQRnpN?=
 =?utf-8?B?Ky96RHVJUk5mcCs4RUNLOUNxdGRNMkVJNWF0Y01iblFWdFU5M2JuTnk4Skti?=
 =?utf-8?B?WnBySW54L25wM2lCTFJSbUdFLzlyRnJHRWJkVkVCbzRSMG82Wmo5eitIbjBu?=
 =?utf-8?B?ZWpkMXY2YWxhT05vZUJjWnAwaW0xVzN6WlliTjFQdTF1M0ppWjRyRTd6Z2Rz?=
 =?utf-8?B?OU05dldmSE1XT3c0WFhTZzJKU1VSa3JOa2U3QWFWZkdVRU1DSU5XTXFXbUtV?=
 =?utf-8?B?eTZFZjFXYVpsa0NaLzZlamhrZVlkUklCZWxHOFJobFRFbjdRRUp1bGRoQXpu?=
 =?utf-8?B?MXJEN3VBcW5sYWNJTDVGcUt4S0oweUxhRlZ6RHMzRUljVlZNNnRWWTZiSXhU?=
 =?utf-8?B?Ty9ZQ3FFQ2QxZXJ5eDhCalpXa2p6cVBvZyszVmFKQldSSDl4TmhIak4yenFt?=
 =?utf-8?B?ZEk4cVM5ZkZtMVBMdDRwSFpYVDdJK0ExSFZ1c0VoVFZiOVpseklwWkVZaSsr?=
 =?utf-8?B?T0tqWWVmMndPbFkwMXBsK01oRy96OUZKQVhmMVdzZkNsR2VFSGVENWxCc2dh?=
 =?utf-8?B?Rjlmb3dnWlhUWlI1Ukk0eG1oRTlXSFhncTlaUEFlS25rYmkvdE12MzlVWmdh?=
 =?utf-8?B?RzhtU2JCTGZETmhnSGlKN25yd050aWRjai83QzNOQTBsbGlicUZuTTdwYjRP?=
 =?utf-8?B?QTJPWXZWdUdKcmd3eUxQNmN3Rm5pbjN1bnhISW45eFA3ZWlibDkrWExhak5P?=
 =?utf-8?B?amhseVZ4NnkvOUpTRnA4Y2JERll1SDZtV1lJbmhoV3p4L20vblpMejBpVWFx?=
 =?utf-8?B?Rnd4aWdwVk10eUIrQXZ6VTkwVFgzMnp4cUZocTg4clYyN1hLVlBTQnZvNUo0?=
 =?utf-8?B?VmRLNmt6ZFJPNGRONTB6VnVjaStaOFRsdjRpdGdCbXlSNURHeE00MkppQlZT?=
 =?utf-8?B?djVkQjlmZXVna3k2Z3JZNEVBazJ6aXhwRXVCSDNjRlRkd3Uybm11dUoweFY3?=
 =?utf-8?B?N0JMY3pGR3p2dXFYS3JWeEpocG1wNE5zd1ErZXk0RnFvZFM5MzRaWG45Q1dt?=
 =?utf-8?B?anlraUViSWg1MlJEbTZaQ1ZzUlRCZCswMVFER3Z4T0E1WGt1blpSQXR3ZmE1?=
 =?utf-8?B?blZVTWZUUjBYa2crS2Nkd2hlMGdEUmFxeVd0eWFLby90Nk4zSDhBcUtiSCtZ?=
 =?utf-8?B?Rk9KWVBCbFZqZitaVUpFS2JyNDhleGsya0RpMTRSU2tvWUg4a1FxWHljMnlU?=
 =?utf-8?B?bjB3N0k2a0F3Z2hpa25rM20zNWlaa0ZBNWxvTTJLUGdMQTBzekYwNDdNbUNR?=
 =?utf-8?B?NkN6RGdIK3pXTzgxeUVCUUtzVkNJQStocFVNQy9KVi9qWFMrVzh4THpPd3N6?=
 =?utf-8?B?RGZsSWZoNjV2TUJjamhLeG9hek1LUGlSckxPNDlnQXJYWExhQlhOSWd0dERw?=
 =?utf-8?B?MFBmak8rVk5XVmxJYTZEZXgxVWNzREpVSEljQnk1Ti9TWkdSY2ZZV0VndWJm?=
 =?utf-8?B?eWl5VGpZZUg1eE92SHV2U0dpYkdlMk5ROG83NEw4UzZXcDZjeDBTWHUyZ1A0?=
 =?utf-8?B?WEhMc1dRbEdOeks1WWpBd1UyaW9iWEZSenpPYU8zVkhRc3RpTVhteHR0WTV1?=
 =?utf-8?B?dWFDWEtJQmFEbnk1dzhJOGFyMmJRMDhINXJYRkpiYVphT3U2bWFrYzQxbjVp?=
 =?utf-8?Q?sPskrm41SRT8QUFhseCi09icmyJr4qfUwQSzPDB?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1YwMHhRVUZOSmIwNThBSFRxSE5FYXcxVFR2ZW9aRDZBUWpXV0g1RFFHTDkz?=
 =?utf-8?B?bUJNRFlkT1E4NjNLSTVRNjM0eEF2TzVaMWtNTHFFbndsdmZsZW92Y1NiblYw?=
 =?utf-8?B?dmtReVExdG9RVkI1RlZ6Tm9VNVA0RVc3YW0wSi9nZjRGckJzdkViY3lsMXp4?=
 =?utf-8?B?c081YXU2RTFXWlhTTnJmZlNDSFpPUlpqK0xpc1lpbUtqNmx3czRZWDlVZmNL?=
 =?utf-8?B?UGtab25wWERoOS9xRGFWUW9aTVhYWWhSdjFVY21xdHNBcWdoNzNRM2FLbnZU?=
 =?utf-8?B?cWdyWkVZalhVYlYwWWhCVXFHQmJDY0lUVTNRSGNGRitVZmRHeVFNa0Q4aklH?=
 =?utf-8?B?SGlvaFg4VjBaMks1Yng2WUhSM2hHVlk1aExGYldpTjhQSDdJWDJtbm1VMFRo?=
 =?utf-8?B?d3hudWRlMm90T1ZiRU1XTFpLZDNWeFBsQm5jd0s3M1dwTzdIKzFJQlRmb0xj?=
 =?utf-8?B?STV2K1NjVnRyaGYyNWJ2dnNEaHpuSlY0bE14ZFovR25kemVkbW82Lzk4UGlj?=
 =?utf-8?B?YUxSbzNhL0xDQVp3VG1lN3NBWGdIQm5sOUdGN05CaHRLQWlBdHUyL1NMbU1G?=
 =?utf-8?B?dHlkaEpydUF6K25lZGFsbXNTaUtxNEEySGs2NnRoRTd4QlVaWWtZd1NQR1Za?=
 =?utf-8?B?Unl1cEYzOUNHTC8rMDJqa1B2QXlUN2wvZC9UNWpGa3R4WXd5a0J3NFlkN3Nm?=
 =?utf-8?B?K0QxcG9DT3dtMEtOdlMyVE9QbklFbzFWa0Via01MRi96eWlEV21YaTVMamhN?=
 =?utf-8?B?eHp2eXBYSzk0cEVBOGhLTmEzUWxtRUhxUXRNTHp5aFI2LytVRTIwUjBncTFX?=
 =?utf-8?B?VUppajJCQStnYWFBb1dhU2c0WHJ1SWV3L1IzZi91MVRJb3FMemp3SHFXRjc5?=
 =?utf-8?B?WWVrWWlRVVk0QjZPczJ3YjFPaXpYbTBjaVQxTXIvaWxjcjd3RTBuZDFtNFYr?=
 =?utf-8?B?R3c3a3pNVVFBcEo4eGJnZVlmRnBSNmRxVEIxMmtBODA3QWlKWkxXVVNqRmh2?=
 =?utf-8?B?MjBLazJFMlAyaXBNaHNjNVRKNzh0Sk81UXU2ZjZaQUs2SFlra0xqYzkwZU1i?=
 =?utf-8?B?Nk1BVEZhZkVESVRJUk5lcGhWaHZRZTdhVnlXL0R3N0Z4R1d4NmQzdnBlVDdK?=
 =?utf-8?B?K0tKcml5V3RmZkNySjYwNjFJVGJSOSttcEZTSXNVczB2aGRXZkh6TElnZVFl?=
 =?utf-8?B?M2FRNXZnM3dzMkpaM05EbmtHRHRuY0JyWm83dHZ1M3ZTT09HVk5jM1VrWlpJ?=
 =?utf-8?B?MWt0QXdlMSt3WmxwTGNjSGRBSHhWVHBxWklWbmlRN2s1amFiVFZpMXNNNEVF?=
 =?utf-8?B?TjFKUXVZLzZaZVNxSUlYdTBJRTFsMS9WMlFydmJRZWtFYjZ4NU5KK3FWZlB1?=
 =?utf-8?B?SUdtOXQ3Y29KYlU0Q2FUcGpzbFpLcEN1bW41QXdrZ01MR3JsbWRtUzZETGtr?=
 =?utf-8?B?R2wwYWlhWlBmSnhNRW94Nkd2U2RndE80aXAzL1VFc2NRbEV6T1RJMlZISnJj?=
 =?utf-8?B?TFg2VkVyc043czZrWmtsZXV0UDdGMUhDc2ZUZTZwSWFqeEVPcWJzeHlxaDdH?=
 =?utf-8?B?dkRROUJEUkpsMzFZMFM4S1FEb2xGVTAwK29McEU2dFFGMjBFU0VhOGJRODlH?=
 =?utf-8?B?MXFPZkh5TTJMYWFIcFl6a1lQdElCbE50UGVJUkRCRno1SnJ4M2RCZjgzTTM4?=
 =?utf-8?B?T2U2K0V3bytNV2FRd21YMHRIWkhYOENJSjk3SFQvUEl0OEF1L3VUM3NYeXMr?=
 =?utf-8?B?cDJTcC8randnbFhTemp0UDVzd29NbnRXdFZUMHdNdXIwZTNtOTI3UjRCTmcw?=
 =?utf-8?B?aEpSWFNSR3MwNklaejNJUzU2OXVPbklSKzBXSDlOTDJKcDgrRTZYVXJ4dlow?=
 =?utf-8?B?Q1M2REIwMThhT0ZrL00xOWxFb3FaZVo0S0wxVmozOHl2d3BqZTFycnlSWENp?=
 =?utf-8?B?dFY2d1hkSHA4OHBUeExXSUhybUMyMGwydkp1a2FXMEdxMzJvWkVuMU1qYk40?=
 =?utf-8?B?K2J5K3hydHVscVVXYVJNN1ZvbzErSHhlbWRudDhENmYvUmoxN3pnYjVHdmtG?=
 =?utf-8?B?YlR1dUM1QVFWNEVTcHhQYUN4T2ZONFdGOVpzd2xJdG5odTJLcjMwMUIrL0dI?=
 =?utf-8?Q?2HtCz7W1isPOZXwR7sudcAlqB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 576609c1-c461-4327-86e1-08dcf19a09b2
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 06:31:47.2788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2r3O1LKcLyXEjdIXBqmVbHxR+xx8i3aLC+Y80t9ZzseESyC1/wqfpklM4gKONgEPY8DQoKzHeYK088GEwCMeeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7255
X-OriginatorOrg: intel.com

On 2024/10/21 14:18, Baolu Lu wrote:
> On 2024/10/18 13:53, Yi Liu wrote:
>> This helper is to ensure the domain is compatible with the device's iommu,
>> so it is more sanity check than preparation. Hence, rename it.
>>
>> Suggested-by: Lu Baolu<baolu.lu@linux.intel.com>
>> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/intel/iommu.c  | 8 ++++----
>>   drivers/iommu/intel/iommu.h  | 4 ++--
>>   drivers/iommu/intel/nested.c | 2 +-
>>   3 files changed, 7 insertions(+), 7 deletions(-)
> 
> Yes, this helper calls for a name change. I have already a patch in the
> coming v2 of below series:
> 
> https://lore.kernel.org/linux-iommu/20241011042722.73930-8-baolu.lu@linux.intel.com/
> 
> Just for your information to avoid duplication.

then I can drop it. It's not a critical patch in this series. :)

-- 
Regards,
Yi Liu

