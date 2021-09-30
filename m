Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA2E41D0A4
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 02:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347493AbhI3Aiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 20:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245276AbhI3Ait (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 20:38:49 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4054AC06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 17:37:08 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 70-20020aed20cc000000b002a69b3ea30aso10487130qtb.15
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 17:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GIihH7fTqPTkqNbcG76uWZc+GyA3hP8vajq1vIIFUoo=;
        b=lDCI7N9K8wg3fxqCcnAxbMYeDmmnRQtdz06EXq7hpPDtGwxzTlxDa6ye56HRpTB0Go
         UDnr5DGm/gIgs6x5asdSPD1+c8ZtTwZcCgXmdU8SRvDhJNJ08lm11WjbSP69s2WQSLAr
         vle/kiQYpJ+KiTuLXKhlr1qbbEPuQIhElqBvWjmtZvI5NDnfDyJuhIYMY98LKXHViGbV
         afIIwpMgrGmN+rj7rF3iKz95PoKV29tVvuRwPQzuisdC0IVcojjZe754qxL+++zEUkmR
         4DuPTlxhTxGJsYAFAyz22Lu8yQP1ORdm10XYdwHtwekyah3JO07y9Jo14KMVjvguErqf
         XIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GIihH7fTqPTkqNbcG76uWZc+GyA3hP8vajq1vIIFUoo=;
        b=mdo4z8qOvG6xKze4Rj7ExIy9b1e+MFhG+nSoU+0CrXUMxmUSQpUbV2bYPk9d9t4vSv
         QsjRhZe5NLK5jYE5REpq3Ox6uxWb3LjOEWOtyPXC/dNj/EJ3O8q3g+TwuI5BSTVLGd0I
         Tq5g/EiTwNwP6pWZSYVRFIzbiXuVDIF2mLW3Aox0BY4G0WDQkjMohJ8TPzKH7VBmffxx
         ybhGYSEUYjvp68UlzqZqY9waz6+qIcbrTiZ7DaSugtCX2Q5qByjuNwKWrLZAx++dbVx+
         ctPCNy32SR2/Ts7XwpR4VmJJ3O4cCehky4HXJZK2DFn9GxONAcs5gwRBlFr+CnZa1Wmb
         qnMQ==
X-Gm-Message-State: AOAM5338N58Kg5XREMeoj2Sr/4bSQTsP2c+w3pq7gAeYiRYEvxCdqGHW
        MXmp2z8w2OBN6edccpCkqhdy4bWMzrrpsju78Fs5pXeZV7wooKgBK3lFuk8+Q10YfIBl5quF7Wy
        sl7ukVCLLlfz3ZQrBIzBSwFt1GobIBJvneFVL5OyfLGLNTAIxZf/rPaK3e7QrHJI=
X-Google-Smtp-Source: ABdhPJzt+6V/mu35oWiww18ik8eOiC2j+tV//TCGVgFez+P8Uid3T0n6hkWt09usWI3Ps9xpf+dV+HMWmDl2vQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6214:1461:: with SMTP id
 c1mr2821301qvy.19.1632962227249; Wed, 29 Sep 2021 17:37:07 -0700 (PDT)
Date:   Wed, 29 Sep 2021 17:36:49 -0700
Message-Id: <20210930003649.4026553-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH] KVM: selftests: Fix nested SVM tests when built with clang
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Though gcc conveniently compiles a simple memset to "rep stos," clang
prefers to call the libc version of memset. If a test is dynamically
linked, the libc memset isn't available in L1 (nor is the PLT or the
GOT, for that matter). Even if the test is statically linked, the libc
memset may choose to use some CPU features, like AVX, which may not be
enabled in L1. Note that __builtin_memset doesn't solve the problem,
because (a) the compiler is free to call memset anyway, and (b)
__builtin_memset may also choose to use features like AVX, which may
not be available in L1.

To avoid a myriad of problems, use an explicit "rep stos" to clear the
VMCB in generic_svm_setup(), which is called both from L0 and L1.

Reported-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Fixes: 20ba262f8631a ("selftests: KVM: AMD Nested test infrastructure")
---
 tools/testing/selftests/kvm/lib/x86_64/svm.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 2ac98d70d02b..161eba7cd128 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -54,6 +54,18 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 	seg->base = base;
 }
 
+/*
+ * Avoid using memset to clear the vmcb, since libc may not be
+ * available in L1 (and, even if it is, features that libc memset may
+ * want to use, like AVX, may not be enabled).
+ */
+static void clear_vmcb(struct vmcb *vmcb)
+{
+	int n = sizeof(*vmcb) / sizeof(u32);
+
+	asm volatile ("rep stosl" : "+c"(n), "+D"(vmcb) : "a"(0) : "memory");
+}
+
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
 {
 	struct vmcb *vmcb = svm->vmcb;
@@ -70,7 +82,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 	wrmsr(MSR_EFER, efer | EFER_SVME);
 	wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
 
-	memset(vmcb, 0, sizeof(*vmcb));
+	clear_vmcb(vmcb);
 	asm volatile ("vmsave %0\n\t" : : "a" (vmcb_gpa) : "memory");
 	vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg_attr);
 	vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg_attr);
-- 
2.33.0.685.g46640cef36-goog

