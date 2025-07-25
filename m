Return-Path: <kvm+bounces-53443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC56FB11C54
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 12:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D3E27B823C
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 10:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5B442E06D2;
	Fri, 25 Jul 2025 10:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uB25rSsT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF842DE6ED;
	Fri, 25 Jul 2025 10:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753439391; cv=fail; b=atyCW/E6WbpfE4gOrT+iwLFdeGvDU4MlpspySte+R/7pk2iHzQXWugI7t81K4uROQCSTW9q5V/wmBxucRBx8/vJM6oNC6NXtr8sXgSxYRRTIBdtoHVpG5l4jp2tN2D9mSWDQFqpVKJNcg3ZsU0NF/FMuA0Zb61YVnRft3W7mR7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753439391; c=relaxed/simple;
	bh=XjbD2pejo0FxFUqPbNFBBLJGLDV+POLIOx5pYNeBhO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=pVmwIeY0fNzJ4ZDt7i1VSrv+IKg3t5R4H2sKB4fP3z3mGeO19dlmVIExokkTPenwX4AMpslfFApLehpnBGpdjHrq7kvLbQC8G9huoNNmgVNW2TMPciUaKevyjoLxjaCC5S8y/YfYUS8Y/YhSBdyJL9ddVgNgTjGGSjb1tzAIMmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uB25rSsT; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t2BvKqZhlOvn2mujytFkSRJiUT7UFs3j09SifBfPcAzNXEcU8Q/vacfjwEF2marASkBQb4fraV3oB9PG3uQ8aUA+wkfpxeQzPeb5v6cWhgfzUlo+4plomcO21nsNEypPWCAQuAMDnM5GXoF8PV4DPXoBPg4/Qz27gXg0K2laoDTj+gweLG29/azVmITtYNmZJNHdWc8ZA/gzpHjj+Q8sEIyK9wx7JT3S4wlS7ihUPXx+Zx2S94DzO/2C3B83SgMnF+LmzY0wOUl1UC93bx+YMfpu3jHsJee6xz/Q3u0TQTMUdcqUyV42YFBb0RdiR/Rf/3QJ4DJl92jJNDtmiX8M1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2PVfuKiD44FaM2uYk4Cu+QoQvKJjg2/dWU2rdF5+FKo=;
 b=J1TzwoOjJ/Tea7q7QgyGF6bM0L0K8PAR7IDWt1nEeKwxjWEpr+1w2f0B/JlPIVmlMS8BH4AIGm46wLolcLvaOBnYy6RFdSueFGjabS99RMtft1LwqJPMqP6+8XoFpZrNO5HATgBcVmuC54Sg5pjetq42mIQlTV20Pot8o/gF5iTOZBSkoJMnxOlD/pJDFNNhE+ETJmmv4DdYY+NzipLhWQUDKffhbpznPzIi0KWDhmFoIx7lTt6scvORIfdiOCQvyDrY2b0fqCyLlYgKy9F4FjaIzh4+Z/SoEKvz8Oyxqi0CMDlBvLL4wZbgvxCxWGHVfvpeUQfL37f+tzsSbf59LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PVfuKiD44FaM2uYk4Cu+QoQvKJjg2/dWU2rdF5+FKo=;
 b=uB25rSsTxkzOScQkaTjQo+IgHvquNw84wF/cQj+OjyBSosZbkqYNbhCrJfdRl/ftwogpCpMSU8tb7sXuLVVWJU+SHF+/DFOcYbPNfmAcHrVpmQSZgtSWgqxuMnsotSBbjgg7GCrxG3eWPiqxCZOiOwpPZB3adRJzJJEYGnTVTjE=
Received: from MW4PR03CA0337.namprd03.prod.outlook.com (2603:10b6:303:dc::12)
 by CYXPR12MB9387.namprd12.prod.outlook.com (2603:10b6:930:e6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 10:29:45 +0000
Received: from CO1PEPF000075EF.namprd03.prod.outlook.com
 (2603:10b6:303:dc:cafe::9f) by MW4PR03CA0337.outlook.office365.com
 (2603:10b6:303:dc::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.24 via Frontend Transport; Fri,
 25 Jul 2025 10:29:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000075EF.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Fri, 25 Jul 2025 10:29:45 +0000
Received: from [10.136.41.253] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 25 Jul
 2025 05:29:40 -0500
Message-ID: <90529f27-6e64-4756-9999-b572621b8d6d@amd.com>
Date: Fri, 25 Jul 2025 15:59:37 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] iommu/amd: Reuse device table for kdump
To: Ashish Kalra <Ashish.Kalra@amd.com>, <joro@8bytes.org>,
	<suravee.suthikulpanit@amd.com>, <thomas.lendacky@amd.com>,
	<Sairaj.ArunKodilkar@amd.com>, <Vasant.Hegde@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
References: <cover.1753133022.git.ashish.kalra@amd.com>
 <0a9f79741e8a5b1619069a892bc5c22f17df1c34.1753133022.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <0a9f79741e8a5b1619069a892bc5c22f17df1c34.1753133022.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075EF:EE_|CYXPR12MB9387:EE_
X-MS-Office365-Filtering-Correlation-Id: bf2df71a-ba40-495c-7578-08ddcb662cd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUoxK3ExODJDR0NDNm5CLzVjSnp1OHJINTljbkVUVkQ4eDFKdTZaSVVVK2dk?=
 =?utf-8?B?dlpiSXNCbG1mYWNiWVpVUDh3M0NWWDIwaWRIZnBrSEo2aWx2aTZqeGxVOEJy?=
 =?utf-8?B?UU8yeFhUeFk4ZVdFbHB5Sis1Rk1aRjFwbjg0TFQvOWhrOHpTbTZKSEhHa25R?=
 =?utf-8?B?Zy81T2lISWZmQmxDVDgydld4Wkx2aUNNZll5UE9pZlJ2ZkhyKzJHcVhQckwz?=
 =?utf-8?B?b2xLQjNGN2dycjhqd29XOHVLMzNIbE5DdW1HeWtwdWsrSVBOZytqU1llSU1D?=
 =?utf-8?B?N2RNdDdhZlV4MERrM0pNMzNYbjFXN0xWZmwwZFVDYjlIMjlZMlBGdVdWVjJP?=
 =?utf-8?B?WURhb01jTGhWeXEya0g0NUhpWFNqdjlpM1hPTVB3Q1RRZ3pLV3lVUEZPZXVM?=
 =?utf-8?B?WVg1bDh2OGpQenVnVkVxZloreTV6L201bHYwemxxZCt5bzN4c081R3ZuZlNV?=
 =?utf-8?B?dGxjTjEvVHZwRHBmSnRHaGEyRWJOckJjUEZ2VlVyS1pIYmxLcjBJUmI1NDBQ?=
 =?utf-8?B?ZUl4WkxJSlU0OElmOHRTdzNFYXRJbUJHRkwvMUdmZ1pGYW10emtWRWZuVm15?=
 =?utf-8?B?TmYyRWZVSHdVNGgxcTRSbCtCeGd0cUluY09qeDc4cFJwMGZuaVoxaTZvazAz?=
 =?utf-8?B?Nk04V0hCODUyaUg3NGgrM2FzbjRZTm9VREJvK202clo0WklrTURReURIUVhG?=
 =?utf-8?B?YXJYNDRSUHJsN1MrQ3pkcFVtS29majFhZG4zUGU4VWdGL3R3WTFWaHRFRHhN?=
 =?utf-8?B?eWdqb25uWUlDL2Q0aTNKWGtKa25Hdklockx5cVFFd3VWV2VNaWFSS1gxb3JF?=
 =?utf-8?B?Z3VoRldUd0RBNnZHYVVXR29oNmZTWUcwL2I5eGoyN1Y1ZDRWWWxuMWtYWFJK?=
 =?utf-8?B?bTFFQ2VyVm5QQkwrS1J6eE1tVXFIMXhlQ09BWDJNU2xTTXVGZzdWaVQzWnJH?=
 =?utf-8?B?d0NvTjlMTXhEcjM0SmZ2b28wellvTGhJSVJySXBLWnI4MjBYK2YwQi9OR3dr?=
 =?utf-8?B?S3hkbzF4bXFvUW52VE1OajRIWFcxYzVVYUJnTW1KS3RLa2t3dDVwTkFKOTBG?=
 =?utf-8?B?UHBtUmwzMlVwdzNha01JSkI1dEs4RE1kNXJJc1RPdDhwUjF6SjdFdlJXU3Fx?=
 =?utf-8?B?V2l2Z0RoaGJnU2xxZHhINmF5bldnRTBBUGhrenhLRnlIQ0FpZEtRVlptaUow?=
 =?utf-8?B?bmM2cTl5Skc2V1M1b0NsMUxCZVk0SGdFMG15ZHFkWUFvbSs3YXhMZWJkdmx1?=
 =?utf-8?B?ZmFaMzdpcDM1ZDcyejR2ZkhoSGVWTkVKNi82OTMrZ2RhTVppNnJxWEpNazVq?=
 =?utf-8?B?eEVkRG1Vck14RGpCbThrZkpIcE54ZlJ3dGoyaHBzQnUvR0RIYjRVaWREeGlq?=
 =?utf-8?B?TURFWmlMT01CQTNSdWlvcm9uZEhnTmZIWjV5RkF1K1NzMDdPb3N6dG9oYmkv?=
 =?utf-8?B?anA0cmtGNTlFM0poaGZmcmxqazhlSERlUDhrL1dwMkpHWW1seTFRbTFxRHNa?=
 =?utf-8?B?ZEZLQXBUbytjUS9kR3VFcTBHZklTbVFrZ2JNaVFwUkc5ZG5ZcE5qa2plL2RB?=
 =?utf-8?B?emdBK0oyd2o5YmdRSUFxRE5Fa2NjeSt2bjNQQXpSejYwUkZqcng3bnZoUHdo?=
 =?utf-8?B?N1VENXJsSmdOWmNSeXd5a1Joa0JQZC9xbmF0YzlWZkJ2Rng5VHFDRUxnZFJC?=
 =?utf-8?B?bTdCZWxDckFOWGVmZk5LY3ZBZWFVSnZEMTM2bU9XQ3JnK09lZXNxajNmSkxU?=
 =?utf-8?B?cHRHdStPTE53WkVaaWhpY2dZNnJpa3BYZHZvTkhGUFVCcjlWc2xrRUhzRW84?=
 =?utf-8?B?QUZneUtxdUg2QzlIOWpidFR6K2l6S212ZW11VHc0UVhmSlhYQWhodzFsUmJU?=
 =?utf-8?B?NWlHamRCTE04ZHpiUUpJYlIxa2NKNk93ZjJJZzJkSzBvWjFrK3ZvL1JmRE8x?=
 =?utf-8?B?anNyN2hxNTZucjNTUUFvYndiWTFFdkViYUh4SHN6OXcwM1FRVnRZaVdrc2hx?=
 =?utf-8?B?RXFJQlQ3dVBDR3psNmdmV1F4V1lBRktabFpEbU90M3VHd3lWUy8zUDlQd3Y5?=
 =?utf-8?Q?HarVDu?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 10:29:45.3763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf2df71a-ba40-495c-7578-08ddcb662cd3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075EF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9387



On 7/22/2025 3:23 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> After a panic if SNP is enabled in the previous kernel then the kdump
> kernel boots with IOMMU SNP enforcement still enabled.
> 
> IOMMU device table register is locked and exclusive to the previous
> kernel. Attempts to copy old device table from the previous kernel
> fails in kdump kernel as hardware ignores writes to the locked device
> table base address register as per AMD IOMMU spec Section 2.12.2.1.
> 
> This results in repeated "Completion-Wait loop timed out" errors and a
> second kernel panic: "Kernel panic - not syncing: timer doesn't work
> through Interrupt-remapped IO-APIC".
> 
> Reuse device table instead of copying device table in case of kdump
> boot and remove all copying device table code.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>

