Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B688262579
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 04:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbgIIC5m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 22:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIIC5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 22:57:35 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13759C061755;
        Tue,  8 Sep 2020 19:57:34 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id c196so999109pfc.0;
        Tue, 08 Sep 2020 19:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ohIW29ciAv1DCA5L2Ue/toPc76GmU7pThdqKIDSGsEE=;
        b=P63Oird4WMQWLoVFobqNtzk1rmw4TgJHg0uGLtgFbJTyK1YxZYSUCxbfU3vq2roVpj
         S5C+RUhCGyXyNOLIks8FKd20hF3No3hycjNtGO/VMy4Xcx88a0Z+wwT/1V/E49JLWWF3
         MoWPz8SMeDWPEP/y+K0Xh+yK+CHv2vCAO8ddyz8+SVbEbaey2Q7+l49CkLmEUakMa7TW
         d97zzQCLOj+1nEhnoPRVlZv2NeicHZU5WUD8fWc/JoD3x+7JnuhkWWLrZEYdkhQqS+/a
         +VEkWaCinNMWeie5rIbkEE1GyrMUpzH0iyO5J9KyR/DHWEDWci/VfVlzehidR5SyhdAU
         PwLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ohIW29ciAv1DCA5L2Ue/toPc76GmU7pThdqKIDSGsEE=;
        b=WkOlxHsAAWLB+rnxpBOV2ZGNpb9DIw4fYTkHT6jbh3rBjSmeMB+gwGvVwMB2TLknBw
         ctzf6Io2B6osK556BVdcdvysxUd/saBEsm8JDaea1dv60ZkKYgMLIAPa/B5tYQaLC6mM
         KkljsfdDpQErIUINIXgu69aB1EK+rU+6XxGfDjgxkMJnc6ZQyyHY7XpWmMjlm9dRxNEE
         Vh4HvjX0nMq6JMXtIShi7aVZ8btwaJ+P8ltL64GHeWV+KVFcYOakv/aMnqWm0R9X6+qf
         d6CyiNdqUNzOVND2Dh9EOXhh/oxJ8OUtRROpXogF/6TgoKdA0U2kjyDjIWwljnlAawaS
         NuZg==
X-Gm-Message-State: AOAM533leCxJH0yQv6WqDW0VaYGigBJUdb6dNwBhhG09atH9HnrP2nTF
        XBQM8Y/faeZfJkuSdUoJgpPv4uFWOhQ=
X-Google-Smtp-Source: ABdhPJyhb4qzJRiur9+RdUfsh5WETGYJrYPj2iB9nPZkNoX+uAzV8FYI7+LV/UIn8hboPOmLRTeAGg==
X-Received: by 2002:a63:5b4c:: with SMTP id l12mr1284500pgm.243.1599620253902;
        Tue, 08 Sep 2020 19:57:33 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l9sm556063pgg.29.2020.09.08.19.57.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 19:57:33 -0700 (PDT)
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
Subject: [PATCH RESEND 3/3] KVM: SVM: Reenable handle_fastpath_set_msr_irqoff() after complete_interrupts()
Date:   Wed,  9 Sep 2020 10:57:17 +0800
Message-Id: <1599620237-13156-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599620237-13156-1-git-send-email-wanpengli@tencent.com>
References: <1599620237-13156-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Moving the call to svm_exit_handlers_fastpath() after svm_complete_interrupts() 
since svm_complete_interrupts() consumes rip and reenable the function 
handle_fastpath_set_msr_irqoff() call in svm_exit_handlers_fastpath().

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paul K. <kronenpj@kronenpj.dyndns.org>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 74bcf0a..ac819f0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3347,6 +3347,11 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 
 static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 {
+	if (!is_guest_mode(vcpu) &&
+	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
+	    to_svm(vcpu)->vmcb->control.exit_info_1)
+		return handle_fastpath_set_msr_irqoff(vcpu);
+
 	return EXIT_FASTPATH_NONE;
 }
 
@@ -3495,7 +3500,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	stgi();
 
 	/* Any pending NMI will happen here */
-	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_after_interrupt(&svm->vcpu);
@@ -3529,6 +3533,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		svm_handle_mce(svm);
 
 	svm_complete_interrupts(svm);
+	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
 
 	vmcb_mark_all_clean(svm->vmcb);
 	return exit_fastpath;
-- 
2.7.4

