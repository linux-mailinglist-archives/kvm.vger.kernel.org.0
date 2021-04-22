Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C827367761
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhDVCW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbhDVCWY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:22:24 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19EFC06138B
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:21:49 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id o15-20020ac872cf0000b02901b358afcd96so14356569qtp.1
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XcIgsTPGBs6pRE6jBWDLczuu/rTigBWEnSLaTIOPH8A=;
        b=MA6uLPrTjojcprVshBXIbULDoC733rFWX2OeQoxwFVRl6kD2xQRf6BkZyRD8o4U4m+
         O8WPbr2U0/V+VxYsUkl5zCA4UYV1lJniJbwLP4q5iuTJ+PmHc3c7IrTi7VhUeQw/E2rs
         jQQho5X7/60heZOTBYzDzUemibyJEf/RckgZijK1bWbIwZURYtIz78ydl7RK6IqPYjk2
         qI+J2TLBeLtzgHNASBedmrhuZwLU7bh2KgHqrig/NPaQ5xCDlemf1A2dBMC6eAFq1hLF
         rTT17Rr6WtcqNueReKlkUeZVDFoJ1lkFtFw3XY5RaMAjPJ7NYwdiuhtT14pReyYYGi0+
         UHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XcIgsTPGBs6pRE6jBWDLczuu/rTigBWEnSLaTIOPH8A=;
        b=XZNVSYVOl9Btz1q2fmCAor4MRYJzjfJgerpjaa+JLxtbD/Kw5PPJ1OkrokVui0AXPD
         STpkKaYWpTd6p5aWW6ip1Xf58ymMQ2mfyp8/9WvMFUttwZW0hb7P0WDJQaL75cNRoCSb
         ubaD5I6i2GD6lwjp3L34i3HcdhsQMgOTGPj3tpJbsQRu3Rl4B053zoyqtoSIr9ir3uog
         cDndMZ6XLdYCDYnkw4x73uQPSrv2OXdXJG/Ytlqw3m50M3AAaC+t+6jSXVqrAVX7Ok88
         VcfH7WMiQBqqUtNVthCf5Fx6WWC6X6G85mmUc6YN0ZnpNmnFulR9XslgQeB+U+ajibB1
         HPMA==
X-Gm-Message-State: AOAM533aUFTaQHGRtNdJRQ2/daONvXTsxlgscr+MTjQY3ZtJ7YMlFF+X
        a8EORxfbGOY8nqGn+QpqF8Eyx4DKIbk=
X-Google-Smtp-Source: ABdhPJwZRJI4oZlTAaFsOF5n0MbgQM+R5WUPn4TqCzTpYEc2H7u1P4wgJxLLGGZTw6UYPcfg0NekA+phRM0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:ad4:4944:: with SMTP id o4mr982180qvy.18.1619058108878;
 Wed, 21 Apr 2021 19:21:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:21:27 -0700
In-Reply-To: <20210422022128.3464144-1-seanjc@google.com>
Message-Id: <20210422022128.3464144-9-seanjc@google.com>
Mime-Version: 1.0
References: <20210422022128.3464144-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 8/9] KVM: SVM: Use default rAX size for INVLPGA emulation
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop bits 63:32 of RAX when grabbing the address for INVLPGA emulation
outside of 64-bit mode to make KVM's emulation slightly less wrong.  The
address for INVLPGA is determined by the effective address size, i.e.
it's not hardcoded to 64/32 bits for a given mode.  Add a FIXME to call
out that the emulation is wrong.

Opportunistically tweak the ASID handling to make it clear that it's
defined by ECX, not rCX.

Per the APM:
   The portion of rAX used to form the address is determined by the
   effective address size (current execution mode and optional address
   size prefix). The ASID is taken from ECX.

Fixes: ff092385e828 ("KVM: SVM: Implement INVLPGA")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6df12d7967db..ccf9499f2683 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2301,11 +2301,17 @@ static int clgi_interception(struct kvm_vcpu *vcpu)
 
 static int invlpga_interception(struct kvm_vcpu *vcpu)
 {
-	trace_kvm_invlpga(to_svm(vcpu)->vmcb->save.rip, kvm_rcx_read(vcpu),
-			  kvm_rax_read(vcpu));
+	gva_t gva = kvm_rax_read(vcpu);
+	u32 asid = kvm_rcx_read(vcpu);
+
+	/* FIXME: Handle an address size prefix. */
+	if (!is_long_mode(vcpu))
+		gva = (u32)gva;
+
+	trace_kvm_invlpga(to_svm(vcpu)->vmcb->save.rip, asid, gva);
 
 	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
-	kvm_mmu_invlpg(vcpu, kvm_rax_read(vcpu));
+	kvm_mmu_invlpg(vcpu, gva);
 
 	return kvm_skip_emulated_instruction(vcpu);
 }
-- 
2.31.1.498.g6c1eba8ee3d-goog

