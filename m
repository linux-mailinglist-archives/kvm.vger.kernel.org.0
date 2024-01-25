Return-Path: <kvm+bounces-6910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6723A83B7D4
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:29:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1692428905D
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B6F10A2D;
	Thu, 25 Jan 2024 03:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LoisvXnb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491BF10A10
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153292; cv=none; b=sBl5HC9gjaeBlHQHIptulHlmy+8mo3qw3kpyZjVxok15nMml32HkUzCAsSrpqXk5xeuIIJWnpvBfwObrk5k9guaM4DeE8GR0jYQDTN2aocVwtzQOvYGA4txbTYkNNGVn+Ovuv34RiAo/YGvuabuMGXk7UrYSq+g13mwKkqfm24I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153292; c=relaxed/simple;
	bh=Uni5ljiplp5k1TOtlm3XfrP7/ANeaONuXLXuV9G5ctA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sTD69wcNkExAqoWc13JCjXP22h/IYmhx4pkFMvQSbj6CkqkwFpbrY+SO3dTUSFdXXwViZApDZ0UdXJB/sLw0ClLGTP8h3TJ4sEbCQI9ToYgDhp49zyQVpns+ZvHlfecgKybGZAAwMjNi1ak+BnmvuwSSxmYd8V/ppq/elsehwws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LoisvXnb; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153291; x=1737689291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uni5ljiplp5k1TOtlm3XfrP7/ANeaONuXLXuV9G5ctA=;
  b=LoisvXnbUNEJhMThMYI/XUtWl9iDs9ThMosumipwaywEZP3Wi6/6bkYE
   hDA7EOihBq9sKY5Pp8nl9eQ3/HFn5ZfY2OT8yfL3smNOzo7tXUT2dKs2x
   9CNjtQDZhYjiSihq7pKosk3rY8SAA+hZ0RiA4+z6Evp6Vx7gLgcaHWJ8G
   ewAtX1RQbwDgTX+gSURXXiATd+WuNw7nbzEYPeV0MAa28eiBEeu5e2HVZ
   NamqmjKaG/n1iDh4ITIdMdwRb4Lopwdchk4Me68yIiMrXkqhF976REWhu
   DFTWrgMPIzrAZp7TVelu5VsFJjSI1pGn0eI9bBtIW7Yy7BaYrjHrvQFgO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9428003"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9428003"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:24:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2084663"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:24:16 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 08/66] kvm: handle KVM_EXIT_MEMORY_FAULT
Date: Wed, 24 Jan 2024 22:22:30 -0500
Message-Id: <20240125032328.2522472-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 accel/kvm/kvm-all.c | 94 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 3bc78a16b48d..2421b8a5b314 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2893,6 +2893,68 @@ static void kvm_eat_signals(CPUState *cpu)
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
@@ -2960,18 +3022,20 @@ int kvm_cpu_exec(CPUState *cpu)
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
@@ -3054,6 +3118,16 @@ int kvm_cpu_exec(CPUState *cpu)
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
2.34.1


