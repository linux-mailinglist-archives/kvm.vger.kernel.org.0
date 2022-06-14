Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E90F54BC39
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358495AbiFNUty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358280AbiFNUst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:48:49 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED78E4EDFC
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:21 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y1-20020a17090a390100b001e66bb0fcefso83142pjb.0
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9yzgzTlgrscZUiJ1Gi4IjzGYJkO0pcdsrR04YqBf76E=;
        b=rZ1uyAwvL/OQ5zJbPDu3GtwjHiMrA52vKQUQZyHFOqhPmh4K6JC4Opbx/1JqZurU4n
         R3IQkslvvfIOAaK0wE+4oU2y2EKWWd84LJKm1Vg8qIh5mX9UNmJMty6s9E1Qd/jZd4QG
         JnvrxYXToV1xhxgeIr5zxxbUjTvH4v2UnD22TGWVFrCFwNnUVVjLOgzqh5lbdOSucPDq
         zzDQwzN/ZRRdcBeqTnbMmUCKwiPGOQQwFfYh67TMTulpaJl/dgqzXkdbknHNdy1fqUet
         cOpiH/8yUp0pZ5az0R/ak73jiwJnVJKtJr06j6aTRalxsOf+BZ12l1u4ZDQLITYg4lfJ
         B06A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9yzgzTlgrscZUiJ1Gi4IjzGYJkO0pcdsrR04YqBf76E=;
        b=0RtLg2t9InmsZsGhje679Mhy+8RUlfdF4blglnR2xtrcZhhThLIvHxVHs9jTSffv/J
         ydCWX4z5BwaRp+QoGE2iNvut/ihrlSbA9Kk89FdSvLOXcTtWlX3PCT7ALCRfnUvK7G+L
         y1z/wggRSrhinzNBVYrkJXi65DdOOJ+6XH4l3AYz2M7nWwa6kV1aWTQgJbTOXpTbwsyQ
         U/r5f+3hLGvx5Qrf3afKRVGCLw6Y24tdPbxDLSqEel1HI8GN7Vn0SBluWLVvHfxPjaJk
         POn2t5EjdCoc1XdMSSIBcYQVi9fLO4/qHCihUk0r86sqkBnYlQ5XRFspga9OVxPGgpLi
         r1dg==
X-Gm-Message-State: AJIora8FU4nf8EwA9iZqfBQN9BtV2MKU/9czXV9T6/YE+Ae/mXd+zTod
        xuaYonJvRy3mznvInYbA6fdkTeRHrI0=
X-Google-Smtp-Source: AGRyM1vnJ9jOUAVV0uEy2GCBCkz/g0b0LhaP3MerIhzM8lUSLfVcJRVpjNj492GH1iIqIot21y2s3ifkVxU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:bf49:b0:168:d855:883b with SMTP id
 u9-20020a170902bf4900b00168d855883bmr6167928pls.79.1655239694001; Tue, 14 Jun
 2022 13:48:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:29 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-21-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 20/21] KVM: selftests: Use uapi header to get VMX and SVM
 exit reasons/codes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
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
2.36.1.476.g0c4daa206d-goog

