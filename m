Return-Path: <kvm+bounces-34704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22236A049A6
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 19:54:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B0807A10AD
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 18:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A5A1F4298;
	Tue,  7 Jan 2025 18:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F9g2blcy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79B71F190E;
	Tue,  7 Jan 2025 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736276027; cv=fail; b=Qxht8pnH8lPd3OPmiO0sFTM7aLFbTCVxU4Uhh/bUJldY68tX86pUXOVMzE2Jup8ImCd55XD3wSTsgsxKPFBOBciaX54x7BAqT7X4Ebp94oN2dppoCg+qeTdifJIxSTN6JHCNujlysaqfudaJm0IGyFhIZJHI+ZKBaaRfnQy60Qo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736276027; c=relaxed/simple;
	bh=uiMbTNNvmDygVMEEfy3N8sfOzxlBFoC5E978zwcCRnY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f7VL6/cU15+cUQk2XIb7C1+y5DfWRrd4bRIxqsAACQ1ohdPZrMP9DmID13NG+2Yb0P/aFes006A+4XtzFJ5/zXjMZ720Ehqm5EOFDWlATO22hVxpS232zWN07QAxEMuiM4vwkMuWm/x3OUmGAAQvHJLjrBgu8FzM8Bpuk6BMd/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=F9g2blcy; arc=fail smtp.client-ip=40.107.223.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IJGa2RS/PXueMfOxGJZ67ZVpnqF+tv6A1RXtyMFvb8miKG9uxDmUwJUWHUFmuhyhdjv4ayWHE5Fu/DHs72HApuvkN6VoBuM5JQy0UP2yAAJGmVUD4MS0ReGTDgrscIOn+59dKENx8hSHlAmvtat8dI10dkMM/odjq4Qc8o8FUQxY2jRsCM0vxBD3eLxpVDq072B5KZ7allfbFYy/LOiqwHATrFX1KwWIlYD7TV/g3TIO95tzKRB24h8I3pCXPHr1PiK+W7LgthTu/5jgXfzUUMrvc8w8YWeklvHPhDQivGkwUWEt77G5JWcoZZzM+VYQ6aQYqxYXaZOK2kShMzReRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFS0xdTUowo5Pxgw4YCvSHb5B0z5SY541PFH+typIIE=;
 b=YkmpTIzWDabaworNGDFBH8RaSNfMrNC62t53apm9i1NKpEGSBBKCANYJrLXZCi1nfg7pbsAoZ6fTaawtwx/gD7jeb4x/R5dBIrLGNskJ1OBLKXM7psj2es0nBRJC/C63womls+wSMnriouD8dIkSRBVgRTd7/2Y4v/heaLbTWkqSIo3qvAUkALsKJa6dZwWp0juJxxIG6sMjkwWEWYGsQAnULypB1roRhCZaoTo/EFMzFhwRlLbFKLOrnzKMrik5HvAuLamrbPO8CBx5g+4jJbPN+GsnP03Xhm9p2Wx1iybqbK+iHXdXS4j3fbfga9xC+ZqmRSzPfrys5agJEVYKBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFS0xdTUowo5Pxgw4YCvSHb5B0z5SY541PFH+typIIE=;
 b=F9g2blcy7sLL7W9VSd3oTge56M4sEVgE7d/tv5hKSBpaaQ/ytHA1l9fP0sCdizLGUej86Gcvz7eoW+E41KnYSrK9KF2PdWrg5iiE1dLoKNVrbx3nTEk4L0KBxv7p340qFBDQhvulwjgLrzkpsZxmTL3zWG5k+6/K+zWhBVnDICY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by CH3PR12MB8305.namprd12.prod.outlook.com (2603:10b6:610:12e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Tue, 7 Jan
 2025 18:53:41 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%5]) with mapi id 15.20.8314.015; Tue, 7 Jan 2025
 18:53:41 +0000
Message-ID: <5391cdaa-ac29-4964-b2d6-59d2ba38d35d@amd.com>
Date: Tue, 7 Jan 2025 12:53:38 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] crypto: ccp: Fix implicit SEV/SNP init and
 shutdown in ioctls
To: Alexey Kardashevskiy <aik@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <be4d4068477c374ca6aa5b173dc1ee46ca5af44d.1735931639.git.ashish.kalra@amd.com>
 <a6cfdfe5-37b5-4d86-9a97-ac75720ad424@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <a6cfdfe5-37b5-4d86-9a97-ac75720ad424@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0125.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::19) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|CH3PR12MB8305:EE_
X-MS-Office365-Filtering-Correlation-Id: 49309c75-eb6c-4ddc-5d83-08dd2f4c9a6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?em1sKzU5RVFGRHI0cnJHY202cE1nL2tNakFFWlNvNi9kU1dESmc4TUJYS1ZX?=
 =?utf-8?B?VUNJaEZSMFlGZHRvUUZIaWJuMmtQR3NuRGJmVzZmaEg3QUwwNmdVbUNJcTgr?=
 =?utf-8?B?Vm0zdGJ5bDhZWm1kTnd3K1FLNC82cTBXQ21Lb1YvRFh3c0lHbzgyUml5dlV4?=
 =?utf-8?B?U0lUTXNRVnNyS1VYc2ZTbnQwR0xwa3Z5WFE2YUN2MTJIa0tzWi9QQmZhV0Rz?=
 =?utf-8?B?U0crQkQrbnVTcmVJanB6b2lJR24wNFlYNnZkM0pnbExFdnRLS20ycnJXYUUy?=
 =?utf-8?B?cHhkOWFOUW5xWFZhL3lkMWJzYnowdDl2YmFkWTFTOENlZ2FxRnZIT3NXR1FX?=
 =?utf-8?B?WncrdUlTVkVQN1JVZFRpZ2drbzRwV0RFTThIMHhsNWljWjN5WUNkUDh0SjJG?=
 =?utf-8?B?UTVKUHFEZTQ1dUNmOUNtRGJVZjQram9qVFVsaW5kM1pWTVJVSXlGSy9PdWp4?=
 =?utf-8?B?Zk0vMjRVOFpVUG5lSzEvMXRTRXFhS1BtY2FSdjU2czlhMnFnT1c4WkxuNXk4?=
 =?utf-8?B?TGYwOG5uVmRRS1E5TDVzNVVVemlaVXFWZmhKZkxVWHQ5UlBjU1dXNDc0UEdl?=
 =?utf-8?B?THh6S1BlbnVWTHhjTDVJT2N2WnRLdkRNTUVacHJjU0kxOUZsdkowOVNmaUty?=
 =?utf-8?B?TVUxL0t2cWhiMitHa3kzOTA0azdSbzhubitYbmovWmVja1ZYL2FaZTQ4OG15?=
 =?utf-8?B?V0JleXh5V201NzVkOHdTNUhrQ1U3ODJkaHh5ZmxNdzVKb1R5emxudVNRMVBI?=
 =?utf-8?B?WS91ekFBaisvUmlLd08xUVovNnNHMkRWUWtBZE95bTRDVEg4OEpVRmRPUG96?=
 =?utf-8?B?emkyQjhmU3VINEhaMktxenJUMkN0NkI2bXF5RUhnMERRMC9zZCtNcGhvcmZv?=
 =?utf-8?B?VUV4L0tKL21ybkx0SUhZdHluYWlxYUFpbGtGUWx6RzJkMXlPSU12c0Q5UTBJ?=
 =?utf-8?B?b0VXak1lM05oQU1IQXlFenR3ZkhPaDhWMFBPSkRQcXJUL01nb3RrTHN6UXFa?=
 =?utf-8?B?RjlNVVFYVmVoMjdEWEFxRnN2YkdZd0JvRStISkdzWXVyMFRyZkdGUjRxQ2Nq?=
 =?utf-8?B?TGQ4MThsRE9Kc0ZZbzJoMkg5N3diNVFNd3RiZkZOdFlDV2toaUxIRy83YmtP?=
 =?utf-8?B?WG9zTHBHUDdQZWIrQk5mT2VJeGhURFdaV3hDeU9ia2NZNDNMWDQxbHpqbU8r?=
 =?utf-8?B?U1ZCRFpUTC9HUktLNk5zUDZZQ2kvUWFlNUU2dUhXVWVCbzBUMmUraWZGSWYv?=
 =?utf-8?B?ZkhGSGErbTVJdU1DMTNYbHRpRVYwZ0RlUDRTVnhLU0RvZTlsVnNhdkNmbXBi?=
 =?utf-8?B?S2pJajBQc2VRNUNlenRuaFBHcVRsOWtJTE1sZTd6NWZSa1grM1lWSkIyL0ZZ?=
 =?utf-8?B?eGlBL0podC9zak5FUWRFRzBmTERReVNkVzErNzEvdDNKNGxxRGJaOG0xcXJo?=
 =?utf-8?B?OG02akhrZ2ZEcVNaRmhRM013S2xlUFNldWxYWkdFdGdsaEZhMnd6YzhmYUox?=
 =?utf-8?B?ZmZtQzRuR0lBUDloK2loRzBCVlZENEoybm9ybi9hVGtmalRxVlpIemd3aGZT?=
 =?utf-8?B?R3FTaUw2cndwNDh5YmlGV3IvS1BIN0M4WHhFNG1RSzdFei9NVWdEV3hOM2ht?=
 =?utf-8?B?S3M0bHRSR01mRWhoOWd6SFJqL3ZpYnphbG1TWjdFQUN0ck5ZTVJMUDNjeEg2?=
 =?utf-8?B?YzZKY1I2cTlCT1Jvd2p4RlBHWWJ3VzkrbEJlRkI3RlRsWEV4cjdTTklBZ0pa?=
 =?utf-8?B?S0c4d0N2OXlxbGY0Sy9HQ1hTN0VLRFc0bVF1Mk50MVovSzFFWkxBdk5JcGpo?=
 =?utf-8?B?cjZPSmlrUEh2WWhqeWZJbWxVSUFFNURyRnp6NUtnTHBFUDJxbTFjTkhpWGxq?=
 =?utf-8?B?cXIyWXUwOHpzSTlaNjBWWXZRTnFzWFdJS3VtdHlDVk1BZzZhZzlxeU1QYlVH?=
 =?utf-8?Q?t/maLZEUsPw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VG91WnkyQVJJcVlUVy8xK3k5Qjg1SWJVWkFSZzRWeHNUSURDdjhpcW16N1ZK?=
 =?utf-8?B?M0tuaGJDbTljekRUSHBuUmpJZE9CWlhxYWJSOHFZRkFRYVpnRVFFR0NkYlpW?=
 =?utf-8?B?TmlXZHdWVmRWM3lFaHhNL1dSWTZBL3NaQkNzUW1KaDRnU09RU3A0SjgvcWpp?=
 =?utf-8?B?VEdMZi8vdVl2QUJZaWRrRzBqa3hIQWZ2bVhNQllIV0cyd2U4d0ZldDRJdjNL?=
 =?utf-8?B?b2xudTBwaWZzRnJuKzR6a3pKcndqT1RCT0xyVmNObXJnbDk1WnJ2Q3RMKzU2?=
 =?utf-8?B?UnUrZ051Ui9BNHFaU2RoM3FKMWVseFRzMmtHWWFuVENPVGVpVndTTGkxbmJu?=
 =?utf-8?B?REM3SzkwK0xFRGF5R2d2cVEwaUZxZ3J4VnVBdncvNnZJdXR6RjJhbm01VkVx?=
 =?utf-8?B?WGVuL0hmUXNxaGFWN0FqajNsQWE1ZmJPQVBxdWZvTEEwcVJsNmNLYW1pVTlo?=
 =?utf-8?B?d0p0SjBzcEUxT0NzMm84QzVlbURNTDRhZnRPSzJPaHJZMGhzcldKdVBlbUxH?=
 =?utf-8?B?N1ZjaXB3cWptRm1LZGVmQzBocFFQaVVrRVQwaTJzT2wvZW1vZk1mWGZVSnk5?=
 =?utf-8?B?NXJBcXlqOXRDNlByWmxBaFBlci9QRWdOdkhnNjZnTWhuRUJFTDNnTEUrTGJR?=
 =?utf-8?B?OG1ydW94ckJoR2wyaytSM3BoWTVCZGd2SzFIUU04TzY0MXo4MWJwdGsvbUU5?=
 =?utf-8?B?NzlBQVcxblpxbS9IaU9qRldNdUowdmc0cEtTdy9zVTRRQjZ1ajNoUUlKSUNG?=
 =?utf-8?B?aExLTW1VZVVaOW9jc1lOS2dmdlBScVlMZDVSSlUrcnZzU3hILzVpTWVIMi92?=
 =?utf-8?B?WlhRbUZ3aVdQWUJpY3ZjalZHZEpTeTh3TUFmbExhSmxUaUViVHZPbmJDb1ZT?=
 =?utf-8?B?Rll6aFlSOGRyWUVYeElMbXc4KzNtK284c1dUaVFkTHZFa2xuRWpudTllQWYv?=
 =?utf-8?B?aEFWeVhzTWFnYWRObHpHcWpZR0Vzc2pQYXRHdVVTcEQ3a3hHRUJxWE9sOVFy?=
 =?utf-8?B?czZNRkZvM29QaWpvQUNkUUR2TElMc1lxaHhZalVac1BadDdobWxIeFRNQ2d2?=
 =?utf-8?B?emUwQlRCbWpKcExvZEwzT2RGcUNJcEJueGJxejdRYWZTZmpjcVU4WmdjTSts?=
 =?utf-8?B?UGFPalpoSWZVZEVjcmtib0FsYmhKZXNlTTIxWnQyck9tNnM1R0MxNEN3dlFl?=
 =?utf-8?B?WmNGaXczdmEvWEI4V0ZxSnplVWkvWlQ4MEhkK2J4eDdicnBHY3Fnc08relZn?=
 =?utf-8?B?VEhHNTVNNXF5OFBvNkt6eGRUc3FtbzNjMHdET1hicEdiRHpHMGpNcTRUMkdP?=
 =?utf-8?B?T09qK1pxUWhFeFJtMllGN0RoWW1ZSW51cDRQMEREU3ZwS2t1RDBETjRvUHRQ?=
 =?utf-8?B?a0FaMkM4M0hYaUpDNXMxMEcyNllHSmZNNEhDekQyR09NNWhmcUpjV3UzZ2VB?=
 =?utf-8?B?M2lyQWplR1dQZy9vMjVpSFlvcDloL1pMeUFyS1RzQm9mb0JJYUJEZjd2bHp2?=
 =?utf-8?B?NXV3SWJxVWoyVmorRG1uTytzNndqZTZPbTVTK05udnhZMzhBV3RtQ1p6cVFZ?=
 =?utf-8?B?eU1TVy83cm0rZEZaWjZrSFgwZCtMY1RlMzU4cTV0RWF6YXF5SzZKVHc1b1Fr?=
 =?utf-8?B?bDE2MGVrcEx1WDlYdXZVMDRHejk0eUhyS3RQUmtFWHlZWUZBUC9tMlNKdGhM?=
 =?utf-8?B?U25GQStuc2FxUGY2Q01jV1FNRUhvNlIzRmgxOXhvL0lUVWxyL1lGaWdwMjdY?=
 =?utf-8?B?Q1JmVmdKRVFMYWd0cVdjZ3FnNUFWTm5xVThhalZQR2JpSm9ESmkrbUI1L1Zz?=
 =?utf-8?B?dlY4UFhOOFRBRE1YWkIyTmJMWlQ4dWRXRlhVUEFmWGlwOWtVTnd5VmVGeEVa?=
 =?utf-8?B?dTVzYXUyRnBUSnVJWmlyN2JwK28vT05PNmQ2ZWNyK3VmaWJMVjA3SlhCYXdR?=
 =?utf-8?B?SFVvZGxvNkFDQk1WSUp4dTZDV0M3ZkU1UFZwTVhSZkVDWndJaW5PbGF0aGJT?=
 =?utf-8?B?Ry8wODBvWThrSGJ4Wi9laWI1cnJvUGZObVo4dnplNzhNZ1ZOMzBYRHBoL2Rr?=
 =?utf-8?B?ODByYVRkeGxjQmJYbytGaFBEc1FYNGorOS9lb056ZjZSNG1XMVl6bGVWamRB?=
 =?utf-8?Q?z+VIF0JsIy57cSekt1/Bc6fDo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49309c75-eb6c-4ddc-5d83-08dd2f4c9a6f
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 18:53:41.2886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1d8mOL/vZgcmBp3eBV0EYDoGhiRrXOio4O02qFxEiyBIuJq+0D2SwEbH8mrLvqPfqvvm7RS9YgvQjt3d5EomdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8305



On 1/6/2025 9:29 PM, Alexey Kardashevskiy wrote:
> On 4/1/25 07:00, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Modify the behavior of implicit SEV initialization in some of the
>> SEV ioctls to do both SEV initialization and shutdown and adds
>> implicit SNP initialization and shutdown to some of the SNP ioctls
>> so that the change of SEV/SNP platform initialization not being
>> done during PSP driver probe time does not break userspace tools
>> such as sevtool, etc.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 149 +++++++++++++++++++++++++++++------
>>   1 file changed, 125 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 1c1c33d3ed9a..0ec2e8191583 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -1454,7 +1454,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>>   static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool writable)
>>   {
>>       struct sev_device *sev = psp_master->sev_data;
>> -    int rc;
>> +    bool shutdown_required = false;
>> +    int rc, ret, error;
>>         if (!writable)
>>           return -EPERM;
>> @@ -1463,19 +1464,30 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp, bool wr
>>           rc = __sev_platform_init_locked(&argp->error);
>>           if (rc)
>>               return rc;
>> +        shutdown_required = true;
>> +    }
>> +
>> +    rc = __sev_do_cmd_locked(cmd, NULL, &argp->error);
>> +
>> +    if (shutdown_required) {
>> +        ret = __sev_platform_shutdown_locked(&error);
>> +        if (ret)
>> +            dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>> +                error, ret);
>>       }
>>   -    return __sev_do_cmd_locked(cmd, NULL, &argp->error);
>> +    return rc;
>>   }
>>     static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>   {
>>       struct sev_device *sev = psp_master->sev_data;
>>       struct sev_user_data_pek_csr input;
>> +    bool shutdown_required = false;
>>       struct sev_data_pek_csr data;
>>       void __user *input_address;
>> +    int ret, rc, error;
>>       void *blob = NULL;
>> -    int ret;
>>         if (!writable)
>>           return -EPERM;
>> @@ -1506,6 +1518,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>           ret = __sev_platform_init_locked(&argp->error);
>>           if (ret)
>>               goto e_free_blob;
>> +        shutdown_required = true;
>>       }
>>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
>> @@ -1524,6 +1537,13 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>>       }
>>     e_free_blob:
>> +    if (shutdown_required) {
>> +        rc = __sev_platform_shutdown_locked(&error);
>> +        if (rc)
>> +            dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>> +                error, rc);
>> +    }
>> +
>>       kfree(blob);
>>       return ret;
>>   }
>> @@ -1739,8 +1759,9 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>>       struct sev_device *sev = psp_master->sev_data;
>>       struct sev_user_data_pek_cert_import input;
>>       struct sev_data_pek_cert_import data;
>> +    bool shutdown_required = false;
>>       void *pek_blob, *oca_blob;
>> -    int ret;
>> +    int ret, rc, error;
>>         if (!writable)
>>           return -EPERM;
>> @@ -1772,11 +1793,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
>>           ret = __sev_platform_init_locked(&argp->error);
>>           if (ret)
>>               goto e_free_oca;
>> +        shutdown_required = true;
>>       }
>>         ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
>>     e_free_oca:
>> +    if (shutdown_required) {
>> +        rc = __sev_platform_shutdown_locked(&error);
>> +        if (rc)
>> +            dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>> +                error, rc);
>> +    }
>> +
>>       kfree(oca_blob);
>>   e_free_pek:
>>       kfree(pek_blob);
>> @@ -1893,17 +1922,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>       struct sev_data_pdh_cert_export data;
>>       void __user *input_cert_chain_address;
>>       void __user *input_pdh_cert_address;
>> -    int ret;
>> -
>> -    /* If platform is not in INIT state then transition it to INIT. */
>> -    if (sev->state != SEV_STATE_INIT) {
>> -        if (!writable)
>> -            return -EPERM;
>> -
>> -        ret = __sev_platform_init_locked(&argp->error);
>> -        if (ret)
>> -            return ret;
>> -    }
>> +    bool shutdown_required = false;
>> +    int ret, rc, error;
>>         if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
>>           return -EFAULT;
>> @@ -1944,6 +1964,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>       data.cert_chain_len = input.cert_chain_len;
>>     cmd:
>> +    /* If platform is not in INIT state then transition it to INIT. */
>> +    if (sev->state != SEV_STATE_INIT) {
>> +        if (!writable)
>> +            return -EPERM;
> 
> same comment as in v2:
> 
> goto e_free_cert, not return, otherwise leaks memory.
> 
> 
> 
>> +        ret = __sev_platform_init_locked(&argp->error);
>> +        if (ret)
>> +            goto e_free_cert;
>> +        shutdown_required = true;
>> +    }
>> +
>>       ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
>>         /* If we query the length, FW responded with expected data. */
>> @@ -1970,6 +2000,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>       }
>>     e_free_cert:
>> +    if (shutdown_required) {
>> +        rc = __sev_platform_shutdown_locked(&error);
>> +        if (rc)
>> +            dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
>> +                error, rc);
>> +    }
>> +
>>       kfree(cert_blob);
>>   e_free_pdh:
>>       kfree(pdh_blob);
>> @@ -1979,12 +2016,13 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>>   static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>   {
>>       struct sev_device *sev = psp_master->sev_data;
>> +    bool shutdown_required = false;
>>       struct sev_data_snp_addr buf;
>>       struct page *status_page;
>> +    int ret, rc, error;
>>       void *data;
>> -    int ret;
>>   -    if (!sev->snp_initialized || !argp->data)
>> +    if (!argp->data)
>>           return -EINVAL;
>>         status_page = alloc_page(GFP_KERNEL_ACCOUNT);
>> @@ -1993,6 +2031,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>         data = page_address(status_page);
>>   +    if (!sev->snp_initialized) {
>> +        ret = __sev_snp_init_locked(&argp->error);
>> +        if (ret)
>> +            goto cleanup;
>> +        shutdown_required = true;
>> +    }
>> +
>>       /*
>>        * Firmware expects status page to be in firmware-owned state, otherwise
>>        * it will report firmware error code INVALID_PAGE_STATE (0x1A).
>> @@ -2021,6 +2066,13 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>>           ret = -EFAULT;
>>     cleanup:
>> +    if (shutdown_required) {
>> +        rc = __sev_snp_shutdown_locked(&error, false);
>> +        if (rc)
>> +            dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>> +                error, rc);
>> +    }
>> +
>>       __free_pages(status_page, 0);
>>       return ret;
>>   }
>> @@ -2029,21 +2081,38 @@ static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>>   {
>>       struct sev_device *sev = psp_master->sev_data;
>>       struct sev_data_snp_commit buf;
>> +    bool shutdown_required = false;
>> +    int ret, rc, error;
>>   -    if (!sev->snp_initialized)
>> -        return -EINVAL;
>> +    if (!sev->snp_initialized) {
>> +        ret = __sev_snp_init_locked(&argp->error);
>> +        if (ret)
>> +            return ret;
>> +        shutdown_required = true;
>> +    }
>>         buf.len = sizeof(buf);
>>   -    return __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
>> +    ret = __sev_do_cmd_locked(SEV_CMD_SNP_COMMIT, &buf, &argp->error);
>> +
>> +    if (shutdown_required) {
>> +        rc = __sev_snp_shutdown_locked(&error, false);
>> +        if (rc)
>> +            dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>> +                error, rc);
>> +    }
>> +
>> +    return ret;
>>   }
>>     static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable)
>>   {
>>       struct sev_device *sev = psp_master->sev_data;
>>       struct sev_user_data_snp_config config;
>> +    bool shutdown_required = false;
>> +    int ret, rc, error;
>>   -    if (!sev->snp_initialized || !argp->data)
>> +    if (!argp->data)
>>           return -EINVAL;
>>         if (!writable)
>> @@ -2052,17 +2121,34 @@ static int sev_ioctl_do_snp_set_config(struct sev_issue_cmd *argp, bool writable
>>       if (copy_from_user(&config, (void __user *)argp->data, sizeof(config)))
>>           return -EFAULT;
>>   -    return __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>> +    if (!sev->snp_initialized) {
>> +        ret = __sev_snp_init_locked(&argp->error);
>> +        if (ret)
>> +            return ret;
>> +        shutdown_required = true;
>> +    }
>> +
>> +    ret = __sev_do_cmd_locked(SEV_CMD_SNP_CONFIG, &config, &argp->error);
>> +
>> +    if (shutdown_required) {
>> +        rc = __sev_snp_shutdown_locked(&error, false);
>> +        if (rc)
>> +            dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>> +                error, rc);
>> +    }
>> +
>> +    return ret;
>>   }
>>     static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>>   {
>>       struct sev_device *sev = psp_master->sev_data;
>>       struct sev_user_data_snp_vlek_load input;
>> +    bool shutdown_required = false;
>> +    int ret, rc, error;
>>       void *blob;
>> -    int ret;
>>   -    if (!sev->snp_initialized || !argp->data)
>> +    if (!argp->data)
>>           return -EINVAL;
>>         if (!writable)
>> @@ -2081,8 +2167,23 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
>>         input.vlek_wrapped_address = __psp_pa(blob);
>>   +    if (!sev->snp_initialized) {
>> +        ret = __sev_snp_init_locked(&argp->error);
>> +        if (ret)
>> +            goto cleanup;
>> +        shutdown_required = true;
>> +    }
>> +
>>       ret = __sev_do_cmd_locked(SEV_CMD_SNP_VLEK_LOAD, &input, &argp->error);
>>   +    if (shutdown_required) {
>> +        rc = __sev_snp_shutdown_locked(&error, false);
>> +        if (rc)
>> +            dev_err(sev->dev, "SEV-SNP: failed to SHUTDOWN error %#x, rc %d\n",
>> +                error, rc);
>> +    }
>> +
> 
> same comment as in v2:
> 
> 
> It is the same template 8 (?) times, I'd declare rc and error inside the "if (shutdown_required)" scope or even drop them and error messages as __sev_snp_shutdown_locked() prints dev_err() anyway.
> 
> if (shutdown_required)
>     __sev_snp_shutdown_locked(&error, false);
> 
> and that's it. Thanks,
 
Yes, makes sense to use the dev_err() in __sev_snp_shutdown_locked() as that is the whole purpose of the first patch in this series, but will
still have to declare error as a local as we can't use argp->error here.

Thanks, 
Ashish

> 
>> +cleanup:
>>       kfree(blob);
>>         return ret;
> 


