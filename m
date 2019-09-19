Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D07A5B87E4
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2019 00:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392180AbfISW7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 18:59:30 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:33034 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390868AbfISW7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 18:59:30 -0400
Received: by mail-pf1-f202.google.com with SMTP id z4so3299860pfn.0
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 15:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6Zlr8wuycCBeL7Zrxw1psZnttExi5o85U5sXHuZaYoc=;
        b=AUA17vzQNnBlrNdpzLcSAVQAKoY3dolcqBXnoXQa9U0d01UijWP5dZWHusLICv2eWz
         lbctqJbdXYpgx2LT7tKh6WFY9rgs4SxahbX2+BSQtbIeGirCUlUQ8PvFOV4VQPu/7OTZ
         1Z4J0fHxFXu4MCzq7gAZO00ntHaul85mZWoFyidOX86i4bkFmhnkp2ZytihEGXp2vERV
         rg9qJuUJBYW0wDtbfxzlzsTB5CCJNM55WxXTaLH3to+VE/YmCQf+8Vu7VEcjPhUyQ+3N
         oFUQqCNmWgE4rZmEcmbhBAFvFpU1ees4a/Ro5c0Ro6pir1dZsZkUYFGm7mucyF3z41JS
         CGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6Zlr8wuycCBeL7Zrxw1psZnttExi5o85U5sXHuZaYoc=;
        b=keAcJro/sf2CAmST3GsfByR6xLbvwjvR+6OmCU4ZjwIrb5VBZ+yQfj0wrGSSTNZbzJ
         SbB1tD1rZu7/3wPmmepvQnO40PLlC2xKuYCeDewwddbHwByQdiAwzAD9nuqd4RZFn2Bo
         3B9xUEFQ+HderQuJdzZIk+Q2Y+RVZLJjxZ1J3ofAm5+CMDYclLxVBXPPxbB+U3CMKzNm
         OrBcyywkP23Rc6AxlCIze9l7sMBdLzmhvn5NX/YdiHLCyiGHBRBGxhhl3c2MI33lOcBS
         X7wNxN+cpctpFweFpBSqTFdBoFrxo6w9SpU2QX4Qr0TlQ1e9r0zynucQM/8JnpIb7e+6
         mTUQ==
X-Gm-Message-State: APjAAAXTiLop6uaVPWD85+c0gSJk7bzRPhk7YMmsfiyhwifC3s1iJWKa
        QlYfosJvDqBGooBlEU9Fry45ht5758NDO6YUIxgnHkqyQd7YdgYVK23dS+eByP5X+9CAPcSk+R6
        5etaIDliRa7cLPBCaSVqUdw/AqOXiHcNfUmuYrlPJwxHcvvXOiXdLQwjrXl+FqNQ=
X-Google-Smtp-Source: APXvYqz1hDTKHONDLD0Id+mic4R7iXpqOirlGHtpF3j7qi9/HVjNHOx6r6Ool7so4f0UTrNRvn8fJMhbYgCsFg==
X-Received: by 2002:a63:a0d:: with SMTP id 13mr10354462pgk.99.1568933968821;
 Thu, 19 Sep 2019 15:59:28 -0700 (PDT)
Date:   Thu, 19 Sep 2019 15:59:17 -0700
Message-Id: <20190919225917.36641-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
Subject: [PATCH] kvm: svm: Intercept RDPRU
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Drew Schmitt <dasch@google.com>,
        Jacob Xu <jacobhxu@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The RDPRU instruction gives the guest read access to the IA32_APERF
MSR and the IA32_MPERF MSR. According to volume 3 of the APM, "When
virtualization is enabled, this instruction can be intercepted by the
Hypervisor. The intercept bit is at VMCB byte offset 10h, bit 14."
Since we don't enumerate the instruction in KVM_SUPPORTED_CPUID,
intercept it and synthesize #UD.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Drew Schmitt <dasch@google.com>
Reviewed-by: Jacob Xu <jacobhxu@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/include/asm/svm.h      | 1 +
 arch/x86/include/uapi/asm/svm.h | 1 +
 arch/x86/kvm/svm.c              | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index dec9c1e84c78..6ece8561ba66 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -52,6 +52,7 @@ enum {
 	INTERCEPT_MWAIT,
 	INTERCEPT_MWAIT_COND,
 	INTERCEPT_XSETBV,
+	INTERCEPT_RDPRU,
 };
 
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index a9731f8a480f..2e8a30f06c74 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -75,6 +75,7 @@
 #define SVM_EXIT_MWAIT         0x08b
 #define SVM_EXIT_MWAIT_COND    0x08c
 #define SVM_EXIT_XSETBV        0x08d
+#define SVM_EXIT_RDPRU         0x08e
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 04fe21849b6e..cef00e959679 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1539,6 +1539,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	set_intercept(svm, INTERCEPT_SKINIT);
 	set_intercept(svm, INTERCEPT_WBINVD);
 	set_intercept(svm, INTERCEPT_XSETBV);
+	set_intercept(svm, INTERCEPT_RDPRU);
 	set_intercept(svm, INTERCEPT_RSM);
 
 	if (!kvm_mwait_in_guest(svm->vcpu.kvm)) {
@@ -3830,6 +3831,12 @@ static int xsetbv_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int rdpru_interception(struct vcpu_svm *svm)
+{
+	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
+	return 1;
+}
+
 static int task_switch_interception(struct vcpu_svm *svm)
 {
 	u16 tss_selector;
@@ -4791,6 +4798,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_MONITOR]			= monitor_interception,
 	[SVM_EXIT_MWAIT]			= mwait_interception,
 	[SVM_EXIT_XSETBV]			= xsetbv_interception,
+	[SVM_EXIT_RDPRU]			= rdpru_interception,
 	[SVM_EXIT_NPF]				= npf_interception,
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
-- 
2.23.0.351.gc4317032e6-goog

