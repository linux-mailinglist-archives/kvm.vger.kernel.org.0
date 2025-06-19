Return-Path: <kvm+bounces-49930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCF4AADFB99
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 05:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 692373AE928
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 03:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E54236A70;
	Thu, 19 Jun 2025 03:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UIGOoZ0N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D423D544
	for <kvm@vger.kernel.org>; Thu, 19 Jun 2025 03:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750302441; cv=fail; b=hSX9pk0IDWGj+cGBhgzKQ5NkPHeAc4351whdXHBYG/zBZr8hZ1gu1QRlDk1PaOdyLZMlVhebdUJI2i4AgSLRAZAwVMK7gn3kcMV1URZ/a48yIdDILsbRUB5GxlUmZRvhmlXSpFZfRDFlhP4WyY5KXQfBfgjFafN9XaJwSqWimOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750302441; c=relaxed/simple;
	bh=uitvcfbKtVntWynsoBZiKsqV7ViBe+4BICW0zqsczSU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WUxA7A7SfHnRMR6vqI/xBsPDzJyKs9hbuSfHlOaKCbLsmV5Jw5c7aA2FQ+HwCj3iXVBNWnvU/9ItsU+NUwC70I8wPkdoRukWulm1zUu+Z+DOcEPsokDziK72yqVkS2lTthFDFV3TKFhbBIzKuQSBOKSiofZBtrFcbNHtUmgk6zA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UIGOoZ0N; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750302440; x=1781838440;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uitvcfbKtVntWynsoBZiKsqV7ViBe+4BICW0zqsczSU=;
  b=UIGOoZ0Ng9w8BFKiFANf9nMulOeg88753gENtt57NqeoHqtiYJHnkKrs
   OjAYOXtNVTUxEqF56P5/rwlW8GR9X661XAAamI7uTTeXRNQ4A/jSJqSDe
   y9oH84RUfPR27+Ewi7Qz8LiqIaeMdBEp6RkWYTIS2FMg3ddxIx1+uK1YZ
   3ES3JAGO1W7ecp91acBain4OU8uQfNgrK7Tmf8DN5zX4Ho5ZNxDWXNCEi
   QJdGo+o6g18UqBYmELCjJY/ZqIYo0aDb17pw6dmzLu3Uo0qtaxjWomnLv
   U0PqPFkFwNiolEUSa2d+yp+5ZjjSpw6SRs7Xco4pMv3OlmJvMSb2JA8Fw
   w==;
X-CSE-ConnectionGUID: DwvuB8raSS2Ln0IWCqF8KA==
X-CSE-MsgGUID: T4aoSZGNQYOJ0pYfNC6adw==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="63152776"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="63152776"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 20:07:18 -0700
X-CSE-ConnectionGUID: EyRSNVq7SIeKLB2hu5Hgow==
X-CSE-MsgGUID: v1zQyZKpQbiDcNm6VT6XyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="149930456"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 20:07:17 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 20:07:17 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 20:07:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.45) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 20:07:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xlWxbNe82KQnYr9Wtsb9sStpeKa+f/kqGuG13Px6yLzsNYWiAQHkHFCNcyzOjrCkFZlbv0dYFzOCxRVQ9kpLbnJZOyI5YRaAPrcMLQ0MqCTaf1wf8Y3YyIjbLpyVHvjV1GMCDVGTGTL3U6oY+LV5H0m5uzOFxQBIc/eAwb6KuoPGvgF7bLjHibvrs5baooDxqox8Gy5SIzm+z1zVV2HWL8MjiVNaNg64LYDl709yoHqO2YK1yH8zxLQYbg1YWakUmBYoHqwYEt7UQjkVF76mOyCFISwo6FmhbFdVKwzwlhHnf5/BEmPXJ4un6aLNaC45HKdQK1WHQThlN2wN2wLzqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UR8H5wSTVkgeYSF5Oj2QnSt1j8jm/qAbFQQUIXplvF0=;
 b=S+LzNsXBKQ9r6mi5yqOoWQaKLdz1oICixJfuZmg7vhHJWDgk/ldsJ4KiPdm1h4dyLIvkoSCMoeWQxAYBMNq3X+u82ANNEBj1Eh+PokyPGfFQs2+4ckuw1KWfp/uQV8WH4wKiRfp32XKxuSBqRmqU1BwIXRrE9Wv53ny0aAX96UPMHLezYy8fOzunckC/6Cq9bsTbKILCd1ujp9PoDID7wGyVB6cm3rDt+59kW2D5yLSmLc75qvAqZ+0bpVclkHkvDjIifW0epbzu9297VhtxY+wHp+jbYBpm/DT0PYxutbU1fXmLMBs+lFy7ME+GmybR5rFXx2AP4/3uS0eODN8x5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DS7PR11MB7857.namprd11.prod.outlook.com (2603:10b6:8:da::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.28; Thu, 19 Jun 2025 03:06:56 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8835.034; Thu, 19 Jun 2025
 03:06:56 +0000
Message-ID: <0de41d54-31da-466c-a6bb-f45ff919ced5@intel.com>
Date: Thu, 19 Jun 2025 11:06:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/5] memory: Unify the definiton of ReplayRamPopulate()
 and ReplayRamDiscard()
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, Alex Williamson
	<alex.williamson@redhat.com>
References: <20250612082747.51539-1-chenyi.qiang@intel.com>
 <20250612082747.51539-4-chenyi.qiang@intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <20250612082747.51539-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:194::7) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DS7PR11MB7857:EE_
X-MS-Office365-Filtering-Correlation-Id: fff8f11e-9c1d-4020-1a88-08ddaede5951
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eCt5cS9ZY2pGNjhpd0g5b2d0bG1NMmxFSkpKU0Uxd2kxMVJ3cytINHRGS1ZR?=
 =?utf-8?B?ampzcEtLUno1OGF2T3k4L3R2QTNSSjFNd2VXTm5USlpDbmQwMktXWWQ2WHQw?=
 =?utf-8?B?UXR5OHFwZUJZdTUyMkIrNkMrWkhYcW1LWTllMmw4QmlTMitvazlnQVpiWEY5?=
 =?utf-8?B?eXUrNXAwMk9qd211S2dodUJTZU1jMnhmY3FPODlydmhETi9scG54V2o5MDRI?=
 =?utf-8?B?Q1ZxbjJWQWtkWTlwSzVIRWt2OCtRaSs3dHVBcEtybEhZNEV0Q1k0WFl1V2hp?=
 =?utf-8?B?eXZlKzUwTTZWbkVOOW0wWng5dWFiWCs4S3NPM2R2T0hwSHBVekQyNitNTWh2?=
 =?utf-8?B?NW9yQzB2Rnh6NGVVbEtWbWFmQXYyR3FCcE53R1FKTk5LMTZyM3UyN3A4U3JB?=
 =?utf-8?B?aTFIbzFSTWtsQ2M0eGptOG9XSXE0Y0xDY1JFaFB3ZW00dS9sZHJHSnY5SWc1?=
 =?utf-8?B?dGx6bU9pcmdhNGFFdnZZSXZkem1id3cvUzdmWmZjbVQ1UmVSa1VxcXhzUU9p?=
 =?utf-8?B?dnlxK2VaaVl5TXJvcWhZL0R1QUthN2dtNXpHTEZCK3VJMzdaNDlZOTB1aUdX?=
 =?utf-8?B?NGxHdExhRGxldCszRGtYcHRaUGJjZ3IycHY4KzZHWC9ZbnRySmJxWWRKUUNS?=
 =?utf-8?B?Y2NHZGtBU2wrTEZqd0g3UTBmOHJsOU0yZFltZGRmQnQydTVYeTVFZXAxK1Q0?=
 =?utf-8?B?cDlMZjRERnNGYzdFaURQc0JKd3grTVRtNFgxbmp5d0pjSHpDMHJvS0NPVkxX?=
 =?utf-8?B?VDlGUVUvaG51SjI5R3JtOGVhYjl3Mzh3Q0VqbUNaQ1pNNVFYUFI1RUZ3dlc3?=
 =?utf-8?B?aTgxUDgyc2ZTU1FLN3RDN20zVE1zQ0phWTlNbUthV2dIZGVCanpRUlpXN3Yx?=
 =?utf-8?B?d3pGY3BjNUM3aVA5cUJHY1RaK2wrMGIrY0Z2eFp1VlFPT2R0b3NzT2RSMXRi?=
 =?utf-8?B?bzJ6bDQwTmJ5WitFQS9xNDI3Vjltcjhrc3JsL2RaYTZ1NS8zYVhVQ2QyK1Va?=
 =?utf-8?B?TlhsT00yditMOGMzNzd0dkFVMHVNQmlZMXM1RXNmNjJWSUt0amJISDFzR1d2?=
 =?utf-8?B?UEkyZWZPOWwwNDYzMFlsYmY5aktPOUxPMUhoM0lEd1lQYlRZbHBmcXpCZHE2?=
 =?utf-8?B?M0cwZ0NwaWdlVkxNTkx6UjZJaHd3Y3lhSFBDVlowaU9mdE41VkthY0k4SFBz?=
 =?utf-8?B?WlJCbWUwbERQVEhodTdwczcrb0sydEZrWFJwZk10UFBCZGJuVWlXeFUzNk9V?=
 =?utf-8?B?QTBwb1hvZlpkTS9udmgzaGNJT0xtL0ZGNFFyWmdaQ0czbXkxaDM5V1FUUEhQ?=
 =?utf-8?B?TUJKQnVnNVpwWThpSnJQRHNJbys1SXRWVHZQdXAwdU1KSmh1ZWlPdW1INkVU?=
 =?utf-8?B?QXZTY1RQYnpXOGEzVEZJTGJrMGRnbDBIWmROSjJ5azBuMWhJdnNMNWU2SUxY?=
 =?utf-8?B?amp3SjlhWld1QVlNZHdUZTVkUkhvMSs2MWVxZFdpMjQyREtXaEl6Z3RseGhR?=
 =?utf-8?B?cmRZajBMdjVBdHZnTU1EdG1SWWJBODZkT2lQcGE2MytwTm5BU0Q1NHpGazd6?=
 =?utf-8?B?cWMza3pUQ3B2NzVleDNvRG9VTzlZY21XcWR1RVRrTitXZmVGL1NXbzk2b1k4?=
 =?utf-8?B?Y2VrMWhrcWd0aDdGalhRVWtkem03OE1hdHdISTZEUXlESkxLakc4ejJrM3RO?=
 =?utf-8?B?MFMrMDRZQUQyaTBtSldrKzBkNXcwakFaV1J6b2lFTDM4a2RNY1huQXBiMzJk?=
 =?utf-8?B?Szk3d01aOFYwbktZUEh6OWo4d1JkVGY3UUxIRFo2RkRRVWtDclRSTzhNMzM3?=
 =?utf-8?B?TUpGdnE5cmd0anlhaGlhWkdLSHk4OTVGYWE5eDZPNjRvSG85VGdIeENuMlNl?=
 =?utf-8?B?YUIyNDVvTm91WEx2c3krUW5teWN0TzIyVEhxaWJMdWZTalNCRlBJcHc4azhs?=
 =?utf-8?Q?7RiYsJY3HLY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmpmLzA3bDV3MjNPTWxiL1ltUWpGa0hLNnZhZ1R3WGIvOW1MRzY0eVBkYzJM?=
 =?utf-8?B?eDNQRHBESTVRNGdxUGlhVU51bXRzVWw0c2lNWHJ5dEFZQWNkUDBWZllLWHBC?=
 =?utf-8?B?MkxDa0xNNzVJRkpQZzhFVUQxUTNIVnNmRzNwZzZMZXZrNms2NGhjSlBMcnI4?=
 =?utf-8?B?U1B1WlBrYkhtY1JKVnVHRnVWd09RNnRzTlhib1ROZm9BdUFCZWZIMTlHVlBF?=
 =?utf-8?B?Y0F3WTFZNGgzS0VydVNpb01rRENPd3BEaHVKdVpQc2Y1Z1ZjSTRUYTcrb1Iv?=
 =?utf-8?B?eFZtK2gvQTVaTkRmZmt4SUNWZUh0U0cweVh0ZHBkVjhxeDNucGtjM0k0T0Nx?=
 =?utf-8?B?ckg0MWtZVVlpQkNlZ1lJdG9LMit5TkJGMjJucXJTQVRoTG5ieFlucllsczBh?=
 =?utf-8?B?SEs1TDU1NnNLbVA2UWpTQzF4cG52YzRwZjZNWTBlRHplc1F4c2R2VGFOWk5G?=
 =?utf-8?B?cUgrZll2VTB5VDVtalZFcjFuYXc4MlBPZzMwMGZ0MVk0ZnV5Vk1CWlJrZnNE?=
 =?utf-8?B?VEUxdTBQU0dkSzJaR24rc1Z5R2E1TkxnYXllL3grY2VSc2FVdVpoY0VITHc3?=
 =?utf-8?B?dklaazhFb01zTjQvRHBGRGt1N2xyaWlENzNnaUgyU0hkQmZmSW1iMlBtL0Vl?=
 =?utf-8?B?WkNKNUp5eVVudXlMKytRRkpMdkVaSW80d29SK3lhamlxK21SVk5WaFZwNnMr?=
 =?utf-8?B?Wmh6ZXNSN3Qrd09Fa1hVcE1pZGphejIva0NseG8wTGFHSUoyYVZlSjJzdE55?=
 =?utf-8?B?d1p6WUh6Rk5SZzRJd3lqOHlnLzdUOSs3YzVZRVcyRE52emE2SHpqbnA5YWRv?=
 =?utf-8?B?ZnBhMjBBMUJxc2ZrRlJMNUVNeFNMVERsWTZKWTZheERuVGtYV3BQL3ovNVpy?=
 =?utf-8?B?U3BLRDcvY1lyei9Hdms1b0pSbHdSSWZSNThzQWZ3SmZlbVFIWjNwazlQVWdS?=
 =?utf-8?B?a2FiaE5JTE9MeCsrU3FPTXE4Mm5RaVpmTFhJR2ZiOFM2RVhNRDh5N2lTemlI?=
 =?utf-8?B?SFpnYWpseWFISDRVNTJUdGhKbkwzcktyZytnVlFFVXdKU3hIU2QraTZQSkZC?=
 =?utf-8?B?RG14MEs2Rk9ZdXRSazlaMEgwK0k0V203WVJ3VTdtdWNKMnpKZlZTZGl0K2dC?=
 =?utf-8?B?WXYwakMzYUVUNWoraDNRc3p4cUdzQTVTVFFPQ3lmTG1aOHJiK1VZT3QwNktr?=
 =?utf-8?B?MmVPODNrb2J2UWQxSklFbjI5STRsa2FQSmdscm0yQ3NWSjU5V2RiN3lKUVpN?=
 =?utf-8?B?ejlWblgybmVpQkdudXVtUWxBbUVxcm1FL1loNUtSOVhrRUt3aTJ1cDcySFlp?=
 =?utf-8?B?VkdkV2FXWFRYNVdWT0VnN2JIQTBHU1d3ZnNTVUJOWHNDZ1F2T3FKU21Lb2dj?=
 =?utf-8?B?TmFDd1FIQk1xRCtTank0bzg1a28xSGRjeUJsZHdKZ1k0V05hQk1SNGhESzZS?=
 =?utf-8?B?YmQ2VUl1dnRjcUw4WnpNZ3BnSHAyUlpmc0ZxLzJTcktQYWlKL1F6M2RTVzZs?=
 =?utf-8?B?ZE5pa2lPV3FKeGQwOWVJOVZ5T3cycTlLeGtkK3BJdU9BODREczI5TXhhVWNQ?=
 =?utf-8?B?VUg5Y3hBeFViU21rci9lS05hUkxjNmZsWUVPM1JSUTFXTDVlOS8rbXBOS2c2?=
 =?utf-8?B?ZWJ0K1liRnNrUk16b1laVVgzcHV2OUZnYmJhVWxYVFNtYlNaUWpqYW9WNi9l?=
 =?utf-8?B?YjlhMlVnVmdKcG9uK0pDT2FQSFA3dDR6QkR4SytxaFVTWXhLNTdBZjIvdVZU?=
 =?utf-8?B?UlR0NU5JUFRmUnQ5WmRsa0xIL3hTSGoxbTdWaUxFeHZXN0g1NWhJblN1elRQ?=
 =?utf-8?B?UTBtQ3BITGhxdEhzclZnaDJ4UFJsKzFMVVNielhpOHFET0puWU81ajlWRmU1?=
 =?utf-8?B?N0JFNGpJQ0pyRFlJYkplU3Q2c1FsQXJUSmJJcmJjWXpQLzlWNEdTR21TK3lW?=
 =?utf-8?B?Q3E5UmxhdUNiZ3NINEtkZE1BQlcvK1hOR0tVRVc2VjRNbTJsL2l4ellnY0Nh?=
 =?utf-8?B?Vld3Y25HZk9CTG83QlRiaS85cE1FV3cwT1prUkVhZHZYaFYvVW5rcTJGUVhT?=
 =?utf-8?B?TlBTd1FyU0pMTWp4WkppZTZDcXlxMjNoT3h3cytKZEkvSkQxTFh5WWhKN0hS?=
 =?utf-8?B?VlE4QUpwOERicFVtUmpCRlBTOG5hNk9YU3B2RGdJNHdqa25OWCtmTTJmVDJ2?=
 =?utf-8?B?bGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fff8f11e-9c1d-4020-1a88-08ddaede5951
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 03:06:56.2655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7lTe56GYP4JHnu7x6e0pqApkIrBCKog9oyFka/Bh35ChtWuGty+bNTP4c9wKEpR/FO7hoEfpXPi9G18GhlWzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7857
X-OriginatorOrg: intel.com



On 6/12/2025 4:27 PM, Chenyi Qiang wrote:
> Update ReplayRamDiscard() function to return the result and unify the
> ReplayRamPopulate() and ReplayRamDiscard() to ReplayRamDiscardState() at
> the same time due to their identical definitions. This unification
> simplifies related structures, such as VirtIOMEMReplayData, which makes
> it cleaner.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v7:
>     - Add Reviewed-by from Xiaoyao and Pankaj.
> 
> Changes in v6:
>     - Add Reviewed-by from David
>     - Add a documentation comment for the prototype change
> 
> Changes in v5:
>     - Rename ReplayRamStateChange to ReplayRamDiscardState (David)
>     - return data->fn(s, data->opaque) instead of 0 in
>       virtio_mem_rdm_replay_discarded_cb(). (Alexey)
> 
> Changes in v4:
>     - Modify the commit message. We won't use Replay() operation when
>       doing the attribute change like v3.
> ---
>  hw/virtio/virtio-mem.c  | 21 +++++++-------
>  include/system/memory.h | 64 ++++++++++++++++++++++++++++++-----------
>  migration/ram.c         |  5 ++--
>  system/memory.c         | 12 ++++----
>  4 files changed, 66 insertions(+), 36 deletions(-)
> 

To fix the build error with --enable-docs configuration, Add the below fixup

======

From 41bf404651b180f886bd174d36ae62be2b0da61f Mon Sep 17 00:00:00 2001
From: Chenyi Qiang <chenyi.qiang@intel.com>
Date: Thu, 19 Jun 2025 10:49:46 +0800
Subject: [PATCH] fixup! memory: Unify the definiton of ReplayRamPopulate() and
 ReplayRamDiscard()

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 include/system/memory.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index eb2618e1b4..46248d4a52 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -577,7 +577,7 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
 }
 
 /**
- * ReplayRamDiscardState:
+ * typedef ReplayRamDiscardState:
  *
  * The callback handler for #RamDiscardManagerClass.replay_populated/
  * #RamDiscardManagerClass.replay_discarded to invoke on populated/discarded
@@ -741,6 +741,11 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
  * A wrapper to call the #RamDiscardManagerClass.replay_populated callback
  * of the #RamDiscardManager.
  *
+ * @rdm: the #RamDiscardManager
+ * @section: the #MemoryRegionSection
+ * @replay_fn: the #ReplayRamDiscardState callback
+ * @opaque: pointer to forward to the callback
+ *
  * Returns 0 on success, or a negative error if any notification failed.
  */
 int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
@@ -754,6 +759,11 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
  * A wrapper to call the #RamDiscardManagerClass.replay_discarded callback
  * of the #RamDiscardManager.
  *
+ * @rdm: the #RamDiscardManager
+ * @section: the #MemoryRegionSection
+ * @replay_fn: the #ReplayRamDiscardState callback
+ * @opaque: pointer to forward to the callback
+ *
  * Returns 0 on success, or a negative error if any notification failed.
  */
 int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
-- 
2.43.5




