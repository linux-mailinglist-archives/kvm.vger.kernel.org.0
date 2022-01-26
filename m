Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CE849D0A3
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 18:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243632AbiAZRWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 12:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243646AbiAZRWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 12:22:34 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ABBC061747
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:22:34 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u24-20020a656718000000b0035e911d79edso34063pgf.1
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 09:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ff0gIIVT5mkOusZfHSkDsjrfQJ504HRuYB+DqdCYRzo=;
        b=sTzD25hboOP7p75R02/TLTWw//Il8gFhJL7Vz+HbfZ87lxCmYMp5oWAU6axG+RVQ87
         /CN2IwWa3VZk5ZmAvYeQjN+DmbdtnvL3gfxHeRuC+xKv4sZHQeyerJZLW2ixNDdsORPf
         bMTiRLh2vPc0I3b64auOVBcwuVbX8BkpMMDfa3hA/IkVPPgt9RhHsXuRN7yx3ZyrHuxf
         CM3pngA/s3TeL/XmM+EItNhSUW0hA0xfcuiglqxqyenTXNtuxCqo4Sy8ym9s2Gw76isb
         6n8uR62WCmVky2WU/cShi8umiIBPimr9+6k1+Dz4qbidJV3jD+ug2VtH9SpRzrbd+vZe
         Dktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ff0gIIVT5mkOusZfHSkDsjrfQJ504HRuYB+DqdCYRzo=;
        b=T/hJ1roAYAUpqQjXAGuzm+Y8nK8lbgZi+v/9/UoqDlaKC1N+F2CrChwhdypPjZzS/l
         9X4UIv46p990PoQauWsmJ2bWgFmec6QDXIRA9Gcp06AXNcaaV9pmH+i7pNNd6SgFHFIE
         Tgvf7aV/LD48FqamPFglTo/6QXKlYVIRimWhP9eQHkuN3d9bc0op/HCbuUKGFnMyqZzL
         JNXpVOWn8JA1YcjTqlHORv/ZP6FlNzL8MVORxlwRImIdY8cXxR/Zhu0EZVgSh/RSRM6W
         Hwx+Qu8eas3HuF7WwuWZ20SjonoWrGWCPMYRRReas3ej2n2lkGROER7+iJYG4CcqMQAN
         fN6w==
X-Gm-Message-State: AOAM531uubNqe26LZOlABh747pqWzX/Apnm4LxC5UpUW81NR1D43ElW+
        auX65ufLPTwFbxhICyHr9mxsLNwSphk=
X-Google-Smtp-Source: ABdhPJykFRaRlXBaojklngrMWzzMi+AE/Ri/f9JoeyGhR1SzYF9FA8YbNxzu1MkcoaS3qIkqNFc8hZ2rAs0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:7110:: with SMTP id m16mr19433809pgc.123.1643217753999;
 Wed, 26 Jan 2022 09:22:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 26 Jan 2022 17:22:26 +0000
In-Reply-To: <20220126172226.2298529-1-seanjc@google.com>
Message-Id: <20220126172226.2298529-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220126172226.2298529-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 3/3] KVM: x86: Sync the states size with the XCR0/IA32_XSS at,
 any time
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

XCR0 is reset to 1 by RESET but not INIT and IA32_XSS is zeroed by
both RESET and INIT. The kvm_set_msr_common()'s handling of MSR_IA32_XSS
also needs to update kvm_update_cpuid_runtime(). In the above cases, the
size in bytes of the XSAVE area containing all states enabled by XCR0 or
(XCRO | IA32_XSS) needs to be updated.

For simplicity and consistency, existing helpers are used to write values
and call kvm_update_cpuid_runtime(), and it's not exactly a fast path.

Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
Cc: stable@vger.kernel.org
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13793582f26d..2e8a8fb42269 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11257,8 +11257,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 		vcpu->arch.msr_misc_features_enables = 0;
 
-		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
-		vcpu->arch.ia32_xss = 0;
+		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
+		__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
 	}
 
 	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
-- 
2.35.0.rc0.227.g00780c9af4-goog

