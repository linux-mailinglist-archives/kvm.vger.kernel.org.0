Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6176E2C3C7D
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbgKYJl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:41:58 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57190 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727611AbgKYJl5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:57 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 581E7305D508;
        Wed, 25 Nov 2020 11:35:46 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3AC2C3072784;
        Wed, 25 Nov 2020 11:35:46 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 22/81] KVM: x86: export kvm_arch_vcpu_set_guest_debug()
Date:   Wed, 25 Nov 2020 11:35:01 +0200
Message-Id: <20201125093600.2766-23-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This function is needed in order to notify the introspection tool
through KVMI_VCPU_EVENT_BP events on guest breakpoints.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c       | 18 +++++++++++++-----
 include/linux/kvm_host.h |  2 ++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 816801d6c95d..00ab76366868 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9684,14 +9684,12 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
-					struct kvm_guest_debug *dbg)
+int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
+				  struct kvm_guest_debug *dbg)
 {
 	unsigned long rflags;
 	int i, r;
 
-	vcpu_load(vcpu);
-
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
 		r = -EBUSY;
 		if (vcpu->arch.exception.pending)
@@ -9737,10 +9735,20 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	r = 0;
 
 out:
-	vcpu_put(vcpu);
 	return r;
 }
 
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
+{
+	int ret;
+
+	vcpu_load(vcpu);
+	ret = kvm_arch_vcpu_set_guest_debug(vcpu, dbg);
+	vcpu_put(vcpu);
+	return ret;
+}
+
 /*
  * Translate a guest virtual address to a guest physical address.
  */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6d622d8bd339..2c640ea9d7ba 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -919,6 +919,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
+int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
+				  struct kvm_guest_debug *dbg);
 
 int kvm_arch_init(void *opaque);
 void kvm_arch_exit(void);
