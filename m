Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE822C3C91
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgKYJmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:08 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57134 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728539AbgKYJmF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:05 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 15C9C305D4F7;
        Wed, 25 Nov 2020 11:35:44 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E88B63072784;
        Wed, 25 Nov 2020 11:35:43 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 06/81] KVM: x86: add kvm_arch_vcpu_set_regs()
Date:   Wed, 25 Nov 2020 11:34:45 +0200
Message-Id: <20201125093600.2766-7-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This is needed for the KVMI_VCPU_SET_REGISTERS command, which allows
an introspection tool to override the kvm_regs structure for a specific
vCPU without clearing the pending exception. In most cases this is used
to increment the program counter.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c       | 21 ++++++++++++++-------
 include/linux/kvm_host.h |  2 ++
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 540e42341435..5951458408fb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9406,16 +9406,23 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 	kvm_rip_write(vcpu, regs->rip);
 	kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
-
-	vcpu->arch.exception.pending = false;
-
-	kvm_make_request(KVM_REQ_EVENT, vcpu);
 }
 
-int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+void kvm_arch_vcpu_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs,
+			    bool clear_exception)
 {
-	vcpu_load(vcpu);
 	__set_regs(vcpu, regs);
+
+	if (clear_exception)
+		vcpu->arch.exception.pending = false;
+
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+}
+
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	vcpu_load(vcpu);
+	kvm_arch_vcpu_set_regs(vcpu, regs, true);
 	vcpu_put(vcpu);
 	return 0;
 }
@@ -9816,7 +9823,7 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_REGS) {
-		__set_regs(vcpu, &vcpu->run->s.regs.regs);
+		kvm_arch_vcpu_set_regs(vcpu, &vcpu->run->s.regs.regs, true);
 		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_REGS;
 	}
 	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_SREGS) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 13c6b806477b..6d622d8bd339 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -904,6 +904,8 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 void kvm_arch_vcpu_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
+void kvm_arch_vcpu_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs,
+			    bool clear_exception);
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs);
 void kvm_arch_vcpu_get_sregs(struct kvm_vcpu *vcpu,
