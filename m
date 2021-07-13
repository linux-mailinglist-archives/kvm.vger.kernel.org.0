Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E788F3C74BC
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbhGMQhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbhGMQg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:36:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BFCC0613AB
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z64-20020a257e430000b0290550b1931c8dso27317018ybc.4
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BciuiwGJwso95cAjqjPQ+Wf7zIf6IuqrurDTOWbsptw=;
        b=K15tC7HDPTNvLb3YFMilynTbQJZ6O0e2OQH/a9z/1hQKLTNoG4NeQ1JhiahFrS7kqQ
         cBKoQgJwCMjP48NwpdespWi4BNVtl4/sj2FokKy/Ep3QkGdmMRT7m1ypoPBjdKPPqZdc
         2vhzrKqdFd4eTeWm7AItGiRY2rbZc8OC5Umv0R1jqhKwLK7eamLdU7iIE6mdeoK8giH6
         L8J8kU0ZUJMyVMRvCNYPIgmywqZELvjwtMv3fIt+8PCbentMMgdAE2ZA5sApIleNszOR
         HsCSv9K6CaDTY6mYi9faILfSIlI+iEmAvOChhkP8Hns3uvzYENdZagiGPI4hggmTS/ly
         bKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BciuiwGJwso95cAjqjPQ+Wf7zIf6IuqrurDTOWbsptw=;
        b=g5S2JlCbkl87nZnIBv3c/rt10y7pdwgdzqlEH7Sqh20W7yrIuKpIDGszfEAtdH/2fW
         HGYKnZQu/LrkLJ9+9DfB4jkgqVLwhGUgNHRfSnheGqrxavgzJ/CqbCd+sTdjPy8NFKWZ
         GBsHEceegeVssNHsF/FuzCmEG9VBO44Y6KITb5n5Z8dKGKW5VtoNMONEgVsiaseaPjH4
         uBW4j8SkfIQyeNyRDStS2VpF8HTg9h0OU1cixoxGxwQEW0yVbDnLNcln232NHEVW4afj
         yJKw/HGHn5kmVRXsOOUg7vzLctnG0FbplPBW8euTuw1hmrAyFLL3+51G4c3bqiDtyWVS
         e9KQ==
X-Gm-Message-State: AOAM5319Hj3jwd8U/8PEU30P18d3NEw5SSdOAXiSOHiEHSxdx8MPx8H+
        A75guoopuSV2TxhQrKIkLtAF1BnpYjU=
X-Google-Smtp-Source: ABdhPJyldDfff3SwBK+LS3MY+Ihjl7Hs/4K5Kegxr1rFTVMBEybaCSca4HJNGryM5LLVfjVZ49Kw78j4q5A=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:6c6:: with SMTP id 189mr6740215ybg.33.1626194042605;
 Tue, 13 Jul 2021 09:34:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:53 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-16-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 15/46] KVM: x86: Set BSP bit in reset BSP vCPU's APIC base
 by default
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

Set the BSP bit appropriately during local APIC "reset" instead of
relying on vendor code to clean up at a later point.  This is a step
towards consolidating the local APIC, VMX, and SVM xAPIC initialization
code.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index acb201d16b5e..0fb282b64c8f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2321,6 +2321,7 @@ EXPORT_SYMBOL_GPL(kvm_apic_update_apicv);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
+	u64 msr_val;
 	int i;
 
 	if (!apic)
@@ -2330,8 +2331,10 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
 	if (!init_event) {
-		kvm_lapic_set_base(vcpu, APIC_DEFAULT_PHYS_BASE |
-		                         MSR_IA32_APICBASE_ENABLE);
+		msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
+		if (kvm_vcpu_is_reset_bsp(vcpu))
+			msr_val |= MSR_IA32_APICBASE_BSP;
+		kvm_lapic_set_base(vcpu, msr_val);
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 	}
 	kvm_apic_set_version(apic->vcpu);
-- 
2.32.0.93.g670b81a890-goog

