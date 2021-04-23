Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036D9369CD0
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 00:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244114AbhDWWfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 18:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244006AbhDWWe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 18:34:58 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B2EC06138D
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 15:34:16 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h22-20020a05620a13f6b02902e3e9aad4bdso11380304qkl.14
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 15:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3FZQgk34SCAEH/5Yfdg9zYeevM/f3oDzvK0CNaN8pUI=;
        b=JtoysbVW5puihHQaqaRHim3A+fvT9gM3bW0Yh1fW5gu9UayVB92Z7sJ6NmSn4oS6K/
         q2U0dwecaNAfvVAIHR0jfyntDPgAoA57qWEEOVNWRXPo55/oN/W5s04QwRFj8aog1hQQ
         ObDP/mDZdYnQaSZis9jLlSbfHN3Wrk9fxh0sVbuCEHuUbE8a/k4oi6GkJ335XH93dmjj
         k37roNT+RzRenabv+x6zqJxERbPIpCmy08N5qY+3Gr/NqRN9DKdUY8UJEh4a7RBBJLmy
         C4lpwQBiQYjRgZ7ZMtDXMA/fHKGmWKsILCPlHB+XSivd6xX+ouH7XbgIQhBdZdPOaExL
         7PLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3FZQgk34SCAEH/5Yfdg9zYeevM/f3oDzvK0CNaN8pUI=;
        b=NLwSjltg8D84Ax2k2ghgOcnUPZdAR02E8UkdII48KdXadzMJPju/AOB6JQJl3aPTZV
         bx/5QCviLWnmmusN4GDttfL8DPWj7dxLxuaVMpm8p4Oo9Ja+i7M61+px+C/kt3bgkETQ
         zO70HNQZYK1Ff6hGiuelSh27OgFPBynLYVP62yCshwzxi17yodc0ivDWXITvkFqsozrI
         HA8T1SmgekiloEoGdimB3qK4Qb23y0MBg7ezuC3iXdCkB/q9xjCX3XoEmRmfcKpbRkVO
         dS7pXPb/cxgnuld7i6VrNsEkaFtrRFgNGojEnRsWf10YHvC8/iBMSNQ/GyL9wX716HmU
         4AvA==
X-Gm-Message-State: AOAM532tGpoMO7YgPtKUlqBPwedeft6ncxJtmTtGPor5q1/fVAxIigRe
        pyHOj8CrMMd9BJJO0HUu8jFnQqHvRBw=
X-Google-Smtp-Source: ABdhPJxACcZTceTA892PPr06aY0ZOa8IzN92MHMftjtUJzrnZ7FTZWV9phOU2atke0Mj1TIigGfMfGqFS2E=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a0c:e6c5:: with SMTP id l5mr6901795qvn.2.1619217255239;
 Fri, 23 Apr 2021 15:34:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 15:34:02 -0700
In-Reply-To: <20210423223404.3860547-1-seanjc@google.com>
Message-Id: <20210423223404.3860547-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210423223404.3860547-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v3 2/4] KVM: SVM: Clear MSR_TSC_AUX[63:32] on write
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Force clear bits 63:32 of MSR_TSC_AUX on write to emulate current AMD
CPUs, which completely ignore the upper 32 bits, including dropping them
on write.  Emulating AMD hardware will also allow migrating a vCPU from
AMD hardware to Intel hardware without requiring userspace to manually
clear the upper bits, which are reserved on Intel hardware.

Presumably, MSR_TSC_AUX[63:32] are intended to be reserved on AMD, but
sadly the APM doesn't say _anything_ about those bits in the context of
MSR access.  The RDTSCP entry simply states that RCX contains bits 31:0
of the MSR, zero extended.  And even worse is that the RDPID description
implies that it can consume all 64 bits of the MSR:

  RDPID reads the value of TSC_AUX MSR used by the RDTSCP instruction
  into the specified destination register. Normal operand size prefixes
  do not apply and the update is either 32 bit or 64 bit based on the
  current mode.

Emulate current hardware behavior to give KVM the best odds of playing
nice with whatever the behavior of future AMD CPUs happens to be.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9ed9c7bd7cfd..71d704f8d569 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2904,8 +2904,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * direct_access_msrs.  Doing that would require a rdmsr in
 		 * svm_vcpu_put.
 		 */
-		svm->tsc_aux = data;
 		wrmsrl(MSR_TSC_AUX, svm->tsc_aux);
+
+		/*
+		 * Per Intel's SDM, bits 63:32 are reserved, but AMD's APM has
+		 * incomplete and conflicting architectural behavior.  Current
+		 * AMD CPUs completely ignore bits 63:32, i.e. they aren't
+		 * reserved and always read as zeros.  Emulate AMD CPU behavior
+		 * to avoid explosions if the vCPU is migrated from an AMD host
+		 * to an Intel host.
+		 */
+		svm->tsc_aux = (u32)data;
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!boot_cpu_has(X86_FEATURE_LBRV)) {
-- 
2.31.1.498.g6c1eba8ee3d-goog

