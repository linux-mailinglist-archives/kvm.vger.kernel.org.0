Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3B333DA4A
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbhCPRI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:08:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238334AbhCPRIX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 13:08:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615914502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UXcIwAYQJO7er3n8t1vDQmVg3HZL2SMIlbQJ9A3NI5E=;
        b=gQscFF5H6KUTJ0FWCxxk5L0SE3y9dYAMDwx9JgjSo9nbKAmUs2NGX+C6da33FsJgfpW+BJ
        yJkcpw7U7d7wFLx449qZVGo/kuHkDil2jAwvFP17IOsYoP92hvQJiMTn0Aieh2X6v+ms/K
        Lx3RTyi1dYZV9aLgASiYPb0P+NHS5lU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-ULJuriCgNAClr2HeXhANLw-1; Tue, 16 Mar 2021 13:08:20 -0400
X-MC-Unique: ULJuriCgNAClr2HeXhANLw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 744CE800FF0;
        Tue, 16 Mar 2021 17:08:19 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-30.ams2.redhat.com [10.36.113.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DB075D9D3;
        Tue, 16 Mar 2021 17:08:16 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     linux-doc@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] doc/virt/kvm: move KVM_X86_SET_MSR_FILTER in section 8
Date:   Tue, 16 Mar 2021 18:08:14 +0100
Message-Id: <20210316170814.64286-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_X86_SET_MSR_FILTER is a capability, not an ioctl.
Therefore move it from section 4.97 to the new 8.31 (other capabilities).

To fill the gap, move KVM_X86_SET_MSR_FILTER (was 4.126) to
4.97, and shifted Xen-related ioctl (were 4.127 - 4.130) by
one place (4.126 - 4.129).

Also fixed minor typo in KVM_GET_MSR_INDEX_LIST ioctl description
(section 4.3).

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 Documentation/virt/kvm/api.rst | 250 ++++++++++++++++-----------------
 1 file changed, 125 insertions(+), 125 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1a2b5210cdbf..a230140d6a7f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -201,7 +201,7 @@ Errors:
 
   ======     ============================================================
   EFAULT     the msr index list cannot be read from or written to
-  E2BIG      the msr index list is to be to fit in the array specified by
+  E2BIG      the msr index list is too big to fit in the array specified by
              the user.
   ======     ============================================================
 
@@ -3686,31 +3686,105 @@ which is the maximum number of possibly pending cpu-local interrupts.
 
 Queues an SMI on the thread's vcpu.
 
-4.97 KVM_CAP_PPC_MULTITCE
--------------------------
+4.97 KVM_X86_SET_MSR_FILTER
+----------------------------
 
-:Capability: KVM_CAP_PPC_MULTITCE
-:Architectures: ppc
-:Type: vm
+:Capability: KVM_X86_SET_MSR_FILTER
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_msr_filter
+:Returns: 0 on success, < 0 on error
 
-This capability means the kernel is capable of handling hypercalls
-H_PUT_TCE_INDIRECT and H_STUFF_TCE without passing those into the user
-space. This significantly accelerates DMA operations for PPC KVM guests.
-User space should expect that its handlers for these hypercalls
-are not going to be called if user space previously registered LIOBN
-in KVM (via KVM_CREATE_SPAPR_TCE or similar calls).
+::
 
-In order to enable H_PUT_TCE_INDIRECT and H_STUFF_TCE use in the guest,
-user space might have to advertise it for the guest. For example,
-IBM pSeries (sPAPR) guest starts using them if "hcall-multi-tce" is
-present in the "ibm,hypertas-functions" device-tree property.
+  struct kvm_msr_filter_range {
+  #define KVM_MSR_FILTER_READ  (1 << 0)
+  #define KVM_MSR_FILTER_WRITE (1 << 1)
+	__u32 flags;
+	__u32 nmsrs; /* number of msrs in bitmap */
+	__u32 base;  /* MSR index the bitmap starts at */
+	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
+  };
 
-The hypercalls mentioned above may or may not be processed successfully
-in the kernel based fast path. If they can not be handled by the kernel,
-they will get passed on to user space. So user space still has to have
-an implementation for these despite the in kernel acceleration.
+  #define KVM_MSR_FILTER_MAX_RANGES 16
+  struct kvm_msr_filter {
+  #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+  #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+	__u32 flags;
+	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
+  };
 
-This capability is always enabled.
+flags values for ``struct kvm_msr_filter_range``:
+
+``KVM_MSR_FILTER_READ``
+
+  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
+  indicates that a read should immediately fail, while a 1 indicates that
+  a read for a particular MSR should be handled regardless of the default
+  filter action.
+
+``KVM_MSR_FILTER_WRITE``
+
+  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
+  indicates that a write should immediately fail, while a 1 indicates that
+  a write for a particular MSR should be handled regardless of the default
+  filter action.
+
+``KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE``
+
+  Filter both read and write accesses to MSRs using the given bitmap. A 0
+  in the bitmap indicates that both reads and writes should immediately fail,
+  while a 1 indicates that reads and writes for a particular MSR are not
+  filtered by this range.
+
+flags values for ``struct kvm_msr_filter``:
+
+``KVM_MSR_FILTER_DEFAULT_ALLOW``
+
+  If no filter range matches an MSR index that is getting accessed, KVM will
+  fall back to allowing access to the MSR.
+
+``KVM_MSR_FILTER_DEFAULT_DENY``
+
+  If no filter range matches an MSR index that is getting accessed, KVM will
+  fall back to rejecting access to the MSR. In this mode, all MSRs that should
+  be processed by KVM need to explicitly be marked as allowed in the bitmaps.
+
+This ioctl allows user space to define up to 16 bitmaps of MSR ranges to
+specify whether a certain MSR access should be explicitly filtered for or not.
+
+If this ioctl has never been invoked, MSR accesses are not guarded and the
+default KVM in-kernel emulation behavior is fully preserved.
+
+Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
+filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
+an error.
+
+As soon as the filtering is in place, every MSR access is processed through
+the filtering except for accesses to the x2APIC MSRs (from 0x800 to 0x8ff);
+x2APIC MSRs are always allowed, independent of the ``default_allow`` setting,
+and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
+register.
+
+If a bit is within one of the defined ranges, read and write accesses are
+guarded by the bitmap's value for the MSR index if the kind of access
+is included in the ``struct kvm_msr_filter_range`` flags.  If no range
+cover this particular access, the behavior is determined by the flags
+field in the kvm_msr_filter struct: ``KVM_MSR_FILTER_DEFAULT_ALLOW``
+and ``KVM_MSR_FILTER_DEFAULT_DENY``.
+
+Each bitmap range specifies a range of MSRs to potentially allow access on.
+The range goes from MSR index [base .. base+nmsrs]. The flags field
+indicates whether reads, writes or both reads and writes are filtered
+by setting a 1 bit in the bitmap for the corresponding MSR index.
+
+If an MSR access is not permitted through the filtering, it generates a
+#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
+allows user space to deflect and potentially handle various MSR accesses
+into user space.
+
+If a vCPU is in running state while this ioctl is invoked, the vCPU may
+experience inconsistent filtering behavior on MSR accesses.
 
 4.98 KVM_CREATE_SPAPR_TCE_64
 ----------------------------
@@ -4706,107 +4780,7 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
-4.126 KVM_X86_SET_MSR_FILTER
-----------------------------
-
-:Capability: KVM_X86_SET_MSR_FILTER
-:Architectures: x86
-:Type: vm ioctl
-:Parameters: struct kvm_msr_filter
-:Returns: 0 on success, < 0 on error
-
-::
-
-  struct kvm_msr_filter_range {
-  #define KVM_MSR_FILTER_READ  (1 << 0)
-  #define KVM_MSR_FILTER_WRITE (1 << 1)
-	__u32 flags;
-	__u32 nmsrs; /* number of msrs in bitmap */
-	__u32 base;  /* MSR index the bitmap starts at */
-	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
-  };
-
-  #define KVM_MSR_FILTER_MAX_RANGES 16
-  struct kvm_msr_filter {
-  #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
-  #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
-	__u32 flags;
-	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
-  };
-
-flags values for ``struct kvm_msr_filter_range``:
-
-``KVM_MSR_FILTER_READ``
-
-  Filter read accesses to MSRs using the given bitmap. A 0 in the bitmap
-  indicates that a read should immediately fail, while a 1 indicates that
-  a read for a particular MSR should be handled regardless of the default
-  filter action.
-
-``KVM_MSR_FILTER_WRITE``
-
-  Filter write accesses to MSRs using the given bitmap. A 0 in the bitmap
-  indicates that a write should immediately fail, while a 1 indicates that
-  a write for a particular MSR should be handled regardless of the default
-  filter action.
-
-``KVM_MSR_FILTER_READ | KVM_MSR_FILTER_WRITE``
-
-  Filter both read and write accesses to MSRs using the given bitmap. A 0
-  in the bitmap indicates that both reads and writes should immediately fail,
-  while a 1 indicates that reads and writes for a particular MSR are not
-  filtered by this range.
-
-flags values for ``struct kvm_msr_filter``:
-
-``KVM_MSR_FILTER_DEFAULT_ALLOW``
-
-  If no filter range matches an MSR index that is getting accessed, KVM will
-  fall back to allowing access to the MSR.
-
-``KVM_MSR_FILTER_DEFAULT_DENY``
-
-  If no filter range matches an MSR index that is getting accessed, KVM will
-  fall back to rejecting access to the MSR. In this mode, all MSRs that should
-  be processed by KVM need to explicitly be marked as allowed in the bitmaps.
-
-This ioctl allows user space to define up to 16 bitmaps of MSR ranges to
-specify whether a certain MSR access should be explicitly filtered for or not.
-
-If this ioctl has never been invoked, MSR accesses are not guarded and the
-default KVM in-kernel emulation behavior is fully preserved.
-
-Calling this ioctl with an empty set of ranges (all nmsrs == 0) disables MSR
-filtering. In that mode, ``KVM_MSR_FILTER_DEFAULT_DENY`` is invalid and causes
-an error.
-
-As soon as the filtering is in place, every MSR access is processed through
-the filtering except for accesses to the x2APIC MSRs (from 0x800 to 0x8ff);
-x2APIC MSRs are always allowed, independent of the ``default_allow`` setting,
-and their behavior depends on the ``X2APIC_ENABLE`` bit of the APIC base
-register.
-
-If a bit is within one of the defined ranges, read and write accesses are
-guarded by the bitmap's value for the MSR index if the kind of access
-is included in the ``struct kvm_msr_filter_range`` flags.  If no range
-cover this particular access, the behavior is determined by the flags
-field in the kvm_msr_filter struct: ``KVM_MSR_FILTER_DEFAULT_ALLOW``
-and ``KVM_MSR_FILTER_DEFAULT_DENY``.
-
-Each bitmap range specifies a range of MSRs to potentially allow access on.
-The range goes from MSR index [base .. base+nmsrs]. The flags field
-indicates whether reads, writes or both reads and writes are filtered
-by setting a 1 bit in the bitmap for the corresponding MSR index.
-
-If an MSR access is not permitted through the filtering, it generates a
-#GP inside the guest. When combined with KVM_CAP_X86_USER_SPACE_MSR, that
-allows user space to deflect and potentially handle various MSR accesses
-into user space.
-
-If a vCPU is in running state while this ioctl is invoked, the vCPU may
-experience inconsistent filtering behavior on MSR accesses.
-
-4.127 KVM_XEN_HVM_SET_ATTR
+4.126 KVM_XEN_HVM_SET_ATTR
 --------------------------
 
 :Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
@@ -4849,7 +4823,7 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO
 KVM_XEN_ATTR_TYPE_UPCALL_VECTOR
   Sets the exception vector used to deliver Xen event channel upcalls.
 
-4.128 KVM_XEN_HVM_GET_ATTR
+4.127 KVM_XEN_HVM_GET_ATTR
 --------------------------
 
 :Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
@@ -4861,7 +4835,7 @@ KVM_XEN_ATTR_TYPE_UPCALL_VECTOR
 Allows Xen VM attributes to be read. For the structure and types,
 see KVM_XEN_HVM_SET_ATTR above.
 
-4.129 KVM_XEN_VCPU_SET_ATTR
+4.128 KVM_XEN_VCPU_SET_ATTR
 ---------------------------
 
 :Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
@@ -4923,7 +4897,7 @@ KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST
   or RUNSTATE_offline) to set the current accounted state as of the
   adjusted state_entry_time.
 
-4.130 KVM_XEN_VCPU_GET_ATTR
+4.129 KVM_XEN_VCPU_GET_ATTR
 ---------------------------
 
 :Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
@@ -6721,3 +6695,29 @@ vcpu_info is set.
 The KVM_XEN_HVM_CONFIG_RUNSTATE flag indicates that the runstate-related
 features KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR/_CURRENT/_DATA/_ADJUST are
 supported by the KVM_XEN_VCPU_SET_ATTR/KVM_XEN_VCPU_GET_ATTR ioctls.
+
+8.31 KVM_CAP_PPC_MULTITCE
+-------------------------
+
+:Capability: KVM_CAP_PPC_MULTITCE
+:Architectures: ppc
+:Type: vm
+
+This capability means the kernel is capable of handling hypercalls
+H_PUT_TCE_INDIRECT and H_STUFF_TCE without passing those into the user
+space. This significantly accelerates DMA operations for PPC KVM guests.
+User space should expect that its handlers for these hypercalls
+are not going to be called if user space previously registered LIOBN
+in KVM (via KVM_CREATE_SPAPR_TCE or similar calls).
+
+In order to enable H_PUT_TCE_INDIRECT and H_STUFF_TCE use in the guest,
+user space might have to advertise it for the guest. For example,
+IBM pSeries (sPAPR) guest starts using them if "hcall-multi-tce" is
+present in the "ibm,hypertas-functions" device-tree property.
+
+The hypercalls mentioned above may or may not be processed successfully
+in the kernel based fast path. If they can not be handled by the kernel,
+they will get passed on to user space. So user space still has to have
+an implementation for these despite the in kernel acceleration.
+
+This capability is always enabled.
\ No newline at end of file
-- 
2.29.2

