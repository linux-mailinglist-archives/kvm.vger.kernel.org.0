Return-Path: <kvm+bounces-71510-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aM0UH9iRnGnvJQQAu9opvQ
	(envelope-from <kvm+bounces-71510-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:43:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D750A17B01B
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 18:43:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 961B9316C654
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FF4334685;
	Mon, 23 Feb 2026 17:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gwepGNR9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F714330B2D;
	Mon, 23 Feb 2026 17:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771868384; cv=fail; b=AMwr4oA1FlV7w4zyTvn0qDRQ6Ids1ofQWLJHzE5OluNtxAnAygBQC8YIygQucsCyjj1m+Zq9VzuEYCW48JqzRiP3K49NHtc9BD/Lv9hpBqfqFbRmH2a8JxGVINO4DFslGKAQpDLlbS2uY43zAXiQ8Kfwxb/XdbzInvgR9/vMz9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771868384; c=relaxed/simple;
	bh=xpN0NC/70R8HJiiR7tMOdciBwzDk/A2GMSv7u5+pp+c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s3cgx34SMov6HDEFiHwK1W4qm9x286+oip9/mRdNOHv6uoHCk24vvrWgPWoAWl/c1SYtTw9d8ArJRv9NZ4Xr4tLmM1hb9xdd8QKEjzU66iY15Zendt5ORDLyJzjgA3mqTSWKlasjpiXZFs5x8Eaew4qlCOcFL6ONROCAO6TDcj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gwepGNR9; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771868383; x=1803404383;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xpN0NC/70R8HJiiR7tMOdciBwzDk/A2GMSv7u5+pp+c=;
  b=gwepGNR930496brFrmtoyvd2mFZhraHHka8/Hevva666Hz4ysY7S1/LQ
   BQB4my6G4sFqbDcl6iWDK/AskjtNVxx2v4afS+33mkhczIgY6X1mH62Qg
   WxrvXG+0owwSJNKmMbLD/crvmnOV5sFwI+TMrdApAE9fuuaSvJvKdzgKX
   aigni461T9lAcm+owBwsc0wK4xc8P+TyM0Su5mWpdvKFrV4p/K8x35DXA
   SxlZWCt8M0LsaYQ8eCTW3vmrNg1CPYMBiuAab7yUsj+JIzptkWmK7giAD
   6p7k7cyNJ17VPEGEJUBE+hDKTMeX5nSCKmmcyL8q4Vxxr+Pjb/w3B8IN4
   Q==;
X-CSE-ConnectionGUID: yLRrxGAbQBSB8n8jId4mGg==
X-CSE-MsgGUID: /uLunjbXSMyZgpBDv+mRcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="76735334"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="76735334"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 09:39:42 -0800
X-CSE-ConnectionGUID: U5yCrkp1QQSQIwNro1SmMQ==
X-CSE-MsgGUID: OfhYgsRrSyyeYaqwQeFrsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="219169870"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 09:39:41 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 09:39:40 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 09:39:40 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.43) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 09:39:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nqSFmOLv31vgxTgt8yUV2YOyK4agcb/f2Sneox2BTqNoxpEfpgC3qin6fBbb9vjNIdeCfzDJ3xgT2CD8zGeBNmpj92TYlP6saObrVglykTf1bdsoKb3YJ12ZIrB74/8glhMHVYC2f3e00PCVwMKM3YMAGjzRXRkxNNjtaDK5rUmdzfw4+XS9EzXURFbmnBPF5alNKWWp+90nobWlVaslte5Mua1sc546K2JlbZunIVYcterFVegAxbxOBuUR6V4FcFJQOFLvchyxOSxrPaVXMWUUmlcz3QaeXQZf8wRa8Xd5AY37p015/xcZa+n35gNsvVIrkhUGJ86Oy0AeubKx4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOeJnSh/Aw32lPrY+JSn2HibJ00jWT0VxD/EM8hx6XY=;
 b=oRSeHccZEvxcrOn1ycBspjAI8WuvVSbw+uc/thZl8QN+Ii83iUOzNZhcS5S6I0qxXi+1pVMLECCx9J0j52y9QPjSbLCvc1ovlDeRiVGT0iWwmvd1Ogdnix7vgo7bespnF9NNQAFYGYppuO5zCjPAM28SLkDtpmCMtzyJ81wmGbULVSjMkBoKmiC8FA/H4/uj09O1iuo58cHZdw+57BViBnzLmXVtCz7OCRqJZZCHIkpE+ho8t+2ig7vWysAkr72Y1mAp8tTaiS6GDyTWO06oYMOhCdGFckNg4U4sLAxSnoiKmbvHWwTKTtlnagtqUJgMkt4Fa8ABj2t/yczY30HSoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW3PR11MB4762.namprd11.prod.outlook.com (2603:10b6:303:5d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 17:39:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 17:39:37 +0000
Message-ID: <7f606c1b-7f57-463f-8bff-35e43426951f@intel.com>
Date: Mon, 23 Feb 2026 09:38:41 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Fenghua Yu <fenghuay@nvidia.com>
CC: <Dave.Martin@arm.com>, <akpm@linux-foundation.org>, <arnd@arndb.de>,
	<babu.moger@amd.com>, <bhelgaas@google.com>, <bmoger@amd.com>,
	<bp@alien8.de>, <bsegall@google.com>, <chang.seok.bae@intel.com>,
	<corbet@lwn.net>, <dapeng1.mi@linux.intel.com>,
	<dave.hansen@linux.intel.com>, <dietmar.eggemann@arm.com>,
	<elena.reshetova@intel.com>, <eranian@google.com>,
	<feng.tang@linux.alibaba.com>, <fvdl@google.com>, <gautham.shenoy@amd.com>,
	<hpa@zytor.com>, <james.morse@arm.com>, <juri.lelli@redhat.com>,
	<kees@kernel.org>, <kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <lirongqing@baidu.com>,
	<manali.shukla@amd.com>, <mario.limonciello@amd.com>, <mgorman@suse.de>,
	<mingo@redhat.com>, <naveen@kernel.org>, <pawan.kumar.gupta@linux.intel.com>,
	<peternewman@google.com>, <peterz@infradead.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <seanjc@google.com>, <tglx@kernel.org>,
	<thomas.lendacky@amd.com>, <tony.luck@intel.com>,
	<vincent.guittot@linaro.org>, <vschneid@redhat.com>, <x86@kernel.org>,
	<xin@zytor.com>
References: <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
 <d66f5229-f2fd-4fb1-945a-264b3b7d32e9@nvidia.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <d66f5229-f2fd-4fb1-945a-264b3b7d32e9@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0125.namprd04.prod.outlook.com
 (2603:10b6:303:84::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW3PR11MB4762:EE_
X-MS-Office365-Filtering-Correlation-Id: ad03c627-3ba9-494f-7a3a-08de730283a9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cUNJcmgwVHdhclN3UVBnc1JRQ0ovWWxDR1NubXdnRWFsbmpVaE82UzEwa0J0?=
 =?utf-8?B?czQ5SmZ3cTR5U1NKZnkvelREOHVxNVNvMFcvdTFrVGJGWlo2eGN5SjFLYk5s?=
 =?utf-8?B?MGcwbEdyaExxRmlKUU9jbi9OZSswSlQ5d0luWCtCZnZBZTRyOU1FS1d3REdj?=
 =?utf-8?B?WExaakpPVEhYUWVLNmdYYkV0SndidUd6QnV3ZFAyTmpKaFV0R3JQQmRoV3c0?=
 =?utf-8?B?M2tYaENEa1dDOVVZOXBmbGIvSjF3WWRLSWpKZkVMTFluODZWTGxYYXY2SWMx?=
 =?utf-8?B?NFEzclNRbFhlcjBtbGVhY2VsOHNHeXBva2tiRmIzN1BLVGFvdXhodVU5WXk3?=
 =?utf-8?B?c29BdVM0QjFJRUpkUkhpRTV5WDZsYW5tUDhNQTd2dlF6Y2dnWjBJOVNObHIr?=
 =?utf-8?B?RWxKTVVBdkREMnR0WG92cTRNMDBkVGQ0Y0xEUnVBRWJPWFdLaEZLWCtGRGpa?=
 =?utf-8?B?TzNrd0kyeUNxVlo3SkZoTUtyM0MxMnNOV2ZUaVdydS9tS1RPMWkyMTQ2RG1C?=
 =?utf-8?B?SkdKeDcyRjBNVnk2QXhoWDR6NlVqNC9qdEZtdG9wemZZVzZYY1drWUNZa2Iz?=
 =?utf-8?B?M1gvYWZ1QXUrYU1PTmFEam5NeVY5K0xYb1UranprcE9uTHRiY3JvYkdnc2dk?=
 =?utf-8?B?UnpUeHhhZHQ5YVpVeUNDUUhndk9wUFN5UnlPM1VBS3l0M09FQXZWUnFEZFkx?=
 =?utf-8?B?cGRGVStWbnBtbTdFOVgyQXV6NmhPM3d6dGcydEx4RisxS2d1TitPbnN4Y3ln?=
 =?utf-8?B?Y0pNZW1NWlMrQ1kvVHZ1VHlXTGlqaXl2VVpUdXgrS25nK1BrallXa1YxMlgr?=
 =?utf-8?B?Y1R0QnM4Tk5pZ3QxVHZWcW5XSXlKMXQ1SnZxbnJ4N0ZvenFCM1hyRGlWWFVY?=
 =?utf-8?B?ZHV4WXcyMUxBV3ExdHhZOHl2K2Q5M0I5NEZUMVprSTVDa1JBQ3lHQ3RIdTQv?=
 =?utf-8?B?TFdKTjhGSHZoNUlVVldUVkV6cTdCZllkWDhRRG1tK2xaYzMwNFlUZitmOGhH?=
 =?utf-8?B?b04vczZRWjFjSE5ocGt1VEVlZ1dQejFqTDRJUVJtQWtiUG1vL05LZmg3S2xv?=
 =?utf-8?B?SUo2YW1JU0xPWE0zaDRUeS9ZZ1pPa0JTZjZicUlCN1NrVUxEOUZtdnVPTHUy?=
 =?utf-8?B?S1VhOURKRTNpbXFSQ1pJOXlibmVKaE55RUM1ZFhFcE5leGFDeXMwdE85b2VU?=
 =?utf-8?B?RmN0MVdBMFl2K1NYVW02c3AvdVZnSWNTQURZYTRSREkybHhhbFd1bHFqRlF3?=
 =?utf-8?B?ZlZMckxJSDA3WHlwT25ZVjZVVkcrYTdlRmVzWUdXQ2NMTmNQMWRaVXZ0Znpy?=
 =?utf-8?B?MWoyK1pnM2lrK3pHOE9EMHFnNFlaNGhjem9JWU5sQi9RK0xCa2l3eWZidjJD?=
 =?utf-8?B?THpqSitCRno5RS9CaVR0b2FZTGRSbExJcmNaY3VuNUpvTCswNDhyWDVva3o1?=
 =?utf-8?B?ODZ3RDRvUkhXaGtaa0c1akRYYjJ0WDZOZCtvZTJkRHhGMzV4QktMdmcvVEJS?=
 =?utf-8?B?bjRpTDhYSkdzQjA2eFlBRG9OQmNsQlgweVB3eGtuU1hFT0VkbUFHampUMURE?=
 =?utf-8?B?SGN6d1hPaW4vYnowbzA3STRpY2NNanlOMWsxSTRJRy94K2FIR1AzbGErRDha?=
 =?utf-8?B?UmEvbHloZnlnbWJqamI5TlFDTjJTVHJycmRSbENqczVkb3VzdWlmbWVFNzFH?=
 =?utf-8?B?U2xiVUVQZnFKNytPSXpxc2NLZmRzZXFZdjFIc1ovQStiRm1TdEN6cEw0Mzg3?=
 =?utf-8?B?Z2hzME8yM09kMGYzVy9xQXVnc1JPY2gxNVkzaEhrR3paUlF6R1dYRmRRTlFR?=
 =?utf-8?B?Q1RoM3RFYzgxYkljZStyakxyUHBtc0FsOFBtUWhIZjQ0ZHg4bWttdkM3dUpo?=
 =?utf-8?B?VmlwQmtLcW96a1hwTmdtREZOOW5BbXBISHZLbG82eU91KzRyeGE1dytzUThj?=
 =?utf-8?B?WTU0QnBzbFNTYnptcXBQSVRsUTlPU1U0Y1U5YVh6RFBMSnRkQkhBTFNtb09p?=
 =?utf-8?B?OXNaY2c2VjRreS83RVJRS2Erc09ZR0IzcVp4LzRzWXAyUE5zMEQvZHcycDBt?=
 =?utf-8?B?Um8wbHVpWEQ0cFVQM3Zxb0I0NkRMYkIyRldQSDByeHEyTitWeFU2RUMrVEsw?=
 =?utf-8?Q?JaUc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGowTU51Q2RpVEZQZ05HZDBhMHB4bFZsWVFOUEhxTmpqdjhIRVY4Z08zb1U2?=
 =?utf-8?B?a1ZOQ2ZaWGt2Ulh1T2Z0OGVQcnY1NkhlTW9FMGJQK052R0V0L2pjdzF6UWpi?=
 =?utf-8?B?QnByZDBBcWFjL1ppcEVtRkNzSUphMTZkd0tsWXBpSS9HWExCZjdyNG9kZGJ6?=
 =?utf-8?B?Z0ZkSlJ1aXJ1TWdyV2FtM1FoamhjNUc1NUxOZlVuZWN0cXpBdTJoVjQyQVFQ?=
 =?utf-8?B?ODJMUXg0TFdzSE9mNzZ5b0NTQllvZHp5SlRCSlNCd3pWZFd5SHd1eThiTTZU?=
 =?utf-8?B?SnRxVXlXUWZ6MGlWTG0zK2U0OXI4THMyaFZFNlpmZmg2Qk51K0Rqbk5oMGgz?=
 =?utf-8?B?Vi9rbXFhd1h6eFVUMDUzZ1JVTnlDdFlZTFJ4UytmUzFOM24zU2h6K1AyWTRT?=
 =?utf-8?B?RENpbDRqam1vTzdRUmJZcGlzVGlLd1ljOExnbVVaaUlCbDJHMFQ3dzY4T1d2?=
 =?utf-8?B?VnFxUUFxVkRaZWFHN1VEczJZTnNKTTdVaW8yaXdHTlR2MEd4S3hzZDRLUTgx?=
 =?utf-8?B?Q2M1MmdCK1VmM1FCL3RHV3V0YXFvZmxNNyt4RU1tK2lQOUR4aUV6UkpDQzZn?=
 =?utf-8?B?TFhCMW43ZmpBWlM2UGF5SXA5VEo2WjhIcW9YcTNyQkVtNC9FZkVWcGdkcHpz?=
 =?utf-8?B?b2NueklMTWxEQjh5ak95aFhuaUpSalFZa1kyQ0UwSWdIdklEcUN1aTJIUjky?=
 =?utf-8?B?cGI5d2FmbGNxQTBTTFZpSG5kM1VrUmxyZTBscWZkMDA2MDR5VVRIalBWTnFm?=
 =?utf-8?B?aVlVSEJxNFlIWnRzWHd2S0NsNXVaMmordklubWUxbFIrOWo1SUNjZUJ3QVBS?=
 =?utf-8?B?KzdNV1FXVXJFWTlVVkpKUjB5V1lJZVJPa3d4aE9IYUl4RHd5bDFqVGdIVlY3?=
 =?utf-8?B?ZEtpSWg2UFVHOVVyandkaHFEelJxZVZ1OXpiYlZFZWNYdlpXSFlwRGZPTXdW?=
 =?utf-8?B?QkNqcmc2MktOZjZadDBqcDBmRWMvRCtmWDRLNC8rVTA1THUyT09yRVpjRjM3?=
 =?utf-8?B?aHhhTDFaWklCTDQrMEoyd0JWWDJsY2N2V1h1Y1R6bUtXMmZvUTZMQjlHSEZw?=
 =?utf-8?B?QXFNZDZqU3JlLzFWcmhlVk5oSGpNRVRnb1AxSW82MlNJREpsSVNhUXRCcEkw?=
 =?utf-8?B?S1psQTFjOWk5TVJPRVRCSEhXM2dvbnVFMUd3bC82MlVTT3lvMXdvdVNWbFR4?=
 =?utf-8?B?MXhNcmh0bVd4Q1ZVN3c5WEVCbmZQNVMwMDdzcW0yT2x0NllZbUZVZmVsN3p5?=
 =?utf-8?B?bG9wSVdmaXQzK2ROWkMzTkFJOEhnSWllRVpUMWM4VjVOeFlJSTc4KzlUcnEx?=
 =?utf-8?B?Y2ZscVRpWWlFZE1XUDZuWndubk1wUkFYQkM5Y0N1d2hSbmVwR0RyWjRLdUV1?=
 =?utf-8?B?eXNodnVtQTFYT3J1NGF0ZUpRSUZ5eXNHVEVGQjJEd09aVTdYTFpIRmd1RHR4?=
 =?utf-8?B?Zmx3UitNR04rOVlqZWM4NjdIejBWWXE1emIwTzhrRkpwSUREeE1zZjhVWjgx?=
 =?utf-8?B?dW91UE5SeEg3OVd1cFR6dnVoNVh6NjBLN2NjVGRQSERaV3lHc2x2T09hbTA3?=
 =?utf-8?B?SjUySXlPNW9kZXhxQmVQaGhZYkJNQWJiOFJnRGc2Z2F6amJFckxuTXRkdlYv?=
 =?utf-8?B?V29OR29JR04yNUJGR3dTbG9qYjBERkF1YitGVGdZS0xLUmJCd0kvdVlWWTc3?=
 =?utf-8?B?Z1Qva2hvVmpRT0NzNGt4WEhWT1BUMXhuZlBKVmZLWklPTG53d1o5R0RtQ0Z2?=
 =?utf-8?B?ajBIVDV3b0VHVkp4Z2M4QWFPYjNMcWpXL1NkaTQ0NUY1UHAyVUJIREdzZDdw?=
 =?utf-8?B?OFAzM3EreHFwaG43a2RmQ2JlNHNqdWpzZUxML0orWTZiaXpwdk45YUsvZnVo?=
 =?utf-8?B?Z0N3NHZUbUpBalljRTRLaHUvQmM0TEtjRlh6Zll6elNrQ0RPUkJ3RDRMYUlr?=
 =?utf-8?B?Z0paQThVM2pyQUtlRWg4U3JqVDBhazMrMjF0V3NZYm84WTVObGpRRmRjVklN?=
 =?utf-8?B?NFp6ODFmZkpUTmF4Yk1GRE0wMVdKeXVPMm8vdUtpbkJSYUtHMFpxYXJnOWp2?=
 =?utf-8?B?ejdQS2FvUjJKalJCRjNIdVVpN2JBUHJYZEw4ZzhFdGUwTkoyZVRnbTR2d1dJ?=
 =?utf-8?B?ZE8xa2R4eGpVcitTQ2ZmRmgvNGhTQzlzOFd1cG5DbDl6dzVIejZrZWVaaHB0?=
 =?utf-8?B?NXdjRTNRWjJQOEZCeUQ5UCtWZytEOUZUSDhMZ2x2bUJEMXpxNThCdHpmOFAw?=
 =?utf-8?B?MWdPSzA5cTJLSklGaDBxQjdZbVVwWUJvWG1QNTkrRCtlbDhucUpLQVZsbTha?=
 =?utf-8?B?Wmk4VGIwYWNoaWxibjFDaGxHQndDUS9oT05QZm5PQ0wzQTg4MXlERDB5STBv?=
 =?utf-8?Q?3y/SOn84UBBNymaQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ad03c627-3ba9-494f-7a3a-08de730283a9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 17:39:37.0717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hi+KF/KQZNiNkNtWgX6F++ux41Wqvxi7KZfcapo++pVFI8bWAs7zahvNdspboxWfKVK46Pcn1ibSx78CXXmnQ/BlkR2C9EqRmSwn64lfs4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4762
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71510-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[reinette.chatre@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D750A17B01B
X-Rspamd-Action: no action

Hi Fenghua,

On 2/23/26 5:21 AM, Fenghua Yu wrote:
> Hi, Reinette,
> 
>> What if, instead, it looks something like:
>>
>>info/
>>└── MB/
>>    └── resource_schemata/
>>        ├── GMB/
>>        │   ├── max:4096
>>        │   ├── min:1
>>        │   ├── resolution:1
>>        │   ├── scale:1
>>        │   ├── tolerance:0
>>        │   ├── type:scalar linear
>>        │   └── unit:GBps
>>        └── MB/
>>            ├── max:8192
>>            ├── min:1
>>            ├── resolution:8
>>            ├── scale:1
>>            ├── tolerance:0
>>            ├── type:scalar linear
>>            └── unit:GBps
> 
> May I have 2 comments?

Your comments are always welcome and appreciated.

> 
> 1. This directory is for both info and control, right?

Right.

> 
> "info" is a read-only directory:
> dr-xr-xr-x 8 root root 0 Feb 23 12:50 info

While "info" is a read-only directory it has contained writable files
since the original monitoring support landed (max_threshold_occupancy)
and has gained more writable files since then.

> 
> And its name suggests it's for info only as well.
> 
> Instead of mixing legal info and control together, is it better to add a new "control" or "config" directory in /sys/fs/resctrl for this control and info purpose?

While I agree "config" may be a more appropriate name I do not think we are
in a position to change it now. The documentation is clear here with there being
only two sections for resctrl files: "Info directory" and "Resource alloc and monitor groups".


> 
> 2. This control method seems only handles global control for resources. But what if a control is per domain and per closid/partid?

The intention of the files within info/<resource>/resource_schemata related to
controls are to describe the control *properties*, not for user space to set control
values using these files.
The values of the controls will continue to be set by user space via the per
closid/partid/resource group "schemata" file. The intention of the info/<resource>/resource_schemata
files is to describe to user space what are valid values for the "schemata" file and
the expectation is that these files (info/<resource>/resource_schemata/*) will
be (at least initially) read-only.

> For example, MPAM has a hardlimit control per mem bandwidth allocation domain per partid. When hardlimit is enabled, MPAM hardware enforces hard limit of MBW max. This can not be controlled globally.
> 
> For this kind of per partid per domain control, propose config_schemata/control_schemata file:
> 
> partition X/
>     control_schemata (or config_schemata):
>         MB_hardlimit: 0=0/1;1=0/1;...
> 
> Is this reasonable?

Yes, managing HARDLIM as additional schema/control is reasonable. 
Exactly how to expose its valid values to user space via info/ files has not
been discussed but I believe the schema description format does support such
extension.
Please see https://lore.kernel.org/lkml/aO0Oazuxt54hQFbx@e133380.arm.com/ for
some example schemata related to HARDLIM.

Reinette



