Return-Path: <kvm+bounces-31671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B522F9C6362
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:26:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40B711F23648
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C78321A4D0;
	Tue, 12 Nov 2024 21:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YiE6FMiq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B898E219E5F;
	Tue, 12 Nov 2024 21:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731446783; cv=fail; b=o9iw4YeQvKd3KU6b79SVFU+1qgmU8NFKgG7h5GxNnyGLUqaoa6v4yCdK4dM9bA2XEU2NCPypw2OsjjqGOrRcd+Hj6uzF5W2zcIcEEQQNDQ1OaWOF4OVuNraTUjRuLCyU6lZx+60EzO6svaPkiXyhsZnwg5zvppPIZlK5+U50YN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731446783; c=relaxed/simple;
	bh=cPur6Z2r1H+TCdOTikok0p/UMl0G7tRjx4HK+nKLYSg=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=rU9kLC8b7sb9OHLar+IvHd9HYq/jceKjG/RVaTRQjUvXaR74sMJBPc/6tS2Iu/0zNLl3vK2gv65GwdocJVKZGIITuf5ajJaB8WcE9DvbkKVxFX/flQDRo7eihiEiR2xmEPxAAvfDra8O4wC9lc1bW/bOJodcNvYEMRrQqDSV91I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YiE6FMiq; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DKFL5yrIoJ+SDff+VE0yUUSHQT2dxrdA/wKkykX8n81pqtlau0Cq9BNTk0WPYGeozKnz4sXa/bUubwb3c9QZyCSIn45UXLZCb+UN3WUjpAUh/4c67LxW9sdBv3HtUV+6Cp+rhYwAlZZfLsDexgORfP69JUtvufYVGxCR1Hk87Ip23MWXYnCY8v1SuTyovG8XaD4V4+WC2GlU2Hc73YW9ih9dBXYwQc6ZqpNSpYa8thOkWgrFMsbI9XxyffOYn8AhM4q8owMDZZjGVlQw6SuQJvXJt9unvZzoin/pApS7QTeis0Pqeb8wJFoQG8dkr/Se8EUojm4F7G59HlxZLVFDvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yq70ZJp/kTBTHdCQnDlUM3qq+Ns+Vk0kDnAkzGXm0tE=;
 b=U/uYnhX+gEgpHgMJEtmDNILugx7wKoKdVh1rI8IGuqAWoGvQnm4hfpKO+0U4INAjzP+G/B9xoabAOD4fSbbRSY3E5uCyW/YE+PP4fub+1V7LNSAnGMDZdJ0C+2shU+/eXgXAEz7rXStnGkD+EFRB6IuzXqlqSe4MTdf0n4q/drbrzB/DApWOqUYB9MGcShtlJRnMDyu9c0gsMnWyIY47bQP9Y76+nX2ZB7yiyMnkgM7uY5lcY4X+mdRSDPCBKWBfRF2EqfXIGBznFhk4lDqBzIMwN7X4NaDJXno5SB3dF8+wrm8U8Y37Bwy4wm0mi3i32ShifuqFDGLq34CPoZaWbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yq70ZJp/kTBTHdCQnDlUM3qq+Ns+Vk0kDnAkzGXm0tE=;
 b=YiE6FMiqaOJMtZa8IBqlp9iApMqWq82VaUr+gxFlw/Af3JnYRzq0Ocv4z2KYh5OKgC/J5v82UDnPU7rTMwuWcO1+OTLm6nd2PnqNcoUMmm7YUIQT1HClIlo6f3I0dWSw5AUBA2znT4o25YeEJLWblojlN9vLw9t8euOZiOuTeHk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN2PR12MB4238.namprd12.prod.outlook.com (2603:10b6:208:199::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.25; Tue, 12 Nov
 2024 21:26:17 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 21:26:17 +0000
Message-ID: <308f26c5-d47c-df63-19eb-59ebbf1e16dd@amd.com>
Date: Tue, 12 Nov 2024 15:26:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-coco@lists.linux.dev, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Michael Roth
 <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 kvm@vger.kernel.org
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-10-dionnaglaze@google.com>
 <43be0a16-0a06-d7fb-3925-4337fb38e9e9@amd.com>
 <CAAH4kHasdYwboG+zgR=MaTRBKyNmwpvBQ-ChRY18=EiBBSdFXQ@mail.gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 09/10] KVM: SVM: Use new ccp GCTX API
In-Reply-To: <CAAH4kHasdYwboG+zgR=MaTRBKyNmwpvBQ-ChRY18=EiBBSdFXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0097.namprd13.prod.outlook.com
 (2603:10b6:806:24::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN2PR12MB4238:EE_
X-MS-Office365-Filtering-Correlation-Id: 417fd434-5965-41a9-d40d-08dd0360a4c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zm92MEM2aHF5MzNBNlpjMjNEODQrVlcrQWRMK3N4aitzZ3RTbHluMjNrK3gz?=
 =?utf-8?B?cisrZndIWFlWS1NFYkdVVTJ2Z1hDOG5uQTRPKzk3MncvS2crNUw0R2trcWt5?=
 =?utf-8?B?UVdHNlFhc3RqS3hITmdDMEh1NnpwUHJrRFhnZG02Vm5YTkNHMExXdnlHS0px?=
 =?utf-8?B?UFJnUmR2ckUvenV4OS9yMGN6RGY2TFZFQTlnbmlmckFscmt2cGVTQlpSSFFT?=
 =?utf-8?B?U0FoZXpKL25yN1BnWkdoci9JVUFtbVpCV1htbzh1S2dSNXVoU2RDS3JBMU0z?=
 =?utf-8?B?bGZqekpIbk5ZRnErVS9UbjN2TlVTQklza3NVZ2h1NFdXT1o2QkY4QXNxcktR?=
 =?utf-8?B?WkZiU0NVenArb0Z0ZFJTTXllcE1FRE51Vm1YMitRRS9MS1gwclcvNjdpL0RF?=
 =?utf-8?B?UHZMc3BOTXlLSmRwNTA5TXVhMjI2VFo1cWVrRE5oejc5ZkdZaTRJNitGUWJD?=
 =?utf-8?B?RVpDWUY1WmhYbCt5b2E2QkNMTDN0RTVGbUl3MVlySHBlY3dQVTVzWWhYRlFG?=
 =?utf-8?B?SXF3cklFcGhBalh0ekRwRE9PWUpxR2Q0RktPbmFYWDl6S00vWTNHc1FRd3JO?=
 =?utf-8?B?SDJVYWZRaGd0Y2JBSWdDMnpHMGgzMFpxdVlVelp2VnVBd3FSYksweWZwV2Q3?=
 =?utf-8?B?c1R1bHBUTG93cWNYRTdrSzBvWTVxTTZzaE5yYURUeEh1andrQXBheWFPYzBn?=
 =?utf-8?B?bk1BcGVDaTlIN0dPS3cyTUtmckJmaHpmdlZiZXYva1JsWlRGcEpieWZtWitk?=
 =?utf-8?B?QUpUc0s5TzA5b3U2dzVVVzVubzl0V0VYNEFoL3J1bTdDd1hVenZ5c2FSNnVl?=
 =?utf-8?B?TVV3cGVuSk5qRHZMZ0I5TmNneklCbE9aR1p5U2RUMFU1ODBkOXpZYVhJVEdr?=
 =?utf-8?B?aForM1BOUFJhNEd6YVRqaitORU03Z0VlQmVTOG1RWUdUaElLT1FmaHdiV1JK?=
 =?utf-8?B?T3poV0JCcCtPSCttdU1mQUtFdWxuaGlxM1I1eS83djV5dHlpaXI5YXlDOHFV?=
 =?utf-8?B?RDBxYlpwVGVXMGp0cXhSSlpLWngxanNrdWtSVmZKTi8rY2ViZ2Y0R0Z1TWE1?=
 =?utf-8?B?VzdTUy9TK1VJSHY0QTdxWnNUWlJjK3Z5OXQwUDUzUk9sN0tSdE1JKyszeFhp?=
 =?utf-8?B?emozZG5QWnEyRjJqNVRpUmhycGE4ZmFwaXhWNERQdlR2VW9OTlBISDdhTG5v?=
 =?utf-8?B?QURLemM3TGlkS3hqb1NBR205WTB3bHltZjV2OFFwcXhabnM5SEhqRkhDVkdX?=
 =?utf-8?B?bnQra1lQTHg5dEVZd0tpMzNRV0s4NnE3QkJNTWhjSVZHdWdLM09hN1UxTUJF?=
 =?utf-8?B?eHpRSUZGcUJrcGtXdG9CMUl0WXhCZlcyYldialRrRHBWcHVSUzRMVzJvM1BU?=
 =?utf-8?B?Y1BIdnpTRGhydWJLOFQxQXVNVkZQSmViLytMNnNDZWxVOWZiQWFMN1p1QXdk?=
 =?utf-8?B?SFJCWjdIelY0UER6dGRuTmE5QlhtWGI1dXhJM3B6WUFHc1NYbFpNUVVuTitk?=
 =?utf-8?B?MnNIM1U4ZmprVkY2eWwvWE1WVk15MkhBdnJEQ0VhZHB3UXIra3pJTnRpRWxH?=
 =?utf-8?B?Vk95YzFlK1k2REdIcGMzUHpXU3dmdE9MVDBxcXk0ZVJPb1o3cURSWW9nQzMv?=
 =?utf-8?B?ck80djhUVWxxSmZzL2dXVWs1R1lma05UVTlWbENqazVjQkVBZko4R2VVK214?=
 =?utf-8?B?K0xlZy8xbm8yeW5EWGJQelU4ZTNCTHVMdkN6MFRjWHFxY3ZHZ3BqdmhPRmd6?=
 =?utf-8?Q?YYiefUwDyHBmmBrOVj/2fB5PGcb5U4TrpbCNcp0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWtBV1VmWFVNMENDaXdYbnMxUk5KU1BDYyt2YkpHcW1Qa3RKb2I1T3Q0NTBr?=
 =?utf-8?B?NmtZVHp4R3RFVy9oV3FrM0U5WEVUMjNGYk5sZENnelpqakpYUldmS3hwK1U2?=
 =?utf-8?B?VmVZZnpxZnpYeE9TT2twVzQzdzcyMlVQcFRBMHJoWCsvS3pmWkZCanJoKzUr?=
 =?utf-8?B?WUtOelJuMmF5eWo2dms4S01Makt3VWNXYU5CVlRMeDlxZjBzMU9HMXBudXMz?=
 =?utf-8?B?dXc5OE5ib3NJamZDN0tMWlVlNnhOSkMzSlVtNlFyUzFKT1c2QXJoajVyMlhs?=
 =?utf-8?B?Q2RobXNWMFpVS2kvOUNXTzVjVGQ4d0phajc2REthWmxUbUw1dS93QnpXekd1?=
 =?utf-8?B?M1RSckhWZm9NNnBNSnJKbTIwaGNFQ0dkejJuYzNlTnFSYjFqNlRqWEtSaHRU?=
 =?utf-8?B?aWh2MmtaMm43YWFkbVkzZVhMRlk2QTRPUkt2NExubDFmcDMzdzhaMzRaWXhx?=
 =?utf-8?B?aHpVUmhnMEpPSVpXV3FvWGRJS0VMeWhHU2NZaUo0Zkx5Qmd2cm5HR0JMdG1r?=
 =?utf-8?B?cmU3ejNBTjQxY0toajk3ejRVVkZjQUdhaXQzMmFRZTNxWGlIMVE0RFhqQkNs?=
 =?utf-8?B?TGVxY3R6QVlFQzJRZGFLZjFidWtXYkRGR0l0REdEWUkwZGtlWTNhbjhwUFNR?=
 =?utf-8?B?YUNsVWhpZUdreUFGN0Nybi9xZ0NjUkRNY0VlSEJKUmZQRFBNaW5oYnlHWkNI?=
 =?utf-8?B?UW1TMzVWVmdHUHh1U3FmcURienBpR1ZmZU0wMytpazhyQ0h2ZnhqS3lRL21i?=
 =?utf-8?B?K2JGUmt2WUpEY29KK2c5dkt4YU5ieS9zeVV5QjFzeWEvL09oL3NBQnZ0MTJJ?=
 =?utf-8?B?N0pOQVRmT3l1OFA4VUVpdnRqZGNCcUZNQUpQL25pSGtYcWJodXZMbmp4NGlZ?=
 =?utf-8?B?ZUtzOGxpQ0pYU2ZRWmZZYStmQ0NYY1R5NjhmSDdFOEFiSU5Kb3VaOGkzc1JE?=
 =?utf-8?B?cjhCcVZESWRVNkxsMG12L2RtalZlSWJza2xkTG1QbGJNOG12NW5nd045TmJD?=
 =?utf-8?B?VnJVUk52RFc0YzQrYjY5QW14M0duR3Rpc3hwSDhLeTk2YzM5cytJajRWVWpp?=
 =?utf-8?B?eTdVMFNzREFEdnQwN0Y3V1Ixc0ZmaWxXMmxrY1I3QkJlSm90UXp3MHhJQXVJ?=
 =?utf-8?B?elo0clJpRUNDbHhUaEg2a1A1Mk5uQXExYzlwL1V5S2pFK3EvZjY2WVV5NzNZ?=
 =?utf-8?B?UGdnMWdmeENwWlVhMkVhcSt6RDg1SmtIN1NycXE3Q2ZBY3hmS3djWVJFb2Iw?=
 =?utf-8?B?TjdodDJhT0JVQUpic0hPdXQzWHROQ2NzOGdUeXB3RVlDZ0lmT0FDUWhHRllx?=
 =?utf-8?B?NHVhbjIzZGpGMFdwQjBmRDIxY1gzSzdFZ1FGRGR2OFJJOGNLOWV3MjBTZFlO?=
 =?utf-8?B?Zy84K1NzMm53OWtlV1FQWkRjQ0xrSWh5NmFiM01qRDhGSndqTnArRzVpa0x4?=
 =?utf-8?B?QkdjTW5zNFlHUk93UEtvNk9qQk1senh0SENKNVBGckFONDdhbHIyT25DeWhC?=
 =?utf-8?B?QklkanVoVVAvZDRlZzJqWDlzUVFLTkprQXZ1dkdGNGJmUitkaDh0ZEZCcUh2?=
 =?utf-8?B?TjRiNTB3SUUrMTQ3alNlRVhOaWxiNFJva0ZHTUpHQlV6a25mNUdOWk45NjVS?=
 =?utf-8?B?bC9URVVsVHBSNUF4bVYzWHQ0VW9uemF1RlUvOVY1ekRqeHFhcGxKLzV2VTE3?=
 =?utf-8?B?N3pyRTNEOWtZUnpGNlVRV2hCbFc5THJxdXMwVy9vSmFPNmZNWmJ1OUpYeE9t?=
 =?utf-8?B?T2JCVUluR29HaGV2UVAvZWljakc1RGFNZEZySjZTeHZ2T29ydXNaZjE3MkhE?=
 =?utf-8?B?SlB4ZW51b1FpSnRKQ2VQSU90MmhuNHpmV3RsM2pYZlQ3T3BlZFl1YlJBZmo2?=
 =?utf-8?B?Q3NtZ0g1anRjSjB0cHE1R1A0OVJjWjQ1V0MreHBQNjVoM21xR0QvRjdEbnlu?=
 =?utf-8?B?VFlQck9XWkZJTythTk1lZGs5TkJpNXdSOGZxVDAyZSt3SkM4bVVXYUR6RGdu?=
 =?utf-8?B?MEk1SXRZSGVxbnBjV3MvdmQ4YklzY2oxdEU4MUNyK3dWamhwL1VxWTZpQXdK?=
 =?utf-8?B?RzNKU2VNMVFxVU5uZ1pKOHpaamtFSG9sbG1GNjIzR1g4ZTdncjdmSzNKcHNk?=
 =?utf-8?Q?vFt4naCytrRjxAHXgcgodonMm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 417fd434-5965-41a9-d40d-08dd0360a4c9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 21:26:17.5052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfDGJnslO8Edgs91G9CI5kUk3aFYeHo4/jsNaYJDuxNuBD7Jxk1RcmZlZqw+jp27UTEHgOkJGs8Hr4cF1ksqTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4238

On 11/12/24 13:33, Dionna Amalie Glaze wrote:
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index cea41b8cdabe4..d7cef84750b33 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -89,7 +89,7 @@ static unsigned int nr_asids;
>>>  static unsigned long *sev_asid_bitmap;
>>>  static unsigned long *sev_reclaim_asid_bitmap;
>>>
>>> -static int snp_decommission_context(struct kvm *kvm);
>>> +static int kvm_decommission_snp_context(struct kvm *kvm);
>>
>> Why the name change? It seems like it just makes the patch a bit harder
>> to follow since there are two things going on.
>>
> 
> KVM and ccp both seem to like to name their functions starting with
> sev_ or snp_, and it's particularly hard to determine provenance.
> 
> snp_decommision_context and sev_snp_guest_decommission... which is
> from where? It's weird to me.

I guess I don't see the problem, a quick git grep -w of the name will
show you where each is. Its a static function in the file, so if
anything just changing/shortening the name to decommission_snp_context()
would be better (especially since nothing in the svm directory should
have a name that starts with kvm_).

Thanks,
Tom

> 
>> Thanks,
>> Tom
>>
> 
> 

