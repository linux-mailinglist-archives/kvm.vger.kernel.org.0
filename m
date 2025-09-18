Return-Path: <kvm+bounces-57977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 946BAB83088
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 07:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F5FB4A373C
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 05:43:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7E02D6E67;
	Thu, 18 Sep 2025 05:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cmWjWKaD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E0028F5;
	Thu, 18 Sep 2025 05:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758174203; cv=fail; b=NKRrnu3WEDidSqktMgK9tHN4vvxhtTLUyzhtJdH8x+ZsByoUaEEwTftpOoI0QgIPso1eUAh1B5+hxZdHG0uh6bCX+E3TtZsKwlM5EOciYw18lUgIwHnonNXfGyAuZUxK2nKMtSo1BOe13O9L5aW9XZiLBfiOzP3PkLiBxXZ+wB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758174203; c=relaxed/simple;
	bh=NPji9NPWKqKgEppqkE3KzlHfQUcaI1mMIWn/WDBRLuE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rRRub+JeRzJXIU2fhw1cEITzaT4QBdWPGVsJOktR2ItX3VG43ba3dCPfaHIZ1zZhcNRsVY0SwdKS7TznePz5UqCYp0/x3+q7nRZmMWNcMbhizBO5PiyjXUc5VeygJmdtjk1ABKaE9rqa/6PLwCeUcsrsao4Lh+ccDtakRYSBK2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cmWjWKaD; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758174202; x=1789710202;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NPji9NPWKqKgEppqkE3KzlHfQUcaI1mMIWn/WDBRLuE=;
  b=cmWjWKaDhItgcXlP5V4TjRInnW8V+vI+qqyI7/4rbf2rv9y0dlH+ZXs3
   6ApHdpR7sIrCFO2V+NMop+RG9UW5wjEtd2y7xjU7Ztm4Y528nUfcVVyR7
   wnzNb/8Y2Zih+G7wrP0VKR+hPr7AX2htgGGHd4qWvEaYhddRqNsJckvsK
   0kyYarPHRh6qgb9FgKVZKB62EyCv5qqEzcsIh7i8Hr6fFtkbZ9iqzTTHW
   QqfKPA3Wkm4LhxeET73AjDG8la2eq9JP+TP7srk3Ze/Z2oL7kRYBj/rHl
   M8wtaarAkOHRXXtSjc7yiNTSfroUABaTfTo+yf830uHOdfA0cR4DG73y7
   A==;
X-CSE-ConnectionGUID: guO4YGaqSiCuX/tWwYkp7g==
X-CSE-MsgGUID: fIBCVPkMTdycfdP0KPtsww==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71125009"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="71125009"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:43:21 -0700
X-CSE-ConnectionGUID: iNRFeKfDS5yzSsXK7NHh7A==
X-CSE-MsgGUID: vZJsxY9MTYK+afd4U2mhCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="175843619"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 22:43:20 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:43:20 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 22:43:20 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.71) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 22:43:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AMkhXwnG2tSflAYBb2srNj6jF1OnOozMkNCGZlEPB+COqB7aebEnmkjYAaGJibYsjAGVl1serf2/rQEyC35g0VW7M98ZHUotmn2hrDmLOmUOAKpsQZifADLBQ5nak7xZVhmTz/8JoZ5gejbIzii6KW949fNHqERmFTfS+Qs3IyQtJLL2Z/Z5cbXwgKwqdkp6iv1TL+tVGhn6bdaiCvktaaoqs80y9sksZHwTRUKpfqzZ/mBDDEHuV7rbvZDHSh3LdFiynWX+n920ku7szF3INsDxJ5cWRoTbd6zh+TO6VF8m7yW6NBhA6/4jRwobYp59CSmtNWQDEH3SHEKZEgXvlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zKHWUDhURayGzoySR8GiY+C7xZgrHvk79Lw0rDXRUos=;
 b=RWrOcs24skwPcBATqjErE5nrnFoBAGEfqjbRdaedpHbhXiVFX/511ztv29LpCtMh5tRe1obwN8FbPVIVSVPACdgevtPcUbuOBUWocYeiU2db0oQHM8qWrjA58J74YHmnxZrpqtAtgv8I8uky2Jce9EtQLiwggI9z4dnWzVQtTMWs04MDxVL9xA716bxy+VJ+ABmCIO0eDRNN2HzL10PUFCAHA4lxjZnKlIEYLNk5XNczY2zey91WVdi3aNfwnX+f6tjHIKMmRL9c9CRMrJu/YayoD3nceH05vtucjjoF4ggrrDmJAHCttXgV1GqsF0tkzUYo5seqgXZUluQEAdLBkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB9105.namprd11.prod.outlook.com (2603:10b6:208:564::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Thu, 18 Sep
 2025 05:43:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 05:43:17 +0000
Message-ID: <2c3a8282-e876-4cdb-8355-0fd78eb6c0b4@intel.com>
Date: Wed, 17 Sep 2025 22:43:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/10] fs/resctrl: Introduce interface to display
 io_alloc CBMs
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <cover.1756851697.git.babu.moger@amd.com>
 <382926e0decbe8d64df56c857fdf10feef6fcc51.1756851697.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <382926e0decbe8d64df56c857fdf10feef6fcc51.1756851697.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB9105:EE_
X-MS-Office365-Filtering-Correlation-Id: f578835c-ed7c-4fc5-c03f-08ddf67644ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RHJUcTBLbmN3alRUT1MvOHlrOUROeUxucFJDMXBhdUlicWtVcEFWMGxwNEQr?=
 =?utf-8?B?TXIzaEYreitzRDkzbUhibDA1QzdIOWxFdnlHN00rU0ZPTkwvYWIwc2RPS1Ur?=
 =?utf-8?B?VjY3Ykk3RGlwSXg4QVlPR2dSWWtjSjQ5TjM3eENmQ1dTSWJPc3hVRkN0UEpx?=
 =?utf-8?B?QThXZ3NPMVhoSVFqZWVsNmcxd0owbXpQNEVpNlQxNWc4TXpUZmRWbjhQUnVz?=
 =?utf-8?B?bExDM1NPaTVBNGNadVA0K3FmRjY5WlRXSi9CejNNVVBtcS95TDZocUx6NG1t?=
 =?utf-8?B?WkJDeUl5Y1J1dW0vcHdxbjBBcGtIR0ZuaXcxdmFXQ3R6VTRVWkI4a3B2blhZ?=
 =?utf-8?B?Z0ptVS90cEVuNUswV2JwaWZvSHlNaVFSU1lWdzR5ZEZjTlFCek1nbEJpT1dq?=
 =?utf-8?B?cTRtSTVQZlNOUG1sdmEyREQra2RacHJ6TnpmdGpLekxMYUFqTldEeUQxYU9Q?=
 =?utf-8?B?cDRWNlM3bENhc3RBQ0J6Z1ZPZWJCUGdwZzZKTjlVc00rbnJDNWEyNmwycmUy?=
 =?utf-8?B?VWRzTjc5RkZuSmg0d3B0MFMwRDNGRm80NG9taWhIMUNKUHZIS0ZmcWYyZUoy?=
 =?utf-8?B?K01WVDBRbldYTDZnZW1VWklTUWg0dXVkS3FXNVVYMENIZkliN2djL1p3Zmtl?=
 =?utf-8?B?U25GOC9GQVRtS2MxWjRaWXB5VktkUWQ1OXZjZGMwdXVKRG5TbjNTa0w3NDBM?=
 =?utf-8?B?OUlUMmEyTHU0dDdzOFZaRm83QWxsblF4Y3JrcnY5TXZWTVpVcHhMOVd2UmpT?=
 =?utf-8?B?ZXpDSHpNRVVDd09SenVSQ0s5S05uSlBJK2JheEFwNUtBbGhlNXB5ZEIveFo5?=
 =?utf-8?B?N1g4c2IrWHIzbGlET3N1a29ORytCWEV4Q1lIOHhaZzcxRnU2QUowK0d6TGZP?=
 =?utf-8?B?amlWeFA3c29ucEZ1bEZDSjdBUHNKSVR4TllNanhSZU0wQVdhY3R2S0Z0U1ZN?=
 =?utf-8?B?S0ZrcGZkNHdBRnlJUTQ3Y2g4bXYzaVJNMGh0S0M4MzZtOEtOVEZCK1M0UFRX?=
 =?utf-8?B?cXVrb2ZLcm92OVhZQmhVNGFVTmdsVEZVTDN6SkIzaUFjMGt1cE5ENFU1NFFW?=
 =?utf-8?B?R0VzbHA5N2hIMDZ2SjRLMzh6aHpXMmd2M096aVVITVd0cmVwQlIvZ1NpdUFN?=
 =?utf-8?B?RnhqNXhBR3lWM3VxSjVObVp4eVdzRW5XVEx1VFRTR0VmaFh0U05kbVVJOWJa?=
 =?utf-8?B?Z3oxSllsbHcwK3h0T3JsYmtjQXA4UncvQVhDUEU4ME9wVXJzK1FzVTFkcjda?=
 =?utf-8?B?emJzaUpNQzYrOXBReVlUeWZaaWt3bUp0ZThnc0ZhRHNiYk56WU5tYXAxQkla?=
 =?utf-8?B?Vnk1Y01Bc3hINVE0dW1FdUhGL3daWjFqRk03VjE4Nk5leHp3b2p4M3FWR1lU?=
 =?utf-8?B?SlJZUVgrM3ZsWVpkNzA0b0E1SHpkaHMyR29TNTYvemowNlNhTjU2Y1czMjBu?=
 =?utf-8?B?VmhSQzY3K0JJLzZmQ0F0QnVNRXRhNktRc1d0aFUxc3J0VCtaTjh2OEcvQ0po?=
 =?utf-8?B?MXBZaDBMSFRHRWgzODlsS0JWMlJxSS9pVE54SnZTUXF2ZUQyd0dwSnM2ekxl?=
 =?utf-8?B?ZUFLSTYrZWlNdE5nZ2F4NFlGQ3dmcnVjTzFncEtBUmVmWmpEdW5DNndwWW9O?=
 =?utf-8?B?bjFuUHNjVUtvbXhTcDRxOUFrSWNuU0lJSzAvS1NIc1ZUeXRMS3Q4S3BCeHJ4?=
 =?utf-8?B?R1ExYTlKN1RLUjJGcWhINCtYSysxd1RnV2s3c2dkSnRPK1BKQWZMKzk4bEdh?=
 =?utf-8?B?WTkzUWpqZjVwdzVqdjg5S3R6djZ5dVNIM1ovOTViNysvM2t6cjVNbmNOYS8r?=
 =?utf-8?B?TlVpK3hpWTRrNzVNdFZTT1ZmMjY5RjNiVjR3VGNWeUwxemVYSm81ZGUrVzVC?=
 =?utf-8?B?QUFxWVNvWlgwS1NCd1ZkWFJpWHl6SlBic3VCY3UrdzQwNzJXWDhCNjJuMWho?=
 =?utf-8?Q?0dQGurcfRjQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0NjRW1jRzFrMDJVQzhMbGhnUlYwUUF1U1J3MGZQSTJrVzYxNVU2QzNwOVph?=
 =?utf-8?B?VW9LUXpNN2lWWldBb0FBRzFGQTFhZlVoMDQ5V3lycUQ5bzIva3lGaEFhb1Ns?=
 =?utf-8?B?b09kdmRyQ2R6QTVVVmo4UTBpVkFvc2VyTXkyNTg2dFdVZTFjdUQ4blRac3Vh?=
 =?utf-8?B?c2xJd0FQTHVzYVBveVhRMGRDYW53eUZ0aGJXWElKY2FqYkxvaUxudmNVZWdn?=
 =?utf-8?B?clJzZDBDK0lmaDJpNHBybXh4R1REdlBlMFNYNW9LRnBvVWJ2NUFpMWZxNjUv?=
 =?utf-8?B?U21GUXRoVlJLbzdXSFFuaUdqMVlRbys2L3dSY1NHZzY4N1N2TStaSWhMTllR?=
 =?utf-8?B?SkJJcVZ2aXNRMUU2eDFvVUJOcXpaSWJGV3p0MlJzWnU2eGlyRzlXWURLYXNl?=
 =?utf-8?B?T2tHeFBoNHg3aVpGVlZJQUVVSXhNMFFKSkFXV0lEbDB2SmRZNEhPZmxGRnQy?=
 =?utf-8?B?bVp5V1gxdEpsVkU5ZEdQV3kreVJNSWdOV1RnQUpKUWIzbG91dmR1RlYrelRh?=
 =?utf-8?B?elVwK2t3bGlpSUFvOUdZRzNMSVBoU2pPc2U1T25yVWJIMHd0cEhPZnMwRkgy?=
 =?utf-8?B?K2x4ZmFZbmRaZ2UyZWV4aDFpaGFiRTJiVkVnMFFDZ05Ra2JreU1FSnVueDZR?=
 =?utf-8?B?by84TG1PVXkvUmpvcnVwOTNlWFRNZUtMNXgrd0UzeE52OXR0Z0RhL2FYVDAr?=
 =?utf-8?B?NlFpS2RjcS90TlJNcjVsdS9LTG9rNFlMQnpUQTBjRko2aUZhcVZVcGt4Zys5?=
 =?utf-8?B?dExnZjRLT1EvK2d4dEdpbjVpa0J3T2NQQXY5NVNBc1FZWXpXeDlBbS9XcUFM?=
 =?utf-8?B?ODJXbnhhM3U2aGtDZXpNN2xQMi9XK3FvZ3FKbWE0eTAvTnNlRjJpZzlyQ3lp?=
 =?utf-8?B?WmxraUpONjhJWHlJVVNqblhSaStCRGg0dDRTRGNDVXVabUxVamdyeXI5M2FV?=
 =?utf-8?B?aUN0UElDTlRCZFc2NHNFdlh2WjcyNlNsRjYwclp1cE44dkgwTjlOQUNZRWlk?=
 =?utf-8?B?ZE1wTDdldUt5ZjFhZTM3SGJkOGttSDg1SGUvZlRqNzQ2MEtlRXIxWWZLR05l?=
 =?utf-8?B?ODVxV3E4ZEZFUU5WeWVwTnQvcEI2UktaWTd0cjFscVA3NmNUV01FdW9OZ0hC?=
 =?utf-8?B?cjU1SUVpdVpPYUJ1dG9SMEhKNGtBZEtib0VYT2ZMUDFDTkFsTzFDbUVqUHR1?=
 =?utf-8?B?NFFEdTA2V0NCNlNxUTJrZTBHTXlzUWlvZ05aZmcyNGk2WWdWNWpzQ1NsQVpD?=
 =?utf-8?B?R2NuanNuaUx6RmUweVNJc1JWdXpkZmRpaFBKbXFJVXBRNjNOeFR1Zm5mb3Zx?=
 =?utf-8?B?WUpKM2dWZFpyWC8wNERjc0dhRFRTT2hkdE5aSWdOVEl5bFZwdEhwaXh2Z09J?=
 =?utf-8?B?bjhlZ3BFMEc1NSszV0FTMFVadFpaVlIrT1lHRyt6enlsdmdXNEVPUjhqd1d0?=
 =?utf-8?B?MW8xM0dqdUY5T05PRmdQZ0V5ZXJWT2t0V3RyWEtTMW5TcXpaV1VPekxmRUN2?=
 =?utf-8?B?dmJnVzVrek5weU9NbGJhK2lZeTRIWGZGZmNoY3kzdkxaNEVZcUtnQnlranJn?=
 =?utf-8?B?MmY2MDBmRXlOMDZSb0xkUEZraTdmSkJvY0dXU01lOGp3ZXowVjF3TDcvNGpz?=
 =?utf-8?B?RFJodzVCc0VvY1hKQXhSVmhLZEQxVEVzbmJxQ1F5NUYrRWFZNEgweXJrV1Nh?=
 =?utf-8?B?REVDS1RxL0U4ZXZ5Y3k0cDFjN2hUSkdEdCtsdC9aTWs0SjBRYVBOc05Za1l6?=
 =?utf-8?B?YU9FMzNNSnFLOHdUOUx3dFRpSTJUWWJDdEdRM2U2ZldEdW9LY2ZFc0pRTmMr?=
 =?utf-8?B?MlJ6aDNVZVZscjVKcHdNN05FbVZFS3V0YTJYNzJnUm9kSWUvWGYrTS9uOGYx?=
 =?utf-8?B?b25aMHFvaURVeU10MHBNc2VNbnA3Uzd3SGpiRGVnRTI3UUwvTlJtbUM2cTN6?=
 =?utf-8?B?a2RnYVBPMXFrdGhUa0hTVjhxUXNHcUFxUjRyRngvWHQ1K3ZjT3RMZXV1cmQv?=
 =?utf-8?B?QXlVMVB0TldOWWJHdnFBdWlRdVVHZG5HV3FkTEpkQ3JONERTSDVXd2VlelRL?=
 =?utf-8?B?NjU2dzBBcTliTGtIRmE2YmRKQkM2N2NxcDNxQW94MGpNZGlrZzc3Q1puZ1lw?=
 =?utf-8?B?akZqU3lxc1lMWVFCOE9KT3AxZkFWV2Mvcm1VbThTRkxsY1lmSXU4QzFPMEt2?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f578835c-ed7c-4fc5-c03f-08ddf67644ae
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 05:43:17.7291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewdfW6xEc+aafxwr6yvlYg2L3Fq0M7Hae2f7JNIwD1jpC8wLR0ZTFml/J8Wwsxa1PfHqIAQFHedgQUkUHsZI6IwAG1novg1eSPJlWAdwYow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9105
X-OriginatorOrg: intel.com

Hi Babu,

On 9/2/25 3:41 PM, Babu Moger wrote:
> The io_alloc feature in resctrl enables system software to configure
> the portion of the cache allocated for I/O traffic.

(repetitive)

> 
> Add "io_alloc_cbm" resctrl file to display the Capacity Bit Masks (CBMs)
> that represent the portion of each cache instance allocated for I/O
> traffic.
> 
> The CBM interface file io_alloc_cbm resides in the info directory (e.g.,
> /sys/fs/resctrl/info/L3/). Since the resource name is part of the path, it
> is not necessary to display the resource name as done in the schemata file.
> Pass the resource name to show_doms() and print it only if the name is
> valid. For io_alloc, pass NULL pointer to suppress printing the resource
> name.

Related to changelog feedback received during ABMC series I think the portion
that describes the code  (from "Pass the resource name ..." to "printing the
resource name"), is unnecessary since it can be seen by looking at the patch.

> 
> When CDP is enabled, io_alloc routes traffic using the highest CLOSID
> associated with the L3CODE resource. To ensure consistent cache allocation
> behavior, the L3CODE and L3DATA resources are kept in sync. So, the

I do not think the "To ensure consistent cache allocation behavior" is accurate.
This is just to avoid the possible user space confusion if supporting the feature
with L3CODE used for I/O allocation and L3DATA becomes unusable, no?

Also, this also needs to be in imperative tone.

> Capacity Bit Masks (CBMs) accessed through either L3CODE or L3DATA will
> reflect identical values.

Attempt to put it together, please feel free to improve:

	Introduce the "io_alloc_cbm" resctrl file to display the Capacity Bit
	Masks (CBMs) that represent the portions of each cache instance allocated
	for I/O traffic on a cache resource that supports the "io_alloc" feature.         

	io_alloc_cbm resides in the info directory of a cache resource, for example,
	/sys/fs/resctrl/info/L3/. Since the resource name is part of the path, it
	is not necessary to display the resource name as done in the schemata file.

	When CDP is enabled, io_alloc routes traffic using the highest CLOSID
	associated with the L3CODE resource and that CLOSID becomes unusable for
	the L3DATA resource. The highest CLOSID of L3CODE and L3DATA resources will
	be kept	in sync	to ensure consistent user interface. In preparation for this,
	access the CBMs for I/O traffic through highest CLOSID of either L3CODE or
	L3DATA resource.

> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

..

> @@ -807,3 +809,40 @@ ssize_t resctrl_io_alloc_write(struct kernfs_open_file *of, char *buf,
>  
>  	return ret ?: nbytes;
>  }
> +
> +int resctrl_io_alloc_cbm_show(struct kernfs_open_file *of, struct seq_file *seq, void *v)
> +{
> +	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
> +	struct rdt_resource *r = s->res;
> +	int ret = 0;
> +
> +	cpus_read_lock();
> +	mutex_lock(&rdtgroup_mutex);
> +
> +	rdt_last_cmd_clear();
> +
> +	if (!r->cache.io_alloc_capable) {
> +		rdt_last_cmd_printf("io_alloc is not supported on %s\n", s->name);
> +		ret = -ENODEV;
> +		goto out_unlock;
> +	}
> +
> +	if (!resctrl_arch_get_io_alloc_enabled(r)) {
> +		rdt_last_cmd_printf("io_alloc is not enabled on %s\n", s->name);
> +		ret = -EINVAL;

The return code when io_alloc is not enabled is different between reading from (EINVAL) and
writing to (ENODEV) io_alloc_cbm. Please be consistent.

> +		goto out_unlock;
> +	}
> +
> +	/*
> +	 * When CDP is enabled, resctrl_io_alloc_init_cbm() sets the same CBM for
> +	 * both L3CODE and L3DATA of the highest CLOSID. As a result, the io_alloc

Not just during initialization, they are kept in sync during runtime also (when
user writes to io_alloc_cbm). First sentence can perhaps just be
	"When CDP is enabled the CBMs of the highest CLOSID of L3CODE
	 and L3DATA are kept in sync. As a result, ..."

Reinette

