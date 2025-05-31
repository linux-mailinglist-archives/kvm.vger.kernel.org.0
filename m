Return-Path: <kvm+bounces-48137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C69AAC9C74
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 21:13:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCA5617D675
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 19:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3AEE1A2547;
	Sat, 31 May 2025 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CVfbX01T"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C2C2907;
	Sat, 31 May 2025 19:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748718824; cv=fail; b=lKXWm7d6VYIDDJBSFLDnC1uhqy1p49qskj8YrfRKuexQMPsfIMdglyPnINT5sp7KmI1Tanfqoc8CvGKx/BP15hNTT20FK8BzjR45lerYHG2nrKkgibD8EttMUMB43YYHnh5b6OOF5tYlx9FM7KvVBPGHqZ2ruEAQgv0lU4GWeSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748718824; c=relaxed/simple;
	bh=A8CQ5Vu3im1CKpGOAHXE9tEJ+WG3iXsBYuqTRlWjaHs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GvaOuY+Dzol5d/CsC6XUGIjXU+T9v9H4TaRn1Txn7+fc/dRKpYR86SM8On9NeQ2vhJv4yi6EZCNKeXvLIFcRPCU+iw+vs1V3jyEZvE7YKDaU9k8ZdZcserGna1l9CmyoghOjs6sWFrZlmWVHWdwGOSzvyXKSPls7S7Ah9kYRQJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CVfbX01T; arc=fail smtp.client-ip=40.107.93.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W23EbrZuAgomhK7023dYbYw8I18sEESj8jN4QrhxkAHHEQi//K83x0hXyoJ7xaB5gVHVjIFmyem4OgAagabv0lZBguXSO425DStWdAYnu5+08Hg51SrUPJBK7ZhuN0eU9QbVrezmeB4dLXA3eEHht2joaIdRtoK/M8x33N9ycDB/eOTpSgGmX23qO7tAYW3stbMpucNaXGzmhuOss+9cxq43yyJg603oZDoUxkc+pKhRijy0+mB26RHAB4CrVHarAU8SYqOxA8Ijc2arkRa8xyBAZBdmoiysnk2pTKCe6sUyuGPgCOkjHjVeNV+BU8ETKpl4r53QCipNuRBjlEFfoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=niD9hSbAeo+u8Kxd6CMP1Mf7XAArnlk7p9OVFfEj8WQ=;
 b=V3dvxhU5RSAjj1fIaHw0mr250QCVxLNYKMxzjqVDFXauRXdX3yiNU1stLdN9AFBem4ovi6C0ji+R5YT4UspDDPLINKqs/rWa6zVJ8E0aweoqO30TlQWbL4DwmuHlqSDfFhoq5/MAb/XdbE9D25Bm7JbhyNv1oVVFbbviIH3nzD0ShP9n3nMeBaXNMAnVh1CEB65WI9VJvaIQEx3VOdVdkb/vCHExENR6e5I8zmcXxhgr/y51Rtf5wirpVUU/5aebsyRo73zN8/GwIEc7XpcDSvNbExFWrj3PvPMd3s8SrgqsaX1PhI1Qy4VtgbqBgsoItOijSyrFTwS/DOOei2ukCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=niD9hSbAeo+u8Kxd6CMP1Mf7XAArnlk7p9OVFfEj8WQ=;
 b=CVfbX01TB93VblXiYsV5SVqGUaZVnqwzJjKXLCkZfBeUwJ+QdgBjU154MWMJJz4hph86Q6tRKXnEgyXgu8d9gGJAg1Dcj3oLlVDq8Z5o3ja39aWa6N5M8765qywIy6Ra4xGrnhrPYLVnXXFLAvN9CfiBuou7yqeKtfpO+tNpMsQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by PH0PR12MB5605.namprd12.prod.outlook.com (2603:10b6:510:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Sat, 31 May
 2025 19:13:39 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8769.033; Sat, 31 May 2025
 19:13:39 +0000
Message-ID: <383eab8a-aa7c-430c-8aa3-011830a5b906@amd.com>
Date: Sun, 1 Jun 2025 00:43:18 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/16] KVM: x86: Rename kvm->arch.has_private_mem to
 kvm->arch.supports_gmem
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
 <20250527180245.1413463-5-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250527180245.1413463-5-tabba@google.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6325f306-6bcd-4bd9-e761-08dda0774026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WHVKQkNXNTlDd0doWGhuaDVZMDNwNTNQVjRFOXVzM29MVnJ4UXNwbnRFNEFM?=
 =?utf-8?B?dVlMeHVBTTAyWU95Z3JPVzA0b2xVbkdWT0JsVFRma3pJWkk3SEpIcGZRbXdl?=
 =?utf-8?B?VTBVR3U4ZFRwS1hxcG1YeGdmNW1zbWZGQkFZNFhYL0hhK1NTT1NQamQ4Rll4?=
 =?utf-8?B?QVJIOW8xeDgza2VKSWs1L1lJVXNpUUFkT1FCTXdqTU5QMXBTUkNZeGltVXRH?=
 =?utf-8?B?NENXaVhmbGxmUk1NY0Q2cFlDZ1JNbXRpY1pZaSs4cFFwRm1vWDh2K2V6UHNT?=
 =?utf-8?B?ZGd0YjY3TnNMdkZhME9OYUIxNUZDUkFSN2NMbm1sTFlRSnNtY0NJemgzOGd3?=
 =?utf-8?B?eExuK3hrdlBONUpsdnVDb29oWEVOYVMxVVBHS2F0aGxXZVNYRkVrRENhQ1ZE?=
 =?utf-8?B?ZXZBeG8wRDBrdEVhanRuSWFmNHM2ZXhrVWZWME1TcEttQWs3UE4zWkk5QXZr?=
 =?utf-8?B?TkVuclNsOE5idEJXc2VLSmZLdVkxSnVyNDZUcDdtaGhqSnpZM04ya09DUCtZ?=
 =?utf-8?B?RS9hQkVaMWZsUFdVYXZ4ZmxSeUs5aGFnMjYrdGlOdFdnMjNjejVwWEwrREZJ?=
 =?utf-8?B?ajJ1VW03TlF3N2VWRzY0bUlKRUkxbEVYZC82Rmt4UnZlYVF6czZhb2JHb0o0?=
 =?utf-8?B?ZEJqdUJqQ3lqTmJQU2dvLzdMdW9NWDVwUEYzS1VqdnRab29DdzFwaU05ZFJp?=
 =?utf-8?B?SytlQTNhKzdGS1RBaTUvelIySjV1NVZiZWRXS2RuUm8vUHlsRVp1d01GanpZ?=
 =?utf-8?B?ejZjeHZnaDdzNzVwQytBV2RUUjl1WTZMOGNUc25FdnFLMHlPejJ2SkRMclJV?=
 =?utf-8?B?QVAwK3crRTRKS21DbFFDa3oveTloRHZZemJTQXhXTElPaVQ3Q01Ca24zWnY3?=
 =?utf-8?B?Rm5oYUtOaDdiWThxcDh6ZkxBeXE4MXFvMGhWTkowZ3VzMTRFeXVWWDBGdGRo?=
 =?utf-8?B?U0VqSC9BSGJBS3JQZlpvQVQwN3F4SXBuUXVrL3RqdzhkVThzUWRlOXpKTnp6?=
 =?utf-8?B?QXdyVHQzYlBjWW1rV3I5UUl1RkVlMllyVTQrR2xrTlBVR0FQYUxzemNRd3Fs?=
 =?utf-8?B?TzZtSWpkRnZRUkI4WlVtcFhPSkMyVHRiSGFQWmhLQ3lUUjh0REpORnY0R0J3?=
 =?utf-8?B?K0Y4azNvbDV4ZkRSYlRPcG56SDNEcFg3Q0J2cE9Ua2ZWY0FuUXRNMDBmc0pW?=
 =?utf-8?B?b21NS3d4VDJSOTE4UjJjSUZOTGx0YSs3UzFuS1gwS3hXNm5kdFlON2dkOUwx?=
 =?utf-8?B?Z2VTUHJYOERtb1g3ZlBCS2xERURINGhqaDZXQUtXUVF6amlZU2UrQ0dnSUNT?=
 =?utf-8?B?U1AxZDJ2WUp1SnhzdmhpYnU5T1VESUFJQjB5ZjFUemEyMEl3VzV1R2FUZGg0?=
 =?utf-8?B?ZDRjZjBMVzc2MnNVSlhzZUlLSVlpU0plZ3NZTnpxQ3NTK1l0bWZnT0RyRUdJ?=
 =?utf-8?B?WGFCVE1NVTRKai9jS0dVQVFGTXRXVk0vZHB0SStOSnBreEtObXFneVVmcW44?=
 =?utf-8?B?YWRrTkxoVE92cUhyY2F1KzFPN0lqeXFWdlk2czR3elBPRERvVU52eHNJYXF5?=
 =?utf-8?B?SDBNSjIwSE9qSUZ1STRZbmF6S3AwMUJzWmpCUWdPWjFNNCswNHZFbzFSMCtu?=
 =?utf-8?B?UDRBWEZpb01GWE9UQ1AzMEpXS2RMVlVwY04yMlZzaVBXSEhqbXJMTFFZN0Nu?=
 =?utf-8?B?dGFXWE9kemxqY1F5VDNJeC9rNGJ4UDQzVVE3VUtxSHRJRW5nQ3B6aThvck1X?=
 =?utf-8?B?M2xpTGRtM1JzckwzVWwxV01pdkVWZEh1MFZxYi8xSnQ3THQ1aS9XdXRUUXRH?=
 =?utf-8?B?bHNrMkJuQ2txSUhYVWd3dXVqTWVTMm1nTER3WnBsTXpYcXZsc3BzSlE1MnVH?=
 =?utf-8?B?UDkyYitocG04dGNzdkhUMGFVSFVJY2hrL3Vyb0RhVHAvV2RhaHowZ04xbXph?=
 =?utf-8?Q?imrRroZmZT4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1dHVUpYbFpqM05TekdxbTJDSC9sU2l0dEh3ckhjbVVpakQ3Zmp3UlRUSk5B?=
 =?utf-8?B?QkpUQ2tOT2V6NUFoNU1LS280V2s0N3NRV1ZscFE5OHl6blI1UlMwVVpFclQ3?=
 =?utf-8?B?NnppM1FqemZUVFQrVnFxL2lhMlVJa1lzYkNBblBhbEN6M0JJR3RQbGNvWkVB?=
 =?utf-8?B?cTdJQ2RBYnJXTXpyMUExRDRHOTl2eVJhYWg5MktDL2Q1b0FnaGpNR3pySzFy?=
 =?utf-8?B?b1FjMDV2TmZPYUdSWlFwQXNTN2d5Z20rOHdwd1BoOTU0eEdzU3NpMW9Lb1hQ?=
 =?utf-8?B?cklTTitseU9HRE01TG1NeWhDUE0zKzNDZTduU3ZKR2ZiMU9zanBiUVM4OWU3?=
 =?utf-8?B?bkk2UmNoNCtaOXpYQTFUUXhUR09pUFZvS1lWMnBxVDUwTDRvYzlCYXZ3YlJm?=
 =?utf-8?B?T25vcmZrOFdkS05lZG1kOWdqdk40QytRbzFKYlZnUG1CbWYyVXhXaWFCS29O?=
 =?utf-8?B?NmUrOHA3UjNhbWJCcGlUekM2R0MycGxLRzFIWEZCY0VNOTBtNUUyam56VGVS?=
 =?utf-8?B?Rm5mam15SU1vTXA0Sk52aEJGbUUwd0Q3SjAzOTUxOUFrWEZ4dkZIWW5FdEZJ?=
 =?utf-8?B?ZEx2czlKOGQwKzdhVlI4MnFlRFRoN1ROK3B3cTdBMFhEU3l6RnlvSm1ON0th?=
 =?utf-8?B?UFI2SnErT245c0pCNG8welViZVp4c3M1UGNEdnR3dGh3WVN6N1NnL0JJYnRQ?=
 =?utf-8?B?Ylc0cVFvUWc0UEZEalBESEF0RlJZOGdLdzd6WHNLN3lOcXFGUVRCcmUrY3E4?=
 =?utf-8?B?QlJyWHRJM1UyZWpkVC9OQjFwQWtHTTJRYXVUNmVkMXhYZS8vN3BDWElLVWxB?=
 =?utf-8?B?UzI0UFE5WUJadU9PcDFoREp5V1BYc09DbkMrWXdIR2p2elpZaHdVUHdoZ01C?=
 =?utf-8?B?UXN3RzIyYUZhUG9FQnREWTRlMHlUb2pKNkpvOGFTbFBoZFFnSXY2VjFRejlW?=
 =?utf-8?B?aGhkTmJXTTBmVnlXYjBGTEJiMjYxc2gxQXJydDE3U1J0azNiNXdFR05vUnla?=
 =?utf-8?B?MDluMVBzdjM4N0VtbzloTkNXUjdwYXVZeXl1RlpRU1Q4NHp6S1B3Vnp1SDBC?=
 =?utf-8?B?SjJPT3NHYnZNejhSdllPVTVUemVHL3hoQnR4VGp1ODlNMW5GSFNnalZQS2xP?=
 =?utf-8?B?b0hmeWk1bENIbEQzUzZSbGhpWDdyU0c3cjRwVWVWM21sTjZQdUdJclM4S3Qr?=
 =?utf-8?B?bVN2eHBSZ0pVT3ZRS0JHMU5hVFh2cFRKVk1RMkpYTjIxRE5ZSGVubWU0OU5P?=
 =?utf-8?B?YzRENVd3eDNzeDBubDlVNXk5aWsrTHdNNngwdXd5MTdwQXJ0cWt2UEVLZkRv?=
 =?utf-8?B?Z2NBeXlpNjM0SnhWeFM3RWpBbXpkOXZ1aWtQZlhPTWUyTmp5cU5RdEhKK09w?=
 =?utf-8?B?QXJWbTVZaThUYVBiZXhjNlJqeGQ3bFpDck0rQ1hsVHQ3a1MvK1RYRjJJKzkr?=
 =?utf-8?B?alBKajVPMUEvMFRsc3h5ZGR4cVdydStISllpbzMzd0VLWVBVeEs4eGV6bHcv?=
 =?utf-8?B?ckhBQXdGUnpwUXdndlJVcXNyUUErclVPbzBBam5ITGVTRTBnL0FGSlBkWlhn?=
 =?utf-8?B?enJwSzBwU1RtUmxXMjZub1hxUUxuZUphUDZXWUlqM3lLM1R6WHJVbDl4b3Rk?=
 =?utf-8?B?dS9FaEFLaUoxRVE4aHQ4MWN5aUYvOWNhWm8zMUI4OUc5MXNQeTJIdXM1SmhM?=
 =?utf-8?B?WXM0SW1QQXJEaHFKa0czUjgrWWgvWlk3YnRlQmRuSW56Nmp4MjB3dnZPRkVz?=
 =?utf-8?B?bjJZbnNicVlHRnlqTnhRaXpCQVVSMUU5eVBWVWFOaXFyNko2YlFBRXE1cG55?=
 =?utf-8?B?N2dWU1owdmRVSVNDRnZ2Yjh0YWtHUzA5NGtPa0ZEYm5peVl6L2dKNU1pNXA1?=
 =?utf-8?B?SGNBd2xSWUMwZ3FwNE5zd0lzb0szczh5ZlIvUkYvZ0ZyS1FjaE9nd0JUblRY?=
 =?utf-8?B?b1J4a2ROVlZ2UDgzazZqT0RBTVFGRkFTL3cxUStyMEhoR2VpeHZTL3c3cHRQ?=
 =?utf-8?B?N3VxLzl6NktOa2lBZzBjb1RkZEpYcFRvdUFxRURraTN4NkI2Q0R6NVZ6dFVY?=
 =?utf-8?B?T0IrQzRDK01xSE1uK1lSbVE5cWhrRGtqcm5uVjlCZ1lCd3RMRGhEbjRkaVFk?=
 =?utf-8?Q?jwPFk2bb/k39FZrjMwOybcQzo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6325f306-6bcd-4bd9-e761-08dda0774026
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2025 19:13:39.7526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NuvUiYuGc2THtcCdmy8uVrDoZwiYcCiFfXq6Wk2DoHAz8ngfMHDG5huO4HmjnCEVz7ichTFZtvAAHSr5PFRixA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5605



On 5/27/2025 11:32 PM, Fuad Tabba wrote:
> The bool has_private_mem is used to indicate whether guest_memfd is
> supported. Rename it to supports_gmem to make its meaning clearer and to
> decouple memory being private from guest_memfd.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  arch/x86/kvm/mmu/mmu.c          | 2 +-
>  arch/x86/kvm/svm/svm.c          | 4 ++--
>  arch/x86/kvm/x86.c              | 3 +--
>  4 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4a83fbae7056..709cc2a7ba66 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1331,7 +1331,7 @@ struct kvm_arch {
>  	unsigned int indirect_shadow_pages;
>  	u8 mmu_valid_gen;
>  	u8 vm_type;
> -	bool has_private_mem;
> +	bool supports_gmem;
>  	bool has_protected_state;
>  	bool pre_fault_allowed;
>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> @@ -2254,7 +2254,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  
>  
>  #ifdef CONFIG_KVM_GMEM
> -#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
> +#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
>  #else
>  #define kvm_arch_supports_gmem(kvm) false
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b66f1bf24e06..69bf2ef22ed0 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3486,7 +3486,7 @@ static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault
>  	 * on RET_PF_SPURIOUS until the update completes, or an actual spurious
>  	 * case might go down the slow path. Either case will resolve itself.
>  	 */
> -	if (kvm->arch.has_private_mem &&
> +	if (kvm->arch.supports_gmem &&
>  	    fault->is_private != kvm_mem_is_private(kvm, fault->gfn))
>  		return false;
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a89c271a1951..a05b7dc7b717 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5110,8 +5110,8 @@ static int svm_vm_init(struct kvm *kvm)
>  			(type == KVM_X86_SEV_ES_VM || type == KVM_X86_SNP_VM);
>  		to_kvm_sev_info(kvm)->need_init = true;
>  
> -		kvm->arch.has_private_mem = (type == KVM_X86_SNP_VM);
> -		kvm->arch.pre_fault_allowed = !kvm->arch.has_private_mem;
> +		kvm->arch.supports_gmem = (type == KVM_X86_SNP_VM);
> +		kvm->arch.pre_fault_allowed = !kvm->arch.supports_gmem;
>  	}
>  
>  	if (!pause_filter_count || !pause_filter_thresh)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index be7bb6d20129..035ced06b2dd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12718,8 +12718,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  		return -EINVAL;
>  
>  	kvm->arch.vm_type = type;
> -	kvm->arch.has_private_mem =
> -		(type == KVM_X86_SW_PROTECTED_VM);
> +	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
>  	/* Decided by the vendor code for other VM types.  */
>  	kvm->arch.pre_fault_allowed =
>  		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;

Reviewed-by: Shivank Garg <shivankg@amd.com>


