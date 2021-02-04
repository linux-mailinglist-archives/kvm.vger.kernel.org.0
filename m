Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B54130E846
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhBDAGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbhBDACv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:02:51 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E117CC0617AB
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 16:01:40 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f127so1516277ybf.12
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 16:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=N+cVTlisb7HGeqiFkTgiq2oBYDM+4NRVXkhEzMWc8HU=;
        b=D+cDoX0CFeijjXjDOMKS1/GeQQ3JfQRkctlHnPNzFIcUiAlceE1gti5gMS5FO38S3f
         9TtpNy1ziIY1Nc9PS21csPZ30J0SZKK9Yya9/iVbpoVHvfswEEJjtYlpBlduh92Kkl3b
         s4aSt1mgSroQ1pjVc05K8Zs0GwG7EkORFwvePnzIwKPSX7RnnA9PZji9ZRxbt8Nip4KI
         FEeXaoYpxWBb7pmxh499IWlIpGE1IXJLIzaX/9pHaYSib4HzufoBViLQlQ2+c8nFsaJH
         +lpuABrinVTd1R69z49otzaoMR0Yx5Uj4s5uis+V9cLoXZPBHX8NkpTVrPDfbfLEarUi
         dS+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=N+cVTlisb7HGeqiFkTgiq2oBYDM+4NRVXkhEzMWc8HU=;
        b=EHy2HGARtZ0DgAjQjlUj4ptOX55f/zNAjXtI8RmuyceTQ3IBSs4MPNBNRuajTyIdwh
         PymUC4XDHYeemhCQLfHPw6aeS9jDgF1v/axtdLpv5uKTGGR6Y702jKQFpbMEliM/hIT9
         VQ4i4VZ5cXOEVI9j60IGcwRdKcTaExrHQa1TOTsF3kzE8E8XuPS896d0yXaBAvCeM2r3
         y4jADHydZVoIHjlrbQ1p52H1tKwqKLEVRuu9iWzPW0H4pqQ3ZQCojQNumPcGRDU11wZg
         u/R26+gRibnvkfQQEAgsRWfV3ZrMwtaxQKSCTLCm9vHlIXiOaYr5q6SGtM5aDeQy4QGN
         vRJw==
X-Gm-Message-State: AOAM533pCjNgz7d4ABRkzr0IR20gL4G0NUqMl7pzeoN+2tB8tSDQGPWU
        6jJIoXIHmR3Ux4JfBEkX3png9E4vCB4=
X-Google-Smtp-Source: ABdhPJzqnVf4CSigFEmz3ocNKb2F5pHtFZSP7dI3TSolRfUl2/D+j8ACOtft1vwnRzJ823gt3rhJYe2+AGA=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
 (user=seanjc job=sendgmr) by 2002:a25:bbc1:: with SMTP id c1mr7996046ybk.130.1612396900135;
 Wed, 03 Feb 2021 16:01:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  3 Feb 2021 16:01:11 -0800
In-Reply-To: <20210204000117.3303214-1-seanjc@google.com>
Message-Id: <20210204000117.3303214-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210204000117.3303214-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 06/12] KVM: nSVM: Use common GPA helper to check for illegal CR3
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace an open coded check for an invalid CR3 with its equivalent
helper.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 70c72fe61e02..ac662964cee5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -367,7 +367,7 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			       bool nested_npt)
 {
-	if (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63))
+	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
 		return -EINVAL;
 
 	if (!nested_npt && is_pae_paging(vcpu) &&
-- 
2.30.0.365.g02bc693789-goog

