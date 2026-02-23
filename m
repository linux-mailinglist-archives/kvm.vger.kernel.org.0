Return-Path: <kvm+bounces-71545-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id zX/ZECTfnGnCLwQAu9opvQ
	(envelope-from <kvm+bounces-71545-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:13:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F5517F054
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:13:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 02D4A302FFC5
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B57937E315;
	Mon, 23 Feb 2026 23:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O3OwN8G+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A72137E2FF;
	Mon, 23 Feb 2026 23:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771888415; cv=fail; b=nXdHChiLjTshQKAEsRnRgXiKix/cnqVBGGjh/zRZllytLS625RZQjpsHFOCyxmAUMti1jV2jiYCtiaIVlwO5lbOiXzKbOU05xRp95+gWdc6wrgs5732U5kUpO9OCcJ4MQ3Sf/AB+RQUnrF6xBcG6d4M2YmfN1UFPXAxelFe2HgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771888415; c=relaxed/simple;
	bh=R0YmWzu6q/4paS/MJh+yHSlRWvIqqxcf3r2NiYSFYkY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pEzditUiDu7gxApb9ok3WTLCW9ZDv/KrcFY1m9zO66O8yXYy9VwEMo7/ymex42JpjzO7ES0UMTlte5Itkj0AKAicXx+whyPtOSwKFyoAMu3R6RiIn+6ePvuerP+t0KHJp/4gx5Z1C4a9e/OwIBmbkGESrt4U96hGq55b7TL+AYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O3OwN8G+; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771888414; x=1803424414;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R0YmWzu6q/4paS/MJh+yHSlRWvIqqxcf3r2NiYSFYkY=;
  b=O3OwN8G+ZbeQef4bdVpYBJpNKbtglwEoW3w9uubjACuIo65X6CnSxu9n
   qr+nJ0MpPikpLWdnarQS7cSR8rO0aJfvrGGFWAse25WCsiWkbN7qV3wOR
   B5HGoLGnTwrwgX2PVhW/E6PwHoOmnF7CPx558TFEQxcZnFIrN9oc4cc+K
   WJ8zPshvNTkyZEVuiUSuPnD15xXNKWJA4+hdFmwqd076Q6T5/JFw9Ct9U
   SRg4N8+EXA5UqAlrfy3cICA1RZqq+/pLnmVbKX2XokY8eKHJBQueAc8lZ
   2jrFiX/6NXI64hJeUoEk9lMbXWiGcGD823BKWVnJecMkNJIEMZPAFDlO/
   g==;
X-CSE-ConnectionGUID: GM1ytleiRIaU3Noj7vXO8g==
X-CSE-MsgGUID: VZvBDermRcO5CmqJ+0HD2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="76758195"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="76758195"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 15:13:33 -0800
X-CSE-ConnectionGUID: y85QN1drSmeXVcGg0E8uuQ==
X-CSE-MsgGUID: RxzeGLAuSmSauyEbFSk+eA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="214572268"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 15:13:32 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 15:13:32 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 15:13:32 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.9) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 15:13:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xh4iWT5Yrz7V8dcqMiWgMs4Bv6LGXjbYtESB1aCH8837xHD6q0qjufes6NzVT09HvLDmFAmcZLfxGPhxvtVxIArVsbvZIwhQIbxT0dJotOD8eDDQQGffjlypuT2LvS/vM4GGinP198EBGB6BbIDXYrt24TpyjrFZzcFO5i1+3Hj02IdeDEwHZ/gUhqaMAMvNBMhXSBT4olnieu3L3rmlqordfxrnvmmWJfBUEROiA9y9N+W0roXhriWhD13oAewrvtxdaF2dtSdq/hqVvmKVdjPeGuGCq/65snHqEbS/FTYSD+VAHnGyyXcqPR1NU86IE2yqNGpALbkXNCpY+W2Wig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OVSTLDyA3DQMInYFHxNwA2e2PT8ZHMBRFbKU3mVurs4=;
 b=xdnwuz2dt8haBjd6deeyUXL/0gDcq48WYiRSkhtyV+xNdcN2+w/prYVXZ7UGdJmP9/H1YZf6eXemJEO+LfAjm3yaiRvEPgx7+ByyoWObDTr3rcF4tiBZCUSuwCVp9LElt9fxR8yj4lj5u9ErdK9f1iWubKXCIJP4ZAjjRgau9+w4gqUrdv6x4TgzKAP1lACIYbnpkEK9AG6gquIBEpPnjI2/dwDd/G2vBUMr3ic2znktuYIft9kbmZBMjuERieV88ZFbwFKuJlBDkKNmDKjJXtJsiAJdqHpZUw0s02T3ZvE5G6A+QFESh491bI9q+tfvQk/MOrfmv9AKSxDCn2MfGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8861.namprd11.prod.outlook.com (2603:10b6:208:59a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 23:13:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 23:13:28 +0000
Message-ID: <0645bba3-6121-41d4-b627-323faf1089b7@intel.com>
Date: Mon, 23 Feb 2026 15:13:24 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Moger, Babu" <bmoger@amd.com>, "Luck, Tony" <tony.luck@intel.com>, "Ben
 Horgan" <ben.horgan@arm.com>, "Moger, Babu" <Babu.Moger@amd.com>,
	"eranian@google.com" <eranian@google.com>
CC: Drew Fustini <fustini@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
	"Dave.Martin@arm.com" <Dave.Martin@arm.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
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
	<peternewman@google.com>, "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
 <aZTxJTWzfQGRqg-R@agluck-desk3>
 <65c279fd-0e89-4a6a-b217-3184bd570e23@intel.com>
 <aZXsihgl0B-o1DI6@agluck-desk3>
 <2ab556af-095b-422b-9396-f845c6fd0342@intel.com>
 <427e1550-94b1-4c58-828f-1f79e5c16847@amd.com>
 <37bc4dc5-c908-42cd-83c5-a0476fc9ec82@intel.com>
 <53be07ff-75c6-4bd6-a544-e28454b4f6b3@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <53be07ff-75c6-4bd6-a544-e28454b4f6b3@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0242.namprd03.prod.outlook.com
 (2603:10b6:303:b4::7) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8861:EE_
X-MS-Office365-Filtering-Correlation-Id: 5453673f-a027-4c0c-e062-08de7331274d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RGhXcWFTcmRSNlNvTC92UnVUZHl2WHEvUVpXY0Q0LzgzMG4vV3RkV2h1d3lm?=
 =?utf-8?B?MDhSL2liazBoZjJ2R0FKR0NFamxtTjNvdWdJQlpKVU1uMkZ1SWt3clYzcTYv?=
 =?utf-8?B?N0xTRmM3djNOV0dneFl4QkhLR0dkaSs1ekhZNVVXV0dXQzNzTkhOVTl2M0ZY?=
 =?utf-8?B?OGlXT1NHY0pOL0hxSDVMdStRV21rZGw3NHNoUGl1bm5yak90THJuSDZsai80?=
 =?utf-8?B?aGlBSUtFUzhEUTh0dStIci9jMEFicTVhTG9CVGNSdER1dmVYMFh2RjVleERZ?=
 =?utf-8?B?RVdFZDdQR20rbkZkekdNZm11SmJOOTFyY3hoS1FjUStQMVVqc1oySjgvcFIz?=
 =?utf-8?B?dWxNVndTUEhITDBPRkRVcDNwVUlUbGxSbXg3NHZGRlEwR2QySFNlNFQ3Tzgx?=
 =?utf-8?B?RUZBUzVVVXdVVHVuSVZ6V2NESUpBaXFwcmlPQ1NLS2Jkb3hPSGh4SEY3cWN6?=
 =?utf-8?B?TUp6Nmh4alozYmtTdjc4MU5aazN1VnFWcXhUSVFEbU55ZUp5QWhoSUdraVZz?=
 =?utf-8?B?ZjZHaHMvS0F1NDlGbUFRT3pXQkZpV3U2emQ1VmxpTHRoa3hwajhHcVNyek1X?=
 =?utf-8?B?a2dFQjhwRGFVTFVnQnNzcklaL0NWcGZQUzVOaXQ2Q0EwTE51Mml3NkNRZ0ZD?=
 =?utf-8?B?QWcyaWFFbEJieVhWS0w5RzljRG0vaUo5RGprZmpoZDlmMHp4MVRHcWJVRUdp?=
 =?utf-8?B?SlNjZjBIa0tNOVp5ZlFFRFIyYWh0RmgrbHoxcHVTdUxkOHNScFd4MjdvTjBX?=
 =?utf-8?B?UjlIV0NFQXhtamZZZmxOWHBidUlNN0o5QzFmSzF4ZENZdFpLMEhyb21UcUFP?=
 =?utf-8?B?UmxoY1d4Qk44dW5zVnovU2J2b0NwcEVpalRUeWQzaENpdFV5Y3U2SEYxYm51?=
 =?utf-8?B?bnBTZS9tRVpvcVRrNTNjVXUxTjRKSjZKcEdSVEprS2xNQUNWVkxhZEhNbWNy?=
 =?utf-8?B?eTJQUEYwc0hvWTA0TVpRUTVXZXNRRXk0c3FxMzF1MU1Ld0xVUTZiYWQremhi?=
 =?utf-8?B?aldKWEpHd0RYWVk2WEMvdW15elJMZnFOQW90Y25veWVYWjBRZDBrY3VDbkJM?=
 =?utf-8?B?eTMxN2IydjFIWTVob1lqRTFJN05qUW5UOWNxT2t2QmYrQ1pqUGRxaGRXMWZL?=
 =?utf-8?B?bjN6WVFlNW1iNzV0bnRabEZ1cWlzV0ZFQ2ZoN1BxM01rYzhIWGR4OEpIK29E?=
 =?utf-8?B?T3BGM2FqbFZkWE4vOSsrNVhhOWFhQUpvamM0bmVTTWg1ZG9talNjcnRkZmcz?=
 =?utf-8?B?WDhGS2J6elEzY2RtcmtTWWJ2R2hrQXJmL3ZFaGdNMFJ0TUhWcnNhZVlxQUVL?=
 =?utf-8?B?OWlrT21QVTJnVGR5bS9XMVgzdzN6NU1HVVZaTHF2YlMxMkRRZkZPQ0d4a2pP?=
 =?utf-8?B?eXBjb0RlSGhOKzJOODZoS2xHOVFoZG04S2ZHdlVKc3FrcUhTcUd5ZVg3VDZ6?=
 =?utf-8?B?RzdNQjcxQXo0eU05Um5JUWJIUTJ3V0x1ZjRGOGYxTk9yRVg2ZG1uTER6TTZw?=
 =?utf-8?B?VDhjUms0dDRCUGFPOElWWlQvWUJKSFhYb2lNSGFOYlpyaStYR3pVN29uVXND?=
 =?utf-8?B?U2lXMHh3dmhwSHJ1TWhBeWdMQjhtREhzMmN0N1c0S2tNQnEyaUI4Z2JhU1Iz?=
 =?utf-8?B?YXA2bTNlTGtMMWFBUmVyaTFreUdXdWJTdE5Zdys1SVlZTVJrTEdnZjVyR21F?=
 =?utf-8?B?Sk85RXhQK0hyTzN3dVVpTHZjNXZXMmFJQ3FSL25sb2lnZjBKOXl4NFUyMmEw?=
 =?utf-8?B?VkFuM2JDbjRnekJPbGZpMVUvOVo3WlhBSkpxSUpuQUIyaW9vdUg2d1dLVXhK?=
 =?utf-8?B?Y25TVE5zdzhTQWY3OG8ydEtLdExXbmJiVFB6SFM4TGtIajRyTkdxcFZCQks0?=
 =?utf-8?B?V1J4MkZsNStBWnUyYURSWGtBVDgrdVVZSWFrVlFXNjFSYWJ1K2xLbk9BdDdE?=
 =?utf-8?B?UkF2cjU3b2psdXB1NEVMN25UeW9JdStweHlMU0IwS0RZSndxTWdBd3RQK2I4?=
 =?utf-8?B?eDdaNDFxTWFLT25aTi9UbEUvelVXWWhocDl0ZnVyM00vSmdCKytKajk3Y1dR?=
 =?utf-8?B?N0l2cHVmOGVQcTcxTTNxT0hYKzJ2S1VLVDRUbnh0SkJvWmZkOWRXbFN0U0Nz?=
 =?utf-8?Q?qO+61F0L42LVNQf52TgQBGrKz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVF4Y051UlNMQ25HSXhUbTBubk5FSHA4TFZFK0RmSzRVT21PRmk0emhKZ1dK?=
 =?utf-8?B?cDFQS01rMU5OdDk3SS9kNHgxWE1Rek1zMEdIV2NWY3VYZUQvOFh5ZzYvaGsw?=
 =?utf-8?B?NUdVb28xa3hRY1VNaGVPSUpHMG1WdFUvWWxONEkzVGFzdjQvYXloWlNHUlBK?=
 =?utf-8?B?UDZza2xteTFrTnc2cElRREtpY2o3NEFjZmVrYnl3TGJOWHBkMlFuZE1ZNHRR?=
 =?utf-8?B?VlBCbm1LaTQ0Ty91VTdockNSWGFuZ2RaMksxLzBScVk0NERmbmlLWkM2bGtQ?=
 =?utf-8?B?VnFNS3g4cHpBdEtNUis3MjVSOTM0SjRvcTV6WGR2a3lkWXlIc2ViS2wwU01K?=
 =?utf-8?B?SUUwOUsyMFlsdFN0NVR2T2hGOXl6MmJwQkpNYW1TZ2RnYkhiTlNYcTVXTVI5?=
 =?utf-8?B?eXhuTlUzeTJEVThqYXVINGl6eWljSHNsSENaVlpzYk15WHpmVkRhSXZobzRJ?=
 =?utf-8?B?SmRvb0tGOUJaSGtXa2M3QUhhZ2Z4ZDFrMGJxMDdxR0hzS0tjOExubXVvdk5H?=
 =?utf-8?B?MUtEckdZbkFXWThkNDkvQWVpUUc5UHJIZ1ROaE1uVkdlNjZMVjhMb1NVb3NZ?=
 =?utf-8?B?U2JZemp4QmlhdWNQYlJtL2VJUGk3RzA4RVlNTlBPMHVNOVNGbzJtUVdmUmM5?=
 =?utf-8?B?TU9sQ3A2OHJZTFhiVG51M0cxSmxHaW4yQUhuRE9FOXd2QVNsOWh3djJHY1di?=
 =?utf-8?B?M3NDUllXa2lNTUQ3YUkrRm8vRG4xMVBlM2lDSWlWckJncXFBL2Yydko4cmh4?=
 =?utf-8?B?TkM5eHhGbGEvUmF3VXlVY0g1RXhxS3hBRHZBOW5kQnZGcVd0MC9xakJrMHFH?=
 =?utf-8?B?Q1hvZTBsWWlBcG9UMkdYb1JVSXdDeVNhVEN2d3lXMWVwRktlUGlGR052Z1N3?=
 =?utf-8?B?Z1FRdFNBUndiR09Rb2lRbG1UVDJ0a3NlN1ZEVUQ1b1pBWlFmZ1JvSU0vOWIr?=
 =?utf-8?B?T2l2MkZVQ0JTMmQzNkJkTDY2dDgwOThvd1laNmVkZzVxSE42cGMzQzR3ZGls?=
 =?utf-8?B?ZEx4Y2JpNlNpMFQ2RW9hWDIxaGFhNVFCRUZJZm04bDRIOTdPMTE0MUN6SVE0?=
 =?utf-8?B?QjhWb2VSQ0VSRTU4NTdWcVhSOTMxWWozL1hVQzg3WW1xdWQyMDgzOXhwQ0Vu?=
 =?utf-8?B?SlByeVhRcVNhUE5aRVljRGV2bzdSUzNGcm1DM2VRdWFYRkZER09zNzlpMGJl?=
 =?utf-8?B?RE5KbDZaRTFNb1l5d1JXL3haRFZKVlMwWTc1WEJiSzcwM2lVbGx6R2NJM29l?=
 =?utf-8?B?YkFldElsUGhYNEhIK3dJWGluRFFrZmNHMWhoSTFvTzRXeXZheGRka3RxaEZM?=
 =?utf-8?B?alFVc0JCQ0t3c0RhZGkwZHlBWUIrZzE0dERpaDI2S0cxUElLQ2RjNmd0UzZ0?=
 =?utf-8?B?S0NsUkkvU3V6RThRNVlCaGl6Sk4zUGkxZUJxaVA5V1NzM0JYWmlJMGx6QUZk?=
 =?utf-8?B?ekhOVXNWbkFLWUZrM2NYWmF3cW9VM2ZSUGRwcFVPeFowVnBBYXErbVg2U1ZX?=
 =?utf-8?B?Y2p5YmtTcnBDaGkyRjY5STJNUEdPRytIZ3I1N1lkb1BpRnNwSExodUhhU3lM?=
 =?utf-8?B?S2JoYkpVdmE5aS9IZ3B6WmpEUmZreVJtOG9DMVVRVkNXNHEwL3JtcjJsZ3pw?=
 =?utf-8?B?QlhNeXBDWnJjdGk3M0dzR2w5ZzFsdHEvRWZQa1prMlVVOVd2dlFiWlB3eDUz?=
 =?utf-8?B?RHMwTkVuaW1vbHY4cHJrZ1FLZFF5c1ZlWEJ2ZmFrdEJhZnhIYUlwMVFSVzc0?=
 =?utf-8?B?NGNyU0JpemJ5S0l1Y1pTUmw0Z0ZmSjZBMGZUOU9KeXdVa3BRYTQ4MFA2Q2Jp?=
 =?utf-8?B?Q0YrSDVERHh1U09JcnYwanUyUjNsTlBZSnE1UE0yMGUrTGdjSzBCNm9XbnR4?=
 =?utf-8?B?RWJibVpobTB4dENBQkxtNUFXREd5Vi9UQ052NkVpY0JqUjN6QnE5UU0wRU9o?=
 =?utf-8?B?bzBnK2NsOXRXZTRzTUNqVUZWOGN1cTZqZXA0NWxCQ1Z3dVc1L1VXdnRvTVNM?=
 =?utf-8?B?cTJ4QTUxWlJ6aFJOQS9nOTNYWXNpNHZLbHdKRkdFU0JrbDI0TGk3VEpkNG92?=
 =?utf-8?B?TXIrTFhnd2ZEZjFYME8xMXAyTkFoZURMa3RRMjIvdlVjVjdsUy82OGl3L1RT?=
 =?utf-8?B?dG5ReE4vNW1ZbmdsNkZnMC9zUUYzY29UeGFST09HZjJzcWxrZmQxZXN0SXF5?=
 =?utf-8?B?K05NbjMwUjVsd0wxUTdIMlY2cE85OVl4eXQ2eTQyeENGQy9XRjZKWW53a0Jo?=
 =?utf-8?B?MU5EMkZqb0VkSmdsTjBxaC9zVnlZcmFlWTlEZzNJcVU0S3VPSVpKR3VieDBt?=
 =?utf-8?B?cm40WXoxRHo5Z2FocEpLL2N0WGw2QmNZWW9UU0ROMkVZSnUzN2drcWpJdnd6?=
 =?utf-8?Q?roElNJPgCn20U+4o=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5453673f-a027-4c0c-e062-08de7331274d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 23:13:28.4787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mWxfZDagLZakKLf1yV+RoVnqR8jIcj+aT8QCWlGQL1rRUkX+QFmt/O7tFAKUVeq4Nm2ZZYUEnIEzhrkrGZTslCCscrDO9lE0l1DZBZDm2QI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8861
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71545-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: B4F5517F054
X-Rspamd-Action: no action

Hi Babu,

On 2/23/26 2:35 PM, Moger, Babu wrote:
> On 2/23/2026 11:12 AM, Reinette Chatre wrote:
>> On 2/20/26 2:44 PM, Moger, Babu wrote:
>>> On 2/19/2026 8:53 PM, Reinette Chatre wrote:

>>>> info/kernel_mode
>>>> ================
>>>> - Displays the currently active as well as possible features available to user
>>>>     space.
>>>> - Single place where user can query "kernel mode" behavior and capabilities of the
>>>>     system.
>>>> - Some possible values:
>>>>     - inherit_ctrl_and_mon <=== previously named "match_user", just renamed for consistency with other names
>>>>        When active, kernel and user space use the same CLOSID/RMID. The current status
>>>>        quo for x86.
>>>>     - global_assign_ctrl_inherit_mon
>>>>        When active, CLOSID/control group can be assigned for *all* (hence, "global")
>>>>        kernel work while all kernel work uses same RMID as user space.
>>>>        Can only be supported on architecture where CLOSID and RMID are independent.
>>>>        An arch may support this in hardware (RMID_EN=0?) or this can be done by resctrl during
>>>>        context switch if the RMID is independent and the context switches cost is
>>>>        considered "reasonable".
>>>>        This supports use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>>>>        for PLZA.
>>>>     - global_assign_ctrl_assign_mon
>>>>        When active the same resource group (CLOSID and RMID) can be assigned to
>>>>        *all* kernel work. This could be any group, including the default group.
>>>>        There may not be a use case for this but it could be useful as an intemediate
>>>>        step of the mode that follow (more later).
>>>>     - per_group_assign_ctrl_assign_mon
>>>>        When active every resource group can be associated with another (or the same)
>>>>        resource group. This association maps the resource group for user space work
>>>>        to resource group for kernel work. This is similar to the "kernel_group" idea
>>>>        presented in:
>>>>        https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/
>>>>        This addresses use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>>>>        for MPAM.
>>>
>>> All these new names and related information will go in global structure.
>>>
>>> Something like this..
>>>
>>> Struct kern_mode {
>>>         enum assoc_mode;
>>>         struct rdtgroup *k_rdtgrp;
>>>         ...
>>> };
>>>
>>> Not sure what other information will be required here. Will know once I stared working on it.
>>>
>>> This structure will be updated based on user echo's in "kernel_mode" and "kernel_mode_assignment".
>>
>> This looks to be a good start. I think keeping the rdtgroup association is good since
>> it helps to easily display the name to user space while also providing access to the CLOSID
>> and RMID that is assigned to the tasks.
>> By placing them in their own structure instead of just globals it does make it easier to
>> build on when some modes have different requirements wrt rdtgroup management.
> 
> I am not clear on this comment. Can you please elaborate little bit?

I believe what you propose should suffice for the initial support for PLZA. I do not
see the PLZA enabling needing anything more complicated.

As I understand for MPAM support there needs to be more state to track which privilege level
tasks run at.

So, when just considering how MPAM may build on this: The PARTID/PMG to run at when in kernel mode
can be managed per group or per task. In either case I suspect that struct task_struct would need
to include the kernel mode PARTID/PMG to support setting the correct kernel mode PARTID/PMG during
context switching similar to what you coded up in this initial RFC. MPAM may choose to have struct
task_struct be the only place to keep all state about which PARTID/PMG to run when in kernel mode
but I suspect that may result in a lot of lock contention (user space could, for example, be able
to lock up the entire system with a loop reading info/kernel_mode_assignment) so MPAM may choose to
expand the struct kernel_mode introduced by PLZA to, (if kernel mode is managed per group) instead
of one struct rdtgroup * contain a mapping of every resource group to the resource group that should
be used for kernel mode work. This could be some staging/cache used between user space and all the
task structures to help manage the state.

I do not know what MPAM implementation may choose to do but as I see it your proposal 
provides a good foundation to build on since it establishes a global place, struct kernel_mode,
where all such state can/should be stored instead of some unspecified group of global variables.

Reinette

