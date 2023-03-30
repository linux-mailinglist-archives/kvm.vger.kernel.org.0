Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76376D0A5D
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 17:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbjC3PuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 11:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbjC3PuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 11:50:13 -0400
Received: from out-6.mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA32E067
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 08:49:47 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680191369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OZNWRRs9l2tEGU8s3B8ZHsDyVaJ8K1s4GblMevvvp3I=;
        b=nyu7hn5fGXUEVpV+Xh+kaQamQN4tcaQo8tmAT5NWgvooKk+dcjg8hSRcNaifQum8ygYU+f
        V5XthmHiEQUyh1t1wIgH0FFzRim97/rNp6FbQ76CBrEEkZ6IwDM7pOB1EPRwu1x57AZBe3
        jJTr5QjOYhBveNyUSrxiwRDJM002hEE=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 01/13] KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
Date:   Thu, 30 Mar 2023 15:49:06 +0000
Message-Id: <20230330154918.4014761-2-oliver.upton@linux.dev>
In-Reply-To: <20230330154918.4014761-1-oliver.upton@linux.dev>
References: <20230330154918.4014761-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'longmode' field is a bit annoying as it blows an entire __u32 to
represent a boolean value. Since other architectures are looking to add
support for KVM_EXIT_HYPERCALL, now is probably a good time to clean it
up.

Redefine the field (and the remaining padding) as a set of flags.
Preserve the existing ABI by using bit 0 to indicate if the guest was in
long mode and requiring that the remaining 31 bits must be zero.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/api.rst  | 3 +--
 arch/x86/include/asm/kvm_host.h | 7 +++++++
 arch/x86/include/uapi/asm/kvm.h | 3 +++
 arch/x86/kvm/x86.c              | 6 +++++-
 include/uapi/linux/kvm.h        | 9 +++++++--
 5 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 62de0768d6aa..9b01e3d0e757 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6218,8 +6218,7 @@ to the byte array.
 			__u64 nr;
 			__u64 args[6];
 			__u64 ret;
-			__u32 longmode;
-			__u32 pad;
+			__u64 flags;
 		} hypercall;
 
 Unused.  This was once used for 'hypercall to userspace'.  To implement
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 808c292ad3f4..15bda40517ff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2204,4 +2204,11 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
 	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS)
 
+/*
+ * KVM previously used a u32 field in kvm_run to indicate the hypercall was
+ * initiated from long mode. KVM now sets bit 0 to indicate long mode, but the
+ * remaining 31 lower bits must be 0 to preserve ABI.
+ */
+#define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7f467fe05d42..1a6a1f987949 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -559,4 +559,7 @@ struct kvm_pmu_event_filter {
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
+/* x86-specific KVM_EXIT_HYPERCALL flags. */
+#define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7713420abab0..27a1d5c1a018 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9803,7 +9803,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->run->hypercall.args[0]  = gpa;
 		vcpu->run->hypercall.args[1]  = npages;
 		vcpu->run->hypercall.args[2]  = attrs;
-		vcpu->run->hypercall.longmode = op_64_bit;
+		vcpu->run->hypercall.flags    = 0;
+		if (op_64_bit)
+			vcpu->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;
+
+		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
 		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
 		return 0;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d77aef872a0a..dd42d7dfb86c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -341,8 +341,13 @@ struct kvm_run {
 			__u64 nr;
 			__u64 args[6];
 			__u64 ret;
-			__u32 longmode;
-			__u32 pad;
+
+			union {
+#ifndef __KERNEL__
+				__u32 longmode;
+#endif
+				__u64 flags;
+			};
 		} hypercall;
 		/* KVM_EXIT_TPR_ACCESS */
 		struct {
-- 
2.40.0.348.gf938b09366-goog

