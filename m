Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402DA32DEE9
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhCEBLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbhCEBLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:35 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDE4C061760
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:34 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id i16so258640qtv.18
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UoSJXw/PVEOjBFScqgNo0bQzSNuTFSWEQtCbZglmTq0=;
        b=kQAMJObEqqL+h/6HsZlsplPO1BCJpjh9pP+48cHLs3OobIOB6CgTtrh6EZUMu3bXFi
         SHbHfRmqn8dUDqWqCLuyGL1qpn/iSCISWig3ZEmUqIOSOJf84eA7mq/rxUqwRENuEaS1
         bMeL/YM/DTmkCvKXJsxa8oH6zJQE+GEHRs++0WStbmPTpCCY4ix/suKB5VIiC8F2mFfm
         gVvvGp1a4BcXKYtQE/1E+t2IlypiBh1StC6Fx3FSEBYdV4TrwK8+IM67QaO/+AmjsMYu
         7w6gmYHZ7zvChYP1fmGyniTRJ06L8LCTWj1APum5SrUWMTrUkp5ID1aQAB1TXbCAYsLS
         /bOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UoSJXw/PVEOjBFScqgNo0bQzSNuTFSWEQtCbZglmTq0=;
        b=uC/JzvwMZ7vyqjUaG9sGztxKHYEtsoZXTvO6btSSuEMq29ky7AQuArphmWifalyuL2
         9/Cn7AinEIdC3qbwPrCy9tJc3U0UCwoSPfsOJXfh6A5odcDv1ib2AdrurT4JsL7GUfgD
         yqoXcCRcELQpIH/wJuHgwgPiXR664myGJPS50Qhi8JYL6m22CZRXlKHF0ypLh12kX9GL
         ahqB5JU88wOwlRk12zHCjbfrqMmkFL0y8earRtMTZ5UpTEznHPRBGXnVJvbpQkJ0O3i9
         ZwWre1LKbZFKb2dMIBFbBxWbWrEXY49NATA7u3rVLYVKrdAYNQRMgMtNOfmHK61DR6sK
         6fvA==
X-Gm-Message-State: AOAM5317r1YAB+hDi3pRMcDPHg+vF/7WXCu2MXoBINFbxUQvyBFZfONb
        XBteFCgkbKfOSP1KEle2E8Fyh8mppm4=
X-Google-Smtp-Source: ABdhPJzYlWm8aGDZV4ZezLV91M6AacXjOom4mKjt8Lg/YvFhNfe1l4qG1CS/p0mg+dc/jjRPcvsiw64XfYE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a0c:e5c9:: with SMTP id u9mr6738397qvm.55.1614906693998;
 Thu, 04 Mar 2021 17:11:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:56 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-13-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 12/17] KVM: SVM: Don't strip the C-bit from CR2 on #PF interception
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't strip the C-bit from the faulting address on an intercepted #PF,
the address is a virtual address, not a physical address.

Fixes: 0ede79e13224 ("KVM: SVM: Clear C-bit from the page fault address")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4769cf8bf2fd..dfc8fe231e8b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1907,7 +1907,7 @@ static int pf_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	u64 fault_address = __sme_clr(svm->vmcb->control.exit_info_2);
+	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
 	return kvm_handle_page_fault(vcpu, error_code, fault_address,
-- 
2.30.1.766.gb4fecdf3b7-goog

