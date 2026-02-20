Return-Path: <kvm+bounces-71418-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AFlZB8OqmGn5KgMAu9opvQ
	(envelope-from <kvm+bounces-71418-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 19:41:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E2116A24F
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 19:41:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 52C4E3083848
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED99536680C;
	Fri, 20 Feb 2026 18:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B9+bXJXx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99FA2EDD7D;
	Fri, 20 Feb 2026 18:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771612802; cv=fail; b=eQfkQNKKCG201fTPwa7xOvdN5Krf1pKJzhjOaD5rvkt/5sH4HkXBP+acLKw9ho4h/ZDyTRMDxvmMRPTH1XZcj6NOtJZYzYdk+b7oAyMb2e1seI9nSf0/0yUYVQk7AGjqZ3zWP/05sARW2naLZehXNgR5s2kU/WEKKtqdzHKauDk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771612802; c=relaxed/simple;
	bh=odxc3R43PDe4NWVqxTVuR6dCd4YJ1o47BlYmVaB960I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jUat1OgLk8dWrBrY9LJLC6eC/igw7YGtn8c5hDhv7aV98N4KI4350wDcvvWXyy0F0KDfkq+PjEAX/dFTZJDAakUAC+gW/mCCnQSrVA6nSBgkenwT2qUbsZ4fWD+45AS7vk5SqVYgUeOPovM+C4ev6kBn36A1GiALA7BfKVMSd+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B9+bXJXx; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771612801; x=1803148801;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=odxc3R43PDe4NWVqxTVuR6dCd4YJ1o47BlYmVaB960I=;
  b=B9+bXJXxqjyP/7wivIoRCIrw0H6LrnkLtajniMp2irmM8Qo2LnEQjasy
   muaRq1/BjV4Hz6jKZVVmNux6H85rxpE7nMCE2vC45I62rJ97Fqvywovqa
   yga4LKNodwWRT9rOcGeeO+Nu/sKm2gTYC+hkU36zBH5uSmOII18lk0YWl
   kwqxx4Or7qFo6B1OhT2Bz3limK4wkcwFJKJxfWASanguVgxlH/eLjPJkG
   4/v4MkG3vVwnb6SRS/isDJxBfeDHIa3LXtB4yn56UQF0NXP+c/8m34d55
   Lw/ryCpOEs0YyvEbsweSJeDgbCWFGO51ZfXD/Z2xh8g+hDt3x/JNbzNyn
   w==;
X-CSE-ConnectionGUID: jt3IBBlfSJ6xYWIR7e91wg==
X-CSE-MsgGUID: va6WiTzISzyKSk6ZWuJuYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11707"; a="76323445"
X-IronPort-AV: E=Sophos;i="6.21,302,1763452800"; 
   d="scan'208";a="76323445"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 10:40:00 -0800
X-CSE-ConnectionGUID: SKoa65PKQzuDDRk1c6u/6w==
X-CSE-MsgGUID: AUs0bPeWRqOm20R0gi0Ljg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,302,1763452800"; 
   d="scan'208";a="243348650"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 10:40:00 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 20 Feb 2026 10:39:59 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 20 Feb 2026 10:39:59 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 20 Feb 2026 10:39:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j3QMk8W3UTmP8jgl+BlgnqlqOUA7hdwo0lYVgnjYxXMKOn3tvSyB/C/qVuk7lB/YfveyqHjlZyFpAFoMftQrP739t1lXCnq/kmTev4KFLz/MF2a0tyxRGDjrwxW6nQDr2PnDp54fVb16WebnFtfqSQKIs7MtMpaWpjQ+TEv9nGD4L8VJI2pJnsulT8PqvP38B+hrtv7Co+jHKhdeJtuHNr4JSAeQnlum3ApmRYXGdKPHL+hqAeqU00sasosxFO8OGtmpzLNKr9DEk90kFuqwnlCVBzSHIymzWsn1nhmga/XxdPgYvieNtDT8TXWX7FZYx8fmP2dOhyth6Mmqljx+PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LRgORf0t2DSA64tz0J4oxUq+dxf4K0tFdhvpdJvumO8=;
 b=gIQOxBHpwiPo8jw8r9ddA/kAfgD+yDAWPZ/JPkJuOgFHcBhfI6gMCuJNhrOZJSdzzpTx0+yNq8Y05ANyFDs2/I/scU+8s4fzm3/XZradMdemdsNpleN6suk0os0Ge+z8rJ5wRJB/UxKYKWIyfyRWiv4+FYVM+qapMGbydjXqHnwZAoxRrG2tbI3TfuBhHGr4YLqUOYpE/qNeWRVHOCeOWMDDWFoLZjvxWvB7WKlK4+qKuS+Ro/fwbdFexUPKYO3dS1XmFxv34icP8FyUsc/qYsIPIYbugAFMkhqBzBnw9h1J/nkQ7uWF9aHSx9UR6YQmHDrk6V/v6LjkxUzQgcZkEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Fri, 20 Feb
 2026 18:39:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 18:39:56 +0000
Message-ID: <68b6693c-a665-4c1a-ba5f-b6430a090e0c@intel.com>
Date: Fri, 20 Feb 2026 10:39:50 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Ben Horgan <ben.horgan@arm.com>, Babu Moger <babu.moger@amd.com>, "Moger,
 Babu" <bmoger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
 <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
 <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
 <5857f3a0-999a-46ed-a36f-d2b02d04274a@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <5857f3a0-999a-46ed-a36f-d2b02d04274a@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0326.namprd03.prod.outlook.com
 (2603:10b6:303:dd::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF2F7FC4EE6:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cd693ab-64c1-4262-0a3d-08de70af71b5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cHM5NkUvOFQ0UGZhTmZZUG5scXpIMFdCUndpZ2hEOEF6T3M0ZHV6SDNqQkhB?=
 =?utf-8?B?ZTZqVnZVSGpSaUE2UWdJUElCZTdtTGZLZmZydzh6K0UzdTJmUklpdmlVUzZU?=
 =?utf-8?B?STNDSWlPYUJudUwrNkQ4Nkllbk1STzFPcEdqOTNGS29yWUJYMHBqZVpaOTVs?=
 =?utf-8?B?R0pZb1RFcDd1VFMvSWNUamtxU3dRU28yUWNiYUJRMDFrVFdNQ0hvNCttbWs4?=
 =?utf-8?B?QjFxUGUrOVdTc2tDNEZsYldHbFppWkhCQmNCbXhEZk5CK01XVjA1MXZIMTlQ?=
 =?utf-8?B?bjRmZm91TkRreWhQZjhmRlFEbGVOaTk1R1EvNkdqZU9GbzFjZ21udXJuQXlw?=
 =?utf-8?B?OUJONjdXUm9jWU9FeUI4clEvUDhsbGJWU1Z6VUZQNTlwYWJQR2RuUkg0MGMv?=
 =?utf-8?B?SnYxNGRLdStqWUlPY2U0c0FGVk9tMi9ydGZBVU9NWnhCMThUL0pqVkRkK0ZU?=
 =?utf-8?B?TktjUDJoczB4NWtVdWpwY01WdTladWRSR2ZINXJEaFBxS2dieFRSS2U4OHF5?=
 =?utf-8?B?ZDI0TW5TYUxqK0xONTFwempnRERpa0sxWTZtUHN6VkwxSVNKSjJrWjdEZ3ds?=
 =?utf-8?B?cVhOT0Y0VGI4ai9uYUZJUmR2Qzg3YnJISGNpYnQ5SWlwdE9IVzhWeUdHb2lQ?=
 =?utf-8?B?azRxcDRaOVRzLzNvR05WeXljWDBBNWpLc0JzMGFIWTBkQ0Z4ZjYySE85M1l4?=
 =?utf-8?B?alRmSE9GWnIwYS9sUmVUVE5FMUlkcHNEclBOcFUzbk0yNjZKZTRLdXZZOUpV?=
 =?utf-8?B?bGVwZW9QeGRpaHhIdVliU1Zpam5WRmZSRGdMUE5OcHk2R29TeXg5SzZ4TktF?=
 =?utf-8?B?MlRqY09IQkE3bnJnbnlXcEtMVy8waVJScjZPOHRvRnVoTGx3NHJoMVBVQW8w?=
 =?utf-8?B?WC9ZRHVyNU0rdmRhWUUrY2lZS2J5N245MGlmN3hXUmRXMmp5cHo0U0cxU2JR?=
 =?utf-8?B?MGNkZjBpWk5SWDRvNFloR3lEY1JpT0xVV0ZZaXFHc05leVpRMm0rK1BBY0NV?=
 =?utf-8?B?c2FnZHAwSzNXUUl5dFBRbngvUlAvdlhDMjlTVThWZ3dINTU5SGluMElsdU9p?=
 =?utf-8?B?MFJuYXBTS3k5SXpkbW0xUVZIWGJlOHJMZ0lwNVgyLzRveHhNT1NoYWU3VTJL?=
 =?utf-8?B?a0M5Mkw4ZTd6dXArcm9xTnFidHBrVThOOWM1ZjZrSU9INlNVR3dzNWlSN2p5?=
 =?utf-8?B?VXk3NzVXVHdaWGFzVHN3b2MxcHdtWE0raU91VTA0NWFjWXR0Ky9IVEVuMGYx?=
 =?utf-8?B?dUhUVzgvOEhROU1zajdjclorNkthdG1FQzRCaWZ4SnlHOFlCR25ucUJualRK?=
 =?utf-8?B?OUhobG9SZzhHU1VVS3BhY29qMnpiMXZrcDdVekkwRlZvbGp5VWlXMmp5Nmxq?=
 =?utf-8?B?Q1BiWmpHOGxqeTFiZTVkYyt0YUlaOFNNdWZuQng1aHlIS1hMOUVlMVk2RzJU?=
 =?utf-8?B?cGg1T1g2TUJITGFRdlFmNDYrMEZhRjltTnFWTGVxVGJHZWl4WmttQXdhbzdN?=
 =?utf-8?B?VHFBRGVlOWQrdnBjSW5ZdURXdHNVZDVBT0ZzK3ZTdlBKUmhmUjRla0s4eUlW?=
 =?utf-8?B?STZsUVJLWVlFWTRTcUltQjFZWEVwc3JQdmYxcTY2Um1MY2FDUEtRS2lNNmdv?=
 =?utf-8?B?U1kyT2NPNFV6dDQ3ck0vNzRYQ2p3MXQ0WXlwSmVENlY4UW9MUlZvWlQwdlhJ?=
 =?utf-8?B?b002MzRJL01wcC9hVnhhY2RDUjFSc2g5ZjNmbnZRbXc0TmZzK0tVTGxHS1J0?=
 =?utf-8?B?L3E0c2FLemVobjYyVFlYZC8zM0xseEhiTm5xWllzbG5kL1o1aW5Uclhralh3?=
 =?utf-8?B?cEhjZ0xUVlIycG9xQzNkd2pnTnR5MDdTWVhvYWRrVmlmWVVHdW41Z2NMa3Vz?=
 =?utf-8?B?bEF6d3NlL3luZG5XbTNGRmxIdFN0cnRRQUVlTDlWblBsbkErVlZwcG1GTGpV?=
 =?utf-8?B?Wnh1M3pkS0ZETC8zRjhhK1pqZE9JL1RGa1MwZFBqdmZRNVNNemVtQmxJbFBM?=
 =?utf-8?B?aCtSNHhPbVo0SlVncEJkc1lCVm1VaEwvdXYrUkJhWldLcForNUk1U1Nnbml5?=
 =?utf-8?B?NDB5UlhTaXpnUGpSVVorRDRWUWIrWmI5U0xlN09Ud0o5TVdwZml4Q0hYVE1D?=
 =?utf-8?B?bHkxcUtWdkZobnMxWHFtRGMxQldvY0FoSmx5QTVFQWRIOEg0QjdoVkhSMndS?=
 =?utf-8?Q?swLrSm3dtsfd3al7X2AIOdk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHoybTZ3MksyQmJWUC9ObnhjdUN3UUhEVkZUR05wM2NJOThlTW1rc09uaTB0?=
 =?utf-8?B?dFZCVW1GRXNnRnA5dUpXTEsvVW00WC9HMk5UTVI4SVJTcmRKQVBmUFpNbm1E?=
 =?utf-8?B?RWtIaGo3WUpoYitHTjBQOUhFNmQzRTN4U3RTMzN4SVc5SWZnQjB0ZnhhN3Zi?=
 =?utf-8?B?RWdGbkE2YkxYdVo3b0JsdG1pbDlHc0JKK2pvNjl2WjQ4eklMNWEweG5oUStI?=
 =?utf-8?B?OWhHSEhQMXZhUGRQeWNleTY4SjR6L1VpODY2YjBxZWF3SC9FMzV4ZWQwTlp2?=
 =?utf-8?B?T1JKcjdpVkVyLzJMRFdUWXptczI4QTU2MHcvdkpnVlJLZXpHdUs3VVBMRDRz?=
 =?utf-8?B?Rm9BOFhHNnBUZWNhMyt1b01nMm01bXIvSnNRZ21JVkFmZktURDBoTXcybXBC?=
 =?utf-8?B?V2xhSytRRTk1MkNGaWFSYmZzNWhDWHhUOXlqRS9pZVZaZHJiSks5bnI0cmhK?=
 =?utf-8?B?M1hlVUk2NVlETGt6QlJRWVRRS3VYa1lXMzNGZkRvdTZvRUh4VDNOTTRsdmVY?=
 =?utf-8?B?eFpUekxHN3hldThrSnhNNU9VaUVNSEV0Q1NwbWkzVEdSVE9ZODJocXorYURU?=
 =?utf-8?B?RnRwRzl1Q1VnZ1JIME40aGR5QzVmU25uTWhNY1RQTkFnb055Um1WZ3dISEo5?=
 =?utf-8?B?YzlXN1R5U09zQTdpWlV5VUw0WTZwR0tnNGp1UGpUZ1c5elJLbnF3SXJlMStn?=
 =?utf-8?B?aVBZOVhtb3c4TXVtbVQ1UnNBcGp2S3NoYmpyMy8rcWZwQTBFaEQ1VkJaYU1Y?=
 =?utf-8?B?WW90QkNyTS9TTEUrUzFwZ0tXeURyZk1Yd2hrS0JaT0lodVJYVGJHdE90b3pn?=
 =?utf-8?B?TXNaS0wwbjZaNk92clFWbjljRkpBTTM0b25HcW44M3pidWFQSzNHMzVDVkVM?=
 =?utf-8?B?dEJzZUc3SXh1RWNJY2k3RGNrZ1FrWDBJNXVtbkRJWTI4YjhqV2ROVnpHMzhR?=
 =?utf-8?B?cW1oRHZ5QUc2bWR4R1JmSkdYK1hsdXcvWDRTaEhndmI3cWdnRmdGODUxOTJH?=
 =?utf-8?B?OVNwcDRGVVI4cmlwUllpejhNaWo1NTgxcDZHcGlxN1c3dFZocDF0L3FhUlAr?=
 =?utf-8?B?c3pFb01KTGZ3aXVBNyt2UHVKU0s0dXRMT1p5ejFBZ2VFWXhhclVNSUJWVWNT?=
 =?utf-8?B?VXVLNDRYSDBhdXkweGNNV3FKWERmZ1dHR2NJZUFKcSt5bkpjTy9qZ2VIQVlk?=
 =?utf-8?B?QjFQaGdhNE5SV3ZVRDlZS3ZBMjdKSWMvSmlpNTE0OGRNanl1WXhsemZtQ254?=
 =?utf-8?B?SnlMV3ZNY1F5VzdCc3NWMGR1RVRjUEZTSVMyWk9yL1VlYWVqZTltYnY3bVdZ?=
 =?utf-8?B?RVFYclJ6c0gvc3c1elNSaEtKOTJqNDdZODdPbnVXa3FOcUcyT25MT2hpUjA0?=
 =?utf-8?B?Wi9INmFndlFiaWRIWDFEZ2ZRUzk5TlZHd2VPb0phTGtINXVtNWJNNGQ1REF4?=
 =?utf-8?B?Wm9peTFmUGtTL24vQktPZ25QcURld2NJVDV6aitTY3FWVWgwd3pHSmF5WmJk?=
 =?utf-8?B?ckl0OFpSaXlORk1QQUs0bHU5YjhHTHAvY01sY3NzRWZYNFRYbmJFMmw3aisw?=
 =?utf-8?B?RmxjNzlIMFBObyttajQ5Q0RmeU9MQVFXUXlFamdwc0tSTG5MOWt4dEVKemxB?=
 =?utf-8?B?Uk5jRERiUEdobTRNbFVORjJpV0hsUERMdFcxa05OT3AxMTROalhSbml5NVFk?=
 =?utf-8?B?U0d4Ty9DSVBUVVNkNUlqWlJGT3RQWDd3R3pzRUhqWGN0MUlNd3QrcEN4c29B?=
 =?utf-8?B?SkVrSFZlK0lra1JFSXZkQ0dmdTJUQ2FzZDZBbm1Na1RmbGlEZkMzREVzZXFo?=
 =?utf-8?B?Q0RDTkJvd2YvMFhSSjNWUk5ncXkraWZ6WTZIcWVJKzhFbmhmbWtacU1uMmRE?=
 =?utf-8?B?QlhFU3RSbWdQc2ZZbnlsTUt3M2lNY3Nya0FvRzhMWS9JdUxIMkhyZW9rRVFV?=
 =?utf-8?B?ZGRIblpob1Jmc0t6SGpPVTJwbUZhR1FrUHR1L0ZSVUhLQXQyR1l2em9hUWlL?=
 =?utf-8?B?d20zM25kdTRNNGdzWWhKWVFQcUNpamgvWHhmSTNEOUwvL3pGblhOMUdzSi9D?=
 =?utf-8?B?TWtoSTRPd1VxTkdzWStOa2doSnpWNUlmQUxEVXJkWmV3bEVHdVROVWVrTDQ0?=
 =?utf-8?B?b2M2eHhaN1dLVnRUSGREVzRiWENvT1k1eGpIWndHMnhmTmxKb0U3UVhjM085?=
 =?utf-8?B?ckdMbG52VCtIVWpreGRSbWlOVmpray9uc25WTzdSRGZROUJrNEpndGxCNHRv?=
 =?utf-8?B?YXBjZlVoY2tPMFdadWxEbXpyM1A1aXp2NGhuUU9kU0hjeWMwK2RSc0Vsd05F?=
 =?utf-8?B?WTlWR3diVi9kYXJFaFZrZGc0NUhEeE9CZVBaY1B4amMzbHRldm9mb0EydmJN?=
 =?utf-8?Q?oUIaaoGnO4W7pniU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd693ab-64c1-4262-0a3d-08de70af71b5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 18:39:56.5020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x716hQd3N6MUACYfFmEi3dIr5gZlKfzHvGefIsDnTvABI0zhKCXdKH5kUK/h+6d4JFaNz9hOkfefAbQVomlOvAD8hNPuCA/ygCkXCoqit+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2F7FC4EE6
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71418-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 75E2116A24F
X-Rspamd-Action: no action

Hi Ben,

On 2/20/26 2:07 AM, Ben Horgan wrote:
> 
> I haven't fully understood what GLBE is but in MPAM we have an optional
> feature in MSC (MPAM devices) called partid narrowing. For some MSC
> there are limited controls and the incoming partid is mapped to an
> effective partid using a mapping. This mapping is software controllable.
> Dave (with Shaopeng and Zeng) has a proposal to use this to use partid
> bits as pmg bits, [1]. This usage would have to be opt-in as it changes
> the number of closid/rmid that MPAM presents to resctrl. If however, the
> user doesn't use that scheme then the controls could be presented as
> controls for groups of closid in resctrl. Is this similar/usable with
> the same interface as GLBE or have I misunderstood?
> 
> [1]
> https://lore.kernel.org/linux-arm-kernel/20241212154000.330467-1-Dave.Martin@arm.com/

On a high level these look like different capabilities to me but I look forward to
hear from others to understand where I may be wrong.

As I understand the feature you refer to is a way in which MPAM can increase the
number of hardware monitoring IDs available(*). It does so by using the PARTID
narrowing feature while taking advantage of the fact that PARTID for filtering
resource monitors is always a "request PARTID". In itself I understand the PARTID
narrowing feature to manage how resource allocation of a *single* "MPAM component"
is managed.

On the other hand I see GLBE as a feature that essentially allows the scope of
allocation to span multiple domains/components.

As I see it, applying GLBE to MPAM would need the capability to, for example,
set a memory bandwidth MAX that is shared across multiple MPAM components.

Reinette

* as a sidenote it is not clear to me why this would require an opt-in since
  there only seems benefits to this.

