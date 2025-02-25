Return-Path: <kvm+bounces-39117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44497A4424F
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 15:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0F5517BC24
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 14:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE50A26B08B;
	Tue, 25 Feb 2025 14:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Cf0zuFZQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2052.outbound.protection.outlook.com [40.107.100.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E3C26AA9E;
	Tue, 25 Feb 2025 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740492776; cv=fail; b=E9dOvZPEPz74ARm2tAFdeFeScwG+J0auqYy+C+VcXZc+C2Rd0UwimQydSCiMMGx1hADzd+fYjcYXCPD2/K9xsJCM/bUtfcyEIK3nSoq+1LIdhkLLsw+lI1CbWWOMxTu9rPIOibhZ4cjzhyAoIjsWOC9Nx8pad/a+OwagE79BjBc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740492776; c=relaxed/simple;
	bh=WjxqJBGE/9ryDNUdQ9GlcBaRxJyp4GtTl+0WVVHgPzI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jouJcJvliyqq/woApM40MECQWBYo53KcUanKlfXxYUp05U/+qNTHBX+hzVQLU5ton3NUKEBZSgfXVWb2TLF6gVU0g3C7ZrPkvKWOmVFwu8yBgISUWxkPx+zsKhC+EjvmSrTr6ASGxcq7q8mHC9yW01ifWigdoYjvIyIIVknoaP0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Cf0zuFZQ; arc=fail smtp.client-ip=40.107.100.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ILAwEYNc8J2Z/5fzkxqnuvqCxwiRSBbCFpYnBkAExq+Yjq2nrZSLLzPFBr7ihl1qOWr5sIg4SiooKix0a679Zh+HRhxYYXNam+6rH5B/Hn7kHaCGIIvhLlv9NUzChi+CjC4yVzMK/XwM5EncdDzPDPoZswcnoQEcMU5sxCSPfW/7vkXRI53mHAzMhXzi2De6UCz5teGDXrdCpM+648s5NM830GPjJEMetuCcYAUX8Cjh5GwbYrZuXTHIY7w/OJ0qAY8YFu8jyqxC9WGgKXj3Hv74g+0pT9gzKlhHsGyN0nCe1W+t97pSVXg623N7S37exxeXmKLSu3a0TNXq9XIPtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZysLyQLD1MOSvb313q8kzFKOhRb/cfAnOEU5Q25WJJQ=;
 b=AdoXxzD0EbWfRUaSg9d2DB/yD2fGXafj6rmoe04vqgPo6wgN7+EY8xrPX1C2N2qXvIXzYhKDXmoTOMgaEM2r7vUzaOPPb+tleqGjP4WpnrthwQdnY1G17kUrCPE+mB80cEiizHEsbe/h3yYlwyYHzjQ3n7qd932/89M3iF8eVYYg1yjE3H+UJJaF5BdB8dy5DOqpo9z2EsTNkTNPBaw9Nh1vmaxManO/X+MDS5AYY3LaUMS0e1WDiej0mmClydYfuin4neua33gTZDSpMalSEjtP2QmsC1PgFD1KS84V+VWpQWYyZTNsFJwrk/ZYqsXlVB6FSkzT/8OXf/bddzvqhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZysLyQLD1MOSvb313q8kzFKOhRb/cfAnOEU5Q25WJJQ=;
 b=Cf0zuFZQ3ISE+xPMwF5K83mxK3mWLaIAMLR7ZIQSeWn1g7+QsxZygYL8GFj5IJhLo3jAT5JGefiRQsG28vAleOgGCLe453UtGpiKJc97rO2Afsralcys9QbjlnYpVFqZrwJik6X0++Ja5Wt/8BVod1TDQX/hrol1S0jz6Q3zrW0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SN7PR12MB7449.namprd12.prod.outlook.com (2603:10b6:806:299::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Tue, 25 Feb
 2025 14:12:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Tue, 25 Feb 2025
 14:12:50 +0000
Message-ID: <b958d363-962a-7927-a83a-8b80358f890a@amd.com>
Date: Tue, 25 Feb 2025 08:12:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 01/10] KVM: SVM: Save host DR masks but NOT DRs on CPUs
 with DebugSwap
Content-Language: en-US
To: Kim Phillips <kim.phillips@amd.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-2-seanjc@google.com>
 <3a1b6e1c-5a74-4c9d-81d2-7f9a34f58042@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <3a1b6e1c-5a74-4c9d-81d2-7f9a34f58042@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::17) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SN7PR12MB7449:EE_
X-MS-Office365-Filtering-Correlation-Id: 1313522b-83be-4206-4f86-08dd55a67ca9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UjFvQ2F4VFNzUUYzWTArREQwQVJZRDdNbEplaGxNOWpiRno5K21SMWc2N2hU?=
 =?utf-8?B?WlpaVjcrQWZFYVhuSXRPaUNpd2R1VnJMcnVFZ0xSVVFxaytUVlBUNjJzTVo2?=
 =?utf-8?B?WGhLWXIxZjhQbE5oMWhGZDN2aFlHMFBNVjBCN25oYkMzUTcvSjRYNW9ETkhz?=
 =?utf-8?B?WEJEUzVUdUdBQW12bDBMT0E4RnkxNHk5emlEV2h0NlZZcXVsSHplelI1V2JT?=
 =?utf-8?B?d2R5RDNzWG5teUhBQ0tsVVJDdXlKUDY5UG1WZVNLM3dYTjJhMEEwVmJZMjJ6?=
 =?utf-8?B?bE5sVVB5aVZQUDR6MVhDOThzcS9aZ1YvR05rdzl5R2FaV1plemhJZHJ5TTR1?=
 =?utf-8?B?NHR2QnJvRnNqQkZ0V01OR3ZuNUsxSTJqd3lkMW1raWVEUkw5T1MzaEhoUlNS?=
 =?utf-8?B?emZza0l2NmRoMHhlWUFMbnEzZ1h4L1JaOXAzZUhiTmNqMWdLQ2tPUWNvYm5k?=
 =?utf-8?B?ZDRkZXc0bktXdEh5LzkvSXJtSERkOGpicEx6emZBMENGOW1PREE4dUtQM01Q?=
 =?utf-8?B?YUNTVFYvUUh2ZDc4ckZ4QXNiSkw3WndKRXNJd0NTVXdCYUwzRSsrVXBmNGtG?=
 =?utf-8?B?SWxWYjlmNG1QRWZJWkRKSHNUUStRUy9yZTlLVXo3OTBaaGg0WVZ4ejNtWnpD?=
 =?utf-8?B?SXp3R2c5OG1NbFNVYUwxcmZKNmJmZmpWSU1YdHdrZHFOUDVtVVp2L1JRZlJP?=
 =?utf-8?B?aGdOVFgrNmRvVkxvREo3c0drRG5LTVFxVWxQV1BsVGxaRzM4SXdTd3ppVGsz?=
 =?utf-8?B?bVFMams2dVJrU3ovSTZUbXpoN0g5VFBraGd2S0l3MFpXcjZjOGhPSlc4Z3U2?=
 =?utf-8?B?WnVubGVBOWt2Szh2cnpQMGxBUFVzbE93ODVuQUtnS3ZZSkJsNEM4ZVlWc1Vr?=
 =?utf-8?B?SU1weVFHcG8zMzRmOEZtcTF5MGJRclM5UHRUUXJsSWFhc2U4QzdrSEpBK29U?=
 =?utf-8?B?NDFGaFhWbWU4SlVCOUdTN25yQTNMbUZQdmtRS1RUNDZRbmVSOThXUnV1S01P?=
 =?utf-8?B?MTRPL2VJUFpZeGh0Q2pPanFtMDBpR2N0MGU3ZUlSWVNqNWc0bE5ZZ2ZHZkNa?=
 =?utf-8?B?SkpSMDZmanh2eUs5MUlDaGhiNmhYOSs1ZFRIODA4cVhTNjRxbDZQWFR6Z0g1?=
 =?utf-8?B?RXM3SkdBUWZRL1VjblpaeWZJUG10WVA4amhpWmNIK3pxeW9RcE93SWRCdlp4?=
 =?utf-8?B?T2VXa01kQXoxTlJQMjhMNW1jamR1SWk1N0hhUzRodEhTc1Z2TWpwZHJIU3VX?=
 =?utf-8?B?YmU2T2g2YVg1dGpWVnhXaTg1eFpkeEZBcUJtbi9qTHhFUWl1SXZkZHRJRFVt?=
 =?utf-8?B?VDQ5Zk9FMjM1OFZIN2kwVGc3V0pGSUdjbE1INllpM0VmcCtaSXdEUG1NSkNC?=
 =?utf-8?B?NWx6UnVQT0ZteDQ0VGpIdE1VMm9yWFhOTGpRajZjdnM3L1JQV2FkR1JUMlJh?=
 =?utf-8?B?SWZNVXhrR05SamRRcGQ4NmlNU2pwOHgwejBXd1A3MUlRNk9oYy9VbVZtcUNr?=
 =?utf-8?B?cDR2bCtUaG1PNGpIYWttb2xxTXVKUm1oclB1dXQzcldraVk5THRsU1k4ZExH?=
 =?utf-8?B?akJ6TU4wR3U1ZVBKS0p6SlBVek9UTmpxQ2pDUVJlcEtqSWRCMzFXemt3R2hN?=
 =?utf-8?B?NXZMUzIyT2NKbzVZbEZ3NnhXeDJXYS92dkpCU2RLQ2JTS1dIUzA2c2RSTkVB?=
 =?utf-8?B?S0xNS2RVdndPUEd3UzJXdTBVa3IwM3NSam5IWnU1N1RUN2x2WUpFWGEzU1NM?=
 =?utf-8?B?amJ0VlJxVHFUaUxoU2Jrb2NraHk1TXhycWIwSW83VzVTdm9JT24zN1p5MkxB?=
 =?utf-8?B?N2E3cnBkK28rM3hVWEZwQ0Y3dVBPN1c5YW5Eb2w4SlVwajdDbDZyb3B6bXB3?=
 =?utf-8?Q?w/zHFEYAG5KAD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1BJcWEzeFkxdDZuc3hocXhUbml4dE1YeGtQNmJQMmhRQS9RQkx0bkRIWEhH?=
 =?utf-8?B?WWZMWGw0T1ZDSGo0RVZqL2JRU3dGN2loOFlBYTM3OVdsVDZ0TUEvL054a3lW?=
 =?utf-8?B?b21USE9wcUl4emtOajN1TmtRM0dDNGg3alhvckQxRmdmbjBxTTZ3eWhqV1Rq?=
 =?utf-8?B?WUE0REkwS3RoVzYzL2E2bml1dFFtTkhGSWRIWFdHVnFIejFIb0ZkRnpsZU1P?=
 =?utf-8?B?NmhESjFyeHQ1bTlQeEdCZmF1SElOdytYVWFmVjdBbmpMTXNJdFJON20vOEJM?=
 =?utf-8?B?RThkZEZMckFUdXJKbkMrV2xmelBQNWhYeDNQcmVucFpUdWRSZHRFZTFTY2lk?=
 =?utf-8?B?emlRWm4wM2dLM3ZJRkZLZ1JUS2JUdFp6ZFAyS1Z4OTBLcDYwY0hsM3Y4Kzdz?=
 =?utf-8?B?STY1OHNPRXpoUWM3TnpkcUxjM2lWV3oydEQxcGh6VG9MdDRLQnBzT0FLbjJG?=
 =?utf-8?B?SE1pTk1GZ2dpUG1UanpwZElhMTk3OHFXdnViU1k4MmJFSkFySXZ6Zlo0bzg4?=
 =?utf-8?B?UGlpL3ZDQnhvUStMTGloWFRaa0NsazdPVExNeFZsV1ZmdWVQR0NkVmpnR2Ni?=
 =?utf-8?B?NmliT0p2MDQyTEd1NHVBeVh4VjdBNWJCSHhPcEhYS043RDhKUjFubThUYXVF?=
 =?utf-8?B?NXVwTDkzc0kxK3NYTTc1Q2dNNitmQVhDcnUzbjR6aE1mUlkxclNKdFlMb0Rn?=
 =?utf-8?B?ODFjVUpQMndaT1JnR0hTKzZiY0JzSmhoK0FlRnFmU09seTBBbEIvSzV5N1ha?=
 =?utf-8?B?aWZJM09MQmpub2ptai8vS1JsdEFKTUoyd2pPTHJZdDh6dVhWMzlOaVNoSWpN?=
 =?utf-8?B?Qm4yaFF0QkRpNkRnSFNLM1I0MWs2Rzd4MXhEajBSMGlnZnlqTXNsWkpFaWpQ?=
 =?utf-8?B?VlZ2N2wwM2ZXeFFwVk50cERYUGJRQ21qNHgwL1plRUVLOEJSTEdTOFRhaGZD?=
 =?utf-8?B?NTB3Wm1SRlRZWUNDUWVmaEkxTmRwU3VYYWxwZUlRa0J5Z2JLTE9ZODZqRmwz?=
 =?utf-8?B?VTBmS1RUWmdiUFAvOU04all0UWRBVHlxdjdmZ2kweG4wNzZnMXc0VTdXRUVp?=
 =?utf-8?B?SWhnbmNCbGduL2JsN1ZMWUpwMis4ZGdWZThCUHNvYzVCdzBlS3ZRK3NUdUht?=
 =?utf-8?B?N1Z6V0xjNkpmMm44QTdLcFpNUmxpdVpNMHpHVGRocDBnRnY1VG5QeVU1cnE4?=
 =?utf-8?B?dHBEQnJuV1o0ZlZGclZxb0lLYnYxdHRLRFVWbUlweGk0ZmpFZm1Ha29EOUNE?=
 =?utf-8?B?MHlQaTVrVXdFK1IvOUtEb1drOFBKZXdpdWdqMmhmVkZPT1ZLUzRIeWt1Yk13?=
 =?utf-8?B?V1JkSHJ4Z21wTEdmL3g4cmxZbDZ4M1FDMktUYURIVyttaHV0Nk00bnFpbEJW?=
 =?utf-8?B?WVJpNUdXNUtRS3lua1FzZXYwd1ZjL0FUYmtPM2N3cm13R2R6RmF2WTNGaXNs?=
 =?utf-8?B?bUJwVVNnRHoxNmQzeWlIdU1sMDdGd2F5RmpPNVJLellFeE9ZbWp5d3l6MGJ3?=
 =?utf-8?B?TzE2ejNoVzRxZEVGVlpTQjF1cmdsdS82ZWJIU2xlYllRcnE1L2dCRkZNNy9h?=
 =?utf-8?B?Y01zMXdSejhqRmk4RlQwNGFCL0tqdExEVDRUVFAvbHlORENmQmgwaGM2UmtO?=
 =?utf-8?B?aHIzYzE1U1AwNEZRcGJjYUY1cllqdS9pK0hKbjZwQ0g0SVlnWWMxQWxLZGlH?=
 =?utf-8?B?dVo1S092dDdlZER5cVZiYU14QTB3MkZUeDNid0lIeERuaEFPNnc1T1EzbEpq?=
 =?utf-8?B?UEFOV0dnL0Y1bytETnorV29tNE4vUk1xa3Vvakg5Mi8vVEJQakdoTTI5akUz?=
 =?utf-8?B?QUtPeGRsaVJEb241RHhIWU10bEdwV00wVWtCbkg5U3ROL2xrUko0dGpES3Jt?=
 =?utf-8?B?cFZGa1hhQlM2dDZqSmVTeVVjY3BsV2xPUlF5dDRacDNjYnhSR1BtdU44M1dV?=
 =?utf-8?B?bWQ1MnJlT3NDR1pxZTYvTVBBZnJqTTk0UVQ0YUhhUnhWRmF2S2h6MFlUYkt5?=
 =?utf-8?B?bWZDQ05DUTBPYUdkQkxwakRoZW5GTzIyYzMwZk5rYTFzQk0rUFJiRVpUTEQ1?=
 =?utf-8?B?Qlk1aDYrT0kvZUFXT2NJd3QwakRDYkVKczhVWk5MUWh2bWluY1RzRzdhcmlG?=
 =?utf-8?Q?hJqHDGOANMJ4RtBk+UW4CGLfX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1313522b-83be-4206-4f86-08dd55a67ca9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 14:12:50.3041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t+3UOFPKMiVS5DrPt0RGQxdbBzIqdqzHQ1woWFRpvv/TgFVnB6j1KmO+yMuV2DapdRTLMtix5zsuVAKHr5GRqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7449

On 2/24/25 20:22, Kim Phillips wrote:
> On 2/18/25 7:26 PM, Sean Christopherson wrote:
>> When running SEV-SNP guests on a CPU that supports DebugSwap, always save
>> the host's DR0..DR3 mask MSR values irrespective of whether or not
>> DebugSwap is enabled, to ensure the host values aren't clobbered by the
>> CPU.
>>
>> SVM_VMGEXIT_AP_CREATE is deeply flawed in that it allows the *guest* to
>> create a VMSA with guest-controlled SEV_FEATURES.  A well behaved guest
>> can inform the hypervisor, i.e. KVM, of its "requested" features, but on
>> CPUs without ALLOWED_SEV_FEATURES support, nothing prevents the guest
>> from
>> lying about which SEV features are being enabled (or not!).
>>
>> If a misbehaving guest enables DebugSwap in a secondary vCPU's VMSA, the
>> CPU will load the DR0..DR3 mask MSRs on #VMEXIT, i.e. will clobber the
>> MSRs with '0' if KVM doesn't save its desired value.
>>
>> Note, DR0..DR3 themselves are "ok", as DR7 is reset on #VMEXIT, and KVM
>> restores all DRs in common x86 code as needed via
>> hw_breakpoint_restore().
>> I.e. there is no risk of host DR0..DR3 being clobbered (when it matters).
>> However, there is a flaw in the opposite direction; because the guest can
>> lie about enabling DebugSwap, i.e. can *disable* DebugSwap without KVM's
>> knowledge, KVM must not rely on the CPU to restore DRs.  Defer fixing
>> that wart, as it's more of a documentation issue than a bug in the code.
>>
>> Note, KVM added support for DebugSwap on commit d1f85fbe836e ("KVM: SEV:
>> Enable data breakpoints in SEV-ES"), but that is not an appropriate
>> Fixes,
>> as the underlying flaw exists in hardware, not in KVM.  I.e. all kernels
>> that support SEV-SNP need to be patched, not just kernels with KVM's full
>> support for DebugSwap (ignoring that DebugSwap support landed first).
>>
>> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
>> Cc: stable@vger.kernel.org
>> Cc: Naveen N Rao <naveen@kernel.org>
>> Cc: Kim Phillips <kim.phillips@amd.com>
>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>> Cc: Alexey Kardashevskiy <aik@amd.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 74525651770a..e3606d072735 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -4568,6 +4568,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>>     void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct
>> sev_es_save_area *hostsa)
>>   {
>> +    struct kvm *kvm = svm->vcpu.kvm;
>> +
>>       /*
>>        * All host state for SEV-ES guests is categorized into three
>> swap types
>>        * based on how it is handled by hardware during a world switch:
>> @@ -4592,9 +4594,14 @@ void sev_es_prepare_switch_to_guest(struct
>> vcpu_svm *svm, struct sev_es_save_are
>>       /*
>>        * If DebugSwap is enabled, debug registers are loaded but NOT
>> saved by
>>        * the CPU (Type-B). If DebugSwap is disabled/unsupported, the
>> CPU both
>> -     * saves and loads debug registers (Type-A).
>> +     * saves and loads debug registers (Type-A).  Sadly, on CPUs without
>> +     * ALLOWED_SEV_FEATURES, KVM can't prevent SNP guests from enabling
>> +     * DebugSwap on secondary vCPUs without KVM's knowledge via "AP
>> Create",
>> +     * and so KVM must save DRs if DebugSwap is supported to prevent DRs
>> +     * from being clobbered by a misbehaving guest.
>>        */
>> -    if (sev_vcpu_has_debug_swap(svm)) {
>> +    if (sev_vcpu_has_debug_swap(svm) ||
>> +        (sev_snp_guest(kvm) &&
>> cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP))) {
> 
> Both ALLOWED_SEV_FEATURES and DEBUG_SWAP are also SEV-ES (not only SNP)
> features, so s/sev_snp_guest/sev_es_guest/?

Only SNP can supply a VMSA that may have a different SEV_FEATURES. For
SEV-ES, SEV_FEATURES will have been set by KVM and only KVM.

Thanks,
Tom

> 
> Thanks,
> 
> Kim

