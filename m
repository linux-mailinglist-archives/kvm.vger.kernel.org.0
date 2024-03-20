Return-Path: <kvm+bounces-12269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3D8880E29
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 10:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA2B91C22E4D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A31D838DED;
	Wed, 20 Mar 2024 08:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jIMOAdsV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517CA11720
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710925100; cv=fail; b=ltuVjx6h7b+ocVfYwUKFIARFb7ll3Iyaq1aElkpDlSNZeeFOXe7Zrd2M86CBP8j8lWS3ZVk2AClin9f2Qimn1mwHl3TioLPOZP6w9wRIk/4auzPiwrzhWdWDQKiLuhN/0CjPjEnM+uMLZLrsvUMDiBZVPyA3nvS6Eb4iW9Fke7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710925100; c=relaxed/simple;
	bh=dMrJwPUQb8Ia6khauH6BUakxNziFFkA2ncHLW61YFSE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pk/n17bEqxGcrUHR9Et47DFmxMkuTLEmf5+5JpZ7tEUvt2/wAtmfmpCwSLpLJ6qo838sz3K7OOnPcsI8bbc2OV5EWcI2GyimzqPW/TR1jyTnkfkq0lzzh0oaTChK7SiWQ9LomgBBr0d2YxLsf90lFeTr0Cmlu2YqRH+1lGPjAA8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jIMOAdsV; arc=fail smtp.client-ip=40.107.223.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOVzZhCMNdeJv0l6pEQ5HT+YrrQt+ngfptQPPXtW78G0lJKO4SW9Z82nb22i/zZTtfesjvFUelYSN+WFvLMcDvsnifZafJuzGlmaxUEgc0iRxK55BLIbIIIgDUGOC1ibdOlobt4BeCfFefqcj6dl6nTIiu8ENWn2vbDQD3+IKYzIjM8mFjdwAfGNjaQlSS8QwM0WBtkttaFanQpy5Kwv13lQDVnTPFUwdF2nL/3cOhjKdno774P6vfFO3rXUBuvlhxoAkXcH/chMUm4JmD6tD93+5cfieKnVuXg0/JvGlRnMhUoSRT1WSSjGtwUYKQMdMVwE74yrw3w3mNo4ijlC8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XyC8UNRWo9Trf6WIFCzcD+w1cyVM/VMsHML0mDc3vZE=;
 b=Vcj5/GAbNG9/spm1f6PaMoUcNh9M2eu4ZFdI42BS7kmW4yeDDnrExAjb8rH/cGo7WeEx0hwEW09hnNEYqEWFuIlK9RX9MmNEUawKap9t/6memgz8QJHvsRfziJ5J2xDvekV6VWzU+SEeZDXWmiAj/pvF1A7InQmkyfzSMTYZZYfjjtlSspCiCxJwEWT30WPpP+/KDJcWW11UkdJCXdA6qK6QWfdfpCiIKBnDVSPEjJol1b1VZebt0AmudaCS41s2x1GY2yajHggNZc/rAVD0IPerBkyeSBhXiRplv0jxPEJsP++l3shm1J0jsG1PnYLsphQ0WwVIZMi9YZq8zusUZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XyC8UNRWo9Trf6WIFCzcD+w1cyVM/VMsHML0mDc3vZE=;
 b=jIMOAdsVI8Ztn/92VAC9+ZY6X3gZtbR+D2PoZMV3eQ31pHIfUE59PBmRKvx7Nfe7ojv34IL0n5jAj9yB3KiVijehKf4WjReIowaJcHB5f2imkMTwBZJfrdClqcky09mlFPbTzK2/QKWXE7TOrtVlH4Xj4n/WwBLGae2/1AxUj3I=
Received: from SJ0PR05CA0129.namprd05.prod.outlook.com (2603:10b6:a03:33d::14)
 by MW5PR12MB5682.namprd12.prod.outlook.com (2603:10b6:303:19f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Wed, 20 Mar
 2024 08:58:17 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::ce) by SJ0PR05CA0129.outlook.office365.com
 (2603:10b6:a03:33d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11 via Frontend
 Transport; Wed, 20 Mar 2024 08:58:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:58:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:58:15 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 08/49] trace/kvm: Split address space and slot id in trace_kvm_set_user_memory()
Date: Wed, 20 Mar 2024 03:39:04 -0500
Message-ID: <20240320083945.991426-9-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|MW5PR12MB5682:EE_
X-MS-Office365-Filtering-Correlation-Id: ed068838-dda3-4314-7c12-08dc48bbe21f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	00BFDDhe18etKv++dIwucK3RJ7IgpfftOz8ksSG5S4Oija4AFX0MycCrqt1aEaN0D9pa2rxCCemvSQK62kzWVPE5H/WDxx+SpT9ucx2tSbD9S3LsrRtn7oz+BlfuPPBpbEu3usxjEJLFgKWGBLpqYqDHg43R3Ccx9zT031SmuVx8QRBZzR8SuaEaUeu9G3g1QrRD71wn4snco5ME/TUOb2HopheIR5do2TUAWUgeVrLkmXm9/ibmToZd2695nl978uQ1pwJltVW6Qpx2sI38JQf9tgaYTmveFLIw/18Bzl4CLQGcdqrP0oDT5kQPI4WCx0g+eTf48wkMDwkxeambNZ5iyukdkwLcFnmrWdFYqOxt2f9XbTrPbb0y9YUE6KXbpr+U134L540T3pYbnxWBCiX9t7oSdG8csiVd0/GQiyNwp2Bj/7ncd+dW9chy4imWvXI8UjAX9+pnLsLyh1mLWEdG0JXIr6Neinqd1kcLs3TxJ0b59b+XbyogakD08L12TcfYl3fcDB51KM/Rdcdz9XdTS/AnYUZXbFgzgdCJ30dUL7StdVoQJfSfqWIiglGqxdMxq1E27OBskkFghCHLnGBSiWeoQQ1kgdGcz0qyu9Z+unGyP5YbVHK4h3UvDOxv/8WMJlHSTghEks+qk5TynlSRQia03OXnPzXWdh1IYKmRa+4NJXrvcJQp/EeKF+zPwaociMNteC9Cu4IquHyBY3A+So1wuwYcJ6aig491lPmWfWMa3cqmtSU0q7VdfeZH
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:58:16.3941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed068838-dda3-4314-7c12-08dc48bbe21f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5682

From: Xiaoyao Li <xiaoyao.li@intel.com>

The upper 16 bits of kvm_userspace_memory_region::slot are
address space id. Parse it separately in trace_kvm_set_user_memory().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 accel/kvm/kvm-all.c    | 5 +++--
 accel/kvm/trace-events | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 132ab65df5..d2856dd736 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -304,8 +304,9 @@ static int kvm_set_user_memory_region(KVMMemoryListener *kml, KVMSlot *slot, boo
     ret = kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, &mem);
     slot->old_flags = mem.flags;
 err:
-    trace_kvm_set_user_memory(mem.slot, mem.flags, mem.guest_phys_addr,
-                              mem.memory_size, mem.userspace_addr, ret);
+    trace_kvm_set_user_memory(mem.slot >> 16, (uint16_t)mem.slot, mem.flags,
+                              mem.guest_phys_addr, mem.memory_size,
+                              mem.userspace_addr, ret);
     if (ret < 0) {
         error_report("%s: KVM_SET_USER_MEMORY_REGION failed, slot=%d,"
                      " start=0x%" PRIx64 ", size=0x%" PRIx64 ": %s",
diff --git a/accel/kvm/trace-events b/accel/kvm/trace-events
index a25902597b..9f599abc17 100644
--- a/accel/kvm/trace-events
+++ b/accel/kvm/trace-events
@@ -15,7 +15,7 @@ kvm_irqchip_update_msi_route(int virq) "Updating MSI route virq=%d"
 kvm_irqchip_release_virq(int virq) "virq %d"
 kvm_set_ioeventfd_mmio(int fd, uint64_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%" PRIx64 " val=0x%x assign: %d size: %d match: %d"
 kvm_set_ioeventfd_pio(int fd, uint16_t addr, uint32_t val, bool assign, uint32_t size, bool datamatch) "fd: %d @0x%x val=0x%x assign: %d size: %d match: %d"
-kvm_set_user_memory(uint32_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, int ret) "Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " ret=%d"
+kvm_set_user_memory(uint16_t as, uint16_t slot, uint32_t flags, uint64_t guest_phys_addr, uint64_t memory_size, uint64_t userspace_addr, int ret) "AddrSpace#%d Slot#%d flags=0x%x gpa=0x%"PRIx64 " size=0x%"PRIx64 " ua=0x%"PRIx64 " ret=%d"
 kvm_clear_dirty_log(uint32_t slot, uint64_t start, uint32_t size) "slot#%"PRId32" start 0x%"PRIx64" size 0x%"PRIx32
 kvm_resample_fd_notify(int gsi) "gsi %d"
 kvm_dirty_ring_full(int id) "vcpu %d"
-- 
2.25.1


