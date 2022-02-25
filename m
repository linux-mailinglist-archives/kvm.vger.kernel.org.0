Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931E04C5024
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 21:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiBYUwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 15:52:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbiBYUwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 15:52:45 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20ABE223202
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:52:12 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id x25-20020a63b219000000b0037425262baeso1090913pge.13
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=NrKSXSX0Ejbdt8Wd9QgUP4pP5j8LyGhFsIy8SA/+5XM=;
        b=Pu2BcAX6cGgskeOtQrxvdXFfweiJZCrYIIB6EECZjjrqNkVsu3hHzVB+1Ac7tPIFME
         yCHyVnwWaiBbBKMtVy9IeNley7jmwwtNnBA27mqCxK8zYo3meVHV9WV5Jm5Hi6YHMgYx
         v9N4gGBwh3dG0+Z8EK/D5Q/DPLUVUqDbfel+5PZF+GeUcYBk0InYlWPAi3WWoX6A0j1J
         i4TNmsxKSaLCTEtoGER4SpPT+f+owTkiNUj98olnZK5GQ+u9Ml8IF/d4vZaAdg0+o+c+
         t4UZ6zRQQhs9xFKzDbBzGMkisI05ofGYOfWNAIuPnVE+mB5D//YDX0pWIOBrRH55FNID
         qWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=NrKSXSX0Ejbdt8Wd9QgUP4pP5j8LyGhFsIy8SA/+5XM=;
        b=jqDyQvD9u84ETswtlYsEWbXZXdScaxDh2MUwLdbRrVlFLtmopdMvW7TrwVI4nOvA1B
         1ThAXHwfjeUrwaqa9vtFfl55FBDLjXOEmxYGb9dt4mj/drDjC0YpM24tPAEMvBDig8ph
         eWaIK24wVuqvwhYB+osb3uv4C37dqw682qTO/b3y96f+Z3XHc83SzA2eYU3RQu21MP9H
         IQdQJDIpiZ+AQgqxrJu6mfyhIYNz0Jq1sXmSeM2GcqIo+3Mt+IzuhTESlFt8F1ZxCBWe
         BShtW5aHXXqalFJ+7mGknWX+/U4OZwR+4eOLpm3sDphVdwArdjM8iqZcvOuiTXu2dPrN
         5ahA==
X-Gm-Message-State: AOAM533bgS3CN5YMX3JB8ZZ+P+WXb2d1Nyg7MCLjTWRo+ZobSd2NlTEI
        n0XxsaXa9yP6V54TMV/NjO0fAwA2Nic=
X-Google-Smtp-Source: ABdhPJwfoRUZoJ+hDw1N8Cvy3Kw/BmQ8vhMH1ng3RzEoTtbyh/OZpSVtSD9LwNYyACW1jfK4AV7TuoL80dU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:364f:b0:1bc:7337:d7df with SMTP id
 nh15-20020a17090b364f00b001bc7337d7dfmr4923152pjb.61.1645822331502; Fri, 25
 Feb 2022 12:52:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 25 Feb 2022 20:52:09 +0000
Message-Id: <20220225205209.3881130-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH] KVM: SVM: Exit to userspace on ENOMEM/EFAULT GHCB errors
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>
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

Exit to userspace if setup_vmgexit_scratch() fails due to OOM or because
copying data from guest (userspace) memory failed/faulted.  The OOM
scenario is clearcut, it's userspace's decision as to whether it should
terminate the guest, free memory, etc...

As for -EFAULT, arguably, any guest issue is a violation of the guest's
contract with userspace, and thus userspace needs to decide how to
proceed.  E.g. userspace defines what is RAM vs. MMIO and communicates
that directly to the guest, KVM is not involved in deciding what is/isn't
RAM nor in communicating that information to the guest.  If the scratch
GPA doesn't resolve to a memslot, then the guest is not honoring the
memory configuration as defined by userspace.

And if userspace unmaps an hva for whatever reason, then exiting to
userspace with -EFAULT is absolutely the right thing to do.  KVM's ABI
currently sucks and doesn't provide enough information to act on the
-EFAULT, but that will hopefully be remedied in the future as there are
multiple use cases, e.g. uffd and virtiofs truncation, that shouldn't
require any work in KVM beyond returning -EFAULT with a small amount of
metadata.

KVM could define its ABI such that failure to access the scratch area is
reflected into the guest, i.e. establish a contract with userspace, but
that's undesirable as it limits KVM's options in the future, e.g. in the
potential uffd case any failure on a uaccess needs to kick out to
userspace.  KVM does have several cases where it reflects these errors
into the guest, e.g. kvm_pv_clock_pairing() and Hyper-V emulation, but
KVM would preferably "fix" those instead of propagating the falsehood
that any memory failure is the guest's fault.

Lastly, returning a boolean as an "error" for that a helper that isn't
named accordingly never works out well.

Fixes: ad5b353240c8 ("KVM: SVM: Do not terminate SEV-ES guests on GHCB validation failure")
Cc: Alper Gun <alpergun@google.com>
Cc: Peter Gonda <pgonda@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

This is feedback for the "fixed" commit that got lost[*].  I felt quite
strongly about not returning booleans then, and I feel even more strongly
now as Alper got burned by this when backporting SEV-ES support.  Even if
we don't want to exit to userspace, we should at least avoid using bools
as error codes.

As before, compile tested only.

[*] https://lore.kernel.org/all/YapIMYiJ+iIfHI+c@google.com

 arch/x86/kvm/svm/sev.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 789b69294d28..75fa6dd268f0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2377,7 +2377,7 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
-static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
+static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu;
 	struct ghcb *ghcb;
@@ -2482,7 +2482,7 @@ static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		goto vmgexit_err;
 	}
 
-	return true;
+	return 0;
 
 vmgexit_err:
 	vcpu = &svm->vcpu;
@@ -2505,7 +2505,8 @@ static bool sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	ghcb_set_sw_exit_info_1(ghcb, 2);
 	ghcb_set_sw_exit_info_2(ghcb, reason);
 
-	return false;
+	/* Resume the guest to "return" the error code. */
+	return 1;
 }
 
 void sev_es_unmap_ghcb(struct vcpu_svm *svm)
@@ -2564,7 +2565,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 }
 
 #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
-static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
+static int setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct ghcb *ghcb = svm->sev_es.ghcb;
@@ -2617,14 +2618,14 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 		}
 		scratch_va = kvzalloc(len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
-			goto e_scratch;
+			return -ENOMEM;
 
 		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
 			/* Unable to copy scratch area from guest */
 			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
 
 			kvfree(scratch_va);
-			goto e_scratch;
+			return -EFAULT;
 		}
 
 		/*
@@ -2640,13 +2641,13 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 	svm->sev_es.ghcb_sa = scratch_va;
 	svm->sev_es.ghcb_sa_len = len;
 
-	return true;
+	return 0;
 
 e_scratch:
 	ghcb_set_sw_exit_info_1(ghcb, 2);
 	ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_SCRATCH_AREA);
 
-	return false;
+	return 1;
 }
 
 static void set_ghcb_msr_bits(struct vcpu_svm *svm, u64 value, u64 mask,
@@ -2784,17 +2785,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 	exit_code = ghcb_get_sw_exit_code(ghcb);
 
-	if (!sev_es_validate_vmgexit(svm))
-		return 1;
+	ret = sev_es_validate_vmgexit(svm);
+	if (ret)
+		return ret;
 
 	sev_es_sync_from_ghcb(svm);
 	ghcb_set_sw_exit_info_1(ghcb, 0);
 	ghcb_set_sw_exit_info_2(ghcb, 0);
 
-	ret = 1;
 	switch (exit_code) {
 	case SVM_VMGEXIT_MMIO_READ:
-		if (!setup_vmgexit_scratch(svm, true, control->exit_info_2))
+		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
+		if (ret)
 			break;
 
 		ret = kvm_sev_es_mmio_read(vcpu,
@@ -2803,7 +2805,8 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 					   svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_MMIO_WRITE:
-		if (!setup_vmgexit_scratch(svm, false, control->exit_info_2))
+		ret = setup_vmgexit_scratch(svm, false, control->exit_info_2);
+		if (ret)
 			break;
 
 		ret = kvm_sev_es_mmio_write(vcpu,
@@ -2836,6 +2839,7 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			ghcb_set_sw_exit_info_2(ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
+		ret = 1;
 		break;
 	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
@@ -2855,6 +2859,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 {
 	int count;
 	int bytes;
+	int r;
 
 	if (svm->vmcb->control.exit_info_2 > INT_MAX)
 		return -EINVAL;
@@ -2863,8 +2868,9 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 	if (unlikely(check_mul_overflow(count, size, &bytes)))
 		return -EINVAL;
 
-	if (!setup_vmgexit_scratch(svm, in, bytes))
-		return 1;
+	r = setup_vmgexit_scratch(svm, in, bytes);
+	if (r)
+		return r;
 
 	return kvm_sev_es_string_io(&svm->vcpu, size, port, svm->sev_es.ghcb_sa,
 				    count, in);

base-commit: 625e7ef7da1a4addd8db41c2504fe8a25b93acd5
-- 
2.35.1.574.g5d30c73bfb-goog

