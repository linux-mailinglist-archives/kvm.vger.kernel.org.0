Return-Path: <kvm+bounces-37525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D13A2B23C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 20:28:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A53273A4FC9
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 19:28:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994211A705C;
	Thu,  6 Feb 2025 19:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mUmFriZ7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B9119ABD4
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 19:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738870130; cv=fail; b=uAqnLww9ysigVmgDGiHJv09/t3hesHJjmpg8NU9/6jMwILkwMbhlxTTrVYVO4m2y9R5EmmW9gCnXogoPJmSCcjort3ybPNlN0pTnyw+0zFdFPUzFCPV4wsZCsqJM9aR9vBenEPED/gqS33s7yIib5AAQ4BV8KhglxnM5BMPnFeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738870130; c=relaxed/simple;
	bh=Uqbbqpx66WaRt6fRZcboIzgCa3ZYGvbky/x8dixK/vk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eerLcuGadguwm95/o44Fl2uQ2e5pLh7gxY8hPfBfTDO2hrheLsaIFSJ6sG84WKefUgRPnPETOnvPqQQsUx6jSj/9UWTuL7LUFuRtb+v/meSfnTvsPmNIlBL7Qi972kjh+aRVbPc9L6maoRDiMCbvJYMKgzbOcOHXvt5dJrGlo2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mUmFriZ7; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RMWNtW7j+5XxlytcmswIndVKM6jGOxlnvECp7dOUtp29U+izgkdzDqniH/uCkr6pUuHgjvR1lYF3qfqxa5QwxFz7w03V2Gc4k3U5gQgVaWhtK5/UCTuAFfEf+IP4raonoOH2wOfprt+9ZMsO/YWnAHzh46NNXdxZuwAqJXbn5Uw3kKqoESYY6PYHYFjing/6ntcjv4EYrdeGXnt4gCXUzf8svEz1G4Z63bOvKycvY9/R0m4OKKgYjZhubbNt7caaIHtkYRzvyhn18vHuTYcG4gDMAFCiGuZ33WMghqJnBz6bGSay++yCOpd2v8cdN1EboSisZbo2OIB0MhQNiGMEsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTl03S4dzjIOc24j49r7KWzJqmNMAxawXxN2EqRv3Po=;
 b=p5zFxCUrviuVLmvSIZHBbdaVWys7ailsJtXNsZkA6z6I+9C65bHYJI9jJUREDdekVPMxIOItxRxdKA5ugCrNRIp6zzGw/67kpbxo10uqSBQO6Z2cAfcxQPRA46crpqOvqbc//no+gmXJ2DPYPxdWMWNAaGf4L5Rq58Aj3HkQjdUw8Z5vuZ2ITPQWQfLrrggdOBoJnmF7+k6NCrh/N4J+o9AhdbAdyKCezP29WGgcaSU8rVLv8v2CTwr/oCJ+mQUgTvoUC4qQW+vAOcCEwfS9BLqN+0lY31enl21QXFwmbQtB8w9MxXd3/UEUQFtrqrSF2Hyx2KbpOxXRn/S8U9eRSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTl03S4dzjIOc24j49r7KWzJqmNMAxawXxN2EqRv3Po=;
 b=mUmFriZ7OHeqQhAOlkwOkz++PWPw92Wbq3mTVG/E967/XuBObXMoRpTpT3wpSosOgvwtMvLCbHTulKb3sLimqwrgfGXYCFaEEzrb8h9ophkHcKNs5RkZ2flJL1aubDJdE/s6hJQR3Q5cK3soAELBpsdFQMtGjtl77tUUWf7NfyM=
Received: from CH0PR03CA0212.namprd03.prod.outlook.com (2603:10b6:610:e7::7)
 by BY5PR12MB4115.namprd12.prod.outlook.com (2603:10b6:a03:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.10; Thu, 6 Feb
 2025 19:28:46 +0000
Received: from CH3PEPF00000017.namprd21.prod.outlook.com
 (2603:10b6:610:e7:cafe::32) by CH0PR03CA0212.outlook.office365.com
 (2603:10b6:610:e7::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.28 via Frontend Transport; Thu,
 6 Feb 2025 19:28:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000017.mail.protection.outlook.com (10.167.244.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.2 via Frontend Transport; Thu, 6 Feb 2025 19:28:46 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Feb
 2025 13:28:45 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v5 0/6] target/i386: Update EPYC CPU models for Cache property, RAS, SVM feature and add EPYC-Turin CPU model
Date: Thu, 6 Feb 2025 13:28:33 -0600
Message-ID: <cover.1738869208.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000017:EE_|BY5PR12MB4115:EE_
X-MS-Office365-Filtering-Correlation-Id: 759e4cde-2ea1-4441-a24c-08dd46e4799f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Us5IuhTLteOvXdsDvk9IKGHM2yI+QibTFiG09a1ysN7CF6O2fEAbHE96UQMJ?=
 =?us-ascii?Q?yR26opT2sVW/1hKUGH9az5MmNO90OWORap83BOaheEd3pXHpL2QbSyEuuEdu?=
 =?us-ascii?Q?Imn4BV5RZETC1gySqcLcmUQx3bsPZn+QJxOtu5RZLn2cs/4RwcVcR3TcbuiV?=
 =?us-ascii?Q?qkclhoTt7fKHq+qOgRBGPFgjiTDTqCGZIygY8acyw6KtTMIIM2IqPhh+qaJn?=
 =?us-ascii?Q?nH4cLJgRn7kQV6B8HJOIPQ7NZt3hjwHmiNfKK3PYUivAOYc6d1tCnWamZrwo?=
 =?us-ascii?Q?kEWZd9+y/BJY2uUR9ym0WYoQswj4n5psVhaw8+h/+orJBRZ6N3trW9Igq11K?=
 =?us-ascii?Q?2Lq1qO/MqjL/+jZNPUWqWMjP1lN4Eszhy7YV6HQlkbpPxG1V+23RQIwIZlQc?=
 =?us-ascii?Q?axvPk6TIc5NkaGaq4mVAHJbX+tG/gIhavJQljyL35gD3T18FMUdggyfIwMA9?=
 =?us-ascii?Q?BL+U+NNYxsNUuDlmn93QC7ubeSBMjtAIUJAjfNpdfYOdGmLZgPK29E4wMalv?=
 =?us-ascii?Q?1Khl8p+nJ6xs82kIcJ2wdNNAavcjCFxGtkcur6n7mKRQ1xvLUAFr2KjByNSr?=
 =?us-ascii?Q?8ejwTKG1qKf/dUtWa1pu1LbMDjxqT5E7NwQI7y52CGBQqStDdpNZqgPRj/gh?=
 =?us-ascii?Q?jbG7+Y9F+7B5kXAjHaheCEFOlTWOifYPTOUpW3dW5296gUq0UVZqVawfkVVX?=
 =?us-ascii?Q?QKpkWTIaU8wqNRHYBgvfj0Y4EQzj5Fnej0bgV8OHakj87cJZq5GD0GVeH/to?=
 =?us-ascii?Q?Ku1jl/vqIbJuaBVnwuCFD9IgpssTDhRYIoy3FAA2Bjb2AOZ3biHAUllJO0Zd?=
 =?us-ascii?Q?fIMRfvt3YoDLcBwpQfeXzdkXGiMkPJJjZXnLvJyvchrB/P3WJPDjH31cJB+U?=
 =?us-ascii?Q?4hWjrBCqL7U2gb9gCrJbUd5uZfoTeW4N73deLqsgxlZkTEFKfzkYp0cXPI0j?=
 =?us-ascii?Q?T2aCLTbMdC7joPBD5vusBatlkzFEEihn6ecCh4MHM3PiMBNrWsCp4mSEk21b?=
 =?us-ascii?Q?pRMg9lfV30tgIKnGB+rV67YWivvL/kAUNnC0evMY95cH2Q5QoTeHSpv3/XZR?=
 =?us-ascii?Q?hrBtErVxmjrawMI7hNXn5oPjvCCGWxHCsfkcOrN07fa6c/WCH/gEcvU8vqti?=
 =?us-ascii?Q?7xRxRQ/7txLyqcjifNX7xt6ZNA/tQSdTCPeO3ROuqJexqA/Eut9Qfj16k/Uj?=
 =?us-ascii?Q?1Z3tJszh9ayNW7f/6Q1cPTIGZLFzTpNt28zEJYIyOjQ7/OgvGOCocI/nzb/Q?=
 =?us-ascii?Q?35hwqkwLTar2zWfafWKbffth5UfXe+EP7XzkiG7c3OgUx/kb5+jYkIg5ri7Z?=
 =?us-ascii?Q?Ir4EbVunZ0zeYFK8O4CQE0vwe0aY26fK11GqOIJ/Wg5taXFPXb1cbMzw4eBp?=
 =?us-ascii?Q?UOznU6rFtdjSLW1gioqKYlQs7K+xmrKEZkH5OXa9HDVjGKJlliLZ7yqvDFvf?=
 =?us-ascii?Q?8ARunvsPRSN0TYoBLyCUqO/k0Dr2LLTx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 19:28:46.2533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 759e4cde-2ea1-4441-a24c-08dd46e4799f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000017.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4115


Following changes are implemented in this series.

1. Fixed the cache(L2,L3) property details in all the EPYC models.
2. Add RAS feature bits (SUCCOR, McaOverflowRecov) on all EPYC models
3. Add missing SVM feature bits required for nested guests on all EPYC models
4. Add the missing feature bit fs-gs-base-ns(WRMSR to {FS,GS,KERNEL_G}S_BASE is
   non-serializing). This bit is added in EPYC-Genoa and EPYC-Turin models.
5. Add RAS, SVM, fs-gs-base-ns and perfmon-v2 on EPYC-Genoa and EPYC-Turin models.
6. Add support for EPYC-Turin. 
   (Add all the above feature bits and few additional bits movdiri, movdir64b,
    avx512-vp2intersect, avx-vnni, sbpb, ibpb-brtype, srso-user-kernel-no).

Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
---
v5: Add EPYC-Turin CPU model
    Dropped ERAPS and RAPSIZE bits from EPYC-Turin models as kernel support for
    these bits are not done yet. Users can still use the options +eraps,+rapsize
    to test these featers.
    Add Reviewed-by tag from Maksim for the patches already reviewed.

v4: Some of the patches in v3 are already merged. Posting the rest of the patches.
    Dropped EPYC-Turin model for now. Will post them later.
    Added SVM feature bit as discussed in
    https://lore.kernel.org/kvm/b4b7abae-669a-4a86-81d3-d1f677a82929@redhat.com/
    Fixed the cache property details as discussed in
    https://lore.kernel.org/kvm/20230504205313.225073-8-babu.moger@amd.com/
    Thanks to Maksim and Paolo for their feedback.

v3: Added SBPB, IBPB_BRTYPE, SRSO_USER_KERNEL_NO, ERAPS and RAPSIZE bits
    to EPYC-Turin.
    Added new patch(1) to fix a minor typo.

v2: Fixed couple of typos.
    Added Reviewed-by tag from Zhao.
    Rebased on top of 6d00c6f98256 ("Merge tag 'for-upstream' of https://repo.or.cz/qemu/kevin into staging")

Previous revisions:
v4: https://lore.kernel.org/kvm/cover.1731616198.git.babu.moger@amd.com/
v3: https://lore.kernel.org/kvm/cover.1729807947.git.babu.moger@amd.com/
v2: https://lore.kernel.org/kvm/cover.1723068946.git.babu.moger@amd.com/
v1: https://lore.kernel.org/qemu-devel/cover.1718218999.git.babu.moger@amd.com/

Babu Moger (6):
  target/i386: Update EPYC CPU model for Cache property, RAS, SVM
    feature bits
  target/i386: Update EPYC-Rome CPU model for Cache property, RAS, SVM
    feature bits
  target/i386: Update EPYC-Milan CPU model for Cache property, RAS, SVM
    feature bits
  target/i386: Add feature that indicates WRMSR to BASE reg is
    non-serializing
  target/i386: Update EPYC-Genoa for Cache property, perfmon-v2, RAS and
    SVM feature bits
  target/i386: Add support for EPYC-Turin model

 target/i386/cpu.c | 437 +++++++++++++++++++++++++++++++++++++++++++++-
 target/i386/cpu.h |   2 +
 2 files changed, 438 insertions(+), 1 deletion(-)

-- 
2.34.1


