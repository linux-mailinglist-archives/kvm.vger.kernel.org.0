Return-Path: <kvm+bounces-48138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3095AC9C76
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 21:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A8FC17D6C1
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 19:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A9C1A23BE;
	Sat, 31 May 2025 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JeJ9AVgC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ACE2907;
	Sat, 31 May 2025 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748718843; cv=fail; b=P0K78HkT8ygvNkUbwQeAqfOPRTd5prKA2dxCOiEVhBocdxoGLWGDz0Gc8SiO92pPQ1O5Tafu78o9rBdA2ineO26CBQY7wl2HigiZtvq4NznWcrZazdXZZAgCYberVdS3Xc2verotLqcQ8JHqLylxDjA/wYRcE7SoPd6AAviESg8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748718843; c=relaxed/simple;
	bh=jf/tcnKhAuEXcHdB5r67Q/mqtgGtPAZYsWOJ+UVr3QI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jvpjX+FZyPLguUBkxgKfHFGznbErzsJjTO3+6HtPB8UqeEIIjn2NKfj3KjmNBsf2j6MXJuYkLfsL9c+hy92xv5mlJu1AH122kstXD7MMwM7AomROT+q/3bhFvw5bs83KFH3Pz87KTgXVHkrbBnuJlvUUV7qnYdCPZCYyPhFJB6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JeJ9AVgC; arc=fail smtp.client-ip=40.107.223.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZFaPCkLCqEp/Wl44FAz3gOSm8TEfRXP8frPMp9g13GeXwdeViCT7K+WPiGR9EI1mcUc/xpO1bWS/0WH5yVPCzfkTBC5JoVM8tsaOQzFo+SDQHiwRYwAXIPSaPPYyMyVuVss3hkG+alMSHqdlpxObcsYmxjwTVwqtDjCoEO0KyLo2FsBVm8IYPihE48v5ZLK/OI7KSA4Kh4i9tK/pn6w7ujAeyJ1CSDYyV8KTObmoUqOFqFSSje99dWGAlFDUFT+lOJid4mhlJ3kB4WVFHHqZs3tK55rfx2dSwaqyIuCzX10etB5tV7GQPKqFXejq8X8Lxk7iQRo1WaPnZrBd1mqfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKHUKAmg3UX7tUw1evlgoGW1j74KZjhGXgCitLtzXUU=;
 b=QCiQZleWqTwtJLg/mjMsQLG1qls3M3DdMHtMgCa3FySDvfpRQ9nDgi/KMuqnToYAhymZHkKJDHUk2ypWvoapQScwd7QLXkQY9IW6jWjJFmJvxL1rF6RHh/1O1kQfPGLHrpf3GhQjQggvEkew1ErZWAvVLOmoDuIVpmVyDr95OuEx8+5pa2rIjBNNp6EErihG2J9tvGjkKY/hgCXmnYD84dWLwJWFPzPxgs/q0wIqOJIPaQgj7c7si9eKKJwqNwPZPnZggU5oGaKV7RXNeJhzoykZfQ6+l+c0udXl/kSdFJgTp3Awf7Eci+blueDWAzxEChIlwuBpbNoOhEhyFHPHDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKHUKAmg3UX7tUw1evlgoGW1j74KZjhGXgCitLtzXUU=;
 b=JeJ9AVgC+1UYj1wNs7mcffICOZzzqTJjh33QP6oIOx8OmRciK5t6bi5JJqj+Od0Pt4wAaTCVp1W8QuXPosuafmzNVnGNAClXLLH/bfXls4aTgkE312tZeH3TkLbpQBHTbqrTk8k6YDbsGxxEi3DN1YEA0ccqwCt0pzPXJ4z9GsU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by PH0PR12MB5605.namprd12.prod.outlook.com (2603:10b6:510:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Sat, 31 May
 2025 19:13:59 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8769.033; Sat, 31 May 2025
 19:13:59 +0000
Message-ID: <448929c0-c3a0-498a-9a69-71e379b0725a@amd.com>
Date: Sun, 1 Jun 2025 00:43:34 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/16] KVM: Rename kvm_slot_can_be_private() to
 kvm_slot_has_gmem()
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-6-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250527180245.1413463-6-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::13) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|PH0PR12MB5605:EE_
X-MS-Office365-Filtering-Correlation-Id: c0819617-1693-4379-c2a1-08dda0774b8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bklMRXYyVXdDRkVVeEx1SWFFUTF2bjYvVG12VVdrQTFTbUwvSUpra29Zd01y?=
 =?utf-8?B?MzU5aG9XYUZRTy9sL3QzRzk3ZGpXaWlzRlRxSTZGUnhScVo2NDJZSXo5UGRx?=
 =?utf-8?B?YW4vR1RDb3VoNC8yQi9VazJxK2MzZG5JWWZycmwyUnJYSXNQS0RKb2xQUkNV?=
 =?utf-8?B?dERQN3lRSk0zbFBEOVhFN28zSVhRZVlnQ1V1aGtYUUcrMVNNVmFzcjFNMTd0?=
 =?utf-8?B?cmFENEo0QmNRQm44UHFnOStrM1gwWisrSmo1ano1VlQ3cFVzVldhNGxpTkVT?=
 =?utf-8?B?SlNsUFd3cGw4d0YwekFjRHNKdE5IVVUzaURIdHFNbDl0ZUpRZzhxbVc4RUEx?=
 =?utf-8?B?N1NmWjl3cDFFVzhNZkN4SEh2cmlUUHdRWmZPTUY5NitQa0hRM3g3bnA4N0Mz?=
 =?utf-8?B?M09Kdjg5RjN4U3pBcHVZcE5LRm5WYW93QUVma0NkdXZsME9aSEZOdElOUGhB?=
 =?utf-8?B?aTJmU0NJTHQzWWJrdVVlbVdqR2Jvb0FuMmtIZW52a1RnOEFJUExmMCtrZmMz?=
 =?utf-8?B?dExFNlNld1FTK3dNS2o5NUxyS1dteWpBQnVYUUFCUUtUc1FXc3I2NXBwVDBU?=
 =?utf-8?B?eWxiQmJLMnBXOVhPQU0vQm1KLzhWMElkOFF5Z1BBSldDUjhzYTkwN2J3NGx4?=
 =?utf-8?B?eElnNzBkVnFJTFFEcEhHQzlpN3Y3YzNqSnlYRWh1d0l6U2E5cHhrU0VPQnZP?=
 =?utf-8?B?WitIbW9veDM1cWpYTUZaWGZjOWRaZGxzeXVDcTVOVG45VGh0K0dKYlAxMjVP?=
 =?utf-8?B?M0pYa3lEWXhkaVN1YkxaclA3U2M3OFhvc29HbGlxQ1lXSmFWUHY0dC92cW1E?=
 =?utf-8?B?VWRFSndjbmRoaXBkVjNtRFJZSVQ1K2Z4WFVBUlNyL0tuc1g5WWJ1TjJyMk11?=
 =?utf-8?B?dG45VEFpT2tQZ1c4M0picTRHS0FUdjJ0dlo4R291U0ttKyt6UFB0cnhaeWtG?=
 =?utf-8?B?YzhZaXZ0a0NoUk1tV0Y4aVdFN3ovVnN1OHViemYrTGtnOXFERjhua3VOTFdH?=
 =?utf-8?B?R3NLckJvNEQ3cHVWWlZtN0dELzlxQ1VIWVdyamE1Q2tHN25ZcUVDY08yWk1N?=
 =?utf-8?B?dkhJRlBtcGFlQWZMSWRaUUFDRTR0UjQzYjJabzNvMXVxNkxiUms1NlJUc25x?=
 =?utf-8?B?NGJZeU1wZUU0NHdheDhhd1FxUDhEQkFEOW56QXBSZk5VQktILzBZMnRSWVM3?=
 =?utf-8?B?NGRPeE0weHd0NlNwbERIS2l6VGNWeTA0bEFWRjlWSVh0VjYycldoRWlwQlEw?=
 =?utf-8?B?UjhURUFpR0grT2Nsb1B5TmlKcGJvMGxaaldxbkJPMHJFZHhabHd0NG0vK1Fk?=
 =?utf-8?B?ZDFlOVAxRHN6K3EwdDRodzhGQktjeUJuWHMzd0lEZ3o1cTBFVnloeHpXZVV5?=
 =?utf-8?B?elpNeUNGK0ZOU0VDWFVtQ1EreU1USDVjZDY4SkFJM3dNeUVqY056UU02REtI?=
 =?utf-8?B?TzJLSGx2MFdIaGlBUEpLUmxKWUdUOXp0Y0NOVHpLTmN1Ty9KeW1YZEtZd2NT?=
 =?utf-8?B?aE1SQ0FKcXV3b3duTUpWd0hLbFJXcHVaTExsN1k4RzY5QXJTQ25rUXZEUHFY?=
 =?utf-8?B?ZFIwcHZwOEwrSWtESUkvbC8wbnpncC9WUjJsRjJyZFE0STR4WHRrOHQ5cFF5?=
 =?utf-8?B?N0VkZnh2Z2hTeTE5Yms5cVRzRnhpUFJ2NTVSdnhpV3llMFlaWnFFWmI4Q09I?=
 =?utf-8?B?cjdDWUNVUFhOb2JKOEdnaUJDTFpQU3BqbWVLSWRCS3AySXh4U3F2REl0R2NY?=
 =?utf-8?B?RmVhMzNCQkhRUE1oSUk3R3p0L2hlYlo2NHE5K29iaU9nN0xudVozRjJ1QmNp?=
 =?utf-8?B?UWpJUUE4UXFyRU5leDNaWWlEQ0RGaXJBVnh6K2g2VzZwUTdvK2tMSzB6cFA1?=
 =?utf-8?B?b2sxNTByR0lpT1ErWHpwNjhWeDczTEhaZ1cxSm5kTnVLdDdHcVhxUGdzQkdN?=
 =?utf-8?Q?/vZ/AqjfYpg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SWJ3ekk0TUtBUktCaHZMUkpNdmxVS0ROeXVNdnpKaWI3bTg3TEtwcXpJZGxa?=
 =?utf-8?B?di82UFJUR01qMWliS2w2VWhLbXRVdXZCWFNaSlRJNUlPYVV4d3pGbzdUc1Rp?=
 =?utf-8?B?dkpFaHlZdmVsSFZKQVRiS3l4alB4MGE0eWV5TnQzS3U2Zk5XZTRzY1FTNUhI?=
 =?utf-8?B?Ym5DbXJmWjJ5VEFBTmpiZFpkMnFiMjM2Z2gxeUw3Y1RhTmp6WlJSM25MRE9r?=
 =?utf-8?B?TThpWGc3bU8wM1M1aUpIVDUxWmJnOSsvMHY2THpNM0tKUTlRekZCeTA2dXVB?=
 =?utf-8?B?TzUrQVp2T1dmODlocG1uOUZZa2tOVjhxYWVwNFNwTW1RTVdBdXdIajM2aVBP?=
 =?utf-8?B?bmhSZ1dORnl2eGxIWWgzN2V0aDcxdk1GOE5xdlJKSEd0V3l1NVhhWlBlb3Z4?=
 =?utf-8?B?MHZaRGw2dCtJR2dMWGlIdEtHTEM1T2VnTDF2WUp6ZUxGZkhINUI4L0dDdUtv?=
 =?utf-8?B?NUZTMFJDaFFhdXk3Rys3cFpWemhNTWtnaHZtK3dGT2xpWmNFdXV4MmZxM3hG?=
 =?utf-8?B?TC9nNDMvS3Q2bEtpLzg5N1YvcW5LaG5HcHZaemwvaTFXa1dmaVBGREl2L2t0?=
 =?utf-8?B?MHdtaTFmR09OTUN6WGNvdllDcncvZDVzNjJPYlc4elgyQWhTT3NpU0g0U3Jt?=
 =?utf-8?B?SFl6WVVBU1RjcmdnU0hwaDhxVXkvUXh4MWtJQkdjRFV3REtHdnJ6NnZtYWUr?=
 =?utf-8?B?NjZYYkpocFk0TE5Wall2SXZkSHRsdk5GQUcwQjRaRGgrQS9pejg3ckV3MDRo?=
 =?utf-8?B?OEVsZkg5MXg5V2pWbnlXa3dWbGdEZC9BS0Y5M3FTaW5HZkxEdTc1SWNPQmJY?=
 =?utf-8?B?anJRaHVyQzBGVUUxMTFLRTcrREpucnRkUUVJa0lZVE9UWGM1MHEzS1RDSi80?=
 =?utf-8?B?U3JPU09KamdiSDhoSGpnU3daek9QZ1lXQ3pob2p4R0dUa0w1WnNCczVzdFl0?=
 =?utf-8?B?WGpKU3ovcGtRL2JKeitRL3BkRHMxNTNlaUl4RnZSVWUwd05XTUdNbXhSMzdj?=
 =?utf-8?B?Nmg2QjY3QnlkU2d6NGdWd09TZSt5RFh3S1lwMHYySmZPTFp5NmI3L01HdDl1?=
 =?utf-8?B?bjJ2Nk9QL0VzTjd6YVFJeXpScm4xNTJTUmlQOUdaQ2x6NXRScUZMWm5RemVL?=
 =?utf-8?B?b3BLWEM5ejQyN28xTXQzeTlOUFN5cHRZbHlNakZkQzh0MkYxWUQ3ZHRHTVNt?=
 =?utf-8?B?NWV6TTI4U1g0K0JPcXp2aWJHekxIbDVoaU80N2twa3Jpdmp5cmQ5Q3JzeUxG?=
 =?utf-8?B?c0RqbzNkKzRnUTJQNm41REI2V1lJcXNMWlZFMy9kaXQwNnVzRUZhN0E5Ynpq?=
 =?utf-8?B?TGNqMlEyMlYyT0xqZFhabENPajN3VjJ6dDBrUjBqczJTYmFjTXhxa093OWxM?=
 =?utf-8?B?Yk9HWmNDa1djbGtoUGwrMFA4a2c1L0haTGdCMFpLb05ZQ01WaGpJY25nRDJR?=
 =?utf-8?B?SlBabWVOV0REMlozNHRxUnBnUkIzb1hRWVZPSjU2bFdrdmpjSjdrZEEwdG50?=
 =?utf-8?B?L2FGUzk5SHNpM1d6dHJ3RUZtMSs3eXRWb3VrMXdXak9qQTRoYVhBVFFqRmtl?=
 =?utf-8?B?b2RyTDUyZkpVZkxiWngzRWgyYmd1b0JubzQvQThnSnRjc1E4Z1Bhbk1HV29C?=
 =?utf-8?B?Y3B0Z3BMTlBWUTVGQm0zVTBZQlhaV0V1eEwwTlFXOW95bTJEdm5BZ2I3Zzlh?=
 =?utf-8?B?NzZWS01EQ2xCbnNzUm04eG9WZ01TdGlpVld0MENRckg5R3dNbkUyY3NLcitB?=
 =?utf-8?B?Qk5saCsxQmc2RXcwQ1BxZHN1Ty9PRlpTK1hQYno0SXNHSlNnbTJCNms4L3Y2?=
 =?utf-8?B?OTVwZUMzbk9nMGZuaTZwb0E4VVNpdk5uS3Nsc2Z1MHVvRnFMN1lqNWtIbTRa?=
 =?utf-8?B?c0tZcGJZL0pNNmlLcEY3RlRWaUpTMHUyd2R0aGVTQVp2TkhTZlNPc2NhUk03?=
 =?utf-8?B?YmM5L1gyanIvSXk4eHZSUEdGSXpQTkZzeE1aRmUzUXVzZW96NisrbUFCRUla?=
 =?utf-8?B?by9SQnVkUlhVTEdtb01UR25jUXozTk1YWFI4SkRFSGF4SCt0eWdTMFl2Qitk?=
 =?utf-8?B?bkN0a0dEY2s1Q3FWbGtNdlJmTjJHa3FuZnRVMkFEckRJdjl2Z3NOMGtkNmVT?=
 =?utf-8?Q?j+r+elXhGdd9Hwt/qyzpxQAs/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0819617-1693-4379-c2a1-08dda0774b8b
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2025 19:13:59.1579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6R+PzrFpKSL1rb+aNJGAVJbeLAmU8nRBSPFdOrD9J9smqLd4QJN/3BtKb7vSBksgSXKr/vaidpxj51VHEnnkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5605



On 5/27/2025 11:32 PM, Fuad Tabba wrote:
> The function kvm_slot_can_be_private() is used to check whether a memory
> slot is backed by guest_memfd. Rename it to kvm_slot_has_gmem() to make
> that clearer and to decouple memory being private from guest_memfd.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 4 ++--
>  arch/x86/kvm/svm/sev.c   | 4 ++--
>  include/linux/kvm_host.h | 2 +-
>  virt/kvm/guest_memfd.c   | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 69bf2ef22ed0..2b6376986f96 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3283,7 +3283,7 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>  int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  			      const struct kvm_memory_slot *slot, gfn_t gfn)
>  {
> -	bool is_private = kvm_slot_can_be_private(slot) &&
> +	bool is_private = kvm_slot_has_gmem(slot) &&
>  			  kvm_mem_is_private(kvm, gfn);
>  
>  	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
> @@ -4496,7 +4496,7 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
>  {
>  	int max_order, r;
>  
> -	if (!kvm_slot_can_be_private(fault->slot)) {
> +	if (!kvm_slot_has_gmem(fault->slot)) {
>  		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
>  		return -EFAULT;
>  	}
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a7a7dc507336..27759ca6d2f2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2378,7 +2378,7 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	mutex_lock(&kvm->slots_lock);
>  
>  	memslot = gfn_to_memslot(kvm, params.gfn_start);
> -	if (!kvm_slot_can_be_private(memslot)) {
> +	if (!kvm_slot_has_gmem(memslot)) {
>  		ret = -EINVAL;
>  		goto out;
>  	}
> @@ -4688,7 +4688,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
>  	}
>  
>  	slot = gfn_to_memslot(kvm, gfn);
> -	if (!kvm_slot_can_be_private(slot)) {
> +	if (!kvm_slot_has_gmem(slot)) {
>  		pr_warn_ratelimited("SEV: Unexpected RMP fault, non-private slot for GPA 0x%llx\n",
>  				    gpa);
>  		return;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 6ca7279520cf..d9616ee6acc7 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -614,7 +614,7 @@ struct kvm_memory_slot {
>  #endif
>  };
>  
> -static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
> +static inline bool kvm_slot_has_gmem(const struct kvm_memory_slot *slot)
>  {
>  	return slot && (slot->flags & KVM_MEM_GUEST_MEMFD);
>  }
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index befea51bbc75..6db515833f61 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -654,7 +654,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		return -EINVAL;
>  
>  	slot = gfn_to_memslot(kvm, start_gfn);
> -	if (!kvm_slot_can_be_private(slot))
> +	if (!kvm_slot_has_gmem(slot))
>  		return -EINVAL;
>  
>  	file = kvm_gmem_get_file(slot);

Reviewed-by: Shivank Garg <shivankg@amd.com>

