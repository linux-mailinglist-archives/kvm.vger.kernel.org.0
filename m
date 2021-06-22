Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12BE3B0C46
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhFVSFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbhFVSEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:04:46 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB25DC061149
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:28 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id m133-20020a37a38b0000b02903adaf1dd081so18979717qke.14
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=a9zPNtBlg/qu0kCUht360R1GJCEujAU69kTvJewr3ik=;
        b=bPVlD7rtWzLf2AsOGFWd9xztbB2LhjIoidy1eG/n3+quQfDjyQpU9ZzO4GYUnDyqxD
         nsKaWU23fDyPnMniQ8ZO+LwlgscLpPXe7d10Ie1XNl429HLxF8WpeGzRVd1Am0tcElND
         tyXkDY7YiAvwhECSbBqV9A2Z04QBqRRdzLufrV0NNHtEUcAW+q5GoZ7TOpSsOTilNkyh
         z6PKt1ckGmOPPvDS+GjhseTilVBydl8fjabGHd35SS6HOlhK7l/G4V88D6wfeyVb6zcM
         5GmDoiLtWoZQ7REMuNNKZ0ctj/VJVdsJRfmt2JrjxIYOoj7zAJwTgAMJa46Z4ZVN+Pkj
         cNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=a9zPNtBlg/qu0kCUht360R1GJCEujAU69kTvJewr3ik=;
        b=RRaSXzdMF8EXxTkOQmn3YkZw0F+eJ68EAMWWIweA9VcS82vXL1qIaLN2ecY3MLje4l
         aXuJBr6uC9syjRFU6Raao0S19MoFau8S8NSBEpOS2tYueTfYuxejxKhgnRDr8jlmd5UF
         hcGFTI5JX1/kf2+TGS3/Moe0Dg5bFM8JeTJfEX2/URr5FStOgA9Mt3LaUnU/w5I4YGSu
         B61GiiBkiFWj78OoiXGg+uEJY2p3MTuieR/+L8Ueuizwm8MrmBJS4K5XyYKmHkHgbGsh
         qVIaPRrN9PEnryORz/RgQWp9mHxNQX0bDSmXKyY3OnHAa7ZIpbd/9dPo9j3HvuVegAav
         scdg==
X-Gm-Message-State: AOAM530yQ/YxY2mZk/zNWr8+nqj2GtajQz6Av74wZu4ho7LlBDaep1lP
        YZcqcoZ1coo5RXSugOXXH/6YhwYY/aA=
X-Google-Smtp-Source: ABdhPJzOrTtOd9hL1wlbgR79i9jOPb4MgOv+cS188btXnFinG+K6DbjdBbWNJMmGrPI48QUDFEBjrIW0DLw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a5b:5c6:: with SMTP id w6mr6485868ybp.279.1624384767865;
 Tue, 22 Jun 2021 10:59:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:25 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-41-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 40/54] KVM: x86/mmu: Use MMU role_regs to get LA57, and drop
 vCPU LA57 helper
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get LA57 from the role_regs, which are initialized from the vCPU even
though TDP is enabled, instead of pulling the value directly from the
vCPU when computing the guest's root_level for TDP MMUs.  Note, the check
is inside an is_long_mode() statement, so that requirement is not lost.

Use role_regs even though the MMU's role is available and arguably
"better".  A future commit will consolidate the guest root level logic,
and it needs access to EFER.LMA, which is not tracked in the role (it
can't be toggled on VM-Exit, unlike LA57).

Drop is_la57_mode() as there are no remaining users, and to discourage
pulling MMU state from the vCPU (in the future).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c |  2 +-
 arch/x86/kvm/x86.h     | 10 ----------
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6418b50d33ca..30557b3e5c37 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4635,7 +4635,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
 		context->root_level = 0;
 	} else if (is_long_mode(vcpu)) {
-		context->root_level = is_la57_mode(vcpu) ?
+		context->root_level = ____is_cr4_la57(&regs) ?
 				PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
 		reset_rsvds_bits_mask(vcpu, context);
 		context->gva_to_gpa = paging64_gva_to_gpa;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 521f74e5bbf2..44ae10312740 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -157,16 +157,6 @@ static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
 	return cs_l;
 }
 
-static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
-{
-#ifdef CONFIG_X86_64
-	return (vcpu->arch.efer & EFER_LMA) &&
-		 kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
-#else
-	return 0;
-#endif
-}
-
 static inline bool x86_exception_has_error_code(unsigned int vector)
 {
 	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
-- 
2.32.0.288.g62a8d224e6-goog

