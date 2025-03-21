Return-Path: <kvm+bounces-41668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B2BA6BD54
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:42:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D5BF460E38
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E181D5166;
	Fri, 21 Mar 2025 14:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4LKDryKM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C74E1A256B;
	Fri, 21 Mar 2025 14:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742568020; cv=fail; b=jAKx0bIlaP/Wb/SM+5qHB3GJtAM+R63Zkzz7h6QwRfkQKtqB5hmQ/REcsF7JZSJ+lr5eWwYywCBWllKlfPmPiln+aRJXrwDHsAs3+SOt56V9x7uELgWhZ5TnGHLYcKVU4S/FbuMTqQ7QVc1+r/q0isETilKjC6tAnUHKCkYHD6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742568020; c=relaxed/simple;
	bh=MIczyxCCvb9zZLb1TdJSC2cQQYHJ7FrRanzpPUexG50=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bM+RM25EIXBEx3FBqWjyMzddozybf126O38y03inYyNsjGNcoA7z2pAF0AwA64NJhi1sZ0zFwamKYvTWYqissvXyqgq5QP/clNVFt8acQUJB13EPSnEQ1QUuK1H9wYBFlK6zgaLDYm59hsqcbjMciBBODfnXGChf5G9QW/3peTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4LKDryKM; arc=fail smtp.client-ip=40.107.244.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ixvu2QhtjI2+v9gYl1pWnVSePvzfZfVvBsTkpmlSTfs+96urglW1SbZp+zqAdGOiNyXPxUM2MC94gV4XKaxyZJDRycdWAh2G+2XGd57KruZ2QJoFprFubTI3SjyXXHNjUbr7mQMHikUO20JZdHFaaU/YWQHE0KhkaIEgpByx4909PAAJB4zvI7Yht1HjkgK8f9x+cw8D2jWkIhtV2Lj3Gfjja3i1trkIcNAjkJjFtgJTlbgzcRBy5YMBGTyT0f2UVpq+PeWwrrkLN/KY7XPocQB3IjKmXTLlEHTNzm0QRBg50gFTqwPllLbsNvMk3zKb3sxucl3ZTz9mbTRP3On5FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GE5q1G5OsJdY3OoqNN7+lYdxtZtdIU9ejsS4fLRJUyU=;
 b=tVMf04bm9xEBGtr9FrbTeOqVNR9Drn55aJa2RI0Ou9fI70LZgtV+sWfq1W5T53XrxQw7tOquMCt2M/R0yLKp/E6VALHpPlFbXNzzDjljISvLjw/cl4xvF+nR3NJCf8d6SNE4IF0Tfk5M9ZHkAWUIx183uucU9EAczKAL0OXcxfYAp3hme4k15bCo8SeuqtJvoHNqYcu5PU24kqOYlzIzDsHVAZU33Ft+bEXQqy/LXTAjUpSgOQPNBmX2BjUE+jIZgTyUsfCAznjENp3Ucxf3lP9Els2uPw50BiWKF5/kylQEgAyntXd0/MtdeJv2FxJK/SUnRmHjNidPPp02+s0z8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GE5q1G5OsJdY3OoqNN7+lYdxtZtdIU9ejsS4fLRJUyU=;
 b=4LKDryKM6Yw1uZfeUH2ys6gTSSvMkB96wjMUdQD4ZEQC2cMb6sAN50xrP9rrIUpamk8WTewrLydpNhvyEAH9gHhcH17fkF7gA4uaKAO5R2TKHKUAWqJxUDbj7P+GgctpiO2c0XSnoKLfOh2KV3nxjLcDo4eHvqXmKR0nwwwyyn4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL1PR12MB5924.namprd12.prod.outlook.com (2603:10b6:208:39b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.36; Fri, 21 Mar
 2025 14:40:15 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8534.036; Fri, 21 Mar 2025
 14:40:15 +0000
Message-ID: <673b9be2-67b0-7386-0f9a-abfe103e6bc4@amd.com>
Date: Fri, 21 Mar 2025 09:40:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/5] KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if
 debugging is enabled
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
 <ea3b852c295b6f4b200925ed6b6e2c90d9475e71.1742477213.git.thomas.lendacky@amd.com>
 <419e72d3-5142-41c0-61d8-21b9db14ec5b@amd.com>
In-Reply-To: <419e72d3-5142-41c0-61d8-21b9db14ec5b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0062.namprd04.prod.outlook.com
 (2603:10b6:806:121::7) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL1PR12MB5924:EE_
X-MS-Office365-Filtering-Correlation-Id: 732646af-415c-41bb-73ae-08dd68864b11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SGFDam1wVnd1Ri9EcDE4ZEdWcmpIMU5VRHVPY3RwWHU4QjVhZ1RKeXFoWnlx?=
 =?utf-8?B?SngzS0xMN0hWM0xHZG9rUlpVMFFhdGM4WU41MXd6T01WUitiT2JxaW4rTG14?=
 =?utf-8?B?RHlra2V3aUNvdGJBQzFrL1lkOGlyOHQ1ekZVSm1iZnE2b0FMMEkzcmtKdkxs?=
 =?utf-8?B?aWI5Rmg3d0NRYlc0MnVJSldidVlVM3l6eU1oOFhNSHdIcWNaTUlhdHo3QzZW?=
 =?utf-8?B?YmJJdW82SWphV0k0WDJBZ3YvVFNPSWx3WTRCN3JRbXpHclY3ai9VeGk1ZTkz?=
 =?utf-8?B?US81R05tV01NbDJmZnJVRUlYQnFDVldBR0FPUEsxa1JteHFKcWtkWmt3c3Rj?=
 =?utf-8?B?QStIVG5qSWtUWHYrS2ViM0VNczlhTUJNL042TDlMWlhXWFVNbDErNk1od243?=
 =?utf-8?B?WHZkeFNxeXpxSzRkTEUwMDhyTllBVEkvRS9tU3BsaDljaXp4QTZuK1pHV3RJ?=
 =?utf-8?B?Um9obnFDUWd5K2gzcnZVZkV2UlRWZnpDZGVNbmNMeXp0dUw5Z2FSc3pkWTVU?=
 =?utf-8?B?cXpNc1luRlNONGJFSmMrTXNPSFlJdmpERHBTMGtPb2pqNVMwUVk0R2FRZFFG?=
 =?utf-8?B?ZVkxWFdlMGpzYzdLazZSUE9TdHNEYTFlYUNRQXhrM3RSeWlvc3lWQTFyMFVE?=
 =?utf-8?B?VW5BelBSVWY1aDUxclgwMm9TV1RQNUlvbmZvQWcxdUxHYWFTVzN2MnFkR3I5?=
 =?utf-8?B?UExleW1DT3V5Vko3SVpZdGZUQlMyd2NkS3NsUkFKOXVuRFFpUERCSUhicEVo?=
 =?utf-8?B?cHE0eVpGUHBNZ0VCeEJzNGxJeHJOd3ZnZFhsWnhkc2RMZ1A3dnRBenY2NGlS?=
 =?utf-8?B?MndHNGltVWRKalNGVmJRWEJyWFE4V3BYSE1nUGRmUitxVHUvYlphSHh0R2t4?=
 =?utf-8?B?c0JkMXJ1SkNFWFhMRUw0SzRQRDE3M0pBUWFUMksxUjNDQ1dPNEZSM3FMZXdk?=
 =?utf-8?B?OVloUk9QY0Z0ek1DYkV6cDJyeUJoeVRNUE9LVmtNNGx6YXFnZXY0UEI2N0tD?=
 =?utf-8?B?aGdyVXBSa2I0blVDTkNDcnAxQ0d3YVRiT1hjblpZMk5QZWhNU2J0MEcwM1FN?=
 =?utf-8?B?UGJPZ3hOL2hkSFluNDNNN3hJaU1VdmJFTmEvZGtOZnJuYVRYVEpyZ0lQc0ZI?=
 =?utf-8?B?YWJ5dUtMaG9DWWlqNEhWYnViRHNzRDg3a0x0TGJjSUlvUDlidVAxSG54dk4y?=
 =?utf-8?B?YWJsVE1MYkc4QmI3RXFtU1hIYTdsa0tsRnJNMFlXc212VWljQmNwS2wxUEZQ?=
 =?utf-8?B?R2ZKdUh5ZGtoQURDTWIvRGhVQmJ3czdxeVNyMVBUUXhLcm4xdVM5bHMvaS9r?=
 =?utf-8?B?WmpTa2xDVFBLVnEzNTdQZ0xtb1Zwc1ZYV3loRStrbnYvVGh5QTZKL1FHNEVB?=
 =?utf-8?B?Snh1U3dOMHplOFh1TVMzZW5aTlFWVUd3M0V3ZTc3QXRHblhua3YvR003MWU1?=
 =?utf-8?B?aWQ5YkcrU1FVQklMQ3hFcEpoV2NsVXNZLzI5UTlZTkdqYjVSajREbThGM05P?=
 =?utf-8?B?ZWJnZVpEZE5pcHdiZ2dybzhXTi9NOGhPVDB2S2lMb3R1ZThWbG5xZXJFWWw4?=
 =?utf-8?B?N0p1VjVHUUxCVEpzSklBMzgya0VtZmtSMTJwYzJtbjNXY1lRdCtNRTRpeTRC?=
 =?utf-8?B?VEF6V21aNUlIM3h0U20wTEhuQmdEWEsvSHlwNHpjY0VKNXMrVDQzb2o0aGQr?=
 =?utf-8?B?WEE1Q2twazJ1dTQ3WDdkNm9FOGROc3VMZHByM2gxcnluN3h0bjRQOERQQkRk?=
 =?utf-8?B?VzhZSlpBelZSbThxdkgzeGY1S0VuZVVNcCtQeWlzNnlXUENSbkl5aVRDMlU2?=
 =?utf-8?B?NFM4WUZQbEpZT24yV2R4TnF1b0ZkK0xNUyt5UGZldnZhblJEbUtWakNZeU1T?=
 =?utf-8?Q?17gwY4/NybFkT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEM4TDhnR2NvcWs3NzNIMnh1VG91WTUzTWZqUnJocmUzdUpieDh4ZTJTMnMw?=
 =?utf-8?B?OHk2RVVqN0tadCsvamFHamhBd2lvbGNBMldzTWVrOC9QcHdiODNHNldaYWFR?=
 =?utf-8?B?bGpNZU5YZmNWNXZZVGV1THNDS1pYNlJ6MGdDRVhyT1p2azNkd1ArZ0c3ZDJW?=
 =?utf-8?B?UC9nanhzRmFoSGxSYkJqOXRKUlBjbDRJdVNCb3lFWXRvNXFKWnZ4R04wNDNV?=
 =?utf-8?B?cWJvakc4ZHBNeGVubXdpejFRNU9BblFycHJpNmRkcmNFbXlxaStLNkUzK1N3?=
 =?utf-8?B?K21DcEJZK2I2NTJSbTRMb3pSQ2hUVytrYkRwVllEWUZqcHRjRmFpN2gyOU84?=
 =?utf-8?B?ek40RzRyaXBVNjMxd25FSDNZU3B4NFNTMDFQMzJzY3ZTWjJTNmhDTUhJbjBr?=
 =?utf-8?B?NXoyTkt0Ny95cHhUcDNKV2pSWXJuYW1idVNJZ2J4WnBzTU0zdVlnTU1tZURx?=
 =?utf-8?B?d3VVcE9TV051dHROY1FjQjI3bkFxWEdiNDhlT2dGTTlpcVgwdHAvaFZHYWho?=
 =?utf-8?B?WkdabkEvMUd5RktnZ2lGNmNVaU14eEpJdVh3RGtKczB3TFZOTm9NTFVUMFVN?=
 =?utf-8?B?K1ZYN1JibFFXano4OVlDdE5HWEdhRk9QbmUzOTVicVh2cHArLy8wR3Q2UHV4?=
 =?utf-8?B?cENYZ3k1d0NMMDl3V2J0MTllb2VSWEsvbDIwUGlaYmp0QXZMM205c2xDSE9S?=
 =?utf-8?B?cGRMYWkxM1N6WVpyS3V6cDZZbGtvR284ZGZyYTE5Mmljd05VVnNRcU40Mm9J?=
 =?utf-8?B?RFl0STRUWHhLaGRxditiOHVaRkJrUEE4VWxnQmk5VkNBdUk5VDlSVjZxMTVJ?=
 =?utf-8?B?TlhOaHk1V3c4ZmR5WjYyeFh0aW5JOFpla0pWdHl1MGl1emFDeFNWOWVVaitn?=
 =?utf-8?B?YmFhQUFERHBiL004TWNablpDcTBMYUlNSHF3TkNRbStnY1laY0lyUVlQT3NV?=
 =?utf-8?B?UXhBUGhyekFLZXlQYVZaNG1JT1BsOG9MNUcvZk1nTGNQMWJNakZvcmUvR0ds?=
 =?utf-8?B?cGVFOCt6aE5hOEEvOFZtbUgxaXJ5OFB0ODduOVd1YSt6S1VUS0xybDJTcHlE?=
 =?utf-8?B?bGZob2NoZzNiNUJnNTBqb05ZcmhVQ1VkTWluY3F1c2pEVXQ3eTVVWWptRFRM?=
 =?utf-8?B?RDV5czNYeG9FMXhzTjZZUm5VU3pyZ09RTHo2eEJUa0hRZ1phWlRBUVJjcW5r?=
 =?utf-8?B?bWErNmMxZitZbXJkLzdhVkdDMVl3VWJud1YzNUczeVZiTHh6TVk2Zjg1MTIz?=
 =?utf-8?B?WmNuY3F0TlF3bENJZWJhbmRJVGlJWC9CTXJsQlMxRVF5a0ZVYkNnZGw0c1dF?=
 =?utf-8?B?S3RERk1aOEFJSndDRTEvRmVLNktkNTk2VDdaRmZFR3BBTktTYWUzNmFwWWkz?=
 =?utf-8?B?VGZiTkJpd1RnUG9zL1pnTEl2L0tHTjQwWjA5bU9qTGlaTHZ3UTQ5TzBmODFB?=
 =?utf-8?B?U0h0UFVKeEV1cmhLalRQUmt3SWhDa0xqNGxVRlNMTmdsK0hYVDNQTysvRFJi?=
 =?utf-8?B?Y1NxWmdFY3duQXRzOUJ2VlA4eEdqbk94OHdnOUplMUtGemVneU9NWGs2aHhZ?=
 =?utf-8?B?TXFGOC8waUk3ZWh2VnFlZVRrVmZXQlRlY1BZS0x2NzduQlI5enpyQzYzTVpP?=
 =?utf-8?B?WCsvc1ZjR0g4dldubjhEZ1RSdUNwNWR4MWZGa1lDSWwrNVMwc3ArSTlvcXB4?=
 =?utf-8?B?OG5ZbU82MUcrck5vTlhMQjBrejE1QmF3elpSa0RnWjF6bHc1QnpNUGNrSStI?=
 =?utf-8?B?UWlEckpJa2ZrWGU5bmI0cGZyTWc3ZFo2b01qYTc0SDVVN2hkNzFxYzZhcU5y?=
 =?utf-8?B?ZTV2czZMYkU3akhZV3dtNUhZUDBXNHRPbHRWcnIyUUlMTzFIc3RSeTZSYTBI?=
 =?utf-8?B?ZVpuZ3NlUEE1ajU5TDhHV3pkbmV0R1g2azBITkhTK203NDBzbzRRQnRUSjBS?=
 =?utf-8?B?dGdpNVdnaXFJczJRNmE1dEEyS3lmWDR2R2lmRXZYMEdhL00wZjdSMk9WV1FG?=
 =?utf-8?B?aC9vZ0JuODhZeWtJZGhRVERUUGUvREJKT2FHS3ZVTjRUZlR1aTJSeVNuMnJv?=
 =?utf-8?B?aWJkMmNOU2xxbzQwejY3Qnk2UG5TR3ptanNET01EU1dtZzVWWHlsVDV4M2JE?=
 =?utf-8?Q?+3OV5cKYuUjOwXWZaHHFu0O/e?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 732646af-415c-41bb-73ae-08dd68864b11
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 14:40:15.3029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOgsvzA/EK/ES/Y40gZoHDab/gZ4zOgfjL02/Xs2ZeLzt8GYav10y/hxmLaF/Jy+YIoHXEknn6zRGutZ8QLJGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5924

On 3/21/25 09:36, Tom Lendacky wrote:
> On 3/20/25 08:26, Tom Lendacky wrote:
>> An SEV-ES/SEV-SNP VM save area (VMSA) can be decrypted if the guest
>> policy allows debugging. Update the dump_vmcb() routine to output
>> some of the SEV VMSA contents if possible. This can be useful for
>> debug purposes.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---

>> +		/*
>> +		 * Return the target page to a hypervisor page no matter what.
>> +		 * If this fails, the page can't be used, so leak it and don't
>> +		 * try to use it.
>> +		 */
>> +		if (snp_page_reclaim(vcpu->kvm, PHYS_PFN(__pa(vmsa))))
>> +			return NULL;
> 
> And actually I should call snp_leak_pages() here to record that. I'll add
> that to the next version.

Err... snp_page_reclaim() already does that. Nevermind.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>> +
>> +		if (ret) {
>> +			pr_err("SEV: SNP_DBG_DECRYPT failed ret=%d, fw_error=%d (%#x)\n",
>> +			       ret, error, error);
>> +			free_page((unsigned long)vmsa);
>> +
>> +			return NULL;
>> +		}
>> +	} else {
>> +		struct sev_data_dbg dbg = {0};
>> +		struct page *vmsa_page;
>> +
>> +		vmsa_page = alloc_page(GFP_KERNEL);
>> +		if (!vmsa_page)
>> +			return NULL;
>> +
>> +		vmsa = page_address(vmsa_page);
>> +
>> +		dbg.handle = sev->handle;
>> +		dbg.src_addr = svm->vmcb->control.vmsa_pa;
>> +		dbg.dst_addr = __psp_pa(vmsa);
>> +		dbg.len = PAGE_SIZE;
>> +
>> +		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_DBG_DECRYPT, &dbg, &error);
>> +		if (ret) {
>> +			pr_err("SEV: SEV_CMD_DBG_DECRYPT failed ret=%d, fw_error=%d (0x%x)\n",
>> +			       ret, error, error);
>> +			__free_page(vmsa_page);
>> +
>> +			return NULL;
>> +		}
>> +	}
>> +
>> +	return vmsa;
>> +}
>> +
>> +void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa)
>> +{
>> +	/* If the VMSA has not yet been encrypted, nothing was allocated */
>> +	if (!vcpu->arch.guest_state_protected || !vmsa)
>> +		return;
>> +
>> +	free_page((unsigned long)vmsa);
>> +}
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index e67de787fc71..21477871073c 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3423,6 +3423,15 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>>  	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
>>  	pr_err("%-20s%016llx\n", "avic_physical_id:", control->avic_physical_id);
>>  	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
>> +
>> +	if (sev_es_guest(vcpu->kvm)) {
>> +		save = sev_decrypt_vmsa(vcpu);
>> +		if (!save)
>> +			goto no_vmsa;
>> +
>> +		save01 = save;
>> +	}
>> +
>>  	pr_err("VMCB State Save Area:\n");
>>  	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
>>  	       "es:",
>> @@ -3493,6 +3502,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>>  	pr_err("%-15s %016llx %-13s %016llx\n",
>>  	       "excp_from:", save->last_excp_from,
>>  	       "excp_to:", save->last_excp_to);
>> +
>> +no_vmsa:
>> +	if (sev_es_guest(vcpu->kvm))
>> +		sev_free_decrypted_vmsa(vcpu, save);
>>  }
>>  
>>  static bool svm_check_exit_valid(u64 exit_code)
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index ea44c1da5a7c..66979ddc3659 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -98,6 +98,7 @@ struct kvm_sev_info {
>>  	unsigned int asid;	/* ASID used for this guest */
>>  	unsigned int handle;	/* SEV firmware handle */
>>  	int fd;			/* SEV device fd */
>> +	unsigned long policy;
>>  	unsigned long pages_locked; /* Number of pages locked */
>>  	struct list_head regions_list;  /* List of registered regions */
>>  	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
>> @@ -114,6 +115,9 @@ struct kvm_sev_info {
>>  	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
>>  };
>>  
>> +#define SEV_POLICY_NODBG	BIT_ULL(0)
>> +#define SNP_POLICY_DEBUG	BIT_ULL(19)
>> +
>>  struct kvm_svm {
>>  	struct kvm kvm;
>>  
>> @@ -756,6 +760,8 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>>  int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
>> +struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
>> +void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
>>  #else
>>  static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
>>  {
>> @@ -787,6 +793,11 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>>  	return 0;
>>  }
>>  
>> +static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
>> +{
>> +	return NULL;
>> +}
>> +static inline void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa) {}
>>  #endif
>>  
>>  /* vmenter.S */

