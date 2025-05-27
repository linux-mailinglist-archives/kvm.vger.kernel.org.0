Return-Path: <kvm+bounces-47777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D96ECAC4B5D
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 11:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E516217D2EE
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 09:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70DC724DD0B;
	Tue, 27 May 2025 09:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ceShQnH7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3D31B423C
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748337557; cv=fail; b=of4qegQf0l2DGYT59aDdtM8P0NHqe5j5U1uVvRo2Xz5TTTuxeP+uKYohxxfLwPhJjPwnQPuCu4wUJQuz+R85zJ17au/ydREx85ggTVib8alvi0zFh+OowfRr59z+5oeJDJ/ulE3nBMZfxoouZ2MMRj0efmzlOGrU2qK4+CtQvi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748337557; c=relaxed/simple;
	bh=AsPeyA/qyGHMA+gWcrH8CspOXlSPDE1Don7DZ40C8qQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lHcw2gJ/DWWmpbH573FKu4GufzQ1jHv7SYZUjtalHBMMqQqP7bjOOQOTHDZcLRBEUo8K8yJWBC+iMaYRwD26Hs4XhL1uhcQQ5N1IzURIHt/cTf/Rvk3qsHuHuXRd437F3sQKRVgdznHaoaHFtnwDLQq3gu3yKy0MmoI6BozuTng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ceShQnH7; arc=fail smtp.client-ip=40.107.223.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kiJ8m3w3n3lfG1Vnn/8TwP+3rjQtlKO6WpPGDMwfHeJh/zKcJw38yaKjmfLRkrRytYY6MaLUxfkP4p1sVH/7TGiI8ANSnOGU6KGzf1COpoKYnYPzUlUB52NcA9/hMXlzzUZSIkaIlq75OY33FCbpG9lpY8Jlwb3NAnG7puECGghN+toHu6Md6WRnFsfKd5MJRao3Le1ApLjKygZsx6+JrBvKON5EUY4Sc9KewOmHpBqzSqjjTKcLzF1ELlg5M2eyjZumyQiOsL185UGeYSVVnBda/UxxtNd+0WaVF/UwDwykjyFfuY2hvPqYCFxKDvyD2gHLJGXjpEnVg70JZwX34g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CWb8iSbrKdehh/nxpnysBoEbRaZSgiA+I2RwBlz5Sog=;
 b=msn7VXDzgzXO/VlrBMI7JYtRxP3iMaA3JS+NrGAxv2/kf6MWxjgvSTeJrbCpokHpxVzOq67D/MG8vGCNXCrM7cl+iKHGb7L9XvIHQ6RCudUBfYCXYO72cB82v5mqcUwrG5b5bMYBKy7fNtha5INQx0m5Wyd6ajnT+mBqyW65NNdH9agPjPyqyvsOlgt9zpx8sLU7QdLxsz741cNHe/YP3xjDrIyjqOTx5dagb4CQPI9S/j+gj7draiOQhs7t6HStj4+IhI7AWYmBjVEaCtO0Jlhmvn0qvWdvDNGtQ7tVBQ+sE4Fe15J8jHv/uQ4INz1Biy9LVzeU4svU+Te5iFFrPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWb8iSbrKdehh/nxpnysBoEbRaZSgiA+I2RwBlz5Sog=;
 b=ceShQnH7h9PVT0nGfwOqtA5Sv3qmIeieOYGGNDCc6+QkVcywC3JWgQXaJrySmc/ahYprZApbJBN78ej3Hi8xwvX5Jx1il0fabbMGbV2EeGHFLBe0CZ+5SflAJZjk+5VXX+OP8EScdpVeTqLo24ogHe5lebFCzb6W5wBNhAfP8CE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH3PR12MB7761.namprd12.prod.outlook.com (2603:10b6:610:153::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.21; Tue, 27 May
 2025 09:19:13 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 09:19:13 +0000
Message-ID: <2702b8d4-2db2-44dc-838f-a67adbb5cf7b@amd.com>
Date: Tue, 27 May 2025 19:19:06 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v5 05/10] ram-block-attribute: Introduce a helper to
 notify shared/private state changes
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-6-chenyi.qiang@intel.com>
 <952ff8ef-815e-484f-a319-3416dd3c03e8@amd.com>
 <e2ad3d45-68db-41fe-be1d-cefe0484d52e@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <e2ad3d45-68db-41fe-be1d-cefe0484d52e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYBPR01CA0186.ausprd01.prod.outlook.com
 (2603:10c6:10:52::30) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH3PR12MB7761:EE_
X-MS-Office365-Filtering-Correlation-Id: c5d2f807-3f4f-406c-96d4-08dd9cff8b7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEpWeWJYMjJwNEFqa3JBRFFyeGthYTdRWkdLUFk2RklZUnFMeUs1czQrM2RU?=
 =?utf-8?B?UTEyL1h3VFZmL3d0QktLYUtpdmtPUjlwZ3l6SXRpODd3KzJSTEtCc3djUU1H?=
 =?utf-8?B?L0xLK2pCU3pTQmlUN25Rb0N3UVFqeUdjdTRreEUrNGN5MWVheTczZ1Z4VFZV?=
 =?utf-8?B?c2FXQk9KZlhYY1BsWkdZcE01RjllSGNSVjlkNDgvUkVUbGVZTHRiSTRnbnhS?=
 =?utf-8?B?djVaSE5pYXhXN0c1THVjRVJvOGZxS2NBT3V1bmFsUytMQTcwaHJGWXpqNWt5?=
 =?utf-8?B?UEJPb2tidy8wOVRKWnlBQWhNcXFnMGdINTlYSWRGVDBKTkFwaDBBU1hKbm00?=
 =?utf-8?B?d1E4a3lhVDNheEl0V0U1UHk1UEFUblAyT0VzRzd1cWlGQjliaEgxNG9RMkxI?=
 =?utf-8?B?SXpmVi96M2NYOFo1THVDc3kwNmEyTDArWnlRTVM2V1ZibDh5ZkFOZlhORzNl?=
 =?utf-8?B?ZkVLbEVhOGIxVXNUaWYrUWR0WC82aVEzWTBhaXkybzZZelk1QkNLT21sYkVj?=
 =?utf-8?B?K2FTZFptemtCSXpnNlBxcnZ2c1FzcUYwSnE3cklqSW1tckJLdUxUZU8raHhL?=
 =?utf-8?B?Wkk5LzNERU9tQXhGbjlUempsL3BmZ25yTU53aVlMeGF0alZJdTExQjRtZWxX?=
 =?utf-8?B?dldjMTdJVE11bS9idStnZldRZEdQMDlaanNGazZSUDBScmhVL1NLbGM4bU5E?=
 =?utf-8?B?Zk90L3NVVWlkWitHRWVweGhvakV4NUx6VkwwaEJkR0NQMEJoeTBKMlpFNFhv?=
 =?utf-8?B?bW5GNzAvNE5JbUVDYXg4eHE3T2U5RWlnWTJzenRaY1c3Zk1pL3Q2Q0txR1pY?=
 =?utf-8?B?U1JEcnBBeEdaak5SSlp1dVZLS3M0RWVUWlAzT2dzQXlNZy9hOUN5TnllbHlR?=
 =?utf-8?B?clNaTGtJSGVmNlo1T3ZvRm5JakhQR0hSNVIwdi9jWGhVbE5lekxLMnZtRmJS?=
 =?utf-8?B?eXhVYndmR2dRRWFXdmhYZUJqd1FUenBOT3RGaG9sNG5wQ3hBVGFzQlJrZFJP?=
 =?utf-8?B?TzhFa3REdVRwTnhSTnpqMG90M08xM0p1dlFISllENDh0aXhjSUJtNEJKVkZu?=
 =?utf-8?B?VTMya3NIVEdRbEhGNFpNTVIwQnZqVHZnQUpzM0lYT0FLN2tMMmk4aTVRTXlm?=
 =?utf-8?B?REFNY0JSMXdWcnZnS3o3eGhBZUhySDBHZkJHdHdDR2diOUR1WEE4bStpWFdv?=
 =?utf-8?B?WXFwZFBpa3RQdUpyS1RWb1FqN3B6dEUwMlUvejk5Ykw5VnUyZFpLMnJsdVFN?=
 =?utf-8?B?am41M1VXeVdXMkFPSHF0RHVaZStYWU1MdWc0dUZKQjQzL3BZWXJkcysrUmRC?=
 =?utf-8?B?NFpqVC9Hc2RLRDI4OXd5RkF6RW04M2xoMHc2ZVRHa0ZXRGluVG5BYURxV2o4?=
 =?utf-8?B?YXV5K2R4cjNxbkV3MUtwOHdvcElzZnFQdmNQdlREWFZhZWFJYmRKa1JMdThB?=
 =?utf-8?B?NjgzVnI0NlZwSFFmSFJDSEI0WUUrZ2k3azcwTU9WNXRnWCt4d2ViZzFQNmNy?=
 =?utf-8?B?aldjQ2dZdndiV0NIQi9XcTNmZWhPT2ZiQUlSdklzaTBEMHJOQ0F5UC9EQVlp?=
 =?utf-8?B?VTRuZk1yMWh2UjhCVjZFR29GeDFUT1QwdlhiSEZTT3BZNWxvWmE1Sk0xczVp?=
 =?utf-8?B?aXBaV3cxNStSYzY5b04vYnZpazl1M1hBZmxiT2wrR1QrUHhBYVpkaUsrZVdY?=
 =?utf-8?B?WXpZNElGQUk3TXRvOEw4Z2JLQ0lCaDBibmRQQjBkaVA4eStkRmNqQUJ5aXVl?=
 =?utf-8?B?aURnSEhoK2dCSzRTaTBuYUlrdkc2Qm9WclI1Ty9TZVNQckZXQ2ZpcFBTVFZH?=
 =?utf-8?B?aHhqWmlsUzN2MGovYktLZXFGZDF6bFhHaXpRNnp2TWp6UkduV1VSMERqVmNk?=
 =?utf-8?Q?5eTSfDxgLpWpq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGJBalY5cmoxV244YW1hT1czMDk4ZW5MTGVoek5qODZvV0t0N0wrekRYRXNN?=
 =?utf-8?B?WjB4cmJPN0R1S2pOOGtQQlRwOXN3ZkQzR3NHZjRJMmMxRmt1YlZSY1ZJRHVj?=
 =?utf-8?B?QVkyQUp3Qk90YUkzd0txZzZHTXRVRGlhR3FqelFCNE5QZ3JLR0V3b3JBK2xZ?=
 =?utf-8?B?a1hSSjhNb0s3N21Tek1NaFJDNVVUZWV0M3JQY3BGUWtvaXdreWpvK3lVU3ZU?=
 =?utf-8?B?THpoNFJDOXo2K1p3emtpV09NL2FPcU9naEJjTm5ZS2ZwVCtaQjN2QWVRcG9h?=
 =?utf-8?B?ZHV3R25zZ0F6WDhmVHR0Y21IWVdNTEFBekRPRTZUdThvN1JoUkozWThTempi?=
 =?utf-8?B?SU8zTnpUUjBPSkpjOS9CQyt6NXhNR0tGSUJCc0Nqa1lSNzVuNjNaMkJDVEJh?=
 =?utf-8?B?bTJneWdDUHJudDdqbFBYS3o4Y1dTYXFrOVNQbDg1WjhuU2dldWRYdmVxVTJD?=
 =?utf-8?B?UFdQVGNCeUxxQkRLSkxqVldNVDNBSmlnZFMyV2NUYnJPWWU4dkRKVDVhazR4?=
 =?utf-8?B?aS9HekkrUDB5ZFFDRmdaT3YyOWVRSlVzQ1lBK0tZUUMzN3ZFeThOSU9ML2JD?=
 =?utf-8?B?OFNNWUxWa0Jua3YyNFRhWkpzR0VLekZVSi9qMGVDNDk4WTlNVkIzUVZuUVU4?=
 =?utf-8?B?a1M0STlKV2lLTEE1b040MjR6TTh4aURscTRNc1lVenM3STY4bUF6NGF3UnY0?=
 =?utf-8?B?WGhhdDQydHoxMlVqRHdRZko4VDVMaWZRMXhLekxZVnUvNzhicG8ycjY4WjNY?=
 =?utf-8?B?bDBHTnhwS1FxOWtYWU1WUy96TWg1VXZnRDEzRnhraUg5K2VESGlmVDhQK0xT?=
 =?utf-8?B?ZGsvaWFFMldKaDE0c21pQTAwc2d0NURtWlY4WWhTcHZkR3gvZU5WWk4vU0tM?=
 =?utf-8?B?VVhhVmJsc2lDNTA5TUZjSm9YWWwrYnVhY1JQSDNMMmU4V3JRdm1lUlpRMkgz?=
 =?utf-8?B?ZDlBMkdaZE9pdVhRMGY0Y0xvbHJTOWlUZ2RLUFJlYzNPUEVaTXdvT011VGph?=
 =?utf-8?B?M3BmSHhVdGwyZ3c0UnRKTzNGZVUwR25wZkwwaGNDOGh2L1ppQnJiMytMWENl?=
 =?utf-8?B?SlkweDVxa1NnaTZTc2g2eEJQK0FIb3lsc1pUOXRDSFExdGtFNlordFNweHVm?=
 =?utf-8?B?RDQ0dDY3VlY3RjlHQnR3MFlzYytzZDEyd0ZSeVlYMUhuZEE1eURWRExNRjNB?=
 =?utf-8?B?SDNWZG91U1NVMDBDeDRiSWs5VGlGZEJ0NmxMaXZtcFpKK3VLN0QvKy8rcVlB?=
 =?utf-8?B?WGlnK1IrdThMemVxanJPajlXaXBJUmFJT0VsS012ZzQ2eUh0RHp0V2pkUEhO?=
 =?utf-8?B?ZkR1SWdNek1Xc2hyN2UrQlZjamVxcGJWQnhhWVBKOFN0S1BCR2VodGJNeWQr?=
 =?utf-8?B?UHcxT2gvT25BYm5hOHZsTldjakJNeVFTc04ydFZCZ0dHTjNzSGJ6RHBPYmtD?=
 =?utf-8?B?MnlYcE9XZkZnaitTSlgycnJGU1QvR3NJNWNucWNNbXlQczJJd0oxcGROL1dl?=
 =?utf-8?B?ZmZwck5PTlQ2bHVjUzQ1alVERmUrenJBQU5wRmhsdVZHOWtGTEI1WExPanNa?=
 =?utf-8?B?MFVSVHlCdG8vNlV1alBNbk0xV2VwKy9SUGg3THREZTJUcWlJR1A5REY2bzdD?=
 =?utf-8?B?TVBzOElhWnJhZkVKZUxrSXpGQTNhQ2oya3phM0s0UWhSN0NTVWp6MkNGblRK?=
 =?utf-8?B?N0s0WXgxeDdlV1IycTZZNU0vZFRTbUl6RzBiS0RCb3h0eTlRV041b1QyMXFP?=
 =?utf-8?B?Y1JhMmZNRGNobnd0SjBlK2laaHprUDJlWEVZQkhZak5DZXl1cERuTk54QzhZ?=
 =?utf-8?B?cDZyY0RqZXhQNVkxSFJpTFVvZkozVGFUWklDQjAxT3V0M0ZMcDNkTW9JczlP?=
 =?utf-8?B?N2k4UWQzM1VaMXRyM0lEdUkvd0l0T01HTXJ4b0ZtWEdLNjQxZzlTN3lJRUlV?=
 =?utf-8?B?bkVuSkNHQ3hsVzZMMTVXWXZmR1VyaFllanJvak85Z3IyUjc2T2gvQ3MrbVd3?=
 =?utf-8?B?VWpRaE9pUldvdE5Vd3R6Tm5nWkkxT29EalRSeWZQaXZ3OFNkcHF2S2svZzNG?=
 =?utf-8?B?L0EyWmNZN0ozZ3lqYm1ickxRYi9rNzVkc1MvRUNLQ2hHcXFDNFk3U211TDNo?=
 =?utf-8?Q?gf6YvMG3TXlkN+rNMkZlqDufz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d2f807-3f4f-406c-96d4-08dd9cff8b7f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 09:19:13.0574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kTpBK25OOIDuugmrvHU5Yzu1wI0EMPZt/E0M6NNnvrIEwJtxnmWrpK5doud2o+e+cfecpnNZeq/Vh92ah7E3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7761



On 27/5/25 19:06, Chenyi Qiang wrote:
> 
> 
> On 5/27/2025 3:35 PM, Alexey Kardashevskiy wrote:
>>
>>
>> On 20/5/25 20:28, Chenyi Qiang wrote:
>>> A new state_change() helper is introduced for RamBlockAttribute
>>> to efficiently notify all registered RamDiscardListeners, including
>>> VFIO listeners, about memory conversion events in guest_memfd. The VFIO
>>> listener can dynamically DMA map/unmap shared pages based on conversion
>>> types:
>>> - For conversions from shared to private, the VFIO system ensures the
>>>     discarding of shared mapping from the IOMMU.
>>> - For conversions from private to shared, it triggers the population of
>>>     the shared mapping into the IOMMU.
>>>
>>> Currently, memory conversion failures cause QEMU to quit instead of
>>> resuming the guest or retrying the operation. It would be a future work
>>> to add more error handling or rollback mechanisms once conversion
>>> failures are allowed. For example, in-place conversion of guest_memfd
>>> could retry the unmap operation during the conversion from shared to
>>> private. However, for now, keep the complex error handling out of the
>>> picture as it is not required:
>>>
>>> - If a conversion request is made for a page already in the desired
>>>     state, the helper simply returns success.
>>> - For requests involving a range partially in the desired state, there
>>>     is no such scenario in practice at present. Simply return error.
>>> - If a conversion request is declined by other systems, such as a
>>>     failure from VFIO during notify_to_populated(), the failure is
>>>     returned directly. As for notify_to_discard(), VFIO cannot fail
>>>     unmap/unpin, so no error is returned.
>>>
>>> Note that the bitmap status is updated before callbacks, allowing
>>> listeners to handle memory based on the latest status.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>> Change in v5:
>>>       - Move the state_change() back to a helper instead of a callback of
>>>         the class since there's no child for the RamBlockAttributeClass.
>>>       - Remove the error handling and move them to an individual patch for
>>>         simple management.
>>>
>>> Changes in v4:
>>>       - Add the state_change() callback in PrivateSharedManagerClass
>>>         instead of the RamBlockAttribute.
>>>
>>> Changes in v3:
>>>       - Move the bitmap update before notifier callbacks.
>>>       - Call the notifier callbacks directly in notify_discard/populate()
>>>         with the expectation that the request memory range is in the
>>>         desired attribute.
>>>       - For the case that only partial range in the desire status, handle
>>>         the range with block_size granularity for ease of rollback
>>>         (https://lore.kernel.org/qemu-devel/812768d7-a02d-4b29-95f3-
>>> fb7a125cf54e@redhat.com/)
>>>
>>> Changes in v2:
>>>       - Do the alignment changes due to the rename to
>>> MemoryAttributeManager
>>>       - Move the state_change() helper definition in this patch.
>>> ---
>>>    include/system/ramblock.h    |   2 +
>>>    system/ram-block-attribute.c | 134 +++++++++++++++++++++++++++++++++++
>>>    2 files changed, 136 insertions(+)
>>>
>>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>>> index 09255e8495..270dffb2f3 100644
>>> --- a/include/system/ramblock.h
>>> +++ b/include/system/ramblock.h
>>> @@ -108,6 +108,8 @@ struct RamBlockAttribute {
>>>        QLIST_HEAD(, RamDiscardListener) rdl_list;
>>>    };
>>>    +int ram_block_attribute_state_change(RamBlockAttribute *attr,
>>> uint64_t offset,
>>> +                                     uint64_t size, bool to_private);
>>
>> Not sure about the "to_private" name. I'd think private/shared is
>> something KVM operates with and here, in RamBlock, it is discarded/
>> populated.
> 
> Make sense. To keep consistent, I will rename it as to_discard.
> 
>>
>>>    RamBlockAttribute *ram_block_attribute_create(MemoryRegion *mr);
>>>    void ram_block_attribute_destroy(RamBlockAttribute *attr);
>>>    diff --git a/system/ram-block-attribute.c b/system/ram-block-
>>> attribute.c
>>> index 8d4a24738c..f12dd4b881 100644
>>> --- a/system/ram-block-attribute.c
>>> +++ b/system/ram-block-attribute.c
>>> @@ -253,6 +253,140 @@ ram_block_attribute_rdm_replay_discard(const
>>> RamDiscardManager *rdm,
>>>                                               
>>> ram_block_attribute_rdm_replay_cb);
>>>    }
>>>    +static bool ram_block_attribute_is_valid_range(RamBlockAttribute
>>> *attr,
>>> +                                               uint64_t offset,
>>> uint64_t size)
>>> +{
>>> +    MemoryRegion *mr = attr->mr;
>>> +
>>> +    g_assert(mr);
>>> +
>>> +    uint64_t region_size = memory_region_size(mr);
>>> +    int block_size = ram_block_attribute_get_block_size(attr);
>>
>> It is size_t, not int.
> 
> Fixed this and all below. Thanks!
> 
>>
>>> +
>>> +    if (!QEMU_IS_ALIGNED(offset, block_size)) {
>>
>> Does not the @size have to be aligned too?
> 
> Yes. Actually, the "start" and "size" are already do the alignment check
> in kvm_convert_memory(). I doubt if we still need it here.

Sure. My point is either check them both or neither.

> Anyway, in
> case of other users in the future, I'll add it.

Ok.

>>
>>> +        return false;
>>> +    }
>>> +    if (offset + size < offset || !size) {
>>
>> This could be just (offset + size <= offset).
>> (these overflow checks always blow up my little brain)
> 
> Modified.
> 
>>
>>> +        return false;
>>> +    }
>>> +    if (offset >= region_size || offset + size > region_size) {
>>
>> Just (offset + size > region_size) should do.
> 
> Ditto.
> 
>>
>>> +        return false;
>>> +    }
>>> +    return true;
>>> +}
>>> +
>>> +static void ram_block_attribute_notify_to_discard(RamBlockAttribute
>>> *attr,
>>> +                                                  uint64_t offset,
>>> +                                                  uint64_t size)
>>> +{
>>> +    RamDiscardListener *rdl;
>>> +
>>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>>> +        MemoryRegionSection tmp = *rdl->section;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            continue;
>>> +        }
>>> +        rdl->notify_discard(rdl, &tmp);
>>> +    }
>>> +}
>>> +
>>> +static int
>>> +ram_block_attribute_notify_to_populated(RamBlockAttribute *attr,
>>> +                                        uint64_t offset, uint64_t size)
>>> +{
>>> +    RamDiscardListener *rdl;
>>> +    int ret = 0;
>>> +
>>> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>>> +        MemoryRegionSection tmp = *rdl->section;
>>> +
>>> +        if (!memory_region_section_intersect_range(&tmp, offset,
>>> size)) {
>>> +            continue;
>>> +        }
>>> +        ret = rdl->notify_populate(rdl, &tmp);
>>> +        if (ret) {
>>> +            break;
>>> +        }
>>> +    }
>>> +
>>> +    return ret;
>>> +}
>>> +
>>> +static bool ram_block_attribute_is_range_populated(RamBlockAttribute
>>> *attr,
>>> +                                                   uint64_t offset,
>>> +                                                   uint64_t size)
>>> +{
>>> +    const int block_size = ram_block_attribute_get_block_size(attr);
>>
>> size_t.
>>
>>> +    const unsigned long first_bit = offset / block_size;
>>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>>> +    unsigned long found_bit;
>>> +
>>> +    /* We fake a shorter bitmap to avoid searching too far. */
>>
>> What is "fake" about it? We truthfully check here that every bit in
>> [first_bit, last_bit] is set.
> 
> Aha, you ask this question again :)
> (https://lore.kernel.org/qemu-devel/7131b4a3-a836-4efd-bcfc-982a0112ef05@intel.com/)

ah sorry :)

> If it is really confusing, let me remove this comment in next version.

yes please. Quite obvious if the helper takes the size, then this is what the caller wants to search within.

> 
>>
>>> +    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
>>> +                                   first_bit);
>>> +    return found_bit > last_bit;
>>> +}
>>> +
>>> +static bool
>>> +ram_block_attribute_is_range_discard(RamBlockAttribute *attr,
>>> +                                     uint64_t offset, uint64_t size)
>>> +{
>>> +    const int block_size = ram_block_attribute_get_block_size(attr);
>>
>> size_t.
>>
>>> +    const unsigned long first_bit = offset / block_size;
>>> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
>>> +    unsigned long found_bit;
>>> +
>>> +    /* We fake a shorter bitmap to avoid searching too far. */
>>> +    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
>>> +    return found_bit > last_bit;
>>> +}
>>> +
>>> +int ram_block_attribute_state_change(RamBlockAttribute *attr,
>>> uint64_t offset,
>>> +                                     uint64_t size, bool to_private)
>>> +{
>>> +    const int block_size = ram_block_attribute_get_block_size(attr);
>>
>> size_t.
>>
>>> +    const unsigned long first_bit = offset / block_size;
>>> +    const unsigned long nbits = size / block_size;
>>> +    int ret = 0;
>>> +
>>> +    if (!ram_block_attribute_is_valid_range(attr, offset, size)) {
>>> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
>>> +                     __func__, offset, size);
>>> +        return -1;
>>
>> May be -EINVAL?
> 
> Modified.
> 
>>
>>> +    }
>>> +
>>> +    /* Already discard/populated */
>>> +    if ((ram_block_attribute_is_range_discard(attr, offset, size) &&
>>> +         to_private) ||
>>> +        (ram_block_attribute_is_range_populated(attr, offset, size) &&
>>> +         !to_private)) {
>>
>> A tracepoint would be useful here imho.
> 
> [...]
> 
>>
>>> +        return 0;
>>> +    }
>>> +
>>> +    /* Unexpected mixture */
>>> +    if ((!ram_block_attribute_is_range_populated(attr, offset, size) &&
>>> +         to_private) ||
>>> +        (!ram_block_attribute_is_range_discard(attr, offset, size) &&
>>> +         !to_private)) {
>>> +        error_report("%s, the range is not all in the desired state: "
>>> +                     "(offset 0x%lx, size 0x%lx), %s",
>>> +                     __func__, offset, size,
>>> +                     to_private ? "private" : "shared");
>>> +        return -1;
>>
>> -EBUSY?
> 
> Maybe also -EINVAL since it is due to the invalid provided mixture
> range?

May be, I just prefer them different - might save some time on gdb-ing or adding printf's. Thanks,

> But Anyway, according to the discussion in patch #10, I'll add
> the support for this mixture scenario. No need to return the error.
Yeah, chunk from 10/10 should be here really.

>>
>>> +    }
>>> +
>>> +    if (to_private) {
>>> +        bitmap_clear(attr->bitmap, first_bit, nbits);
>>> +        ram_block_attribute_notify_to_discard(attr, offset, size);
>>> +    } else {
>>> +        bitmap_set(attr->bitmap, first_bit, nbits);
>>> +        ret = ram_block_attribute_notify_to_populated(attr, offset,
>>> size);
>>> +    }
>>
>> and a successful tracepoint here may be?
> 
> Good suggestion! I'll add tracepoint in next version.
> 
>>
>>> +
>>> +    return ret;
>>> +}
>>> +
>>>    RamBlockAttribute *ram_block_attribute_create(MemoryRegion *mr)
>>>    {
>>>        uint64_t bitmap_size;
>>
> 

-- 
Alexey


