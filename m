Return-Path: <kvm+bounces-42988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D0E0A81D35
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 08:40:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83B803B8132
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 06:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B12E1E32D9;
	Wed,  9 Apr 2025 06:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="RnD4z9mI"
X-Original-To: kvm@vger.kernel.org
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021115.outbound.protection.outlook.com [52.101.57.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEF11DF247
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 06:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744180754; cv=fail; b=eD3J+rylp+BGxfiuxTXcx/LCPYr8mYGs1OfYA9KjIg/cpfOpx7MV+RqcQL395qtUYUtEWcMqthdBVHs2wrPD/vMnLzBvAKr5/IVu0NqrehseAOWosjqfPwPapoAxPOJiyuDCmf7RvleykCkfHoIZ8clecWueyzkAika4OcVRvGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744180754; c=relaxed/simple;
	bh=8fwa2Zprp7Jvv5ET9hM6DhoHSgU1ffULPhAiCfmgl9s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iEBKZvyBMLgehl6tS/ZPp9jms9o38yz1Jpx5L30OJajzFu0MzN93klQ2O8tILFdyBoTCGD6abPfDHNSUDVsD5QguIP2MIhIsy7WroC27OWVC/qhfaH0k1xY2eOjnyRiSJApdZlxZUJJXbTwWC6QOcvlsPd+L2c8n+biqV2YqMR4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=RnD4z9mI; arc=fail smtp.client-ip=52.101.57.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3oa/rpjoYSIQuJ0zdFQxBUHu6TQtu5iBYENM+1lbm8Q1dEh6DT5YVn/+dn/NVw7dN5rUAkoOW5cJ00J5eA4nRxWG5gl3HSCtcEFNsDW3rTwqZ9Ppkc1nfX1H0xd2pwFr9F8wCEoC1mlQJXaZtTnInekQoEwNro8PuS3y+pF5v4HWjdtHJkiJYeseLXapsQVk6DETKPBES3nVPeXXhO/4QOFKAl35t1vKy4EjYYrE3+kVL5DDRr306qpvhZ3bFxoI7Whw507JYnqPDfr3uTdN+KhjnZh5q4DMUF2zwsTS+MNRkxfBBn8nZyZysmRTakLOAwwi7J1r1wUNN0S8eLRoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UYpFXORb+/GVbn3kStZC7Gz4w/Q0hHWgUzGZWzOInQI=;
 b=TQ1Ya/THTVd6cucsAmYnIE/RwW5NMA0x93rgz+JFbeL348W4tBjBQNi0JHLyxeLq6Un5pfdosSFkzfdRGKnz7eiInHVM+oHUUJq2rEVok4bsaDBLS0Rg8RDpDafKKLvHyDZK1ysMC6crYm+QGmz0WIwI3FiIvy+G4AeIqZW2er1WBnbt8DRfaOiVmTCseR7OUXpeCdGEY2y0El7H8Dvzg46AfjyOEhmCWRDHUPKypPdQHufoFi+aBR7TWvajmZ/oZZB6/Bi0BRubZdYyJ1mMmBmON7gBb20yQVsqYD2Fc+XmXzJnOaluqdcWA8O662P0UPLB2lpX8Ky/TPWUyGmArg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYpFXORb+/GVbn3kStZC7Gz4w/Q0hHWgUzGZWzOInQI=;
 b=RnD4z9mI1NckSf5oO3t8FhmELiYm77v/42dzb8FuiivStErO7/eP149CodobNWHkNBIEGrJipbXDcRq9k0DjpE54C7c83Jud4u6MwmoVNyen4nvVgQaHMAi2vhRj5j853GaTJCcYJh86FBhNgL+YvS7YedP2dYTBNkxS9eM6i5Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SN4PR01MB7405.prod.exchangelabs.com (2603:10b6:806:1e8::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8583.46; Wed, 9 Apr 2025 06:39:10 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%4]) with mapi id 15.20.8583.041; Wed, 9 Apr 2025
 06:39:10 +0000
Message-ID: <2fd5c211-1f1a-4539-8b47-81d91bbab991@os.amperecomputing.com>
Date: Wed, 9 Apr 2025 12:09:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/17] KVM: arm64: nv: Allocate VNCR page when required
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, Eric Auger <eric.auger@redhat.com>
References: <20250408105225.4002637-1-maz@kernel.org>
 <20250408105225.4002637-3-maz@kernel.org>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20250408105225.4002637-3-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0123.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:11d::6) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SN4PR01MB7405:EE_
X-MS-Office365-Filtering-Correlation-Id: 64d96150-3cb9-4528-0e5d-08dd77313bf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VURWeXJqTU9UTjdKMkdkUTJvUlBNa2ErZ3ZrWURRSGdrZEo1UDJLU2tTUVNZ?=
 =?utf-8?B?NW5SSnFtTjBlMjJ4aHlNY2lrZW5YbzJvQUphSHB0dE1xOFlUKytLb3BXZ2t5?=
 =?utf-8?B?N0VLTU5BNHE5dS9kZ3dod2hCRUJhaG5LWk5zbXVnUHBwSlFPWmdISDIyR1RP?=
 =?utf-8?B?QjRCU2dtSVpOdDg5ZmFGOTFEQkpRL3BpV2JhcHB4MEV4L09BNmhPQlYxaTRl?=
 =?utf-8?B?ZVB2dWhyckNhSG9YTkpRT2IvTUtqcnA1OWRCYm1ZUHhRTjhld2ZBdmZKdHZq?=
 =?utf-8?B?NXI5RTJvcHI3K3daTFVZcEZsOFdMbW92SkVCWDY5MEpFNGhMZjFtMllvTkJP?=
 =?utf-8?B?dGhOeU9NS3UybFJsRHBDS3hSaDNwclh6MnhqY1RCZGNPSmdZdUJobE53MU9E?=
 =?utf-8?B?UEZpTEcxWHFpTytxMlJkbGxNZ215c0R0bHJCZFJZQTNaL1QraWl1bStCelM3?=
 =?utf-8?B?bUEvc1VnNmJNSXM1VE92bDF3RFlNQnB2UTdCVVpGSmRvTWw4eUhEalQwNkdZ?=
 =?utf-8?B?bDJsSXlWSDhCVE5XRmNlMVZ3Um16L0xSZERLbGkyZDdOdThLcmJDMFdtenVE?=
 =?utf-8?B?OHNRVnlYb2hZbkN4OEdoQWtvVlBzZFpVTkVKZG9tRmdDNUlVSWFRNmdqbFI5?=
 =?utf-8?B?cFduMWZYTGpHTFNTQ1YwT3VmYUdXbVJiTldjNFU2SnVPbU9lZ3hCcHdLZWJG?=
 =?utf-8?B?aVNCKzJJbjZ3THJOQ2VhN2dFbDRKNklVc2c4aWY1N0owWlpYRG5qTysyckIz?=
 =?utf-8?B?OUFXTnM4OTBqUnRNaUluQ2RvbDY0c29ZUFhUalZaZTlpZGVRQnFDaVI1eSsv?=
 =?utf-8?B?TkU3RjV2cXd2ZHVNS2ExTjU4UHVRNkFqR3ZlRklkV2xqMnNXZVg4YzI3aWxt?=
 =?utf-8?B?SEZwcGVjcUI3OUp5YWtJUzVZbk5JRnBnY2pMekF0KzlkOHdRS2pYck5tc2li?=
 =?utf-8?B?cUtZSSt2ZHBBMW5oZ3E2NEZHcmJWbnRrV2pvL1FxRjVJWi85Q29NbUl5Y21L?=
 =?utf-8?B?SWJTSktHaHNiNHFlbkdocnNaRXJiRnJlaGh4UitpN0Fidk9TRGkzcWN6MDJ1?=
 =?utf-8?B?aUVMSWtmMmIxNGxIcWdnZDdSWGFudTI2a1QxVldTNERiOE13Z2tjSHBRK21E?=
 =?utf-8?B?dEFBWlpjMXNIM05JL2hLZVJNR0pTd0N2NCs3a2NMZk40RVlENlhHZ0syVjNn?=
 =?utf-8?B?eE1MaU9Bb0RLaUZOb3ZBbWQ5bWg4dURtcGhvcnZUSWlzR1VHcGhjQVQ2UGtF?=
 =?utf-8?B?UUFHaExOY0FuS2JXaDNpbzNVWnF2S3F2ekdlQ1JPZFN0MW5IeEw4akQwWk8z?=
 =?utf-8?B?a3ExVGJnbVJraTNNYlBVbE9TdURaYVhIRWNmL3dRbCtsSGZHZUtiUEUrSVFM?=
 =?utf-8?B?cUI0TXVDTDFrMHdRS2p2c2w5bkwvclpsM0o4aStsZGJMMHJ0enRMVDdxSFZI?=
 =?utf-8?B?RkY3M1RJejNyNEYra1ZvVjFzZUhocEpOVWlhNkw2dDJzRVZSVVBGYXZOWThB?=
 =?utf-8?B?VUtZTXZmVm9XdFRhVGtlYStFK3lGMU1SSjJycHRqbVF1Nm5MSUdjVVFwaWk1?=
 =?utf-8?B?eXBNZ00xbmpoRHlvUjd1bkRjT1hRaEJvNEhvMjgrdm5TUUhrMUF5bWFPMUlm?=
 =?utf-8?B?L1JZME9XWlBFS3FFeHNFRzExZ1FaOHpaelZqOXA3MG9wVmRTeWY5VGNhd05p?=
 =?utf-8?B?aEorM0J4WUhDcXl5Rk96YmpPaU50aGM4T0tSYlFIeEFmRlhmeHJJdGxlNzBs?=
 =?utf-8?B?TGV2UWprYnhCVXV3YkVhc3ZBRGMycElqTkk1YUxkeitNU2lJdmxiSjloSmhm?=
 =?utf-8?B?c3dyK3lhbU5RT0dYQW0rN1NnYXcvR0lCYTU4YWxEMUdPTWJ6Mzc3SThLcVp3?=
 =?utf-8?Q?SaHVPCvvERQHj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTYva3puUU5NM01FOXgyQnB2ZkFEaGtrZ0dhbG9Ca1NONTNPSWxoQ1BkK1cr?=
 =?utf-8?B?ZDBIMFF1M3o1cHFMVFZFQzVyQmRFRTJ6Zyt0RnN4MHdUUUV1RTRHSHk4Zmxv?=
 =?utf-8?B?eGorb3F3bjFWY3B3UTZXdzl2aHQ2VkdxZ1U3cFBNK243WGs4YnhiYTNXRFJ4?=
 =?utf-8?B?VGN4Rnk2dkx2bXVSSjlYay96b1NRMnlpNkcxWlF6bTNFaDQ2MnQ0ckFVRktw?=
 =?utf-8?B?N0txdUEyNHdwdWdlN1dIV0EvQkR5Skk0eXEwNnZwQnZmVGpGWUtLeFIvUU82?=
 =?utf-8?B?SlVURjMxY2VyeWJpano5aEE3K21IWmd6S3FXaXJwL0ZVenY0UDJSQjQ4NXpC?=
 =?utf-8?B?ZW9tOCtVWjJGUWNLZXErWGwyTzhnczZGV0YvazMvQkliaU1YbC9KUVZhT3Z2?=
 =?utf-8?B?aHE5aWpaOFNiUWdjcXRtdHgzdEh6QlJxOFZaQmcwd3Z0eUFOTDdmTkhpWTFU?=
 =?utf-8?B?UVBIYjNlVGlobVJSenduRGlyczI3MnlGdldvK0F0WjdGN1k0aGJ4OFY1ajJv?=
 =?utf-8?B?ZXJmdTFzMGtaZlBIa3UwalZleXpodW5hZDRvS213UzQyZjFacjZibDBYYlVk?=
 =?utf-8?B?L2VZMVZ1VkZRdE9pRGVzWUxzamwvSEVUbXlRR0xEQ1BXZzJPcy9VZ2NLSi9O?=
 =?utf-8?B?UUROa2FIQmx3bWdpTU04QXdkWTB1N2VreE0wTXRXVEhXdDJjaHAzdUlxMkZI?=
 =?utf-8?B?dmFtVGVLY2cxakNIaXpkWmtqYVBQS1NtdXd0V2lBMExLWm1YRmg5cStCU3dW?=
 =?utf-8?B?NHFCUGZxUktSbU9NWnNJbHJQMEs4MUc1RTR5U3FXZ29xVk1IejQ0TzdKUTlB?=
 =?utf-8?B?MlNDOE5nMXp6YTQwOThMb0dlS1pWYU9tTnkramxOaFRRaW9uekRaWUlkVUlj?=
 =?utf-8?B?VUZIOVlnVkVoOW9kNGVac0FwMmVkamx0QVYrMkNONmg0MG5ZYmFLamNYSnp4?=
 =?utf-8?B?SEQ4TnZHeFpXM0k1Mm9wSlFMMm4wZEJGeTB1MjNPK1VlRFNzTjIzdnRYM0I2?=
 =?utf-8?B?RmJZM1pFWWVXQjhSZDBxWTJIdWI3bFVablEwSVlYeERndHFoVzhnV3MyWUdT?=
 =?utf-8?B?aDF0TXlSOW1Ld0J5ZnFaTk51aEFDeTJXZDlaOGhuWEV6YkswdEo0d0pyL0ln?=
 =?utf-8?B?MUpRSlU0Qk9ibGxRcFBJcElvS0RjRWN0Wm9LVyttemwzRkJ4K3hQd2RjcTFZ?=
 =?utf-8?B?aGJ3UTEwc3RwUXZuSmdwWTdBL1dvZC9UN25UaUJvNXNNaUFvb21EQTFZVksy?=
 =?utf-8?B?TWdLUkF5NHpTTzI5ckl4TFFqVTBFa3Q4RW9vZGM5ek5qcy9QNGp6TmhXS25P?=
 =?utf-8?B?U0VEM1FSdGpkbWdnUXFNbE9MWW0waVJ0S1BoWXRKZ2orKzZKNENva2oxeFY2?=
 =?utf-8?B?dk90bXpYaTMzc0ZoajRHSzlJQllzWEI3RE1LOElGV3VaK2x1UnBvTUY5cVI5?=
 =?utf-8?B?SHF3ck82eGJmTVNEQ3A3V0toZjJlTFl5dnVBZStMd25XRURzcDUvdi81V3RV?=
 =?utf-8?B?SjBPaHZ5U1VTd0tyMGJ4bG1FcDR1TENaU2tXaDVOaktOdUMzdG50YS93TmMy?=
 =?utf-8?B?N2RqaG9PMmFzanAyVjlnTGpNbWdzeG9kMGxRaGhmWkMzSEE4VVV3NnEwZ3Iy?=
 =?utf-8?B?bTBYV3I5MFhyM1JyVUI5ZGRCK08weVNEaGxQUkZyaUNEZlZENml0TWhBeDlZ?=
 =?utf-8?B?M2N0M0NVMG5xRWxaNEdGVGVBaGNaQ0hPV29hbEo2WDRiREp1VWdPdHR2MlBj?=
 =?utf-8?B?VFNNUWVwTkFMNGN1TGZqY3VuTWxqS25OUzdTSklzL2tmbDQyeTlGK2FLRFRF?=
 =?utf-8?B?SmNPNDdqLy9NMENtcitxMHRiR2hJMTdMRXRGOEV0bTNUZURLa2RqdGxLNGQ1?=
 =?utf-8?B?OG5BS3pka2V5aFdKRnpxb2EwVGVFWVNkd0l1NHY1NkpKcUFZd2hWeG14UHkv?=
 =?utf-8?B?NzNvZ1RtZzlsSFE5MzN4TnU2SU4vaWFkSWFJSW55eEd5YmlYTWo5NjBMNkE0?=
 =?utf-8?B?QmZKekRXeC9UKzhDNU5qVHo3ZEw1WExmU1lqaW1KK1hiUklGYytza3NPKzdF?=
 =?utf-8?B?Q09HcVZVMGFMcitjUDlLNk45SmFrN1JRWDdoOU45Njg2T1o5bVlpSjk1VUIy?=
 =?utf-8?B?K3lwTTN1U1YrYS94d243enR2cEI4Y3ZCdzdubEdkZDdyeWNwd3cveW15MmJx?=
 =?utf-8?Q?wzssMeMtwQKOuSY4A6CThR9RHe21z5qUycG03r3/TmVc?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64d96150-3cb9-4528-0e5d-08dd77313bf1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 06:39:10.2118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TOPfxNjdQhMmBv6OmlLpxoKu4nbHiorOR61h+jnL62tdyLXIYOdJfQ7cWa3bETOXx7Vj4nkfItGsO2BBM1FX+dNYJeLWufI9R/pRzkx2KqMuk0xQOGmny23mGOouWlm+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR01MB7405



On 08-04-2025 04:22 pm, Marc Zyngier wrote:
> If running a NV guest on an ARMv8.4-NV capable system, let's
> allocate an additional page that will be used by the hypervisor
> to fulfill system register accesses.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/kvm/nested.c | 9 +++++++++
>   arch/arm64/kvm/reset.c  | 1 +
>   2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 4a3fc11f7ecf3..884b3e25795c4 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -55,6 +55,12 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>   	    !cpus_have_final_cap(ARM64_HAS_HCR_NV1))
>   		return -EINVAL;
>   
> +	if (!vcpu->arch.ctxt.vncr_array)
> +		vcpu->arch.ctxt.vncr_array = (u64 *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> +
> +	if (!vcpu->arch.ctxt.vncr_array)
> +		return -ENOMEM;
> +
>   	/*
>   	 * Let's treat memory allocation failures as benign: If we fail to
>   	 * allocate anything, return an error and keep the allocated array
> @@ -85,6 +91,9 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
>   		for (int i = kvm->arch.nested_mmus_size; i < num_mmus; i++)
>   			kvm_free_stage2_pgd(&kvm->arch.nested_mmus[i]);
>   
> +		free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
> +		vcpu->arch.ctxt.vncr_array = NULL;
> +
>   		return ret;
>   	}
>   
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index f82fcc614e136..965e1429b9f6e 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -158,6 +158,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>   	if (sve_state)
>   		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
>   	kfree(sve_state);
> +	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>   	kfree(vcpu->arch.ccsidr);
>   }
>   

Please feel free to add.
Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>

-- 
Thanks,
Ganapat/GK


