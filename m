Return-Path: <kvm+bounces-47672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EDF6AC3822
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 05:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92947189078B
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 03:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B2D9190692;
	Mon, 26 May 2025 03:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iB6xCSOB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E284C6E;
	Mon, 26 May 2025 03:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748228435; cv=fail; b=Ph7LuTJo8LvO8+tEWLiUKQzmX0da0/q/GEPxo+0VlEJE31OAYqDs8aa1IKb0xo6cpemVHgP3Im1M2bfZV/x43J9AfM3trch5wS3UKgu0owi2T3WNZpRtGhTUFPknjvQWWEkebLggM4ni0TRWAKN+7LWN+MSnoYn7padrT3HNg8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748228435; c=relaxed/simple;
	bh=Fjuv1BVUzWC8KvCHTv6P/1nCYsAu3Xyu3r1HaXba4vI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uVJ7bjd4D10KvJOxXJCUN2mjcIvPf0e4R//FWI5CUj1lqV1ZXN2+DV1bJL7fHPZDVCLI8Iszs02PqY6uwRYcrmvAQdWQYyXCQ8RvTNwjWKwB+UzXRlHZPCT1KkrmDcZZrPATMHunprPTluZSXHDYHiDViTwT4qdNJk4+jcdtF/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iB6xCSOB; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BTuMtZp98FsqJLwfBhZaiXiRA6ibRhl+PMkGE3MzxlRU5movJriSb+6iJwB8uuTh1UCu3OmgQcw8jnnkiPYT8nFa2XfSqKYX9PxqSgBdQROM6578dB/1FrGw1Kj8dZL64pl1fgFgyIQTB/Od1yPWVvHz9RiS7GkwUZAIkSpHGMTYyo9+v3GrwVwGwo62QIP5tVw8ir3wOUmI28j34heJcp8TZ5Z03QiByrN1excKTTPf9wNJ4aMOaHEBInS14Hl7/lOJwode80TH6+QGtg1JCv8AHZ9oQhu1qx7ZBvXSdV98i4Xqo1iuEKdl9GDkje/qXoW4VSEHNzFlVV+6f3gzYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OWhc9KVtOoUIQnhyDL6rYyLM0r9TpMNVpqqnqSY6Tvo=;
 b=JtnRdDBcN+zlI8kF4SyF3uzETpke3Id4Yrs4gxKGZCaReR8y1ZOy909Eer0SsGCsSwVePsrZnBPhQkph+iVLFcwdHH/PFvr6L9oTa5cMPuu4QO8mEzBb7csNi5ZKM4zbjllh64U/QgZgxpGuLoijP9QdoPpjoyeL9wlF8yyn6YWuXNhcIg1P4kIeqnLmNFQPCll4Q9bJGlA2pERUdy4YZy8LBHjW3l6NUa+7M/wSdZxyllYNhjiZ/1SEk9Gytm+Cx+wYCP3lrYDZsXmZ/htSKK2CpUe6uD9b/uzRtmClSMuhUIqx6TRq6hK1fl/yDAs8tY8L2Rehse7uJotm0BRZjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWhc9KVtOoUIQnhyDL6rYyLM0r9TpMNVpqqnqSY6Tvo=;
 b=iB6xCSOBmnAGzyIq1ZB6G+KOA/KECLxRaAorned4v0V+ozRGl/7BQQx3cgOD9BtwH0hNe6XRCPJAsv+tjyv8GGLMsNt09uXnGpFfbdeDn2mXR7PuHbrvNxqvBePbaNqXjMge0N19jH4zMGjACBxgBp7TKlaPq3jYD3POClOw+Ug=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 IA0PR12MB9048.namprd12.prod.outlook.com (2603:10b6:208:408::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Mon, 26 May
 2025 03:00:31 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%6]) with mapi id 15.20.8769.025; Mon, 26 May 2025
 03:00:30 +0000
Message-ID: <4dd45ddb-5faf-4766-b829-d7e10d3d805f@amd.com>
Date: Mon, 26 May 2025 08:30:14 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 07/32] KVM: x86: apic_test_vector() to common code
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
 <20250514071803.209166-8-Neeraj.Upadhyay@amd.com>
 <20250524121241.GKaDG3uWICZGPubp-k@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250524121241.GKaDG3uWICZGPubp-k@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1P287CA0016.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::27) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|IA0PR12MB9048:EE_
X-MS-Office365-Filtering-Correlation-Id: 252b9e63-16e3-4501-f9f1-08dd9c0178fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2p0dnVJZ1lHU3RhUDM3V1RHTmdGNnd4K2JoQnJUa2N3YTk3L3phTFFuQTF3?=
 =?utf-8?B?Z0FmSys0SXVzN1NWTkF3N0ZNZ0s4NzJGMUpaUHFudjlMaGVoYldrTnRQdzdF?=
 =?utf-8?B?TVk3dlpvNGJBSXFhYlZaYUhPdjFnUzV0Q1RiUys1azl5ZGxYTUFyaU05Q0VG?=
 =?utf-8?B?ZWRsY0JuWHBwNjA4SE5RL0lxdTRCU3lSNzVKZ1oyamZlYmFnWXBYR01Hbmdk?=
 =?utf-8?B?RUZhdGkyWW5zK0lFYWtzVklwQlEwSTArbk5tZGVhVFFoMnRaNDdRZmNYUXkw?=
 =?utf-8?B?c05zNnVnWUtsRnVOSUN6VUo1RHcwaGlTcVBYdnJvYlFpdzM0a25pYWFJeklD?=
 =?utf-8?B?U3phOEtVcVRwS0FSd2t6SVpWMStCUDVFWktUU0cwOTZhYmdHWnhHeTUwV2Qz?=
 =?utf-8?B?SHdRL2xwa0Jxc2paRXFtcEsvaURPSmlkWEdYdzM0NmJmN01EWnNtTzFJMHFN?=
 =?utf-8?B?Q1I4VmkzaEFVNFZLS01RZDhWSDU5Z1dmY21rc2pSYUh2Ly9tMEpZenhDalZt?=
 =?utf-8?B?cTBFUm0yb09BR2NiTlhCZnFFRXVmMVhyNWcvT1BUV2VkbHNvSm5ZYXZjMEhs?=
 =?utf-8?B?SWkrSFVEQy9QbVpmQzhTdGFZLzdwd1Z1elAveVBvdW50MzJrU3VEcGwrODNZ?=
 =?utf-8?B?MW8yR2p4Y1FhVmwrMmNBL29peENJSzVyNjFaenJNblZUTDRQTGl6MjArQTg0?=
 =?utf-8?B?M0FaR2xRTnZxZlJaNlQ5eFlHcGsyWVNzZ0FGZXVvUGNoZXRiMUdHdUVJU0Rh?=
 =?utf-8?B?ZXY5bkNOUTBHM2JLQ3QrQmxHZzhvNG1RUTVJUG9pdXJiRmtTV3Y0eHJ6c0h2?=
 =?utf-8?B?YmFSWnhmMnRVTGU2eW02bjlPOURCdTFDRDJKRUwvR1BJcTEvd1lYVktSekwz?=
 =?utf-8?B?Ymt0enJqL2F6ekRQTGJqcGU2N25hYk55eURNQVlPU0RYY0RjWTMrVFhRRjZz?=
 =?utf-8?B?NHRIZkJPL2JIZGRQd3Q1dVhvS2dBQkNPOE41cERMZVM1REZZSG5DWnBmWTRI?=
 =?utf-8?B?a0RSaDNhS1l1UndDSTdQb0NLc0pMekFBem1kNlNXYklySk1iOFh4dk9Ta3Iw?=
 =?utf-8?B?OFYxN3pJY3pldTBLK2V3bDNmZXRnV051MUJxK2llMHFDR3R4YXl4SXc1ellk?=
 =?utf-8?B?NDQwUklwaS8yQ3AyNE42eGZGR3BBSEp0N08zZW5QdHNwQzdEb253SlNBM2pV?=
 =?utf-8?B?OFlUMGY3N3RWQVZWZGJDQ09VTFR6U3BmVS9DY1Uxd25rOWlxaDhib3FvdlpX?=
 =?utf-8?B?djc4NVJJRkZSUk1iK3BmamE4UVo5emdGTithVnRLRE1RbHJvcDc1RnFrRDRt?=
 =?utf-8?B?RDJUdlY2OEUwSXFMd05zakhydmtxTGdtMkJ0TStqU254dmhTUUZUY3kvQUJ6?=
 =?utf-8?B?d0V5VkRBdlIzb1FuZWFSb1BTRG1oM3ZCOEVuZEZLMTNEdTRPZmNscVRFWFdT?=
 =?utf-8?B?ZHFxbEM5S0lqZG4yY3dPZG5LSlJVQTF3MitQT0ErdXFReWtrVUFNSlNWSFlz?=
 =?utf-8?B?Ry8yamt2QXZsTjV6K09tNlBudXNPQkZ3aDhvdjFVWU1FU2tuVUpBQ092aGwv?=
 =?utf-8?B?dnRjZGdncUg4U1RISitUYVIzNkVia0tIbkJuNlVOU3QyT1ovN1djTW1oTXJN?=
 =?utf-8?B?Q2NmNFY3VDk0TS9oREcraDZtRDhVUnlYZEE2a1YvRE92cWs4VmpYZU9WWmVs?=
 =?utf-8?B?WXhnaUVjSnpTM2lqQ3BiNnMxSEFEclpLcnJwTzhkcEwxRUVBdVRGUUl5RVVL?=
 =?utf-8?B?WHNmRkJlelh0NHUvRmFSNXU0Y28ybWRoM1lrUXNhNGpBeGdpWnMwSVV0M09W?=
 =?utf-8?B?aWs5cnREWlBGVGZrOHIxUVdhUXhLVUJRajA4bXVlc0dRanV2bkhKbXhsTHJH?=
 =?utf-8?B?Ky9GbVZkT0RRVG1iajVjS0JBSWZIR2d4MGhqVGZHZlYrSGFMTmZVaGZkNkNP?=
 =?utf-8?Q?D2vS8nhxhCQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ckZESXdvR2g1bld4STZEaFk0SllwZXdWaHhRSFVLOVBBd3pKNGFNTVoyR3po?=
 =?utf-8?B?QmUvaTlackx2eWZEaUg0RjU0Sm0walJhUDhkb3htd2FUeTlkMCtIOS9qd2Uy?=
 =?utf-8?B?aWRYdEZWUmtheGYwbTRicFMvWVArWEp6a20xZ0laQkFBME13MEp3VVFNUXNN?=
 =?utf-8?B?aTJpakQ0dEhXbHNpbmFDVHlob1FxWnBTdEpkRHA5cnI3OG8weVFZdjQ4OGtB?=
 =?utf-8?B?eTZEbFNHMDczSVBOVGI3QmJ2ZmY3Q0NzU0ZGSzYzYlZUVlNpRFVVZUo3ZEsz?=
 =?utf-8?B?RzFzdmg0M3hKWi9YNmNNN0JJb3M0VUsxdndXeWpzWmJPbmt4U01MNXY4TjA3?=
 =?utf-8?B?SmRHTDZTLzdEeHlSdWJraHl6QmtXVHNMYWt2bVdGRk8zOFdqMTJ2THZQeHBI?=
 =?utf-8?B?U2t1TXdlMkpsWE81RXVJb1Ixa2tPMGF0aGxqcU16VFJNVmFqa29uSUV2SGVo?=
 =?utf-8?B?Wmo1VGZwMFF4TGlxMlc3U21hdThzR2ZxUThxRzNxT05PTklXZ0JCdDBKeWdr?=
 =?utf-8?B?YkJBcjFtdmpJVkl1cnNyMnhnR0h1SU4xVko2ZjZDdmU5U0g3bCtNQXZxUHpn?=
 =?utf-8?B?WUdNVVRaQ05EcE53NzlyaUlKMmxiOHdxYSsvUFRKWUlOUDVvZWQvc3FNNWox?=
 =?utf-8?B?UjVZVGovSTViTjZNM0pBQnQ1YkIvK1FpMVZ2S0dCRkJ1VjFveDVWVitNYVRF?=
 =?utf-8?B?Q2swbUFXb1hNdklVUEpUQUdjSmdWaU4zSnBKL3dPb24zeG13RDJtdzhienls?=
 =?utf-8?B?djdXKzVOYkVEZ2Nra0dOczRPYWp2RHNPcm1yVmQwUlNianVCSGloMHhxblJO?=
 =?utf-8?B?SmtHYzZNTVBzRGNXUE5vbC9lNStJcmZpN002R25rZExyNFVIRUVscTBHc1pi?=
 =?utf-8?B?YjA3dGxZcW44SVVUV3lDcnFhUElKQzk1dlhWVW11Q3BxbkxJWlBNL1UyeXIy?=
 =?utf-8?B?VzNPNVlwakZVRTUvWXdWMDhKZ0NZRnJvd0VvL2VORlI5aFRiMy9nV2FJeXpu?=
 =?utf-8?B?dExvYlgyanVBYXpmd1RvcTJwZWlueVBCdEQ4Z1A4M3Mrc0liTS9QRDgrVTNZ?=
 =?utf-8?B?MldGOTkybG5uM0ZSUHpSV2tSWm55bXUrNnJiUUt3Rm1OMmlMcEJHMURISldw?=
 =?utf-8?B?VTdrU1YrOFppTjNOazEyNTVhR3EzbjFSd1o4cXp3WGdEOERhR3JMM09yUVVq?=
 =?utf-8?B?NFdNeUF0TG5pVzM2VVlrZThrcnJmMlc5NlFxTEVKdk03b2VtWThKUGNaM2Fv?=
 =?utf-8?B?UnNTb2tUVThNRWpTejRiT2JneGNpVFhmRDNzN0pGaXBBQU9iK1hxRXpTS1Ju?=
 =?utf-8?B?QlRrdjE4c2htb2x1S2IwRDNFeS9OUmgzUzJ3SDIyM243em1SK2RCUHcwUEl6?=
 =?utf-8?B?dmFsdzI3cTVlanBIVEwwS0pkblZWTXBtdVJjMURvekxldjhpNWIwNlB5blhn?=
 =?utf-8?B?RmNCSDk2U3I5MjJkMnFydXhsRjk5RlBQMDczaXp2Tm93MDRyaHNScm8xbWxp?=
 =?utf-8?B?UkkvTWZpeGhKNlBzSENONlE3aWpPVy9JVzRGbEttYlE1T0dLWEQ1K0NnY1gw?=
 =?utf-8?B?ZTl6aC9MZEFPOURpSFdLVXAyS0h0RFovZ0U2bUgwb0tWeEhMV0dmSDBnQkJ5?=
 =?utf-8?B?REhwbytxODgzc0ZqdDdyYWVOWVJkNk9OTlJjS2RGYm43Skk3dWRqRDd1SXU3?=
 =?utf-8?B?WlRRYndDR0owOTM4Q2ptN0ZvbUxHbkpXQzIrdHlHaVVia0drUjAxcnBOK2ty?=
 =?utf-8?B?ZVEvb1JWVDU2VEtFMDBIZWpZRXZHdy84V2dwQXU4V0RPMFZzdGxENmhxRmJU?=
 =?utf-8?B?Z29LNEZOWExNcW9nUDk1TVBQMktaa3JXVnNJYk1aelpVTy9lWGhFd3NTRjhI?=
 =?utf-8?B?dSsyYlpvU0kzR2Z0bjA1aG9XOGZZUitSNEE1MWYzMTdRbXcyeFZyTkg0Qk4r?=
 =?utf-8?B?TDhJU3B3Nmpsc2VaK0kyRUFtU0MwT0hRS2kzN2s4U01GVlNHYlpnNVRoOXpN?=
 =?utf-8?B?R3IrZlorR1A2UGVIZGdCWlR6dFl2WERBV3hGTG9DZHFBUC9JTWJuazM2Nzh3?=
 =?utf-8?B?MGpNL1FBVC9hL0k2RzRXOXJxNWhMUCtuK2FDR1d3Z2RURWN4OVVqdXRGK3lz?=
 =?utf-8?Q?yHnOZH6sLjOA6bOxG3sATTb/Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252b9e63-16e3-4501-f9f1-08dd9c0178fa
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2025 03:00:30.0259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kx4j+7RR1PkswPCqjAZYC+wcy9ouWqT+Jb0uNHsunwEVvcn/sqFADfNiSthjYBrnV1gFsCgI8A8Nve+/jzUPEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9048



On 5/24/2025 5:42 PM, Borislav Petkov wrote: 
> 
> The previous patch is moving those *_POS() macros to arch/x86/kvm/lapic.c, now
> this patch is doing rename-during-move to the new macros.
> 
> Why can't you simply do the purely mechanical moves first and then do the
> renames? Didn't I explain it the last time? Or is it still unclear?
> 

I thought it was clear to me when you explained last time. However, I did this
rename-during-move because of below reason. Please correct me if I am wrong here.

VEC_POS, REG_POS are kvm-internal wrappers for APIC_VECTOR_TO_BIT_NUMBER/
APIC_VECTOR_TO_REG_OFFSET macros which got defined in patch 01/32. Prior to patch
06/32, these macros were defined in kvm-internal header arch/x86/kvm/lapic.h. Using
VEC_POS, REG_POS kvm-internal macros in x86 common header file (arch/x86/include/asm/apic.h)
in this patch did not look correct to me and as APIC_VECTOR_TO_BIT_NUMBER/APIC_VECTOR_TO_REG_OFFSET
are already defined in arch/x86/include/asm/apic.h, I used them.

Is adding this information in commit log of this patch sufficient or do you have some
other suggestion for doing this?


- Neeraj




