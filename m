Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F59832F7A8
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 03:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhCFB7q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 20:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhCFB7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 20:59:39 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A902C06175F
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 17:59:39 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id u5so3333078qkj.10
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 17:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OHqfOWYkCtBzN8FXFwQA9R+6Q0DqqewYBBW3KPBwe5g=;
        b=psTJv1f4CywsTAdd1fIlRBcihS8Cb6AY4HTXVMmkFkPC+dkc95AzdwBIZl/XDlzbRL
         77kp0KaRC+aQGmlNhrI4BJH02PdohFffRpVbJKm7n16IYCt+qn36jaW6R3sIBhOuhfvE
         3XhwueVUjgszky1vUlcDppVQnHcid17Js+cKODxAvWJ+ej7GWtIRP+UFbtDIYWe0WkXi
         qZdB2gy3DtXPJgD/wGTM86rp4CPvTYzSegjJ6jjgrBu0xEkGSBeO/76vCM7DdB637xu5
         gwZDzWu7CvOh8vEQ93gigrsyk82XNXTjqNlaz34mjGqiHb8WBhT8SKg4YYhPbx/It1Jx
         Ig2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OHqfOWYkCtBzN8FXFwQA9R+6Q0DqqewYBBW3KPBwe5g=;
        b=WVY/DJklFleQh8yBdx9GCXEh+7It9CapQqqq1NNQGqeELSt5lYgD8snAgDT/BODR81
         QF/gh9sgOm6fUv8N7qG/TiAtNfYec9w0w2RX0oUqUQwMtYp0yu11UT43MELYKuSIxIu6
         kNDEF/o8PwkkU8dNF2iCGb++5Z55EatzAW2I9m0/drmvoQfPv9XHkmoEe72vklysl3jb
         C0qpdpuMsgWeTAlNGbi9SxhCmsHiZPY9whzBypG6MeCwb9gCyshLdXx7ayPzK9tQS87L
         naeVUvlo6q7SbKx2hxcRfn0BPH7w5RXyMi6wrQHhE34AuvJ8bBnGsRVduznlVloVH8ON
         tzzg==
X-Gm-Message-State: AOAM533aoftzDlPmOiCww/m5eR+S9UDb3Ez+j94q1ftMcQPkcYQjf/DL
        2akcJWj/z9n3mmJVLr+XMce+MjNbTz4=
X-Google-Smtp-Source: ABdhPJx6XFmYG+uUHqHxs2+LLpbrJnLDEFG6hnsswkkeGsrb0wG9EY9eJVdimEHgEbj4V/DWb4k4Awc+BRY=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:fc04:f9df:1efb:bf0c])
 (user=seanjc job=sendgmr) by 2002:ad4:5c4f:: with SMTP id a15mr11907990qva.41.1614995978243;
 Fri, 05 Mar 2021 17:59:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 17:59:00 -0800
In-Reply-To: <20210306015905.186698-1-seanjc@google.com>
Message-Id: <20210306015905.186698-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210306015905.186698-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 09/14] KVM: SVM: Unconditionally invoke sev_hardware_teardown()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the redundant svm_sev_enabled() check when calling
sev_hardware_teardown(), the teardown helper itself does the check.
Removing the check from svm.c will eventually allow dropping
svm_sev_enabled() entirely.

No functional change intended.

Reviewed by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6dd8bcf3e8fa..0fa6c409b484 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -883,8 +883,7 @@ static void svm_hardware_teardown(void)
 {
 	int cpu;
 
-	if (svm_sev_enabled())
-		sev_hardware_teardown();
+	sev_hardware_teardown();
 
 	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
-- 
2.30.1.766.gb4fecdf3b7-goog

