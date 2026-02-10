Return-Path: <kvm+bounces-70677-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WBYDEVp2immmKgAAu9opvQ
	(envelope-from <kvm+bounces-70677-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:05:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DBD4115873
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 01:05:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6E99E3009E11
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 00:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92ACB3EBF39;
	Tue, 10 Feb 2026 00:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fQCzn/2a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BB23EBF16;
	Tue, 10 Feb 2026 00:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770681934; cv=fail; b=C3yR1rhkzC5d3h8KMBbs6OkbRjYsI0+AJlCW3I3zoVjoXdv3bR7PvC8S1yOpDB62M1MRC1KanmtwWWLKt4876GJfF5vPjg6rZB1Q7JgAYtz7e5E8WhjmM5mtnwDTXIHZ5hO3jgG+HvZS2HG4gVVRTWQhwdpDM6cIcLxwyHBrmSk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770681934; c=relaxed/simple;
	bh=VDPEp25ohBaTfKXeqGRk5JoeZ6FCOOvIFHQLEuQN5EM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E+rdoNVwAsYSrVcspkVjr1CYx++TiUAv3Lxvo16fFgqLazBuObpYoA+tK9xHy2rP4tk8r/Um+tq57sZmvWR4UozanRBOtMnnqSzGeVTlCkUQ2H3wlJY6g6qrjf6mQ+L5FlbF5sNUM6ZC/y7/jjXvanUy9vr6WnPGNEJfXEHZqmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fQCzn/2a; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770681933; x=1802217933;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VDPEp25ohBaTfKXeqGRk5JoeZ6FCOOvIFHQLEuQN5EM=;
  b=fQCzn/2aGDasfdP7l/EC5JnuJswXA2RSh5RlAnalKvKXu/rYhjOUC8Fh
   IFy9+j1BYDd1sEdUJbuTJthqHgFqiWcNFd/uZ2cVaCMPtOpz77ySjQQMz
   o2dZ72Cq4eQ8cMlG+uzZ9l1vq1xpC3psROCgz7J0HHNMq6rowucMb06oJ
   VPBtSi07vXHVTXFBUOqKcL3U4UrC9g+mhOIP1yj3MyCdFxqtgnCx3IBrc
   yWlZ4ZIeM4822DwR4iFPKS+H/PURSY680bgypBg7jpkuIfomeLTDnA29r
   lsKG7Esjwkvu+O+TVLlEGGVvI8jengRg8DJhBigR66EEIwOGJbuTvQ7BM
   g==;
X-CSE-ConnectionGUID: YjiWm9doTIuLNsY0pLJ2SQ==
X-CSE-MsgGUID: VDwTZuLAQ5urs/SwG9HPFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="71870844"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71870844"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 16:05:31 -0800
X-CSE-ConnectionGUID: YPvWhlYORYukWz/JfUw07w==
X-CSE-MsgGUID: 1V1QT5orQBinF42OAwFSEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="210861629"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 16:05:32 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 16:05:31 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 16:05:31 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.45) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 16:05:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZpzwewgvOUd3cvnYEapPMGJX3CIio8GWt7HkDHNztL+n96/0Vys3LxM8hoE9iMHATB/xfw8R61QvqYdgW+9Ka6rLhMBBclEMLfhmEq5nyRzuxTmLFGTy7FT+r79v81xeuEcSIavYHmAUexsJFJSVxe3ypfqcggYqc+BgPAylE4AM0AUIq9u6KRYyazLLuejQOJMFNGJjxfN+NMOBREtALF9yF6+ugEp4wrHdfzuGiBfqO5W5vx+I6RbgyrPoftQ3kFlq7RYT/8TSgS5uRQPeWxbTVHZqzfgklIEr6UW7acA+HqXUDNnDmKbSmRfk2EynE4FPDnocD0DinYjErM6xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bQP4coI9329cj8U8aMN+nVBSK60nS1j/BS7YcJATFbQ=;
 b=KLuhe/yu3epZH9fnU/Yk/eXFEwUOqbtiQu7jJ1+3AVYd6duNzFEkH1Y0J+saGlkjz21TCRgiNpvi7LR6BsADoY1rgCTaPz769MBGHWEih0J5P/vHhogacDez3B5V3Dn1CjnJ/Hco+8Yubmiv9vS9xrnMTDRhLz9jUBiHxWqYOCDgUG2Pxpvd60f8bZITNT4RmO6XMBSkrL4W/ZfDGa2drzwvzWxxh4MAAahTqGre13bJsg3xhuBPvr/FcpeUfGX5zfXll3gmXHsTFEWJCwmI3DNp21XYKS3/Co1y8eCpsCMMJmrhC2CRD2H6XdRPLYmRrVxOezGzwqfYV5zUHb/duQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7685.namprd11.prod.outlook.com (2603:10b6:930:73::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 00:05:22 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 00:05:22 +0000
Message-ID: <6fe647ce-2e65-45dd-9c79-d1c2cb0991fe@intel.com>
Date: Mon, 9 Feb 2026 16:05:18 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 16/19] fs/resctrl: Implement rdtgroup_plza_write() to
 configure PLZA in a group
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
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
 <a54bb4c58ee1bf44284af0a9f50ce32dd15383b0.1769029977.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <a54bb4c58ee1bf44284af0a9f50ce32dd15383b0.1769029977.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0145.namprd03.prod.outlook.com
 (2603:10b6:303:8c::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7685:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e5eebc8-becc-4ef1-4ee2-08de68381576
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TGdkRkplV3B5SzBpNVpxdTdZbFpLWDRuOFlvNEE0U1VRQjYvWTNRNVV1TFcz?=
 =?utf-8?B?R2NWSjdHMjNCU0xQMEZlRmMzRHd4WUEwbGYycDlRcjlMQ25IeUI5WDE0bzR2?=
 =?utf-8?B?aUw0MlVxTzdkSDVuajBFUEZiN2FvM1d0ZXhoOEE0ZVVvcUlBSmJYNkhOUEdC?=
 =?utf-8?B?U2tlZTRaWGJBYWtiZTB3MGZuejRGUjRzdWduYnBWTUZqVXJJSHBKMzlOQUEz?=
 =?utf-8?B?UVBNVVhLWC9iNlRkd1NxWVIwSlFydWVscGFYb3J1OFNkeUFXY25RQ010ZWlj?=
 =?utf-8?B?UnY0aEFsSTNQY3ZleFU0a1ZxeFh2TGlDYVJQcDBydmN1MjAzSkltLzlRbjJy?=
 =?utf-8?B?RUU4OFlVNFMvdmlrbmxIaHRkSEx0RTJiQ01IbTNzb053dkNzQmR1elZoMXpT?=
 =?utf-8?B?R3VucnpRS2dJUUNYUnJncWFnSlRyelpGVzkxRXNVTmM5ZHNJTXJaeUdyTCtz?=
 =?utf-8?B?b2lzZzFENE9LTDdKU3pyS2d2VGZQMUxpQTAxdTRUQ3laNk5LQzJTekEzY0xr?=
 =?utf-8?B?dVBNK2pVVHJoa3FvTHp5ZFRNMFdLdjNJNkJWNytOUHU2bWpmRTZmb3hEdzli?=
 =?utf-8?B?bVliMXpXakhobUlTRlpYL1JCcTg3cGlOMEY5cnYwTmNWRkFXeHlvbE4rdGtx?=
 =?utf-8?B?TUcrY0JwYlVGalBYMEpmazRnWEEvWDV0eE1Rd0RrRHZ5bnlvaVFUMmY0YWJ5?=
 =?utf-8?B?WFk1bkRyUWIwdklaaHNYY0w3NCs5L3AyNHE2VFZ0azdCZ2FMVVBueEVmemxK?=
 =?utf-8?B?SFc3QnRWek9rcjl6YU1xRTB0czRudTZHemp6bmR3c1lEY1lLTkdNYUNwODNa?=
 =?utf-8?B?QlFPcFZQQy9FZkw4UUEzVDlSZE80TjV5N3MrT0VGQmYyL1djNzVDaEtkZVh2?=
 =?utf-8?B?RnUvM1ZxTFE3UlBZaTZ1TzlwU29IWlBnck10aEtDT3VYOFhtMTY0MGRMak5Q?=
 =?utf-8?B?Ti93cHVxeUFsb3Uvajl3aFB6cDAzaXNTenV2VzREMU80WmowL1RPeTBVWFE2?=
 =?utf-8?B?RnB6NGxSbGRYbDhtZmpGRmZSWHNCTkRGa1hzSzRsM05tbHlrbEFxbDNRcTVR?=
 =?utf-8?B?ZkI4WTJ2aEpWMHorQWFFNjNSSDV5Qmt1K2lMNTFRS3FvOEVDN0VLQ0o1cTU5?=
 =?utf-8?B?MmdHSC9yWm5nV3cxdDhpN0lMeC83UGNGekRGRlpIWnFTUWdpN2x3eHhHWVBR?=
 =?utf-8?B?ZmF1djNEQkFaUTJTZkVGN1ZBbWtSa3pBSlRhOGxxUEZuSEFwYS9HYmR2Tnlk?=
 =?utf-8?B?bmh1eHF3bUNDVzNYbjhXSzI5Y2Myby9vZ0ZlaVpMNC9HZHNBUkdBZlUzLzg0?=
 =?utf-8?B?NU5qdXVCNTZ1SW9sYmdKRHdXTlM3UTZhVzh6SmZXNXQ1dlpMYlZJRWprQklY?=
 =?utf-8?B?OXJTdC9YeTliZC9peFVsRUpRZ2lCazZFSlJtYWV3OVVwRVE3Qkcvb2tXQWNG?=
 =?utf-8?B?T0NhU0Q3QXhGTHFLeGxMRUdZMG8xWHZEcGJHQXlzaXhCd3FnU29FS1ZkQ0Nn?=
 =?utf-8?B?dDMxclo3bmx6WXNnTTc1SmtEcTYzZFNvNTJqVERKeEhsVmRaSjZSZ3lYeEIv?=
 =?utf-8?B?RGhSN2MreVBSakFlQ2JLbk1YSnZmWkRNd3FjTXBlTnlTRmxLYnJsSFdJTVg5?=
 =?utf-8?B?TytxSFNrb216MjVDOVNLQlgzcHRYdEtYV0g2ci82d2cxclovK0FIcGtodkNx?=
 =?utf-8?B?QXFZM3N0L1owaStvaWRhRE1ZcEZTWUF4c3dMbC9CblV3bE1mS012MWZsQXJ4?=
 =?utf-8?B?bGtBMTVBYUhKcmlJYUdrTi9mdGFZZ2svbm4veXNla1hubitqeFFtWCtKN0ZY?=
 =?utf-8?B?NVVyN1Q2c3VuaEduVTdFQ0lUOFlOZDQyTENFYVVWZldxaEE2bndrcG5jN3dS?=
 =?utf-8?B?QnhyQk5LNFJMSmd3RmNFYVkyMnVCZHpaRmxQUEEzNnNGZ2dTWlpWdTdtTDhB?=
 =?utf-8?B?NFI0a1BPQjdtajVMUFZWaVJ5bk5ad1ZPOWJYRG1zWE1paGN3VkpCakdxeUJP?=
 =?utf-8?B?YUhYTXVmdnhqbm1TZnFLZ2hZVCtKN1BwYld5M0JBVzRrLzNQbjF6bDRoUDlE?=
 =?utf-8?B?RWMrd0ZpZEwrQmE4ei9QNDJYZXRsUkpLOGs3UWd6ZlJrbXdFU041NXRaa1JT?=
 =?utf-8?Q?Bhqo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXBpVzBnWEZzM2tLT3JKdkIrVDdqd1dwQjBHcWo0NnVmNFIzQ2NYeWtuUTQy?=
 =?utf-8?B?MENPWDNKRGQ0U0duSStXeXNRVENmUGlYRjVsTUZLYlFOMUFQT0grSXFsbXpI?=
 =?utf-8?B?K3g3WVkwcUt4T3J2NHgyWGozTTVpVC9zelZhL2JvRWkxQWVEdWxjNXZnREFi?=
 =?utf-8?B?V2hsaEJ5Y2xsc1loU05tcnNGZTl5cEFCOGtDNHFQTmc1NUNWbi9UOUdQWENS?=
 =?utf-8?B?bUN0WUxXTUZxK3hibUkzYVljUnFVWHloZWllb1FPdWVMWDFKamo0SVJ6NkE0?=
 =?utf-8?B?N3lvOWQyRW5FMy8zdzFYMUZ1TzlsSWZGSHhpN1VnRWcvRCtLTmtXR29PcXds?=
 =?utf-8?B?ZllCbWtxdTNoOFkzR0lTRmJsMVg5eURNYmQzL2s1djZUUUhqRkd6ekE2SXBJ?=
 =?utf-8?B?QzNGS2pLWnNRYVN2Z09JeXZlSGJ1TVViU3RmWFVteHRvMmtTQkpvSEIrcm01?=
 =?utf-8?B?SnpOVGVnc2NRRXN4dlRZbXhLTVRodTV6bjM5a2lIZ0l0dWU5bTdkMzBLM0FH?=
 =?utf-8?B?UEs4Q1VqQmxqNmpEeFJmYWNGeWxsdUZYMERZTVk4MzBMQ1VZTnFxeXFreVFO?=
 =?utf-8?B?MktHRjZXZkl6L1BtdUprNmtDNUVlVkZsNEswM201aVJ2ZXU2VG51RUZBUE5i?=
 =?utf-8?B?UmRXOTFXKzJYMnplVytuOGdQa0NhczBPcVBBZGl3Y0ZsL0FkREgvR2RsR3dB?=
 =?utf-8?B?K2IyL0JIalBPa0k5aCs0K0UzNVR1T3JyaHJ2cFVKMnVuTExJZ3NPZk9IcG84?=
 =?utf-8?B?a1VwaEFWL0xtREZGdGRBNXhzOWxQQW5XZm9abEFVSTFWRnNOakk2NzdPUmxa?=
 =?utf-8?B?NFprNmplMDhCRHBaWHNWZWRqVDZSd1dsenh3Q2ZIWjJBS2tHcXhJTytsazRx?=
 =?utf-8?B?M2NFS0xCMlBuZzZnVndnb1FpaVc4M2p1c0Y2NUdxeE5OaERWU1c5U2FoN2RH?=
 =?utf-8?B?NHQ0bVJsWUtHYkhsQVR1OStpMWp1UnNnUnNIM0xYRks3OG12YXV2Ymh1cXV4?=
 =?utf-8?B?bFFMKzRjc3B3OFR2ZDNNWEZ3UURqWWtvWG0zNzJvK21CMTBhN0lobDZJa0JL?=
 =?utf-8?B?Z1lCWlBDazA2ZVIvekJvbXc5emovRzA1ckxsemNmU1loVlhWd2NWUlZPanVv?=
 =?utf-8?B?QjNxbG9lc3FTMmpsOStIK2JsaXB0Znc3Z2luS3MwblFMZm9DcXREeXJpOUE0?=
 =?utf-8?B?MVBVSnJiRk9qaXRvaUw3OGhiUjdmWjF5QkVLOVoranJldldQZ01KbTRKeUQy?=
 =?utf-8?B?cnhMYyt0bFFCNjd1R2hSV09zNC9UelBaTUFzSis1MklmVzI5RHFPVkRSZzZx?=
 =?utf-8?B?bk9KU2VVM0ErTHBwQkdheXJvL2xnKzBYcVVTOGt3UVdPS3ZEcWdNd0FVUHVC?=
 =?utf-8?B?WVVSb1hETTFKZ2VDNDk4ZU1BVkwvVUlyYTA4c3UvMWpmVXJiQXM0VzQ2NHNB?=
 =?utf-8?B?aThZYTQ3cWdyUm9sNFBSWWk1c3BuMVc0ek54NDllNGNPdHA4bWdUUFB6NTBa?=
 =?utf-8?B?ekdydWtCb0plWVRwNUhlNnVIQXo3NUNKMXRvNjJIeWRlQ0xPSFd3WmJIN1M0?=
 =?utf-8?B?L05oUDVEVGkxcDRuMzFza1hTUUdHV3RBTi9BWmQrVHAwQWt0Y3VtWUx6eUsr?=
 =?utf-8?B?c0NhN2JOZHlwSFFYc0MzaFpwL3d2elo3c0x4T002aFdNMFh0N09SM3pVeXEz?=
 =?utf-8?B?dnRYbzdSc29RK25wMWNNUnBpdnhpU0tHNHZWY1lGSkJEU3N4bmNsR1dyQXhH?=
 =?utf-8?B?WGhuWFpZakZzR0FoeWgwTlJ1b1dHTlMyN1RrZHFFR0xUTUE4cmF3VjdSMklJ?=
 =?utf-8?B?ajlSdGFpbVIzN3dBeHRvZ0MvZ0NZMUpBWFQxemhrR0dKK1dsRlZYbGhYalZW?=
 =?utf-8?B?aFYwditpaFR3cHNZaTBMajFCemhkb1lXY2pyS0hONm5oWVM3V1ZWTHpVaUYy?=
 =?utf-8?B?ckdWeXVpdXVSMVhKcndYa1lnMzN3RUR1aVNIeFRtcElZcWlrRXFldzZReGFs?=
 =?utf-8?B?Y00xZnhTd0Z6RWh2SHVLRnArRzR1UDUvME4wYUdhOVFSdDhZV3QvSWwwWGc4?=
 =?utf-8?B?Rm5LWkcwOEZjMXRzdXNhcEVFOG1rU2RKWld0aWJSa3hGVWxOZC90TzltOUR5?=
 =?utf-8?B?UTUxSVIvZEZKMXI1ZVluQk9KdGxUNzJod1NjQ0VKNENadEppdDNXZnFCOEdx?=
 =?utf-8?B?Ly9FVmR5UVZQRVNvSXRQWXhrRE95L2RuUUs4azJ2bE52WUxsWDZxbGd3c0pS?=
 =?utf-8?B?UnluL24rY3dSeUVHa1I5NjZxbm5rbWdXaGlOT1c2SmxCOE4yZk1JQjJVVFgz?=
 =?utf-8?B?cE56b3BKVkEzNFpKR2FPL29iYlRxR3JmZnRvYjVSVS9XZnVhbVQreVFMdXg4?=
 =?utf-8?Q?CueVZKbfZeTa+aOM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5eebc8-becc-4ef1-4ee2-08de68381576
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 00:05:22.3035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lbbXBhkxPn4+WF/6mh5wLDT9dxTJX+njQFk1VR8OZCZSc39TVpfaxgDprzU5QFdK5RrsUdESROhlt+TqwoGk2UD7Bu8xIH18h7fc4UiKwJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7685
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[43];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70677-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 5DBD4115873
X-Rspamd-Action: no action

Hi Babu,

On 1/21/26 1:12 PM, Babu Moger wrote:
> +static ssize_t rdtgroup_plza_write(struct kernfs_open_file *of, char *buf,
> +				   size_t nbytes, loff_t off)
> +{
> +	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);

Hardcoding PLZA configuration to the L3 resource is unexpected, especially since
PLZA's impact and configuration on MBA is mentioned a couple of times in this
series and discussions that followed. There also does not seem to be any
"per resource" PLZA capability but instead when system supports PLZA 
RDT_RESOURCE_L2, RDT_RESOURCE_L3, and RDT_RESOURCE_MBA are automatically (if
resources are present) set to support it.

From what I understand PLZA enables user space to configure CLOSID and RMID
used in CPL=0 independent from resource. That is, when a user configures
PLZA with this interface all allocation information for all resources in
resource group's schemata applies.

Since this implementation makes "plza" a per-resource property it makes possible
scenarios where some resources support plza while others do not. From what I
can tell this is not reflected by the schemata file associated with a
"plza" resource group that continues to enable user space to change
allocations of all resources, whether they support plza or not.

Why was PLZA determined to be a per-resource property? It instead seems to
have larger scope? The cycle introduced in patch #9 where the arch sets
a per-'resctrl fs' resource property and then forces resctrl fs to query
the arch for its own property seems unnecessary. Could this support just
be a global property that resctrl fs can query from the arch?

> +	struct rdtgroup *rdtgrp, *prgrp;
> +	int cpu, ret = 0;
> +	bool enable;
> +
> +	ret = kstrtobool(buf, &enable);
> +	if (ret)
> +		return ret;
> +
> +	rdtgrp = rdtgroup_kn_lock_live(of->kn);
> +	if (!rdtgrp) {
> +		rdtgroup_kn_unlock(of->kn);
> +		return -ENOENT;
> +	}
> +
> +	rdt_last_cmd_clear();
> +
> +	if (!r->plza_capable) {
> +		rdt_last_cmd_puts("PLZA is not supported in the system\n");
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	if (rdtgrp == &rdtgroup_default) {
> +		rdt_last_cmd_puts("Cannot set PLZA on a default group\n");
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED) {
> +		rdt_last_cmd_puts("Resource group is pseudo-locked\n");
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	if (!list_empty(&rdtgrp->mon.crdtgrp_list)) {
> +		rdt_last_cmd_puts("Cannot change CTRL_MON group with sub monitor groups\n");
> +		ret = -EINVAL;
> +		goto unlock;
> +	}

From what I can tell it is still possible to add monitor groups after a 
CTRL_MON group is designated "plza".

If repurposing a CTRL_MON group to operate with different constraints we should
take care how user can still continue to interact with existing files/directories
as a group transitions between plza and non-plza. One option could be to hide files
as needed to prevent user from interacting with them, another option needs to add
extra checks on all the paths that interact with these files and directories.

Reinette


