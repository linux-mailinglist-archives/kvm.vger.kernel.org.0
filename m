Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DE249B122
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239085AbiAYKDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238501AbiAYJ7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 04:59:38 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61111C06175C;
        Tue, 25 Jan 2022 01:59:37 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so1645027pju.2;
        Tue, 25 Jan 2022 01:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FM5pcNZb9iz5vCSPvdknnsJq7LFJsbOHrnL0CWm1fY8=;
        b=FfrOVLVxAr1U0q6A89oN8AlGrFHBD6+1usdFkL8nXiF6n39K8Ge8E6UEZAAsBPDYt3
         9Mq//E7pGo3kw+v/jmVsKpe4WkikWA3kg0eim03DFhlr/IuYYgL+1FKYjpPLKabTefju
         lkokuwyGOCYkvdL56Dkf1h6bnSdaa2CI5nP38twHwz5yTv9wDpk1TxO6MUaKOjadKoJR
         10dU17vMD4NDYcmlhQ/bdIO7s4XHVeqZhgKkEGKmUe2+KjSuo4tCtY7MOoFqwHBI/G/B
         J8SGPTV7Tf8RdtJvOaGTO3Wnv2mTBal15pV8kwieBWEsJiHJkXPWdY8qhXZoj+1D6ayH
         VZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FM5pcNZb9iz5vCSPvdknnsJq7LFJsbOHrnL0CWm1fY8=;
        b=y4DQw3Sm9V2ClBO36oUs43Hc/4YEANp053j/+zwBKBmmL5iqyPQixkhBs1IVakte43
         skOgwT8DjH8V/9gbtWXtFvcoPpXEZqo+/Gikq1sV99qcIw4a8o0sA3536+m+g2pceR9l
         D2RuNsfg02HcXIbe3/HA0rcHu7/v/mC5EAwaZX1u1lYAcN46eF/+NqZPhB5pneEPOld3
         yuXWiy/2DY+/oQxM1vWLtK4mMsxagrOzykVDXohLFeBBRFZTDCJv/kLZVWwGr6Hvv5TZ
         Oco+NEXKYP5qqK/nu4SMUSWnE0Z9l+AFUJa0iytNoxsYSumJQDFBo3cgOjfFPi/isdkt
         R3bg==
X-Gm-Message-State: AOAM53356K7n1F3s6Kxtv7bXE34ek7CUafeKwX55Ks+39Bul4c7vi5ly
        3BalUGJxXf0fGrW50hojtME=
X-Google-Smtp-Source: ABdhPJxI9k7iHgnNBmOf81BloRoGh9PVBlAA/BtGWSejzRigOrY3HL55gaecq97eWoC1PgucwX4jkQ==
X-Received: by 2002:a17:902:ed82:b0:14a:9ad8:a146 with SMTP id e2-20020a170902ed8200b0014a9ad8a146mr18004700plj.55.1643104776958;
        Tue, 25 Jan 2022 01:59:36 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.01.59.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 01:59:36 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/19] KVM: x86: Remove unused "vcpu" of kvm_after_interrupt()
Date:   Tue, 25 Jan 2022 17:58:58 +0800
Message-Id: <20220125095909.38122-9-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "struct kvm_vcpu *vcpu" parameter of kvm_after_interrupt() is not used,
so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 arch/x86/kvm/vmx/vmx.c | 2 +-
 arch/x86/kvm/x86.c     | 2 +-
 arch/x86/kvm/x86.h     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bc733dbadbdd..744ddc7ad6ad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3737,7 +3737,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	/* Any pending NMI will happen here */
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
-		kvm_after_interrupt(vcpu);
+		kvm_after_interrupt();
 
 	sync_cr8_to_lapic(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a02a28ce7cc3..62b0335d9ae2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6453,7 +6453,7 @@ static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
 {
 	kvm_before_interrupt(vcpu);
 	vmx_do_interrupt_nmi_irqoff(entry);
-	kvm_after_interrupt(vcpu);
+	kvm_after_interrupt();
 }
 
 static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55518b7d3b96..df46d0737b85 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10094,7 +10094,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 	++vcpu->stat.exits;
 	local_irq_disable();
-	kvm_after_interrupt(vcpu);
+	kvm_after_interrupt();
 
 	/*
 	 * Wait until after servicing IRQs to account guest time so that any
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1ebd5a7594da..651aa7ed5200 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -399,7 +399,7 @@ static inline void kvm_before_interrupt(struct kvm_vcpu *vcpu)
 	__this_cpu_write(current_vcpu, vcpu);
 }
 
-static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
+static inline void kvm_after_interrupt(void)
 {
 	__this_cpu_write(current_vcpu, NULL);
 }
-- 
2.33.1

