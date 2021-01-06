Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C692EB6D4
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 01:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbhAFAYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 19:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbhAFAYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 19:24:06 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DA3C061793
        for <kvm@vger.kernel.org>; Tue,  5 Jan 2021 16:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=h7qf/Q3nRXQPoubj1J0wE5hiTMUDYk1pIYgTMLBIVyU=; b=mdvGmAgrhSQCV+W7Y1nGPH7DXn
        SHBCRAuC4mEigps0x5EIjQuLpHMlaITjbul8X0mkej10yOGdeCcmFLCKHeLIxxQe4ohz4M2873WyF
        2tVLEnxN2KCEstwCSjsWjw1Jkk7K9x4YBw6AIDvB9lmUkrY2xqLxP8ibzGBZURURbMD+L2h8+FVuy
        2euxqLWYegDN6uAMZUK7Cu7DaEz2X02fqjKU5a3jJQA29ssrWq3ovyTkqMRC7MBLSXYlXrGems6JT
        HTIBTkM71HWhL5PIQY3pkaR07oIfz1YEI/NQEMPEIfhVLy7gpfUV4LywGJ0YTSIafqIEF57NuQw2Z
        Tlj1ln7A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kwwbi-0004a5-LR; Wed, 06 Jan 2021 00:23:22 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kwwbh-001NjT-JF; Wed, 06 Jan 2021 00:23:21 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
Subject: [PATCH v4 15/16] KVM: Add documentation for Xen hypercall and shared_info updates
Date:   Wed,  6 Jan 2021 00:23:13 +0000
Message-Id: <20210106002314.328380-16-dwmw2@infradead.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210106002314.328380-1-dwmw2@infradead.org>
References: <20210106002314.328380-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst | 124 ++++++++++++++++++++++++++++++++-
 1 file changed, 123 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 70254eaa5229..e8858cca93ab 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -956,6 +956,13 @@ memory.
 	__u8 pad2[30];
   };
 
+If the KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL flag is returned from the
+KVM_CAP_XEN_HVM check, it may be set in the flags field of this ioctl.
+This requests KVM to generate the contents of the hypercall page
+automatically, and also to intercept hypercalls with KVM_EXIT_XEN.
+In this case, all of the blob size and address fields must be zero.
+
+No other flags are currently valid.
 
 4.29 KVM_GET_CLOCK
 ------------------
@@ -4825,6 +4832,71 @@ into user space.
 If a vCPU is in running state while this ioctl is invoked, the vCPU may
 experience inconsistent filtering behavior on MSR accesses.
 
+4.127 KVM_XEN_HVM_SET_ATTR
+--------------------------
+
+:Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_xen_hvm_attr
+:Returns: 0 on success, < 0 on error
+
+::
+
+  struct kvm_xen_hvm_attr {
+	__u16 type;
+
+	union {
+		__u8 long_mode;
+		struct {
+			__u64 gfn;
+		} shared_info;
+		struct {
+			__u32 vcpu_id;
+			__u64 gpa;
+		} vcpu_attr;
+		__u64 pad[4];
+	} u;
+  };
+
+type values:
+
+KVM_XEN_ATTR_TYPE_LONG_MODE
+  Sets the ABI mode of the VM to 32-bit or 64-bit (long mode). This
+  determines the layout of the shared info pages exposed to the VM.
+
+KVM_XEN_ATTR_TYPE_SHARED_INFO
+  Sets the guest physical frame number at which the Xen "shared info"
+  page resides. Note that although Xen places vcpu_info for the first
+  32 vCPUs in the shared_info page, KVM does not automatically do so
+  and requires that KVM_XEN_ATTR_TYPE_VCPU_INFO be used explicitly
+  even when the vcpu_info for a given vCPU resides at the "default"
+  location in the shared_info page. This is because KVM is not aware
+  of the Xen CPU id which is used as the index into the vcpu_info[]
+  array, so cannot know the correct default location.
+
+KVM_XEN_ATTR_TYPE_VCPU_INFO
+  Sets the guest physical address of the vcpu_info for a given vCPU.
+
+KVM_XEN_ATTR_TYPE_VCPU_TIME_INFO
+  Sets the guest physical address of an additional pvclock structure
+  for a given vCPU. This is typically used for guest vsyscall support.
+
+KVM_XEN_ATTR_TYPE_VCPU_RUNSTATE
+  Sets the guest physical address of the vcpu_runstate_info for a given
+  vCPU. This is how a Xen guest tracks CPU state such as steal time.
+
+4.128 KVM_XEN_HVM_GET_ATTR
+--------------------------
+
+:Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_xen_hvm_attr
+:Returns: 0 on success, < 0 on error
+
+Allows Xen VM attributes to be read. For the structure and types,
+see KVM_XEN_HVM_SET_ATTR above.
 
 5. The kvm_run structure
 ========================
@@ -5321,6 +5393,34 @@ wants to write. Once finished processing the event, user space must continue
 vCPU execution. If the MSR write was unsuccessful, user space also sets the
 "error" field to "1".
 
+::
+
+
+		struct kvm_xen_exit {
+  #define KVM_EXIT_XEN_HCALL          1
+			__u32 type;
+			union {
+				struct {
+					__u32 longmode;
+					__u32 cpl;
+					__u64 input;
+					__u64 result;
+					__u64 params[6];
+				} hcall;
+			} u;
+		};
+		/* KVM_EXIT_XEN */
+                struct kvm_hyperv_exit xen;
+
+Indicates that the VCPU exits into userspace to process some tasks
+related to Xen emulation.
+
+Valid values for 'type' are:
+
+  - KVM_EXIT_XEN_HCALL -- synchronously notify user-space about Xen hypercall.
+    Userspace is expected to place the hypercall result into the appropriate
+    field before invoking KVM_RUN again.
+
 ::
 
 		/* Fix the size of the union. */
@@ -6409,7 +6509,6 @@ guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
 
-
 8.29 KVM_CAP_DIRTY_LOG_RING
 ---------------------------
 
@@ -6496,3 +6595,26 @@ KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG.  After enabling
 KVM_CAP_DIRTY_LOG_RING with an acceptable dirty ring size, the virtual
 machine will switch to ring-buffer dirty page tracking and further
 KVM_GET_DIRTY_LOG or KVM_CLEAR_DIRTY_LOG ioctls will fail.
+
+8.30 KVM_CAP_XEN_HVM
+--------------------
+
+:Architectures: x86
+
+This capability indicates the features that Xen supports for hosting Xen
+PVHVM guests. Valid flags are::
+
+  #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
+  #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+  #define KVM_XEN_HVM_CONFIG_SHARED_INFO	(1 << 2)
+
+The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_CONFIG
+ioctl is available, for the guest to set its hypercall page.
+
+If KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL is also set, the same flag may also be
+provided in the flags to KVM_XEN_HVM_CONFIG, without providing hypercall page
+contents, to request that KVM generate hypercall page content automatically
+and also enable interception of guest hypercalls with KVM_EXIT_XEN.
+
+The KVM_XEN_HVM_CONFIG_SHARED_INFO flag indicates the availability of the
+KVM_XEN_HVM_SET_ATTR and KVM_XEN_HVM_GET_ATTR ioctls.
-- 
2.29.2

