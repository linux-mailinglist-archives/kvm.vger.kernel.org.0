Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B07132B594
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380658AbhCCHSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581630AbhCBTA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 14:00:59 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3749C061A28
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 10:46:11 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i2so23705022ybl.16
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UoSJXw/PVEOjBFScqgNo0bQzSNuTFSWEQtCbZglmTq0=;
        b=lwgXT6FI8+/1UT8FGrjiTavPAr0JKYB0UWbkjGqt7EyPK3rhZ6rAiI6lBmAT7WA898
         e0BEX/4xziKzMBSqkmjDozDuK5WnSHbDOG+eR8mInErGT+TbXD4at9EZnRInk/6rb9Cj
         BoWKjo0tzn+DwYSsG3imVzuTgoRlC9M73YKnNUSMR+8Dj0WsiVXdxUzAj8myq/vzRXr1
         dlkurnV+eEAgGbSZqtYSHfu24HYZ4G8kXJNHvvkHlFaVk9DfSsXczRU+W1HualcuLUee
         z8dBZsxRkZ8lBY3j721lFPn5lJZj3po3y/bOCrwt906AIJwZK7pyl4iQRnxw+/q2k0VD
         055w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UoSJXw/PVEOjBFScqgNo0bQzSNuTFSWEQtCbZglmTq0=;
        b=O3kDAwVZTyA/Uqyih1Y5yocLa8Aa0RV28q66E2lKommjI+wQtF3Ak8Kaij7KWhvlfs
         G7KHH0f0JiAD7Bt10XHk9GcNfo25pDiLjQ9agui2r1cW9ycpZ/l8Tfgqd11+kLUhFP3w
         VqEotCOlOKdPgza9PCW4MxqvJkd6EaD75jD6gUg70r6FkbOY+OoNKYYTV42TYf1vIGhc
         GgMBPc/gYTV7PacF6nqwQ/dL1LCgOGAIpJBUJjdbcn0oJnGqXQo+/hdraaiSutVMHqEv
         EL3eKO6RVqW45TaI7sg9D0n/ckCzom9PzbQ++JIftmboC3I2E6dzCHU7nFPU8Z6VPI7V
         7Ubw==
X-Gm-Message-State: AOAM531wIRKFDdmd5BTQQt62YEli/dyB2IJXFuPA7a1GG9Gdy9B46oWv
        215+n32YJfuw4JxZUYXIfYTpdrV3twA=
X-Google-Smtp-Source: ABdhPJxXp9gj3TQbYMpbnDiuJU1nyT2DyJMbSHnnOW+armBYCgjzJRMfMkf1ZDQJr9aOpisAIIbUxejbTis=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:805d:6324:3372:6183])
 (user=seanjc job=sendgmr) by 2002:a25:76c3:: with SMTP id r186mr33750361ybc.365.1614710770992;
 Tue, 02 Mar 2021 10:46:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Mar 2021 10:45:35 -0800
In-Reply-To: <20210302184540.2829328-1-seanjc@google.com>
Message-Id: <20210302184540.2829328-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210302184540.2829328-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 10/15] KVM: SVM: Don't strip the C-bit from CR2 on #PF interception
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

