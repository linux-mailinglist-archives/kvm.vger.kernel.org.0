Return-Path: <kvm+bounces-48736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC97DAD1D15
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 14:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F9D6188BB0D
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 12:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F2E92561B9;
	Mon,  9 Jun 2025 12:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FfqKaodg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6665F7FD;
	Mon,  9 Jun 2025 12:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749471676; cv=fail; b=bxN98qGlI47DY2iDUsdzQK5dMpLd+puJjewiW1e/3Zj+GLkJQVYt22dc5VXqTKdUqQEZol4+ZndGQJmW0N3wXJPwxglX5FmGRaCr46prHWtqxQ6JRqiO+yk25gkNv8eYl7SXCxDYbNhpfECltdRm1LvG6R0XBarWw28nbaz72GM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749471676; c=relaxed/simple;
	bh=AvkYcloWMSnNO+GXlJeZASS8aPlGiVr/y/GLqswHrBg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tDZtIX3ib+9YCxOdaSqD6RpN9vLHEXTba5BcqyPedagFquBYrwBOeO3pHfWFlqW7/QtDfvlI6Dw0PxIHN+w8sFPGaK0ELC0nTcb/E/70b7gHfoMNu4WEBUktkxwrxhbhCJSVeGvD256DSFrCv4djgMSW40XComDSTj1R64pCL6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FfqKaodg; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=beI1RJocirv/hfuKOlpVTQFTKX8ieyIRnSRna4Hz9MpvJAJ/W9ivSeKWxLjTZckAYLyQ5TTw3U67mU215yARF0sQkN8PIaAd8Crwnw1YoaYnV5ualH5PJAgcErcSxTADg9Qyv5Loo1bLe6ipv7L5pO97eIt9/ZIcErvN4KZvZdD/Yt6As1uOes7pcy7sNtvnDiSX6k1S+iu2T7/WXthXR13DMtDTcyn8oVhMo7Lsp8v1ah56BVelbGW/GHKtXmLJmc0Zt5IRdq98YluFB865uMJ7LVfIPYv8QcHf2rYJZ2gz8Awz8NSZbmnzQkr3CV9TtcT6VlNK1jU4ndOsY+iBxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7z1iDID1a6Qs4yJ3gZd6GcK43HtJ7WanN8DBoFodzkM=;
 b=KFzxg8nLnW+k2cI8F5wrmEWysy7KH2MNuEqb0yTJI74w9YTbbrd6IE3KJyAfcx1n0Cb1wXTj1hd72GlsnVxnJTVYjfuoM1btoSXS7TMF8r0QzJimGwtZ1jxHlSaqs1BPATxR0ERxbO8xoteKobReEDuCc6Nz33JuGqgPZKJwdWGCBNJzVv6n6qQcstSuaBAzpD3Y1qHZxnbU5V4q5MwuOeDypMUOVk4IR6QZ4gouizGbLOtjMAEvc3ENCEK/CFUVJWdhRneZRDtHTJc9+P/EPYfRAZfVzdFB/RaidFbpUga8R32nTdrHFEHawt2qyd7BVQLH1buN4y4AIE+p6aRYgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7z1iDID1a6Qs4yJ3gZd6GcK43HtJ7WanN8DBoFodzkM=;
 b=FfqKaodg4ryrq4RD58J8Kzw0rBB+UbXd1CTFbp/97rt5XV68vJeVYNDXaRMCFzvKQqwSPlIOu67dNfQD9QmSEaa5Fp9s1o3NFCpdR1/9tqddHAra8Dlo6x5Aa29WTArUdcKqKlj6fBlln7Yzf/S6IG0jkNmnJTnT/XjKYxkovUw=
Received: from BY5PR03CA0012.namprd03.prod.outlook.com (2603:10b6:a03:1e0::22)
 by DS0PR12MB8219.namprd12.prod.outlook.com (2603:10b6:8:de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.38; Mon, 9 Jun
 2025 12:21:13 +0000
Received: from MWH0EPF000971E4.namprd02.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::aa) by BY5PR03CA0012.outlook.office365.com
 (2603:10b6:a03:1e0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.32 via Frontend Transport; Mon,
 9 Jun 2025 12:21:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000971E4.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 12:21:12 +0000
Received: from BLR-L1-SARUNKOD.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 9 Jun
 2025 07:21:07 -0500
From: Sairaj Kodilkar <sarunkod@amd.com>
To: <seanjc@google.com>
CC: <baolu.lu@linux.intel.com>, <dmatlack@google.com>, <dwmw2@infradead.org>,
	<francescolavra.fl@gmail.com>, <iommu@lists.linux.dev>,
	<joao.m.martins@oracle.com>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <mlevitsk@redhat.com>, <pbonzini@redhat.com>,
	<sarunkod@amd.com>, <vasant.hegde@amd.com>
Subject: Re:[PATCH v2 00/59] KVM: iommu: Overhaul device posted IRQs support
Date: Mon, 9 Jun 2025 17:50:50 +0530
Message-ID: <20250609122050.28499-1-sarunkod@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
References: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E4:EE_|DS0PR12MB8219:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f93b16f-abe3-4415-5971-08dda7501f6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PyTcCbqcjwIhyEVMoDa48GkO9JnuH9pRvl1Rzthd523UNkObXy1TNignEd7T?=
 =?us-ascii?Q?DFzfrsQ1BIXVYpTBTW74kVZfJiq1URggin0mKk++Gab4W7WzE/NYoPdKDMbT?=
 =?us-ascii?Q?pp9F3dnj16tFzGtX3d0efC2IXPANk7PI7gclYImiJD30D9Y6si7X81hO+9h6?=
 =?us-ascii?Q?43Z9mQsPQaKe4+RjUPKR1Iiwt5qn09Kfm29N0Z35NBti4UdlsbPU09pqNZ5E?=
 =?us-ascii?Q?ROIFP+eftGO7J1RKwMe4JhukCYXj5N4YtLRFHfcsVVDLATIanJG09CqOz+He?=
 =?us-ascii?Q?OufQBSXck9J6JBTrC0IikMfAfAsQDvDlYaBpqdUmjrC/ni6K5NDSb8i8uYEh?=
 =?us-ascii?Q?lmpqw5mauX7Eo8ynyu5zdd0tCiQ7dW4AaEvN66huMTBj8wIYE5QKY65SZMVE?=
 =?us-ascii?Q?ojoI9RFuRA/KdA6bPTyPlQ7ymsKL+FJfa5oArQT3vBm9OxDj237A/J6aj1HU?=
 =?us-ascii?Q?LuQX35SmUamF5RyeI5Y2RrBxlObLEnLcU1PVcYbt49ZluDvfpS65Ek0MIWvC?=
 =?us-ascii?Q?zV4iW0PeIYLZUrcOJYyBDaqpt8POpFwFGUljNxkZBc9ptZ06C60Tmapq8KQE?=
 =?us-ascii?Q?Iy8oWb1Y+ywbNqux3qqkEptN7MqlRauEoSMhOIUNUCdKIJh0rocFlBpUdZ03?=
 =?us-ascii?Q?BYHu662pHekdU/RZQFV/HjHQhjw1uPhwHZ4EfBq+oVRXIcxRx2O7Nwir2eag?=
 =?us-ascii?Q?D+NkZjaCnI/0Kh60tKtxmaGJZgF3fbeGhkho63bsWep0UFKDAAoWjOy3wi4Z?=
 =?us-ascii?Q?N/uUDTbiNsSF0oyRcS5O/BmwbVuSNIAoA+/eU7ELjEbD91J+YoPrxS1T1B/S?=
 =?us-ascii?Q?qRC5jLNMd//vRDy3mIS7KQ6ayzU1vKMKd9lgdYgnZNiGPcl65FCG4GJVfuUg?=
 =?us-ascii?Q?NGa9bLuFdy+GodSMN24raIM5JcuGdacke6YtuyOJ4tYteP+eiLyC7Jm+1K9U?=
 =?us-ascii?Q?h5sGOe1NU0rgK5PXyvBZN6ZW9C0bAG9BMQIOeGvk1QRapr794eNAcYJzncfi?=
 =?us-ascii?Q?zBD0RJ8bBG8ncLxMBZJxAtemqINNVy4msuGJYRRM0Ai695RzgmQkalGgJ3Z3?=
 =?us-ascii?Q?0jXkHID3MZKhSe1+7aZGLfDy6TdVJBBP8Bn0Ys1MQTkjaiE6EHZGV0jToEAB?=
 =?us-ascii?Q?Ab8yMSgXwDlF1R6kF66sunbkIIhybmeTKHOTnpir5n9bQmiAlugwEQ/FZ8lJ?=
 =?us-ascii?Q?9U7L5hFe0aQwNK6YZkrimUvtwgPWieluNqXnFzICd5SdKbgiHPui89QCxxcC?=
 =?us-ascii?Q?hLeietiSfIxoFYWSPziCHJwPG7PSop/4p2YuGTzC5LAB6mrakUydAGyYkJHp?=
 =?us-ascii?Q?S8P5qmeEu0DUE3qeoIj7WuvWf97c++lWFEjHt/GbewCq4lqyIJ9tVqYifpNP?=
 =?us-ascii?Q?bQ32eHnCAoBtRyyatFPX5ky8VKLPiGt0cFdNEaFoUQdeCEtvwU5ecMy5XKqn?=
 =?us-ascii?Q?P+o0WW08d0HKE3KGHr92NZxOBtBBL3iwML0uXw4FTHfmnaAgk97/NHN+Vq1r?=
 =?us-ascii?Q?wPYHHrXmA5O+FDhBawm7ED8g346UUZ3z1cDY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 12:21:12.1372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f93b16f-abe3-4415-5971-08dda7501f6b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8219

Hi Sean,

Sorry for the delay in testing. All sanity tests are OK. I reran the performance 
test on the V2 and noticed that V2 has significantly more GALOG entries than V1
for all three cases. I also noticed that the Guest Nvme interrupt rate has
dropped for the 192 VCPUS.

I haven't figured out what is causing this. I will continue my investigation
further.

                          VCPUS = 32, Jobs per NVME = 8
==============================================================================================
                                         V2                         V1          Percent change
----------------------------------------------------------------------------------------------
Guest Nvme interrupts               124,260,796                 124,559,110             -0.20%
IOPS (in kilo)                            4,790                       4,796             -0.01%
GALOG entries                              8117                         169              4702%
----------------------------------------------------------------------------------------------


                          VCPUS = 64, Jobs per NVME = 16
==============================================================================================
                                         V2                         V1          Percent change
----------------------------------------------------------------------------------------------
Guest Nvme interrupts              102,394,358                   99,800,056             2.00% 
IOPS (in kilo)                           4,796                        4,798            -0.04% 
GALOG entries                           19,057                       11,923            59.83%
----------------------------------------------------------------------------------------------


                         VCPUS = 192, Jobs per NVME = 48
==============================================================================================
                                         V2                         V1          Percent change
----------------------------------------------------------------------------------------------
Guest Nvme interrupts               68,363,232                  78,066,512             -12.42%
IOPS (in kilo)                           4,751                       4,749              -0.04%
GALOG entries                           62,768                      56,215              11.66%
----------------------------------------------------------------------------------------------

Thanks
Sairaj

