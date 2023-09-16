Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AD27A2C2B
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238685AbjIPAcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238788AbjIPAcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:32:45 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FC7E6D
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:32:07 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8109d3a3bbso3247079276.2
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824327; x=1695429127; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=g87cF9aMFFIIQhALNgZyjDSNT/0Iy7aXKR5wCizfY2Q=;
        b=giSg+gCVVOrEc5FageiFHVw+1BxDfcFg66J/ZK03jIn36YcQJk+0YdoenOOm/R/oor
         a6/ngPIASQipZXnEE77CELpl9diiITyIIh4TnRIqTGgT4YIhNXP+iHw6YPv1LKJnK6Ei
         qL6X04A6yM7kcWetXaCIFFt+0VQXyr1zOy3CDM7BpsbM3FwLgTbKTAqqO6AVkdGggrvv
         MRnZNzzkxCyLUheux/fXhwHwIV1fehB4bA4KbUdMZF+F/wKTeL3zVEvQEmA/8u3GJ84b
         gyDZvo481bvF5xePOkCFKztqAczCgieO4PAWhkCniU7jMdWbkJP6atgKTXgoAe1wmSud
         2a+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824327; x=1695429127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g87cF9aMFFIIQhALNgZyjDSNT/0Iy7aXKR5wCizfY2Q=;
        b=Zc5UrsXCHfnKNjrNAY/PM68HGOjlxPkGGt6cY9kJApUiSd8Wvc4/ZOHzsVqPZQkz5e
         EWoJM9j0T0NeIA6roM60I+TkWm95eKRNBhCrGF8g9ilKmtyvL8T3kmS+9sLh/stjV1tI
         X9KYSlcOVUzahcjYNFvVGs1zCp5bG+864DOoenYeU/ygx3W2Y/gU4xc1XnTxGu4IPp8b
         jOlmL8jaV07txNcVVN70TNQ6P5/iDiGNU6dgZGl76WDD2NiT3xqMDekt5Xj36e1q5ieK
         o+xZEkC5FpeC1UHzIvaqZWvGj/dpSLTkb/wucH493HSiCQyd0J/6FWnlR1zwJezW67aO
         wD9w==
X-Gm-Message-State: AOJu0YyFZ1saI/kJ05FQG3bZjOgBuCxfa6O9crQjlcHM/Z9Iz+iS968M
        Gw91BolZthvstj4Ff7YPsBJ2rX6vcDI=
X-Google-Smtp-Source: AGHT+IFjtTFMkJb5nyS/TbDu5WGvlim/mDgHE3y34bDt9PwwLEa+gj6fWVowFGkCoq7czWyFJVVkIfy0aAQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d28b:0:b0:d0c:c83b:94ed with SMTP id
 j133-20020a25d28b000000b00d0cc83b94edmr70330ybg.10.1694824326852; Fri, 15 Sep
 2023 17:32:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:31:15 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-24-seanjc@google.com>
Subject: [PATCH 23/26] KVM: arm64: Move and consolidate "public" functions in asm/kvm_host.h
From:   Sean Christopherson <seanjc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move a variety of "public" symbols in arm64's kvm_host.h, i.e. symbols and
functions that are used by non-KVM code, towards the top of the header.
This will allow hiding the "private" code in kvm_host.h, i.e. the stuff
that is intended to be KVM-internal, with a minimal amount of #ifdeffery.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 48 ++++++++++++++-----------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 90cfbf420545..89b40c34f0af 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -67,10 +67,32 @@ enum kvm_mode {
 };
 #ifdef CONFIG_KVM
 enum kvm_mode kvm_get_mode(void);
+
+extern phys_addr_t hyp_mem_base;
+extern phys_addr_t hyp_mem_size;
+void __init kvm_hyp_reserve(void);
+
+void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
+void kvm_clr_pmu_events(u32 clr);
+bool kvm_set_pmuserenr(u64 val);
 #else
 static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
+
+static inline void kvm_hyp_reserve(void) { }
+
+static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
+static inline void kvm_clr_pmu_events(u32 clr) {}
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
 #endif
 
+static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
+{
+	return (!has_vhe() && attr->exclude_host);
+}
+
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int __ro_after_init kvm_sve_max_vl;
@@ -1086,28 +1108,10 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu);
 
-static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
-{
-	return (!has_vhe() && attr->exclude_host);
-}
-
 /* Flags for host debug state */
 void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 
-#ifdef CONFIG_KVM
-void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr);
-void kvm_clr_pmu_events(u32 clr);
-bool kvm_set_pmuserenr(u64 val);
-#else
-static inline void kvm_set_pmu_events(u32 set, struct perf_event_attr *attr) {}
-static inline void kvm_clr_pmu_events(u32 clr) {}
-static inline bool kvm_set_pmuserenr(u64 val)
-{
-	return false;
-}
-#endif
-
 void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu);
 void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu);
 
@@ -1142,14 +1146,6 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 	(test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &(kvm)->arch.flags))
 
 int kvm_trng_call(struct kvm_vcpu *vcpu);
-#ifdef CONFIG_KVM
-extern phys_addr_t hyp_mem_base;
-extern phys_addr_t hyp_mem_size;
-void __init kvm_hyp_reserve(void);
-#else
-static inline void kvm_hyp_reserve(void) { }
-#endif
-
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
-- 
2.42.0.459.ge4e396fd5e-goog

