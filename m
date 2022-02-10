Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C0A4B026C
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 02:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbiBJBcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 20:32:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiBJBb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 20:31:58 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A01820F51
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 17:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=WG3prxj2crGx1WaeF+/kJumw/841xmevKri51CniynQ=; b=XWDrCdiNp/HtP/j2iQHa92uAI2
        Wqy5qdxxJT+zINWdSwIWw7qvE3o0cSUwDbRlSVI6AmnWl2O9yNf/09FoJPRqeQZZPs54eE4HFxInT
        4PNGoLBNFLcGEVV+uw51SMnJJz8wBY5z5nihgM+ousTMeibf5Lkw/Mm/OphNnMtJD5R33asq2hQ1e
        U3r2CEuIPbI5c7lXGfA2NKAakDl3/fIi7k1I/OORyQncw1VzsMDfjCWv41bh5zMN/o2w+uWO5JnLv
        2Yn3OUIOnniTB6CYHvqf8yZcpSJRjZZ6Rtt/RQjjnQoIjCPh4959Bof8WW4TnvDPlJVsh/azwkARu
        iq3wXW3Q==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-008xlD-PF; Thu, 10 Feb 2022 00:27:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHxIy-0019Dm-8p; Thu, 10 Feb 2022 00:27:24 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH v0 14/15] KVM: x86/xen: Advertise and document KVM_XEN_HVM_CONFIG_EVTCHN_SEND
Date:   Thu, 10 Feb 2022 00:27:20 +0000
Message-Id: <20220210002721.273608-15-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220210002721.273608-1-dwmw2@infradead.org>
References: <20220210002721.273608-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

At the end of the patch series adding this batch of event channel
acceleration features, finally add the feature bit which advertises
them and document it all.

For SCHEDOP_poll we need to wake a polling vCPU when a given port
is triggered, even when it's masked — and we want to implement that
in the kernel, for efficiency. So we want the kernel to know that it
has sole ownership of event channel delivery. Thus, we allow
userspace to make the 'promise' by setting the corresponding feature
bit in its KVM_XEN_HVM_CONFIG call. As we implement SCHEDOP_poll
bypass later, we will do so only if that promise has been made by
userspace.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst | 129 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c             |   3 +-
 arch/x86/kvm/xen.c             |   6 +-
 include/uapi/linux/kvm.h       |   1 +
 4 files changed, 127 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..046b386f6ce3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -988,12 +988,22 @@ memory.
 	__u8 pad2[30];
   };
 
-If the KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL flag is returned from the
-KVM_CAP_XEN_HVM check, it may be set in the flags field of this ioctl.
-This requests KVM to generate the contents of the hypercall page
-automatically; hypercalls will be intercepted and passed to userspace
-through KVM_EXIT_XEN.  In this case, all of the blob size and address
-fields must be zero.
+If certain flags are returned from the KVM_CAP_XEN_HVM check, they may
+be set in the flags field of this ioctl:
+
+The KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL flag requests KVM to generate
+the contents of the hypercall page automatically; hypercalls will be
+intercepted and passed to userspace through KVM_EXIT_XEN.  In this
+ase, all of the blob size and address fields must be zero.
+
+The KVM_XEN_HVM_CONFIG_EVTCHN_SEND flag indicates to KVM that userspace
+will always use the KVM_XEN_HVM_EVTCHN_SEND ioctl to deliver event
+channel interrupts rather than manipulating the guest's shared_info
+structures directly. This, in turn, may allow KVM to enable features
+such as intercepting the SCHEDOP_poll hypercall to accelerate PV
+spinlock operation for the guest. Userspace may still use the ioctl
+to deliver events if it was advertised, even if userspace does not
+send this indication that it will always do so
 
 No other flags are currently valid in the struct kvm_xen_hvm_config.
 
@@ -5149,7 +5159,25 @@ have deterministic behavior.
 		struct {
 			__u64 gfn;
 		} shared_info;
-		__u64 pad[4];
+		struct {
+			__u32 send_port;
+			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
+			__u32 flags;
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
 	} u;
   };
 
@@ -5180,6 +5208,30 @@ KVM_XEN_ATTR_TYPE_SHARED_INFO
 
 KVM_XEN_ATTR_TYPE_UPCALL_VECTOR
   Sets the exception vector used to deliver Xen event channel upcalls.
+  This is the HVM-wide vector injected directly by the hypervisor
+  (not through the local APIC), typically configured by a guest via
+  HVM_PARAM_CALLBACK_IRQ.
+
+KVM_XEN_ATTR_TYPE_EVTCHN
+  This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
+  support for KVM_XEN_HVM_CONFIG_EVTCHN_SEND features. It configures
+  an outbound port number for interception of EVTCHNOP_send requests
+  from the guest. A given sending port number may be directed back
+  to a specified vCPU (by APIC ID) / port / priority on the guest,
+  or to trigger events on an eventfd. The vCPU and priority can be
+  changed by setting KVM_XEN_EVTCHN_UPDATE in a subsequent call,
+  but other fields cannot change for a given sending port. A port
+  mapping is removed by using KVM_XEN_EVTCHN_DEASSIGN in the flags
+  field.
+
+KVM_XEN_ATTR_TYPE_XEN_VERSION
+  This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
+  support for KVM_XEN_HVM_CONFIG_EVTCHN_SEND features. It configures
+  the 32-bit version code returned to the guest when it invokes the
+  XENVER_version call; typically (XEN_MAJOR << 16 | XEN_MINOR). PV
+  Xen guests will often use this to as a dummy hypercall to trigger
+  event channel delivery, so responding within the kernel without
+  exiting to userspace is beneficial.
 
 4.127 KVM_XEN_HVM_GET_ATTR
 --------------------------
@@ -5191,7 +5243,8 @@ KVM_XEN_ATTR_TYPE_UPCALL_VECTOR
 :Returns: 0 on success, < 0 on error
 
 Allows Xen VM attributes to be read. For the structure and types,
-see KVM_XEN_HVM_SET_ATTR above.
+see KVM_XEN_HVM_SET_ATTR above. The KVM_XEN_ATTR_TYPE_EVTCHN
+attribute cannot be read.
 
 4.128 KVM_XEN_VCPU_SET_ATTR
 ---------------------------
@@ -5218,6 +5271,13 @@ see KVM_XEN_HVM_SET_ATTR above.
 			__u64 time_blocked;
 			__u64 time_offline;
 		} runstate;
+		__u32 vcpu_id;
+		struct {
+			__u32 port;
+			__u32 priority;
+			__u64 expires_ns;
+		} timer;
+		__u8 vector;
 	} u;
   };
 
@@ -5255,6 +5315,27 @@ KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST
   or RUNSTATE_offline) to set the current accounted state as of the
   adjusted state_entry_time.
 
+KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID
+  This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
+  support for KVM_XEN_HVM_CONFIG_EVTCHN_SEND features. It sets the Xen
+  vCPU ID of the given vCPU, to allow timer-related VCPU operations to
+  be intercepted by KVM.
+
+KVM_XEN_VCPU_ATTR_TYPE_TIMER
+  This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
+  support for KVM_XEN_HVM_CONFIG_EVTCHN_SEND features. It sets the
+  event channel port/priority for the VIRQ_TIMER of the vCPU, as well
+  as allowing a pending timer to be saved/restored.
+
+KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR
+  This attribute is available when the KVM_CAP_XEN_HVM ioctl indicates
+  support for KVM_XEN_HVM_CONFIG_EVTCHN_SEND features. It sets the
+  per-vCPU local APIC upcall vector, configured by a Xen guest with
+  the HVMOP_set_evtchn_upcall_vector hypercall. This is typically
+  used by Windows guests, and is distinct from the HVM-wide upcall
+  vector configured with HVM_PARAM_CALLBACK_IRQ.
+
+
 4.129 KVM_XEN_VCPU_GET_ATTR
 ---------------------------
 
@@ -5574,6 +5655,25 @@ enabled with ``arch_prctl()``, but this may change in the future.
 The offsets of the state save areas in struct kvm_xsave follow the contents
 of CPUID leaf 0xD on the host.
 
+4.135 KVM_XEN_HVM_EVTCHN_SEND
+-----------------------------
+
+:Capability: KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND
+:Architectures: x86
+:Type: vm ioctl
+:Parameters: struct kvm_irq_routing_xen_evtchn
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+   struct kvm_irq_routing_xen_evtchn {
+	__u32 port;
+	__u32 vcpu;
+	__u32 priority;
+   };
+
+This ioctl injects an event channel interrupt directly to the guest vCPU.
 
 5. The kvm_run structure
 ========================
@@ -7472,8 +7572,9 @@ PVHVM guests. Valid flags are::
   #define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
   #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
   #define KVM_XEN_HVM_CONFIG_SHARED_INFO	(1 << 2)
-  #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 2)
-  #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 3)
+  #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+  #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
+  #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND	(1 << 5)
 
 The KVM_XEN_HVM_CONFIG_HYPERCALL_MSR flag indicates that the KVM_XEN_HVM_CONFIG
 ioctl is available, for the guest to set its hypercall page.
@@ -7497,6 +7598,14 @@ The KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL flag indicates that IRQ routing entries
 of the type KVM_IRQ_ROUTING_XEN_EVTCHN are supported, with the priority
 field set to indicate 2 level event channel delivery.
 
+The KVM_XEN_HVM_CONFIG_EVTCHN_SEND flag indicates that KVM supports
+injecting event channel events directly into the guest with the
+KVM_XEN_HVM_EVTCHN_SEND ioctl. It also indicates support for the
+KVM_XEN_ATTR_TYPE_EVTCHN/XEN_VERSION HVM attributes and the
+KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID/TIMER/UPCALL_VECTOR vCPU attributes.
+related to event channel delivery, timers, and the XENVER_version
+interception.
+
 8.31 KVM_CAP_PPC_MULTITCE
 -------------------------
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7240d791e4ab..8ef276fed7fe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4234,7 +4234,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
 		    KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
 		    KVM_XEN_HVM_CONFIG_SHARED_INFO |
-		    KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL;
+		    KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL |
+		    KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
 		if (sched_info_on())
 			r |= KVM_XEN_HVM_CONFIG_RUNSTATE;
 		break;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 60459e52a2fd..87706bcecaef 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -917,7 +917,11 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 
 int kvm_xen_hvm_config(struct kvm *kvm, struct kvm_xen_hvm_config *xhc)
 {
-	if (xhc->flags & ~KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL)
+	/* Only some feature flags need to be *enabled* by userspace */
+	u32 permitted_flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL |
+		KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
+
+	if (xhc->flags & ~permitted_flags)
 		return -EINVAL;
 
 	/*
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3506186ad16f..540495642467 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1222,6 +1222,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
-- 
2.33.1

