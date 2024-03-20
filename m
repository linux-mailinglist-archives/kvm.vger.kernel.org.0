Return-Path: <kvm+bounces-12246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9101B880DD2
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:52:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1FBC1C20AEF
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D93B3A28D;
	Wed, 20 Mar 2024 08:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Mm7281rM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2085.outbound.protection.outlook.com [40.107.100.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056E339FEF
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924638; cv=fail; b=Id6mt04BUivxFn/L4NecjnjRFoxZNQ/eX6C1DN/N/Jp2NJh7q6R+hhLlmeGvu7GIbGVJLqbH795sjrhuYPrGbOmQD4ce6t5YdQZs9hcGttWO2yGM/5gii7v4p3hyZDLCshfKJlbTrZz6TJlmsi+hIhgVb4DRGLd22n1V9YTYXf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924638; c=relaxed/simple;
	bh=x4emDrRrA8cQkb5mCUgydTh8NN7ngn9Cm3pic1Ex/5g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j+g6fRMfmbC2Hw+r41Hz0ZxDfHx/FJIrfVffVk4iIZdVPx/IpXtdy0JdVXQ1LtcNqcu/FsTAq9fPCWiOKqTsbk/QGUP0x/amLkb2RP2AiJCU0ljJKBmBQR76BKRDNYa+5AKhZmXheVqMi5wVjEtckbXOGZCKcOWzCy21S0Bis7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Mm7281rM; arc=fail smtp.client-ip=40.107.100.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXABgHA+P+X71X5YjMzYJs39/qkfmDvhiSCWRkSJUf0+HAksZPSWyk30bwY4uvldNIRqW7RuPL+CS0Lvn2Obncw43GqgaZZ6BhL5bav2VoC+kIRpC0SLc/25gGjWoLxh2977uLqLYGM22wFoVy7HgR0cuu4H0gcF7E3fWkIBJZ7HVZqChjYyoqK2L/tyfYx96EMAPKAwTIFCdgPuZDm35QfCs/0BVUcJ0HEcHgx1zOaBxFWoGwa0frKhqE61sIAg0d4JWa2PxdIpIzoH5gjRreHzcUtyShRvTvH5PBrM6t1tft7nwPYiluZdFL5nVS7rE2axBVH8S5zH0rlR2t7DyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/SiwnHA5evDZT3y+GXVRjpBBKLhqfvbXO3fPYwyUjQU=;
 b=CDkDTtmqa73iV8ajp9IesoVhmLy7up+7PuaF4UCrY5wwD/LlFN8ZDq8orEonFfl+9q3JA8p67H6PFwdm2Iw38BC1uXTcUqAOisHuohadwhnYibDEhIu0CPw2uFbDiBCGe+0siW1dKY9zoYxJebNspRHwd+dNYzRLcrXB3+m3lp2JSfLYzMPq8InhtjlKCBFyeyCj2VRsIDLqk6mzxrhMFV22PXLfhPAlgbdzn9hYWW0zL7yJ/tc5X9Z/fSlWuGceyhWJJhDj7DoUkL+ncG/JNcHzhoPZ/HTtWu6sqNBpbknNAhXvkyVYTX59P6Kw/cf13Dki0bg0aJIR0hXixvak8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SiwnHA5evDZT3y+GXVRjpBBKLhqfvbXO3fPYwyUjQU=;
 b=Mm7281rMQRkXP1a5OLPRwynPgKhqRAK5WmpCOZmlQ7TH9CddPWtsr/4GprnVFC1qSMfJHK3k5WIvHYwNea7+RrK+gCUd70Pn1hriODCIlnd7qs3rJDj6arWQD5ntZT/xONrq1G5K8ExKyBlxbcpy4BgUlb7hZLp7DHDO4xptL2M=
Received: from BN9PR03CA0186.namprd03.prod.outlook.com (2603:10b6:408:f9::11)
 by SN7PR12MB8436.namprd12.prod.outlook.com (2603:10b6:806:2e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Wed, 20 Mar
 2024 08:50:34 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:f9:cafe::46) by BN9PR03CA0186.outlook.office365.com
 (2603:10b6:408:f9::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:50:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:50:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:50:34 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 33/49] kvm: Make kvm_convert_memory() non-static
Date: Wed, 20 Mar 2024 03:39:29 -0500
Message-ID: <20240320083945.991426-34-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|SN7PR12MB8436:EE_
X-MS-Office365-Filtering-Correlation-Id: e1a2d5b7-f6ea-4ac9-2cee-08dc48bace7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5WOE+XT1FFh1P87IzQMY1FfMxPxzDnck2nmm28j1+W8ZOlcC3HVCnrhBLMr3MQmumzyoTmEs4lldkzBeaj7KX0AiRjGmkYcgXX3AN8QwYiykHuHEGBnFdLKffI67o0WNATo7gCJ5QyT+GrsLVMn6NBZzqVLFBrZTC6e12e32F4/D/TgGhjkAV6NW/taFX4W/TjL5ph7w3TiUYLNmkuLmCB0dtS5/fwPE94KJB1mwKYmrozgG7SAHG2n2e1S3L7MPnjrpwpBmByQFBWSgGrP9y2UM4Q5ZH0pWYmp01VT4YFI+8mshtRKEHORzdQVCtzr4Q1+bDya8JmhO6BlQ8sEc2mgPezXi3mINVBGhaf3gJYabl0tJkmMXUqpkfv5y5GFiGJyHNSi1uREmvk4DNqrjQZbBMRL0Cc26RdlbyR85v6WGcCF3xfL3XqLwDHe7E3P3kYmXyKeun5FUCugFR4Nprp3lYEDHrMXHLXtFOD2usfqjIkYeDcx9803rGIZimj54Jz/o+dnCPf4K9OSA4PCTuLQb9dDbZ+HSrdYdXi/jX4XttU78FsPSzN/HLDiuRJI0fCS62YQnsjIkEsSsDwTN0c3t4c5G5ODe7SZGGMYBqYgT8R2EWztz+bjsulNdLTh20wdo4dTQFsaoZi3E0sKbcEMxoyQ6BEJWHgbQ527XQyOdbZpse44EIFG9+0lHdMreOs7QkTONx9LnEK4w0vVmZGZJ1fvJoyySnLV4pE42ouDV0Tiubr7alIB4hm0JBjsF
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:50:34.4857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a2d5b7-f6ea-4ac9-2cee-08dc48bace7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8436

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 accel/kvm/kvm-all.c  | 2 +-
 include/sysemu/kvm.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index b5872fdc07..bf0ae0c8ad 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2913,7 +2913,7 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
 
-static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
+int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
 {
     MemoryRegionSection section;
     ram_addr_t offset;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 2cb3192509..698f1640fe 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -541,4 +541,6 @@ int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
 
 int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
 int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
+
+int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private);
 #endif
-- 
2.25.1


