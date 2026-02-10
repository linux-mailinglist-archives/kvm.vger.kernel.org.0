Return-Path: <kvm+bounces-70779-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MEkYGaSKi2nYVgAAu9opvQ
	(envelope-from <kvm+bounces-70779-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:44:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E9F11EC60
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:44:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2BAB7304AD0A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 19:44:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB2B31A072;
	Tue, 10 Feb 2026 19:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OI57wnfq"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010058.outbound.protection.outlook.com [52.101.85.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B332F49F0;
	Tue, 10 Feb 2026 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770752663; cv=fail; b=ODJLCHV3qOsRKn8XLK33OgxaP0rXkcDUpUw1OFhIqkOMa1qPq0BI+ITnNpfi+mfKOibYchavpHpw8UEB8k5aN0JcQnY3DpaGp4aO4gSIlW6hD/Zhe+yr+JH8mTaREA3rOJdIiidMOCRahNLVzSv2GHU2D0/DeM/JNRpQzMWrVcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770752663; c=relaxed/simple;
	bh=pcxeL9trPZvPmD+0m399Rim1/QXeTmg/lGxPrzrcfXs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CHa03V3rUf56zQvzRJ8kGdninviDqpX1Xi8GkVKeh4WR+tQbFcGaAG1VhpE8WsbrRAhR5CuV/d5Uf5OpfL7Mg12Abij/rmHbxMDG7vLbZFbEe0+Bg3dU/NW3idN3bN6O2ws3wIRMnwrkQ16kcYlCwqLcP/x9WK3hlmscMNtXo1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OI57wnfq; arc=fail smtp.client-ip=52.101.85.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CqfRWct9jWKrpKQv1rP5wckojO40cUDrtwK37UG8TlNiiij161toW+wtJwybqFI5IbjR0HQW3nkMxzZ5HEl91vdJZttb1t+94m0nA+TX+Ct32DZB8PwiUpe21mUrkklD10xiZv4IdFgdL5RpTDIj3RyEzA366tDxAa7uFTFkjrisVWPJ0XyeWOSa89WLej8fAWmUfu1NOFt8ikfGoMczod/Yra1QtwT6W7s8TJSsBXIkAUt91I6jzbGksoQ7j90Bs7cUA/SakaalQlKOeeCaF1oGDHHL6Gy1XhSOQD5qdHMF8p886EqziTo5XyMPttClpo9qHB2BJe7eWfRy14wmXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NpSv1vWcBa00FUuveIaluWz0/qF4Zbt+RtvPEMq/Bg=;
 b=VuTZPums262sQJodRqRAIB26+uIdZhyDC7PLqBpuwpC61HIanULHOE8qwvQP/Sv7VvACecXk/+ePgVDyoRS2J7AQpnRJ1xT6aeZX0rVjvnze2FfvSdEh+hFVSNVQj+iPNpH8RAeswR2cxDx+jW/BtuoVfcJev6ebHukrRXENcmTIDEBFUklFAM0rIWvXyzuE6zlR6z8leZlO+k+4IZAFp3LHBwNV7yrY4LmhQepc4ZdyqHU/O8livUOouhyJo5ZL4ildrg0pXE7oC6Bw5eScRhicHfnm5IjNvQH5r2ZnmCTt2gGoQGnDxEGT2l+fmmtBs0e95sDBaGMcqVzTyrT7PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NpSv1vWcBa00FUuveIaluWz0/qF4Zbt+RtvPEMq/Bg=;
 b=OI57wnfqFwHTDsoGrnnA9OZZMRwawVy6ILqox0MfsbBJyISVjyFb/IDKf4ZRkz8/8vOcehQe1/jdn6v4Znd6wZs0WeVp4mFqpcgccQu1+UFwjKchzFReE6kfRS3Qihgf7E4JergFUiAZ5x9GNc5okKY0lAsZXcQT8f3CeKSwRrw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by SN7PR12MB8169.namprd12.prod.outlook.com
 (2603:10b6:806:32f::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Tue, 10 Feb
 2026 19:44:19 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.006; Tue, 10 Feb 2026
 19:44:18 +0000
Message-ID: <b815f822-83e7-4ab5-8464-7f53485ba362@amd.com>
Date: Tue, 10 Feb 2026 13:44:14 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/19] fs/resctrl: Add the documentation for Global
 Memory Bandwidth Allocation
To: Reinette Chatre <reinette.chatre@intel.com>, Babu Moger <bmoger@amd.com>,
 "Luck, Tony" <tony.luck@intel.com>
Cc: corbet@lwn.net, Dave.Martin@arm.com, james.morse@arm.com,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com>
 <aYE6mhsx6OQqeXG4@agluck-desk3>
 <e0c79c53-489d-47bf-89b9-f1bb709316c6@amd.com>
 <493bd87b-6f91-4fbb-9215-c07fd8105393@intel.com>
Content-Language: en-US
From: Babu Moger <babu.moger@amd.com>
In-Reply-To: <493bd87b-6f91-4fbb-9215-c07fd8105393@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:806:22::10) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|SN7PR12MB8169:EE_
X-MS-Office365-Filtering-Correlation-Id: e3334c23-d65c-49c3-7e15-08de68dcc7b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N0w1bngyTllNcVFvRTdVelFiUmY5N3Z4NE1CSTRnSVQvUDVTTko5Mk5xbTZt?=
 =?utf-8?B?dVIzeVd6QkJWR0V0UVNDbkFQQzN2K1QvcVR6T1k2YVl1azM1RUhOMlNMNG1Y?=
 =?utf-8?B?SnBhMUN4NzAyK0hZR3ZpUittOC9QK1ROVWhERjltWXZtTkF1MWwzR2NpWmhh?=
 =?utf-8?B?dmtsTTY1Ly9Kb05MMFl2KzR6dldFYmVXaGZUVUhURnlBemtkT25RNEJ3WVNX?=
 =?utf-8?B?b2V2UERKdm5XUVVHdmFUOG5KbnBQQ0d1by9wY21aY3VaVEhlbXIwSHJ5U3hJ?=
 =?utf-8?B?b05IcVBIcnY2N1ZtY3FXNWFqN2w3MEFiQnpQRlFhZXg5MDdqengyOFhRL0th?=
 =?utf-8?B?dTZNdTV5N3lVaWR0akNyVjRwalpqdUpVUi9yUmZsRThMTllxUUJ4RUdCRFR2?=
 =?utf-8?B?T0NxeFVUNTF1U25BcU1vTG9mbHQ1NlRzRE9IanFwV05tWkpHV1Z3c3R1emRW?=
 =?utf-8?B?WG5lck1vRzZSSzFkaFdYK1o0WUxkWHJDV0ZnWkFkSVNad1ZITmp5NmR4NThK?=
 =?utf-8?B?RDBURkt3Q3lXaGtrT1hMNXpiRThVY2lQcGxZOStUb2Y4UTN0bXhqL1lwY0Zj?=
 =?utf-8?B?VHVqR0Y3TDBPN0VuR004a0E5bVRjdVNpTEprZDNWdld0aGFXREM2bmoxRmJJ?=
 =?utf-8?B?YnBVNEFFR2I1OUUwWlE5WXJLa2FodU1MclYxN3A1U0t0Z3NZbCtRNzF1eTdD?=
 =?utf-8?B?ajFpUE9kSVlLakVjeTFOZmtzcFFzNVo2K3duQ0JRSlVZWG9hdG11YTJPWnZa?=
 =?utf-8?B?cVlNb1VVbE9SaDNaOThQOGRzckxTOXF0VmU1R0duWmZrQWRMMldaK1RKd3p3?=
 =?utf-8?B?SldpYnFpL2xvL0hzMUdRdnFmY2Fna2pHN1BWNE05WkM2S3VlZ1JKUmp4ZjJj?=
 =?utf-8?B?NmZ4aTB1YWZyTFdjRVczUlQwMUVvNVRlSURKVk80S0ErUlhDaXR6ZnM3bCtz?=
 =?utf-8?B?aDRwaGRJc1F4aDQyUHJjRytyNk9jdXR1ZVVuaUM3ZFVkTFZVQ2pnQTFjYll6?=
 =?utf-8?B?TTVNWG0yUzVzSzFqRFdndEpaa2p2TUFUYUZiSk9GazRLUVd1aGNpcHBGeWIz?=
 =?utf-8?B?S0lNYWhKRStvVnJwaTlpZ0Jjc2N4a1UycGtiNldRak9xVXVuRmI1QTVid2c4?=
 =?utf-8?B?VWNYRklXTzk4RTNTdy9hWWwzV2c3d2RYSnFQVFZIcFIrNmtteXdRNEJJem82?=
 =?utf-8?B?ZGRsaVpYeTkwVzRIMHc1OXBQRlhLU3phcDExa0xnV1p5WFhTSFU4UDNwd3B5?=
 =?utf-8?B?V1c0VzFNaDNta0hlSWhnb3BqM0ZtRVhtWGZ4SjdFWkRPaWRScDMzWnhLdmRN?=
 =?utf-8?B?T1ZFRzkycVRCTjZHUm5UazdHWXFTTzNYQ0tkRXVQNk0weEdRbFBvNnAxZlp5?=
 =?utf-8?B?ZlhqbDM2S3M1L1hyZDdOVzRTRXBxVkl2emZ3aXNjeEJVeHdRdmQ3M3pBZHhO?=
 =?utf-8?B?Q1RZZ1Rob29QZmxocEd1YmFPUStkVWdKbmdsZXFhUjhZaGI0RTlSUTRBQTEy?=
 =?utf-8?B?Z1NUcks1MVRxOGF1NE9HQmtqMHUxOGFnd3p2QTA3SFZZL3AxdlhGVkFFa0hH?=
 =?utf-8?B?QmM3blBrZEFRZmticndHRGVsbFJSbUFkSnM0a3N0cDh4eFZLTS8yQlBuR3Fq?=
 =?utf-8?B?Tkt5ckM1Q2FtNlZ1djdpWmJIVHMyL1BkWTE4bnhENGFiMnM3OHdGTnZ6TzQz?=
 =?utf-8?B?aXhBK0F2VExUaU1FVlpYc20zMGV3U2Y4dzlwWk9ucWJaUkZXOTRPRlZMZzA1?=
 =?utf-8?B?eTVPMkpTdDBvVjFDYXVRdGUxSitxTExQTU1rMU9CcnRxRXRkSjlXLzlKMVAz?=
 =?utf-8?B?cTVNY1ZjL1dTNnVRdWhwKzFpQUw0cmcra3RsbGJHZ1lHMmZmZWllNWJTaS9u?=
 =?utf-8?B?SHJjQzdkaGNzaVpoaVlQczRXeCtRNGYzTkNNOXErSDE0R2JBZUh0WS9oZURo?=
 =?utf-8?B?KzgvTEp6ZWFxN3I3enoxRlZhYjk4b2kwU3FRK1VFZWl4bHlGNWdTdWJaMXl1?=
 =?utf-8?B?c2hvOFdvc2ppVlNJNHN4amZsTjVjZTRYcDNMazlETWUwL29oa051enZkU0xQ?=
 =?utf-8?B?Tnc0Z29qZ3VRTHcvVnBoc2g0MllkZGNJVGI0aVRySXp2N0pwKzhRSWIwUVVt?=
 =?utf-8?Q?iKh8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGdFQzd1MmJKMzRvRkxJT0ozMXBrU1FCWnZ0dzJCdjNiaWFITVF3NGI0TVFk?=
 =?utf-8?B?UFRqdGRqdzNzc1FwR2ptNHF4ckYzUFRRa3RnbmhMQjEycWpGUzUvWTcyWGxh?=
 =?utf-8?B?aUkvQ25zMjFWd0dZdlBJUGo4bU1Xa1hrcjJWTHlRRkZrdUJsQnQwa202VDhO?=
 =?utf-8?B?L2VzcHJDK0VPWlplYTBPaytLMjJDdFBKcTdrT0J5b1BSdEczanRPRlZLUitr?=
 =?utf-8?B?eTVPMlhDSkVRUEtRRTlaTW1xRVJLaGtLRS9nWTYwdCs1MDVJcmFINHJSM0xE?=
 =?utf-8?B?RXBqU0JMOEpsbkRSeklDT2RIZjgvbXk1MzQramJ5aTdocGI1ZExMRlVXOWZ4?=
 =?utf-8?B?eWNxYmljVmtnS1VWRTI1d2poMmpOenlVM3ladC9uYVJhYUlYYWJIN1g3N3Rr?=
 =?utf-8?B?QjJxVTR4dlFUUFF1YmZHblROZk52aW1rWWlZcFEwRHVvU29DM0c4SllrSEVq?=
 =?utf-8?B?TXR1Wm5FdzN1TVVtMEhQazA3djZxcHlwekc2YnNLcVVJSTZPWTkwaTdsWHB3?=
 =?utf-8?B?c3hMMXQxMXgxa1JzUlpPcFJzVjdMQlhTTG4vcjNMRFJvdDlxQ3BnYVNmN1pY?=
 =?utf-8?B?blRCQmlhdHcrN3lhZmJoN3hjU1N3SldCSUw5a1plVk9BZDErdzVVb0xiWHBR?=
 =?utf-8?B?bWxTVEV4RmZEL0VxN3FUOHJOUkQxWFRjdW9KY3NHaXVsTEdBMzZKN2cvWU9u?=
 =?utf-8?B?TUovTDZUSUFXZ3FXa0VjM1g4b3d6eVpRMXFlMDVYa2k1a2dXM1dRWUgxK1Bv?=
 =?utf-8?B?ZVZUSmVkSHNNa0JyVTJCTWpGc1A0QzMwbFBQNVJRTjN0NEVHd1dYVmM0MWdn?=
 =?utf-8?B?NXBIVURTM2s1cXlwVHpVU0xra1l4UklYdVo2dHp2NFBzOFovQnk4czRDaU9E?=
 =?utf-8?B?MWgzSW5nN05aNFVQZnZZV3NBUkVqUEswNVRubnNteWpoaWVac0tkRkpnZTZP?=
 =?utf-8?B?QnA1RzNYUGxGempTRWJTQnpVTWh6TzB5U0tacE02SGtGKzFlRmN4cVNYVml2?=
 =?utf-8?B?azJKM2dlUUg4a2VlRTNtaXJ4b2hseUp6K0I5dXNJNzdFQ0dhbUVCQ3BnbEl0?=
 =?utf-8?B?bFp6cCtTQ2xHLzBLOHozTWlXcFFTSndQR0FOZjNMRXpUeTh0MUJMYUFPanpK?=
 =?utf-8?B?K293NzFzQkhWSTB2SW91QW9wdkx0WmlyVGdQbGVaaUlDZ2htaVZjK3kxclVo?=
 =?utf-8?B?V3l6THVQck81d2VSY3dwRkNtMXB0RVptWlpDNnJROHkwU2F2aDdOcVVkZUxF?=
 =?utf-8?B?RTBpclFPS0lPSWlqcE4rMDd1NmN2UStsbm9FL3JEeWlLOTVCRXN3dUpDdUhz?=
 =?utf-8?B?VWEzdEJ6QjdEbEJTVzRXK3Y4aFB0SFNYc0ZUbmNmSlZYcDBrMWVsT2xOS25p?=
 =?utf-8?B?K2lRZDlkSHJLS3hxY2tCVDJjemNZZkNrcnpOVHNCdmh4TTQrS2xSaDRVWm92?=
 =?utf-8?B?anc1cGZTME5KbWM4OWlrWTZ5V0lmZ1RiKzEzMHg5MXIyZ3ZyNVk2VWJKSGVX?=
 =?utf-8?B?QVg5Szl1Q1FvWW5pcTlSd2xKanNDU3VGcTBrYm1ybXREK09NeVlmYTlZTTZo?=
 =?utf-8?B?eFVGMFZIQloxaWJ3MGxzNThzU05Wbm1kOVo3ODBscVV5WjI5dTNOVmNMb0pD?=
 =?utf-8?B?T1B4VnA0dStoRkU1UWUwOE1XNUswdjZZOUswWE1TekV4S3B3QlV4bkphdUI4?=
 =?utf-8?B?OWJUMHFyLzVnWHhrRTBOSDdpWWdoY2xrUWZ5U3EwdU5NOWd5dnU1OCt2Tm1h?=
 =?utf-8?B?OVR5UTZiMCtnNHhCaXB4N2pVRzcvOUZWYm1VWUlIS3hHWEV3ck1WMW92TEJC?=
 =?utf-8?B?RkwxcXBhUDFCVml0aDhwUFpuNWxubTRJRzNtekFEeGdrdlI4aENqZFcwTkFs?=
 =?utf-8?B?S1VtaUs0VFFBaXFBcXV4cTFYYllSM2VOc3k1QWlTQUtKRG40aHBrUklrWTRZ?=
 =?utf-8?B?MXRvL3plWTRDU0RHenBMcmh2cW1DNHlrdUxJUHJ4dGxwYmdtbXVUNVcyNVZU?=
 =?utf-8?B?aStkNjNTRDhWR1pRby9yZnM3VWZnOUExUVRSSTlNVlhaZ056STRTd3VYaFhB?=
 =?utf-8?B?THQ1eTMxZ2dlM0NFNW1YdEthelg4a3VDMkdzTGZCQ0lVOEVrZ3Q2Uk5LYURZ?=
 =?utf-8?B?eVdIOGdoU0dhWkY0SHNBTndQUnBPNlNINVZCSDJ6SGVXcTMwZXA3cStIZy8v?=
 =?utf-8?B?S3FpbWpqN29CMEhGV2MwZXFEdnVyb2lZWWtudnRZQ2Z0ZG9iZWVOU3ZqMEk2?=
 =?utf-8?B?YndqTUVla0lrUEVodHJaKzhEQ2d5V1NWa0p6QzE5RGNXRUFscXF4N2pjSk5P?=
 =?utf-8?Q?ARFcCGr7XxKxusAlXk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3334c23-d65c-49c3-7e15-08de68dcc7b2
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 19:44:18.7550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJCCv9wR3ZfHeOytznH4vM1Evi/yrPaYKXCs7PFwCXMN6fBxuJyC+f2omfGNEn6V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8169
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-70779-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: C0E9F11EC60
X-Rspamd-Action: no action

Hi Reinette,

On 2/9/26 10:32, Reinette Chatre wrote:
> Hi Babu and Tony,
>
> On 2/3/26 8:38 AM, Babu Moger wrote:
>> Hi Tony,
>>
>> On 2/2/26 18:00, Luck, Tony wrote:
>>> On Wed, Jan 21, 2026 at 03:12:42PM -0600, Babu Moger wrote:
>>>> +Global Memory bandwidth Allocation
>>>> +-----------------------------------
>>>> +
>>>> +AMD hardware supports Global Memory Bandwidth Allocation (GMBA) provides
>>>> +a mechanism for software to specify bandwidth limits for groups of threads
>>>> +that span across multiple QoS domains. This collection of QOS domains is
>>>> +referred to as GMBA control domain. The GMBA control domain is created by
>>>> +setting the same GMBA limits in one or more QoS domains. Setting the default
>>>> +max_bandwidth excludes the QoS domain from being part of GMBA control domain.
>>> I don't see any checks that the user sets the *SAME* GMBA limits.
>>>
>>> What happens if the user ignores the dosumentation and sets different
>>> limits?
>> Good point. Adding checks could be challenging when users update each schema individually with different values. We don't know which one value is the one he is intending to keep.
>>
>>> ... snip ...
>>>
>>> +  # cat schemata
>>> +    GMB:0=2048;1=2048;2=2048;3=2048
>>> +     MB:0=4096;1=4096;2=4096;3=4096
>>> +     L3:0=ffff;1=ffff;2=ffff;3=ffff
>>> +
>>> +  # echo "GMB:0=8;2=8" > schemata
>>> +  # cat schemata
>>> +    GMB:0=   8;1=2048;2=   8;3=2048
>>> +     MB:0=4096;1=4096;2=4096;3=4096
>>> +     L3:0=ffff;1=ffff;2=ffff;3=ffff
>>>
>>> Can the user go on to set:
>>>
>>>      # echo "GMB:1=10;3=10" > schemata
>>>
>>> and have domains 0 & 2 with a combined 8GB limit,
>>> while domains 1 & 3 run with a combined 10GB limit?
>>> Or is there a single "GMBA domain"?
>> In that case, it  is still treated as a single GMBA domain, but the behavior becomes unpredictable. The hardware expert mentioned that it will default to the lowest value among all inputs in this case, 8GB.
>>
>>
>>> Will using "2048" as the "this domain isn't limited
>>> by GMBA" value come back to haunt you when some
>>> system has much more than 2TB bandwidth to divide up?
>> It is actually 4096 (4TB). I made a mistake in the example.  I am assuming it may not an issue in the current generation.
>>
>> It is expected to go up in next generation.
>>
>> GMB:0=4096;1=4096;2=4096;3=4096;
>>     MB:0=8192;1=8192;2=8192;3=8192;
>>      L3:0=ffff;1=ffff;2=ffff;3=ffff
>>
>>
>>> Should resctrl have a non-numeric "unlimited" value
>>> in the schemata file for this?
>> The value 4096 corresponds to 12th bit set.  It is called U-bit. If the U bit is set then that domain is not part of the GMBA domain.
>>
>> I was thinking of displaying the "U" in those cases.  It may be good idea to do something like this.
>>
>> GMB:0=      8;1=      U;2=     8 ;3=      U;
>>     MB:0=8192;1=8192;2=8192;3=8192;
>>      L3:0=ffff;1=ffff;2=ffff;3=ffff
>>
>>
>>> The "mba_MBps" feature used U32_MAX as the unlimited
>>> value. But it looks somewhat ugly in the schemata
>>> file:
>> Yes, I agree. Non-numeric would have been better.
> How would such a value be described in a generic way as part of the new schema
> description format?


I dont think we need any special handling.  We should report the actual 
numeric value for max in new format.

> Since the proposed format contains a maximum I think just using that
> value may be simplest while matching what is currently displayed for
> "unlimited" MB, no?
>
Yea.  I t should be ok to display the max value here.

Thanks

Babu


