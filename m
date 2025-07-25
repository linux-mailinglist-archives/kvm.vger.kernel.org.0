Return-Path: <kvm+bounces-53445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AEB2B11C5B
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 12:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0683A4E0DB8
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 10:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D25D2E4986;
	Fri, 25 Jul 2025 10:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pgixuGk3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED23323A58E;
	Fri, 25 Jul 2025 10:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753439463; cv=fail; b=co+QMtGEb0y7f/4j7m8IJugoTjSKjq3rbJY8v7K8q8eNe5MvDqXc3iLrSXNrO/b92uGhkUFhT28nfC7AzdBm0t5pX565c+ITj6c551cfvxnUAzaI4srOIo72GjpMfso/okLludmCaNnpSlNXDFl+Qk0TiMH9ZqKTCtz0pisp+yY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753439463; c=relaxed/simple;
	bh=I4gPn7NjZOi8nTiJOwpQbnkEBoaF51p+reJgMk8h+O4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DqrlT3IEbiSoi2G4DnL1lsk4eXkUkRCl5bz/4XDjNZQLAkNLIBIkE7rhcFRJOezKbyBsw7KkWfNwS1HzlrbcDCY5Cy4l0uUMx5ID3H0u4uUKlGPVBSByjrlZS/rjWEa6vt2PYAl3gXtfhqkZMQFlFCGAGYXD74Oisil/h4nNBLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pgixuGk3; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KBNLSYICEg+q9c8rVflZo5OlSbU+R5vEM1Z5MuV0sIucEEk1Fd1aGYzLQzDgWhfOci5RYQdj161aOT67cmRdGi5GKuVgGCL9cTFrHRo5RgLUJo5ehtHuLEklalZNUwl3mW4vwxPfP8qnJycDV4Sck5Ec2XnXIn3JB4ZJUuiV9MMq9g/2zWM5SYQZ0ax0oaMrUVk1rnFo5RLaaqwsoerTZQP5qdH9QMWEtTCPPzQl/zGyltpeNNOTq1wfXKGGGg2+4F+rYre4Ob3MWs+GDdjR9p01hd27SoVUuayjhqKe87ZuhI82hoETuNllgMntyK12dok19VfdsiB2XY5xgCMtJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32UZYLywo8KH+MpROOPIKjo1og/FmFmziShXB6FNNrY=;
 b=NCs0aimk6oNqU0RC9El1ixKHoT6REUxgk0aq12OpAbfLLKZoESMObRmTydI2QNqB/wlKyf5/bppzygyNf/ChbZWsGvibuXTqiGaUP6ZX7XuBpdRzvshNnaDS3gpqPAb/TowKIHoOvW1BLFMdCyNWOP40lPMtHFa6kTDOW1meN0Xs0hDHkRBM2VGmgraBEyny6C9yPz4MFINt8G33fWRnj1pO7Onv06wRt6EzfNwY2d+2r7f01nahEEmQkfO+d4bA+PnrXgeWQVOKa1E420mrqI9f//VlHSl9raVZ7KMzYhuKWH947LtjmSSAtg5kCOGgkxzulyawVkmISXdKJ4jJnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32UZYLywo8KH+MpROOPIKjo1og/FmFmziShXB6FNNrY=;
 b=pgixuGk39a/YsiTY9mwDScNAd6/R6f9XzAF7vdmtgpbGvdddmqWYkc//RVMZJeTVKh2dPCydZ/MNPSuxWAW5/m/D3gRc2ZRZYrf6au7pKhNJXerYoLyaMjqST/auyxiqK19eipzPIr22/6g+IOTRC/GNPq5WbrqwB74B+UL6diY=
Received: from BN9PR03CA0220.namprd03.prod.outlook.com (2603:10b6:408:f8::15)
 by DS7PR12MB8251.namprd12.prod.outlook.com (2603:10b6:8:e3::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.30; Fri, 25 Jul 2025 10:30:58 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:f8:cafe::15) by BN9PR03CA0220.outlook.office365.com
 (2603:10b6:408:f8::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8964.23 via Frontend Transport; Fri,
 25 Jul 2025 10:30:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Fri, 25 Jul 2025 10:30:58 +0000
Received: from [10.136.41.253] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 25 Jul
 2025 05:30:53 -0500
Message-ID: <770f0fe1-08da-417e-9a0e-fc19d1781f51@amd.com>
Date: Fri, 25 Jul 2025 16:00:51 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] iommu/amd: Skip enabling command/event buffers for
 kdump
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
 <eeecb08fee542b36713769a16e31532537de0727.1753133022.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <eeecb08fee542b36713769a16e31532537de0727.1753133022.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|DS7PR12MB8251:EE_
X-MS-Office365-Filtering-Correlation-Id: 740fa15b-d13c-446c-da96-08ddcb66583c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aTN3NGNCY1NTUjZ1LzM0L0tSZFVBTnRVcVRtQlREYzFOTUpLakkxSUxWMXMr?=
 =?utf-8?B?b2JhSEdJYS9xNUp6NFVnbDhuY2FjbG9zL1BuSWNXTVkwREowZzBFams0QnV0?=
 =?utf-8?B?N2x4UjQ4dUNFazc2amVPOVQ0cW92QitvczdBaEtCRU5qZmUxYjNMeEpiaFI2?=
 =?utf-8?B?VU9ZMmwwb09zY0JXMWpIa2pWQXVFNEFicUxXQ050a0U0dkFLNi9FNm5LY0xL?=
 =?utf-8?B?ckVGR3YxQjI1YU5TclZGcG5aczdIRVFhY0JMVEt3ay9XUDhmd1hHa1QzUlNW?=
 =?utf-8?B?dlFrUk16WWExcVovNGFQUWh5K21OUEV5NklnWnNzcXlsSVp5MjJaeTdob3dW?=
 =?utf-8?B?M2M3STBGek9TZlhHNmRLc3FRTmx1blJaanNsUm9OMmgweVI3b002aFcvdVdu?=
 =?utf-8?B?N01JOWRtQlpjdWxPb3BVOGdvSEZma0RJbTRFa0JwQ0IvUmpyRmxHeDByM3Nu?=
 =?utf-8?B?djhCdnlWUlpwamFOQktlUnBlNWpSOTZMNzJPbGlYMFVlaVlGM01aQThKUlNL?=
 =?utf-8?B?VlN2WTBlOUFsOUpKU3dGSDhYQ3pHdFFnV2lkbG5ZZURVN1o1dGpzNHdtbVoz?=
 =?utf-8?B?WS96bEhra1BpRFNZbWdDdnFqRHo5TTBJRm4wck1TS0c1OEpoSTZERStuenZp?=
 =?utf-8?B?VFpDNWgzNCs2VUR3MDkyOHhaUkFnVHBLeGRITjVRb2M2RE0xa2pIWFcrSTdM?=
 =?utf-8?B?SmU5cUdzRWp0OVQwbi9JdWhyVjlUK2t2bk5qSEVnR1lXTUx2dy9WSk9OSDVz?=
 =?utf-8?B?QkQyUis4a3BJenR2M1UzT0dlOWJwbnNucjNuUHVLcW1lWVl3Mll2ZmJ2L2Nz?=
 =?utf-8?B?aDQreC9Qb3RQdmtHSlBvN1lFVWI4NFo1MWRhM1h2MEN0N0NtRUVXWjlFSFRP?=
 =?utf-8?B?LzloYitTR2Ftd3FBaGdhbjRBSnIrdHVwUkJOTEx1c2t0RTgwbUJkKzVBQUVW?=
 =?utf-8?B?OUxYSkpyZE01Q2lDbkFrRk40SngvbTlsQXBPdXhlc3YvRGF0V2pPc2RXcTg4?=
 =?utf-8?B?b1hwYmN2R2Y0N2Mva1pPVXJDMHU1dnVOODdtTFBCeUQ4Z0cxVmMxTjl1eU82?=
 =?utf-8?B?Mzkwa05XNDBReHIxM2NXdlhKN2M0U282OWxRODZNOXlwbkNtTHMrQkFvOHhu?=
 =?utf-8?B?cHdsZFg4WHVNZnQrU3A4TDMyTzY2SzFlYXdqVEpwNWh3TGNOazcyd2lONTg2?=
 =?utf-8?B?bm1mM3N5N3l3NFNSNFRwZGR2NjI1bk9mN0J2UUxCcjNHVTlBMHRya3M1a3pY?=
 =?utf-8?B?UUZmaHZKaWZ4U09aYUhpRnBkYXIzKzBTUE9jd1o1Z3lQSkRIRThOVVl1WTAw?=
 =?utf-8?B?UEo1ZHJTczlGcDQ4UUNGazRsYVoxdXFNNm00NjhRc3F2NHNWU3NRTkZWVE5T?=
 =?utf-8?B?NFZFbTl3V3RUNU53MGRpQmZvRmhISFoyMFVhVzUwSXJFNHhzZkZUNUcveE5U?=
 =?utf-8?B?UFF4RFZzd1ZmcllVdWJVY2xjbHlDMVlSMmdaZitacFRRWTlob21zOXJTTFlh?=
 =?utf-8?B?VVMrTmVBL2tSdDJXTHNlc1Nwb0l2RjN1SWlxMTNyUHRVOWY3eW1FNjBncjh2?=
 =?utf-8?B?bStGR3VqSy8wZ0d1MjVCOWc2YlMxWjVuVTM2WGJRdGFZelVnQW1RTHM0WVFL?=
 =?utf-8?B?c2tZVktqc1h0RFovdDRlQWcwRGxrZkxGdHNrbzFDV09ncVIrVUJibnVWcWsv?=
 =?utf-8?B?dU8vMGZkUm92Y2FQbmZ6Nk12SWxMZmNheEQ0aTN5QjdWeWtyS3hsbFNrOHNn?=
 =?utf-8?B?dm5ncXF5cDhJQXRidE5peVRTOFVMSE9VVzMrR0xlTVpqV3BvNlVyMGlkSEFK?=
 =?utf-8?B?Sis4QXNyUUFQQlFJOUpaRDZxQkxVbWRldGlYQWQ2YlQ4Ri8zazlYWmhoUGF4?=
 =?utf-8?B?OFdkNXJOMm1tMjJ0WHVmMEJqZ0YyRWVyTWVqcHhnbS9yazJLVWNGRnhTcWpw?=
 =?utf-8?B?ZGN5c2FieTN1aVgyZnFqS3ZucFpLcGNkTm9hOWd3T1ZValdZVHpqOHF2ekhP?=
 =?utf-8?B?aHpyZXZhT1VyclkwY2loajBPT2sySEFRSDhqR2tWcTNTQVQxSjEwenpwcWo5?=
 =?utf-8?Q?iWFSDW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 10:30:58.3535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 740fa15b-d13c-446c-da96-08ddcb66583c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8251



On 7/22/2025 3:23 AM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> After a panic if SNP is enabled in the previous kernel then the kdump
> kernel boots with IOMMU SNP enforcement still enabled.
> 
> IOMMU command buffers and event buffer registers remain locked and
> exclusive to the previous kernel. Attempts to enable command and event
> buffers in the kdump kernel will fail, as hardware ignores writes to
> the locked MMIO registers as per AMD IOMMU spec Section 2.12.2.1.
> 
> Skip enabling command buffers and event buffers for kdump boot as they
> are already enabled in the previous kernel.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>

