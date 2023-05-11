Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA57B6FFD5F
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 01:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239670AbjEKXea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 19:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239646AbjEKXeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 19:34:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268257287
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:34:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b9a25f6aa0eso16973705276.1
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 16:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683848048; x=1686440048;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5OzO4AIyk8CcuO4AHVhystfnHKvcEmys7VtS5dmQ4ZE=;
        b=FabEf2n42yFdnZkLbN5ZUvfZEnmjHnwc4bL3soeRte3ESjENRciPwc/+PDZO96NOZy
         ZGGZDkN10x7aFM5fJzHXRkvFdq8wZ+4fCecT0IaaAcnc/wXwuLylmJmoTdVDvJR4UWYi
         vg476bGBpmuyYEsvZY+Xb3uAuueflvB9z5Gi6PzZpVSHGWmOJV0QMIguBJEHhrmxAP1K
         zPe2v24Slvbp+iTgxUkYTDijq8YotnQYgnIbnVIY/C4JG1djQ81M6oZIoFX2JV4vADOR
         QZcvWzaC97bo95iCT9wb0MUtrAyG16dPWRGRc8ag3Gb0XE0JF0vq+rhlLsdjQhb/Fuzw
         9IHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683848048; x=1686440048;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5OzO4AIyk8CcuO4AHVhystfnHKvcEmys7VtS5dmQ4ZE=;
        b=REyeoPy59VlbiMFVapW7jj6eAcyhe+DxUoXXWnCjdtRBpdAHtOsdepc8zW1jR0DgNN
         qDmeOfIX6GqKeFQTOH7ECu0seD18Xj+9xD4rKiFlj+rjIQ/d5O5k5VFGsltOVV5+JjaE
         hSvdvQR4DN0pv9tS5FLwDZO08i8ZVs40Ex8BvOdcycVgjHJA197a1o9tCn0rkok5Zn6n
         UYUkGbA5ZtmvpIayHeToFthmnU8ffCOUe1V6h1fhUn+khlz1VIqwClH7ug9HZCH+AGId
         Wo68MU1AUi4CKbQ1gZCo2Za774/O7P6k4dX0ubuUiaz8qot2+p4Rt+ViAqDScH1ykww0
         2Dug==
X-Gm-Message-State: AC+VfDzmU/jaErTl6buNVw3rwtqP+gdzMlDRf/BBDtcaTFcrMCP1OkMS
        KhPvlDKVRfC2qlMiPORCm5ePybsQtPo=
X-Google-Smtp-Source: ACHHUZ6eSWGmngZVlLRhCtXtjaxjnWEvvr2M16cfqckuopueDFEMBXB17+9yzcQfk7oe7i5bM+LlMeGzC9Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e746:0:b0:ba6:c52a:cb7a with SMTP id
 e67-20020a25e746000000b00ba6c52acb7amr1357395ybh.4.1683848048189; Thu, 11 May
 2023 16:34:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 May 2023 16:33:51 -0700
In-Reply-To: <20230511233351.635053-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230511233351.635053-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230511233351.635053-9-seanjc@google.com>
Subject: [PATCH v2 8/8] KVM: x86: Move common handling of PAT MSR writes to kvm_set_msr_common()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Wenyao Hai <haiwenyao@uniontech.com>,
        Ke Guo <guoke@uniontech.com>
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

Move the common check-and-set handling of PAT MSR writes out of vendor
code and into kvm_set_msr_common().  This aligns writes with reads, which
are already handled in common code, i.e. makes the handling of reads and
writes symmetrical in common code.

Alternatively, the common handling in kvm_get_msr_common() could be moved
to vendor code, but duplicating code is generally undesirable (even though
the duplicatated code is trivial in this case), and guest writes to PAT
should be rare, i.e. the overhead of the extra function call is a
non-issue in practice.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 7 ++++---
 arch/x86/kvm/vmx/vmx.c | 7 +++----
 arch/x86/kvm/x86.c     | 6 ------
 3 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index db237ccdc957..61d329760f6c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2935,9 +2935,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		break;
 	case MSR_IA32_CR_PAT:
-		if (!kvm_pat_valid(data))
-			return 1;
-		vcpu->arch.pat = data;
+		ret = kvm_set_msr_common(vcpu, msr);
+		if (ret)
+			break;
+
 		svm->vmcb01.ptr->save.g_pat = data;
 		if (is_guest_mode(vcpu))
 			nested_vmcb02_compute_g_pat(svm);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 33b8625d3541..2d9d155691a7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2287,10 +2287,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		goto find_uret_msr;
 	case MSR_IA32_CR_PAT:
-		if (!kvm_pat_valid(data))
-			return 1;
-
-		vcpu->arch.pat = data;
+		ret = kvm_set_msr_common(vcpu, msr_info);
+		if (ret)
+			break;
 
 		if (is_guest_mode(vcpu) &&
 		    get_vmcs12(vcpu)->vm_exit_controls & VM_EXIT_SAVE_IA32_PAT)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d71cf924cd8f..3759737c0873 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3701,12 +3701,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_IA32_CR_PAT:
-		/*
-		 * Writes to PAT should be handled by vendor code as both SVM
-		 * and VMX track the guest's PAT in the VMCB/VMCS.
-		 */
-		WARN_ON_ONCE(1);
-
 		if (!kvm_pat_valid(data))
 			return 1;
 
-- 
2.40.1.606.ga4b1b128d6-goog

