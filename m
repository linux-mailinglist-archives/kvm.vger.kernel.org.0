Return-Path: <kvm+bounces-70612-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJIuN4MMimkQGAAAu9opvQ
	(envelope-from <kvm+bounces-70612-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:34:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB53112878
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 17:34:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 15896303A13C
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 16:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF1137D114;
	Mon,  9 Feb 2026 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EDRMfs7i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60AB2AD2C;
	Mon,  9 Feb 2026 16:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770654770; cv=fail; b=GHOXb7eqmXzV5E16ZhQc/aKzANBRtx79JFTVejwJN13F/YH7M4awGs+zqVa5d4m/Y+OkXhXCw/us2lYWgxKbAX1T6i9N9yJSkdQoyW7XaGO2vcnNvwRdKBRiEEx+j1PdbRUYVuTeatiEUQ/kWW2dVwmiR4ycr5ZtmfSqxEslcAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770654770; c=relaxed/simple;
	bh=dVHux2UVArJ2oE28hSDJ/DR3xykTK7yl8KSEZLe21SE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sw0ue7yQNJDzKMWi6eCNUaQIVobrn6zvbPEWw50F0e9xjh/2LfynKrb4smKVb/K5TTU2pCRaR1xL1JTJQYCMVoI+npSmxHsk4fChjZy38jLxtpUw2UlJVV7NlBpCfXOMAIPM17UrbcGFpdiV3qabg1V7c27PbTzZzr/qsq27I5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EDRMfs7i; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770654770; x=1802190770;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dVHux2UVArJ2oE28hSDJ/DR3xykTK7yl8KSEZLe21SE=;
  b=EDRMfs7ilkZGtdUMUX2QSuYeHYS2HVOngVb/0DwYCgxKkTBQ0huwxLNf
   gP5aXB83M8sFvOqTL8MQ+ymVZjQ0YzFWSQ3/4jiH3YJZ/0Xkk9K6WeSia
   jXkCemKaqemlSUHYhpFCsIMRQ9ddXaYuOdYVNd89/grFZBWfqwakC1FXM
   fOIs6LQpue3ZkBGg5D5zQmmI5ay6BEPTKLOAbDiaM08xCtkXDjl4wJpyF
   +k0bCn0KDAJsuYzIAVIW4xFCPClppnfJsW+dMjv0Ebm7Fsu2gnifdVdaC
   zEt7+YOtekxtuDTLj/oq4Cl6BGkHSmR+cLrzf0jzrIONBY2p0/5uqfScW
   g==;
X-CSE-ConnectionGUID: qaOppyF/QjezlHXFeSMMVQ==
X-CSE-MsgGUID: wyWV8MJiSMql6WqjE8GEfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="71870725"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="71870725"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 08:32:49 -0800
X-CSE-ConnectionGUID: IZPhA/joT/G9m93E46XzGQ==
X-CSE-MsgGUID: XYzQX/WVRbKg9a7PBHP9oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="234579770"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 08:32:48 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 08:32:47 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 08:32:47 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.35) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 08:32:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yQsaJB4nsyCTvLsRPQT9pGKYmY9AnZp2qBzfiQYrHI8sFxqDDdyYfjG+WSgTFzw+YoFRgr4GMPUjH3VWVEEHCe481gn6zK5asB+KmicPX8vlqwrDHTjp7GdonvHDc8S52NwvguMOj9di62HcTmtt6nNxgmxjGzOe4sH+Rt8+qTMSRjj0UyaM4BwxhD7u3STjRaAsCkir18TFGc73cVMd4lcXYbmS7qd7fDTf+RzIyP+mubUWNF26cwrC67j0nmB4ltJ4UIhuf3abotD9U+noinzH7XVj1ax1Re62Ein/skv5bOFOLk66/A3SrUWcnahAFw3a7tCXLHe5rflR9hOsVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZkwcqWvYXjY72DP+447eAYtkbOT+t1g9TwVjIUMWt8=;
 b=BDrwUed8zzCOI5ZyKRy7Qm3MobWJA4ZMIHzUU9Ej9ZotPcSmP+96KAL+DF6/4GuzyFJMA24WqrEMptWVM36HFMyC6rP9GuBQzlQESGOvjY2Lar50ErTVQaQ+pLqednM2ejATzADc+YXKhBGthg89FyXskDwz6EnFAUk7nMhZVV3GTK5tF43+VJPLSmYCHIl8ge39JRc068521aimutcuxtL4JAFwrStrfbBI04Pxjs/rw4Ql1Xs0p/i/1gMyizGmBbC40O69GaEPhWBceLgaVNmcBhJZr0uAj/Ruixh5d49ob5m9BMKkcpGn+Ttt5C8HHJn7DKa/mYwPzyKu41mKMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB9494.namprd11.prod.outlook.com (2603:10b6:208:59c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 16:32:45 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 16:32:45 +0000
Message-ID: <493bd87b-6f91-4fbb-9215-c07fd8105393@intel.com>
Date: Mon, 9 Feb 2026 08:32:41 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/19] fs/resctrl: Add the documentation for Global
 Memory Bandwidth Allocation
To: Babu Moger <bmoger@amd.com>, "Luck, Tony" <tony.luck@intel.com>, "Babu
 Moger" <babu.moger@amd.com>
CC: <corbet@lwn.net>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
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
 <d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com>
 <aYE6mhsx6OQqeXG4@agluck-desk3>
 <e0c79c53-489d-47bf-89b9-f1bb709316c6@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <e0c79c53-489d-47bf-89b9-f1bb709316c6@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0177.namprd04.prod.outlook.com
 (2603:10b6:303:85::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB9494:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b212b15-0ba2-40dc-c6a8-08de67f8da8d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NmQ4cXZKSDZkYlJ3RlNiV1VuT1FkT0FBa1IwdjZjVTFsR3c3SmpFOHFEdE1G?=
 =?utf-8?B?azgzRUNRc3R2a1VUbE5XdGZCMmhOYWJHNnBwaUFOcjZnZXZTNlJhVUNBZXdC?=
 =?utf-8?B?VXJVL2dLUUh2VW5vVFNBTzJoRVFFMmk2aDNpT21xQkR4THhMb2NLTS9QR09D?=
 =?utf-8?B?b1FKWjluMFZ0dXpscHBvQlliOUV0d01TMzJ5U0thY05md3NTeU9aN3NndWNw?=
 =?utf-8?B?V2pkdnM4NWgvbGdrT0hUdWVIK1BTRmJaYkt5K2lmOHZad2YyWXF5NFdoT21l?=
 =?utf-8?B?RFAxY0tPWStpS25hK2xoSE8wVEVoZEhhSU1ZSlBpVWhTRmxIMkhublFtQWJK?=
 =?utf-8?B?WGhtbUlSak1KOEd2dE1NWEhJNEpZWG0yZDhhVXc5QUdvTnlVSmpUalBWZXJn?=
 =?utf-8?B?VVpkTW9RaHpNeXp4UnJiQjRJK1NublZFVXVxUlNxQ0xaandpdVJpNi9Vc0Ix?=
 =?utf-8?B?SThhMDVySVZnRTJlRkUrZVhTMThxZHpRS1k4S0ZIb05jY2NrajBudUhlY0x1?=
 =?utf-8?B?My9BK1QyVHRsVG1BV2lLeXo4NGU2M1N2Y1RFNFI1YXBHSXBrUXBDT3F3aE9k?=
 =?utf-8?B?RzIwRkpTVnpUS0pOSWJUaVRTVnlBNmMxQVFXSXZXVkJ4YUhYZlJwU1hqUGFy?=
 =?utf-8?B?dGpRM2FvbHpPTjlzQTgzbHg0YXhieDRTMTdyODB2UFNVd1pCTy9QTDgzdGV3?=
 =?utf-8?B?MHNuQnBUVlUwZHowNXFoR2FneUhhajZ5R3BJV1NaakxRdHhKZ0JyZFB4dFhO?=
 =?utf-8?B?ZG10Tk1tTnVsb0UybExiLys0TkZqZmtCQU5TY3FMT2hjV1hiMEpjM3R1dVVr?=
 =?utf-8?B?NCtCS0xZblZCTFVDU0R5VFk2QVdHUWgwbFRBWVUwbVNZbkdFVFhIUFZ2c0tk?=
 =?utf-8?B?V21sUHBGcGFXOGtVaFI1YlJVVDJtalFNSzFncmc0c2VEK0VVYjlKUmlKWmZk?=
 =?utf-8?B?TlYzcGltVnFVMmVMWHZFU1BlVWxjemVsWDYrbU03b3RONEZ6cEZjTEJTYW43?=
 =?utf-8?B?aFhaTFJDaFJhM1FvQzZnUnFxSFhyTksxK1g5ZnB3QlR6b015WDdjNCtLYmVL?=
 =?utf-8?B?ZW91QWNSSWx4TzJjbTZoWGFyL1ErWXRLMGEwaEtmMG5pOW4rcWVHVCtlcXAr?=
 =?utf-8?B?WDBBSTlnZlhTd2tOVUVVZTBVSSsrSDd6NmZFTGlPeUtwZDFsckJCdEw1Z3pr?=
 =?utf-8?B?TE9NU3pjYS85dko5Z2NxdlJZSHZOaEVySnRBMzluaks1VjZoV1NEZm8zMEMz?=
 =?utf-8?B?alU3Q2JlTnFnLy9pNkk2TXlLWjJHa0dCblBxOUNocDdKdFR2RVlNVkdmOVZ6?=
 =?utf-8?B?WlRkWGhZdDFCYnZ5Q0NJTFVQTnFyVUtlNjk4em9kcXJmVnY0a0liNVZnTWdm?=
 =?utf-8?B?cjRWSVQrQ0VMMDdvVENpVWlDeDZUZSt3aFd6UFFIYjFwZTQ4Ujc3Um0wSTJX?=
 =?utf-8?B?YVN1Y1FlMUNHOFR5QlI3UDdvMndNY3k1RTh4Smg3K0FtUUR0N2ozT2d0Rm4w?=
 =?utf-8?B?SnMxaCtVSmdYTlZVQ0dnZzZVWlZncE03OXIxS1NqYVJvN0NQRk5DVVkzTVpx?=
 =?utf-8?B?U2xodjdkeFRVaFlkKzlwYjI1QWlyalJ2Y1lRU2F6N2lta1hZd3hSbm1DK0xU?=
 =?utf-8?B?VWdQY0NkVW9CbTUydVJzUUVzTHpxMnUybGN1SHZ4UGRKNDlVRGd1V3lMV0JL?=
 =?utf-8?B?Y29RMU1Mb3ZKNTJIQ1NOSTF0aFVKemZabUF4aGFYR1lUMUM2aWRhWkVDMUFF?=
 =?utf-8?B?WktMQVR2YlhZcm44NjJYSHNTRHhPS292dE4zWDJrL1RBcUVvTk5vT1hkR0pD?=
 =?utf-8?B?SWVsNHFhQ0VZdFlZUURQTTVHaklRSTJhcUVGdXYyNWxMeUtoMktwdE16S3lL?=
 =?utf-8?B?cTFVZFlDbldrZm8yWFpPNDU2TEc2clJEVFNhb3pnb1VoUXRJd1FUM0QvYWxv?=
 =?utf-8?B?TE9rSk5pbEorWE1YNUNwa1lsTVlUZDIwYVNJWjNPRUJRSDZKRWNtRkNwUUFz?=
 =?utf-8?B?YUw3aHVBbjVxS3RxUWEwdFNlR0Z1WHNxVzdMMGdzWnpWQTB6VDdWUnJOb1Rr?=
 =?utf-8?B?OGpGWEYxeW8xTmxBajFEd3dwSzN2SmxXQUVVUXVPNEhjV3hQbyt6cm1MVDRX?=
 =?utf-8?Q?U7yQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDJ5c3hDR2d0N0ZkNWRnTzF5MXNZYVBlMTlHbjJvVkp2UTRVMFlVVisxUk9l?=
 =?utf-8?B?NVp0dzhWZlZuQ01QaWVOaSt5ZER5Mk85TUh0UzBMS3lIVmZ5TTZyeUw2T3I1?=
 =?utf-8?B?R1hBVkpaSE1Gd1JDUXpETktMdXdha3ZCZEhZVFlDcVRmbTFWdC9sTnZ5d0JV?=
 =?utf-8?B?OW42MDFVRWhja2FzbFlFWWN0eXhLVEJQaU1LN3VhRk8rVVM1Lzh3blZYQk9E?=
 =?utf-8?B?R250bnF1bTZNMXYrNWVzVGd5SWhiVzY1Zm1PdkhuclRQbm1UVlRkQ2FiNDJa?=
 =?utf-8?B?NE9leGRTZzdTV2U4QTZ2TXBnenRHSHpoNUQ4OXY1VUpGaDhFSGFQTXRDRVli?=
 =?utf-8?B?dzRGT3hFWHpncHhvaDdXYlQ0cWM0NzFCR2cyeDVGN2xjeHZlYkxTcHk2b2R0?=
 =?utf-8?B?M0k2L2VLaDVkU2dSZGVRalBLZlpDOGRCQ3pReUx6cFNnREVqeGtSK2F6WmxE?=
 =?utf-8?B?am9lUFR3Wk5UQkRlbDNPUHVXaVdkNHBiYUxoTHpESzRNNmNQM3lwQmV2RTN6?=
 =?utf-8?B?bDA3MEEzeEkwVmxlR212TGhYa1JFcWQyRFVTVGx0YjNFNnhaZU81Z3Z6c3h6?=
 =?utf-8?B?aWYrL3BDazd6U1NpdmZmWU4zSTBDRi9nc3BBR0ZXRHdQYXRxQmNrV3VDdjU2?=
 =?utf-8?B?MExtOFJxT0IrL0xGc1JINjFvb2k5NWVxcXg4R2NwQXN4SzdyWFo1djdycysz?=
 =?utf-8?B?OTJFQUUwOWZmUHNUTmFlYmJISmlITEU3enVBQTVaQ0xEbGdYSkI3eExmUFR2?=
 =?utf-8?B?MSs1NzducW5oSFMxd0FNVlZGQnhyVUtCbWloVlcyZTYrcXdxalpmQm5rRzhY?=
 =?utf-8?B?QVZPMjFBOTZ5UU02NlpLRDBuU3FyZDg3WGRNY2tML202YWdDb3cxNXd3dDJW?=
 =?utf-8?B?aW1nVzNlQ3J1M2V1aElBNTdKV2pXVWdBWTVWVVpFdmxKY3hiNmpub1JtZ01l?=
 =?utf-8?B?Mlo0T21Bc1QvSlpNaS82aFVIbExHT1Bkam1kbXVWa3BzZ0JvNFp2TE51eUNK?=
 =?utf-8?B?clJCM2hxTXNwVGE0Umh2emxxdDh1dS9nVTQ0QXEzWEU3SVE4L0tEejBRVTgy?=
 =?utf-8?B?Y3ZTTmZRTWpMeFo2YldqRmxjZ3hwY0tBaGVHbmtScTlvUjhSbUxtaHF2bVJn?=
 =?utf-8?B?RXNyK2RQUTY1ODlROWFTYStEa0NOR2xwZW9FTkJ5SWs0Wit1NEk1TXVPYnd2?=
 =?utf-8?B?dEZYUzZNdFluSVB2Vjdla29lZU9uZURaNjhKcGtkSWZZSHl2dllGVTFwWk1w?=
 =?utf-8?B?SG9PamJlRCt3UTdienB6aUpKNnZWOSszOE9tanhjVXdmbzZsU2pNcXNFZkhp?=
 =?utf-8?B?ZHkzSHZBZ3dsM0hQNTdkcXFwWDdvdGZnNVFvaTNyWDhma0dQNDQxcEQ0NEN5?=
 =?utf-8?B?V01KUTFtazRvYXZCdVJNS0dzU0pQc0wwWjVDc1BLOHBaV2hCcUc5VVRkdjM3?=
 =?utf-8?B?TTluYkFJQ3Npbk9OOHpucDgrb3JKQm1Ma0pDTCt4WnY3Q242a3JIbUhEL0ZV?=
 =?utf-8?B?SDYzaGFvUTVSa0UwR3oxTUNadUhmNzM0cWlaOVg0NlhjS1BiMlVlUjNROW9J?=
 =?utf-8?B?dm9lN3RCSU4zTWE5TGVZSXlMYkFPMXZRb1B1L2crVDQ5eXZsNkZzWGhpdUp0?=
 =?utf-8?B?YmVDaVhLMUc2ZDNBNlNSamh3R3prQVJpNWNHbU40YmFkWEoveHlyRGlxTGgy?=
 =?utf-8?B?OHJlaCtyajdmYTBVb2twQm01T3cxbFM2VXRQSklkQXdaY3lOSmh3RnErRmQx?=
 =?utf-8?B?N0Y3N2R5Nk5WUUtaNUp5bDgzdU84QXk1SnFFTkNKVmNSOGRNdk5TZE5LdkVZ?=
 =?utf-8?B?WnoxL0tybFJQQnZqbk1UUmlPME5BSFVvanJ2UCtnZ0N1VnVkQ3FZUlRQU0NW?=
 =?utf-8?B?V1VYa3lObjAxYk1ETTB5RGIzNFdCTnQ2Qk9KS3FINWtWSzcyaTlwTW9JT0R6?=
 =?utf-8?B?SDh0Q1pQVXRkY2M0c2krcnplcDRuSlFqUkQyMmE4TmhTNmlqS2JaSXM1NVdN?=
 =?utf-8?B?MVRhdHQ1QUtwSmNuNThkd0wzY3crMVBLaEdzbEpCSzFyUGkwaGtqUHFwVWxC?=
 =?utf-8?B?YS9ybFlha09wNGRaUThhdmx4WHVMV3Yvb014VUtGZnRyVllReHpIQ25veDA2?=
 =?utf-8?B?bk1lK1JhOEVYUUxtYzlVRlVIMld0Z3ZJR1MydVZrZEtHRTJnTFpWQ0MvVm9F?=
 =?utf-8?B?YzVGUWZOU1BtZ1BpdXpuNGFOL0lzSXFzWTVWcjBaUEozVXVET2U3aWFMa0ts?=
 =?utf-8?B?dWREMVBuTHlQYVEySnloNzNucnFXWjJKNGdaUVZ5c1gvNTZqcGRkZm9hZ1pv?=
 =?utf-8?B?WnhSamFSQ0dXNzgya00zUVF4aFplZTVLTkV1UmpoVkszMm5kQU8yUGRmbHdJ?=
 =?utf-8?Q?ciS3EeF0tcmaFAuc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b212b15-0ba2-40dc-c6a8-08de67f8da8d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 16:32:45.1142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ios8w76lmRtyx8hQnXUdOkx93yHlP93TFeG+PgsI90MfKkDKd3yDGRxJxzZXIW59GY+VJTt+yzRAXS+5bxCXFDKuwyo2QabDsW6hw+5c8PQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB9494
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
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[44];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70612-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 3DB53112878
X-Rspamd-Action: no action

Hi Babu and Tony,

On 2/3/26 8:38 AM, Babu Moger wrote:
> Hi Tony,
> 
> On 2/2/26 18:00, Luck, Tony wrote:
>> On Wed, Jan 21, 2026 at 03:12:42PM -0600, Babu Moger wrote:
>>> +Global Memory bandwidth Allocation
>>> +-----------------------------------
>>> +
>>> +AMD hardware supports Global Memory Bandwidth Allocation (GMBA) provides
>>> +a mechanism for software to specify bandwidth limits for groups of threads
>>> +that span across multiple QoS domains. This collection of QOS domains is
>>> +referred to as GMBA control domain. The GMBA control domain is created by
>>> +setting the same GMBA limits in one or more QoS domains. Setting the default
>>> +max_bandwidth excludes the QoS domain from being part of GMBA control domain.
>> I don't see any checks that the user sets the *SAME* GMBA limits.
>>
>> What happens if the user ignores the dosumentation and sets different
>> limits?
> 
> Good point. Adding checks could be challenging when users update each schema individually with different values. We don't know which one value is the one he is intending to keep.
> 
>> ... snip ...
>>
>> +  # cat schemata
>> +    GMB:0=2048;1=2048;2=2048;3=2048
>> +     MB:0=4096;1=4096;2=4096;3=4096
>> +     L3:0=ffff;1=ffff;2=ffff;3=ffff
>> +
>> +  # echo "GMB:0=8;2=8" > schemata
>> +  # cat schemata
>> +    GMB:0=   8;1=2048;2=   8;3=2048
>> +     MB:0=4096;1=4096;2=4096;3=4096
>> +     L3:0=ffff;1=ffff;2=ffff;3=ffff
>>
>> Can the user go on to set:
>>
>>     # echo "GMB:1=10;3=10" > schemata
>>
>> and have domains 0 & 2 with a combined 8GB limit,
>> while domains 1 & 3 run with a combined 10GB limit?
>> Or is there a single "GMBA domain"?
> 
> In that case, it  is still treated as a single GMBA domain, but the behavior becomes unpredictable. The hardware expert mentioned that it will default to the lowest value among all inputs in this case, 8GB.
> 
> 
>> Will using "2048" as the "this domain isn't limited
>> by GMBA" value come back to haunt you when some
>> system has much more than 2TB bandwidth to divide up?
> 
> It is actually 4096 (4TB). I made a mistake in the example.  I am assuming it may not an issue in the current generation.
> 
> It is expected to go up in next generation.
> 
> GMB:0=4096;1=4096;2=4096;3=4096;
>    MB:0=8192;1=8192;2=8192;3=8192;
>     L3:0=ffff;1=ffff;2=ffff;3=ffff
> 
> 
>>
>> Should resctrl have a non-numeric "unlimited" value
>> in the schemata file for this?
> 
> The value 4096 corresponds to 12th bit set.  It is called U-bit. If the U bit is set then that domain is not part of the GMBA domain.
> 
> I was thinking of displaying the "U" in those cases.  It may be good idea to do something like this.
> 
> GMB:0=      8;1=      U;2=     8 ;3=      U;
>    MB:0=8192;1=8192;2=8192;3=8192;
>     L3:0=ffff;1=ffff;2=ffff;3=ffff
> 
> 
>>
>> The "mba_MBps" feature used U32_MAX as the unlimited
>> value. But it looks somewhat ugly in the schemata
>> file:
> Yes, I agree. Non-numeric would have been better.

How would such a value be described in a generic way as part of the new schema
description format?

Since the proposed format contains a maximum I think just using that
value may be simplest while matching what is currently displayed for
"unlimited" MB, no?

Reinette


