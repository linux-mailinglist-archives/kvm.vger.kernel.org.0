Return-Path: <kvm+bounces-41169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B92A64350
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 08:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB2511881BB5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 07:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA60921A931;
	Mon, 17 Mar 2025 07:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sulc40/C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2640D1422AB
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 07:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742196022; cv=fail; b=dhPU3AQsXlAk3Z/AGW6aIWVQ+MidvYGeJOnfgJPulEA+3XimkWf5jkBZyUgV5udUgjZ4X5WCiULtKFeNAvy9UoMz9FhL4Y6h81OjklbBIx9HailHavN4Fx2PnWRFaR9WsFedQ+llxnuJ68nZniX/5mR26u0hO4HGOAn4nkZE8Xs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742196022; c=relaxed/simple;
	bh=8KUz0LV5wTwsT1ZDj0ui/YIZ9Z0vttsr8S5HSJvQF/s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BoUy5Vpd6QCDNhucCbgI1XwKe9fyuokelOH9tMXslVY6l1DaaNGuz+PKAwk6LYhpeoTXNJYVThZsgUh2qSKDdhCfpjwNwC8fp4ftiHtafgw0rzHYrzWMdhBhJao00V+tviU+q7xbiQOA2M8wSSNU0zkMQa//p2m43mfHPBgNJ5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sulc40/C; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742196021; x=1773732021;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8KUz0LV5wTwsT1ZDj0ui/YIZ9Z0vttsr8S5HSJvQF/s=;
  b=Sulc40/Ce7dXiIEU3GcEKxa5odSopEL2uIXuvfeeCQsB2PD6XN2xytcD
   hWqzKvpXybce2TwzkSDZbKOpZ+o4bBTRbm+Jq5P5u3Yleh+LrIyZ1VxGR
   9lzlhoaWJVEAKWh+6Q6EQ4kw4nDbEHysCcJ+OWBdQ5dE5O6xR06+/PROo
   oHDl/fJ3Ebcj5oQSSdE3wIDwZkoZVNBNXcvRV5i9DMieF+ypNJBKntJdl
   OYqzqZ8mv5DT3bfYwqlms4uhyJTlsZhs1qV6tRuu+6jDe8OKLRrg3xUJ9
   MYMCAZpMhuZOxKJiwFHBtwe09QjnuxyVWm/m0sEr7Gos5nVASWzLfo/Xm
   g==;
X-CSE-ConnectionGUID: uqOUbHGPSc2RlcBj3GeKtg==
X-CSE-MsgGUID: lLb+qvW5R3+QPBcsX0D6ZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11375"; a="54274049"
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="54274049"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 00:20:20 -0700
X-CSE-ConnectionGUID: o21mjXlJSu6xECzw0p0U+A==
X-CSE-MsgGUID: AB1PPC3VSNam1N2bOOHapA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="127042832"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 00:20:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 17 Mar 2025 00:20:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 17 Mar 2025 00:20:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 17 Mar 2025 00:20:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kI+YKvCrpxJJq+GiYWbmcJjRlO/yM0dgdhW6z9WSZfuFZ0kDqvZRT9To4/TSz8MJb5SCzkdMkcc9iv4HdN+szlNTzMkJDxJ/vL0hMQmUDxFGoQ4hakvWNb741LrTrF09oMoH0mesZql0oDsh/1hO6aS/x+dEiMUHqPmwB5uqCgD+yXFAUg6d/aE78jxgV5MtC5BBkHQqdrwKOTsumr/DSg+x3rx/RPPCLv1in4Bn0KW6AkmNmoUXhPt8pfjnWyHYXh4IB3AIPJa0XW88P17JXC+LOoRwaQUh18b6txHROpQlSKNyFgEBERtUIwiQPS0S4irm3Xu1Z6ze0YnDGIVtLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qVanGhVlpsd7Rr3aFn2pwo5WRzyWYxKSDHqH0DELZys=;
 b=A8xh8DiYKzdX8XgOPxVpN1fOGIRc1rOKcDKQb945ZUd/B3xcVb7dturr+cV2/QXsYo94H/MXABm8HkvCVbiee/wMFM+U5WWlBezNMedX6cbF4+DAUzQPkkpRXnQunPvqIaTOxIsEzqC4CH4YHEcdB2hNN9bKjY769Sxu4lAoIRBdTllB+y7MBx4h9qIO0yQ+4Gu5YT/HXMtamf/rPQgTSxXVthmJKmZeRJdj8SFDDv91z+tgV98sNjbw0WbWN9oBMVU036SBB/Fiq52/Po+SG4YBNKzQEUDJGq0AKB4zfkk1MGMwkJ/u5GgEg8bzObzL4UUBpfgPF5i01Nma/q0PWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6145.namprd11.prod.outlook.com (2603:10b6:208:3ef::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 07:19:53 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%3]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 07:19:52 +0000
Message-ID: <f5cf80ed-0761-4b2c-a721-f41f9556d520@intel.com>
Date: Mon, 17 Mar 2025 15:25:18 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] vfio-pci support pasid attach/detach
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kevin.tian@intel.com>, <jgg@nvidia.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<zhenzhong.duan@intel.com>, <willy@infradead.org>, <zhangfei.gao@linaro.org>,
	<vasant.hegde@amd.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250314084813.1a263b66.alex.williamson@redhat.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20250314084813.1a263b66.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0197.apcprd04.prod.outlook.com
 (2603:1096:4:14::35) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: fa5269a5-9552-44e9-d201-08dd65241c5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bnJBV2JrWVU0U2F6VTRZWCtHaFdkTmRDK0VGRTBhcENaaCtZWlNudUJyRGZt?=
 =?utf-8?B?UTRmKzNVSFRUMjhLbG5zeTJYMi9jdThXdFo3ajI5YVF5cjNOZVdwYWRqdzBC?=
 =?utf-8?B?ZmlpU3RuYUk5aXJBU3ZDZTdoQkNoV21xN0JHQlFtOXFMVzVZZVdlWWlBK2dZ?=
 =?utf-8?B?QVAyT3FBdzlQWVFJek1HUnh6NzZYVC9jWEwxUjV1VFA4UC82cE9nV3hTUDYx?=
 =?utf-8?B?RWgwQlRRN204TXpYaEtqYlJwWVRvZmNQeFZhbDE4Z0d0UGdHeU51VWdMS2FT?=
 =?utf-8?B?MGRWcitBSFlWWjhaYVFrbVVlcFRQZzhhbFFRVzhIcEt1R0psUDhBaXdhZ2Fu?=
 =?utf-8?B?K2hQR2V6YlhTOWZXbG14S2YyRlVjZ0E3bm5pdXZVOVA2M3RDekp2M1RNYTVm?=
 =?utf-8?B?cVRzOTcwN1FmSlZObCsxTFArY1hRemY3bEw4SmFEdUtPZU1HV3pxYkEvOGRU?=
 =?utf-8?B?L3lKTkFXSngyVVZvRzhmRkdjbVREdFEzQnpxR290NDhUdlIvTjJObm54eTFB?=
 =?utf-8?B?bjZodEV4VDl1QnZNbnZkNUJmRzdhYjN6cXF2RjV2QmVHSlV6cjRmZEcxbXdO?=
 =?utf-8?B?RXkxYXNnSmIxYUlaRnFJTVA4Ym40cVNKRDdPai9pWlFhTkxRNHNYSjExVXRG?=
 =?utf-8?B?bitLTXREbEdndExrbGVQWFQ2cVk2WWYrOTI1NkRUYWpNeDdkTSs5UVI2a0F3?=
 =?utf-8?B?UERWNC9KaVFTWlovUU1nQ29ZY0NlNzdSQ1RDQXJtRGRDQy91WlVscGxTdG9S?=
 =?utf-8?B?aFNWdGJ6TUgreTFZRjNoamJhWG5uZGxQNGFTUGxiOUIrUzEvaFFMWWhwTGlJ?=
 =?utf-8?B?L0VuWkFCQkRLZTRneUJ3eVdudURlRlU4UnhvTDZpbEF6eXNvZ3NJaGVQSDkw?=
 =?utf-8?B?ajNlSThDRXZld05YU0FxZVpQVXN2ZnZpOHlpRzlyWTltMjM0MTRneGpmdzl6?=
 =?utf-8?B?Z0lHbDRtdlpXSVV3S3J1UFNsUUtvWUZBSzZUUlUvV2RSaUIwdGJMN3krcnRr?=
 =?utf-8?B?MFhUdmNmazViQWltM2sweEhTQ1BVRTI3WXNSR0IvMWlmTlc0QVAyTjhvMFF1?=
 =?utf-8?B?QmEzcDVYcktiNSt2ZGl6K1FTbEFBYmNJRUNiTzgxQkRqVGUvdHFtRys0UFd2?=
 =?utf-8?B?NnJsMFNYTHVkZGJPUVMrUnh2cDg4TkhCajhXaEd6NmF5elhLd0JPUUlva0pJ?=
 =?utf-8?B?cGdUcVNsZEVnZlJ1WExOcDR1YnlsN0g0VlVJMDhvRTMrdE9wam5pc3VxYlMw?=
 =?utf-8?B?bkY3TWdvbWNkM1FkaHlUSDJnZkVQNldDTXhMRzF4UDhzSFIxR0NpNmRtd0Fj?=
 =?utf-8?B?SWlLbFFWNGFkRVR5cTJyVVZpV0t3VmJmU0UzMjViSVFIdWxXK1JMbldwMEdF?=
 =?utf-8?B?OW92M0RNNlJSdnlxbXdkNTJIMkU4K1Y5akxmZ09zYWlYaElLa3pqa1M2amMy?=
 =?utf-8?B?QXZzRndUd0RXS3ExWk9UMVp1Q0U4cjcwVEVsNjhrbyt6MXRzaUdEUDMyN3Rz?=
 =?utf-8?B?TE4zS1FLOE9SZEtGVUwxczY4MmNnNVcwZkJ5Z3YwaVN2UldBTDV6My9lU21J?=
 =?utf-8?B?cVlEV1p0RDZBYzkzV2pRaEM2RTZrVG5FVGp1aUNNL1B5cHZ0MGk3WE00dThy?=
 =?utf-8?B?UWtTd2ZObi9iclNKVmtwWUhMN3hYVDFPaXpLekhvem9RMVJpOGFTZEhWNVVT?=
 =?utf-8?B?L2tvTk1jQk04ZmxkanNzZnE5QVZwVGlnSkYxTmNERGxEcVpYZTVzTE5BZ21n?=
 =?utf-8?B?dlFadHdhYmdMajdLd2FnWmswbE9RSWtGdS9ZK1NuUW1FWnlkbDNJOVNXb1kz?=
 =?utf-8?B?MFFnYWl2MmR6em5hTytsZmdQem0zdUhsVStnM0pmTDZjeHBsWjhVRDJDY01u?=
 =?utf-8?B?c2JmVWVLcVFTV2JYeWNuTERXSU5JL0pLNERHQXRHQjc5K2c9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUpMUmRKOWZEQ0pweW04NHlKZmR4MGNiRnQzcjJtOEcvbHdlTHkzWVNudS9D?=
 =?utf-8?B?VUVlODIvcUFsVjdCcHhWOVBhTWlLVDZZNDZKMUxCVnBHb1VGMHliQllTenB1?=
 =?utf-8?B?S2VNbXNVN1VTZnA1TXVNck96VEVLak5yTnh1M3RUNDVMMk9EVVU1cU9Kem95?=
 =?utf-8?B?QzVMUlZzWENxS0lrMGNHdW9JTGZkQW5pZHluVWN4Z1hsTVh5NWpEWUtrN2dF?=
 =?utf-8?B?aitJWmwvQzY3SkFXc2toa1NlblMrNjNUanlVd0NGTUZVN0ZERG9WelZ6Wjgr?=
 =?utf-8?B?anR6clI2MVg5QjFPNXFqN0YrejBCbHdmMWEyTGpiZTNlVzR3Z2luU3NORWgr?=
 =?utf-8?B?d2FnNFhweDZ4YnJESEtsK0U0aklLNW50NEI5UmdlNG5XSW9qQ2huVkJ6UE5j?=
 =?utf-8?B?WGlUOFBEM3NhblNYQ05UckxZZDhBdTc3ajBLdHh4UGpicEpQR0ZhNkNaRlVa?=
 =?utf-8?B?bUFwWmljd1A4WnVHa05xN21FZEFwN2l0eGtkdnZPTm1FU1hvZDJDaWFvYTd4?=
 =?utf-8?B?MllpYlZ6ZmkzUGhFUGFkalUrWWhVbElwWmNndm9hWjZGWGphanZvblNadzIw?=
 =?utf-8?B?NGhIeTVGVVc1SHhBaHY5L3kvMVFFUmVINkJRQmNYbVN5SVhZa0xJUUpNbjA2?=
 =?utf-8?B?eGNySlF3WkZVOXA2VmcvMkZYb1pqNE1uZVFKUHE5R2dVMndIdWgxSTZsWWND?=
 =?utf-8?B?SmwzaXgxTTNVZU5Eb0YvTUhnQXQycGFtcmZzOWhJdnlKcEpFc2ZpenlGaWpW?=
 =?utf-8?B?anN4V3hZN3BLZjdid1dKdGl4R2xMYmNjblhXOExrZllBN3hjTXA4WWUwWTJ1?=
 =?utf-8?B?cDJKcTNOUEt2c05RaE81VnBlRUpCMnhrSytzN2gvNHVjRXhDZjVHN2ZmKzQ3?=
 =?utf-8?B?dlpienJYYXN0eGlob25kS1FiSTJoTXRCaytvRzdnbzZMMUdUcmhLZkFMdXJx?=
 =?utf-8?B?K3ROdTg5SzVjWURGTE1SOHJJS2x2OUp2TG5YRm51dFh3U2xXYVlWNVBwK0hD?=
 =?utf-8?B?Z01JbndsMmNGcmFHRGN3UnRRNVJLcHlwY2d4Ni83cUhpT2xkMUVWd3dzWlJP?=
 =?utf-8?B?SVFPTzU4R1lYVVlyWTlzOWcxa2w3ZXRnbTJSeHJlOUNYR1RMeHl1ZkRoMGlT?=
 =?utf-8?B?VzVmYm1IUUJLTHJKQXQwMGU3N2IrSUgrc2ZHNU5OZDRrNURnUmQ5akk1Zk56?=
 =?utf-8?B?cVlqRnRYVGQ0RkpON2ZDMEZGZHVsQ2ZYdVV3eHZ2SEZ3Z0lSL1ZaWWc4RjBQ?=
 =?utf-8?B?VVdMR2NGa1hVUzcvWFJJUG5QRkZ2WDRQcjZEVnJ6T1RmRVpUQmhiRjltM25D?=
 =?utf-8?B?SUhVdEVBV0tKK1pRWGt1b1ZMcmpzVHJPc0RTVlZveDZtR0dneHZYRHVHY0hp?=
 =?utf-8?B?RHFITmxrYlBIVURKQ2huTFFIdTFxTVFNbzZYdVNMNXVQSzZudjJyNHIzbjNl?=
 =?utf-8?B?RVp3S0lBcElBaHR5SVI0cEluMDFxNDBhY3o0KzUxSE41VXF4d2k4YkpaRENH?=
 =?utf-8?B?b2UrbmZIMjNQUVQzQUtwcHVuTzh2YjlRRDRDN2hONEFodmhyZHZGZjdySC81?=
 =?utf-8?B?V2syeXA5RDhpckhBbk9VSkMwZWFyM21ycEN0VTBEdVVHUUpYSlFjQU8yS3Qx?=
 =?utf-8?B?SHdaY3h0OWovbEtYSzVzbERXTEdNbmFadDhyK2tVVTNOSTJxeE1QdHNEZWdv?=
 =?utf-8?B?dEduTDM1Sy8wOTVDNXF0ajNKMW53NDlUVnlOKzNnaGpQQWdsZDlBYWQ0dGNF?=
 =?utf-8?B?cXh3YmRSUS9KRDB1eVJPaDczQzhIWHdVY2tBYWpCY0VEVHRKOExQOEdUaFdK?=
 =?utf-8?B?TXV0bzNpK1U3STR1SFZ3dDRuei96akxtQnM2MmZqeDJ4cTFsU25mOW9kcTJv?=
 =?utf-8?B?aTBsaFRXd1VtcHg5UXBMNUVQRzlESnIwb3pmbko1MXExeC9sTXArMXcwUHgy?=
 =?utf-8?B?NXU0Wnp2K0M5UFlnTDlQbDAyWHJJd21NdUNRUzc3dENLN2RFbEhRMVJsNE93?=
 =?utf-8?B?RVEzRzFZRVR0dXptQ3RiTmUrU2xLTTFoUG5UZzh0TDg2MzBRV1NyQnBFK011?=
 =?utf-8?B?aTdmZU1uQ29SbGpmT1NTVktSYy9FRFVqbUhWMHlxTzFIR1dxQ1M1cmcyRUFa?=
 =?utf-8?Q?swv737TE8GdCyeSqWaCxjXKyQ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa5269a5-9552-44e9-d201-08dd65241c5c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 07:19:52.8573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djFL/SkMFY+fVMRIU90LnLXTX3/SpxVMzySX9iMYp+OgKdj0T5G+iIQ/wC8W3nm8ju/7USegwOIDPr/+0oISrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6145
X-OriginatorOrg: intel.com

On 2025/3/14 22:48, Alex Williamson wrote:
> On Thu, 13 Mar 2025 05:47:48 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
>> This series introduces the PASID attach/detach user APIs (uAPIs) that
>> allow userspace to attach or detach a device's PASID to or from a specified
>> IOAS/hwpt. Currently, only the vfio-pci driver is enabled in this series.
>>
>> Following this update, PASID-capable devices bound to vfio-pci can report
>> PASID capabilities to userspace and virtual machines (VMs), facilitating
>> PASID use cases such as Shared Virtual Addressing (SVA). In discussions
>> about reporting the virtual PASID (vPASID) to VMs [1], it was agreed that
>> the userspace virtual machine monitor (VMM) will synthesize the vPASID
>> capability. The VMM must identify a suitable location to insert the vPASID
>> capability, including handling hidden bits for certain devices. However,
>> this responsibility lies with userspace and is not the focus of this series.
>>
>> This series begins by adding helpers for PASID attachment in the vfio core,
>> then extends the device character device (cdev) attach/detach ioctls to
>> support PASID attach/detach operations. At the conclusion of this series,
>> the IOMMU_GET_HW_INFO ioctl is extended to report PCI PASID capabilities
>> to userspace. Userspace should verify this capability before utilizing any
>> PASID-related uAPIs provided by VFIO, as agreed in [2]. This series depends
>> on the iommufd PASID attach/detach series [3].
>>
>> The complete code is available at [4] and has been tested with a modified
>> QEMU branch [5].
> 
> What's missing for this to go in and which tree will take it?  At a
> glance it seems like 4/ needs a PCI sign-off and 5/ needs an IOMMUFD
> sign-off.  Thanks,

Hi Alex,

yep, I just looped Bjorn in patch 4. While for patch 5, Jason is cced. I
thought this may need to be taken together with the iommufd pasid
series [1] due to dependency. Jason also mentioned this in the before [2].
It might be a shared tree from both of you I guess. :)

[1] 
https://lore.kernel.org/linux-iommu/20250313123532.103522-1-yi.l.liu@intel.com/
[2] https://lore.kernel.org/kvm/20250115005503.GP26854@ziepe.ca/

-- 
Regards,
Yi Liu

