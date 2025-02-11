Return-Path: <kvm+bounces-37911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77EFAA3148F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 20:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E9263A8A96
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 19:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7210A262D39;
	Tue, 11 Feb 2025 19:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RzsQctQX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FA61E5B68
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 19:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739300616; cv=fail; b=XJUM3ol+gHBeuHYsJF8QDCrqnskRsaqEz+8ZvVzYDCTg9nhbrUrOiCA9cwV9RxAOw3XPllWJBiH4Ht6UaWfdMi8MjCu6HZYRzk/g8MaP+qITMpTVQj4FqAPf3fYhLiqlnErALFiCSj4jqC5UOsgrlyBrMmjKrS8tSDnHuuTC9V0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739300616; c=relaxed/simple;
	bh=4VX6rYlPErLqo1eHlNYPgZu0zS5uX+IoXFoDNzCGQa8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fM8GiFIX7wEqfkanaJ71JO1uINq1/lMfnup1tXT+gKgRM7Mirk+uvZzbAT+O64bPaqXnvVi6U1ZGZerpDKd+iXb5LMHysvo4FsYpeBBI0fsqAPPNYw27q21DEG/jMEmAwdivJpZHdDzY2yjaSx29YYtwhST+GThvkgpgK5GLtqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RzsQctQX; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Id3OrO/S4rCt4hrsZsdBQV5cuOlCsqOUodKdyoI5cCZ6EXcSNT4RhtLmJNdedUxWYaqbbc22wYCO4W9yPLrqr7+jG49QZhWeNqLPCmVikxuN/QJ5o5bbQTxndFooS/zxwG6BIoUx1cGsUWZDoncJn4fz5KdGog+ZQQgaZxP0TwbiCIM0+7GGaz10oAxM/4cp6uHmPMHzgFzMdR/32SLrFxQA3PEtJVVPkR8+Qcg7yB2vf9aXqgmHyNPnvjWSP9DwY9vccorNZ+A2UfbhMUq88U+RSTZX0C36rPpdexIutimr+KsGF/sNEMsKh/vFBoWxgs7omlKFYt72jZ8sSvJw0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrUSHHQzILJWvq2Qd9uEJGxtMW0SO10VdvdLamKzYn0=;
 b=QKzICztiVyzfJmKzGZJ/kssc9v+XLEoB1EvhbVs6WgQcBmRiigGL0aQkUf4RC/q/z/6eHw0JBqhYHFngJ8MsI3WuqN0BB2uDClooa/VpCO6VRK0jDgovUvUfhZwKnJ3bWkUN+rFRQCbDuaTjfNStscJz/e1RK3Xyf+pBp1H8T5ITTxIvQ9FGSNlDAfrE7Q8AMz2cFayVqUiNMhBt47vvNGI5YnZqvS5qc47JK+8u4dB6715uCX7MVD4xaE5a8UlfFp2P/qFcWeQd0PcDMVxHXwlTIhevKbXbs7+P5/O7e3ZmdV+akEfJF5STNWxZRbPIPgtzB7NgsrifXllH53eAbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrUSHHQzILJWvq2Qd9uEJGxtMW0SO10VdvdLamKzYn0=;
 b=RzsQctQXovUjjzXBmODz/oubrzH50wnI20iXOWKT/lWWeyT0rcLrJQ2Binjn+s4gysENfJzcxRuUcdzCweLAXqlco5Ye7eQ2bv2BRDnZetySehng/zYD8LAQsUWrRXE7gP8YFsg1lF0sXVr31kriTfNFcur9pPuSy+OIAiKiVw8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 CH3PR12MB8971.namprd12.prod.outlook.com (2603:10b6:610:177::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.16; Tue, 11 Feb
 2025 19:03:30 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::66d2:1631:5693:7a06%4]) with mapi id 15.20.8445.008; Tue, 11 Feb 2025
 19:03:30 +0000
Message-ID: <d61d4ca6-41ec-4236-a5ca-8fb40d987e3a@amd.com>
Date: Tue, 11 Feb 2025 13:03:26 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] target/i386: sev: Add cmdline option to enable the Allowed
 SEV Features feature
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A . Dadhania" <nikunj@amd.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20250207233327.130770-1-kim.phillips@amd.com>
 <Z6nFzwwOZDx4p6yq@redhat.com>
Content-Language: en-US
From: Kim Phillips <kim.phillips@amd.com>
Organization: AMD
In-Reply-To: <Z6nFzwwOZDx4p6yq@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::18) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|CH3PR12MB8971:EE_
X-MS-Office365-Filtering-Correlation-Id: 6501c991-01ab-40a6-4794-08dd4acec5ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vk1TTFlvTTluYmdTbDRuVk9tY2lTS3lJUVNnSnZETWo5VnM0Z01tbmVzT1pj?=
 =?utf-8?B?TWpWeDZxUGNKRlZUZ0tyTW4rcnNEOXovazRMS0U2SUtVcXNrV0t1MmYvOG0v?=
 =?utf-8?B?NWtseHV4RGxJSTRlck9QcVNQREVWZzJBYUlPYzlrUjF6SFE3SWtzZlpseW94?=
 =?utf-8?B?U3NOK0RjM2FibzQ4c2IwUFpnak5GR1FqcjBPOTRUdWdQYW5yN3FPWHZ5NHI3?=
 =?utf-8?B?cXpxQ3RVWVJZU05SQXE3Z3lmV3EveXFXZk9DRDdiZmx0dnI0RXZ5UzMwWHVL?=
 =?utf-8?B?Q1JqYjRPN0VyeStFVXl1R2Vkd0lwUU5lWGJqM1plT2RTUDJXeXN5TmVXbE5E?=
 =?utf-8?B?VzBZS2VTcUZIV2Y0UVVuWE1YeVZ0Qk8vbEZYVGlUUXc1cDZyY1NMWkVMY3o3?=
 =?utf-8?B?RVM2aEtXUXh1SlEzYW5weHg4QUMxRlJkRVM1YklXR2JoTWgyL1h3KzhlWjh5?=
 =?utf-8?B?ZnFSVVU4Wmw2V2FPeHl6U0R2SjBTcVdjUTNvUG52dGZmNXNzTWUrQVJVMDgv?=
 =?utf-8?B?elhlcDRPeERaZUxPU25qTkxvdVdNM2cydnNtQTlsTXhuU1dJWjJmQ3F2TVM1?=
 =?utf-8?B?NTByRWlCTDVVaUZZUmJmMTlEOGNaaGNyNkNxS1JhUjVCSTJpTkZmVW9VWWY2?=
 =?utf-8?B?UFVTb0FZK3lnL01uRUUxYkxYemxTRzBjK3Rjc1ZESkpJSnVmV2hUcXFtZENQ?=
 =?utf-8?B?TUFZVjRXdjJlZ0V4M0kvZHBMKzd5K25SOTNjcFRreEN5bFhwOXg5NW9lTGpJ?=
 =?utf-8?B?MXJGSUNlMHJSeTVpSml4c3dBQ3dmcU5ZS1doeWIxeDhKb2lwUVArcWNRYzR1?=
 =?utf-8?B?ZzdkNDlsVGtzOWNKK2tCZHppTitaMG5kRnZndXM5UmNmcWliWWdySXdQbUpB?=
 =?utf-8?B?eFpXSHN4eWNhcDA0OVJVeHRjRWlRanJvaTJ5aklLRFNZbHBXQmdOT1lSNk9z?=
 =?utf-8?B?WGQvTVBTNm5uems4MGF0a0RJSm92dWkwNkNDNGtGTHpBUnJSTUx2cCtkeW5s?=
 =?utf-8?B?TjdqYWxYZmdoVTNJejFrR0FONnRGSGxwQW11cHVXTmRaNXJyWWgrck5OWGo3?=
 =?utf-8?B?SVZiREU0clRYcWt3bCttdCtTT1J0NEo3Nm0yb3l2L3ozRlA2ODRLd3dZYzl3?=
 =?utf-8?B?YUJNK1c0SHM4eWIwQ05DQTRRSWNQN2RYemdBTkV6aXl3YnQ0MDJHazJHZnJL?=
 =?utf-8?B?bUhDL2MvdWU5TExEdS8xTDJ3ZGVuSWRTeW9LMkJ6Z3FrNFV1WXRtL1JWZmFs?=
 =?utf-8?B?N0Z1VGxyakpZZ2ZvMXBtdlR1UHRjRmI0NjhHYjErSTJtYzJyK2xPVGd6MDVN?=
 =?utf-8?B?WjdIL09iMFZOM1F5enVEVzI2OTgvOVpHRGNMU0VKM2pud3JGSkZkY3FhbDdp?=
 =?utf-8?B?R1lNL3ZhbHNtQkF2VnFHNWt2eG1DTHFUTFdaYldzUmpSU3NjdTFISHh5LzFT?=
 =?utf-8?B?MTVqNHdqNlN0UkNvM0xXQkV6R1hBeDgzS3kvVUhnL0NBKzFqNEdXUnBYMG1P?=
 =?utf-8?B?YkUrdlBQWWwzVWRzZUFSWjdRRGg5Qk9YbEJXdEdTSnNZQjNvbVErRzMrM0R1?=
 =?utf-8?B?SjlEUHA4NlFGRDVDakZ5NHFoMXV5ZHd2SDZXZDdpWFB6K1pUaW82RGd4b2hS?=
 =?utf-8?B?RjdZck1oS2JkdTA4MndYaW1VdGh1SmxTbHNDUitXVUc1U2J1WkI5S2xyV24w?=
 =?utf-8?B?ektYckx2SVVtOG11WmVyYTRVYlJaQTZMVVVJTHVaZUZZYXhSQkFMazhYQ05W?=
 =?utf-8?B?NkZQKzRCc1pJM3BJV3E4UkVrR3JFVWNpUFFVVkJUOVdqeVFRbDVJY0o1Tzh1?=
 =?utf-8?B?ekJVenRld0E3OS9YZXlxQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajhGWXlZbTRBb1BEbkF2cjNzanoxMU9RSm4xRXJWUVFhNUNUSzYzdUZSQ1oz?=
 =?utf-8?B?MXpMRy9EbG5VRjc2cWVrdktCVWs3eGI0V3JwMmVuclQrcFhmTDJmeE9weEVp?=
 =?utf-8?B?Q1c0NzBKY2VEZ3hBUlRtREFvWXlqQmxtY2lTMmVncEZYYlNUaVhJM2pKMHpj?=
 =?utf-8?B?MTJLZTRDMFlPRXBmM21VWXpMSHFTMXhYT3FGT2c1Z0RpaFg4K1ZqL29TaEdZ?=
 =?utf-8?B?UFdQV0wrd3dNN1Joa0hKYSt3V3NaMXFPVjA0ekxvWm9rZTQwdG1HN25vUnVZ?=
 =?utf-8?B?Sk0xMGlQMGkwR0R4VmZhcmVvVGMrTC9ZMVpmWmRBR3d2TU1JQ1J3elRHUDZD?=
 =?utf-8?B?UXFXd2xEV08vL2tvUk9RTkFEQXoxeW9yQ3dGb01zNUVKNzNzR0o3RWx6eEhH?=
 =?utf-8?B?T1BUbHA5RFRpWTMveGdDRGYyck5EWVJFdkljdEw5OHR1dkZ1Y0hHUExkQmll?=
 =?utf-8?B?RmVrTFQ5aGdoTUxSeDhSY0pNd0RiT2t1NDZ4aDV4UjZWUGNSZTdYTjBrODFk?=
 =?utf-8?B?SDZoS213ZXMwQ2NBOEhZY1lTYWZHOEd5SXI1QURJWXZ1L1Q0a1hjOUhxR1E4?=
 =?utf-8?B?VUtCdnVPV1Jsa3VidUswODlXSTUwOTNWTlBzM0NKQ01MYkRDODdhZXM2K0hI?=
 =?utf-8?B?cGZySW83YzRYRnlOQXlMdXRIWkY2ZVVZUmdReDRzRlUrR3dveDc3bHByOGJB?=
 =?utf-8?B?UDk1S1QvM3J3QlNub3lCU05OZnM2dkhzZ0dUWGhQNzZzYVJlUldsQ0Fua0Yr?=
 =?utf-8?B?eFJYQ2FwaGlGTjgrd3QvdzRNdDg2RGRkbEJmcUhQcForUHhRVDdUOGs0djl3?=
 =?utf-8?B?aUZmVDVnNlM4UUZtTHYrTjE1Y21nMmR1VmtxcUNJMTlBUHZ4L0Flc3BtL3ho?=
 =?utf-8?B?OEM4aktEZnhTWS9vM2grOGVtZUJKM0VqdzJjU3V3UlFDdkNadXJNY3hWakZh?=
 =?utf-8?B?SGRsTjhMUWh3TVF1dHJLQm5lTXJ0ajhaWTdvaHhOZjR6REZsM2dKMjZTbUpa?=
 =?utf-8?B?RXFrSUN6bzEvUHRhQVZPeGlGV1ZkMWtTcmpOWUE0UjIzTjJvSDN0RDN3SWxR?=
 =?utf-8?B?cWd4b1BYYmNzcjdhTFFpZEZZRlZpUGI5RnlLdkIzdE53ajd3VllmK2prR0xS?=
 =?utf-8?B?VUpGemZwUjZiZFJBV1I5Z2VFSDhGdEVBTjduT1dLOW5wcXErRWpyMHQ3ekdq?=
 =?utf-8?B?VCtHdUE5QXo4S1dJS3E4ZzFWV2EvTmllNXJCMGZNWnJhbVVKZlQxYUlaWjZU?=
 =?utf-8?B?bS81YWxvUGtMQmZqdFREMm0yN1JmWjJUTzVKRmhub0RjUWhwdUVBR2Y5YVI0?=
 =?utf-8?B?T2ZVcjQ1SSsrZHdaQmlnUElXaXd1Q2xTZkl2TERmZWN2T0RoYkl1NGFPMFZ0?=
 =?utf-8?B?NjFTVjdPaXBVYmVGTUxUWjNNMkFLaG4vUjZ4c01OL1oxbVJ3N2NqV0xpaURT?=
 =?utf-8?B?cFZsbllrNC9URk04OVFFbmFrTERYNGNvb2hHaGJZM2dNMTkybnM2L2loT2Vq?=
 =?utf-8?B?N255Mm85UFNqK3h0TXlMcmMvSFZmUzdOTnpwemd2bUliKy94WEVyU1M5dis5?=
 =?utf-8?B?Z1hxOStLWnhjOVRQZE12MThQeUN4UzBrcHpIZFRDV3c1TmVyWWQrRFJkek9i?=
 =?utf-8?B?WXlFU1dvaGtCZExRZEpoYVVQd3F4bGQ2RkNiN1dSNFhmWVJMTWZxYzZVS2d6?=
 =?utf-8?B?RjhEVDV4Z2Nxa1p6NW14RFhVRHhadWxtQ1RQR3lLaWpKWCtVRkpJUTMzRmU3?=
 =?utf-8?B?YVVWR3c3cktBVzJsNTUvaC85V3dadTJidjF3cEtUY0hDWHhaQmgyd2cwaDYv?=
 =?utf-8?B?ZG5hampRT2g3VnVqN3lrR29SWm1xclI4bnZoOFhGeU5tL09CLzk2MVdLaVRi?=
 =?utf-8?B?VUlBVS9SL25KZFdvYmhRUUVnVEl1Y3o4TG9UQW9jbGYvaDF6NTJucURxb0pE?=
 =?utf-8?B?VmVXSTdxZm5lb0pKUkhEdyszdmJmRXhtdzQ2YTJZcURzNHN2Z3dUYW54WUYy?=
 =?utf-8?B?WTI0WUhBRTBnenU3K2JRU09qQ29WZHFMa1NBZWMxcEJiUlpkZzEyendEWUZU?=
 =?utf-8?B?a2dBY0pzb0tuV2NtQnlBK0YzZkFtWkx6N1hEZ3lOVjNwU1IxWThDYTBGN05P?=
 =?utf-8?Q?UYZ7FjWBzepqBjyygi+mBzjI9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6501c991-01ab-40a6-4794-08dd4acec5ca
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 19:03:30.2549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMUIq3f4LL0S1W7AH4q29xZ1oBWKwK3DLL3md1xcHbZ0xzX8udsJW5eorMuAZcaqnYfEyfSX/vTmRWXOd3CvDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8971

On 2/10/25 3:24 AM, Daniel P. Berrangé wrote:
> On Fri, Feb 07, 2025 at 05:33:27PM -0600, Kim Phillips wrote:
>> The Allowed SEV Features feature allows the host kernel to control
>> which SEV features it does not want the guest to enable [1].
>>
>> This has to be explicitly opted-in by the user because it has the
>> ability to break existing VMs if it were set automatically.
>>
>> Currently, both the PmcVirtualization and SecureAvic features
>> require the Allowed SEV Features feature to be set.
>>
>> Based on a similar patch written for Secure TSC [2].
>>
>> [1] Section 15.36.20 "Allowed SEV Features", AMD64 Architecture
>>      Programmer's Manual, Pub. 24593 Rev. 3.42 - March 2024:
>>      https://bugzilla.kernel.org/attachment.cgi?id=306250
>>
>> [2] https://github.com/qemu/qemu/commit/4b2288dc6025ba32519ee8d202ca72d565cbbab7
> 
> Despite that URL, that commit also does not appear to be merged into
> the QEMU git repo, and indeed I can't find any record of it even being
> posted as a patch for review on qemu-devel.
> 
> This is horribly misleading to reviewers, suggesting that the referenced
> patch was already accepted :-(

Apologies, that was not the intent.  I'll remove it from the next version.

>> @@ -1524,6 +1552,20 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>>       case KVM_X86_SNP_VM: {
>>           struct kvm_sev_init args = { 0 };
>>   
>> +        if (sev_es_enabled()) {
>> +            __u64 vmsa_features, supported_vmsa_features;
>> +
>> +            supported_vmsa_features = sev_supported_vmsa_features();
>> +            vmsa_features = sev_common->vmsa_features;
>> +            if ((vmsa_features & supported_vmsa_features) != vmsa_features) {
>> +                error_setg(errp, "%s: requested sev feature mask (0x%llx) "
>> +                           "contains bits not supported by the host kernel "
>> +                           " (0x%llx)", __func__, vmsa_features,
>> +                           supported_vmsa_features);
> 
> This logic is being applied unconditionally, and not connected to
> the setting of the new 'allowed-sev-features' flag value. Is that
> correct  ?

That's correct.

> Will this end up breaking existing deployed guests, or is this a
> scenario that would have been blocked with an error later on
> regardless ?

It would have been blocked regardless by this check in kvm's __sev_guest_init:

https://elixir.bootlin.com/linux/v6.13.2/source/arch/x86/kvm/svm/sev.c#L418

I've addressed all your other comments.

Thank you for your review,

Kim

