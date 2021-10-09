Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4AF427626
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244517AbhJICQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244588AbhJICQS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:16:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA23C0613E4
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:39 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso15004405ybq.10
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=U1tiLVYe+uI6GynZ+KQaLRA7FrCZBu6OMUfWvRALpKY=;
        b=a0dUiDnuPYQQeQR8jjKdumWe754GISZ9QQg3r88Y9DPMivvvQMFzh5ozOn9lgZsXNq
         EANJ0517a1qk3IJoQbDKT/HbLrXOUwIqcNyu7+dfgeXxAYoz4kpH6adSQnkUxJfAgZaH
         UPUzp5K5Wp61nwf9+BQC7R2+G4acKBHUtHtY2hEJqpIlphtwlmsMneENvaDHUPfYIfWA
         ce641KOEb7G5/eE8IiwGpPr2d3hjmLvvlL+U/IoLXhsAHo2ay+SC7X4AbXIrGRjqgSKf
         IvYRZoNRXUDoSssc3WxQQYPxSY6c1N4ujAzz18+PUihtVJsRky6YFUvr+8O4bpS4z7of
         nYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=U1tiLVYe+uI6GynZ+KQaLRA7FrCZBu6OMUfWvRALpKY=;
        b=O8s5aI9Pn1QAS+Z3OW4QWjXHf3OPtEc7JzDUcCRShz7gQ1QrbAAKBUj2Ca+fjOhhxF
         MZhzcHBb7RNMbFVEzl2uEzT+cshZfEHQiZSRUsGOORNYR7d1A4Xntb3qyCEzUb+vo+CY
         fNG9u9K1mYIBli7U2sPOJueB99oKEiLakTrmQuo0k0+pOH4PtlfZM6GxShPiZ+LpIKWt
         F6IBvjIO2xIyYCWhcK41bcPT0DiW5qT1GxegwYC+lSF8ecOEVEzWAxTMmbZl9oaWtU3k
         VV+amftrpuWW/NtjfUeRtx9LuRpueVwJo3x1NMGgLudXB+YvDHnbsILdfscpgcBnD6dA
         IEMQ==
X-Gm-Message-State: AOAM533EJgTgD5tJj29E77OAsT6XoWu/GJ15GeCP1uIMarJGuuqYI/p8
        bW/KPuJqBCGGQ8zx0YMsA4ZMEh+rnHE=
X-Google-Smtp-Source: ABdhPJxgCS3VlMfHSnl5qi0AADkiPF1Y5hzLatGiCcOeklrDazrBVCyGloG341BJ/seTJPIOJhGhWWtHs4E=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a5b:145:: with SMTP id c5mr7344586ybp.60.1633745618610;
 Fri, 08 Oct 2021 19:13:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:16 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-24-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 23/43] KVM: VMX: Use boolean returns for Posted Interrupt
 "test" helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return bools instead of ints for the posted interrupt "test" helpers.
The bit position of the flag being test does not matter to the callers,
and is in fact lost by virtue of test_bit() itself returning a bool.

Returning ints is potentially dangerous, e.g. "pi_test_on(pi_desc) == 1"
is safe-ish because ON is bit 0 and thus any sane implementation of
pi_test_on() will work, but for SN (bit 1), checking "== 1" would rely on
pi_test_on() to return 0 or 1, a.k.a. bools, as opposed to 0 or 2 (the
positive bit position).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 4 ++--
 arch/x86/kvm/vmx/posted_intr.h | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 6c2110d91b06..1688f8dc535a 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -185,7 +185,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 			   new.control) != old.control);
 
 	/* We should not block the vCPU if an interrupt is posted for it.  */
-	if (pi_test_on(pi_desc) == 1)
+	if (pi_test_on(pi_desc))
 		__pi_post_block(vcpu);
 
 	local_irq_enable();
@@ -216,7 +216,7 @@ void pi_wakeup_handler(void)
 			blocked_vcpu_list) {
 		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-		if (pi_test_on(pi_desc) == 1)
+		if (pi_test_on(pi_desc))
 			kvm_vcpu_kick(vcpu);
 	}
 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 7f7b2326caf5..36ae035f14aa 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -40,7 +40,7 @@ static inline bool pi_test_and_clear_on(struct pi_desc *pi_desc)
 			(unsigned long *)&pi_desc->control);
 }
 
-static inline int pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
+static inline bool pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
 {
 	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
 }
@@ -74,13 +74,13 @@ static inline void pi_clear_sn(struct pi_desc *pi_desc)
 		(unsigned long *)&pi_desc->control);
 }
 
-static inline int pi_test_on(struct pi_desc *pi_desc)
+static inline bool pi_test_on(struct pi_desc *pi_desc)
 {
 	return test_bit(POSTED_INTR_ON,
 			(unsigned long *)&pi_desc->control);
 }
 
-static inline int pi_test_sn(struct pi_desc *pi_desc)
+static inline bool pi_test_sn(struct pi_desc *pi_desc)
 {
 	return test_bit(POSTED_INTR_SN,
 			(unsigned long *)&pi_desc->control);
-- 
2.33.0.882.g93a45727a2-goog

