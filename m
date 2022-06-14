Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7356954BB3A
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352366AbiFNUIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357107AbiFNUH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:07:58 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6B319C2B
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:38 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id n8-20020a170902d2c800b001663868e2c2so5316878plc.21
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+7ZQJwDPN94XCZWfMY0f3bKfe/+MUS1iizJz1cRRud0=;
        b=sIqMgtwGiyDHB3/kQbsW/oD4UnbmjesMIETpHCFlNxZxusO1G/q1uZC8YeeenM8ChI
         wncWmYl+BRdoJ3ADmpzPLWZjcQbT0uv2CaZ2/ysVEnstkkMEcSVSLA2yCISAUeGDKgHJ
         8F5n3MynOh8inkdgO4AkZ4MmT2QsYl7U0BgXBnQ3jmdH2Wj/x12qd247+fwKKk8E6tx4
         xYBhZxemKJ0UTSNaY1OEeLjV7pakGUlm8HDmU5NWfCGhPueh/MXo0ljJFqn1wb+S0t1l
         RHdKvrWADr/xFpNanNJOoB+GI0PHHm+G1UrzCy7WF44LteDCNKnWqmRz0xOzo93vX7mH
         QrYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+7ZQJwDPN94XCZWfMY0f3bKfe/+MUS1iizJz1cRRud0=;
        b=dGx8HNJOPT5JNNOc+6rVPHFPRFz2jTYwDbAGvf5TMxAsWu6xManRAbSaL7Vt+OBnGJ
         Mgib4zI1HDn86fUDn7wqV7+XIfRXMsDD7As2YJPxXSb+L67EzG9M4t5iX5/Xc2MBbDeg
         rNwGgOTgJ2Bh56NY3P6ubvSofkUiY2XFQDuqmdVtgAdDrmd8gdZqrwHqWyEJG7SuHfEl
         ibvoQwiPlyQcbNoT4CIgM8d9HIVNM5d4kKkBN0xYt1JZqmOkvQwiTBDs6Uco5o7LJqj1
         FrRlTb3ln0Kjlru+6VhRmo0DcnBdwGbEteXe2KX9bThrrB2GQ1g9xf3zauCDFa0Bu1EL
         N1zQ==
X-Gm-Message-State: AOAM532oZaav/ZVlEV/k4DEP728iVcAFgFcUpMTIOLcY3PQk+qOhRdd6
        GdpV91lJtqBvRnlkuZHHHaAAuVk74Vc=
X-Google-Smtp-Source: ABdhPJxgqeZMM0y2qDglaFdnE6xkyIlTT/6rdReCFv/JLoNxOC50esqKyJy67OTUPqUBCIH1rq7hmLiIqdc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:15c9:b0:51c:178:ac7e with SMTP id
 o9-20020a056a0015c900b0051c0178ac7emr5974949pfu.64.1655237258068; Tue, 14 Jun
 2022 13:07:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:39 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-15-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 14/42] KVM: selftests: Use kvm_cpu_has() for KVM's PV steal time
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_cpu_has() in the stea-ltime test instead of open coding
equivalent functionality using kvm_get_supported_cpuid_entry().

Opportunistically define all of KVM's paravirt CPUID-based features.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 22 +++++++++++++++++++
 tools/testing/selftests/kvm/steal_time.c      |  4 +---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 95d1b402da9b..db8d5a2775dd 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -135,6 +135,28 @@ struct kvm_x86_cpu_feature {
 #define X86_FEATURE_SEV			KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 1)
 #define X86_FEATURE_SEV_ES		KVM_X86_CPU_FEATURE(0x8000001F, 0, EAX, 3)
 
+/*
+ * KVM defined paravirt features.
+ */
+#define X86_FEATURE_KVM_CLOCKSOURCE	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 0)
+#define X86_FEATURE_KVM_NOP_IO_DELAY	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 1)
+#define X86_FEATURE_KVM_MMU_OP		KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 2)
+#define X86_FEATURE_KVM_CLOCKSOURCE2	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 3)
+#define X86_FEATURE_KVM_ASYNC_PF	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 4)
+#define X86_FEATURE_KVM_STEAL_TIME	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 5)
+#define X86_FEATURE_KVM_PV_EOI		KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 6)
+#define X86_FEATURE_KVM_PV_UNHALT	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 7)
+/* Bit 8 apparently isn't used?!?! */
+#define X86_FEATURE_KVM_PV_TLB_FLUSH	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 9)
+#define X86_FEATURE_KVM_ASYNC_PF_VMEXIT	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 10)
+#define X86_FEATURE_KVM_PV_SEND_IPI	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 11)
+#define X86_FEATURE_KVM_POLL_CONTROL	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 12)
+#define X86_FEATURE_KVM_PV_SCHED_YIELD	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 13)
+#define X86_FEATURE_KVM_ASYNC_PF_INT	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 14)
+#define X86_FEATURE_KVM_MSI_EXT_DEST_ID	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 15)
+#define X86_FEATURE_KVM_HC_MAP_GPA_RANGE	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 16)
+#define X86_FEATURE_KVM_MIGRATION_CONTROL	KVM_X86_CPU_FEATURE(0x40000001, 0, EAX, 17)
+
 /* CPUID.1.ECX */
 #define CPUID_VMX		(1ul << 5)
 #define CPUID_XSAVE		(1ul << 26)
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index d122f1e05cdd..5769d0cab4f5 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -60,9 +60,7 @@ static void guest_code(int cpu)
 
 static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid_entry2 *cpuid = kvm_get_supported_cpuid_entry(KVM_CPUID_FEATURES);
-
-	return cpuid && (cpuid->eax & KVM_FEATURE_STEAL_TIME);
+	return kvm_cpu_has(X86_FEATURE_KVM_STEAL_TIME);
 }
 
 static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
-- 
2.36.1.476.g0c4daa206d-goog

