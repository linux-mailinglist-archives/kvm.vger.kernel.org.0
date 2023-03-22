Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2386C3F9B
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 02:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCVBQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 21:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjCVBPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 21:15:52 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1453459E68
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:15:28 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id j18-20020a170902da9200b001a055243657so9766281plx.19
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 18:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679447722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gDWDUJZKEiSdc2jrx8xTfg9KaQTEhFf0r1pqILfpYfw=;
        b=c3vy0tRLOjOsR5JxOTTiqFC4RogaQM7GDamcMvByk11LgnruHpbE0CrS3dqs/uWiNy
         IfAErbnBxDoXUzsSwlirlmq6tg8Gv02goL5hgS5cbCjhSegRXhoeuOPaxT0K5E/hcjXZ
         uHly/hPshpkQc2OGsHdsgvAutoX51UwxGGrw7hek4T9CCI5chUpRR7pp80palsbOhg6j
         CKrExnLgK6rx+rT79i2HMg/l4K5dfZNWoGSokqGj4OGW7/unsdycIDuy1B5fMpI0sqAd
         4BYnElvb6yco11+yccg+6cQyxXLc/sKnc9yrX67bmbEmzHw9Lkvy2JffZ8itDeYSorRY
         L6ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679447722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gDWDUJZKEiSdc2jrx8xTfg9KaQTEhFf0r1pqILfpYfw=;
        b=N24E7tT8G+fzgkSiuTKvJcrmzydA6OIMtYDxNY+5JqnIC+qiqLG0G1Q8YkxIFqOk7L
         l8Ypd9Wugn6fk8sGRJtuO1fr4lc3XTi5vMLJ0TCyyDg4vm9GSqD9r0VDDstHgad/JH+v
         p8G6bFF09nGmjcB4pUZCWOymLxTsB3+/sgwhL9JltjzFj+wPRMeqzFe5Q0hB7NvkYbpm
         gbI7/mbpuLkAJqZHSHRQJ5PDTbSYD9h2XLj99RFvmOa2qbCipqK4VK7+advVQdaXiG2c
         UQM7Y9LSytDokLlayaUuZOmrqJKmBvOnP5mjaDG3u2rxEUbRbQ1b0pOcLhCtscP79j1a
         Mc7w==
X-Gm-Message-State: AAQBX9fgxUbHFulkZfwBJRmhCVP/0EpXgVpWLEnyWGFKIGC9d90HsdhP
        dnq8c4Qk/a12myBnFHUh9gVvity5zcI=
X-Google-Smtp-Source: AKy350bhYH/mN3be0Nvdh6JmMN6RjBoXTacZBAfDFH/cZZn0+D6DHLnYaz0gfwAWEf8bsunQUCVF4fokyig=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d88d:b0:1a1:def4:a030 with SMTP id
 b13-20020a170902d88d00b001a1def4a030mr248093plz.0.1679447722736; Tue, 21 Mar
 2023 18:15:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Mar 2023 18:14:38 -0700
In-Reply-To: <20230322011440.2195485-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230322011440.2195485-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230322011440.2195485-5-seanjc@google.com>
Subject: [PATCH 4/6] KVM: x86: Move MSR_IA32_PRED_CMD WRMSR emulation to
 common code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
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

Dedup the handling of MSR_IA32_PRED_CMD across VMX and SVM by moving the
logic to kvm_set_msr_common().  Now that the MSR interception toggling is
handled as part of setting guest CPUID, the VMX and SVM paths are
identical.

Opportunistically massage the code to make it a wee bit denser.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 14 --------------
 arch/x86/kvm/vmx/vmx.c | 14 --------------
 arch/x86/kvm/x86.c     | 11 +++++++++++
 3 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f757b436ffae..85bb535fc321 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2942,20 +2942,6 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 */
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
 		break;
-	case MSR_IA32_PRED_CMD:
-		if (!msr->host_initiated &&
-		    !guest_has_pred_cmd_msr(vcpu))
-			return 1;
-
-		if (data & ~PRED_CMD_IBPB)
-			return 1;
-		if (!boot_cpu_has(X86_FEATURE_IBPB))
-			return 1;
-		if (!data)
-			break;
-
-		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_VIRT_SSBD))
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5c01c76c0d45..29807be219b9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2285,20 +2285,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~(TSX_CTRL_RTM_DISABLE | TSX_CTRL_CPUID_CLEAR))
 			return 1;
 		goto find_uret_msr;
-	case MSR_IA32_PRED_CMD:
-		if (!msr_info->host_initiated &&
-		    !guest_has_pred_cmd_msr(vcpu))
-			return 1;
-
-		if (data & ~PRED_CMD_IBPB)
-			return 1;
-		if (!boot_cpu_has(X86_FEATURE_IBPB))
-			return 1;
-		if (!data)
-			break;
-
-		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-		break;
 	case MSR_IA32_CR_PAT:
 		if (!kvm_pat_valid(data))
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 237c483b1230..c83ec88da043 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3617,6 +3617,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.perf_capabilities = data;
 		kvm_pmu_refresh(vcpu);
 		return 0;
+	case MSR_IA32_PRED_CMD:
+		if (!msr_info->host_initiated && !guest_has_pred_cmd_msr(vcpu))
+			return 1;
+
+		if (!boot_cpu_has(X86_FEATURE_IBPB) || (data & ~PRED_CMD_IBPB))
+			return 1;
+		if (!data)
+			break;
+
+		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
+		break;
 	case MSR_EFER:
 		return set_efer(vcpu, msr_info);
 	case MSR_K7_HWCR:
-- 
2.40.0.rc2.332.ga46443480c-goog

