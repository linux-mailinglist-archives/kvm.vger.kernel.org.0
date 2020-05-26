Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2801A529B
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 17:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgDKPgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Apr 2020 11:36:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44925 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgDKPgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Apr 2020 11:36:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id c15so5405149wro.11
        for <kvm@vger.kernel.org>; Sat, 11 Apr 2020 08:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B2CzJLWFMYmwwsJYkKy73SfkMclBkma4uy8He2m3Tts=;
        b=kLbpBgYaLHFmewHYp4Q3UGHwEX4tG7XpLHGlJS9nbRLhX0nvwmnYyw+xl0spj3VZFn
         IZ+/U6rZpJrO5TKOeLtC68csBWkpTanCirN7yhRhaiXSKEx06b7lOKmbNB6AesT0r/69
         FVAUz4ODsTAo4B2FMqIUlp7krLyIdgd8NSyTdeL2MI2ZvB8lgtKv+eig2WujqzHfI3XD
         Pvgpvk+tKTwqyFxNL29lLmkzZ15s2e676uZxOlEqNpAiCK1QkWKqO9KbqPHCBoGPSMt4
         IHqzpmA0uBR+gPhiI/e8zu8QB7wjX0XPuTNECW7AlZSazavSx/slj6hpqjn2VQbLqKcd
         mWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B2CzJLWFMYmwwsJYkKy73SfkMclBkma4uy8He2m3Tts=;
        b=pVpYRop2GA/HBRsN81erkaUXbtVRg6vMI1of8+Fbc+95a+Nr7rBPHZgBt+ulKMfna1
         Z8L/z99sKWtVeVN5GMr2p+PZLxutMwjprr/lJzkKRQgEw5JyB1Y7YgduGWwMl6Ph2Q4q
         gEbY3lsV93HjXH3SR0obxFGhH3uiZaZaDpmvn24UFd28hHkN6vUuXH2oqCYKDsCJqliP
         JPnoQ2X86Jpouhva7ciAUHAdV4s4QlnaStGhbJU/+A11BquMSE82OsxM0RtQkRJPrgvB
         L9UgU8zQC1qWSqGb9lEXSWVB5c7Q4lzAH7QSWmjJF54XgmsxbCNtexeAlAnNo84UJbyx
         ovAw==
X-Gm-Message-State: AGi0PuaSsYXcxgs+FJBSNv9Mp/hwULSDhzNXgRfR3CUxnjoB0yQ7ZYHY
        iq8dZtJXXYIvyB2M0ppjx23NyQxNifU=
X-Google-Smtp-Source: APiQypItMwRemJ+QEa5LjhsfD6/KeojcUM+NDqiTHdqDpMpIcodrRaaeGPz4d1vdd2ikHldkGnwFZQ==
X-Received: by 2002:a5d:4a42:: with SMTP id v2mr9686933wrs.333.1586619405657;
        Sat, 11 Apr 2020 08:36:45 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id g186sm7408772wme.7.2020.04.11.08.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 08:36:44 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH] KVM: SVM: Use do_machine_check to pass MCE to the host
Date:   Sat, 11 Apr 2020 17:36:27 +0200
Message-Id: <20200411153627.3474710-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use do_machine_check instead of INT $12 to pass MCE to the host,
the same approach VMX uses.

On a related note, there is no reason to limit the use of do_machine_check
to 64 bit targets, as is currently done for VMX. MCE handling works
for both target families.

The patch is only compile tested, for both, 64 and 32 bit targets,
someone should test the passing of the exception by injecting
some MCEs into the guest.

For future non-RFC patch, kvm_machine_check should be moved to some
appropriate header file.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/svm/svm.c | 26 +++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c |  2 +-
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 061d19e69c73..cd773f6261e3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -33,6 +33,7 @@
 #include <asm/debugreg.h>
 #include <asm/kvm_para.h>
 #include <asm/irq_remapping.h>
+#include <asm/mce.h>
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
 
@@ -1839,6 +1840,25 @@ static bool is_erratum_383(void)
 	return true;
 }
 
+/*
+ * Trigger machine check on the host. We assume all the MSRs are already set up
+ * by the CPU and that we still run on the same CPU as the MCE occurred on.
+ * We pass a fake environment to the machine check handler because we want
+ * the guest to be always treated like user space, no matter what context
+ * it used internally.
+ */
+static void kvm_machine_check(void)
+{
+#if defined(CONFIG_X86_MCE)
+	struct pt_regs regs = {
+		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
+		.flags = X86_EFLAGS_IF,
+	};
+
+	do_machine_check(&regs, 0);
+#endif
+}
+
 static void svm_handle_mce(struct vcpu_svm *svm)
 {
 	if (is_erratum_383()) {
@@ -1857,11 +1877,7 @@ static void svm_handle_mce(struct vcpu_svm *svm)
 	 * On an #MC intercept the MCE handler is not called automatically in
 	 * the host. So do it by hand here.
 	 */
-	asm volatile (
-		"int $0x12\n");
-	/* not sure if we ever come back to this point */
-
-	return;
+	kvm_machine_check();
 }
 
 static int mc_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8959514eaf0f..01330096ff3e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4572,7 +4572,7 @@ static int handle_rmode_exception(struct kvm_vcpu *vcpu,
  */
 static void kvm_machine_check(void)
 {
-#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_64)
+#if defined(CONFIG_X86_MCE)
 	struct pt_regs regs = {
 		.cs = 3, /* Fake ring 3 no matter what the guest ran on */
 		.flags = X86_EFLAGS_IF,
-- 
2.25.2

