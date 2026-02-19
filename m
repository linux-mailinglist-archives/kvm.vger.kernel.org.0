Return-Path: <kvm+bounces-71364-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QArWETxYl2lPxAIAu9opvQ
	(envelope-from <kvm+bounces-71364-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 19:36:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 15140161BA6
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 19:36:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DA71B30055AF
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 18:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C30C2E7164;
	Thu, 19 Feb 2026 18:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DdO9vp82"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F3710E3;
	Thu, 19 Feb 2026 18:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771526196; cv=fail; b=YMhBHsy+OiZ2SZu+qmxbfwMnXq9X5ovo7E+Ufrgh2/cSZb1oIpMc5oWG6pkZRswRBMIKLHu2d7FPNAU5xxZhS2WiIgjEsp62ceYx2d8LYjZTUZXpamN6QhQZ6P5kAeqHRJPeTM62O3ER5Z6mqMKK6q2jjligadbZgxRD/7Q6FFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771526196; c=relaxed/simple;
	bh=5pTzjbX9sGOcSgRPiCq4QPs9c2oFB6K4Zl9OfNyM/cg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o9jFeqAHLOLfuZ+lMcm70SQtHpl4k27YsgkLYMGJPKpgX8B2tuWW6vJw/of2IyC1gnyzaILr57eb2PcuAaLFgdyDgAqQgHzgsT4JeUFxzhfSt1bPi8bKobVOmju7zINLXh5IFFFMmUAKpGizbIXrOPa8hQZ6XFrsrEI+Ligpffo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DdO9vp82; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771526196; x=1803062196;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5pTzjbX9sGOcSgRPiCq4QPs9c2oFB6K4Zl9OfNyM/cg=;
  b=DdO9vp82Z0huhK8vufoOr+vG5dRCclu6y9oArVLzmHYaRgXtQ8yPgBsU
   g6nobh0p/abJmP44paIDQ99gnePt3p0HTTfjw7TxkCLvjJ5+PGrUEOtf4
   qc9dJKhYgDce3ceH/rFfHKH1WY5wRt9YAOHXBGoFYHWEW/WW8RLTuoK0y
   wCigAGnu4WBv8g2OBg8iRd+t3WU/aNg8K7lN7AhEANCH9wv9Tf6TxuP8T
   YGziIZc1aoIKajbg1s9XET1mzR59Mkoq6L4B8vfUl5+jLA8HnC8HV48Ir
   qgtBY5KaEZ6JNvTEt9uoIkMWhfiUaTb7SbUW5l42Mj2ZFh2eio7Lw65XC
   Q==;
X-CSE-ConnectionGUID: au6Ig9hITjGrcSZiVZpEtg==
X-CSE-MsgGUID: V5fCN5vdQT+DSbOooD5gcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="76456830"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="76456830"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 10:36:34 -0800
X-CSE-ConnectionGUID: 13BJ8U7YTVK0UcQF6luY5w==
X-CSE-MsgGUID: cG2j9HhZSwej6+6sAE73Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="212820563"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 10:36:33 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 10:36:33 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 10:36:33 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.23) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 10:36:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=adtP6mlglXBCIJHXeUvLruhxN+RJTSO6nS5go84SN3G021WKKyq+BRbXFEgol02dpk7c59rjmPVE6GA54Q8CMNkUyJmatbpaJMg0yrMUHxSDq8EiQG5hmzTfqf5qfPjJCqpKU38g2ZNoEVJKHtflRTcx/lJYQ2a2sbeTCGjuIOGdBnNGknOonBhs0R1xbDYSw53wvtjKyAf7DEVkZze9yPX2/k7nhlnB/stDl/tDfrH+8fawYAyt3dboM2csQFvcvojy1jwRBdR9gXwnfCMV+wSFdYzjjOUcDwfbuZmDsO7M/kSb0ncjLdgBeayyk4FCe/Zeo83Y/ej4yFJWGhgkJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+xiVRi0cPO2MqZMUNFgJifs4r9YvwvXJIhEx+MzJGk=;
 b=Y835piXwzLRYgRibYlP34M0Oc/Gd10X0pP6TbuEV+u8rs9EkYgr92Qs8h2iw3Bl7O8X4SYFejeUBfjGWpdrJR6YEnuEYJmVdQlMiTIbKIsNRrP6dye8SseTc1PkBxt2RJWEKbABjb3NV+sqyOhTSlL8RxIHAx+aewdu2RpDpxFa1FGFvPBqubszbgYdnLTQ7zrjz3RytSj8RvEbtwimsDakd+5uHb7892oW36IAUY0UNOSvoVsYnZH9FGKo0vi2OBSfoRWiAD7D2vWrXABhCVvS3Ph2AxR6N1PrU86MdGGeaMNVLmMPMSb7owF/wTS1Eiv6ndW4ZPa8YiZdRlZnvpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN6PR11MB8217.namprd11.prod.outlook.com (2603:10b6:208:47d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Thu, 19 Feb
 2026 18:36:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 18:36:28 +0000
Message-ID: <5c19536b-aca0-42ce-a9d5-211fbbdbb485@intel.com>
Date: Thu, 19 Feb 2026 10:36:24 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Luck, Tony" <tony.luck@intel.com>, Ben Horgan <ben.horgan@arm.com>
CC: "Moger, Babu" <bmoger@amd.com>, "Moger, Babu" <Babu.Moger@amd.com>, "Drew
 Fustini" <fustini@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
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
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>, Zeng Heng <zengheng4@huawei.com>
References: <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <1f703c24-a4a9-416e-ae43-21d03f35f0be@intel.com>
 <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <d995e00d-2b90-4df4-a067-c4c76979e499@arm.com>
 <aZdSdXi0KtEf8Mqj@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aZdSdXi0KtEf8Mqj@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0205.namprd03.prod.outlook.com
 (2603:10b6:303:b8::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN6PR11MB8217:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a373d33-5c64-4bc6-ab16-08de6fe5cb34
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RVAvd2srdlIxMXdjNUx5OG5ROUtkUjNLajZmZy9ic1VJZEwrejVDb0U1M1Rt?=
 =?utf-8?B?amhpbTFvNm1aNFFnY3VPYWFVNmhZSnVLbzUxS053WnZDMzV3aEpOdkNaRGVt?=
 =?utf-8?B?MXUreXFlelZ1NXBKVitCaUg3ZmZyQWFySGpJZkhpcFRJMEhqcW9xdWxLVUNB?=
 =?utf-8?B?MTVMaGU3RW9sSTdIZmJSanBMSGxGcE1XMDZtdTJmR1NVaG1kQlA5TnVLQWw2?=
 =?utf-8?B?WXI0OEtHTFJMbnRIVTVqWTlKQ1lkRVljQWUwZnBwY1B6RWtTR2NTWXY0Qkd6?=
 =?utf-8?B?QlFKdEJoZDBZL2NPZW5NMFViZlNqNGhJOExJUHNPaTFLbXNLMEJCbTFEZ2F5?=
 =?utf-8?B?S29Gb05nRVNlTEhvYUFHRjVlRlh4SjdJTDdvNi9jZVRvaTNZUVlHMlBKcVBp?=
 =?utf-8?B?RGhwUUt0OHI4c3pqdnN3Y1p4V2FoMjhSbkV1bWorZUwxbmFnWTlaVWgxbFMv?=
 =?utf-8?B?dXFoalRtMWFKTk5TRXJ1L0tMc0RYRXdpYk9hb2V2R3lGZEw4MnVTY1l3YWpi?=
 =?utf-8?B?MzIza1lTczZ2c0VMcHVIdHlxMEJpM0luQzZBV0hoS01tWHZwRDEyRjJFb0ow?=
 =?utf-8?B?VnVkY3pJT3NmYm5lNnMxUUpRQWJVZ1dGVUVxa1V5RlhrNHQ1Rk84SElvamZS?=
 =?utf-8?B?R2ZwazdNQ0cyYTdHL2lJd3lVTThmM095SDV2c2FUUkNqRVJQMHVncTVUeFNW?=
 =?utf-8?B?QTAvWWF1UXptblE4Vy9UYXR3NGhhdysxS3I3dUsvRUdGQmplN1Z4R0pUL2pI?=
 =?utf-8?B?ZERaWE1rbWlaSEt5QlVJdTR2TEUrM2t6N0pWZzMzUjIraWEwQkJJVFRRVVFw?=
 =?utf-8?B?NWhvRkgyT1VxNXZyd25qa0FCK1ZkREhBWXA0YWRCQTlNVTBPS2g2R3ByS2lt?=
 =?utf-8?B?VEFWNFpjZ0NxU1NDOFkyWG8rN2dpelZJbjlQbFNQMnhHUkxJcVdwd3BteDF5?=
 =?utf-8?B?VzQ4ekVURU94YWVNT1BIYXZBY3JDL3Fjb1pWQlNPZWxDNk5IZWMxYitPSXhF?=
 =?utf-8?B?SnlSSy9DcElEZU83cWhmNUIrVE5uZEhDcXFHTW9ORzlzQXpyNEdRRlo4TkpV?=
 =?utf-8?B?dHhPa29laVBFQUErdURLNUpVWGxXWVVRc25SV0w3WWlLUUJUTzdCQk9QTmFl?=
 =?utf-8?B?RjBOTkl3cllXQmFhYk1iOEhDYSs0SlVDdHJ2NWlnMHU4THdlVEpYcHp6MEl2?=
 =?utf-8?B?dm9ONGN1N0JVMUx4RTg5UDAxVm9SdThCdTZ4Z3dPaEE4Z0pWUjRKdnlUaVFK?=
 =?utf-8?B?enlUQmpWcFVONG45S3hmTzJESktQSFRCalhtaGEzbHVyYndZUjRkNTdlSGxa?=
 =?utf-8?B?L1pYMzJUbGhlRnhCcytlZ0Z4NHJmVVpOYTVMMmREZXdUZDUweGRURmxpczN3?=
 =?utf-8?B?aTR1eFBrUFV3NHZCUFQ5N0hMTTdKWGtHU21HRi9PVGNaU3ZpUnNBZUd3STZU?=
 =?utf-8?B?YkZ1QUlvZ2pkZ1dGcklqRkdKVG52YlRVd3hFUWZQSnNmNzdxdE5MVElaSkJh?=
 =?utf-8?B?ZVhTRitUTkFSSHJoRTl5NVFsbUF3TG5XR2JhbHI2cnp6VXJYS0ltV2tNYUxH?=
 =?utf-8?B?OWdBZGRva1VuK0NDc3RkUTJJYkV1L3Y1ei9MdWJhZjNXaUlJWVNOZ1ErV21M?=
 =?utf-8?B?cnRaTTJ5b1RkV0ZGQ1J4YUVjQjRZSG1nVTVNcnhiRzZCVm10bCtUbEVVVUhy?=
 =?utf-8?B?dUhZMnZSYkdBcVpyQndDaXdJa3BRQUpvYXJQTlJNWm11c3V2bDZZVHdCVVh2?=
 =?utf-8?B?R0QxTmRTbGZxZWs3S2gwTUp3aitSbkhqbTVmYzYwSStFZVJwL3BPVjhlZ2xJ?=
 =?utf-8?B?b3BJUTdSMEhzcmJ1N1BZREhXc2FOVFFmcTg4Wm1oS1dkRVFaKzFMNjZBd2w3?=
 =?utf-8?B?bTdiL3VyTUxZcFR3b2Vjb3Vra3NXdlBtUHJ0RWUzdGZoVk1BZyt6MWN0ZXNB?=
 =?utf-8?B?WXdqa210bERIUHluejUrdnUyUU0zRVpMeHpQMGMrMERaRnNXMXRnWVkxeEJZ?=
 =?utf-8?B?SzlYdThMQkZ1TU9Lelo3WGppeENWdjJ2cVUrVWlZM1NxaUFidlNuOG1BZ0pm?=
 =?utf-8?B?M2FiQ01COGJCMjRzTmRTdm5zbTE3aUdwZ0pFYWJRaVAzNHhBY3EvY3p4ZjJG?=
 =?utf-8?Q?VGVM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0h1bnNWUmNVc0w2NS9NdTdFRWloc0VoWnFPR2wxS3A0aWltb1I3dWYwRC9U?=
 =?utf-8?B?ZTdKQ2RCRktmN0UxUHVSQ1FJWjVtUWt2bThlakI3ZzRCd25ScDMyaGVGaE1T?=
 =?utf-8?B?WnpaM2JETFI0emZNaFF3a2phQXIyV1crRlcrM0JaR0I3bExFOG5DaWVHT2tr?=
 =?utf-8?B?UE1reW9DMjlnV3hUK3BMUmtTcFpPeDVtaWI2NU40enVkQytaclNkWmIwNzUw?=
 =?utf-8?B?dlNjaTlsdWI3dGk2bjdQZjdmV0FrUUhlMFJFeURrd3FnMWg2R1dyQSt5ZklO?=
 =?utf-8?B?NE9XMWozWFYrRG0vRXZ5N2pLVERyZHNONElHUnVrVjFVQ1Q4T1I5emZOM09o?=
 =?utf-8?B?YWZOTFZzUGlaVjk0RXFkRi9aMUpFVWJuMkppV2ZzUFgxMG9QQTBBSEh1TDU0?=
 =?utf-8?B?RnpuYzVsYjg4ZnFIck0vWXowOEVMV05GWFRMcGc2enlpcnNLc0ZjalhqaUNt?=
 =?utf-8?B?QURkdDNaSTVoRUFlOCtuRHlGdVdzbk41SUVQSFI1ZGtTeXdweFBReEp1MFcy?=
 =?utf-8?B?Z1lvdmY1RnBTQ1BYMmNWamdjWlM5Nko4VVdVNzM4ZnFGUHZkcVBaMnFUaGNX?=
 =?utf-8?B?alZzUmlqQWpPbTBXM0M2MnQ5b0tuVXlyT0tjNzNjaDJSM2hFNklsOTExL3Na?=
 =?utf-8?B?bmova2s1aXdRZ3VBS2pKd0dsd3ZiVmZlOG4vOVZyNHVhSXRJY3FRV1pMUUhO?=
 =?utf-8?B?TGtydW0yK2RlTnJMNnQvOTdQWEMxcndtZ0dVTGt5blJuTGpCc1JXUy9XVmh3?=
 =?utf-8?B?Z1NvbUU0OUhRZXZVV3dGenRvWVFKcjZ4ZzQ0eE9kNms2cmE3bUVpMU9zdmVK?=
 =?utf-8?B?NXFWNzgvRFVLUUdNWmYvRHl0SnZBMVEzdXJwNXVoVGgzUWNxNllLazhOK1A3?=
 =?utf-8?B?b3pWWVYvUkVDa016WWxIbkJaMGRTRjRuNE9qTm9RMmsrSjhpWTNiSCt4NVpv?=
 =?utf-8?B?VjBOVkd4UXBTdHNIZ1p4RFFRYnhOVXF2YnBqeE5hUkg2eWVUd0M0UDF1U3FT?=
 =?utf-8?B?SnF1YkEzd0RBUzdUUjFGNkJhK3dlenc1UDNTdmJYQkVITUdMVnFvVG8wbzBh?=
 =?utf-8?B?YlV4R2JtMHJhQzFURmFKUytPTFZPSU1venBIOEMrcmZ0R3ZMLzI1MU5NWnhJ?=
 =?utf-8?B?WDY4ajB6dlZzczAxTWVEWHRCaE4zY0kwZUNGekRtRGdpOWNteHlyZWNrclpY?=
 =?utf-8?B?eEhaSlI1RkZlZUJaRlI2VXZvcVVMbHFWSllmWnlMTHdPcjVjOGJaM29vT1dZ?=
 =?utf-8?B?Ukljb3oxbUI4K3YwZmlFTWVnd3E2bHowMElxbENqQ0Y3RkpydFdUNXBxN21m?=
 =?utf-8?B?cmlYT3BuUy9mcDQxYWhuTFNBSng0by82UVBySnRaaTZ6a1RUOG5PclV1T014?=
 =?utf-8?B?R1oyMENmNUcrQzNvTWJPYS9kc3ZEK1RJNG9YNlh1K291ZWk1STE2MGdYMHh3?=
 =?utf-8?B?V2s1UTBzM0pUYUlJa0NOb3EwK1NySnU0Nm96Zk5nb2FmZFVINnhpSFdjRS9Y?=
 =?utf-8?B?ODVDZWVwY3pUc21jRkRlY2pibjBjUmpQbEFBUUdwVTRvOTFHN0R1ejc4eUxp?=
 =?utf-8?B?QzFDSzNyeWZtY3Y4SndqdFpzWExlUVRJUkJuT09QMDNKTGhPSkViQkUzWWo1?=
 =?utf-8?B?Q2kxOWxtalplQzVXWmVnMENHaGoyU2NObDVzbmQ4Wk45RXNRQjMyYm9TWlA1?=
 =?utf-8?B?RjBkSWk2eEhMeUptSWlDSERyak5xZktybDBNazI0UTZlR2o0QkFwTm5uajM3?=
 =?utf-8?B?dHI1V0ltb1NVSFkrQUoyZ1BCMGg4Y0dwN3hHWXFsMCtOVGQ4MHJSVm43ajl4?=
 =?utf-8?B?WlRqcWZucm9MVkNQTC9UdHNpTUJDeHJlRzlyTGd1M0FqMHFuWXN0eVVBajB1?=
 =?utf-8?B?d1VTdVpGVDZuY09od3FhMER0c2NtYzBoMWRVQkN0dWxtUEdjSThQNWt2WkRo?=
 =?utf-8?B?TGFYZ09aNjJQdWlLQ1NsVWRLRERIUFpPREd0UUozRTgxTGhSWWhkWmxHMlVK?=
 =?utf-8?B?bXUxRlA1OUVoTi8rQ1NvUml1cVRSNUVwR2ZxZm0zd0lIRFAvUDRBNGVXekZl?=
 =?utf-8?B?bXJFdUsyMW1IU2tzNTNMQ01KL25wU0xlRWVSZnJRQWxUOVhCVkNjWlFKMTMw?=
 =?utf-8?B?MDVIUE1VcVZ4L1RvdldrT005N1NGd0hBMkEvdGVXbTNpL2MwaDBzeGJ6Wmdy?=
 =?utf-8?B?dWUySHhSQ1pNc09TTlF1L3plTEJlMk0rZWEydk1qZzVrMGl3OXA5VDUxYUo3?=
 =?utf-8?B?V0tXMmlNN25QZUE4dVAzU0dIWGdzMGwxclRsUUIxamQ1cjZUUmxjYzVtSDBZ?=
 =?utf-8?B?b1U3T1dDemRUUUFRWFNzUVpXK3BvR1dhSy9Hdmg3N0ViVjNXQlpIS1Y1Q1Y2?=
 =?utf-8?Q?lO+yAdGx0p/gkVWs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a373d33-5c64-4bc6-ab16-08de6fe5cb34
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 18:36:28.2487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnLKqigBjCec5V0oyaXQhjhqIIpQEHZvbChugEbVidPAMT6pMiskRuvjLAOQcpaiXpb3XFNQbowdUE5XkQNVl3MZMt8f1mLPZHnuVbpV5fM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8217
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71364-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[47];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
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
X-Rspamd-Queue-Id: 15140161BA6
X-Rspamd-Action: no action



On 2/19/26 10:12 AM, Luck, Tony wrote:
> On Thu, Feb 19, 2026 at 11:06:14AM +0000, Ben Horgan wrote:
>> If we are going to add more files to resctrl we should perhaps think of
>> a reserved prefix so they won't conflict with the names of user created
>> CTRL_MON groups.
> 
> Good idea. Since these new files/directories are associated with some
> resctrl internals, perhaps the reserved prefix could be "resctrl_".
> 
> Plausibly someone might be naming their CTRL_MON groups with this
> prefix, I'd hope that the redundancy in full pathnames like:
> 
> 	/sys/fs/resctrl/resctrl_xxx
> 
> would have deterred them from such a choice.
> 
> But I'm generally bad at naming things, so other suggestions welcome
> (as long as this doesn't turn into a protracted bike-shedding event :-)

I do not see how we can invent a new prefix after the fact. We cannot
dictate what version of tooling user space will run and we cannot just
retroactively go change the documentation that has been in the kernel for
many versions. Looking at documentation of what user expects today is that
"Resource groups are represented as directories in the resctrl file system".
There is no flexibility here to add directories that mean something else.

Please keep existing user space in mind in proposals. [1] marches forward
ignoring previous comments from this discussion on how existing user space is
impacted without addressing those comments on why such changes are acceptable.

Reinette

[1] https://lore.kernel.org/lkml/aZXsihgl0B-o1DI6@agluck-desk3/

