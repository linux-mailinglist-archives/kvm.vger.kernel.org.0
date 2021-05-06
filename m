Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384643759E5
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 19:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbhEFR7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 13:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbhEFR7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 13:59:36 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36167C06138B
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 10:58:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a7-20020a5b00070000b02904ed415d9d84so6893543ybp.0
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 10:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Sd8WEj+PgaScYsgfeqR/hc4kupQ0VU11JVPKLdE8YCo=;
        b=EmxT2XYM2BzbyxRgqdF5HDGKtLZiZcnPRSifrgtlrx+r/MjFEWoZwrmSGBBERXCvs4
         E4JIMwds8T6m90XBZR5l2O3QP443a+AwrHmBWyMelZNwrHPBAl4Hmh5arXGuu6h4J1iM
         Rm5uqjjM2FMI64lzQ6N2f/9WHBNjh93h4h4k4DibfmSfFvawbtvQyDP543alMfzc1l65
         QF0bR1KJkLfrjd2TDw/0QZoQEf/ivFATCQI0/H4KRAxBNoVMS6hfzZYBkan+rz9iTHXu
         ovAMVNxKFNOlQWJwAKpD9wVIqcG6DgkfK39Cr601qCjML5V5yXkXrWg8GZCB98h7feyr
         MUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Sd8WEj+PgaScYsgfeqR/hc4kupQ0VU11JVPKLdE8YCo=;
        b=ITDRq9C9R/SEEnqUxsWkvVza1TrFMZeCi77ezVblg2F6fZZaaFqghQtz0MlprNUcfG
         tf3e6vXShz9Zq+s+PJqImCEj6xlVosfQkj98AsgmZ58dm1NlcvR3x0MYFJIbSoXol2Xw
         WvnKU9uKvbw5VbmIvb61NSg89QKuOEB2K334+YDOAMM0XN1E6vA/I/yjDMSalTO53ZHr
         /hWBJrpuXKTZTXrzhaPQ5LnpLz9NbxPhyixj+noF+1UTw3BruSuuG/Shd+K2uwhkZBb3
         23cxDp6N/gL0+dTSz3c1bSDLhqgQGDf8jN73WWMBjDZjg3bn7KItItJi04R/BMWMw0lG
         uTFQ==
X-Gm-Message-State: AOAM533t+2pKiFK13xNuO8lmd/UgQHG3cpziwn0fSneETQADNTWrSJ4S
        fGhX9Oa44H7OVYwd3gVGLF16TdzFNq8=
X-Google-Smtp-Source: ABdhPJxC4+0lI0Mm3aAI52n+oh65A9gZczkK2o2BhouAnB7HbvxYpIa98mtba7ZNKqYNKGNKPSZi2lSApto=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:818d:5ca3:d49c:cfc8])
 (user=seanjc job=sendgmr) by 2002:a25:3496:: with SMTP id b144mr7152883yba.393.1620323915928;
 Thu, 06 May 2021 10:58:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 May 2021 10:58:26 -0700
In-Reply-To: <20210506175826.2166383-1-seanjc@google.com>
Message-Id: <20210506175826.2166383-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210506175826.2166383-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH 2/2] KVM: SVM: Fix sev_pin_memory() error checks in SEV
 migration utilities
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steve Rutherford <srutherford@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use IS_ERR() instead of checking for a NULL pointer when querying for
sev_pin_memory() failures.  sev_pin_memory() always returns an error code
cast to a pointer, or a valid pointer; it never returns NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Steve Rutherford <srutherford@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Fixes: d3d1af85e2c7 ("KVM: SVM: Add KVM_SEND_UPDATE_DATA command")
Fixes: 15fb7de1a7f5 ("KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1f99c240db6d..9b23b7ac60fa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1265,8 +1265,8 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	/* Pin guest memory */
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
 				    PAGE_SIZE, &n, 0);
-	if (!guest_page)
-		return -EFAULT;
+	if (IS_ERR(guest_page))
+		return PTR_ERR(guest_page);
 
 	/* allocate memory for header and transport buffer */
 	ret = -ENOMEM;
@@ -1457,11 +1457,12 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	data.trans_len = params.trans_len;
 
 	/* Pin guest memory */
-	ret = -EFAULT;
 	guest_page = sev_pin_memory(kvm, params.guest_uaddr & PAGE_MASK,
 				    PAGE_SIZE, &n, 0);
-	if (!guest_page)
+	if (IS_ERR(guest_page)) {
+		ret = PTR_ERR(guest_page);
 		goto e_free_trans;
+	}
 
 	/* The RECEIVE_UPDATE_DATA command requires C-bit to be always set. */
 	data.guest_address = (page_to_pfn(guest_page[0]) << PAGE_SHIFT) + offset;
-- 
2.31.1.607.g51e8a6a459-goog

