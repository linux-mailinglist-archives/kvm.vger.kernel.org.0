Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D449C34F6A4
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 04:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbhCaCbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 22:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhCaCae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 22:30:34 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0823AC061574
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 19:30:34 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id i7so311666qvh.22
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 19:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9ngxz5QAuEGilGZvxilVYqHe1BwKjT3flmnusOi2/fI=;
        b=LicNR0ZkoiCXiKVmO0Ds1YFkeaxDw5kP7hrokUUJ0H/UfOMARURimbTR8ystlpw3LE
         DTG2R/6GZcZWFnTEKaTKUSI+5X/+ZROOXtoGen04R9T9IrAtnHe5lgDOqRHfhAXtu6en
         gfysf/mhPrr+0dmQPfeCQdg0G41X4orl90ynZN7tF9L5WvGZDP5jJBIHlmflCjmQBWA4
         xT+MTcqVUXUtNm7ErI84r4YaLK752It8TaLMCpDBZ/LzWUrTqBJfoXPWmBx7R5koeZoo
         SVIXqGKmsNtjyJtU7BKhIkMEEfm90yy93p5gA5Or1bwgdk+G1pjY1I7iKZ3BPML9rNSm
         A2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9ngxz5QAuEGilGZvxilVYqHe1BwKjT3flmnusOi2/fI=;
        b=R0WxBzFyWWK0lwowX2rU35as/JF2udmPozxt2g8xJZu72iarrc5vA57YP8zgZoN/4k
         zAfb+S1fXeH256uw2n0aU3z0QT8ZcQp0SbnDK3/dlV5iVqFIaWi3y80cSBw00KvuvYmm
         VISfds23l39SnYyA1fSSIz9bxkC+6iFagYCvjs9C+sCJ/BNz+Jtwdn8/lXNmPgWNKWeE
         /FR7KQYToYSJxy11s6NPXd34CLbVVLxb7TY5c89pSszAGmObr0auNrxnc6buOFegVyR2
         js3p1lvEd10Jp107w5V1/Y6l1H5sz+bxtfYPKIOhXbwZaKUe6fonXVBLwGlF+PF7Ffqz
         ic+Q==
X-Gm-Message-State: AOAM531gILT92C/H9mTnQkKB/BJS8StMypCfF/XfDEhfRKPLP33HUjby
        LSBInMVsAFQxTAkqqqItZf64qUkZgJA=
X-Google-Smtp-Source: ABdhPJzuedRPX2SVO40eFzTyVbFitDzVxdBK989CVi+aohDw/Pi7chg4NgBOrFfsM8w4yFLDCK0+NvuKbzg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c6b:5d63:9b3b:4a77])
 (user=seanjc job=sendgmr) by 2002:a0c:f092:: with SMTP id g18mr930054qvk.11.1617157833106;
 Tue, 30 Mar 2021 19:30:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Mar 2021 19:30:25 -0700
In-Reply-To: <20210331023025.2485960-1-seanjc@google.com>
Message-Id: <20210331023025.2485960-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210331023025.2485960-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 2/2] KVM: x86: Account a variety of miscellaneous allocations
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Switch to GFP_KERNEL_ACCOUNT for a handful of allocations that are
clearly associated with a single task/VM.

Note, there are a several SEV allocations that aren't accounted, but
those can (hopefully) be fixed by using the local stack for memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/nested.c | 4 ++--
 arch/x86/kvm/svm/sev.c    | 6 +++---
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 8523f60adb92..4f9e8b80ef99 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1234,8 +1234,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	ret  = -ENOMEM;
-	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL);
-	save = kzalloc(sizeof(*save), GFP_KERNEL);
+	ctl  = kzalloc(sizeof(*ctl),  GFP_KERNEL_ACCOUNT);
+	save = kzalloc(sizeof(*save), GFP_KERNEL_ACCOUNT);
 	if (!ctl || !save)
 		goto out_free;
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 83e00e524513..883ce6bf23b9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -637,7 +637,7 @@ static int sev_launch_measure(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		}
 
 		ret = -ENOMEM;
-		blob = kmalloc(params.len, GFP_KERNEL);
+		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			goto e_free;
 
@@ -1074,7 +1074,7 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		}
 
 		ret = -ENOMEM;
-		blob = kmalloc(params.len, GFP_KERNEL);
+		blob = kmalloc(params.len, GFP_KERNEL_ACCOUNT);
 		if (!blob)
 			goto e_free;
 
@@ -1775,7 +1775,7 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       len, GHCB_SCRATCH_AREA_LIMIT);
 			return false;
 		}
-		scratch_va = kzalloc(len, GFP_KERNEL);
+		scratch_va = kzalloc(len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
 			return false;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c8a4a548e96b..5ab25376d718 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -562,7 +562,7 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 	 * evmcs in singe VM shares same assist page.
 	 */
 	if (!*p_hv_pa_pg)
-		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL);
+		*p_hv_pa_pg = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
 
 	if (!*p_hv_pa_pg)
 		return -ENOMEM;
-- 
2.31.0.291.g576ba9dcdaf-goog

