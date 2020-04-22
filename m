Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC22F1B4581
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgDVM6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:58:22 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:50949 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725810AbgDVM6V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 08:58:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0TwJzjgy_1587560292;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TwJzjgy_1587560292)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 Apr 2020 20:58:12 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@linux.alibaba.com
Subject: [PATCH v2 1/7] KVM: s390: clean up redundant 'kvm_run' parameters
Date:   Wed, 22 Apr 2020 20:58:04 +0800
Message-Id: <20200422125810.34847-2-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
References: <20200422125810.34847-1-tianjia.zhang@linux.alibaba.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
structure. Earlier than historical reasons, many kvm-related function
parameters retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time.
This patch does a unified cleanup of these remaining redundant parameters.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/s390/kvm/kvm-s390.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e335a7e5ead7..d7bb2e7a07ff 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4176,8 +4176,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
-static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void sync_regs_fmt2(struct kvm_vcpu *vcpu)
 {
+	struct kvm_run *kvm_run = vcpu->run;
 	struct runtime_instr_cb *riccb;
 	struct gs_cb *gscb;
 
@@ -4235,7 +4236,7 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		}
 		if (vcpu->arch.gs_enabled) {
 			current->thread.gs_cb = (struct gs_cb *)
-						&vcpu->run->s.regs.gscb;
+						&kvm_run->s.regs.gscb;
 			restore_gs_cb(current->thread.gs_cb);
 		}
 		preempt_enable();
@@ -4243,8 +4244,10 @@ static void sync_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	/* SIE will load etoken directly from SDNX and therefore kvm_run */
 }
 
-static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void sync_regs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_run *kvm_run = vcpu->run;
+
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX)
 		kvm_s390_set_prefix(vcpu, kvm_run->s.regs.prefix);
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_CRS) {
@@ -4257,23 +4260,23 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		vcpu->arch.sie_block->ckc = kvm_run->s.regs.ckc;
 	}
 	save_access_regs(vcpu->arch.host_acrs);
-	restore_access_regs(vcpu->run->s.regs.acrs);
+	restore_access_regs(kvm_run->s.regs.acrs);
 	/* save host (userspace) fprs/vrs */
 	save_fpu_regs();
 	vcpu->arch.host_fpregs.fpc = current->thread.fpu.fpc;
 	vcpu->arch.host_fpregs.regs = current->thread.fpu.regs;
 	if (MACHINE_HAS_VX)
-		current->thread.fpu.regs = vcpu->run->s.regs.vrs;
+		current->thread.fpu.regs = kvm_run->s.regs.vrs;
 	else
-		current->thread.fpu.regs = vcpu->run->s.regs.fprs;
-	current->thread.fpu.fpc = vcpu->run->s.regs.fpc;
+		current->thread.fpu.regs = kvm_run->s.regs.fprs;
+	current->thread.fpu.fpc = kvm_run->s.regs.fpc;
 	if (test_fp_ctl(current->thread.fpu.fpc))
 		/* User space provided an invalid FPC, let's clear it */
 		current->thread.fpu.fpc = 0;
 
 	/* Sync fmt2 only data */
 	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu))) {
-		sync_regs_fmt2(vcpu, kvm_run);
+		sync_regs_fmt2(vcpu);
 	} else {
 		/*
 		 * In several places we have to modify our internal view to
@@ -4292,8 +4295,10 @@ static void sync_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->kvm_dirty_regs = 0;
 }
 
-static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void store_regs_fmt2(struct kvm_vcpu *vcpu)
 {
+	struct kvm_run *kvm_run = vcpu->run;
+
 	kvm_run->s.regs.todpr = vcpu->arch.sie_block->todpr;
 	kvm_run->s.regs.pp = vcpu->arch.sie_block->pp;
 	kvm_run->s.regs.gbea = vcpu->arch.sie_block->gbea;
@@ -4313,8 +4318,10 @@ static void store_regs_fmt2(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	/* SIE will save etoken directly into SDNX and therefore kvm_run */
 }
 
-static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
+static void store_regs(struct kvm_vcpu *vcpu)
 {
+	struct kvm_run *kvm_run = vcpu->run;
+
 	kvm_run->psw_mask = vcpu->arch.sie_block->gpsw.mask;
 	kvm_run->psw_addr = vcpu->arch.sie_block->gpsw.addr;
 	kvm_run->s.regs.prefix = kvm_s390_get_prefix(vcpu);
@@ -4324,16 +4331,16 @@ static void store_regs(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	kvm_run->s.regs.pft = vcpu->arch.pfault_token;
 	kvm_run->s.regs.pfs = vcpu->arch.pfault_select;
 	kvm_run->s.regs.pfc = vcpu->arch.pfault_compare;
-	save_access_regs(vcpu->run->s.regs.acrs);
+	save_access_regs(kvm_run->s.regs.acrs);
 	restore_access_regs(vcpu->arch.host_acrs);
 	/* Save guest register state */
 	save_fpu_regs();
-	vcpu->run->s.regs.fpc = current->thread.fpu.fpc;
+	kvm_run->s.regs.fpc = current->thread.fpu.fpc;
 	/* Restore will be done lazily at return */
 	current->thread.fpu.fpc = vcpu->arch.host_fpregs.fpc;
 	current->thread.fpu.regs = vcpu->arch.host_fpregs.regs;
 	if (likely(!kvm_s390_pv_cpu_is_protected(vcpu)))
-		store_regs_fmt2(vcpu, kvm_run);
+		store_regs_fmt2(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
@@ -4371,7 +4378,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
-	sync_regs(vcpu, kvm_run);
+	sync_regs(vcpu);
 	enable_cpu_timer_accounting(vcpu);
 
 	might_fault();
@@ -4393,7 +4400,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	}
 
 	disable_cpu_timer_accounting(vcpu);
-	store_regs(vcpu, kvm_run);
+	store_regs(vcpu);
 
 	kvm_sigset_deactivate(vcpu);
 
-- 
2.17.1

