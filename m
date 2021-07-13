Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F743C74FC
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbhGMQjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbhGMQiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD26C05BD3D
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:35:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l16-20020a25cc100000b0290558245b7eabso27776273ybf.10
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2rxcC4vIuxY5YCnXRcrldky6aRxCM98WRgaPiN4Y0rs=;
        b=eyv4YFSBvRhlJkYZ4guHD6EoCspFxgLX9Taq/OJ/Zs1/OeCzPSXj58SmF1tJfheNPQ
         FaPADp2ER+YkXFwezeosrFHo5tmarn8ns12RB/5m/73NFJWy5Ww98gIkk84AzOl1O1wE
         rTHUBkUPUmDZtEEPm2x1r+kq62dMjUKtd1cbZIWNMZwsXZqzS1wa3P3fLRnmKv3f1oY4
         edCTgdIBfuTKTtUSC2MiWXVOWpWGtQxMhBQOkd2BdN+laE4PzbcnubXP2vU+ZZInHx/g
         gskZ//sHZVEEkZN1yQ4/+vcL2LhkQKVTBruvwCId633vdzOgO3AoVDUvDgwbXBvv2gSM
         L+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2rxcC4vIuxY5YCnXRcrldky6aRxCM98WRgaPiN4Y0rs=;
        b=hEkWUt3clXL9lMCYAV+ICqpPJWJ0pEqRAgRY7nhde1j8DVOSb4gN4yXJH0/6TfOrBf
         STw6dnD8HofqVulgSptDFpnnBaeUqQ+H3uwA62GCGwSAGM6dIrosEkEEnU30dZWKUjH8
         GejS9y29GEApcVx5mIwU0xDFltw4OPjVe45fvYQCfay/cm9BEsx51SywM9SarGQM74wF
         YWIxtS/f1azhCxD3xJbnlGEcstBcCEQZmLGCe1s0FCNX3m7EPI0E8I69zKkE043Qk2Ho
         YlPKdNGtfEhFoJPpPdS5Sn7yPFyWM1M+LFTQCq/KdmqFXkCZTq5S4Qn2J71FB3tHoB15
         Gbwg==
X-Gm-Message-State: AOAM533ItIJk8Wj1fDfsS+2zjrGGsP2ZOtfoRwoHFuc6urREmfid+XZH
        5WXPPg6Oj2hqL4o36X7Qj0xa2wDjYsg=
X-Google-Smtp-Source: ABdhPJym3PBNjITgxPhnZwVrT14qQ1Y9+05uaLxuS6+kIvCIhq8Vjgfa7U6VT4khAaNQwcvT17uHumvZviM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:ac8f:: with SMTP id x15mr7405404ybi.36.1626194103477;
 Tue, 13 Jul 2021 09:35:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:24 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-47-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 46/46] KVM: x86: Preserve guest's CR0.CD/NW on INIT
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

Preserve CR0.CD and CR0.NW on INIT instead of forcing them to '1', as
defined by both Intel's SDM and AMD's APM.

Note, current versions of Intel's SDM are very poorly written with
respect to INIT behavior.  Table 9-1. "IA-32 and Intel 64 Processor
States Following Power-up, Reset, or INIT" quite clearly lists power-up,
RESET, _and_ INIT as setting CR0=60000010H, i.e. CD/NW=1.  But the SDM
then attempts to qualify CD/NW behavior in a footnote:

  2. The CD and NW flags are unchanged, bit 4 is set to 1, all other bits
     are cleared.

Presumably that footnote is only meant for INIT, as the RESET case and
especially the power-up case are rather non-sensical.  Another footnote
all but confirms that:

  6. Internal caches are invalid after power-up and RESET, but left
     unchanged with an INIT.

Bare metal testing shows that CD/NW are indeed preserved on INIT (someone
else can hack their BIOS to check RESET and power-up :-D).

Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f35dd8192c32..3f0226259496 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10787,6 +10787,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
+	unsigned long new_cr0;
 	u32 eax, dummy;
 
 	kvm_lapic_reset(vcpu, init_event);
@@ -10873,7 +10874,18 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	kvm_rip_write(vcpu, 0xfff0);
 
-	static_call(kvm_x86_set_cr0)(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
+	/*
+	 * CR0.CD/NW are set on RESET, preserved on INIT.  Note, some versions
+	 * of Intel's SDM list CD/NW as being set on INIT, but they contradict
+	 * (or qualify) that with a footnote stating that CD/NW are preserved.
+	 */
+	new_cr0 = X86_CR0_ET;
+	if (init_event)
+		new_cr0 |= (old_cr0 & (X86_CR0_NW | X86_CR0_CD));
+	else
+		new_cr0 |= X86_CR0_NW | X86_CR0_CD;
+
+	static_call(kvm_x86_set_cr0)(vcpu, new_cr0);
 	static_call(kvm_x86_set_cr4)(vcpu, 0);
 	static_call(kvm_x86_set_efer)(vcpu, 0);
 	static_call(kvm_x86_update_exception_bitmap)(vcpu);
-- 
2.32.0.93.g670b81a890-goog

