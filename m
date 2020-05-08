Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F781CB910
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 22:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgEHUhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 16:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727108AbgEHUhG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 16:37:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1FFC05BD43
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 13:37:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h185so3542081ybg.6
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 13:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=w4qW/VNK1GgqP6kbHy5LSEPtJWF2jV3O0V1qObPzmFA=;
        b=c5Ie1kbX0guPcgMQEvwztbLcikBY8qYpIPyKl3/uQuStvCvAktbbhjFssCEcZTaxd+
         0+ITTk+kGrgK5h/OGT1lXOzuQ4BOAuVlfqIajuk3C1aTO5OkBsUIYhkZIQEjMsQnANo8
         XPVOGgz7GEMttLQPYVw9fwsiJyhSlrPp1WWuhMGBMm6KBycDfdSFf4z+zJtwtl25kklW
         27QXlBaTIIRUfcnhlDaJgHBOkuY6tutdbG/RRLYlyyx8TkqnR4VCtVL7TjIJELkj3kax
         qTz+rHmp/mo/O98POKM0h94siSAVBIdTh52loifb0qvF07qsEfRN7qUnX6NsYOLNx2fJ
         2e5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=w4qW/VNK1GgqP6kbHy5LSEPtJWF2jV3O0V1qObPzmFA=;
        b=QIgK/mitHMWhJWnbt9UOZRqosthYwEMM44sDrz+JhPuDr0K+pKe/G++gX4uA92l5gT
         822SVxTGmjsu/qkzZjCnEg7zBF5z+xm7GxVZwSxSKnDpm7Bu48IApmkcqwOfmCs0YEXh
         i5bZp7nnlTEp84kLd/8b3qRJ77SEb2qWbd0ZX/7N5rT5Xfy3wq+qfAq+l8covDRpf+SS
         +m56EZCgDIW2KIwo93jKv56nsEWTBIBviBUwoqBzqZgtoQEeVV2RL2myOqYO8nPJvU5j
         i+IQORcBKVJU/gY9WzM0keJqMj2r3WeQvFjpDAo2C4pBtUX8Ut7pl3g2h6075liwX5wj
         3wMA==
X-Gm-Message-State: AGi0PuaRxuqTj1WZsjAJV25DLPpsyxJzjbYGY2Ko9zThz+DqlYfRJYT8
        9/wXqWopoS1dXzaiL7TgJ15MaTVZPQ8oVjUXS44U5IKeZq51Dxp/SBx2TvxXKsMo6lswIu6oo8G
        S3bWgDQ1nG73sKtC4zG5ky4RF94fxj9gcB0Y2tQtR/utUCRAtHh6TvrxHU0DlmQg=
X-Google-Smtp-Source: APiQypKH0sBHGa5DkYxxf1H3iw4LhgfmRCRIOY2M6wDnkw/EWf4VgkJ3aYEXF2GDVwk8/enrmY14dXMwL7qwKg==
X-Received: by 2002:a25:ac13:: with SMTP id w19mr8083110ybi.467.1588970225447;
 Fri, 08 May 2020 13:37:05 -0700 (PDT)
Date:   Fri,  8 May 2020 13:36:43 -0700
In-Reply-To: <20200508203643.85477-1-jmattson@google.com>
Message-Id: <20200508203643.85477-4-jmattson@google.com>
Mime-Version: 1.0
References: <20200508203643.85477-1-jmattson@google.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH 3/3] KVM: nVMX: Migrate the VMX-preemption timer
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hrtimer used to emulate the VMX-preemption timer must be pinned to
the same logical processor as the vCPU thread to be interrupted if we
want to have any hope of adhering to the architectural specification
of the VMX-preemption timer. Even with this change, the emulated
VMX-preemption timer VM-exit occasionally arrives too late.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/irq.c              |  2 ++
 arch/x86/kvm/vmx/vmx.c          | 11 +++++++++++
 3 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d3984a..a47c71d13039 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1254,6 +1254,8 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+
+	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index e330e7d125f7..54f7ea68083b 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -159,6 +159,8 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
 {
 	__kvm_migrate_apic_timer(vcpu);
 	__kvm_migrate_pit_timer(vcpu);
+	if (kvm_x86_ops.migrate_timers)
+		kvm_x86_ops.migrate_timers(vcpu);
 }
 
 bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2c6335a998c..3896dea72082 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7687,6 +7687,16 @@ static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	return to_vmx(vcpu)->nested.vmxon;
 }
 
+static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
+{
+	if (is_guest_mode(vcpu)) {
+		struct hrtimer *timer = &to_vmx(vcpu)->nested.preemption_timer;
+
+		if (hrtimer_try_to_cancel(timer) == 1)
+			hrtimer_start_expires(timer, HRTIMER_MODE_ABS_PINNED);
+	}
+}
+
 static void hardware_unsetup(void)
 {
 	if (nested)
@@ -7838,6 +7848,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+	.migrate_timers = vmx_migrate_timers,
 };
 
 static __init int hardware_setup(void)
-- 
2.26.2.645.ge9eca65c58-goog

