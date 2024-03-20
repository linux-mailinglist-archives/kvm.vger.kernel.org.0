Return-Path: <kvm+bounces-12226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CA4880D59
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F36A6281FD1
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46360383B5;
	Wed, 20 Mar 2024 08:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mO5aasD6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157C6747F
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924219; cv=fail; b=qAHBFxfL/UTQwUVFzCaQCBsEtJAPnJBFnuyzL3JkRAvLhIySflAd9jsfGByrVVIivKvLGPlQI6OI94tZb14zmIXnptUskN+StEnOk/X9zPvPWB7jazWXp1IeNPIJLrsNt9jw9YeKhyVMAyB7DucCKYwiCPyt9OpjDsfYvx01j5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924219; c=relaxed/simple;
	bh=vC31M/yatuQeXhRCUeo914IlXCem4W5xMaiHkvUFSUA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DloH1skiKP7OKrLqCzatBKgLBUZTnYxGoJlF+Kfq7BDeOhv0zZKaLkhLQwlkoS7TjK2aQrdr/3dGwOPVYKBjs9CCB/DBSwFlNTvBDKhKUwWCB3xaybWbZflgkezPtcPYzOuff8zQioPNIqYTImdywgDNwwEGwkOtsmxGISBTOyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mO5aasD6; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIVcXwEY6KI1YTNOVA7QpmPqov9Xe0SV6+UXp1TDSZO8n2DflpVpk3FZgH9C/q0k29xejpC3InRgdwkdq5xA5AQkbfYZj5ClQxtyZzIm3fSWZncGp/s0rghtOVVbWpZczoUuxOzq9G+w1UiRrxvcKDWLEgl8+j6aBdLfmZ3FWEK32vVdS5fIO4DesNypC1aJ1GOtOuxo5ib3QyZzqd48HQZWLBUCjvrtuXy9nv8lP3fBpAbwT96dvGo5P/gXElKm4rEf7OGWIvorm88aCSzl+nD6NsmJ4hBQqHSeuHgOKjfl+vWCivjE8UOhOCxoJQ5IXlzLV/ejTAQK5LSzKAdKww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTqtcVZjp5Czz38jYigxgL9NCDNjryBgjRqYPmRRX3g=;
 b=Qx4ebsWwJZM3c1/jFRay9haLEub0zUB0cfqVZ6NmHsMhkzLQLNTylOYnYfakvGg0IvyURvadt+hRzqGquwXPn/InHCukCffdIwx28onhlwFCK0ijL+qO65xqPOvuABT5CFMq0QNIpAhUtN1a/kwZP9FJTBDS6/Cfa+F4V65EKP07oJdOVAjepzMRLtvUIJRvySfY2pHSe2C7yGnk1vDGjUPzOECg+xonX8I8SKK5UFbnrU+lBIyXNLZ75T3B3D62/mgzU5jiHIFe2WtxqmfL8+H4qoymAwpgRRxaiidEpO2p/ls0mX+u9w6S035hhwDYXRYr1HLW2qDgRD5SZVYIfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTqtcVZjp5Czz38jYigxgL9NCDNjryBgjRqYPmRRX3g=;
 b=mO5aasD6was/9ZE+WbLpwwdf5gYSKJDY9oJNqNiy17j8e+CDOstuDLuOZtSRp8zBXhwP32LUtwqow/+BpSiRokKytCcAPHknP9Ls1Xa1eRqRB4ljOE1fr5VgMbdttA+qjYu4QC/T9nHq3aW4rmXXInJxPVIBYrOD6BPPyuGgVRU=
Received: from PR0P264CA0083.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::23)
 by SN7PR12MB7324.namprd12.prod.outlook.com (2603:10b6:806:29b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Wed, 20 Mar
 2024 08:43:36 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10a6:100:18:cafe::aa) by PR0P264CA0083.outlook.office365.com
 (2603:10a6:100:18::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:43:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:43:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:43:34 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 15/49] kvm/memory: Make memory type private by default if it has guest memfd backend
Date: Wed, 20 Mar 2024 03:39:11 -0500
Message-ID: <20240320083945.991426-16-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|SN7PR12MB7324:EE_
X-MS-Office365-Filtering-Correlation-Id: 14b6ec9d-d6af-44d8-81b2-08dc48b9d4a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	miuzvejBctE+hSNFvabJuddQsm7nnWVcz2cLwsqJeGPcvG6/geias7G1NM0sbUvxumsuJcmyh4xFxFOdEsrs9cLiqfSpn0Z7ZFDsEfOc3Fjycr8y9JBUIuS+esPOiKuhu54LhtIlZdvVJd3SKXjwaHMDKoWAHawz128lBsTab1TaT1csvqC7TOPZbcKf+isIvr+hg2zwY47dKh9js5C59lvSbu/V7l95Jc99hku8nWgtyTY7hJvTBjUgpm2E/JsMobTqfZcOm+ifhjX/GsJ/Zm8V92lxec61M6FotCmNdKk8eY5uqind45x/zn6vcI7ztTwg/Z3o9oROZLQ672MXqlzsoDzU8wiKQkBQc8Oe4TEUNVst+KsF9ZDhKUb8VkeBPhbCv158J9WY3PWl7gafBfv5Wqxk1eTSGNJf0QvnTscFdSH0l1eOODvwtTpD4J8uGRxMCaKWGv/HCR1kmFIj+8R1AMU4guBPGbHeAYDNHBQYfe7tznT7qxI5Atlv7K2H69ieYc4jvIRTZ+Rk/Nubl3xG80gkPS3FuaLpqUtqo3xzaniYJf/84vA3oD1kjfGLxP7dcY9TlN+JwkxTujYh8bz8h4cKSewHXnRrq4k7K+7GFya97m8RJtvquJ/Jnx8jiNPGqJiWeJb2N9nHfL0I73qoKXETsWi++7dFzhyZ0W2n0jPu/D9fCRuLVWEtJRqXfBm59SxWw3cXMXULj3ba5yjfQCWEFzxPpupwZDA3hMnkzy+0vXD5DUFDBwg9FHE9
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:43:35.2581
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b6ec9d-d6af-44d8-81b2-08dc48b9d4a0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7324

From: Xiaoyao Li <xiaoyao.li@intel.com>

KVM side leaves the memory to shared by default, while may incur the
overhead of paging conversion on the first visit of each page. Because
the expectation is that page is likely to private for the VMs that
require private memory (has guest memfd).

Explicitly set the memory to private when memory region has valid
guest memfd backend.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 accel/kvm/kvm-all.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9a8b365a69..53ce4f091e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1451,6 +1451,16 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml,
                     strerror(-err));
             abort();
         }
+
+        if (memory_region_has_guest_memfd(mr)) {
+            err = kvm_set_memory_attributes_private(start_addr, slot_size);
+            if (err) {
+                error_report("%s: failed to set memory attribute private: %s\n",
+                             __func__, strerror(-err));
+                exit(1);
+            }
+        }
+
         start_addr += slot_size;
         ram_start_offset += slot_size;
         ram += slot_size;
-- 
2.25.1


