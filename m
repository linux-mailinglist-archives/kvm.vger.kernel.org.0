Return-Path: <kvm+bounces-12223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F832880D4E
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:42:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03E932819B6
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19AEB383B5;
	Wed, 20 Mar 2024 08:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KGrw9UUG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2043.outbound.protection.outlook.com [40.107.100.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375A2381A1
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924158; cv=fail; b=mGEsAzr7AOgBMXwnkKonpDTpj06At3h2Oswlu2A+SzGD99IbX5yWG3sBsJAeQR34FiWKFQ+7M08OA3gtpYcAH+/z6+Mw60Ukn6EEQBTv1doDFHI4W12C0lgPO/jialXJj8O1aJKGEDHcdeMnnTORbWuM8AqpaQeJrZUJ/NvlhmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924158; c=relaxed/simple;
	bh=aP3UaHVpkBm3YRjHs7W2DFFxEBB4CF6IEY16Q3DLgPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=agsDsbQu6tfc7RPW7J7ky1A/PHGCplw3duHqgWbBhoHwy2jYk5vg3rclyvFJIRJIoLu7IdtGHei+HRyw/O+RUowlyKqR3TrpiC4C/UiZxcYk2WNprzuPwH4HgyiBn3zlynTEp5saOB9bD9UMRNbn6Y9afqGr8uf/+aZ2ULMPzOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KGrw9UUG; arc=fail smtp.client-ip=40.107.100.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=clukpr9QPfVdJs7VRjaBhrmTkBnmuiOEefI0NeZXg1HaW7zLI3VXRUp/3y0Z0+0j8S3ALW8kBQuYUU2uyCdF28IcDbPO3D5bKank/J5Ys3LAUSFVOi7cQucIioBzO3cgAY7Bvb8NwME840lJK2UzfY+WjVbNVfd3wwdFCeObJJMwqyZcLbxZJLgB5n/5Vss9tvBzhXfl7ZZ8cN6F0saq7mcIILZ/xANokoDflsLjPkPfCN0y6ZWqcp5fM+PIxiLmW+vZe6fzJvBEJngBMsRkkwnkJmPAdeI+B4/V1Za19e9vzdoXJDgEKVPsQMTajlh/8gD1BuQP/8/Ua4qjq94l5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTpe5ac0xxwwCms3B+uA7aQK3XRQ5Pf70MDJoVTSbKM=;
 b=bEgHDPdHqU3NVmI9N46dj4brlHNy5yIOxc6X3YXeWJZAUe3BE0EMDDd70fYwsAi6A3GLxOzgNUystIgtTg1BjnklbuzotlYBh32vLF+dHiqk9Zu2nx1qu/w1RBLXVWFutMDaS/EsTORpy8hX+KEqs3Bx7sYsoQEPTGBS02CiigyuTEljhLW8vjae/umqANHefKlr2SRtI1fUFixr7Jy3VWrEJMNlXRlZYMrxNG3//ACvWi3T+gXMY3AXa7cM15vluP0d4QX82UJxr01IWnuYGfDy/DPo2grORWh91WnzPR+PTVCWPlCXDF/m5ZInWdPKUDmGwHCOkLNkD+QAN/ehjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTpe5ac0xxwwCms3B+uA7aQK3XRQ5Pf70MDJoVTSbKM=;
 b=KGrw9UUGfsA8gQhFed8VEBcdtI4Otw5a8lNQML9ri/17QPvr+LfwrrsowWAkQQTEnlSe5J9k2tClSYnmo50ulhVXSwk3YbVn8/VsHBCHKcGSnmPdlWTxmJ6CjOXEa/LSTUXroSewBCR9NyePh7HLUR9VYu+02O0f4yG0ua9vJo8=
Received: from SA0PR11CA0138.namprd11.prod.outlook.com (2603:10b6:806:131::23)
 by DS7PR12MB6238.namprd12.prod.outlook.com (2603:10b6:8:96::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 08:42:33 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:806:131:cafe::34) by SA0PR11CA0138.outlook.office365.com
 (2603:10b6:806:131::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:42:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:42:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:42:31 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH v3 12/49] kvm: handle KVM_EXIT_MEMORY_FAULT
Date: Wed, 20 Mar 2024 03:39:08 -0500
Message-ID: <20240320083945.991426-13-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|DS7PR12MB6238:EE_
X-MS-Office365-Filtering-Correlation-Id: bf6f8b1a-6483-4b9a-1aa0-08dc48b9af54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0ytq9e16lXy4cjnOK6ENCxxrmbSuzALnL8dSt+k2jtrW++GrSaG+YzZMrWEcxkm7QYkVhw+gE0qM5cy6pFpS7jfOYHtD/FvU4xgJpyt3PD0Nd/xn3bpcjttbRR2xdeAVDtV/3qSDBQuD8Gx5XLnQPyxiJqFcuk+Hx3BIBZ3F04V/VXrZ+3UgH2ILVi3sk6KeVyr1peVtNBbLSgI62lrEKaVW4/Vw/wUoELqEpgAi0pATnH7QzbJp7wciPXmLu1YnOMp85AfGVau5Pq1e+FJX5userVXm7cgNIAbeq8xRb2M50di/TfGwyqo7zGwB+o6SsN9oKYM0nzFbZCqXEWTnySzmWBv91kDIP3BMEgSH8o3ueyUZiSl3ptaV69oWXhC+G5nXtgHYPSCADk3290SBHYDFxsYsnTNMML1w6eIt35w+hR1X9osVVvxaeEQIgchLNN9lgtHAW212TWMUNYobrGnYF1cpsmT+OQzYIetgNiI/yVy43o3wqMZ3J1vCji55gjfhuG9Lem/ve9QMj2yTJSyg0lr5lm+dbN5w/CshDVXaXGzoqi0wP2eip4k5bYt60ImcJ7KwkCNKJp682Zu/UFApve8NoPsDymwqN/ZshZwhCd1yJ1tUzs5vVrbXp32NPjLpiAq9gH5s53NJ9J9Hfcej/dE8KEn+7kFRG90q6Z3F9ZO/+T7ckxZ4rrY4r7xPbUVnNG6QisDrzgq9u2Nfksre75GlVvfa2CFqu6MWjC9BWOpgxjw+ydB0iknDpVec
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:42:32.6817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf6f8b1a-6483-4b9a-1aa0-08dc48b9af54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6238

From: Chao Peng <chao.p.peng@linux.intel.com>

When geeting KVM_EXIT_MEMORY_FAULT exit, it indicates userspace needs to
do the memory conversion on the RAMBlock to turn the memory into desired
attribute, i.e., private/shared.

Currently only KVM_MEMORY_EXIT_FLAG_PRIVATE in flags is valid when
KVM_EXIT_MEMORY_FAULT happens.

Note, KVM_EXIT_MEMORY_FAULT makes sense only when the RAMBlock has
guest_memfd memory backend.

Note, KVM_EXIT_MEMORY_FAULT returns with -EFAULT, so special handling is
added.

When page is converted from shared to private, the original shared
memory can be discarded via ram_block_discard_range(). Note, shared
memory can be discarded only when it's not back'ed by hugetlb because
hugetlb is supposed to be pre-allocated and no need for discarding.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

---
Changes in v4:
- open-coded ram_block_discard logic;
- change warn_report() to error_report(); (Daniel)

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 accel/kvm/kvm-all.c | 94 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index df7a32735a..2fdc07a472 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2903,6 +2903,68 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
 
+static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
+{
+    MemoryRegionSection section;
+    ram_addr_t offset;
+    MemoryRegion *mr;
+    RAMBlock *rb;
+    void *addr;
+    int ret = -1;
+
+    if (!QEMU_PTR_IS_ALIGNED(start, qemu_host_page_size) ||
+        !QEMU_PTR_IS_ALIGNED(size, qemu_host_page_size)) {
+        return -1;
+    }
+
+    if (!size) {
+        return -1;
+    }
+
+    section = memory_region_find(get_system_memory(), start, size);
+    mr = section.mr;
+    if (!mr) {
+        return -1;
+    }
+
+    if (memory_region_has_guest_memfd(mr)) {
+        if (to_private) {
+            ret = kvm_set_memory_attributes_private(start, size);
+        } else {
+            ret = kvm_set_memory_attributes_shared(start, size);
+        }
+
+        if (ret) {
+            memory_region_unref(section.mr);
+            return ret;
+        }
+
+        addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
+        rb = qemu_ram_block_from_host(addr, false, &offset);
+
+        if (to_private) {
+            if (rb->page_size != qemu_host_page_size) {
+                /*
+                * shared memory is back'ed by  hugetlb, which is supposed to be
+                * pre-allocated and doesn't need to be discarded
+                */
+                return 0;
+            } else {
+                ret = ram_block_discard_range(rb, offset, size);
+            }
+        } else {
+            ret = ram_block_discard_guest_memfd_range(rb, offset, size);
+        }
+    } else {
+        error_report("Convert non guest_memfd backed memory region "
+                    "(0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",
+                    start, size, to_private ? "private" : "shared");
+    }
+
+    memory_region_unref(section.mr);
+    return ret;
+}
+
 int kvm_cpu_exec(CPUState *cpu)
 {
     struct kvm_run *run = cpu->kvm_run;
@@ -2970,18 +3032,20 @@ int kvm_cpu_exec(CPUState *cpu)
                 ret = EXCP_INTERRUPT;
                 break;
             }
-            fprintf(stderr, "error: kvm run failed %s\n",
-                    strerror(-run_ret));
+            if (!(run_ret == -EFAULT && run->exit_reason == KVM_EXIT_MEMORY_FAULT)) {
+                fprintf(stderr, "error: kvm run failed %s\n",
+                        strerror(-run_ret));
 #ifdef TARGET_PPC
-            if (run_ret == -EBUSY) {
-                fprintf(stderr,
-                        "This is probably because your SMT is enabled.\n"
-                        "VCPU can only run on primary threads with all "
-                        "secondary threads offline.\n");
-            }
+                if (run_ret == -EBUSY) {
+                    fprintf(stderr,
+                            "This is probably because your SMT is enabled.\n"
+                            "VCPU can only run on primary threads with all "
+                            "secondary threads offline.\n");
+                }
 #endif
-            ret = -1;
-            break;
+                ret = -1;
+                break;
+            }
         }
 
         trace_kvm_run_exit(cpu->cpu_index, run->exit_reason);
@@ -3064,6 +3128,16 @@ int kvm_cpu_exec(CPUState *cpu)
                 break;
             }
             break;
+        case KVM_EXIT_MEMORY_FAULT:
+            if (run->memory_fault.flags & ~KVM_MEMORY_EXIT_FLAG_PRIVATE) {
+                error_report("KVM_EXIT_MEMORY_FAULT: Unknown flag 0x%" PRIx64,
+                             (uint64_t)run->memory_fault.flags);
+                ret = -1;
+                break;
+            }
+            ret = kvm_convert_memory(run->memory_fault.gpa, run->memory_fault.size,
+                                     run->memory_fault.flags & KVM_MEMORY_EXIT_FLAG_PRIVATE);
+            break;
         default:
             ret = kvm_arch_handle_exit(cpu, run);
             break;
-- 
2.25.1


