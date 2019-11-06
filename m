Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1854AF108A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 08:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbfKFHmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 02:42:44 -0500
Received: from mga06.intel.com ([134.134.136.31]:15128 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbfKFHmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 02:42:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 23:42:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="232770685"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga002.fm.intel.com with ESMTP; 05 Nov 2019 23:42:41 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v6 1/9] Documentation: Introduce EPT based Subpage Protection and related ioctls
Date:   Wed,  6 Nov 2019 15:44:56 +0800
Message-Id: <20191106074504.14858-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191106074504.14858-1-weijiang.yang@intel.com>
References: <20191106074504.14858-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Co-developed-by: yi.z.zhang@linux.intel.com
Signed-off-by: yi.z.zhang@linux.intel.com
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 Documentation/virt/kvm/api.txt        |  46 +++++++
 Documentation/virtual/kvm/spp_kvm.txt | 180 ++++++++++++++++++++++++++
 2 files changed, 226 insertions(+)
 create mode 100644 Documentation/virtual/kvm/spp_kvm.txt

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index 2d067767b617..85a764812f3d 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -4111,6 +4111,52 @@ Valid values for 'action':
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+4.121 KVM_INIT_SPP
+
+Architectures: x86
+Type: vm ioctl
+Parameters: none
+Returns: 0 on success, < 0 on error
+
+This ioctl initializes storage for sub-page permission vectors and
+SPPT root page.
+
+4.121 KVM_SUBPAGES_GET_ACCESS
+
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_subpage_info (in/out)
+Returns: 0 on success, < 0 on error
+
+#define SUBPAGE_MAX_BITMAP   64
+struct kvm_subpage_info {
+	__u64 gfn;    /* the first page gfn of the contiguous pages */
+	__u64 npages; /* number of 4K pages */
+	__u32 access_map[SUBPAGE_MAX_BITMAP]; /* sub-page write-access bitmap array */
+};
+
+This ioctl fetches subpage permission from contiguous pages starting with
+gfn. npages is the number of contiguous pages to fetch. access_map contains permission
+vectors fetched for all the pages.
+
+4.122 KVM_SUBPAGES_SET_ACCESS
+
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_subpage_info (in/out)
+Returns: 0 on success, < 0 on error
+
+#define SUBPAGE_MAX_BITMAP   64
+struct kvm_subpage_info {
+	__u64 gfn;    /* the first page gfn of the contiguous pages */
+	__u64 npages; /* number of 4K pages */
+	__u32 access_map[SUBPAGE_MAX_BITMAP]; /* sub-page write-access bitmap array */
+};
+
+This ioctl sets subpage permission for contiguous pages starting with gfn. npages is
+the number of contiguous pages to set. access_map contains permission vectors for all the
+pages. Since during execution of the ioctl, it holds mmu_lock, so limits the MAX pages
+to 64 to reduce the impact to EPT.
 
 5. The kvm_run structure
 ------------------------
diff --git a/Documentation/virtual/kvm/spp_kvm.txt b/Documentation/virtual/kvm/spp_kvm.txt
new file mode 100644
index 000000000000..2b49846c0722
--- /dev/null
+++ b/Documentation/virtual/kvm/spp_kvm.txt
@@ -0,0 +1,180 @@
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
+  *Note*: In current implementation, SPP is exclusive with nested flag,
+  if it's on, SPP feature won't work.
+
+2.SPP Operation
+  Sub-Page Protection Table (SPPT) is introduced to manage sub-page
+  write-access permission.
+
+  It is active when:
+  a) nested flag is turned off.
+  b) "sub-page write protection" VM-execution control is 1.
+  c) SPP is initialized with KVM_INIT_SPP ioctl.
+  d) Sub-page permissions are set with KVM_SUBPAGES_SET_ACCESS ioctl.
+     see below sections for details.
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
+  |------------<----------get-the-SPPT-point-from-VMCS-field-----<------|
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
+    Get sub-page write permission vectors for given contiguous guest pages.
+
+    KVM_SUBPAGES_SET_ACCESS
+    Set SPP bit in EPT leaf entries for given contiguous guest pages. The
+    actual SPPT setup is triggered when SPP miss vm-exit is handled.
+
+    #define SUBPAGE_MAX_BITMAP   64
+    /* for KVM_SUBPAGES_GET_ACCESS and KVM_SUBPAGES_SET_ACCESS */
+    struct kvm_subpage_info {
+       __u64 gfn;    /* the first page gfn of the contiguous pages */
+       __u64 npages; /* number of 4K pages */
+       __u32 access_map[SUBPAGE_MAX_BITMAP]; /* sub-page write-access bitmap array */
+    };
+
+    #define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, __u64)
+    #define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, __u64)
+    #define KVM_INIT_SPP              _IOW(KVMIO,  0x4b, __u64)
+
+4.Set Sub-Page Permission
+
+  * To enable SPP protection, KVM user-space application sets sub-page permission
+    via KVM_SUBPAGES_SET_ACCESS ioctl:
+    (1) It first stores the access permissions in bitmap array.
+
+    (2) Then, if the target 4KB pages are mapped as PT_PAGE_TABLE_LEVEL entry in EPT,
+	it sets SPP bit of the corresponding entry to mark sub-page protection.
+	If the 4KB pages are mapped within PT_DIRECTORY_LEVEL or PT_PDPE_LEVEL entry,
+	it first zaps the hugepage entries so as to let following memory access to trigger
+	EPT violation, there the gfn is check against SPP permission bitmap and
+	proper level is selected to set up EPT entry.
+
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
+    *NOTE* SPPT miss and SPPT misconfigurations can occur only due to
+    "eligible" memory write, this excludes, e.g., guest paging structure,
+    please refer to SDM 28.2 for details of "non-eligible" cases.
+
+  * SPP permission induced VM exit
+    SPP sub-page permission induced violation is reported as EPT violation
+    therefore causes VM exit.
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
+    Set up SPPT entries correctly.
+
+  * SPP permission induced VM exit
+    This kind of VM exit is left to VMI tool to handle.
-- 
2.17.2

