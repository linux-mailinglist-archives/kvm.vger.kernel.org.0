Return-Path: <kvm+bounces-69419-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uBJOGfSHemkE7gEAu9opvQ
	(envelope-from <kvm+bounces-69419-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:04:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC60BA95EE
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 78840304C63B
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 22:04:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5FE342C9D;
	Wed, 28 Jan 2026 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TSDosQMa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709F72F2607;
	Wed, 28 Jan 2026 22:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769637850; cv=fail; b=fh/VolNWcuyW2KzyevC+5QmnEIgF0rv+u7sq4yx9qhp8aOrRG+42RxB4Qwpg6Hk/5j9ocCTX4ev+YRg2hGilCEpM9szsfJp61l0R/dt2dwxwPK3IAU77jvoGCHj15DyT9iq36GGoZelSWRBSov0thX/oRAMXVNErDgcjlEavWds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769637850; c=relaxed/simple;
	bh=fxn1hPAsnN5SE6WQqn55kNSi/o/iMSgFMGQwqyzD1zo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rCGu6Yo7QosaQxm0Zu3n6iC1LqAL7t4//7U33uGpmqGNee6dYoAVCia1qbKvqEHVwbiapIQv3YcA2E9fPa60KZp3ltifJTFm1/TY96KoOru2KMJt3/RhGTlhNiLaXnlZ+u/GV7rvbVsVWYvm/pmiHzQGA2w61+HfqvfekjbuqXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TSDosQMa; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769637848; x=1801173848;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=fxn1hPAsnN5SE6WQqn55kNSi/o/iMSgFMGQwqyzD1zo=;
  b=TSDosQMaxUoi7CZD8wRBpBSXI/H2e8O5KpfWbRIPrkW1ncwtTk/FVm0z
   wramvv5bThLPVgPN0D/RP0Tsd+7hNsGWAFiyd3QnZAdbBS6/foMUWu7Lo
   /HCqlBQ+gp92ABAsEC/sjTjM2LtUlXYc+Gc9Tu61Lx+q+t4aWQNft9VU1
   IEwRJe1EnYlxncpXFTLjMPPuqN/NPFx7NZCjqj8pSWzD3m6HR8m6HQ8V3
   UF3cSJUY58cyuxiVlNVTLI4h15+4CdMuk/GBxFaQFctkT2udFQ9Sesdqi
   Xo5VvnzmJW250OHc8z7i0/AOKXDbrVaEJgzsOpoz2Le+PGuTm7kvwoIk6
   w==;
X-CSE-ConnectionGUID: Qg+ICA4nQ2Oe43QUdusGOA==
X-CSE-MsgGUID: 9quRNUf4S9yn1kas44VY4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="69878792"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="69878792"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 14:04:08 -0800
X-CSE-ConnectionGUID: ZK1+FFSCQZWFDmDsXaWNgg==
X-CSE-MsgGUID: elQUZ9vkRCuhNrq77h3yHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208815970"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 14:04:07 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 14:04:00 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 14:04:00 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.5) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 14:03:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R/W27I5gS85MFD06KMK6PlWhQMFHjmDVBiNINfJ5ki76Dad37E8t64kQjTDNcOVf/4OsF9ZfOj3+0QEJG7Cw4FogCmA+kJfuIbjniaU5S7USYpzOgwl+3s3viB51EaroKlx/yYRASa/UfI/yhd2In8Xsl2gNeKEGiGXrgYJ6wyX4m/lYl+UAHqWCvEtEKJSQ3ToLf3NqBJR7gxxdg1hKwcLfWe6qtF5++eDKOMSTSsFfbv2dg0DunS0lhLgXnWcYb5KWYJJx9Mv69WynQqJdWTXXfyn/ijBJWbgZtYyDgQp4/gmlMCcmWOS91tviUGX7xQm9fMdTLrjexXwDr3E2UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QcLrGV4uhZHTGO104/+f1bKbrTDVhKq4aMhk9Evd2c=;
 b=VnYak2fEU+Pzfpkr7Sy3F2QBtD02uEzt2+T69MKiOAg6SI/go4hL1E4H6Ugq8PrAYZv7lzPsq/tr8fH+Bwt5nmgK6ncGbv8HNodd71SlrMH/OSbzDR7TYMwK9uMcXZi4dFsZ2OWiRfnq9VKevPZHKwrlxH1nrdu4XTBLyCbr7qnXhUKX01MCYOzlDaHHJ4Z6t4G1aPCjTNnhzu6waCy/iP9YFUQuC4aaVaZPobwT+3XzgPvRbnwABPQkl7xTTF5QM7i1q09a9eiQvT8NN7yPZr4COYj6ahTUEvmuTN1uWNkCxPqa5xEo53iTDVdcmY58SvdTl495j+arwHeucdh+2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH3PR11MB7866.namprd11.prod.outlook.com (2603:10b6:610:124::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 22:03:33 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 22:03:33 +0000
Date: Wed, 28 Jan 2026 14:03:31 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>
CC: <corbet@lwn.net>, <reinette.chatre@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
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
Subject: Re: [RFC PATCH 16/19] fs/resctrl: Implement rdtgroup_plza_write() to
 configure PLZA in a group
Message-ID: <aXqHs0Mm5F9_R4Q6@agluck-desk3>
References: <cover.1769029977.git.babu.moger@amd.com>
 <a54bb4c58ee1bf44284af0a9f50ce32dd15383b0.1769029977.git.babu.moger@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a54bb4c58ee1bf44284af0a9f50ce32dd15383b0.1769029977.git.babu.moger@amd.com>
X-ClientProxiedBy: SJ0PR03CA0349.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::24) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CH3PR11MB7866:EE_
X-MS-Office365-Filtering-Correlation-Id: b6d8a3e0-bceb-4a1e-d56a-08de5eb91422
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Y78UJsPrrV1fM29Dm0fMLAbkdWsEwazSW5NE4pKpILH0MUGv4rzRnGyrbicY?=
 =?us-ascii?Q?eqm3rjuhFdYVop6kxj2H0WNPYlMPZ4uzYA796NkMRYQHmFgY+TggmifSXsk1?=
 =?us-ascii?Q?9JmjZ9u84bXMf6ZOP/gx4F1HMWWJpp7aOY3ZpfzYTdgmtZnTCCfcIGgstuGM?=
 =?us-ascii?Q?fkB2/sVTTcgYLbFXgYIXa2g4Sp/lBSz0pNORLT0xwzEMJhiZpwQlANu17t4H?=
 =?us-ascii?Q?cMyEDS8sbF5MDyeIU11920U8buMxIt5eyvCxQJV3CLGHcTRj1iffLGFHY7S9?=
 =?us-ascii?Q?3jcv6NaflqjZA6Y2CoWogHnjlhx9Kwt5A3Oa1gkYnJuXsTESlwSiDXPve4cC?=
 =?us-ascii?Q?TgYS0/r7datCi1k9yA3CftL5MJOKrV+zIJKKstvxFc90Z0F3s2Ow4t4o6Snm?=
 =?us-ascii?Q?PTC3IL9GpmyH5kNjr0W5OiK+mh6ysLyjdRpyVJZZFFEc5yqcQcyPUCRzyIwh?=
 =?us-ascii?Q?FDPGYZb9fdsTjD7M148vqMTgtFlo9YuXPfg8/+ntdZWtDxEgKT8m7K2okJcd?=
 =?us-ascii?Q?BmXfsNF38iCdVvYtvuYOgRypo+QxGGk6exs/TRoaZd9EUUBA+L/zxwvy/Fh4?=
 =?us-ascii?Q?vz1PZRHyLUccj0rjTrFOV0uXhxSH5g75wlgvd8Fima/SBba/xrr8kL1ywdPv?=
 =?us-ascii?Q?15rnoUPkfkEH7ts/BrzdDd69upKIilcAdVADE/Eu1YGxei1OyQ14EwaJ4gi3?=
 =?us-ascii?Q?hnujkUVK9q/pK6i+pCcZEyNYPeYN2dsxcFvYBLbBC2LeCNT0q1ndH3JVyZ+8?=
 =?us-ascii?Q?6nPYtfyu1DWIZaJbUowx9xcU5KftCs858JKUB6aXSLBa9BL7mFwLpQIynwfN?=
 =?us-ascii?Q?Z3//maBkTaSVSNbfJ8KaQ8AAZ/hzIkJCCPA1FW387gBfD7/9dqmLfJGvfiil?=
 =?us-ascii?Q?2v0Bl56fCr9HdtEJ/ze06sQcV5S2DrrnWwY0ecameezRZXyZw5hkQ51eNS2T?=
 =?us-ascii?Q?jaYa7RLsWdKDSxocY4TjQBZauzTmG3W+cVFgbQ/tBGB2uLFC4nrCrT1tFv7i?=
 =?us-ascii?Q?2+3s9CrzYNUHN0smENoNTt8EK9t2YRocZ50xB8+xjpITyMyUMcO6KAP/5INt?=
 =?us-ascii?Q?Bf0TjhL11CUywS42K2r+UreaxCi2/ntXhVOVkMY/zdG8UXEzvlV4VkJSuUNy?=
 =?us-ascii?Q?dPBHuKYX/IM/m5G2NOx8yuhmcrWrcvXNJHGWKV/Fm/A57RqDVANTrU1Hl2VJ?=
 =?us-ascii?Q?tpKT59D0i30Xv2MUg4jUFtkoYzas1Z4+HuDNWqJ/8+p9U6HiHbtvKxbunScI?=
 =?us-ascii?Q?iQzRxmfv5LaSUS+mvB5irWvIBpld82L37EgGVMh1FK+hsDaV+skM1/yrWWpL?=
 =?us-ascii?Q?linczGKOfK1gBZ4SwPN6wd371sX26Bt2cdvndYu6ko6vQULQKOC9qe9HUpU7?=
 =?us-ascii?Q?gvuV7VrnKo6IQ3/rK8c/gIzcdpM1yxtVEH1JCbssUUIWGy1qlT68fliQDE12?=
 =?us-ascii?Q?UaH06eAFv6YeDR8J4lByiMMo2yBH5EBw3IzXI16nbHBrmoRob/wsJ2wGq7q2?=
 =?us-ascii?Q?hRxTGbec8M1BQgqjR2ESj9PJyOx1ubP0gNnkjL5G974pH0gWMsJgR+PXio7c?=
 =?us-ascii?Q?vuRmRhZJCkPQX9o+iPE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QWFMVRDeWe8mpZ7jqvhEVbAqkRTNdgBme1iRkEXNX/Pp/BdquxpDVuokExP9?=
 =?us-ascii?Q?zTB+T2IfwaAqOiCGU+M/RHXtPQa6zOsxe25S5Cy95NQX1JflakuqOcSdq5QC?=
 =?us-ascii?Q?6SihUirjsWQVR5fqvGNWiemR4WsVCjZ/mPfA/ik3F08hSnAuJN3V2k8rK37D?=
 =?us-ascii?Q?xOCftPzbqMG5G2kLi8uI37GgSv0Q/kkUmo9pHNIcVZNHdHzsxh5cwoVoJaAv?=
 =?us-ascii?Q?OLuRYl6aPBNEbVurLXvnhE6/MID7hXus/nwgvGEi0yYAvlN1G1KVgvqcOeHc?=
 =?us-ascii?Q?0UWGpoFfxxHstJIpeR6CG57bttlMMdWF3x/FB8Tj6vmo/ccNMXPMitn95S/f?=
 =?us-ascii?Q?lIb8qV+oZJxi7KWRhIdQnsWa+ghS/BvZVsmmQT9cLQncEBv2Cn9kicZFyEZ8?=
 =?us-ascii?Q?dxO+RCUk1FHr1d+SyQZ4KED6WDj2wOYmysFVAZ40G+m9oxoG/Q0bYC21vESG?=
 =?us-ascii?Q?EG16Idmaj8YNeY4u3l1RjN8t7sHhJLKeQpCaOVGe/z1vcSOVI5RCGETDyFAu?=
 =?us-ascii?Q?JEcYkhLgGLqqrqeJZE7c9JPiS6T4tOEWA36nsS5i1P8BTsNPc3yA1+qFgRJf?=
 =?us-ascii?Q?101lDnbW28KMlPlPEkXn01+hHkTwWR6lrbyDuweJlqCqoCuln/vpau8TRWI8?=
 =?us-ascii?Q?lAPBpUN4FilBzsVbmMy+ZBt7yLxXFGwh2irKGBY5cldASRrjd26JY1Tyk+lN?=
 =?us-ascii?Q?wxI6cBRjcxks5y49CNhYXoZ8r2zxo2Lxxvjiklrsrhfjdcb8xDyVdVmpgTOY?=
 =?us-ascii?Q?ZLUOTAwKxANiMPACzcxr1mM1Ywk16Rum3ckXtWJBlCmWdy+mrHl+remhY5yf?=
 =?us-ascii?Q?KffyW/vIdI9vPrPLHyG6d6mA5i1sGnvrbSlsvLawmQ5Pm2TDRk3d0E470VKf?=
 =?us-ascii?Q?tJV4VYSbBJvE5GchcIj5w7uGR1C+cVINXaU5RP2mbTCxAMQZniVJLCHKLGnU?=
 =?us-ascii?Q?ax6to2MymKboXbjIed4Kp9XTVdsGRvOWk8WXd95DNS4w0Snw+Nz8xkigi2VN?=
 =?us-ascii?Q?GQsYklFk0IYr2Ov0T+Bm/4eBIXCP7jAKPsV2tNldBBj2VM9F2eqO96sA1PBf?=
 =?us-ascii?Q?byODIQk6wdti7selHBGYKqoHZmW5CRhE/lYHVY7feNiNfswaynVB4WRuMJXw?=
 =?us-ascii?Q?kDRQ0vdanBK+3rAzO0Wt1nZck6hGKTMOS7oCC4o9jvV1Q8rd4VFFSapuuVDd?=
 =?us-ascii?Q?RmnpxvZnmuZRHEpX7t9o4JMFJvH+26rhNXi+v9Zg7GjNHovbglJYsWNTJHkS?=
 =?us-ascii?Q?opoPRqJmfYb3MrNg+AZdeeKQIqP5ltUiK4yNJIvXkNX/dDsmce+L0ME82Kh5?=
 =?us-ascii?Q?UG5shxztjVE6Bqgitq8CD5lwR+G//h5jr+GHzci7XlwyXS38T6J9S1za0imX?=
 =?us-ascii?Q?kWXulXR0xfEykrFSPUS2G+oWp181N9mX58sFRs+PiplMdRz+864uCZNhJDMK?=
 =?us-ascii?Q?mEy46BBwFOGx4IE+dkh+w1MTCsYiEbJFXYbk2u7c3x1z7JzBXi7v+MRA7yeB?=
 =?us-ascii?Q?vdM8PRBlE1N7W7dvK/djii6r/SyL+jH3euKl0t/JglcaVUTuUt/r4Noqmduw?=
 =?us-ascii?Q?fWjnROTT4jQL5rjyEsBTGMW2Ffamj5iAFTYAa29xMl7ZM10/KXbB601cLt+U?=
 =?us-ascii?Q?Q7GNreNRr5QkDohOlPV10R/hK+NQcsSGgMR0A9LRAGqiXEBPsPgUcgyK+Slz?=
 =?us-ascii?Q?PVkw2I4foJl0wzPMD/EpH50RT9MfB5CZHl/qAIMxC/lvkQ65a8rRIJij2Q4/?=
 =?us-ascii?Q?aMQ0UWaMpw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d8a3e0-bceb-4a1e-d56a-08de5eb91422
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 22:03:33.5310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xO08UmU137FTNZ4DyO8lbRAQxY5j2VfLQeX4jZkyjlOVzV0WxpgHnEwbTcQNMDC3S94DmY/qffvO3vieOwwAzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7866
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69419-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[43];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: BC60BA95EE
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 03:12:54PM -0600, Babu Moger wrote:
> Introduce rdtgroup_plza_write() group which enables per group control of
> PLZA through the resctrl filesystem and ensure that enabling or disabling
> PLZA is propagated consistently across all CPUs belonging to the group.
> 
> Enforce the capability checks, exclude default, pseudo-locked and CTRL_MON
> groups with sub monitors. Also, ensure that only one group can have PLZA
> enabled at a time.
> 
...

> +static ssize_t rdtgroup_plza_write(struct kernfs_open_file *of, char *buf,
> +				   size_t nbytes, loff_t off)
> +{
> +	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> +	struct rdtgroup *rdtgrp, *prgrp;
> +	int cpu, ret = 0;
> +	bool enable;

...

> +	/* Enable or disable PLZA state and update per CPU state if there is a change */
> +	if (enable != rdtgrp->plza) {
> +		resctrl_arch_plza_setup(r, rdtgrp->closid, rdtgrp->mon.rmid);

What is this for? If I've just created a group with no tasks, and empty
CPU mask ... it seems that this writes the MSR_IA32_PQR_PLZA_ASSOC on
every CPU in every domain.

> +		for_each_cpu(cpu, &rdtgrp->cpu_mask)
> +			resctrl_arch_set_cpu_plza(cpu, rdtgrp->closid,
> +						  rdtgrp->mon.rmid, enable);
> +		rdtgrp->plza = enable;
> +	}
> +
> +unlock:
> +	rdtgroup_kn_unlock(of->kn);
> +
> +	return ret ?: nbytes;
> +}

It also appears that marking a task as PLZA is permanent. Moving it to
another group doesn't unmark it. Is this intentional?

# mkdir group1 group2 plza_group
# echo 1 > plza_group/plza
# echo $$ > group1/tasks
# echo $$ > plza_group/tasks

My shell is now in group1 and in the plza_group
# grep $$ */tasks
group1/tasks:4125
plza_group/tasks:4125

Move shell to group2
# echo $$ > group2/tasks
# grep $$ */tasks
group2/tasks:4125
plza_group/tasks:4125

Succcess in moving to group2, but still in plza_group

-Tony

N.B. I don't have a PLZA enabled system. So I faked it with this
patch.

From 1655fea0049947218fa5400916d57109be8521ef Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Wed, 28 Jan 2026 13:02:51 -0800
Subject: [PATCH] fake PLZA

---
 arch/x86/include/asm/resctrl.h            | 10 ++++++----
 arch/x86/kernel/cpu/resctrl/core.c        |  4 ++--
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  3 ++-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 2c11787c5253..7ee35bebb64c 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -90,14 +90,16 @@ static inline void resctrl_arch_disable_mon(void)
 
 static inline void resctrl_arch_enable_plza(void)
 {
-	static_branch_enable_cpuslocked(&rdt_plza_enable_key);
-	static_branch_inc_cpuslocked(&rdt_enable_key);
+	pr_info("resctrl_arch_enable_plza\n");
+	//static_branch_enable_cpuslocked(&rdt_plza_enable_key);
+	//static_branch_inc_cpuslocked(&rdt_enable_key);
 }
 
 static inline void resctrl_arch_disable_plza(void)
 {
-	static_branch_disable_cpuslocked(&rdt_plza_enable_key);
-	static_branch_dec_cpuslocked(&rdt_enable_key);
+	pr_info("resctrl_arch_disable_plza\n");
+	//static_branch_disable_cpuslocked(&rdt_plza_enable_key);
+	//static_branch_dec_cpuslocked(&rdt_enable_key);
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index e41fe5fa3f30..780cdfb0e7cd 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -295,7 +295,7 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 
 	r->alloc_capable = true;
 
-	if (rdt_cpu_has(X86_FEATURE_PLZA))
+	if (1 || rdt_cpu_has(X86_FEATURE_PLZA))
 		r->plza_capable = true;
 
 	return true;
@@ -318,7 +318,7 @@ static void rdt_get_cache_alloc_cfg(int idx, struct rdt_resource *r)
 		r->cache.arch_has_sparse_bitmasks = ecx.split.noncont;
 	r->alloc_capable = true;
 
-	if (rdt_cpu_has(X86_FEATURE_PLZA))
+	if (1 || rdt_cpu_has(X86_FEATURE_PLZA))
 		r->plza_capable = true;
 }
 
diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
index 79ed41bde810..24a37ebed13a 100644
--- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
+++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
@@ -136,7 +136,8 @@ static void resctrl_plza_set_one_amd(void *arg)
 {
 	union qos_pqr_plza_assoc *plza = arg;
 
-	wrmsrl(MSR_IA32_PQR_PLZA_ASSOC, plza->full);
+	pr_info("wrmsr(MSR_IA32_PQR_PLZA_ASSOC, 0x%lx)\n", plza->full);
+	//wrmsrl(MSR_IA32_PQR_PLZA_ASSOC, plza->full);
 }
 
 void resctrl_arch_plza_setup(struct rdt_resource *r, u32 closid, u32 rmid)
-- 
2.52.0


