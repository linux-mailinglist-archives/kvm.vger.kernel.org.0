Return-Path: <kvm+bounces-71078-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +N8mBqe9j2niTAEAu9opvQ
	(envelope-from <kvm+bounces-71078-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:11:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D1B813A1E4
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE53B3048B1C
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 00:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDC6A4F5E0;
	Sat, 14 Feb 2026 00:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O+DEzEF6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082443EBF3A;
	Sat, 14 Feb 2026 00:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771027868; cv=fail; b=Gg8+W6di/g9XHiCvdWih6xtDwmqLYHIt/hQssCqCbHB8NBtloT6ZfstJFp1uNJOepEIafDpdoPJ1drbyKd6dW9SMO2NURQSukFJnqRhYSOAbMIMDC9bGoLy2SCM/SRyrxNHSqVRUyFJ2CZslb1RQC1sSnj8hLWFp5xDeaLsCi64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771027868; c=relaxed/simple;
	bh=NCAL6uwjHomiMCnUeYUfg4VkEGvPjSAPNUAQn0DR5m4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P1kKmsHBJzORRXuFYfyCSg05dF8s1sDA9Deb7B58TDNk61gjYDgIa8Jee4PooC4pZD2ChxsPRjs3IAjHWwrs1BbqbncAH8PkCr+2RbdVIYwlrzAveM4dwGYydXxRGD0yd4lN6xK0opelTuIJCNzMuBEaws9rAaPI8QASGPL3yC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O+DEzEF6; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771027866; x=1802563866;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NCAL6uwjHomiMCnUeYUfg4VkEGvPjSAPNUAQn0DR5m4=;
  b=O+DEzEF66+XsVX27eDV1+8wjQH4IHHUrzkbJ8ZVxRAsMXjvLdRiraUVs
   RLcJO1WyZvWLVAnC/XcGqpqXYcIpLKm2QuA7Ed2tVYVlReJ1+GruM4Hc8
   iOTUXtLEZCOyY29megiBmepg521Q/H3Ed0uckknLSb7KVoCjMfRlGvNxH
   fXg04aOEqbAggFvZMtMxlwKwPOjzx6cFHjtEL9DOZnFGbxpPKsJslIzyK
   ydQK+MrYpCcRHQNv8oScnuorHBll2FsQHb+x21Hr82bPr7veZlEQOIm/g
   mp6ebhbEu4f3/TrEXfzV+XPfGnFMRDOpfEDZhjY9NrluTER0LwMjsO4mR
   w==;
X-CSE-ConnectionGUID: sJQhCZVyRQywECkPNCF+ZQ==
X-CSE-MsgGUID: 0npVOhncQ0WyrsbgpDZV3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="71413211"
X-IronPort-AV: E=Sophos;i="6.21,289,1763452800"; 
   d="scan'208";a="71413211"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 16:11:05 -0800
X-CSE-ConnectionGUID: w+gx3D4qQJ6lMVOJGug3Tw==
X-CSE-MsgGUID: nJU1jl9CRRer+PjTTLJsCg==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 16:11:04 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 13 Feb 2026 16:11:03 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 13 Feb 2026 16:11:03 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.21)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 13 Feb 2026 16:11:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3UejMO/ySbSwoQXevhCcx4AdaBg2CYFUDTZdYltzFQVVdrR5RO7rJnv/eQqfr2UAGHcJT6V+0W0uuU3PZrO/0gQKvJZSfUpPSviP+TxjTN55T/KTbw3bQI6sng+x9+vqPAG7eNmWiYcvHgVRXQCfClibt1PBeYKW444mAk+dj2WhtRwT3t4KwR+SfLJK/jkcHv5ya7YW+1+jx/brtXf3ZEDQUCclKw6DEr4kuGLbCtB4MkbBvpLoHq0XCNFNSQumroCUsu5xtgWUAzsJzCB/WBaUw2tmYZROM35zsCF4u9EWYdvcG9DLHV1l98GcM/v46eRsnZpe0JXkuYZSSCedg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9gG98USsvNGT//018LiMd+zwS7SvstskbCOVTaNljk=;
 b=H3HyXPX91DAdjRysTiCdNJEE5BiRGky5pr3xtcF2kDjqDG3NK9baW1OZaYCrzIosiYz/xR+HZmERE7xwVV5RzJKvF2TLDfjwux1cZLtRD2yov85LVyf3Wjr+h5G9irzbibht+bzhuXdxFb0klnqt5ml1ui6UVHVB351lLbRzA0hm8qI1Co5qVf+1duvHhlK+++owHyze+XcZo+VuPHqnIeT4X6fENkCtyF7QZMD6YjX0LqU60eMbU4A+gUNCCSRAU1/S3aslSJZBKBQTRpvSsShMRszEXW0wmoycOUme/4V4s/v+eepdNuo7ZHDmwxdk/Anf1YpO5syaDh6/JJf+Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PR11MB8684.namprd11.prod.outlook.com (2603:10b6:0:4a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Sat, 14 Feb
 2026 00:10:58 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9611.008; Sat, 14 Feb 2026
 00:10:56 +0000
Message-ID: <1a0a7306-f833-45a8-8f2b-c6d2e8b98ff5@intel.com>
Date: Fri, 13 Feb 2026 16:10:52 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Moger, Babu" <bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>, "Luck,
 Tony" <tony.luck@intel.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
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
 <abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0221.namprd03.prod.outlook.com
 (2603:10b6:303:b9::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PR11MB8684:EE_
X-MS-Office365-Filtering-Correlation-Id: 867e189e-de98-4242-c71f-08de6b5d867b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014|19052099003;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZVREZzVyb09ISWtYN1pZTm54TVZvWWZFd2VVbXFuRVVMUGhkR3Z0SG4yQ2di?=
 =?utf-8?B?MDR4bGwvcEE4aHo5bHpqREFvQVU0b0s5MXo4TCtTSGdZS2tVUHpJSVRYbndE?=
 =?utf-8?B?M1pFSkFBdUtWVnVRTDBoMTBJd2ZEVkliaWVKOVh2QWJ1VGVyWVRqdGcrUU5Z?=
 =?utf-8?B?ei9UUE96UVlRdllwaSs2ZmpNYmxJQ3hYRmJMV1BYNEVVaGc4MkRpK3VJYnN5?=
 =?utf-8?B?V3VxMUVlZWVscjN5UGUvdEVkY2NPa0RRTUNRYnVUWHFyMWRZMndKd1lhZHlk?=
 =?utf-8?B?bzJmY3Erajg3ZkZIdStSaVVYQnh3QXpsWkdid2J2K0RHU2diNVFhd1J1V1pL?=
 =?utf-8?B?RTZVQ25NeHFFZzRCcXQvZzRlVEo0MmV5cXBxR1NVa2pRT0ZXL0R5VDJXb1Y5?=
 =?utf-8?B?MXpUUEtkYWtoT0FPazFOUS9zWjBETkMvcm1jTXNGNFdsb0VZbzk5WG9pT1Y0?=
 =?utf-8?B?R05MallndUhOdkUrcmNEZEM5RkI2TEY5L1NtdmIxc29vTHJUNWtoRFk4dno3?=
 =?utf-8?B?NmNXMllhZVJXRnV0L1o2d3FacGN0dmZMMkxFSlFWV05nMGNackdHdFk1bC9C?=
 =?utf-8?B?c29nZWkzNktIbTdCcHlYd3FIS1E5TkhJa2ExTUlYd01DMnQxNjQvT0YzWlQz?=
 =?utf-8?B?cytISWt0UnRqcituakNVU3VURXFkZU90b3RJTllxaG9ZWFhRb3VvcHcwN3I3?=
 =?utf-8?B?Zm01Y1NFL3JoRGtMRzFDcC9DMlFLVjAraGgvaXFPaTJzMDVRaGFoMEE0K2Qv?=
 =?utf-8?B?d0ZDTm1lMVNYaVpBM3RUaERSQnJGT3N1Q0ROcEVnREsyNkU0dGtwRTk3OUow?=
 =?utf-8?B?T0RFc0V4VG9MSjFEUVcvNUcvS0h5ZGtiTU1GMTM1cUtLRHhiVmVBelltUVpw?=
 =?utf-8?B?cnM5T1EwMk5ySEMyVUg1Wi9SbW5KT3RuSVhVS3l3aHVUNTlaSndLQnBoN0Iw?=
 =?utf-8?B?UnFsVy9Bem1vRjJ3SFpNUGhUMTBVRnZWZkRUZzFIc2FvcWhrRkFTWTFFbG5Z?=
 =?utf-8?B?VDdCemVEK29PZG41bURmcktFMDNyWlduZU4rdE9DeEVjTnQ4QWZjY0tFUXY2?=
 =?utf-8?B?T0FRNWxick1icG9mak9vY3RXT3NnZ3NRSGkvQTZENWdwdEFLdG5XT0o2UERH?=
 =?utf-8?B?UGRhV0h0ZktsRGFWa0FqdnBVL2N2RDlzdHVQeVRXYUgzblpGckVBd2ZDZHF6?=
 =?utf-8?B?enhTSkdxMUFldUZid1JYWEZ1L2I5VWwyTkl0bi8vZFl1U3FYUEphV0JzNkdE?=
 =?utf-8?B?SGlWck1DbzdDZVVySW9DS3BWdEdDT1RteEZPc3lSVzVWZGh6UVE1NWJSOFgy?=
 =?utf-8?B?ZnFXUldvS054bWhqdlI3K3R1Ry9uUFNONmgwMXpwKzM4L3Y5b2J4V052K0Nj?=
 =?utf-8?B?dFdsK1JWSHcvYTI4aDdDNTFMZmVlN2tCei9yWHJwUEJWZ0N3MWpreEIzYUp1?=
 =?utf-8?B?NXBvN0ZDYk9laDFwb1lEdXNlcW9GbjlCa3lFT0owVVVsQUNYb1A2Z2tyZWYy?=
 =?utf-8?B?akxzbTJhVXlsNWRUMGpLZHI4RHJvSVZsbVU0SjQzckRxOTRraDlxd2QyV3E3?=
 =?utf-8?B?dnpvVGhWandGUkZBVXNTNXdlRmRxT05rU3pkcXN1V01USnhHRFV0aTB5Qkhx?=
 =?utf-8?B?d3hjRVliSmRIMWFEQ2NaajNZbmJHMjNlNmZxTFBMYTVqL2tlMVE5b1l3Rjcr?=
 =?utf-8?B?emVycnpoajA2SjVBaXZRb2NiZUNPZzgzUWszTXdLaHYzOXNjMEFETldjbEw0?=
 =?utf-8?B?Y3JnUnFrZVd2TlJRT2YvVUhYOGtQWWpWNlpybHRGSDVTTW5WSGg2R0VOYnBI?=
 =?utf-8?B?NEh3VEJVWEo5VEp0TUdNSDlHL2hkRkVJeHFobXNKM2J6ckQrUUVsbUdMVlcv?=
 =?utf-8?B?QnpJUjAxNEFJc1lOVjhZUE1LL0NkL0RmQTZDVU1aaWZkbUxUdEVOTUQrblFv?=
 =?utf-8?B?eFlpZngzWEhsT2ttSmlhZHJJZHAzQWovQW9WdXg1ZzZmUWFuSUgzNWdnUWNK?=
 =?utf-8?B?cXZhbnZEOTR2MzZnSjN2SDNkdExsVWFGcjM4VDhSY05KNkRkd2dwa1I0bFZQ?=
 =?utf-8?B?YTNsK1B4cWJqZlBiYnpPeHBFcldYSlQ5MS9mVGNOODY1WHlsWXBjVVgrVTJk?=
 =?utf-8?Q?UWGU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(19052099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0FyV3U3ZWhvNzdqckJSTCswcWEzUzZBZ1ZSNkNhWVBCNy91Vkg1Y1dma2JS?=
 =?utf-8?B?ek5nTUhYK2hsZitwd1QrNW8xZHcvU2twL3p1Rk91YzRqZFFDV1hZWFBIM3BS?=
 =?utf-8?B?MjBzKzI3cXl4blpnZjNrRUoyTmEzS3ozRDhGVG9JbWk4ZVpyK1dTRXI3QXhy?=
 =?utf-8?B?eWJHRHYzZ0wyellqN3VsTHFSNDFJMFJocG1lUFJXVnBVaHFURnRZZVZkNUtr?=
 =?utf-8?B?dkFiQ1lIRGoweUkvMkgzVllobXRIMXVwemNmZDBwdThMdktQOVRnUmZJUzlI?=
 =?utf-8?B?QWxIKzNhK3ZteU0wWGt1d0pxSmFpL3hVUHB2SThyclR1L0xneEg1NG9ndjVl?=
 =?utf-8?B?QTA4V0ltZWgxODk4Zjk1ZHJwbGpBcW80cmlPOW9OajM0amhlOTQ2Yy9vbmcr?=
 =?utf-8?B?K1hhekFzOU9wcHBmK3NEbDhJZUI5S1d1K3hqVHk4eERTcGM2TmFiQ1ZGMGtV?=
 =?utf-8?B?R0VFZWpSNVlIU2xtZStRK2F0R0RDQ05LbVloSEFvZG1QY2p0Y1lXcXhJZzRz?=
 =?utf-8?B?YlhhSzRSaEV3MTMxaFdzK21vMlBNVzBwbFczdnVzT1hacXFxUTRvOFpWREc4?=
 =?utf-8?B?WW9Vc2JraXl3VGhLVGFEaUE2c1IrYjFHOEdjWXVnYlI0Sm1PZUwyNmlnNFRw?=
 =?utf-8?B?ZkJjRExxMXVwUFZCTHVVT25XVkkwV1d4R3R0Y3VlbWwvclpMMEF5Snd5dFpz?=
 =?utf-8?B?NFk2TGlPamJCNE8wNkRSYzJvWlE5MjQrSVFsaXg4TWFMYW96OHdvcWM5Wk00?=
 =?utf-8?B?Q3dNdTcyZWVjb3JBTWQzZk1RSDFFZGVLTVpUNnBPekFTR2orSTh1ekF6elI1?=
 =?utf-8?B?K3ZMS3dDcXp4YnZQZGJGMmZDdlZPVlBpY1JrR01JY29BWUxiNzJtTHlnS3h6?=
 =?utf-8?B?MTBQdGhhNFdObnM5VHBRdWxvdVFyZnhBeGFvMHlhZklCNEVCQnN1NWtTSWov?=
 =?utf-8?B?Z1U4Y3FGUUNnOHZqdWorMzNjU0JIODl6QzF0NU05a1VEZktNdE5lN3paMFBq?=
 =?utf-8?B?K0ZDTXp4b1I1eDNiTUFwbU1PMnVrUVN4d09BYU11NnlNODNmaTNqQmZ2QXVs?=
 =?utf-8?B?RVlnRGFqcjBUZkEvdm1HV24rUkI1cm8vWnJxcEhRQ0ZkMmczYmxXOTNTVit6?=
 =?utf-8?B?VzRqSkRiRTRXaUZ4NUZLNXkzZ2hPMUtGaTF3UHQ2L3FMTjc2ZWJKVHQ4MWx1?=
 =?utf-8?B?N0N5Ykt0VFlMVkp4cnNQRCsxV21QQTl0OG9rb0VqVEpQVEVHbFdweFIxMVdl?=
 =?utf-8?B?UkFHK25EOVF4RnFlZkN0enhTUW5nODZRbkdEZHRCWmEwWDk5NUdHUlkzdzFh?=
 =?utf-8?B?MWJ2QWVQZ21DWU1IOXg3ZnYzYWlZejkwLzJsZ3JwUVN6a2F3ZWJaVmZTME5E?=
 =?utf-8?B?cnp2eG9UbGhTc09YTHJmQUNoUmpVVzVHblhNb1M2WUJMaEJNeXNkM1FVTkFt?=
 =?utf-8?B?VmVMbDZHd29Od1ZmQnFOdG4vR0dGSFNVSWI0c2IyczFMTFFBSmNTWGJyS2lN?=
 =?utf-8?B?M2hMWFIzZjZoNnhlMjJkbVp0TVg2TUQvVFVCL2VqUExERURKdUZVZE9aR25W?=
 =?utf-8?B?UDRvaTFMdTA5ZkVqdjBVaWlueGdaOU9YWTlGR1JqRE55VThyblh2Vkk0RFIx?=
 =?utf-8?B?YUkzWG8rUkpVN3RBQnUrQjYxNUtNRmo0dWU3V1RGejVGV2pXRkhDcjJzVE1p?=
 =?utf-8?B?RUZFZVVUa3RHcGVmYSt6SzNRYlVLZDBrWTFkZlF0NWZTUURrVW1MaGRjNHcr?=
 =?utf-8?B?ZWtQUUtWeGVrbXJ0eWtaVEdCRjI4WWdIclJxRkN3VGlzRHpNV0tvdk9UQnVU?=
 =?utf-8?B?WURhYk9YTmgvRXZEeS9jZHhXbm9iNHZydWZNMzdDekxXaDlYdDdQQjlaanNF?=
 =?utf-8?B?dGtvdVorbmN6U1pWUGpLN2NrOERIek9YMkhGcllHQVEwNXp6bmNnc2hQVUV5?=
 =?utf-8?B?WXdFOHVNQzFMM2VDeHpQNU84bjBPMHdkUXpTdEUvTk5keWFGTHJSL2hidElZ?=
 =?utf-8?B?VGpFUGNZRHVoNkFiVDJuajVCM0s3RVBQbDlwYlNwNE1CeXIxYzdmdUNNS2ZX?=
 =?utf-8?B?TTdXTHFQeXR6dVBMb1hOcExZWEZtbU5BTW5DQlA2bzRqT2Erb1pqeEpEb1lv?=
 =?utf-8?B?MWNCdTVUMkx3eWRBVW9JS0Y3N1BDVEFmMndiVzVINzdkRW1MTjRhcVRZQmR4?=
 =?utf-8?B?cGF6NE41RjZ1WlgvOTZsczd3dzl2L1B5MHlGNmRiZUU2VmFRbWdxSHVwamN3?=
 =?utf-8?B?cHUrMGg5NGxTMkZXWlNSamdOSWphQ2R3ZlhlTmZVYW5zaExTQ2VVMEtwTE1v?=
 =?utf-8?B?QTh4bVJNSk5LMk1CenZ4WlRaM1F3ZXFOR1NQZExpaTQrWGd5ckd1cE5MUmVW?=
 =?utf-8?Q?1noFrzvM+c3asJ+E=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 867e189e-de98-4242-c71f-08de6b5d867b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2026 00:10:56.6874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRM8fDxU0LjihMIUhlgx9izFoEHLtTKD5hYIysKt5ll0YP76tpFoaZ7F8SUru6ss1L7krCtv7f/hw5tLofVn5tdgxW2U/6VYls2T3amsA5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8684
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
	TAGGED_FROM(0.00)[bounces-71078-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
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
X-Rspamd-Queue-Id: 6D1B813A1E4
X-Rspamd-Action: no action

Hi Babu,

On 2/13/26 8:37 AM, Moger, Babu wrote:
> Hi Reinette,
> 
> On 2/10/2026 10:17 AM, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 1/28/26 9:44 AM, Moger, Babu wrote:
>>>
>>>
>>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>>> Babu,
>>>>>
>>>>> I've read a bit more of the code now and I think I understand more.
>>>>>
>>>>> Some useful additions to your explanation.
>>>>>
>>>>> 1) Only one CTRL group can be marked as PLZA
>>>>
>>>> Yes. Correct.
>>
>> Why limit it to one CTRL_MON group and why not support it for MON groups?
> 
> There can be only one PLZA configuration in a system. The values in the MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN, CLOSID, CLOSID_EN) must be identical across all logical processors. The only field that may differ is PLZA_EN.

ah - this is a significant part that I missed. Since this is a per-CPU register it seems
to have the ability for expanded use in the future where different CLOSID and RMID may be
written to it? Is PLZA leaving room for such future enhancement or does the spec contain
the text that state "The values in the MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN,
CLOSID, CLOSID_EN) must be identical across all logical processors."? That is, "forever
and always"?

If I understand correctly MPAM could have different PARTID and PMG for kernel use so we
need to consider these different architectural behaviors.

> I was initially unsure which RMID should be used when PLZA is enabled on MON groups.
> 
> After re-evaluating, enabling PLZA on MON groups is still feasible:
> 
> 1. Only one group in the system can have PLZA enabled.
> 2. If PLZA is enabled on CTRL_MON group then we cannot enable PLZA on MON group.
> 3. If PLZA is enabled on the CTRL_MON group, then the CLOSID and RMID of the CTRL_MON group can be written.
> 4. If PLZA is enabled on a MON group, then the CLOSID of the CTRL_MON group can be used, while the RMID of the MON group can be written.
> 
> I am thinking this approach should work.
> 
>>
>> Limiting it to a single CTRL group seems restrictive in a few ways:
>> 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
>>     number of use cases that can be supported. Consider, for example, an existing
>>     "high priority" resource group and a "low priority" resource group. The user may
>>     just want to let the tasks in the "low priority" resource group run as "high priority"
>>     when in CPL0. This of course may depend on what resources are allocated, for example
>>     cache may need more care, but if, for example, user is only interested in memory
>>     bandwidth allocation this seems a reasonable use case?
>> 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
>>     capable of in terms of number of different control groups/CLOSID that can be
>>     assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
>> 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
>>     MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
>>     example, create a resource group that contains tasks of interest and create
>>     a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
>>     This will give user space better insight into system behavior and from what I can
>>     tell is supported by the feature but not enabled?
> 
> 
> Yes, as long as PLZA is enabled on only one group in the entire system
> 
>>
>>>>
>>>>> 2) It can't be the root/default group
>>>>
>>>> This is something I added to keep the default group in a un-disturbed,
>>
>> Why was this needed?
>>
> 
> With the new approach mentioned about we can enable in default group also.
> 
>>>>
>>>>> 3) It can't have sub monitor groups
>>
>> Why not?
> 
> Ditto. With the new approach mentioned about we can enable in default group also.
> 
>>
>>>>> 4) It can't be pseudo-locked
>>>>
>>>> Yes.
>>>>
>>>>>
>>>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
>>>>> would avoid any additional context switch overhead as the PLZA MSR would never
>>>>> need to change.
>>>>
>>>> Yes. That can be one use case.
>>>>
>>>>>
>>>>> If that is the case, maybe for the PLZA group we should allow user to
>>>>> do:
>>>>>
>>>>> # echo '*' > tasks
>>
>> Dedicating a resource group to "PLZA" seems restrictive while also adding many
>> complications since this designation makes resource group behave differently and
>> thus the files need to get extra "treatments" to handle this "PLZA" designation.
>>
>> I am wondering if it will not be simpler to introduce just one new file, for example
>> "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
>> file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
>> task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
>> resource group to manage user space and kernel space allocations while also supporting
>> various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
>> use case where user space can create a new resource group with certain allocations but the
>> "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
>> the resource group's allocations when in CPL0.
> 
> Yes. We should be able do that. We need both tasks_cpl0 and cpus_cpl0.
> 
> We need make sure only one group can configured in the system and not allow in other groups when it is already enabled.

As I understand this means that only one group can have content in its
tasks_cpl0/tasks_kernel file. There should not be any special handling for
the remaining files of the resource group since the resource group is not
dedicated to kernel work and can be used as a user space resource group also.
If user space wants to create a dedicated kernel resource group there can be
a new resource group with an empty tasks file.

hmmm ... but if user space writes a task ID to a tasks_cpl0/tasks_kernel file then
resctrl would need to create new syntax to remove that task ID.

Possibly MPAM can build on this by allowing user space to write to multiple
tasks_cpl0/tasks_kernel files? (and the next version of PLZA may too)

Reinette


> 
> Thanks
> Babu
> 
>>
>> Reinette
>>
>> [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/
>>
> 


