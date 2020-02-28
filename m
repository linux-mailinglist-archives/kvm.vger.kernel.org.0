Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88717172D6E
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 01:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgB1Af3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 19:35:29 -0500
Received: from mail-yw1-f73.google.com ([209.85.161.73]:41245 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730034AbgB1Af2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 19:35:28 -0500
Received: by mail-yw1-f73.google.com with SMTP id q128so2368821ywb.8
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 16:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PuYSDpfkod6UnkA/hNIPxRv/jbAeDf/uATgjnhPNCyM=;
        b=u1wSsBnw/72eubi79/mmoedTR6kl05GWhw+696wERJlphxtg2+LkFgJXFDT7WREF2p
         Pj7a6uImQ/X/mYKAwhykXT9EeRPgZUqsywg0aF5xPhu8ASwqBjkxlb/dbOwzIZu7DAfL
         ncx8T57yI56nF+RnZHj+KUkHx2K2e1ebgefwR3FH4INR2bu50lWIDBmaunkZJhfKJdV3
         XiEwYW5D7/GwYiYPhWoM4UUFeS6gPmHrKJEY3FG9Vj/EBWAQHUpmwEIb+SVedmJtPDK6
         RBpIVI16N+zeDK+K2xysSvqIZrcREazXE/39uCGSVcEfigXpM8qK/CYIq6itqFC7EByH
         Fucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PuYSDpfkod6UnkA/hNIPxRv/jbAeDf/uATgjnhPNCyM=;
        b=kmPyH/eGKWtnxbReVmFZ3Xt03bPzhlal53IT/paRKTC8hXbsySQAfgl4N728bthUpn
         ApbTd3UBAa07607X2wpjUIfYDi5iN6GwOXk2jEunQCB6EIeHQUbHQSGNg4jafRoUxtso
         ZhMZYANONYt7h9c/lCR5QNrHQvfxQqcQfz3B9BBSeVe7LfZYyWm9FvzytrIUGfrtAwLa
         FLfdTkarxWbonOs8Q+uYTpGSTqVV5JxuPY1fzqeL8l/fgPP73iR0WEeMVWRdnI0jAAWh
         9WX5Py4eM3Ki/v81oQetTQfIohc+3oCj0uQss8g0hP+P1U0b4BPwRSEYTJw9IlGyjgr5
         Zp1Q==
X-Gm-Message-State: APjAAAXxvqBrC6dzur0k45Tl2riSKt8jNe6DnmyVjMATh/9CLhUo32Fd
        ZtUjtfOVQ//AvIhKlDcOifRfl83bGGcuaqh45Ih7g0sEllqubuSJDBn55Q3rZkcTPkso04PK3gI
        Znw0qCBxw6m36yc/8Evx5PBuAVGxGsEH8DXPgKDPSNKR8+BXsHcLU8kdOWQ==
X-Google-Smtp-Source: APXvYqy3/ZmH1e9HDgkRt0Qni8tFP7I/6rx7aZgyWAkVXzPtrfhsDomW4QC0gGikzeW9/QD8rPQc1sEcHgM=
X-Received: by 2002:a81:23c2:: with SMTP id j185mr1995486ywj.465.1582850127714;
 Thu, 27 Feb 2020 16:35:27 -0800 (PST)
Date:   Thu, 27 Feb 2020 16:35:23 -0800
Message-Id: <20200228003523.114071-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH] KVM: SVM: Inhibit APIC virtualization for X2APIC guest
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AVIC does not support guest use of the x2APIC interface. Currently,
KVM simply chooses to squash the x2APIC feature in the guest's CPUID
If the AVIC is enabled. Doing so prevents KVM from running a guest
with greater than 255 vCPUs, as such a guest necessitates the use
of the x2APIC interface.

Instead, inhibit AVIC enablement on a per-VM basis whenever the x2APIC
feature is set in the guest's CPUID. Since this changes the behavior of
KVM as seen by userspace, add a module parameter, avic_per_vm, to opt-in
for the new behavior. If this parameter is set, report x2APIC as
available on KVM_GET_SUPPORTED_CPUID. Without opt-in, continue to
suppress x2APIC from the guest's CPUID.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---

 Parent commit: a93236fcbe1d ("KVM: s390: rstify new ioctls in api.rst")

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              | 19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 98959e8cd448..9d40132a3ae2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -890,6 +890,7 @@ enum kvm_irqchip_mode {
 #define APICV_INHIBIT_REASON_NESTED     2
 #define APICV_INHIBIT_REASON_IRQWIN     3
 #define APICV_INHIBIT_REASON_PIT_REINJ  4
+#define APICV_INHIBIT_REASON_X2APIC	5
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ad3f5b178a03..95c03c75f51a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -382,6 +382,10 @@ module_param(sev, int, 0444);
 static bool __read_mostly dump_invalid_vmcb = 0;
 module_param(dump_invalid_vmcb, bool, 0644);
 
+/* enable/disable opportunistic use of the AVIC on a per-VM basis */
+static bool __read_mostly avic_per_vm;
+module_param(avic_per_vm, bool, 0444);
+
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
 
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
@@ -6027,7 +6031,15 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
-	guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
+	/*
+	 * AVIC does not work with an x2APIC mode guest. If the X2APIC feature
+	 * is exposed to the guest, disable AVIC.
+	 */
+	if (avic_per_vm && guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
+		kvm_request_apicv_update(vcpu->kvm, false,
+					 APICV_INHIBIT_REASON_X2APIC);
+	else
+		guest_cpuid_clear(vcpu, X86_FEATURE_X2APIC);
 
 	/*
 	 * Currently, AVIC does not work with nested virtualization.
@@ -6044,7 +6056,7 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
 {
 	switch (func) {
 	case 0x1:
-		if (avic)
+		if (avic && !avic_per_vm)
 			entry->ecx &= ~F(X2APIC);
 		break;
 	case 0x80000001:
@@ -7370,7 +7382,8 @@ static bool svm_check_apicv_inhibit_reasons(ulong bit)
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
-			  BIT(APICV_INHIBIT_REASON_PIT_REINJ);
+			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
+			  BIT(APICV_INHIBIT_REASON_X2APIC);
 
 	return supported & BIT(bit);
 }
-- 
2.25.1.481.gfbce0eb801-goog

