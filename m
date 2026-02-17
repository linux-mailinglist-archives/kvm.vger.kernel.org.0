Return-Path: <kvm+bounces-71173-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKbIJsW4lGlmHQIAu9opvQ
	(envelope-from <kvm+bounces-71173-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:51:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A01614F5C8
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 19:51:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9DCC4303EFC4
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 18:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD65372B59;
	Tue, 17 Feb 2026 18:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GQ6Bx5N6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE7428D8ED;
	Tue, 17 Feb 2026 18:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771354299; cv=fail; b=gqgRyPKg9Ej6algeBw9Q3eMtcTY/QXbmtjSlh0nAWq5Mt5olvtev/1LiAIWohdPjZTjXNEYvVet6l/FkCd1m7iaapauB1JHuGK8Juy+GQ1Ww6KI/9zOkbErVuZpd41/q2SdSpiROhWsblGFd8UE39r2ciWJfO0mi7dppahZzKlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771354299; c=relaxed/simple;
	bh=Le7OkLOPMNBAwCzYCfrTlNs6KPrYl9x/d4GTYUsdRbM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oef6emRyDQBuH6o8tS++LCKJ3WyLnvWVQaspwL7L4R77cNYdEhTGA6jaA4z1Rrny9Dvsp9kz+Nzl85YIeca5Cv1xvUbezP4bmhKtE8UwgcjC9y9fXuUJMgzwfxqjT1AxQpcM9H//AdlgyMHzFxJF8dgIEXPcDk5RSm3ho0MLtXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GQ6Bx5N6; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771354297; x=1802890297;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Le7OkLOPMNBAwCzYCfrTlNs6KPrYl9x/d4GTYUsdRbM=;
  b=GQ6Bx5N6wt6ImaxE/3e1vsYeLzj/e85w4QOXyckt9pOishFPq5I0YLjB
   rk0pjHNfA4QNWylmxdfeQslF5BwU8c2k7nbrjyczYnxvGPANzt5JE+HIu
   yLx9/XqpUg7cMQRkRaSO4AAHh9CYVvwq1NaOPQ1z5t2qO98AQxEZxjl4r
   kqbNARe/lu6niN2k6Icw1aBM59fRP2ZrbYlNZz5hIrCFhQ8WYOXsTQoC/
   ncFexFTrr56Uy2jOeVAujHfZb3i9vBZ0X6rRvnkuW2vsP53bj20CUVfS8
   c//XNQNJkapxhEOHeP+Itho70EBHiIQ/ap6WoynnDzZMXCPWsCjWyLj4V
   A==;
X-CSE-ConnectionGUID: G6ga/uyQRnmUvDqZ7hVT1A==
X-CSE-MsgGUID: KnQ4nuNTSEGJk78iXwNa5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="95061258"
X-IronPort-AV: E=Sophos;i="6.21,296,1763452800"; 
   d="scan'208";a="95061258"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 10:51:36 -0800
X-CSE-ConnectionGUID: PyKfvyznQz2qP+dXtbgoag==
X-CSE-MsgGUID: BOFdlNRDQHO0cUliG9BP6w==
X-Ironport-Invalid-End-Of-Message: True
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,296,1763452800"; 
   d="scan'208";a="218107931"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 10:51:35 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 10:51:35 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 17 Feb 2026 10:51:35 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.24) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 10:51:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eR9doTqW8cYXWzo0A5T1rLCrBjjRc94zYt6rNH39JbUhVFGeHNBzNex8zf9Zc5iv9H0+j8bjvBtrJ0Vyz3G8ryQQtAUkEl5pe/lAXAklai62zhn6HLk2+6cfZP9bqPiDjFPgCyGYL/OkkrabL8KEvjI4pETRdQycchWd09sQLe8OWJgA5YIzGkxS5UWMvbsk/Sw6k8IrHRFqAhQosRr2IYfcy4P6i8/INk/XUrNrk5foeDVEK6vCWXoDyufiDL4uSj62F/UIv0U74HGmDf006IevrdCPMtdfbRou53D2JplUgH1hZ92BWN7zvUW7M+aa8gOjZ9mTPmwUnj7DjmHdkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lfD+JPbfn6vqlND5ZbYyoZWsySEFXK6NdAo+aBof4hc=;
 b=Z2Mjq5gMEZ6hANcoRNiKkJN42Ef9qUQ1Hcx4OmDr/9wGpOEqsMg1FeQY+zjDzucFEc9W+wwFP/6QDhZpPfxzTBQZeuzGUY0xdvIw7qgVfcqc9a3l0WedFSjvRn2LIuzgh4rc679XIIIlpiJ3Slz1pHTtBJ+EH/lZ6Qxy9xiuQjjwZ1NEczYXeASE9ewPFmRcgnI9qfbe/h7IDdOOHESAEDknd0boAAAbj7L1Rv0WIqq3+a9ELQnEndwftTsYifMFy+UU5XIl9eMuIU+z+Dq1eTibBA6V/v2uPHg4MnwRCbaTal8IcTaF7LAIVg5KV5NT6PBkSVR0YXIV93YLI3A+9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4815.namprd11.prod.outlook.com (2603:10b6:a03:2dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Tue, 17 Feb
 2026 18:51:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9611.013; Tue, 17 Feb 2026
 18:51:26 +0000
Message-ID: <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
Date: Tue, 17 Feb 2026 10:51:15 -0800
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
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aZM1OY7FALkPWmh6@e134344.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0343.namprd04.prod.outlook.com
 (2603:10b6:303:8a::18) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4815:EE_
X-MS-Office365-Filtering-Correlation-Id: 10a10756-71d1-48d7-d5fe-08de6e558d8d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aDF1YnpJNEhFUzk4WHFQQldjTFdqOGtRbTROU1JKaWFseTFhYzBmZXdRUlls?=
 =?utf-8?B?TFlrdjBUeUhBT3JrRkpWWGJ2Tjk4bTIyQTRtNXBVTjhBc25VWE5HR1VEL0V5?=
 =?utf-8?B?TXVMMktDaUNhVzdMelFoMDhjUkNCRjVUMlgwOVkvVlBCUk81MzAyd3NQck1X?=
 =?utf-8?B?RGMrMndUOGoxN0tPK0trQm5xSG04MWVJRnNpbkd4OEROSy8wUnIwV0Z2azhD?=
 =?utf-8?B?cmljd2dlSFpMUytnWllDY1FKaFNraGdlc01CUENKc1RwRjAvNTZNNVlYd2ND?=
 =?utf-8?B?KzVWNG4vaWtSM0JPNEVST281ZGxVRnNScnJaYnBBaExhcFY1Q3FHL09SemZL?=
 =?utf-8?B?NXpCVE9uN3FMcC8xc3dVY3pkQU5CcFZ0bCtUYkxGUkRIbEdXTnl3UTRsTlZR?=
 =?utf-8?B?VWxDUkJCaHZ2MWJKNkkyRkIyby9CdVE4VWFqVTJxV0NVa1BiTXVoeEFvVjh1?=
 =?utf-8?B?VVBKMDdoZ0VvRVVxTXAxWFB6aVJjZjlFTTBOUGhVc1RIM2tOQ2xvNkFscXRx?=
 =?utf-8?B?NElCMWlRS1JJMWQxOVVPQ2t4VVA2MnkrUEU2MFA2T2VpZ3IrMzFXZnM3bFhz?=
 =?utf-8?B?UVMzMUhBV1QvTTNqSHRwN3h3N2p6ei90citFVzBUUEdqQkdMMkdvaFdTNlh0?=
 =?utf-8?B?SFZ6V09FRXN3RGFycWE0c0Q0SnFUYlBZZnhFOUpjQlJpdGg0bnMrOTJRTW1i?=
 =?utf-8?B?aE52ZmMwakh6T3NZc3BhTnV2QWxXYk5Ma3hyN3JPWU9nVFhJcnoxMHdtTkEr?=
 =?utf-8?B?MWdDQmR3VCtFTS9tb0pwMC9uemoyRFpVRThaeGRzbmFRQmZmT3doQ2l0MVJB?=
 =?utf-8?B?T05ZYStzYU1KQVFja2VJVzE4WDN5NE5WMnVzbnVkUGVuYmtJVHltYU1GNkZP?=
 =?utf-8?B?dkhhdDlFWXlOa2xWamUyUllPOTRSd0hxYkZYck5mVDcxVjlXcitSaDhkR2lI?=
 =?utf-8?B?UmNYbHNob2pLejVhOXh2eHZsOGNraU1hZWJQMXVHcmpZTlVEMm52ZllnODRC?=
 =?utf-8?B?TGFKcHJhdUJnSlBMWUQ0Y2t4QU5HallXb1lrMHgxL0gwQlpiS3RuekhzdkRW?=
 =?utf-8?B?bkdQNjlPZWxWMjBMejk5dmJWK0g1ZjFaWkc1SUV1eExUVFVMbThJOE5DV2xP?=
 =?utf-8?B?S3hjbTQ0RVh1V0QreGdJeVIwamcvaWxLT3BBTnBGSnoyTm4wZTdmbUpId1A3?=
 =?utf-8?B?bmVVVDhuTnNoeUxYZm14K3dMVlVZdlRqeDdGUThiSThEOUozT2x4aVZSUTZr?=
 =?utf-8?B?TWdPSEVpRGszNnlSZlhFdUlEUU4zTzFpcmRPcHJ6RTh5Z1NmUXJQamc0QzJL?=
 =?utf-8?B?b1I4Z2lqUWU0cmZDV3VNdDhMTFN0eHg1a2JKM0x3Y1FMSXB6Tmw2U2QzenM5?=
 =?utf-8?B?VVRxamdDUkJkYUpvNnBIN2JBSjNtb0ZxRktiRXl2SEZ1Rjg2NGRiTHF2NlBU?=
 =?utf-8?B?SzRrY1FSbVFoUEtMRENBZ0RrL1VCdllENXFQc0M5VnhlMENLWDkxQzd2QktN?=
 =?utf-8?B?VjQ4eTkvSnp2eFZYbTFwbTg1TU9qK0hicWMxMHMxa00wYnU4ODNLbk9GSlhn?=
 =?utf-8?B?ckJ4OWtqbUFlT3JTMnROY1pFVzV6WlBsZkJPYkpsa1dKQ21pSno4aVBER1NM?=
 =?utf-8?B?M0FVWWFIS2NqZ1ZIUEhJcFYrUnVHMTlBNU1EdTlvd0VCQnlFMDlvKytiNStk?=
 =?utf-8?B?c21od1VpbXpQYmZrVkxJamh1RldkQ25UN3d2QjdrRWRwbnNGOE00UTIyNnQw?=
 =?utf-8?B?OFJvc1JTSG15U0k2MG9wSlJzZmIvMllOT2RHWHNHNWduVUt6TVQ1ODZhRTVK?=
 =?utf-8?B?cWhTZU1CLzY5QkJqN2ZtRWJEYzhFMGNrb0IrQ1hPOTdYUTVYQ1dzeWhxVHMv?=
 =?utf-8?B?R2lzRUV6UStYNlVFei9CNSs5cnVpSjNLM2FnS0NlYVhXTmZqSnlLdWdYRFFr?=
 =?utf-8?B?UXZwUmF2dWxpNEhxZFpPQTM3Tk8rNk5weXJxbTZiVEc1bWkrcHZ2UFZ5L0pj?=
 =?utf-8?B?akRuczZ5ZUZtc3g5VUZuamJ3VG5FemVjUTlhT21tSUF3SXlBSXROWHVaaTcy?=
 =?utf-8?B?MW4vN0oyNEJ2YWxBOXEyU3JHV0EwMjVKR0RFWGhicVQ2SnF6N0N2d2o5cWpm?=
 =?utf-8?Q?ojwQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzNacllDUG5lRy9aWG9LaHoxbTgvR24rZFVsMzFpcW5xNHVIS0JKMVE4Vjdr?=
 =?utf-8?B?M3ZUQ3l6akwyM055TWo1RVhOY0dLSi9aMGJTbE9tWHJyMUZkd3Z0eEtSektp?=
 =?utf-8?B?aEpma3dWRlNDKzRZd2FQdXNoeGZZWUd2UTdJc1YvNFhoWmR4bHdZRnFUUXRp?=
 =?utf-8?B?c0pQWVBWTjdaQVFaN09KU2pOQUc3ZHVPeFhTTXRkdUZ2L0Z5YVY3VGhlTEdn?=
 =?utf-8?B?dE8wS3JmbVEzNzk1bHg3M1F2V1VhUjZ0SksyNncva1g5TkFPZUpPNkxqbzNQ?=
 =?utf-8?B?dGF2MlB5MTRTUjJLV3lWZVcrTk9YbHBrbFgvL2t5VEFSZDJPZndEMG1FcXB5?=
 =?utf-8?B?L3Y0dGx6dGpBWXJ4SFN1Rng5VWk0N1Q5THJZRzhSZi9TWkxWM0x5SXpTVjla?=
 =?utf-8?B?RjdWWmh0QXRIYWJSeDlMRU9kNUVxY2Fta0RrNm9MYWJ4Ky8wbkN5bFBFdmNF?=
 =?utf-8?B?YVZmbVp2QUdtVzgwMnVscVlCNWd2Smw2bUlwdjQyVGg1Wk5oK0lRM2tzaUFq?=
 =?utf-8?B?WFh6enVmYkUyeHZNeElYUFF2cXJvc0hwQ0VEZmVKZTNaRVRraklEbnJ1Z1lW?=
 =?utf-8?B?TkF1OG8rWmxtQjNBblVPMTJWQzVrOURRZDM5VEJVUy9xak5QN3o2ajBUY1Ra?=
 =?utf-8?B?RmRReVFtVU5sMUV5L0RCWFVOVUFKQndnR2VmaFo0ZWNJK045Q3VZNFFNRW9j?=
 =?utf-8?B?MnBJaVQ5d3dPdkFBNFRueGdybUxQZEhkMTdjNTF4aWgvOGVaQmV0NnE4Q0tM?=
 =?utf-8?B?cW9wRyt2VzhFSkgxeXVnUU04U1d0bENiaTRsN09adDVmcExVdXk0M2lNd3kv?=
 =?utf-8?B?cnBCTkhRWGJLekJSU3RrbWRVM3FuTi9pTzBhR1YwMWdVNW0yWFdzbFRPU3NU?=
 =?utf-8?B?QURoYXpYam93dnB6MkN6a1N5VjRURm5QWDJLb1crbmU5SmVVOU1vUmErSmtM?=
 =?utf-8?B?V0V4WEIvWk1XK2pYQWtFTk9uT3BBR2RyQmIwc3ZOd2htL25iZitFVzNoQ0Yx?=
 =?utf-8?B?V3ZSS1ozNFhmdXZMRFdubWoydld0ZEMrb0ZBc3JSOEFhd01WTjczb1owL2F3?=
 =?utf-8?B?ZkN5SFg2N1FkT2w3K2ZOK0tuSWg4VVpuWjZMejliSzZJV2ZCMUFiQUFCNTIr?=
 =?utf-8?B?MFgrZDVHeEtqME1wa1VVbXFSYjlpNStwVnd5YjAyMVVuYm9YUnJVcFRLeTYr?=
 =?utf-8?B?QnRaamVRTjdtZ201ZXErT1ljeGhPNUFEa2F4OG81bFUya2pEaHZIdTJZa3Nq?=
 =?utf-8?B?cEJ1VXR3U1ZNdlROMXdtWG03T2JseUk2cEkwQklTNy8ycmNURDM3eXBSQzFk?=
 =?utf-8?B?RzM1b1I1dGczZHdOTm1xanAwV2tENS94RUtnQ2hCRktyM2FQM3FtK21kclNs?=
 =?utf-8?B?STNRelpibGh3WEo4NEFlSUdxd05KeEpodnp0c2REUHFuWkQyQjdINnpXVmJp?=
 =?utf-8?B?M0E2UzJNTTRLWEcrRU9PZko3eG5LYjRENWdTVE1XVjJ0UkprWlFTNCtla0sw?=
 =?utf-8?B?YklLUWNHM1Fwa2ZvKzdFaVhoRW1teUQ4cEViVEZSeFdwMU9GcDU3OHY5V3NW?=
 =?utf-8?B?YkY0Q3VpeGtMNVpsOVBxK21mMGpNU25CMG5sR1BtM0poUVZ0andCNlc0ekxJ?=
 =?utf-8?B?TW9Qa3RpMS9rbGtzYVhaUWhJeWkwcnhFb0hiVUh5c2Qrbjc1S3cwTnhlQ0FD?=
 =?utf-8?B?blVPeHNuczM2STBWLzYzRWUwRnVYbXRLcVBRY29FUm5nNncvQ05kenpUK1ZT?=
 =?utf-8?B?c2xheGRiM3VGWnVrRTdicFRUMnczWHFrdDl2blBRZWdsbWg1VFV4aFp6cFBw?=
 =?utf-8?B?QWZhQ3NpK2xGaFI5alVXVGVYTSt5aTdZbTU0b0FFVUs3YUE1cGRLSnJPT3p3?=
 =?utf-8?B?VGVOYnJkTVFrL2p3SStWMCtQalZKdjVyeTMrdU1BdVMzaUJIQTdFTlhhRWU3?=
 =?utf-8?B?Z3Z5VEZ3S3Bab25uWkpZV2dMODUxbFdtekhVOVEyTHJheEhOUnNMQ3JPSkxY?=
 =?utf-8?B?a2Vqa0lBTWtTMmVVVExaKy9xK2tvRXNLaU1ZcGQ0MkVNWlEyMmtmeElBeURY?=
 =?utf-8?B?WGhEc1ZsSHQwOG10aityTXZKNU1nOExXVjZPbkdzNHRRdE91SElmK0JUSkl6?=
 =?utf-8?B?K2M5MUZQUWtFZnlWdFdyUmE3WHZFVENQR0hQOFRzSXpibWxLb1o5eHlaYXdy?=
 =?utf-8?B?K0tBK05KM09nMThudWNoTnZ5cCtZME9IVE9jQjNFNU0xUVZ2SzJxd21MYmo3?=
 =?utf-8?B?UUNwb0tGNFFjWVJMVEx1Q0pnNW9xR1Fqc0RCS05KWXlrTDIwQWJ1S2tTWUti?=
 =?utf-8?B?MkJFRFBMRWl2VnFnaHh2RTV2NUtlRDJZVXhVKzZ6ZXk1SHRzMk5nZXJvaDVD?=
 =?utf-8?Q?SfEbiX6d6k/GChrU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a10756-71d1-48d7-d5fe-08de6e558d8d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 18:51:26.0821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOJjcGhmtBXaIMmWF6q0YtpjNTfPI8YJlrouRHuM9OIml9zPB+XkkQYNIHc6H1PESw43I0iBcKMSBjXiby0fhXXcA9mYaLltpZEVsSDsKI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4815
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71173-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 5A01614F5C8
X-Rspamd-Action: no action

Hi Ben,

On 2/16/26 7:18 AM, Ben Horgan wrote:
> On Thu, Feb 12, 2026 at 10:37:21AM -0800, Reinette Chatre wrote:
>> On 2/12/26 5:55 AM, Ben Horgan wrote:
>>> On Wed, Feb 11, 2026 at 02:22:55PM -0800, Reinette Chatre wrote:
>>>> On 2/11/26 8:40 AM, Ben Horgan wrote:
>>>>> On Tue, Feb 10, 2026 at 10:04:48AM -0800, Reinette Chatre wrote:

>>>>>> It looks like MPAM has a few more capabilities here and the Arm levels are numbered differently
>>>>>> with EL0 meaning user space. We should thus aim to keep things as generic as possible. For example,
>>>>>> instead of CPL0 using something like "kernel" or ... ?
>>>>>
>>>>> Yes, PLZA does open up more possibilities for MPAM usage.  I've talked to James
>>>>> internally and here are a few thoughts.
>>>>>
>>>>> If the user case is just that an option run all tasks with the same closid/rmid
>>>>> (partid/pmg) configuration when they are running in the kernel then I'd favour a
>>>>> mount option. The resctrl filesytem interface doesn't need to change and
>>>>
>>>> I view mount options as an interface of last resort. Why would a mount option be needed
>>>> in this case? The existence of the file used to configure the feature seems sufficient?
>>>
>>> If we are taking away a closid from the user then the number of CTRL_MON groups
>>> that can be created changes. It seems reasonable for user-space to expect
>>> num_closid to be a fixed value.
>>
>> I do you see why we need to take away a CLOSID from the user. Consider a user space that
> 
> Yes, just slightly simpler to take away a CLOSID but could just go with the
> default CLOSID is also used for the kernel. I would be ok with a file saying the
> mode, like the mbm_event file does for counter assignment. It slightly misleading
> that a configuration file is under info but necessary as we don't have another
> location global to the resctrl mount.

Indeed, the "info" directory has evolved more into a "config" directory.

>> runs with just two resource groups, for example, "high priority" and "low priority", it seems
>> reasonable to make it possible to let the "low priority" tasks run with "high priority"
>> allocations when in kernel space without needing to dedicate a new CLOSID? More reasonable
>> when only considering memory bandwidth allocation though.
>>
>>>
>>>>
>>>> Also ...
>>>>
>>>> I do not think resctrl should unnecessarily place constraints on what the hardware
>>>> features are capable of. As I understand, both PLZA and MPAM supports use case where
>>>> tasks may use different CLOSID/RMID (PARTID/PMG) when running in the kernel. Limiting
>>>> this to only one CLOSID/PARTID seems like an unmotivated constraint to me at the moment.
>>>> This may be because I am not familiar with all the requirements here so please do
>>>> help with insight on how the hardware feature is intended to be used as it relates
>>>> to its design.
>>>>
>>>> We have to be very careful when constraining a feature this much  If resctrl does something
>>>> like this it essentially restricts what users could do forever.
>>>
>>> Indeed, we don't want to unnecessarily restrict ourselves here. I was hoping a
>>> fixed kernel CLOSID/RMID configuration option might just give all we need for
>>> usecases we know we have and be minimally intrusive enough to not preclude a
>>> more featureful PLZA later when new usecases come about.
>>
>> Having ability to grow features would be ideal. I do not see how a fixed kernel CLOSID/RMID
>> configuration leaves room to build on top though. Could you please elaborate?
> 
> If we initially go with a single new configuration file, e.g. kernel_mode, which
> could be "match_user" or "use_root, this would be the only initial change to the
> interface needed. If more usecases present themselves a new mode could be added,
> e.g. "configurable", and an interface to actually change the rmid/closid for the
> kernel could be added.

Something like this could be a base to work from. I think only the two ("match_user" and
"use_root") are a bit limiting for even the initial implementation though.
As I understand, "use_root" implies using the allocations of the default group but
does not indicate what MON group (which RMID/PMG) should be used to monitor the
work done in kernel space. A way to specify the actual group may be needed?

>> I wonder if the benefit of the fixed CLOSID/RMID is perhaps mostly in the cost of
>> context switching which I do not think is a concern for MPAM but it may be for PLZA?
>>
>> One option to support fixed kernel CLOSID/RMID at the beginning and leave room to build
>> may be to create the kernel_group or "tasks_kernel" interface as a baseline but in first
>> implementation only allow user space to write the same group to all "kernel_group" files or
>> to only allow to write to one of the "tasks_kernel" files in the resctrl fs hierarchy. At
>> that time the associated CLOSID/RMID would become the "fixed configuration" and attempts to
>> write to others can return "ENOSPC"?
> 
> I think we'd have to be sure of the final interface if we go this way.

I do not think we should aim to know the final interface since that requires knowing all future
hardware features and their implementations in advance. Instead we should aim to have something
that we can build on that is accompanied by documentation that supports future flexibility (some may
refer to this as "weasel words").

>> From what I can tell this still does not require to take away a CLOSID/RMID from user space
>> though. Dedicating a CLOSID/RMID to kernel work can still be done but be in control of user
>> that can, for example leave the "tasks" and "cpus" files empty.
>>
>>> One complication is that for fixed kernel CLOSID/RMID option is that for x86 you
>>> may want to be able to monitor a tasks resource usage whether or not it is in
>>> the kernel or userspace and so only have a fixed CLOSID. However, for MPAM this
>>> wouldn't work as PMG (~RMID) is scoped to PARTID (~CLOSID).
>>>
>>>>
>>>>> userspace software doesn't need to change. This could either take away a
>>>>> closid/rmid from userspace and dedicate it to the kernel or perhaps have a
>>>>> policy to have the default group as the kernel group. If you use the default
>>>>
>>>> Similar to above I do not see PLZA or MPAM preventing sharing of CLOSID/RMID (PARTID/PMG)
>>>> between user space and kernel. I do not see a motivation for resctrl to place such
>>>> constraint.
>>>>
>>>>> configuration, at least for MPAM, the kernel may not be running at the highest
>>>>> priority as a minimum bandwidth can be used to give a priority boost. (Once we
>>>>> have a resctrl schema for this.)
>>>>>
>>>>> It could be useful to have something a bit more featureful though. Is there a
>>>>> need for the two mappings, task->cpl0 config and task->cpl1 to be independent or
>>>>> would as task->(cp0 config, cp1 config) be sufficient? It seems awkward that
>>>>> it's not a single write to move a task. If a single mapping is sufficient, then
>>>>
>>>> Moving a task in x86 is currently two writes by writing the CLOSID and RMID separately.
>>>> I think the MPAM approach is better and there may be opportunity to do this in a similar
>>>> way and both architectures use the same field(s) in the task_struct.
>>>
>>> I was referring to the userspace file write but unifying on a the same fields in
>>> task_struct could be good. The single write is necessary for MPAM as PMG is
>>> scoped to PARTID and I don't think x86 behaviour changes if it moves to the same
>>> approach.
>>>
>>
>> ah - I misunderstood. You are suggesting to have one file that user writes to
>> to set both user space and kernel space CLOSID/RMID? This sounds like what the
> 
> Yes, the kernel_groups idea does partially have this as once you've set the
> kernel_group for a CTRL_MON or MON group then the user space configuration
> dictates the kernel space configuration. As you pointed out, this is also
> a draw back of the kernel_groups idea.
> 
>> existing "tasks" file does but only supports the same CLOSID/RMID for both user
>> space and kernel space. To support the new hardware features where the CLOSID/RMID
>> can be different we cannot just change "tasks" interface and would need to keep it
>> backward compatible. So far I assumed that it would be ok for the "tasks" file
>> to essentially get new meaning as the CLOSID/RMID for just user space work, which 
>> seems to require a second file for kernel space as a consequence? So far I have
>> not seen an option that does not change meaning of the "tasks" file.
> 
> Would it make sense to have some new type of entries in the tasks file,
> e.g. k_ctrl_<pid>, k_mon_<pid> to say, in the kernel, use the closid of this
> CTRL_MON for this task pid or use the rmid of this CTRL_MON/MON group for this task
> pid? We would still probably need separate files for the cpu configuration.

I am obligated to nack such a change to the tasks file since it would impact any
existing user space parsing of this file.

> 
> If separate files make more sense, then we might need 2 extra tasks files to
> decouple closid and rmid, e.g. tasks_k_ctrl and task_k_mon. The task_k_mon would
> be in all CTRL_MON and MON groups and determine the rmid and tasks_k_ctrl just
> in a CTRL_MON group and determine a closid.

This is possible, yes.

>>>>> as single new file, kernel_group,per CTRL_MON group (maybe MON groups) as
>>>>> suggested above but rather than a task that file could hold a path to the
>>>>> CTRL_MON/MON group that provides the kernel configuraion for tasks running in
>>>>> that group. So that this can be transparent to existing software an empty string
>>>>
>>>> Something like this would force all tasks of a group to run with the same CLOSID/RMID
>>>> (PARTID/PMG) when in kernel space. This seems to restrict what the hardware supports
>>>> and may reduce the possible use case of this feature.
>>>>
>>>> For example,
>>>> - There may be a scenario where there is a set of tasks with a particular allocation 
>>>>   when running in user space but when in kernel these tasks benefit from different
>>>>   allocations. Consider for example below arrangement where tasks 1, 2, and 3 run in
>>>>   user space with allocations from resource_groupA. While these tasks are ok with this
>>>>   allocation when in user space they have different requirements when it comes to
>>>>   kernel space. There may be a resource_groupB that allocates a lot of resources ("high
>>>>   priority") that task 1 should use for kernel work and a resource_groupC that allocates
>>>>   fewer resources that tasks 2 and 3 should use for kernel work ("medium priority").  
>>>>   
>>>>   resource_groupA:
>>>> 	schemata: <average allocations that work for tasks 1, 2, and 3 when in user space>
>>>> 	tasks when in user space: 1, 2, 3
>>>>
>>>>   resource_groupB:
>>>> 	schemata: <high priority allocations>
>>>> 	tasks when in kernel space: 1
>>>>
>>>>   resource_groupC:
>>>> 	schemata: <medium priority allocations>
>>>> 	tasks when in kernel space: 2, 3
>>>
>>> I'm not sure if this would happen in the real world or not.
>>
>> Ack. I would like to echo Tony's request for feedback from resctrl users
>>  https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/
> 
> Indeed. This is all getting a bit complicated.
> 

ack

Reinette


