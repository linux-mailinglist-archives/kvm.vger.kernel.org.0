Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FE169158B
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 01:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjBJAdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 19:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjBJAcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 19:32:43 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FB66F21B
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 16:32:11 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-527501b56ffso34350087b3.15
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 16:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Vk51ezOTW4zNRYSRQz4ZjoRqnpbLfX1qjajQbLOjz6E=;
        b=KF2AyvR1TBIJUtf7p+Na1cAbpKslF9Xw+j+Oyin6+e8ZXCwZEGpcDsbJh76rth4Nkk
         tGhiF5apvHuGkSkNrDPU5XGhjINXuD9J3vCdIVA5aIHAM7mbxc58e8L7oZrEwok4LK0s
         ZedtPFFfsvDPw7r2j0DjBjf/XuqQ5F789eziWdjiWkPmmW/Tue67s5bZ50vLVB6GvbNh
         xEsjIbZL1cOuugqo4NkzfThg9PE1yk65PBc8tvt3+Y6GEl09zDluOGaO9f5tsyunVCmM
         W6XgoSPcN+gRF+xsb0hAvTgeFUqlCt2NjX+TwcJNbeYvFEPLDdQrn9gTJ1/Llzsa/aKS
         dOQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vk51ezOTW4zNRYSRQz4ZjoRqnpbLfX1qjajQbLOjz6E=;
        b=FMM2kduzBd/fje2faAAc7MNgQwX9YtNCaGCOjXpE40KCSApRpvg8YtFmdoEzM316ul
         Pk9DTZLBiQ5ETHUqg3ECocKCFALzGBBQ//Lqe4Y/WXLrA9nN+rPp3jD6LlSMUqMkNO96
         aFXHGfn2Tu6u1nrDsNcSk3AjGb+pqYjfucbFei5jUfwixofxqaC6PV+/ntEvZ6RFGPy7
         +Oxj27ycI8xSs9dVpSjdaZAfjvgl9Kpk6bhssHrkRLASaRnVjZc8GCuHqQAKTD4aLCJi
         ps1tdeDul6BoUu9hIFtRDJapkQDkBQC2k7tRd31poONUscEw5idHkU98KPLyLGc5Y7zM
         a5Hw==
X-Gm-Message-State: AO0yUKU10bJRatKYzWSjX7+36msRzrSDlBq/+X8jJtFikO0jNNpOwJEp
        r65rUSRZwLoeTbFkrWPo2s1NGa6/FzA=
X-Google-Smtp-Source: AK7set/Ob/ZegCPdJs7b/shxX7kUESmuPDm+LiV5FRWUWbDjPtQwnN5htwsHujDAHb+RExXCqWRuUCswF10=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4d:b0:895:2805:1fb3 with SMTP id
 m13-20020a056902004d00b0089528051fb3mr1249187ybh.275.1675989129752; Thu, 09
 Feb 2023 16:32:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Feb 2023 00:31:38 +0000
In-Reply-To: <20230210003148.2646712-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230210003148.2646712-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210003148.2646712-12-seanjc@google.com>
Subject: [PATCH v2 11/21] KVM: selftests: Print out failing MSR and value in vcpu_set_msr()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reimplement vcpu_set_msr() as a macro and pretty print the failing MSR
(when possible) and the value if KVM_SET_MSRS fails instead of using the
using the standard KVM_IOCTL_ERROR().  KVM_SET_MSRS is somewhat odd in
that it returns the index of the last successful write, i.e. will be
'0' on failure barring an entirely different KVM bug.  And for writing
MSRs, the MSR being written and the value being written are almost always
relevant to the failure, i.e. just saying "failed!" doesn't help debug.

Place the string goo in a separate macro in anticipation of using it to
further expand MSR testing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 30 ++++++++++++++-----
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 53ffa43c90db..26c8e202a956 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -928,14 +928,30 @@ static inline void vcpu_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 uint64_t vcpu_get_msr(struct kvm_vcpu *vcpu, uint64_t msr_index);
 int _vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index, uint64_t msr_value);
 
-static inline void vcpu_set_msr(struct kvm_vcpu *vcpu, uint64_t msr_index,
-				uint64_t msr_value)
-{
-	int r = _vcpu_set_msr(vcpu, msr_index, msr_value);
-
-	TEST_ASSERT(r == 1, KVM_IOCTL_ERROR(KVM_SET_MSRS, r));
-}
+/*
+ * Assert on an MSR access(es) and pretty print the MSR name when possible.
+ * Note, the caller provides the stringified name so that the name of macro is
+ * printed, not the value the macro resolves to (due to macro expansion).
+ */
+#define TEST_ASSERT_MSR(cond, fmt, msr, str, args...)				\
+do {										\
+	if (__builtin_constant_p(msr)) {					\
+		TEST_ASSERT(cond, fmt, str, args);				\
+	} else if (!(cond)) {							\
+		char buf[16];							\
+										\
+		snprintf(buf, sizeof(buf), "MSR 0x%x", msr);			\
+		TEST_ASSERT(cond, fmt, buf, args);				\
+	}									\
+} while (0)
 
+#define vcpu_set_msr(vcpu, msr, val)							\
+do {											\
+	uint64_t v = val;								\
+											\
+	TEST_ASSERT_MSR(_vcpu_set_msr(vcpu, msr, v) == 1,				\
+			"KVM_SET_MSRS failed on %s, value = 0x%lx", msr, #msr, v);	\
+} while (0)
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
-- 
2.39.1.581.gbfd45094c4-goog

