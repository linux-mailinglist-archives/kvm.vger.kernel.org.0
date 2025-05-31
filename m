Return-Path: <kvm+bounces-48136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9CD0AC9C72
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 21:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17FEB17DFF0
	for <lists+kvm@lfdr.de>; Sat, 31 May 2025 19:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407F41A23BD;
	Sat, 31 May 2025 19:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S49+TCEA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3052907;
	Sat, 31 May 2025 19:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748718789; cv=fail; b=QdlipOz/rcEty5Q9VAwv2QHSfLbX4OEBMCQc6dRBdWalsJMslPl/HSx3P3HL86G5KyjTsebs89rN8ZVq57ldBaTD5vFxzoPeKofArEpl1kuGKa+VkoShY2B2r95V048yv18HfZSsA8XfNA6wLvmy0mv3vzGUfdjKyhe78MoCllo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748718789; c=relaxed/simple;
	bh=3A1KdQ6b1SQ9QYGpBHeFar1DGR9Gpo+txFDRBZRzbVY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KFiB3N5VLtFd6Y2xlPsQx2Yn/7Fj0Ub8p6pNDtsbrhx1gZBxbZTaaJD7q14Vzl91kZlDKzT3EzDRFiNViGEupbNyJp8oCOP2X3gliFdF5MpY7LRu9w8g/nWzRac4q8a6cPuADYsgwzQC3X+ChC+XDIGEmdNRqbO2aIF79i80tQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S49+TCEA; arc=fail smtp.client-ip=40.107.223.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MqVS5mf9BaBmkqFFVMZRNzug/bkYysGvWs2vhUURGtbx9ot3tIz6XPPfVuLHKVcJkR+iRIaFUi8Sgdkmw21NwNNaItBGozjrWL5+abHuq9bzR0COFZ8lisCUO439x/Q2wv/mMMu36xq3Hbv5OzTOYFb9yRyGiyRjG9FL0jv3FMZPpNyUzvPZD7rs8vONRsJ1zyA7pEXCl9bp64nT2+TDS5vNsDu1Kk/jnJI/nxe8ob5KObI2YdtOoFyG1XupG8fVIPi1hl+E1+DS7tPU0tBa5wAbfV6mLXD5KxUFY6wpFsI5/shPX9LNZbxRsxSgoY6IYanmvMVfStL49TjYC9tK1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fe5AHMDisbS0vu+kFyMej3cEYHjRKhKQXtV42JjLbwQ=;
 b=Xh0GNOLAVib7zpe9B10dC+QvPFUNDKgWSBwqIPGhG56cdmMZwS+7nIrHcR9zO/I/soNSc1KVWMiyuLz/dkaSyK4PjMLKMfIwydZmTOo9YeiCeYmHjXwPNWNKAZIqy2YukOdpe/UB4OigJhcizhqHVl3PLvwzTgN+mcloK68aS9uaYt271x0rBthW/lMppcUj2XiLUqQU0wYzf/k66pk8rDY57AiEAdHVVlqxeDhV07m6A6u0r/5jpYNu24IBLgeeqAGDRcvpgRCQ1lEfuZQiNU2Cd5+z7z6+9TiE4p8yAClWk43W7U+Y/j5vRlSPpb+Kr6oPc3/JPy2JZoRTRLjU/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fe5AHMDisbS0vu+kFyMej3cEYHjRKhKQXtV42JjLbwQ=;
 b=S49+TCEANdqVBhDi96fY258HAZEy79lpvmc7WltRmMq76hR54n84ynacTd2Mwq8Q5Y7K+GasEYRnPzYklVcwwb6sVrUcWSWaPQjNxuOwQ+4yknGeSlagyI8mBvncC0/9ryWYOz3ADe0NHBjFB/3uIVKcdrph09/DWwyEWWkm1ik=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by PH0PR12MB5605.namprd12.prod.outlook.com (2603:10b6:510:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.36; Sat, 31 May
 2025 19:13:04 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8769.033; Sat, 31 May 2025
 19:13:04 +0000
Message-ID: <383ee45f-756f-4188-8dd0-634f8a463190@amd.com>
Date: Sun, 1 Jun 2025 00:42:43 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/16] KVM: Rename kvm_arch_has_private_mem() to
 kvm_arch_supports_gmem()
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
 <20250527180245.1413463-4-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250527180245.1413463-4-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0163.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::33) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|PH0PR12MB5605:EE_
X-MS-Office365-Filtering-Correlation-Id: 76375c2c-a0b7-4192-0b87-08dda0772b03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDM3MDB5bEdETnJxcU9ZWmhrRHNURDE2WWE2SEJNQnZUYUV3SzkyTDJZSy81?=
 =?utf-8?B?RnIzemNMV1F3UXZrYmFjSXhjaGJqeU9JLzFKNm5tZysvU3hodG5yZlY4UFZP?=
 =?utf-8?B?cnNmVTBpNXpNdVIraFVPVnQ1K2ZMWllnSzBSL2NhUFNIKzhRZ1VzZlJDcmRD?=
 =?utf-8?B?R3FLQ0ltUE9mNWhsTnBHdER2cTdvc2Z5RWhtSlB4R1BiYm84Ny9JTWtlOWZ1?=
 =?utf-8?B?dWxZVURwMHJaT1pOa2ZUTDlCS003ZUV2RUQyY294QXNGOCs1bFo3cmFjVTM4?=
 =?utf-8?B?bHFyRlFBUVVqM3J2bitmUE8zdThSYUtrcy9DcEJDRlUvN1hVVDJYZDh1Y3JC?=
 =?utf-8?B?WVhzZDNCVUpmaFVVMng2aGF1Qk1TdHZJbTJBaFBSaGcwNjlhMzlFc2dpN2o5?=
 =?utf-8?B?cDhMd2lhMjhIdWRIdDVlVkRVaDZoc2NtWWw5RmhYdWNvbGNQcVlJQWU3YVBu?=
 =?utf-8?B?SmdzYWxzT1Vzam9aRXdOTnFlWXJIRWdKM1JTSUNvM09Uek1KK1BMRXorUzdO?=
 =?utf-8?B?a2ZhVTNNRlB2VVllbS9hVlRYbUtTc0VOS2xsUjdoNlZZQlZPVjE1b285Q014?=
 =?utf-8?B?OWxPT3RYdFVRZjVrZnVZb3ZXeWFocTl3YVYrVnY5eFUvaFVHVmxjelFWT2l2?=
 =?utf-8?B?NmxEb0wxRkRlTjl2V3pWOVNFVDV5UGZDdkRyb2JMa0szZWFOVGVlbG5rbDBV?=
 =?utf-8?B?cUFQTENObEY2U0NwV0kwM2EvT3lmMk81TDFLM2JLelJmMk1CL0xQR290TzNG?=
 =?utf-8?B?bVhmVDJGQmR0VVd6emM3Q1lqck1OOVJ0SFd5ak84Uk1DdE9SSnFHUy9YMHlW?=
 =?utf-8?B?NGtiU252VEY4Ym9oWHJqcFM0ZHgzMVp4N1F0U0FaRy9nQ282SDdlZng4NUds?=
 =?utf-8?B?Qnd5YWVnR2Y4Z0xEYkFGWUFjejMyZmRMMGZEYXoxQXIyNkd0S0ovVHR5dmRw?=
 =?utf-8?B?WFZZV2dGSXlpQlFVbFRJT0VZNy9kWUhaVHlWMy9GZitodzZTNTVIaFZSYWtm?=
 =?utf-8?B?NUorZDR4aTdvdWtGM2xvRDFUcWhkLzV3bUpmTVBVNWxIVEQ2cnpGbE1mMHhH?=
 =?utf-8?B?NS9PaHBzQTRjTElSOVQ3cUY2M0pRdFJtanVsdUJPZEUrc1ZJWlVaTXpJWkpk?=
 =?utf-8?B?TVhKR21wcGtYemEwNlJhb3VmVEV1NnN6Y1BSK3hWamJURnpSemJaa1lSYVJ3?=
 =?utf-8?B?QjJ6WFQ5SmR0NW9UOThjQk4zUUJKb1puQVVXeFliTDRHZFk0QUxJRmVLcE4y?=
 =?utf-8?B?dTBEZmlSOGtRV0x0dG9relNIdVhVOENQTGxnWmNDNk1jV0I3OHJOTGQ2bEkw?=
 =?utf-8?B?dm5xVHM4ZU5lOW1lV1lpTEpXWG9qVVdpZTAySDB1b09vc2szVGl6ZGc1TGdM?=
 =?utf-8?B?bnZIQ1laSW0yV2JDVWlLM3Y2dmQ0dmc1RjFuemJtV1lxMEhaWVpUSkMxNnVK?=
 =?utf-8?B?UGtScTR5Zm9EOFZoQVhjK204aXhjQzdsbklsd1BtcTgzSTJ6SldtUDhxS2V6?=
 =?utf-8?B?d1lUaWQ3Y1RBUkxhbnEyNnBjMnY3LzdHYTR0WW9ydnE2bFBCd3ZmMU1TUUlu?=
 =?utf-8?B?WFNFenYreVdIOXVTb1lwZEdHcytndlVPTUd3aTZ3V3lrSzNOc1RrOGJXa0ds?=
 =?utf-8?B?ZEJHNTFzSzAveDdLRWJhRDM3eWY1dTV3a2J6UlNJN0U1czNGYTU1UnVrT2pB?=
 =?utf-8?B?RzBQdzQ4VGNCM1d6Rlp5aUpkVngyOWdYblRucmQzbVo0eXJxY0JLMjhCOFF4?=
 =?utf-8?B?MWtCci96cWJ5cDJVeVZKSFBXWmIxRkpRcTdUaE1XOE5zcXo3UUtpTW81dUNR?=
 =?utf-8?B?ZTRCNGhuelgwVE5YNWhCaTNrWUhSZm9HZnZZRUtKbklhVlphTytHR3F5N256?=
 =?utf-8?B?QmhPaCtYTVkzVTB1TWNQam41TXVocGg5VS9jcTRDWitJR0pxYWxvZVozMTNv?=
 =?utf-8?Q?2ESwc73PA7E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ME4xc0RHSU5iQnN6R2hHTkZsdlQxQWdYeGczeDVQNDRsSW1FWS9HTjZHbTN3?=
 =?utf-8?B?ZFEzV2YrZXlkVFNQWU5uaVE2WnlLMTRBQmtTM1k2b1lSN25LdmNQSDFLTlFO?=
 =?utf-8?B?TmhIYi8xYkZLSjFCY0VSZDFtdmZVZ0UxTUpBVGg3SWVxbVVNNlV6b3pJL2x6?=
 =?utf-8?B?dzlmZlZNM1FseGx2ZVhuWW56QTlOQnFBTDZkeDNXdDJhbHdJK0hBU0lKRWtT?=
 =?utf-8?B?SUlQejczQ1V2MSszRnlWSktWd2tjYzFqcStLNTRMSzI1cDJGTFJqU0dOMlYw?=
 =?utf-8?B?bkFaZGhabnZFNFc2OFpUYnlNUGc1KzdxYU5PaDB4OWV2dGt6cnVOVFFaNC93?=
 =?utf-8?B?bE1oSlgxbHZaR3BOcmxkUEtveHFCMkhicTZJUWVOY1NLSUZ6cmtISWlQbWhq?=
 =?utf-8?B?TnM5YTFPekhsMUJoMTVpUkhlL21jSW1XUVV0c0JqM0JWZTJabHhFU05SeWZ0?=
 =?utf-8?B?a2JGSFMrd2ZucXFISVB1ZE9UM05DYUlLUUNLdDcwZWxUYVdsNVNzeUlxeFU4?=
 =?utf-8?B?L1kxV0ZkZERYbkR0SEo1bXpDa21aSXN1OWhIZ09nc01MYTJUM2R3c1Q3ak82?=
 =?utf-8?B?RFpRL3VxdnNHakFUNGlDOHdReWMxaVVRT3JYN1BidVZDeXRndCtGTXphZWVN?=
 =?utf-8?B?Yy9pL2hGUGlmMVZEMTVDUW9LY2VtRitvL2gzdDU2VkdKMTJVQnptcnVKUFlU?=
 =?utf-8?B?SEp2ck5UZXkrYWhBQ3FOdHpkVEJFOExOWEdwUXRERnJlVklBdzJPS0pmeGQv?=
 =?utf-8?B?MWRhYXBKQkNhaWg2cjRkOTZCWXQrOS8xeGIrWnd2ajVSVmJLTDJIQSsxRkJq?=
 =?utf-8?B?eUcrWmVUK284UmN4dzdValVnQ3R5ZTYrbFJFbE1FakF2VStFdk1DQ1ZSRVRa?=
 =?utf-8?B?UjVWVTJTU2Z6RVdaYmVueFkvcDlITWV4WWlqdloxMll3Rmt4T0xQZUNYUk1H?=
 =?utf-8?B?VG5laEhLYnRiWUc3V2hWa3p4TW51TFFTMlUvL3E1cUc3Sy9EVlFyZ2ErMWhD?=
 =?utf-8?B?UjNxaTZzSjh5Z2dDOVFtd1dzWmZNd3ZaeUJUUjU4MlpnYzE0TlJDN0p3SnFq?=
 =?utf-8?B?Uk5icTZEZFUxTzkxMVJCU1F1ZDFHV3AzT1IzMzJ2WDZMRHF1djNVQzJQMW1V?=
 =?utf-8?B?cmpjWStCMGhVZVYxMXZBNm8zbzJuQlkvb3dwMjRIWmdGbGJ0eEpZeTV3SUdz?=
 =?utf-8?B?MkwveW5nVWZGd0RzdU9tSXYzazRGdytTZmtweVplUVVoU3pENW9GOXBKUVRx?=
 =?utf-8?B?dUNRUTNWWENDVGlOUjM1a0tFWm1tbFJJS0tMNjRCamh6YXlPVnl4L2k1YUlz?=
 =?utf-8?B?VzJEODlYV3VpUHBCM01paDZ2ZTNaR211L0xCRVppOVRQRnprZS9Jc3hzRWpL?=
 =?utf-8?B?azVzZ2JxVVQ4Rm9QWUV6UHF1RDYrRWxhSkpJZUcwSk1rV1R0RlNzMVJ6V1p0?=
 =?utf-8?B?alJuNHFEbFNOZnJoZWFBbFVjVDM5aFhxZzhpYklPckhmWWFKUGhEK2VHMUwr?=
 =?utf-8?B?bjE5RVcvT0lnOVFzRDlrSEQ3SHkyaVhaOGlvOUtEK3R4RUNKeGVVRGZqc0p6?=
 =?utf-8?B?WkwzU2NNeForS0M3TTltUDlxSDhEdm80alpTT2R0VVRqZ0kyOStJYXQ5czhJ?=
 =?utf-8?B?Sld3Vi9vUGo1cUkyelVrWTF2SXJXY24wU1c2OS9yblRtY3ZVZ0hyeVRqZzl5?=
 =?utf-8?B?cnZQRHhlcUtSOUxCVTVSdzFyQm9zdmVyMDd4dkxnVjdSR3Q1RVZiK25ubXVT?=
 =?utf-8?B?UTNqTUZRRjZjNjd0ekxod0NxejhlMWRRMm9keVdCYXYyZXdLdEUvMlh4bE1h?=
 =?utf-8?B?Wk9lRys3Z25tL3pTV1JYWFhUaFF3YktHTzcyQVV0MzRyWVg0SmwyUVdNblpp?=
 =?utf-8?B?aklxL1orSDJ1VTIvY2pMVHpiS01KQzB4UlVkU0xVc0xLM1kyVW5aV3doSmN4?=
 =?utf-8?B?dnpESFBqODlVMld5UkV1QlN1S3BWVng3amFhYXlDL1VzaWs4Y2YzVnZyL3lJ?=
 =?utf-8?B?bmtzZXNoWVpmaGpvMTFCckVlMzZ1TkJ2aTNmbU9XcEloMlhBd2U0S05acXNa?=
 =?utf-8?B?L1p1elo4Y3JPZ0c1V28xbDNraFF0bkk1T3BEV1gyWHR5M1NmOHlGaEFXMklj?=
 =?utf-8?Q?ncZL1zOgnb+s0AqG5cFEHSTOr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76375c2c-a0b7-4192-0b87-08dda0772b03
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2025 19:13:04.4681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wllff0/NeQGNqov+NcLGfMwxjBHiH4/2el1tOxq6v9qQdWQfxsJlhcD9ziGyre74Qw4AcZnUWarVZAqqOM1Tkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5605



On 5/27/2025 11:32 PM, Fuad Tabba wrote:
> The function kvm_arch_has_private_mem() is used to indicate whether
> guest_memfd is supported by the architecture, which until now implies
> that its private. To decouple guest_memfd support from whether the
> memory is private, rename this function to kvm_arch_supports_gmem().
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 8 ++++----
>  arch/x86/kvm/mmu/mmu.c          | 8 ++++----
>  include/linux/kvm_host.h        | 6 +++---
>  virt/kvm/kvm_main.c             | 6 +++---
>  4 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 52f6f6d08558..4a83fbae7056 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2254,9 +2254,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  
>  
>  #ifdef CONFIG_KVM_GMEM
> -#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> +#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
>  #else
> -#define kvm_arch_has_private_mem(kvm) false
> +#define kvm_arch_supports_gmem(kvm) false
>  #endif
>  
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> @@ -2309,8 +2309,8 @@ enum {
>  #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
>  
>  # define KVM_MAX_NR_ADDRESS_SPACES	2
> -/* SMM is currently unsupported for guests with private memory. */
> -# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
> +/* SMM is currently unsupported for guests with guest_memfd (esp private) memory. */
> +# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_supports_gmem(kvm) ? 1 : 2)
>  # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
>  # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
>  #else
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8d1b632e33d2..b66f1bf24e06 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4917,7 +4917,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	if (r)
>  		return r;
>  
> -	if (kvm_arch_has_private_mem(vcpu->kvm) &&
> +	if (kvm_arch_supports_gmem(vcpu->kvm) &&
>  	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
>  		error_code |= PFERR_PRIVATE_ACCESS;
>  
> @@ -7705,7 +7705,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
>  	 * Zapping SPTEs in this case ensures KVM will reassess whether or not
>  	 * a hugepage can be used for affected ranges.
>  	 */
> -	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
> +	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
>  		return false;
>  
>  	if (WARN_ON_ONCE(range->end <= range->start))
> @@ -7784,7 +7784,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  	 * a range that has PRIVATE GFNs, and conversely converting a range to
>  	 * SHARED may now allow hugepages.
>  	 */
> -	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
> +	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
>  		return false;
>  
>  	/*
> @@ -7840,7 +7840,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
>  {
>  	int level;
>  
> -	if (!kvm_arch_has_private_mem(kvm))
> +	if (!kvm_arch_supports_gmem(kvm))
>  		return;
>  
>  	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7ca23837fa52..6ca7279520cf 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -719,11 +719,11 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  #endif
>  
>  /*
> - * Arch code must define kvm_arch_has_private_mem if support for private memory
> + * Arch code must define kvm_arch_supports_gmem if support for guest_memfd
>   * is enabled.
>   */
> -#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> -static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> +#if !defined(kvm_arch_supports_gmem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>  {
>  	return false;
>  }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 4996cac41a8f..2468d50a9ed4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1531,7 +1531,7 @@ static int check_memory_region_flags(struct kvm *kvm,
>  {
>  	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
>  
> -	if (kvm_arch_has_private_mem(kvm))
> +	if (kvm_arch_supports_gmem(kvm))
>  		valid_flags |= KVM_MEM_GUEST_MEMFD;
>  
>  	/* Dirty logging private memory is not currently supported. */
> @@ -2362,7 +2362,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>  static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>  {
> -	if (!kvm || kvm_arch_has_private_mem(kvm))
> +	if (!kvm || kvm_arch_supports_gmem(kvm))
>  		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>  
>  	return 0;
> @@ -4844,7 +4844,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #endif
>  #ifdef CONFIG_KVM_GMEM
>  	case KVM_CAP_GUEST_MEMFD:
> -		return !kvm || kvm_arch_has_private_mem(kvm);
> +		return !kvm || kvm_arch_supports_gmem(kvm);
>  #endif
>  	default:
>  		break;

Reviewed-by: Shivank Garg <shivankg@amd.com>


