Return-Path: <kvm+bounces-38406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EA36A396FA
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 10:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71AF93A6ACE
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 572DB22FACA;
	Tue, 18 Feb 2025 09:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5Z6kRoVU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2069.outbound.protection.outlook.com [40.107.96.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721E222DF91
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 09:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739870365; cv=fail; b=s6UGe3DVrvCIsgum6KSclrcqrdIgofAx5g0c8ckFtX85R7tf8tVIlGFPC/cYjG1EmLjKRVOsRU2s2nA8Ghkcnc3MhG7KuvdJJ9FDU0ZdBCJSv7EiZRDa1BVxy4d1xGfdFJbhQg9Eg4lrvIo7jd9L5G9U3TLYJNqTI427UVZ48es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739870365; c=relaxed/simple;
	bh=Ollpl37aUvWalU6d7rSCUxIh0Js3WProuAbbIgg2TxQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IEuH8W3IxBPXF7oiIoAScCSLc/pjrRItXQMZxaMz3gFc7k14hQItDI/IbgZ6Y1Y0seFAjXakMo5gXh/1LBvg7Cia2eJWwXgXD/aN+M5FIfikG3nx4baN55JQq3yK+FxufFW2fZ5QDt8iShe9EatYi2zKa5uh12LKqC/cAIzOrG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5Z6kRoVU; arc=fail smtp.client-ip=40.107.96.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WIXvOyG5ULS+JnekXjk5nU2KeD12IeUvpj+3h4FJg08LOzC5nJymddzMCBXwUdSeJNBn3KF29FJ+KylMgLEDXbvPXlry82gdJhnAf+vttarVleHSTrEdCJQvPl0QPTYzpVzUZydwMmwOYKxYZPYo7REKkQ9B9lHV/vRAcVZzQYZkXMsVx66vHyH9VRtybI3OYGk1ZWyoikn04OlJejtydk13mnLqeLHk6RGElkW/TSAdRdI7FmNOxIy7o5x4sNcPAxQt44weNAH4wJjPuFOY/dFqzr26s8kB+cRBkXTuMSWrkpOGhQ3rHv7OVpEZf7rdBx5LrQXo/7g4jE1QFiqE6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=246pFZmXZvCYuWkcelA/XblmYC4j7NMSsawHyv4yvZ4=;
 b=UfqbzjCuO0Wk96Zks2RLsotph7OwBYzK5OMLplNgntjwWbF2Kmu8JhfLh7+NLBm2Ih+XOwM7CIxelJKPbQlfnGb0bKCE1xblQiFPnESRFGYi0OY1krtw+KRJaLcwPgb3W9B3TSM0VtsLsxBQXhO2z3ZVsLlgN1VJJPuJASOGX09z/QQVcwNMCaFgDOqWgAd7EwgcuxleZEHNcqr0KV0CN74iVTUQk1zDTvQFy7/e9St75iZPxKWkepDADSfeP80zYb640ruTU4PxRziWErnABnBc/tMKA9giOBPKF9j0RboMGosrXazJsksTmiQ1EsVlbjmDipEcn7Us/ddO/lE5KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=246pFZmXZvCYuWkcelA/XblmYC4j7NMSsawHyv4yvZ4=;
 b=5Z6kRoVUNNNqbyM5mewF58COSCThrsB0b4cVkAr5r8zZCVTwPh4GUeV3Bc10CIAw4tF2nInaaVuEx8zGvjZxCEyVwKvBBzQpFh6trdRG7c6+DSzgqK6+NjemDd8XzJLz56OofZx5SFO7eRVJA9AsZzybQdD3dPveiIrpSrIjp3g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB7115.namprd12.prod.outlook.com (2603:10b6:510:1ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Tue, 18 Feb
 2025 09:19:20 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8445.016; Tue, 18 Feb 2025
 09:19:20 +0000
Message-ID: <10029ca9-a239-4d3f-9999-e1059bc17d85@amd.com>
Date: Tue, 18 Feb 2025 20:19:12 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 2/6] memory: Change
 memory_region_set_ram_discard_manager() to return the result
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250217081833.21568-1-chenyi.qiang@intel.com>
 <20250217081833.21568-3-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250217081833.21568-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME0P300CA0045.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:220:20b::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB7115:EE_
X-MS-Office365-Filtering-Correlation-Id: eb37f7a2-e5e2-4e3e-a5fd-08dd4ffd537e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUFZbEFlb0o3SWhEcFVEY1JXQzI5TmlPVEMvdEdHK2xoMGdRNnB1WW4wZjR1?=
 =?utf-8?B?RVlIcUVDNkNvdWRsMG1WQisxTEF3UjlHSk9NRXJwWUQ4OUtLTHczeXZTdDBI?=
 =?utf-8?B?L01la09rWndQUVBBdjd2T1I5eTlBZXk3c0JBZHBiQldqdlYyakRQYXhvcG40?=
 =?utf-8?B?SWlKelgrdEhsYUJKVW9HbGNqcFVpWmd5OFpiK1ZkQklodXpteVd3UU55bEVl?=
 =?utf-8?B?Skt4K0VtWkRwWm83STFJb050cTEyMFh2cDhkVFNGaFZ4VVNEenhudHBmYVZq?=
 =?utf-8?B?dEZSQ3NzWGZRazg3Y3VKdmtiR0RCV2NJM01RNk9Yd2VkK0dIL3IzR0JBdFpq?=
 =?utf-8?B?V0tMTjFSVy9GWVRrSWZIWE02TDZNSTRlNmZoM3RlVjhXMmNUMGEwREZMZzhw?=
 =?utf-8?B?eGpwYUljSnpuSmhzb0RUR0FMOGRoWm1jOTRjbEIrazBHMXhnVjI2ODlHYUIw?=
 =?utf-8?B?U3R2N25GNE5RNXZ2WWRQWDBjZ1VweTVqaEFRb2RaaW13emp4d0FCL3VFMTRy?=
 =?utf-8?B?NTVhSW0yc3RnQkJTMmlHcXhHUlJndkl4OFo5OWMrKzViWkZRSStkNmV2SGcx?=
 =?utf-8?B?MGRTbThEc0N2cjJiS2xuZS8vemdaYzBmZFM4U0xQd0RJSnRoditOT3RUekgx?=
 =?utf-8?B?dldkZlJpanhxdy9tdmZKOGRoV3FSMGt3TVVQZ0VOeTVEaWFFbW9ySmIzenZ3?=
 =?utf-8?B?R0tZUFAzdHB3UWo2MmJJd0tQWmgxU3M0SDg5NCsyMDVqWUpIbk16TVdLQmVT?=
 =?utf-8?B?dWZ6MXFjRTVPOS91RkRoSkU4OC9KdFNVdmIyM3I0U1N6OHJONGNFd1l1cyth?=
 =?utf-8?B?cnhLUXdmTnlxSEpIaGJUWDA0Sk1JNTF5TnFZRmtHQVVnOGY3eElnTVFreFRu?=
 =?utf-8?B?U1dRSFlNVkZvYW1ETVBhSmtuYVozTEg1T2VQSVNMQzl2aUtTN1Q5ejJ4bGRk?=
 =?utf-8?B?d1p3d1VkYk9xd3FCZEc1RndBb3FBZU5wVGYwWmhkK2dGTkFvRS9UdWpLYTF6?=
 =?utf-8?B?eENhSjRvdldSSktKbllnZ3IxZlN5ZzFmcmtqeG1rRGNFZ1ladS8yZCtrSGZF?=
 =?utf-8?B?SXU0TWgxcUYrdWQwWnIyT2plQm9HQjVTcWxiWkJLZS8yT0UxNWtoWW1aWlZi?=
 =?utf-8?B?L09BSWpGUEZCeTdLeUdUR09ZMzV5YVpOYldXMnFIcFZNRkx2OG1CVlV2R2M5?=
 =?utf-8?B?TmxyTmxBaXNhVndkWnJTblMrZ1E0Q1ErY215Y0o3VVc5RmpXVnZxYnIycFBQ?=
 =?utf-8?B?OHVhU28xK3BDSEJ3b2VKSTh0b0dDamRtQkhTNFJEZHp0VFpXMkhRQ3hSUkd1?=
 =?utf-8?B?dkN0QUdpWUoxVER6Y0VsM0ZvbXZxdi94T05WQXVsTW9nbXkxcTdYTlk2R3RT?=
 =?utf-8?B?M0pvT0FLbEV4ZWZiKytoZFZ1eTFsQzhGUTBXQjFsWFd2U1N6bjk1aDVyVkJ3?=
 =?utf-8?B?Sm5XWGwvRXRPVWVyU3Q2RTkwRWJTS2NPWTVXYThxK2tRcDhjcDUrQ1c2eW5O?=
 =?utf-8?B?SnRkSXpoNm56eEliNnZhQjNLMFphdDVBRWh5VHdWL0E4YnFQTjViSk9xZWhz?=
 =?utf-8?B?YTk0ZFhYZXo5MVNmbmtPOUVudE9YTkJRNnBIZnhnbG41NjY5NlRwcFhMN2lp?=
 =?utf-8?B?Z29SdXVwRmdPNHVmYXhIOUJBUGRUODA2cnRaQ0M4N1M1VzRPOHovNU0rcGFo?=
 =?utf-8?B?T0UrRWJCNllmM0l1cEF5L1h3bm5USG9SS0hRUUExUUhFaUtkMnoxd2NHOHQ5?=
 =?utf-8?B?SG9tdERuUWdEdzRqUW9nLzFrb3J0MXJHY3AyQjRIM04yWTFKVkpqTml0eHUw?=
 =?utf-8?B?Qyt4MURQTHRJMzlCNXBNdTh4YzVMQTVUby9ycGxaMTBxWWoxOTBkcXh6NnEv?=
 =?utf-8?Q?esjOiKfLrEB0V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHNONDRzVVU5VnB3V1NCUnJJNWtTT1k2MU5uMWtZVGo5NDZydEhYcGN2VDdE?=
 =?utf-8?B?MFQzbzcrRHJ3eXpOTzFhbHlTcjB1eXY5NFpvMHRrdFBpajUwbVViZmswdytO?=
 =?utf-8?B?SExlUmhLM00zdVJnT2RWZkwxNHJ3TXQ2cTZOWTFGdUtkMEV6MUlMa2NzNHAw?=
 =?utf-8?B?bWdXNGo3S2tvMmM1alh0OHFncHNUZVovTEJlS2ZkYm9iQ0UzanVIMmlQd3Vh?=
 =?utf-8?B?VTFLRGVsZjhPS3JXMjdQL01lWTJQVzlMSmt4UXh4Rk1TcFduVHZOMTNIQ3Jh?=
 =?utf-8?B?elpxRXltVHVvS1VrQkhkQTcwSHhOeWZxMGRGSmZHYUVocGllZjZET1ExbjBE?=
 =?utf-8?B?WEFZZGYzNkszcmFTVi9MU1U5aFJObkFPQjhhUUFMaklxSmYrazl3RlA1alV2?=
 =?utf-8?B?OTBEVEh2dkdaR0w4ampydVZteVBhVWdHR0lSNjBVaVZYckcrK05uYVY3Yng4?=
 =?utf-8?B?MWlMTEh6VmlSbVp0U1JYeFI3NHA0dndVN2ZaRURWYytnRTFEWGtXN0hPaklF?=
 =?utf-8?B?VDY2N2tYOU93ZUN2RmM5OEJod2dwKzVhclBNUm56d0tOYnhJWUlaN1hEeTV5?=
 =?utf-8?B?REtZNThTVUpSSm56TDErZ0R3UitnU0U1Q1FDSFBDbk55MjBIeFVyb3p5VVRn?=
 =?utf-8?B?bHVoOUhTZ0FDTHRNRWc5MkV2RE5vN2VmSjdKbEtEb0xReU04dENUOWxkMUgw?=
 =?utf-8?B?MVZrWHJlZTU3YnYrY3FTUWZWWEtycnBxVHNRbW53VG9hRE04QlFaN2pydGlr?=
 =?utf-8?B?elg4MzBuZGcySzN4cmJyZ0dUckt4UEllUm9YRHVUS3p4Z2M0dnMxaGlVTUpW?=
 =?utf-8?B?b3hVKy93TllWRXI2NjdvZ1JWWEpyanY5UVhvOGUwdzM3YlJ4NzI4SlJOWGFy?=
 =?utf-8?B?TTVtOFg2U284N3g2WjUvc3pWb2g1UytoVUsvelVYN0M0aGtuU0FQMzE1Q0JC?=
 =?utf-8?B?NWdXSkFtcFFWbU1QUHNYVk4vQURhNWdoQnlpMThsL05YeDRab01Zc3lzSlV4?=
 =?utf-8?B?dndQeEtoYlM4MDc2OXlKMFF0czFxL3AzRmQ5WW9RTmEwKzhZUHVxdnNEZXA4?=
 =?utf-8?B?TGdPUloxenB5YUZFdE55Yk9kOXJPdUJZM2JTZUQ3eU16clEyTi92bUtsUHg0?=
 =?utf-8?B?dFJzR280ZStOWFo0K0xGckZwR1VvSklpcElUdnBXZ1VweFEyMzdnenJCRThx?=
 =?utf-8?B?MXRaNUZrWEp0dHRJY1RyYWlhTWtETzRCdjNDTzQ0MlE2NmVWZitYNzBpQTZY?=
 =?utf-8?B?RXl6bWhpQmFPUHlQNFgyTkNBd2FQUnpMZzZ4dWE2ejRsT2JuYjE3TS9LUlBC?=
 =?utf-8?B?amt6aC9wVHF2K2w5M2wveFZVZDF0SHlnVU1pek5SLzQ2QWdLWGRlRkVrWlZ3?=
 =?utf-8?B?eHZxMTZTbjFGREZWUTR6U2sraHkzNEhnbW13UHlLd1VYS2xRMVVjLytkRHlN?=
 =?utf-8?B?VGZ2dVNPVllTTXVTR3ppSVBReFB0NFFjQUhMZFRBUEpRYTl0RE8wdFI0K1FL?=
 =?utf-8?B?ODZhcE83YUoveVVnRlM5VGxnTnYwcDN2NUN4Rmp4MGI0YW5wMThKYkhKQzNV?=
 =?utf-8?B?cElsdTdGcUdkYm9oWExMN0tUQTlkeFNGWkoxek55dkxiK1JhRkhKNWVQNUJr?=
 =?utf-8?B?UUlFWmpsRDl6M3lMZ1JUdGRDa1Ivano0dG12L0hYMjJkUEF6NWR2UGlwKzJD?=
 =?utf-8?B?MlFBVDUyc2lDek8wWThPc2NVTUlJVVZJNncvb1lsRmpPUTgySHBVeW9sWk1m?=
 =?utf-8?B?VWl2QVNlbGgwczlWRGxtWHdraDNaUlVDOGtNN3Q2QlJFT0ZXbm1RYmtHdW81?=
 =?utf-8?B?OFdRSmVxbmdOaC83NUNqNE5JdkVFWEZuSnlVNktab0I3Si9LZGZ6ZVZHYko5?=
 =?utf-8?B?eDN2MEJEVlZNYStralgvKy90Rk9uTUpoUHVhZVpxNERzQ1pZRWlIcXVyTGRO?=
 =?utf-8?B?M0NjYTluNUJsMzM5ZzExRDJiSEoxVmM5UnFvZHF0b3ZrMitwOFVEaEEwcFBP?=
 =?utf-8?B?MzFORGxLTGNKS0hFNWVQbFRlOHBnVkJVcEQyR2p1Mm5GcWhzN3N2WUlaZlRp?=
 =?utf-8?B?dGVyNnRzUGJYNEdrUFY1QUI1UEszd21sNFZydVNRck8zTzhSWk90Ri91Q2FS?=
 =?utf-8?Q?2pv5TUbJ0y5Ml7Anoc5YzmyC3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb37f7a2-e5e2-4e3e-a5fd-08dd4ffd537e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 09:19:20.4136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AUNBrSGjio1qZK3sNvEoXWAVR2qHIM+32p44vop9C+fcENgr81LPhgzvZurw9ljeTKzAApdpSxhJD2ujWPuaKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7115



On 17/2/25 19:18, Chenyi Qiang wrote:
> Modify memory_region_set_ram_discard_manager() to return false if a
> RamDiscardManager is already set in the MemoryRegion. The caller must
> handle this failure, such as having virtio-mem undo its actions and fail
> the realize() process. Opportunistically move the call earlier to avoid
> complex error handling.
> 
> This change is beneficial when introducing a new RamDiscardManager
> instance besides virtio-mem. After
> ram_block_coordinated_discard_require(true) unlocks all
> RamDiscardManager instances, only one instance is allowed to be set for
> a MemoryRegion at present.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v2:
>      - newly added.
> ---
>   hw/virtio/virtio-mem.c | 30 +++++++++++++++++-------------
>   include/exec/memory.h  |  6 +++---
>   system/memory.c        | 11 ++++++++---
>   3 files changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 21f16e4912..ef818a2cdf 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -1074,6 +1074,18 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>                           vmem->block_size;
>       vmem->bitmap = bitmap_new(vmem->bitmap_size);
>   
> +    /*
> +     * Set ourselves as RamDiscardManager before the plug handler maps the
> +     * memory region and exposes it via an address space.
> +     */
> +    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> +                                              RAM_DISCARD_MANAGER(vmem))) {
> +        error_setg(errp, "Failed to set RamDiscardManager");
> +        g_free(vmem->bitmap);
> +        ram_block_coordinated_discard_require(false);
> +        return;
> +    }

Looks like this can move before vmem->bitmap is allocated (or even 
before ram_block_coordinated_discard_require(true)?). Then you can drop 
g_free() and avoid having a stale pointer in vmem->bitmap (not that it 
matters here though).

> +
>       virtio_init(vdev, VIRTIO_ID_MEM, sizeof(struct virtio_mem_config));
>       vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request);
>   vmem->bitmap
> @@ -1124,13 +1136,6 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>       vmem->system_reset = VIRTIO_MEM_SYSTEM_RESET(obj);
>       vmem->system_reset->vmem = vmem;
>       qemu_register_resettable(obj);
> -
> -    /*
> -     * Set ourselves as RamDiscardManager before the plug handler maps the
> -     * memory region and exposes it via an address space.
> -     */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> -                                          RAM_DISCARD_MANAGER(vmem));
>   }
>   
>   static void virtio_mem_device_unrealize(DeviceState *dev)
> @@ -1138,12 +1143,6 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>       VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>       VirtIOMEM *vmem = VIRTIO_MEM(dev);
>   
> -    /*
> -     * The unplug handler unmapped the memory region, it cannot be
> -     * found via an address space anymore. Unset ourselves.
> -     */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
> -
>       qemu_unregister_resettable(OBJECT(vmem->system_reset));
>       object_unref(OBJECT(vmem->system_reset));
>   
> @@ -1155,6 +1154,11 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>       host_memory_backend_set_mapped(vmem->memdev, false);
>       virtio_del_queue(vdev, 0);
>       virtio_cleanup(vdev);
> +    /*
> +     * The unplug handler unmapped the memory region, it cannot be
> +     * found via an address space anymore. Unset ourselves.
> +     */
> +    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>       g_free(vmem->bitmap);
>       ram_block_coordinated_discard_require(false);
>   }
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 3bebc43d59..390477b588 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -2487,13 +2487,13 @@ static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
>    *
>    * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
>    * that does not cover RAM, or a #MemoryRegion that already has a
> - * #RamDiscardManager assigned.
> + * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
>    *
>    * @mr: the #MemoryRegion
>    * @rdm: #RamDiscardManager to set
>    */
> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                           RamDiscardManager *rdm);
> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> +                                          RamDiscardManager *rdm);
>   
>   /**
>    * memory_region_find: translate an address/size relative to a
> diff --git a/system/memory.c b/system/memory.c
> index b17b5538ff..297a3dbcd4 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2115,12 +2115,17 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>       return mr->rdm;
>   }
>   
> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                           RamDiscardManager *rdm)
> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> +                                          RamDiscardManager *rdm)
>   {
>       g_assert(memory_region_is_ram(mr));
> -    g_assert(!rdm || !mr->rdm);
> +    if (mr->rdm && rdm != NULL) {

Drop "!= NULL".

> +        return -1;

-EBUSY?

> +    }
> +
> +    /* !rdm || !mr->rdm */

See, like here - no "!= NULL" :) (and the comment is useless). Thanks,


>       mr->rdm = rdm;
> +    return 0;
>   }
>   
>   uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,

-- 
Alexey


