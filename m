Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2397B26B8F3
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 02:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgIPAxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 20:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgIOLdB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 07:33:01 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32C3C0611C3;
        Tue, 15 Sep 2020 04:30:42 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 34so1794989pgo.13;
        Tue, 15 Sep 2020 04:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/aKCB6Ww7t4Gp9xxyRSUMaEGPTL0wXO3eSVSTDC7m0=;
        b=d4WhKkECa3SOGw8M71woMrGRb8L3iIpBgHl9yPPQdPZHW2cuQk6yPAfxHwtH4m16AY
         i8eO1nmHUxz44HalUpWvO/YzlG305829rRK5yPPRGVy90YgDqV/Wan0i5sfeeFE58u3H
         TOrXdQZS0Gs7bSc6uhvGH95c3XKON35BahEi1zC5ueg3LTPfJLERLSGgpn2CTv1TlFWN
         Q70DcUUJBwXSvisWdnM7WS29wn1JFmBZ6wCkIqmpn1/aa6SHUNkCBPBNIyDX2x4Fn1um
         FRuVU4DBwHPe/EKg6nCuxlYfce3oxLUe7QjIq1mKmw5juXB3Y16xaV0oqRqYV19utN1o
         GA7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/aKCB6Ww7t4Gp9xxyRSUMaEGPTL0wXO3eSVSTDC7m0=;
        b=Svv3wdtdBZ/l12yn8SP1j+0dpzJ2ob0LVV1czWosfYnXJmqpyC6ejQDnF5E0KX17Nv
         yyn3Wn/OVasUlNmrtkE4RvliN93o4Qesq1vce9Z5cQvjbR67n/VIY4YuU/WVMc5mj5Da
         xNuFvJANn4UyJZS/tuKKsQ3ntrYH1wMGFD5X1g4Ir6jkrtIpBvomfstOZZrs0EjDNFHF
         bdGT2LaMxMvOVRpqFkN5kgGxYJy1TthruWdF7pdzDc0WhRxR9UB1T+khbhcnoV9XLEoW
         BxXvo/0H27xCHFAm7DdH754ibimTns9j2UycgeYNtFSm//tuepqyWzwVEYRsFoqz7Wqc
         Uh3g==
X-Gm-Message-State: AOAM5308s0UqdymYPFnJosGBWjI54FqaMgqD91LUrLUMmyLGYQe3Vvwc
        /Jg2ohToQAWfriAytytxyw==
X-Google-Smtp-Source: ABdhPJzts20bJt3xmsrlELcwAAEof7lLtQ+V7XR8dOoAiPZP+BrYF3HNavyhKQBgmkQHs6aNbkw1eQ==
X-Received: by 2002:a63:a23:: with SMTP id 35mr14865811pgk.333.1600169442425;
        Tue, 15 Sep 2020 04:30:42 -0700 (PDT)
Received: from LiHaiwei.tencent.com ([203.205.141.63])
        by smtp.gmail.com with ESMTPSA id z129sm11377807pgb.84.2020.09.15.04.30.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2020 04:30:41 -0700 (PDT)
From:   lihaiwei.kernel@gmail.com
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, hpa@zytor.com,
        Haiwei Li <lihaiwei@tencent.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH] KVM: SVM: Get rid of the variable 'exit_fastpath'
Date:   Tue, 15 Sep 2020 19:30:33 +0800
Message-Id: <20200915113033.61817-1-lihaiwei.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Haiwei Li <lihaiwei@tencent.com>

'exit_fastpath' isn't used anywhere else, so remove it.

Suggested-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c44f3e9..6e88658 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3413,7 +3413,6 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-	fastpath_t exit_fastpath;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
@@ -3536,8 +3535,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 		svm_handle_mce(svm);
 
 	svm_complete_interrupts(svm);
-	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
-	return exit_fastpath;
+	return svm_exit_handlers_fastpath(vcpu);
 }
 
 static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
-- 
1.8.3.1

