Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E8E543F61
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 00:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbiFHWp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 18:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbiFHWpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 18:45:22 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DC02504C3
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 15:45:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-30c2aa26ebfso187396947b3.4
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 15:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Aj47vH7bOM7CIvT8Dyt2GzqDM34J/7dBeBUz69774ew=;
        b=FvUPMqERCr+vn5DAlXucDMK8JQYwnBC6iD8ztZR5A8TbC0iMs2oNwezvO8LZsbk2Bd
         JAnaOUZlOiKhfVjCBJhHExnscF2eISgVrvFq+nbT+JmZ7aqhE2tG9XNQZLeCqXw8yDHQ
         FHC3PRf0jU40rP479ZovjS3+Cu/81X9UX9pbb3DjmdXZGlRx1JB2Wep4jVFaj5DVxZrO
         25RiEmgEBl0NQ1gGT7yrntGFbguPrYyNx2VpcH7B6YueRUaLHp5ioeHiaIX5zViGdvaj
         dvqZ3w7+J+wTbq734pXBBu9nywfJaXrQvl4ybyZbRWZFvkS4gMVHZbQUF+Nph9rz2J4b
         HAqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Aj47vH7bOM7CIvT8Dyt2GzqDM34J/7dBeBUz69774ew=;
        b=wC0kWGSmL02FHOGPLdvGIUIluNwO2yMH4Qg00wNuRNBg49nedPm5RMzzxEAC5O2NQQ
         YlwtLXD0ZbGHJFyDTiQ+/lP9yMBobxKotIf50sA4TTlw9JA+0Ui949ghGY0tfBi4ivdy
         rGK4PD0PTbofA+dRJRvALJ8jMgrAeCBIi9CpoF5QBvOmQgMDJtiOUzCUeQHMSd2uIbD1
         Fd+j6ZAh5hSn/GEW8BnD4UGpqkhXTknPLrtfGkPD0NiPAEdkAqjtKh1yOidHQEscNbl+
         qwthNuAX4UpQ7Vbq18VCuUixYmfazJHc1/qjAULke9npHGDe1r4OcBUgdS2lWvdElrI4
         8B4A==
X-Gm-Message-State: AOAM531XkPG11s226wzXwwiEBS7EHNUe8lqLvXSNN/f4xL7plAW1AQJ7
        93o1iH9sFG/isauZp8M6MSJjNpBJMEc=
X-Google-Smtp-Source: ABdhPJwitxoDkwVjT8ngUL3WN+GVfi9ZRSFxFHUCta7tvzet9Zy5A3/DRpzqmKRGgeqbz97ywWxxDaO5gjo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a0d:d843:0:b0:30e:c210:87a4 with SMTP id
 a64-20020a0dd843000000b0030ec21087a4mr39532146ywe.313.1654728321051; Wed, 08
 Jun 2022 15:45:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 22:45:12 +0000
In-Reply-To: <20220608224516.3788274-1-seanjc@google.com>
Message-Id: <20220608224516.3788274-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220608224516.3788274-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 1/5] KVM: x86: Add a quirk for KVM's "MONITOR/MWAIT are NOPs!" behavior
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Add a quirk for KVM's behavior of emulating intercepted MONITOR/MWAIT
instructions a NOPs regardless of whether or not they are supported in
guest CPUID.  KVM's current behavior was likely motiviated by a certain
fruity operating system that expects MONITOR/MWAIT to be supported
unconditionally and blindly executes MONITOR/MWAIT without first checking
CPUID.  And because KVM does NOT advertise MONITOR/MWAIT to userspace,
that's effectively the default setup for any VMM that regurgitates
KVM_GET_SUPPORTED_CPUID to KVM_SET_CPUID2.

Note, this quirk interacts with KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT.  The
behavior is actually desirable, as userspace VMMs that want to
unconditionally hide MONITOR/MWAIT from the guest can leave the
MISC_ENABLE quirk enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst  | 13 +++++++++++++
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/x86.c              | 26 +++++++++++++++++---------
 4 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 42a1984fafc8..5c6cd8f7975f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7374,6 +7374,19 @@ The valid bits in cap.args[0] are:
                                     hypercall instructions. Executing the
                                     incorrect hypercall instruction will
                                     generate a #UD within the guest.
+
+KVM_X86_QUIRK_MWAIT_NEVER_FAULTS    By default, KVM emulates MONITOR/MWAIT (if
+                                    they are intercepted) as NOPs regardless of
+                                    whether or not MONITOR/MWAIT are supported
+                                    according to guest CPUID.  When this quirk
+                                    is disabled and KVM_X86_DISABLE_EXITS_MWAIT
+                                    is not set (MONITOR/MWAIT are intercepted),
+                                    KVM will inject a #UD on MONITOR/MWAIT if
+                                    they're unsupported per guest CPUID.  Note,
+                                    KVM will modify MONITOR/MWAIT support in
+                                    guest CPUID on writes to MISC_ENABLE if
+                                    KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT is
+                                    disabled.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6cf5d77d7896..bc3e85a81f41 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2011,6 +2011,7 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_LAPIC_MMIO_HOLE |	\
 	 KVM_X86_QUIRK_OUT_7E_INC_RIP |		\
 	 KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT |	\
-	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN)
+	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
+	 KVM_X86_QUIRK_MWAIT_NEVER_FAULTS)
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 24c807c8d5f7..b7c92844550b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -438,6 +438,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_OUT_7E_INC_RIP		(1 << 3)
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT	(1 << 4)
 #define KVM_X86_QUIRK_FIX_HYPERCALL_INSN	(1 << 5)
+#define KVM_X86_QUIRK_MWAIT_NEVER_FAULTS	(1 << 6)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2db6f0373fa3..14abcd5c2714 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2034,13 +2034,6 @@ int kvm_emulate_invd(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_invd);
 
-int kvm_emulate_mwait(struct kvm_vcpu *vcpu)
-{
-	pr_warn_once("kvm: MWAIT instruction emulated as NOP!\n");
-	return kvm_emulate_as_nop(vcpu);
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_mwait);
-
 int kvm_handle_invalid_op(struct kvm_vcpu *vcpu)
 {
 	kvm_queue_exception(vcpu, UD_VECTOR);
@@ -2048,10 +2041,25 @@ int kvm_handle_invalid_op(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_handle_invalid_op);
 
+
+static int kvm_emulate_monitor_mwait(struct kvm_vcpu *vcpu, const char *insn)
+{
+	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MWAIT_NEVER_FAULTS) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_MWAIT))
+		return kvm_handle_invalid_op(vcpu);
+
+	pr_warn_once("kvm: %s instruction emulated as NOP!\n", insn);
+	return kvm_emulate_as_nop(vcpu);
+}
+int kvm_emulate_mwait(struct kvm_vcpu *vcpu)
+{
+	return kvm_emulate_monitor_mwait(vcpu, "MWAIT");
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_mwait);
+
 int kvm_emulate_monitor(struct kvm_vcpu *vcpu)
 {
-	pr_warn_once("kvm: MONITOR instruction emulated as NOP!\n");
-	return kvm_emulate_as_nop(vcpu);
+	return kvm_emulate_monitor_mwait(vcpu, "MONITOR");
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_monitor);
 
-- 
2.36.1.255.ge46751e96f-goog

