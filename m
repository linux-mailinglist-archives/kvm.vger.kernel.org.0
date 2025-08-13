Return-Path: <kvm+bounces-54579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0A22B24699
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 12:06:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AFF288570B
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 10:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B512F28E8;
	Wed, 13 Aug 2025 09:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sMxoDY2E"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3F62F1FFD;
	Wed, 13 Aug 2025 09:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755079149; cv=fail; b=Sa3b2238R4pw+e2iQ0gpG3tG6+9OPQd2sLYQ5fncLHgpZzkkmF0jecCRV5aJAQoUIYpwBE37CSGaEJPyzanSsm6HYw5e/gYarTiKh0FIYJ9L54zf7/latr4AX6+7JWf9FbtN32f2CK5uU+7yb13MTq52r/BOHCvXzO7bosea4kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755079149; c=relaxed/simple;
	bh=wbQfibRBiVijAa0IfFKX0GkQpoEzhGQLreu3qsZN338=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IDOpGkFj5fqyMRzZYa6ZT44e3ya2Ps7UX9ikM54YlRsdmYI4PnhWgB6dPvvJ3NxUnkgRdtuPxXM2s6eHc4fdX2rUAPr+NwG9HMGWoe/EVKHlDEI8u5H393G1fiILGh7eCM06u+mdHIEhSVILEBadBJBxslY0EFUnTzg4DzwlsAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sMxoDY2E; arc=fail smtp.client-ip=40.107.243.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DvnnLKPtxlmmBwmA5wAHU5zkb23a5z6Fjw/FXR7JszDHEMy6H3g1e4iY93YQcKSRj1dazzdxo4refWJ94VpgvFgNadF5RrIYNlj5RvayK3UR46Td0SsrZWmDRHcorfHzYZYovqhojt9MmmTRTcGGy2s2fGhI+pAFXJzA9MnpWDf/0ah3+GmUeVUrrigLQajmSIU9HxhlXS7KoI+pj2AwHv4TORrvBrBAzWSK1xpCI7sB64Cc6+OIceAsIHbHBAc2Epf2ea/3NpX1Kt1ZWZ22Ckn71394kBOjIvfItr7m/DDw5qUANViP90Q39hLqYR+JBk4zQYJ6DWq0d6em5FCQnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2wbgiGbYVin77ZfRYhxJDSLw3Gr19rQCepn6RulWRH4=;
 b=P5T1a5ysL76sB4cy7T778ikMrywr0u0l5XfbtGV70PD7wh7Ss48v8DRF88DuFzcCoclHucuHC4kt6W8MnVMhn2N5PdoSQHfrbKbKbBCOPwmnEGuIyA0N9LEnjwTrTn7quPrIfvm6SAIdM5e0nFCmlkK2r54eMNQ28bijIrIvHiZIwls/t+G43zKPrFatMVLzvji9I6s+dwyGFgksHo8lCCdGVoo3/dTQLk+RXt4kNnuYkr5cjdMZ9hangHJvPLz71ForW6UzsgP3Fi4n/Yf143Z+TW8yfaKGoxRKCdVxKGIi1QbFHHZrJughqN54B7EM4EFc/v1NPNC/u6hdYqWf1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wbgiGbYVin77ZfRYhxJDSLw3Gr19rQCepn6RulWRH4=;
 b=sMxoDY2EeJJkChYQq8q5v6CKBbwIH10qSypy5PO4/0XKuGtu6BpTTVf5nes86hyjjo4XbZWiEOmrGAYn2/eN0jUfovsKM3Gq8R04Zat3PSqvJEBGkovXsqpEizQL6H4lVPyNg8/bqXBMlxq5tsGoytDE1LkMkFdK1zHz9BC4C54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by MW3PR12MB4458.namprd12.prod.outlook.com (2603:10b6:303:5d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Wed, 13 Aug
 2025 09:59:05 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.9009.021; Wed, 13 Aug 2025
 09:59:05 +0000
Message-ID: <dac108d6-ad4a-4447-a67c-91600a5b8a9c@amd.com>
Date: Wed, 13 Aug 2025 15:28:50 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 15/44] KVM: SVM: Check pmu->version, not enable_pmu,
 when getting PMC MSRs
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao
 <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Kan Liang <kan.liang@linux.intel.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Mingwei Zhang <mizhang@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250806195706.1650976-1-seanjc@google.com>
 <20250806195706.1650976-16-seanjc@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250806195706.1650976-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0016.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::29) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|MW3PR12MB4458:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ec0fc45-dd37-4878-337a-08ddda50098c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXdXMFFmZ2pMOWtlclJnVHVNK0g5RWNCbDF6bWNWbEttcDJBRXo2cVlPL21k?=
 =?utf-8?B?RFRuMTJNWi9mQ2RQSEl1VmVqbjRUazhXbS9qVytVSGpmb2ZuSW1ER0srQWpD?=
 =?utf-8?B?azVOUkYxTThUdDk5YWliNG1qZkkwODd5WXkzdC9OZkdoR0JUTkRlQ3R0Wk1X?=
 =?utf-8?B?b1ZKdGxPdS9taTR0aU1VNVFiRFV0aU5raW5SMlZKQW5OZ21mN1ZBVHNzRUxk?=
 =?utf-8?B?SlpuUVFxc2hsNTRSZ0U5ZyttV29tVHkwcUlwYStobjUwZzk2Tmo2ZVlNUFVo?=
 =?utf-8?B?MGhlMURTZldGaUxNUjROREdtRzVQZWRaalc5TFdvUGxMbFNqR1ZwVzkxYUpx?=
 =?utf-8?B?SFlyMlNXWGFtNnR2Vlp1TjdtMDkxV0dGS3lFMzJiaCtwMlZUSUk2MW1nZlRE?=
 =?utf-8?B?Tnc5WUdoS1gwZGZXOXgyMGlMcXRPbmlwaTRIVzRkZVdNZis5Q3RIajFJYXVP?=
 =?utf-8?B?YUViZU55eUZEaTcya3Rqb3ZtSDN3dmNQN3QzTDlOZkdPSjRUK211QzFXa3E5?=
 =?utf-8?B?R2lYMDRYVmV5MUpEK3ZldmZ3RDdGUUZkcnRiUDh5QkxyU3pYMktLZTVzTUhV?=
 =?utf-8?B?K3c2L25lR3RpSUM4UGdibzFrMmZBbE5jcmtWOGx2bjliRzlGVFE1THhwUnky?=
 =?utf-8?B?V010SE1kcERaYlpHNzFaM2xuank4c201VTlSUXBUVXR6WElBU2ZRcUtaZUlL?=
 =?utf-8?B?aDh5Q1l3NmUwOUpmcXZ6bDk4MEhib0dTMmE1eW0xTmVPT3kzK0pDS04rcDg3?=
 =?utf-8?B?N2ZUZnNCQzE2enZiSVh4YXc3bXliM0lERnpRMzlIK1VYRUVJenVCY0RpY0hi?=
 =?utf-8?B?bGEyT25CUFlSOGNWVGF1RkhGZWkxODl4YUw4UzJVSm9KeVBhVjhTQS9TVDB3?=
 =?utf-8?B?NzZLcUtTYjVnbXJ2dmtDMHQ3ZUF6bWpzclEwd3ZwVHphamtNZldEbGtrSnV2?=
 =?utf-8?B?NHVmdmd4TXREZVVKMFlQYnVldnNBRVFZZDM1MzdDYmsvN3E1OGtNWm5xeUFm?=
 =?utf-8?B?NmZmUTIzUVpGeXRHbmFzQUxDNS8rOVJvbnhmYWhyb0ZUWUZtblliRk1BMnJn?=
 =?utf-8?B?bkpWcDFwYjNlc2pDMHFndmFPL1FlQ3MzZFJ3Vk1iVzVDMzZnRDNXUGw1WXhw?=
 =?utf-8?B?U2g4bHNMSk5LTFpURUZMcnRzcUFTdDZOMDhFQUxMbGtUMXdic0ljSFlrZklx?=
 =?utf-8?B?b1B1NUNVWURHUEo3RGlPd0RNTmkvczBJM21YZ3pFUjZJRmNJakpRQzQ5VFNi?=
 =?utf-8?B?OXhEd0JYUUdiYm1DSnQ5TnNsWHQraWwvNDl4MFhiNWRkUVEvK21SaUdSYjRw?=
 =?utf-8?B?UXZBRUlPV3NWV2orNmd0YVV5L1ozUGJkOUhiM1FVTlExYnMrcFVKaWRhK1Rx?=
 =?utf-8?B?ZDY2ZFNwN3lKemJyekNsNDV3cHVla1V6ME8wS21UMytSN21wSFJ3aC9ad3Zk?=
 =?utf-8?B?Vko1cFZSYk95VDlpRHhaalBlV25PK28wRGRyeklzZjI5R09jcXU2WTZRZW0z?=
 =?utf-8?B?MjgvUzZGME05OFNJZ08xNHVLT3BQOWNqbUtOVjhyMTNxRmhiTW5zYno4OXI5?=
 =?utf-8?B?MW11eVp2ZlVhaVpncmNmWGttQU5mZ1BWYTNGRWhzTVJHbEpKQ2hDM0lUVURn?=
 =?utf-8?B?aitUYWp2cmpkdlgwOVhNbFB5UXBBbmNJNFN4QzlwTWJ5czJOQmpSY2NNWStt?=
 =?utf-8?B?WFIyZmhqYkZIL0lieENhMUhraUQ5QTFCbTNvbHcyN1lTOUpvMVVwNjJVR0NU?=
 =?utf-8?B?d0Z0N25tVGFZOUVaM2ZqaWNwV0VXeHZOQ2hoVWh6TjFHa3NIYXcyTktXTDFJ?=
 =?utf-8?B?R2Q3Q0hXMlk4eHIzbTdrWXlzaTlrUkxtQlh4aGY4S1N2c3hqZldOck13cTNp?=
 =?utf-8?B?UExpNHFZcTRHSEhhUWwybUhVNVRxSnczNSt1N3pITngvcjZPVjBHSkFkUlk2?=
 =?utf-8?B?UzMyeXE1N2I1eUZwZkdkS3FGakZkeldYSnMzV2UxYzBjNnpUdTBHd0hVbWM2?=
 =?utf-8?B?bURDTExCZEVnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzhvY2JUS09JdXZVemFRN0R0bzZaL0YwR3M1QWtNSm5nbVpMQnREQkN1clNS?=
 =?utf-8?B?b3FGWDRyQUQ0YWtVZ3hVMDlkZm10TU5hQUJ1WmNZSEt2anlERm95M3FETU9p?=
 =?utf-8?B?a0dyT1hobkpXbmkzbk44ekZPdTVuNXRzN0Z4cmorUURObk1ISnVjTVIvWXJN?=
 =?utf-8?B?czRnazFsQndaWTk4RlNWbWRUMzl5ODg3c05TY1NGM2s1bGhjQXJvTGZpTFBW?=
 =?utf-8?B?RHNpYXJ0Vk5NQXBlYmJjUGhqN00zMENYWlkrdG5tTTVvYW5CeGFtTFovVEtZ?=
 =?utf-8?B?QjhvakxYb2owTm1VVXlJL3FRN3NMTEZxcFhUODF6eTU1bnhaaU5ScXJYWG5m?=
 =?utf-8?B?bDUxbGtPT3NCMVA4dXlWcldiWnY4WGdIK2NzdnM0SllWd3E0OEpsNjg3NEF0?=
 =?utf-8?B?WUZIM3JvQ3BaaEQ4MEZmZlMwL0NDdkMyUTJiQ1U4Q2g5SlFDY2ZZVnRac2hI?=
 =?utf-8?B?akwwNEY4a2VkbEc3QkVQbWE2LzhWVHM0cFZPeEo2S1J3a3RZNlFKK1N5WXkx?=
 =?utf-8?B?NUxJUlRIK244UENZSjdBUGZoS3pWbVFjSFNycGxYdjJId3V6bENmUDFpUi9S?=
 =?utf-8?B?TllQU3BlMFRpSFhxaHpUN1A4UnJVRFFhRVk0YVlJQ0x1L0RUV0F5VzJ6UW9t?=
 =?utf-8?B?dDJqRWNTQ3NJTkcyVUpZVExoRHd0aTQ4S3N0VG1CeWswYzhtYUN4UlBOaWVv?=
 =?utf-8?B?LzIwanZLeVFad3crWWRCOGNFQVZYZUdZMHdaUGd4ZnY3UlB0aEc0M0hXQkJE?=
 =?utf-8?B?aUVWRmhIYlMrUG5vdi9mZVp5SVc2ZjZQZ0dFUFR2ZG1uektvWXNBNnI4VG1s?=
 =?utf-8?B?dGJTSHR2d0wvbjQyR25wNzVNS0xUQXZGM1NhSWl4M29odUVTTTIxL29JNXJ0?=
 =?utf-8?B?N2RGNG03YnNVTVFpTW1MWWFZN2J2akF0UGdlMC96V1ROZmNJLytoNmtQWm9T?=
 =?utf-8?B?M3RLbW9UMjExVGdLcDZlVFc2NHNGc0F0d0hXTWVFb2t0UjRLTjRDZ2dTN2RW?=
 =?utf-8?B?TzNhK2lubG5SSmM3VkY1bnQ3TmVQakQyMDVRVy94M0pGbmtpSDRGK05Gam1M?=
 =?utf-8?B?dlZteWhTRnQyQjA2UnQwT2FSUFUyWXY2cXJzaDNCeVp2SmJFUHdLYlltREgr?=
 =?utf-8?B?RnFBOS9kOW95RXRoK3ZzcTZzbGx6dmdDNE5jSkIrQmJKOS90MmtuSUFiNC96?=
 =?utf-8?B?VjJzakkrR3pJclFUOGxSR0dJMGtuVk56MTVJVFcxUGFTZWtQc0tTblQxZ0RW?=
 =?utf-8?B?VjZmeEtISGo1WWNuOXVOYUl5RC8xTGVYOEVkOHp3SnBvRm50RTcvMEQweDRN?=
 =?utf-8?B?MEo2ZTYyVUtRQktMaERwRStyTU1ublRvYVZJMEJQZUFTSFBBbVAyL05kc25v?=
 =?utf-8?B?ck5aYnUvMXU5NFBUQnBqTC9YWDRzaDJJMEdHRlFPL2s2R2hyNG5JcCsyTzM2?=
 =?utf-8?B?Mkh5ZW9zWkxzQkptSVhLNm9vdmZwWnlPSjFmdEVJK00rNUorVmdFa1hDYTRZ?=
 =?utf-8?B?S2tVV0VKcEJEM0NMbnczaTBMdkdQYnFPSy8zZ1hramdjbzlEWWxVMW9pVG40?=
 =?utf-8?B?WENKbW9OQTBHVzZ6S2RQS0w4VCtXcHBnMUdkckdxTnJhckhHS1AzcXNxeVkz?=
 =?utf-8?B?b0hyZkE2UmxTT1Fza0pHSHkvN3BUcWxLaDVjWU8vL29YKzRrY05sT2tVNDFR?=
 =?utf-8?B?S0FwOWJUbHJkRTJ0NmJheGlHajJ1UUJXcllnM2RFWUM5WENCNHpGVlBjZkpr?=
 =?utf-8?B?ZStwRkxvcEl0SzFOVjhZNGdsN0hHVG5aK2R3RTFnZVgzZGpYUzBHNEdIeTZM?=
 =?utf-8?B?R0YxVGNMaHE3eC9DSjQ2Zzg0RjhKM3lraGJUKzVUVkYzQ25ZdTh6Y0V5Y0g0?=
 =?utf-8?B?aWNwTWdobG5EWE4zelp4N3RKVFR0aGtUZnQxUXBtN0VEdFpQdGRsMHhoTGxL?=
 =?utf-8?B?ZHFmN1h3OEF1Q0FiU1RaR29LZXFTTnRuMEF5UDdZRVMySnhzekhkL3I2N3E4?=
 =?utf-8?B?V0NmQUxZbGFYblVmZGxIT2NITmtmMHVtZ3g3Zm9IcG8va2NJbFFsRE5QM0ll?=
 =?utf-8?B?RStaV3NlWlZhdlAvQk1BYk5TOWd1UjVEc1BocnphQ3FpRFcvOVRZby83U0pK?=
 =?utf-8?Q?G+tT6NdllLci0rO0SqCp1+AL2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec0fc45-dd37-4878-337a-08ddda50098c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 09:59:05.2547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4du93BLPJKJMNMMbKjyiLsVjP7dZ2jxB/6gCalaa8/IDzOeXRK/4e8Tj5pv5ARiaGpyiRc59eAPb3kh0x0xNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4458

On 07-08-2025 01:26, Sean Christopherson wrote:
> Gate access to PMC MSRs based on pmu->version, not on kvm->arch.enable_pmu,
> to more accurately reflect KVM's behavior.  This is a glorified nop, as
> pmu->version and pmu->nr_arch_gp_counters can only be non-zero if
> amd_pmu_refresh() is reached, kvm_pmu_refresh() invokes amd_pmu_refresh()
> if and only if kvm->arch.enable_pmu is true, and amd_pmu_refresh() forces
> pmu->version to be 1 or 2.
> 
> I.e. the following holds true:
> 
>   !pmu->nr_arch_gp_counters || kvm->arch.enable_pmu == (pmu->version > 0)
> 
> and so the only way for amd_pmu_get_pmc() to return a non-NULL value is if
> both kvm->arch.enable_pmu and pmu->version evaluate to true.
> 
> No real functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 288f7f2a46f2..7b8577f3c57a 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -41,7 +41,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>  	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
>  	unsigned int idx;
>  
> -	if (!vcpu->kvm->arch.enable_pmu)
> +	if (!pmu->version)
>  		return NULL;
>  
>  	switch (msr) {

Reviewed-by: Sandipan Das <sandipan.das@amd.com>


