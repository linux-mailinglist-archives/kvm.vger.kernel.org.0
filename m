Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E593D6BD20
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 15:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfGQNge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 09:36:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:36148 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfGQNge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 09:36:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 06:36:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,274,1559545200"; 
   d="scan'208";a="191261822"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jul 2019 06:36:32 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 1/9] Documentation: Introduce EPT based Subpage Protection
Date:   Wed, 17 Jul 2019 21:37:43 +0800
Message-Id: <20190717133751.12910-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190717133751.12910-1-weijiang.yang@intel.com>
References: <20190717133751.12910-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Co-developed-by: yi.z.zhang@linux.intel.com
Signed-off-by: yi.z.zhang@linux.intel.com
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 Documentation/virtual/kvm/spp_kvm.txt | 173 ++++++++++++++++++++++++++
 1 file changed, 173 insertions(+)
 create mode 100644 Documentation/virtual/kvm/spp_kvm.txt

diff --git a/Documentation/virtual/kvm/spp_kvm.txt b/Documentation/virtual/kvm/spp_kvm.txt
new file mode 100644
index 000000000000..072fa86f14d3
--- /dev/null
+++ b/Documentation/virtual/kvm/spp_kvm.txt
@@ -0,0 +1,173 @@
+EPT-Based Sub-Page Protection (SPP) for KVM
+====================================================
+
+1.Overview
+  EPT-based Sub-Page Protection(SPP) allows VMM to specify
+  fine-grained(128byte per sub-page) write-protection for guest physical
+  memory. When it's enabled, the CPU enforces write-access permission
+  for the sub-pages within a 4KB page, if corresponding bit is set in
+  permission vector, write to sub-page region is allowed, otherwise,
+  it's prevented with a EPT violation.
+
+2.SPP Operation
+  Sub-Page Protection Table (SPPT) is introduced to manage sub-page
+  write-access permission.
+
+  It is active when:
+  a) large paging is disabled on host side.
+  b) "sub-page write protection" VM-execution control is 1.
+  c) SPP is initialized with KVM_INIT_SPP ioctl successfully.
+  d) Sub-page permissions are set with KVM_SUBPAGES_SET_ACCESS ioctl
+     successfully. see below sections for details.
+
+  __________________________________________________________________________
+
+  How SPP hardware works:
+  __________________________________________________________________________
+
+  Guest write access --> GPA --> Walk EPT --> EPT leaf entry -----|
+  |---------------------------------------------------------------|
+  |-> if VMexec_control.spp && ept_leaf_entry.spp_bit (bit 61)
+       |
+       |-> <false> --> EPT legacy behavior
+       |
+       |
+       |-> <true>  --> if ept_leaf_entry.writable
+                        |
+                        |-> <true>  --> Ignore SPP
+                        |
+                        |-> <false> --> GPA --> Walk SPP 4-level table--|
+                                                                        |
+  |------------<----------get-the-SPPT-point-from-VMCS-filed-----<------|
+  |
+  Walk SPP L4E table
+  |
+  |---> if-entry-misconfiguration ------------>-------|-------<---------|
+   |                                                  |                 |
+  else                                                |                 |
+   |                                                  |                 |
+   |   |------------------SPP VMexit<-----------------|                 |
+   |   |                                                                |
+   |   |-> exit_qualification & sppt_misconfig --> sppt misconfig       |
+   |   |                                                                |
+   |   |-> exit_qualification & sppt_miss --> sppt miss                 |
+   |---|                                                                |
+       |                                                                |
+  walk SPPT L3E--|--> if-entry-misconfiguration------------>------------|
+                 |                                                      |
+                else                                                    |
+                 |                                                      |
+                 |                                                      |
+          walk SPPT L2E --|--> if-entry-misconfiguration-------->-------|
+                          |                                             |
+                         else                                           |
+                          |                                             |
+                          |                                             |
+                   walk SPPT L1E --|-> if-entry-misconfiguration--->----|
+                                   |
+                                 else
+                                   |
+                                   |-> if sub-page writable
+                                   |-> <true>  allow, write access
+                                   |-> <false> disallow, EPT violation
+  ______________________________________________________________________________
+
+3.IOCTL Interfaces
+
+    KVM_INIT_SPP:
+    Allocate storage for sub-page permission vectors and SPPT root page.
+
+    KVM_SUBPAGES_GET_ACCESS:
+    Get sub-page write permission vectors for given continuous guest pages.
+
+    KVM_SUBPAGES_SET_ACCESS
+    Set sub-pages write permission vectors for given continuous guest pages.
+
+    /* for KVM_SUBPAGES_GET_ACCESS and KVM_SUBPAGES_SET_ACCESS */
+    struct kvm_subpage_info {
+       __u64 gfn; /* the first page gfn of the continuous pages */
+       __u64 npages; /* number of 4K pages */
+       __u64 *access_map; /* sub-page write-access bitmap array */
+    };
+
+    #define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, __u64)
+    #define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, __u64)
+    #define KVM_INIT_SPP              _IOW(KVMIO,  0x4b, __u64)
+
+4.Set Sub-Page Permission
+
+  * To enable SPP protection, system admin sets sub-page permission via
+    KVM_SUBPAGES_SET_ACCESS ioctl:
+
+    (1) If the target 4KB pages are there, it locates EPT leaf entries
+        via the guest physical addresses, sets the bit 61 of the corresponding 
+        entries to enable sub-page protection, then set up SPPT paging structure.
+    (2) otherwise, stores the [gfn,permission] mappings in KVM data structure. When
+        EPT page-fault is generated due to access to target page, it settles
+        EPT entry configuration together with SPPT setup, this is called lazy mode
+        setup.
+
+   The SPPT paging structure format is as below:
+
+   Format of the SPPT L4E, L3E, L2E:
+   | Bit    | Contents                                                                 |
+   | :----- | :------------------------------------------------------------------------|
+   | 0      | Valid entry when set; indicates whether the entry is present             |
+   | 11:1   | Reserved (0)                                                             |
+   | N-1:12 | Physical address of 4KB aligned SPPT LX-1 Table referenced by this entry |
+   | 51:N   | Reserved (0)                                                             |
+   | 63:52  | Reserved (0)                                                             |
+   Note: N is the physical address width supported by the processor. X is the page level
+
+   Format of the SPPT L1E:
+   | Bit   | Contents                                                          |
+   | :---- | :---------------------------------------------------------------- |
+   | 0+2i  | Write permission for i-th 128 byte sub-page region.               |
+   | 1+2i  | Reserved (0).                                                     |
+   Note: 0<=i<=31
+
+5.SPPT-induced VM exit
+
+  * SPPT miss and misconfiguration induced VM exit
+
+    A SPPT missing VM exit occurs when walk the SPPT, there is no SPPT
+    misconfiguration but a paging-structure entry is not
+    present in any of L4E/L3E/L2E entries.
+
+    A SPPT misconfiguration VM exit occurs when reserved bits or unsupported values
+    are set in SPPT entry.
+
+    *NOTE* SPPT miss and SPPT misconfigurations can occur only due to an
+    attempt to write memory with a guest physical address.
+
+  * SPP permission induced VM exit
+    SPP sub-page permission induced violation is reported as EPT violation
+    thesefore causes VM exit.
+
+6.SPPT-induced VM exit handling
+
+  #define EXIT_REASON_SPP                 66
+
+  static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
+    ...
+    [EXIT_REASON_SPP]                     = handle_spp,
+    ...
+  };
+
+  New exit qualification for SPPT-induced vmexits.
+
+  | Bit   | Contents                                                          |
+  | :---- | :---------------------------------------------------------------- |
+  | 10:0  | Reserved (0).                                                     |
+  | 11    | SPPT VM exit type. Set for SPPT Miss, cleared for SPPT Misconfig. |
+  | 12    | NMI unblocking due to IRET                                        |
+  | 63:13 | Reserved (0)                                                      |
+
+  In addition to the exit qualification, guest linear address and guest
+  physical address fields will be reported.
+
+  * SPPT miss and misconfiguration induced VM exit
+    Allocate a physical page for the SPPT and set the entry correctly.
+
+  * SPP permission induced VM exit
+    This kind of VM exit is left to VMI tool to handle.
-- 
2.17.2

