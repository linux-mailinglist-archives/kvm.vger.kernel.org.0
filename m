Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7DD417ECF
	for <lists+kvm@lfdr.de>; Sat, 25 Sep 2021 02:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347000AbhIYA53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 20:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346330AbhIYA5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 20:57:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF50DC0614ED
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b5-20020a251b05000000b005b575f23711so5826851ybb.4
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 17:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=g5w58E3IGKbXWYSiPvVnlhcj+7GlkHG6CZrKZkT3vP0=;
        b=I4e5kehhED/KRR7N2cidXMqEex8CTCjyKcS2GmlIqby43yZ8ILGKXc2f8gJK+B0Mak
         qsHzsvvWsCOKQJyUk1JPfK+IGXjf6HCaHUL0FUfUcIrbIXa51o8WuFSJxvxfe1GsH4Uq
         4wkMnXqEXE0T8fqaBiVS5RKDJvfyHZounlDt3fdqbzenS67IcSjNvXGEUIO65DT9UowY
         0WWolyDLxEo23l06ilRvVvGf7N+Xj5mOiB69dEn6Jh/LGqqKzS/fLSd5iYeTHh7nJpAh
         FQSoKxIi7LGL9zafzLlsSFp9qcFmRpB1uVn56AcQPu/0zXKKSrucn7vuTNN4MAZ8uLSx
         Kfxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=g5w58E3IGKbXWYSiPvVnlhcj+7GlkHG6CZrKZkT3vP0=;
        b=x27izYHUAspFkYf+N9KJrXHrjRlmcDtnupvtgusGhBLHvAIt7p2sAvIwwGBxlgA5Pd
         H401DhFPT/6/MpK20PTMX0f76Wssn1TN5d8d7lqDpT/z1MDZrhpWhpIp7VYTaBDp5PN9
         ctjcSw+7yu+A9bvrxR7n4Dz/Aobqt+WWzwDOQWN5sGEw+vdknEV6GDNVXL6bnlnGzxFd
         YBUpA1y0aTHfQf0ggM/lOHGeYehHhYzAJxLoko983ZnUHP3I8L2a3zSp2yFVFpTx+dum
         46LUgR5hHot28kB+hUQUQv8XUOyoLc8YQDzO0Mr3xuF1jb65aKI2UJquIb3TC/CPfMN/
         UFVA==
X-Gm-Message-State: AOAM5308NHzId52kscaq9cGWcVmN+N6H0Q2XnbWj1O3PAk+6Rx7nXWKO
        p0mCSEh3VWTtAQCcTBY/76pyLGXSfEg=
X-Google-Smtp-Source: ABdhPJyiTN53g148rAgVoj1ICII7m79WO7ugJdd/HLrJy3M0TecyAbb/0CT74AaOvmAyzC41vJkVDTyrGUg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:4c72:89be:dba3:2bcb])
 (user=seanjc job=sendgmr) by 2002:a25:2789:: with SMTP id n131mr9633757ybn.440.1632531343946;
 Fri, 24 Sep 2021 17:55:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Sep 2021 17:55:20 -0700
In-Reply-To: <20210925005528.1145584-1-seanjc@google.com>
Message-Id: <20210925005528.1145584-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210925005528.1145584-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH 06/14] KVM: Drop obsolete kvm_arch_vcpu_block_finish()
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_arch_vcpu_block_finish() now that all arch implementations are
nops.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h   | 1 -
 arch/mips/include/asm/kvm_host.h    | 1 -
 arch/powerpc/include/asm/kvm_host.h | 1 -
 arch/s390/include/asm/kvm_host.h    | 2 --
 arch/s390/kvm/kvm-s390.c            | 5 -----
 arch/x86/include/asm/kvm_host.h     | 2 --
 virt/kvm/kvm_main.c                 | 1 -
 7 files changed, 13 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..4e0ad0fff540 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -716,7 +716,6 @@ void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
-static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
 void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 696f6b009377..72b90d45a46e 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -897,7 +897,6 @@ static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
-static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
 int kvm_arch_flush_remote_tlb(struct kvm *kvm);
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 59cb38b04ede..8a84448d77a6 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -864,6 +864,5 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_exit(void) {}
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
-static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
 #endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index a604d51acfc8..a22c9266ea05 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1010,6 +1010,4 @@ static inline void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
 
-void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu);
-
 #endif
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 08ed68639a21..17fabb260c35 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5080,11 +5080,6 @@ static inline unsigned long nonhyp_mask(int i)
 	return 0x0000ffffffffffffUL >> (nonhyp_fai << 4);
 }
 
-void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu)
-{
-
-}
-
 static int __init kvm_s390_init(void)
 {
 	int i;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1e0e909b98b2..4e8c21083bdb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1916,8 +1916,6 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	static_call_cond(kvm_x86_vcpu_unblocking)(vcpu);
 }
 
-static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
-
 static inline int kvm_cpu_get_apicid(int mps_cpu)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2ba22b68af3b..2015a1f532ce 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3301,7 +3301,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_vcpu_wakeup(block_ns, waited, vcpu_valid_wakeup(vcpu));
-	kvm_arch_vcpu_block_finish(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_block);
 
-- 
2.33.0.685.g46640cef36-goog

