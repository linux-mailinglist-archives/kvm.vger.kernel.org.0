Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D8F5A71BB
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiH3XT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbiH3XSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:45 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFC7A3D4F
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:17:03 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33d9f6f4656so192251547b3.21
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=19wpStpWgjciG3Cnonw3gTfd1FpuXzvtxhmxo4kcyWo=;
        b=QuhmWsK4UlqQbc8jWk0gJKIwhBoOrSZEb3GpvJXgUlj/Fjm2/3wTkU2exiwLaIsVRK
         eyoT0Qxr/wA6WYH6074LA1x4nUBl1bPMdb83s1zqUQ/uAf5rhVHxQePUoyQZ9nbQzo76
         6w6HHeKUc6nVm15OUP5Dqidpt656uV4Vb0A/r49hf7xApsF9bqRNI4VJQmhDw0teGzbU
         U0IVbXAeC0IHu+rqqvl9l/q/LW/uDU0UmBP/7+molaMmPvQz2vvGMuKBTr3JlnC+O/Gv
         Wj6z1676sq9rClwaFpYaWv6QR+MNXNmokkDCGkeA7tuzPnBorqyDrcP+a8J9QvVyGbKa
         4t5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=19wpStpWgjciG3Cnonw3gTfd1FpuXzvtxhmxo4kcyWo=;
        b=URD6DpkcznouBL99c4gskfcDPZMnmp4dLzbZY+3Alt3lYl5JUptuJH0ZixYKZGTy4L
         oMe3aldLm+EDX1IcER0kG8sEXn/5RIsb6qt3Hxifflo69CEBrC+OhGKqjafq90xzicDA
         BfcDdqZUxy9zEDM8TTEytrL6+/PnHosLaedTbUBOEvM95lExEx6rU0UmpFS2nbDTRFtk
         CT3nyFaaUNz1d8m2LESh84i9OGniJKe8t0+v+HMi8eR6b45xEJ4q5PmL1EnK285I8Bnn
         qd139GKwNBxqLlaVtd8lUithd1mU5B73DDbNPvNF+zJaZp+ArGuX8guuq7u4xQ8tmeey
         E1AQ==
X-Gm-Message-State: ACgBeo2Y9NQSaDaxJQ+TS/s2SwY6cAK/c/OxLHxGQoFpfeZRoaJJfI9B
        8ZuzrYw0oIzpOh9V1y/MI6h7Sojnuvg=
X-Google-Smtp-Source: AA6agR56twy6OZVHnzIYAie76XeVBifGue4TfnX2tu4ywJqWqbTemGxxRZX5qCD4BYL7ogNAiir9PTwDilM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:23d4:0:b0:695:65fb:bf66 with SMTP id
 j203-20020a2523d4000000b0069565fbbf66mr13671172ybj.3.1661901418977; Tue, 30
 Aug 2022 16:16:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:16:12 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-26-seanjc@google.com>
Subject: [PATCH v5 25/27] KVM: selftests: Use uapi header to get VMX and SVM
 exit reasons/codes
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Include the vmx.h and svm.h uapi headers that KVM so kindly provides
instead of manually defining all the same exit reasons/code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 .../selftests/kvm/include/x86_64/svm_util.h   |  7 +--
 .../selftests/kvm/include/x86_64/vmx.h        | 51 +------------------
 2 files changed, 4 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index a339b537a575..7aee6244ab6a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -9,15 +9,12 @@
 #ifndef SELFTEST_KVM_SVM_UTILS_H
 #define SELFTEST_KVM_SVM_UTILS_H
 
+#include <asm/svm.h>
+
 #include <stdint.h>
 #include "svm.h"
 #include "processor.h"
 
-#define SVM_EXIT_EXCP_BASE	0x040
-#define SVM_EXIT_HLT		0x078
-#define SVM_EXIT_MSR		0x07c
-#define SVM_EXIT_VMMCALL	0x081
-
 struct svm_test_data {
 	/* VMCB */
 	struct vmcb *vmcb; /* gva */
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 99fa1410964c..e4206f69b716 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -8,6 +8,8 @@
 #ifndef SELFTEST_KVM_VMX_H
 #define SELFTEST_KVM_VMX_H
 
+#include <asm/vmx.h>
+
 #include <stdint.h>
 #include "processor.h"
 #include "apic.h"
@@ -100,55 +102,6 @@
 #define VMX_EPT_VPID_CAP_AD_BITS		0x00200000
 
 #define EXIT_REASON_FAILED_VMENTRY	0x80000000
-#define EXIT_REASON_EXCEPTION_NMI	0
-#define EXIT_REASON_EXTERNAL_INTERRUPT	1
-#define EXIT_REASON_TRIPLE_FAULT	2
-#define EXIT_REASON_INTERRUPT_WINDOW	7
-#define EXIT_REASON_NMI_WINDOW		8
-#define EXIT_REASON_TASK_SWITCH		9
-#define EXIT_REASON_CPUID		10
-#define EXIT_REASON_HLT			12
-#define EXIT_REASON_INVD		13
-#define EXIT_REASON_INVLPG		14
-#define EXIT_REASON_RDPMC		15
-#define EXIT_REASON_RDTSC		16
-#define EXIT_REASON_VMCALL		18
-#define EXIT_REASON_VMCLEAR		19
-#define EXIT_REASON_VMLAUNCH		20
-#define EXIT_REASON_VMPTRLD		21
-#define EXIT_REASON_VMPTRST		22
-#define EXIT_REASON_VMREAD		23
-#define EXIT_REASON_VMRESUME		24
-#define EXIT_REASON_VMWRITE		25
-#define EXIT_REASON_VMOFF		26
-#define EXIT_REASON_VMON		27
-#define EXIT_REASON_CR_ACCESS		28
-#define EXIT_REASON_DR_ACCESS		29
-#define EXIT_REASON_IO_INSTRUCTION	30
-#define EXIT_REASON_MSR_READ		31
-#define EXIT_REASON_MSR_WRITE		32
-#define EXIT_REASON_INVALID_STATE	33
-#define EXIT_REASON_MWAIT_INSTRUCTION	36
-#define EXIT_REASON_MONITOR_INSTRUCTION 39
-#define EXIT_REASON_PAUSE_INSTRUCTION	40
-#define EXIT_REASON_MCE_DURING_VMENTRY	41
-#define EXIT_REASON_TPR_BELOW_THRESHOLD 43
-#define EXIT_REASON_APIC_ACCESS		44
-#define EXIT_REASON_EOI_INDUCED		45
-#define EXIT_REASON_EPT_VIOLATION	48
-#define EXIT_REASON_EPT_MISCONFIG	49
-#define EXIT_REASON_INVEPT		50
-#define EXIT_REASON_RDTSCP		51
-#define EXIT_REASON_PREEMPTION_TIMER	52
-#define EXIT_REASON_INVVPID		53
-#define EXIT_REASON_WBINVD		54
-#define EXIT_REASON_XSETBV		55
-#define EXIT_REASON_APIC_WRITE		56
-#define EXIT_REASON_INVPCID		58
-#define EXIT_REASON_PML_FULL		62
-#define EXIT_REASON_XSAVES		63
-#define EXIT_REASON_XRSTORS		64
-#define LAST_EXIT_REASON		64
 
 enum vmcs_field {
 	VIRTUAL_PROCESSOR_ID		= 0x00000000,
-- 
2.37.2.672.g94769d06f0-goog

