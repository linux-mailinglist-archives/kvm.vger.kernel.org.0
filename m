Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C83287FAE
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437132AbfHIQUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:41 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53320 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437097AbfHIQT6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:19:58 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 60BF3305D3D5;
        Fri,  9 Aug 2019 19:00:57 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E7403305B7A4;
        Fri,  9 Aug 2019 19:00:56 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>
Subject: [RFC PATCH v6 14/92] kvm: introspection: handle introspection commands before returning to guest
Date:   Fri,  9 Aug 2019 18:59:29 +0300
Message-Id: <20190809160047.8319-15-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

The introspection requests (KVM_REQ_INTROSPECTION) are checked by any
introspected vCPU in two places:

  * on its way to guest - vcpu_enter_guest()
  * when halted - kvm_vcpu_block()

In kvm_vcpu_block(), we check to see if there are any introspection
requests during the swait loop, handle them outside of swait loop and
start swait again.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c   |  3 +++
 include/linux/kvmi.h |  2 ++
 virt/kvm/kvm_main.c  | 28 ++++++++++++++++++++++------
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0163e1ad1aaa..adbdb1ceb618 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7742,6 +7742,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 */
 		if (kvm_check_request(KVM_REQ_HV_STIMER, vcpu))
 			kvm_hv_process_stimers(vcpu);
+
+		if (kvm_check_request(KVM_REQ_INTROSPECTION, vcpu))
+			kvmi_handle_requests(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index e8d25d7da751..ae5de1905b55 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -16,6 +16,7 @@ int kvmi_ioctl_event(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset);
 int kvmi_vcpu_init(struct kvm_vcpu *vcpu);
 void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu);
+void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -25,6 +26,7 @@ static inline void kvmi_create_vm(struct kvm *kvm) { }
 static inline void kvmi_destroy_vm(struct kvm *kvm) { }
 static inline int kvmi_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
 static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
+static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 94f15f393e37..2e11069b9565 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2282,16 +2282,32 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_blocking(vcpu);
 
 	for (;;) {
-		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
+		bool do_kvmi_work = false;
 
-		if (kvm_vcpu_check_block(vcpu) < 0)
-			break;
+		for (;;) {
+			prepare_to_swait_exclusive(&vcpu->wq, &wait,
+						   TASK_INTERRUPTIBLE);
+
+			if (kvm_vcpu_check_block(vcpu) < 0)
+				break;
+
+			waited = true;
+			schedule();
+
+			if (kvm_check_request(KVM_REQ_INTROSPECTION, vcpu)) {
+				do_kvmi_work = true;
+				break;
+			}
+		}
 
-		waited = true;
-		schedule();
+		finish_swait(&vcpu->wq, &wait);
+
+		if (do_kvmi_work)
+			kvmi_handle_requests(vcpu);
+		else
+			break;
 	}
 
-	finish_swait(&vcpu->wq, &wait);
 	cur = ktime_get();
 
 	kvm_arch_vcpu_unblocking(vcpu);
