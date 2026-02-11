Return-Path: <kvm+bounces-70897-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NW7JW4BjWnAwwAAu9opvQ
	(envelope-from <kvm+bounces-70897-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 23:23:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E89181281A4
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 23:23:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 19C7430FED55
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 22:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13E93542E6;
	Wed, 11 Feb 2026 22:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hX2MOIts"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97E1355028;
	Wed, 11 Feb 2026 22:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770848596; cv=fail; b=lYhg4ONSvuPN56sGZWLrsEBx4/f+AvcleQbwyNGs5rg+QCTh3OBGPqE0dJsFADaKiOgFRY3jKNEi2sbm126RcsIhs7jw2hlcgda0c7vYfLL91+VAQMpTkmBZrKSiMgRf8I0+y4/Y9xjAZhgvFtTZobD2WSaOYUELyrAOoe4al0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770848596; c=relaxed/simple;
	bh=xNn5JPOCs/CXguUzoGvcdNqxCkLXj6wuWE49epLMuto=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aUmxK2VzBCFC3tMDo4eZ2G1qmPToOI5Wm/vK8/hLTOudsg+Ie5LTPzgqymNMsuvQa87QOubCqPnwdVYayfwy21Pfwiqdu0HySfrxU/W120rfmNu2+6e0MUzQu6BxJf80jiwh77VHFytK21iEIJ5HXPfbkbnijXbHW40zrAPU0HI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hX2MOIts; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770848595; x=1802384595;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xNn5JPOCs/CXguUzoGvcdNqxCkLXj6wuWE49epLMuto=;
  b=hX2MOItsgkmghmDcOmIXLP8hzAmv2aMjwMy84DG4S1SWIUSGi1zjB4hY
   T0UCMh40qITa0ilUEYQzSlVtop/5Vs91fOTIez2X1A3i+sqHvbgwZ2ckW
   RkOrkTQQQt0k+x7xITLyuMzvc4iiSqltdxZ6YZK+4yVGgdQbc24r1PPx7
   WI1R8iRWE5217ASS+iQc6Ycqm8mobhpo5jDLQF0XbR1wF4KYfZLe/SlT2
   tVvOgrPUpbBIVV6aSylGouF0mSGHZWgQM2pf+bQFMJwUNGL34ovp+dE3I
   97YE7li+LCcL7NYhJz8FMRypjDqbA7+swx5kRFpMxolBvruD+hbeu23RF
   w==;
X-CSE-ConnectionGUID: ViPK8BqfTFW9rKnnboQ7nQ==
X-CSE-MsgGUID: yOP/g7ATRsesi1uA9Obwwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="72079646"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="72079646"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 14:23:13 -0800
X-CSE-ConnectionGUID: AfT7TcYTRbex/1vF2DrGrA==
X-CSE-MsgGUID: WqqDCHszRFeQK9154fpjaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="250044518"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 14:23:13 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 14:23:12 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 14:23:12 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.45) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 14:23:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SFkk7fZe3mL25aDE0ZNPKqiTMTvWgryzCciJbrn0FoW6GvVkB2SF5NL4As6SHTsggI4a4qxzV44DCHykQGWFnt34G7P8AGFDgdbGyFU96dbLn7yymEgodxe1Nt5zcbfcIpzyeZ3+66dvfEmHt6YIdbFgctlkfnU4Qr/dXEqw+KFnrHk0UQH1/x58XBDI8pIGKJVoZCUXbfzxkdZJzVKwV0kPVwyTr9qImePWBf02GV9lr7oNcbdYd0L7zUwLPu65yIWIUak8b4Tl//9a2URt/J/XfHULWfuOgojtr6uxA1tFj08R5DZBBj50B9PRydQR8PttRqjrMl7UoznR8j3Shw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wW493o7HKgc0VOHUfZI5lJ5GkNeRf14qsrKfCkuCHXM=;
 b=ulbMPAAadPc58sRPaOMZfrwDZeyRZnN5Pn/PmK7xwmiFt6f62fIlIH/1wPXF07uGPoiOv0TTPXMTgMhkSq9TBrFWAxE+7xh2W2WMMTNWwlglvQC6ixrT/qU1FFc+xkqyv7im0rK8dT8tHjdeLHi3Tl7nVy+oALUmr22z3BobPzZ9554vZDGfm+TnFZvoGub6qESTB7167ayRNYFkLmBwug3R5HpWPvY6VrODfF8hLcNRgHmWeOiqco+tDs7QSdGZ2/lAYzFvykOObzMnE1Hm0bk6NLNdXznLfD2JurxI0I0LOoIs1Lovhlj4zfKJhjiU8Il8IE4ZN3mJ+N7hCbZ4ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB7111.namprd11.prod.outlook.com (2603:10b6:806:2b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 22:23:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 22:22:59 +0000
Message-ID: <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
Date: Wed, 11 Feb 2026 14:22:55 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Ben Horgan <ben.horgan@arm.com>
CC: "Moger, Babu" <bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>, "Luck,
 Tony" <tony.luck@intel.com>, Drew Fustini <fustini@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aYyxAPdTFejzsE42@e134344.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0243.namprd04.prod.outlook.com
 (2603:10b6:303:88::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB7111:EE_
X-MS-Office365-Filtering-Correlation-Id: e600665d-32d1-4d40-5471-08de69bc1d17
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VzIrZjBTSVRHQVJ1NFZzTDFjUDhjWmM3c0I3L3RQMWlITEJmTXNwckttOTVJ?=
 =?utf-8?B?VDNNdnNDSlJJNUtKTkJXMFJTUitZUXVHMkgrLzVBN2IzRllCcHlGUU41S2tN?=
 =?utf-8?B?K1ozUWMrRUJwc2NMdnZXVStiUGVYc1MwNEdEVTNqY3NuM0syR256VWNnTVlk?=
 =?utf-8?B?ci9oS3FxNnpQT2QvYW02SnFxNjczcVlUdEhvNVdqUFRsNndzc3d1RHlGd3lz?=
 =?utf-8?B?WkJNSjFaZmNhbE9kc29uaVFtZjlZVEw4aUdHdDhINE9GbVlTQU1MOHFEVWNy?=
 =?utf-8?B?TDE1MlpTTWh5TXNLRUU0djdrYndrd1cyejJ6amMrMVNYbm1FMThhVkxsNXQ4?=
 =?utf-8?B?QzBpOExsMEc3ZVJ1N3pYbXFDNXQ3Q2dGekkyYkg0SnlndUNNb3hWMVUvbFha?=
 =?utf-8?B?VE9WT3ZkMVU1WENZalZjelVEc2xOVTJpMHoyMEk3R1VUV0VaU2Rvb1FWRFg5?=
 =?utf-8?B?TUZUQWtmVVFiUlpmMXVCSDFTNkVhUEFURG5jbWJZU2NQWGNYRDhGRkFTQSs1?=
 =?utf-8?B?SFFBd2F5RFoxNmRPZkhHK3BEeXJuU092VmxiZHd6YmJsazNlRUFsQUxuaG94?=
 =?utf-8?B?K0NDM21FQWlFNTB6M1VxZ1E1T2FoZzllUVRGUnl5K2E5Q1poM2RSYW9Ud050?=
 =?utf-8?B?ek1aS2MwVVhvSTVuTTNLQnNrekp5Q24vQmNqRmx4WWpLOUNwUUV2eUttSFVH?=
 =?utf-8?B?NnJEV2NxeVdKZGZKSjFiUVZVNE9OQVhiMWt5MFJtQWc0ekZydlZEVjlJTWVU?=
 =?utf-8?B?TEJZeXJhZEVYN0RhU0hiendabHZmeVd4cnp4T1pYbGd4UlRvUmVUSGdQcGlj?=
 =?utf-8?B?S09rYmR2dkdTR1pmWUxLR1h6NVo3UFhyRkUyRjJwVDVuS1IrNEY4WGdxUTFz?=
 =?utf-8?B?TzU4R2NqWHhpaml1anE1Nm1iWnBtczlPaytzWGR3cWlRWXgvYk5uWWdUYXJH?=
 =?utf-8?B?VDJlR1ZkV0N1ek4zTElNUU5EK0ZqTUdCMUNCNzBsUWhiU0JkRUNaczQ2Y3Nr?=
 =?utf-8?B?Rm4xdHlaNHE1MTI0cXNzODRPSzl3SS92clFrRzk0bGZvaUQ0YzJlODB1bG8r?=
 =?utf-8?B?dGgxVmNhUFU0MDJjQ0gzR2FZbm1RNDRVWnk5TXZpYXUxR2N6Zkg4S1JUck84?=
 =?utf-8?B?RHVzWW1JL3JjdzZVN1BNNlZXeWhxMEJvSFVtRWhpbXFJNmMxcS9EcXRtUWZ0?=
 =?utf-8?B?NTNSaldyZmRBbnJoVHR1ano2MkhTRGpYcWNGWGVoSWFiZ3FOeXUxcnA2TG15?=
 =?utf-8?B?T2JSekJSeEMwTENob2N0c1QyWWN1dG13QmkwKytHQkVIMU1JSjRyL09ma2V2?=
 =?utf-8?B?U2VsMHgxV0tmMHFlamo3M1ZxdGd1L2NpSkNNc2xaQ040ZTM4U1JOMEluNjZQ?=
 =?utf-8?B?T25IaXp4dWdIcGM1NjlBNG0vOHRid0ZtV0JDdjc1YWlVZFJ5ZjBCV1hrWE1U?=
 =?utf-8?B?aU82TFFNVGc1RnZUZWdiMy9KcHZBVFBjNVd2WEhRa1NPTVZ2ZEtScFR1VFdG?=
 =?utf-8?B?a3o0Vk8rSGMzYTFBYWsxditsc0xpN1R5K2cvVUtuQWxXRVA4SllheUxCcmZO?=
 =?utf-8?B?R2toaE55V240NUcvRWpnWGl3Rnh2RTRWMnRwV1ZQbU5IczUxak90SXhXMCtB?=
 =?utf-8?B?N1NZMk1ybFhwUlJTdnNDczUvRkl1czNnS1ByL3k4SzhZY0ROZ2w5TVlKclBn?=
 =?utf-8?B?MWgwZWZ0NUx3bkh0ZzZXQkdOcUtkalRNT3pKaUtjVG41NlR0d2lKK3JxMngx?=
 =?utf-8?B?RWR5R2ZtRVdMNGRlVWs4Q25WYjNnenZ5ZGNSUXM0am03QTdqbDZib0Y1MFFs?=
 =?utf-8?B?cGo3K1lSelJZVGZzNitITzRHZTFJeFZUV3NmdXBzaHNGZFl3eHowYW9kTlBH?=
 =?utf-8?B?TzVFSUE3ZmQrVnNrRUl5UU9HVXprVlg5RmtBRzVMc1lVc2ZqRm11SWY3eTJ3?=
 =?utf-8?B?NEdpMFB0QTZLTkRrcTVQaTA1L1hQYmlxaFZnMGhXcUdQNDNneW14dk5CMit1?=
 =?utf-8?B?KyswaWtVTHFDT2NrSit2QTdWL1pwVUY3VXNzT0lEY3kwWE9GR1ZUWmVpZTZT?=
 =?utf-8?B?akVJMUV3OXc4Nm4zZkdXWXF5dEtpTFZ5TVhoUkVUL2tPeHZoK0ZzcUhpZnpW?=
 =?utf-8?Q?ifv0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blZ4N2NkMlFaN09oeHF3VzBGNVdQZGYySS95N2JkODFYUDNhZHVuRGZSeHBi?=
 =?utf-8?B?SjJzaGppN1ROWEwxSmxvcHZUZ256eFdzZ3FtUjdRNDZKMkFsbFdtYnNaVSs2?=
 =?utf-8?B?M2xxczhrWEMwbmpQbHloSlZ5VEVxd2tSb0htL0NZZ2VPWGF2dllwOUgxQXZH?=
 =?utf-8?B?ZWZ1Z2xjYk40SWl4UjdRbnZlU3RSL1c4eFFXd2JQWHRnMS84SUloa0xuT1hh?=
 =?utf-8?B?empqKzI4alNab3B1KzFDL1haYUlYTWdWdkFwaTZlcEwyMHcvaGdnOVZabkx3?=
 =?utf-8?B?Qy8vbWtRMndqNzVCbVl4WjQ1bnVDV0UzM0dnbHk2UVVsUFJUQ2Fmb0ZDRnhK?=
 =?utf-8?B?VXJ1cGV4UGZMd09LYmhXcmRGQnBFcGx1OE01V3RtZXp0bjdxZGNNZ1BMOEJz?=
 =?utf-8?B?L2dNSjZYVEhtR1VMQmM0RUVVZEltek95azNRYXVONWwwQitRRUJGUDhCYXV6?=
 =?utf-8?B?QkJZUHdLTlhCcEkxVlBubmVCYk5uVE9LZU9FVVNBSy9KSjQ4Wlk2dHp4MUpv?=
 =?utf-8?B?cUhpMzZldlpOamx4V3VKVE9MRXpIbmt1em1mZ3pyOXhoSVhHcWdOT2JSV3pX?=
 =?utf-8?B?Vk9OSm9TVkZGK3QzREhQR0VKNDVzMEVPc1JyMHc5b0NUOUZaQWRJWWtqSmN2?=
 =?utf-8?B?SFhRTEdLbm5qbWh1TlBja2VOR1NhTWZYKzlMdXVJYitNeThqM0s1LzJYTS85?=
 =?utf-8?B?bzRJMG1WMHcrNitlZDJSNllpYVFUOVcyMjNhdFJsbiszTmNRZ3NJMFlSa05l?=
 =?utf-8?B?L092Tk1qcnVIaHpENGUzZ0hhbnlOenZPeWhBemg5bEdvTWI5V3lzY09ZMnlP?=
 =?utf-8?B?RkhtL2dzV3FFNmxkMXY4ZDlOcEYyS2ZPUHpDVjdPVkd2QnYxWTE4QUZHMmJI?=
 =?utf-8?B?NXNYTDZ0RHZnNWk2YTFLNCtJVkZZOW42Sy9mV01sSVdKZ050ZUpoeVJvcU9V?=
 =?utf-8?B?Zy9RZlMrc05vV2VjUkE1aGtXb3VCbGVmWk40aSt1Q2FMNDRsT0dSQnVGSlBR?=
 =?utf-8?B?QUtsZmNyYnkvVEs5MXhkd3pTOVB4ZzEvUEhxVVd2WjZJbGdEeXFZSDEvcENv?=
 =?utf-8?B?S1llTU5nd1lqQURPQ1JxUUVNQmRzdUlYdWYyL2s2SHU4YzErd1JkeUV1V05p?=
 =?utf-8?B?dUFGdHQweHRIS2dVbGpGSlNQUXVNNStodmVjSzlCaVZZUnpzcDkyS1hjRlhD?=
 =?utf-8?B?SCtHMVRiTjFQakJ2Y3VLdGp6bGJSUHVpUU9zNWVmWjFPREUvNmhLU2xmbXlR?=
 =?utf-8?B?L2MwQ2RnWVBHK2lHTW93blNHVFhVU2FRNXM4ZzQxTkNweU5ISjhNeS9nV0dD?=
 =?utf-8?B?VE9jeUtkNHVmMUhONE5JaUNlRTFUVlp2TjlkRUtEYmlja1g3c2ZLdXd3SkJa?=
 =?utf-8?B?Y0ttOEZKelFGWWlhdjUrTWtvN2lEUWRGNlBMbm5OWGJMTmF5WWlYTjBpZ0V6?=
 =?utf-8?B?cXlCQm13K2VVdEtlRW1YQXhiODBNTFZITlR3Z3d4Lyt6THpYeUFSNlF5dTg1?=
 =?utf-8?B?a1B4dG9HcjJ5ZE1Da01lZmw1YVJuVkJNNldjcGk2VTFabEJNQ29vVk1JUWFr?=
 =?utf-8?B?a0k3N0JjbEg4dVd6d1Q5c0dCYlMrYy9Pek8zcjF3RWJGanh5QXJJcklsbnZ5?=
 =?utf-8?B?blFsZmRrV3I0a2lXYlRNZTlacHYvMzVtZ0d2cGtFWUk1cjdoZ1doMXFOZ0RM?=
 =?utf-8?B?NkxhcFZqQ0hxcGRiMjBlMDFDZzYxM2RCalpobzI2bjlWQlNCcWhORUx2VVQ0?=
 =?utf-8?B?bDdJTTJMbEdTN3ZRUURETnNPUGw4NXdwNGxjUEVjeSt1bHUrS3pZVWFsNUVC?=
 =?utf-8?B?ak1LSFR5MC9FMG5RMGpNUkNYZXAvSGl1K1ZwM3k2SE5uMWRqdXBvdExTWFpv?=
 =?utf-8?B?K0MzZ2NvR2xmRm4vQmhZdzdiOWF4eTZqOGtuUXI3RTdkRDBNZkhIRkVRY0Nm?=
 =?utf-8?B?SEE2T3FnMjZBcGdLbmVGdlVnRWF0NWQ5TE53eGFJZmpTYlBid1EwNzRHdDdZ?=
 =?utf-8?B?QzhGV1V4bU1BMVN4ck40L1pIT1pkYjd2c3orQkhnK21EQVhKWUs3Sy9ENjNa?=
 =?utf-8?B?ZTBwbTk2MVBidENPSzk4bnNWc0VNZTZ3b1RYWWxSc1lVOWlDV1VDK3NyRWxC?=
 =?utf-8?B?bUNXSnB2ZFFRelRIQzNlTTRqQm1TcDFvSEs5QldwYUV0L2N4V3lWYVpaT2Z6?=
 =?utf-8?B?R0J6YWhaeW05ekxrM0VSWTNqVXk1dnU1TURoYjQxYkJ5cGg3SzBHY3ZMM2Vj?=
 =?utf-8?B?bDRuRkpXQjJKOHJ1ZW53ZEFJYW9aNVRWOHVFYkJTNzh0TDRteUs1ejQxSVRW?=
 =?utf-8?B?VHlrSkFXS1RyLzJvcFlONHdiTnltWEpBMU1WVXhLV055UHJTSGNtQmpudit0?=
 =?utf-8?Q?VR+feYCmVOV1j3G4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e600665d-32d1-4d40-5471-08de69bc1d17
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 22:22:59.7925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zntG+NwoO5hpekWZ+WU5Lex/wXFUwg/tifRsrWafGueu3vgNqOmAuD2g1zmMBGTBTlbNB6p5AR9P8u6kdi5zJtF/L7/gKewLsCpamrTV+aQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7111
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70897-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: E89181281A4
X-Rspamd-Action: no action

Hi Ben,

On 2/11/26 8:40 AM, Ben Horgan wrote:
> On Tue, Feb 10, 2026 at 10:04:48AM -0800, Reinette Chatre wrote:
>> On 2/10/26 8:17 AM, Reinette Chatre wrote:
>>> On 1/28/26 9:44 AM, Moger, Babu wrote:
>>>>
>>>>
>>>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>>>> Babu,
>>>>>>
>>>>>> I've read a bit more of the code now and I think I understand more.
>>>>>>
>>>>>> Some useful additions to your explanation.
>>>>>>
>>>>>> 1) Only one CTRL group can be marked as PLZA
>>>>>
>>>>> Yes. Correct.
>>>
>>> Why limit it to one CTRL_MON group and why not support it for MON groups?
>>>
>>> Limiting it to a single CTRL group seems restrictive in a few ways:
>>> 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
>>>    number of use cases that can be supported. Consider, for example, an existing
>>>    "high priority" resource group and a "low priority" resource group. The user may
>>>    just want to let the tasks in the "low priority" resource group run as "high priority"
>>>    when in CPL0. This of course may depend on what resources are allocated, for example
>>>    cache may need more care, but if, for example, user is only interested in memory
>>>    bandwidth allocation this seems a reasonable use case?
>>> 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
>>>    capable of in terms of number of different control groups/CLOSID that can be
>>>    assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
>>> 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
>>>    MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
>>>    example, create a resource group that contains tasks of interest and create
>>>    a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
>>>    This will give user space better insight into system behavior and from what I can
>>>    tell is supported by the feature but not enabled?
>>>
>>>>>
>>>>>> 2) It can't be the root/default group
>>>>>
>>>>> This is something I added to keep the default group in a un-disturbed,
>>>
>>> Why was this needed?
>>>
>>>>>
>>>>>> 3) It can't have sub monitor groups
>>>
>>> Why not?
>>>
>>>>>> 4) It can't be pseudo-locked
>>>>>
>>>>> Yes.
>>>>>
>>>>>>
>>>>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
>>>>>> would avoid any additional context switch overhead as the PLZA MSR would never
>>>>>> need to change.
>>>>>
>>>>> Yes. That can be one use case.
>>>>>
>>>>>>
>>>>>> If that is the case, maybe for the PLZA group we should allow user to
>>>>>> do:
>>>>>>
>>>>>> # echo '*' > tasks
>>>
>>> Dedicating a resource group to "PLZA" seems restrictive while also adding many
>>> complications since this designation makes resource group behave differently and
>>> thus the files need to get extra "treatments" to handle this "PLZA" designation.
>>>
>>> I am wondering if it will not be simpler to introduce just one new file, for example
>>> "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
>>> file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
>>> task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
>>> resource group to manage user space and kernel space allocations while also supporting
>>> various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
>>> use case where user space can create a new resource group with certain allocations but the
>>> "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
>>> the resource group's allocations when in CPL0.
> 
> If there is a "tasks_cpl0"  then I'd expect a "cpus_cpl0" too.

That is reasonable, yes.

>> It looks like MPAM has a few more capabilities here and the Arm levels are numbered differently
>> with EL0 meaning user space. We should thus aim to keep things as generic as possible. For example,
>> instead of CPL0 using something like "kernel" or ... ?
> 
> Yes, PLZA does open up more possibilities for MPAM usage.  I've talked to James
> internally and here are a few thoughts.
> 
> If the user case is just that an option run all tasks with the same closid/rmid
> (partid/pmg) configuration when they are running in the kernel then I'd favour a
> mount option. The resctrl filesytem interface doesn't need to change and

I view mount options as an interface of last resort. Why would a mount option be needed
in this case? The existence of the file used to configure the feature seems sufficient?

Also ...

I do not think resctrl should unnecessarily place constraints on what the hardware
features are capable of. As I understand, both PLZA and MPAM supports use case where
tasks may use different CLOSID/RMID (PARTID/PMG) when running in the kernel. Limiting
this to only one CLOSID/PARTID seems like an unmotivated constraint to me at the moment.
This may be because I am not familiar with all the requirements here so please do
help with insight on how the hardware feature is intended to be used as it relates
to its design.

We have to be very careful when constraining a feature this much  If resctrl does something
like this it essentially restricts what users could do forever.

> userspace software doesn't need to change. This could either take away a
> closid/rmid from userspace and dedicate it to the kernel or perhaps have a
> policy to have the default group as the kernel group. If you use the default

Similar to above I do not see PLZA or MPAM preventing sharing of CLOSID/RMID (PARTID/PMG)
between user space and kernel. I do not see a motivation for resctrl to place such
constraint.

> configuration, at least for MPAM, the kernel may not be running at the highest
> priority as a minimum bandwidth can be used to give a priority boost. (Once we
> have a resctrl schema for this.)
> 
> It could be useful to have something a bit more featureful though. Is there a
> need for the two mappings, task->cpl0 config and task->cpl1 to be independent or
> would as task->(cp0 config, cp1 config) be sufficient? It seems awkward that
> it's not a single write to move a task. If a single mapping is sufficient, then

Moving a task in x86 is currently two writes by writing the CLOSID and RMID separately.
I think the MPAM approach is better and there may be opportunity to do this in a similar
way and both architectures use the same field(s) in the task_struct.

> as single new file, kernel_group,per CTRL_MON group (maybe MON groups) as
> suggested above but rather than a task that file could hold a path to the
> CTRL_MON/MON group that provides the kernel configuraion for tasks running in
> that group. So that this can be transparent to existing software an empty string

Something like this would force all tasks of a group to run with the same CLOSID/RMID
(PARTID/PMG) when in kernel space. This seems to restrict what the hardware supports
and may reduce the possible use case of this feature.

For example,
- There may be a scenario where there is a set of tasks with a particular allocation 
  when running in user space but when in kernel these tasks benefit from different
  allocations. Consider for example below arrangement where tasks 1, 2, and 3 run in
  user space with allocations from resource_groupA. While these tasks are ok with this
  allocation when in user space they have different requirements when it comes to
  kernel space. There may be a resource_groupB that allocates a lot of resources ("high
  priority") that task 1 should use for kernel work and a resource_groupC that allocates
  fewer resources that tasks 2 and 3 should use for kernel work ("medium priority").  
  
  resource_groupA:
	schemata: <average allocations that work for tasks 1, 2, and 3 when in user space>
	tasks when in user space: 1, 2, 3

  resource_groupB:
	schemata: <high priority allocations>
	tasks when in kernel space: 1

  resource_groupC:
	schemata: <medium priority allocations>
	tasks when in kernel space: 2, 3

  If user space is forced to have the same tasks have the same user space and kernel
  allocations then that will force user space to create additional resource groups that
  will use up CLOSID/PARTID that is a scarce resource.

- There may be a scenario where the user is attempting to understand system behavior by
  monitoring individual or subsets of tasks' bandwidth usage when in kernel space. 

- From what I can tell PLZA also supports *different* allocations when in user vs
  kernel space while using the *same* monitoring group for both. This does not seem
  transferable to MPAM and would take more effort to support in resctrl but it is
  a use case that the hardware enables. 

When enabling a feature I would of course prefer not to add unnecessary complexity. Even so,
resctrl is expected to expose hardware capabilities to user space. There seems to be some
opinions on how user space will now and forever interact with these features that
are not clear to me so I would appreciate more insight in why these constraints are
appropriate.

Reinette

> can mean use the current group's when in the kernel (as well as for
> userspace). A slash, /, could be used to refer to the default group. This would
> give something like the below under /sys/fs/resctrl.
> 
> .
> ├── cpus
> ├── tasks
> ├── ctrl1
> │   ├── cpus
> │   ├── kernel_group -> mon_groups/mon1
> │   └── tasks
> ├── kernel_group -> ctrl1
> └── mon_groups
>     └── mon1
>         ├── cpus
>         ├── kernel_group -> ctrl1
>         └── tasks
> 
>>
>> I have not read anything about the RISC-V side of this yet.
>>
>> Reinette
>>
>>>
>>> Reinette
>>>
>>> [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/
>>
> 
> Thanks,
> 
> Ben


