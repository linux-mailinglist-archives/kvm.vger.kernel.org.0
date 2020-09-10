Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051A92642EC
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730340AbgIJJx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730493AbgIJJvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:51:23 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C69C061757;
        Thu, 10 Sep 2020 02:51:23 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d16so643743pll.13;
        Thu, 10 Sep 2020 02:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j7htwJAeNCUvO4S5RlNc3DOtl4dol2zJUiU0SUBRc+I=;
        b=g4OTNybujZoa7EfwmXbgUf10fX2yhnMBDkP8tJ5tNWEG9sjZ5epA/K3eLzMxz1tbCc
         eK7ZwnexxYAOUkQU5ImT2eBA9xTip3+TuhGkeZRL92U65cpTF4lGQDy/n3AD0mHCds3p
         YPPOMZhZmbm21D+itxzUDBs21JkNXl/SUTjrS18rlK/s5YeMZaTZosXCBhFZ6baXMfGI
         v1T8YtnbuWyD6F3qNEhCvpnIPOKWWeRKofKSjxmGLN+eZ5Q4rRye/RL4kihEZ/e5e+Fb
         fQBzo6IkB0d5KC7wdHd1wizK7rtpj5K81KZePnxjZ0H1pCmH+94E83weAfwQdVHgTbvE
         Si/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j7htwJAeNCUvO4S5RlNc3DOtl4dol2zJUiU0SUBRc+I=;
        b=BK6lmQHIdjH/TY0au8/GKSIIA0oGum+3+6wOci5/NI2bXO2Jn+p6QLrjzaQS/+4/mL
         GC66yjzB2Or1ix8psDuHcDDM4IbIDfXvS0EP2a8OxpHxzFh8V2Y/48vfqOEQhdmjMQJg
         8mGt/DuvFIOf1HETNHXYEw6foISqq0PIHY8qAdp+Gflbn3ysL+iFjV8SU9Vjhqnuclwu
         8d+Vd5BOKbu/qcIu1p3jEZJYpsxS2Af4R7MjWUZUbPzIceOGmgNWWwmAMftl3HSDVcMJ
         rnlLFdhHuPxPv+8R/axdC3GvLY5A25ZVrf2J7gM0uvJPMZhQfEF3sZwFBxflzb8mq1YK
         9PKg==
X-Gm-Message-State: AOAM531irvgYX1gK2DOqCZezSKBA5z/vxD4MipaiQZrz5VhOjuy+bWa7
        6Jpun/UQgwyQDnHCixTK2kXQ2JVLh6s=
X-Google-Smtp-Source: ABdhPJy4Ec5AtTKMudbwxwexym3/hbq7B0Y99oDBkr+P3nbMIpcYhmxvpIYlbBI23hq8NAJ/xNL2+w==
X-Received: by 2002:a17:902:10f:: with SMTP id 15mr4779290plb.121.1599731482578;
        Thu, 10 Sep 2020 02:51:22 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e1sm2576534pfl.162.2020.09.10.02.51.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:51:22 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
Subject: [PATCH v2 9/9] KVM: SVM: Reenable handle_fastpath_set_msr_irqoff() after complete_interrupts()
Date:   Thu, 10 Sep 2020 17:50:44 +0800
Message-Id: <1599731444-3525-10-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Moving the call to svm_exit_handlers_fastpath() after svm_complete_interrupts()
since svm_complete_interrupts() consumes rip and reenable the function
handle_fastpath_set_msr_irqoff() call in svm_exit_handlers_fastpath().

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paul K. <kronenpj@kronenpj.dyndns.org>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dafc14d..b3e3429 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3347,6 +3347,10 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
+	if (to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
+	    to_svm(vcpu)->vmcb->control.exit_info_1)
+		return handle_fastpath_set_msr_irqoff(vcpu);
+
 	return EXIT_FASTPATH_NONE;
 }
 
@@ -3495,7 +3499,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	stgi();
 
 	/* Any pending NMI will happen here */
-	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_after_interrupt(&svm->vcpu);
@@ -3530,6 +3533,12 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	svm_complete_interrupts(svm);
 	vmcb_mark_all_clean(svm->vmcb);
+
+	if (is_guest_mode(vcpu))
+		return EXIT_FASTPATH_NONE;
+
+	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
+
 	return exit_fastpath;
 }
 
-- 
2.7.4

