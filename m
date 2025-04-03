Return-Path: <kvm+bounces-42572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 554D9A7A217
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 13:45:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 086E93B350A
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 11:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0140824BBFF;
	Thu,  3 Apr 2025 11:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="c1jHekr/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F6C24BD1F;
	Thu,  3 Apr 2025 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743680704; cv=fail; b=eZe8tgDRP8KXP85+WCvk53utRZlvAZiUF28ZUNQmhuK/fMwwWWUw1XTmkivOVs+G7l8JiAniyTcAOZjITp0Ph0GmhVTwBY3xToB/EuzdCv0z3AZ/YdxrPxCoRtoK7AkOU/6rJLjAaxk58m6IVSzaeY6cF3rq/gDFb89tn0isItQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743680704; c=relaxed/simple;
	bh=QVboLh8wAM+CtyL6CEwZuvdZic/E02qDVNYHnmxrFi4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T7SPS2obcaeciZ4f8CKUfhoXQOwFy2FnrKVhYGg1aBNi6/tAse7EphZUsr44e7wz1Rf1F2XGCpGtITHSDyt0ZOcElrlt6s/Oo+dq/Tj8kWtMnqPFcg30TukX6FA4Ww2e4Tp5ULHqFwYmzXV4gN4SEi2KYgde11JDmtuBtu0nyiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=c1jHekr/; arc=fail smtp.client-ip=40.107.92.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ITNvU2IuFUkA4HOSM3uY/r7JIaTZA8XFfalPZBbikDo9DoPzWX24al8+YjFEM0zVuwJP8WSpgpEoTYKJtaYVGTLttkLCpsckScMP6yVKSmUhOyp9OBuvy7J75IEPeUBSMlq6PiffEUq0rXEbA9/hPM6VwJR4AtgtSqQISowYuG2ELG4WXnhUYroSmFKWAHYf/ibOlUTnlJ4aWIf5wOHXSeTHQgEMK9Qg75AiaazcezoUYRLsRXJu9elY7/n65zKJOdeZVNBxBRqsxPNfteQ6mCTM6qIjM38fNfDh2xzwq5ZUG8LsgX5UuslVS3qoHeWJnaCrxNzkgBHk9YNyb4P2og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oia76thca7tqMUlfjDpZWBuqsUvKJP4iMBvgE1zFlag=;
 b=LE7klcWoBzDsQoS6XMubJNZWkwRVLkbQumZTjtBbDAeaUVLMS84LrYcs6tfTdq13BlkUaM4ydl7LODgklE0FHdv0PNpuAHMZe8lHpwniYHkQzoui4ZJaLarDAiq/0EX1BX/HJeUg4zHEHqpVy6c8YjgbI3Q7kCZXFpXUCDOQTCjzEEsiqS/XyZy6+uQ/BhMKlqfNQu+ISENKg0l56EAB7VfSnXEYbJsVzEvwmlhKPLk+n0F0tSXMjBgl0UuLzsybTGz9qnIvDOP/8XFqXWe7Wgw1a5M8Q1kZbR2Igg4NWR0PBgFl5fzfQ8FvgyLBnLfm5LVqr/2eE2CsKMvlUxmzVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oia76thca7tqMUlfjDpZWBuqsUvKJP4iMBvgE1zFlag=;
 b=c1jHekr/tEJNdkMSQi0B6nmo1O/QVKgn/qfyuDpCc+H8rZ+f2RHiWiw9buV0VXDNDrGQq5xcBcuSCAIwvp0E7JKMaCUWrWB+2z82T7DUQEl1uCr7Eu9uQVDW7mNXjdQ8P6NrqhM9vQkAmvm91YHrsaez9UsFmpQ+Z2M6FHg61p0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CH3PR12MB8257.namprd12.prod.outlook.com (2603:10b6:610:121::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Thu, 3 Apr
 2025 11:44:59 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Thu, 3 Apr 2025
 11:44:59 +0000
Message-ID: <8f60f4a6-6356-427e-9c4c-145081f8e14f@amd.com>
Date: Thu, 3 Apr 2025 17:14:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/17] x86/apic: Initialize Secure AVIC APIC backing
 page
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
 <20250401113616.204203-3-Neeraj.Upadhyay@amd.com> <871pu9wk4p.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <871pu9wk4p.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::20) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CH3PR12MB8257:EE_
X-MS-Office365-Filtering-Correlation-Id: a389c2e9-a69e-4feb-5046-08dd72a4f69c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0VLelFEb2JUUWlxUC9nK2xBMVdGRVZSVll0UTFWcUNNamg3MVJKSXVqYndX?=
 =?utf-8?B?RWlmcDBadTM2N3F1Ulh4cnc3VjcyakF6RjZKUHRNQW9OeUtpc1pVYUpWa3FW?=
 =?utf-8?B?UVRNRnkwYWFDaHQ1b0xiT0FaWjNjQVFSQ0ZMY3k4aUJjTzR1N2YybmF5cWhh?=
 =?utf-8?B?V0hNZVpLa0VHZWlEUmo5b0lkZGRGU3poMXRVMWlWa2E2c1NKL09sV1pycncx?=
 =?utf-8?B?Qjk4OGx1bGt2RkVENVM1cG0vaVFkUk9DbFl3U015NkZhOWREMmlpZmxwK0xu?=
 =?utf-8?B?Z2xHM1g1eE5IL1hMUlBIWVExUG5QOFF2YlJoSjh0Y1Fqd0UwaGZKT0ZOZEZT?=
 =?utf-8?B?RWcvK3R2L0FRcWV0VEgrY3BvbjlhRmlqU3Rmd09rd1ZDM242YytjTTFUNzJt?=
 =?utf-8?B?S292MUw5NXlPQTBsVmNBVHFteGJsVWFub3dGay9jOGdoOTd4SDNPSWVMQnow?=
 =?utf-8?B?MXdkdjlYaERjSzdQczFNSHdURTZPWUtPVHo4eHVOZzhCOG50VHlkSG1pT3pS?=
 =?utf-8?B?VUROZ0RCelpJL3AyY2FSUjdDOUV5cmRyeFRjNWZDcXpRdGFLbmMvYWxZeDdY?=
 =?utf-8?B?aS9OMGkvL3dQMVFHTkl6cnJNOWNBcVBNYjBWaStBb3Y2NTBuL3ZiNFA3ckx4?=
 =?utf-8?B?WXdKRnUwUU5NTmRTN3M1VlpuYkFvMWxvYjd2dGNhU0JtejNHTGM3UnJxS1ky?=
 =?utf-8?B?eDZ0VnFNb1ZnbnNHR2RPRjFrYjN3LzF5ZHJ5MXhyQVlOSWNHTHM5Y1RxNThG?=
 =?utf-8?B?RlQrcFljUWVHdVpYUnlOQWRxOHV3anE1QUxiVFdvTE1NZEhwblRJRnZxN0pN?=
 =?utf-8?B?WG9CUlRyQjlIZCtOcHZ2NlNaRVV1b0xEZjFyQktranhoRTB1cld1VitFNytk?=
 =?utf-8?B?ZFR2d3U0WE5qM21MN0RiWGpvM2NlUCtRbUN4Rytob3hRWmc4V0JFNFhiekZi?=
 =?utf-8?B?Uko0cUNmd0lMT3hhM3Q1RmMzZ0JZWHlYR1JGcHYxZ01hM1ZYSnZaSm85OHc3?=
 =?utf-8?B?ZkVLazZGelhUeThlbjNqUi9IQ2EzM0VlR2k1eXppK0FkbjdIWGIvRE85R3hM?=
 =?utf-8?B?MjdFVXF2S1Qrb0loQ0VtWTd2eEJjTXRqUHJkdHArRFRCR0pFMkMrRFhKR3gx?=
 =?utf-8?B?eTVSaWtjTUJWeml1TXhwSXg5U2FmU0w3eFg0OGFFeVpQRmp6TVdoTm1KREtt?=
 =?utf-8?B?TUpVZi95am1DazZRcW5yK1FmUkZFWWtiOTNYOGJhbTF4UkJITlViSzMyWG9V?=
 =?utf-8?B?M2VMeElqUWFBV0NlMDlHbDNZSTF1RUthdU55aHJ5SXQ1MjFWVVcxdElyZ2hN?=
 =?utf-8?B?SUpPeWNRS1cwc1JOWGsrSC9Ea2tLcEZmSW1VY1hKSVpYcWlQMUIrOGFzSEpU?=
 =?utf-8?B?cUFOcENlVU1mSlFwYWthWGZmT3FkY0pVRGs4dlFqRitMNkZZaG9xUkl5UTgy?=
 =?utf-8?B?S2xUUG5hbUlUWjFxVlpNVHEvOWpvMXdEdGk4YTFEcmVKM1BTb1VJQjM4NVJs?=
 =?utf-8?B?eXpqOElBVEc4Q2NERFBOS2lNb1QrQWdHcStyMXJ6ckVKQXUvR1VORDNGZjJR?=
 =?utf-8?B?YXErWTF2dEh0Y2I5Y2xXTDdoaS9uMUx6WCs3ZXVLTHdOYzliUUMwSXdhR3V2?=
 =?utf-8?B?T1BnbTBNUHRiN3ZjNlNUVWhsQzRXUU5tREtoaFNUc2xtMHpLc0djNUlKVU92?=
 =?utf-8?B?S1hXd1lnRmZFZnlsMVhLT2IyRXZuZ0l6TzZkOGJwOTk2SjlQeURsK0F5ampx?=
 =?utf-8?B?MzlLR0U1Qis3T1BpWGVTYWxWRjhCcm1xUHQxQnhOYlZud2tDMzF1K3IzaTI4?=
 =?utf-8?B?VXdVQjNIbTNhS0tjMFVqUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1Y1aGZBNXZuYm5IUWpNQXFRN0tONEFYNkFlRjJrZjU5bVRscmNNQ2lIOWhT?=
 =?utf-8?B?RE92dHhvaE5rcGttYm8rUVVMY0JkcGw2QWhIS1BER0lpZVBPN3FxOHdFdXFl?=
 =?utf-8?B?TjF0cVU2VmxyM2g2TTh6OVR4bnNDcDlsWVFkajNjMHFKSUZRa1FYZDFOci94?=
 =?utf-8?B?QUFBRHZBeEJFZkZWUGY1WHZ5bi9EaUtoYXVJdUo4YXk1cXZJMDNNclMxSTRq?=
 =?utf-8?B?UUszaTdGbGZ3ckd3dGZCUmp1aWtPZlI0UFlTODkxRHFTK0RldWtrMmsyd1Bw?=
 =?utf-8?B?dnhJYTF1bjlBeDhMQVR5eTZKQUc1VGl1empVdlYzcEhmdjVjY1JGU1JuVjly?=
 =?utf-8?B?UHgraHpMQy9pamVpbDNYR3Bpelk0Z2MzSGlxcHo2RGxjUUFrUWE2UVY3eXRt?=
 =?utf-8?B?ekJaenZ1bVUzc0NFSXF0Wk5PTkk4MDdnT3U2cXVQdWo2UEd2YTlPc0ZuTDdl?=
 =?utf-8?B?ZHZFKzVzTU1JZllQMkg2QjRXekRQWjIwRk1DM1lNNWFNdnNwSmV6ZTFIWFZ2?=
 =?utf-8?B?MElpK25IblhCbDNhbUd3clJQdk9LWXZiOTk2QVJPRTZIdWFHTXpnb1cvK3Nh?=
 =?utf-8?B?eU1GbGlUNTFaOHB4d2FSOGdxSXVjTmdWMzJrYUtrVlVXTmp3SnFjZE94dE9C?=
 =?utf-8?B?L25xSG1YK0tMZTlHNXBmb1JkQjFwakRTd3RhTTBmRnhXdGk3L091UVAxQVpH?=
 =?utf-8?B?K2ovZDRhQWZvM2FzVjVubXgwd1NmdzRpS2M1dGR4TmthYTN4Yk5ranFodncw?=
 =?utf-8?B?YVdXWW5XSXhIVERKK2FxWm1sS1J4YTUxUm4vU2Nkc2JFUzNSNGhXaCt2N2Iv?=
 =?utf-8?B?RXFwQXBYMlBTeTl5SlpldVBHTVVKZjdUaFl6aXpJMkRHc1YvM3ozOTZ0OWts?=
 =?utf-8?B?UG1YaWFzUFBqekFGQ1VIeGp6NDJDUHpLa3hrMDI2WUlIZUFoNHIvNEl2SkNs?=
 =?utf-8?B?dmxpRzJ6OUlxZkt4UURLbHMzTEM0TlRCQ0FFTmZVRXV0RGw0MEtBVWNwWWxJ?=
 =?utf-8?B?TzgybWFTUGcxSDR4NitXWmx0eWNVQjZnWURvZktNcm1HblNzNVBybGxPMHlD?=
 =?utf-8?B?a0daR0dYdGdMT0IzM2hhSE9LMFU3YXprUnpBbElNVHFRUTU0cHJYdE9kZ1ly?=
 =?utf-8?B?eUd4UzRycFVtTGFSbWdIVkIzdXh1eFk4Zk81S3U4eUdsREVMNHg1RUMrMHVm?=
 =?utf-8?B?eGtRQjFDamhoRnF3VHdVTTRQN2k3VXRMZXArcGJ3UEd2Y2plWlRXWjZTVVhq?=
 =?utf-8?B?RWtteFlIMFlKWWhHNGpyU3RnM3hZVjFCM0tlb25zc0NBWEN1RzNsNGVOM3k4?=
 =?utf-8?B?eGN1YjE3TUh3dkJwQ1FXTE1Qa3V1cGNSMklzcHF1UDAvTEFzSkpWZktxVEw3?=
 =?utf-8?B?Y0JadnVLTUltRnUvN3RjWWJSU2p6dTV4R2hiaStKMmkwNjg4djlOdW41eWRC?=
 =?utf-8?B?K2NLUEJURkNuQ0VXWHZQV0ZnWU9VdlQyWlZoWEVOaWtoZHZjSHpGeWJHemli?=
 =?utf-8?B?SW9zOHlRRXNzWEVVekNSem1VUk9RYXJsbGZsb0tSV2R1SWRNc3BYYTA0bjRi?=
 =?utf-8?B?WGVRc3ltQUhGN21ic212aWpzMjErSGhsYjFlbXpNK1BiYXJvOGdvVTBFTmo4?=
 =?utf-8?B?TVZ6NXFwRW10YzNOZnRUVHBYaXlReXgvS0F4TDVERFVGelkzdEZvNUoyaGNu?=
 =?utf-8?B?KzV5VkpFcTlNalBSL2ttbENyaE9TM3pNbitrSHdsZXl3ZmZhMmlrc3RXTy8y?=
 =?utf-8?B?ME8xUzBTeWVodkhUZzFZT2gwb3lRdENUaEZsM0hjalJFYmxOdC82cHNpOWtT?=
 =?utf-8?B?SytYZEFUcVZpVTEwR3FuTktKY3YxQ1FWZUV0MWU5TXlaRFlDWU42R0JJdXVm?=
 =?utf-8?B?MmVMOFFjUFY0ZEkyQlVGNFRiditxcUdadDQzVkh3dTU1SUlodW5nZGVRTENF?=
 =?utf-8?B?Rm1VbGtQK0kxZm5oY2NodmR2TWc4S3lVRVVKcHZKYWJkQ1hPRU8vWUR4TTRY?=
 =?utf-8?B?WEY3aTlrR2RKQ29qZGxkRTFDL0gzOVkxUUYwaThWMU5QbmlSaFJoMDBWRm81?=
 =?utf-8?B?NzdEUVlwVmhmdmN3Qkp2T2tVMG9oYWhXUHViZlFIREdsN2JhY0J2T1duMlFX?=
 =?utf-8?Q?wjRzz4aBWt/4sQvqxuciPq7IZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a389c2e9-a69e-4feb-5046-08dd72a4f69c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2025 11:44:59.7682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZNN3EXGOYXsfE9ZPGoYieeXUwU6+fs2x0qct7dSGkKU+RapUfQ1JHnIMuidk0qi9ogS/yYrz1kLpKNWVATsGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8257



On 4/3/2025 5:07 PM, Thomas Gleixner wrote:
> On Tue, Apr 01 2025 at 17:06, Neeraj Upadhyay wrote:
>> +enum es_result savic_register_gpa(u64 gpa)
>> +{
>> +	struct ghcb_state state;
>> +	struct es_em_ctxt ctxt;
>> +	unsigned long flags;
>> +	enum es_result res;
>> +	struct ghcb *ghcb;
>> +
>> +	local_irq_save(flags);
> 
>         guard(irqsave)();
> 

Ok

>> +	ghcb = __sev_get_ghcb(&state);
>> +
>> +	vc_ghcb_invalidate(ghcb);
>> +
>> +	/* Register GPA for the local CPU */
>> +	ghcb_set_rax(ghcb, -1ULL);
>> +	ghcb_set_rbx(ghcb, gpa);
>> +	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SECURE_AVIC,
>> +			SVM_VMGEXIT_SECURE_AVIC_REGISTER_GPA, 0);
> 
> https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#line-breaks
> 

Ok, will align with "ghcb" arg on previous line.


- Neeraj


