Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334DC6CB5BE
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 07:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjC1FCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 01:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjC1FCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 01:02:41 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366842109
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 22:02:39 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q8-20020a17090ad38800b0023f116f305bso5614446pju.0
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 22:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679979759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=udq/ePFeW7CvQACtcQNehbXf/gZw7sbEUVmVhNf4POs=;
        b=Os8wp7EJPMnawyxgwRwXO7YmtAHd3/112S/LUek8fFyLehEnDwZ84lB+UG3r/tFcQ4
         xUL3xqY1OeFYwVKuIWIQ1iZWKCAQ+MDN5yvEAUgKp9Y7gv+CP+LYINV4v0pH+TKzv10i
         wn0yXWzSOICDNMxY3Bstnh9SP1/n/R0kLuz+IxuPx4j7pkTTaFDcs4OQt6rZnkrk+CwN
         Oj5AIZVkHeLsoan+T/gYRAfpE01n3e8Z2oPLfy/Wbf3OggqWhOwCWGhv7JS3qJ3iYhlz
         QJHV1xD3N3t2KSouq/YU41tVDx6bIA/LjrTdmkzyFELS9QTrq2CkAfmEjbRlko3Q/sIA
         cI2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679979759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udq/ePFeW7CvQACtcQNehbXf/gZw7sbEUVmVhNf4POs=;
        b=6TorIPNMSZGRNv1cX1611voyphP6mBDFN/k1aeaxxqvKrzO15ZAgdejtZn2/tvmHAz
         4a6NabCdDOWeZec1vHk0sBgWKCQdH4j5whHybd5Q7PjcfQNTOSrUK7QItk9WWnH+yGMs
         uQZ3HlpqSlcZwry5vfxEivkD1co5P7IsBXN3FysT5L+9DOYqo9QMO8sG4sXUWJ9ALlPR
         ml4AJrF+okKopLMPsm1Ky3DsaoeuA6gCymB6q7q2xV1/Eo/TS4SjfpiomhhndDU+bl2K
         JaGzJdvhVSH86YlYreJ42Ml7EjrDRBmAyewvKWPdZzsrImu180e13IgR0nXyKFTB8C+H
         fG9w==
X-Gm-Message-State: AAQBX9dWe3NhZDc1g6sEk4QfbSD1QNgHw80PZnHN5jwc8wrZ+RbRUTgL
        jd+8IPU+OirqgHfBa55Yqbb1ZPbre7I=
X-Google-Smtp-Source: AKy350Y2+brHs2WMQZeP4IQ5teAvmh5Vr+TNO5aQuoymho6Zhdhf9TvZeAKbYUNxuReFXhBz83Vfb67tGCA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a09:b0:625:dc5b:9d1d with SMTP id
 p9-20020a056a000a0900b00625dc5b9d1dmr7602410pfh.0.1679979758832; Mon, 27 Mar
 2023 22:02:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 27 Mar 2023 22:02:31 -0700
In-Reply-To: <20230328050231.3008531-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230328050231.3008531-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230328050231.3008531-4-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 3/3] x86/msr: Add testcases for
 MSR_IA32_FLUSH_CMD and its L1D_FLUSH command
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add test coverage to verify MSR_IA32_FLUSH_CMD is write-only, that it can
be written with '0' (nop command) and '1' (L1D flush command) when the L1D
flush command is suported, and that writing any other bit (1-63) triggers
a #GP due to the bits/commands being reserved.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/msr.h       |  3 +++
 lib/x86/processor.h |  1 +
 x86/msr.c           | 11 +++++++++++
 3 files changed, 15 insertions(+)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 29fff553..0e3fd037 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -36,6 +36,9 @@
 #define MSR_IA32_PRED_CMD               0x00000049
 #define PRED_CMD_IBPB			BIT(0)
 
+#define MSR_IA32_FLUSH_CMD		0x0000010b
+#define L1D_FLUSH			BIT(0)
+
 #define MSR_IA32_PMC0                  0x000004c1
 #define MSR_IA32_PERFCTR0		0x000000c1
 #define MSR_IA32_PERFCTR1		0x000000c2
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index aed6d180..e32c84f7 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -246,6 +246,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_SHSTK		(CPUID(0x7, 0, ECX, 7))
 #define	X86_FEATURE_IBT			(CPUID(0x7, 0, EDX, 20))
 #define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
+#define	X86_FEATURE_FLUSH_L1D		(CPUID(0x7, 0, EDX, 28))
 #define	X86_FEATURE_ARCH_CAPABILITIES	(CPUID(0x7, 0, EDX, 29))
 #define	X86_FEATURE_PKS			(CPUID(0x7, 0, ECX, 31))
 
diff --git a/x86/msr.c b/x86/msr.c
index 13cb6391..f6be2be7 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -295,6 +295,17 @@ static void test_cmd_msrs(void)
 	}
 	for (i = 1; i < 64; i++)
 		test_wrmsr_fault(MSR_IA32_PRED_CMD, "PRED_CMD", BIT_ULL(i));
+
+	test_rdmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD");
+	if (this_cpu_has(X86_FEATURE_FLUSH_L1D)) {
+		test_wrmsr(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", 0);
+		test_wrmsr(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", L1D_FLUSH);
+	} else {
+		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", 0);
+		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", L1D_FLUSH);
+	}
+	for (i = 1; i < 64; i++)
+		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));
 }
 
 int main(int ac, char **av)
-- 
2.40.0.348.gf938b09366-goog

