Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72A451978FD
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgC3KUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:47 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43864 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729658AbgC3KUF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:05 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 14903307489B;
        Mon, 30 Mar 2020 13:12:53 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id EA3C8305B7A2;
        Mon, 30 Mar 2020 13:12:52 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 28/81] KVM: x86: export kvm_arch_vcpu_set_guest_debug()
Date:   Mon, 30 Mar 2020 13:12:15 +0300
Message-Id: <20200330101308.21702-29-alazar@bitdefender.com>
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

This function is needed for the KVMI_EVENT_BP event.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c       | 18 +++++++++++++-----
 include/linux/kvm_host.h |  2 ++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bfd8e3515c0d..4a4d6663608a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9103,14 +9103,12 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
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
@@ -9156,10 +9154,20 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
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
index 3cfc38ef4048..158fc782bf4a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -869,6 +869,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state);
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg);
+int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
+				  struct kvm_guest_debug *dbg);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 
 int kvm_arch_init(void *opaque);
