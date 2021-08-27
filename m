Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777A43F9E20
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 19:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbhH0RmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 13:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhH0RmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 13:42:12 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D09C061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 10:41:23 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id r1-20020a62e401000000b003f27c6ae031so1688199pfh.20
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 10:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BiRBmZK1PG8vtC7K8U5YhEk+AMuFdq7Zxq4OxUPgKWk=;
        b=pIneK38fIZN0zToEv8bF1uyakxu13I5L7FWXWcg6Si2RYqk1ulHB5NNH3tN+pfacKO
         uLt0rwc0O9GbEDMeYVBmmeUOmCy09ql2q5O9/GxKm0MluJjFCxpJ2PghoMGjZ5Hi0HP7
         q+3pB54Us6udm/u3FM8HDp8mHOL6BktnriudDrIuVwvnE9JTI/v1PM+x4eo934U+nVlR
         UGgkeaGv5dWmqfLwzt0HPlInErlf9i7r8VTJurz949mHioTvlFBGKYXVRoZbbkegN/+i
         A45+crc/pdYF4DEc+V+ex4yDj+o4oqoAgltkN045Rku7ffreTsQPVErZCyNKaLlucrRa
         i4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BiRBmZK1PG8vtC7K8U5YhEk+AMuFdq7Zxq4OxUPgKWk=;
        b=Jf4FwQrlWpU9G72tTX8S5MNT9PvySeR5h8BCfrMDNDO5jei8yEtOb83laJjsQfA7pl
         YofX1ZA2lN7rFfM/iaN5+XlTTiI+x3vFJ2s95F7aw/+E+0jnfoWwgEymvSWFNneYUmFW
         2qvczqVKWn3EBoB4WgxNZDcZtei9tHJ104EC0cUGSzQGHrz7l90Q8vI0spKED43SeMgO
         UTqzf5dLCYnZ2qi+i7tlEUWUYezgCiokgKDD/8ZEW9uVhn34JQNKjseSfmUbnobFMkZg
         ofF2VdTwCvEfu2NwI2DNoNBo8ASw+MSEVGimCnzNAGBNLyFr7jpCFCZZ8PiMP6NEVUXA
         ioEQ==
X-Gm-Message-State: AOAM5326E4oWPxUtAtATZOWqOXg0WK/usu/hKdH8aoiU7sEYsnS6OZnA
        zexknBtMAPg1S7QFj58n8XuTYCE16lpoHDH1ayXGO/d4fB/ravnLkaVnUiJVmrz1dQ1B9TNfSPX
        XQFvbuTIoBywgw29jPT111gqfPRrYOKz0qnuutZ6B/ZDU1FUeE5L2MIRziOj39LjFGmSrgQk=
X-Google-Smtp-Source: ABdhPJz1fsiBm8CeitaiFkZZ4+07wa8S7r772pYCRzJ7KbNRSW4B7gF4gXq3lf4kOQU4axAWLWiimp7us7xkBGQcKQ==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:8198:0:b029:3dd:a2ec:9ea8 with
 SMTP id g24-20020aa781980000b02903dda2ec9ea8mr10174025pfi.11.1630086082609;
 Fri, 27 Aug 2021 10:41:22 -0700 (PDT)
Date:   Fri, 27 Aug 2021 17:41:10 +0000
In-Reply-To: <20210827174110.3723076-1-jingzhangos@google.com>
Message-Id: <20210827174110.3723076-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210827174110.3723076-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 2/2] KVM: stats: Add counters for SVM exit reasons
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Three different exit code ranges are named as low, high and vmgexit,
which start from 0x0, 0x400 and 0x80000000.

Original-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++++
 arch/x86/include/uapi/asm/svm.h |  7 +++++++
 arch/x86/kvm/svm/svm.c          | 21 +++++++++++++++++++++
 arch/x86/kvm/x86.c              |  9 +++++++++
 4 files changed, 44 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dd2380c9ea96..6e3c11a29afe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -35,6 +35,7 @@
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/hyperv-tlfs.h>
 #include <asm/vmx.h>
+#include <asm/svm.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
@@ -1261,6 +1262,12 @@ struct kvm_vcpu_stat {
 	u64 vmx_all_exits[EXIT_REASON_NUM];
 	u64 vmx_l2_exits[EXIT_REASON_NUM];
 	u64 vmx_nested_exits[EXIT_REASON_NUM];
+	u64 svm_exits_low[SVM_EXIT_LOW_END - SVM_EXIT_LOW_START];
+	u64 svm_exits_high[SVM_EXIT_HIGH_END - SVM_EXIT_HIGH_START];
+	u64 svm_vmgexits[SVM_VMGEXIT_END - SVM_VMGEXIT_START];
+	u64 svm_vmgexit_unsupported_event;
+	u64 svm_exit_sw;
+	u64 svm_exit_err;
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index efa969325ede..153ebc4ac70e 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -2,6 +2,7 @@
 #ifndef _UAPI__SVM_H
 #define _UAPI__SVM_H
 
+#define SVM_EXIT_LOW_START     0x000
 #define SVM_EXIT_READ_CR0      0x000
 #define SVM_EXIT_READ_CR2      0x002
 #define SVM_EXIT_READ_CR3      0x003
@@ -95,17 +96,23 @@
 #define SVM_EXIT_CR14_WRITE_TRAP		0x09e
 #define SVM_EXIT_CR15_WRITE_TRAP		0x09f
 #define SVM_EXIT_INVPCID       0x0a2
+#define SVM_EXIT_LOW_END			0xa3
+
+#define SVM_EXIT_HIGH_START			0x400
 #define SVM_EXIT_NPF           0x400
 #define SVM_EXIT_AVIC_INCOMPLETE_IPI		0x401
 #define SVM_EXIT_AVIC_UNACCELERATED_ACCESS	0x402
 #define SVM_EXIT_VMGEXIT       0x403
+#define SVM_EXIT_HIGH_END			0x404
 
 /* SEV-ES software-defined VMGEXIT events */
+#define SVM_VMGEXIT_START			0x80000000
 #define SVM_VMGEXIT_MMIO_READ			0x80000001
 #define SVM_VMGEXIT_MMIO_WRITE			0x80000002
 #define SVM_VMGEXIT_NMI_COMPLETE		0x80000003
 #define SVM_VMGEXIT_AP_HLT_LOOP			0x80000004
 #define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
+#define SVM_VMGEXIT_END				0x80000006
 #define SVM_VMGEXIT_SET_AP_JUMP_TABLE		0
 #define SVM_VMGEXIT_GET_AP_JUMP_TABLE		1
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a70e11f0487..e04bd201dd53 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3291,6 +3291,7 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 exit_code = svm->vmcb->control.exit_code;
+	size_t index;
 
 	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
 
@@ -3337,6 +3338,26 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
+	if (exit_code >= SVM_EXIT_LOW_START &&
+			exit_code < SVM_EXIT_LOW_END) {
+		index = exit_code - SVM_EXIT_LOW_START;
+		++vcpu->stat.svm_exits_low[index];
+	} else if (exit_code >= SVM_EXIT_HIGH_START &&
+			exit_code < SVM_EXIT_HIGH_END) {
+		index = exit_code - SVM_EXIT_HIGH_START;
+		++vcpu->stat.svm_exits_high[index];
+	} else if (exit_code >= SVM_VMGEXIT_START &&
+			exit_code < SVM_VMGEXIT_END) {
+		index = exit_code - SVM_VMGEXIT_START;
+		++vcpu->stat.svm_vmgexits[index];
+	} else if (exit_code == SVM_VMGEXIT_UNSUPPORTED_EVENT) {
+		++vcpu->stat.svm_vmgexit_unsupported_event;
+	} else if (exit_code == SVM_EXIT_SW) {
+		++vcpu->stat.svm_exit_sw;
+	} else if (exit_code == SVM_EXIT_ERR) {
+		++vcpu->stat.svm_exit_err;
+	}
+
 	return svm_invoke_exit_handler(vcpu, exit_code);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 245ad1d147dd..df75e4b2711e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -281,6 +281,15 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_LINHIST_COUNTER(VCPU, vmx_all_exits, EXIT_REASON_NUM, 1),
 	STATS_DESC_LINHIST_COUNTER(VCPU, vmx_l2_exits, EXIT_REASON_NUM, 1),
 	STATS_DESC_LINHIST_COUNTER(VCPU, vmx_nested_exits, EXIT_REASON_NUM, 1),
+	STATS_DESC_LINHIST_COUNTER(VCPU, svm_exits_low,
+			SVM_EXIT_LOW_END - SVM_EXIT_LOW_START, 1),
+	STATS_DESC_LINHIST_COUNTER(VCPU, svm_exits_high,
+			SVM_EXIT_HIGH_END - SVM_EXIT_HIGH_START, 1),
+	STATS_DESC_LINHIST_COUNTER(VCPU, svm_vmgexits,
+			SVM_VMGEXIT_END - SVM_VMGEXIT_START, 1),
+	STATS_DESC_COUNTER(VCPU, svm_vmgexit_unsupported_event),
+	STATS_DESC_COUNTER(VCPU, svm_exit_sw),
+	STATS_DESC_COUNTER(VCPU, svm_exit_err),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
-- 
2.33.0.259.gc128427fd7-goog

