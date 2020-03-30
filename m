Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091C41978E0
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgC3KUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:09 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43866 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729723AbgC3KUH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id BB4DD30747C5;
        Mon, 30 Mar 2020 13:12:49 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 9C39A305B7A0;
        Mon, 30 Mar 2020 13:12:49 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 08/81] KVM: x86: add kvm_arch_vcpu_set_regs()
Date:   Mon, 30 Mar 2020 13:11:55 +0300
Message-Id: <20200330101308.21702-9-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This is needed for the KVMI_VCPU_SET_REGISTERS command,
but without clearing the pending exception.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c       | 21 ++++++++++++++-------
 include/linux/kvm_host.h |  2 ++
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d45b5093fdd3..7f23e015fc86 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8819,16 +8819,23 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
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
@@ -9235,7 +9242,7 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_REGS) {
-		__set_regs(vcpu, &vcpu->run->s.regs.regs);
+		kvm_arch_vcpu_set_regs(vcpu, &vcpu->run->s.regs.regs, true);
 		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_REGS;
 	}
 	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_SREGS) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 18b7d2a259b7..3cfc38ef4048 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -855,6 +855,8 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 void kvm_arch_vcpu_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs);
+void kvm_arch_vcpu_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs,
+			    bool clear_exception);
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs);
 void kvm_arch_vcpu_get_sregs(struct kvm_vcpu *vcpu,
