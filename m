Return-Path: <kvm+bounces-70884-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cOIgN0C0jGmMsQAAu9opvQ
	(envelope-from <kvm+bounces-70884-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:54:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 827BB126582
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:54:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 847BC3007BA7
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2A7344D9F;
	Wed, 11 Feb 2026 16:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jlRty3hk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185A22DB7AD;
	Wed, 11 Feb 2026 16:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770828858; cv=fail; b=Zspb2YFlhPkEwAlS2AT9Owy2sZuCeH0U6xXCa7vGIj0gkPtTvDMsBVJ/cBe0AwiUu6RZ9UUlyvfSoo5CmrPkXcHhrdirQEbdoi2DWp5rR+hRRoqGBXK9gQCGWsuipfjOkXwQBZ453R7nR8VzpCPxQmeniuwAApKNMCKaBOLcfTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770828858; c=relaxed/simple;
	bh=RjYL8qOKugZmYAusa4rLkQn8LW3rpKFa7soKBBwUky8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lh1QgNR7EmkU9B/2dxapLUKcvV2uwsU7UFOrjm7IcrGkm0DyNemve3p2u8ST26CSdFPgDchGzoxFQeH3FTMWxNjpoXK25jRzitFkrHQwFpEy5WyZ4DcAaBw547oDezsFnnUW1K4DwbcJl8F8Z2BX+1BpPQTBXqrX3hFlRYtdabs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jlRty3hk; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770828857; x=1802364857;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RjYL8qOKugZmYAusa4rLkQn8LW3rpKFa7soKBBwUky8=;
  b=jlRty3hkqSuH8ewXUTvsevLZeShfgNTyVttW7GrODdES1iHPzWWUcAVY
   BtkX9OTOhpW6Z1vlqi9IXD5fpnDybslE/s2s4PAG+Ea9Ag868s/iZ0uQQ
   4pNlmMlBtZmX7NWvL/1Fm0cQxFTjk6u64u6hqwk7vxF0+3BbqtIniQzIo
   /uwzUC3+7XmBuaTd9woZnJXEuBsny2KNF+jvramtVxozx9RhdGSEKw9Dy
   v/gNNFPm57IyYRPyO9jV9FxCkb3dXj5APqFh1W2rTT95cFHlp7vJQ78b6
   goua3KzCj78FUe/xs/XaiWc4Xxm7mXs7VUHfRB46jxHQMotQyCYeZbtRu
   g==;
X-CSE-ConnectionGUID: WgI7+h2gTfClSO/oNqdYgQ==
X-CSE-MsgGUID: Jtfo0QJPTHaC5fTBkrgMaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="94622442"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="94622442"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 08:54:16 -0800
X-CSE-ConnectionGUID: krSy4KRpQXm3D78x1juh3g==
X-CSE-MsgGUID: Ac9qlp7URuWCsEIpEX4VRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="211661486"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 08:54:16 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 08:54:15 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 11 Feb 2026 08:54:15 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.49) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 11 Feb 2026 08:54:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PgwXZXons+rfI0uELmsCsAw1cXN4giC1CdEfx3LAPiSE8sFVSRHhOoK2MoPw1SC51dRGWk8aqeZJCirC5jnWPSddlL+ymyxqVhBAiXZS1W/N9S3gvx1FQrmlgJIhTX5voZeu7zRgiuBwNmz7FFrD5Y4pfLLs4K0IBkUfmzXbW+8f1Ww2CuKnRwk+3UsONi43+NMDKvYk4/Zvf07GbrPhznA6QIJHzGNtuobC57f5BVqKQwvm7Ap15jWBORVj5NBJUgOiRCCs3dFibgDn7vKGf3WTJjxFHCczGlzRh9LZkbSxklU3IgVOTM5HG49TDDzNReJ7crauWzIynkTYewdw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HF8AdlTVEyUs5NZ54ahGmEy5wmBHgBKE++UqCofsQm8=;
 b=w43Oxf4JIcTC8tHi8nygG/Z+1+niII2UW++vK9X/u5fS2hk2M5FbE/gX7PcSKWUDHFogzW47opiWyCc8IXmdA5M32FiJYK9sRq4Ffx3SM1JMB9gAPmGK3pVQHJlz2r72675mhgFedCsUAz4USYbCgrjZmHVygm10PKBtFRZeHOojvbrr4AF6x1QefjofjavJNQg1uWXN59O+8/GYtPz3MmK90iIBRvytKzAW/Ado9vWSMGeGiB3ndOHUC2Q5I3tKfIvzMUQjmDy7sYLsCEj5iJ+cgqPvaW9vMj0grZ9vKyItyj0WhqnGF3wr3isrdsv31cn/rXGOVzC4kuJkVPN7Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4926.namprd11.prod.outlook.com (2603:10b6:a03:2d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 16:54:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 16:54:12 +0000
Message-ID: <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
Date: Wed, 11 Feb 2026 08:54:08 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: "Moger, Babu" <bmoger@amd.com>, Babu Moger <babu.moger@amd.com>,
	<corbet@lwn.net>, <tony.luck@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>
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
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0269.namprd04.prod.outlook.com
 (2603:10b6:303:88::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4926:EE_
X-MS-Office365-Filtering-Correlation-Id: 097b4b63-303a-49b6-76a0-08de698e2ee1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dWdidFZVZGhuQ3JjZzRzT3gxbDA3N2RCYTZpWDRZNFNTOUlEVkdRbDZIRlJu?=
 =?utf-8?B?YTdieXBkTzFJSDAzMEdWOWRPUlU2SEoxOXc3Y1JTRzE2dzdMNys1bXEvOHEz?=
 =?utf-8?B?NGNSWmNyWDRwMW9NdGtRT1oxbDczMlNVbzFJSmovQzIrWG5heHVwNXZRQWRh?=
 =?utf-8?B?VmZtdEVGV0NxVkQ3NEZOVEFPZGxuVGVmMCs1YUN1Nkt0VWdwNzd5RDY0WlFV?=
 =?utf-8?B?MkJiQjRaYk8wSlFNUUN0SUtiWFVJSnNEUHIvQ0g0akR2a2pMZGJWNWNQWXdU?=
 =?utf-8?B?alQwcFJDUlBZZzMyeFhmNmhTQzU0eDZqTm1jU1pRcVVybUR3RG90c2R4Zmc5?=
 =?utf-8?B?dHZObnduVE5oK0xxMk1NZ1hkRG9mSGRtWUlDNnZNTUxNdm5hNi90ZVlwQTNw?=
 =?utf-8?B?YXMzUGE1MlZJNUVvVzNUVmhHbkRvYmVvOGdEUzJTNHRBazhheERvTlVXaDZE?=
 =?utf-8?B?ZnVHQjRpSk9MMlo5bUpVcU1RZEIzZUR4cXV2YmtiY0dZaFZMLytRZUFuUkF0?=
 =?utf-8?B?QS9lL0ZoaEZyV0ZReEpHNWJxM2FZa1BrY0lpcFVvMzdVT3FyeDB5OEhPOEpS?=
 =?utf-8?B?T013ZjNwTTVTcEVXR0VWbERsaWpxQnFUbWxmdEh1SGcrNmlPbEJwSFdET3ow?=
 =?utf-8?B?MFBEM1RLQktlN2drN0I2UnNZVFdOLzh0QmEzR2s5Y09OWjd5UWZVd1QrMGkx?=
 =?utf-8?B?enJYbTh3a2YxeUVpTjZYNkVRSEpBK3MxWHQ0cU9CK2Flc1o2YTArM1R1RmVO?=
 =?utf-8?B?dVpZNHhPMHJPbkpUSVNHQWo5cUhpd1RrRzN6aWFteE5RMm5HWG9WTmJLbHZk?=
 =?utf-8?B?ejdLUFRHNjVlMGdkRmRNZGowUktmYitXTHBtSExUZEJkeEpHOGxvbU9MS3Bp?=
 =?utf-8?B?enBCSFNndVVOYUtobEg1M2s5Ym5QSm5FUzRwSlBvbmtsSkVEZEdER3ZQa2dy?=
 =?utf-8?B?V3ZDUWVwbGRLY1dJSTVNVUpkWmZocHJORTlsbGZ6UVJqVVJ2bHI4QnY2bjB6?=
 =?utf-8?B?Qm5tNTVwQUwrMksydGFvYWVGN29kTGZMR3NHZW5lUFFQUEh6U0lzRTMxQTFm?=
 =?utf-8?B?S2IycForeDgxbDNPMXJuNTBnUTFBL2pDSUZyM1V3dFMwZVcwWGhvQ28yUktQ?=
 =?utf-8?B?Z21ZOFZSZktNc1ZPeGJ6RVRLT0YyeE1PUmVDZkRvdFZFZHBEcWZ5L3JIK2Q0?=
 =?utf-8?B?RzQ0NVIyc3NLakFEbmZER0VCaWhJMjZjMm0xaGlxbzh0VzljQ1h5SVc5cWVt?=
 =?utf-8?B?V1hqeHdlTTArcHNiRmdzWUNETjRTdWNERXk2dURFVnNVWXg1WlN0cUxKZWFx?=
 =?utf-8?B?UFNBVkxXcGl0TnJ6ODMybm4yaGpSZThaN3BIcjVIZXp6N0lTenJ4NWg3M3dh?=
 =?utf-8?B?Tmx3YW55ZStla0hzd2pnckFpakZPVjRXRFNtV3Job0w1YitLMEhYWXFTUDJr?=
 =?utf-8?B?dFZpOXJnT1RJV0FGTUtNcDVHYUQ0ZnQ2MjRETXA4VFltS3EvNUY0RFllMVlU?=
 =?utf-8?B?UTEwQnYrQWVyYnJVRXlabk1YN2c3dXIxU1JVUCs4dXJYdXBubHcwRGlNNFVT?=
 =?utf-8?B?Q1RGMVR3dGtwMVBPYUxUdzFrYll1UTNQRTdTbXE2N29GZEpESmpXdUVxd3NR?=
 =?utf-8?B?RGhCSGpsYVRSRmhMWmJ4aGxJWFp1ckxQaGhJK1d0dmJuR21YdVBGME5LMFY1?=
 =?utf-8?B?NTZtbUxRaEZsNnhMeWM4WldqRFZSUlp6eDBVNzR2RGFDUzhkTklNK1U4K1Jt?=
 =?utf-8?B?NUtBNWRJOHlocnR0d2ZGeitwYXJZTVNBdzJMUTFleFZ5ak1lTFRhclJUNk5O?=
 =?utf-8?B?czFZbmp5eVFRcDNXdXNEYnU5NThrRExyN2hreWk3dnRDUlVrOXZWd0Rvby9i?=
 =?utf-8?B?T3h2QWZTclBhR3g0QVk0VWNMOTBCbjF2ekVvblVJY2grVmRuemxHM2ozUW5B?=
 =?utf-8?B?Y0FXaFlrOVZjUUI2ckErY0NVc2s5clZ1K2cvMjF4OThYMm01dk5reXp5WEhr?=
 =?utf-8?B?SXQyT1ArQm96di9LenJBVjlxazYxZ2tOYzNCNmMzSWdkaVh0dHRvQTd5Zzh4?=
 =?utf-8?B?cFh0MFNkemJHNi82WWZobmhNRUhZdXRaOXlvZW9rS2pqK01LYW1GRU1TaElj?=
 =?utf-8?Q?dHfSIqaDZ5XYZMAT82znY3L8H?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bU1ldVBUTGZlUWNpSHY0M3NsK0lMc0N5bGpnTHRROVRUMHcvWldGSEdkcmhu?=
 =?utf-8?B?QmVVZ20wRCtpSy9kSU5obk5SVlJMM1JMajMyeUR2T0p3TGFHdHFscFhYZ0Fu?=
 =?utf-8?B?L1dHcEVNQnRwVjZudjFNd29uYnVwbkxiTm5Wc2o3aHpmcFBVcENDTkZaOER6?=
 =?utf-8?B?aGRvZ0traWkvaTVueUU2MmFod09Sdzh0L08yKzZwYzJ0eVpvOXh4M0dPNldr?=
 =?utf-8?B?Q015TjJRRTh6UDJKR1Y0ajF1T3VZTjJMRFJwQ29iNnB0NTljRjBRcUp0UXdF?=
 =?utf-8?B?NUhNWlRuMkJhOXBOMnl1TmcvWk1zdFBxL0JUUEFjNDBGUEdsNGRqVDV1Zm12?=
 =?utf-8?B?MkhZUGRMK1JRd21xbmo1czF6NjJkQXloRUJMTUF6MFl3ZEVXMW1idFdpV1FQ?=
 =?utf-8?B?RTY2ais5VS8rb3F3NWluRDYrLzdjVTl2OXVmMlpQSUROM0MwdjZxMXBEVEZp?=
 =?utf-8?B?dkM5TzNPWGJ6VTFldndSK1VVOVA2bmltMDZCaFgwWFd6TVpnS0ZkbW1xREtG?=
 =?utf-8?B?OW5sWXRzZzNIb0ZBalRyUjhzeTRKOENmZmFmM3pNVlBqcjJNM1VYeWxYQlRy?=
 =?utf-8?B?ZmE1LzA2eDFHYVExQ01sSGUydzdzakk5SkZtV0ZHOG5STi9Uc0VJWFJuUUtB?=
 =?utf-8?B?RzVwMW5vUSswbUhUMUZFYVRKcVhjMUZ0Q2d1L1VJcWhUS2R4YitocTRzd1ln?=
 =?utf-8?B?Zmkzdzl2ZlkzejJETEN6YU9tN0hOODBQc0pOaU9aY2pSekNUMm9nM1BHSC80?=
 =?utf-8?B?cVlDUXNSL3FwS2xMaEhhZGgyUVZTdXhlenhZTzhIN1BDUnlLRzB0V1BXYW5j?=
 =?utf-8?B?bzhGWm5mbVQwQjdPK0kwOEhpd3RLVDNBOTNhSHk0THBjV1BzVGxQZWsrN200?=
 =?utf-8?B?SkxIUk5VWnhmcXp2akl2bzE4eWRVSnFjaDlpdFErb1lLSlh5RmV3MHNFcksr?=
 =?utf-8?B?MDZ0NTZnQ0g0SW9WUWFjRDEvbEZDd0h3VTRmbEhuVHE2N0Y3NnpXUWdOSjVr?=
 =?utf-8?B?L29aS1p0ZExGaHp5VldtL0NVa3E0M2hzLzJ5RFBEd3BXaTNuR2dSODUzcnFL?=
 =?utf-8?B?dk1SdWdUWngzd2Q0UHlUaXdrazVta3ZrbVpjOWJ5LzNhNnRQZW94YmhwRDdy?=
 =?utf-8?B?Wms2aERjeGhuVFNIUzJ4a0s4VnhnL1FDRlM0SEhoYVh5V09sRUVXa2EwTjVy?=
 =?utf-8?B?WUUrSEVkVlRxZHNKSm00bE9MUDFNREN2MWZSUUZuZXhVaThwa0IyanM2Qmxn?=
 =?utf-8?B?ckpVZnRPWXh2alZjd1dTY0ZCSFBCZHhBRGg2WGV6VzVPTW91Rkc5K3NLbmQz?=
 =?utf-8?B?OVRVQ21kcDlpVzFxcnZtU0ZYOHY0WGQyUGVMV2drWnYycURWeGtRSnJPSlBp?=
 =?utf-8?B?bUVwQXUvbzlMbzh1TXpYcm03MDlGeXNFNEdTdmdaNnNEdnViZlJ3a2FpdWZj?=
 =?utf-8?B?K28ralRKNTArQ3Nlb2t6eHhPdE93SG5XcEJ0TEppWW9QV2VCbjA5cllXNlhE?=
 =?utf-8?B?c0dXazV4cmNsTnN1a3IrUUJBUXp6U1Jkc0liYXB2MCtvWE9QU0FISG5tK3V4?=
 =?utf-8?B?bDhTZVovM3FPWlQ2b08rY2oxQWd0T2lqeHVrWHRrdHg3SGIwL2wxdnZ5dU8r?=
 =?utf-8?B?a0k0OUpBeDdRd3dsMHE2eU1wdHpna01Wa3lTVWw0c3NjSnZ0NjAxdE9HTlFS?=
 =?utf-8?B?NCtSUWZPd0I2ZGJERkVkS3kyNzFYNG1TdVZLbWhvZXN5dkhld213M2Vra0Vj?=
 =?utf-8?B?b3BYUU9kQ2x0L2xXVUdORE03b2NHampEN3lLOGJYTndZemJSVTlwRUFQUlly?=
 =?utf-8?B?cStMaEtob1pPbUhSQXlzdlp0Sm04b3d0K29hazZ6dG9IaXVWdkpnenFyVkZ5?=
 =?utf-8?B?QkF6WjdpKzFZclM5MDVNZmQ0TExEZHV3N2I3QndobHhoNGxQdU5mZ3ZuYTAz?=
 =?utf-8?B?b21LNkpMS21GRlFYZXFHSTM2dTVJOHAzSGtPV3JzbmpjRVphSTZJNDJ1a3d6?=
 =?utf-8?B?a01RY0xKdTVxNEVONjhqWjRRSXczL3JDRHFUSnlDVDNrbkg1bGwrUk9lWFhh?=
 =?utf-8?B?Nmp3a0tzRkk3bWhBa0hzNkJ5R2Zwd2VYSDdXUlpPQ1dVcDNVYnBWVXJ4MVlZ?=
 =?utf-8?B?VmU2aGZ2UmVOeGx6dG56Mm5oU1k2UUhBZkhBUGUwelJLSkJhM2JNMDlFTmZR?=
 =?utf-8?B?UE85WWhDaC9OMHZweHlzQ0JrRXl2KzFXall0djFDMHNHd0NPR2pzaDE5ckVB?=
 =?utf-8?B?U0hSNmV1ODhvS3BlWDduODJEWHc5UVoxLzBmdUo5WU1lQks4LzRmTXlZRytS?=
 =?utf-8?B?eE5HZ1lOeEpFOFNOSEFYQ0hEQ3l3WmNPUUxXdzVNVHhxRDRyVzVHVnFid0VW?=
 =?utf-8?Q?cNIl0buRxMacwmBk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 097b4b63-303a-49b6-76a0-08de698e2ee1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 16:54:12.7891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uMQCqFXtZs3fP0LHuJQAgtKDX55lqoaUe9pQuF2YBhBkE6Nz4snFjVwoTw3LJIzl1wp5CmBPDCkHpNyrzJgQ8VRTQTIIH1FC2fTVtqe/NsU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4926
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70884-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 827BB126582
X-Rspamd-Action: no action

Hi Babu,

On 2/10/26 5:07 PM, Moger, Babu wrote:
> Hi Reinette,
> 
> 
> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 1/21/26 1:12 PM, Babu Moger wrote:
>>> On AMD systems, the existing MBA feature allows the user to set a bandwidth
>>> limit for each QOS domain. However, multiple QOS domains share system
>>> memory bandwidth as a resource. In order to ensure that system memory
>>> bandwidth is not over-utilized, user must statically partition the
>>> available system bandwidth between the active QOS domains. This typically
>>
>> How do you define "active" QoS Domain?
> 
> Some domains may not have any CPUs associated with that CLOSID. Active meant, I'm referring to domains that have CPUs assigned to the CLOSID.

To confirm, is this then specific to assigning CPUs to resource groups via
the cpus/cpus_list files? This refers to how a user needs to partition
available bandwidth so I am still trying to understand the message here since
users still need to do this even when CPUs are not assigned to resource
groups.

> 
>>
>>> results in system memory being under-utilized since not all QOS domains are
>>> using their full bandwidth Allocation.
>>>
>>> AMD PQoS Global Bandwidth Enforcement(GLBE) provides a mechanism
>>> for software to specify bandwidth limits for groups of threads that span
>>> multiple QoS Domains. This collection of QOS domains is referred to as GLBE
>>> control domain. The GLBE ceiling sets a maximum limit on a memory bandwidth
>>> in GLBE control domain. Bandwidth is shared by all threads in a Class of
>>> Service(COS) across every QoS domain managed by the GLBE control domain.
>>
>> How does this bandwidth allocation limit impact existing MBA? For example, if a
>> system has two domains (A and B) that user space separately sets MBA
>> allocations for while also placing both domains within a "GLBE control domain"
>> with a different allocation, does the individual MBA allocations still matter?
> 
> Yes. Both ceilings are enforced at their respective levels.
> The MBA ceiling is applied at the QoS domain level.
> The GLBE ceiling is applied at the GLBE control  domain level.
> If the MBA ceiling exceeds the GLBE ceiling, the effective MBA limit will be capped by the GLBE ceiling.

It sounds as though MBA and GMBA/GLBE operates within the same parameters wrt
the limits but in examples in this series they have different limits. For example,
in the documentation patch [1] there is this:

 # cat schemata
    GMB:0=2048;1=2048;2=2048;3=2048
    MB:0=4096;1=4096;2=4096;3=4096
    L3:0=ffff;1=ffff;2=ffff;3=ffff

followed up with what it will look like in new generation [2]:

   GMB:0=4096;1=4096;2=4096;3=4096
    MB:0=8192;1=8192;2=8192;3=8192
     L3:0=ffff;1=ffff;2=ffff;3=ffff

In both examples the per-domain MB ceiling is higher than the global GMB ceiling. With
above showing defaults and you state "If the MBA ceiling exceeds the GLBE ceiling,
the effective MBA limit will be capped by the GLBE ceiling." - does this mean that
MB ceiling can never be higher than GMB ceiling as shown in the examples? 

Another question, when setting aside possible differences between MB and GMB.

I am trying to understand how user may expect to interact with these interfaces ...

Consider the starting state example as below where the MB and GMB ceilings are the
same:

  # cat schemata
  GMB:0=2048;1=2048;2=2048;3=2048
  MB:0=2048;1=2048;2=2048;3=2048

Would something like below be accurate? Specifically, showing how the GMB limit impacts the
MB limit:
  
  # echo "GMB:0=8;2=8" > schemata
  # cat schemata
  GMB:0=8;1=2048;2=8;3=2048
  MB:0=8;1=2048;2=8;3=2048

... and then when user space resets GMB the MB can reset like ...

  # echo "GMB:0=2048;2=2048" > schemata
  # cat schemata
  GMB:0=2048;1=2048;2=2048;3=2048
  MB:0=2048;1=2048;2=2048;3=2048

if I understand correctly this will only apply if the MB limit was never set so
another scenario may be to keep a previous MB setting after a GMB change:

  # cat schemata
  GMB:0=2048;1=2048;2=2048;3=2048
  MB:0=8;1=2048;2=8;3=2048

  # echo "GMB:0=8;2=8" > schemata
  # cat schemata
  GMB:0=8;1=2048;2=8;3=2048
  MB:0=8;1=2048;2=8;3=2048

  # echo "GMB:0=2048;2=2048" > schemata
  # cat schemata
  GMB:0=2048;1=2048;2=2048;3=2048
  MB:0=8;1=2048;2=8;3=2048

What would be most intuitive way for user to interact with the interfaces?

>>> From the description it sounds as though there is a new "memory bandwidth
>> ceiling/limit" that seems to imply that MBA allocations are limited by
>> GMBA allocations while the proposed user interface present them as independent.
>>
>> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
>> enumerated separately, under which scenario will GMBA and MBA support different
>> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
> 
> I can see the following scenarios where MBA and GMBA can operate independently:
> 1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an independent CLOS.
> 2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an independent CLOS.
> I hope this clarifies your question.

No. When enumerating the features the number of CLOSID supported by each is
enumerated separately. That means GMBA and MBA may support different number of CLOSID.
My question is: "under which scenario will GMBA and MBA support different CLOSID?"

Because of a possible difference in number of CLOSIDs it seems the feature supports possible
scenarios where some resource groups can support global AND per-domain limits while other
resource groups can just support global or just support per-domain limits. Is this correct?

 
>> can be seen as a single "resource" that can be allocated differently based on
>> the various schemata associated with that resource. This currently has a
>> dependency on the various schemata supporting the same number of CLOSID which
>> may be something that we can reconsider?
> 
> After reviewing the new proposal again, I’m still unsure how all the pieces will fit together. MBA and GMBA share the same scope and have inter-dependencies. Without the full implementation details, it’s difficult for me to provide meaningful feedback on new approach.

The new approach is not final so please provide feedback to help improve it so
that the features you are enabling can be supported well.

Reinette

[1] https://lore.kernel.org/lkml/d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com/
[2] https://lore.kernel.org/lkml/e0c79c53-489d-47bf-89b9-f1bb709316c6@amd.com/

