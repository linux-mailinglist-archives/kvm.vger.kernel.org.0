Return-Path: <kvm+bounces-30882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C665C9BE207
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:12:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5653F1F2701D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D99410E5;
	Wed,  6 Nov 2024 09:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lQ4Jimls"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6209E1DB365
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730884227; cv=fail; b=UDy+ZBb7oW/i+ASQ8mWqEJRbZaNjxdb3ujEsrqZJyqnesh3KXqrdG0NEpQGtAi8SGWjHfkSn0yLxoRBO/HE9OfMKqMhtIHpktdvsIdtop3zhCtRfJ85TuALoXK1ELpWrn7n7te/wq5f9wHbjY+Y4n4f6xg7W+sJlOs1kGjdY/lQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730884227; c=relaxed/simple;
	bh=SM775gGXKciDLyhD4Qsl+9w2joNycvBfUk6pHrA8b5U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NF/7m1Ornhn0ittl76k3qY35Q8pHlKdhNHkVQpbV8B2THv4nJSHvGDGQMUsJ92SxQUwHPP32ycV/v2oEMDga2nkEqqDGmzdmTH/oGqG77R2pwDup6nOjOXIbeqqZrmR1l2965Pm+2OnUvpLOe6LYoo21oWMxD5UOpAOxnvKibiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lQ4Jimls; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730884225; x=1762420225;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SM775gGXKciDLyhD4Qsl+9w2joNycvBfUk6pHrA8b5U=;
  b=lQ4JimlsyTHXtETbC4Op3ShP7kdKSOvZRgY0GZpAAgc3MT+q0twY8MV0
   xYtvMTsVP4TDLigXrryQhtLlvf0aGuEY/OsP1TDYDYzGjDcPf2PMn17kc
   zHNm34W3FOMnRXkWHvEbWsDxTwQZwjWAQzwP6byZnxhxtInwOCtjf0HFT
   epXvRK11wsMEj1jZcBQyfx1uh3+siAyYTV5MnYAFqVhYe8Gq7XwHyP8z5
   lbRxYUg7xDZtq6B9OU06MR4T0Lr+QsU7sTCBZBda3ua7DDgmVDulLxa1L
   kavsk6aeH2dbtJqcTW42se0iZ+S11PlLJFpr8Gj4+JjMx/1Q1mf5AdOns
   Q==;
X-CSE-ConnectionGUID: Lcapu9qBRHaWIlUujElDbA==
X-CSE-MsgGUID: lkjkhAnFSjar+CwfWV4/Rg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30556126"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30556126"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 01:10:25 -0800
X-CSE-ConnectionGUID: 2qJab1iiS5mS8lvjX29KLQ==
X-CSE-MsgGUID: T4VvD/FHSDq+8eLBVkyXKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="89564799"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 01:10:21 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 01:10:20 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 01:10:20 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 01:10:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kOLq1CUGbX6qiQoyp1baSHxI1lHEL09ATc3niv248NP9Elm/8PBspmnrryNV6sIY3elR8nJBwdgZjl2AGgQ9Zy/CxEkZIcNUjr9XcQw5aYGOe5hohHkL5fDS6/OWpNwGECYqfCW7Xq/74SwQ0oz1SqiToLqXAMufj5N0h237kJjNPyqpivZGspSaZr522wLEcrgcRUt3KDw6dya9w4f6vdi5oYc89/dkhmKzUQZogKsodThst/Bio7jvG2LD62YXM0uEyXoXy/d6mffYMfkG2DAnCSqRfZDe+d4yfChKjSk8r5LLxO0bjjpteT6vq8eViXOs4I5fTuMLNsECXIlHeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpKJYNlDQHoKz8Uewk6e1cMCOSYYzHFYD92hupkAR1Q=;
 b=M1662GTyeILdrz711T/aQs+/nWxwH7GeMt6FEBNQtbR+t8Rwrpxa1b/NFVV1Ojdxcu3jCblY053XBi8Knh+11kzUBNBhdKrQ/SxXNQLPvrNtKOiPln8QcDITYLNloRTc1GJvgd4jgYfIGkUSU+l3QEnBqJtFFt0xkP+sbRVH0rCC9VLYFRlqdm/zx55iE58peWl7u2KDyA4HNEkwIxaDbt6josiePkU5TLTonq5X9RBY9A/FVpgPXuyKzyfJgiIaticT9pFhYKuNX51hwc8X3U9jS8FoFYShL8izhAq7ky+0mjP0y1FTos7fB7nWLdBeayf2Z5DAZxZkxp3oIDKZ2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB8142.namprd11.prod.outlook.com (2603:10b6:610:18c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.32; Wed, 6 Nov
 2024 09:10:08 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:10:08 +0000
Message-ID: <982f10e2-5fc7-4b13-9877-77042ce20a11@intel.com>
Date: Wed, 6 Nov 2024 17:14:44 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
To: Baolu Lu <baolu.lu@linux.intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-12-yi.l.liu@intel.com>
 <BN9PR11MB5276F52B50577B8963A20BEB8C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <778d4e7b-cb4f-48d6-9b5d-de5e18c1a367@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <778d4e7b-cb4f-48d6-9b5d-de5e18c1a367@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0030.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::15) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH0PR11MB8142:EE_
X-MS-Office365-Filtering-Correlation-Id: b96907cc-0978-4c97-6a24-08dcfe42cf22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dVpnMW92V0hFcWV5MEwwclB5OHJIRlN0QTNUdUtHWVo5N092aDI0UXlNV0JT?=
 =?utf-8?B?NG5RWC90VitNTjRIcnBJZmMveGptWVZSTGpNUVVyODBpMXFuV29NS3huUDVo?=
 =?utf-8?B?RXhuRG5QUnljUmNIdCswNjNTS0VCK3htdGNyZ2dpQmVOMkFENXVmM3NtRG1R?=
 =?utf-8?B?Z3UrUHpBaTF1ODRWWThZeDBHZkFRQ3Q1bFB0cFZyRTgrTFFvZXFTSnpzQkFK?=
 =?utf-8?B?SVQ3VWd1dEdwS2QxUXhITWRtZFhJaUsveTFicFlUdktKWWt1SVJyWFBUSW1u?=
 =?utf-8?B?SGNveGp6ejRqWEdWNDExT2h4b3dzbldtVW9KVFNEYVJpd0lOaU14a0JLMkhW?=
 =?utf-8?B?ZHkyZnRDc0Ntamw4THRwTS9lTDhmK294WnpJdklkaVZOaTkxb1pMSkdtazk1?=
 =?utf-8?B?cEtKOStLNHd5Zm9aRklmMXlBSXpLT0UwOXJMOGxPZlE3cDZSTmJIOHlXaGpn?=
 =?utf-8?B?cG5OSW8vNTBMaS9yQ0RuaG81bjhYWWp5OUllaVh2MVJ0N0tqK0wybi9WUEFD?=
 =?utf-8?B?SnNJMlN4QkNCSTdwU3h4L1dkcVhyUHB4azh5N3RwS2lCMVFoVkRTWmZ0VFdj?=
 =?utf-8?B?MWRIdjJ4TzZSR29IbG1nQndVcTRzUGl1YVpNQVR3ODhMcWZ4NnZDWVEya2dK?=
 =?utf-8?B?WlQ1UlFScUtQd1pQM0JUbFZjNmhobkFNa3dFYzRubm5udExsTGYwWGxBOW5m?=
 =?utf-8?B?K3E1RUIrTXo1T0VIaWhnYjhFQk11amZjaXdIMWRLZ1FpeHVrZlNIVVd3ZUg0?=
 =?utf-8?B?YVRkTWI4cE9VV25CWTJDUkJNYkNuNFlON29BL2pxY09QSFNyblBNdTQwRGJn?=
 =?utf-8?B?RU5NRlFsNjYyc2ozSnJvVkJLK2djcnZVTTNsVWVNcmYzczZ5UklDRm91a3RQ?=
 =?utf-8?B?aEFqZ1k4eU1xYmozTjJxcDREbS9YdlVhYzNjZGhBUFlPMXZFY0kyUDZIdjZt?=
 =?utf-8?B?eG85ZDhxdWVoRXU4Nk9KTHVZa1lsL0MwcUFldXRGWUlLY2llb0t0a25lbE1r?=
 =?utf-8?B?clJxSjZiR1RudDNqalhnVmR0TmxEcFlDbGRSYTRLUkRQVUhwZnRCUkU0dFpP?=
 =?utf-8?B?K3JVc1FhcTNrY29FNXl6ZGFYaEdUZTRjK2w2REFjbU5ydTB4SDA5VkhQeEVj?=
 =?utf-8?B?N1BCWUlreVE3cFhpbDhzWFpCSDh6SGV4YWRlc0lic0p1MFZhYVBlbzhoeG1j?=
 =?utf-8?B?S1QzZ0V0ZmJCVCtuRnlIRUpOTmJFSHZ0TDBBd1VxdmJWeWF5MDM1MDlhU2Ev?=
 =?utf-8?B?L09ldzRSWGNqMmFiYzFOdWk5WEgwQm5LOStOUHlESGZtZmxDdC9vM0hHZHRF?=
 =?utf-8?B?RjFXRW5IMzRCYjJiSVArQ1E0NTZ5RThLbGJmTVFvbTNVdHhmUGhITnhyNjlq?=
 =?utf-8?B?UGNzVlY4d2dmMnNhY0c0SUk1Q1pWSldpUmgxRk90V3lRb2Fkc0IzZzdrNDV5?=
 =?utf-8?B?MmU4cUlCQzZWK0QxRGhWSk5vWDZWcExBaUY0VldIRkdLeURPMjhrL0JQYzl4?=
 =?utf-8?B?T1ozZjcvMk1oL3EzeElsN1V0NzFRUGgxY21DSkRJNzdpL1grUHphV0ZNa282?=
 =?utf-8?B?TDVzdmRjemZ3cDNmcXlERXZNWDVYRlRaNUlPZFNna0F3OCtBdVlCQ1llSGFS?=
 =?utf-8?B?RW1oWldmNVMyQm0zM0lmQUZPTHZJT2FMazJHZzh3aFVOM0lVVnJwZ2o0QWFl?=
 =?utf-8?B?UEM2cmMxNkFNZFd6ZzRiU2MvUDJRQ0RQOW5KV2tTcFVnQTVMdmJaL2F3aTdT?=
 =?utf-8?Q?HURfLCgvLjZYOiFLIA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cENwZ1Jmc0ozb3RGcnU4S2RFem1MakRGQURNOUpXdGVhQzN5ZnlRK2E2Z1Uz?=
 =?utf-8?B?VTU1MHJ1T0xXQm9Cc0FIRG80L3NLWEVBRk5PRjJBanVhUnFsYUVjVFlTN2o5?=
 =?utf-8?B?Q0ZMVHhIWEh2ZDFZYTgxVW9XRk5sdldtNkQ5MEVxMlFVSTc0UHhiU3JDemZY?=
 =?utf-8?B?VkZDK1F2ZXduTnZUbnN0bWZzSGFneFJTeTgrYXUvckZIYlh1U2ZrMktQWDRl?=
 =?utf-8?B?Znp0cEYyWFpHcU1QZEVGakR5S1RocUhlOVVQeWRzalB3SS9IZ3l4OGFjRGF3?=
 =?utf-8?B?TTJmVXB0YU9PRElzbXVZRkQyN2JzaDkwN0pqZWZvenRla0dnV0ZEaTg1bGxq?=
 =?utf-8?B?dWgzWXl4OEhOMWtPVDFzYm1ia1llYkJtT1ZkUm5oZUh3N0dZL0tmMlJqY2RU?=
 =?utf-8?B?NExCMnJBZFVYME8vLzBwNlA0WGhsYjhuVEpYTFVpb3EwODlpRzFCWXB0K2xY?=
 =?utf-8?B?Mi82TUxzTmlLQmI3TG4wU01kTkNFbEROMG9wUU1uL2lOc1lybjA2U3RMRFlM?=
 =?utf-8?B?cHlMOU5OSllKc2k3YjdGaUw1S25rWDFsWjJEMEIyQkJtUDN5d2dEdzAydlZK?=
 =?utf-8?B?MTZ3RlVLekV6UUc0KzltY3Vrc25wdlZrU3lFenNCOHF3REVIOFh4NjRhK2tS?=
 =?utf-8?B?RStURHA2TjhoTmoxcURMYmZVZmRIcnNiVTluaHFHSG1DU3dqNUNGQW9aZ3RQ?=
 =?utf-8?B?ck9SV2hHYW8zNVlOM2N2Q21ZRmhXQ2pKbHk4Vmx6cEhWZGJoQldUMEJhMUph?=
 =?utf-8?B?VjZKNVZ3TVg0bC9aZ2owaFBHV3l2dlE1d1g1T1pxb2tCS0N2N3ViK2xXcEhh?=
 =?utf-8?B?RmpFcEtpZEdxR1R2c2o4SVlQVEJGZDY3bnVrSU1FaFMrT3loYXphaWpqbGg2?=
 =?utf-8?B?KzU3RE5xbUJVbWZ6Vjcvb3JBbVljdzNSRW1ObVMvMjU1Qm5HZmVPZHlrb0l5?=
 =?utf-8?B?RVVJQU5VSlRUQkJqTjVwL093aTBGSS95eHZtbEp1ZzhZbzdpNFArZmNDKzdm?=
 =?utf-8?B?b0pxcGZUUXcwT2FLMkRhMTZCZUxuUzhJN1pOMStGSzh3djA2T0Y4VmZjUVBZ?=
 =?utf-8?B?a2k1dXJhaXZPYWNtS040cFJONlYwSi9XWWs5RFhMSzJZaWpKazJ1UDhnTEFj?=
 =?utf-8?B?YUUrWUtkUmM0SUdKUjc3THoydWwyYXhCc3duenYveVJ0WjZ0TVY4L0RJV0ll?=
 =?utf-8?B?SEwvZU5PcGl5OSthL2plRDRUYVI5bGdOZmMza1ZqZ0xBSFlYWGlSQjJOMDhE?=
 =?utf-8?B?MjcvN05BajMwNUppd2wvLyszS1N2WFhZWEVJc0JteWVsWXFoQnFhS2RFeUlJ?=
 =?utf-8?B?bGVPNHRiQWJMWVRDb3BNUkZmelBWVUVnTUpac3pqem5sb3dmOXdUTkJjQmhM?=
 =?utf-8?B?VlFpNkY0ZzBQK0ZzT3BYV1R2eG9rd3Q0RzBpMjZWVVF3RHZzWUZQRHdBYWE4?=
 =?utf-8?B?Q1dGaHY5YVo1c2l2Wi9adjJpRHZLbGFxTnV0S092dlZPd0RuWi8vcWpoWnM3?=
 =?utf-8?B?Skt4MHR4QnpBcUN4bkJaSklpb3VKdm5lWFpkV2JXU0x6aGtGejAwMzhoMjBi?=
 =?utf-8?B?WDNlQmtkUDFKQWRWUUs0K2Y0YVBmNW9NZ0NqN3lTRWc3WGlSL1ZQVGgwRUth?=
 =?utf-8?B?Q0hQQ3JRQkJsSU1QbVQ0NW5NSUNWbDc5am42Y0hza0xVWXk2KzZxQTdTMVY4?=
 =?utf-8?B?c0x0U25nMmJmUFRxeVVuZDI3Tkp4ZTNSdnlrSGxjSE43ME1OSGF1VzllekJ6?=
 =?utf-8?B?Z3VvQVV2aWRyQ0NIcGV2eGNQV0ZXTTFHMFYrUGMxSFpZNVQ5U2dwdnNnVnhw?=
 =?utf-8?B?WlBmMzU0YmEzSGJNUDZtQXNpTTNiU0N0UjZOalQxNzJKSGtrb2ExRi9vQjRy?=
 =?utf-8?B?WEIvSXVwQ0kyOUVwNGFmYnZ0V1V0T3hYOGdyMlpLUUQ1Z2M0Y0t2SXhGQUVC?=
 =?utf-8?B?Z21pMm1VMk4zUk4vV1VSdVloTDlQU3dNaW0xTzhyZnp1TVJUZUpZbUFOd1hI?=
 =?utf-8?B?bVdZRldEeTBxMnRRbUtJeHE0TS90dS9xWG9ZbUxYQlR0L2c5RHBZU2gvWHJk?=
 =?utf-8?B?eTE0c250QUhrUGwxVS9KRDhiODJqNXhXSTNRR05YbWR5ZWtNTS9PbEpBUkFy?=
 =?utf-8?Q?zPWt7NEh4ihzsCu6/QOFtDPrE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b96907cc-0978-4c97-6a24-08dcfe42cf22
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 09:10:07.9251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vovgc4Mh746YjD+5TVLk6k4ayNzbnGf5AahYJ6BxYwKP23Ggyxf/otvj3HcfHVv2qOCBa3P3vqJWQ5P9sqgZIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8142
X-OriginatorOrg: intel.com

On 2024/11/6 16:41, Baolu Lu wrote:
> On 2024/11/6 16:17, Tian, Kevin wrote:
>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>> Sent: Monday, November 4, 2024 9:19 PM
>>>
>>> +
>>> +    dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
>>> +    if (IS_ERR(dev_pasid))
>>> +        return PTR_ERR(dev_pasid);
>>> +
>>> +    ret = domain_setup_nested(iommu, dmar_domain, dev, pasid, old);
>>> +    if (ret)
>>> +        goto out_remove_dev_pasid;
>>> +
>>> +    domain_remove_dev_pasid(old, dev, pasid);
>>> +
>>
>> forgot one thing. Why not required to create a debugfs entry for
>> nested dev_pasid?
> 
> This debugfs node is only created for paging domain.

I think Kevin got one point. The debugfs is added when paging domain
is attached. How about the paging domains that is only used as nested
parent domain. We seem to lack a debugfs node for such paging domains.

-- 
Regards,
Yi Liu

