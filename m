Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1446C243E
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjCTWKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCTWKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:10:30 -0400
Received: from out-15.mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A908E7AB1
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:10:29 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679350227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+XiBxGfsjUg95FnqWRFuaz/dPR+dRUpm3lhu6gZLKLg=;
        b=NJUoRrnc+WDDTcff4YSz7aXejsXWd7b1iVUTWZ73Vo5+oSFVmXPcg2dAuc25uTaCTATCpA
        h9Aoq0Z3SoLNidcT5Eq4Sy+WFS/EDE7IuMVuPGLSSYeZae68JLVv0Z9YFikCp4c3u9C/AS
        pdrBJsdrxznkQFiVy5Nm8y96Q4lKORo=
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
Subject: [PATCH 01/11] KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
Date:   Mon, 20 Mar 2023 22:09:52 +0000
Message-Id: <20230320221002.4191007-2-oliver.upton@linux.dev>
In-Reply-To: <20230320221002.4191007-1-oliver.upton@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
Preserve the existing ABI by using the lower 32 bits of the field to
indicate if the guest was in long mode at the time of the hypercall.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/x86/include/uapi/asm/kvm.h | 9 +++++++++
 arch/x86/kvm/x86.c              | 5 ++++-
 include/uapi/linux/kvm.h        | 9 +++++++--
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7f467fe05d42..ab7b7b1d7c9d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -559,4 +559,13 @@ struct kvm_pmu_event_filter {
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
+/*
+ * x86-specific KVM_EXIT_HYPERCALL flags.
+ *
+ * KVM previously used a u32 field to indicate the hypercall was initiated from
+ * long mode. As such, the lower 32 bits of the flags are used for long mode to
+ * preserve ABI.
+ */
+#define KVM_EXIT_HYPERCALL_LONG_MODE	GENMASK_ULL(31, 0)
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7713420abab0..c61c2b0c73bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9803,7 +9803,10 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->run->hypercall.args[0]  = gpa;
 		vcpu->run->hypercall.args[1]  = npages;
 		vcpu->run->hypercall.args[2]  = attrs;
-		vcpu->run->hypercall.longmode = op_64_bit;
+		vcpu->run->hypercall.flags    = 0;
+		if (op_64_bit)
+			vcpu->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;
+
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
2.40.0.rc1.284.g88254d51c5-goog

