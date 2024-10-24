Return-Path: <kvm+bounces-29671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCAE9AF52F
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 00:18:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E1461F22A58
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 22:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0CD321732D;
	Thu, 24 Oct 2024 22:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="U0oN6fgU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E2122B66F
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 22:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729808317; cv=fail; b=ACzqf1dS6w2z6UlKulRiB8KmuHx/GyuT7VoZ2N3evZc+wUjd5lX6Y9r8eH2TCmW21Y+r0zDlqmtG/8ECDmZQmzeAajpdeDSucO+fJ6OswlrHBgrMAuCr7ZUYqAQvNCmOkYL6CTbbUNS5aGl/CsUk0vjdfYLHGc7rDh168QvsiFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729808317; c=relaxed/simple;
	bh=z1DhljKc6UYYZFT5tcX2MGzsM8XPdh+0ZnvW+nsu3e0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XgrU2L2WH4T/RU7192a1iNBxLTbHXsnvM+Nk6fJQ1R7rwV0t08xZI+NanBS+mViYhKVeL6UThcdNrx6k9BVRUtCGJM+EKzNUleXIyzwjeLHgqkhoyOfA/AKfp6BLqwoO1Qz+8lE2HqQWPyMSmnwp39bARiwaiDavsI/rXmiBKUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=U0oN6fgU; arc=fail smtp.client-ip=40.107.93.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tyesYlE8WA6w1VXmQiW54XqlXrDFf/geNuyC4lcR6x6K4mBv0Ej9k3ascWfIST3OPyyEdkd1uHaRboF4ye0qp59cwCdy3QOmKU+3F85Ka9VkUBwSP6vWRLq7nll8lTEOb+RRZHu8uqWUGyebPbxRgRcOVSKMWXi+ZLvQsPjGw/yiZ2ecBLX4Cs8lmLujo39tuEmDErd1oRy4DH7Do7NwyBX4nkDD+KH8hXXRCQCA4M3mBv1YAdvkUjydmjVJ88hR9EoLZH4DkJkNKW8Km5oIA8Hs/ppxftMqpRxujztWEDDHHSFyi+8a4GMZq5S2zgcJH5UDDxLP1FplNhqt9WJbxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8KlgY/CBUmuUVbXblaZl34+v6ommK/tcxDyalJB91c=;
 b=C+ucdSiIlFI2gyiBsvXzbyD62NwQEYaNEI7QYSDi1RdAuHwmXrloWFVYfq+dX8le5upPGPVvFjRFjZHQIB/ThEkEmILhGkjzlXWA/na2KoNbUPCSiNk7aWgG3B1+5Cu0T7XgIjzyBvhVEq8lsB8GXTv38uo9pOZ5WWqPxbIKWmtfUYkqwWarmATm44z1jFJkanRcJ7N4CtothLp6qwRlZ/SyNkUHptqAGgTYskOAyWWlcaGVVmgq1ucTnSlXVTZSUSSby0FsiotCRKFcz1ICySmkdeFg2ZBQes6aY1h+5+NmxzVgavM/qRIS47t+r5/yBLX1X+lzDWCEmlwb7zhiLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8KlgY/CBUmuUVbXblaZl34+v6ommK/tcxDyalJB91c=;
 b=U0oN6fgUehQ6n/GK/elT/TC8NT6EWx2gFTosqUjew5bso298MWzo23Ezp5ij/7FqImzD40AFcFMWUkQWsmoEg9t449OKhJ9v/gNlSWzKmDnx6RPa5qnuCE7641OtKifeUdtRUctkpBOWgXzZVnPUoPSlyfw1dUTZzu25I69bOWQ=
Received: from BL1PR13CA0327.namprd13.prod.outlook.com (2603:10b6:208:2c1::32)
 by PH7PR12MB7378.namprd12.prod.outlook.com (2603:10b6:510:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18; Thu, 24 Oct
 2024 22:18:31 +0000
Received: from BN2PEPF000055E0.namprd21.prod.outlook.com
 (2603:10b6:208:2c1:cafe::af) by BL1PR13CA0327.outlook.office365.com
 (2603:10b6:208:2c1::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21 via Frontend
 Transport; Thu, 24 Oct 2024 22:18:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E0.mail.protection.outlook.com (10.167.245.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.2 via Frontend Transport; Thu, 24 Oct 2024 22:18:31 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Oct
 2024 17:18:30 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 0/7] target/i386: Add support for perfmon-v2, RAS bits and EPYC-Turin CPU model
Date: Thu, 24 Oct 2024 17:18:18 -0500
Message-ID: <cover.1729807947.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E0:EE_|PH7PR12MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: 90d37421-4a2b-4d6f-8219-08dcf479cb22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R6Y5ddJdwuILIvMLaPFVu/7qxNyCysIZA8xH0C99MYbB8xolgBlwj4fy3MzO?=
 =?us-ascii?Q?O5BYdHDtSb11xQX7PnM8dSkIHEsGUuuEslC9sRR5ZnU4W3TyQ7Zm4r4OKbrq?=
 =?us-ascii?Q?D6s6Lxo3uXh7OZ3y3wU4S1MOg4DT5+W/n9uf2q98ylIQkVFZ4JSeopMiMmld?=
 =?us-ascii?Q?sfMG0n3anBfalB0dQPfYHS5/NL+3dO9iMLyv2mxDqxaSakeaZE741xEPI4iy?=
 =?us-ascii?Q?/Z4BIC6m8oFXB080x+KdCpO6AlldhHWPFyMdv3mZP2XSO9MUpaP+48VEHPZz?=
 =?us-ascii?Q?O03Rpuwl0dEZiq2f62VCCdQy2lZvGzKtdKCOPzQi1eP2da5CS6w7HPSM35ut?=
 =?us-ascii?Q?oVqA0VanGT2WG95rstLXMsTbFosgyygYJByA9/TSYqSvus2VlKmxR8C/8T2P?=
 =?us-ascii?Q?yCpFbP/sTFY2T6JrNogoOcxHTx7Kq+LezZXnt14V+qUwJq5a+NxFtOGj6bQC?=
 =?us-ascii?Q?c1lirdRyWmjT6j2ph3ySdG7OTTg2wEE+iyIHxSaCUqlPYvrRMrQdUTMFazs6?=
 =?us-ascii?Q?BvtGl9Oxir1Rz3/4gqqkhaA36hT6TogIL+TGDRyqEx/EGAziwfW6VqH8iDUS?=
 =?us-ascii?Q?SPPQpaZf5/p3gMVLR2Mg8jesSlWES213E+ViTMfIOoxeHnhfK+lZP6k/7gtq?=
 =?us-ascii?Q?XLtN3eg9ZQ+V0EJYrVDh5Y0A1Hkja5LnVl8U5My4upKzhLvo6hOnZ2pPZH3S?=
 =?us-ascii?Q?CpWaqQpNO36ctbeDeFL+Xbgni56Za4ZnzTybED1cyUkUd6DwcIj4iA8cqdZr?=
 =?us-ascii?Q?8VkI3lpc0j33owm5s3VVOs+J92SBHtX3Czmp40bHZIWCrZ3VqPtqCPsZ/4vM?=
 =?us-ascii?Q?a5+IuwFCGZP999DO/kcu1rK7lg1jGaYx91RFKUFxY8Z+BO4QZSs+Y7tDEtU8?=
 =?us-ascii?Q?Q38es42B8veHrhOyNijjUFrWS7FTrVVTSgBBAlToJCSwg9AtPlpyeXUswqGV?=
 =?us-ascii?Q?WlY7SVpJ8zrpnU7EoM5Onz7zcgzJ6mUJae4G8KKbZWbcCNpwcdTpW8sZGrWh?=
 =?us-ascii?Q?z2wt8g3jWYorjMiJ9q72fIqSLMLY2dSeTiO3HimO2q+TWWADBIiBXEfnX989?=
 =?us-ascii?Q?Y5vY8B8WSDdPEpziNha40rEqzwH5GPToIspKctm2Re3QQf2r/Zek5Rt0aS3W?=
 =?us-ascii?Q?YhZhk+j345V+DnktCQu5U0Dlsnb0XBXE8g2/S4PQ5+P3gZLaHEWj8hMF/gWL?=
 =?us-ascii?Q?NZtVO4hwA7eADwr4nFW/bvCaUhc/kviqQ586qB8fW+OXgoIrMglghtrCMiyL?=
 =?us-ascii?Q?gjCD9kiRTqyhUvduhRpCkxzvH8pGTdpSK7AU65dM3N2StRK7TSll5c/eSyQy?=
 =?us-ascii?Q?NSmjEuNRZzgk9cb9oMb5Ytf0TdSXPM7d1x/YMu4S1rTstM5BV9WNuDjEBDXA?=
 =?us-ascii?Q?5xDg+E8G/B6G9VeDJOwJ4D/lJ1mN6nxfYCzcgj97vzqiBo3GZLkFIETcyHjx?=
 =?us-ascii?Q?K9qKju3Hn2g=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 22:18:31.5399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d37421-4a2b-4d6f-8219-08dcf479cb22
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7378


This series adds the support for following features in qemu.
1. RAS feature bits (SUCCOR, McaOverflowRecov)
2. perfmon-v2
3. Update EPYC-Genoa to support perfmon-v2 and RAS bits
4. Support for bits related to SRSO (sbpb, ibpb-brtype, srso-user-kernel-no)
5. Added support for feature bits CPUID_Fn80000021_EAX/CPUID_Fn80000021_EBX
   to address CPUID enforcement requirement in Turin platforms.
6. Add support for EPYC-Turin.

Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
Link: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
---
v3: Added SBPB, IBPB_BRTYPE, SRSO_USER_KERNEL_NO, ERAPS and RAPSIZE bits
    to EPYC-Turin.

v2: Fixed couple of typos.
    Added Reviewed-by tag from Zhao.
    Rebased on top of 6d00c6f98256 ("Merge tag 'for-upstream' of https://repo.or.cz/qemu/kevin into staging")

v2: https://lore.kernel.org/kvm/cover.1723068946.git.babu.moger@amd.com/
  
v1: https://lore.kernel.org/qemu-devel/cover.1718218999.git.babu.moger@amd.com/

Babu Moger (6):
  target/i386: Fix minor typo in NO_NESTED_DATA_BP feature bit
  target/i386: Add RAS feature bits on EPYC CPU models
  target/i386: Enable perfmon-v2 and RAS feature bits on EPYC-Genoa
  target/i386: Expose bits related to SRSO vulnerability
  target/i386: Expose new feature bits in CPUID 8000_0021_EAX/EBX
  target/i386: Add support for EPYC-Turin model

Sandipan Das (1):
  target/i386: Add PerfMonV2 feature bit

 target/i386/cpu.c | 222 +++++++++++++++++++++++++++++++++++++++++++++-
 target/i386/cpu.h |  27 +++++-
 2 files changed, 242 insertions(+), 7 deletions(-)

-- 
2.34.1


