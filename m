Return-Path: <kvm+bounces-50677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64702AE8250
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 125CA3ABEC3
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 12:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBB425BF09;
	Wed, 25 Jun 2025 12:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jOGoxDaS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2085.outbound.protection.outlook.com [40.107.220.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB48F3074A3;
	Wed, 25 Jun 2025 12:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750853022; cv=fail; b=JWv/RWLvUmy2RzMrYwHW4OAtd6o+2CUURIQN4c6fHkqwj/ZH6xbBqj2lByKJgT8KsBZWeMlYDjgcHdk+NYeLQCRquQJefchDBb/OWng/mm1/gSvoaThK9ZDWx/ddjqbKlaqZzkA49FlwSxS6RKc2MMGGcC93whyXwXSphkmmhaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750853022; c=relaxed/simple;
	bh=00dvLhqZtpFuHAHYv1Z4jQrAM2Wva3ECtVL8QyGVojc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pSjU86kbxvvBKxe2xqrmC1hllUrueIia64ij958ZkWAil3FPC7v0ONCmSqTZE7OXgSu43q0eAPJdsd+7pyetna3Q3LslufjzgpRySyWlxlpsN4QRxNTZdm15iLisK+Q9/lON4nLbJ5T3vmeqqu9SsJqILRz7FPROjYiayTT9igE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jOGoxDaS; arc=fail smtp.client-ip=40.107.220.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k5Pgk5aIc23KFPDG/qgwaeges214BmdYEt1enCducTo9kEH7DbPgxiH0H3EVkyIvtm/+Zk8DFjoIyjYsnlOQCgzCkpqfX1W5EA6N8aJraFTTqdB5LpDYyhFC+do3iewopf0GBs/rZbWVt3kiKjmpvB/KfnrMDVckhEiwUzm4JIyAsLh3ansaCxUNTGd3yzI2WKNkVrc46ae5FiafCkbvCjIL7gdkeSKHmFkUirgpYlGThjdgvbEqZG9RoEUx5Ds3+NEnOE5cmDPamqDYs+6KG8z3nls0JMdKqh8b7+3fi06+BYdje1SuVEJHnvLEfHfBTBjEzaxqtjK5YVu9dNYO7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ck43tgM8xFlZ/EFyfljsyrNI3tKKEVzpZbV4owoeMJQ=;
 b=OpRc210Q0s1tPnlk+CrqY1SlYbMgMYXCcq1yliIwcR+Bd4aL6vCgRyShU2CU02BygSdnYPXWbMozhKzxtIB54bjvwZHFhwoKnD9kgCNwUjOuH9ybEy/TGwWMQT7diTeY6Oyy3HNkGKfKs3XAEnD4xB3wVcf7s5qbMmzZNaV632vpZKshbutNQ4DA89uZ2ea6pHlBiWYq6DRxfBOFIzUZFs14Kb5zAVMIKbG1SNhr+oVmwPRpRSDzeP4Qbsr2uMuYJ2MOTLCwBHYXP3IEsOWnm/VlIADyMwqMuNbwyQ4bsKXdTOMjoPXTc+TP5d9Oiooh9wOd8o5aNlVBl/4yItb4PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ck43tgM8xFlZ/EFyfljsyrNI3tKKEVzpZbV4owoeMJQ=;
 b=jOGoxDaSN/R5uXiZLex8Pb6ZcgOUm3g73QEO9xMGbaEui12lPOzOUzUA0+9ZsxMiDr5tXkBbVcb6jKRC0V/lEXxP7ecwYBjFfvSFZDKePJi/dt4uwMU4uxWVyVLPBNTCS8dsHN4hV6+Qpd4va38lehsiRwYP0woKOFzFr+M2UtE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 LV5PR12MB9756.namprd12.prod.outlook.com (2603:10b6:408:2fd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 25 Jun
 2025 12:03:37 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb%3]) with mapi id 15.20.8857.020; Wed, 25 Jun 2025
 12:03:37 +0000
Message-ID: <a80db415-209b-4a75-a2a8-2b8072c2407d@amd.com>
Date: Wed, 25 Jun 2025 17:33:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/32] KVM: x86: Clean up MSR interception code
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>,
 Xin Li <xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>
References: <20250610225737.156318-1-seanjc@google.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN4P287CA0081.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:26b::15) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|LV5PR12MB9756:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cac8809-03a0-4f4e-e455-08ddb3e050de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YjZCbmpsM29YL0J5Z2IwUlduZmRaN2xoT1padkNUWGFuNUV0eWc5QUFyTzFj?=
 =?utf-8?B?NEVjOEIxWW15U0FiY0ZMZ3lWeDBxZEhaU1pMWElpZWhYYjg3RTJZVFBNbGlQ?=
 =?utf-8?B?QTNSdERlVldRNlREUEpEdmVpZTNvSGNTZ0JsdDJKaWNBMXdoOVlwNVlBS1hs?=
 =?utf-8?B?RWhscTY3VUg3ZG1OcXAwdlV2cE1ZM0VNeDNNMjByWnlLaFc0Tm1jRE1KdXZG?=
 =?utf-8?B?SHlqVm5UV1ZrRnVkanVFWVRuNXdLWUVpRWdVbi9ienJYY3pQMmwyazc4OXZy?=
 =?utf-8?B?R2JrVXZXVUdCVGg5aGlxQUhsdSs5WEo3Umh0d0xLbGhHNVMyVDVXS1gvQzhP?=
 =?utf-8?B?WlF6VlMxdGlmK2JobE9nUHhsS095MFpFNzllQTcyY2ZYQUpFc0xLeE1xcHIw?=
 =?utf-8?B?cUdpSGo3ZUNQN3N2L0p2RlV6ajMvZ0xkM1JpYkdEbGNCWXliRUJiVzRPOVI3?=
 =?utf-8?B?OW1zcUQrSzhwa3lzZFRiRHlCTHpXNWQ4RkFjOVd4dEk2RjNkb1hqOEIrT3hI?=
 =?utf-8?B?cDdHQkFrZ2FxUHYrMUdNaXFPK2hnR1V4dTRtQUlpZjdnSGh0bUUreWNva3Qx?=
 =?utf-8?B?L1E5Y3gzV3VuMkFCVlVYQm1tbmxERm9Ka1pqaDZYNW9OWVhhZTF0dDRHVzVp?=
 =?utf-8?B?eHFVYU42akt5NUlUdVBJbTB1ZjhvZmRSeDRNRm1CaXJmbENaMTg5NURqbllx?=
 =?utf-8?B?YUZtbmpyNjR3ZGJoNERLblRuZ2NGbnd6M0V6UWRWZmRDb09rOFVLYjlSZEY1?=
 =?utf-8?B?K2ppVFB0TVhOZHdmWkl2ZlZGOVVoLzBiVVNEZ1JPSXZQbFpsTjk5MGtRbHpN?=
 =?utf-8?B?c0FibERjN1kyVFJTT1p6M2gxN3o3RXAxK2FOQ1crOU1mQytnbkwrNjNmb0NX?=
 =?utf-8?B?YmRrd3dFc3dDOUl1UXhneDdTQkZ3MmZtRXFQOGNQcTNjU01OVW85TzVPOHk1?=
 =?utf-8?B?c1M3dnZHZmcwekJ5UVRhT3pNblV4UjRJdk9POEZKVUlwK1VSL1UxYWp1aE5k?=
 =?utf-8?B?dWdFU2JIUE9NRTFlU1RyWTE3UGk4cnhlNFZvTVZ3cGFuQXgxanBMSEpIeXZz?=
 =?utf-8?B?aEIxM0EzQy90YWZvQllFU0xjUnp6Y3Fua2twNDVmTHhxeUw3ZDV6Y1ozMCtU?=
 =?utf-8?B?elBvaFJPWmFEMEM3R3ZaNU5SNVZQaGFXMjBVbnRUblFDSGtlTGw2RVd0VjNY?=
 =?utf-8?B?OHp5YjlkbUlqUUhqczVWYVljcDVPenRMRTlLR2d2MWhIR2xBSEpVMC9UaTNs?=
 =?utf-8?B?NE9vUUtJMnU4OVlSdm9sSXAwTm9iMmJiaUR6ZFVOMGwvRjR5dGVjd1lqb1RP?=
 =?utf-8?B?NkF1SDNpU2YwMlRrRFBSZkNIRVEyVzJReVg3NkRJWlBjVmpGRElGZFRqcUxi?=
 =?utf-8?B?MEJpcVk2UW9UZWNGb0s0SFo1R3JoM2RLRFNBSnJNbnVoTmZaeVZ0eXc4NTRV?=
 =?utf-8?B?WERISnJ0N0lpR3RoZENtT0I3L2hVU0xBWlpyUWUrc05SckdHVWZidEQ3WWVr?=
 =?utf-8?B?SjlwMUhkT1FYdmRyMktMbCtTUy92ZDVKU2JDOEFtOVp2cm0wRjQ1Sm1WcE0z?=
 =?utf-8?B?VXJhVzdad1V1RVRNSSswbDU4dWlVN1BGZUtGM2dCbzdJMVZZZmVWWUk1NkZ1?=
 =?utf-8?B?OWlCekNWQ2dpM2VjNjRsbXpIQTdWV3RZOTlRMG94MlBmR3dQSmxNZkMxUDJa?=
 =?utf-8?B?cDNzcUhmV0hPZGhZOXg1TDBKdzZpUk95QVgrR0NhZVZMazIzTEhDVXBTc2Nl?=
 =?utf-8?B?U25qRXd5aUczb0tlT2RVUWc4R3dlUDVkV3hubHZ6akdDUjJEQWQrelh1VktH?=
 =?utf-8?B?dFY4WVdCS3JYc3lQS2crTXpSeUkzYWp4cVhDU3NIM2UvTmNFZjY5Q2V0N2NK?=
 =?utf-8?B?OGZwbU9QMjhzMTl0WXV5eEphZmh5VjM4eUZVMGFVdWx6Rjc0M3krRkRibWxO?=
 =?utf-8?Q?MwJeeCwgFaE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDRPVmNhYnI4WHhTRUtscnBxbUVDUjB5U29qTTZRRitaOFlNSXJ4QmlQM0F5?=
 =?utf-8?B?bCt4TjdZYlVJRmVZS24vQno0dWJBOHA2TCtvbnpDWm9OeVdSVnhITlVBaFJB?=
 =?utf-8?B?S0ZxdWJtN0VvSEM4NW8zU3AyZVd5NDAzSmdxaEU1WEx4ZlZQb0VmejE0d04r?=
 =?utf-8?B?QnhmK1ZaNUw3RVEyMWNBcStSRVpGNW5aVHQ5SjVyTTRGZHdEd2paWWFtQzc1?=
 =?utf-8?B?c1ZFNWE0SWh2L1VWWmVidHBtbTQxckRQNXpUMzZPYUdhbTUvOGhCSmI0bjFs?=
 =?utf-8?B?bUs0T3NvNGhWT3dUWGt5SGZ0Y2w1VjhRVEZPU1p0WHZHWEEvMm13UFJNRk56?=
 =?utf-8?B?UDAyQmVMUzFzQkRKYjZPR2RiaVY3KzNmejlCcTJlTlBPVWlreWdKREhSVWw4?=
 =?utf-8?B?SGExZElCbm1YeFAyWGIvUHA4cmt0ZmdtYlczZzBDbkNkSFF4ZXVqL2Zyb1Zv?=
 =?utf-8?B?S2EvWmtHZ2VCQzR1ZGgvWGd0cnA1YlhFaTUvdEJ3cTVDM29YdjRRSjJMSmlX?=
 =?utf-8?B?YkZkMCtnOE9weUhrSlhRQ2l4ZjhRSWgyK21aeXk0NkdiRnFSNzBBT3VDeE53?=
 =?utf-8?B?THE4UjREclZWYTJEN1R2dFN1VFphZmdDZkpMQ0IwT0hKRXZSRXNJWG8yT2p2?=
 =?utf-8?B?ZFMwV1RtOUEveWMxcnhFUG9naVJSOHpCdkVZVjFzTU5uaUZybFp4YzNNVHNI?=
 =?utf-8?B?NTlMcmVPdlk0N3lrU01VbjNYSXY2d0UveVJjSVBhbTVqeDBSL3FmMHprTTJx?=
 =?utf-8?B?djdJMkwzQ2Y1VGU0akFMRDY3Smt2b2tJWHpvcXpFMFhqV01HR0VhdkxJRVkr?=
 =?utf-8?B?Y1hUWXQzcVZ3dHkxeUEvNzUwYlIzWWhpVkRTVkZiaE5SWUIvUnI2RGlETVJN?=
 =?utf-8?B?bDR3US9NQWlqLzBJdytybll2Qm14YXh5THlLSU1uOS9jVnRmdUhQZ09IS3Rr?=
 =?utf-8?B?Nk5KMEdFVldPaDBmQVN0WEdsaDBDRjZDeUJ4N0dOaXZrZXRWSVVDWjhjVkRz?=
 =?utf-8?B?RXhPSy9JS1ExanJYT0RiZlZwOGZxUmhxN3lncjN4aTdEVDJLNUVGanBmQS9s?=
 =?utf-8?B?OVpxRTlKV2VjTTd0c09YSDNNckZ4SkZKYWNzWCtDNytPZXBXeWZ3WFVEWWxH?=
 =?utf-8?B?TGExWmc0ZHR4bHNzQldvV3Q0RzdoVDJoY0FlbWdXYW9GYk5sck91UTI0bnA0?=
 =?utf-8?B?MGhDZ0IwZ05IMms0dTdmemhPVktxNWM4YTA4OS9Yd0dIdGJnWlU5Y0lRRXFP?=
 =?utf-8?B?aGNPQ0FsWVY2N0RjZy9ydENDSGNKMDIxc1FtTWZrU1UxN3BCVy9YV0lER21x?=
 =?utf-8?B?OGFjMi95U045Ymd1WHlxOHE3b1h0bEZuZTRmOVNSeE9wNjhDL1o2QjdGN1FF?=
 =?utf-8?B?cFQ5RGlqSWN3RHN3YjA3ZXdsLzE3Z2pUaE5GMEFOQ1RON2djTVlDSEVELzcr?=
 =?utf-8?B?cFc2Q0dmaVRWVlNSRkhsTmRZRHV1aVJTL2pGc1BoNXdJMHJtV2F3RWg2K2hj?=
 =?utf-8?B?MFlFTXdjQ3I3ejBNakN0a1YwcWUyWVg2SkxNbCtRNmF5KzkyTkR1WHFGMTlj?=
 =?utf-8?B?KzhwSXg5ZS9BR1orOVFtekQ5RnZjeUtqK3JFQy9TNS9QcEpXNWV6b3dkS2tG?=
 =?utf-8?B?UTdLY1BoY1FramZub3pmc3NoVlEwOEh6RXpaODJFSjR0QkhudVk3Z3FLYWNN?=
 =?utf-8?B?dlkwRnBObEt5aDUzSWJPaFVkelVweGJLUm9BUkZMN0RvNklydWlIU2pCWFRi?=
 =?utf-8?B?NXcvUFM1akx6VDdnQSt6OXJ5ZjdtUFpFV3lsNXhXVlFaZTliZGVlWDdhVnZ4?=
 =?utf-8?B?QTlEYkY2b2ErMFhERVhLOG1Pb3poWjNFRlRSRU9UUDV0REpwWHI4L3RMSVh2?=
 =?utf-8?B?YTB2c0llZk5VUlFYaldxN0xWV05rMmdTYzQwKzNDamFJRUhoOXFJNERHa0Zx?=
 =?utf-8?B?Rjg2c2xtSDZLQkpEbllGcXZzN003VXhENjdKVFVhcHVDVE4rL21JOTl6QXlT?=
 =?utf-8?B?WnFiSGNTUHRUM21sUFpNUUgrbGRVUUFKcS9Rc1N5V1Z6a3FJUi9nR2M2NDFq?=
 =?utf-8?B?U2pVN3lobFk2cHpsQXlleml6VERVMzFLMWhBdEtIM1VJZm45MzYyQk5TUXN5?=
 =?utf-8?Q?s4StncyTDfgZprE21/ZH5IJ6/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cac8809-03a0-4f4e-e455-08ddb3e050de
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 12:03:36.9199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CI0qKnktTevvwYr+88IHKvLXspYwmjCM4iO6h4CJMu2h/wDYseyeApkgLxvWVy3JHm/jnMHoREJa27Oqn34Ejg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9756

Hi Sean,

On 6/11/2025 4:27 AM, Sean Christopherson wrote:
> Clean up KVM's MSR interception code (especially the SVM code, which is all
> kinds of ugly).  The main goals are to:
> 
>  - Make the SVM and VMX APIs consistent (and sane; the current SVM APIs have
>    inverted polarity).
> 
>  - Eliminate the shadow bitmaps that are used to determine intercepts on
>    userspace MSR filter update.
> 
> v2:
>  - Add a patch to set MSR_IA32_SPEC_CTRL interception as appropriate. [Chao]
>  - Add a patch to cleanup {svm,vmx}_disable_intercept_for_msr() once the
>    dust has settled. [Dapeng]
>  - Return -ENOSPC if msrpm_offsets[] is full. [Chao]
>  - Free iopm_pages directly instead of bouncing through iopm_base. [Chao]
>  - Check for "offset == MSR_INVALID" before using offset. [Chao]
>  - Temporarily keep MSR_IA32_DEBUGCTLMSR in the nested list. [Chao]
>  - Add a comment to explain nested_svm_msrpm_merge_offsets. [Chao]
>  - Add a patch to shift the IOPM allocation to avoid having to unwind it.
>  - Init nested_svm_msrpm_merge_offsets iff nested=1. [Chao]
>  - Add a helper to dedup alloc+init of MSRPM and IOPM.
>  - Tag merge_msrs as "static" and "__initconst". [Paolo]
>  - Rework helpers to use fewer macros. [Paolo]
>  - Account for each MSRPM byte covering 4 MSRs. [Paolo]
>  - Opportunistically use cpu_feature_enabled(). [Xin]
>  - Fully remove MAX_DIRECT_ACCESS_MSRS, MSRPM_OFFSETS, and msrpm_offsets.
>    [Francesco]
>  - Fix typos. [Dapeng, Chao]
>  - Collect reviews. [Chao, Dapeng, Xin]
> 
> v1: https://lore.kernel.org/all/20250529234013.3826933-1-seanjc@google.com
> 
> v0: https://lore.kernel.org/kvm/20241127201929.4005605-1-aaronlewis@google.com
> 
> Sean Christopherson (32):
>   KVM: SVM: Disable interception of SPEC_CTRL iff the MSR exists for the
>     guest
>   KVM: SVM: Allocate IOPM pages after initial setup in
>     svm_hardware_setup()
>   KVM: SVM: Don't BUG if setting up the MSR intercept bitmaps fails
>   KVM: SVM: Tag MSR bitmap initialization helpers with __init
>   KVM: SVM: Use ARRAY_SIZE() to iterate over direct_access_msrs
>   KVM: SVM: Kill the VM instead of the host if MSR interception is buggy
>   KVM: x86: Use non-atomic bit ops to manipulate "shadow" MSR intercepts
>   KVM: SVM: Massage name and param of helper that merges vmcb01 and
>     vmcb12 MSRPMs
>   KVM: SVM: Clean up macros related to architectural MSRPM definitions
>   KVM: nSVM: Use dedicated array of MSRPM offsets to merge L0 and L1
>     bitmaps
>   KVM: nSVM: Omit SEV-ES specific passthrough MSRs from L0+L1 bitmap
>     merge
>   KVM: nSVM: Don't initialize vmcb02 MSRPM with vmcb01's "always
>     passthrough"
>   KVM: SVM: Add helpers for accessing MSR bitmap that don't rely on
>     offsets
>   KVM: SVM: Implement and adopt VMX style MSR intercepts APIs
>   KVM: SVM: Pass through GHCB MSR if and only if VM is an SEV-ES guest
>   KVM: SVM: Drop "always" flag from list of possible passthrough MSRs
>   KVM: x86: Move definition of X2APIC_MSR() to lapic.h
>   KVM: VMX: Manually recalc all MSR intercepts on userspace MSR filter
>     change
>   KVM: SVM: Manually recalc all MSR intercepts on userspace MSR filter
>     change
>   KVM: x86: Rename msr_filter_changed() => recalc_msr_intercepts()
>   KVM: SVM: Rename init_vmcb_after_set_cpuid() to make it intercepts
>     specific
>   KVM: SVM: Fold svm_vcpu_init_msrpm() into its sole caller
>   KVM: SVM: Merge "after set CPUID" intercept recalc helpers
>   KVM: SVM: Drop explicit check on MSRPM offset when emulating SEV-ES
>     accesses
>   KVM: SVM: Move svm_msrpm_offset() to nested.c
>   KVM: SVM: Store MSRPM pointer as "void *" instead of "u32 *"
>   KVM: nSVM: Access MSRPM in 4-byte chunks only for merging L0 and L1
>     bitmaps
>   KVM: SVM: Return -EINVAL instead of MSR_INVALID to signal out-of-range
>     MSR
>   KVM: nSVM: Merge MSRPM in 64-bit chunks on 64-bit kernels
>   KVM: SVM: Add a helper to allocate and initialize permissions bitmaps
>   KVM: x86: Simplify userspace filter logic when disabling MSR
>     interception
>   KVM: selftests: Verify KVM disable interception (for userspace) on
>     filter change
> 
>  arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
>  arch/x86/include/asm/kvm_host.h               |   2 +-
>  arch/x86/kvm/lapic.h                          |   2 +
>  arch/x86/kvm/svm/nested.c                     | 126 +++--
>  arch/x86/kvm/svm/sev.c                        |  29 +-
>  arch/x86/kvm/svm/svm.c                        | 490 ++++++------------
>  arch/x86/kvm/svm/svm.h                        | 102 +++-
>  arch/x86/kvm/vmx/main.c                       |   6 +-
>  arch/x86/kvm/vmx/vmx.c                        | 202 ++------
>  arch/x86/kvm/vmx/vmx.h                        |   9 -
>  arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
>  arch/x86/kvm/x86.c                            |   8 +-
>  .../kvm/x86/userspace_msr_exit_test.c         |   8 +
>  13 files changed, 426 insertions(+), 562 deletions(-)
> 
> 
> base-commit: 61374cc145f4a56377eaf87c7409a97ec7a34041


I’ve tested this patch series using the `msr` tests from kvm-unit-tests and didn’t
observe any unexpected results.

Additionally, I rebased the mediated PMU v4 patches on top of this series and ran
PMU-related tests from kvm-unit-tests with the following configurations:

  -cpu host
  -cpu host,-perfctr-core
  -cpu host,-perfmon-v2

I don't see any unexpected results.
Testing was performed on a Turin machine (AMD EPYC 9745 128-Core Processor).

I understand the patches are already merged, but just wanted to share this for reference.  

Feel free to add:
Tested-by: Manali Shukla <Manali.Shukla@amd.com>

-Manali




