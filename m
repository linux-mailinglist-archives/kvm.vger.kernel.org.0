Return-Path: <kvm+bounces-59869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B50BBD1ABB
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 09F6B4ECC5A
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 06:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07B9F2E2EF3;
	Mon, 13 Oct 2025 06:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZCIIQYko"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011002.outbound.protection.outlook.com [40.93.194.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47992E36F1
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 06:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336757; cv=fail; b=kRB++Q4ohEhKtUbpump4BMCgYvJGyyCBux/RvNxBnKAg6NVDU6XV0JOdtpJM/sW+nmGQO9Kxc78tQYVxphUipgKUezAlj4mL6qW6SOMj9SEvUBHhv0c8uT8ZsTgYRQCCs2/78hl5uInajV7e4Sz9XDrfwOteqH/2D7MSdWgM/OA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336757; c=relaxed/simple;
	bh=DLuvp+8ZmqwiyMT4McU4PEOVy0rRSuRhNWXbBWZgB/w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GlC9Snc4CFc5iTJwqUYUPLPxKq/iFWpMut39giE5/ZBEQMAfIBTtLaQjacVaYwsMfAJuu4sA/urXmIZcaYo3g0Sxq5aMEGObZf9S9yhDHUuMe5onggAnTofQ8dMctSwNctY2hcEPzfseZXUrob15QhdvavOQdPd2gqyDctNMBXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZCIIQYko; arc=fail smtp.client-ip=40.93.194.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=okjrQ43GjdtMd+bX7hOoGxbjr/lBsygVWZDyIXRAEG3SzXNwnNQKRYviZHB89aQkJdb/1mGtFmvUvWb7nLIr2eXYZKJq4vRXht29BcBvPkZMMqUFh5i1GKSalAOIHg1mCZaARavaEJzNZeWiPq8ltLZaOUUqqZG2geQ8WKbzww4gfZPxUklc2jRu/foyxCvrVWqvASjIOnG/6ptScqE6rUfw1aZ7BTWAijDbnuLKWLtsGAwTn/OTNBXVVTWHm7zQn7D8JmaExaRiLa3j20vmt6YNKxWrEseCk/giwKIbeGBLi5IqCCHC+QLwhiXXGC/I4OIp0g4fY/iVYwjMXsGxfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOF1B9Z8W+yuSLaAK3jRZixxHUdal2LrE+aMyow0cuk=;
 b=X6PEWe3YJcAboJSRndO5bC1M5W/xazU64m5l6H9DFw1kmHNhrHJ1kdLDnU2zxoHBqH0QT/fvbDP6hk62mcXZlU6uKkQeM+4jgn9L/H31qddyor/D3qcdxZwH6skPB7oW39oj4tD3gjIQaR3FDSqnb3M3JxBVtGrFUEHY+wuK9CFMAA/Gt19Koqpx/XUcYhrhj6D7At0VH9fDWA01VmfSXvBbv7hK9yPfDD8+ct1aVwYsWGK28sCkouadSaOMJg1EJCeLDxcHINzUfRK4fe/i0Kxbn9CbWRur2B+6gq+vdyYttgrWG7Eh4CQBKbTVXeEmozSRcfZAwqQ8wFMv5XWt1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOF1B9Z8W+yuSLaAK3jRZixxHUdal2LrE+aMyow0cuk=;
 b=ZCIIQYkoSEYTl0y5PafyUd4rMJkl5LuZv8qsH5FkGsqdoX9LL9KIv8UjUdbH95n9DXT6REsklbaKNsdyhpDXRtt1JNJxoOKolZ2id1bmryR40lzU3rszv1s5hn+dHFAOl4cNM4rZzMdbNvzjlql/0UwiuUX19lb9nK/O9GBYFEQ=
Received: from CH0P221CA0026.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::6)
 by DS0PR12MB8042.namprd12.prod.outlook.com (2603:10b6:8:141::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 06:25:49 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:610:11d:cafe::da) by CH0P221CA0026.outlook.office365.com
 (2603:10b6:610:11d::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.13 via Frontend Transport; Mon,
 13 Oct 2025 06:25:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 06:25:48 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 23:25:44 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v4 1/7] KVM: x86: Carve out PML flush routine
Date: Mon, 13 Oct 2025 06:25:09 +0000
Message-ID: <20251013062515.3712430-2-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251013062515.3712430-1-nikunj@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|DS0PR12MB8042:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cdb6dae-32ec-424f-3f9b-08de0a2159d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0t7oE6YxAaBaNMWaE9AgA60eyJcNSfO4t/gff8luwuvVtzmvR124JzF4twrA?=
 =?us-ascii?Q?QZWbUN8XE5gwpOVhEgRu9FxijUnMQ9gGl3E/H1Ni0vp/xU8ELU5qMbnaR1pg?=
 =?us-ascii?Q?+g/NN/K1ZbaVuJZiesGJOx4pyE1BVVaoY4cFikvblsIGJT3bRrsto1JrStZ7?=
 =?us-ascii?Q?KVsKbcUez53qyZ2embvdb98XE5K7qVAXk42nrtm39CMPOl7QEEVWT9MzX6N+?=
 =?us-ascii?Q?xAQkFp4gNHvygpRlnorEUCfon6z5qt3phje8Z5SPoXgcqwEFdrauz62rhFdE?=
 =?us-ascii?Q?H9u0kHw8UcH5VU7/GWGHqsQtknasyM3z27MIzPBuN2Gf6jxzNhu3FloMPerM?=
 =?us-ascii?Q?DIq5KzLbYau3dfbvDd2LlQ+cHXV8TQIncA9vvRVMSvWTVddVAzED/7AoOuwA?=
 =?us-ascii?Q?J62heH5Cl7DTDN0C+fVXxn10ZUzNhZxzdZq29FMqwi408/HVJ7uvB0jMVicm?=
 =?us-ascii?Q?Dqz4uX2PBltMIIsfXneJmP5giCERFfVqBnfnxGUlJ6YlpFhHet3JaiUEdCKT?=
 =?us-ascii?Q?OBOlBq+4IfTnn9X8gCG26w5G4g1Q8WIqLtcGUFHCLeUMW20Lw5YFuUoMBH9Z?=
 =?us-ascii?Q?rh+vQ/5pY1rBTB4bIvRBEphL5DJPTmp53gbGMnPbDjKNIk43ZA/yMMTcGRqs?=
 =?us-ascii?Q?QfSr0kVdVz6gjBvoxEXo6JvAMp7KTSu+QVev7PwPIcmzp9RlB7uCoNwr99qZ?=
 =?us-ascii?Q?cOyBps8hfwx7vBmQjWS/ehiSFR6bsf2n9oTshXHvfdrTLERaRZ0exUYBHCat?=
 =?us-ascii?Q?kxomNph9aLhYANl5zt75vY4TQ00rob/QSAVZoe17DMYKBC5kCpUcyclxOWIC?=
 =?us-ascii?Q?FBgOqzbqHQ1yplTtG5pkEdUM9+xjc0gCyIYYvIAVIPnSKlFbILfbMp6hPiqj?=
 =?us-ascii?Q?ANo62IZOyXRSIdbVEIMNZNnx0VeLvZzXEUfcoZswq8/ZPEXHOknne/5IEHlP?=
 =?us-ascii?Q?/AJY84nSqxnJdvyNoK4fMGmliqCydGcWXR1t6H3/QojReoMM/0dWKiJYWh2Q?=
 =?us-ascii?Q?ZBYBGl9p6PO0z+TQ+7r77VFZublxTduAXJQ7PBqaZWVrHnkyRdhh0Fc42DJ+?=
 =?us-ascii?Q?4XK5YTBbLOo1A+OJMdep3Gc7b5nqUn7kzZeYQfEFr3WHKuX/YFji3KYBg9QP?=
 =?us-ascii?Q?rWZzhSICZ3luH3LzWjb7PLd20dDo8pDcL9qwmZuGGSIH8aqiyPHmh8Jwx6nI?=
 =?us-ascii?Q?dVQxGhuquyoSqRJC9ufGJVk+br4CjKe6aJS4lYke3KSW3wiuixRPXEBC8MbJ?=
 =?us-ascii?Q?sJCThoo3TFFR+41vZX8l8m8Ha2+wmht8G4AOcHifTjob5LgniMBA/9l5YrMR?=
 =?us-ascii?Q?8nJUlAHC/8UKwbqybo4glkfuvHCNx6l9I+Hm6zZRJH8NK+GYGqp7kVEajB77?=
 =?us-ascii?Q?U6z8rk2HGhcT7FzQg3TT4qOHK0rhYgbV0PbJhlUomg2Wy7j62AXMyTbf4gpK?=
 =?us-ascii?Q?LWu2wIhxlJw6rZ/QdYDutDP3P2HpCMmHsfJ40FgXnMGPYBS4KUEzr/3hYZpv?=
 =?us-ascii?Q?0X1NjQ+W7iYOrBe/gkgaaYQU2BSo7VGNO6Uk1BH+o7ku9x+7t7QdUJQFRHlM?=
 =?us-ascii?Q?ZeriI8d2KJCG6Nbf154=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 06:25:48.9456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cdb6dae-32ec-424f-3f9b-08de0a2159d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8042

Move the PML (Page Modification Logging) buffer flushing logic from
VMX-specific code to common x86 KVM code to enable reuse by SVM and avoid
code duplication.

The AMD SVM PML implementations share the same behavior as VMX PML:
 1) The PML buffer is a 4K page with 512 entries
 2) Hardware records dirty GPAs in reverse order (from index 511 to 0)
 3) Hardware clears bits 11:0 when recording GPAs

The PML constants (PML_LOG_NR_ENTRIES and PML_HEAD_INDEX) are moved from
vmx.h to x86.h to make them available to both VMX and SVM.

No functional change intended for VMX, except tone down the WARN_ON() to
WARN_ON_ONCE() for the page alignment check. If hardware exhibits this
behavior once, it's likely to occur repeatedly, so use WARN_ON_ONCE() to
avoid log flooding while still capturing the unexpected condition.

The refactoring prepares for SVM to leverage the same PML flushing
implementation.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/vmx/vmx.c | 26 ++------------------------
 arch/x86/kvm/vmx/vmx.h |  5 -----
 arch/x86/kvm/x86.c     | 31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |  8 ++++++++
 4 files changed, 41 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 546272a5d34d..db1379cffbcb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6206,37 +6206,15 @@ static void vmx_destroy_pml_buffer(struct vcpu_vmx *vmx)
 static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u16 pml_idx, pml_tail_index;
-	u64 *pml_buf;
-	int i;
+	u16 pml_idx;
 
 	pml_idx = vmcs_read16(GUEST_PML_INDEX);
 
 	/* Do nothing if PML buffer is empty */
 	if (pml_idx == PML_HEAD_INDEX)
 		return;
-	/*
-	 * PML index always points to the next available PML buffer entity
-	 * unless PML log has just overflowed.
-	 */
-	pml_tail_index = (pml_idx >= PML_LOG_NR_ENTRIES) ? 0 : pml_idx + 1;
 
-	/*
-	 * PML log is written backwards: the CPU first writes the entry 511
-	 * then the entry 510, and so on.
-	 *
-	 * Read the entries in the same order they were written, to ensure that
-	 * the dirty ring is filled in the same order the CPU wrote them.
-	 */
-	pml_buf = page_address(vmx->pml_pg);
-
-	for (i = PML_HEAD_INDEX; i >= pml_tail_index; i--) {
-		u64 gpa;
-
-		gpa = pml_buf[i];
-		WARN_ON(gpa & (PAGE_SIZE - 1));
-		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
-	}
+	kvm_flush_pml_buffer(vcpu, vmx->pml_pg, pml_idx);
 
 	/* reset PML index */
 	vmcs_write16(GUEST_PML_INDEX, PML_HEAD_INDEX);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ea93121029f9..fe9d2b10f4be 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -272,11 +272,6 @@ struct vcpu_vmx {
 	unsigned int ple_window;
 	bool ple_window_dirty;
 
-	/* Support for PML */
-#define PML_LOG_NR_ENTRIES	512
-	/* PML is written backwards: this is the first entry written by the CPU */
-#define PML_HEAD_INDEX		(PML_LOG_NR_ENTRIES-1)
-
 	struct page *pml_pg;
 
 	/* apic deadline value in host tsc */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b8138bd4857..732d8a4b7dff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6737,6 +6737,37 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 		kvm_vcpu_kick(vcpu);
 }
 
+void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_page, u16 pml_idx)
+{
+	u16 pml_tail_index;
+	u64 *pml_buf;
+	int i;
+
+	/*
+	 * PML index always points to the next available PML buffer entity
+	 * unless PML log has just overflowed.
+	 */
+	pml_tail_index = (pml_idx >= PML_LOG_NR_ENTRIES) ? 0 : pml_idx + 1;
+
+	/*
+	 * PML log is written backwards: the CPU first writes the entry 511
+	 * then the entry 510, and so on.
+	 *
+	 * Read the entries in the same order they were written, to ensure that
+	 * the dirty ring is filled in the same order the CPU wrote them.
+	 */
+	pml_buf = page_address(pml_page);
+
+	for (i = PML_HEAD_INDEX; i >= pml_tail_index; i--) {
+		u64 gpa;
+
+		gpa = pml_buf[i];
+		WARN_ON_ONCE(gpa & (PAGE_SIZE - 1));
+		kvm_vcpu_mark_page_dirty(vcpu, gpa >> PAGE_SHIFT);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_flush_pml_buffer);
+
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f3dc77f006f9..199d39492df8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -737,4 +737,12 @@ static inline bool kvm_is_valid_u_s_cet(struct kvm_vcpu *vcpu, u64 data)
 
 	return true;
 }
+
+/* Support for PML */
+#define PML_LOG_NR_ENTRIES	512
+/* PML is written backwards: this is the first entry written by the CPU */
+#define PML_HEAD_INDEX		(PML_LOG_NR_ENTRIES-1)
+
+void kvm_flush_pml_buffer(struct kvm_vcpu *vcpu, struct page *pml_pg, u16 pml_idx);
+
 #endif
-- 
2.48.1


