Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468CB42763B
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244568AbhJICRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244421AbhJICRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:17:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8427FC0613AB
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y16-20020a2586d0000000b005b752db8f97so14926237ybm.18
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=55YfyLhMwNaRUScBeXWYLQcHUBDZGdNHeb4QvoQSFyE=;
        b=C9t4uCApsnS68i3KeThREaZe1Om+7Tp6CUDNf13J8E2BemfJEmkFtqcFwUAJufMVG0
         3WOLQFovIcCgHqQjc76I/Bb0RIN+B8Z777pX6m6sLBFwdTtCa87oR4HWw8W6pADqeqG2
         QgUYUEV3xUzi5O46w1OCtmTdfddkVtZfkufO6ZAREf4t4CTBbAXPgnb7eruajoxMEvZx
         gCBjUgNPJ65sSMFZJJ8LojLsxPquqyHqOv0DC5H3uJyc2iDg6eA0A7oeegQMAdRUi/Aw
         WUM3JuhaNVZIdEjfnGeX3lFU5I9xVxnDQhJTwRYwm4Q6N5wAp2zXvscnBr8P/79r34/t
         9KlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=55YfyLhMwNaRUScBeXWYLQcHUBDZGdNHeb4QvoQSFyE=;
        b=wlN3GoLcHDp6urkjInvP3BAyxL5WwkVa98RI6hT+Yi75hbkQ/eouercbVBute50Oms
         hjiCaKdHtJ02DH1H/ctBKVs1qKLr3e9tDds/3ZoJV7uBh0oGcQhBRJqe0bft2nhrEQOY
         +r6ccLq9ZTyVbezZmyjAe07L9TPy60ZdCLIJcUixaZPQCafcPQE8hGAmFIQR8swmcfW3
         4CmKPYhyCPulSN4yOaTBxG9vkJSoBl5W5YrTZ+AZUhAGtnshKWxxXFLTikhqyWWH5PhI
         OEsa434vKA5bL+yB8UaE+3uTFafDjdeBsa2jcA4XT/iqUxmMpBhK0fxsEVkcSMUORDhN
         od1g==
X-Gm-Message-State: AOAM531YeMQuTaP9R/E3j5Roke73cq5ft/BSV0TF9fzkEsQiyXj2Nc04
        s/iuSwc2/iCbC59wVsdUVSquENMfaCE=
X-Google-Smtp-Source: ABdhPJxjSI94TgUwx52krVH0O+S/pIZKhRKzmwxzVW6y/1e67T6fOupN9aoHyYhZTK7KMTNPYcyhb6P2J28=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:5545:: with SMTP id j66mr6891804ybb.288.1633745630724;
 Fri, 08 Oct 2021 19:13:50 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:21 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-29-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 28/43] KVM: VMX: Remove vCPU from PI wakeup list before
 updating PID.NV
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

Remove the vCPU from the wakeup list before updating the notification
vector in the posted interrupt post-block helper.  There is no need to
wake the current vCPU as it is by definition not blocking.  Practically
speaking this is a nop as it only shaves a few meager cycles in the
unlikely case that the vCPU was migrated and the previous pCPU gets a
wakeup IRQ right before PID.NV is updated.  The real motivation is to
allow for more readable code in the future, when post-block is merged
with vmx_vcpu_pi_load(), at which point removal from the list will be
conditional on the old notification vector.

Opportunistically add comments to document why KVM has a per-CPU spinlock
that, at first glance, appears to be taken only on the owning CPU.
Explicitly call out that the spinlock must be taken with IRQs disabled, a
detail that was "lost" when KVM switched from spin_lock_irqsave() to
spin_lock(), with IRQs disabled for the entirety of the relevant path.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 49 +++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 2b2206339174..901b7a5f7777 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -10,10 +10,22 @@
 #include "vmx.h"
 
 /*
- * We maintain a per-CPU linked-list of vCPU, so in wakeup_handler() we
- * can find which vCPU should be waken up.
+ * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
+ * when a WAKEUP_VECTOR interrupted is posted.  vCPUs are added to the list when
+ * the vCPU is scheduled out and is blocking (e.g. in HLT) with IRQs enabled.
+ * The vCPUs posted interrupt descriptor is updated at the same time to set its
+ * notification vector to WAKEUP_VECTOR, so that posted interrupt from devices
+ * wake the target vCPUs.  vCPUs are removed from the list and the notification
+ * vector is reset when the vCPU is scheduled in.
  */
 static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
+/*
+ * Protect the per-CPU list with a per-CPU spinlock to handle task migration.
+ * When a blocking vCPU is awakened _and_ migrated to a different pCPU, the
+ * ->sched_in() path will need to take the vCPU off the list of the _previous_
+ * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
+ * occur if a wakeup IRQ arrives and attempts to acquire the lock.
+ */
 static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
 
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
@@ -101,23 +113,28 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
 	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
 	     "Wakeup handler not enabled while the vCPU was blocking");
 
-	dest = cpu_physical_id(vcpu->cpu);
-	if (!x2apic_mode)
-		dest = (dest << 8) & 0xFF00;
-
-	do {
-		old.control = new.control = READ_ONCE(pi_desc->control);
-
-		new.ndst = dest;
-
-		/* set 'NV' to 'notification vector' */
-		new.nv = POSTED_INTR_VECTOR;
-	} while (cmpxchg64(&pi_desc->control, old.control,
-			   new.control) != old.control);
-
+	/*
+	 * Remove the vCPU from the wakeup list of the _previous_ pCPU, which
+	 * will not be the same as the current pCPU if the task was migrated.
+	 */
 	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
 	list_del(&vcpu->blocked_vcpu_list);
 	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
+
+	dest = cpu_physical_id(vcpu->cpu);
+	if (!x2apic_mode)
+		dest = (dest << 8) & 0xFF00;
+
+	do {
+		old.control = new.control = READ_ONCE(pi_desc->control);
+
+		new.ndst = dest;
+
+		/* set 'NV' to 'notification vector' */
+		new.nv = POSTED_INTR_VECTOR;
+	} while (cmpxchg64(&pi_desc->control, old.control,
+			   new.control) != old.control);
+
 	vcpu->pre_pcpu = -1;
 }
 
-- 
2.33.0.882.g93a45727a2-goog

