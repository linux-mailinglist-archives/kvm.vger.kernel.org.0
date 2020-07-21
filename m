Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82EA228AF1
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731295AbgGUVSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:22 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37986 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731212AbgGUVQB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C935C305D7E9;
        Wed, 22 Jul 2020 00:09:19 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id AA309303EF35;
        Wed, 22 Jul 2020 00:09:19 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 07/84] KVM: x86: add kvm_arch_vcpu_set_regs()
Date:   Wed, 22 Jul 2020 00:08:05 +0300
Message-Id: <20200721210922.7646-8-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This is needed for the KVMI_VCPU_SET_REGISTERS command,
without clearing the pending exception.

The KVMI_VCPU_SET_REGISTERS commmand allows the introspectiont tool to
override the kvm_regs structure of a specific vCPU. But in most cases
this is used to increment the program counter.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c       | 21 ++++++++++++++-------
 include/linux/kvm_host.h |  2 ++
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 10410ebda034..e973ffe04d54 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8970,16 +8970,23 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
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
@@ -9386,7 +9393,7 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_REGS) {
-		__set_regs(vcpu, &vcpu->run->s.regs.regs);
+		kvm_arch_vcpu_set_regs(vcpu, &vcpu->run->s.regs.regs, true);
 		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_REGS;
 	}
 	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_SREGS) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 23ab4932f7e7..49cbd175f45b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -866,6 +866,8 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 void kvm_arch_vcpu_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
+void kvm_arch_vcpu_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs,
+			    bool clear_exception);
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs);
 void kvm_arch_vcpu_get_sregs(struct kvm_vcpu *vcpu,
