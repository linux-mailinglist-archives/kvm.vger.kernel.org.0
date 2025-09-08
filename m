Return-Path: <kvm+bounces-56981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B87BBB491DC
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 16:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D65B18977E6
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 14:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5946822A4EB;
	Mon,  8 Sep 2025 14:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o2xftqg9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2056.outbound.protection.outlook.com [40.107.95.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0E31C7013;
	Mon,  8 Sep 2025 14:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757342491; cv=fail; b=ZMRhY2C1Lo+FiIcSsZSRSaA1CIneGPJKO13myfUATfjryxaW9uTZeKlf2O91aZohUeFjCe7IW6SBPjAXJQMBXAyoDNvETuwaZQU1ZFmH2EEcuRuF0Neps/egnMeo9dFs4FdpGa9jkph3f+kykFL7qwXp0jwCh5PqQbxWIR26gTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757342491; c=relaxed/simple;
	bh=Gedjl2ie5Z3jDa8Jct5ns5wOAugxNnCZnvE/KaBWZjQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CxF0Y+PqBhadWPyZf6LRnEqgw5tsyua+n5UnRSRpW7QRsPPso8bkDTmh8gCoUKk8Eg2M825yWAWB1kK43Tm+QobG1l3u5Zd2uk+OePnpzwSdnD0BssNaRJ2025Tkmh0bQVROYhxIFEeAGlo4stjEEJgrfcZ/KButKqQkww+XwXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o2xftqg9; arc=fail smtp.client-ip=40.107.95.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NfHcgezXGLB2G+G14UEfSguUxNziQRBe46tNPKcWfXgsj4OTkTBc8Plr71JfXrEaN6wS6SJ5SZeJtgkKIZiU0FC/cSV/cFMvuMS5nhaIK+6Rzi1eg126n+6m7WhY1soZGDeTPbXCqKnN39AZ+u1qRd1STCkKoPFtOv0DAlMU4YeGEjxxsTpAAEC7Olq1XJpXO/bxntk/3ZWq/3fqwobhEFoqG9d+52dD633etzgW6Z/TEmUsUnzQ73y1krjHpmc2DF1FJW5l5aHe9FHWYJfTMsQYa5BZuukZ+QglCOPt5efVe2kjRHG61zHXaHXPZ8F31uui2vNyOFbCBDVtC60FmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZByfrrxLzdBnMAULlt6XtlTrUZllTd8j41qDc8Isxc=;
 b=gLgY+0f545zyr8Sii1stJpuD6i4VG0yNZaTgcKLGQiA/+EjJL+g/+Qo32Aa7FM5Tux2VTqvQXTkAyTu7o0JhWyZzmMFlPqT+voTJGBk8lJivalKOQ8LS3/a8KRaqgTH1a59VujO1cyfCt6SuX9f4mdooypmPR61P3leYyx0NYzfokxTKR+CsJi+3E7TFcfDRDvK6kt+2ByZuOv98s+TnCoST/lCMQU3JForKw2p7GgQbmDopHi94x0Algt25GAtgUs3W7o8+D+XZQj35ziSEIAa4aIttd3YvYx3UHfgxKz8a6Uk2KX4Fdo1XlcMJVk5D5KUs5u3KsrmkNUdi56kqMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZByfrrxLzdBnMAULlt6XtlTrUZllTd8j41qDc8Isxc=;
 b=o2xftqg9ASGtCiIBacLny7IpdLxAnczWPORGdbNZi4ZmxwGAR5e3dR+oVdlPk8S/47MtI8/BtGhn5A8LziPn11xMs4tJPzBA3Ah+xSsCeeWtSEhll+NHV86b0YDGJKzfoEeGLhFANrHXYNSlBD8FjfRCr+PioFnOfV3mpwE5R84=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by PH0PR12MB7862.namprd12.prod.outlook.com
 (2603:10b6:510:26d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 14:41:25 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16%7]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 14:41:25 +0000
Message-ID: <d3e4ddd7-2ca2-4601-8191-53e00632bf93@amd.com>
Date: Mon, 8 Sep 2025 09:41:22 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v18 05/33] x86/cpufeatures: Add support for Assignable
 Bandwidth Monitoring Counters (ABMC)
To: Reinette Chatre <reinette.chatre@intel.com>, corbet@lwn.net,
 tony.luck@intel.com, Dave.Martin@arm.com, james.morse@arm.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, akpm@linux-foundation.org, paulmck@kernel.org,
 frederic@kernel.org, pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org,
 arnd@arndb.de, fvdl@google.com, seanjc@google.com, thomas.lendacky@amd.com,
 pawan.kumar.gupta@linux.intel.com, perry.yuan@amd.com,
 manali.shukla@amd.com, sohil.mehta@intel.com, xin@zytor.com,
 Neeraj.Upadhyay@amd.com, peterz@infradead.org, tiala@microsoft.com,
 mario.limonciello@amd.com, dapeng1.mi@linux.intel.com, michael.roth@amd.com,
 chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
 gautham.shenoy@amd.com
References: <cover.1757108044.git.babu.moger@amd.com>
 <08c0ad5eb21ab2b9a4378f43e59a095572e468d0.1757108044.git.babu.moger@amd.com>
 <fb2d5df6-543f-43da-a86a-05ecf75be46d@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <fb2d5df6-543f-43da-a86a-05ecf75be46d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::21) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|PH0PR12MB7862:EE_
X-MS-Office365-Filtering-Correlation-Id: ad6f2e3f-42c3-4938-8b57-08ddeee5c990
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TUdra1FVWDY1SWU2Ty9nOERtOXRoNjZPbzRsVXdzVnFyRjR5eEhmRUk5T0lo?=
 =?utf-8?B?cmFVYVdPWHhraW1hVUQwUFgxeFdGc2QvZU9wdU5XeStIZEh2cjZzRktzek5x?=
 =?utf-8?B?Qy95WlhuNFJRNFF6MEgxVnNtbExITksraHNrOGJsendDZnVYaWVraVRqcjQ4?=
 =?utf-8?B?RllyNzdaeXhvbjd6SU5uNE00Q0NFWTdRVmtLa3ZDOUR0YkFnbURSUW03YytQ?=
 =?utf-8?B?bmxiVHkvb3NVa2h1SCt3VW4vZVViSW1oeSs5MGV3dG5Eb1lPOWU0aCtuaWFk?=
 =?utf-8?B?UnBHdUhVSWplSjZqUitZdFE3anVyNWREK3hqaFcweitVWjFZWVUwektsTTBZ?=
 =?utf-8?B?UEZlV3psVm5sTmM3Q3oxY0Z5UnZueml1YkNEU0FTSmt5bGRpd3VNVzc2cEFm?=
 =?utf-8?B?RXI4TEo5R3hNeUZRRWpQaWpKNThmMjdhVzBDd0xaWjFrdEJYa1R5eUVLdUY0?=
 =?utf-8?B?ZTlNemtRVE9GQzE0S3YrbzF3YmYzSjJlam43MjNPUkpEc0xNdExkUkFGTG1u?=
 =?utf-8?B?eGxia1FrcWtKcGFYVHVBQzJzdU1tNytmVm1pVzFYODczOGozemR4Mm5DR3o5?=
 =?utf-8?B?NmRuWm5oTm5PS2dkQzc1Q3JINVFiUVZIMWRwK0lJbzZBamw4cndMeUI1L096?=
 =?utf-8?B?dzFnZGdwQlJGOFhEbEkxUWloVjl1K3V5dVpYNGE1eVd3cHlOOWVNYWVvVllV?=
 =?utf-8?B?cHFYL0ZNK0RQUXd3ZGs4V3g4T296N0E5bXlTT0FrMkRmTk5jc3Y4a1RyTWk1?=
 =?utf-8?B?V0t4SVdidTRTRUVxQkNhN1k4U2pVV1NWNXVNeUFhMUZMa3Ftc0kvQ0srNEJq?=
 =?utf-8?B?UStQcmxXdU1Cb1RxTThPdW5MR3dUV1VpUXgwck81dTgxK0h0OVQ4MWQ0aDB2?=
 =?utf-8?B?MlFwcnJaSXdmS3hXLzB2MHpvSWZPdG1DdjRyZk54YWRPR1dwVnBhRjlkM2Nx?=
 =?utf-8?B?dWNGdTAxOGQwaDAxWTNuVlhVNUM0UjJLMUFWcFZNb0tGMFhMaVMyRXdjR0k4?=
 =?utf-8?B?UllnSWZiMk1ndmtvbVozQ3h3MG5MYzVGN1EyNHJvelpGNkRGY1dzTDVQa0d1?=
 =?utf-8?B?ZE5FZndKODY1V29jUnUxVnFpbWNDWFpLeGtRSEY1dGQ5aUd0Q3A5WEJkZDFw?=
 =?utf-8?B?UlpNd1dhSVVFWWREU2ZWWXBDNklZa1lVMDJ6Q2xYZHRyTk5kZk9VbXp0cktU?=
 =?utf-8?B?YkF2UVk2RklQZ1NRd3BVTHpaLzRPTUtTVnphL0ExZHBOYm1IbE8vSW1ndGtp?=
 =?utf-8?B?VThWN25yMHVsam43ZzlLd1VVdmlKZmJ4RkFDS09CQ1p5WDhKa0hIU2swV3hx?=
 =?utf-8?B?MitWZElKZmJPQ2p5SE4yRkVlMGJtRHlxYy9seXJ0ei8wcWNpMkVNVXZORzhF?=
 =?utf-8?B?akpyVHFDSEMrcmVxQnhLbFArRFhMOXp1RkZZZEc2c3ltaHUrbC9MSjFrNC95?=
 =?utf-8?B?Vmt0SHFaU0p5QXhzaGxRMDhRYzdVQ3lsMnFSU3Byc1R4WTQ3SlVIZklWbGFS?=
 =?utf-8?B?K1JKYUNTR0lwQ3IzK1BPWEVPemhhQVdEWmZ4WitsYWJ4cTZWS0xJV0xlZmph?=
 =?utf-8?B?UmxJQTY3U0tVNHhkTEswQTlweThzOXZsdjJ3Q0x3a0QxMUlXaVNuaktOM1dp?=
 =?utf-8?B?L3c1Qm14K1ovTDhjdTJ3dzMvSUZJVFZqd2hOdzFSeGsxWU1Jb2RkYkx6OW53?=
 =?utf-8?B?Um9ESGRYMXVjN1ZmcXQ1R0FYaGo2M3hodU00ZmhhQXFSL2lJSHNYNEpqUnl0?=
 =?utf-8?B?Y0x5OE9ESnpEaWdxUUFDVGFHa3l4WUdxWVYzZHVLOEhlQWMyQ3hYbE9BR29F?=
 =?utf-8?B?aDdrK09rMytaMmREbStvWWRtd0VubmN0QnpMMlMrRUZXbG9neFNJdnBrOHA5?=
 =?utf-8?Q?3nOdkzzVF2fmt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b29FTE1YbVR2TFB3cU95VENMTng1Yk5BVGNyTEozeTEwUnpobmdhaU0rcFNz?=
 =?utf-8?B?MXhLNjRmSHdBWGFJNU5QZzNOV3VDaGlpY1dCZ1U3aUJoRG1YUjRGdTZSZHEv?=
 =?utf-8?B?WTRmVTYvOU4xWm9xMnd6bVlVNFhYZnkyQkVEMkZhT2dvem80akRiZWkxRGNC?=
 =?utf-8?B?M3k5Ry85Yzh1WnEvWmx0MHE2QWY2aGRqaHhMU1pzUk5ma0ZmRFhDeVcxVGkz?=
 =?utf-8?B?dFdrVnlLNVZuZHdRN05nUEFSaUJ6dDhIYzZEaUJYNHNrYjFVSmZXYksxM2c4?=
 =?utf-8?B?NHF6cVJ2cHJoTjU0aEVBS2JzTm02UXl2STVzN2hiWWZqRUYxMnRQanJLNkZm?=
 =?utf-8?B?RW0vdGFMc09xY0JpUURxUjhNd2tOemlxb1JyR0dIN3NESS9Gd0ErMGpjL3Zn?=
 =?utf-8?B?d2pHMWp3blQ5UDZhNFVDeGpsTU1TbkJPTndQQzJYdFhvVU9SNzU4ZmsvSkFO?=
 =?utf-8?B?OXppVjg4alB1L2o2SlJHZk1JWnI1KzFTSG10OXVlUThqeGU2aithcTFPZVo0?=
 =?utf-8?B?OENwM1V5Uk5xeFpVenJYMTFkMG4vOHlUZjBYeFoyeFFQNHZnd0lGcnljZ21p?=
 =?utf-8?B?TmoyaTVKbWhVTUpUekdWNWo0ZUY4Y1ZkRGRzWDFpRnMwK0hYcVVYNWFhVjEv?=
 =?utf-8?B?SXJMbXZkZnpFYUg4MUlXSCtJdUpacmNzTlplMy93Vm1TbDIwUCt2cGpjM0NZ?=
 =?utf-8?B?S21ZOUl2TDAzSzEwVzFUYXFqUHNPZjdiemlzSlhSZGtBSTBlcWFBUzl5UDE5?=
 =?utf-8?B?Ty9ORnQyd1VaRUo3eEJHazRmeWdMbjdtYkZnaEFJZkNHdGo2TTFZR0tIbjZP?=
 =?utf-8?B?OWZJcWpmdjIwcmhDWngyL2FLRnV0ZGdLeGM4RGk5QkdYRFNmOEpzZy83Yjdn?=
 =?utf-8?B?SXViUWRpL3d4NytMYjgrUmZkWWVkWmh2dXJuQWxvZC9Nc2dBcDVIR1VIYWFU?=
 =?utf-8?B?ajgxazJaZDBTaTlXdHVSaXVMVkg3TVV3Ti9UZEpwVzVwUkNSdWc2M0RBUG9G?=
 =?utf-8?B?UHlXN2pSU1JGbHBpY1lKdXJ3TkpQOWRZRXZIdStIWHZ4UVdSMmprMy9SVWVr?=
 =?utf-8?B?ckhnT2xLU2t4LzNPTEgraWdIK0c0L0kzR3dqcWJ2UFhnYmRENng5MUk1VlJz?=
 =?utf-8?B?NVQyckVmd0ZUcTFkSUZJWW85R3Byd3pweDVLMi9vQVVObE1TT3ByK0E3NTk3?=
 =?utf-8?B?MHJ0dDhreHErL1pUenVUTFlha2lGOCtCQVhmNHNTbDNrcnFqdFdiU1I5Tkgx?=
 =?utf-8?B?UHB2SG9pT1dNd01FZ2l0NkdEWmlyb0Z1TE5XK29zZVI1dFFZNm83ZXhwcXJu?=
 =?utf-8?B?KzJDc3lCajNtRThBU1BBeklQRVBSRTE3VjVCUFFNZHkwa2ljeVdZOEZiV3Iz?=
 =?utf-8?B?M3FuK2FrVmZxZ3JubGw3Qy9jdkh4cFpkTmlFS0xWYjlGbGxzcjNUWm9HNUhw?=
 =?utf-8?B?dlVTTkxZbzVpc2hwOVU5SDBCVkN0UDczZnNCT0w1bE5rb3g0V0VBMmVZR3Nv?=
 =?utf-8?B?N0Y5UjBsdDVwc1UwTzVpWE5VNzkvSksvRktocVZFUWRjQW5yVmt0WHBIa1RZ?=
 =?utf-8?B?Y2l1ZWJyWU9xT1hFSlAzKzR5cnhmcStodFJkL2J1bHdwUlUza0ZVcnFOMUJz?=
 =?utf-8?B?UHpTSlA0YU15Z3l4L3VGeE5yb3RUem93T2R3Mk9iSWVwVmsrYzVoY2xzSGVP?=
 =?utf-8?B?Tk9wRytGU0VZdGs4cTNkeVorZzB2MTBYRVNQUjcxY3VJUzJpeERBRnRxVFBO?=
 =?utf-8?B?Ly9aK2Y1emVxN2JFMXhnRks2SHNUZWkrSnpzR3VhVGloNEJEOEppWHN3a3hz?=
 =?utf-8?B?RVZlM2hhV1dSQjhTMWhvajRMa2lCeUVvUklGTTJIUEU1NFVEM0Z1Ri9DV1Zq?=
 =?utf-8?B?QjJQa3hGeDNzOHNyVjU0SXEzNDhlMnRJeWFwVzhTanV2MU0yMmRDbGNmU28w?=
 =?utf-8?B?SS9oaGQrczlUWnZFampXUFd0NDhEL3orbWVpQ2doaHRIMm51NGZjSVdaeXpy?=
 =?utf-8?B?WW40THlHeEp0SnNud2R6a0xzQkFyWVlmVFdVVElrcU9lZTdUSGg0SnJLUEhG?=
 =?utf-8?B?MGt3NC9kQ2NVTmFWckRpMG5yOG1meVNMd3I1VTM2blkvQ1Y1Q2J2TFhkMy92?=
 =?utf-8?Q?UlGo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6f2e3f-42c3-4938-8b57-08ddeee5c990
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 14:41:25.5167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kqCF+ykmMkIDdqRmOlSNqZss8Nx+JWll70sZcYgaMIc8TE0IEmTaRoEwhhziJ53H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7862

Hi Reinette,

On 9/5/25 23:49, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/5/25 2:34 PM, Babu Moger wrote:
>>
>> The ABMC feature details are documented in APM [1] available from [2].
>> [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
>> Publication # 24593 Revision 3.41 section 19.3.3.3 Assignable Bandwidth
>> Monitoring (ABMC).
>>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
> 
> Apologies for not catching this earlier. I double checked to make sure
> we get this right and I interpret Documentation/process/maintainer-tip.rst
> to say that "Link:" should be the final tag.
> 

That’s fine. It wasn’t very clear to me in maintainer-tip.rst.

I checked a few older commits, and the placement seems mixed—some have it
at the end, but it’s not very consistent. I can update my patches
accordingly and apply the same change across all of them.


 The ABMC feature details are documented in APM [1] available from [2].
 [1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
 Publication # 24593 Revision 3.41 section 19.3.3.3 Assignable Bandwidth
 Monitoring (ABMC).

 Signed-off-by: Babu Moger <babu.moger@amd.com>
 Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
 Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]


I’ve been basing the patches on top of:
git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
with `origin/HEAD -> origin/master`.

Please let me know if this is the correct branch to use to make the merge
process easier.

-- 
Thanks
Babu Moger


