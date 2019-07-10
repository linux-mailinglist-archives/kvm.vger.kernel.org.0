Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4432A63E96
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 02:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfGJA0V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 9 Jul 2019 20:26:21 -0400
Received: from mx7.zte.com.cn ([202.103.147.169]:50328 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfGJA0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 20:26:21 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id 0AD18C49280A697936D4;
        Wed, 10 Jul 2019 08:26:13 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x6A0Po56035564;
        Wed, 10 Jul 2019 08:25:50 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019071008260808-2222445 ;
          Wed, 10 Jul 2019 08:26:08 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     pbonzini@redhat.com
Cc:     rkrcmar@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, sean.j.christopherson@intel.com,
        up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: [PATCH v2] kvm: x86: Fix -Wmissing-prototypes warnings
Date:   Wed, 10 Jul 2019 08:24:03 +0800
Message-Id: <1562718243-46068-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-10 08:26:08,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-10 08:25:53
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-MAIL: mse-fl2.zte.com.cn x6A0Po56035564
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We get a warning when build kernel W=1:

arch/x86/kvm/../../../virt/kvm/eventfd.c:48:1: warning: no previous prototype for ‘kvm_arch_irqfd_allowed’ [-Wmissing-prototypes]
 kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
 ^

The reason is kvm_arch_irqfd_allowed() is declared in arch/x86/kvm/irq.h,
which is not included by eventfd.c. Considering kvm_arch_irqfd_allowed()
is a weakly defined function in eventfd.c, remove the declaration to
kvm_host.h can fix this.

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
v2: add comments about the reason.
---
 arch/x86/kvm/irq.h       | 1 -
 include/linux/kvm_host.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index d6519a3..7c6233d 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -102,7 +102,6 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
 	return mode != KVM_IRQCHIP_NONE;
 }
 
-bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d1ad38a..5f04005 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -990,6 +990,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
 				   struct kvm_irq_ack_notifier *kian);
 int kvm_request_irq_source_id(struct kvm *kvm);
 void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
+bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 
 /*
  * search_memslots() and __gfn_to_memslot() are here because they are
-- 
1.8.3.1

