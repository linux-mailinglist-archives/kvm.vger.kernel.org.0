Return-Path: <kvm+bounces-12265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A6E1880E08
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:57:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEFAF2846E3
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F21383B5;
	Wed, 20 Mar 2024 08:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FSTxg1KV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E23638F82
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710925020; cv=fail; b=gETGh0l/tIObsiBdrnZ7dTK9z4S1yVBGLfPf4iRWMaWie9XBbp2+pR0uo4lxwEzLxyzONbteSYq3L/63BgvBKvmzpXn5ln0R/k57jpZxniapqi3wlchTQeTga6GsqQz7x2VYPZy8A+noq2tP5nckhJvbe6eld1JM4rzpjLQ/2nY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710925020; c=relaxed/simple;
	bh=t1+PSIHP5e/2fCb88+ZJx1C0vmwCO7pgbrCG4TX5KtQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OGrGaPnsHXWnSlgQx63H06oCKHhJ1yz3Eh8VBi8u8cjKyCs5Scw132R633YE9+8JxB1lyhB8JXsuUo/1uX2g97BoQs6YgzUJYQUE3hmdatubFmlbg134LYElbp92vaRXek39F1ZCYobo2CuLbj+0ozsHQOkd1bKC9iEdCpFp/b8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FSTxg1KV; arc=fail smtp.client-ip=40.107.223.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnxhpxtIWIhzonTXp2uHXUQo7tzviplZZxBYTylYbW7z9n2RKdBdyQcRwgGP/MP6MKqzfBxSAQqWoPiTVbq3Cg358w4q4KDWx1xRF3BejfcWFzC8Sn5TEajHUjmKhmmdGEMuWvqlroOeKqDC+y3qYQo4sjCecWjuBdayrrYacnpQIGqiRgW1EuAKwDrf3Tc93D7n2BM7CPYIGvC+ZhT6k42x8ZUIyvDOAI319ioA9BsZX6DfQimZSaL6PNA9fHje125lAJVna9WRWDZEtej+sPMhtkCDWjj50YmTEOXsNAjeL5+Fd8MDMnRYeX5dTxqAlY8UaDonBrQPF9rXG8Opzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/B5elOnbVpvwQHGxxBOGT20cWiVHAeQi4ai/PJUx8KY=;
 b=Wv+uEkUdsAOmkyKE8yIRz6qzqYUzeCxv2nfK2lLwHa3qlX8AODuyI2Cn2lYNFGXwjUt6eUzcPZpJEysH2FvoGZRKQTY6F2SjTGTwKIgmgQCc5V9XSGx+wDl6psg68Cuy3F3lB1lfvYDlb0Oq718FkM8q9mRvuBhw983Ga7Dh1yHqbQjW1qdW6SOMTSHrdlwA810l9ZaOp2mIUs/GNrbWnViOvR/xMNKbER2t5LJYnYiKc1skkNQapGInENTToklAsUyXAxV9M5PxSy+u8tKinDGAYcRdgVGguC6WKuAsVz7V09hDxE/Rd6n0M2lCyfxaK5YHg/x0m3HSLCynFC9bjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/B5elOnbVpvwQHGxxBOGT20cWiVHAeQi4ai/PJUx8KY=;
 b=FSTxg1KVClOLC9sPeJNfQT4rlJAaFH+sCHh3iTDdniZXJCFs8mrG21gxGvGyasld6dUz3kejebWD+heT0gVNVUHp2HJh2SBrupBHkKxNzK9glfvqCkAujO+ILTAPLnoEpO6qXj9EIXEkWr2WqeCVBM9/CFWY49mNvKu15TOKZcA=
Received: from SJ0PR05CA0130.namprd05.prod.outlook.com (2603:10b6:a03:33d::15)
 by CH3PR12MB8912.namprd12.prod.outlook.com (2603:10b6:610:169::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 08:56:53 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::55) by SJ0PR05CA0130.outlook.office365.com
 (2603:10b6:a03:33d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11 via Frontend
 Transport; Wed, 20 Mar 2024 08:56:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:56:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:56:51 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 04/49] [HACK] linux-headers: Update headers for 6.8 + kvm-coco-queue + SNP
Date: Wed, 20 Mar 2024 03:39:00 -0500
Message-ID: <20240320083945.991426-5-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|CH3PR12MB8912:EE_
X-MS-Office365-Filtering-Correlation-Id: 964e2a3e-8361-41c9-a36b-08dc48bbb004
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6hv0+iBsXSZbBAVVjUd8gN5s+LgZID5exlBk4KMcEonuO3iyfvpNcx8M+RIY6mpezkOJctwkFf2j1SFilJfibBDmw8DAi6V+IscnhyHhOHxsGDhRUf+WnXab4TSrKX3XMHQfsl+O/XFuee58kN0aIZq0OFMdDz3uh4yWSsuWNsV/Z8HoChBlqfmE0w2oMBt5R4cuECbjuhEhz82oFJBXy1hmEh7JupLN7BJGN7rw0uStThR+JoyLz12Kyq1C7EgNzhXLG+71dR7ktnL0aWxVPBf15WET2GZuxsMwEWpDQJU48MFhCpK1DF6UgXFIlzXYoqRiqhrkXNzssBlNVFdRcdQG9deSlIpWlvKS6ZDxmLdxXoVpI2hiZ4sZxfKPj1FXG7zFjPGc2ilG67DEPboq5iRWb/uMs2ExQulBuutNv7udE0+utyZwe0tHLz2DKfajQH8ns+iOOP1Qen4t7B5v3jjln9yLB4a86TyI78VXkr+5uReAusnBRxVcXJBEa4VtcuskdXH0TPKVWfQaXktWiNvqOs2L2YWKy0toBbgny9uGiwb8N4chowBooZthOcqBk8h79LhDU7Xcn/5bZgG973PQBr6bpgqODT/riS34S+frojacPp57xUejl+/F/PhwGlZOe5516xpJMSuRtuaDP8wM434cRdCQ3nP5sOXlH7+y+lGbSLTfDH8LSK0BU4OJBUwRN3IK0Q/Q/ayENuKCDBhPL1mC2HJPWobIu9kO1eLrCaG5Pp2iuwQFr6hJmmzy
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:56:52.7383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 964e2a3e-8361-41c9-a36b-08dc48bbb004
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8912

Pull in 6.8 kvm-next + kvm-coco-queue + SNP headers.

Be careful to omit removing the following virtio_pci.h definitions which
are no longer present upstream, since QEMU still relies on them:

  #define LM_LOGGING_CTRL                 0
  #define LM_BASE_ADDR_LOW                4
  #define LM_BASE_ADDR_HIGH               8
  #define LM_END_ADDR_LOW                 12
  #define LM_END_ADDR_HIGH                16
  #define LM_VRING_STATE_OFFSET           0x20

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/standard-headers/asm-x86/bootparam.h  |  17 +-
 include/standard-headers/asm-x86/kvm_para.h   |   3 +-
 include/standard-headers/linux/ethtool.h      |  48 ++
 include/standard-headers/linux/fuse.h         |  39 +-
 .../linux/input-event-codes.h                 |   1 +
 include/standard-headers/linux/virtio_gpu.h   |   2 +
 include/standard-headers/linux/virtio_snd.h   | 154 ++++
 linux-headers/asm-arm64/kvm.h                 |  15 +-
 linux-headers/asm-arm64/sve_context.h         |  11 +
 linux-headers/asm-generic/bitsperlong.h       |   4 +
 linux-headers/asm-loongarch/kvm.h             |   2 -
 linux-headers/asm-mips/kvm.h                  |   2 -
 linux-headers/asm-powerpc/kvm.h               |  45 +-
 linux-headers/asm-riscv/kvm.h                 |   3 +-
 linux-headers/asm-s390/kvm.h                  | 315 +++++++-
 linux-headers/asm-x86/kvm.h                   | 364 ++++++++-
 linux-headers/asm-x86/setup_data.h            |  83 ++
 linux-headers/linux/bits.h                    |  15 +
 linux-headers/linux/kvm.h                     | 717 +-----------------
 linux-headers/linux/psp-sev.h                 |  71 ++
 20 files changed, 1186 insertions(+), 725 deletions(-)
 create mode 100644 linux-headers/asm-x86/setup_data.h
 create mode 100644 linux-headers/linux/bits.h

diff --git a/include/standard-headers/asm-x86/bootparam.h b/include/standard-headers/asm-x86/bootparam.h
index 0b06d2bff1..62e4cd5390 100644
--- a/include/standard-headers/asm-x86/bootparam.h
+++ b/include/standard-headers/asm-x86/bootparam.h
@@ -2,21 +2,7 @@
 #ifndef _ASM_X86_BOOTPARAM_H
 #define _ASM_X86_BOOTPARAM_H
 
-/* setup_data/setup_indirect types */
-#define SETUP_NONE			0
-#define SETUP_E820_EXT			1
-#define SETUP_DTB			2
-#define SETUP_PCI			3
-#define SETUP_EFI			4
-#define SETUP_APPLE_PROPERTIES		5
-#define SETUP_JAILHOUSE			6
-#define SETUP_CC_BLOB			7
-#define SETUP_IMA			8
-#define SETUP_RNG_SEED			9
-#define SETUP_ENUM_MAX			SETUP_RNG_SEED
-
-#define SETUP_INDIRECT			(1<<31)
-#define SETUP_TYPE_MAX			(SETUP_ENUM_MAX | SETUP_INDIRECT)
+#include <asm/setup_data.h>
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
@@ -38,6 +24,7 @@
 #define XLF_EFI_KEXEC			(1<<4)
 #define XLF_5LEVEL			(1<<5)
 #define XLF_5LEVEL_ENABLED		(1<<6)
+#define XLF_MEM_ENCRYPTION		(1<<7)
 
 
 #endif /* _ASM_X86_BOOTPARAM_H */
diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard-headers/asm-x86/kvm_para.h
index f0235e58a1..9a011d20f0 100644
--- a/include/standard-headers/asm-x86/kvm_para.h
+++ b/include/standard-headers/asm-x86/kvm_para.h
@@ -92,7 +92,7 @@ struct kvm_clock_pairing {
 #define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
 
 /* MSR_KVM_ASYNC_PF_INT */
-#define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
+#define KVM_ASYNC_PF_VEC_MASK			__GENMASK(7, 0)
 
 /* MSR_KVM_MIGRATION_CONTROL */
 #define KVM_MIGRATION_READY		(1 << 0)
@@ -142,7 +142,6 @@ struct kvm_vcpu_pv_apf_data {
 	uint32_t token;
 
 	uint8_t pad[56];
-	uint32_t enabled;
 };
 
 #define KVM_PV_EOI_BIT 0
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index dfb54eff6f..01503784d2 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -2023,6 +2023,53 @@ static inline int ethtool_validate_duplex(uint8_t duplex)
 #define	IPV4_FLOW	0x10	/* hash only */
 #define	IPV6_FLOW	0x11	/* hash only */
 #define	ETHER_FLOW	0x12	/* spec only (ether_spec) */
+
+/* Used for GTP-U IPv4 and IPv6.
+ * The format of GTP packets only includes
+ * elements such as TEID and GTP version.
+ * It is primarily intended for data communication of the UE.
+ */
+#define GTPU_V4_FLOW 0x13	/* hash only */
+#define GTPU_V6_FLOW 0x14	/* hash only */
+
+/* Use for GTP-C IPv4 and v6.
+ * The format of these GTP packets does not include TEID.
+ * Primarily expected to be used for communication
+ * to create sessions for UE data communication,
+ * commonly referred to as CSR (Create Session Request).
+ */
+#define GTPC_V4_FLOW 0x15	/* hash only */
+#define GTPC_V6_FLOW 0x16	/* hash only */
+
+/* Use for GTP-C IPv4 and v6.
+ * Unlike GTPC_V4_FLOW, the format of these GTP packets includes TEID.
+ * After session creation, it becomes this packet.
+ * This is mainly used for requests to realize UE handover.
+ */
+#define GTPC_TEID_V4_FLOW 0x17	/* hash only */
+#define GTPC_TEID_V6_FLOW 0x18	/* hash only */
+
+/* Use for GTP-U and extended headers for the PSC (PDU Session Container).
+ * The format of these GTP packets includes TEID and QFI.
+ * In 5G communication using UPF (User Plane Function),
+ * data communication with this extended header is performed.
+ */
+#define GTPU_EH_V4_FLOW 0x19	/* hash only */
+#define GTPU_EH_V6_FLOW 0x1a	/* hash only */
+
+/* Use for GTP-U IPv4 and v6 PSC (PDU Session Container) extended headers.
+ * This differs from GTPU_EH_V(4|6)_FLOW in that it is distinguished by
+ * UL/DL included in the PSC.
+ * There are differences in the data included based on Downlink/Uplink,
+ * and can be used to distinguish packets.
+ * The functions described so far are useful when you want to
+ * handle communication from the mobile network in UPF, PGW, etc.
+ */
+#define GTPU_UL_V4_FLOW 0x1b	/* hash only */
+#define GTPU_UL_V6_FLOW 0x1c	/* hash only */
+#define GTPU_DL_V4_FLOW 0x1d	/* hash only */
+#define GTPU_DL_V6_FLOW 0x1e	/* hash only */
+
 /* Flag to enable additional fields in struct ethtool_rx_flow_spec */
 #define	FLOW_EXT	0x80000000
 #define	FLOW_MAC_EXT	0x40000000
@@ -2037,6 +2084,7 @@ static inline int ethtool_validate_duplex(uint8_t duplex)
 #define	RXH_IP_DST	(1 << 5)
 #define	RXH_L4_B_0_1	(1 << 6) /* src port in case of TCP/UDP/SCTP */
 #define	RXH_L4_B_2_3	(1 << 7) /* dst port in case of TCP/UDP/SCTP */
+#define	RXH_GTP_TEID	(1 << 8) /* teid in case of GTP */
 #define	RXH_DISCARD	(1 << 31)
 
 #define	RX_CLS_FLOW_DISC	0xffffffffffffffffULL
diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index fc0dcd10ae..bac9dbc49f 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -211,6 +211,12 @@
  *  7.39
  *  - add FUSE_DIRECT_IO_ALLOW_MMAP
  *  - add FUSE_STATX and related structures
+ *
+ *  7.40
+ *  - add max_stack_depth to fuse_init_out, add FUSE_PASSTHROUGH init flag
+ *  - add backing_id to fuse_open_out, add FOPEN_PASSTHROUGH open flag
+ *  - add FUSE_NO_EXPORT_SUPPORT init flag
+ *  - add FUSE_NOTIFY_RESEND, add FUSE_HAS_RESEND init flag
  */
 
 #ifndef _LINUX_FUSE_H
@@ -242,7 +248,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 39
+#define FUSE_KERNEL_MINOR_VERSION 40
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -349,6 +355,7 @@ struct fuse_file_lock {
  * FOPEN_STREAM: the file is stream-like (no file position at all)
  * FOPEN_NOFLUSH: don't flush data cache on close (unless FUSE_WRITEBACK_CACHE)
  * FOPEN_PARALLEL_DIRECT_WRITES: Allow concurrent direct writes on the same inode
+ * FOPEN_PASSTHROUGH: passthrough read/write io for this open file
  */
 #define FOPEN_DIRECT_IO		(1 << 0)
 #define FOPEN_KEEP_CACHE	(1 << 1)
@@ -357,6 +364,7 @@ struct fuse_file_lock {
 #define FOPEN_STREAM		(1 << 4)
 #define FOPEN_NOFLUSH		(1 << 5)
 #define FOPEN_PARALLEL_DIRECT_WRITES	(1 << 6)
+#define FOPEN_PASSTHROUGH	(1 << 7)
 
 /**
  * INIT request/reply flags
@@ -406,6 +414,9 @@ struct fuse_file_lock {
  *			symlink and mknod (single group that matches parent)
  * FUSE_HAS_EXPIRE_ONLY: kernel supports expiry-only entry invalidation
  * FUSE_DIRECT_IO_ALLOW_MMAP: allow shared mmap in FOPEN_DIRECT_IO mode.
+ * FUSE_NO_EXPORT_SUPPORT: explicitly disable export support
+ * FUSE_HAS_RESEND: kernel supports resending pending requests, and the high bit
+ *		    of the request ID indicates resend requests
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -445,6 +456,9 @@ struct fuse_file_lock {
 #define FUSE_CREATE_SUPP_GROUP	(1ULL << 34)
 #define FUSE_HAS_EXPIRE_ONLY	(1ULL << 35)
 #define FUSE_DIRECT_IO_ALLOW_MMAP (1ULL << 36)
+#define FUSE_PASSTHROUGH	(1ULL << 37)
+#define FUSE_NO_EXPORT_SUPPORT	(1ULL << 38)
+#define FUSE_HAS_RESEND		(1ULL << 39)
 
 /* Obsolete alias for FUSE_DIRECT_IO_ALLOW_MMAP */
 #define FUSE_DIRECT_IO_RELAX	FUSE_DIRECT_IO_ALLOW_MMAP
@@ -631,6 +645,7 @@ enum fuse_notify_code {
 	FUSE_NOTIFY_STORE = 4,
 	FUSE_NOTIFY_RETRIEVE = 5,
 	FUSE_NOTIFY_DELETE = 6,
+	FUSE_NOTIFY_RESEND = 7,
 	FUSE_NOTIFY_CODE_MAX,
 };
 
@@ -757,7 +772,7 @@ struct fuse_create_in {
 struct fuse_open_out {
 	uint64_t	fh;
 	uint32_t	open_flags;
-	uint32_t	padding;
+	int32_t		backing_id;
 };
 
 struct fuse_release_in {
@@ -873,7 +888,8 @@ struct fuse_init_out {
 	uint16_t	max_pages;
 	uint16_t	map_alignment;
 	uint32_t	flags2;
-	uint32_t	unused[7];
+	uint32_t	max_stack_depth;
+	uint32_t	unused[6];
 };
 
 #define CUSE_INIT_INFO_MAX 4096
@@ -956,6 +972,14 @@ struct fuse_fallocate_in {
 	uint32_t	padding;
 };
 
+/**
+ * FUSE request unique ID flag
+ *
+ * Indicates whether this is a resend request. The receiver should handle this
+ * request accordingly.
+ */
+#define FUSE_UNIQUE_RESEND (1ULL << 63)
+
 struct fuse_in_header {
 	uint32_t	len;
 	uint32_t	opcode;
@@ -1045,9 +1069,18 @@ struct fuse_notify_retrieve_in {
 	uint64_t	dummy4;
 };
 
+struct fuse_backing_map {
+	int32_t		fd;
+	uint32_t	flags;
+	uint64_t	padding;
+};
+
 /* Device ioctls: */
 #define FUSE_DEV_IOC_MAGIC		229
 #define FUSE_DEV_IOC_CLONE		_IOR(FUSE_DEV_IOC_MAGIC, 0, uint32_t)
+#define FUSE_DEV_IOC_BACKING_OPEN	_IOW(FUSE_DEV_IOC_MAGIC, 1, \
+					     struct fuse_backing_map)
+#define FUSE_DEV_IOC_BACKING_CLOSE	_IOW(FUSE_DEV_IOC_MAGIC, 2, uint32_t)
 
 struct fuse_lseek_in {
 	uint64_t	fh;
diff --git a/include/standard-headers/linux/input-event-codes.h b/include/standard-headers/linux/input-event-codes.h
index f6bab08540..2221b0c383 100644
--- a/include/standard-headers/linux/input-event-codes.h
+++ b/include/standard-headers/linux/input-event-codes.h
@@ -602,6 +602,7 @@
 
 #define KEY_ALS_TOGGLE		0x230	/* Ambient light sensor */
 #define KEY_ROTATE_LOCK_TOGGLE	0x231	/* Display rotation lock */
+#define KEY_REFRESH_RATE_TOGGLE	0x232	/* Display refresh rate toggle */
 
 #define KEY_BUTTONCONFIG		0x240	/* AL Button Configuration */
 #define KEY_TASKMANAGER		0x241	/* AL Task/Project Manager */
diff --git a/include/standard-headers/linux/virtio_gpu.h b/include/standard-headers/linux/virtio_gpu.h
index 2da48d3d4c..2db643ed8f 100644
--- a/include/standard-headers/linux/virtio_gpu.h
+++ b/include/standard-headers/linux/virtio_gpu.h
@@ -309,6 +309,8 @@ struct virtio_gpu_cmd_submit {
 
 #define VIRTIO_GPU_CAPSET_VIRGL 1
 #define VIRTIO_GPU_CAPSET_VIRGL2 2
+/* 3 is reserved for gfxstream */
+#define VIRTIO_GPU_CAPSET_VENUS 4
 
 /* VIRTIO_GPU_CMD_GET_CAPSET_INFO */
 struct virtio_gpu_get_capset_info {
diff --git a/include/standard-headers/linux/virtio_snd.h b/include/standard-headers/linux/virtio_snd.h
index 1af96b9fc6..860f12e0a4 100644
--- a/include/standard-headers/linux/virtio_snd.h
+++ b/include/standard-headers/linux/virtio_snd.h
@@ -7,6 +7,14 @@
 
 #include "standard-headers/linux/virtio_types.h"
 
+/*******************************************************************************
+ * FEATURE BITS
+ */
+enum {
+	/* device supports control elements */
+	VIRTIO_SND_F_CTLS = 0
+};
+
 /*******************************************************************************
  * CONFIGURATION SPACE
  */
@@ -17,6 +25,8 @@ struct virtio_snd_config {
 	uint32_t streams;
 	/* # of available channel maps */
 	uint32_t chmaps;
+	/* # of available control elements */
+	uint32_t controls;
 };
 
 enum {
@@ -55,6 +65,15 @@ enum {
 	/* channel map control request types */
 	VIRTIO_SND_R_CHMAP_INFO = 0x0200,
 
+	/* control element request types */
+	VIRTIO_SND_R_CTL_INFO = 0x0300,
+	VIRTIO_SND_R_CTL_ENUM_ITEMS,
+	VIRTIO_SND_R_CTL_READ,
+	VIRTIO_SND_R_CTL_WRITE,
+	VIRTIO_SND_R_CTL_TLV_READ,
+	VIRTIO_SND_R_CTL_TLV_WRITE,
+	VIRTIO_SND_R_CTL_TLV_COMMAND,
+
 	/* jack event types */
 	VIRTIO_SND_EVT_JACK_CONNECTED = 0x1000,
 	VIRTIO_SND_EVT_JACK_DISCONNECTED,
@@ -63,6 +82,9 @@ enum {
 	VIRTIO_SND_EVT_PCM_PERIOD_ELAPSED = 0x1100,
 	VIRTIO_SND_EVT_PCM_XRUN,
 
+	/* control element event types */
+	VIRTIO_SND_EVT_CTL_NOTIFY = 0x1200,
+
 	/* common status codes */
 	VIRTIO_SND_S_OK = 0x8000,
 	VIRTIO_SND_S_BAD_MSG,
@@ -331,4 +353,136 @@ struct virtio_snd_chmap_info {
 	uint8_t positions[VIRTIO_SND_CHMAP_MAX_SIZE];
 };
 
+/*******************************************************************************
+ * CONTROL ELEMENTS MESSAGES
+ */
+struct virtio_snd_ctl_hdr {
+	/* VIRTIO_SND_R_CTL_XXX */
+	struct virtio_snd_hdr hdr;
+	/* 0 ... virtio_snd_config::controls - 1 */
+	uint32_t control_id;
+};
+
+/* supported roles for control elements */
+enum {
+	VIRTIO_SND_CTL_ROLE_UNDEFINED = 0,
+	VIRTIO_SND_CTL_ROLE_VOLUME,
+	VIRTIO_SND_CTL_ROLE_MUTE,
+	VIRTIO_SND_CTL_ROLE_GAIN
+};
+
+/* supported value types for control elements */
+enum {
+	VIRTIO_SND_CTL_TYPE_BOOLEAN = 0,
+	VIRTIO_SND_CTL_TYPE_INTEGER,
+	VIRTIO_SND_CTL_TYPE_INTEGER64,
+	VIRTIO_SND_CTL_TYPE_ENUMERATED,
+	VIRTIO_SND_CTL_TYPE_BYTES,
+	VIRTIO_SND_CTL_TYPE_IEC958
+};
+
+/* supported access rights for control elements */
+enum {
+	VIRTIO_SND_CTL_ACCESS_READ = 0,
+	VIRTIO_SND_CTL_ACCESS_WRITE,
+	VIRTIO_SND_CTL_ACCESS_VOLATILE,
+	VIRTIO_SND_CTL_ACCESS_INACTIVE,
+	VIRTIO_SND_CTL_ACCESS_TLV_READ,
+	VIRTIO_SND_CTL_ACCESS_TLV_WRITE,
+	VIRTIO_SND_CTL_ACCESS_TLV_COMMAND
+};
+
+struct virtio_snd_ctl_info {
+	/* common header */
+	struct virtio_snd_info hdr;
+	/* element role (VIRTIO_SND_CTL_ROLE_XXX) */
+	uint32_t role;
+	/* element value type (VIRTIO_SND_CTL_TYPE_XXX) */
+	uint32_t type;
+	/* element access right bit map (1 << VIRTIO_SND_CTL_ACCESS_XXX) */
+	uint32_t access;
+	/* # of members in the element value */
+	uint32_t count;
+	/* index for an element with a non-unique name */
+	uint32_t index;
+	/* name identifier string for the element */
+	uint8_t name[44];
+	/* additional information about the element's value */
+	union {
+		/* VIRTIO_SND_CTL_TYPE_INTEGER */
+		struct {
+			/* minimum supported value */
+			uint32_t min;
+			/* maximum supported value */
+			uint32_t max;
+			/* fixed step size for value (0 = variable size) */
+			uint32_t step;
+		} integer;
+		/* VIRTIO_SND_CTL_TYPE_INTEGER64 */
+		struct {
+			/* minimum supported value */
+			uint64_t min;
+			/* maximum supported value */
+			uint64_t max;
+			/* fixed step size for value (0 = variable size) */
+			uint64_t step;
+		} integer64;
+		/* VIRTIO_SND_CTL_TYPE_ENUMERATED */
+		struct {
+			/* # of options supported for value */
+			uint32_t items;
+		} enumerated;
+	} value;
+};
+
+struct virtio_snd_ctl_enum_item {
+	/* option name */
+	uint8_t item[64];
+};
+
+struct virtio_snd_ctl_iec958 {
+	/* AES/IEC958 channel status bits */
+	uint8_t status[24];
+	/* AES/IEC958 subcode bits */
+	uint8_t subcode[147];
+	/* nothing */
+	uint8_t pad;
+	/* AES/IEC958 subframe bits */
+	uint8_t dig_subframe[4];
+};
+
+struct virtio_snd_ctl_value {
+	union {
+		/* VIRTIO_SND_CTL_TYPE_BOOLEAN|INTEGER value */
+		uint32_t integer[128];
+		/* VIRTIO_SND_CTL_TYPE_INTEGER64 value */
+		uint64_t integer64[64];
+		/* VIRTIO_SND_CTL_TYPE_ENUMERATED value (option indexes) */
+		uint32_t enumerated[128];
+		/* VIRTIO_SND_CTL_TYPE_BYTES value */
+		uint8_t bytes[512];
+		/* VIRTIO_SND_CTL_TYPE_IEC958 value */
+		struct virtio_snd_ctl_iec958 iec958;
+	} value;
+};
+
+/* supported event reason types */
+enum {
+	/* element's value has changed */
+	VIRTIO_SND_CTL_EVT_MASK_VALUE = 0,
+	/* element's information has changed */
+	VIRTIO_SND_CTL_EVT_MASK_INFO,
+	/* element's metadata has changed */
+	VIRTIO_SND_CTL_EVT_MASK_TLV
+};
+
+struct virtio_snd_ctl_event {
+	/* VIRTIO_SND_EVT_CTL_NOTIFY */
+	struct virtio_snd_hdr hdr;
+	/* 0 ... virtio_snd_config::controls - 1 */
+	uint16_t control_id;
+	/* event reason bit map (1 << VIRTIO_SND_CTL_EVT_MASK_XXX) */
+	uint16_t mask;
+};
+
 #endif /* VIRTIO_SND_IF_H */
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index c59ea55cd8..2af9931ae9 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -37,9 +37,7 @@
 #include <asm/ptrace.h>
 #include <asm/sve_context.h>
 
-#define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_READONLY_MEM
 #define __KVM_HAVE_VCPU_EVENTS
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
@@ -76,11 +74,11 @@ struct kvm_regs {
 
 /* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
 #define KVM_ARM_DEVICE_TYPE_SHIFT	0
-#define KVM_ARM_DEVICE_TYPE_MASK	GENMASK(KVM_ARM_DEVICE_TYPE_SHIFT + 15, \
-						KVM_ARM_DEVICE_TYPE_SHIFT)
+#define KVM_ARM_DEVICE_TYPE_MASK	__GENMASK(KVM_ARM_DEVICE_TYPE_SHIFT + 15, \
+						  KVM_ARM_DEVICE_TYPE_SHIFT)
 #define KVM_ARM_DEVICE_ID_SHIFT		16
-#define KVM_ARM_DEVICE_ID_MASK		GENMASK(KVM_ARM_DEVICE_ID_SHIFT + 15, \
-						KVM_ARM_DEVICE_ID_SHIFT)
+#define KVM_ARM_DEVICE_ID_MASK		__GENMASK(KVM_ARM_DEVICE_ID_SHIFT + 15, \
+						  KVM_ARM_DEVICE_ID_SHIFT)
 
 /* Supported device IDs */
 #define KVM_ARM_DEVICE_VGIC_V2		0
@@ -162,6 +160,11 @@ struct kvm_sync_regs {
 	__u64 device_irq_level;
 };
 
+/* Bits for run->s.regs.device_irq_level */
+#define KVM_ARM_DEV_EL1_VTIMER		(1 << 0)
+#define KVM_ARM_DEV_EL1_PTIMER		(1 << 1)
+#define KVM_ARM_DEV_PMU			(1 << 2)
+
 /*
  * PMU filter structure. Describe a range of events with a particular
  * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
diff --git a/linux-headers/asm-arm64/sve_context.h b/linux-headers/asm-arm64/sve_context.h
index 1d0e3e1d09..d1b1ec8cb1 100644
--- a/linux-headers/asm-arm64/sve_context.h
+++ b/linux-headers/asm-arm64/sve_context.h
@@ -13,6 +13,17 @@
 
 #define __SVE_VQ_BYTES		16	/* number of bytes per quadword */
 
+/*
+ * Yes, __SVE_VQ_MAX is 512 QUADWORDS.
+ *
+ * To help ensure forward portability, this is much larger than the
+ * current maximum value defined by the SVE architecture.  While arrays
+ * or static allocations can be sized based on this value, watch out!
+ * It will waste a surprisingly large amount of memory.
+ *
+ * Dynamic sizing based on the actual runtime vector length is likely to
+ * be preferable for most purposes.
+ */
 #define __SVE_VQ_MIN		1
 #define __SVE_VQ_MAX		512
 
diff --git a/linux-headers/asm-generic/bitsperlong.h b/linux-headers/asm-generic/bitsperlong.h
index 75f320fa91..1fb4f0c9f2 100644
--- a/linux-headers/asm-generic/bitsperlong.h
+++ b/linux-headers/asm-generic/bitsperlong.h
@@ -24,4 +24,8 @@
 #endif
 #endif
 
+#ifndef __BITS_PER_LONG_LONG
+#define __BITS_PER_LONG_LONG 64
+#endif
+
 #endif /* __ASM_GENERIC_BITS_PER_LONG */
diff --git a/linux-headers/asm-loongarch/kvm.h b/linux-headers/asm-loongarch/kvm.h
index 923d0bd382..109785922c 100644
--- a/linux-headers/asm-loongarch/kvm.h
+++ b/linux-headers/asm-loongarch/kvm.h
@@ -14,8 +14,6 @@
  * Some parts derived from the x86 version of this file.
  */
 
-#define __KVM_HAVE_READONLY_MEM
-
 #define KVM_COALESCED_MMIO_PAGE_OFFSET	1
 #define KVM_DIRTY_LOG_PAGE_OFFSET	64
 
diff --git a/linux-headers/asm-mips/kvm.h b/linux-headers/asm-mips/kvm.h
index edcf717c43..9673dc9cb3 100644
--- a/linux-headers/asm-mips/kvm.h
+++ b/linux-headers/asm-mips/kvm.h
@@ -20,8 +20,6 @@
  * Some parts derived from the x86 version of this file.
  */
 
-#define __KVM_HAVE_READONLY_MEM
-
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
 /*
diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
index 9f18fa090f..1691297a76 100644
--- a/linux-headers/asm-powerpc/kvm.h
+++ b/linux-headers/asm-powerpc/kvm.h
@@ -28,7 +28,6 @@
 #define __KVM_HAVE_PPC_SMT
 #define __KVM_HAVE_IRQCHIP
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_GUEST_DEBUG
 
 /* Not always available, but if it is, this is the correct offset.  */
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
@@ -733,4 +732,48 @@ struct kvm_ppc_xive_eq {
 #define KVM_XIVE_TIMA_PAGE_OFFSET	0
 #define KVM_XIVE_ESB_PAGE_OFFSET	4
 
+/* for KVM_PPC_GET_PVINFO */
+
+#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
+
+struct kvm_ppc_pvinfo {
+	/* out */
+	__u32 flags;
+	__u32 hcall[4];
+	__u8  pad[108];
+};
+
+/* for KVM_PPC_GET_SMMU_INFO */
+#define KVM_PPC_PAGE_SIZES_MAX_SZ	8
+
+struct kvm_ppc_one_page_size {
+	__u32 page_shift;	/* Page shift (or 0) */
+	__u32 pte_enc;		/* Encoding in the HPTE (>>12) */
+};
+
+struct kvm_ppc_one_seg_page_size {
+	__u32 page_shift;	/* Base page shift of segment (or 0) */
+	__u32 slb_enc;		/* SLB encoding for BookS */
+	struct kvm_ppc_one_page_size enc[KVM_PPC_PAGE_SIZES_MAX_SZ];
+};
+
+#define KVM_PPC_PAGE_SIZES_REAL		0x00000001
+#define KVM_PPC_1T_SEGMENTS		0x00000002
+#define KVM_PPC_NO_HASH			0x00000004
+
+struct kvm_ppc_smmu_info {
+	__u64 flags;
+	__u32 slb_size;
+	__u16 data_keys;	/* # storage keys supported for data */
+	__u16 instr_keys;	/* # storage keys supported for instructions */
+	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
+};
+
+/* for KVM_PPC_RESIZE_HPT_{PREPARE,COMMIT} */
+struct kvm_ppc_resize_hpt {
+	__u64 flags;
+	__u32 shift;
+	__u32 pad;
+};
+
 #endif /* __LINUX_KVM_POWERPC_H */
diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index 7499e88a94..b1c503c295 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -16,7 +16,6 @@
 #include <asm/ptrace.h>
 
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_READONLY_MEM
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
@@ -166,6 +165,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZVFH,
 	KVM_RISCV_ISA_EXT_ZVFHMIN,
 	KVM_RISCV_ISA_EXT_ZFA,
+	KVM_RISCV_ISA_EXT_ZTSO,
+	KVM_RISCV_ISA_EXT_ZACAS,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index 023a2763a9..684c4e1205 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -12,7 +12,320 @@
 #include <linux/types.h>
 
 #define __KVM_S390
-#define __KVM_HAVE_GUEST_DEBUG
+
+struct kvm_s390_skeys {
+	__u64 start_gfn;
+	__u64 count;
+	__u64 skeydata_addr;
+	__u32 flags;
+	__u32 reserved[9];
+};
+
+#define KVM_S390_CMMA_PEEK (1 << 0)
+
+/**
+ * kvm_s390_cmma_log - Used for CMMA migration.
+ *
+ * Used both for input and output.
+ *
+ * @start_gfn: Guest page number to start from.
+ * @count: Size of the result buffer.
+ * @flags: Control operation mode via KVM_S390_CMMA_* flags
+ * @remaining: Used with KVM_S390_GET_CMMA_BITS. Indicates how many dirty
+ *             pages are still remaining.
+ * @mask: Used with KVM_S390_SET_CMMA_BITS. Bitmap of bits to actually set
+ *        in the PGSTE.
+ * @values: Pointer to the values buffer.
+ *
+ * Used in KVM_S390_{G,S}ET_CMMA_BITS ioctls.
+ */
+struct kvm_s390_cmma_log {
+	__u64 start_gfn;
+	__u32 count;
+	__u32 flags;
+	union {
+		__u64 remaining;
+		__u64 mask;
+	};
+	__u64 values;
+};
+
+#define KVM_S390_RESET_POR       1
+#define KVM_S390_RESET_CLEAR     2
+#define KVM_S390_RESET_SUBSYSTEM 4
+#define KVM_S390_RESET_CPU_INIT  8
+#define KVM_S390_RESET_IPL       16
+
+/* for KVM_S390_MEM_OP */
+struct kvm_s390_mem_op {
+	/* in */
+	__u64 gaddr;		/* the guest address */
+	__u64 flags;		/* flags */
+	__u32 size;		/* amount of bytes */
+	__u32 op;		/* type of operation */
+	__u64 buf;		/* buffer in userspace */
+	union {
+		struct {
+			__u8 ar;	/* the access register number */
+			__u8 key;	/* access key, ignored if flag unset */
+			__u8 pad1[6];	/* ignored */
+			__u64 old_addr;	/* ignored if cmpxchg flag unset */
+		};
+		__u32 sida_offset; /* offset into the sida */
+		__u8 reserved[32]; /* ignored */
+	};
+};
+/* types for kvm_s390_mem_op->op */
+#define KVM_S390_MEMOP_LOGICAL_READ	0
+#define KVM_S390_MEMOP_LOGICAL_WRITE	1
+#define KVM_S390_MEMOP_SIDA_READ	2
+#define KVM_S390_MEMOP_SIDA_WRITE	3
+#define KVM_S390_MEMOP_ABSOLUTE_READ	4
+#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
+#define KVM_S390_MEMOP_ABSOLUTE_CMPXCHG	6
+
+/* flags for kvm_s390_mem_op->flags */
+#define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
+#define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
+#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
+
+/* flags specifying extension support via KVM_CAP_S390_MEM_OP_EXTENSION */
+#define KVM_S390_MEMOP_EXTENSION_CAP_BASE	(1 << 0)
+#define KVM_S390_MEMOP_EXTENSION_CAP_CMPXCHG	(1 << 1)
+
+struct kvm_s390_psw {
+	__u64 mask;
+	__u64 addr;
+};
+
+/* valid values for type in kvm_s390_interrupt */
+#define KVM_S390_SIGP_STOP		0xfffe0000u
+#define KVM_S390_PROGRAM_INT		0xfffe0001u
+#define KVM_S390_SIGP_SET_PREFIX	0xfffe0002u
+#define KVM_S390_RESTART		0xfffe0003u
+#define KVM_S390_INT_PFAULT_INIT	0xfffe0004u
+#define KVM_S390_INT_PFAULT_DONE	0xfffe0005u
+#define KVM_S390_MCHK			0xfffe1000u
+#define KVM_S390_INT_CLOCK_COMP		0xffff1004u
+#define KVM_S390_INT_CPU_TIMER		0xffff1005u
+#define KVM_S390_INT_VIRTIO		0xffff2603u
+#define KVM_S390_INT_SERVICE		0xffff2401u
+#define KVM_S390_INT_EMERGENCY		0xffff1201u
+#define KVM_S390_INT_EXTERNAL_CALL	0xffff1202u
+/* Anything below 0xfffe0000u is taken by INT_IO */
+#define KVM_S390_INT_IO(ai,cssid,ssid,schid)   \
+	(((schid)) |			       \
+	 ((ssid) << 16) |		       \
+	 ((cssid) << 18) |		       \
+	 ((ai) << 26))
+#define KVM_S390_INT_IO_MIN		0x00000000u
+#define KVM_S390_INT_IO_MAX		0xfffdffffu
+#define KVM_S390_INT_IO_AI_MASK		0x04000000u
+
+
+struct kvm_s390_interrupt {
+	__u32 type;
+	__u32 parm;
+	__u64 parm64;
+};
+
+struct kvm_s390_io_info {
+	__u16 subchannel_id;
+	__u16 subchannel_nr;
+	__u32 io_int_parm;
+	__u32 io_int_word;
+};
+
+struct kvm_s390_ext_info {
+	__u32 ext_params;
+	__u32 pad;
+	__u64 ext_params2;
+};
+
+struct kvm_s390_pgm_info {
+	__u64 trans_exc_code;
+	__u64 mon_code;
+	__u64 per_address;
+	__u32 data_exc_code;
+	__u16 code;
+	__u16 mon_class_nr;
+	__u8 per_code;
+	__u8 per_atmid;
+	__u8 exc_access_id;
+	__u8 per_access_id;
+	__u8 op_access_id;
+#define KVM_S390_PGM_FLAGS_ILC_VALID	0x01
+#define KVM_S390_PGM_FLAGS_ILC_0	0x02
+#define KVM_S390_PGM_FLAGS_ILC_1	0x04
+#define KVM_S390_PGM_FLAGS_ILC_MASK	0x06
+#define KVM_S390_PGM_FLAGS_NO_REWIND	0x08
+	__u8 flags;
+	__u8 pad[2];
+};
+
+struct kvm_s390_prefix_info {
+	__u32 address;
+};
+
+struct kvm_s390_extcall_info {
+	__u16 code;
+};
+
+struct kvm_s390_emerg_info {
+	__u16 code;
+};
+
+#define KVM_S390_STOP_FLAG_STORE_STATUS	0x01
+struct kvm_s390_stop_info {
+	__u32 flags;
+};
+
+struct kvm_s390_mchk_info {
+	__u64 cr14;
+	__u64 mcic;
+	__u64 failing_storage_address;
+	__u32 ext_damage_code;
+	__u32 pad;
+	__u8 fixed_logout[16];
+};
+
+struct kvm_s390_irq {
+	__u64 type;
+	union {
+		struct kvm_s390_io_info io;
+		struct kvm_s390_ext_info ext;
+		struct kvm_s390_pgm_info pgm;
+		struct kvm_s390_emerg_info emerg;
+		struct kvm_s390_extcall_info extcall;
+		struct kvm_s390_prefix_info prefix;
+		struct kvm_s390_stop_info stop;
+		struct kvm_s390_mchk_info mchk;
+		char reserved[64];
+	} u;
+};
+
+struct kvm_s390_irq_state {
+	__u64 buf;
+	__u32 flags;        /* will stay unused for compatibility reasons */
+	__u32 len;
+	__u32 reserved[4];  /* will stay unused for compatibility reasons */
+};
+
+struct kvm_s390_ucas_mapping {
+	__u64 user_addr;
+	__u64 vcpu_addr;
+	__u64 length;
+};
+
+struct kvm_s390_pv_sec_parm {
+	__u64 origin;
+	__u64 length;
+};
+
+struct kvm_s390_pv_unp {
+	__u64 addr;
+	__u64 size;
+	__u64 tweak;
+};
+
+enum pv_cmd_dmp_id {
+	KVM_PV_DUMP_INIT,
+	KVM_PV_DUMP_CONFIG_STOR_STATE,
+	KVM_PV_DUMP_COMPLETE,
+	KVM_PV_DUMP_CPU,
+};
+
+struct kvm_s390_pv_dmp {
+	__u64 subcmd;
+	__u64 buff_addr;
+	__u64 buff_len;
+	__u64 gaddr;		/* For dump storage state */
+	__u64 reserved[4];
+};
+
+enum pv_cmd_info_id {
+	KVM_PV_INFO_VM,
+	KVM_PV_INFO_DUMP,
+};
+
+struct kvm_s390_pv_info_dump {
+	__u64 dump_cpu_buffer_len;
+	__u64 dump_config_mem_buffer_per_1m;
+	__u64 dump_config_finalize_len;
+};
+
+struct kvm_s390_pv_info_vm {
+	__u64 inst_calls_list[4];
+	__u64 max_cpus;
+	__u64 max_guests;
+	__u64 max_guest_addr;
+	__u64 feature_indication;
+};
+
+struct kvm_s390_pv_info_header {
+	__u32 id;
+	__u32 len_max;
+	__u32 len_written;
+	__u32 reserved;
+};
+
+struct kvm_s390_pv_info {
+	struct kvm_s390_pv_info_header header;
+	union {
+		struct kvm_s390_pv_info_dump dump;
+		struct kvm_s390_pv_info_vm vm;
+	};
+};
+
+enum pv_cmd_id {
+	KVM_PV_ENABLE,
+	KVM_PV_DISABLE,
+	KVM_PV_SET_SEC_PARMS,
+	KVM_PV_UNPACK,
+	KVM_PV_VERIFY,
+	KVM_PV_PREP_RESET,
+	KVM_PV_UNSHARE_ALL,
+	KVM_PV_INFO,
+	KVM_PV_DUMP,
+	KVM_PV_ASYNC_CLEANUP_PREPARE,
+	KVM_PV_ASYNC_CLEANUP_PERFORM,
+};
+
+struct kvm_pv_cmd {
+	__u32 cmd;	/* Command to be executed */
+	__u16 rc;	/* Ultravisor return code */
+	__u16 rrc;	/* Ultravisor return reason code */
+	__u64 data;	/* Data or address */
+	__u32 flags;    /* flags for future extensions. Must be 0 for now */
+	__u32 reserved[3];
+};
+
+struct kvm_s390_zpci_op {
+	/* in */
+	__u32 fh;               /* target device */
+	__u8  op;               /* operation to perform */
+	__u8  pad[3];
+	union {
+		/* for KVM_S390_ZPCIOP_REG_AEN */
+		struct {
+			__u64 ibv;      /* Guest addr of interrupt bit vector */
+			__u64 sb;       /* Guest addr of summary bit */
+			__u32 flags;
+			__u32 noi;      /* Number of interrupts */
+			__u8 isc;       /* Guest interrupt subclass */
+			__u8 sbo;       /* Offset of guest summary bit vector */
+			__u16 pad;
+		} reg_aen;
+		__u64 reserved[8];
+	} u;
+};
+
+/* types for kvm_s390_zpci_op->op */
+#define KVM_S390_ZPCIOP_REG_AEN                0
+#define KVM_S390_ZPCIOP_DEREG_AEN      1
+
+/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
+#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
 
 /* Device control API: s390-specific devices */
 #define KVM_DEV_FLIC_GET_ALL_IRQS	1
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 003fb74534..a551e44b1c 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -7,6 +7,8 @@
  *
  */
 
+#include <linux/const.h>
+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/stddef.h>
@@ -40,7 +42,6 @@
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_MSI
 #define __KVM_HAVE_USER_NMI
-#define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_MSIX
 #define __KVM_HAVE_MCE
 #define __KVM_HAVE_PIT_STATE2
@@ -49,7 +50,6 @@
 #define __KVM_HAVE_DEBUGREGS
 #define __KVM_HAVE_XSAVE
 #define __KVM_HAVE_XCRS
-#define __KVM_HAVE_READONLY_MEM
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
@@ -457,6 +457,7 @@ struct kvm_sync_regs {
 
 /* attributes for system fd (group 0) */
 #define KVM_X86_XCOMP_GUEST_SUPP	0
+#define KVM_X86_SEV_VMSA_FEATURES	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -524,9 +525,353 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
-#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS _BITUL(0)
 #define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
 
+/* for KVM_CAP_MCE */
+struct kvm_x86_mce {
+	__u64 status;
+	__u64 addr;
+	__u64 misc;
+	__u64 mcg_status;
+	__u8 bank;
+	__u8 pad1[7];
+	__u64 pad2[3];
+};
+
+/* for KVM_CAP_XEN_HVM */
+#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
+#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 8)
+
+struct kvm_xen_hvm_config {
+	__u32 flags;
+	__u32 msr;
+	__u64 blob_addr_32;
+	__u64 blob_addr_64;
+	__u8 blob_size_32;
+	__u8 blob_size_64;
+	__u8 pad2[30];
+};
+
+struct kvm_xen_hvm_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u8 long_mode;
+		__u8 vector;
+		__u8 runstate_update_flag;
+		union {
+			__u64 gfn;
+#define KVM_XEN_INVALID_GFN ((__u64)-1)
+			__u64 hva;
+		} shared_info;
+		struct {
+			__u32 send_port;
+			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
+			__u32 flags;
+#define KVM_XEN_EVTCHN_DEASSIGN		(1 << 0)
+#define KVM_XEN_EVTCHN_UPDATE		(1 << 1)
+#define KVM_XEN_EVTCHN_RESET		(1 << 2)
+			/*
+			 * Events sent by the guest are either looped back to
+			 * the guest itself (potentially on a different port#)
+			 * or signalled via an eventfd.
+			 */
+			union {
+				struct {
+					__u32 port;
+					__u32 vcpu;
+					__u32 priority;
+				} port;
+				struct {
+					__u32 port; /* Zero for eventfd */
+					__s32 fd;
+				} eventfd;
+				__u32 padding[4];
+			} deliver;
+		} evtchn;
+		__u32 xen_version;
+		__u64 pad[8];
+	} u;
+};
+
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
+#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
+#define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA	0x6
+
+struct kvm_xen_vcpu_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u64 gpa;
+#define KVM_XEN_INVALID_GPA ((__u64)-1)
+		__u64 hva;
+		__u64 pad[8];
+		struct {
+			__u64 state;
+			__u64 state_entry_time;
+			__u64 time_running;
+			__u64 time_runnable;
+			__u64 time_blocked;
+			__u64 time_offline;
+		} runstate;
+		__u32 vcpu_id;
+		struct {
+			__u32 port;
+			__u32 priority;
+			__u64 expires_ns;
+		} timer;
+		__u8 vector;
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
+#define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
+#define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA	0x9
+
+/* Secure Encrypted Virtualization command */
+enum sev_cmd_id {
+	/* Guest initialization commands */
+	KVM_SEV_INIT = 0,
+	KVM_SEV_ES_INIT,
+	/* Guest launch commands */
+	KVM_SEV_LAUNCH_START,
+	KVM_SEV_LAUNCH_UPDATE_DATA,
+	KVM_SEV_LAUNCH_UPDATE_VMSA,
+	KVM_SEV_LAUNCH_SECRET,
+	KVM_SEV_LAUNCH_MEASURE,
+	KVM_SEV_LAUNCH_FINISH,
+	/* Guest migration commands (outgoing) */
+	KVM_SEV_SEND_START,
+	KVM_SEV_SEND_UPDATE_DATA,
+	KVM_SEV_SEND_UPDATE_VMSA,
+	KVM_SEV_SEND_FINISH,
+	/* Guest migration commands (incoming) */
+	KVM_SEV_RECEIVE_START,
+	KVM_SEV_RECEIVE_UPDATE_DATA,
+	KVM_SEV_RECEIVE_UPDATE_VMSA,
+	KVM_SEV_RECEIVE_FINISH,
+	/* Guest status and debug commands */
+	KVM_SEV_GUEST_STATUS,
+	KVM_SEV_DBG_DECRYPT,
+	KVM_SEV_DBG_ENCRYPT,
+	/* Guest certificates commands */
+	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
+	/* Guest Migration Extension */
+	KVM_SEV_SEND_CANCEL,
+
+	/* Second time is the charm; improved versions of the above ioctls.  */
+	KVM_SEV_INIT2,
+
+	/* SNP-specific commands */
+	KVM_SEV_SNP_INIT,
+	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
+	KVM_SEV_SNP_LAUNCH_FINISH,
+
+	KVM_SEV_NR_MAX,
+};
+
+struct kvm_sev_cmd {
+	__u32 id;
+	__u32 pad0;
+	__u64 data;
+	__u32 error;
+	__u32 sev_fd;
+};
+
+struct kvm_sev_init {
+	__u64 vmsa_features;
+	__u32 flags;
+	__u32 pad[9];
+};
+
+struct kvm_sev_launch_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 dh_uaddr;
+	__u32 dh_len;
+	__u32 pad0;
+	__u64 session_uaddr;
+	__u32 session_len;
+	__u32 pad1;
+};
+
+struct kvm_sev_launch_update_data {
+	__u64 uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+
+struct kvm_sev_launch_secret {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u32 pad0;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u32 pad1;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+	__u32 pad2;
+};
+
+struct kvm_sev_launch_measure {
+	__u64 uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+struct kvm_sev_guest_status {
+	__u32 handle;
+	__u32 policy;
+	__u32 state;
+};
+
+struct kvm_sev_dbg {
+	__u64 src_uaddr;
+	__u64 dst_uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+struct kvm_sev_attestation_report {
+	__u8 mnonce[16];
+	__u64 uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+struct kvm_sev_send_start {
+	__u32 policy;
+	__u32 pad0;
+	__u64 pdh_cert_uaddr;
+	__u32 pdh_cert_len;
+	__u32 pad1;
+	__u64 plat_certs_uaddr;
+	__u32 plat_certs_len;
+	__u32 pad2;
+	__u64 amd_certs_uaddr;
+	__u32 amd_certs_len;
+	__u32 pad3;
+	__u64 session_uaddr;
+	__u32 session_len;
+	__u32 pad4;
+};
+
+struct kvm_sev_send_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u32 pad0;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u32 pad1;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+	__u32 pad2;
+};
+
+struct kvm_sev_receive_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 pdh_uaddr;
+	__u32 pdh_len;
+	__u32 pad0;
+	__u64 session_uaddr;
+	__u32 session_len;
+	__u32 pad1;
+};
+
+struct kvm_sev_receive_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u32 pad0;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u32 pad1;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+	__u32 pad2;
+};
+
+/* TODO: use a common struct via KVM_SEV_INIT2 */
+struct kvm_snp_init {
+	__u64 flags;
+};
+
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u8 gosvw[16];
+};
+
+/* Kept in sync with firmware values for simplicity. */
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 gfn_start;
+	__u64 uaddr;
+	__u32 len;
+	__u8 type;
+};
+
+#define KVM_SEV_SNP_ID_BLOCK_SIZE	96
+#define KVM_SEV_SNP_ID_AUTH_SIZE	4096
+#define KVM_SEV_SNP_FINISH_DATA_SIZE	32
+
+struct kvm_sev_snp_launch_finish {
+	__u64 id_block_uaddr;
+	__u64 id_auth_uaddr;
+	__u8 id_block_en;
+	__u8 auth_key_en;
+	__u8 host_data[KVM_SEV_SNP_FINISH_DATA_SIZE];
+	__u8 pad[6];
+};
+
+#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+
+struct kvm_hyperv_eventfd {
+	__u32 conn_id;
+	__s32 fd;
+	__u32 flags;
+	__u32 padding[3];
+};
+
+#define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
+#define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
+
 /*
  * Masked event layout.
  * Bits   Description
@@ -547,10 +892,10 @@ struct kvm_pmu_event_filter {
 	((__u64)(!!(exclude)) << 55))
 
 #define KVM_PMU_MASKED_ENTRY_EVENT_SELECT \
-	(GENMASK_ULL(7, 0) | GENMASK_ULL(35, 32))
-#define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(GENMASK_ULL(63, 56))
-#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(GENMASK_ULL(15, 8))
-#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(BIT_ULL(55))
+	(__GENMASK_ULL(7, 0) | __GENMASK_ULL(35, 32))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(__GENMASK_ULL(63, 56))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(__GENMASK_ULL(15, 8))
+#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(_BITULL(55))
 #define KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT	(56)
 
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
@@ -558,9 +903,12 @@ struct kvm_pmu_event_filter {
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
-#define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
+#define KVM_EXIT_HYPERCALL_LONG_MODE	_BITULL(0)
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
+#define KVM_X86_SEV_VM		2
+#define KVM_X86_SEV_ES_VM	3
+#define KVM_X86_SNP_VM		4
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/asm-x86/setup_data.h b/linux-headers/asm-x86/setup_data.h
new file mode 100644
index 0000000000..09355f54c5
--- /dev/null
+++ b/linux-headers/asm-x86/setup_data.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _ASM_X86_SETUP_DATA_H
+#define _ASM_X86_SETUP_DATA_H
+
+/* setup_data/setup_indirect types */
+#define SETUP_NONE			0
+#define SETUP_E820_EXT			1
+#define SETUP_DTB			2
+#define SETUP_PCI			3
+#define SETUP_EFI			4
+#define SETUP_APPLE_PROPERTIES		5
+#define SETUP_JAILHOUSE			6
+#define SETUP_CC_BLOB			7
+#define SETUP_IMA			8
+#define SETUP_RNG_SEED			9
+#define SETUP_ENUM_MAX			SETUP_RNG_SEED
+
+#define SETUP_INDIRECT			(1<<31)
+#define SETUP_TYPE_MAX			(SETUP_ENUM_MAX | SETUP_INDIRECT)
+
+#ifndef __ASSEMBLY__
+
+#include "standard-headers/linux/types.h"
+
+/* extensible setup data list node */
+struct setup_data {
+	uint64_t next;
+	uint32_t type;
+	uint32_t len;
+	uint8_t data[];
+};
+
+/* extensible setup indirect data node */
+struct setup_indirect {
+	uint32_t type;
+	uint32_t reserved;  /* Reserved, must be set to zero. */
+	uint64_t len;
+	uint64_t addr;
+};
+
+/*
+ * The E820 memory region entry of the boot protocol ABI:
+ */
+struct boot_e820_entry {
+	uint64_t addr;
+	uint64_t size;
+	uint32_t type;
+} QEMU_PACKED;
+
+/*
+ * The boot loader is passing platform information via this Jailhouse-specific
+ * setup data structure.
+ */
+struct jailhouse_setup_data {
+	struct {
+		uint16_t	version;
+		uint16_t	compatible_version;
+	} QEMU_PACKED hdr;
+	struct {
+		uint16_t	pm_timer_address;
+		uint16_t	num_cpus;
+		uint64_t	pci_mmconfig_base;
+		uint32_t	tsc_khz;
+		uint32_t	apic_khz;
+		uint8_t	standard_ioapic;
+		uint8_t	cpu_ids[255];
+	} QEMU_PACKED v1;
+	struct {
+		uint32_t	flags;
+	} QEMU_PACKED v2;
+} QEMU_PACKED;
+
+/*
+ * IMA buffer setup data information from the previous kernel during kexec
+ */
+struct ima_setup_data {
+	uint64_t addr;
+	uint64_t size;
+} QEMU_PACKED;
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_X86_SETUP_DATA_H */
diff --git a/linux-headers/linux/bits.h b/linux-headers/linux/bits.h
new file mode 100644
index 0000000000..d9897771be
--- /dev/null
+++ b/linux-headers/linux/bits.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* bits.h: Macros for dealing with bitmasks.  */
+
+#ifndef _LINUX_BITS_H
+#define _LINUX_BITS_H
+
+#define __GENMASK(h, l) \
+        (((~_UL(0)) - (_UL(1) << (l)) + 1) & \
+         (~_UL(0) >> (__BITS_PER_LONG - 1 - (h))))
+
+#define __GENMASK_ULL(h, l) \
+        (((~_ULL(0)) - (_ULL(1) << (l)) + 1) & \
+         (~_ULL(0) >> (__BITS_PER_LONG_LONG - 1 - (h))))
+
+#endif /* _LINUX_BITS_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 17839229b2..629a015e4e 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -16,6 +16,11 @@
 
 #define KVM_API_VERSION 12
 
+/*
+ * Backwards-compatible definitions.
+ */
+#define __KVM_HAVE_GUEST_DEBUG
+
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
 	__u32 slot;
@@ -85,43 +90,6 @@ struct kvm_pit_config {
 
 #define KVM_PIT_SPEAKER_DUMMY     1
 
-struct kvm_s390_skeys {
-	__u64 start_gfn;
-	__u64 count;
-	__u64 skeydata_addr;
-	__u32 flags;
-	__u32 reserved[9];
-};
-
-#define KVM_S390_CMMA_PEEK (1 << 0)
-
-/**
- * kvm_s390_cmma_log - Used for CMMA migration.
- *
- * Used both for input and output.
- *
- * @start_gfn: Guest page number to start from.
- * @count: Size of the result buffer.
- * @flags: Control operation mode via KVM_S390_CMMA_* flags
- * @remaining: Used with KVM_S390_GET_CMMA_BITS. Indicates how many dirty
- *             pages are still remaining.
- * @mask: Used with KVM_S390_SET_CMMA_BITS. Bitmap of bits to actually set
- *        in the PGSTE.
- * @values: Pointer to the values buffer.
- *
- * Used in KVM_S390_{G,S}ET_CMMA_BITS ioctls.
- */
-struct kvm_s390_cmma_log {
-	__u64 start_gfn;
-	__u32 count;
-	__u32 flags;
-	union {
-		__u64 remaining;
-		__u64 mask;
-	};
-	__u64 values;
-};
-
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
@@ -167,6 +135,31 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_user_vmgexit {
+#define KVM_USER_VMGEXIT_PSC_MSR	1
+#define KVM_USER_VMGEXIT_PSC		2
+#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3
+	__u32 type; /* KVM_USER_VMGEXIT_* type */
+	union {
+		struct {
+			__u64 gpa;
+#define KVM_USER_VMGEXIT_PSC_MSR_OP_PRIVATE	1
+#define KVM_USER_VMGEXIT_PSC_MSR_OP_SHARED	2
+			__u8 op;
+			__u32 ret;
+		} psc_msr;
+		struct {
+			__u64 shared_gpa;
+			__u64 ret;
+		} psc;
+		struct {
+			__u64 data_gpa;
+			__u64 data_npages;
+			__u32 ret;
+		} ext_guest_req;
+	};
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -210,6 +203,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_VMGEXIT          40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -313,11 +307,6 @@ struct kvm_run {
 			__u32 ipb;
 		} s390_sieic;
 		/* KVM_EXIT_S390_RESET */
-#define KVM_S390_RESET_POR       1
-#define KVM_S390_RESET_CLEAR     2
-#define KVM_S390_RESET_SUBSYSTEM 4
-#define KVM_S390_RESET_CPU_INIT  8
-#define KVM_S390_RESET_IPL       16
 		__u64 s390_reset_flags;
 		/* KVM_EXIT_S390_UCONTROL */
 		struct {
@@ -466,6 +455,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_VMGEXIT */
+		struct kvm_user_vmgexit vmgexit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -532,43 +523,6 @@ struct kvm_translation {
 	__u8  pad[5];
 };
 
-/* for KVM_S390_MEM_OP */
-struct kvm_s390_mem_op {
-	/* in */
-	__u64 gaddr;		/* the guest address */
-	__u64 flags;		/* flags */
-	__u32 size;		/* amount of bytes */
-	__u32 op;		/* type of operation */
-	__u64 buf;		/* buffer in userspace */
-	union {
-		struct {
-			__u8 ar;	/* the access register number */
-			__u8 key;	/* access key, ignored if flag unset */
-			__u8 pad1[6];	/* ignored */
-			__u64 old_addr;	/* ignored if cmpxchg flag unset */
-		};
-		__u32 sida_offset; /* offset into the sida */
-		__u8 reserved[32]; /* ignored */
-	};
-};
-/* types for kvm_s390_mem_op->op */
-#define KVM_S390_MEMOP_LOGICAL_READ	0
-#define KVM_S390_MEMOP_LOGICAL_WRITE	1
-#define KVM_S390_MEMOP_SIDA_READ	2
-#define KVM_S390_MEMOP_SIDA_WRITE	3
-#define KVM_S390_MEMOP_ABSOLUTE_READ	4
-#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
-#define KVM_S390_MEMOP_ABSOLUTE_CMPXCHG	6
-
-/* flags for kvm_s390_mem_op->flags */
-#define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
-#define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
-#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
-
-/* flags specifying extension support via KVM_CAP_S390_MEM_OP_EXTENSION */
-#define KVM_S390_MEMOP_EXTENSION_CAP_BASE	(1 << 0)
-#define KVM_S390_MEMOP_EXTENSION_CAP_CMPXCHG	(1 << 1)
-
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
 	/* in */
@@ -633,124 +587,6 @@ struct kvm_mp_state {
 	__u32 mp_state;
 };
 
-struct kvm_s390_psw {
-	__u64 mask;
-	__u64 addr;
-};
-
-/* valid values for type in kvm_s390_interrupt */
-#define KVM_S390_SIGP_STOP		0xfffe0000u
-#define KVM_S390_PROGRAM_INT		0xfffe0001u
-#define KVM_S390_SIGP_SET_PREFIX	0xfffe0002u
-#define KVM_S390_RESTART		0xfffe0003u
-#define KVM_S390_INT_PFAULT_INIT	0xfffe0004u
-#define KVM_S390_INT_PFAULT_DONE	0xfffe0005u
-#define KVM_S390_MCHK			0xfffe1000u
-#define KVM_S390_INT_CLOCK_COMP		0xffff1004u
-#define KVM_S390_INT_CPU_TIMER		0xffff1005u
-#define KVM_S390_INT_VIRTIO		0xffff2603u
-#define KVM_S390_INT_SERVICE		0xffff2401u
-#define KVM_S390_INT_EMERGENCY		0xffff1201u
-#define KVM_S390_INT_EXTERNAL_CALL	0xffff1202u
-/* Anything below 0xfffe0000u is taken by INT_IO */
-#define KVM_S390_INT_IO(ai,cssid,ssid,schid)   \
-	(((schid)) |			       \
-	 ((ssid) << 16) |		       \
-	 ((cssid) << 18) |		       \
-	 ((ai) << 26))
-#define KVM_S390_INT_IO_MIN		0x00000000u
-#define KVM_S390_INT_IO_MAX		0xfffdffffu
-#define KVM_S390_INT_IO_AI_MASK		0x04000000u
-
-
-struct kvm_s390_interrupt {
-	__u32 type;
-	__u32 parm;
-	__u64 parm64;
-};
-
-struct kvm_s390_io_info {
-	__u16 subchannel_id;
-	__u16 subchannel_nr;
-	__u32 io_int_parm;
-	__u32 io_int_word;
-};
-
-struct kvm_s390_ext_info {
-	__u32 ext_params;
-	__u32 pad;
-	__u64 ext_params2;
-};
-
-struct kvm_s390_pgm_info {
-	__u64 trans_exc_code;
-	__u64 mon_code;
-	__u64 per_address;
-	__u32 data_exc_code;
-	__u16 code;
-	__u16 mon_class_nr;
-	__u8 per_code;
-	__u8 per_atmid;
-	__u8 exc_access_id;
-	__u8 per_access_id;
-	__u8 op_access_id;
-#define KVM_S390_PGM_FLAGS_ILC_VALID	0x01
-#define KVM_S390_PGM_FLAGS_ILC_0	0x02
-#define KVM_S390_PGM_FLAGS_ILC_1	0x04
-#define KVM_S390_PGM_FLAGS_ILC_MASK	0x06
-#define KVM_S390_PGM_FLAGS_NO_REWIND	0x08
-	__u8 flags;
-	__u8 pad[2];
-};
-
-struct kvm_s390_prefix_info {
-	__u32 address;
-};
-
-struct kvm_s390_extcall_info {
-	__u16 code;
-};
-
-struct kvm_s390_emerg_info {
-	__u16 code;
-};
-
-#define KVM_S390_STOP_FLAG_STORE_STATUS	0x01
-struct kvm_s390_stop_info {
-	__u32 flags;
-};
-
-struct kvm_s390_mchk_info {
-	__u64 cr14;
-	__u64 mcic;
-	__u64 failing_storage_address;
-	__u32 ext_damage_code;
-	__u32 pad;
-	__u8 fixed_logout[16];
-};
-
-struct kvm_s390_irq {
-	__u64 type;
-	union {
-		struct kvm_s390_io_info io;
-		struct kvm_s390_ext_info ext;
-		struct kvm_s390_pgm_info pgm;
-		struct kvm_s390_emerg_info emerg;
-		struct kvm_s390_extcall_info extcall;
-		struct kvm_s390_prefix_info prefix;
-		struct kvm_s390_stop_info stop;
-		struct kvm_s390_mchk_info mchk;
-		char reserved[64];
-	} u;
-};
-
-struct kvm_s390_irq_state {
-	__u64 buf;
-	__u32 flags;        /* will stay unused for compatibility reasons */
-	__u32 len;
-	__u32 reserved[4];  /* will stay unused for compatibility reasons */
-};
-
 /* for KVM_SET_GUEST_DEBUG */
 
 #define KVM_GUESTDBG_ENABLE		0x00000001
@@ -806,50 +642,6 @@ struct kvm_enable_cap {
 	__u8  pad[64];
 };
 
-/* for KVM_PPC_GET_PVINFO */
-
-#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
-
-struct kvm_ppc_pvinfo {
-	/* out */
-	__u32 flags;
-	__u32 hcall[4];
-	__u8  pad[108];
-};
-
-/* for KVM_PPC_GET_SMMU_INFO */
-#define KVM_PPC_PAGE_SIZES_MAX_SZ	8
-
-struct kvm_ppc_one_page_size {
-	__u32 page_shift;	/* Page shift (or 0) */
-	__u32 pte_enc;		/* Encoding in the HPTE (>>12) */
-};
-
-struct kvm_ppc_one_seg_page_size {
-	__u32 page_shift;	/* Base page shift of segment (or 0) */
-	__u32 slb_enc;		/* SLB encoding for BookS */
-	struct kvm_ppc_one_page_size enc[KVM_PPC_PAGE_SIZES_MAX_SZ];
-};
-
-#define KVM_PPC_PAGE_SIZES_REAL		0x00000001
-#define KVM_PPC_1T_SEGMENTS		0x00000002
-#define KVM_PPC_NO_HASH			0x00000004
-
-struct kvm_ppc_smmu_info {
-	__u64 flags;
-	__u32 slb_size;
-	__u16 data_keys;	/* # storage keys supported for data */
-	__u16 instr_keys;	/* # storage keys supported for instructions */
-	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
-};
-
-/* for KVM_PPC_RESIZE_HPT_{PREPARE,COMMIT} */
-struct kvm_ppc_resize_hpt {
-	__u64 flags;
-	__u32 shift;
-	__u32 pad;
-};
-
 #define KVMIO 0xAE
 
 /* machine type bits, to be used as argument to KVM_CREATE_VM */
@@ -919,9 +711,7 @@ struct kvm_ppc_resize_hpt {
 /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
 #define KVM_CAP_USER_NMI 22
-#ifdef __KVM_HAVE_GUEST_DEBUG
 #define KVM_CAP_SET_GUEST_DEBUG 23
-#endif
 #ifdef __KVM_HAVE_PIT
 #define KVM_CAP_REINJECT_CONTROL 24
 #endif
@@ -1152,8 +942,6 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
 
-#ifdef KVM_CAP_IRQ_ROUTING
-
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
 	__u32 pin;
@@ -1218,42 +1006,6 @@ struct kvm_irq_routing {
 	struct kvm_irq_routing_entry entries[];
 };
 
-#endif
-
-#ifdef KVM_CAP_MCE
-/* x86 MCE */
-struct kvm_x86_mce {
-	__u64 status;
-	__u64 addr;
-	__u64 misc;
-	__u64 mcg_status;
-	__u8 bank;
-	__u8 pad1[7];
-	__u64 pad2[3];
-};
-#endif
-
-#ifdef KVM_CAP_XEN_HVM
-#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
-#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
-#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
-#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
-#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
-#define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
-#define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
-#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
-
-struct kvm_xen_hvm_config {
-	__u32 flags;
-	__u32 msr;
-	__u64 blob_addr_32;
-	__u64 blob_addr_64;
-	__u8 blob_size_32;
-	__u8 blob_size_64;
-	__u8 pad2[30];
-};
-#endif
-
 #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
 /*
  * Available with KVM_CAP_IRQFD_RESAMPLE
@@ -1438,11 +1190,6 @@ struct kvm_vfio_spapr_tce {
 					 struct kvm_userspace_memory_region2)
 
 /* enable ucontrol for s390 */
-struct kvm_s390_ucas_mapping {
-	__u64 user_addr;
-	__u64 vcpu_addr;
-	__u64 length;
-};
 #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
 #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
 #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
@@ -1637,89 +1384,6 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
-struct kvm_s390_pv_sec_parm {
-	__u64 origin;
-	__u64 length;
-};
-
-struct kvm_s390_pv_unp {
-	__u64 addr;
-	__u64 size;
-	__u64 tweak;
-};
-
-enum pv_cmd_dmp_id {
-	KVM_PV_DUMP_INIT,
-	KVM_PV_DUMP_CONFIG_STOR_STATE,
-	KVM_PV_DUMP_COMPLETE,
-	KVM_PV_DUMP_CPU,
-};
-
-struct kvm_s390_pv_dmp {
-	__u64 subcmd;
-	__u64 buff_addr;
-	__u64 buff_len;
-	__u64 gaddr;		/* For dump storage state */
-	__u64 reserved[4];
-};
-
-enum pv_cmd_info_id {
-	KVM_PV_INFO_VM,
-	KVM_PV_INFO_DUMP,
-};
-
-struct kvm_s390_pv_info_dump {
-	__u64 dump_cpu_buffer_len;
-	__u64 dump_config_mem_buffer_per_1m;
-	__u64 dump_config_finalize_len;
-};
-
-struct kvm_s390_pv_info_vm {
-	__u64 inst_calls_list[4];
-	__u64 max_cpus;
-	__u64 max_guests;
-	__u64 max_guest_addr;
-	__u64 feature_indication;
-};
-
-struct kvm_s390_pv_info_header {
-	__u32 id;
-	__u32 len_max;
-	__u32 len_written;
-	__u32 reserved;
-};
-
-struct kvm_s390_pv_info {
-	struct kvm_s390_pv_info_header header;
-	union {
-		struct kvm_s390_pv_info_dump dump;
-		struct kvm_s390_pv_info_vm vm;
-	};
-};
-
-enum pv_cmd_id {
-	KVM_PV_ENABLE,
-	KVM_PV_DISABLE,
-	KVM_PV_SET_SEC_PARMS,
-	KVM_PV_UNPACK,
-	KVM_PV_VERIFY,
-	KVM_PV_PREP_RESET,
-	KVM_PV_UNSHARE_ALL,
-	KVM_PV_INFO,
-	KVM_PV_DUMP,
-	KVM_PV_ASYNC_CLEANUP_PREPARE,
-	KVM_PV_ASYNC_CLEANUP_PERFORM,
-};
-
-struct kvm_pv_cmd {
-	__u32 cmd;	/* Command to be executed */
-	__u16 rc;	/* Ultravisor return code */
-	__u16 rrc;	/* Ultravisor return reason code */
-	__u64 data;	/* Data or address */
-	__u32 flags;    /* flags for future extensions. Must be 0 for now */
-	__u32 reserved[3];
-};
-
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
@@ -1733,58 +1397,6 @@ struct kvm_pv_cmd {
 #define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
 #define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
 
-struct kvm_xen_hvm_attr {
-	__u16 type;
-	__u16 pad[3];
-	union {
-		__u8 long_mode;
-		__u8 vector;
-		__u8 runstate_update_flag;
-		struct {
-			__u64 gfn;
-#define KVM_XEN_INVALID_GFN ((__u64)-1)
-		} shared_info;
-		struct {
-			__u32 send_port;
-			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
-			__u32 flags;
-#define KVM_XEN_EVTCHN_DEASSIGN		(1 << 0)
-#define KVM_XEN_EVTCHN_UPDATE		(1 << 1)
-#define KVM_XEN_EVTCHN_RESET		(1 << 2)
-			/*
-			 * Events sent by the guest are either looped back to
-			 * the guest itself (potentially on a different port#)
-			 * or signalled via an eventfd.
-			 */
-			union {
-				struct {
-					__u32 port;
-					__u32 vcpu;
-					__u32 priority;
-				} port;
-				struct {
-					__u32 port; /* Zero for eventfd */
-					__s32 fd;
-				} eventfd;
-				__u32 padding[4];
-			} deliver;
-		} evtchn;
-		__u32 xen_version;
-		__u64 pad[8];
-	} u;
-};
-
-
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
-#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
-#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
-#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
-#define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
-#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
-#define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
-
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
 #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
@@ -1795,242 +1407,6 @@ struct kvm_xen_hvm_attr {
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
-struct kvm_xen_vcpu_attr {
-	__u16 type;
-	__u16 pad[3];
-	union {
-		__u64 gpa;
-#define KVM_XEN_INVALID_GPA ((__u64)-1)
-		__u64 pad[8];
-		struct {
-			__u64 state;
-			__u64 state_entry_time;
-			__u64 time_running;
-			__u64 time_runnable;
-			__u64 time_blocked;
-			__u64 time_offline;
-		} runstate;
-		__u32 vcpu_id;
-		struct {
-			__u32 port;
-			__u32 priority;
-			__u64 expires_ns;
-		} timer;
-		__u8 vector;
-	} u;
-};
-
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
-#define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
-#define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
-
-/* Secure Encrypted Virtualization command */
-enum sev_cmd_id {
-	/* Guest initialization commands */
-	KVM_SEV_INIT = 0,
-	KVM_SEV_ES_INIT,
-	/* Guest launch commands */
-	KVM_SEV_LAUNCH_START,
-	KVM_SEV_LAUNCH_UPDATE_DATA,
-	KVM_SEV_LAUNCH_UPDATE_VMSA,
-	KVM_SEV_LAUNCH_SECRET,
-	KVM_SEV_LAUNCH_MEASURE,
-	KVM_SEV_LAUNCH_FINISH,
-	/* Guest migration commands (outgoing) */
-	KVM_SEV_SEND_START,
-	KVM_SEV_SEND_UPDATE_DATA,
-	KVM_SEV_SEND_UPDATE_VMSA,
-	KVM_SEV_SEND_FINISH,
-	/* Guest migration commands (incoming) */
-	KVM_SEV_RECEIVE_START,
-	KVM_SEV_RECEIVE_UPDATE_DATA,
-	KVM_SEV_RECEIVE_UPDATE_VMSA,
-	KVM_SEV_RECEIVE_FINISH,
-	/* Guest status and debug commands */
-	KVM_SEV_GUEST_STATUS,
-	KVM_SEV_DBG_DECRYPT,
-	KVM_SEV_DBG_ENCRYPT,
-	/* Guest certificates commands */
-	KVM_SEV_CERT_EXPORT,
-	/* Attestation report */
-	KVM_SEV_GET_ATTESTATION_REPORT,
-	/* Guest Migration Extension */
-	KVM_SEV_SEND_CANCEL,
-
-	KVM_SEV_NR_MAX,
-};
-
-struct kvm_sev_cmd {
-	__u32 id;
-	__u64 data;
-	__u32 error;
-	__u32 sev_fd;
-};
-
-struct kvm_sev_launch_start {
-	__u32 handle;
-	__u32 policy;
-	__u64 dh_uaddr;
-	__u32 dh_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_launch_update_data {
-	__u64 uaddr;
-	__u32 len;
-};
-
-
-struct kvm_sev_launch_secret {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-struct kvm_sev_launch_measure {
-	__u64 uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_guest_status {
-	__u32 handle;
-	__u32 policy;
-	__u32 state;
-};
-
-struct kvm_sev_dbg {
-	__u64 src_uaddr;
-	__u64 dst_uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_attestation_report {
-	__u8 mnonce[16];
-	__u64 uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_send_start {
-	__u32 policy;
-	__u64 pdh_cert_uaddr;
-	__u32 pdh_cert_len;
-	__u64 plat_certs_uaddr;
-	__u32 plat_certs_len;
-	__u64 amd_certs_uaddr;
-	__u32 amd_certs_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_send_update_data {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-struct kvm_sev_receive_start {
-	__u32 handle;
-	__u32 policy;
-	__u64 pdh_uaddr;
-	__u32 pdh_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_receive_update_data {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-#define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
-#define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
-#define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-
-struct kvm_assigned_pci_dev {
-	__u32 assigned_dev_id;
-	__u32 busnr;
-	__u32 devfn;
-	__u32 flags;
-	__u32 segnr;
-	union {
-		__u32 reserved[11];
-	};
-};
-
-#define KVM_DEV_IRQ_HOST_INTX    (1 << 0)
-#define KVM_DEV_IRQ_HOST_MSI     (1 << 1)
-#define KVM_DEV_IRQ_HOST_MSIX    (1 << 2)
-
-#define KVM_DEV_IRQ_GUEST_INTX   (1 << 8)
-#define KVM_DEV_IRQ_GUEST_MSI    (1 << 9)
-#define KVM_DEV_IRQ_GUEST_MSIX   (1 << 10)
-
-#define KVM_DEV_IRQ_HOST_MASK	 0x00ff
-#define KVM_DEV_IRQ_GUEST_MASK   0xff00
-
-struct kvm_assigned_irq {
-	__u32 assigned_dev_id;
-	__u32 host_irq; /* ignored (legacy field) */
-	__u32 guest_irq;
-	__u32 flags;
-	union {
-		__u32 reserved[12];
-	};
-};
-
-struct kvm_assigned_msix_nr {
-	__u32 assigned_dev_id;
-	__u16 entry_nr;
-	__u16 padding;
-};
-
-#define KVM_MAX_MSIX_PER_DEV		256
-struct kvm_assigned_msix_entry {
-	__u32 assigned_dev_id;
-	__u32 gsi;
-	__u16 entry; /* The index of entry in the MSI-X table */
-	__u16 padding[3];
-};
-
-#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
-
-/* Available with KVM_CAP_ARM_USER_IRQ */
-
-/* Bits for run->s.regs.device_irq_level */
-#define KVM_ARM_DEV_EL1_VTIMER		(1 << 0)
-#define KVM_ARM_DEV_EL1_PTIMER		(1 << 1)
-#define KVM_ARM_DEV_PMU			(1 << 2)
-
-struct kvm_hyperv_eventfd {
-	__u32 conn_id;
-	__s32 fd;
-	__u32 flags;
-	__u32 padding[3];
-};
-
-#define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
-#define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
-
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
@@ -2176,33 +1552,6 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_S390_ZPCI_OP */
 #define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd1, struct kvm_s390_zpci_op)
 
-struct kvm_s390_zpci_op {
-	/* in */
-	__u32 fh;               /* target device */
-	__u8  op;               /* operation to perform */
-	__u8  pad[3];
-	union {
-		/* for KVM_S390_ZPCIOP_REG_AEN */
-		struct {
-			__u64 ibv;      /* Guest addr of interrupt bit vector */
-			__u64 sb;       /* Guest addr of summary bit */
-			__u32 flags;
-			__u32 noi;      /* Number of interrupts */
-			__u8 isc;       /* Guest interrupt subclass */
-			__u8 sbo;       /* Offset of guest summary bit vector */
-			__u16 pad;
-		} reg_aen;
-		__u64 reserved[8];
-	} u;
-};
-
-/* types for kvm_s390_zpci_op->op */
-#define KVM_S390_ZPCIOP_REG_AEN                0
-#define KVM_S390_ZPCIOP_DEREG_AEN      1
-
-/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
-#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
-
 /* Available with KVM_CAP_MEMORY_ATTRIBUTES */
 #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
 
diff --git a/linux-headers/linux/psp-sev.h b/linux-headers/linux/psp-sev.h
index bcb21339ee..3095af51e5 100644
--- a/linux-headers/linux/psp-sev.h
+++ b/linux-headers/linux/psp-sev.h
@@ -28,6 +28,11 @@ enum {
 	SEV_PEK_CERT_IMPORT,
 	SEV_GET_ID,	/* This command is deprecated, use SEV_GET_ID2 */
 	SEV_GET_ID2,
+	SNP_PLATFORM_STATUS,
+	SNP_COMMIT,
+	SNP_SET_CONFIG,
+	SNP_SET_CONFIG_START,
+	SNP_SET_CONFIG_END,
 
 	SEV_MAX,
 };
@@ -69,6 +74,12 @@ typedef enum {
 	SEV_RET_RESOURCE_LIMIT,
 	SEV_RET_SECURE_DATA_INVALID,
 	SEV_RET_INVALID_KEY = 0x27,
+	SEV_RET_INVALID_PAGE_SIZE,
+	SEV_RET_INVALID_PAGE_STATE,
+	SEV_RET_INVALID_MDATA_ENTRY,
+	SEV_RET_INVALID_PAGE_OWNER,
+	SEV_RET_INVALID_PAGE_AEAD_OFLOW,
+	SEV_RET_RMP_INIT_REQUIRED,
 	SEV_RET_MAX,
 } sev_ret_code;
 
@@ -155,6 +166,66 @@ struct sev_user_data_get_id2 {
 	__u32 length;				/* In/Out */
 } __attribute__((packed));
 
+/**
+ * struct sev_user_data_snp_status - SNP status
+ *
+ * @api_major: API major version
+ * @api_minor: API minor version
+ * @state: current platform state
+ * @is_rmp_initialized: whether RMP is initialized or not
+ * @rsvd: reserved
+ * @build_id: firmware build id for the API version
+ * @mask_chip_id: whether chip id is present in attestation reports or not
+ * @mask_chip_key: whether attestation reports are signed or not
+ * @vlek_en: VLEK (Version Loaded Endorsement Key) hashstick is loaded
+ * @rsvd1: reserved
+ * @guest_count: the number of guest currently managed by the firmware
+ * @current_tcb_version: current TCB version
+ * @reported_tcb_version: reported TCB version
+ */
+struct sev_user_data_snp_status {
+	__u8 api_major;			/* Out */
+	__u8 api_minor;			/* Out */
+	__u8 state;			/* Out */
+	__u8 is_rmp_initialized:1;	/* Out */
+	__u8 rsvd:7;
+	__u32 build_id;			/* Out */
+	__u32 mask_chip_id:1;		/* Out */
+	__u32 mask_chip_key:1;		/* Out */
+	__u32 vlek_en:1;		/* Out */
+	__u32 rsvd1:29;
+	__u32 guest_count;		/* Out */
+	__u64 current_tcb_version;	/* Out */
+	__u64 reported_tcb_version;	/* Out */
+} __attribute__((packed));
+
+/**
+ * struct sev_user_data_snp_config - system wide configuration value for SNP.
+ *
+ * @reported_tcb: the TCB version to report in the guest attestation report.
+ * @mask_chip_id: whether chip id is present in attestation reports or not
+ * @mask_chip_key: whether attestation reports are signed or not
+ * @rsvd: reserved
+ * @rsvd1: reserved
+ */
+struct sev_user_data_snp_config {
+	__u64 reported_tcb  ;   /* In */
+	__u32 mask_chip_id:1;   /* In */
+	__u32 mask_chip_key:1;  /* In */
+	__u32 rsvd:30;          /* In */
+	__u8 rsvd1[52];
+} __attribute__((packed));
+
+/**
+ * struct sev_user_data_snp_config_transaction - metadata for config transactions
+ *
+ * @id: the ID of the transaction started/ended by a call to SNP_SET_CONFIG_START
+ *	or SNP_SET_CONFIG_END, respectively.
+ */
+struct sev_user_data_snp_config_transaction {
+	__u64 id;		/* Out */
+} __attribute__((packed));
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.25.1


