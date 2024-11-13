Return-Path: <kvm+bounces-31718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7668F9C69C4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 08:17:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2ED4B244DB
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 07:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E9F17E00E;
	Wed, 13 Nov 2024 07:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MJv3elU/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACFC230987
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 07:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731482252; cv=fail; b=mqt+ygtzi3kEBLn6U+vbYx0t8/ryl9pEkeAugDg3MLnsCLvRuboECs8CThT+geqSgFu0MZP2lr4aVlkKdVeA8+NLdZImaO6KY2TDQn54wO1yMJWPUNVvhtjppCArmr5K6TrXUfYEXrW93yeCzg0i7kRm1sAPc9czibAZJcTNwtk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731482252; c=relaxed/simple;
	bh=9R8/s3zxskqVnXxeccjsnvV3+BqsBygFu/58I+aLT9w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DG9UqyQptQY1/fO6jkkA3pVwQIvOL5zSbr+XhqP0YYiNpjNEAzlSiIhAZ7j4OpQDNcLfmbGq32+SP6PciJW9+3IndgfjcC+nYNZXD7tjxCHlJcQFosDCptfhwwcJ+2dS7Rc6cOAyCe4BjZh2m4YxpC2LwYp4WSWgXidGZ3uPm+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MJv3elU/; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731482251; x=1763018251;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9R8/s3zxskqVnXxeccjsnvV3+BqsBygFu/58I+aLT9w=;
  b=MJv3elU/pkxmNrNKjN2K/w7YQZWdDPgkBnec0Wp+hZxFVcfQAWNd2xOr
   maQXGoIbIqfAEC+bYd0lIeFoQqwqgASkkn7AsY7IloX7jeI+2bUvNQFvY
   UNGLFZ03k3Rkxl6BJQgXS/0PV5FD7PZ/E7xexIncAPrRnDDgjNbl06WmC
   js0VvwozRs0eSUOHZ3rE+hl8gdUxMp9zdJbrrs2Z44g6bT0MvxTnk9Emy
   vfS8Yr3cf400smC+8/fWX/NjgxzgpqlXXk1fHoGyfS86U9AQIwf67gyHt
   cZR2OwkhLZbwdddwEmsTPpjDFOrhshe/lW/4jTanT3SWFx59/YPq8KNOi
   g==;
X-CSE-ConnectionGUID: EyyKwBhqR7yOfotXIp9mGg==
X-CSE-MsgGUID: WM45SDCZRTGwvY9vapk01A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31528404"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31528404"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 23:17:30 -0800
X-CSE-ConnectionGUID: rPVGR+MHRGuoLKOEGvkiHA==
X-CSE-MsgGUID: Hi+KU7wkRdKmLazRqxjfww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,150,1728975600"; 
   d="scan'208";a="88179259"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 23:17:31 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 23:17:30 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 23:17:30 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 23:17:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TdtGRGi/psF7KYopoSXrIlyXE6VElyP5VuF+jsBC5TaN0tvTde1vcQ3jiRw63sk3W0yeBH1CN7ZBO8VnGlyCjbogrDIQPSFExUeSJt7HISqiF/pKOVDW/esGTzYnq+LIOHC5yaW90y46iG7RgfmBG/McpoqOfjxaE/YYzNuj7rZCZoNwxJIJLl8HB83RoJO9Zbz6ZUQ3SXStJbg/1NKgrvkFKGiEoJdk6+aLz79IQXdke7fyf55iwAhtq2dxxHYxhKbctp3otQXGhOf/uTfhv2bPOTv0XUudJLCztRc/1hKYOVYDomIuYjzdJZlTFZKu9paJiXUh/+Xpd0agAV6Djw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xkfcASQunILNZNE4OEzDCGIx9LVGuAHCVcHxLwIvYyI=;
 b=FPPzIjXadu1nCJARJguaDjIDalFpXuMQ1dGRKahWPbFQnUyE47CjG8ykty32aFV9hgviWwUVUAvsMGPS5d1xGwpLEog+93G6azmBvySDaj082qBf3XaWBPJhEiz+ZuJUPhyHBbcNi7meAy0UIehLtvZUM9ZuXXPmBxVAxYCx7UvP1RHeUFdBpOOgEUiRvbmVAU4nhopzdW/1XXBn/7P7b4PLd7FinXl8KZs0n+SVl0eit++oizkassPkZ52/rjs6OKcoAqV+lSKWhCrWrLx5etVigaaqxSzyISeGwvcD5IUG2apmKXaKWBGdiiQYs+xspg70y25vXTGuVt8V3+7gDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 07:17:25 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 07:17:25 +0000
Message-ID: <7808f8da-8932-486d-8d47-10a95bc5002d@intel.com>
Date: Wed, 13 Nov 2024 15:22:02 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] vfio: Add vfio_copy_user_data()
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<joro@8bytes.org>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<will@kernel.org>
References: <20241108121742.18889-1-yi.l.liu@intel.com>
 <20241108121742.18889-5-yi.l.liu@intel.com>
 <20241111170308.0a14160f.alex.williamson@redhat.com>
 <9d88a9b9-eeb5-49e5-9c59-e3b82336f3a6@intel.com>
 <20241112065253.6c9a38ac.alex.williamson@redhat.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241112065253.6c9a38ac.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:3:17::16) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB4855:EE_
X-MS-Office365-Filtering-Correlation-Id: 61cedc97-d3e7-447e-870d-08dd03b3393f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K25ZeWpyalhTR1YwbmZZK1pSck5uMmNOOFRoSXNSSlpBZm1FRU51ZXhQcEx2?=
 =?utf-8?B?ckpDM3lKcUVjakFVaHZXMkt3VW14a0RpczRoWm1FUmo4YjI3Z3lBaUIyTjFU?=
 =?utf-8?B?Nk1nRWt5c3ZRNU9DMmJEZEk3L3ZuNWo2UFhwYSsydTg0Z0xoY0ZOSTdRZ0lC?=
 =?utf-8?B?STJFTEdHbWxTM05VeExrOWFDMFNaOEtWSFlmdHQ5TDU2eDU4M1duaVd6UjBR?=
 =?utf-8?B?MnRZaVV4cmN2WVBZTCsvUjhDbVg1ckEreTY3V3R4aXNzME1OcnJHOFJLU2lV?=
 =?utf-8?B?THoyZ0V1MXNucXQ3a09WeHZWQ2NxMUhsZjRVMGFUQlpYZ28yNW9QNGFtMk9X?=
 =?utf-8?B?UC9Oa2Z6WUtUZmZ3MEdOaGx3Y2ZsQXQ5V2JnbnpLbUduY2hyZU1iazI0MzA4?=
 =?utf-8?B?N3ZNNFo2S3k0dXFldlByc1FsaVVaWGE2UFRQMG1HWDJHaFJ1Nng5WllpQlV0?=
 =?utf-8?B?YjduYS8xbVZYWmdxWnRjVXZvS1FlWmFoeUJnVEE3WDltSGxzMFZaSFlCVTBM?=
 =?utf-8?B?R0ZjeGdocE1ZbUFVSlhNRWJud3FXUDFKYmZVdTlzNjNoWTdublNMUVY5cFE0?=
 =?utf-8?B?aHM4d201cUFuNVQwOTJ3UjdZUlBYclBHS1pxN2xZcmlNM0UxaTc5T2NPSWdF?=
 =?utf-8?B?TUlCaytNSzdBK2o4MkpXakw1S3JPeHFsWnNLWlhlUXQvOGQyRzhiMGozTC9J?=
 =?utf-8?B?SjZTQU90TjRxN0NvU0MweGNENXdRWTlDVE9Ud3FnRzY1bkVGbUVKSUxoWDhX?=
 =?utf-8?B?cHpOdDMvanA1YmQ1Mko3ZzhnczNKVklMdU9ORXhpekQ1dzBSb0Q0NUE0ekth?=
 =?utf-8?B?QXd3V2JsVzVxT0JYWUtyajdyeXRKdUhIaGJGbkFMRGVXbXVSN0NzVTZnU2hi?=
 =?utf-8?B?ajZxb3lLRER3Mkgvazg0NWw3ZUp2b2lGYTJuTlVPZTRXV3BtTXorbm44ZTJ2?=
 =?utf-8?B?OWFXNEhVRFFLenN0V0dybWVQZHNlcjVZWkUvRStwMlVkSU5GZytYOHRhQ3Y2?=
 =?utf-8?B?SGRFNEV6Znd2WmhOdGhtVWd1MlNobkN2TFdUbU9VYkM4Tm5tdXZScGZJU3lK?=
 =?utf-8?B?MExITitXbEp4c2xiWlVzMUxXdERNUEg4Y3JuWk02a1Z4eWNxbEN3MDRqUnky?=
 =?utf-8?B?Y21aQ0hEci9sWGZYODVhaytTbjh6cFk4N2F3aDFZSVlSRUZOVE01dGN6ZlRV?=
 =?utf-8?B?YXhLOUx2N2h4dTRPZ0xXKzNDNFlibHJwWjc5bWhxazZkWmJSc0l1QWc0a2tw?=
 =?utf-8?B?cGxsWm1ISW5XbjR3d21ZVjZPTi8xTFlXZ1lzc1BHSzlqOEQ1d3M0TnVNR3Qv?=
 =?utf-8?B?dmY0L0xIc0FUMUFiN1BIK2RTQTZKZFJnOXdrV0VqUjNWaHRkZURRZ09KV2Mx?=
 =?utf-8?B?bmUxRFdOKzFBTCs5WURkNkZneXFqaTV5OFRveW9tbjlmSkxnT3JTYWlFTUlX?=
 =?utf-8?B?ei9MSHY5anJjZUsvUEh4MkwwSFRwQ2ppY0pJRS83TkgxVXhmMWJsZXdwL3ZZ?=
 =?utf-8?B?QllJVTQwWnFZL29UcTlBcVBrNSs1MW9YWFpOM2hFalE1ZmpWZDhLbC9NZkRt?=
 =?utf-8?B?OXRmRUhoMlV5UnFRQjEvL1Z3a0x0SExZL2hOQjgyaG51WjczbzNaYVNhM2Z5?=
 =?utf-8?B?Tm9BRkFMbUI2WjF3VWdNZVlTZDVxMGlwUHAzazhkcnJCSHBjZ3VPVmV1WWZC?=
 =?utf-8?B?S0JnOExmbENZbEcvYkdiL1FaS1pzTEt3MEI0eGxKS0toamluRXBxWWJvQ0ZZ?=
 =?utf-8?Q?pubkLhBVSVmYg2wov7woS9+X3pO6OHLvsrlMPyW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXV6ZXFWL3crTlVMZ2N1MGpXSmVqR2pGTlFFdW1SMGZiM3ZQd0dXaUxxdVhL?=
 =?utf-8?B?T0tFaG0raUpMd1NOVml2Vk9idE84b21DRFQ4VVlMK05wUks0ckljOHpzOWl0?=
 =?utf-8?B?dzNwWHhicC90Z1lFMVJheDgvYXgwbXB5cEY1S01Hak92SlRiMjdOZm5yRGxa?=
 =?utf-8?B?dkdJdmxMZkgrbEdZc0t0UVJWUDFLWGVXVzZpNWkzQ0pvRmNsMUxPWXd6TWd3?=
 =?utf-8?B?eTY2VFpCcldyWU9SQ3l3RFI3cUxUUEo5Qk1zY3c3MnhTMEVSZmRNZG9LV1U4?=
 =?utf-8?B?UGFGaHdrU0psU1dPclJTam5oQ1ptd282OXZxRGlBUE9jOXp6RmExNmdFTnho?=
 =?utf-8?B?SG1nZ056SlhPYmlOODg1S2NydklwdTVzRmNiaFRKVTYzckdjSURmZU9pMkpO?=
 =?utf-8?B?Vy9ERmVYWi9BZFl2OXEzMUY2dG44R0RjWU1UbFFkalo1YmFyVkpidExESm5D?=
 =?utf-8?B?RVRiODVVY1pHWXlwSDhJbnlYVDBQWjllbGlQRmZaSEtRTlRlVGpmZlNEQXFD?=
 =?utf-8?B?N0UyVUxsRm9DVHJ4Y094Y2JnME9LZElpUDBQbnhEcGY5cEw0N082cndQL0FE?=
 =?utf-8?B?N0J0SW5CNU1TTzVDS0JVbVIyWjd6OHgzbVgwMUxDb2JIVzM5SmZJbnQwMTBv?=
 =?utf-8?B?a3JkVXh1NFZ6RndHY3dhUFZrZmN5WmxwdnFaOHI5dDZmTjV6NzJwcnJtejRx?=
 =?utf-8?B?bllna2xkdkpLWThTNmJISVhEaS83VVNRZGYzcDhYRmJnckEydU5Bc2dCaXUy?=
 =?utf-8?B?WlNNVDFUZjVPVzQ0UHptQklIdUpyMTlEU1BPNW9CVDFkc0dnRThxQ2ZYZit1?=
 =?utf-8?B?WE9WVEFDcHg1VHNFblNIK1c0ZzE3WXVSSnJ0NVpPcktlajZwZ1JyWEk4TlEz?=
 =?utf-8?B?NFpLLy9ZWVRmMkE2MytKeDRYVk95TG1oeWlsMEQwRHBBR0x3OFJ2Q00rZkI4?=
 =?utf-8?B?R2p4dUFuUnlIR3NNSTk4UUhhMFlGeS9lSXBnU05Ba3JxTlFmTURTT0ZpYUhy?=
 =?utf-8?B?RkhRcGU4Y2tEd0d6N2tuVzlzZHZ6UFFhQ2I0ckJuZy8vbVVuaFFrd2t3WThu?=
 =?utf-8?B?VVpob0RlZ0NiNGFxdEJNS2dNZnBiZnZWZmhrLzBQRXYwclVuczNmMkVtZE1w?=
 =?utf-8?B?YmNFU1hhMU4wZ2NqYlZZUm1IeHpGbXh3K3o2aTUzOENIc2ltTWJmbWd1dkZZ?=
 =?utf-8?B?NHc2NU5IYnVXNjFPdVN6UzNQZlFzT1pTWFU5R0I4VHgrb2dzYVdveGxRUXI2?=
 =?utf-8?B?QVMzVDd4K3VuKzAyQzNDMUlzS3hTbGpLYmdCSEJTakh0eWRPQlFXWDhTNDZD?=
 =?utf-8?B?SWw3VUZ2RThyRU96dTlMeEdiVE50RzFXQm1Db3hEMHh4azZhaXoybGRkS2xM?=
 =?utf-8?B?dXJaQ0JYam83Uzk1VVpkRkJadkZjeU9ZMlBwaW5ubkwyN3RnN1k0Q3d5eGlK?=
 =?utf-8?B?OFY0VDdMRUcvYlhnejRhQTlvSDcrd2w4R0ppM2Qyb3g4aE93VkpzNTBaTEhq?=
 =?utf-8?B?RVMxRjl4ckdtUG5XSkxoNGZjZU5taWo3dmkrWjNuZ09yM2xOYWlkTFE4WHdZ?=
 =?utf-8?B?a2JrWmlaTUZPUng5SnpPa05LdVJQYUlJZ0RXOHEvSXFmZkEzeW05TmsxN081?=
 =?utf-8?B?dlEyOVpYNFo4QXhQNUFvNUJmaW1VMHFOUjJBeVpmU2VWRGFRazZ0NGd3QmJK?=
 =?utf-8?B?T2N0Z3ZpUVZPcWgyUHVGK2dvZHZKMEpoRXFwSzcza2pLZStwM1Y0amIxTzlu?=
 =?utf-8?B?QyttVVdGZlR0WmxrSWZOYmd1U1VQVlNiNkdDOTh2eUl6djJkUDNGa2w2WTRn?=
 =?utf-8?B?QXdhc0FueWRLOGtQYVBMWTVrU21HUTdFa1R5eXRaVm8zWW5rWS9zY3c5SVY4?=
 =?utf-8?B?REZaOVNtVlBwRXQzYWlTdWtYTVNGTnlwMkxoVXNTMnJudzRUQzZLYmhxaG1G?=
 =?utf-8?B?Q3graXdsTFJ3VTRMY05xVFJKa0Y5b2Z2SmxuU0VGL05HbVl2YTFsaElPYXgv?=
 =?utf-8?B?T1Zyb2dpRzIwQlRlSkgrRTVtSVR1ZS9odGNMWndoSHFuQ2JSOU9Tb2libTh4?=
 =?utf-8?B?aHVKdkZkT2lmZmlxSUFmQXZrNEV2YVM3YUVsc2JFcHdMVVUzVDk2bGxIam13?=
 =?utf-8?Q?+Zjr+M5V66IeqGMnGfKInAQ24?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61cedc97-d3e7-447e-870d-08dd03b3393f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 07:17:25.4020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8bpCny+ej39ehMaoNw7U6+ZWAzphxEgQSj4PlAaNxLUEu4B3Kj5xcAxdwHd0uEkwTYLF6dGIytZhmyZu3vLVsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4855
X-OriginatorOrg: intel.com

On 2024/11/12 21:52, Alex Williamson wrote:

>>>> +{
>>>> +	unsigned long xend = minsz;
>>>> +	struct user_header {
>>>> +		u32 argsz;
>>>> +		u32 flags;
>>>> +	} *header;
>>>> +	unsigned long flags;
>>>> +	u32 flag;
>>>> +
>>>> +	if (copy_from_user(buffer, arg, minsz))
>>>> +		return -EFAULT;
>>>> +
>>>> +	header = (struct user_header *)buffer;
>>>> +	if (header->argsz < minsz)
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (header->flags & ~flags_mask)
>>>> +		return -EINVAL;
>>>
>>> I'm already wrestling with whether this is an over engineered solution
>>> to remove a couple dozen lines of mostly duplicate logic between attach
>>> and detach, but a couple points that could make it more versatile:
>>>
>>> (1) Test xend_array here:
>>>
>>> 	if (!xend_array)
>>> 		return 0;
>>
>> Perhaps we should return error if the header->flags has any bit set. Such
>> cases require a valid xend_array.
> 
> I don't think that's true.  For example if we want to drop this into
> existing cases where the structure size has not expanded and flags are
> used for other things, I don't think we want the overhead of declaring
> an xend_array.

I see. My thought was sticking with using it in the cases that have
extended fields. Given that would it be better to return minsz as you
suggested to return ssize_t to caller.

> 
>>> (2) Return ssize_t/-errno for the caller to know the resulting copy
>>> size.
>>>    
>>>> +
>>>> +	/* Loop each set flag to decide the xend */
>>>> +	flags = header->flags;
>>>> +	for_each_set_bit(flag, &flags, BITS_PER_TYPE(u32)) {
>>>> +		if (xend_array[flag] > xend)
>>>> +			xend = xend_array[flag];
>>>
>>> Can we craft a BUILD_BUG in the wrapper to test that xend_array is at
>>> least long enough to match the highest bit in flags?  Thanks,
>>
>> yes. I would add a BUILD_BUG like the below.
>>
>> BUILD_BUG_ON(ARRAY_SIZE(_xend_array) < ilog2(_flags_mask));
> 
> So this would need to account that _xend_array can be NULL regardless
> of _flags_mask.  Thanks,
yes, but I encounter a problem to account it. The below failed as when
the _xend_array is a null pointer. It's due to the usage of ARRAY_SIZE
macro. If it's not doable, perhaps we can have two wrappers, one for
copying user data with array, this should enforce the array num check
with flags. While, the another one is for copying user data without
array, no array num check. How about your opinion?

BUILD_BUG_ON((_xend_array != NULL) && (ARRAY_SIZE(_xend_array) < 
ilog2(_flags_mask)));

Compiling fail snippet:

In file included from <command-line>:
./include/linux/array_size.h:11:38: warning: division ‘sizeof (long 
unsigned int *) / sizeof (long unsigned int)’ does not compute the number 
of array elements [-Wsizeof-pointer-div]
    11 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + 
__must_be_array(arr))
       |                                      ^
././include/linux/compiler_types.h:497:23: note: in definition of macro 
‘__compiletime_assert’
   497 |                 if (!(condition)) 
      \
       |                       ^~~~~~~~~
././include/linux/compiler_types.h:517:9: note: in expansion of macro 
‘_compiletime_assert’
   517 |         _compiletime_assert(condition, msg, __compiletime_assert_, 
__COUNTER__)
       |         ^~~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:39:37: note: in expansion of macro 
‘compiletime_assert’
    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)


-- 
Regards,
Yi Liu

