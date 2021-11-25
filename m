Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659B645D2F6
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 03:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236117AbhKYCNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbhKYCNL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 21:13:11 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC12C0698D7
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:49:52 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id q82-20020a627555000000b004a4f8cadb6fso2565410pfc.20
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=pxR1NPHuzRsrzxrqk2JiOjLQ1DwZgeXTpOJUqyHl/6A=;
        b=rSBoDxu1CW93c7R6xJJRfcuRY078jGLz4wFBtqM+zyfp65HEi9ztAQrKnVsOH4kUV2
         R5Dm7EgrY+/mi9ssk/lGFsS8+j6hEbZ6/M9z1N33izQVxIYxgg54Z7hNkI6oPKdaYKYH
         URPpcnrXKMol6M3hOV6Nf+fj/HiglfEt050rt9/h/dNWtydN7zUaHsaEl3mbCA9YwWOt
         dPe0toi9LEpKA8GpjB9E/QXHkNNWLGRe7zLijTwqFalNQRFngDuywMocIJ2+LdlP8Dud
         RuGkTKsBUMsI/zZQl4pqlJYwexR2oYQAqqWJVA9F3fEQ3Q4KHApcG5rFY+EoDdDhb58R
         QU9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=pxR1NPHuzRsrzxrqk2JiOjLQ1DwZgeXTpOJUqyHl/6A=;
        b=1EWxPq0FA9UxRerdxtobrVzuoHb5nGOCDafypWULLmHpFmziC+25qAeelHITc79f/K
         RVocXG4xGHCEs20gS9XzHT9fC2l/gjLUxYjnplxRXoHFJhqeCrrN6V5ovxPTjnAg7uLa
         xLla/DT1Q+9bCT6CNrlo+f1x/zBkA9VtmmmfTrtu2HlGhS9+k3R7LV6wn268ZvYJpJR6
         1Xmlo5bm3HyjJr/imFP3ZqNXRS8T41G2Kgm/qO1SxuRRgYD3jJVd7foupEDsqTWPE01O
         Ks11WSyYDt+FQ6c5JWFZw6BYXX1nYQ+LE6MJExFFCNjBevkfeWVyCxkwuK1W3YvpNvJc
         jpuw==
X-Gm-Message-State: AOAM531C1eNv8tYgK8LdjLXHCku6adWXg/r6XGrGibeSy4/gBQg637+x
        ALlrBAFaqVaXl8os5LyP/dOwviCqOsU=
X-Google-Smtp-Source: ABdhPJxqCKMdDjiz9nRFieKO+Z5+ZKjQxR7J5i2ChEtGh0fTtZksT9j1/QVz/G9W6693lvym+0RucwnfVXw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr455456pjf.1.1637804991895; Wed, 24 Nov 2021 17:49:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:49:44 +0000
In-Reply-To: <20211125014944.536398-1-seanjc@google.com>
Message-Id: <20211125014944.536398-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211125014944.536398-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 2/2] KVM: nVMX: Emulate guest TLB flush on nested VM-Enter
 with new vpid12
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fully emulate a guest TLB flush on nested VM-Enter which changes vpid12,
i.e. L2's VPID, instead of simply doing INVVPID to flush real hardware's
TLB entries for vpid02.  From L1's perspective, changing L2's VPID is
effectively a TLB flush unless "hardware" has previously cached entries
for the new vpid12.  Because KVM tracks only a single vpid12, KVM doesn't
know if the new vpid12 has been used in the past and so must treat it as
a brand new, never been used VPID, i.e. must assume that the new vpid12
represents a TLB flush from L1's perspective.

For example, if L1 and L2 share a CR3, the first VM-Enter to L2 (with a
VPID) is effectively a TLB flush as hardware/KVM has never seen vpid12
and thus can't have cached entries in the TLB for vpid12.

Reported-by: Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Fixes: 5c614b3583e7 ("KVM: nVMX: nested VPID emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2ef1d5562a54..dafe5881ae51 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1162,29 +1162,26 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 	WARN_ON(!enable_vpid);
 
 	/*
-	 * If VPID is enabled and used by vmc12, but L2 does not have a unique
-	 * TLB tag (ASID), i.e. EPT is disabled and KVM was unable to allocate
-	 * a VPID for L2, flush the current context as the effective ASID is
-	 * common to both L1 and L2.
-	 *
-	 * Defer the flush so that it runs after vmcs02.EPTP has been set by
-	 * KVM_REQ_LOAD_MMU_PGD (if nested EPT is enabled) and to avoid
-	 * redundant flushes further down the nested pipeline.
-	 *
-	 * If a TLB flush isn't required due to any of the above, and vpid12 is
-	 * changing then the new "virtual" VPID (vpid12) will reuse the same
-	 * "real" VPID (vpid02), and so needs to be flushed.  There's no direct
-	 * mapping between vpid02 and vpid12, vpid02 is per-vCPU and reused for
-	 * all nested vCPUs.  Remember, a flush on VM-Enter does not invalidate
-	 * guest-physical mappings, so there is no need to sync the nEPT MMU.
+	 * VPID is enabled and in use by vmcs12.  If vpid12 is changing, then
+	 * emulate a guest TLB flush as KVM does not track vpid12 history nor
+	 * is the VPID incorporated into the MMU context.  I.e. KVM must assume
+	 * that the new vpid12 has never been used and thus represents a new
+	 * guest ASID that cannot have entries in the TLB.
 	 */
-	if (!nested_has_guest_tlb_tag(vcpu)) {
-		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-	} else if (is_vmenter &&
-		   vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
+	if (is_vmenter && vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
 		vmx->nested.last_vpid = vmcs12->virtual_processor_id;
-		vpid_sync_context(nested_get_vpid02(vcpu));
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+		return;
 	}
+
+	/*
+	 * If VPID is enabled, used by vmc12, and vpid12 is not changing but
+	 * does not have a unique TLB tag (ASID), i.e. EPT is disabled and
+	 * KVM was unable to allocate a VPID for L2, flush the current context
+	 * as the effective ASID is common to both L1 and L2.
+	 */
+	if (!nested_has_guest_tlb_tag(vcpu))
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
 }
 
 static bool is_bitwise_subset(u64 superset, u64 subset, u64 mask)
-- 
2.34.0.rc2.393.gf8c9666880-goog

