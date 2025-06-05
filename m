Return-Path: <kvm+bounces-48587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C8DBDACF7B3
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 256CC189B372
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98D7527BF6F;
	Thu,  5 Jun 2025 19:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pDZ6jaqi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F5E4315A;
	Thu,  5 Jun 2025 19:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749151102; cv=fail; b=PHmNcNME7cCWxcePIQLMBAK9MwKp+Hcj9ZAqX9bgHWGydJPD3Gph+mNQThIdU94UJOVxOHATe/tFMmJ5Yi2REgyCCIMJ6zeSBoCh3WpPK9YfFS8c1ClSetjj/j/pntGD0wwNit+rpoK7bVCBMF5O25c4Ey6H72L/fvvaakBEebg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749151102; c=relaxed/simple;
	bh=efS0GwH58+zgHHEN5WDJ8u7We1bcJnxSU654SRfpt7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KaSOUzbFcExdcRY79mvd9qd8LP5gFwOr4d3eoI+hpwE0miWKXK1OAnDvYcBz4W8fb9Lan5dVOWgGBaql/R6+ODwD+vHwFQMJHBHxfylStG4fmJICdbky+SFQPRSMLIvQEXNMsKixFLc14qzMXlkrJ+Iyg1/lxOVxEhKa2ibintQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pDZ6jaqi; arc=fail smtp.client-ip=40.107.212.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NJqhTrBZNtiJhGbFT0aDRkjrbIuEvZhkVZynJ5VMhzNiwylS+wyqf/SaaBYDR7sAbdhZry13WJucdb3w8UJoRzShUHvIQbOx5Jcl1sIY7BAbljs95mmdz+AGmqIQ/Y28ODUzS/ocDZEmQTvpPLo+wzBt3yb60PQI/ggrYbglrx+J+AERGDCqAIKUziknQLPundx6Ad954GwDYyRq5M8TLQX609Fhw+0taWYLWWaM3Bgku5gmQJ64xdhUsWGgNd9S6g5RQhh+i6+dSyIx4y3B+M+OU4YwgEyIflA4I2WQKdB+rIfpwQOPz8N60lkfZclutyrGmVoNDtSVxBkPj3FAVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DE/Xk70b6RXjZf98/biy1lb2RbkObWRq6QkVa6zl3JQ=;
 b=mpRlkvIqhF44NbqMK0t5nBhq3NK984p6kLYBc/jxCRgT5fBygByHBv21lMD0w6/QXL/EpTXRLmDujlKznRLWouJZe2eIpehl/PFheGNmFBg0yMJwIXwSDjzKx03Lms580kpV71N3uAqHsO6qxr4buCRYyAT0RG5bOF7OcieP07/zxZyEO/8DLzxfSpqAN2/o4hUZ3TBhRSlagS9g9QWHUs/kJh0AyKLTgSU6x8KoJDCLPK5WhvcqRDSXP84JEXHU9dfxXc7onMzVLmCL1NrDnOyX4quQrv4q5tL6NJo+8CrQz7YTHdSWcGBycsb0K9pzzp8rDJz/H/G+Vk3/eXV40w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DE/Xk70b6RXjZf98/biy1lb2RbkObWRq6QkVa6zl3JQ=;
 b=pDZ6jaqiWPO/HL+XPPWM51WXXzH4TF3+0sIHfaD1B/tKGHFSBvFCir5Jj3gm3sOhRtmH/FygRRH5BnJwmXn9DzRkqPHvLOMEawcbOb+mQXbBOxukLqiHTrWmKhM+TQSVKq4a6fPJe1IiIj1AoH6PdjFm6zkGxcXZExy1jFw29sQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH2PR12MB4038.namprd12.prod.outlook.com (2603:10b6:610:7b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Thu, 5 Jun
 2025 19:18:16 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 19:18:16 +0000
Message-ID: <74421510-ac2f-4094-b388-566a5c55b07f@amd.com>
Date: Thu, 5 Jun 2025 14:18:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Alexey Kardashevskiy <aik@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au,
 akpm@linux-foundation.org, paulmck@kernel.org, rostedt@goodmis.org
Cc: x86@kernel.org, thuth@redhat.com, ardb@kernel.org,
 gregkh@linuxfoundation.org, john.allen@amd.com, davem@davemloft.net,
 thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <e663930ca516aadbd71422af66e6939dd77e7b06.1747696092.git.ashish.kalra@amd.com>
 <cc8c6e32-f383-4ae9-8c49-5e61bfb0d86c@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <cc8c6e32-f383-4ae9-8c49-5e61bfb0d86c@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0057.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::6) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH2PR12MB4038:EE_
X-MS-Office365-Filtering-Correlation-Id: fa7cadc9-b08e-478f-c7a6-08dda465b8e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0RZT1JGZ0wycWJmQ1lMM3E4cVV5VkY0VTE2STRXT2ZYOXlRMlJTeUtKZ0Uv?=
 =?utf-8?B?allySEVTcFFPdCsyaFc2VzBtSjRWOXFFTmh2TTdzdDNPMUFwZDd4Yk5rOHFx?=
 =?utf-8?B?YTVNNGFDQ3Q3ai9BSzBRRFJCZi9wZ1BVcWJyejlTTml0MkJnQ0JmSXJ6dDVE?=
 =?utf-8?B?ODRwRHlINDc5K0tsZW4xMUUrQi9yeGYvVVd2eWlUN0pvUGkrUS81QUNuYnJG?=
 =?utf-8?B?V29xZnpxTE1nWG9KRzlhSlFUSytwYk5qWWtMV1ZhdVRLQnZJdjU1Q2dUVHli?=
 =?utf-8?B?RFdIdVB3aEhVUWNWUlVWZ2dObGtTR0VNSmZMZURUUnJSUDlwaytzYmVvMHVZ?=
 =?utf-8?B?NnZVN2VEZTZJSW1Rb2tMTHZnak5VMnZvZHdzUGdEOTAxcUluV1U3V2ZlUGZ1?=
 =?utf-8?B?WVo5c1NzRllnajI3SFlmRGwwMGdrZVJBZEhtT2VON284MENXTW9adTNpQU1H?=
 =?utf-8?B?YVpkSVdQYzRUcHpaQ1djWUovVHBzdlg1L3Z2Q3BLTlpDQzZGcHFvUVJoTHJs?=
 =?utf-8?B?dDJCSzl6N0JaS09QV1BFZFYvdm9xOThubmpUQ0dLdnppbVVSZzZIcVhoSmhG?=
 =?utf-8?B?dXM5S3pCTHVSYzRhbHB5Tjc5Yno2QlFVbDVNSlhnVDVSRUs1b0E2ZVVRa3BS?=
 =?utf-8?B?OTQxYjd4L3JHTkVDYVpLbXJIcGhzUU1aSkl1YTZUT0ZJaTRYVGlJRmNLT01E?=
 =?utf-8?B?OFVzSGwybW5FcVpXRUdnU2pacW1CdUdyOXBIYWNnaUxaQmo3THc1RXd5OWkr?=
 =?utf-8?B?NzdFdjNjUzcvUU9iQzBJbUp0OEt0OWxEREIrWkR2dktJRXZqMSswRm0vWURw?=
 =?utf-8?B?YkliWUk0OHd6dTV4RE0zWEVIWmROVXNUVTR6L1dMR3Z3OW9oYmlWVEQrZ0wv?=
 =?utf-8?B?cWtXMEtzTFBTa0MrNVplWmdCK1EzdmZDWEc5ck4wODlSbW56TWZjQWZtUHNr?=
 =?utf-8?B?WE9uME8wRFBMTFZmMnFodUJJcGhKRUQ1QVlVZkx3TTBDV2I2a3JSR2xlZ21a?=
 =?utf-8?B?VUdnbFhWUGdQejdZeFg3cHB1bUxoUzdnditVVXFNbTd5MmNvS0wxSjN1QjM3?=
 =?utf-8?B?U09wNGUrMnU5Q0dXKzFRY3R1WURRZDRndmNQTjFpN09kTlpYL3d0Sm5BTnpK?=
 =?utf-8?B?THI1bFRCak10QXJSRkhTb3FWMHRIc3lpMUJqOWZkRHNPN1BrVGVETWxGQmcr?=
 =?utf-8?B?dVdMRjBFWXdiQjBZdjAyeTBLQ2ZGUVJpL2V0TUdaY3Q2ZnlpRzJOY1V1b3gv?=
 =?utf-8?B?ekJVU1l5Snhvemt5QzE4VjJSK1Eyek9NTGo2c3hCaWhwL2JnTklGRFdWWGE0?=
 =?utf-8?B?MHRZcXg5Mm1vdHh5cjExT0IrQ2c0VmVtd0Exd1E4VHRkT3h5VWRXZkozblRD?=
 =?utf-8?B?dC9uQ0pMK3VXSFVZc3prZWV0UWdXaXphRUV0MmJIekJMZkxCVXQ3cDcwUzBk?=
 =?utf-8?B?WjNBUDBJbVVwY09La3djL2djWXJTSXlwYjhVN0tGc2lsc0dsV3VtcmhXMzFI?=
 =?utf-8?B?K3lkNmVDNUJCM2hseTVwOFh4aVBaYVNnQVcrQ3JwM0x4K3JjL3gycWR3NWFq?=
 =?utf-8?B?M0IySWduaFFUUGFCdE0yMGJTMXZRQ3JzSDl2UHR3Qi9mYWxVZWdlNVM3K2FJ?=
 =?utf-8?B?bDdCT1crRkdmTWNLcU1xQjRWVWxzZlVNNCtFRTQ1MlJodDF2a21pcVdpdWNQ?=
 =?utf-8?B?ZW1SUTRTQlBFaTBJUk12QzlyWUFvWlcxb2ZUTlQvUzBDNWJuK21LemYyK0tS?=
 =?utf-8?B?andGdURhNUx3TU1jZE5kcTFUQ1l2d0RDMEhhV2kvWmNjMjF6eUJta0xRcHVT?=
 =?utf-8?B?QlVMd2pnNXlSOFl3Sk9Za1BRY3AzTVBENE8ybkNZREpXQU9NZnd2UFFRb2xN?=
 =?utf-8?B?cHEyd3Q5ZVIvVE1sdUZoVUw5VkJKYnJYVDdIZ012NndjemlhdnprTWtBRUxv?=
 =?utf-8?B?L2RjMlNCUXR6bE8waWNRNlFWd2lXQkJCWWduNENOckQvOStTRERZOW14Y1p0?=
 =?utf-8?B?YlZkQkVUS3FBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y2hEdHhJaHRTMWhxV3YydUxPQUtNNHMwV2FNKy9ldGtyYm91b1ZBc2kxbUw5?=
 =?utf-8?B?YW9SMXJSYkhNTS9KNlBQUE9VUkFURUMwL2h2SzlHZThTYnc1eUdQcGU1Z1Zi?=
 =?utf-8?B?OFpFdXdKVExFTHJMYjJSbkdFTmJYUThtRWFEcEhrMzZ2WjZxOTI1SWh5WEQ3?=
 =?utf-8?B?Z1pwMEFrVlc4c0toc2wwTUt3bWlVUjNQa2V3Mk5rajFScXpPaHdBVUpLcnJL?=
 =?utf-8?B?QUVYVVNqUENCRzZHaEdaQ3BmSHhVYXBqM2pwUjRsZ1RyVFR6MSs1eTJVT2ky?=
 =?utf-8?B?VC95UHF0b3o5aFQ2WFlDckdjOWdVblVYUlJ0ZGRlTjRlQ2hqMU9qTWVUYkF1?=
 =?utf-8?B?MGZ0K1BGeGJtdGNYeXAvZmN6L1NBUGpCQk1vU2w3cEViaXRDMzB6WDEwZmRk?=
 =?utf-8?B?QSsrOE9hcUVBOURLblp5SHV3S2hTQlkwc1N3TGdaakV1Wnkzd2NYVXQzNUNO?=
 =?utf-8?B?VW4rUDIySkN1a3VPWUlLMi9TcS82bTh5WHloUGZnUUZLVG1PYmI2T0E3SzFX?=
 =?utf-8?B?S3NTL3RUZDBlQVM4UDBKOHJ0Tk9xM1dETFRWTy9uMFBNKzVoVmVjVGxDTHFF?=
 =?utf-8?B?dENlMnQxV2NzNlJhNE53MFVNNTBHQUU4VFF2SnkyK0F3VlhUWEFtaEhZVURJ?=
 =?utf-8?B?N1c0bnZjRFlaRWNGVVpuanQxc0NLZkFubUU4cXkzZFFYdG5kUTRwaFdNT1ZO?=
 =?utf-8?B?aVROUzc0NlhwRTEraTVaWTJnTDR3RVBSeTNWaDNCd1lnNnVNK0JJbllvaFdp?=
 =?utf-8?B?RWtwVmZ1L3c3bGFUNkFQd291bzllNkZHb2RvakRORnBLVCs1d3V4R3RWaFcw?=
 =?utf-8?B?Q0NtRlZ6ZVBuRitXdGp6ZEx2YUsyUGZCUU4rdHhyY2lLZTZ5ZjQvK0VpN1dj?=
 =?utf-8?B?SGtNcDk3K0N2aEtvZVhWemYrZGorWG8xblR5eDM3VHZNeGQxT2FXdFl3MWJ4?=
 =?utf-8?B?dzV5NkFSaFVMeVU5c3Ria1ZReURSNDhmOXFyOXRPQ2phcHFiUEtSYnVlWXAy?=
 =?utf-8?B?ZmowdkFJcWRKcXlZeUpSMzNlSkFrZGEreHpYdGIvNkRLOHZ3ZDVwcEwxa2ZE?=
 =?utf-8?B?dkRqOUdaQUkwWFdqaG1HL3VaVFJWOVpQUmxxVjlMT096bGQxeHNKNnYvUGF3?=
 =?utf-8?B?RXFSVlQzcDg1WHNJY0paZlFyRGw4QTdJQ2FGK3prS3hLU25VNW80V3kyKzZU?=
 =?utf-8?B?UE9VVi9UNFQ1c0RkbC9PcmpybFdYb1B2MkxSamZoWFRHcG9rWXZDWktxdTBi?=
 =?utf-8?B?TXdQZ0prbEh6MFQrT05yMWI4ODVEdmoxRm5zTEhtSUJxODl5SWNsRWI3VVRE?=
 =?utf-8?B?d3FmTGp1MS9nTEtlQmQ4SFZaUG5NV0xheUd1VEdvVitSUjdBTjRwcGJ4eldK?=
 =?utf-8?B?SXRxcVJ5SVhDSmw3aU8zWGhLSWpoaUZ1MFd3RGhwU3FLSFh2RVdPUUh1QVAw?=
 =?utf-8?B?MDNJMlE5SHhQVktZc3FyRDkyRlBuM1U0T05wZHRxZjFpMHpmRjBEdkpsZ3Jy?=
 =?utf-8?B?VXB2ZnFObXdIMUVVWnh4OEs1K3pZMWFQZnAwcVBBLzRtb2h1Zjl2TVN3dmNW?=
 =?utf-8?B?SWZsSFNGMkZxV2FoSWtVZVVRbUFONXd1SzRkQ1NrL29IYVArMGJwY05EWmcx?=
 =?utf-8?B?eHVseTJVU0JQZWVaVlF1KzNPMnE4UWUwbXlWSEJFYjJtOVhLNHdvcGljOFN2?=
 =?utf-8?B?RVAzVnV4aEovaXZPU1J4aWd0WFNSbTRnbEpiVkVQWlo1NGQxOWxDOThiYVRX?=
 =?utf-8?B?a1NGUkdlUDRRb1M1eGcrcFBCOFdZWlh5Rlh0c0x1REx5emdKQmZncm8xNDlh?=
 =?utf-8?B?QnBHVG9MMzFRdkRyZFhPbjZLT25oL3VLbG0yNCtEMFpDcnpBK1BSTkhXbWdq?=
 =?utf-8?B?Q1ZWTjFieGJyU3IrK0lnK1RCc1dhZG0zSjQzNnFweVJHSlQrWmFOa0J0Q1gy?=
 =?utf-8?B?RVBSdXErK3ZOVXpSMkNLaExEWFBkaTNSWjk0SzAwc3k4S2NXME80NjNTWWk2?=
 =?utf-8?B?SXBMcFQrMU1RTmxMc1E1RkJqYVh1STR1WXZYTy9LWGgwcVZBOVVUeHlGK3Qy?=
 =?utf-8?B?NHNORnRQSVdPS3M4YVlIaWVPanA3VHJQbGdYUm9HRUNTSVl1STRiTFdYcGk2?=
 =?utf-8?Q?NmDpHsHEuKnigz3xbrs2o8ttu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa7cadc9-b08e-478f-c7a6-08dda465b8e3
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 19:18:15.9305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B9qD0vQI2LA4G2mzwuwduK19v9wpxH7YClvRLiXffyxmw+hjhbNSC98cXQFlRHnZ/gKx+hNjtRjUgLlLsf3TSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4038


On 6/5/2025 1:32 AM, Alexey Kardashevskiy wrote:
> On 20/5/25 10:02, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Ciphertext hiding prevents host accesses from reading the ciphertext of
>> SNP guest private memory. Instead of reading ciphertext, the host reads
>> will see constant default values (0xff).
>>
>> The SEV ASID space is basically split into legacy SEV and SEV-ES+.
>> CipherTextHiding further partitions the SEV-ES+ ASID space into SEV-ES
>> and SEV-SNP.
>>
>> Add new module parameter to the KVM module to enable CipherTextHiding
>> support and a user configurable system-wide maximum SNP ASID value. If
>> the module parameter value is -1 then the ASID space is equally
>> divided between SEV-SNP and SEV-ES guests.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>   .../admin-guide/kernel-parameters.txt         | 10 ++++++
>>   arch/x86/kvm/svm/sev.c                        | 31 +++++++++++++++++++
>>   2 files changed, 41 insertions(+)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index 1e5e76bba9da..2cddb2b5c59d 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -2891,6 +2891,16 @@
>>               (enabled). Disable by KVM if hardware lacks support
>>               for NPT.
>>   +    kvm-amd.ciphertext_hiding_nr_asids=
>> +            [KVM,AMD] Enables SEV-SNP CipherTextHiding feature and
>> +            controls show many ASIDs are available for SEV-SNP guests.
>> +            The ASID space is basically split into legacy SEV and
>> +            SEV-ES+. CipherTextHiding feature further splits the
>> +            SEV-ES+ ASID space into SEV-ES and SEV-SNP.
>> +            If the value is -1, then it is used as an auto flag
>> +            and splits the ASID space equally between SEV-ES and
>> +            SEV-SNP ASIDs.
> 
> 
> Why in halves? 0 or max would make sense and I'd think the user wants all SEV-ES+ VMs be hidden by default so I'd name the parameter as no_hiding_nr_asids and make the default value of zero mean "every SEV-ES+ is hidden".
>

Actually 'max' sounds nice, but we still want to name it ciphertext_hiding_asids or something and keep the value relative to it, so probably it can be 
a number or 'max'.

Thanks,
Ashish
 
> Or there is a downside of hiding all VMs?
> 
> 
>> +
>>       kvm-arm.mode=
>>               [KVM,ARM,EARLY] Select one of KVM/arm64's modes of
>>               operation.
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 383db1da8699..68dcb13d98f2 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -59,6 +59,10 @@ static bool sev_es_debug_swap_enabled = true;
>>   module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>>   static u64 sev_supported_vmsa_features;
>>   +static int ciphertext_hiding_nr_asids;
>> +module_param(ciphertext_hiding_nr_asids, int, 0444);
>> +MODULE_PARM_DESC(max_snp_asid, "  Number of ASIDs available for SEV-SNP guests when CipherTextHiding is enabled");
>> +
>>   #define AP_RESET_HOLD_NONE        0
>>   #define AP_RESET_HOLD_NAE_EVENT        1
>>   #define AP_RESET_HOLD_MSR_PROTO        2
>> @@ -200,6 +204,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>>       /*
>>        * The min ASID can end up larger than the max if basic SEV support is
>>        * effectively disabled by disallowing use of ASIDs for SEV guests.
>> +     * Similarly for SEV-ES guests the min ASID can end up larger than the
>> +     * max when CipherTextHiding is enabled, effectively disabling SEV-ES
>> +     * support.
>>        */
>>         if (min_asid > max_asid)
>> @@ -2955,6 +2962,7 @@ void __init sev_hardware_setup(void)
>>   {
>>       unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>>       struct sev_platform_init_args init_args = {0};
>> +    bool snp_cipher_text_hiding = false;
>>       bool sev_snp_supported = false;
>>       bool sev_es_supported = false;
>>       bool sev_supported = false;
>> @@ -3052,6 +3060,27 @@ void __init sev_hardware_setup(void)
>>       if (min_sev_asid == 1)
>>           goto out;
>>   +    /*
>> +     * The ASID space is basically split into legacy SEV and SEV-ES+.
>> +     * CipherTextHiding feature further partitions the SEV-ES+ ASID space
>> +     * into ASIDs for SEV-ES and SEV-SNP guests.
>> +     */
>> +    if (ciphertext_hiding_nr_asids && sev_is_snp_ciphertext_hiding_supported()) {
>> +        /* Do sanity checks on user-defined ciphertext_hiding_nr_asids */
>> +        if (ciphertext_hiding_nr_asids != -1 &&
>> +            ciphertext_hiding_nr_asids >= min_sev_asid) {
>> +            pr_info("ciphertext_hiding_nr_asids module parameter invalid, limiting SEV-SNP ASIDs to %d\n",
>> +                 min_sev_asid);
>> +            ciphertext_hiding_nr_asids = min_sev_asid - 1;
>> +        }
>> +
>> +        min_sev_es_asid = ciphertext_hiding_nr_asids == -1 ? (min_sev_asid - 1) / 2 :
>> +                  ciphertext_hiding_nr_asids + 1;
>> +        max_snp_asid = min_sev_es_asid - 1;
>> +        snp_cipher_text_hiding = true;
>> +        pr_info("SEV-SNP CipherTextHiding feature support enabled\n");
> 
> 
> Can do "init_args.snp_max_snp_asid = max_snp_asid;" here (as max_snp_asid seems to not change between here and next hunk) and drop snp_cipher_text_hiding. Thanks,
> 
>> +    }
>> +
>>       sev_es_asid_count = min_sev_asid - 1;
>>       WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>>       sev_es_supported = true;
>> @@ -3092,6 +3121,8 @@ void __init sev_hardware_setup(void)
>>        * Do both SNP and SEV initialization at KVM module load.
>>        */
>>       init_args.probe = true;
>> +    if (snp_cipher_text_hiding)
>> +        init_args.snp_max_snp_asid = max_snp_asid;
>>       sev_platform_init(&init_args);
>>   }
>>   
> 


