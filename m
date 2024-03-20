Return-Path: <kvm+bounces-12220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37684880D45
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:42:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80C8CB21D8F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664D439846;
	Wed, 20 Mar 2024 08:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="16Jo6+Kr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945FC22079
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924094; cv=fail; b=bYLaVfN4E5yDJbiE915Y4ok/4RSNmc85eH/JHOSwOlIEYv4c/sk6XJwNJqwhsRFLt+8fqvv81KbcWekeNeBJrKGnLsIjRYYw/RouVYZde7hKTF8+KxwoNeQ2R2yjm0DMVflmQjMJ/ckRf1qyNZcTYr07Gbuz4/L1ymACobUDgQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924094; c=relaxed/simple;
	bh=DtF/yOfQ5gWkXYix/40+KWfGIDDbVj4/Sij4PsMr0E4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X37cbniTqtdwl22/1Xa7bhk1SD1tj93CcntHtQjn4r0JMsWSRaFeWT/djTEf7+qw9TF8lqRJF1p5WRFZxz2kJF9kefsmSi2Bo/Cje/vujcMm8LmED++dI8TcArc1dvhAFPc/p3i40oMkJL6ViET4vwefhpRyO8V9GWaIiuqByFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=16Jo6+Kr; arc=fail smtp.client-ip=40.107.237.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nydfsR9nHYnLp9EV8UmoqiDHBVVKRCQ69K3o2UgkShHFBvelK4Z87F2gCFIvpCJSQ420INB/WmpZr+/13QULUmvip/dhUM4t+n6O1GEHGxpcGGSjhLlhTpQ0qpnJdgx/K6rIWzSjB6bi8YmMQTeZFPp06WKdLpee0nThKizzQ9WOeXfRagxIufA9CvPQtkevoUnpTtypivcKMJKKJNpTWbIAdzstbzA6g2mA9TQn7H1cZ21s0s0Nup3eLvaohRXoRm1Y+bG5dM3/FQnZ1NVPFyo+BO4qxw8wyRpglaBH3AaEUNJE5bFmgi5uD0geFDmHnGSsVmp8bN447wy8PCpsTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQuSWpKvcj4+ThgJHs6oUIdcE/w2mjZN6UvE7iEMxHA=;
 b=NcHBAWmORP3wRIHave7BpxQ/++zsLaIbAqFLVfTaQv25euT1S1HAPG1ETgHY8PBWlRfB/G5CR7PlxUEA2qx5Yoqnhej2IBigp0GBI4kgudItirRS/k1VW8/FVx1PiHGFnus2LBTY832dmpS77lk/g3gayo5UxcuVDQIU7w3TJj1aVn6gE8aRd3Js/dPgw/yAiMM7z6qNnWd9LiajI7gX/lh/pUAuk+Zrh0C8o4CcAMiGXotyfJ2b6Eqi4y0WgBeBumx7u854lCCPmza/AsUBBExy8/FPePKt3yPzxbvoeD/pYkNcgOhi84tFQKazT2jT6x7udqp4fF+SWAd++/3ATA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQuSWpKvcj4+ThgJHs6oUIdcE/w2mjZN6UvE7iEMxHA=;
 b=16Jo6+Kr0DMskBhsROQKFF/an4MMQiHuY+ZrpjPT7W7xd+6vJhGxW7rsTLp38GUDbRbroIGyCBynhf54MZHPKTl+kvTolLAC8pgaZxBM87+DDN5Pr1P/VLjGDbwsjepNI1DcMnbPT1+Uf3f5kwB+fC4XsEruK4XjhdVYBC2zqzg=
Received: from SA1PR02CA0022.namprd02.prod.outlook.com (2603:10b6:806:2cf::29)
 by LV8PR12MB9133.namprd12.prod.outlook.com (2603:10b6:408:188::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28; Wed, 20 Mar
 2024 08:41:30 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:806:2cf:cafe::b3) by SA1PR02CA0022.outlook.office365.com
 (2603:10b6:806:2cf::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:41:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:41:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:41:28 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 10/49] kvm: Introduce support for memory_attributes
Date: Wed, 20 Mar 2024 03:39:06 -0500
Message-ID: <20240320083945.991426-11-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|LV8PR12MB9133:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a896c60-b326-4287-707b-08dc48b989a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vCEhPJuIetAjTxcR0qlVNHmEFwvu4yY63xa40DbpgSNvGc2dyoN/0oBCGEsERq7U7S3F8er90K0A1PQ7y4rKSgol61DD0ZAwrNfXhBG1Eta1PmrsQFDeXz7saw6vn5qi8ZcvRSdDP9s94CO004ARsI0e0fgySZ2GUVc90gKeOAW0AUrZ3Y3GHi6AqOcBrT4ILnywCnnYLPgHkLAMO5EwCGAvv0shS6eDxzVJI+hrtOD3KYPTVjCpnU8twmuZ8U8pDZHTXR3IZiG3rryxODPj0GB5dMPQ+cidWSbf05eydXGaSnJBsZkRYjZWPiHF3vSJMT1IgbsgpHKpZqpaIIqPqd8dNgosndQxWILNRWZ56+eD2PfcnGy8KoB6VM2OMO4tKnNNqmZM6a+Vo8hQ9sAfny8Yvb1oVZFw+0q9l7SREmDen2GRzr6APeksraH8jy8mhwP+JGuE5vNHmlaqdjtL1OEWvn2fSua5ggmD+xu2xk/CwEqU9I5V8VsbQRSaVxKv4Y62WCyrvH3bCebyNXtd5AEAwWaAeFru05/ICp0PLT/pJBuNIDuRuMp4RDrfArtAhO1RI+eG217j2fuVG1fSOll3hOEhNhVVeNPh5tgOxRzqScAfrnZ4j1mcoAZinHiobNQh6lmPHIKhyKWFTClqMRBBiejnjPWOJB+u8I9OhdEuxwlPQYn8W9cZcLTLjpzO4BYGBBOS6R41S5uEtNA091boZPBHdpg2l1RrBvKKTy85/1w7+4u8dbV2iV48NyNy
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:41:29.4719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a896c60-b326-4287-707b-08dc48b989a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9133

From: Xiaoyao Li <xiaoyao.li@intel.com>

Introduce the helper functions to set the attributes of a range of
memory to private or shared.

This is necessary to notify KVM the private/shared attribute of each gpa
range. KVM needs the information to decide the GPA needs to be mapped at
hva-based shared memory or guest_memfd based private memory.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v4:
- move the check of kvm_supported_memory_attributes to the common
  kvm_set_memory_attributes(); (Wang Wei)
- change warn_report() to error_report() in kvm_set_memory_attributes()
  and drop the __func__; (Daniel)

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 accel/kvm/kvm-all.c  | 44 ++++++++++++++++++++++++++++++++++++++++++++
 include/sysemu/kvm.h |  3 +++
 2 files changed, 47 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index e83429b31e..df7a32735a 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -92,6 +92,7 @@ static bool kvm_has_guest_debug;
 static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
 static bool kvm_guest_memfd_supported;
+static uint64_t kvm_supported_memory_attributes;
 static hwaddr kvm_max_slot_size = ~0;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
@@ -1304,6 +1305,46 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
     kvm_max_slot_size = max_slot_size;
 }
 
+static int kvm_set_memory_attributes(hwaddr start, hwaddr size, uint64_t attr)
+{
+    struct kvm_memory_attributes attrs;
+    int r;
+
+    if (kvm_supported_memory_attributes == 0) {
+        error_report("No memory attribute supported by KVM\n");
+        return -EINVAL;
+    }
+
+    if ((attr & kvm_supported_memory_attributes) != attr) {
+        error_report("memory attribute 0x%lx not supported by KVM,"
+                     " supported bits are 0x%lx\n",
+                     attr, kvm_supported_memory_attributes);
+        return -EINVAL;
+    }
+
+    attrs.attributes = attr;
+    attrs.address = start;
+    attrs.size = size;
+    attrs.flags = 0;
+
+    r = kvm_vm_ioctl(kvm_state, KVM_SET_MEMORY_ATTRIBUTES, &attrs);
+    if (r) {
+        error_report("failed to set memory (0x%lx+%#zx) with attr 0x%lx error '%s'",
+                     start, size, attr, strerror(errno));
+    }
+    return r;
+}
+
+int kvm_set_memory_attributes_private(hwaddr start, hwaddr size)
+{
+    return kvm_set_memory_attributes(start, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size)
+{
+    return kvm_set_memory_attributes(start, size, 0);
+}
+
 /* Called with KVMMemoryListener.slots_lock held */
 static void kvm_set_phys_mem(KVMMemoryListener *kml,
                              MemoryRegionSection *section, bool add)
@@ -2439,6 +2480,9 @@ static int kvm_init(MachineState *ms)
 
     kvm_guest_memfd_supported = kvm_check_extension(s, KVM_CAP_GUEST_MEMFD);
 
+    ret = kvm_check_extension(s, KVM_CAP_MEMORY_ATTRIBUTES);
+    kvm_supported_memory_attributes = ret > 0 ? ret : 0;
+
     if (object_property_find(OBJECT(current_machine), "kvm-type")) {
         g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
                                                             "kvm-type",
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index b4913281e2..2cb3192509 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -538,4 +538,7 @@ void kvm_mark_guest_state_protected(void);
 bool kvm_hwpoisoned_mem(void);
 
 int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
+
+int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
+int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
 #endif
-- 
2.25.1


