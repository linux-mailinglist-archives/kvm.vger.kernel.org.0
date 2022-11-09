Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2796E622B04
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 13:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiKIMAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 07:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKIMAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 07:00:19 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57C72AC42;
        Wed,  9 Nov 2022 04:00:14 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id k22so16485491pfd.3;
        Wed, 09 Nov 2022 04:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O6PGZOSFs1RFHC6cUPpBGLSGpl6saz/LTvcVmBRLaSw=;
        b=M7LgCC6e/xl68Uj3BKtiLMUkthpfVrh1df7V5vx0D6O1TUoHh/k7WTAcyNy/w3JrKi
         +MH1pTLZz33I3m3mZ+cL/zRZJGWXF2h6hz2xEMPBhdlRcYp0VQ3Vh1vH8ysgqsjuJbW/
         QjaUZ1OTrJZXozRWO4OiyolQWXyO0fbHCOM17uyNvm/NtwQUObEu5CJz0IQGsxDwqCDy
         1LCN2nFTVfpegbFjh79oOQ4zjlsYnlQh5h44zZz7SBu9yFUqPZrRuCEeuN8C/54gMBB8
         eapj/qirH+tnVf9ZaoRqcbqAugAnIYJJi+FfD0Z7XCtVQSyJ5F44KOei9mG12HdhoAiH
         1bCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O6PGZOSFs1RFHC6cUPpBGLSGpl6saz/LTvcVmBRLaSw=;
        b=bq5D85asbGe8KyyV3rBjHJdNIk/cBxeQcNRF3y3dhyv9pzJLUxefVxL0AgdY2TxAXl
         FGB5i8n2ZcrwWbRGOJtOu/sGU737mHWjhUwGuK1QlyElSSDO5hm55dhfFNHKZ1pkj8SY
         BiJgmcWB647DyjXsxPDFYfh0sccNCTwGk//Zg8lD6M1TP4WA4jvvfPqt8jhd9rGly8Ip
         CkZTcBDrAfoIpCTKBtjpUtlNXX0T1yIz5oiXKvsnqL6KkFlkx/mrouQ0PFxKnirEhIOu
         21H81zvVbB54QyvBbsjwu/t8OIrTSlSxyyjEABFEDgJN87o/U+eEL/vF8iJoPw6f6tnP
         f6cg==
X-Gm-Message-State: ACrzQf1zul+xTcvrP4YVrJCdf9mFdhgZanJc/hZIHRMDFFcHxulXMJ9t
        02bzSZQ1MKzfjcpqLNkQ7ZEY1LWYPrvZAgjf
X-Google-Smtp-Source: AMsMyM5dY+f03735CWliS4KzeGqGsTtTw2tiw4gb4G6aMsUwl1JmvmK8OF55QZXdyQLiLgV9jCFUoQ==
X-Received: by 2002:a63:4549:0:b0:46e:e3b7:88f5 with SMTP id u9-20020a634549000000b0046ee3b788f5mr51644959pgk.102.1667995214283;
        Wed, 09 Nov 2022 04:00:14 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902da8c00b0017f5ad327casm8902216plx.103.2022.11.09.04.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 04:00:13 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: svm/avic: Drop "struct kvm_x86_ops" for avic_hardware_setup()
Date:   Wed,  9 Nov 2022 19:59:52 +0800
Message-Id: <20221109115952.92816-1-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Even in commit 4bdec12aa8d6 ("KVM: SVM: Detect X2APIC virtualization
(x2AVIC) support"), where avic_hardware_setup() was first introduced,
its only pass-in parameter "struct kvm_x86_ops *ops" is not used at all.
Clean it up a bit to avoid compiler ranting from LLVM toolchain.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/avic.c | 2 +-
 arch/x86/kvm/svm/svm.c  | 2 +-
 arch/x86/kvm/svm/svm.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index cc651a3310b1..18283b8e954d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -1161,7 +1161,7 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
  * - Hypervisor can support both xAVIC and x2AVIC in the same guest.
  * - The mode can be switched at run-time.
  */
-bool avic_hardware_setup(struct kvm_x86_ops *x86_ops)
+bool avic_hardware_setup(void)
 {
 	if (!npt_enabled)
 		return false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c773bbf9b6cf..b81fe508b7b9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5038,7 +5038,7 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	enable_apicv = avic = avic && avic_hardware_setup(&svm_x86_ops);
+	enable_apicv = avic = avic && avic_hardware_setup();
 
 	if (!enable_apicv) {
 		svm_x86_ops.vcpu_blocking = NULL;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9d940d8736f0..7f1e2c9ac920 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -427,7 +427,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
-bool avic_hardware_setup(struct kvm_x86_ops *ops);
+bool avic_hardware_setup(void);
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.38.1

