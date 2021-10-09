Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D06A4275B5
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244206AbhJICOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244196AbhJICOt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:14:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C02C061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:12:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j193-20020a2523ca000000b005b789d71d9aso14933988ybj.21
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cmY3ciYgK0Pw7Nc3yQ2tKxt4RfIVgRouhF9jfsbApsU=;
        b=QbQVaw+LEXAnvKqqBqFc88s4xq502vqu1GE3XpXsagKgQF+sSH5oy9ZN3Riurg0uam
         NboPaoBoD+NTvzrr76ut0oSCAr/dobocjfxXDCgfKREM1WgGlcHv/XKBbx+8XlSywjl9
         v6gbyQ/DSMA6ibdL//jX5ac88VgPO68Yar5tSoyOjvQU7DWuLyOGlTMs1EcHp6GBd7t8
         zDaqFcWWP1eS2XcbCz8YiWyZQMO7D8kVYM83EyYLTsNWw/FWNJEOnWDm+n66w3yiKT4b
         k4mJC2lWsO+wgHdIF9UIkXA7mXBDmZvdXGiRS4k0umncgko4hmVixQMSV1g0v0Xm3Xav
         bXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cmY3ciYgK0Pw7Nc3yQ2tKxt4RfIVgRouhF9jfsbApsU=;
        b=GeLQJm4Uw6Lr02MspL8bzDAzaiHCX25cQ8JfLemIVdm0K4bic/3ixMD3No2I+Rjvyw
         vys3gGloNT23PFpGHk2VOOtSJu9ZCo0/eY+TLXSs3MVAYhpDC8G6a0YLyC1nBNL3kASP
         hSPOkIKHbeGteU/bM9pdKXoi0FkusYDxQI3/jWZBeQ+qA8QChlU4ThMiW7+VjUNtT8u2
         O9JNKywSR4LDukSIIJB8gviSI18Y3I9wL1NkD4EwPAiR/Odlp9h1kud3EXi4FDZTBYqq
         koZRUUdT5f1TFxcabRzYxZyVTjf1hSEnGCm5ORmPV+KqA528/Pfez/GasmygNGgAhocC
         XxNg==
X-Gm-Message-State: AOAM53230e4i7XEr/k5T5M+9XPsjpDqp7PlFVfjmdmr7U0iJn2rZ8pf2
        SN18DOZz6XFgcAR4qzNxEK1NKbRS428=
X-Google-Smtp-Source: ABdhPJxDfkHFA9j3YHwNecv1+8g7k+RRNV2EAtanrld0mWMeRHqp+zJFBO4S5rRqjxsoT4caGrG4+Mlfzmc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:bc0e:: with SMTP id i14mr6935877ybh.324.1633745571812;
 Fri, 08 Oct 2021 19:12:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:11:57 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 04/43] KVM: Force PPC to define its own rcuwait object
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
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
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not define/reference kvm_vcpu.wait if __KVM_HAVE_ARCH_WQP is true, and
instead force the architecture (PPC) to define its own rcuwait object.
Allowing common KVM to directly access vcpu->wait without a guard makes
it all too easy to introduce potential bugs, e.g. kvm_vcpu_block(),
kvm_vcpu_on_spin(), and async_pf_execute() all operate on vcpu->wait, not
the result of kvm_arch_vcpu_get_wait(), and so may do the wrong thing for
PPC.

Due to PPC's shenanigans with respect to callbacks and waits (it switches
to the virtual core's wait object at KVM_RUN!?!?), it's not clear whether
or not this fixes any bugs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/powerpc/include/asm/kvm_host.h | 1 +
 arch/powerpc/kvm/powerpc.c          | 3 ++-
 include/linux/kvm_host.h            | 2 ++
 virt/kvm/async_pf.c                 | 2 +-
 virt/kvm/kvm_main.c                 | 9 ++++++---
 5 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 59cb38b04ede..876c10803cda 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -749,6 +749,7 @@ struct kvm_vcpu_arch {
 	u8 irq_pending; /* Used by XIVE to signal pending guest irqs */
 	u32 last_inst;
 
+	struct rcuwait wait;
 	struct rcuwait *waitp;
 	struct kvmppc_vcore *vcore;
 	int ret;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 8ab90ce8738f..be22da157569 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -762,7 +762,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		goto out_vcpu_uninit;
 
-	vcpu->arch.waitp = &vcpu->wait;
+	rcuwait_init(&vcpu->arch.wait);
+	vcpu->arch.waitp = &vcpu->arch.wait;
 	kvmppc_create_vcpu_debugfs(vcpu, vcpu->vcpu_id);
 	return 0;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 60a35d9fe259..1ced2914d9ca 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -310,7 +310,9 @@ struct kvm_vcpu {
 	struct mutex mutex;
 	struct kvm_run *run;
 
+#ifndef __KVM_HAVE_ARCH_WQP
 	struct rcuwait wait;
+#endif
 	struct pid __rcu *pid;
 	int sigset_active;
 	sigset_t sigset;
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index dd777688d14a..ccb35c22785e 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -85,7 +85,7 @@ static void async_pf_execute(struct work_struct *work)
 
 	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
 
-	rcuwait_wake_up(&vcpu->wait);
+	rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
 
 	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7bc38549487e..5d4a90032277 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -421,7 +421,9 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
 	vcpu->pid = NULL;
+#ifndef __KVM_HAVE_ARCH_WQP
 	rcuwait_init(&vcpu->wait);
+#endif
 	kvm_async_pf_vcpu_init(vcpu);
 
 	vcpu->pre_pcpu = -1;
@@ -3213,6 +3215,7 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
  */
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
+	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 	bool halt_poll_allowed = !kvm_arch_no_poll(vcpu);
 	ktime_t start, cur, poll_end;
 	bool waited = false;
@@ -3251,7 +3254,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	}
 
 
-	prepare_to_rcuwait(&vcpu->wait);
+	prepare_to_rcuwait(wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
@@ -3261,7 +3264,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		waited = true;
 		schedule();
 	}
-	finish_rcuwait(&vcpu->wait);
+	finish_rcuwait(wait);
 	cur = ktime_get();
 	if (waited) {
 		vcpu->stat.generic.halt_wait_ns +=
@@ -3460,7 +3463,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (vcpu == me)
 				continue;
-			if (rcuwait_active(&vcpu->wait) &&
+			if (rcuwait_active(kvm_arch_vcpu_get_wait(vcpu)) &&
 			    !vcpu_dy_runnable(vcpu))
 				continue;
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
-- 
2.33.0.882.g93a45727a2-goog

