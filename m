Return-Path: <kvm+bounces-71363-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFehBgdUl2lexAIAu9opvQ
	(envelope-from <kvm+bounces-71363-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 19:18:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71AA31619A6
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 19:18:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4822230B8F49
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 18:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5CB353EC1;
	Thu, 19 Feb 2026 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BiQev25y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7A2354AD0;
	Thu, 19 Feb 2026 18:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771524879; cv=fail; b=FDGByW6ISJXrjH3rHbFo9KfJn7uq7JH1RFk0KwECLLhU95V7Oxh6YPh079XHjJifpYqFzKIo90S2y1cQu1Z8yf0lzXck0ZE/Z/Kf0vZqi+5QIOAvHPY1JzTMlW5B7RdCU0j7YHfXhrBiotY8qNMqE4PG3xDhYIPTE3Wt8FI1hEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771524879; c=relaxed/simple;
	bh=GLk/Lqc1Wgju/LFjSMKYD/N1+GCZPN/DPX6+QwVaS88=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZinBstDNsedbbkCyNvd5Jm44kRSqkIDgS5OcNPGvTk7G50Pj3Itcl+t3zQQz20q85A38svPOI7CqlO6KieWvEqyiErcuGSu+ijy+c8D6hyIDJIoTntSHXFl6ilGgQPdV1NpXPq7iuBsPtvzDYHk+7AMYIOnHT5jduqXSh5Lrpek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BiQev25y; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771524877; x=1803060877;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GLk/Lqc1Wgju/LFjSMKYD/N1+GCZPN/DPX6+QwVaS88=;
  b=BiQev25yMMfbDIYLIVDFjCJnrXxOZujJAD1VzwQjIGijMk5Vndq0NKxx
   DS3lT5I1gY2Za0UBE+xhIsJLy+gKv5vliG95yTMhsyRlounu0CQYqnq9s
   UvsiwwAC9Cpi/sSH9mO82P+xqpVoTviPZICnFmJFRDTDiYHA/oHqM14qu
   9TCRHN26q9XNSfZel5h6klHKtGPaKdNrcJo6y5tAkOtZjZbk+GknnS2QR
   GLy0hnXXp9ZmIaXN7KxYQfWREFwz6hJT0DFdt5nAZPTVIFvz+DId6rQCo
   Rfs7ryyU6rPbU45Y4ecrkQbgeFpdrzd0HLhfw6R2UAcdSCbJgBVp3K9wa
   g==;
X-CSE-ConnectionGUID: tdkCICkXQF2WnnD7RPpiDg==
X-CSE-MsgGUID: pL0wqtrLTyKcRdQvPrljUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="71824619"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="71824619"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 10:14:36 -0800
X-CSE-ConnectionGUID: Q8tUCdadR425H9Lq6VDNqQ==
X-CSE-MsgGUID: ABvqafWKQie95KaCe2nJBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="218759499"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 10:14:36 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 10:14:35 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 10:14:35 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.39) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 10:14:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uro7lZJe2xmSoPt0/gbUl1F/YrSi+Eec3tnXh7T9L4n5Ut9jqiPTU9q/6gQVWfi8g5fMXbdH6TbXOZnqX7ufNzvRgSpKfcGp/4YCbqTXKqaFtRiVrnXQh8l1iCgcmXp2CYc4c2eVpIp/1CdDgoZRBlV78YlkodK+q6QGN4VMeKNYkoip7nsY0VqAzDXILyLcD8yFtO7I1xkQ83iHJ1XVktMhK8GhqH2u0/eJkJDDEm02+p3cDn8qRwQThWe9twPNLmEKTnj+bVTUXM0ko0YgqImFYzulY9W9ZCULh0dFOlt0dqtJvSITv1TC1BAjTZbXk5QXfRKPCjykQB7ayCHKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1edwiFXfSLnSxYkSmMKwjkbbMLEs1OS5mnIcVYIv/II=;
 b=VDDC/UhHMr+N5jhPvgAusbn+nL07It2g3RaN4TywBJRRRPCmVjK1l+Iv053ej9I0sDC4urNwWKq4D4B5yx+JkuJBQeigFl2zV7QB9uzqRFrrwagJ9W1O553BE4xEbC3VJfh2rU9RtbJ8UiMg+q5WhN5u9zJ+w6Sdrutml1g/e8h3iiBkuOCMn2wF4ja/y4kYi+D+KdFmJE5VIHO1/3UAb0Ksv/lb2h7o8GKRc0LWgMIKQfHL72JVkXRfH8DmNMJbhYoJwbY4goR4Z/QXM1XNLAARye8QtJquHjW7WHndY0vohSB12qm9phgXDYp1EsvQkmzc/UzfPXP/i5lGxD7fTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV8PR11MB8723.namprd11.prod.outlook.com (2603:10b6:408:1f8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 18:14:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 18:14:31 +0000
Message-ID: <f9b08563-4958-4f3c-ad6c-1e7fa3047896@intel.com>
Date: Thu, 19 Feb 2026 10:14:02 -0800
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
References: <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <b746428e-1a91-4ed9-8800-c9769e86df97@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <b746428e-1a91-4ed9-8800-c9769e86df97@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0050.namprd03.prod.outlook.com
 (2603:10b6:303:8e::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV8PR11MB8723:EE_
X-MS-Office365-Filtering-Correlation-Id: 2790d68a-54a9-470e-4968-08de6fe2ba6b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UkU2VUMrZThxS3NNZzBCS2Q2K0dnaUpYdlczK2tIaEcwUzZHbVdNZDFJdERa?=
 =?utf-8?B?cStBVnU5WlAreUtucTJ6dm1QK2kvb21TcS9vT1l2RWNqT0tsTURneDVWVnNH?=
 =?utf-8?B?cW5JV0FHeHc0VkJVcElCVU0rOFdIWUZlY0I0Myt4Q3EyTWZTdTNmK2ZxZ3hy?=
 =?utf-8?B?c2F6ejAyVkxORENaNFcrdGNOd3cvbkR2WkpQMERJTm5UbFFuQXJEbDlCWWl6?=
 =?utf-8?B?cFV3VzRqODJnUTNRNzdNTFY4M0E0OU1GOE9JaUtPd09kdVJIWHJQR2Z6RTB3?=
 =?utf-8?B?RU0vZnBVMlpyNjQvWkpLeWt6bGhhOGFXWmRvTFNoMmVMMWFJRXpYbWhicTNp?=
 =?utf-8?B?ZlEza3dxcDF4aVRkS1RxTzBKRWZCMnFLRlk0ek1yVnFxRm91eFFVM0pGdHRX?=
 =?utf-8?B?R2xaek9YcGxZeXpTblZJZEVKeGtjZHo2QlRmc1RIR3Z1TlFEMjFWVS9jUkRs?=
 =?utf-8?B?YThpVFRncXVDQkpOeXhsZTE5L1Z1bWxRV1R3Q3UyK0ZZV1hJSjN5ZTAwMUJM?=
 =?utf-8?B?WVhYak9sSkV1YTZpOW5GeXE5aUZxaTl2enBhU2FEVU1nWHM0d29udFhya2xN?=
 =?utf-8?B?UEhOM0hWRXZjUnN4MHdBbzRRRnN0Y0pCemN0bm5xVHRFZTIyTEZoaVp3RlE2?=
 =?utf-8?B?MVJRZ0NVS1VHUjNjaHZoQ3ozbWJuRmlqRXlielVyemFWd2k5K25CZkV0OVVV?=
 =?utf-8?B?OUNyTmE3RzN4NEdpTFZaOGt5TjRUaW8ySDFzNitlOG0xN1NpOWhNRkRrY1Ro?=
 =?utf-8?B?YzA3V1RYd0t0SW1UWjA1ZmF1Wk50THNBMmJYb3R5bUxyOThtZWdFTlZremEx?=
 =?utf-8?B?L3R3SUwxQkgvWGZoUEthZm1zbXlPaVVpTjUzbnovMTBRMGgyMUQ4Unhsajc5?=
 =?utf-8?B?L0FtT2pKKys0S0QwSks4NjBYV3l5OXdGb2UwOWY0MW1lY3RLR3FUWHp6blI3?=
 =?utf-8?B?RTRLVW9xNUhDRml0WTRjZlpzRUZ1TERwMzFBTnRLZHVKV3oydkgwWWpEazlO?=
 =?utf-8?B?RXF1WnMyOXJBMXFkNVEyMGVpU3A4L0VZbytiT2dzZVBrVFh6UjV2ODhya3dL?=
 =?utf-8?B?eU04cmdaRmlaNGg3cGN4TUFxdTFBdFRtOXhZVkI0UmNHZk8wTEQxOHN1Nytx?=
 =?utf-8?B?cnBBa2NuNUJBVEpPcGFheU5hKy9jdEJndVZ4cGw1cmNPQy9tdzdqYkd3eW9n?=
 =?utf-8?B?MEl3VDlJM3JWV3lBTVZuUUhtemJDNXZRYnNPTFE3NmRNOWlyZVBkVmxHY3Bm?=
 =?utf-8?B?elM1bk95N25JT2RRamdVU25FMithTmJ4YnhVMnlGNVAwNVZObUxlUlQ5R092?=
 =?utf-8?B?dEdnN1pSb1IvQ3VoaG1DcVhFTHRud2hKSFlyckREZmk5ZWc2bzVHZXNZSGo5?=
 =?utf-8?B?Q3E3aTY2dUROTFFIaW96UjFmNWowL2x2T2N0V0VvMmV3V09oV0JxbmpFcGhQ?=
 =?utf-8?B?Szg2bWU4bk1SL3VjSklacUJ0SGlTWkJSeHNlTWJoVGlodHFwbS9DL1lTWUdM?=
 =?utf-8?B?MndzYjRxdDQrK2U4YmJhUnV1ZzdDQWpoRUlYaitoN2YyWTZ4eHdHYlMwd0lp?=
 =?utf-8?B?UEVXZlNWU1I0bC91YnlIMWhOaWQvbDhNb2x5eGprcmViOWtMU3ZiWWZqZ0dI?=
 =?utf-8?B?YzIzaGhCWGpoQmF2Nk5GV3JZeTBFc3I4ME02TWs4ZWpCdUZkNDFVQkIxZU1Q?=
 =?utf-8?B?L1VBcSttRTd2b2JWN3MvSURwcGozVjJkcnhrVjVLQVZuMDRlaXdRWWNuK3NT?=
 =?utf-8?B?Y0RtNlRUYTNXWllFOUs4bTh5eCt5L2U4ZGZLSkJ2eGNOd0xaOU05Z1puU20v?=
 =?utf-8?B?VDhXMzF4a1pldFJyeGpxa1hFdXozOStDay9xT2svSEFRWS9zaDJUMlNhMWsz?=
 =?utf-8?B?cTJXSXY3ZWw2YkRiK3VzcXRlUWM3VHBUaHlIMFZKOWc3STcwV05FbkxLTGZO?=
 =?utf-8?B?clJ5amo0dUpjeUYxZTdKTUJTaWlCM3NDTS9GdFRNZWh5RGhzNUtCQVMybm1I?=
 =?utf-8?B?dVRuQmNXejJVMWJMQzkwaENZcHpBVnhIZE1XZHZwN3dEUUN4K28rc0dwQmQ5?=
 =?utf-8?Q?ytC5Am?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHkxaEh0Qm45YlZXYWxmVitvdER5R25pUmc2TTRrSjR0L0NQWWEzTVd1clhl?=
 =?utf-8?B?V0VZQkZCTWpIdUJzaWw0WTVYTzJBZHBmYXlBMGNwNS9XQXRQME9sUDdzSmN4?=
 =?utf-8?B?clFKQWU0SGdIK3RFZ1llVmxuTm9FMlJRVWpmRXB2M1crVm9LN21Zd0RJQXZL?=
 =?utf-8?B?THMvMEdmN2dkUWRvemV0ZUhjalVpSEoyLzh1MlUzQXRWcjdVQzFRNGtyNmF2?=
 =?utf-8?B?Q0pCWWQ2UWhVcFBUeGpVbnpwQXd5TUZnc3pRZVVVanhkZ0I3Q2l2QVhEOGZk?=
 =?utf-8?B?TEprQUNieEdPT1VzL25WYzlVdzV5RHJYWDZRdGRrZHNhbTk4TFNFSk9acXF5?=
 =?utf-8?B?QnczL2RBelVwZFJZTEF4RGx4cmxqM0drdVJRZjJidGFlRnZldldTSFY5ZTJD?=
 =?utf-8?B?Smk4Rm1iUTd3RXVjaUpWaVhyazdwUGJHbGZCQk16a3JWOUZORUtmQXFzZUpP?=
 =?utf-8?B?cXZ1LzB2UThlL2Q1WHNlelVna3dBVHhBQkFMeVMxVG1lbDR6ekFmTVlMa1ZU?=
 =?utf-8?B?d0NGM2JiaWZ3aENkY04zQTE0THVYa3RFOTEzU1ZBNHR0elh1QnlLblZEcEEy?=
 =?utf-8?B?aTQ1QlVpYlBPTExSSDZNZHlFNDk2WjFubzlDUUR3Wnk5aWJzMGY3YjhOLzNM?=
 =?utf-8?B?cGNUK2RBSGxydFNObk5jOUNlZGh6WGhsQzVpVWN6SExCdDZ5b01GU1VxdXk0?=
 =?utf-8?B?S01jbzVMYitUM3crUXp5K09tbHlXcmRzNTR5elAzTHlydkFEMFpJS1hKNzY1?=
 =?utf-8?B?ZFNEV3VVazg3VVFRLy8zNVBMZ2xWd3hIWVo4NG1odWR2YW5mZG1YWFlKMHdz?=
 =?utf-8?B?M1g2RVpseEFDQTlvbGJCTWErWFB5SmRzVUpRYTd6TWVJOXBLUGw3S0czT2o0?=
 =?utf-8?B?YUtrc0VOR3lQYjgyK0V1UFNIV3dobWc1MG9yV292clBuMFZJZW51RUdIZXR1?=
 =?utf-8?B?TEVCYS9nbThRUlZHcjJIMW1nM3FiQUVHMStuc1ZQT2M2ZTJSUlE5eWdHeFBw?=
 =?utf-8?B?cE5qcXFCYkhaYk9RRnMzb0lOeUxyVTdWd2dYRUt5K013YmVhWGhvaXdEMTVv?=
 =?utf-8?B?WDdpaEZ4YjFsR3JXcW50amRvaDBWK3Qza3pJR09RR2g0NlJ3NmhPK1JKN3pS?=
 =?utf-8?B?anJEeS9nSiswTDRyaklGWGZQa3RzZzRHcjN0NlNudE8wbmNvL3B5T2JBMVUx?=
 =?utf-8?B?RUZoK2gvRFljMld3RWs5ZGg0MS9pWmVORzEwVENQcFc1RUFyMjd0eU5JL1NH?=
 =?utf-8?B?OVQvZFNUMythdkRsWk4wZXB4S0MvMHh4YU5wdEtjcXhKZ0YzWWJyUTloQjgw?=
 =?utf-8?B?cXZ3T29xQlFJNE1pS3JuSWtxUjVLS3ZTYkFwcWlOWGRWalJKQWZDdUpKdXJm?=
 =?utf-8?B?b2Jpcyt5MnF3aUJRZ0VUUW5mcmhGbU0rVmVycXE5VU40UWJpL3BIQnBXUDJw?=
 =?utf-8?B?Rk55THhvSVAvM1RBby9FUmtNSytPbEdzTjhIcjFGSlBDV0p2TFdrZUtGV0Zw?=
 =?utf-8?B?eXdQeTdxZkNYRkREME16Tk9PUzR1L3hlQ3J3d2VCNHRJR2V3M3lHUUtpQ3Rx?=
 =?utf-8?B?S3UwQ0MyZUhIT2lBQnRCdHZxNDFpTEhFc3djMTgxOEowT0gwcUtNYk1ncktI?=
 =?utf-8?B?eVlheHlLZVJIbHlQVndhUmsyYjJka1FMdG5RTmE4SnkxNUdrbUVNQ0k3Mjgx?=
 =?utf-8?B?TklybjA0V0ZPdS9Nb1lXZ1F1WDIyMk9nTElJd3IxdHgvR0E3b01keTNOaVlj?=
 =?utf-8?B?K1hHanp5dEJiR2RkaWIzbUJOSmc4ZER6bWQ4cVAzUjQxbWVrcWhmaTlsYkoz?=
 =?utf-8?B?Uy83T09oWG9TbWVFSXJwMDRUWFZiSWxsWElITndTSjFrNzlVUGk5cmc1Q3JM?=
 =?utf-8?B?bEtnSGpTUENPNS9mNlErV0RzVEJHWXpmY3cwYTkwcE1Tb0pNR28wRXJ4VkFM?=
 =?utf-8?B?ZldJTUVmZ0FXSk95NmNabVU3Zkt1V21IMEU5Rlc0d3BGajNwbnFsWGFIMFRK?=
 =?utf-8?B?WlpyT2cvTjNJQ29yV2lKZjJ3RVRHYlo5bkEwSUZ4M0szTUd0K2ZJOW11dzdi?=
 =?utf-8?B?VzJaQVJ6dWxmekt2MXlESWRyelZsM0ZlM1ljYzRUWXcwdy9DYmNBYXlKZ2R5?=
 =?utf-8?B?Qnp3T21OQlI5UnI4Y210NU4yaHlHeThHWS9lclNCNGlFZFdxUUNVd0hoZkJK?=
 =?utf-8?B?UmFldHZMQVlXY3UvdzErdFR3eHdmbjVUMm9MTmtMd1A0Qmg5aXpiZ2JQd2Yy?=
 =?utf-8?B?aDNRNkdLRlI1YklJUndvdlROclArUHpneGczejdDSk1ZcVlxeW5HbjlFMUUy?=
 =?utf-8?B?UGhJZnIvc1hXNW9XbDBjVEM4TEVpVGdKd0NDMUkwWXRvT0VtU1h6ZkNIeWVu?=
 =?utf-8?Q?9epAXMCqaAjBPvi0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2790d68a-54a9-470e-4968-08de6fe2ba6b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 18:14:31.5694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsvNB9yRpujtdGr0cGjqy6bzQUj7Mq2AH3xoxtapO9VrNP27gYrAesn+JHFC63TfMKdsMxWto9JGYxTSgVUcHih+KTAt5SFT+gU6qhfbCGk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8723
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
	TAGGED_FROM(0.00)[bounces-71363-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 71AA31619A6
X-Rspamd-Action: no action

Hi Ben,

On 2/19/26 2:21 AM, Ben Horgan wrote:
> On 2/17/26 18:51, Reinette Chatre wrote:
>> On 2/16/26 7:18 AM, Ben Horgan wrote:
>>> On Thu, Feb 12, 2026 at 10:37:21AM -0800, Reinette Chatre wrote:
>>>> On 2/12/26 5:55 AM, Ben Horgan wrote:
>>>>> On Wed, Feb 11, 2026 at 02:22:55PM -0800, Reinette Chatre wrote:
>>>>>> On 2/11/26 8:40 AM, Ben Horgan wrote:
>>>>>>> On Tue, Feb 10, 2026 at 10:04:48AM -0800, Reinette Chatre wrote:
>>
>>>>>>>> It looks like MPAM has a few more capabilities here and the Arm levels are numbered differently
>>>>>>>> with EL0 meaning user space. We should thus aim to keep things as generic as possible. For example,
>>>>>>>> instead of CPL0 using something like "kernel" or ... ?
>>>>>>>
>>>>>>> Yes, PLZA does open up more possibilities for MPAM usage.  I've talked to James
>>>>>>> internally and here are a few thoughts.
>>>>>>>
>>>>>>> If the user case is just that an option run all tasks with the same closid/rmid
>>>>>>> (partid/pmg) configuration when they are running in the kernel then I'd favour a
>>>>>>> mount option. The resctrl filesytem interface doesn't need to change and
>>>>>>
>>>>>> I view mount options as an interface of last resort. Why would a mount option be needed
>>>>>> in this case? The existence of the file used to configure the feature seems sufficient?
>>>>>
>>>>> If we are taking away a closid from the user then the number of CTRL_MON groups
>>>>> that can be created changes. It seems reasonable for user-space to expect
>>>>> num_closid to be a fixed value.
>>>>
>>>> I do you see why we need to take away a CLOSID from the user. Consider a user space that
>>>
>>> Yes, just slightly simpler to take away a CLOSID but could just go with the
>>> default CLOSID is also used for the kernel. I would be ok with a file saying the
>>> mode, like the mbm_event file does for counter assignment. It slightly misleading
>>> that a configuration file is under info but necessary as we don't have another
>>> location global to the resctrl mount.
>>
>> Indeed, the "info" directory has evolved more into a "config" directory.
>>
>>>> runs with just two resource groups, for example, "high priority" and "low priority", it seems
>>>> reasonable to make it possible to let the "low priority" tasks run with "high priority"
>>>> allocations when in kernel space without needing to dedicate a new CLOSID? More reasonable
>>>> when only considering memory bandwidth allocation though.
>>>>
>>>>>
>>>>>>
>>>>>> Also ...
>>>>>>
>>>>>> I do not think resctrl should unnecessarily place constraints on what the hardware
>>>>>> features are capable of. As I understand, both PLZA and MPAM supports use case where
>>>>>> tasks may use different CLOSID/RMID (PARTID/PMG) when running in the kernel. Limiting
>>>>>> this to only one CLOSID/PARTID seems like an unmotivated constraint to me at the moment.
>>>>>> This may be because I am not familiar with all the requirements here so please do
>>>>>> help with insight on how the hardware feature is intended to be used as it relates
>>>>>> to its design.
>>>>>>
>>>>>> We have to be very careful when constraining a feature this much  If resctrl does something
>>>>>> like this it essentially restricts what users could do forever.
>>>>>
>>>>> Indeed, we don't want to unnecessarily restrict ourselves here. I was hoping a
>>>>> fixed kernel CLOSID/RMID configuration option might just give all we need for
>>>>> usecases we know we have and be minimally intrusive enough to not preclude a
>>>>> more featureful PLZA later when new usecases come about.
>>>>
>>>> Having ability to grow features would be ideal. I do not see how a fixed kernel CLOSID/RMID
>>>> configuration leaves room to build on top though. Could you please elaborate?
>>>
>>> If we initially go with a single new configuration file, e.g. kernel_mode, which
>>> could be "match_user" or "use_root, this would be the only initial change to the
>>> interface needed. If more usecases present themselves a new mode could be added,
>>> e.g. "configurable", and an interface to actually change the rmid/closid for the
>>> kernel could be added.
>>
>> Something like this could be a base to work from. I think only the two ("match_user" and
>> "use_root") are a bit limiting for even the initial implementation though.
>> As I understand, "use_root" implies using the allocations of the default group but
>> does not indicate what MON group (which RMID/PMG) should be used to monitor the
>> work done in kernel space. A way to specify the actual group may be needed?
> 
> Yeah, I'm not sure that flexibility is strictly necessary but will make
> the interface easier to use.

I find your proposal to be a good foundation to build on. I am in process of trying out
some ideas around it for consideration and comparison to other ideas.

...

>>>> existing "tasks" file does but only supports the same CLOSID/RMID for both user
>>>> space and kernel space. To support the new hardware features where the CLOSID/RMID
>>>> can be different we cannot just change "tasks" interface and would need to keep it
>>>> backward compatible. So far I assumed that it would be ok for the "tasks" file
>>>> to essentially get new meaning as the CLOSID/RMID for just user space work, which 
>>>> seems to require a second file for kernel space as a consequence? So far I have
>>>> not seen an option that does not change meaning of the "tasks" file.
>>>
>>> Would it make sense to have some new type of entries in the tasks file,
>>> e.g. k_ctrl_<pid>, k_mon_<pid> to say, in the kernel, use the closid of this
>>> CTRL_MON for this task pid or use the rmid of this CTRL_MON/MON group for this task
>>> pid? We would still probably need separate files for the cpu configuration.
>>
>> I am obligated to nack such a change to the tasks file since it would impact any
>> existing user space parsing of this file.
>>
> 
> Good to know. Do you consider the format of the tasks file fully fixed?

At this point I believe it is fully fixed, yes. For this we need to consider both
how it is documented to be used and how it is used. For the former we of course have
Documentation/filesystems/resctrl.rst but for the latter it becomes difficult.

On the documentation side I also find existing documentation to be specific in how
"tasks" file should be interpreted: "Reading this file shows the list of all tasks
that belong to this group.". I do not find there to be a lot of room for changing
interpretation here.

An interface change as you suggest is reasonable for a file that is consumed by a
human - somebody can read the file and immediately notice the change and it may even
be intuitive. We know that there is a lot of tooling built around resctrl fs though
so we should evaluate impact of any interface changes on such automation. Not all of this
tooling is public so this is where things become difficult to predict the impact so
we tend to be conservative in assumptions here.

There is one open source resctrl fs tool, the "pqos" utility [1], that is getting a lot of
usage and it could be a predictor (albeit not decider) of such interface change impact.
A peek at how it parses the "tasks" file confirms that it only expects a number, see
resctrl_alloc_task_read() at https://github.com/intel/intel-cmt-cat/blob/master/lib/resctrl_alloc.c#L437 
I thus expect that a user running pqos on a kernel that contains such a change to the
"tasks" file will fail which confirms changing syntax of "tasks" file should be avoided.

Reinette

[1] https://github.com/intel/intel-cmt-cat



