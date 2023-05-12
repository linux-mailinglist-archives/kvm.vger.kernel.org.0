Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660EA7012A7
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240673AbjELXuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240905AbjELXuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:50:40 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F3740E3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:38 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64389a4487fso6243574b3a.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683935437; x=1686527437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/jmBez73RsnuS+uU/xiNQiFMzjYNw0oV2iJF3mbgvJ0=;
        b=xlRxYqTPR40AEoqZn/L6lxwwX9jASAhxh5BJ5/+5IZF9h4us7R3K362Avf7/wX0IcA
         XTozwVsltuizAmLhIaW3V3/21m8bc73W8EZrhnFEUFojSwvZ7LUDqY+bvD9ru1AX3dKO
         3ckkn9O26SKBX0x9uwUd++Tk3Jd2jrWNd2OCjimqKsp62OdmL9Yw2VrLsjKpUYgGdIv8
         NwoqiH0UDdzPyG2QqKyzIxBUM3G6PM2lfN1HYpbsW/ELVvGhofKPj+IwwQ4AGX0NGDr3
         w2Le63AVJ0fMXR33ixFj7na0sT9Yg5wSWbImsdoBS0QVDLO0t/VW8428aurQQH8BXPhW
         hhog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683935437; x=1686527437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/jmBez73RsnuS+uU/xiNQiFMzjYNw0oV2iJF3mbgvJ0=;
        b=ToT5AOc+lWa+YR4FHsCpmT8lk3u8WgFfLgGzDOA9EMAYPh6yNwJthb44cD+GN8UhL9
         kibgMbeM3tixXs3EjVaMP/MtICh/5R7nU8oo93/jy3B4LgMAub4rszV+PbSggCEyXW4X
         0v3pGVuFNFvLXL6OzRbQxZr2zRgibaUukfMKNwfEWAxnfJ31+8L1/RnuZ4dldOMEmGZw
         QKlBEFGrfV0k7KvFaSrKxAK/DUCMspkYCw3OeoLe0UuTqBjDnmlPjf0ma5M6x4pYjlO3
         wkK1vAcdjfhJ5ufPr73ld191Msc86PrtKTf5RkEv9rEW58e3+1ev13oPjLIA334RQfam
         u5yg==
X-Gm-Message-State: AC+VfDx/itbgPrzlycqNEsKJ5kOs2fnJLg3NEeix1hnMpMeBoZb0Hj9L
        fgCEhEVEwsnvlq3nfLBG9wDsbokgFYY=
X-Google-Smtp-Source: ACHHUZ6TWHazXiZOhV3QRVyclx3u8oyy3vtvy+owJF/RtDMeFsLh/zrVPtZPdDtRyNHbm9QOLl8WMmX7aFU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:7d6:b0:624:5886:4b4b with SMTP id
 n22-20020a056a0007d600b0062458864b4bmr6850731pfu.5.1683935437710; Fri, 12 May
 2023 16:50:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:50:12 -0700
In-Reply-To: <20230512235026.808058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230512235026.808058-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512235026.808058-5-seanjc@google.com>
Subject: [PATCH v3 04/18] x86/reboot: KVM: Disable SVM during reboot via
 virt/KVM reboot callback
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the virt callback to disable SVM (and set GIF=1) during an emergency
instead of blindly attempting to disable SVM.  Like the VMX case, if a
hypervisor, i.e. KVM, isn't loaded/active, SVM can't be in use.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virtext.h |  8 --------
 arch/x86/kernel/reboot.c       |  3 ---
 arch/x86/kvm/svm/svm.c         | 19 +++++++++++++++++--
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 5bc29fab15da..aaed66249ccf 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -133,12 +133,4 @@ static inline void cpu_svm_disable(void)
 	}
 }
 
-/** Makes sure SVM is disabled, if it is supported on the CPU
- */
-static inline void cpu_emergency_svm_disable(void)
-{
-	if (cpu_has_svm(NULL))
-		cpu_svm_disable();
-}
-
 #endif /* _ASM_X86_VIRTEX_H */
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 0cf2261c2dec..92b380e199a3 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -826,9 +826,6 @@ void cpu_emergency_disable_virtualization(void)
 	if (callback)
 		callback();
 	rcu_read_unlock();
-
-	/* KVM_AMD doesn't yet utilize the common callback. */
-	cpu_emergency_svm_disable();
 }
 
 #if defined(CONFIG_SMP)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eb308c9994f9..0f0d04900bf2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -38,6 +38,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
 #include <asm/traps.h>
+#include <asm/reboot.h>
 #include <asm/fpu/api.h>
 
 #include <asm/virtext.h>
@@ -568,6 +569,11 @@ void __svm_write_tsc_multiplier(u64 multiplier)
 	preempt_enable();
 }
 
+static void svm_emergency_disable(void)
+{
+	cpu_svm_disable();
+}
+
 static void svm_hardware_disable(void)
 {
 	/* Make sure we clean up behind us */
@@ -5184,6 +5190,13 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 	.pmu_ops = &amd_pmu_ops,
 };
 
+static void __svm_exit(void)
+{
+	kvm_x86_vendor_exit();
+
+	cpu_emergency_unregister_virt_callback(svm_emergency_disable);
+}
+
 static int __init svm_init(void)
 {
 	int r;
@@ -5197,6 +5210,8 @@ static int __init svm_init(void)
 	if (r)
 		return r;
 
+	cpu_emergency_register_virt_callback(svm_emergency_disable);
+
 	/*
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
@@ -5209,14 +5224,14 @@ static int __init svm_init(void)
 	return 0;
 
 err_kvm_init:
-	kvm_x86_vendor_exit();
+	__svm_exit();
 	return r;
 }
 
 static void __exit svm_exit(void)
 {
 	kvm_exit();
-	kvm_x86_vendor_exit();
+	__svm_exit();
 }
 
 module_init(svm_init)
-- 
2.40.1.606.ga4b1b128d6-goog

