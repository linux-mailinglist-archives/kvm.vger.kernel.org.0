Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7FE16646F
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 18:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgBTRWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 12:22:48 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25539 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728882AbgBTRWP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 12:22:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582219333;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4zSPAFD+pq1zzy8dMD3rvr6m7tZzVDJbOvdVC9ghOhg=;
        b=M9qTolkYbV7N7MNTZLhNyK1uh5jAAZOrfV1km5CGExhDyagwiiXagQ45enDmEolGqz7Xa3
        mv/sqZ8VHaKvqRV84na3A2dEZD0DOM09pwiix/mNdu5zU5hrizR3qXnx1IF+8QKmUiBmg8
        Ax9qhWuA0C3We98KZri4E1SyGSox9jI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134--fPx8MlsMi2PatFyp8NUuA-1; Thu, 20 Feb 2020 12:22:12 -0500
X-MC-Unique: -fPx8MlsMi2PatFyp8NUuA-1
Received: by mail-wr1-f72.google.com with SMTP id v17so2008476wrm.17
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 09:22:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4zSPAFD+pq1zzy8dMD3rvr6m7tZzVDJbOvdVC9ghOhg=;
        b=iC5YdjWF/WgLtysVolmDf/P1+wTNzCA0x5g8S1Can7EeQzM4UbuZgBk8ZQnHts3dLp
         KEEwTLl+ITXBgjPUU4TaUt9lfX1RqdVKmeP1YVyKT3+XvQCl+exTZrp/ymPvSnCpE6nZ
         TnY408xN4rcheQn0zYyi8w1okONlSTZ/T7Q9MT1gqSiHpQgb7yZnsAoT/XrogOoA+pzu
         Kf3mEcMcXmFf5JhiDM0XtMZzNdYix/9TnSxXR/sxKMeYhTH0dK9fj93I5ZL4B/vA5T8G
         F3YGsri7zNk0MLWn7sisfAAoKglzDQkc31uuNej6qCaDDv06tEmjm2NYYhDo0wJJdYTq
         zD4g==
X-Gm-Message-State: APjAAAVqbNw/zy5NoiEAwNPpglzayK3Xxciw98/+gb7JNEW8rLrmxiA9
        FkRhDDJ7PAk8mpFBSGpaPmP23GVqrJkoTVVt1MpM9UgovE7y1v/G2hXjjoo+4wRo0zW1yGKQuW+
        xOGcSDBvu82Ur
X-Received: by 2002:a7b:c3cd:: with SMTP id t13mr5561885wmj.88.1582219330729;
        Thu, 20 Feb 2020 09:22:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqyaovZTBPl60h/IscrnJlDVyp+IMSAuBmQqHyvNDD+J1VGVoB56M/2PEkihV8OeoQNnZMmPIw==
X-Received: by 2002:a7b:c3cd:: with SMTP id t13mr5561873wmj.88.1582219330489;
        Thu, 20 Feb 2020 09:22:10 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a184sm5355891wmf.29.2020.02.20.09.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 09:22:09 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC 2/2] KVM: nVMX: handle nested posted interrupts when apicv is disabled for L1
Date:   Thu, 20 Feb 2020 18:22:05 +0100
Message-Id: <20200220172205.197767-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220172205.197767-1-vkuznets@redhat.com>
References: <20200220172205.197767-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Even when APICv is disabled for L1 it can (and, actually, is) still
available for L2, this means we need to always call
vmx_deliver_nested_posted_interrupt() when attempting an interrupt
delivery.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/lapic.c            |  5 +----
 arch/x86/kvm/svm.c              |  7 ++++++-
 arch/x86/kvm/vmx/vmx.c          | 13 +++++++++----
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 40a0c0fd95ca..a84e8c5acda8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1146,7 +1146,7 @@ struct kvm_x86_ops {
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu, hpa_t hpa);
-	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
+	int (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index afcd30d44cbb..cc8ee8125712 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1046,11 +1046,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 						       apic->regs + APIC_TMR);
 		}
 
-		if (vcpu->arch.apicv_active)
-			kvm_x86_ops->deliver_posted_interrupt(vcpu, vector);
-		else {
+		if (kvm_x86_ops->deliver_posted_interrupt(vcpu, vector)) {
 			kvm_lapic_set_irr(vector, apic);
-
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 			kvm_vcpu_kick(vcpu);
 		}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bef0ba35f121..970a3ab2e926 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5255,8 +5255,11 @@ static void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	return;
 }
 
-static void svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
+static int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 {
+	if (!vcpu->arch.apicv_active)
+		return -1;
+
 	kvm_lapic_set_irr(vec, vcpu->arch.apic);
 	smp_mb__after_atomic();
 
@@ -5268,6 +5271,8 @@ static void svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 		put_cpu();
 	} else
 		kvm_vcpu_wake_up(vcpu);
+
+	return 0;
 }
 
 static bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 946c74e661e2..92a14ea4be69 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3818,24 +3818,29 @@ static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
  * 2. If target vcpu isn't running(root mode), kick it to pick up the
  * interrupt from PIR in next vmentry.
  */
-static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
+static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int r;
 
 	r = vmx_deliver_nested_posted_interrupt(vcpu, vector);
 	if (!r)
-		return;
+		return 0;
+
+	if (!vcpu->arch.apicv_active)
+		return -1;
 
 	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
-		return;
+		return 0;
 
 	/* If a previous notification has sent the IPI, nothing to do.  */
 	if (pi_test_and_set_on(&vmx->pi_desc))
-		return;
+		return 0;
 
 	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
 		kvm_vcpu_kick(vcpu);
+
+	return 0;
 }
 
 /*
-- 
2.24.1

