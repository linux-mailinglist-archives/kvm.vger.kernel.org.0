Return-Path: <kvm+bounces-71202-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eKCeNBwAlWlOJwIAu9opvQ
	(envelope-from <kvm+bounces-71202-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 00:56:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 79565152106
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 00:56:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 82911303131C
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 23:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC8737AA9C;
	Tue, 17 Feb 2026 23:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mKCQiuXx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66672284B3B;
	Tue, 17 Feb 2026 23:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771372559; cv=fail; b=N6kqpUESbPpiPlcvfNyxKH8Cyh2lhtpcNlBYnTEGGvr97LPQICHyhQu8kKmkIoES9qeu5pWTjV7OljnBZSxRQ/0SGBTBofjOpMP1RbeIszrjOY6mfZFCUwVL7buRQtusoSGPangVQF4dt6hRvP3RfDnVTJZIRsdB3gWdGEVID3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771372559; c=relaxed/simple;
	bh=tjshRumbMnPcwcq5UZ4Yo2sIucKXsvNcG3kaSArOC/g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XTujxCIDUOACcahGUyHYF5A5hmpnkqEq+VoWKY1JVLP+z1ktDM8ZYaaRWYSr3MvHbmS8jm+0EYrFgp0r2ShpTWNHslwmSQUquXqtiG2Fo4k3rKfiM4e5Stdg9/cdu2i/zrcRYqTabt0Z3M7XiVrESj1xDArlAf19PV2Qs8CbF50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mKCQiuXx; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771372559; x=1802908559;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tjshRumbMnPcwcq5UZ4Yo2sIucKXsvNcG3kaSArOC/g=;
  b=mKCQiuXxyy5bnvQRHfu5ptqOXbi90RDn2lmx9XDmKXou7jI01lutI1OP
   dpDEfHBrRhOt8Nak84L6Aul9kZil6eLoeS5rc6/NLcDymTBCSBNcxyAMi
   bUI6tHsxwJV/jewgKJFfhI35TSVqRnBan8IB+J+4wI8A0rxRKLpYUGnmF
   /hlOdcQ5/QHQLhGzcvgqXiKf14IbVaM9uYOXE+S7vEbYSKGiiCX6u45Vd
   F++JexUsdY+u+O7X/+JOdPJYG4smj8P15TLcz8OjDqinqNvWIm82BhvLD
   8SWc9HcZpq8L+LyPyBm6e4nVzo8iDrY6HAzREWHeoUWWofImWpYiOkiR6
   w==;
X-CSE-ConnectionGUID: 4j1Bpr1YQKK3L99X3+nUPg==
X-CSE-MsgGUID: BMic/QAYR1+K8YUHZgsYbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="72342077"
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="72342077"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 15:55:58 -0800
X-CSE-ConnectionGUID: QNNVFd3fQp2PSezNvCpqsQ==
X-CSE-MsgGUID: vbiolbdTTE+ln7rDf+EVTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="237041635"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 15:55:57 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 15:55:57 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 17 Feb 2026 15:55:57 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.40) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 15:55:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gk/aN+cSzZOT2AemQAiA7p394r+a69HD4E4na8SVkoE0hpN1QyNIQlFwn5CquIJ1gdpFOOb3Sn7ZE1KMMAcX/JY74qOpnyKR3aFTikkFQq2rfAafJ453/aALHh9X7AC3NHGK+adRfBARz7l94J7WleE9N3Ql9FVCgzWABcJrV/6sBdUo5ENEh0iv5ZbJ4SOebTVUc7E4JHm3QyqEpwxpDM0P9tdREia12M0U1JugUl+FZh6BeoSaLzbVexsq4as41cxDm+Haql0pAupsDhQUeNcW/LgPYSuFR0IekRnKEZAgL+ZNA99WcLW2uWBYQPtlbBv5jpPCaQyg8EeeFVhFwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBNQHh2Aybc06FAqnE5vEe9TYoT0uPfJpO2VBPeXEhI=;
 b=fIquBlz9nvuLkySByLlmbsKgG7FItokqdVwubAxrv3a0ixJGdg6et6885BGqzS4caG4ZIAFOf8frNQ6SkgevvzgI9HTr6/ZYvX2viXHm4m9wbhjuV4YD44jsJBK8tkPWFg2YbixvPELHWkK1IhX7oEt2Xn8WndAjwBIuovbZ+RDpCxjQTA6O9IuzS0geO5BHk6jaUTgQt1Wqbfa5gfPHgxPBDAMcf79/pBM+VHq12O0nuF5b7amlkkDNfVq78Oi1SPd1jTl+YlHNWJCilGxKRUVvGd4MQerDpA7be2sRurNJ3FdoZGGgryUwBPMziMut/OcaGfhCTqpmBrpHacJxaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB8203.namprd11.prod.outlook.com (2603:10b6:8:187::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 23:55:54 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.010; Tue, 17 Feb 2026
 23:55:52 +0000
Message-ID: <65c279fd-0e89-4a6a-b217-3184bd570e23@intel.com>
Date: Tue, 17 Feb 2026 15:55:44 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Luck, Tony" <tony.luck@intel.com>
CC: Ben Horgan <ben.horgan@arm.com>, "Moger, Babu" <bmoger@amd.com>, "Moger,
 Babu" <Babu.Moger@amd.com>, Drew Fustini <fustini@kernel.org>,
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
References: <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
 <aZTxJTWzfQGRqg-R@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aZTxJTWzfQGRqg-R@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB8203:EE_
X-MS-Office365-Filtering-Correlation-Id: 12d8481d-fef9-4541-85c9-08de6e801518
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SjBGS0h5czZDQVU3L2pIVktuemVlT01NelV3RDcvZlBtRFNDR1ZDMkZoTmVh?=
 =?utf-8?B?c3NBeXhJZU1SUHZaV2cwSHN6SnFNcE84bGJ4L3F4ZDdmSWZMeHhZZHIzUDJB?=
 =?utf-8?B?d2hnRE1pS2lvOFU0WVJMRXZZbU96aUhDQm81ZHJwTWFpNURuTjAzY0FrVGZp?=
 =?utf-8?B?aFljaUJYbDNUclFja2VkRm8rb2lhK3UzdmFvdStRMlBVWUlrc0RYR2FRUFNL?=
 =?utf-8?B?NGFVV3h5WWVpK1RheEc1TElteDg4Y3hkYU9Lb2doRGIvUW9JNjY1NXVxUUNO?=
 =?utf-8?B?UU9KN001N3lmdDgyQ0dJM1B1OG4yb291ekoxTllGOTVUam0yeG03LzcvTUc0?=
 =?utf-8?B?QitQQ2hTbzBmSFFFZktJdlBoZTk2TnMzYXQyYXdVRVVENVRVYWt6WW8xNHpH?=
 =?utf-8?B?bmRickZPSFVDV2JuWnBuTmk4RUc5U2RkRENUVzgycXRXa1pZcGJRSnZ2U0Vp?=
 =?utf-8?B?OS9JV050QXVqZnkvVEdSSEVFVUdJemt5QVQwOGZTbVRQdkVEWHE4MHZlZUVG?=
 =?utf-8?B?MDYwSENMMGFIbjJUQjV3VElyODlPcXZ1ZWN0S09yS0g4bndwVGhrTTlDTm5w?=
 =?utf-8?B?c2RZWVNpWTVRWDhNTFloVkR5K1VoV0xPdy81RDFEZEMxNUJjU0ZGeU1vSFll?=
 =?utf-8?B?WUVSS0VsUlFZaWhwWVRhL0F4dHhTUzZSZitSZ081dlFYQmkzbUVOeXp0UDI3?=
 =?utf-8?B?V1BHaW9HNWlkMmhESWhxR3QvN1BGeGgzajFkV2QrK2M2bGFnRHdIWkY5SXRX?=
 =?utf-8?B?aUgxbVUvSnhVcE1JVlg0RU5kVWNKT2tlVGdBaS9uaTNJRHY4bTk5RjhtRm8w?=
 =?utf-8?B?aUltZ0dHWEsyQ0pRTzQwT1pYZE9yeWhQaURQaUFjcjRQNVBOc3ppYXFyR3ph?=
 =?utf-8?B?U250Ky9rdFJkVkZ6YkxCSi9oREFMdDZhS2Yvc0hEK3Q5TkpveHcwOTJ0ZDBs?=
 =?utf-8?B?dnF4alVNTk93QXJoUnYvTFRoekJzanpWZlBzaGR3VE5mQ0xFUEpxNTlDb1F4?=
 =?utf-8?B?VEJlcUtDVUlDSHgvQkhzRitHNGFzQTZ2QXg5N1Q4UWFRdjdES2pXOWpSOTVs?=
 =?utf-8?B?RHlJOUZLWDR6WW9hTWhIZ3dLcEVIdXFnVkl5ZVdMQU0wMGdId0NEZWZUNWIv?=
 =?utf-8?B?T2srWkJYN2k3SThCeVl1ZTRNN3UwZmZnNGtNYnZKWGxleU5KMmFVUG52aFp4?=
 =?utf-8?B?Z0xROTFPNVJaRVNkSlRTMUh5ZE5rc2JoMVpCYjV6RGx4NDgvQks4bDFrbEEz?=
 =?utf-8?B?OWpBYnV5Q3BUem5ObzJOdFplVXQzamJqNnNHOHBNZ2NDUTJNVmRNNFgwbVFt?=
 =?utf-8?B?NGFINk1sMlBqZHBkRC9uT0FWS3dlZVp4ZUUzS2dlUzZ1NXFDTVhkdFRQOEIy?=
 =?utf-8?B?eXE5UjVXWTR3bmZ1NGdYUTVmTk82aHdoVVdrSUtBZFlSc2cxdFJadG5JeURx?=
 =?utf-8?B?T21CWW5XTUlZNnQ2L2lXR2tQT2c4Ykhtdzd6Y01MdjA5anJRN0hLUUlFTFVZ?=
 =?utf-8?B?SHhhQXBISGJ1eDV4YVVXY3ozTkxuLzJienVjelF1ak5JOW1JeFp3NEZsWGZP?=
 =?utf-8?B?dFdwRGRCVzBiaWxzNHF4aVBIbW5jaW9pTFBTWklkNFYyZUIwWWppYWdPdVFJ?=
 =?utf-8?B?b2Z1OWJwYVBJc09UMVJFMDRTTUFWc2w1SkRSZ25XMWl2RC9PaU55Tm1MT0Qy?=
 =?utf-8?B?RnUxQXIvOFpvQUJuWWVRVHFEbVNjaU1YNkJMcW1zcW5uY2xNcUFkbEdsbUNK?=
 =?utf-8?B?dnEvYUNkM09yS0F2OVBIQjF1dEVIcHd5U2dId2E5d0pkZEVaeEJSMmxjU0Vt?=
 =?utf-8?B?V0VzaWFDN1BHYzU1eTZMRzVvZmhkWE5FOWw0RXAvVGM2Vk9SMGttQ1hjd1Jy?=
 =?utf-8?B?SEZnd2xZQk9YL1RXNy9yWFNDeW5zRGN0ZGtEUlVrS1NEdytDQUQ1TERPcndt?=
 =?utf-8?B?VkxzaXRrUW14cStqNFloQUZqVTQ4V3duekpmcWpPRk05bGFXSGZHSDlLWVYx?=
 =?utf-8?B?eERoV1NHZWFIa1A2Q2M5WmVnMGZJVmtHV0tDMDVQNmVYRUwyWUpNVjZRaEpo?=
 =?utf-8?B?KzZGdG1UMnkvVHg2em9MdkZFeE9OWHozZSsyVFViNS8yaEtDUDFRS0h0U000?=
 =?utf-8?Q?ysWQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eE5Rd3B0MmRRTnJZSTd2ekJHYXFzSHFobktZU1RodE90RzNwNUQ3N1Q2am5W?=
 =?utf-8?B?bGJxQ3pSU0hFQ1lEcjQ5aHpEcTMwdy8vVHc1d0pZR3QzMnd0UWVpcFkrRG1u?=
 =?utf-8?B?YnAwUUUwUGxDbmhLOW53dFNYMEkwclllWEltbythSUZ4eUJzSS9nVFJPNWRp?=
 =?utf-8?B?YUlQaEpCaXVmdzI2eDFKNWFBTjJKY204d3N4TXJTOUJEY3c1dzE1RU1XK2dr?=
 =?utf-8?B?RW9HTnJGWEpnd1djSVJRVmNocmgyV0dac2hiN3dqK3dFWUdHN2N4L3BWN2tp?=
 =?utf-8?B?NnZzV2RsdGN5YXBSQW9mVElhR3gxTzVQS242dWJUT210NmhUMmg1UlNCekJ2?=
 =?utf-8?B?SjVpazFiRk9oZ0l5NnRTY3V6Z0h0c3Q3dlR2eWVmRkhXUjArVUdiemszdkE3?=
 =?utf-8?B?NlFjZnR6c3VtMjVSWVludHlJZnZpK0xuQ24xYm5kWkMzaHI3bU9uaVJweXl3?=
 =?utf-8?B?QlNkVVhnczJwVlhkcmNhakFsbStXTlVnNkoxSTVjUW5PNVlhbms4cjJlOUZ6?=
 =?utf-8?B?eG5TVW1TNkVnQzVON3EyU25MN1NTYW5NcUY2djQ2SmlBR2RFOGNOeUxwaWdJ?=
 =?utf-8?B?L0IzNm92MTA1Z2pTYmozRTBGUmV2YWtSNjhacSt0OGJ5MHpueFBQbVVtMHNW?=
 =?utf-8?B?dUhtTmRMT2FlYkh6OUUyK0I4TVI2aFJHeHBoZ2FoRmo5Y3lMWVRNSXl2aWFh?=
 =?utf-8?B?TXd5L2UxUzR6UDJNRW95Q2VOakJCVzQxa1dxdDRpVVMxcVVlUEpyWWhuWlJ3?=
 =?utf-8?B?WDZVTGNjNk5GY05mMkdwYW9ZQy9VR3RBQWx6N1M2YlpDL0JaeTZob3VyUHhL?=
 =?utf-8?B?VHRhM0sxTUNVUkdLZUFNRUFMNytiNEt6cFhZNUJPQW5COHJpZU43ZjQ2L0Rj?=
 =?utf-8?B?Y0w3WW9oY1pVWG01cUVFWGhZVHFWaitma3loNWRNUXdGcGlFUG5FdjJNaFdL?=
 =?utf-8?B?S3RyQk1qTndKZmRIeFVuc05JR202azY5K2txam1oUXJRbjlKZjNoMFYrM2xy?=
 =?utf-8?B?OW95cHFCUHVJMXJFTWp0cm5CTFU3dllYUjRUQ1JHSE9wVDF1MWNnaTRidE02?=
 =?utf-8?B?SHVhcll3VFJPOVN5WnN1b3ZxOENnV2lTWG9vWjFYdkJ6MnpkenRWVDRwWWd1?=
 =?utf-8?B?REwrc1p1VVpWZUhsbWc1QlJKNDhVT1ZuVU1rbTROZVRjSTFWRVZQOGYzN2Fx?=
 =?utf-8?B?S1lVbGRaSlJzR0NGOEFPdmdjOVlQSyt5RUhPSDhQWjFXR3lTam5Yb1AxODJ0?=
 =?utf-8?B?NzZqbHpncTNwN3NOZVNtU0g3NEE5dGcwNTFjTHI0VGdOZTZFZFNlbERoZlJs?=
 =?utf-8?B?dEVTOFMvdll2NUZxT3F0SnpmRDI1cXRiYi85bHg4MWxpaUtYVUR6NjIrVW5x?=
 =?utf-8?B?MlpDOENudWNvTEptSU05RUhMY3VBRDRmOVpaME1lUkhkNkZrb2VDcjROZmJS?=
 =?utf-8?B?SHVhaDk5WEtsTmYxVGlMekRjUThLT3l5K3c0ZjRuaThzbUM1LzN1STVyR1Q3?=
 =?utf-8?B?RjZKZHRhUmQ2SEQ3UThWaDZFcHNJUkY1c0toZ29Jc21hWUR5YW1PN1F6anRI?=
 =?utf-8?B?MXdkSUxZZnp4WUQ2Q1hTUURBblJOV0UvQ2tBVFRrMDBtQ3h4Q1Iycm8wVUVv?=
 =?utf-8?B?ZmFXdzI0Mk4vcmVoNk42L3F2WUNKK243dFlKcURvUWVTdHRVR3dFc2s4WTZq?=
 =?utf-8?B?aWRiL3p0Mmg3VDRyS29ZT21oL2IzQVpxYmt0elQ4cENHYUVYcURUVDlYWmw1?=
 =?utf-8?B?dlpKaTNvSVJ1OTgyWW53dlVOQ3F6aFlXODlFRTc3cmh5anRQdmtzeDljTk43?=
 =?utf-8?B?andyNUlYM0lSc2h1OGNaSUU2UEY3dFBuWHF2WU93eGVrRU1XQzJ1RWNVd3VC?=
 =?utf-8?B?YVNKd1h2N2NWNjdLK1U0bjFsV2pPSVppNXVuQ29yc0VxaklnTkVtUllzWE54?=
 =?utf-8?B?L0V3NWlpRm1xRDNTRnpWcFhCTms5SmY4NTFXRVZDZGRJaUlLQkVqWXpneW9E?=
 =?utf-8?B?SytBaHlBYmdrcjhNL25kZ2tVSnBDd1gweis0YUgxY28xK3h5SEluNFhFbXdz?=
 =?utf-8?B?OG94WGhodGV0dFdXSlRBV1RJb01GMGJqbEVYRE44SGdFT29lYzFmbEZBOVZw?=
 =?utf-8?B?QmozaEwrRUd6L09meVpuS3ZYSkZVQWZPTFBVVVYyc3dqSDNDU1dIb0lrM3N6?=
 =?utf-8?B?cjdSbU9kRW1OcTZOUmtJZm5lWGRranNCblFQS29TM1UzVjdBTVFKdEdDUFZS?=
 =?utf-8?B?aTRBdGVkNEQzajRuUHo4Yyt6QmdPUHJENEdoeEkxQWtOWVZ3Z2hxaXlOZGNX?=
 =?utf-8?B?S0F4ZlJzQ0JYbzFLR050Y0VRT0tFbjhIZ3hwTzYycVVhaU5ZbHpQOC9rSGpL?=
 =?utf-8?Q?VhL2JVsg1T+FKs14=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12d8481d-fef9-4541-85c9-08de6e801518
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 23:55:52.3404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qr8wyArx13aZ7kWMZdXHt0gc4avPH11WyO3BStXmpnHEhHkG6zJUl7M25UiJxLV64MMJHnZOCKdn8pd1RzP+h9j4rXs5u6KW5BpR8AGXSY8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8203
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71202-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 79565152106
X-Rspamd-Action: no action

Hi Tony,

On 2/17/26 2:52 PM, Luck, Tony wrote:
> On Tue, Feb 17, 2026 at 02:37:49PM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 2/17/26 1:44 PM, Luck, Tony wrote:
>>>>>>> I'm not sure if this would happen in the real world or not.
>>>>>>
>>>>>> Ack. I would like to echo Tony's request for feedback from resctrl users
>>>>>>  https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/
>>>>>
>>>>> Indeed. This is all getting a bit complicated.
>>>>>
>>>>
>>>> ack
>>>
>>> We have several proposals so far:
>>>
>>> 1) Ben's suggestion to use the default group (either with a Babu-style
>>> "plza" file just in that group, or a configuration file under "info/").
>>>
>>> This is easily the simplest for implementation, but has no flexibility.
>>> Also requires users to move all the non-critical workloads out to other
>>> CTRL_MON groups. Doesn't steal a CLOSID/RMID.
>>>
>>> 2) My thoughts are for a separate group that is only used to configure
>>> the schemata. This does allocate a dedicated CLOSID/RMID pair. Those
>>> are used for all tasks when in kernel mode.
>>>
>>> No context switch overhead. Has some flexibility.
>>>
>>> 3) Babu's RFC patch. Designates an existing CTRL_MON group as the one
>>> that defines kernel CLOSID/RMID. Tasks and CPUs can be assigned to this
>>> group in addition to belonging to another group than defines schemata
>>> resources when running in non-kernel mode.
>>> Tasks aren't required to be in the kernel group, in which case they
>>> keep the same CLOSID in both user and kernel mode. When used in this
>>> way there will be context switch overhead when changing between tasks
>>> with different kernel CLOSID/RMID.
>>>
>>> 4) Even more complex scenarios with more than one user configurable
>>> kernel group to give more options on resources available in the kernel.
>>>
>>>
>>> I had a quick pass as coding my option "2". My UI to designate the
>>> group to use for kernel mode is to reserve the name "kernel_group"
>>> when making CTRL_MON groups. Some tweaks to avoid creating the
>>> "tasks", "cpus", and "cpus_list" files (which might be done more
>>> elegantly), and "mon_groups" directory in this group.
>>
>> Should the decision of whether context switch overhead is acceptable
>> not be left up to the user? 
> 
> When someone comes up with a convincing use case to support one set of
> kernel resources when interrupting task A, and a different set of
> resources when interrupting task B, we should certainly listen.

Absolutely. Someone can come up with such use case at any time tough. This
could be, and as has happened with some other resctrl interfaces, likely will be
after this feature has been supported for a few kernel versions. What timeline
should we give which users to share their use cases with us? Even if we do hear
from some users will that guarantee that no such use case will arise in the
future? Such predictions of usage are difficult for me and I thus find it simpler
to think of flexible ways to enable the features that we know the hardware supports.

This does not mean that a full featured solution needs to be implemented from day 1.
If folks believe there are "no valid use cases" today resctrl still needs to prepare for
how it can grow to support full hardware capability and hardware designs in the
future.

Also, please also consider not just resources for kernel work but also monitoring for
kernel work. I do think, for example, a reasonable use case may be to determine
how much memory bandwidth the kernel uses on behalf of certain tasks.
 
>> I assume that, just like what is currently done for x86's MSR_IA32_PQR_ASSOC,
>> the needed registers will only be updated if there is a new CLOSID/RMID needed
>> for kernel space.
> 
> Babu's RFC does this.

Right.

> 
>>                   Are you suggesting that just this checking itself is too
>> expensive to justify giving user space more flexibility by fully enabling what
>> the hardware supports? If resctrl does draw such a line to not enable what
>> hardware supports it should be well justified.
> 
> The check is likley light weight (as long as the variables to be
> compared reside in the same cache lines as the exisitng CLOSID
> and RMID checks). So if there is a use case for different resources
> when in kernel mode, then taking this path will be fine.

Why limit this to knowing about a use case? As I understand this feature can be
supported in a flexible way without introducing additional context switch overhead
if the user prefers to use just one allocation for all kernel work. By being
configurable and allowing resctrl to support more use cases in the future resctrl
does not paint itself into a corner. This allows resctrl to grow support so that
the user can use all capabilities of the hardware with understanding that it will
increase context switch time.

Reinette


