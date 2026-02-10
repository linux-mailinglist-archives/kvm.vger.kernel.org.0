Return-Path: <kvm+bounces-70679-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CKgCII97imnJKwAAu9opvQ
	(envelope-from <kvm+bounces-70679-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:27:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 259B71159AE
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 682D0300CA07
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19CF523507B;
	Tue, 10 Feb 2026 00:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hQ7Nn6AU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FFB226CF6;
	Tue, 10 Feb 2026 00:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683276; cv=fail; b=PPh2WDZcQtxO0EsXTC6Jjb1I00PafjVZbvxQ4TPO6cza2u2xHHeaxF7FBOFtGMoLgT9By4HArkNm+JGBn6iVPITMMU+cW0UJ2gBsu9wIyY3KB2oDS2wL/FnxX/hxEg2va5RZJzs1LFNHTf7URboE6gILytaWBGO1fuhKp3uNNe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683276; c=relaxed/simple;
	bh=KiZazhK+wT+xIIWeAXsw/31EF1DIemRqEehVTLmN68k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rxSPQpQ6UNqECsqj7lKUPIqCYao/HWAdFMgIjiw6ohDwXyyKAKhdZgpi0fVKyJXYL64yIJ+Syc+lQtmIGV8EbLqfHZbw2JT/vicZ6jLIh0dz16B3SzQydZ+jW7e5dzMXfDjbTxQPnSbUToJGZvh6k1sozq48xAadrQuuA1S6o2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hQ7Nn6AU; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770683276; x=1802219276;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KiZazhK+wT+xIIWeAXsw/31EF1DIemRqEehVTLmN68k=;
  b=hQ7Nn6AUsjXi3uqUIyBHDExp7dZS2HCy1CtBacLxA3Eh40PGZiWyG9n3
   5e/i+8vf8LibepTIOmIe9gPWpT/pHSGRPM51XmgDx5wIwqqaCrxL7Qg8L
   rI6r7TCsSrR3+vlQY5v+WcgCOES7poqS7d1vz6uxZsM11P3mno/GLkiK4
   fhMedXnSYNtxaRS5S+3/F9HBnvhyxM4yrVXhpvDtWIlltuTv1obBRx+lB
   lb/p9KR4//U/OBrk9YjP1clVSiSWEmCSw3lDwDFyWm8737w9KdNAwkllK
   ZGQ8VHMz5lvyoy2TRdstyVpsdTwa213JaJGlxYFXikM0W7mNPfwIFOsHK
   w==;
X-CSE-ConnectionGUID: 6NvQKOEYTxKK1uCei0mGvQ==
X-CSE-MsgGUID: 9HDrZWCfSWyRSwhJ2y/pEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="82126190"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="82126190"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 16:27:55 -0800
X-CSE-ConnectionGUID: o3eRb3cmTdi5JIZKKzDRsg==
X-CSE-MsgGUID: jI4ZO2POQ4yiTaqtN+q0BQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="210866940"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 16:27:54 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 16:27:54 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 16:27:54 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.32) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 16:27:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sDaLpiuTv1+264x2nSiRtbajndEZcA5WATphY7hgkP+bLR08BG6hXg7+244PvfYv6VqpNF6bsLPaeA46Kin/puw//wCUfbwZBUSdqN2Hdtmdu7PmDwFCO3oPl1JaRm8fuvF1JW4LJHquKN8GC2wZi/NjlEAJzZ4gkBZ+asgqD+ytXoZ+RzYn3WIAswpIorts38wyu9Q0Z/6RUhXbmii6SQfMKKNpVSXVnQm7Dx4uonTm27eWZ9iIATi9qA4rX9pW6dCqTqCYTIsc1jl6WyTY/asZieLIgT/OKcsfFrbu2UbxUT8o3RahYlbnpfNf+jKcqNXfI8X6aCAQY/7ZbS25BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ezkZ06v5C5aaEhThMotzMIRziiVDtyp+ZUOsQq3MWo=;
 b=BYjdGzTBL7Lz8QJBwnPFxzj4TY7oXm/U47qlZ/5cegdIuxI47i8+IqashnsUF9WjoyGYCxKKO0xB5G1aU9Vh4hySBWSffTNaiGJVYcobOrFgnGZOsetoPenA0G7CZjF1h+WfNWVxXGT0erRr7CFBBNrGGONWjdoVjhjh66uqWrj/OhHbwc1Z/nPa83QnwzafulOqt70hnxmWrP1pRyofP9vZfMK9Oc1X15Smj92L7YSj/gS7cpVpBSYJfpbla/fO4kXGjgOlJRHH/1stfHhZVHRMfx/0mKp1M6fM90RTDeZ/IusklwicBTkrKzy7xgV0XFiLxXx/WdhEQsnEY7SiFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF00BBED10C.namprd11.prod.outlook.com (2603:10b6:f:fc02::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Tue, 10 Feb
 2026 00:27:51 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 00:27:51 +0000
Message-ID: <d2ccabb1-e1de-4767-a7b0-9d72982e52af@intel.com>
Date: Mon, 9 Feb 2026 16:27:47 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/19] x86,fs/resctrl: Support for Global Bandwidth
 Enforcement and Priviledge Level Zero Association
To: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <fustini@kernel.org>, James Morse <james.morse@arm.com>, Dave Martin
	<Dave.Martin@arm.com>, Ben Horgan <ben.horgan@arm.com>
CC: <corbet@lwn.net>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <akpm@linux-foundation.org>,
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
 <aYJTfc5g_qgn--eK@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aYJTfc5g_qgn--eK@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0373.namprd04.prod.outlook.com
 (2603:10b6:303:81::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF00BBED10C:EE_
X-MS-Office365-Filtering-Correlation-Id: da2201c9-d24d-469e-f0ec-08de683b39a1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Qnl3OGhZeWlmQ1JQTVBuMVZUMXB0anFyY2Q3Q0NyYVVuaXdIRFEzVHducThK?=
 =?utf-8?B?aklmYjRuWnpscURiR0ltbytCQjVndTdNblBqQVFTUUszZDZWS0g2eHNiOFlL?=
 =?utf-8?B?S01LYTExVm51SkhkdHlPZDhEM1pDOWp4U2cxT0FSUjd1YnhsczgwOUx2WFQ3?=
 =?utf-8?B?RmVQNkQ1Rnp6eStJOHFLMS9LMkI0QW42QTZ0U0dMYXhxb3VxV2c5ck0yQlRw?=
 =?utf-8?B?TzNIUHRRWDZrbHcyVDl4cnhSeDN1dmVHRTFuTTJNRS9yWmllUFdCdE4vT2ph?=
 =?utf-8?B?Q1lJeHJ1WWRuV3VjbVRiY2dHVjVFdHVobE52aGJZYjQ3bEZFTm5QSEpja05q?=
 =?utf-8?B?TEp6SU1JMzdYQWRZOElFZ3RZaWliNVZIMVBGY1pnV1pXbUZveFIxaHl0YUdD?=
 =?utf-8?B?NnFralNzZ1c5SkIvekY3N3kzckhNY280U2RNSEZCZjJnR0pGZjFsQTFGL2RB?=
 =?utf-8?B?WS9RT3JtVWVLTUcwZmdSTGsrbW1wZnZmeWFhMHJzakpqU2FXU1d4Q2FRWTBH?=
 =?utf-8?B?aFdsd3drVzJNbG1TbXlKVWh5eGpoc0xUYXF5OWJaRnlpUWhDY09SbldyOGRu?=
 =?utf-8?B?dzhWejY5YkpjTVNudE1mWnByZ0dsQnVzN1lWMGVJMEt4ZWtwcVhsYmVvdXIv?=
 =?utf-8?B?S3VYeXFkalU1YmhIVTN2UDBzL3R2WW9XWjBkN1FuRkEwbVBJTnJnb1R4TWlN?=
 =?utf-8?B?YzRlcFN3eVZMYzN2T3dUK1N5cXVSSE1UWDFCcUJseU5CNzBJMUxmMHVSMXo0?=
 =?utf-8?B?TzYwSklVZ0NYS3FHNTVRZ2lyR3E4SjlydmE5YWxoSWpjelpUK2d4dSt4ek1G?=
 =?utf-8?B?c2plU0VacitiWmJSemYxNXhmcG4wRGxqZzNNVGZHWmJzak5HWUY2eWtud0dT?=
 =?utf-8?B?Sk03QUZiWEM0a0NVK0tUeHJweUZtdkw4dks0UDluNHpaV0wzeDVoZDFYMG1U?=
 =?utf-8?B?ZkROWmNTaVhxc1JiMEt3ZHhhU3R5azdNQmh5M3NnMThPdVdKMmRNWUwvTTZM?=
 =?utf-8?B?STFxYjRlMUJyVUJ0a2cwZEk1RloxVWxDYzlWbG5sRmlvZVlqT2hvWll4eEZK?=
 =?utf-8?B?VkhmN2hlamVsMEFPME10cjNFeDdkMWJoLy9pT1YxQkpMbW44L3lYczMvMUE1?=
 =?utf-8?B?V29EZTErOWNjYnFrNEhxZFgzNnptZEJoYWpmb21heVYxVzArNHlHTmFLQ0o1?=
 =?utf-8?B?N2QxWGQ2eGl2bGZVRHpNMGJiVFRLNS96aEZDZUtpV2gyLzN4M2xMUW16ejJq?=
 =?utf-8?B?UmVzeHhoV1h4VDQ3SXpZTWNhSzlvc1gvbnBDVFc2b1NldUt5a3RIK0w0Yi9u?=
 =?utf-8?B?V01RMFFEd3phdEgxR05RQ0VCeXVHeEQvNTVCa2s5MkZKRGVXVnpuMVFYMHMx?=
 =?utf-8?B?bFJIZS9GNG4zMkJ6RmZEWFcwNlo3NFRUTW84ZlBhY2tWaVg2dlhmT1kxQUo1?=
 =?utf-8?B?aFVCbHR0MkZkTTBWZnFNUUxacUtwcm1hS3NRb01yMjFEayt0Q0lRaUpSNERN?=
 =?utf-8?B?elJiZWg5eG51aGNtZmE0MnEzTG9uZlhBV1hxTVBBN3A2ejJhWWc4aDB3Y2hJ?=
 =?utf-8?B?NFRNdGtwNEtOak1DNUV5bTJkSS80aURXa0RHQkt1SklQdjArQ2hQUGNCUnFp?=
 =?utf-8?B?bGcrTG1xMHBXTStjKzhVMUZ6QUVqZURJZ3kyS1BSWG9yM0IwZFNNT2ZIR0Mv?=
 =?utf-8?B?QjI5WVJON0pUTCtqaXQraDBqaG9XcE9kNzJqQklFb2JpTFFURWFIZlhVMDFH?=
 =?utf-8?B?SytRUXlMRTVmRncxZjkvUFZCMWIwVGViZm53bGl1TmJURnJPWmlKN3RHOHRE?=
 =?utf-8?B?bUIvRjFQZzN2S21UNEZWVHVzWGZKZG5WZnJHQkdWUXBOUW5xU3JKSDduTFlL?=
 =?utf-8?B?Vnd2REVMWFk4QUVaWHhXUmJ0YWtOZVBXdDM5VitjdXlLcXdSZzRuOEQyUkhO?=
 =?utf-8?B?bXZ0RGFMVzFDc2t4VVZTOTdHWnFTL2hlQkExa3U0MWt3dlB5NjB0UXd0MWF1?=
 =?utf-8?B?bDlwajRSMnErdzVGY01nRFliSVplU1BPWUNiV3VLVE4wazZsa1BBWFl0MVd6?=
 =?utf-8?B?R1dwY0ROajdTWWFlSlQxYkc3TkY3dHRud1ZqVnV5bWtLS1UvMVArLzhwQUNo?=
 =?utf-8?Q?uBCI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Nmk4UTFIZHdDeTI3enhQVENyRVVtV2dZWXlsMHhSNVlLSnpnSmpQbkZWL3NT?=
 =?utf-8?B?ckFBNHU5K3VrVG1FYjg5bmhyRUdzMUw1WTY4eXlZeWtvTExsWGZHNzVjT0FR?=
 =?utf-8?B?Y3hKTkx3RVVFV1VMQjdlMWJlaGJTMm1VcDRRWEZrRXRXOW13NTY5dlNEelQ5?=
 =?utf-8?B?RVVjTG9Ia2ZMUWhRbXByaU5XTzlTbDlvRk1uZ2ZJcVI1OE5JZDFWYVZSV2lW?=
 =?utf-8?B?dEJxYkVMa1ZWdXhmbmtWcTBobkdHcC9SL0RucU82SENheWlXbGRLeUxpWUJ2?=
 =?utf-8?B?bFRUZEczTEFDd2JTRHYxckRhYnBSTzVWRlhuOFFHOWRqa0MyKzRIcDRDaVc3?=
 =?utf-8?B?R1ZRM0hFcVVuNGJwRXNNcTY4RHZkRkFzNlh4T1pJNmhvWndxdHROcHE2dE5S?=
 =?utf-8?B?Q04wZUU3RWxiRk5kK1VNN0ZKRG1ITFlGeVNhbkttZGgyMWl6Z090MkpRUXhp?=
 =?utf-8?B?ZGUzajRmeWpNNUJ3aDcrSjJGbDh0RHp0QjZlTlhMOWRCV3N3b1BNNU5pNmI5?=
 =?utf-8?B?M2JkUGpTNVJHZktnbXBFc2QydGQ0ZElJUDJ1WVlidmp1cHI5c2ZKY2hxRXo0?=
 =?utf-8?B?d1RvV2xHejYvR0pOZmNQcGMzajNpTCt3QWg3dkVCZGtDNlFhWmN1dTU1Ynkv?=
 =?utf-8?B?eWRmaWNha2lqdU1scDhLRlV4QUJ3Y3VGc2hReTV4V2dpTi9zSU0xRWVSd1Vq?=
 =?utf-8?B?YkxSeDhrVk4zNjJteStjcnB4R2xta1dBU1lSL1hkSmZTV0lQNUxpUFJSTDRR?=
 =?utf-8?B?V25ZTTM4ZkZHN05zbC9kNDFvcWRCc1pmcGNWYmFsUUFWUFBSdjJ1bHhHaHZl?=
 =?utf-8?B?TEtDdDlRNmZRY3h2TDArVTUvN2sreFFjL1RoZnNQNS9LWnJta3RIS2FqRUxU?=
 =?utf-8?B?eGR2NjZwbU5ySW5wdk1YUFNuMW9HSmlrZ2dWOEFaNStpcEFWSTlLKzd5bTZI?=
 =?utf-8?B?NVpVM0Z3SlZxemlISkJuMU56UGJ5NmRiamtWYWx2QjlpN1pFNFh0TG9PVGFu?=
 =?utf-8?B?NnlSRVozdlFVMkZBQVBCazJlQmJESE1CbjY5MjRoZm5ZT3J0c0V0RldUK0NL?=
 =?utf-8?B?RTJCNjk5OVB3REVVVVNLSklQS0k5RFpWdDBzZXl5dmxaQzAra2RZd1R4d01a?=
 =?utf-8?B?YkJZMG1YK3M4amFrSFR0WnhoSVBERnE2REVqTUg0ZGxTZ2YxS05TRW1PbDRz?=
 =?utf-8?B?WmlXQm4xN2o4aGg2MGhlQ1BOZmg3UkhCT2JLY3J1d1JpMHhyZTNQNGJlS2h5?=
 =?utf-8?B?aGVZK2xpdThkeHVYViszZXNUNXBvbGF6RzVTMFIzZEU4WUtnWkpEYmRHeVZz?=
 =?utf-8?B?WjY2TkNYemFRMS9mZVdLMWM1UGJVWWVaWkhQL2l4NUc1SmhkNnNuRy9GQm1W?=
 =?utf-8?B?R1ZFQVlYN0hzelJacG9hWmVxcnk2MmIwRkNnankyakdBWFlkc3hpMFlNYzZy?=
 =?utf-8?B?QnJMSkVNNG5Ld0p2dHV0MUlPVXZwQnhvbkJGRDVsVDNjZVFZNXJVM3lQL0Ra?=
 =?utf-8?B?c3dwb2YxNWkrQk9STGlqVE5xeVpJNHpUYTVqU3JUZFBsZjBPd1JTZFJ1djdI?=
 =?utf-8?B?MkxCZnA4KzhWcHhNSlVUNTYvcXFMSEkwRjFWZ3dPYkVKQVVwclFDejhQWWlr?=
 =?utf-8?B?UEtodVRlbkh0VCtXQXhqNU9vcXRQZ1JrTmpxZ2NGb1YzdkYvY2N4WGhSdDZz?=
 =?utf-8?B?ekpoTlpHS1pVbzI2OWxTSTRtNVVCVGlRZXZoNStWOEFMM0VGRUsyRHgxVFRS?=
 =?utf-8?B?UFlXaGV2eXRhTUxFelBLeTRXSDFSWHRTQUV6Z3NnRXBtRWdFNWxTNitrWDBY?=
 =?utf-8?B?a1FFVjJya0RLT1JaSzdJWnhVQVRIVyt5WTZIYmc4Njl6Z0NVR1liRU5XVlBi?=
 =?utf-8?B?SUpidmhqT0hwUVhaQ2VFcVpidFNFdERSSTViVUpQY2laSHFJVEV2RWNuTGIr?=
 =?utf-8?B?ZVpuTGQ5TVptUHhUczhGQUV6aHpjYUUwczNLYWNudWpZRExoc290WmlSOG5h?=
 =?utf-8?B?ekdDMzBleCtpek1JczFHNzR4TG5CK2NwZEpxRjdBR2VaN1FRKzdxS05NOW9V?=
 =?utf-8?B?NUZEQzdkU2wwVlNKU0t1d2NWazVZNVdscnhVWDlnK1BxOGMwZDZjWGVVeVVX?=
 =?utf-8?B?WHJHSjFxSlJoZzk2NEovTm5mTlRZaVFEa1pWdzllY3hGQ1hMam9nZlRndTZC?=
 =?utf-8?B?TkU2Q29xaXBNY0xhSUd2Z2w1K01WSHpBTHBrQVhqUlluTHl6MWxsOENQQXhj?=
 =?utf-8?B?K2pZNzBGc2o5L2hyWW1vOTNYZlpSVi95RW1YQWVqcGZoUnJCcTQ3STFrNUg2?=
 =?utf-8?B?MG9nbGNUV0d0MjlMUmxDMk1JT1gyTkMvczNRM2dZeFpsaGNYTUpCSDVKNW9i?=
 =?utf-8?Q?1FAmOh1YBchGdlqM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da2201c9-d24d-469e-f0ec-08de683b39a1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 00:27:51.4419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D6f2PC4SwiMoRiPGoDMWdlg4A+FElzEo/L7L+3rQNJ3gZ7+xbYj99udY8b7xxn3uxwqfKSie1X+rCc/iVFgH1V+GHWZ6iv1nVM+Uz+kImrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF00BBED10C
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[45];
	RCVD_COUNT_SEVEN(0.00)[10];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70679-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 259B71159AE
X-Rspamd-Action: no action

Adding Ben

On 2/3/26 11:58 AM, Luck, Tony wrote:
> On Wed, Jan 21, 2026 at 03:12:38PM -0600, Babu Moger wrote:
>> Privilege Level Zero Association (PLZA) 
>>
>> Privilege Level Zero Association (PLZA) allows the hardware to
>> automatically associate execution in Privilege Level Zero (CPL=0) with a
>> specific COS (Class of Service) and/or RMID (Resource Monitoring
>> Identifier). The QoS feature set already has a mechanism to associate
>> execution on each logical processor with an RMID or COS. PLZA allows the
>> system to override this per-thread association for a thread that is
>> executing with CPL=0. 
> 
> Adding Drew, and prodding Dave & James, for this discussion.
> 
> At LPC it was stated that both ARM and RISC-V already have support
> to run kernel code with different quality of service parameters from
> user code.
> 
> I'm thinking that Babu's implementation for resctrl may be over
> engineered. Specifically the part that allows users to put some
> tasks into the PLZA group, while leaving others in a mode where
> kernel code runs with same QoS parameters as user code.
> 
> That comes at a cost of complexity, and performance in the context
> switch code.
> 
> But maybe I'm missing some practical case where users want that
> behaviour.
> 
> -Tony


