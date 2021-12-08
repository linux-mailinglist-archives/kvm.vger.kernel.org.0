Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8ED146CA5B
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243225AbhLHB6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243208AbhLHB6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:58:20 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C47C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:54:49 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 66-20020a630545000000b0032e4e898d24so437335pgf.10
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:54:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=t+Ei0itOPUqCS4bP4MpGZr4Y0AKiyZYQUO3shvC6OH4=;
        b=k2YwbuxAPGemjRBHL7uFYlBdoruRLQIFroSCqiVqW7M9ZBvnUQQ9jGvvoRM5wp50BU
         zIgGQ7HGQFBmuNg7A+QIp+NCeTdN/K7rIpyetOEYv0fFftMX25G2HHMkN4qtIQ0LfZMv
         nEZ0SJpr3uyAnIWFfnfoFOuoynn+5sugfYnXc8Zu5xGttDxjBfbR1pzNtBX3wmGo5Eh4
         tc+DrZgmJZQlP0JmnQUhMMdwg4C1ob1gWVBL3GTQuYBEqUYWxacTaSRVkDaRkCGPvyNC
         fBrkeiQfSYOSRFEFYUtRYvG8vJlWJMCUTEIGnMXeL5T96k3SQN4J7z95j0CLBBRC0fn1
         ygmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=t+Ei0itOPUqCS4bP4MpGZr4Y0AKiyZYQUO3shvC6OH4=;
        b=KdPTREYeUSEB6e2bwughnCkPx7JZ/YW1PX3N53Q5rfhoFUIqPRHqsIyBomsLSy2O2y
         HZJ7lryL7NhSt1gdNLzcXvTpeYY82CaLnexBjxnZ1x29N1nz2ywxExljoIgCCKGLtCWx
         eMpvg1/CHfK67+xJ4t7FgDVv8cBDNc/xgoC3GI+VXY7TPGEYh36lIsNdWDTjOXwPeq69
         M9Y4MYwjOBvID/qjt/XKPMX3HHY4NjJs8Xca9wIJzoprm2GsqtFpScTlOrkFTnmeswpc
         jI5SCgjOP9DJ/7Tq/YYHGhYjBg5qY0Ew3e7Tbp3E+zyjdanWhe8pOVm8JETv9jRebzZU
         zcxw==
X-Gm-Message-State: AOAM530koU+WRctJb1sWLboyBA1iHTa9nhDmRE359SgfpUKnsPPDoI0K
        x7HxMR0zBaRE72nzHmuxhOOWV4xRpC8=
X-Google-Smtp-Source: ABdhPJydNGMZpFjjQ57G1ZC66ywbHz44PKREG9EyVwHjLHfG2SNsZYM0b6sqBp1lD+CDQVcAS7e/s6aPdYs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1486:: with SMTP id
 js6mr342701pjb.0.1638928488764; Tue, 07 Dec 2021 17:54:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:11 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 01/26] KVM: fix avic_set_running for preemptable kernels
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

avic_set_running() passes the current CPU to avic_vcpu_load(), albeit
via vcpu->cpu rather than smp_processor_id().  If the thread is migrated
while avic_set_running runs, the call to avic_vcpu_load() can use a stale
value for the processor id.  Avoid this by blocking preemption over the
entire execution of avic_set_running().

Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1d8ada5b01f8..d7132a4551a2 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -997,16 +997,18 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	int cpu = get_cpu();
 
+	WARN_ON(cpu != vcpu->cpu);
 	svm->avic_is_running = is_run;
 
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
-	if (is_run)
-		avic_vcpu_load(vcpu, vcpu->cpu);
-	else
-		avic_vcpu_put(vcpu);
+	if (kvm_vcpu_apicv_active(vcpu)) {
+		if (is_run)
+			avic_vcpu_load(vcpu, cpu);
+		else
+			avic_vcpu_put(vcpu);
+	}
+	put_cpu();
 }
 
 void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
-- 
2.34.1.400.ga245620fadb-goog

