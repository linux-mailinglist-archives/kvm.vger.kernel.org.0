Return-Path: <kvm+bounces-31851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 051CF9C8D37
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 15:51:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7EF0B2FEF1
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 14:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF8A127E18;
	Thu, 14 Nov 2024 14:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LInbU1YC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9487DA8C;
	Thu, 14 Nov 2024 14:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731595371; cv=fail; b=OKxQfqj0oJf2IGkcCChGeVb9m2p3DWOKo2rEMjHbblfjrf3diEV2iaVGRvI+zDyp4BPFEddWjLiM7BqK7Mo5OATPdDS0hLXfUaQco4k5hGymufu18i5V1bpqwlD+zG0H+vLOJne1QmhVXYGGhm6qUHzJt8VxLbjDieCIgOfTreY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731595371; c=relaxed/simple;
	bh=Jn0PnGjri8mI4r7y0nfJAH6AHaDvJeFjh2611JYn8xY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t6tLR9u7A/w51IQNW7h8fI4J6y9ZQRV/9YbBosPKgTwvPSgtaJoVbnSXKejX7O1XnaCgWZx7Kx8EGa1b70K5OQYeJAEyfjifOM8dRyuglztfI9OP9trYE/B5aJvVC6J+qj06fuitOVGLChSJnF+Pfv2MdTDqjackSZcF7xmG0Po=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LInbU1YC; arc=fail smtp.client-ip=40.107.243.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q8SNufW/RfGw+llL+N9BjXc67RNBbi6w8W/LZrIYATBFIDBKJTxwNz7ULREnSgC6nSP9ay2lFwGHWOo9fpl+XDjSR0ERfQ9qVA71ko7KEAuQTAvvI+9gtHyPyTpeNFAioUX9pmEaBu265mlbT+vleLMnkMMHrh9BOHbkln/MvZOBDpFOlDnRrVcvMWTIafllaWVobKWQVzQDHrGAHbErY5KBdgMbHFW1NfmwUXcgfhD5WULAFLNrcxnyfFuAMS6UsK7mICOdaGJBroak+9687mE5TjtLYCrIDEAZzIVNw7vKmsJ72Jalf9ENhUjE76eg5pYGVlNm9Kn9/7gO47tStw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=66+LzW7guz3jzish49Pux+SEMtFABCg/CeWxvGiKzOg=;
 b=kmt710L/FV8JRMPRMeQF6OxnGg89yAeihP8nltPy+Rswdt9aDuEKQcO5jyeyW91Oj76TBvVGS/TaFKStlupem4FkzmDONNqF+lD0opmxbLU1p8c/Kl1g5XFhysGn+GBZWKJx1hMvJa2j1Oq2NX1kZkd2nSYo4EtvUdKlmM7kR5pmV2YV9XlqC0WKsix9YgnHXpKJdG/rk+UKhkwqAb8fXOS3N/Lg/YkGiDbizCFkqaljt2wOQogCRxP5w3aIR4vZdhKAZyqd7xbBOvVTsiOkZofaImxgemy2l1FHZtKClPSujVNvf7UGMR6Rj3WiB4G4AHnNQKEMDhzkxqlOai5kMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66+LzW7guz3jzish49Pux+SEMtFABCg/CeWxvGiKzOg=;
 b=LInbU1YCcJW4C0XLdND8qAG3TMVQad0Z15mdOros/I4poRpX8jKpRY1cgHlY6ri/FlV40wsARBtlJro541KIa+gfNMrlyP8GsieMDNPkd2yY7RADeKDGrrXsgDDCZwtxdoQu3QPIqwDTqn0Q92S0HfgDZOSXT1sHoiqGMOLQ0qk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN6PR12MB8567.namprd12.prod.outlook.com (2603:10b6:208:478::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 14 Nov
 2024 14:42:43 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8158.017; Thu, 14 Nov 2024
 14:42:43 +0000
Message-ID: <feba9eb6-d034-2a1a-3705-cb14f125adec@amd.com>
Date: Thu, 14 Nov 2024 08:42:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: SVM: Convert plain error code numbers to defines
To: Melody Wang <huibo.wang@amd.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20241113204425.889854-1-huibo.wang@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241113204425.889854-1-huibo.wang@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN6PR12MB8567:EE_
X-MS-Office365-Filtering-Correlation-Id: 2af941c4-768f-4402-69d3-08dd04ba98ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SzdZTFNqRTdwTlVCR21qMkFpREUyeWtPaEhVMi96UFlSRFNuV2s5UFVxUjMx?=
 =?utf-8?B?azhNRnF3Wi80S3liSDU4eDJET1JISXdxTjFNdWg5bFlKMDFRREFuZ1MyK2tS?=
 =?utf-8?B?Q1hKVTZmc0tFWkJSS2E1ejlvenRpZGJJRE9sOVFMakJyU20rTTVraVA2T01W?=
 =?utf-8?B?bVB3YksyRHBHRkNwSGxxU0RPY2FrOVhIcWZZYkh6NDA5N1kxTnNXeURPclRE?=
 =?utf-8?B?MHpTdEQvc09ITDNOQ3kzM1NRYTZNaW5tRGg4dUpiMk04V3V2dlp3ZVJYYTlC?=
 =?utf-8?B?TTg1Z1RYS2VUZ0ErTERTK0JKQzAyT1FZQXp5akxjZzkrZDNGM2ZhaTJxeTdj?=
 =?utf-8?B?NTJMeUFlQ3VWVm9tT0FQTVpvZDJNUWJiNzFHdFU0Wk44cnlKekYzd3gvUWYv?=
 =?utf-8?B?M2VaMFF3eFl5S0ZGUFNuYUlZN055aUxIRFg0UHhhQ0g3REx1aVJMQU5HZ1Bn?=
 =?utf-8?B?Q0FuajBMbGJpU2FTY05sdXRYeW1oQldBOXBIWkZYRGNDSmdscXZTTExqeUVY?=
 =?utf-8?B?MVJjNGxuQkJDL0NRWFFaRi83TXY2enMyWVNGSmQ0M25HaDFYa0ZiQkJtSy9P?=
 =?utf-8?B?UlZVbVNSVWdVdWtNN0NtTjhHR3BmbkNHdWxJT240b3k4RXNIQkw3N1d5SWEv?=
 =?utf-8?B?Njh2Qk9NOTY1Y21iTnR3ZitBbDFmZUdVZXlWdHI4bFMxVi9GT2M5Q1ZvcGw3?=
 =?utf-8?B?RyswSlE0MUdGTkZYaWZHRWViZlY4OW52c09jdUZFUXJyZHpmYWZJRGMzeHEz?=
 =?utf-8?B?emtSeTR1SFQwNVhxOWFQSkZ1V0ZOQXpSZGhjaVpiTHpBRDgxbTZzOEhoZzFs?=
 =?utf-8?B?MjEyRjFjUzZhemxlcE5zSGZWb3JFaGxjamFPb2ZGN21OVmF3YTZLU1pKbCth?=
 =?utf-8?B?QWVpQ2h4Zm9qVlRocDdDQzV0UlVBVjVsVjlQZ1NmakJ4Y0hIejN2aVMzT3Mz?=
 =?utf-8?B?dG5VdFdwYy9GNTRyNnhwanBNMzd4MzZCUEdQMy9OMVQvclk3N1lRc3hFUFdv?=
 =?utf-8?B?VlVmL2pkU3FtZDlGemFYb1JTdlY2ME15NFFlRVZMbHB6ZVlpWXVuSk02Zm41?=
 =?utf-8?B?a0F5YjIybERndWRXRU5ITVpZM29qaUFtSkcreGNNbEU2Ylk0T2hCYU5JOTRm?=
 =?utf-8?B?Y3ZDblFHNVh3SE83U2FWYXFMc3NYVnh5QkVhbUZEcVRadHlnNUo5WlYwMGNF?=
 =?utf-8?B?OFVwczlNaTlxTlJSOWpXVjhGK1NxL1lYYXJYZlk2bmFlbnFmclIyZnBkZVRH?=
 =?utf-8?B?VUtwY3lFM0ZQVFBHSEU2VklHcDlaVU5YNkc4OGpsQnE3cjBYUVhYMXFNcVUw?=
 =?utf-8?B?c2ZzVzc4a0JOVFVsb09kTlFHOEFPV2tBRC9DbzBnRXY2aFg1K1RMK28zNHBh?=
 =?utf-8?B?ZUc2ekZGTWw1c2FXTnNiSzhROXRUVkFTc1VXTTdYeENQWlI1TGZyMkFrM0VW?=
 =?utf-8?B?K1ovaElOZkpDdFhtZzRRNHBiZEdRcUdzZDI5V2VrQ29rbUxlcS92aHh4a1ZL?=
 =?utf-8?B?K3V0QXlmdXF1M3dpR0ZjaUVmMjlEOG11SXhncEFzaWRHZlAyK2JQTmp0cVhN?=
 =?utf-8?B?UkVzc3pzT1FIV3g3RXArZmdKUmJKdTlWS05ITmFWVXV6QWtGZWNFWHZ6ZXJF?=
 =?utf-8?B?bXdOZzRkcXdtdFdlUG4xc3pSRkx1dk40VHNKektsME91aWVCQWhKUFZZUVdH?=
 =?utf-8?B?ekloeGJCTERKSzdORktKelZDc0c5d1EzemZ4WnNKdHBUOENqTjZyd2t4TThj?=
 =?utf-8?Q?EE4kAU2L9xPF77h52azKZD9TcWeUuO+4WirR2cj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ym5uc3JTWmd1b0FRcTFkZkRpOW1wOVRxVmFXcTdEenVOcys1SEc5UVF2Vkpr?=
 =?utf-8?B?Sk5DUXVEYlo2QVdNSGd3SldiazZtWitFbTU4aS9NUUhYL1RKWTZPUndNMWs4?=
 =?utf-8?B?dTlPTGp1L3NoSllveDRUMlVsQlRUTVJGbjkza2lTSTAzeXJCcjRBR0x2Z3U5?=
 =?utf-8?B?WjdEbm1rSURwZ3NnT3l4QWtRbkJiSDVXeFpNcUlmcXZDVXl0WDVjd0xjT3dV?=
 =?utf-8?B?M1kzYlFGUDkyUXBHaFFrVzNSNGVPcW5BU0RMQkZNRmNlckJYUWdoL25Kbnpl?=
 =?utf-8?B?dDM1VzJXajg4bE5pTzNsTndtWUtQWkN2Y3JPWDVVM1ZydTRuTWpLb3hoN2VZ?=
 =?utf-8?B?bklWaFBBVHgzVGg1NU1FVTRyQVJEZnNpWjB6VjFYaEo0VDZqU05KeFdaMkk1?=
 =?utf-8?B?MlVRT1Y5MUhUbDg3UzArMmQxSDFockNLTlNsVURhRjRNcmNGVHg5dFExYU91?=
 =?utf-8?B?MUNsMlVTcjIwRzdnOHJVUU9EU1I4a3ExNkI5RHFLYW45M2E1eHJiUHB0ME84?=
 =?utf-8?B?UjZRNG9VN0lhTlRTTTFDTVNiOGw5Sk5iUG9ueHViZnFhbXFPejAzWFp0L0Iv?=
 =?utf-8?B?dzl5Y0FtYW5nVHNGTjAwNXcwM3NCbHlwSW1FT2RNL043Qy9HZmRPTHdOK0lL?=
 =?utf-8?B?OXlUSUVidFhhbFE3ZDhYZ2Vqc0srRVhQU2g3ZlpjS3VhQ09tM2UreXg5eVRN?=
 =?utf-8?B?eXZ0WGtOdTFpK1h1WEhwNzFmWTN6a1FVRFUvTGJTQU9SWU5aamxtajJ6c1BS?=
 =?utf-8?B?QmdacnpHdkU0Mmdsbm1nRmRwM2xXNVpRT1Q5U1MxUlJoVmdYemhMdTlyMjRx?=
 =?utf-8?B?Szh0ZDdDT0ovcUtpUjhHZUhUbmJ4aVVTK0x2a3hYNHE0Y3JBaS9maXk0MXBX?=
 =?utf-8?B?OVFDNzBXYUlINXB3TjdEeDhtaGdzUElXeExxdmFCekQ5L0hVNjYwVFVGNFBi?=
 =?utf-8?B?ZTVobzkrMG4zQk56Z295NklwbCtxaW1uc1c2NExBcjRZTmc1OTFNdTJ6OHpU?=
 =?utf-8?B?aU05OFg4NkpBRFhKVXZrNm1xalQrTy9CMk5PNllrcXEvcFVOemtCTDdjV2ls?=
 =?utf-8?B?ekl0THlOMUxmVkw1ZHN1cy9SRTJpbWZ4U0xZVGQrbEluTEhIVllka0s4bFh4?=
 =?utf-8?B?L0JJaGhuUzVoc2FuMThDOWw5N3lJQzNzNlZsNi95NjZkdjlXKzBDdGV5RmR5?=
 =?utf-8?B?dGNFeklMVHhSOTZLVy9kRTlpbHRjZW9tOWRMMVFiQVROSDRvV2lOZU1GYzNS?=
 =?utf-8?B?ZzdaY2xQRUxpMm84Z1VxbkZXYm1xeFBBamJOcmEzdCt4UXVleGtDeVVGV1oz?=
 =?utf-8?B?c0hnemwwZkRwUUoyWllSUVM0MEExSEowTlE5cStvYndFOGpaVitVc2l4WGFu?=
 =?utf-8?B?QXVaQXZQVGs5Z2dmQ2ZqQ0o0MkF1bjJMQUJad3lGRldOWWJKZndlSzlaVXl0?=
 =?utf-8?B?ZVdEOTNsRTdPOEJOaWpyRC9DQXRnZjlVRWlPeWhOVFBlVTlnckJsTTVwTys2?=
 =?utf-8?B?U3RFWExOaFVVT00yWTRRVklCeldtcUU0cEw0UHJJNFFhU0p1cjZvOFJqRjJv?=
 =?utf-8?B?SnJsU01KekhLdUo2Vi9OQWhaWjNtNXVYSG5tYWdsVGpXREdjNWtHd3Y3bWlt?=
 =?utf-8?B?Sy9hVHRxTHNBbHVBK3hXZ3lGaWlBZ3Y2cnl2SmtLTi9lWlZmVE9idUd6NFpC?=
 =?utf-8?B?cnFXQ0lVWS8wV1dmcTlLT1htN2l0Z21RN3BMRG5rLy9nSnJyaldla0h6SkJW?=
 =?utf-8?B?eEZUL0dtWXFHVG5DSnV3OEJSSGRZdDFlbmtHM0t0NytOMVVPVy94bFRwVkpw?=
 =?utf-8?B?ZzJVSjFXMmxBakxVOHNrZkNzM24rUUFmSnBKYmJVV0taanJScVNBcFU5UUtk?=
 =?utf-8?B?a2wxNjJtVHFDOXo5QVNDUVlvTTV5NnVISCs5czRqVVY2YTNSMEhPbW90QWJV?=
 =?utf-8?B?ZWF5QWVZYmcrVE8xKzJldlpocWlOaUxBWEtSTG9rWU9BdUVSVldiSlpBdGMz?=
 =?utf-8?B?LzNNZzFuK3VWM0hCR3ZnNlQwZVBvZ0dZS3RPUDljcXp6MG40SjRyTFFrQzN1?=
 =?utf-8?B?eE0xYkl2Zjk3TW9LWm9LbmRONndOdVhycmRMSUFVeUpaYkVEZ1Vvdk1NdHJE?=
 =?utf-8?Q?KrwBCiwehPCjzsZGtxpExn0Ev?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2af941c4-768f-4402-69d3-08dd04ba98ec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 14:42:43.3990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fm1Z61a1q9UsuEw8SQHgXrJumM/dStzRVkQmW1VekwZmy+S9bw38aYeFbdbqb/yAAGnlTIXQsJoS5AOMM4jNkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8567

On 11/13/24 14:44, Melody Wang wrote:
> Convert VMGEXIT SW_EXITINFO1 codes from plain numbers to proper defines.
> 
> No functionality changed.
> 
> Signed-off-by: Melody Wang <huibo.wang@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/sev-common.h |  8 ++++++++
>  arch/x86/kvm/svm/sev.c            | 12 ++++++------
>  arch/x86/kvm/svm/svm.c            |  2 +-
>  3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> index 98726c2b04f8..01d4744e880a 100644
> --- a/arch/x86/include/asm/sev-common.h
> +++ b/arch/x86/include/asm/sev-common.h
> @@ -209,6 +209,14 @@ struct snp_psc_desc {
>  
>  #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
>  
> +/*
> + * Error codes of the GHCB SW_EXITINFO1 related to GHCB input that can be
> + * communicated back to the guest
> + */
> +#define GHCB_HV_RESP_SUCCESS		0
> +#define GHCB_HV_RESP_ISSUE_EXCEPTION	1
> +#define GHCB_HV_RESP_MALFORMED_INPUT	2
> +
>  /*
>   * Error codes related to GHCB input that can be communicated back to the guest
>   * by setting the lower 32-bits of the GHCB SW_EXITINFO1 field to 2.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c6c852485900..c78d18ba179c 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3430,7 +3430,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>  		dump_ghcb(svm);
>  	}
>  
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, reason);
>  
>  	/* Resume the guest to "return" the error code. */
> @@ -3574,7 +3574,7 @@ static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
>  	return 0;
>  
>  e_scratch:
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
>  
>  	return 1;
> @@ -4121,7 +4121,7 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
>  	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
>  
>  request_invalid:
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
>  	return 1; /* resume guest */
>  }
> @@ -4314,7 +4314,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  	if (ret)
>  		return ret;
>  
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 0);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_SUCCESS);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 0);
>  
>  	exit_code = kvm_ghcb_get_sw_exit_code(control);
> @@ -4364,7 +4364,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  		default:
>  			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
>  			       control->exit_info_1);
> -			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
>  		}
>  
> @@ -4394,7 +4394,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>  	case SVM_VMGEXIT_AP_CREATION:
>  		ret = sev_snp_ap_creation(svm);
>  		if (ret) {
> -			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
> +			ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_MALFORMED_INPUT);
>  			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
>  		}
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c1e29307826b..5ebe8177d2c6 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2975,7 +2975,7 @@ static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
>  	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->sev_es.ghcb))
>  		return kvm_complete_insn_gp(vcpu, err);
>  
> -	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 1);
> +	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, GHCB_HV_RESP_ISSUE_EXCEPTION);
>  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
>  				X86_TRAP_GP |
>  				SVM_EVTINJ_TYPE_EXEPT |

