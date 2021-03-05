Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFCB32DED1
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCEBLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhCEBLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:09 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF790C061756
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:07 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b127so662710ybc.13
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YZHRewQoZy371sjGbfTjC6cuAY8+Z64Uwc7ykPHV30o=;
        b=lbtKupSNNVVnfGQzSlvQ+vTPFhg4zP425mwF5KftOrXADXrxW5MCkY9PdW6+OECVLi
         f7gV3Yd6yk9HuYcd9bdWv1hOqkHKEFHbq+1wcJfndCJtUGQV2uhXVaL5jxC05PzU+IiH
         vZy/QxLlzTQ+SsUMbVNaHztQNZ0z6CPanVisBzdLeHIMuCF52m9Ad1PoHiflsYduUBra
         X8oKSrNikGzi6cw5nBmyUDTIdrAo/GvoAwdZ6atuSc103Jz3Wio3cM7NLE92H1iRQrE6
         tEcpWLHfeJ87aekUvaTCOfkDbJ5cVQkEDsQNNGyBYFgWWIvVzx6r/kXgN0TQ4i12Dg67
         3iFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YZHRewQoZy371sjGbfTjC6cuAY8+Z64Uwc7ykPHV30o=;
        b=MsGqAkUXvn50yH0C5ifgrOyk2ADqjjsCpZKyB9kgR6nuHzHdxe6RWyxSuo6mXspwNJ
         0z7vBBp1CHrv1QJ4hYwGwdm6SkdLQl4501LoPRrKRJvmI1R2uZW6iPlF1uB5D9bxmTsi
         cSBfxbpkDEvMLljrruS/FHFc0S+pW1ExK7zJ/yOjVnVFaoQjFpaKG6E3NL29Dd7KAtJF
         yx7XRy7ey548R8K/HvUOYI58l0Ntmd9orZ13fBzJ1XXmwvUbIaK6lgXW5PAnihgPxNBo
         39Y2shJBXf3vMSzA08fp8vN3DVNfrXUjOQGH/mkf0K/tzly953y3nj1F4vxsdOAULbWv
         Ivjw==
X-Gm-Message-State: AOAM533KF6cWI/9bU4tXWQma6xZcyqSLJ6L1Cl2R6wh0eXnoAIc8v61e
        nSlrPczGct2jd+GfzttOS66/UfRdawM=
X-Google-Smtp-Source: ABdhPJzNiol+uPbyiI3HEQZPgXCwVI/rb61MbgLwfLCGALveKCKrVdNcrvALevBAaHdUJicLhjlt8ns3F9s=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:76c3:: with SMTP id r186mr10611691ybc.365.1614906667218;
 Thu, 04 Mar 2021 17:11:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:45 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 01/17] KVM: nSVM: Set the shadow root level to the TDP
 level for nested NPT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Override the shadow root level in the MMU context when configuring
NPT for shadowing nested NPT.  The level is always tied to the TDP level
of the host, not whatever level the guest happens to be using.

Fixes: 096586fda522 ("KVM: nSVM: Correctly set the shadow NPT root level in its MMU role")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c462062d36aa..0987cc1d53eb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4618,12 +4618,17 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	union kvm_mmu_role new_role = kvm_calc_shadow_npt_root_page_role(vcpu);
 
-	context->shadow_root_level = new_role.base.level;
-
 	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, false, false);
 
-	if (new_role.as_u64 != context->mmu_role.as_u64)
+	if (new_role.as_u64 != context->mmu_role.as_u64) {
 		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
+
+		/*
+		 * Override the level set by the common init helper, nested TDP
+		 * always uses the host's TDP configuration.
+		 */
+		context->shadow_root_level = new_role.base.level;
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
-- 
2.30.1.766.gb4fecdf3b7-goog

