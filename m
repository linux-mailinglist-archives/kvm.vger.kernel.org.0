Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D68CC0920
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfI0QFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:05:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39519 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbfI0QFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:05:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so3701086wrj.6;
        Fri, 27 Sep 2019 09:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=gMGe1RxHLB7ktDM+P7ngRhIvwgy8WL2hbGJxbnP4AYg=;
        b=tWZt3K4lxY9TyOFlfpmgYUURbaM2YtjqW2Tn6Qn9UB4suAdWVtz6rimKk/o2y17zIc
         0D5Qq/LdkLObm/VAKzJFQSREpzD1ZdvWMom+0Jp3J0Sc7vxs/aq1a3S927C7GEVFROyY
         OVolY6iVD3VCMYPzsN9RWpYGngxOl+RwW9j2jNI+yD/WGjhvUquuV5XSnM9QpPQ7qUOT
         fBOIqw+YKVU69QzT+shWplvB24c7rOnchBpey6wqPw6HOmhDkCVnZChWz/OSQT/ltx9X
         OY2RylsKsAuipYpV5ONedCVY4UejzzrDb+f9bJdjZmRWc1VE1Ppk4HKLm1rCPgfgDkh8
         tRXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=gMGe1RxHLB7ktDM+P7ngRhIvwgy8WL2hbGJxbnP4AYg=;
        b=ibo1x4LSAnXGxp+gP5e+7zYYFqHLJgR/zteQz9HtCpiwOWYiI1dkZ8/9KwqiVxuMRT
         dNYu85P0hWwxz1B1Y8TxB16LWA33SUavqIRwGXwft6OEL8kY0bhclz0fL30WbyF3HuNQ
         TVgKfipriC7d/5yPgnpAWtP5v2oj5Mvv0xJNzjdl2dzMgmAlvPD/6uZTuMbklt+6JLL+
         VUDZkUh2PlXZRlH3p1xs1K9g+1WgzjU/1iFIpH9JSPWQqdREA+bIU2x615WUovmQWk4J
         kbWKCPirq/7iG1/Qvu3sbGyhZrI8agHmCqLLTCrtpPcF3iWSZVPeVLty/v5X8xWX0glR
         Shtw==
X-Gm-Message-State: APjAAAWJQiwcdbzN5HWJMNf3g0FltA1vGyMsa12qEanQ0N6yx+4r3zm/
        46B0AOlHIWt8ar5FGQaMRRmbTvWp
X-Google-Smtp-Source: APXvYqzrf/BNCHYjyJATAYJdCzH3MpkGG2RZJC595mLoHIWxWvFh0FaUQydvQV/sCeYQrDbgNwgCyQ==
X-Received: by 2002:adf:ce89:: with SMTP id r9mr685277wrn.335.1569600318893;
        Fri, 27 Sep 2019 09:05:18 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id g24sm3475615wrb.35.2019.09.27.09.05.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Sep 2019 09:05:17 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bp@alien8.de, Waiman Long <longman@redhat.com>
Subject: [PATCH v2] KVM: VMX: Set VMENTER_L1D_FLUSH_NOT_REQUIRED if !X86_BUG_L1TF
Date:   Fri, 27 Sep 2019 18:05:16 +0200
Message-Id: <1569600316-35966-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Waiman Long <longman@redhat.com>

The l1tf_vmx_mitigation is only set to VMENTER_L1D_FLUSH_NOT_REQUIRED
when the ARCH_CAPABILITIES MSR indicates that L1D flush is not required.
However, if the CPU is not affected by L1TF, l1tf_vmx_mitigation will
still be set to VMENTER_L1D_FLUSH_AUTO. This is certainly not the best
option for a !X86_BUG_L1TF CPU.

So force l1tf_vmx_mitigation to VMENTER_L1D_FLUSH_NOT_REQUIRED to make it
more explicit in case users are checking the vmentry_l1d_flush parameter.

Signed-off-by: Waiman Long <longman@redhat.com>
[Patch rewritten accoring to Borislav Petkov's suggestion. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4575ffb3cec..e7970a2e8eae 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -209,6 +209,11 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 	struct page *page;
 	unsigned int i;
 
+	if (!boot_cpu_has_bug(X86_BUG_L1TF)) {
+		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
+		return 0;
+	}
+
 	if (!enable_ept) {
 		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_EPT_DISABLED;
 		return 0;
@@ -7995,12 +8000,10 @@ static int __init vmx_init(void)
 	 * contain 'auto' which will be turned into the default 'cond'
 	 * mitigation mode.
 	 */
-	if (boot_cpu_has(X86_BUG_L1TF)) {
-		r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
-		if (r) {
-			vmx_exit();
-			return r;
-		}
+	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
+	if (r) {
+		vmx_exit();
+		return r;
 	}
 
 #ifdef CONFIG_KEXEC_CORE
-- 
1.8.3.1

