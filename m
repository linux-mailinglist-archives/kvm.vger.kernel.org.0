Return-Path: <kvm+bounces-33453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB169EBBEC
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 22:32:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BE11188A6EA
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 21:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7622E232399;
	Tue, 10 Dec 2024 21:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cZ4zuRqQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACEE22FAC2;
	Tue, 10 Dec 2024 21:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733866335; cv=fail; b=uAnpm5wHgGRwrJi4umEAm8w/EzEUmvI0NUJU34eRnBSq9tL0DvXvCCyio/CYF511/KQYzqTRu7CbP/nLaMYbL9nCcRYk6uKiaQ0RWgzxECeEJL62kUTLDke7K+J465k5HCDK+oK0AzlrchYCPGRr/fHtcDhcSZFaIP65AyEAJhg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733866335; c=relaxed/simple;
	bh=US+4VktgFPRB90UhaUkfSO+12TUA3Js15EhL+4a9Tt0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E0ypJ2tWvuaPYI7ccFAKm/eG9HVAIAG4svM4/kqyq5gvZQ0nsz2wIs7+5hWtZUCWpiFXql+5qvH3E1vjbVsO/YLX4FNn+m6+XM/aso15C5cHqd/M1MrWalKKaanxmHXKpJmXLLBPbUKw5MD1LAibcgV7E6rKpCIs1GlNMbkOErs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cZ4zuRqQ; arc=fail smtp.client-ip=40.107.236.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YkYBN2zX54Ny1CIyYpxZrGgBu/37T5Gjgqum9sFrbAPe0q58CQpzWEZINuWnplB6NeGMzGv9e224aSE0LFK+FKvZ/akwfMMyd/UFSYMJRxw7YzZ6dR05b4RBQnDsUpLbTIZWrwzWfTCWqXkfERnAp/UlEN9WK4Fgc/bgoYPrPumWkb5hw0lmLFppAZt/unWptnubu3c8K2ldhEP2eSeFZLcT9NgQIDMW0+jpqqrFSQoluHvuInErqXRWhM9k4f5NmmZXYx/oIJUQd9xDuWkWA+cYFxFJMpoZuzmQcLbKJ4N1OdmpiM2Ve/Ds45s1AcwHfGoRw5QJVm0fh0QHGU6ouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lozE8UzRQKxDYlJDifxMd3euCb+ZRUlzmTEROPhAkQA=;
 b=P5kbIW0sRw/RcdVhnyylOcW+kho7R+N8AwHqK0YcjcgkFu0UkqRIdgmcR38ED1myHMfxCBq/h6JXfKrekN+XAzX7OOAuW8Zz6bV9wTywfaGAmcvb8wnh11hpkZQm+KTNhYCh6HFKf48DIpDXB2UP9utm9QSNOqfoitGwD/eqJUHDe+QvDwX+dFdGgZRADLZLwq8ab5kRbchsFSLTdKdi1EfldaiBPmpe4ZeV76tb1DvL3eCtvT6AlCTUWhJOd9N0W1jVTbvd1fOqj5HeBpfXOVJ6+AFEMTukAtH/GqjXUK+L1hNV+Qr4Bb/SrN+w3M+anUAJhb5pgBzAzWKvZo2LCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lozE8UzRQKxDYlJDifxMd3euCb+ZRUlzmTEROPhAkQA=;
 b=cZ4zuRqQqaHPYCfy5xnAxElSYvdh0Vx14ts6KKdzlBnMY3blMv3AJP7hoUrIF1CFa7GfRun3F9o1nkQPormTIOv59LauqdQsO4peeT3vddQPJcDvb6tTiS7IhBtv2E8nERH53J5HBClwWGevqsRz6nFKVZF+0WLGm18bUYDdNVQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA0PR12MB9010.namprd12.prod.outlook.com (2603:10b6:208:48e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.14; Tue, 10 Dec
 2024 21:32:07 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%7]) with mapi id 15.20.8230.016; Tue, 10 Dec 2024
 21:32:07 +0000
Message-ID: <0a468f32-c586-4cfc-a606-89ab5c3e77c2@amd.com>
Date: Tue, 10 Dec 2024 15:32:05 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] x86/sev: Add SEV-SNP CipherTextHiding support
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au,
 x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <1e43dade-3fa7-4668-8fd8-01875ef91c2b@amd.com>
 <Zz5aZlDbKBr6oTMY@google.com> <d3e78d92-29f0-4f56-a1fe-f8131cbc2555@amd.com>
 <d3de477d-c9bc-40b9-b7db-d155e492981a@amd.com> <Zz9mIBdNpJUFpkXv@google.com>
 <cb62940c-b2f7-0f3e-1710-61b92cc375e5@amd.com> <Zz9w67Ajxb-KQFZZ@google.com>
 <7ea2b3e8-56b7-418f-8551-b905bf10fecb@amd.com> <Z1N7ELGfR6eTuO6D@google.com>
 <5b77d19d-3f34-46d7-b307-738643504cd5@amd.com> <Z1eZmXmC9oZ5RyPc@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z1eZmXmC9oZ5RyPc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0178.namprd13.prod.outlook.com
 (2603:10b6:806:28::33) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA0PR12MB9010:EE_
X-MS-Office365-Filtering-Correlation-Id: bef2bafd-4234-4562-3924-08dd196218cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZExQalJ3NzlaTUVrU2Njek9TTXJkYzd6VW9pdHNFSHFGTk1XanBnZXpoYWhs?=
 =?utf-8?B?OCsweGRuZ1RuemRSWndBa3p5eGs1S1dsS3ZXOGFSTm1yMlVtWUUwbUlRTFUr?=
 =?utf-8?B?eUcwN0I3bHYrTG5tSk1TT3UvdVcwdStuSjZKemJoTmZmS3pucWpCVEZvMmpE?=
 =?utf-8?B?NDhhNUg3dGw3dU44bTJoeUh1OTZpL1REcVhkd2h6bkVCVzBnNmI3UVpRNVR4?=
 =?utf-8?B?MG5CdzE5Z1hBai9MZjVPcEVrdDBLL0xJK05scmE3c0lvVE0rTHhUY2JCbkx2?=
 =?utf-8?B?Wm1MNzA1eGRkMlJYdEJwd2QyclJaUE1DaTNlZUFVQW9FL1hsZHJ4TDd0TDRm?=
 =?utf-8?B?bThRd0lLbEh1WTVUa0dSdHpWRmp6SFh0ZnZlcnFURVhpc0lYZ2dGQjlMMy9u?=
 =?utf-8?B?ZGhPanhFZlhGZnM1dmIrZUZRaVBKRWczZHRONzVYV0gwbUYvdG81Wmx0cHV5?=
 =?utf-8?B?WE9UbGlCQTg1YlM5QUlvSWVENy9ONEpJaWJ4bjlVZ0hKRUdySmNCMEdUYUha?=
 =?utf-8?B?Z2NYSmg0N3JtYnRGekh5R0tlN29rOHU3dDJiWUdvNllZZkRWWTF3K1pHeEZS?=
 =?utf-8?B?YUNKV2s3OTN4Zy9WcnVQdWxONUpRQTBRUTdBb2NOam1xdWJneXF2djJnZmxE?=
 =?utf-8?B?S2VSaVR1NXp2SlhYeGEyOVJLOUxIUDZYREhNdHdaZWdJRTVaVktJa1R3dURh?=
 =?utf-8?B?V3c5dlVka3ZSa2VKU1dZREtrS1FWRWdWNnpQMWdGeHZMQ21EZ1JhcFlXZTlS?=
 =?utf-8?B?VmErdEN6b0g1YjR3VlphNEd6OEloWjRIUDZXb25vWnpGckdBVGc4SXNwNkZZ?=
 =?utf-8?B?SFN2SlY1SkoyaFBCYk91dFdib1JrNEZVeHJKUzlZQ3lSSUNMdmxEUm9FV0Nn?=
 =?utf-8?B?UmF1VTJ5UzJFbjVvWW9XNEd0RElEbElYRzd1YWFYamhaV1BOZWJUcUJJbzNZ?=
 =?utf-8?B?b1F5NnlRMXBtS20wK1pGdUhDcnduRmNDS2NBWGhvMmx0aTQ3a01FbENEWDlC?=
 =?utf-8?B?UHRXdXpmaVY0WFVFZENETTJXM091V0lZZkFYK1pYMFdHSGdDOHNGUzRrN0hu?=
 =?utf-8?B?Ym5oV1dpS0VFWVo0VHhpaE5Qd2xjNTRjR0llQXNGaEJnRE94bnhMTkZScE1S?=
 =?utf-8?B?VDdxK0s2QWdsamdQakdMT2dxNFpTU0VjamhocUZ5L3pwQXZXRm5hS1JvVVgr?=
 =?utf-8?B?M3h0Q3RWcnQzSGVhRldSZmN0K2daMHpLRVJMZjBnbWt3TVBWSXQvY2FUN24w?=
 =?utf-8?B?Z0ZKaVNWckNGNGlzRWdpYmFQd0RMTk9zb1FCTnNOSFhXOXl1Z2E3cmh1U2ND?=
 =?utf-8?B?MDJETWREQXArN3V6MlRNaGYvMHdpL0V3Q1VRdTRwdGUwSW1XMFNLVERaREtt?=
 =?utf-8?B?Z0JsQXEyUlVLQTVMTktUVUxGelRwTUt0S3NZeS9rZlBOazhxVXBIRHpKMWFR?=
 =?utf-8?B?a3U0Q2c4a1MwSXBncjQ5M2RCTGgwNzJGK01lY1JReWR5OGJhNS9JWUdPZlBt?=
 =?utf-8?B?VEF5U2t4STI1K1RIaHVIT1pzVmZKSEFMMGFYWHZ4UzdJZW56YXFGZU1NUll3?=
 =?utf-8?B?aXJJTDBuWGwra1hjS0JKb2FGa2NVREVTV1BLZVFId2pCWFR4aXA5bm1XQ0FD?=
 =?utf-8?B?YTFVVlVoaE5iMFB2TXhJZDZMTkZiR1AwTVl2ekY4S1JZdExGT0U1bUJhL292?=
 =?utf-8?B?QmxUUVhkUkFhZnhWNmJyRklxa09lZlFsdEFmd0ZNcFRrSGlTQXpMenFkOERB?=
 =?utf-8?B?bEdNVWJsTkRaclJaSDQzUjl5SG5mazdhU3c5c3Z3Q3piMG9nNFY1TWw4SGx4?=
 =?utf-8?B?YTNFSFdDNlE0T3NuNm1JZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVNSZ0svaWJpSm9mT2FhVHRnUXJrSFZvVEVNSGlxK3cvSndEMHBPeDEvUEhs?=
 =?utf-8?B?ZlJXRGtEWFVqOUw4VTBFVnlIVkdaRnhWM2cxUGZUN3cvZFdmb0EvcnkrZWhk?=
 =?utf-8?B?cHdnc3BLTlhmeW4yN2Vzd2pWV211NEJYSWg0YUxXYTBUVVA0QkI2dzlRZHVO?=
 =?utf-8?B?OWlhSk8wcGloK1BTYlFJcW9yZFNvanJyZS9FS3FOSndLNGVRZ2xvdUFYU2Fa?=
 =?utf-8?B?TmZHQjdyUHM1dHFybzBZMHh4VHZtY3ZzbEVGMjlGZ3l5RnJGLzZuRFc1VmVP?=
 =?utf-8?B?WXdoUnA3c2thQmc3bjBmalRoYk9nM2wyNkZzSk82YU4vQldDRm1tTDh6NWFp?=
 =?utf-8?B?Yndhd1Y3NXA1eWVCOFZ1eVdIQlZFVlUxamxVM3RQVEdCVEpMTkZvUGtzYTdn?=
 =?utf-8?B?bTBMSFNDZ3o3VzRKVEhiWEYwclphQUFjeVpXbHRMMDF4aEc2SGhaWjFxaFJy?=
 =?utf-8?B?V1FJTUIxNXN0S0s5VkZMWW9vazFTQkw2TjNMSXVDaHpLcnFkaENOemx1bXVv?=
 =?utf-8?B?NDk0RlBaK1VucTlZdTZ2RUwvVzJuQW9nUm9JYmlNbDcwNnZVNy80aVlSeG0v?=
 =?utf-8?B?NTYzYkl4MlN3MTZEK3I1QlUvWjBYWGJlcmtKOUN6c2xQUENieUlpWjZmcVNN?=
 =?utf-8?B?SzFpTGNaWlNEQ1RQUzJNaTRMeGFEV0t4ankzL0tRS0lwMlJmRzY5eVE2VnNq?=
 =?utf-8?B?Yy9TYjdudks1eXpjTm84Y0c5a0hVYkhIZnFseEcweDZTT1VoQ05YS2l2RTRU?=
 =?utf-8?B?ZUJSVnBLY0JOVXVpamJJdUdUSWpYM0pZUjFIVkt0YndwTlhlVmE1bkVMUlh3?=
 =?utf-8?B?VHRYeElqajBST0xTSHlwdVY0MUdDNmIxbVJqaGx6Rk5adjJwUVhMNkU5T1E4?=
 =?utf-8?B?MW5GZXQ3YWwvekFQT3FSZ2RaL3lvQzFXMnFRNzdKaGV5MnBBVEcwYjc1RmNV?=
 =?utf-8?B?QWhwSk5nVUlnazN4bnhsNlMxYUIyemVmMVA0YzZuSFZFTEVNUENwMnphaGpi?=
 =?utf-8?B?WHNIWWJrSkcvWlpTcm9aSFRrMEVBRmtxek5RckQzd3AwOXFXQzNVdXp0QytH?=
 =?utf-8?B?dEhzZ3dzczFkWXZWbTJRMG16dHZscC9lWENzUmxLajM3eW5HSTdjdzVGWTlH?=
 =?utf-8?B?eW5GUDg3WWVLajd1MGtOUG5vK1IrL2dSRHFhenpnNVg4NGtMOS9nbXpSNlZW?=
 =?utf-8?B?UFhJdTdRUC9MY3packVMK0ora3BMOUloUGdrNXZpYzZSai9YNGRMVVJhNE1X?=
 =?utf-8?B?N0hwcnE5SmhJaE1XZVJ2MHhzZHlmb3llZW5RckF1aGNvdTRodU9DbGhaZFJU?=
 =?utf-8?B?Z1VERzJqbFNmWjZQSmJUZ0hxZjRScXJxSmMvU2Y3d2dGZlN2Y1BBUjdteC9w?=
 =?utf-8?B?N1M3MGdKSW52SnRoQ0NTc3dlMi9UT25ZQ2FyTHFmNmgxZEFsZ0ZhZFVxRmR2?=
 =?utf-8?B?LzBGM1dVeWc3QUNDUkhRZEorQ1hkbmpCK2J1NGR2dllTdlBpNnV3UExWSENT?=
 =?utf-8?B?VEo4WmpFSHVDZjYwYXpUNi9BWkdXVEJ2OTlOeXp3bVdwTVV5ODFoU0R4akNQ?=
 =?utf-8?B?MjRCMVJIUjFBNVZXSFYxWlpkNDZzaUZHaWpwdGFIQTFXN0hmbE1JYVNnZFNx?=
 =?utf-8?B?aWhLRnRqRnZlUWIzYjhkZ044MjNmOE9ScHFhNzczazUrdHB2VlJ0ZlpyNGZo?=
 =?utf-8?B?SHpxMVZjcG15bGJtZUo1MGNGakdwdmJhMkdzUHF4em1wU3dpN0lBMVF3dFEw?=
 =?utf-8?B?eFlyRE5JUWprR1RpSHNGcDN6QktMTnZUU3AzZlVxbENqT01HWUtydnRXNHJn?=
 =?utf-8?B?WUVKRXBRMHE1ZzFadnovazJRN002dGhUSi8xR3RmS2JUanh1TEc4L0RPc3kv?=
 =?utf-8?B?MnNXWnN0RVBwQnc0SUxBN05vZjZTZ0VKb3BCL28vV0xFcFcwSEdrdzMxTVBj?=
 =?utf-8?B?cFJvdEF4Ujhselc4aXRzYWpFTy9lK0hrbmhyYk9adko5MkRReUZwMTFtc1o1?=
 =?utf-8?B?Y0M1WmhCdEs2eDBkWHNjN2M0aHVvQ2FkTU1kYk8zSkVHZG9haTQ3RVhGT08y?=
 =?utf-8?B?WXdNYnBLUEdKWThzdVc1KzdKV0hSdVYvUk5EYzl6WGppZ3VuZnFySUVaZ0lR?=
 =?utf-8?Q?kA1O2giQp9/b9lTkKiyJOgo4f?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef2bafd-4234-4562-3924-08dd196218cd
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 21:32:07.2260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKaxS6ijCp0jMi+RoRGyCh/iP64uO7qhkZPaQ2cmelPYWWKBvEdpLYNZNo9IvkIbDCmnWDVgtPhmW1hmaAIS/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB9010

Hello Sean,

On 12/9/2024 7:30 PM, Sean Christopherson wrote:
> On Fri, Dec 06, 2024, Ashish Kalra wrote:
>> On 12/6/2024 4:30 PM, Sean Christopherson wrote:
>>>> This can reuse the current support (in KVM) to do SEV INIT implicitly when
>>>> the first SEV VM is run: sev_guest_init() -> sev_platform_init() 
>>>
>>> I don't love the implicit behavior, but assuming hotloading firmware can't be done
>>> after SEV_CMD_INIT{_EX}, that does seem like the least awful solution.
>>>
>>> To summarize, if the above assumptions hold:
>>>
>>>  1. Initialize SNP when kvm-amd.ko is loaded.
>>>  2. Define CipherTextHiding and ASID params kvm-amd.ko.
>>>  3. Initialize SEV+ at first use.
>>
>> Yes, the above summary is correct except for (3).
> 
> Heh, that wasn't a statement of fast, it was a suggestion for a possible
> implementation.
> 
>> The initial set of patches will initialize SNP and SEV both at kvm-amd.ko module load,
>> similar to PSP module load/probe time.
> 
> Why?  If SEV+ is initialized at kvm-amd.ko load, doesn't that prevent firmware
> hotloading?

Yes it does, i was thinking of fixing it as part of a series on top of these patches
to support SEV firmware hotloading.

> 
>> For backward compatibility, the PSP module parameter psp_init_on_probe will still be
>> supported, i believe it is used for INIT_EX support.
> 
> Again, why?  If the only use of psp_init_on_probe is to _disable_ that behavior,
> and we make the code never init-on-probe, then the param is unnecessary, no?

Yes, it makes sense to remove this param.

> 
>>> Just to triple check: that will allow firmware hotloading even if kvm-amd.ko is
>>> built-in, correct?  I.e. doesn't requires deferring kvm-amd.ko load until after
>>> firmware hotloading.
>>
>> Yes, this should work, for supporting firmware hotloading, the PSP driver's
>> psp_init_on_probe parameter will need to be set to false, which will ensure
>> that SEV INIT is not done during SEV/SNP platform initialization at KVM module
>> probe time and instead it will be done implicitly at first SEV/SEV-ES VM launch.
> 
> Please no.  I really, really don't want gunk like this in KVM:
> 
> 	init_args.probe = false;
> 	ret = sev_platform_init(&init_args);
> 
> That's inscrutable without a verbose comment, and all kinds of ugly.  Why can't
> we simply separate SNP initialization from SEV+ initialization?

Yes we can do that, by default KVM module load time will only do SNP initialization,
and then we will do SEV initialization if a SEV VM is being launched.

This will remove the probe parameter from init_args above, but will need to add another
parameter like VM type to specify if SNP or SEV initialization is to be performed with
the sev_platform_init() call.

Will work on re-posting my series with SNP initialization separated from SEV
initialization.

Thanks,
Ashish


