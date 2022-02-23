Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCC44C0AF9
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 05:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237838AbiBWEUX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 23:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236973AbiBWEUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 23:20:18 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955293BA72
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:51 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id s22-20020a252d56000000b00624652ac3e1so11005326ybe.16
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 20:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oBFB/xilh37p90MAtedZ2XW8fyKmtZw3IlbClh+i4lM=;
        b=MojSaeqqFqDqfFiYP3GR7fpzY0v5x4pnqhX3VBYwF5yFq0D4eA8efuBrFc/dN5InRf
         mU629W/8VBRhfYCTuIUgoBniLHrNo6LXoPd9LXa+r/0CWi5SI+IPG0AD/9xtQUbKA9DM
         qnXOQDrMl7O87Zece/28SpHmBowt05GTXrp4VO7BDYeGr3lUAFUEU3DYxA5TejaZCyfR
         Pre2TDI4+Sw+qtMSJRhROfX+7i9oDVeoxmQrGlR/cc/eFQyAKufXTAKy9h5Y+JamOOeo
         Wx9Df6bQi7FbV9YCBq5ObX6ISYS+95ifzqS+vZPF8Xi+Er1W+/4Dnup0fF2lCat8M1ym
         A2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oBFB/xilh37p90MAtedZ2XW8fyKmtZw3IlbClh+i4lM=;
        b=dsakwCOLO/TIREBEvABEzKZwnMCCqIYV7EHHdOHYgkVTVk6GT80QTMHitk1onFngP9
         O6uJlRuAKkdkMLL90bcbPQ5d6q4t00QC8nWzcwrUcON/QCcOwUngZDonwYj/y4dwZM0B
         1zRDEXu59ZUCJl63w7lJ6YJwGQczKmFpFZziNZn9kFs/RNYddvpGN5//xBJeebEwrh6g
         OFWN7pQM1mGTEv7RYJ3ilf5OXsV1G/dWsw75dE9b222ezLkRC90B5m0h98mzST4p3Cse
         ZurxS0tN+hCtmBxfIp6M2/CgO06RKYWWzFyVW46iS0dRvNPnG7pk2FWTHyzY7lZXjEXv
         svEQ==
X-Gm-Message-State: AOAM530tVM9Afy7e0hfzkLGAt9eGyO1aXuB+Uq1+0gngFo/kmJ/08DW3
        B3oK6fU+vFbWfJwhjbru60vLbikN3ns=
X-Google-Smtp-Source: ABdhPJz9b+hfmnwYAU6AfGGVvol/lvhuJaB4WCMZd/mum6HGubo/Jo2QgD+znembhbgJPqgYTeAp2lLJ9BI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5b:347:0:b0:610:7b35:2806 with SMTP id
 q7-20020a5b0347000000b006107b352806mr26626791ybp.486.1645589990807; Tue, 22
 Feb 2022 20:19:50 -0800 (PST)
Date:   Wed, 23 Feb 2022 04:18:38 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-14-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 13/19] KVM: arm64: Add support KVM_SYSTEM_EVENT_SUSPEND to
 PSCI SYSTEM_SUSPEND
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new system event type, KVM_SYSTEM_EVENT_SUSPEND, which indicates
to userspace that the guest has requested the VM be suspended. Userspace
can decide whether or not it wants to honor the guest's request by
changing the MP state of the vCPU. If it does not, userspace is
responsible for configuring the vCPU to return an error to the guest.
Document these expectations in the KVM API documentation.

To preserve ABI, this new exit requires explicit opt-in from userspace.
Add KVM_CAP_ARM_SYSTEM_SUSPEND which grants userspace the ability to
opt-in to these exits on a per-VM basis.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst    | 39 +++++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/arm.c              |  5 ++++
 arch/arm64/kvm/psci.c             |  5 ++++
 include/uapi/linux/kvm.h          |  2 ++
 5 files changed, 54 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b4bdbc2dcc0..1e207bbc01f5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5930,6 +5930,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
   #define KVM_SYSTEM_EVENT_WAKEUP         4
+  #define KVM_SYSTEM_EVENT_SUSPENDED      5
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -5957,6 +5958,34 @@ Valid values for 'type' are:
  - KVM_SYSTEM_EVENT_WAKEUP -- the guest is in a suspended state and KVM
    has recognized a wakeup event. Userspace may honor this event by marking
    the exiting vCPU as runnable, or deny it and call KVM_RUN again.
+ - KVM_SYSTEM_EVENT_SUSPENDED -- the guest has requested a suspension of
+   the VM.
+
+For arm/arm64:
+^^^^^^^^^^^^^^
+
+   KVM_SYSTEM_EVENT_SUSPENDED exits are enabled with the
+   KVM_CAP_ARM_SYSTEM_SUSPEND VM capability. If a guest successfully
+   invokes the PSCI SYSTEM_SUSPEND function, KVM will exit to userspace
+   with this event type.
+
+   The guest's x2 register contains the 'entry_address' where execution
+   should resume when the VM is brought out of suspend. The guest's x3
+   register contains the 'context_id' corresponding to the request. When
+   the guest resumes execution at 'entry_address', x0 should contain the
+   'context_id'. For more details on the SYSTEM_SUSPEND PSCI call, see
+   ARM DEN0022D.b 5.19 "SYSTEM_SUSPEND".
+
+   Userspace is _required_ to take action for such an exit. It must
+   either:
+
+    - Honor the guest request to suspend the VM. Userspace must reset
+      the calling vCPU, then set PC to 'entry_address' and x0 to
+      'context_id'. Userspace may request in-kernel emulation of the
+      suspension by setting the vCPU's state to KVM_MP_STATE_SUSPENDED.
+
+    - Deny the guest request to suspend the VM. Userspace must set
+      registers x1-x3 to 0 and set x0 to PSCI_RET_INTERNAL_ERROR (-6).
 
 ::
 
@@ -7580,3 +7609,13 @@ The argument to KVM_ENABLE_CAP is also a bitmask, and must be a subset
 of the result of KVM_CHECK_EXTENSION.  KVM will forward to userspace
 the hypercalls whose corresponding bit is in the argument, and return
 ENOSYS for the others.
+
+8.35 KVM_CAP_ARM_SYSTEM_SUSPEND
+-------------------------------
+
+:Capability: KVM_CAP_ARM_SYSTEM_SUSPEND
+:Architectures: arm64
+:Type: vm
+
+When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
+type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d32cab0c9752..e1c2ec18d1aa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -146,6 +146,9 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/* System Suspend Event exits enabled for the VM */
+	bool system_suspend_exits;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d2b190f32651..ce3f14a77a49 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -101,6 +101,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+		r = 0;
+		kvm->arch.system_suspend_exits = true;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -209,6 +213,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 2bb8d047cde4..a7de84cec2e4 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -245,6 +245,11 @@ static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	if (kvm->arch.system_suspend_exits) {
+		kvm_vcpu_set_system_event_exit(vcpu, KVM_SYSTEM_EVENT_SUSPEND);
+		return 0;
+	}
+
 	__kvm_reset_vcpu(vcpu, &reset_state);
 	kvm_vcpu_wfi(vcpu);
 	return 1;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index babb16c2abe5..e5bb5f15c0eb 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -445,6 +445,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
 #define KVM_SYSTEM_EVENT_WAKEUP         4
+#define KVM_SYSTEM_EVENT_SUSPEND        5
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -1136,6 +1137,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_GPA_BITS 207
 #define KVM_CAP_XSAVE2 208
 #define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_ARM_SYSTEM_SUSPEND 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.473.g83b2b277ed-goog

