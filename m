Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA8149BE2E
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 23:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiAYWFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 17:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233479AbiAYWFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 17:05:30 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88166C061744
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 14:05:30 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id f24-20020aa782d8000000b004bc00caa4c0so11915481pfn.3
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 14:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=zFvD99a+0UYYYZFGctLqwYUZu5wqmjlcInK/gfPu+kw=;
        b=tZ3RyPvLp+yQu7ggIjFujQOHza+OHLu10PEEFCEE/qcX/Wz2n3Fue5+KjYpTYlzgBN
         lrJbDH2cP1v3KOcSrxzpakbqLfLgOHl4cuNzgPPQ/HLPhnoenUhZr62H2l325+eCqI+W
         W/3YmD2J5LjeUWrOVaTwcI6RMwT7iVTsbNrDrXfvl/7hPENaKC8MOm9mU2k9a2Fv3qNB
         1CN4AOHtzT1kRCGpEjCI25ghas4A7oHiNEccE5MDNRT3OtrvCXJjXVJG3pX6XoilWow0
         4ZeDh6JS+EQFQlPWMXVlhMHOVYFqlzxtJNvWdR6d8a6QEcAPNhCOC+cv+J4YPhp6c1rH
         N35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=zFvD99a+0UYYYZFGctLqwYUZu5wqmjlcInK/gfPu+kw=;
        b=jJ9G4za4lpDrWbr++Vd1S3AgWDT8/WmjtVsHMTt3p+60+ufWPdIb7LGNwrFC0bcY1Q
         +AlNFF/3Sf0Xz2uwdsoN9MQzTsqKuablu9QwZ1rD5mN85Jpf9ucHivfc3uj/JI8NjV5R
         FsxmnLCvxz3znM+cZfqmR5OfWPRTk43HSrtTEL6QezkvwTyDIFRHWgJTpU1vj88kBU8S
         O1ZaJ9rzngONljXHG0TlRZCaGSoRIrAYeBtobeF28KZkjSgRFGBzLpzf8fii9bNbsI5J
         lxcjN0uRR/+4VoXkQdtgFC+xyU2UFi45h4tF5bamQ85X7ca7d0A+4+dxUopChWPm1AWF
         Lc1Q==
X-Gm-Message-State: AOAM531EKpxU5R6W72LpN5EAPZlDmuAYlNSvx6gcNj1gYWR7Jh7le4ju
        1ObJndtad0AHOPioAIFzvTR/QfYci3E=
X-Google-Smtp-Source: ABdhPJyp7+H5Jz4qhhqYLMqFDK07gcfEhDkwe5YapLZxHLSq2w6S042kg0pHg9Cw0oHsLijlkCixsGvU5Pc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fe2:: with SMTP id
 89mr5571847pjz.162.1643148330022; Tue, 25 Jan 2022 14:05:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 25 Jan 2022 22:05:27 +0000
Message-Id: <20220125220527.2093146-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH] KVM: nVMX: WARN on any attempt to allocate shadow VMCS for vmcs02
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

WARN if KVM attempts to allocate a shadow VMCS for vmcs02.  KVM emulates
VMCS shadowing but doesn't virtualize it, i.e. KVM should never allocate
a "real" shadow VMCS for L2.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f235f77cbc03..92ee0d821a06 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4851,18 +4851,20 @@ static struct vmcs *alloc_shadow_vmcs(struct kvm_vcpu *vcpu)
 	struct loaded_vmcs *loaded_vmcs = vmx->loaded_vmcs;
 
 	/*
-	 * We should allocate a shadow vmcs for vmcs01 only when L1
-	 * executes VMXON and free it when L1 executes VMXOFF.
-	 * As it is invalid to execute VMXON twice, we shouldn't reach
-	 * here when vmcs01 already have an allocated shadow vmcs.
+	 * KVM allocates a shadow VMCS only when L1 executes VMXON and frees it
+	 * when L1 executes VMXOFF or the vCPU is forced out of nested
+	 * operation.  VMXON faults if the CPU is already post-VMXON, so it
+	 * should be impossible to already have an allocated shadow VMCS.  KVM
+	 * doesn't support virtualization of VMCS shadowing, so vmcs01 should
+	 * always be the loaded VMCS.
 	 */
-	WARN_ON(loaded_vmcs == &vmx->vmcs01 && loaded_vmcs->shadow_vmcs);
+	if (WARN_ON(loaded_vmcs != &vmx->vmcs01 || loaded_vmcs->shadow_vmcs))
+		return loaded_vmcs->shadow_vmcs;
+
+	loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
+	if (loaded_vmcs->shadow_vmcs)
+		vmcs_clear(loaded_vmcs->shadow_vmcs);
 
-	if (!loaded_vmcs->shadow_vmcs) {
-		loaded_vmcs->shadow_vmcs = alloc_vmcs(true);
-		if (loaded_vmcs->shadow_vmcs)
-			vmcs_clear(loaded_vmcs->shadow_vmcs);
-	}
 	return loaded_vmcs->shadow_vmcs;
 }
 

base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33
-- 
2.35.0.rc0.227.g00780c9af4-goog

