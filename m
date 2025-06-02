Return-Path: <kvm+bounces-48164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 713C5ACACB0
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 12:44:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8C9AC175F18
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 10:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A29202C43;
	Mon,  2 Jun 2025 10:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NxEJ2TjI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2921FF7D7;
	Mon,  2 Jun 2025 10:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748861042; cv=fail; b=DR+JtgOK4DncFesErjZO8iyA9/re8yKWrXKFq2i+dgB8MWSlx8lt0LJqtKRnBuwXyAJYGpLvA41pAFzcBFy4/0VxRnbJR9Fmtnl/R7b2PMcKoUqALuJ4CnDgNt+aiz/ltqDIfeRl64jc7uUbw0dXOywGJfYKaOZUdflRSRf9PPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748861042; c=relaxed/simple;
	bh=Jo8Eo7+PLCzW4N29Nh1cspHS3sycf+m0Y+RjmRQKeuM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QzH9DsmaNB+TF9S2xYQ2iZEnpmv3bNBWP2SGiVPO7oBMme3+eZL2W2ZzEyld5EiwFG5hK8m8Rd+vgAN5cEdIFjOgItp4j30RiIMSe8Q/aMMcYz2nmehqrWa/V9sfaWA62ncCv46SVPvg+zbr4KCgCAcZL5V8Tflyv6t0kVePAbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NxEJ2TjI; arc=fail smtp.client-ip=40.107.94.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PESp0Mvx/QVv1XiyZ/Mq2nRu3V15grybqRWfLVSqfK2ycWT92pDvKM0RuzpA96CrrPBmTaySbHNwcCDil5/xTDB0EKtMSjoHfR6h6mrcOpE4VaTVsTet0I54z3pefnUqETXutweZjoGSq00a6s8eOD0rDdRsz7vU9GkSstpQQ+kc9t5Gx0QNHa8kL8EOB0YeMzmNqRhs0VUEuH7In73smJDDvn3xTRwAQEwHLHWHKf1FH2nTxGizkwMqZ5vVECpu6EdkjgMRwynMQQIZeYw60SuyunrKk3LOvS/CJwJEWndO872LNtYjC4GDJkI+vJY+ToYjoG5DefDCMzXgOlko6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VUNbzakcDQuxi60KWzekzmLSrofcG8Oe2EkvLAGHkE=;
 b=gib4Rn/M0P3H95FzqFao7tN02fvnJVVQUnYX6NWy4mJ9Uh6QLYLrYHDj1xRtGRczl7bJ9toZpIeRqYkG1zaMVppAvkK3Ps2AUh9r+ae6keD8gPeJJrlJQc4AiIm/lWvR2DtgfHh1juR5JPq/fV4IMPnEByLedAbfiXrjXzsJ0D3WfNXSF+/N+s/+k0Agv82E2ZHTXnNI6y1EVUagiXH4T37gp/nimqJ4PbW50oQXkSoeuvwjSzkx/MpUkukltcUIygjR7+TGrthCYoGyhLIHQiV6rdntnu4dDdwxDvKn9HHekRL4ne5OkS4Q07pHDgSU2KIkRwQ5/HzyYSZWB/sb3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VUNbzakcDQuxi60KWzekzmLSrofcG8Oe2EkvLAGHkE=;
 b=NxEJ2TjIVWO3rMNisMu2oRIOBcgU+r4QWgyXHg7K8YsTsKygDKcXdQ3Zvwo6OcHVvWhKI/pcAvoxBu4Sb0VFmXv0k6Zqg7yPM1DkCB/QG0uheMIXoGsumD1quhsBCK0WUk4xu5vQIYrLn+QMI9bPrWE2xKKbRFIKZb9bxl4arpQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8)
 by LV3PR12MB9187.namprd12.prod.outlook.com (2603:10b6:408:194::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.31; Mon, 2 Jun
 2025 10:43:56 +0000
Received: from CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870]) by CH2PR12MB4262.namprd12.prod.outlook.com
 ([fe80::3bdb:bf3d:8bde:7870%5]) with mapi id 15.20.8769.035; Mon, 2 Jun 2025
 10:43:55 +0000
Message-ID: <8f85fcf7-3593-46e8-b257-d0da2b7337b9@amd.com>
Date: Mon, 2 Jun 2025 16:13:30 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/16] KVM: guest_memfd: Allow host to map guest_memfd
 pages
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
 ira.weiny@intel.com, qemu-devel@nongnu.org, qemu-discuss@nongnu.org,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, nikunj@amd.com,
 Bharata B Rao <bharata@amd.com>
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-9-tabba@google.com>
Content-Language: en-US
From: Shivank Garg <shivankg@amd.com>
In-Reply-To: <20250527180245.1413463-9-tabba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0003.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::16) To CH2PR12MB4262.namprd12.prod.outlook.com
 (2603:10b6:610:af::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_|LV3PR12MB9187:EE_
X-MS-Office365-Filtering-Correlation-Id: 2192d85b-35f4-4b23-beaa-08dda1c25eba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Smc0NWdGOWpWbU84dlM2Qm45dXNxWFhjblJWeWlCczlHV2dBNDJCa2xhbkNw?=
 =?utf-8?B?N0tyN2pkbUVRdE1MalBSY3lwc0FlOHVnRlJHbDdxNGJWNFFSdkNJWk8ySFM5?=
 =?utf-8?B?eG1wV285UWh3OHpuOEx3MitPeVk2blNQM1g4MTJVcXVQY1pGZGpLNkk1M25D?=
 =?utf-8?B?ZjN6Um4rZjhQMUQzMnFtVUxzdk1FSDIzRDYrcmZ2b01rYUxvSm5CWHRhRjRW?=
 =?utf-8?B?Z0RDQlJKeC90dE41RGdkTFJzb1MzODNoQjRMbGE1L0FIYlFaTzY1dWZHUnBn?=
 =?utf-8?B?SVJEQVZaeGlYWFI3bWM0VUJCOU1Sam5yMjg2WjZiL0FSRXVtT3IzRWVxbnJ2?=
 =?utf-8?B?Z3NUQVM5ZzFya1lPZWx0dW5URlZBby82a2RtMzFQU1NGMTFxa3V3MVFnejJO?=
 =?utf-8?B?WDBWMUFXOTRQaTJSd291eUV0TTNKaDdRTEpsZzhnNG5NUjlsOU5jVE9FNXMz?=
 =?utf-8?B?bU1sL3FWemMwcFVKQ2U5ZDUrNGVHUnErQzl1aHA3VGhGOFVEUStqZ2t5dktI?=
 =?utf-8?B?NXZPQm84d292YUZSVWV6bytQeTQweXkyZENHVGRxekpwTnBtdkk4b0pjTVl5?=
 =?utf-8?B?WkhpQnhOVXpoenM4QU1Bc1J6a1RwSVZzc0Npa0Z1cjJFeHAxUWZLbmNEdnh6?=
 =?utf-8?B?VTVWcGh5dGhDQVpOckprMWVyOUtnWTVRNWhPYS9NRm8xdUw1emF3RCs5Slo0?=
 =?utf-8?B?WG5KRW44b3lNZW9ZVzNNam5nWXlNYXhFR3M2WTM2QmJzWkllVFI4NlRxS0Fw?=
 =?utf-8?B?NVQ2MjJESi9zUHF6Q2t6Z3pqejlIY0I1YjZsOHNKY2p3Nk5lcnd6ZzRPWm5O?=
 =?utf-8?B?VWpqcDRJWVBBMU5mdm9Xbjg2UFFLTjdDWHlpT1dkTTEwNmtydEo5Qk4zTDlM?=
 =?utf-8?B?OXQ1MjYxWGVFNWxZZG1CQXdETDVEUVB3R1V4MTR1eStGc3ozclNyeURIcDBz?=
 =?utf-8?B?UDA4dGNsZ2RQNCs0YXYxUXJUTHBXOWxTWFlGUEdRa2t0d2RCd1ZzbHFhSnI4?=
 =?utf-8?B?ejZTeFVQakJTZjlaS0hKUGJCYUIwM0xGYUZxdysrdHgwSzVpMk1ONVV6bnJC?=
 =?utf-8?B?cVh4VGZUQ2JZNzBWRjJMcFkwczJlT1g3UXlyOWY4NDIxajA5SDVvaTdhRU5z?=
 =?utf-8?B?MTQ3bUo3TEFwZXVoaUtsZ1dkWmtHOFBjcHV3dlJqSVcvRiszL2M3bHgvOWxS?=
 =?utf-8?B?eCtwejk4NDBoMUt6ZkJMSkdCYnd4OTgwZGdFNWJneWFpdUZCVWhHeklPUXpF?=
 =?utf-8?B?YTdIUktiOGFIQm5UVktyRDN6bktIdzV2VWFpZFoxL1E4enBHci9wRlZTMzBH?=
 =?utf-8?B?eSs1cWV3djhyRHBJWDBLWDNQUzBJcHJ2WjErc0Q1dWF0SWlWcjV4ZHUybWtC?=
 =?utf-8?B?S05XTEM0V1dLbUpSUWJBQUxscGw2cXJuMmFNVVpVZlNXcmNyUTB6eGMrbXN1?=
 =?utf-8?B?TVgrNVBZSWY5N1F5Ykd6STdtVW1sSTdTcytjR0lTd2NBQ2Zmd0pGMXVkYWJa?=
 =?utf-8?B?cnBHbmRidzlNMGtiZXdtNndONzNNeTRqQ3dpZzRVZDhqZDJJMktKMXB4cm90?=
 =?utf-8?B?L2R4RHpGaU5nWjNhb3p2MmhNV3JXOGxHWkdSc1hna2RuUmNQSkFCbThTNmM4?=
 =?utf-8?B?WldZdVZ6V3lWcmFUUThFRjdXK28zUkFGMW00Q0l5Z25LRXlhWm5ERW9ZMlZJ?=
 =?utf-8?B?SVg4b0hRa01EYXJGWVA1Y3JxUFpyOHFsNG1aRkRacUpMQU1LT3Y5b0h0YkFo?=
 =?utf-8?B?NHVuR21wbFdxZS8yMHQ3WGk5d2FuMTBSVUVzOEgxTGVQNjNDdmQzaU1vZWtX?=
 =?utf-8?B?THFqc0tjdXdKekNBZXN2eUZ1N2hicWM3ZmlyR3lyVFRvQ1k2SmpxQWZRUkl3?=
 =?utf-8?B?OWdnazV3YVBCSjJFank0eEp5LzRmbFpFT003U1ZqZDM4dThvNWpCakdMYnA0?=
 =?utf-8?Q?OCufw0H9ajYA7kdaW6sFSviwk3aBtKGf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4262.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2FXWG5VNHlqSkhzck9NTzJMZUNFeDJjd3hKeWQ4dGRaVVpjSGY2eGR4YWQr?=
 =?utf-8?B?anNHQWZSWDh6c0FKb0h4cHFEcDN1UEJya050UndLMFRvbEFVdkoyMDV0K091?=
 =?utf-8?B?UlpoLyt3cjhJTkIyc0ovQzlkaDB0UGdCajVFMUErVncwcHNWTXVuZUlJMmdx?=
 =?utf-8?B?MUJ0TWp5bjF0eExwdWJKSmQ1Y09DVkZzcWREKzNoVTNWTE9tTFRiUUZLYTBn?=
 =?utf-8?B?dU9CekFhQUR3ejdIRHhOVzljQlBRdlk4Y0FPZWtOUENQTDhGUCtoK0dKMkU1?=
 =?utf-8?B?bGsyOFBIWENDazJvQnNKd1FkRVA3aExpV2NXZVU3WmJzcUxNOGhteGVPVXgw?=
 =?utf-8?B?SlZPdldtQzNQNVhwZHkyWm5GYitYN01Qb2R1b0tSaVdmb3J2bGpMNEo0VFpG?=
 =?utf-8?B?MVFITkVJbFVyLzVuclh0ZmJTZFBmTkhIYTJSQ3I5MUw5cG5Eb2R0S3JyY0lC?=
 =?utf-8?B?RGtodkN3T0NZam5DTkN6UkNnK3U1cFRCMVBFKzlBY0FqczlLZitRaFNZcSto?=
 =?utf-8?B?ZnNpdFhkc3RyUjF3TnA0b0E5Q2JVRldkei9vUUtmOFcwanJSMDRKZDZObHJG?=
 =?utf-8?B?SWNEZzRTQ2UyMzBQSXV0UG1WT3FSRHN2YmhzeGpXSzFIc3g3SlE5U2lIc1pK?=
 =?utf-8?B?WmVjTUZ2cHMrL2lGZ010Tkl3bU1VMFM5T2VqYjBibmFtckV5OVdCSG1rRkcr?=
 =?utf-8?B?T0lVcGpMNFhmNEl6dmNTVHV4S2szWlFiVm5OcDZ2U0d4UklXdTdmQ2ZkbG1o?=
 =?utf-8?B?YzczTVNXZDBIOUYzOFQySW16dXNDMFhwYWxRK3p0d2xKc05nNExMeVpzQmN2?=
 =?utf-8?B?SmZobis3aDcwWWpTVnZxQU42SVNiRmh6c1V0ZmpUL3g3c2k2Uldja3JjZ29a?=
 =?utf-8?B?a3B4MWNHRHNWU3Fwa04zWTRZMWU1NkU3NXJGOHRxMFZNYVRTc0djWjdxSjdL?=
 =?utf-8?B?eWRlUEhOa0drcTBsTk1CNlRZRXRSdXZrajNEbXZvSWV0U3lSYW40ZmJncEJU?=
 =?utf-8?B?U3poWXltYjFDWkJrbmZFTjhjS3NEMlNGak9aUUhPTTRJSUNZbzhqRk1MVEd2?=
 =?utf-8?B?citoUnUzR3VoNXJpbTRmU1QxWWhDU0VRQ2dWSlhwMHR5NTE3STVSeXlSN0Jt?=
 =?utf-8?B?cERwK25DM0IyY0ZQVGUrSmZOUm54ZFpVNWVUWTlrdHhCWVNKTGl0Rk1SR1Nw?=
 =?utf-8?B?WFoxL1l1a3V3QUxxYk9SNWhENU5waHZjaFlVUHl5TjYrT1o2UUx2NGVqUUho?=
 =?utf-8?B?Y0ZYaEFYNW9HczBKWGhxMDJ4L0hNT2dHRFpCNEZaZjNnUVVNYkVyb3dRSVRl?=
 =?utf-8?B?SlpTdWpCN2JTOUdRT0tTWmxxNyt1eXF3allUQkZVUmhxMnJ1cDBHdjhPWlZV?=
 =?utf-8?B?YTNsbXhNcXZWNGhseUpibmlSYjlRRllwQ3A4VENqZUhBV1lzL2JaenJFS0ho?=
 =?utf-8?B?VEI5ZldRSW5UWHBqYzVVOEVuM2NwNWV6NDdOWEQ5NlZwMXlpZ3h1WENoeEM5?=
 =?utf-8?B?Q0RhM0d2SWhDUzNUc1hxZCt4MnE4SlVBWnl3cTl2d0xOVDVvVlZuNEF2T0VQ?=
 =?utf-8?B?WEY3T1QxVE80bjlvVWROOWJrQmRLOGxJSXdDNi9KODhvUHhFWndMeUJ0a0pw?=
 =?utf-8?B?Ylp6eWc3R2dOS2Fuc2pDekRqa2x2VFI0Qnk4MDRaYitibkYzck5GZXpSK29I?=
 =?utf-8?B?WUMwUHZ2WlZ0UVNCVkZ0SS9GK3N5YitKQWFXVGRIdVpQZ1lZSFVWNzMwNDM5?=
 =?utf-8?B?Q2dzZFUyMWtQRTM3cDh1Z2F1MmltODFGaFRHaDM1eU5LemlQN0pjRnhGUi9X?=
 =?utf-8?B?aHZmdTl3VUpjZWJqTktLRlVrZmJBUUFMaXdTTlRqL3dPcDYxQnlER1pGY2VH?=
 =?utf-8?B?RzVjVUtzUWxpQ3N0UG0rb01EcCt3emF3Slc0ZXdxZ2RXTnZYSW1TNWx6cHNW?=
 =?utf-8?B?akNXbnJvV3Y0Y0NjNE1jcngybzZtMG5lNnRYRFl3SVpWTjFVN0hXYUdwTC82?=
 =?utf-8?B?OXVpL1pEUFJaUmRxV3VDK3hmUGlYY3YwUTBoUmcwSkdxL1dXVnNvUWNQVkly?=
 =?utf-8?B?Rmc4aDZKVmZwaHJsejU2YW5YTUtQQ3BjWmhvZ2ppTUIvcWE1U3R2cWZNVm5x?=
 =?utf-8?Q?bFs381nkUGdtk698CyKQ5My4K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2192d85b-35f4-4b23-beaa-08dda1c25eba
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4262.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 10:43:55.5133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WLYnyWzFxPD6OEA6jKMyz/RZIeq7b1qPxe9FrShKXhuZNMkV74Uag3iUo30B66VX0OMWuF7CEGGFA5QDq5flHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9187



On 5/27/2025 11:32 PM, Fuad Tabba wrote:
> This patch enables support for shared memory in guest_memfd, including
> mapping that memory at the host userspace. This support is gated by the
> configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
> flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
> guest_memfd instance.
> 
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 10 ++++
>  arch/x86/kvm/x86.c              |  3 +-
>  include/linux/kvm_host.h        | 13 ++++++
>  include/uapi/linux/kvm.h        |  1 +
>  virt/kvm/Kconfig                |  5 ++
>  virt/kvm/guest_memfd.c          | 81 +++++++++++++++++++++++++++++++++
>  6 files changed, 112 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 709cc2a7ba66..ce9ad4cd93c5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>  
>  #ifdef CONFIG_KVM_GMEM
>  #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> +
> +/*
> + * CoCo VMs with hardware support that use guest_memfd only for backing private
> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> + */
> +#define kvm_arch_supports_gmem_shared_mem(kvm)			\
> +	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&			\
> +	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||		\
> +	  (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
>  #else
>  #define kvm_arch_supports_gmem(kvm) false
> +#define kvm_arch_supports_gmem_shared_mem(kvm) false
>  #endif
>  
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 035ced06b2dd..2a02f2457c42 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12718,7 +12718,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  		return -EINVAL;
>  
>  	kvm->arch.vm_type = type;
> -	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
> +	kvm->arch.supports_gmem =
> +		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;


I've been testing this patch-series. I did not saw failure with guest_memfd selftests but encountered a regression on my system with KVM_X86_DEFAULT_VM.

I'm getting below error in QEMU:
Issue #1 - QEMU fails to start with KVM_X86_DEFAULT_VM, showing:

qemu-system-x86_64: kvm_set_user_memory_region: KVM_SET_USER_MEMORY_REGION2 failed, slot=65536, start=0x0, size=0x80000000, flags=0x0, guest_memfd=-1, guest_memfd_offset=0x0: Invalid argument
kvm_set_phys_mem: error registering slot: Invalid argument

I did some digging to find out,
In kvm_set_memory_region as_id >= kvm_arch_nr_memslot_as_ids(kvm) now returns true.
(as_id:1 kvm_arch_nr_memslot_as_ids(kvm):1 id:0 KVM_MEM_SLOTS_NUM:32767)

/* SMM is currently unsupported for guests with guest_memfd (esp private) memory. */
# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_supports_gmem(kvm) ? 1 : 2)
evaluates to be 1

I'm still debugging to find answer to these question
Why slot=65536 and (as_id = mem->slot >> 16 = 1) is requested for KVM_X86_DEFAULT_VM case
which is making it fail for above check.
Was this change intentional for KVM_X86_DEFAULT_VM? Should this be considered as KVM regression or QEMU[1] compatibility issue?

---
Issue #2: Testing challenges with QEMU changes[2] and mmap Implementation:
Currently, QEMU only enables guest_memfd for SEV_SNP_GUEST (KVM_X86_SNP_VM) by setting require_guest_memfd=true. However, the new mmap implementation doesn't support SNP guests per kvm_arch_supports_gmem_shared_mem().

static void
sev_snp_guest_instance_init(Object *obj)
{
    ConfidentialGuestSupport *cgs = CONFIDENTIAL_GUEST_SUPPORT(obj);
    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);

    cgs->require_guest_memfd = true;


To bypass this, I did two things and failed:
1. Enabling guest_memfd for KVM_X86_DEFAULT_VM in QEMU: Hits Issue #1 above
2. Adding KVM_X86_SNP_VM to kvm_arch_supports_gmem_shared_mem(): mmap() succeeds but QEMU stuck during boot.



My NUMA policy support for guest-memfd patch[3] depends on mmap() support and extends
kvm_gmem_vm_ops with get_policy/set_policy operations.
Since NUMA policy applies to both shared and private memory scenarios, what checks should
be included in the mmap() implementation, and what's the recommended approach for
integrating with your shared memory restrictions?


[1] https://github.com/qemu/qemu
[2] Snippet to QEMU changes to add mmap

+                new_block->guest_memfd = kvm_create_guest_memfd(
+                                           new_block->max_length, /*0 */GUEST_MEMFD_FLAG_SUPPORT_SHARED, errp);
+                if (new_block->guest_memfd < 0) {
+                        qemu_mutex_unlock_ramlist();
+                        goto out_free;
+                }
+                new_block->ptr_memfd = mmap(NULL, new_block->max_length,
+                                            PROT_READ | PROT_WRITE,
+                                            MAP_SHARED,
+                                            new_block->guest_memfd, 0);
+                if (new_block->ptr_memfd == MAP_FAILED) {
+                    error_report("Failed to mmap guest_memfd");
+                    qemu_mutex_unlock_ramlist();
+                    goto out_free;
+                }
+                printf("mmap successful\n");
+            }
[3] https://lore.kernel.org/linux-mm/20250408112402.181574-1-shivankg@amd.com



>  	/* Decided by the vendor code for other VM types.  */
>  	kvm->arch.pre_fault_allowed =
>  		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 80371475818f..ba83547e62b0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>  }
>  #endif
>  
> +/*
> + * Returns true if this VM supports shared mem in guest_memfd.
> + *
> + * Arch code must define kvm_arch_supports_gmem_shared_mem if support for
> + * guest_memfd is enabled.
> + */
> +#if !defined(kvm_arch_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> +static inline bool kvm_arch_supports_gmem_shared_mem(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif
> +
>  #ifndef kvm_arch_has_readonly_mem
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>  {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b..c2714c9d1a0e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>  
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1ULL << 0)
>  
>  struct kvm_create_guest_memfd {
>  	__u64 size;
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 559c93ad90be..df225298ab10 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>  config HAVE_KVM_ARCH_GMEM_INVALIDATE
>         bool
>         depends on KVM_GMEM
> +
> +config KVM_GMEM_SHARED_MEM
> +       select KVM_GMEM
> +       bool
> +       prompt "Enable support for non-private (shared) memory in guest_memfd"
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6db515833f61..5d34712f64fc 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,81 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>  	return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>  
> +static bool kvm_gmem_supports_shared(struct inode *inode)
> +{
> +	u64 flags;
> +
> +	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> +		return false;
> +
> +	flags = (u64)inode->i_private;
> +
> +	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +}
> +
> +
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			return VM_FAULT_RETRY;
> +
> +		return vmf_error(err);
> +	}
> +
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +	.fault = kvm_gmem_fault_shared,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	if (!kvm_gmem_supports_shared(file_inode(file)))
> +		return -ENODEV;
> +
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {
> +		return -EINVAL;
> +	}
> +
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +#else
> +#define kvm_gmem_mmap NULL
> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> +
>  static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> @@ -463,6 +537,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	u64 flags = args->flags;
>  	u64 valid_flags = 0;
>  
> +	if (kvm_arch_supports_gmem_shared_mem(kvm))
> +		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
>  
> @@ -501,6 +578,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	    offset + size > i_size_read(inode))
>  		goto err;
>  
> +	if (kvm_gmem_supports_shared(inode) &&
> +	    !kvm_arch_supports_gmem_shared_mem(kvm))
> +		goto err;
> +
>  	filemap_invalidate_lock(inode->i_mapping);
>  
>  	start = offset >> PAGE_SHIFT;








