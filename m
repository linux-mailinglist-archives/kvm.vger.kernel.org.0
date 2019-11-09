Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 658F6F5DC3
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 08:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfKIHFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Nov 2019 02:05:45 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44821 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfKIHFp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Nov 2019 02:05:45 -0500
Received: by mail-pl1-f196.google.com with SMTP id az9so4462778plb.11;
        Fri, 08 Nov 2019 23:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZKFRaOW+bpKPizxwZqQQG7355BbFkJUXxhEyGAxMrv0=;
        b=nnha3lfJRQmONkwwgg50/QP/4dlQvjSaO5o5IPqzM9GS54CqrHf4BLZ4dLPQfM3Zen
         OF5a7jJpXT27bbSJDVzSnE++OQXlx9aNhCMbPPAnX6Utp4RK9hLGVSjxq0qV5SVpjh56
         PTH3AQpujuhK0IyRwGCv6E5fV78vHIjZC0C7NCkz58aUQVJcuNwd7FThsXqdSwpVFU8f
         zWI4iEL3S3pmXvWc/ew0fu1YaHJ4QBiDzonEtPzKMfV1dO04bflyRjn9JqfSVKPYwF7+
         9Rz06tTW9w2ffLF7y9TPFi02IoLNqvIlLW5Lz7IB20ScIVyfjMFammz+TseXzEIthUOW
         ACDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZKFRaOW+bpKPizxwZqQQG7355BbFkJUXxhEyGAxMrv0=;
        b=tsYwt6jbJeGOgF1rqIZ8uQwtB3opZ2x9aoUsbLJbVvUJZYAs/znHYzllt7xawp779u
         XD53a342zkId8ohXhsQ70sigURcyJhX3zfHj8zeDf3cnsBghHs0o+3HxzfmRvEhNko2y
         dIvUCEpP+/34PlCHGL1vhtRqLIyPv9DDV/WTO/IM6Y1fKjoUWBLFqnY5enpsFZAduMaE
         /dJ62QnxIZXnmnBeOrxEVZUgNiqtDs0PQ2kL6cxW65ZvAF69QU3fP48NkVP514rEnzvJ
         OQCog4aKUjdORP8F3bjCf+cL5Kc7U/0jzwaXLf99JmrZVpQ09oVgEAJk+HuDwzmix+8p
         iyzg==
X-Gm-Message-State: APjAAAXqFY00slSwtXh7AYfNav4/u3REUVwzqDf5qdInF1COkBRZCc8W
        CvKYfAUuObhH8mmDHsLGyoAPJiDp
X-Google-Smtp-Source: APXvYqxvLpU0EGwB6Ipl7KdzI3cos3MwFxaj9xVmqoY7KF8XHkgILa0n1a3yb7lFMz5SW+7F5l1MLw==
X-Received: by 2002:a17:902:b585:: with SMTP id a5mr14956646pls.191.1573283143879;
        Fri, 08 Nov 2019 23:05:43 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id b200sm8337991pfb.86.2019.11.08.23.05.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Nov 2019 23:05:43 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/2] KVM: LAPIC: micro-optimize fixed mode ipi delivery
Date:   Sat,  9 Nov 2019 15:05:35 +0800
Message-Id: <1573283135-5502-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
References: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

After disabling mwait/halt/pause vmexits, RESCHEDULE_VECTOR and
CALL_FUNCTION_SINGLE_VECTOR etc IPI is one of the main remaining
cause of vmexits observed in product environment which can't be
optimized by PV IPIs. This patch is the follow-up on commit
0e6d242eccdb (KVM: LAPIC: Micro optimize IPI latency), to optimize
redundancy logic before fixed mode ipi is delivered in the fast
path.

- broadcast handling needs to go slow path, so the delivery mode repair
  can be delayed to before slow path.
- self-IPI will not be intervened by hypervisor any more after APICv is
  introduced and the boxes support APICv are popular now. In addition,
  kvm_apic_map_get_dest_lapic() can handle the self-IPI, so there is no
  need a shortcut for the non-APICv case.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/irq_comm.c | 6 +++---
 arch/x86/kvm/lapic.c    | 5 -----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 8ecd48d..aa88156 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -52,15 +52,15 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 	unsigned long dest_vcpu_bitmap[BITS_TO_LONGS(KVM_MAX_VCPUS)];
 	unsigned int dest_vcpus = 0;
 
+	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
+		return r;
+
 	if (irq->dest_mode == 0 && irq->dest_id == 0xff &&
 			kvm_lowest_prio_delivery(irq)) {
 		printk(KERN_INFO "kvm: apic: phys broadcast and lowest prio\n");
 		irq->delivery_mode = APIC_DM_FIXED;
 	}
 
-	if (kvm_irq_delivery_to_apic_fast(kvm, src, irq, &r, dest_map))
-		return r;
-
 	memset(dest_vcpu_bitmap, 0, sizeof(dest_vcpu_bitmap));
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b29d00b..ea936fa 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -951,11 +951,6 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 
 	*r = -1;
 
-	if (irq->shorthand == APIC_DEST_SELF) {
-		*r = kvm_apic_set_irq(src->vcpu, irq, dest_map);
-		return true;
-	}
-
 	rcu_read_lock();
 	map = rcu_dereference(kvm->arch.apic_map);
 
-- 
2.7.4

