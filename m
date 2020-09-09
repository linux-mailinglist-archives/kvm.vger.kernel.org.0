Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12392262571
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 04:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgIICzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 22:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729670AbgIICzu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 22:55:50 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0146C061573;
        Tue,  8 Sep 2020 19:55:49 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z19so850598pfn.8;
        Tue, 08 Sep 2020 19:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ohIW29ciAv1DCA5L2Ue/toPc76GmU7pThdqKIDSGsEE=;
        b=Sm/cfKRjQPPvbxPJDScCiTU8+1ipw5Q12mhszAL+C3tFvciGawTm+LbiD2V9QJAhoz
         SoXA4tbdWw/ThBBHNIKb0LLQLxDQqNSA1GATA/Ob+vlfcamIWFtp6F8NFvbTlaFvIDka
         9ORfb+XZcbGSveHxMg3N4OAaAQMSRVFIe2/xFTU6S8RxzNhimrjfH1ZxbGzoACRIG9R8
         fL4ZQd77QKR04Xxm5gRX7XqlylllLoa5TogDcCdKUrGItbBjN1AuVmGLi5Sc7Y5eQ3V1
         H6vS9wovL4VeQMVJnnZV+tE+gLeReNBJ4k8PW7gI9fFNUBR5/ozc29SVoSii/3ePZd/P
         CceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ohIW29ciAv1DCA5L2Ue/toPc76GmU7pThdqKIDSGsEE=;
        b=HQyF9E9O3L58ot7WC29bWsRhnuIe4DQ+DxSbWJcZWXmA1YAGrM011UK+v0M+bD3FGh
         63dxbneQeUhnNAKKy9L4ysFBbnz0O4kxXmDIBr7nzNoCon6X2IQ2YnNsNiutt++gInGO
         btv9aSHMw/bMalPKRl9IROrd1SvjSSsw6E7auh28pVESnuDpaN8CtTyyPwJfZrU1iHaJ
         aGIgeR72UglV7nYwcb28Jr1nRiHKYTWqSWdgxDK4S6LYbAmmlLZK1Y8vWdzKO6kf6fBt
         ZqeslGONmR7pch495U0ZvNIH7rpmRXRih1NE/LH42u8Jk/PrcrrVNs6qe8PnMJU5d7CF
         wp7Q==
X-Gm-Message-State: AOAM531EeL8wiKTj2VsdtJlnd0X5cronfbF4w7RKAKVOxz5/zqzV3d5k
        kIOFEIfd4s1KuZFI66sSvgcl1tPVTg8=
X-Google-Smtp-Source: ABdhPJxiDIXulPls/TCMMKJwNDODsYdmKPIyBn+fFIIPZ1wvEpEV+1FFRgXwz4XfElIa81ZoGx8/nw==
X-Received: by 2002:a63:d216:: with SMTP id a22mr1321072pgg.339.1599620149144;
        Tue, 08 Sep 2020 19:55:49 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id f3sm532358pgf.32.2020.09.08.19.55.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 19:55:48 -0700 (PDT)
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
Subject: [PATCH 3/3] KVM: SVM: Reenable handle_fastpath_set_msr_irqoff() after complete_interrupts()
Date:   Wed,  9 Sep 2020 10:55:39 +0800
Message-Id: <1599620139-13019-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
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

