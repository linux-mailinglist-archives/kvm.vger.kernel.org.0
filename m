Return-Path: <kvm+bounces-25362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3949D964891
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 16:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 687D2B29034
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B9751AED54;
	Thu, 29 Aug 2024 14:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bmVG/CKQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2048.outbound.protection.outlook.com [40.107.96.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA541591E8;
	Thu, 29 Aug 2024 14:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724941863; cv=fail; b=A2YYB7frZcLZNZh/9ENalcczyOT4aPXZUEHhEaxqg797mMG69T3BNxH6H9t6IxbXFVzhAsYD/NNRXCW38HbxIvd1InoZFg7jcXRAb2flNdPB8JdpM8WhL4b+ckB1dzuqVqyb3MJ0uJ5li8J63mm5cWQIOQCOuRo3xkotnDNhWfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724941863; c=relaxed/simple;
	bh=plga3/2Q71z8zv7WoWX7qJ4HfuuJwSbO5v/OzoHv7XA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fl5Vj5sSAznMjUhU/2KMy3yqrEoFru3uvDufdCacpSTC9PZTXeiNqSdpV2SmzQXMT5yWLkk6ufqinUBlRXYU41i+iIHLRHgKu7BaSpdYrSH1jBBXfakJafxxt7a2U8j+jc6h85JgIQSPvEzRjLIL3wDg7Egk9HsNHAIoFspWuy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bmVG/CKQ; arc=fail smtp.client-ip=40.107.96.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RtK8XhzZNOvleuS8nY9FjldroPvV0Cq/tbSij3y/S4CsKqowqiTFXjVMTP463xupRNrekvzgn4V6jjkrDb5fTbvvTEyeejSRnf+usBxQ0HjoueocTJEJlo7ogu44xhgi7ABSnO6GYLllpB0PL6hsLBsAfg86xr9SjOtlUpLy2EPPEnoymamjdyaFHgkinKdMbE+GsTK2Sb0WG7Ozt5xxiE6W7O0QrgP8Jo87Yqy4Ax+ivhSMNymGDQq4ZKxdH7CM2+HrCMry6DCPBccfq3mziIcP4xhxZ8LVe6aYUnbootmz5bQX5+L732JK6bn/gx6rcaFcsm8HPQBGObY7M3htIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=plga3/2Q71z8zv7WoWX7qJ4HfuuJwSbO5v/OzoHv7XA=;
 b=bkFnJ2cEBpsxKXuccommZQTP43i116zJ27HEMDVO2MSSXyq72Ok7NZBUsX60lgUaCc+gdERZsPZMt5QR/hr2X3lgKRrJHT8pcWxLrzjwBqyp7F3HJ9sM+M4qYpp5inBsFAW+q5ro8LaaSUBtlFftS6nLJ5z5Ef6/Vbd2zK0NJCiIaOk6X++oh/p8r852+pMjUhjtnPETpE19PAzY5jmwQDQdQ+XdzTwGCQ/DXVA8uJUWiQ2/4tRemMlarunjzYgftrfpCwhMVMCemlG8grRcUdB4pA3YA3KdwcDVmBXUXAmObXM0EADig4QW2up5l0jbHYjIKp7tUlaOD2w5yk4bLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plga3/2Q71z8zv7WoWX7qJ4HfuuJwSbO5v/OzoHv7XA=;
 b=bmVG/CKQj3MEhqJLei/8f/aYOWy9R095Td/W0vMhHsEMEkiPyFIwZnrXRgwAXMetIYLzlamnpSWfrw/sG77I3BQUXxXw6rbhLYYLXE8meV2TenBFj2JVLflHFlYDsk7ZLm09aq/X3G1zHteorqwl6RdT6l/CveI1/2dQ5gfyyAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BL1PR12MB5729.namprd12.prod.outlook.com (2603:10b6:208:384::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Thu, 29 Aug
 2024 14:30:58 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%6]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 14:30:57 +0000
Message-ID: <3f887fb7-e30e-41f4-8ac1-bd245e707ccc@amd.com>
Date: Thu, 29 Aug 2024 09:30:54 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/sev: Fix host kdump support for SNP
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, seanjc@google.com, pbonzini@redhat.com,
 dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
 x86@kernel.org
Cc: hpa@zytor.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, thomas.lendacky@amd.com, michael.roth@amd.com,
 kexec@lists.infradead.org, linux-coco@lists.linux.dev
References: <20240827203804.4989-1-Ashish.Kalra@amd.com>
 <87475131-856C-44DC-A27A-84648294F094@alien8.de>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <87475131-856C-44DC-A27A-84648294F094@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0149.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::26) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BL1PR12MB5729:EE_
X-MS-Office365-Filtering-Correlation-Id: b01225b8-c477-43ed-5717-08dcc837324b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGdvNDBvMERndVV3STI2dHdrQTZFMFVSdDY5dEZ0ZURLcCsrTkptLytmWXJt?=
 =?utf-8?B?VnlBUS9aY1hsS1VDakEySEFsNjVQQUYrblY2aGFUUzNmNzgzVklrWDROSWVB?=
 =?utf-8?B?ajJQVVNkdVFrZjFEMU5wN0pXc1VQMS9TWUpSa3VoYTZGK2ptNzRJMjIvanJK?=
 =?utf-8?B?cVJyU2dQOW1qZTRpdEZsbFVGT09rTWJiZzlxYWYzTkEzQnZQTlR0YVozNzVt?=
 =?utf-8?B?YnBnUDBWSjlGRk1ZTVE1S0hOK1dSMGQ5eW04MURBbUxRanlnNkwxQTRVVGtl?=
 =?utf-8?B?REJacDhuY3lWQ2p1N3VxSjBNSUYrY0U5czM3aG03TDdsLzVjWURlRENIaEww?=
 =?utf-8?B?amw0UGFwSXFBWXFXYURDc0xZa3UzWHR5ZnBVdzJWcE1Hd052SmVadmlkQjA1?=
 =?utf-8?B?Tm1HODdHT2lxVnh0T1JWNFp3QjJiczJTOTZMZzBkaFhqRjlJb0x4N0FLekg2?=
 =?utf-8?B?bkFvNkdLOUowYVZNSFNDbG4wdWlQZmZtMVlsVU1iOURhNUpzbTAyL29XRUZq?=
 =?utf-8?B?MUFVdW15cm8zUVZHbmM1THhXNUhyVWt3Wms2SjB3QXcwMmM1bmNKSGRlOWZ3?=
 =?utf-8?B?b0tlbzhwNXRuUnpyNmdrT2FudTJrUkUxc2pzdEpsMzM3N2lRaDB2dVpxNCtZ?=
 =?utf-8?B?WE5KdGdmcVpjTDdSdi9yT21IdkJLdGRpeGs5NUlUWTJ1ZFFSaEhhQlIrS2Jj?=
 =?utf-8?B?eUUvMUFBU0VCZEd4aEpqRnhZakdxVWhTUjUvSmpNN3J3RmxBaW95WndsTjJx?=
 =?utf-8?B?b1lmVGdFTkdDb093VU4ycmV4cm9CazlXNkw3QndyNDliMVRrdjhxM2xIRXUz?=
 =?utf-8?B?WDh6OSs2TVhCT2VMSnF1T2xCQlpzanhqK3hJajBEU1JWUlVmbmFLR2tlME1N?=
 =?utf-8?B?ZkNmM2V2ZVEyRjZpMTdmdjNGVXFqV0x0NHk2U044azYzK3VqUHFrVEFGQW9E?=
 =?utf-8?B?R1Z4aHdvQnpQQ3F2eTgxTVg0Rml5T1FIUmpkU042a0VYRWlRRUdJd0FZWXZy?=
 =?utf-8?B?dytoTWNJeWhHTi9HN1FnN29NWDluOXZOSlgybUhId1FhSEt1bmlkUzA1VFFM?=
 =?utf-8?B?Slhubk5VRUNjTGtpYi9RZi94dFpIWkF2Y2tHOS8zL1NiMjFPSTNYTGtPZXJl?=
 =?utf-8?B?TWk2bk5Bdk1hT0hpaldYRzRuVHFHOU4zcU9kSS9uTGM5bXJTSWZMRmJRRUsy?=
 =?utf-8?B?UW9PREw2cUdlNGo2SVRTa1ZLdGNYeGNxK2hjS1R1eWdONEVEMUkwRVkxU2M5?=
 =?utf-8?B?eWdUODNGdXV0d3RmOENtblE2RlR1VHZ1cnhKdXZBMS9la2w5UzQ2SFRETWZJ?=
 =?utf-8?B?QWRLOUE2dHgrdC91UjhnaGMxZzFaTjZwc0tFTEsxZFIwZjhsN0lPNFpHTzZN?=
 =?utf-8?B?cUc3YU80YnQ3UVhDUllVak5TOGpmakw3RXlDVlVuV0Rpa25lZERLOWsxYm5Q?=
 =?utf-8?B?NnEvZmFIVWZPMUpQVmhocjZ2bjMrQkxDTUpmODNVZkVHblFPa0RjQzBQTTVu?=
 =?utf-8?B?cEVOQVdSVHZab1JRU3hXUE5McC9YUG1xS1Jla1UyZksyUjllZmUvYWpHVnls?=
 =?utf-8?B?KzNlRVVTKy9WUlM4My9WZE8zdXhNWDhqTmZ4elpjTUlmM2NVK2NSa3NsUExy?=
 =?utf-8?B?YXBoM3k0ZytKTytPUFFRRTZLRUkzZXh2YU1STUVqY1ppRG14RXE2bzJyV050?=
 =?utf-8?B?bndrTEc2UlVGRWdLUG11dnM4S3BrQTlIWU1Oanc5VnVBT1JZRTlZa0l0U2JG?=
 =?utf-8?B?ZnY3L0YvbVE1VUs1ejQvZS9ub2cyMWYvYUViUGNNOXh6djVWL0RFL2RXNjEw?=
 =?utf-8?B?cTJRaUgxWGQ3OGk4YnBBQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEhDNWx6TzgxSEFON2RMQ2cvNkc5eUFtRnRFdzcrTEVXNEMxWkZTdW83djVI?=
 =?utf-8?B?TkkzUkxHa1Zkdml0THlaSElVdS81VUZTSGQzbUloSFgxV1hrQm8rYmZqWnYz?=
 =?utf-8?B?NnREaHZEUmlUMVhzVGdPdk1BZWEyOXhOcG9hKytobTRQNGlXSEZyKzJFMHJO?=
 =?utf-8?B?bGNuci9YMVNxa0RoWVdQbGRrSE1ja0JKTkZKb1BZdTI3WmJENUUwRWVWbUhn?=
 =?utf-8?B?b1FZSEUwN3R2QU5hcmlYanJQSlhqUWFRWEQvUWRScFFCMkJJcmxqVzU0YjhU?=
 =?utf-8?B?VWNnaTc1WUtNb0lhamVTZUN2aHhzYnZHcU1pMlMxY2V6ZHIvcWV3QnVXSk02?=
 =?utf-8?B?NUpZNWlkZ3FzQkcvTE5DQ0l3c1haRGttMytEVjlKOVhGcm5WSU1BbHA4a2d3?=
 =?utf-8?B?d285R2F2bm5Pem5PZG93OCtBdU9TWHRPQlRPU1Z4QnhLZ1Z5MGwxOTNBYkxF?=
 =?utf-8?B?NzZDTDRhVGo3Ui84ekpzRzNLYXpLZ0JWY1RQRXJ5L0UvT2swd2w5ZmJGMWpY?=
 =?utf-8?B?NlRUTGw5T00zM2R0Y09nY1doZFdSY0c2a1NHZ203eTRwMTNvUFBCN1R2OTRo?=
 =?utf-8?B?WUxjczRJUnQweU9mU1pFcUdFV2FsTjNzYVNrK1lrMDBLU0ZlNzZjNXFvZXkr?=
 =?utf-8?B?UE10Nll3R0J1ZExscUlxNWpucHlNV1QvMFVaSWxsekdKdmdsbThSOUhQTUlX?=
 =?utf-8?B?RTE0MEU2QzlkaDNBU0F3bXdvUENTRm1oS2NGSWI5cENtRFFhNXdMOTErbGZa?=
 =?utf-8?B?akw3MG04bmJKclhHY0YyMWJhMjNwZVArbnBENjhQc1pDc21ubGV0dWMvVlpN?=
 =?utf-8?B?a1NMbE1RS2RsZ2RsaGF1eUpudFlpZ3RXQTFTdTZLcmlKajQ2OXRsdTFzQVhH?=
 =?utf-8?B?QUh3MHgwNFdZQS9ncHpzYXM2dytCLzM1RmhhWC9ieGQreWQxMjdiVk5HWlVv?=
 =?utf-8?B?dzNhaWJ4bXdVK2x0VG5KSVkvQVFTME9QUzNRZURGUy9RQWlzN2dPSFRnVkVO?=
 =?utf-8?B?NFZNRVB6NDNrS1hNSG5DSWRBTXVtOGJ1cGMzNVM1V3RiU2VLdEhIUmRkN2t5?=
 =?utf-8?B?eVFIbG9PZEo0Mk9ReUhocm9vQ1hHK2Z4am1vNU90cEVOSDQxdy9zWXJTeGU5?=
 =?utf-8?B?Nmg5VDBkUlRjSEhTeXRvUzh0L2h2eGV4YWk0dzcxRWNicDNVdk1iRlpDazdP?=
 =?utf-8?B?blFieTFjV3p1aDRsZUIzNjBIVzdLM252T2FNUTdQRlpxUmFmdFFnQytwNHBQ?=
 =?utf-8?B?dForb0dndU0xZklFMS9jQkJPdjdndU5DenRIcUdkY0NoSndjTXBwNG56bWxl?=
 =?utf-8?B?VDNrQVRxUEZFREtma1VjSVFDV1lnayszRXg0TlVOalhkQlNObGNiREdlU1VR?=
 =?utf-8?B?VzlFbGd5WU9uVzlIQnMvbjdkb1dZZmVUaUhwdUxxUHM0TVI4QUJhaEI0QnFX?=
 =?utf-8?B?bkY5YzA3SHd6dXI4TXdvQXhGTzA1YTVJdUhJK0J2S3pPL1dyTDVaclhsdzNw?=
 =?utf-8?B?d0Rqa0pDUkRZcVhVZm5JWnNuY041bjZid1ZmOHFxRHhoSjgzd3hRa2ZFNlhE?=
 =?utf-8?B?c0RrMENZdnFoY1JNN0hQRXVLdnNqcUJlWWZzcnRyNnVCNjJvS2tLT2RpUkNw?=
 =?utf-8?B?bGI4NkhQMjl0MkxDbGl5T095b3BHcTNjQ1JuVjhrQjZWMnJpc041Ym9ud0p3?=
 =?utf-8?B?OXRPQXc2QjBhaGJlVjk5bnUyVm12dFpBWDRlQ3VOUVhRNXdOU29MaUNWYm4r?=
 =?utf-8?B?UGN1K0l0K1BmYlNCNWpvQ0h3REJPV0M2RFBaYnlJVko1ZnhtdlU1U2E0SGtq?=
 =?utf-8?B?SHlUMHhhQWUzY0R1S0wzVFJGSnAzTlVRVWcvczJTYjBvYUdJYXUxdHZIZDdB?=
 =?utf-8?B?ZUNlajZTaXVWeXNIY3BmaVZtOGpqaWdJSmthRjFIMmtHdnRuNlg2bkFLSDBz?=
 =?utf-8?B?MkljcURvSlJGOUhLMlAvdkNVYkh1cWJDRlpCMUVHUHlYek1rUzZERlFJLzNO?=
 =?utf-8?B?OFQ4dTNPemZTbGxqV0M3TXZ6b3FyZzdWdmJJempMKzVJWHRGOUhWdU43dCtu?=
 =?utf-8?B?c25CS0twb2tOdmEzODluWVpSUGJ4TzJZcmpvM2dsZEd5M0FNNXhlT25UTjFu?=
 =?utf-8?Q?S81ygBXTGCYCkPh2WN54/mNPj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b01225b8-c477-43ed-5717-08dcc837324b
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 14:30:57.4082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Myx5cD4Bj1FwlpyZ531FPzwPhkpun41jmuqy67WJTHY5MWgNdH1OcKvFMjRuhxWn5hpjXAm1z9TNOBRxiXxb8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5729

Hello Boris,

On 8/29/2024 3:34 AM, Borislav Petkov wrote:
> On August 27, 2024 10:38:04 PM GMT+02:00, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> With active SNP VMs, SNP_SHUTDOWN_EX invoked during panic notifiers causes
>> crashkernel boot failure with the following signature:
> Why would SNP_SHUTDOWN be allowed *at all* if there are active SNP guests and there's potential to lose guest data in the process?!

If SNP_SHUTDOWN is not done, then crashkernel panics during boot as the crashdump attached to the fix/patch here shows, so essentially if SNP_DECOMMISSION followed by SNP_SHUTDOWN is not done then we can't boot crashkernel in case of any active SNP guests (which i will believe is an important requirement for cloud providers).

Additionally, in case of SNP_DECOMMISSION, the firmware marks the ASID of the guest as not runnable and then transitions the SNP guest context page into a Firmware page (so that is one RMP table change) and for SNP_SHUTDOWN_EX, the firmware transitions all pages associated with the IOMMU to the Reclaim state (which then the HV marks as hypervisor pages), these IOMMU pages are the event log, PPR log, and completion wait buffers of the IOMMU.

Aside from the IOMMU pages mentioned above, the firmware will not automatically reclaim or modify any other pages in the RMP table and also does not reset the RMP table.

So essentially all host memory (and guest data) will still be available and saved by crashkernel.

Thanks, Ashish


