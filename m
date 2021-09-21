Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A959C412AF8
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 04:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241672AbhIUCCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 22:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238109AbhIUB5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 21:57:05 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E27DC06B677
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:22 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id bm12-20020a05620a198c00b00432e14ddb99so115763813qkb.21
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 17:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HhfaXw9z/CxbmlyXYi9gBhmKaFzn11YSxQIF4RXjlM4=;
        b=LwjyrO0FSh0POb0MRwne7/Fz6bEEqCoT5+N5fuHfwB+xGhlAYcenhsNw0PmeFZLrhe
         5LgEpAKBy9I9QyRdJaIcNrvhSKE1u5iX8OYIbQRLruJrvbgjB0G812aNeAoU2HP5nqU8
         y7032UsWR37dTJCX0ZEbaQHtte9GS0eYhC4CbrTndeGeTywBvsOeV+Qk0Cx+iSL6PV0z
         ud78JH7LjWrVHsHTj0LF3Bmqpgu2fVcK3D6ZdGs4jDgil1tXp0drfD4c5xLLDr7KEIko
         pangdFkPQpaF9BHDIZJZcboiy/Va2UgtwwtlQmAVwn4qzgmU7N7xoCR0SQBqMyyby4SO
         3kwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HhfaXw9z/CxbmlyXYi9gBhmKaFzn11YSxQIF4RXjlM4=;
        b=wPt2yhOwFp5m891MHFOr+MjPZX8vF55MMy46yprc1i+Nb1EZrkCMoa4lyhUL0+NOPe
         oUD75ka2kNexWcY1IfK/LIH6Wq9vT0+EnkAt0HLUNupvA5RNITlfsGOg1dxSSmsGkLPk
         8qLTNaMJ18F3+o6dcBp/1FgaZ+Cn+3G7uo9L3TBmu4KubcQGwHLwUjXG7fRnWP6Gorba
         hknvWkBZZuHleLAtWW9f0cQLB1nauzzNR3iNHGxuJAvWqNpDQggKr1sG+0RBhPS7kFrr
         mmWJa94/HBYY2Ml5jwRTNpJE9n67qaaREC10vdlqJUwUILBGgEaAeGPerYZpEhDSPrCg
         vcyA==
X-Gm-Message-State: AOAM531Z4vQH0CR9TfgTFvtyRIMx7fFu6hfaZSd+6ji8O4UEK1SZlHza
        9y588lRouBEv9z0O26nqvGL+qrwpaNs=
X-Google-Smtp-Source: ABdhPJwB1kYrwuR7IQh/d2Wtw8d6vL+DlZyZ7RcQ0EPSi88Ob2Shqp6uDMin0lBAko9PAKesq8AIgSi7bUg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e430:8766:b902:5ee3])
 (user=seanjc job=sendgmr) by 2002:a25:8409:: with SMTP id u9mr23902732ybk.159.1632182601287;
 Mon, 20 Sep 2021 17:03:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 20 Sep 2021 17:03:00 -0700
In-Reply-To: <20210921000303.400537-1-seanjc@google.com>
Message-Id: <20210921000303.400537-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210921000303.400537-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 07/10] KVM: VMX: Drop explicit zeroing of MSR guest values
 at vCPU creation
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

Don't zero out user return and nested MSRs during vCPU creation, and
instead rely on vcpu_vmx being zero-allocated.  Explicitly zeroing MSRs
is not wrong, and is in fact necessary if KVM ever emulates vCPU RESET
outside of vCPU creation, but zeroing only a subset of MSRs is confusing.

Poking directly into KVM's backing is also undesirable in that it doesn't
scale and is error prone.  Ideally KVM would have a common RESET path for
all MSRs, e.g. by expanding kvm_set_msr(), which would obviate the need
for this out-of-bad code (to support standalone RESET).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d44d07d5a02f..8d14066db3ea 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6819,10 +6819,8 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vpid;
 	}
 
-	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
-		vmx->guest_uret_msrs[i].data = 0;
+	for (i = 0; i < kvm_nr_uret_msrs; ++i)
 		vmx->guest_uret_msrs[i].mask = -1ull;
-	}
 	if (boot_cpu_has(X86_FEATURE_RTM)) {
 		/*
 		 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID interception.
@@ -6879,8 +6877,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 	if (nested)
 		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
-	else
-		memset(&vmx->nested.msrs, 0, sizeof(vmx->nested.msrs));
 
 	vcpu_setup_sgx_lepubkeyhash(vcpu);
 
-- 
2.33.0.464.g1972c5931b-goog

