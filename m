Return-Path: <kvm+bounces-44960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6F96AA53A1
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6013B7AACE2
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D2D5265614;
	Wed, 30 Apr 2025 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J7H1m2EZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6277B1E2607;
	Wed, 30 Apr 2025 18:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746037589; cv=fail; b=MxJ2ly6/IgAF/rxj+u/VyuNkFZ0UJY+eixdLISictTVeVVAMzzbGHz50R20eOKaT/R9r/Fjlk8Qerhgi1z7Qg/8BVptq515yv/p6CwAYt2E2qANr1UdOv3ORJMOCuicla0jrRTWfjyvm9LQ00S1Vrm+UpB/PDwHSFv1nMXvowOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746037589; c=relaxed/simple;
	bh=NkwYXp080TOcz59aHIaD9NaQbYB2iIiRItwB7TFB7iM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b3kdmj4wk/Pf+oSsvE4GKGgkwPb+vfBLk9feQmANUVEzkzvh+I+hACkqnkwMQ/CP8JxBuSehREXghiMmf7PuvWIrjuwMj7ZmBvDhptfioBrOXg/VMtm7TnYTrfHVlpQwZoWQUNoTZLV/bjvGoUQtBDmolg8JoDQI5PfTxa4GQzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J7H1m2EZ; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746037588; x=1777573588;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NkwYXp080TOcz59aHIaD9NaQbYB2iIiRItwB7TFB7iM=;
  b=J7H1m2EZG5RGApO1mIuOMrND2NaGWskAGpAov8eXB21coQIHudY9TBHP
   ifkOPhaS2XoHqN/uuxUT8yVPvwLOrGQ8ngvZUIoLIMup+xrLF6J2eMRIC
   i+ERjDBWaVP55NexhUxgMfOGhDBILiEl2nXXGRG8FAxfM8U0gqwENyKuD
   s+CM+LRffeqO5+pjvj54ANUqIdA1S92XzO3iSU7k8kcLfZWP3IDZZlYFa
   0Q+vUXl6/Iwr1FURzRjbfNOj2E1QekJo2Z/e049HC0wCCq6q1iXuoIsa3
   RyGGvjOUxcyUxgdR6eFEsUGrlT1g6oNK2J/y/PxMO81r9pqWErsL6pXWW
   A==;
X-CSE-ConnectionGUID: zY6y3pqzRwK12qsPryUbtA==
X-CSE-MsgGUID: EXH4HjV4T8KyaxazG/9B5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="47726769"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="47726769"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 11:26:27 -0700
X-CSE-ConnectionGUID: c0p30fu/SCyD0Keo2mtCmA==
X-CSE-MsgGUID: KxZVkQ06TLqITn0Sdhzrww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="135166587"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 11:26:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Apr 2025 11:26:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 30 Apr 2025 11:26:26 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 30 Apr 2025 11:26:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=panBcWlFuCNLeGm38khFU9n+P1WeEDscTHoHVzLeKM8WopAe7su7+Xag4LAR7K3/2x/RlMMxVQOp8206GW7ryVP65jQXKsmLox9N0J8lcM1Lx0N80VdvC9tti1qbOXBRdnDZW3ysjT4WSCTAkNwatLYHWrZeieYVawj+0DiwfJ+i+qCaYOHQdacB6jTwvSjBCIdnWLybK/UEsHYdJzYmUjXlWExhlP22Jwnyowp7uQjhUn//v+zVefriXKRtZVB/3hoDat1bk0W6/H9TRgL7ILHFkkXCV+7BudRR7JIPGVmTAqD2s5zE6+OeHQByCtC44p2edULZLF4K32FMlr3Xkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYv0iOERTBwCIYvYC/kiVACOfSSqk7Wf8zb9i3XL0oU=;
 b=E+83AEIO53Q5s4uevB9uJ3KBcX9dPceqjySetjZZOe430uuJ6mIgXL9j5f1Lvj8m8Z5o/8xKzPDXDpuefxbfhYuUun6N5u6tNbKkLY29LKMZVRKK0sI1TIBhh3e5mOjHjeyyxy3nc+vZUOBOQQPHCNVsNdxvwkgPGJhSUBC5Bu7Y2Gyh5f3A+aRH3UUEBXMzqRs+IiPLqr2a8q7byUgFFDJEjS8oPIaUQoINYp3pkPTUaqL/CmZeM2boLjXc8p4HuCafmaIYJdN46npd/rOgPiYvhfoCjsmAOw+EXS7Ge2ejoOegWgShcdYCYz0VR7Fh1hZsrbzq427QFdWzPIka2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7917.namprd11.prod.outlook.com (2603:10b6:208:3fe::19)
 by CH3PR11MB7251.namprd11.prod.outlook.com (2603:10b6:610:147::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Wed, 30 Apr
 2025 18:26:16 +0000
Received: from IA1PR11MB7917.namprd11.prod.outlook.com
 ([fe80::c689:71de:da2e:2d3]) by IA1PR11MB7917.namprd11.prod.outlook.com
 ([fe80::c689:71de:da2e:2d3%3]) with mapi id 15.20.8699.021; Wed, 30 Apr 2025
 18:26:16 +0000
Message-ID: <0e3296ce-d569-4cef-88fc-09e45a227298@intel.com>
Date: Wed, 30 Apr 2025 11:26:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features for
 host and guest FPUs
To: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Stanislav
 Spassov" <stanspas@amazon.de>, "levymitchell0@gmail.com"
	<levymitchell0@gmail.com>, "samuel.holland@sifive.com"
	<samuel.holland@sifive.com>, Xin3 Li <xin3.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "vigbalas@amd.com" <vigbalas@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "john.allen@amd.com" <john.allen@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, Weijiang Yang
	<weijiang.yang@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, Chao Gao <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
References: <aAtG13wd35yMNahd@intel.com>
 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
 <aAwdQ759Y6V7SGhv@google.com>
 <6ca20733644279373227f1f9633527c4a96e30ef.camel@intel.com>
 <9925d172-94e1-4e7a-947e-46261ac83864@intel.com>
 <bf9c19457081735f3b9be023fc41152d0be69b27.camel@intel.com>
 <fbaf2f8e-f907-4b92-83b9-192f20e6ba9c@intel.com>
 <f57c6387bf56cba692005d7274d141e1919d22c0.camel@intel.com>
 <281354d3-1f04-483d-a6d0-baf6fdcec376@intel.com>
 <b1f5bcc441b74bef6efe91da1055a3a4efe13613.camel@intel.com>
 <aBJMxGLjXY9Ffv5M@google.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <aBJMxGLjXY9Ffv5M@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ2PR07CA0006.namprd07.prod.outlook.com
 (2603:10b6:a03:505::18) To IA1PR11MB7917.namprd11.prod.outlook.com
 (2603:10b6:208:3fe::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7917:EE_|CH3PR11MB7251:EE_
X-MS-Office365-Filtering-Correlation-Id: dc94c447-bf31-4a2f-8831-08dd88147e70
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ejNncVFNbkl1Zks3MjNWRlBwUFlXM3lZUlBycHBjVDhLbVdManh2c1R6S2M2?=
 =?utf-8?B?SXEyRGlZU0hKOGF3c0dpaXJ5RVpvd2M5ZUtzcHhUbUxrVUhLb3BvRWMzUW8v?=
 =?utf-8?B?L0poN0hJZ0lFVmNwck9sRXdvbjRsQU0vUXp3bUo4dTNQcmRmajlBT1FScHZ1?=
 =?utf-8?B?UmxFSWV5TmVYTlZPM3lSTXl1VGpqNmtXbVh2eWxXcGluQ3V1U1luY0QrOUE2?=
 =?utf-8?B?TTlHV3V2eHF2cVp1NDBWdXllTFBoR05iMzNrZmRpY0pRMHN0bVI3dXZpOXNP?=
 =?utf-8?B?bWsrVDFubEhkUnVwWjViL2lwbThwVXRIVDVKVFRBUlJ6VnFlT1lwUEVPTktB?=
 =?utf-8?B?d0lBd3Y4amNITkl5ekFMRmpsT0dyNkxpOUUrMUwxMk9UU1FWVmxpL21DTktt?=
 =?utf-8?B?dWhySlRxSGdHOWd3TjB3Y0xoYk56N3pBaVVTSUZTdzlyRnRRSTZLQWlSTDBn?=
 =?utf-8?B?V1NueFN3NVZLU1VwZjdVRlY0ZXpYMTNvbUJYaWNOY0EwdC9LUzdxYjA4Wmdm?=
 =?utf-8?B?aEtxV2ozVVZIRkU1dXl4Qlo3U3E5VjFEZ05jdzNTT1hiMkU4VFFoNG9UblFx?=
 =?utf-8?B?aklBT2dncDJRUlRRZEdEMWRpZHVzOWJqY3UyeHYyOUR5Tlh3RG5VYkkzMjdh?=
 =?utf-8?B?TXFUaXlXeDhNZVBMbjhjSWhqbGlaaGNzcm94ZXNSUTZQYjZidFJKVVJqSG1O?=
 =?utf-8?B?QTBBYmhJVEs0VkdjMlZ6bU5tS2RGT1lLVU4ySlYvWTJXQ1MvbGxuSFNqSktV?=
 =?utf-8?B?NW1JWXdDN3Jpc05FR3dpWnc0WlphN0RoNW1HUE5pd0h0T3JyYjJQQU56RkV6?=
 =?utf-8?B?WUhMUklPK0srUHdOMC9tS2RiZjBlWVFlMFlZcTR5dlZhb2lLU1RCSENZYWw5?=
 =?utf-8?B?Nmk1cy94bnZjUlFhVE1KMFE5K0YxUEZVOWcxYUVlQzJBOTlkV3VkODgzNjNh?=
 =?utf-8?B?bXdFeVZITS81L2RaWEE3Z1M0VS9kQjVybEFRK0ZkV0JyWFlFTEtaVE55ODFs?=
 =?utf-8?B?SURzUGNLZGxoVDBjSXA1VE1BRk1hdGs1RmNwZG5FZEJjbEhhNG53dnJGWU5H?=
 =?utf-8?B?WmQybzQ3SVMyenNHc1ozZmNDT3ZUZVc3eUxFVTFaL2MvRUp4Y3BzSXY3ZVNJ?=
 =?utf-8?B?U0Zub3RzTTVVWEFCM1EyY056T1hUNC9UWjNBV1NoZm1xSjJzZllRdHJrSjF5?=
 =?utf-8?B?QmZGKzRzVmU5V3RmdEFVU0NYdFN0NE5adlVrNFJKT2NuYmxHd1J6eWMrQXhB?=
 =?utf-8?B?YVkrN1dRZkxTRXMxcFRYMXRPOWEyVzJ3ZzVFeGJpWnJvMkY3NjRTZEU1TzB5?=
 =?utf-8?B?THlmR21ZNHJhOFE3eUJmZTBUdlZyY1FsWVBZN1hnYlVNQW9XYXowWEF2NERa?=
 =?utf-8?B?OTZPYmlZd0JlUkpaSlRLbGVtdlN6ZGlkQ3Rma1B1T0dWS0k0NmZkZUVMNDdY?=
 =?utf-8?B?MTJWOU8wUWlvcHdMN0hTNDJWd01UNXl6Q1l5a1dWajFsOFQyc2JlYmFpdFdI?=
 =?utf-8?B?MmNmeUNUVzc4ZUgyTUQ0OGVLSEUwMmNNRStHTERMRTJib0tpUVZCMVJmL1JZ?=
 =?utf-8?B?REdWdnV3dzZUa3dsdGlBWDhENzQ1MmFmZzZTdCtmV1hqWlV4SnhDS0U1aDlw?=
 =?utf-8?B?SEpmTXEySGhmQXBUQWpQTkswVkowczMyalNTeCtreFRoZXNGUWhJbGZrdlA0?=
 =?utf-8?B?aDgvM3NtUUVXUUlZU213d1BpQjN1R3hpWTlzbzV3U1JLUnBmSVdRdUdEMW1G?=
 =?utf-8?B?RHFLS3BEcTBOZ0V1YjQzUTBOZTNQZXNIS1M2Nk9XejVYdG4rTllLdlNOMjdp?=
 =?utf-8?B?ODUxTW40MzNkSHlIK0FqZWZWemFkMFVLbWdYeWgvM3Q2Ukh2UEhCREcvQ2hY?=
 =?utf-8?B?Z0tvTG5YUnI2c1BiOGgzMGdDeUtGaUY0TEI4ckE0dUFOTmRTaXdCcVBJM3dM?=
 =?utf-8?Q?YwqK63iYHUk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7917.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHU1cGVDeks1Yld3VkExWC9XYkRueHQ1dmFYcTFqWDM1Y05LOU5NS3lTVTRx?=
 =?utf-8?B?MnBLOUdtYXorM1RxT3V6Tkx4VUdhL2NITU41TWF3R1hmZVNLL1M1eW05WVFk?=
 =?utf-8?B?THppZmgyRk1XZ1FNVUFwcHpWRENSSFdmRXFIM3JsY2lkaVhCSVMwR0tPTDBu?=
 =?utf-8?B?R092dGRDQkVrbTRCWm40UVYxR2lhbnMwQVIwaGlQeWtiQjdYMStTb09oRXA2?=
 =?utf-8?B?YUgwY1ZDNjFhaldWaHEyeFAvQms4cVk3SXJZclhyYUFOTndCQXE3TkthbDdX?=
 =?utf-8?B?dUNVTWZlbEMxQTJXMkxpd20wSHJncnRDaVl1K2E1Z2NuM1Y0bnI3OUJINlVP?=
 =?utf-8?B?STJ0aVl5RllEeWk1VFlBaG9paEdTM3NqMFFUNENpelRMdzl6dk8yRjl5dVpR?=
 =?utf-8?B?MG43WEVSMnZVYkFKZjdVcXVRZzBLSGNOWVdpUDc5K0hDNmtlWDdZQmxzL2lZ?=
 =?utf-8?B?NmIxakxwV2FQWmxiNG1LRGlrRHpmaVNKMThhd29WdzZmQit4VE9aVFFDVElN?=
 =?utf-8?B?dDZ0U2JtMGZLajlEMzRZQ1lFMnNEN01PRzNHL3RQdzB1cjRjTnl1R085aWJt?=
 =?utf-8?B?ckdmaTdZdUlaN0FwLzV6ekl6Wnc4NFA1WnB0bHRGTjcxdFFickZHbTRmMEho?=
 =?utf-8?B?Yll0elczbmZkWWk4TmJQU21KcmQ5b3FZTkJieGJoemxjZHhHclVyT2Y0Y1FI?=
 =?utf-8?B?M05BTXg3QkVVc1AvdkMycEdSeHYvNjZ5RXhSQTlVbUlhRXg5SmpNeXBDaEVi?=
 =?utf-8?B?ZG55OWZ1NHg3NGdVNDRrVXZWd1Q4NkdjelhFR1ZJZ1BTN1Ftc1NFNkNsQnBk?=
 =?utf-8?B?RnpBQWVNVUJQZDZibUdWODRGYmFRWjdFbzZscDVTRldzSjdMRzlWSGptMDA3?=
 =?utf-8?B?SGVpWjJNcGN1dFBHMTM3QnJEVXhMSDB3bXZKNEkyampqNzJQbDZpOWZVODlE?=
 =?utf-8?B?WFRmWDY1YkxzQkI1dkZXREdxaVpBNjhBbWlkeVpPMzhORzBMV3FHamJqL2F2?=
 =?utf-8?B?OU02TkZzSTVXUDFzYkFDOHJaZDZMNG0vWWhGY2I5UmJyZ0ZpMENSV001bnFh?=
 =?utf-8?B?akZyei9ZVDJZQWs1bGhqTzRtYUtDaEpYRkdPWDlKOEMza2xZb0RPQTErbmd6?=
 =?utf-8?B?Y1pSOHc4dFllcFBwbUVWOVVlNGZMc0R1TXVHTmJVZi9HbE50Y0Q2Z08xM3BL?=
 =?utf-8?B?NUVYTmVBUktFSW1wSXZJQ29OcDNVQmFYWnBqTnJ3NnhjVkFrb1M1NkZ1Ri93?=
 =?utf-8?B?QkNTNisybTVhZVkxT3k4aFkxemhWelcwRFg1eUtYWGpMbWFXbm4rT3BneU11?=
 =?utf-8?B?MUlsL0kvN0owN3NSb2xaMHJWNWUvWUEwbGlWYTJUT2hIL0xtQ044TzlheDFC?=
 =?utf-8?B?cFpBeXcvZVFDa1hUelVqVC9EcjVvTnNyOHQ4SFF1Z0JiTFFBTFNORzNzYjRZ?=
 =?utf-8?B?U2ZXV2tSU1dhSzd0cVpZdDhqdDZadzdhR1ZoK0FKaEpVeTB3OTdySDlaTzd2?=
 =?utf-8?B?K1E2ZEI5Q2ZJTlFobloyb1pXbGNBVVNnN2IvS2dpWEp2UnBFK3dMM2VwU0J1?=
 =?utf-8?B?d3dBV1MxQ3FaTVhkdFgwM2VlUDdZOUluTTdZZlNWUlVlQy9KbXhxOWNpMUJB?=
 =?utf-8?B?MWtWVDkxVTJUR0dXK0dUZE44SUlQclN1OWdTMDk1Q3hTWWJKaVo1eHlPRjJN?=
 =?utf-8?B?Skx1V3NqN0RiRFYwZ3pnTkxDUWg4MFFjakIySURDY3VlQTJKWHc3emhsZ0J6?=
 =?utf-8?B?eXg0dkl5WEwvekRvMGFFSDJyNkFsM0FsZ3RFNWF4L0hoRW9zeE5mWXdDZ0Fk?=
 =?utf-8?B?SFk4N1l2ZGFoQzIvdWtXM05CZlF3RDlEcU0ra3E5Rk9iUE1xQkNlV0ovK3F3?=
 =?utf-8?B?WTJhU1hJVlZQN0N0YkR4c0FzeU9RYVJZZ00wUEVneGNOdlpwVUtjYmEwbzdj?=
 =?utf-8?B?ZnprUlh1dmtsZFRmK1ZsVHR2bWI2bndvR1dQWDRFYm9QQlBzOWtZYWdRMm9C?=
 =?utf-8?B?V0lzYWQ0Y1pVYXFXeWVibnZ4aEszUjZ1THVZRHJqS0dYOTlTOGdaQjliWDZZ?=
 =?utf-8?B?MWd5WDFJMVZCZ1pVRGYxZ3dBOS9qcGpPcVBZa203Y2VteXl5ZTFhTkpLK0lk?=
 =?utf-8?B?Q2VOZGN3bEtCeVRoSHFaZ3lSNW1PM3NNMzZTdHRUdHFHWFhldC84R2FpZXVj?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc94c447-bf31-4a2f-8831-08dd88147e70
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7917.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 18:26:16.0369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGNhJ/UZasagM8UIhVfdNc28cnMfxWa3aM3pcNI2gm//nGteYUW7kFv1m8r748lW1xKH5JH62rwbV3IGEusDvxRQw+1ZPH2H+YACsx9d+XM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7251
X-OriginatorOrg: intel.com

On 4/30/2025 9:20 AM, Sean Christopherson wrote:
> On Wed, Apr 30, 2025, Rick P Edgecombe wrote:
>> On Wed, 2025-04-30 at 08:01 -0700, Chang S. Bae wrote:
>>> On 4/28/2025 8:36 PM, Edgecombe, Rick P wrote:
>>>>
>>>> KVM_GET_XSAVE is part of KVM's API. It uses fields configured in struct
>>>> fpu_guest. If fpu_user_cfg.default_features changes value (in the current code)
>>>> it would change KVM's uABI.
>>>
>>> Not quite. The ABI reflects the XSAVE format directly. The XSAVE header
>>> indicates which feature states are present, so while the _contents_ of
>>> the buffer may vary depending on the feature set, the _format_ itself
>>> remains unchanged. That doesn't constitute a uABI change.
>>
>> Heh, ok sure.
> 
> Hmm, it's a valid point that format isn't changing, and that host userspace and
> guests will inevitably have different state in the XSAVE buffer.
> 
> That said, it's still an ABI change in the sense that once support for CET_S is
> added, userspace can rely on KVM_{G,S}ET_XSAVE(2) to save/restore CET_S state,
> and dropping that support would clearly break userspace.

I think my comment was specifically in response to this statement "if 
fpu_user_cfg.default_features changes value," which I took to mean 
changes limited to user features.

Diverging guest user features wasn’t something I intended here -- 
although I briefly considered MPX but dropped it due to complexity:

https://lore.kernel.org/lkml/2ac2d1e7-d04b-443a-8fff-7aa3f436dcce@intel.com/

At this point, I think the reaction here speaks for itself. If adding 
those two fields leads to confusion or demands fatty code comment, the 
net benefit goes negative.

So yes, overall, let's just reference fpu_guest_cfg directly as-is.

Thanks,
Chang

