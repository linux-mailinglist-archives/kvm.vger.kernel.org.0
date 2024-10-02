Return-Path: <kvm+bounces-27819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A25FD98E2C3
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 20:44:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A36E1F21727
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 18:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18E2B2141C5;
	Wed,  2 Oct 2024 18:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kJPT6CUD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2058.outbound.protection.outlook.com [40.107.96.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3606F2141B9;
	Wed,  2 Oct 2024 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727894685; cv=fail; b=gi0f0fKM/4EqhYkScBUqfqzeHYull33S/Wiw8vSv93je8HuZMamN7EUIRxCzTZjl0LdiX9op8uPjEiE1Tm5mRRL7j4NQ/YO6e/Q4xqSwpUdiBt9zxwhXDx3RCBVD1YYEiwXjrpizkctuuKgKMpqS6q1jRtcn8fwo79InspmCxOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727894685; c=relaxed/simple;
	bh=N5XeXQNuO8k+AxowErcqXb3Z8KuOD7ufJlmGnYUESc0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QTxn1pyARuV8HBij/dqEkrX2cMCLU+bsvrLqVNyyQzkQM4EMgG8L5O39YCzx0U5vJL1u+rJpmCHTDC9fSRoB8ipgwqUy1nATZMsCw8iIfQKtZsdtrujFg1HJwOaNAw0hjBaioTo/pONzw9JBpeiCfkjVV0r31RvTVtfrWi9bH2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kJPT6CUD; arc=fail smtp.client-ip=40.107.96.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WuJZjdSR0fT+CYu1D9wJFgCPXbD8JOC7URqdV958S4/EOlIPJb6CWF6PF16sf4v2tE8HnQnL6AT0bJYfpjqZOILzhOi2IfY9Qh87poXa8hyBvv+uziO+PuHeizURJGlhItRQeqyYlBORGJJAHbRzjt3Ky78bde2nyyn8CL4twslh8C83yaIOppXZ+1cYaiCLCDVy2PQu3LcSEZI2QcebObwGq7TQwAhCFfLQhd8h4NXK1seE07kLQpl0AIiRpD34MocR4K/uuQS9dt65omU4extj8io9cdDJ3+75Vy1ZdADA4qlaGxVc+ccaeddVy3ngmUtBWVbI7TbYN6GKpgRGnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1GKFABZhIQ7QgPJpOg/JRw24oBn+5uCW30J1p5T6MY=;
 b=bvod/zELnwXNNrNERM5rB57RqQ5sXmgN7553SmbANqYKJFY0HGUWLKc5lo0EMK0CbW3o+Ki6LZo/SzLTfqhgOaxzE7kET92QyFEeTWVsLOHDCJS4Jc5FnGajnHXMwPqRBVkXqFZJ1loEQkXZdnbLqSRJ2xHNPFcBzLZTtUGBmkpj5qfBcJpSQHidE5MQ8qrUOvIBWZ+1w6URhax4HhHV0CBukECLtqncfIFIxzExYlhG3CCclXDUDRJ1/BxgeP5o3ikjaUoPvElc3Xgxl/ZmJF4pMBziG6WQfYc03MaRgr6APf5AkMz0EsKtqQdfinA0t6TVnle9sQsu7A25NSgOcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1GKFABZhIQ7QgPJpOg/JRw24oBn+5uCW30J1p5T6MY=;
 b=kJPT6CUDmsS+obXlsg2B6oLcoQWSOuXkGL1E3b6B6ydwuuzhvAIMWqP2LTw0CRINqK7LKau/Q604SW/Yn7J68gaaTjVnym7pzu2qBV8ZYgMzzHFEtwEEK51/e/IecsKjtJ7HAghCmuk5DE5ae7Kz28ekmQwAmcqjEY3PrPeq5DA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by CH3PR12MB8260.namprd12.prod.outlook.com (2603:10b6:610:12a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Wed, 2 Oct
 2024 18:44:39 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8005.026; Wed, 2 Oct 2024
 18:44:39 +0000
Message-ID: <3319bfba-4918-471e-9ddd-c8d08f03e1c4@amd.com>
Date: Wed, 2 Oct 2024 13:44:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
Content-Language: en-US
To: Peter Gonda <pgonda@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 herbert@gondor.apana.org.au, x86@kernel.org, john.allen@amd.com,
 davem@davemloft.net, thomas.lendacky@amd.com, michael.roth@amd.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1726602374.git.ashish.kalra@amd.com>
 <f2b12d3c76b4e40a85da021ee2b7eaeda1dd69f0.1726602374.git.ashish.kalra@amd.com>
 <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAMkAt6o_963tc4fiS4AFaD6Zb3-LzPZiombaetjFp0GWHzTfBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0033.namprd04.prod.outlook.com
 (2603:10b6:806:120::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|CH3PR12MB8260:EE_
X-MS-Office365-Filtering-Correlation-Id: 98a4f5ef-148a-43e7-4c6b-08dce31245a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWJMUXJhQjl1SW9DbnpQTERLMFZBMnFuZUJJczhzek8rcGQ4VDVWQVJsK01V?=
 =?utf-8?B?eGtDellRMlg2ZXpYRHh0aGRFVVJmVGxJQ3hWRkM3aVhjL1cvcFlnQUg2cFl2?=
 =?utf-8?B?cUdadE9QYytqTjg2VklSVjdKVzFEbGkwaTY1ekYvV1ZBYTJOUFZGRE9UWXpI?=
 =?utf-8?B?NzM3Wm0yYkVWa1R2OHRvdDZPc0ZnS2lkc01XUkxGMzFSZGUrTmJXdnJ6R3Zk?=
 =?utf-8?B?SUJYOC81MHVIVGZkV1Q0WlhNQi9TWnBqL2h5ZzdxWEdoUWd0Y3YzY2lMdi80?=
 =?utf-8?B?UUpoQ2FoWUR0YkNHZkNCOU4wOGluTnhNS1pzczhLU052Q1Q2SmF4NS9PaGpq?=
 =?utf-8?B?eEhkM2Z6dlM1TU5INEFVQmt2QzVVbHVOaFd0WVhIV2swRUhiQ1hqTXB1NHBV?=
 =?utf-8?B?VnhIMlZHWFVjSEEwT0dsWmwrOWZYTnAxdkVJWVVQRStxOW5ycnpGNnRpY1cv?=
 =?utf-8?B?QzVFbnZubFJMVWpxbWFyS2NvMmhtclR3N1FqMlRtUG9LZ1I5S1UxcHJ4WVRn?=
 =?utf-8?B?Y09WZ3NxZU16c2I2Y29RN0ZHTE5VNlIzWFVUWG5oakdYZHQ0eGFBWjdKMXJl?=
 =?utf-8?B?RU9Gbm1lcktFQ1ZWSDBKanh5WVZaOExONVNBUGtuV0IrNzRLYnR5RTliRDhL?=
 =?utf-8?B?bUZRK1lLUnF4MnAzeEEzRFJYSk81ZUZJWm1Zbnhqc0Q5SkZpWmlvNklveExP?=
 =?utf-8?B?a01janVjTkc4YXlVMmhaTjgxSGJKNjJNcTVxMllQaXpLY1g4c2JYZWZycEMw?=
 =?utf-8?B?bDh4cFlEeXZFczB5bSswZHp2MWNEWWM4ei81OW1rb2tkVWtybzVqdGNqSUMw?=
 =?utf-8?B?R0FVdkg2WktkTCtGQ1hWb0JJdEh6ZzArcWxGbVlQYVVHSjZubXFzOEptdStV?=
 =?utf-8?B?cFFEQTBFMTRRRm93bklsRElqekZxUml1TjkzNHp6SmpCdlBDR2ZaalVOVTI4?=
 =?utf-8?B?bTVnR2VFdFQ0UC9TTUhFdS9FT0ozcHdBc3EzYS83bmZuYXY4aDVuR1dTMVA0?=
 =?utf-8?B?Wm42WDZzVXhvZmFaYXBCM05qU0p3VUJUdDhVRzBIdlBBN0d2VFpWdVlqTVBU?=
 =?utf-8?B?RVBZeXFJenovSGZmMHJjL3FxTEhleW0xREdYS0VZTUJDV3JqNGpkajFKRFl2?=
 =?utf-8?B?OXlzb093UlR1NHdlekRPM1VRM1FvU2hOT1RzODZ5WkVCYi9qNy9Fa1R1ZE5D?=
 =?utf-8?B?RHR5eGxBZnhmNFRJS3BkSTlvUDhxL1NpWmx2dlpicE1kdDM2ekh6empHM3Z4?=
 =?utf-8?B?N2t1TlBhVEdQNUVwSmhWOWh1Yjl5alhKMmQ1aDBKNHFCOEtWa0FtZk83Q1JB?=
 =?utf-8?B?ZzlTbFEvRy9nYVJsYmE1NWlMcUdkZWltVWZOTXJqUFZTazd1bFI0SWZ6eTFN?=
 =?utf-8?B?TW5ZSEwvN1JUSFJBdnp4eC8rV2NUdSsxb1BOYkV0a1RFSlUvUjhmcjhpYWhw?=
 =?utf-8?B?S1RFc0E4ZGpaaThOY3UwY3crRUgxRnZTdjQ4WnBUWi9kWVlxc0pUMG95ZnFu?=
 =?utf-8?B?TkJ1azJBSTlTN0RRNVJLTE5ZQjhteFlMd2EwOHlxSTczOWRndFF4eVNRZXM0?=
 =?utf-8?B?TlQ4NVZEM2drOU4vSklaSDBNRGtoMURPTjVkWGVaY1ZGZmJKajZKOWZLaFdC?=
 =?utf-8?B?UURONjV6dTA5bmlIN1B0LzJnclYxSVVWQ2tjckNWTllsc2ZQQkhRWkxFMHNo?=
 =?utf-8?B?OWRVVGpHKzRFQVRncDczYk5WUGtLWFY5enpvWHZWVldFbXh2NThBMlVRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TSsyQWdITFk3dTBZcDNXT0NPS0ZSUkppdEY5bS81ZVduend0WGg5SWsrcjlM?=
 =?utf-8?B?R3RaUmlyNzdMZXEvZlUyNlZaeFhabGFVU0RwUkpXMnVwejl2bWl4Vzd5V0hw?=
 =?utf-8?B?b3NTRDgwSklLNGZqMldMMFdYbTI2bkZHVmR1a0ljeU1VMFY2TS9RT2tQTm45?=
 =?utf-8?B?UlVlNDJmT2R6OVpDTW8wWUtYajBmSDdFQmhYSi9CVW5PeEJhNHBGa1ErYU8y?=
 =?utf-8?B?YjBsVXJpUHYvWXNrbE9ZSTA3WW9CclhzNUsvVjRZVmZsaElkT04yOTZnays5?=
 =?utf-8?B?N09GbmpUVGdQSnBjRGRvems1djFudWI0ZUdrYXRqOGNRZlJMeklQSm9mVklD?=
 =?utf-8?B?a005cGhuUWNOT0MxYjFpQ0ZmVEZEY1J0dEVYSWM5WmxKQjNOMWk4d2hzRFBr?=
 =?utf-8?B?TnQ5SlJSb2pwQ3RMbE1DVTNCaGtsNmdhUGNHejMxUTNSeGhYVk5hOXJaaWVD?=
 =?utf-8?B?SmJxeXozRktRYWJheGFDUXVHZHpMb3ZIUCsva1hQWG1SVld1QnJRVWF2TjVm?=
 =?utf-8?B?enRtT21lMnB3dzVjZDExaEVQdXEyQ3RDaWZLZkxYZXEreldybEZMTWVCenZM?=
 =?utf-8?B?dTlrLy9qUkFnMFFEd1NSYmFTR0hBcnljZ2w2eW5nT3ErcW5yeUtoRG5KN1pG?=
 =?utf-8?B?TVE5ODdQOHlMMWYydHYvQWlSUnF4R2hyZmcybENLSXc3YXpTZWxLQ3lwM1dp?=
 =?utf-8?B?ZUgyQnE3MEZzNUFlNURLQll4N1FMNG5RUHJmUjR2RmhLbVpRUDk5NnF0QVRr?=
 =?utf-8?B?amNuOThLR3Y4QWJKQnkxS2xEZHIzUXRKRngra2loL1lnaVZ4RU1QcDBJcnlK?=
 =?utf-8?B?WVpydS9sWU5hSVJrb0RjeFNFUlBYU2hpSXVsU0JtekxwTCs4bC9WSCtuZkUw?=
 =?utf-8?B?dGhJeTkwUS8zUkZXSjBONDhPQmhxNHk4Ylgwd3pRcWRmSTQ5UyttVWo3ejFn?=
 =?utf-8?B?ZXgrbUpqK3JhU3p6V0VJYzBMclZFNGpvbjFuWjVkWlpXRVdlUjhlSGtUR2NN?=
 =?utf-8?B?c3VGZVFXTnJpb1VkR0IydGFCOUxFeU40UkxZN3BoTXRSZzA4UHN3UkpMYnFH?=
 =?utf-8?B?U1B4R0ZVTlAzUXBDNndXUlB0b083SXRRbE9qWTcyQ2FDUHlRd3pRZmc2Ly9i?=
 =?utf-8?B?djJFaUJBZnZpL2NBYnVmOTRoSWZVamMxTmY5RjdveGZyZWtvYlFPcVg5bEg4?=
 =?utf-8?B?akZoRmNjTHJpRVptOEU5WWk2MHlhbVgwUnFKVnI0eDdCdCtFVkk1amFOVW13?=
 =?utf-8?B?ZGt4eTRKd1BXOEtnYW1mSndtZFcxbnN2WGlZR3BPeDU2dDlKUDU0MXNmbm91?=
 =?utf-8?B?eGNhTGRUQS9YcHNYS0dzaTJBTnRxMlQyRWcvVENlVEdLVGJCcjYyMDZuNllO?=
 =?utf-8?B?Rm56cDJUQUJMYVZyeGw2OW5GSW5obE1rNmpyV2U4NjhHbVlVd0lIdWZ5aEdH?=
 =?utf-8?B?TElDdE4ya1NjeEpaWmtTVmg4VHc3VE5vNGFjRXNscnZacWpaN2Q3Sk1LNU9N?=
 =?utf-8?B?VEFyOEdwRkZxNldIWkdPOC96R2NmSm9qOUhCOUIwam9nVnBaWlNTTmNOUWwr?=
 =?utf-8?B?aFVoWXBBbkJOeFFmSVZFMDh2TGNoUTE3Qkpqa1kzMHorMGJSLzBpQjNlSGZ0?=
 =?utf-8?B?a1Fwb3lGaXlGODFRbXQ2cE8rMDRxdlhQRzJ3K3ZGZXljYTBzalpDNlR6T2ZT?=
 =?utf-8?B?NUFXRTVBdGJuSzZieEFsZ2d5cUlsaFNKZGpYUWx2a2o3ODVnZURZL1VUY016?=
 =?utf-8?B?M0Z6dTFSR3FYelJveENkdkh3eFZjN04zWGM1RzJXUUt3bzFmeGl3MUVJcjFr?=
 =?utf-8?B?cG1Oc1laSyt4SXhHSTJ4eHR5bWhDUEVMOVBOTnZ0bXF4SnMxWHE4aGNzQkdi?=
 =?utf-8?B?bU1JVGFwWUJyRmcyTnZyTFBkUUx2T2NCMVQyWmIrcE9RbzAzc3RUU1FVZGJq?=
 =?utf-8?B?RUlTU0x1RHRBeFhhdG13RTc4aWhNNTJ2TXdOSkM2Rnp5aFB6Y25JQ3BEM2Uy?=
 =?utf-8?B?b2ZCNzFidUlPMi9UOGczTFhxaVFRaUc3dkw3R3pQMzBGRTdHZmNsUWFxZmNI?=
 =?utf-8?B?bmNVanZBTVVCcGlKdGRGRE8wNUlYcXhITE9jay9NenRZNkI2SWVhV1pNeEJO?=
 =?utf-8?Q?22zya42r+0zZ+mqyFshm72i/A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a4f5ef-148a-43e7-4c6b-08dce31245a1
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2024 18:44:39.8247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+pxqDTtD8fABYLdzGVJPsfwOmLhUKJdiLrUHJwmQXQf457vH2fSCMT+CPI3h6xLqeiJVkpwprOG4hu8UfbS5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8260

Hello Peter,

On 10/2/2024 9:58 AM, Peter Gonda wrote:
> On Tue, Sep 17, 2024 at 2:17 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Ciphertext hiding prevents host accesses from reading the ciphertext of
>> SNP guest private memory. Instead of reading ciphertext, the host reads
>> will see constant default values (0xff).
>>
>> Ciphertext hiding separates the ASID space into SNP guest ASIDs and host
>> ASIDs. All SNP active guests must have an ASID less than or equal to
>> MAX_SNP_ASID provided to the SNP_INIT_EX command. All SEV-legacy guests
>> (SEV and SEV-ES) must be greater than MAX_SNP_ASID.
>>
>> This patch-set adds a new module parameter to the CCP driver defined as
>> max_snp_asid which is a user configurable MAX_SNP_ASID to define the
>> system-wide maximum SNP ASID value. If this value is not set, then the
>> ASID space is equally divided between SEV-SNP and SEV-ES guests.
>>
>> Ciphertext hiding needs to be enabled on SNP_INIT_EX and therefore this
>> new module parameter has to added to the CCP driver.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c       | 26 ++++++++++++++----
>>  drivers/crypto/ccp/sev-dev.c | 52 ++++++++++++++++++++++++++++++++++++
>>  include/linux/psp-sev.h      | 12 +++++++--
>>  3 files changed, 83 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 0b851ef937f2..a345b4111ad6 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -171,7 +171,7 @@ static void sev_misc_cg_uncharge(struct kvm_sev_info *sev)
>>         misc_cg_uncharge(type, sev->misc_cg, 1);
>>  }
>>
>> -static int sev_asid_new(struct kvm_sev_info *sev)
>> +static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>>  {
>>         /*
>>          * SEV-enabled guests must use asid from min_sev_asid to max_sev_asid.
>> @@ -199,6 +199,18 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>>
>>         mutex_lock(&sev_bitmap_lock);
>>
>> +       /*
>> +        * When CipherTextHiding is enabled, all SNP guests must have an
>> +        * ASID less than or equal to MAX_SNP_ASID provided on the
>> +        * SNP_INIT_EX command and all the SEV-ES guests must have
>> +        * an ASID greater than MAX_SNP_ASID.
>> +        */
>> +       if (snp_cipher_text_hiding && sev->es_active) {
>> +               if (vm_type == KVM_X86_SNP_VM)
>> +                       max_asid = snp_max_snp_asid;
>> +               else
>> +                       min_asid = snp_max_snp_asid + 1;
>> +       }
>>  again:
>>         asid = find_next_zero_bit(sev_asid_bitmap, max_asid + 1, min_asid);
>>         if (asid > max_asid) {
>> @@ -440,7 +452,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>>         if (vm_type == KVM_X86_SNP_VM)
>>                 sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
>>
>> -       ret = sev_asid_new(sev);
>> +       ret = sev_asid_new(sev, vm_type);
>>         if (ret)
>>                 goto e_no_asid;
>>
>> @@ -3059,14 +3071,18 @@ void __init sev_hardware_setup(void)
>>                                                                        "unusable" :
>>                                                                        "disabled",
>>                         min_sev_asid, max_sev_asid);
>> -       if (boot_cpu_has(X86_FEATURE_SEV_ES))
>> +       if (boot_cpu_has(X86_FEATURE_SEV_ES)) {
>> +               if (snp_max_snp_asid >= (min_sev_asid - 1))
>> +                       sev_es_supported = false;
>>                 pr_info("SEV-ES %s (ASIDs %u - %u)\n",
>>                         sev_es_supported ? "enabled" : "disabled",
>> -                       min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>> +                       min_sev_asid > 1 ? snp_max_snp_asid ? snp_max_snp_asid + 1 : 1 :
>> +                                                             0, min_sev_asid - 1);
>> +       }
>>         if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>>                 pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
>>                         sev_snp_supported ? "enabled" : "disabled",
>> -                       min_sev_asid > 1 ? 1 : 0, min_sev_asid - 1);
>> +                       min_sev_asid > 1 ? 1 : 0, snp_max_snp_asid ? : min_sev_asid - 1);
>>
>>         sev_enabled = sev_supported;
>>         sev_es_enabled = sev_es_supported;
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 564daf748293..77900abb1b46 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -73,11 +73,27 @@ static bool psp_init_on_probe = true;
>>  module_param(psp_init_on_probe, bool, 0444);
>>  MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
>>
>> +static bool cipher_text_hiding = true;
>> +module_param(cipher_text_hiding, bool, 0444);
>> +MODULE_PARM_DESC(cipher_text_hiding, "  if true, the PSP will enable Cipher Text Hiding");
>> +
>> +static int max_snp_asid;
>> +module_param(max_snp_asid, int, 0444);
>> +MODULE_PARM_DESC(max_snp_asid, "  override MAX_SNP_ASID for Cipher Text Hiding");
> My read of the spec is if Ciphertext hiding is not enabled there is no
> additional split in the ASID space. Am I understanding that correctly?
Yes that is correct.
> If so, I don't think we want to enable ciphertext hiding by default
> because it might break whatever management of ASIDs systems already
> have. For instance right now we have to split SEV-ES and SEV ASIDS,
> and SNP guests need SEV-ES ASIDS. This change would half the # of SNP
> enable ASIDs on a system.

My thought here is that we probably want to enable Ciphertext hiding by default as that should fix any security issues and concerns around SNP encryption as .Ciphertext hiding prevents host accesses from reading the ciphertext of SNP guest private memory.

This patch does add a new CCP module parameter, max_snp_asid, which can be used to dedicate all SEV-ES ASIDs to SNP guests.

>
> Also should we move the ASID splitting code to be all in one place?
> Right now KVM handles it in sev_hardware_setup().

Yes, but there is going to be a separate set of patches to move all ASID handling code to CCP module.

This refactoring won't be part of the SNP ciphertext hiding support patches.

Thanks, Ashish

>> +
>>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
>>  MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
>>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
>>  MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
>>
>> +/* Cipher Text Hiding Enabled */
>> +bool snp_cipher_text_hiding;
>> +EXPORT_SYMBOL(snp_cipher_text_hiding);
>> +
>> +/* MAX_SNP_ASID */
>> +unsigned int snp_max_snp_asid;
>> +EXPORT_SYMBOL(snp_max_snp_asid);
>> +
>>  static bool psp_dead;
>>  static int psp_timeout;
>>
>> @@ -1064,6 +1080,38 @@ static void snp_set_hsave_pa(void *arg)
>>         wrmsrl(MSR_VM_HSAVE_PA, 0);
>>  }
>>
>> +static void sev_snp_enable_ciphertext_hiding(struct sev_data_snp_init_ex *data, int *error)
>> +{
>> +       struct psp_device *psp = psp_master;
>> +       struct sev_device *sev;
>> +       unsigned int edx;
>> +
>> +       sev = psp->sev_data;
>> +
>> +       /*
>> +        * Check if CipherTextHiding feature is supported and enabled
>> +        * in the Platform/BIOS.
>> +        */
>> +       if ((sev->feat_info.ecx & SNP_CIPHER_TEXT_HIDING_SUPPORTED) &&
>> +           sev->snp_plat_status.ciphertext_hiding_cap) {
>> +               /* Retrieve SEV CPUID information */
>> +               edx = cpuid_edx(0x8000001f);
>> +               /* Do sanity checks on user-defined MAX_SNP_ASID */
>> +               if (max_snp_asid >= edx) {
>> +                       dev_info(sev->dev, "max_snp_asid module parameter is not valid, limiting to %d\n",
>> +                                edx - 1);
>> +                       max_snp_asid = edx - 1;
>> +               }
>> +               snp_max_snp_asid = max_snp_asid ? : (edx - 1) / 2;
>> +
>> +               snp_cipher_text_hiding = 1;
>> +               data->ciphertext_hiding_en = 1;
>> +               data->max_snp_asid = snp_max_snp_asid;
>> +
>> +               dev_dbg(sev->dev, "SEV-SNP CipherTextHiding feature support enabled\n");
>> +       }
>> +}
>> +
>>  static void snp_get_platform_data(void)
>>  {
>>         struct sev_device *sev = psp_master->sev_data;
>> @@ -1199,6 +1247,10 @@ static int __sev_snp_init_locked(int *error)
>>                 }
>>
>>                 memset(&data, 0, sizeof(data));
>> +
>> +               if (cipher_text_hiding)
>> +                       sev_snp_enable_ciphertext_hiding(&data, error);
>> +
>>                 data.init_rmp = 1;
>>                 data.list_paddr_en = 1;
>>                 data.list_paddr = __psp_pa(snp_range_list);
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 6068a89839e1..2102248bd436 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -27,6 +27,9 @@ enum sev_state {
>>         SEV_STATE_MAX
>>  };
>>
>> +extern bool snp_cipher_text_hiding;
>> +extern unsigned int snp_max_snp_asid;
>> +
>>  /**
>>   * SEV platform and guest management commands
>>   */
>> @@ -746,10 +749,13 @@ struct sev_data_snp_guest_request {
>>  struct sev_data_snp_init_ex {
>>         u32 init_rmp:1;
>>         u32 list_paddr_en:1;
>> -       u32 rsvd:30;
>> +       u32 rapl_dis:1;
>> +       u32 ciphertext_hiding_en:1;
>> +       u32 rsvd:28;
>>         u32 rsvd1;
>>         u64 list_paddr;
>> -       u8  rsvd2[48];
>> +       u16 max_snp_asid;
>> +       u8  rsvd2[46];
>>  } __packed;
>>
>>  /**
>> @@ -841,6 +847,8 @@ struct snp_feature_info {
>>         u32 edx;
>>  } __packed;
>>
>> +#define SNP_CIPHER_TEXT_HIDING_SUPPORTED       BIT(3)
>> +
>>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>
>>  /**
>> --
>> 2.34.1
>>
>>

