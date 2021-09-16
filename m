Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C273340ECDF
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 23:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239084AbhIPVqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 17:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238288AbhIPVqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 17:46:48 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90620C061756
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 14:45:27 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g15-20020a63564f000000b00261998c1b70so6376230pgm.5
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 14:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=R5NhbA+pjUVPZNfNHPtaYNtNYTv1h+ja92HfpRStBqA=;
        b=LlzVqBRk9HyqIgkEKwTRdfPTOIlc3qOVXfopYaEeFe9ZewruQYdODOZc8ASQp5OKCr
         Fl7/fBaZ6EHFKNXJ+xM1+VbZvBIswyWIiv0TEV7LOY++QwJvEVoGtioABjNg40Qn3TMA
         unYRCZZpwXzX+cv1A4dD/X6mHRxaNWtuNhCSi55oFbCJsobXuBQEfo5PI0WwyK3cL0a9
         utyujJWR0SBfQ+Pg+0ED6h3oWQP7PTBC6Q/WhqqWFLJLRF+M+Eeqg2JkmSwEqDt9iPtb
         ribrRQ8TyqBF/g79W4DNfjSteKGfhXaqLR/r0oqZsHexVUqAxtuwTNvMRN/a1XIYDPSl
         9bug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=R5NhbA+pjUVPZNfNHPtaYNtNYTv1h+ja92HfpRStBqA=;
        b=ZgtDVtjgJ/JBswEw0pL35vpoaxTvG1SIxtpCJDLRAA3Zw3s5iYkrQy5Fe6mKwoR5kd
         +v53W+ggN/g6qqjski9nGrNH4+RDQOtE1PCzJ4MmvseW2eYYDL/cC4sTwBUpOCx2DLU3
         x6HteB4FDklDmRwuo/Mqe2G4b90TlAuc8GlfS+z7RIGpJ1Yi+TG7MsVlYY39o0rCJL69
         90G2EPuENlYZyvszpzO2kcmm4p4f6FCDd6ZBfE2j7SZCVL5/IB0j8yQZjcWZq1IDprho
         rG4znR/icRPDi5V0eMHa1TMFg0nQz2xd8Jg3xM83eOhbOj1LcUJiRIpZQExBuqgJc5oc
         tMzw==
X-Gm-Message-State: AOAM533+cd2E7tWjhiVLTlFj5DIPdrS5bGh9Mki6AqjgJNvKdRQDxCo2
        /G4mn2sUG8xmUclVIi8UqlJVOs1Yh4wm
X-Google-Smtp-Source: ABdhPJyJ3GLd7Y4KTIshP0TGJLp8e0qxBx7aK4BWozn5MOmt0QCKuiQq7LSf2MbjftzPa+72dT3WDDKPV4P0
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:1a52:: with SMTP id
 18mr17365103pjl.43.1631828726904; Thu, 16 Sep 2021 14:45:26 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Thu, 16 Sep 2021 21:45:22 +0000
Message-Id: <20210916214522.1560893-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2] KVM: SVM: fix missing sev_decommission() in sev_receive_start()
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, John Allen <john.allen@amd.com>,
        Peter Gonda <pgonda@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DECOMMISSION the current SEV context if binding an ASID fails after
RECEIVE_START. Per AMD's SEV API, RECEIVE_START generates a new guest
context and thus needs to be paired with DECOMMISSION:

AMD SEV API v0.24 Section 1.3.3

  "The RECEIVE_START command is the only command other than the
  LAUNCH_START command that generates a new guest context and guest
  handle."

The missing DECOMMISSION can result in subsequent SEV launch failures due
to insufficient resource. In particular, both LAUNCH_START and
RECEIVE_START command will fail with SEV_RET_RESOURCE_LIMIT error.

Note, LAUNCH_START suffered from the same bug, but was previously fixed by
[1]. However, the same bug could come back to LAUNCH_START if RECEIVE_START
part was not fixed.

So add the sev_decommission() function in sev_receive_start.

[1] commit 934002cd660b ("KVM: SVM: Call SEV Guest Decommission if ASID
			 binding fails").

Cc: Alper Gun <alpergun@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: David Rienjes <rientjes@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vipin Sharma <vipinsh@google.com>

Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
Fixes: af43cbbf954b ("KVM: SVM: Add support for KVM_SEV_RECEIVE_START command")
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..55d8b9c933c3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1397,8 +1397,10 @@ static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Bind ASID to this guest */
 	ret = sev_bind_asid(kvm, start.handle, error);
-	if (ret)
+	if (ret) {
+		sev_decommission(start.handle);
 		goto e_free_session;
+	}
 
 	params.handle = start.handle;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
-- 
2.33.0.464.g1972c5931b-goog

