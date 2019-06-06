Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A64377E5
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfFFP3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:29:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:53940 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729358AbfFFP3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:29:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 08:29:54 -0700
X-ExtLoop1: 1
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2019 08:29:53 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 1/9] Documentation: Introduce EPT based Subpage Protection
Date:   Thu,  6 Jun 2019 23:28:04 +0800
Message-Id: <20190606152812.13141-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190606152812.13141-1-weijiang.yang@intel.com>
References: <20190606152812.13141-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 Documentation/virtual/kvm/spp_kvm.txt | 216 ++++++++++++++++++++++++++
 1 file changed, 216 insertions(+)
 create mode 100644 Documentation/virtual/kvm/spp_kvm.txt

diff --git a/Documentation/virtual/kvm/spp_kvm.txt b/Documentation/virtual/kvm/spp_kvm.txt
new file mode 100644
index 000000000000..4b5edcaf48b6
--- /dev/null
+++ b/Documentation/virtual/kvm/spp_kvm.txt
@@ -0,0 +1,216 @@
+EPT-Based Sub-Page Protection (SPP) for KVM
+=============================================
+
+1. Overview
+
+EPT-based Sub-Page Protection (SPP) capability to allow Virtual Machine
+Monitors to specify write-protection for guest physical memory at a
+sub-page (128 byte) granularity. When this capability is utilized, the
+CPU enforces write-access permissions for sub-page regions inside 4K pages
+as specified by the VMI tools.
+
+2. Operation of SPP
+
+Sub-Page Protection Table (SPPT) is introduced to manage sub-page
+write-access.
+
+SPPT is active when:
+a) moddule parameter spp=on is configured for kvm-intel.ko
+b) large paging is disabled on host
+c) "sub-page write protection" VM-execution control bit is set
+SPPT looks up the guest physical address to seek a 64-bit
+bitmap indicating sub-page write permission in SPPT leaf entry.
+
+When the "sub-page write protection" VM-execution control is 1, the SPPT
+is used to lookup write permission bits for the 128 byte sub-page regions
+contained in the 4KB guest physical page. EPT specifies the 4KB page
+write-protection privilege whereas SPPT defines the write permissions
+at 128-byte granularity within one 4KB page. Write accesses
+prevented due to sub-page permissions induces EPT violation VM exits.
+Similar to EPT, a logical processor uses SPPT to lookup sub-page level
+write permissions for guest-physical addresses only when those addresses
+are used to access memory.
+__________________________________________________________________________
+
+How SPP hardware works:
+__________________________________________________________________________
+
+Guest write access --> GPA --> Walk EPT --> EPT leaf entry -----|
+|---------------------------------------------------------------|
+|-> if VMexec_control.spp && ept_leaf_entry.spp_bit (bit 61)
+     |
+     |-> <false> --> EPT legacy behavior
+     |
+     |
+     |-> <true>  --> if ept_leaf_entry.writable
+                      |
+                      |-> <true>  --> Ignore SPP
+                      |
+                      |-> <false> --> GPA --> Walk SPP 4-level table--|
+                                                                      |
+|------------<----------get-the-SPPT-point-from-VMCS-filed-----<------|
+|
+Walk SPP L4E table
+|
+|---> if-entry-misconfiguration ------------>-------|-------<---------|
+ |                                                  |                 |
+else                                                |                 |
+ |                                                  |                 |
+ |   |------------------SPP VMexit<-----------------|                 |
+ |   |                                                                |
+ |   |-> exit_qualification & sppt_misconfig --> sppt misconfig       |
+ |   |                                                                |
+ |   |-> exit_qualification & sppt_miss --> sppt miss                 |
+ |---|                                                                |
+     |                                                                |
+walk SPPT L3E--|--> if-entry-misconfiguration------------>------------|
+               |                                                      |
+              else                                                    |
+               |                                                      |
+               |                                                      |
+        walk SPPT L2E --|--> if-entry-misconfiguration-------->-------|
+                        |                                             |
+                       else                                           |
+                        |                                             |
+                        |                                             |
+                 walk SPPT L1E --|-> if-entry-misconfiguration--->----|
+                                 |
+                               else
+                                 |
+                                 |-> if sub-page writable
+                                 |-> <true>  allow, write access
+                                 |-> <false> disallow, EPT violation
+______________________________________________________________________________
+
+3. Interfaces
+
+* Feature enabling
+
+Add "spp=on" to KVM module parameter to enable SPP feature, default is off.
+
+* Get/Set sub-page write access permission
+
+New KVM ioctl:
+
+KVM_SUBPAGES_GET_ACCESS:
+Get sub-pages write access bitmap corresponding to given rang of continuous gfn.
+
+KVM_SUBPAGES_SET_ACCESS
+Set sub-pages write access bitmap corresponding to given rang of continuous gfn.
+
+
+/* for KVM_SUBPAGES_GET_ACCESS and KVM_SUBPAGES_SET_ACCESS */
+struct kvm_subpage_info {
+    __u64 gfn;
+    __u64 npages; /* number of 4K pages */
+    __u64 *access_map; /* sub-page write-access bitmap array */
+};
+
+#define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, struct kvm_subpage_info)
+#define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, struct kvm_subpage_info)
+
+
+4. SPPT initialization
+
+* SPPT root page allocation
+
+  SPPT is referenced via a 64-bit control field called "sub-page
+  protection table pointer" (SPPTP, encoding 0x2030) which contains a
+  4K-align physical address.
+
+  SPPT is a 4-level paging structure similar as EPT. When KVM
+  loads mmu, it allocates a root page for SPPT L4 table as well.
+
+* EPT leaf entry SPP bit (bit 61)
+
+  Set 0 to SPP bit to close SPP.
+
+5. Set/Get Sub-Page access bitmap for a bunch of guest physical pages
+
+* To utilize SPP feature, system admin should set sub-page access via
+  SPP KVM ioctl `KVM_SUBPAGES_SET_ACCESS`, configuring EPT and SPPT in below flow:
+
+  (1) If the target 4KB pages to be protected are there, it locates EPT leaf entries
+      via the guest physical addresses, flags the bit 61 of the corresponding entries to
+      enable sub-page protection for the pages, then setup SPPT paging structure.
+  (2) otherwise, stores the [gfn,permission] mappings in KVM data structure. When
+      EPT page-fault is generated due to target protected page accessing, it settles
+      EPT entry configureation together with SPPT build-up.
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
+6. SPPT-induced vmexits
+
+* SPP VM exits
+
+Accesses using guest physical addresses may cause VM exits due to a SPPT
+misconfiguration or a SPPT missing.
+
+A SPPT misconfiguration vmexit occurs when, in the course of translating
+a guest physical address, the logical processor encounters a leaf EPT
+paging-structure entry mapping a 4KB page, with SPP enabled, during the
+SPPT lookup, a SPPT paging-structure entry contains an unsupported
+value.
+
+A SPPT missing vmexit occurs during the SPPT lookup there is no SPPT
+misconfiguration but any level of SPPT paging-structure entries are not
+present.
+
+NOTE. SPPT misconfigurations and SPPT miss can occur only due to an
+attempt to write memory with a guest physical address.
+
+* EPT violation vmexits due to SPPT
+
+EPT violations generated due to SPP sub-page
+permission are reported as EPT violation vmexits.
+
+7. SPPT-induced vmexits handling
+
+
+#define EXIT_REASON_SPP                 66
+
+static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
+    ...
+    [EXIT_REASON_SPP]                     = handle_spp,
+    ...
+};
+
+
+New exit qualification for SPPT-induced vmexits.
+
+| Bit   | Contents                                                          |
+| :---- | :---------------------------------------------------------------- |
+| 10:0  | Reserved (0).                                                     |
+| 11    | SPPT VM exit type. Set for SPPT Miss, cleared for SPPT Misconfig. |
+| 12    | NMI unblocking due to IRET                                        |
+| 63:13 | Reserved (0)                                                      |
+
+In addition to the exit qualification, Guest Linear Address and Guest
+Physical Address fields will be reported.
+
+* SPPT miss and misconfiguration
+
+Allocate a page for the SPPT entry and set the entry correctly.
+
+* EPT violation vmexits due to SPPT
+
+While hardware traverses SPPT, If the sub-page region write
+permission bit is set, the write is allowed, otherwise it's prevented
+and an EPT violation is generated.
-- 
2.17.2

