Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA37B53D454
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350213AbiFDBWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350097AbiFDBWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:16 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3E35A140
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-30c24697ffaso79792117b3.16
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OE2dMTW1WZzsKCBPt600JzxUAoLzhxXCvLG8xb+mJtQ=;
        b=UORouyZwzAzUMWgkV4CowdjZaiMPkLHIlh3mNBtOULPqM9d9+8SaBazYYdKdmT1HUD
         pEmDREOxLR5K2IWIYFtSPF+zmv0nRlDAGZvvu8FuLMfh9XommYsgMypoo6F4yvOvdpY8
         TaY1i3So48BBMR6mfteyLhtqB7mIHi+XGyuGT2xH4t8BMKJGaXA5gSIlkUl4QNwUyUE2
         vmWFuoX7AGTuEve+jcSNaDzpney0u+uFs2fRYgylkTeTSMC1OSfYYPPxB56UBRvVH9ie
         pVI3AOxZgjO9o9m8hqCJtlKtKDzsLylY4mk0cT95f/NXlyJ7CXDDpv+YRJlci6Zkgs7+
         ESOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OE2dMTW1WZzsKCBPt600JzxUAoLzhxXCvLG8xb+mJtQ=;
        b=MIYS6aHmHLE0fpm+Mn0Ig7ema3uWMy/5uQAF7+IE7UoQh+cbrt1d1TumXooVXf+u6g
         FI1M3ySg00Ophf5LM1rbpypPyvZFVb+/KiaI6tATPEip6Ny9R2ow+H8H0rLhh2vFBKb8
         Eoff+S7dZz9TNpkdrMjQyOn91FBwP+jBHIOxeqiyRlJYACzdz1Zuqw0OMmvNAKb0nrHL
         V4qEWrycNbR4+feB2zHkz4eQpmpxZ5CWUTo9OU3dF0yvM8F6+KqSkA9hyuZ99gL7yDVy
         AsIfRpw8JP9ZA8XCmeHVSoM6PjpHI9dnD0097/kyrKl7paf7df9XiRD5OS/pOQibyI9P
         EgsQ==
X-Gm-Message-State: AOAM5338B4PuaVy0wctOqNZRv04mkmNNjrXz234x/rw/DsUq/e8O/AMb
        24rDKZUeV4YO7dm22QjsDpcCqg0bj8o=
X-Google-Smtp-Source: ABdhPJxUnFU8pppx/0XWONy/KqI0nhKfPpx+GukdQA7cXborW9JQLI/bh82Obd1W2WDMVCPsTNZ7GYgxouY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:8303:0:b0:65c:c9f7:3dbc with SMTP id
 s3-20020a258303000000b0065cc9f73dbcmr12894969ybk.259.1654305685297; Fri, 03
 Jun 2022 18:21:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:30 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-15-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 14/42] KVM: selftests: Use kvm_cpu_has() for KVM's PV steal time
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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
index a5e7b7bdec41..4701798736cf 100644
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
2.36.1.255.ge46751e96f-goog

