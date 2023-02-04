Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F66B68A7DA
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 03:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbjBDCl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 21:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjBDCl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 21:41:57 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73A584F88
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 18:41:56 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id g31-20020a63111f000000b004bbc748ca63so3316954pgl.3
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 18:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Eyl2Gk2q9T1eV7DI0p9mlIb5badihX418MuNkpKYmVo=;
        b=X+PPV3u2X+lZn6gVhql6yyg3YYD18L1CfE5YmtH30dolLF/MohybzVOpvnJB6DhBP2
         2wMUXINioM9SxHAybahNJuG4Sd8GIXZ43LUikBMqVcX2a2rJN/jgSGfvS9gTDmiCR1wU
         GWEc3RJMJnIoJ9+MJ06dhIYPfLk5mGwXF9fLq39fXHuX7tVu3wQ4SazrLSoDMHrBxfr6
         7sRZgbr7NgWbT/fqMnSMKzSxDvf380XFuSnqku8bkXMfHmihwzPh00nMLwa3RPOeu2+8
         ig8wNpMUagGEKSE+ZDeZl3Sp6NIvtwEvQrRWif03v8jpgCYao39junVVVs+1toqRnOzg
         Ivvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eyl2Gk2q9T1eV7DI0p9mlIb5badihX418MuNkpKYmVo=;
        b=cpGZtRx+wBh7QiH/PSWEI8ZMJ4OrGpATW5MwD9FcgM07yK1zekT4i8ryGYt5UQIFCA
         DNJmCfSM/OM2Gfm6u809NVlLYFEbtw5ZI6AreRbRQpuyqVXQo43anRBGJyeId4OrcA+B
         mPKQpuor7MiX8ACGkpC+PaoytoYvVQykwbkZh5Wm9lWdUIxPqAw5slAe1f0mK++qqCTq
         DdtM1wSaGIF48W3y87dREA4wdpQfD/kEf7l49Hv3DiprAmahsHB/ZGS3fSBdGGlC7Uiy
         hZKUW7q0JfEHSYem85Y93VnetWxSY4SI02POmbAuXYxDDoDGZNQ407zvZVRurEsfKxVp
         JEuw==
X-Gm-Message-State: AO0yUKX3QCdvDdZ8GN6dSIK9cE0BzIDSwYbE3GUAkB3u549wHFoHXGUu
        Adrn37usA489FWp8nq1olwBfgZJ0S6E=
X-Google-Smtp-Source: AK7set90nfjdbCTcrhj0tNGUc1jPfWUpaqVgb4EofrmYsOkqTBbxA9PgM7T1eMjDyE5iVxtC2ozEI8uUHm8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9285:b0:22b:b89b:b9da with SMTP id
 n5-20020a17090a928500b0022bb89bb9damr1922344pjo.41.1675478516072; Fri, 03 Feb
 2023 18:41:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Feb 2023 02:41:48 +0000
In-Reply-To: <20230204024151.1373296-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230204024151.1373296-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230204024151.1373296-2-seanjc@google.com>
Subject: [PATCH v2 1/4] KVM: selftests: Move the guts of kvm_hypercall() to a
 separate macro
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>
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

Extract the guts of kvm_hypercall() to a macro so that Xen hypercalls,
which have a different register ABI, can reuse the VMCALL vs. VMMCALL
logic.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 29 +++++++++++--------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index ae1e573d94ce..ff901cb47ffc 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1139,21 +1139,26 @@ const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
 	return NULL;
 }
 
+#define X86_HYPERCALL(inputs...)					\
+({									\
+	uint64_t r;							\
+									\
+	asm volatile("test %[use_vmmcall], %[use_vmmcall]\n\t"		\
+		     "jnz 1f\n\t"					\
+		     "vmcall\n\t"					\
+		     "jmp 2f\n\t"					\
+		     "1: vmmcall\n\t"					\
+		     "2:"						\
+		     : "=a"(r)						\
+		     : [use_vmmcall] "r" (host_cpu_is_amd), inputs);	\
+									\
+	r;								\
+})
+
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3)
 {
-	uint64_t r;
-
-	asm volatile("test %[use_vmmcall], %[use_vmmcall]\n\t"
-		     "jnz 1f\n\t"
-		     "vmcall\n\t"
-		     "jmp 2f\n\t"
-		     "1: vmmcall\n\t"
-		     "2:"
-		     : "=a"(r)
-		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3),
-		       [use_vmmcall] "r" (host_cpu_is_amd));
-	return r;
+	return X86_HYPERCALL("a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 }
 
 const struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
-- 
2.39.1.519.gcb327c4b5f-goog

