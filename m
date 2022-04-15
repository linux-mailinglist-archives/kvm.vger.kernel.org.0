Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14853501FBA
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 02:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348162AbiDOAq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 20:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348133AbiDOAqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 20:46:19 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEA598F45
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 17:43:52 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 64-20020a630843000000b0039d909676d5so3466900pgi.16
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 17:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=J6d3I3cnZrxLwCCfWif9ZhGI1oj0wUvU2P/xwVxpp7E=;
        b=CuSw2eeS58tcsTk9P9jmAslUqLdVK+ojiMGCsZ4mnRsJM68tbU/9liTnKHoLbh/zkB
         CET5HLBaxyV3NzCIGyi18Y9MsYS26wH5TgRQTwP+gZ5f4Ar+VKgHDYKroN/6WsiRj7RQ
         eYBX18ZmYNcQc016hYZ/tn8O9erQLGiZhEtG50W9HsvPGIl0DO3yiGcUlFKDtZvgaiVI
         NI2olXANvvBr5xbPXB5K7JCvA/atk44/If4Jg6Ey7vg9mNW0gNp3IHxnApukaQEBDfQB
         oL1lNDBwghjRrkX+QxsS4PYwTmDT6W7IGfpDDgw25D5r7VVZWAXSCZhjJlXhjA7edeTe
         gQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=J6d3I3cnZrxLwCCfWif9ZhGI1oj0wUvU2P/xwVxpp7E=;
        b=j9Xj6HANL/p/frJwki0of6BLhv6IouasX58dBEXYMsvrqv8ux7/UNWOAxUKWng/9YB
         1QLHz4IuuAlb3tto2ec3dje98E2g5xuI7ZX0hapjT8bpEgW2UstE48rfRFyRISRo2PUd
         /Akb8uYwH73Cog9TtC0TRTiST0juM7N2SZguDXzF+TCaJNssKhRU93r1csW0SSlHtXki
         AQgbL+vq0mMjN4+e5+iAwB4v2NfSFEGw8loIaVLecncsBLX0jDpy8Hz0UbCbLOZh/TM5
         oFoI19UxWZgucJUD7JSOUNpsz03GmvYnxJx1Y0DSCh6lmxEHfCLfF5kSognsXAfTLYYQ
         LuVg==
X-Gm-Message-State: AOAM530luXfAedZ7sz3ePS0ZLmXNrLr9Z7JT4Qch55tB/d0tiBi5So+q
        26vRDgox0Vx1o3d4T1zbeGhoVrq87Zw=
X-Google-Smtp-Source: ABdhPJwyjaEfxslH43Y0Hgw/F956yYwPWZ3LOHItRcDaHW9++RXdFSnPeuESTWLSl5iBgzGpFgGfSb9Cceo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a26:b0:4fd:f9dd:549c with SMTP id
 p38-20020a056a000a2600b004fdf9dd549cmr6441264pfh.42.1649983431844; Thu, 14
 Apr 2022 17:43:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Apr 2022 00:43:43 +0000
In-Reply-To: <20220415004343.2203171-1-seanjc@google.com>
Message-Id: <20220415004343.2203171-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220415004343.2203171-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 3/3] KVM: Add helpers to wrap vcpu->srcu_idx and yell if it's abused
From:   Sean Christopherson <seanjc@google.com>
To:     Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
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

Add wrappers to acquire/release KVM's SRCU lock when stashing the index
in vcpu->src_idx, along with rudimentary detection of illegal usage,
e.g. re-acquiring SRCU and thus overwriting vcpu->src_idx.  Because the
SRCU index is (currently) either 0 or 1, illegal nesting bugs can go
unnoticed for quite some time and only cause problems when the nested
lock happens to get a different index.

Wrap the WARNs in PROVE_RCU=y, and make them ONCE, otherwise KVM will
likely yell so loudly that it will bring the kernel to its knees.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  9 +++++----
 arch/powerpc/kvm/book3s_hv_nested.c    | 16 +++++++--------
 arch/powerpc/kvm/book3s_rtas.c         |  4 ++--
 arch/powerpc/kvm/powerpc.c             |  4 ++--
 arch/riscv/kvm/vcpu.c                  | 16 +++++++--------
 arch/riscv/kvm/vcpu_exit.c             |  4 ++--
 arch/s390/kvm/interrupt.c              |  4 ++--
 arch/s390/kvm/kvm-s390.c               |  8 ++++----
 arch/s390/kvm/vsie.c                   |  4 ++--
 arch/x86/kvm/x86.c                     | 28 ++++++++++++--------------
 include/linux/kvm_host.h               | 24 +++++++++++++++++++++-
 11 files changed, 71 insertions(+), 50 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index e4ce2a35483f..42851c32ff3b 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -168,9 +168,10 @@ int kvmppc_mmu_walk_radix_tree(struct kvm_vcpu *vcpu, gva_t eaddr,
 			return -EINVAL;
 		/* Read the entry from guest memory */
 		addr = base + (index * sizeof(rpte));
-		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
+
+		kvm_vcpu_srcu_read_lock(vcpu);
 		ret = kvm_read_guest(kvm, addr, &rpte, sizeof(rpte));
-		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		if (ret) {
 			if (pte_ret_p)
 				*pte_ret_p = addr;
@@ -246,9 +247,9 @@ int kvmppc_mmu_radix_translate_table(struct kvm_vcpu *vcpu, gva_t eaddr,
 
 	/* Read the table to find the root of the radix tree */
 	ptbl = (table & PRTB_MASK) + (table_index * sizeof(entry));
-	vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 	ret = kvm_read_guest(kvm, ptbl, &entry, sizeof(entry));
-	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 	if (ret)
 		return ret;
 
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 9d373f8963ee..c943a051c6e7 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -306,10 +306,10 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 	/* copy parameters in */
 	hv_ptr = kvmppc_get_gpr(vcpu, 4);
 	regs_ptr = kvmppc_get_gpr(vcpu, 5);
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 	err = kvmhv_read_guest_state_and_regs(vcpu, &l2_hv, &l2_regs,
 					      hv_ptr, regs_ptr);
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 	if (err)
 		return H_PARAMETER;
 
@@ -410,10 +410,10 @@ long kvmhv_enter_nested_guest(struct kvm_vcpu *vcpu)
 		byteswap_hv_regs(&l2_hv);
 		byteswap_pt_regs(&l2_regs);
 	}
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 	err = kvmhv_write_guest_state_and_regs(vcpu, &l2_hv, &l2_regs,
 					       hv_ptr, regs_ptr);
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 	if (err)
 		return H_AUTHORITY;
 
@@ -600,16 +600,16 @@ long kvmhv_copy_tofrom_guest_nested(struct kvm_vcpu *vcpu)
 			goto not_found;
 
 		/* Write what was loaded into our buffer back to the L1 guest */
-		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+		kvm_vcpu_srcu_read_lock(vcpu);
 		rc = kvm_vcpu_write_guest(vcpu, gp_to, buf, n);
-		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		if (rc)
 			goto not_found;
 	} else {
 		/* Load the data to be stored from the L1 guest into our buf */
-		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+		kvm_vcpu_srcu_read_lock(vcpu);
 		rc = kvm_vcpu_read_guest(vcpu, gp_from, buf, n);
-		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		if (rc)
 			goto not_found;
 
diff --git a/arch/powerpc/kvm/book3s_rtas.c b/arch/powerpc/kvm/book3s_rtas.c
index 0f847f1e5ddd..6808bda0dbc1 100644
--- a/arch/powerpc/kvm/book3s_rtas.c
+++ b/arch/powerpc/kvm/book3s_rtas.c
@@ -229,9 +229,9 @@ int kvmppc_rtas_hcall(struct kvm_vcpu *vcpu)
 	 */
 	args_phys = kvmppc_get_gpr(vcpu, 4) & KVM_PAM;
 
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 	rc = kvm_read_guest(vcpu->kvm, args_phys, &args, sizeof(args));
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 	if (rc)
 		goto fail;
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 9772b176e406..fd88c2412e83 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -425,9 +425,9 @@ int kvmppc_ld(struct kvm_vcpu *vcpu, ulong *eaddr, int size, void *ptr,
 		return EMULATE_DONE;
 	}
 
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 	rc = kvm_read_guest(vcpu->kvm, pte.raddr, ptr, size);
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 	if (rc)
 		return EMULATE_DO_MMIO;
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 2f1caf23eed4..256cf04ec01e 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -724,13 +724,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	/* Mark this VCPU ran at least once */
 	vcpu->arch.ran_atleast_once = true;
 
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 
 	/* Process MMIO value returned from user-space */
 	if (run->exit_reason == KVM_EXIT_MMIO) {
 		ret = kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
 		if (ret) {
-			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+			kvm_vcpu_srcu_read_unlock(vcpu);
 			return ret;
 		}
 	}
@@ -739,13 +739,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (run->exit_reason == KVM_EXIT_RISCV_SBI) {
 		ret = kvm_riscv_vcpu_sbi_return(vcpu, vcpu->run);
 		if (ret) {
-			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+			kvm_vcpu_srcu_read_unlock(vcpu);
 			return ret;
 		}
 	}
 
 	if (run->immediate_exit) {
-		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		return -EINTR;
 	}
 
@@ -784,7 +784,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		vcpu->mode = IN_GUEST_MODE;
 
-		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		smp_mb__after_srcu_read_unlock();
 
 		/*
@@ -802,7 +802,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
 			preempt_enable();
-			vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+			kvm_vcpu_srcu_read_lock(vcpu);
 			continue;
 		}
 
@@ -846,7 +846,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		preempt_enable();
 
-		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+		kvm_vcpu_srcu_read_lock(vcpu);
 
 		ret = kvm_riscv_vcpu_exit(vcpu, run, &trap);
 	}
@@ -855,7 +855,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	vcpu_put(vcpu);
 
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 
 	return ret;
 }
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 2d56faddb9d1..a72c15d4b42a 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -456,9 +456,9 @@ static int stage2_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
 void kvm_riscv_vcpu_wfi(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_arch_vcpu_runnable(vcpu)) {
-		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		kvm_vcpu_halt(vcpu);
-		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+		kvm_vcpu_srcu_read_lock(vcpu);
 		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 	}
 }
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 9b30beac904d..af96dc0549a4 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1334,11 +1334,11 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 	hrtimer_start(&vcpu->arch.ckc_timer, sltime, HRTIMER_MODE_REL);
 	VCPU_EVENT(vcpu, 4, "enabled wait: %llu ns", sltime);
 no_timer:
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 	kvm_vcpu_halt(vcpu);
 	vcpu->valid_wakeup = false;
 	__unset_cpu_idle(vcpu);
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 
 	hrtimer_cancel(&vcpu->arch.ckc_timer);
 	return 0;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 156d1c25a3c1..da3dabda1a12 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4237,14 +4237,14 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	 * We try to hold kvm->srcu during most of vcpu_run (except when run-
 	 * ning the guest), so that memslots (and other stuff) are protected
 	 */
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 
 	do {
 		rc = vcpu_pre_run(vcpu);
 		if (rc)
 			break;
 
-		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		/*
 		 * As PF_VCPU will be used in fault handler, between
 		 * guest_enter and guest_exit should be no uaccess.
@@ -4281,12 +4281,12 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		__enable_cpu_timer_accounting(vcpu);
 		guest_exit_irqoff();
 		local_irq_enable();
-		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+		kvm_vcpu_srcu_read_lock(vcpu);
 
 		rc = vcpu_post_run(vcpu, exit_reason);
 	} while (!signal_pending(current) && !guestdbg_exit_pending(vcpu) && !rc);
 
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 	return rc;
 }
 
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index acda4b6fc851..dada78b92691 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1091,7 +1091,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 
 	handle_last_fault(vcpu, vsie_page);
 
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 
 	/* save current guest state of bp isolation override */
 	guest_bp_isolation = test_thread_flag(TIF_ISOLATE_BP_GUEST);
@@ -1133,7 +1133,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	if (!guest_bp_isolation)
 		clear_thread_flag(TIF_ISOLATE_BP_GUEST);
 
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 
 	if (rc == -EINTR) {
 		VCPU_EVENT(vcpu, 3, "%s", "machine check");
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f35fe09de59d..bc24b35c4e80 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10157,7 +10157,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	/* Store vcpu->apicv_active before vcpu->mode.  */
 	smp_store_release(&vcpu->mode, IN_GUEST_MODE);
 
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 
 	/*
 	 * 1) We should set ->mode before checking ->requests.  Please see
@@ -10188,7 +10188,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		smp_wmb();
 		local_irq_enable();
 		preempt_enable();
-		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+		kvm_vcpu_srcu_read_lock(vcpu);
 		r = 1;
 		goto cancel_injection;
 	}
@@ -10314,7 +10314,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 	preempt_enable();
 
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 
 	/*
 	 * Profile KVM exit RIPs:
@@ -10344,7 +10344,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 }
 
 /* Called within kvm->srcu read side.  */
-static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
+static inline int vcpu_block(struct kvm_vcpu *vcpu)
 {
 	bool hv_timer;
 
@@ -10360,12 +10360,12 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 		if (hv_timer)
 			kvm_lapic_switch_to_sw_timer(vcpu);
 
-		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
 			kvm_vcpu_halt(vcpu);
 		else
 			kvm_vcpu_block(vcpu);
-		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
+		kvm_vcpu_srcu_read_lock(vcpu);
 
 		if (hv_timer)
 			kvm_lapic_switch_to_hv_timer(vcpu);
@@ -10407,7 +10407,6 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 static int vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int r;
-	struct kvm *kvm = vcpu->kvm;
 
 	vcpu->arch.l1tf_flush_l1d = true;
 
@@ -10415,7 +10414,7 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_running(vcpu)) {
 			r = vcpu_enter_guest(vcpu);
 		} else {
-			r = vcpu_block(kvm, vcpu);
+			r = vcpu_block(vcpu);
 		}
 
 		if (r <= 0)
@@ -10437,9 +10436,9 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 		}
 
 		if (__xfer_to_guest_mode_work_pending()) {
-			srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
+			kvm_vcpu_srcu_read_unlock(vcpu);
 			r = xfer_to_guest_mode_handle_work(vcpu);
-			vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
+			kvm_vcpu_srcu_read_lock(vcpu);
 			if (r)
 				return r;
 		}
@@ -10542,7 +10541,6 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *kvm_run = vcpu->run;
-	struct kvm *kvm = vcpu->kvm;
 	int r;
 
 	vcpu_load(vcpu);
@@ -10550,7 +10548,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	kvm_run->flags = 0;
 	kvm_load_guest_fpu(vcpu);
 
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	kvm_vcpu_srcu_read_lock(vcpu);
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		if (kvm_run->immediate_exit) {
 			r = -EINTR;
@@ -10562,9 +10560,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		WARN_ON_ONCE(kvm_lapic_hv_timer_in_use(vcpu));
 
-		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
+		kvm_vcpu_srcu_read_unlock(vcpu);
 		kvm_vcpu_block(vcpu);
-		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
+		kvm_vcpu_srcu_read_lock(vcpu);
 
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
@@ -10625,7 +10623,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (kvm_run->kvm_valid_regs)
 		store_regs(vcpu);
 	post_kvm_run_save(vcpu);
-	srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
 
 	kvm_sigset_deactivate(vcpu);
 	vcpu_put(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 252ee4a61b58..76fc7233bd6a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -315,7 +315,10 @@ struct kvm_vcpu {
 	int cpu;
 	int vcpu_id; /* id given by userspace at creation */
 	int vcpu_idx; /* index in kvm->vcpus array */
-	int srcu_idx;
+	int ____srcu_idx; /* Don't use this directly.  You've been warned. */
+#ifdef CONFIG_PROVE_RCU
+	int srcu_depth;
+#endif
 	int mode;
 	u64 requests;
 	unsigned long guest_debug;
@@ -841,6 +844,25 @@ static inline void kvm_vm_bugged(struct kvm *kvm)
 	unlikely(__ret);					\
 })
 
+static inline void kvm_vcpu_srcu_read_lock(struct kvm_vcpu *vcpu)
+{
+#ifdef CONFIG_PROVE_RCU
+	WARN_ONCE(vcpu->srcu_depth++,
+		  "KVM: Illegal vCPU srcu_idx LOCK, depth=%d", vcpu->srcu_depth - 1);
+#endif
+	vcpu->____srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+}
+
+static inline void kvm_vcpu_srcu_read_unlock(struct kvm_vcpu *vcpu)
+{
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->____srcu_idx);
+
+#ifdef CONFIG_PROVE_RCU
+	WARN_ONCE(--vcpu->srcu_depth,
+		  "KVM: Illegal vCPU srcu_idx UNLOCK, depth=%d", vcpu->srcu_depth);
+#endif
+}
+
 static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
 {
 	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
-- 
2.36.0.rc0.470.gd361397f0d-goog

