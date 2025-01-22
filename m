Return-Path: <kvm+bounces-36251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC68A1941F
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E3493A2281
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 14:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E9E21421D;
	Wed, 22 Jan 2025 14:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f5+c2mAI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687691F94A;
	Wed, 22 Jan 2025 14:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737556785; cv=fail; b=gMu2qoeSFNY2d1KtmPOoZ/HHzSSurm0HTMOvrdWh5+3X7VuVMpJBhBv6iH+BtK60glTRaolO8Jr2hQR3hj3qvsRmDcPNHi+o7wwbX5JYDxiAPhbNAXPx29GyvAZf61Xb0i3/COO1UrUppNNlgqPuZE4QZRNZsK43wXy74s82mvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737556785; c=relaxed/simple;
	bh=/zXdZ12afTi6Jf55KQTNwEgYHmqWw9ehKykgcIV9kg8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ODVjEn4jWmQns0VZwxZEnGkeLCKYIy69Fb9vLw9u8Rn0mdgPYdYK1Sn7a+yQawzJr28O+eSBxA8uW3zTaVzi1/qKn8nxxTZ0C5mcHbVEXCzW8vBfIC6ztLMXAsb+BpkODbX6HS3uubpWkauIufWyCytOZ8zZ/V3gsEoBTtUklwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f5+c2mAI; arc=fail smtp.client-ip=40.107.223.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q4kWofSc1U3WTnVTCA8atLi2Gd3XlceFfCunQ1lf+1EU0eAmNGwV0M5ozaiycEWePIYv5nPZ1bqQvP7PTYYwtV/z5ag9Men6hVIngkNoMRICD9BTvzGwmbzzXHEm00HlFpyaqsZOcSS9EpXM9IKZsoQ/gXyAnaMxIivS8KYpu++nVLCDzAVaervKkR7dxMDQRVk0A9bDfGTjjautkJp2xyziclt1MUTeq62O4kmw6gkICExyhF2VCdXil54q45c3TNYdKXHFo/wOECE6xF/aA/rRIi+7Zch3ZTrZN0qTw6lQe4X+Mf4EFNU7ee1J2Cq3rn9spHcHxz/vSyB66HSp/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjRhpPzJUDQEwVLeisE/zIBKaQExIT1Q+dFPAgB/Q1o=;
 b=SKG09PBHqoY9+w+NWfHSSx9r8N+opo3oNuDC7Rbhhx4rGMrcFBA3xeGxrDwMAc3H1PZbz9QAqbj6MmHM+3n80tKALj0VAoZUrABPJmYg18/E9FC4Q1XNGOc1+XIxEuRHvGkiJFymCuReBUiXIHFY7v3j1ol3uCzBS8sYutaeQg4PAG0JBN69G4fHgXiHEI0NZZvCvxmz+Wr2ZvzDnDGeAhhhHopvzkrbU324Dhy5Gp/XK58zyL6+rnX/mGSILrK1bc+KFgOfMgTh7qSAhEn/P0NFcQvWCRyWrNYFfpYwX/rzNdT2TWLp5/KsAKmoyFLJUffhcjIKndy1vTYKCAtcIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjRhpPzJUDQEwVLeisE/zIBKaQExIT1Q+dFPAgB/Q1o=;
 b=f5+c2mAIDPrtT2PEMxHDElZugREYvCQXAISoWvFUynojDuX2WIpa3tEyc6/Swg/vbfLWg50Ab+kYBNsZCye4MwBng3YjaaSA08iTS0KTCJfJXK2iHfBiloF/TBq4ZIIVogd/Yzg+0tF7CL4nhbQTHU0r5tyaxPFpOV1Btl20kmQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 14:39:39 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 14:39:39 +0000
Message-ID: <80a5a52d-68d9-b4d3-e243-7720a097a3a1@amd.com>
Date: Wed, 22 Jan 2025 08:39:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/5] KVM: gmem: Don't rely on __kvm_gmem_get_pfn() for
 preparedness
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, jroedel@suse.de, pbonzini@redhat.com,
 seanjc@google.com, vbabka@suse.cz, amit.shah@amd.com,
 pratikrajesh.sampat@amd.com, ashish.kalra@amd.com, liam.merwick@oracle.com,
 david@redhat.com, vannapurve@google.com, ackerleytng@google.com,
 quic_eberman@quicinc.com
References: <20241212063635.712877-1-michael.roth@amd.com>
 <20241212063635.712877-2-michael.roth@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20241212063635.712877-2-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0054.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::29) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV3PR12MB9404:EE_
X-MS-Office365-Filtering-Correlation-Id: d2666122-44c0-4216-181c-08dd3af299d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnpLRVRCTEZYSEQ4VmVzS20rL2ViWURkUUdMbDAzWGxpVkhQdnpiVVF2eXpr?=
 =?utf-8?B?QkVVckhHSytqVjdLL1E3ZFJ4UmJHempGZEh5WDlvZlZsUTBRVThrdDg2MXJo?=
 =?utf-8?B?NWNHS1oyc2FpdmdhR25zendPU1RaVHFnQmdLK3UzYTBvMzMvWVc5QVBDTWlZ?=
 =?utf-8?B?ais0bzhDTkJNa0RGOGEvWmhzYXRlblVCSFM0cUNVbVFYamc0YkFMQVJHN2Yv?=
 =?utf-8?B?ZnhNdzE3bnExS0tCK0w4cEhnWWNpbHl2dEhOS3REcmIrTUE0dFZxYkp6eHZD?=
 =?utf-8?B?MjYwb2xDWTN0dmtrcEhaV0c5amVDY2FLVWN0bWt3L2F1L1lOd3BSS1o1by9x?=
 =?utf-8?B?K1R0RWtSVCtkMWRpVi9YbjZpMFp5VDBpc3lHUTNCZ2wyWkduakJrMVNZaW1a?=
 =?utf-8?B?MDNmL2xia2V1UmZiUnVUZWI2ZXZxaUFKVXcvQlV4NkcyTlVBNkRrSFVSRStD?=
 =?utf-8?B?SVBIVzl4bFBmbGpxcE1XcUJuaDRhNy96aWJkcm1PcC9kRzNJa0licjFjL1Uy?=
 =?utf-8?B?UEFmckUvSU9nVURFL3U5UEZBTDZiZjlSM1dJSWU3eW4yQXRTbXYwRUwxU2NT?=
 =?utf-8?B?dnBmMUpHNVowUnFHODBPSkZNR29mRW1RVVFYSHp5ZXVjbDNwd2orcUJmQndu?=
 =?utf-8?B?RUZQYlIwZXhuNEJZSXpDa2VaL0d6N3RIUkNWQWdTUEZiRlVWNWpkamd4N0VO?=
 =?utf-8?B?emNIVWhQdGdQQ3dKWlVBRTczSUJpb1dQSmZXZ0wvRGdGcGtxZ212MTFjTzhP?=
 =?utf-8?B?SmM3aW1meEREUTRNN0FkdVZMb3M1SEZFNTh3eFJNd2d2TUNaSkhuQ2VMbzJs?=
 =?utf-8?B?YUF1Y2F2RDVXcTlyQW9JOWE3anlVYmgyNFZHWVNYblcvZTRpRDJVVkF4R0F3?=
 =?utf-8?B?L0hUUjM1Z1E0Tmc4N0lCamlLREVZdWl1U1hNQTVPWWsyTGs4ZWRMVkRuUTND?=
 =?utf-8?B?WURseGMvUGVLaFdXNjQwaEhiRUNsZFBpNnM2YmF4aXViVm5XU25KZGdOTkE0?=
 =?utf-8?B?RC9sS2d4UStvNlFETUlZd3dsQmEyS1ViOHBldHpkZnRoZzgra3MxRFIrb3dp?=
 =?utf-8?B?ejlRMTdsNEhSQ0JmVGZ2NW5rbU81MEJKNFFqaDhLTjdQNTNxb1VBL2t4Wndp?=
 =?utf-8?B?Nm1jaG9tQy82RW55U0lIRDZLZGR2NkxvQjBjbDNSVnZ2WjJZSzRIbDlCM0h1?=
 =?utf-8?B?aUw0ZXhnR2Voc2QxcUQ0NHAyNmpHWkRHYXU0RCtCOWJCdm50UkJFRWJuOWNH?=
 =?utf-8?B?Y2ZkVmF1dGRuK2RHOTBWOUIwWFFMd3BxLytkNEd6N2VwRGlFZ29RS2t6VG1l?=
 =?utf-8?B?UVZ0U1A1TE5wVSsvSy9ZZThoWGhXZFo3d1IwaldnN2lUTi96WVZmbnF3RkpR?=
 =?utf-8?B?OHpMSmQwZElCc3BERmphYSs5VnJXN052ZXNsb1djOFR1eGdTYi9mekpEQUFh?=
 =?utf-8?B?ZWxNYkZRU0VHaFRWcTBPdDN6QVkrSEp5OHJWT0ZNaDhNekpLbFR0cGlqeDUy?=
 =?utf-8?B?MHhSdjB3VXpWclU5V3JBcFo2cSt4NmFLMTh6MnYrRGlPR0luTklkaVFSNG1Z?=
 =?utf-8?B?QmtVWjg1K3BzdUtmTzIxb3ZEdFdFbFc1QnFZb3FqZlNNMi9OeWRyRm1ON0Ew?=
 =?utf-8?B?YjNZVVc2ZHFxbDNCRkF2NDFvT0xFVlhhbCtwZ2ZuTENRcHRxVnRzcEt0djNy?=
 =?utf-8?B?WUlVNVc4REY4clRTWE1CYTA1bmQ5ZW5oU1JGak1QcjlNRTF6dW9EYmpwYmFj?=
 =?utf-8?B?dkpJY0NtMDByR0VLeVd2c2l2NDU4b0ZmU1JBaERoT09kZ3dUeml0M0Z0QThK?=
 =?utf-8?B?NGlkeEk3TERUSlFZTzlaVlhtcnFldUtyZHROSW1yK0JJcGFIcjY3VEZvRFRV?=
 =?utf-8?Q?LkM0EMlK63ZOW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUM0cHFpNkNxeTZxNjhLTFJiS1hwQnNhamcxdU1LWXhYbGRqTEcrMjZYQU84?=
 =?utf-8?B?WXk4WWhTM0JDSWEzUzlVdWg5UEIreC8yVWswUjF4OU5yaDVsM05leHhxKzRF?=
 =?utf-8?B?dWVtNWZmVUEzUklyb1llMCt1aFlCQlFKcWxQV3VIRDZkTE40bXVZbVF2YjFw?=
 =?utf-8?B?R1ZjNDkxL0xvN1lIdHpzTHRpOUpDdjBMMVQvTENOQnZzeldyNHI4Qk1ENkor?=
 =?utf-8?B?djJPTEtLb3VLaDRyNGlOMlRWWjBnRUN3K0ZwTlNEWE01bk81azVueXdra1Vp?=
 =?utf-8?B?V2ZlVnYvcXN5RFdKWnJoOW9pL3JhZ3B1N2V4K1N6SXhnMHJpeUdWTHY0MEhF?=
 =?utf-8?B?K1Y1bWdGM016ODJMdzRRREt2S05ITlZ4WjRDWVV2NHF3djV2UzZJUmRVazlx?=
 =?utf-8?B?TWF3MER1ZWZ4TERncFNHckFYcEhEbkpLKy9wVGVEYjlLbFphR3ZNc2hscUlM?=
 =?utf-8?B?WGRweUZRVEtqU2pqWGl0WFZZcmxHTXJ2cnp5M2xQNEZGb1RWTjBlTW1PaUo5?=
 =?utf-8?B?V1lsdi95ZGVSOFVGTmozRmk3cTRZOEJ2ekZTemJVT0tnVkVDVVUwMDhYeUhO?=
 =?utf-8?B?bjVKM0puUmFKV0RIKzNFMnZYcHkyd2xvbGR1ZVRSdTBJeE01SVZ2UzFlN1JC?=
 =?utf-8?B?elUzTVdvN2NabGJSL29reFUvYnVlL1RaOTBrUGZCVVl2UU9zTmdoemVlbVo2?=
 =?utf-8?B?dVRTd1ZEUC9JYjhXZEpZK1JsbVZUdC9pakhmSUsrb0VNZ2l4MkZFWWM0V0xU?=
 =?utf-8?B?U0hYU2dGUXc5K3o3bEE2aVloallPSW1mT2dET010QTRMK3ZOUjZyYnU5L3Fr?=
 =?utf-8?B?eWFpeVQ5TU9aSEhiZ3A0TzQwUTI0RVE1QkRCTGh5UmRRWHJiNFRnb054YmFj?=
 =?utf-8?B?aUlsZ1piNXNZMDlVNW9DVWlaekhKVFQzOUE4cStPLzdQTnl0a3IrVFhsWWtM?=
 =?utf-8?B?TFJuRjl6Q0Y0ZXZFMzhqa0g0bFlTMHROL2FTaFlTc2hrRzdpeno4Y1ByUVFW?=
 =?utf-8?B?bFh1TVgreXR3RTVHOEtVZXNwMmRTWlVlY1I1WmlmYVRlbTAxN2I0Yk5pWXk1?=
 =?utf-8?B?VGhyTEF4TDE5M1JKNGpJYk1XOXBMT0UzNmJtdnFrdm9KL3NwNXU2QUxKckp6?=
 =?utf-8?B?TW1PaWo3MXJ6Nm9KVmZkeXI4YWl2Z2dXRHBLQkhNRzYybHVnWmowdzZCQXhu?=
 =?utf-8?B?a2ZPYUs3QmptclhVa1NPaUVXWmQ0SFc5RG1wZDhwYVJDSHFSWndWZThscWtu?=
 =?utf-8?B?dHZtZDIxSHhhNG5tUGIzUG9aTDdmeHF6QVJMWVVpWE1ONkFGb2dhSUNrbVFY?=
 =?utf-8?B?WmU0bmNrL0IvRi9sV1c0UnVDVUJUY3VTUFU1N0diT2t0SmI1Z25qYUdaZno4?=
 =?utf-8?B?YUtwcGkrK0kwaEpYNVhrT2hncVJQYXZWUHYzM1d0Qjc2eEZXa3BNTytzRE9U?=
 =?utf-8?B?VGcvSlJqbmdwUC9ndFBLSVpFRmxHUzFJR3ovTU1tRnFKNkRsQUVxWHJtZ2lJ?=
 =?utf-8?B?S0cyRjV6ZEw5VjdVeXZZck1QbFNJaVVXMmkxUnFSWmpjcTJSVHpudUUrdGQx?=
 =?utf-8?B?T2pENFV1NUcxZXFlTStYYTB2M3BtZ1d1OStVMlBMSmVZUUVvRXFOUW1HejZD?=
 =?utf-8?B?a3k0WEc5emN6dlMxdXQzbWNyR2RNNDVTUXdObGllUXlRQXJ1NkF0MFNjRVl0?=
 =?utf-8?B?UlhNYVJsTittUEJPdXRZT05oZlFqU25OK3cyd05MSEtzWnRqWXl6Q005d0NS?=
 =?utf-8?B?eHNGMzFmMkZ5QjRFSnZLM2JtdjVMWWtyNnMxUnZsWGFsM3RGNjFDWFFhcWZw?=
 =?utf-8?B?ZkZ2MDFoTHF5WS9OVHBoZ0xVUUIrL0N1WC9LT2xPcTNqZXllWVg1bU90bFdi?=
 =?utf-8?B?RGE4R1VPN2RnYmR0MTR5eUh3WDl2ci9lVEpLZEc3RlBwaXc4cDI1Mjlqc1dO?=
 =?utf-8?B?czl1Ukt3QWo3UmdjcURQcDRLdmJjOVQvVEZxVmxoQis1U3BtbTRKUXdnbzFy?=
 =?utf-8?B?cUlNajBWUTFQOG1NZ0dpQmEwdUpGNFZWZGk1SmtONUM2dENBV2QwZEhMekMw?=
 =?utf-8?B?dWlpWmpmbWV5aXNHK0xmaEFZL1JudDJ1S1QvbFlRKzQ4VmVwdUd5cU5LUHNO?=
 =?utf-8?Q?evjyR0mvKEodktRGGMUzwePpq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2666122-44c0-4216-181c-08dd3af299d0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 14:39:39.6155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rw+vIJAtYYed/G/q3lNJZmyyGff/gEq6LwzvcpxGHSyJ/9xnC9KIFVF9q/MQSS5tGSrv3IPLsq9Ope7Q1hcomQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9404

On 12/12/24 00:36, Michael Roth wrote:
> Currently __kvm_gmem_get_pfn() sets 'is_prepared' so callers can skip
> calling kvm_gmem_prepare_folio(). However, subsequent patches will
> introduce some locking constraints around setting/checking preparedness
> that will require filemap_invalidate_lock*() to be held while checking
> for preparedness. This locking could theoretically be done inside
> __kvm_gmem_get_pfn(), or by requiring that filemap_invalidate_lock*() is
> held while calling __kvm_gmem_get_pfn(), but that places unnecessary
> constraints around when __kvm_gmem_get_pfn() can be called, whereas
> callers could just as easily call kvm_gmem_is_prepared() directly.
> 
> So, in preparation for these locking changes, drop the 'is_prepared'
> argument, and leave it up to callers to handle checking preparedness
> where needed and with the proper locking constraints.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b69af3580bef..aa0038ddf4a4 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -773,7 +773,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  					struct kvm_memory_slot *slot,
>  					pgoff_t index, kvm_pfn_t *pfn,
> -					bool *is_prepared, int *max_order)
> +					int *max_order)
>  {
>  	struct kvm_gmem *gmem = file->private_data;
>  	struct folio *folio;
> @@ -803,7 +803,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  	if (max_order)
>  		*max_order = 0;
>  
> -	*is_prepared = kvm_gmem_is_prepared(file, index, folio);
>  	return folio;
>  }
>  
> @@ -814,19 +813,18 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>  	struct file *file = kvm_gmem_get_file(slot);
>  	struct folio *folio;
> -	bool is_prepared = false;
>  	int r = 0;
>  
>  	if (!file)
>  		return -EFAULT;
>  
> -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>  	if (IS_ERR(folio)) {
>  		r = PTR_ERR(folio);
>  		goto out;
>  	}
>  
> -	if (!is_prepared)
> +	if (kvm_gmem_is_prepared(file, index, folio))

Shouldn't this be !kvm_gmem_is_prepared() ?

Thanks,
Tom

>  		r = kvm_gmem_prepare_folio(kvm, file, slot, gfn, folio);
>  
>  	folio_unlock(folio);
> @@ -872,7 +870,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		struct folio *folio;
>  		gfn_t gfn = start_gfn + i;
>  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -		bool is_prepared = false;
>  		kvm_pfn_t pfn;
>  
>  		if (signal_pending(current)) {
> @@ -880,13 +877,13 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
>  		if (IS_ERR(folio)) {
>  			ret = PTR_ERR(folio);
>  			break;
>  		}
>  
> -		if (is_prepared) {
> +		if (kvm_gmem_is_prepared(file, index, folio)) {
>  			folio_unlock(folio);
>  			folio_put(folio);
>  			ret = -EEXIST;

