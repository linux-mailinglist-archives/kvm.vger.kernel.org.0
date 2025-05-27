Return-Path: <kvm+bounces-47736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 363C7AC45D8
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 03:20:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6E2F1784C3
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 01:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B822D84039;
	Tue, 27 May 2025 01:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tdD0COc/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2061.outbound.protection.outlook.com [40.107.236.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF61C249F9
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 01:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748308849; cv=fail; b=bLJqbfCgZKb+GNjaU+mrPqB+P21ikny1umtxwY+ioE8t1DL6VVeOmk8R3S2ZBqgty/MViLIr3pfn/C7TNOI2yTxeXxJs3DoeSlk6X4sQAfmWzILVhCWi6BMgelHN/g5suwdjE2U/3fRf18MmYdfMXYsaCZegQB/908VcE1/fIf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748308849; c=relaxed/simple;
	bh=YohFJbpaAr4V38IaeeZfKpx4J3hGr+KPNTXTZCB2ox4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cR2EIaz6ivoxalBGxXLVDr6tl4BcOcl50kWv3xUIlZFw7/zpJ8EVnBteSNlsbznSbitlX5y0xQgGAiX/d56pfgxEYIYiTaBVN2goWbLPr81Nw47/mGMsUiPkJNgFiCqIOQgznqkZbyG0s6d+uXkYWNqjDx4rV3fcFJG5xL70LpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tdD0COc/; arc=fail smtp.client-ip=40.107.236.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gnzs9k5Sc8ywj7dwJ7JYuWxYWS2UjyYl+YWGKZMoS4fQdxfRN7FaAJoufRh22iIiFVJNtuwotp7RVCG9UomuirWOElrXKwp3NGqMTDQx6y1v6A47oo3zMPoFiGfJuVfKJ3/sNQRsfAg7bGCxbjhbLZ9RSjyNz3QadSxm+JBQSZFgoJvpFzUv0UVi/WdOffFB/WT9D5kypJFRhltb7eXUWC3Yf3Rd6MFZsk3dHFs1cf5cDk3x3yYjZFTJtjqycNFVpf+ToWQX7cEqYWbyZQp2fFPKHUkgqj88oLq58vXshlSFuXgKbKSWWDhqRiXL4nDD2ro8l4LValyZk7trKKGWBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULRRPprcyIffJWghuG0TeDAdBINNTx58P0EJy74tNlg=;
 b=nEfiPH8V/fUCTL+9JsuPauASdJgpjXEsZ0ixRFDBUZsjlbDgEnTzSuAAc9lLT0d0Ix25MAlzyKvplTZJfXlAWfNo5iAFi9Urm/tDTM6Ki9ItR08N23zxmyC7rq6w7dFAs3gtWQSLDTp8s3hWFhbShUHfpWqrh7PJLQE/tJqbi72udu3xbxC+i6q4IEJ19dTCf+HOoCRIbuZODIafM/RfQvsUWhTydTiVuwzUVy1FD7Ez801xLaWQwqbh0OtYoK0ASZviO+zk/WmGafGZJc1Ydtiu5GHw5oupPR+eUue11ZAsV51mSVZ2VmuuIxQpF/ZYj6CyCdqw7IHugGBHumzjjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULRRPprcyIffJWghuG0TeDAdBINNTx58P0EJy74tNlg=;
 b=tdD0COc/nvolNfDNkJjPAanLcCjEN02gNBq7GdIIbhKXUiz90XV0bTNrtjirc4AjKCqUXIwAWDx5NoYGvl1roIYbuNDmmmgamf9x/f8pnd6ANmY0B0I9elX0M73T6x8GjtMr7pYmhqu0AJMnpl5gPDQjBsVaiNgqPNuGUFHbRrw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB6870.namprd12.prod.outlook.com (2603:10b6:806:25e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.24; Tue, 27 May
 2025 01:20:42 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 01:20:42 +0000
Message-ID: <173fd9e8-65f7-479e-b7ef-a8b9cca088e8@amd.com>
Date: Tue, 27 May 2025 11:20:35 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v5 04/10] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBlock with guest_memfd
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
 <20250520102856.132417-5-chenyi.qiang@intel.com>
 <e2e5c4ef-6647-49b2-a044-0634abd6a74e@redhat.com>
 <0bc65b4f-f28c-4198-8693-1810c9d11c9b@intel.com>
 <f28a7a55-be6e-409f-bc06-b9a9b4b3a878@amd.com>
 <6ebda777-f106-48fd-ac84-b8050a4b269f@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <6ebda777-f106-48fd-ac84-b8050a4b269f@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYBPR01CA0182.ausprd01.prod.outlook.com
 (2603:10c6:10:52::26) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB6870:EE_
X-MS-Office365-Filtering-Correlation-Id: f7ada109-71d7-455b-f256-08dd9cbcb2cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXJnK0tWSDgwOWtZR2JrbWJzRzZGM2hhN1dkTFJjSkpSemFRTlh4Q2U1N2x2?=
 =?utf-8?B?Yjl4L1JFdzJlb1hYSlNvdm0vMjdYKzY0cngrRzJFdWoxZ3ZOSGVBdXF4T3A4?=
 =?utf-8?B?MzFuc0lMMmtWVjJDb0RTVmtCdWZVbng2c0Y4aEZodEhDL3Y5Q3cwb2lrNHlV?=
 =?utf-8?B?SHdrWFl5RHJoamdweld3eVJNTzhiaTZtaFRTZ2ozMXU3RDU5cmxFYzB6Nytp?=
 =?utf-8?B?b3hhRzRwTzExb000ck9PNHhTMHBkcDkvU2RFMjZuYjlJQUIyc2xQYUxyZUEy?=
 =?utf-8?B?QU94dGJBVys2WXNNazBDWU83ajFGTmFWYVZua3NMQjdJcGxRU01UQUl2d3Zs?=
 =?utf-8?B?OS9RZG1mOWNFSkVVWjFnT1hjcjZ5bHAybE12enhZQTZ0aFp1RVJlK1VPdUZZ?=
 =?utf-8?B?NUt2cDU3N0JaYisxdU8zWDdPaitEMHZvc3UrRitValZUOFIxb3d0aGhnOU0w?=
 =?utf-8?B?OWNHQkg1SklHL20wdnozS0IzSGFTR0R5RFRDZGJsajZRRU9LRDlwZEJ4SUVz?=
 =?utf-8?B?SmQ0NW9yRGVuQUExc0YvK0JabjJsYWd5eTRIc0ZOVGthbnN3SVhKKzhPKzYr?=
 =?utf-8?B?QmlrOGpOMjZYTmJ4ZlBYVTBKN3I1cEpwWElJUlozeU03NGk2WHBDZWNoblBY?=
 =?utf-8?B?WGhPdEpNODZMbXNqcHNmYTBidTA1c1ducnBaYVk0ZkVPUExBN3YwZ2xOY0l6?=
 =?utf-8?B?L3BCUFp6NHpZS1hnbCs2QnZWNURHa2lFSjMvRStXemllOURIb0hKL3ZHL2RZ?=
 =?utf-8?B?MEFNZDBQb0QvTGtWMXJNeFNFVlVydm0wMGdmYndHZjgyQmxiWkFNUmxsczZL?=
 =?utf-8?B?eXJkRTBHTnZnV0owMWlzdXp4d0IxY2s3M1FhZmVIdUJyN0FYZGd1R3c3Rk1z?=
 =?utf-8?B?Z3VsdEZPc0NoelI1Y1BPcWc2Ri9POEk2NmNvR0pVa2U1cnduV3hLejhSeEFF?=
 =?utf-8?B?eWxSTFE2TUwwUnNtVVRXL0VzaGM5L1BxV01uazV1ODdGM05pSjhmZm1PUitE?=
 =?utf-8?B?L3NEdXNIWEtUNVVsNWtlejJBWHNtMU5YUWd0QlFTL3E3Z1AyZFJTN3lnbldw?=
 =?utf-8?B?VHpQR0x5cVNPdnpIRGRoSHUreEhOYkJjMHJiL0tMclZvRW9VSFE5Zm9tc0dR?=
 =?utf-8?B?aTByakdWMk8zck5sMEs0alFlMWNOWkV0VlBHK3d4TXpkamg3Nk10cmhzV2pj?=
 =?utf-8?B?bTR2eXIyaE5HbjZTdkhXTmpFVGRRcnJ3c1l1QzJBdVVTQnVpa2s3OHZTdDZp?=
 =?utf-8?B?UGRTSytvVzVyYVF1Vk14WEZhTjByODVxMXZMUGoyVVF5RCtZNEVnaEpRd21x?=
 =?utf-8?B?MUVQMEVwRXBHN1llVGVRTExFSXAyOWxTVGVibnJ0azBiLyt0VmVUZUVpRSti?=
 =?utf-8?B?TUVuVDRNaTgvYWNGUkY1ZnQrcmZ2NnFab1JJejM5TitZb0dweEt5QzVzbnFR?=
 =?utf-8?B?MWxueEt1ZUFtT3liV3BwTXpheExZZ25XeXVaU01HTm4rcTBuUU9Ra0h5TlVX?=
 =?utf-8?B?ZkwwVG16MjU0VHJzdWs2VlRTYUZJdlYxUjNrNFVwQm5kbGhFQXFJeml3bzZ2?=
 =?utf-8?B?dk53ajd0RktwZFNEZDlpUFF0ZGhYWnRGa0dTaUpMY3ZWanBSK3NqdzAyM1hW?=
 =?utf-8?B?ak94RDVTMWNqMDRCUkVIVFRhNmpwZDI5M3RMSzlzSFg2Y0FUc3hKQ2xKYmZV?=
 =?utf-8?B?cDZ2azRpWjVrRzBDWENvYjc0TzRzUmlzY1pUdlV3NnFaTW1kMXorZnRJSDlq?=
 =?utf-8?B?VVRPcjJmWnVyWmRKOGZBVXN6MWlyVGJmU3lIbkNXL3l6VURrUm9lcmpwWit0?=
 =?utf-8?B?OEg1ak81WnN6bFl2VVAyQ2lNOWFiK1doeWl5RzRrNDlwRXEyaGVpajVBWHhV?=
 =?utf-8?B?SnlDV2lMdm9YakUwRng3OXhvWmoyTEVUTFIwazhPWitpTEJ5eVJXdmRrMVdN?=
 =?utf-8?Q?8cbP6I56gO0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1pRQm5MdXU2VVhJK3RidW9jcWZhYUxWQ3FhVURCVzYzZGNFL1BaZ1dQMzlF?=
 =?utf-8?B?R1NFZmxCWjhLZ09MRFc0eThjS2FNWEJzNjNoWkFDbzJSaFk1cGhqd3E1WFBR?=
 =?utf-8?B?RlpsNktoUk9xb3pjNGxuL2dtZExRcFU5dmx4aFg1Unc3NE1tZ1BCMFR4SnA2?=
 =?utf-8?B?THdQY0VKRmZSaHVnL3Mza0Z5NlJzNHJPZEFBQXNtdHpXUEplVXBEeDU3RnpF?=
 =?utf-8?B?bkZPSWJOMmxLRjlaYVc0Q3VUVVVPOFhodFNDKzc0VDFXNTJrb0lFZ2tqTHUy?=
 =?utf-8?B?TVErcjF0RTdtbllPRWFLclpibER0disyRnFhbktQMWZUMjVxLzJ4elNvK0Ja?=
 =?utf-8?B?NWxibVR6bXlNL0UvTHBqQ1d2OFByMGF0TFlKSCt1OVFteWpvVnIvRWNxdkxH?=
 =?utf-8?B?MXVRcDZ3VWUxL0VCNXhtd2VUQmkzSEJhL0szWWhSTy9KMlNnL1JrYW96NVZr?=
 =?utf-8?B?NUhHbmkrWTExLzV1MEkyTWV4bnBpdWdwTVB1R2ZJZFlHL0RqYVV0T2pJUUxS?=
 =?utf-8?B?VjBPczZ3YzFtZkNmK0Y3em9NL2cvZkZ5NnhpSFB1UE1SazkwcEVpcG1nQ3F4?=
 =?utf-8?B?Q25Yc05nTS9aUU5pTWZTdTlwbDJNc2hpYjFBUXhxWFNQQmhsakdscXh6bm1Y?=
 =?utf-8?B?M1krT1ZGcDl1Ym8xMU5MRnJOUEpraHB2L0RnRlNpd245dGZ1YjllQ0V1ODM5?=
 =?utf-8?B?WEgvRnJacUo2d1RkMm9EVVdRdW9rdExnSlFTYWdUM0xkMXUyekxUVEdyaDN3?=
 =?utf-8?B?ZmJLbmtvU0RsUEtZWFF6dTlkcUo4YVdpekhyTmJldWx2RVozQ2xWa2JwR1p4?=
 =?utf-8?B?RHRpcDhTb0pKcjU5c0NzMFpXYm5Bd3hlVllWVm5zWTJZMGZXL0lHcmIrdzJN?=
 =?utf-8?B?L2liaXJHOGlRVDRocWdVT1laaTBOWHlLcEY0WXFyRVRmeTl3Unl3ZUUzTHlj?=
 =?utf-8?B?VWdKRFRPYUZSL1l4Z2JwcDBnUkU2anBFRkhZMmJkWjBCenYyTzl2bUh2aFpn?=
 =?utf-8?B?aVBKckEvTDU4Sm5ZWHcxYmN6cHJqSGh3a0hTWStycDMrUWNiUWJISGQvK0Vv?=
 =?utf-8?B?RUw1S0xUR0hoL2ZndzBKNll3b3NKelFBR2duam92M1dteHFSak5mdWZCNHFH?=
 =?utf-8?B?dWw3R0plY2VjVnlIbkRPOXNFSXB5M2U1TkJ4UE1kaW4vQUk3RktwdW9EYW5o?=
 =?utf-8?B?UEh5aXc0MFA1MjJONXh4K1ZMdTF1Mk4wd240NVhTR3h0WjVhLyt2RzdpQ2lr?=
 =?utf-8?B?UGM2eDRZQndnZUFaYkduNy9zWkUxNVAvV3JjeUJIai81bTlLbUJhTzZqL1ha?=
 =?utf-8?B?dCtucnBRd0NkZi83cjBLZ3lSZ3M0Y1BNcXRCb3dPbWh4R0F6OHNwOWsyK2Nv?=
 =?utf-8?B?TkhsZ0RlMjI1UzlxSHBlcGY1NkFDcGpIbm9jMUl6U2Z0RVFTNWU0ZHpRSUh6?=
 =?utf-8?B?ZWw1UkRIYm52cTl5dW5qQ2poN2NTd01SOG1aUkNGckg0TFc5ZE44MGNkTzZs?=
 =?utf-8?B?NGZVd29nZ0RqRldNeVJiV0pIUTR4QXZzT01HY21qMjh2TU5IeGVsc3l3aGVt?=
 =?utf-8?B?YkdkS2lEZkxOdlZsenhINXJqT1BReUl3OWc3cVdLek5SMUJOWTRxN0kyanVM?=
 =?utf-8?B?Sm9aREp2R09peWRqQ3V0RURycUZBSnpQL3ZhcWRmejhEMTRtZ1FVVGhGM0F0?=
 =?utf-8?B?U2pOak9ZeTI4aGw1S1RDTE5weGFPRkVvcTJsRGNNdFkzOTF0aHNNRGtmd2Jp?=
 =?utf-8?B?Y2pSNFpBWGhTbWkyV0VMN2kyQzNGUmZEeTBhTVp4MGFhVXRmQW9YOVhMSjMx?=
 =?utf-8?B?TnlkRlgvbFU3VW1FeGpXV01jYkxlY3lIYk0wVGtjK3hoWThVMC9CUTJnYm5N?=
 =?utf-8?B?bjNCRkp6aDJmY1ZTL2dpWmt0bEM5clkxSEtNZ0MyeUJ5NHRVRkFSeUNNb0VD?=
 =?utf-8?B?Wi9oZU0wODZlUUliem5OZkRqckFQOHN6VHNJYmhoU3UrM2pZOEt6c25NUHJ0?=
 =?utf-8?B?NzRyaTlPMUk4Ykw2VDJjand6YVE1cjdnKzRFSGpzYzFMdVBzbFhoNmF6RlVO?=
 =?utf-8?B?dktwQUxVMDdhTG9EQTVsSi8zZjlmN3hveCtTY0VWNlBwc2RlZmdXRlRsT3hz?=
 =?utf-8?Q?fIxx4Kgqv7EVWmA9kJYvccH2Y?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ada109-71d7-455b-f256-08dd9cbcb2cc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 01:20:42.8067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzoufKzFqsZr19fVRMdMZ7JEZCGgB+2gYDmcHHm5FeVv1dCRJXZsEmu4dJ/QbYbkvevmGCh1sfOrU3KGPC4uiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6870



On 27/5/25 11:15, Chenyi Qiang wrote:
> 
> 
> On 5/26/2025 7:16 PM, Alexey Kardashevskiy wrote:
>>
>>
>> On 26/5/25 19:28, Chenyi Qiang wrote:
>>>
>>>
>>> On 5/26/2025 5:01 PM, David Hildenbrand wrote:
>>>> On 20.05.25 12:28, Chenyi Qiang wrote:
>>>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>>>>> discard") highlighted that subsystems like VFIO may disable RAM block
>>>>> discard. However, guest_memfd relies on discard operations for page
>>>>> conversion between private and shared memory, potentially leading to
>>>>> stale IOMMU mapping issue when assigning hardware devices to
>>>>> confidential VMs via shared memory. To address this and allow shared
>>>>> device assignement, it is crucial to ensure VFIO system refresh its
>>>>> IOMMU mappings.
>>>>>
>>>>> RamDiscardManager is an existing interface (used by virtio-mem) to
>>>>> adjust VFIO mappings in relation to VM page assignment. Effectively
>>>>> page
>>>>> conversion is similar to hot-removing a page in one mode and adding it
>>>>> back in the other. Therefore, similar actions are required for page
>>>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>>>> facilitate this process.
>>>>>
>>>>> Since guest_memfd is not an object, it cannot directly implement the
>>>>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>>>>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>>>>> have a memory backend while others do not. Notably, virtual BIOS
>>>>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>>>>> backend.
>>>>>
>>>>> To manage RAMBlocks with guest_memfd, define a new object named
>>>>> RamBlockAttribute to implement the RamDiscardManager interface. This
>>>>> object can store the guest_memfd information such as bitmap for shared
>>>>> memory, and handles page conversion notification. In the context of
>>>>> RamDiscardManager, shared state is analogous to populated and private
>>>>> state is treated as discard. The memory state is tracked at the host
>>>>> page size granularity, as minimum memory conversion size can be one
>>>>> page
>>>>> per request. Additionally, VFIO expects the DMA mapping for a specific
>>>>> iova to be mapped and unmapped with the same granularity. Confidential
>>>>> VMs may perform partial conversions, such as conversions on small
>>>>> regions within larger regions. To prevent such invalid cases and until
>>>>> cut_mapping operation support is available, all operations are
>>>>> performed
>>>>> with 4K granularity.
>>>>>
>>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>>> ---
>>>>> Changes in v5:
>>>>>        - Revert to use RamDiscardManager interface instead of
>>>>> introducing
>>>>>          new hierarchy of class to manage private/shared state, and keep
>>>>>          using the new name of RamBlockAttribute compared with the
>>>>>          MemoryAttributeManager in v3.
>>>>>        - Use *simple* version of object_define and object_declare
>>>>> since the
>>>>>          state_change() function is changed as an exported function
>>>>> instead
>>>>>          of a virtual function in later patch.
>>>>>        - Move the introduction of RamBlockAttribute field to this
>>>>> patch and
>>>>>          rename it to ram_shared. (Alexey)
>>>>>        - call the exit() when register/unregister failed. (Zhao)
>>>>>        - Add the ram-block-attribute.c to Memory API related part in
>>>>>          MAINTAINERS.
>>>>>
>>>>> Changes in v4:
>>>>>        - Change the name from memory-attribute-manager to
>>>>>          ram-block-attribute.
>>>>>        - Implement the newly-introduced PrivateSharedManager instead of
>>>>>          RamDiscardManager and change related commit message.
>>>>>        - Define the new object in ramblock.h instead of adding a new
>>>>> file.
>>>>>
>>>>> Changes in v3:
>>>>>        - Some rename (bitmap_size->shared_bitmap_size,
>>>>>          first_one/zero_bit->first_bit, etc.)
>>>>>        - Change shared_bitmap_size from uint32_t to unsigned
>>>>>        - Return mgr->mr->ram_block->page_size in get_block_size()
>>>>>        - Move set_ram_discard_manager() up to avoid a g_free() in
>>>>> failure
>>>>>          case.
>>>>>        - Add const for the memory_attribute_manager_get_block_size()
>>>>>        - Unify the ReplayRamPopulate and ReplayRamDiscard and related
>>>>>          callback.
>>>>>
>>>>> Changes in v2:
>>>>>        - Rename the object name to MemoryAttributeManager
>>>>>        - Rename the bitmap to shared_bitmap to make it more clear.
>>>>>        - Remove block_size field and get it from a helper. In future, we
>>>>>          can get the page_size from RAMBlock if necessary.
>>>>>        - Remove the unncessary "struct" before GuestMemfdReplayData
>>>>>        - Remove the unncessary g_free() for the bitmap
>>>>>        - Add some error report when the callback failure for
>>>>>          populated/discarded section.
>>>>>        - Move the realize()/unrealize() definition to this patch.
>>>>> ---
>>>>>     MAINTAINERS                  |   1 +
>>>>>     include/system/ramblock.h    |  20 +++
>>>>>     system/meson.build           |   1 +
>>>>>     system/ram-block-attribute.c | 311 ++++++++++++++++++++++++++++++
>>>>> +++++
>>>>>     4 files changed, 333 insertions(+)
>>>>>     create mode 100644 system/ram-block-attribute.c
>>>>>
>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>>> index 6dacd6d004..3b4947dc74 100644
>>>>> --- a/MAINTAINERS
>>>>> +++ b/MAINTAINERS
>>>>> @@ -3149,6 +3149,7 @@ F: system/memory.c
>>>>>     F: system/memory_mapping.c
>>>>>     F: system/physmem.c
>>>>>     F: system/memory-internal.h
>>>>> +F: system/ram-block-attribute.c
>>>>>     F: scripts/coccinelle/memory-region-housekeeping.cocci
>>>>>       Memory devices
>>>>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>>>>> index d8a116ba99..09255e8495 100644
>>>>> --- a/include/system/ramblock.h
>>>>> +++ b/include/system/ramblock.h
>>>>> @@ -22,6 +22,10 @@
>>>>>     #include "exec/cpu-common.h"
>>>>>     #include "qemu/rcu.h"
>>>>>     #include "exec/ramlist.h"
>>>>> +#include "system/hostmem.h"
>>>>> +
>>>>> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
>>>>> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttribute, RAM_BLOCK_ATTRIBUTE)
>>>>>       struct RAMBlock {
>>>>>         struct rcu_head rcu;
>>>>> @@ -42,6 +46,8 @@ struct RAMBlock {
>>>>>         int fd;
>>>>>         uint64_t fd_offset;
>>>>>         int guest_memfd;
>>>>> +    /* 1-setting of the bitmap in ram_shared represents ram is
>>>>> shared */
>>>>
>>>> That comment looks misplaced, and the variable misnamed.
>>>>
>>>> The commet should go into RamBlockAttribute and the variable should
>>>> likely be named "attributes".
>>>>
>>>> Also, "ram_shared" is not used at all in this patch, it should be moved
>>>> into the corresponding patch.
>>>
>>> I thought we only manage the private and shared attribute, so name it as
>>> ram_shared. And in the future if managing other attributes, then rename
>>> it to attributes. It seems I overcomplicated things.
>>
>>
>> We manage populated vs discarded. Right now populated==shared but the
>> very next thing I will try doing is flipping this to populated==private.
>> Thanks,
> 
> Can you elaborate your case why need to do the flip? populated and
> discarded are two states represented in the bitmap, is it workable to
> just call the related handler based on the bitmap?


Due to lack of inplace memory conversion in upstream linux, this is the way to allow DMA for TDISP devices. So I'll need to make populated==private opposite to the current populated==shared (+change the kernel too, of course). Not sure I'm going to push real hard though, depending on the inplace private/shared memory conversion work. Thanks,


> 
>>
>>>
>>>>
>>>>> +    RamBlockAttribute *ram_shared;
>>>>>         size_t page_size;
>>>>>         /* dirty bitmap used during migration */
>>>>>         unsigned long *bmap;
>>>>> @@ -91,4 +97,18 @@ struct RAMBlock {
>>>>>         ram_addr_t postcopy_length;
>>>>>     };
>>>>>     +struct RamBlockAttribute {
>>>>
>>>> Should this actually be "RamBlockAttributes" ?
>>>
>>> Yes. To match with variable name "attributes", it can be renamed as
>>> RamBlockAttributes.
>>>
>>>>
>>>>> +    Object parent;
>>>>> +
>>>>> +    MemoryRegion *mr;
>>>>
>>>>
>>>> Should we link to the parent RAMBlock instead, and lookup the MR from
>>>> there?
>>>
>>> Good suggestion! It can also help to reduce the long arrow operation in
>>> ram_block_attribute_get_block_size().
>>>
>>>>
>>>>
>>>
>>
> 

-- 
Alexey


