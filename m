Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8C432B57F
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379677AbhCCHRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381050AbhCBS4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:56:35 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E558DC0617AB
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 10:45:49 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id t6so13533329qkt.14
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YZHRewQoZy371sjGbfTjC6cuAY8+Z64Uwc7ykPHV30o=;
        b=Tbqt6GSTs/cBKpRsz6Z+ZO3EOqFtoyaE5wLJwyCohe9UBaJ+04rH/ZyrEb5X7Y10Cy
         C/8FCMfuhyOCoDsAmNty55rljW6fkw/HhEe9oBIwWC6d61ZKYz2/mB3PQFngKX6ygnaU
         7tBhzaHJd/QPLDw1Zyr32w05Uya3/je3mowIXG6jfktVoWtGv8jLAH6M+zEEAYQaslAk
         dJaJbBJ5akhLEGlSMIsQKQbLfCTSrdzehEggpS2NeN+y1cWihXNRMgsCg+HMX3ES2W2t
         GU84i46tSdbyjtPSUEuCnhz2z7GAhD7kuD6KQx0yNsz/PRrY5D4Qs5WuKhGobCCGcmS7
         /DNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YZHRewQoZy371sjGbfTjC6cuAY8+Z64Uwc7ykPHV30o=;
        b=ojbhd0shrUKrgzvFYmD7rAHX4v+PY4qRNO2JZtW3t1mRhDCfBY+CdbvN8RYqDR6EeO
         y3nCWnUHxzeG/7tpYxFUcWWWKsYXvdQiRKkdmG+SOIJOrIxgRSjmiYkS31wGrqCzSkX9
         tVi9FJb+ESnE9HS2v5sNdiqj/xSpRbsBQnEpFBXtabGxT8G0pgLaAb1sdsfQCYdttR/n
         7qarJrb1GjPGzD7Jrfr+g3ZRRqzfZRSu2R3Z3M9dFrPWAjf3LODiw7vZetGUuc3mFT1Q
         vX56cUFSgbYI7+KxghZfH/OYuMOIE6teyOq/t9rqW8rBTz0QIawMOufkzw7nkNiBsbgH
         8z0A==
X-Gm-Message-State: AOAM531RpQh2ZSgRW5/EMZsF0ftuvb8xDqNjfJnnjjdaFdwLmad/5tAg
        t0fLwWAnrraJs6JGJt+SecJ6NgBFgBA=
X-Google-Smtp-Source: ABdhPJyttoZq05JERdsWEl6MPTgri49/ddXi5SOOkf3NBUVWaM1TTiXfV4sKhSpQtqTr1SNA2Y76kLMylNg=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:805d:6324:3372:6183])
 (user=seanjc job=sendgmr) by 2002:a0c:c1cc:: with SMTP id v12mr20391617qvh.47.1614710749045;
 Tue, 02 Mar 2021 10:45:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Mar 2021 10:45:26 -0800
In-Reply-To: <20210302184540.2829328-1-seanjc@google.com>
Message-Id: <20210302184540.2829328-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210302184540.2829328-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 01/15] KVM: nSVM: Set the shadow root level to the TDP level
 for nested NPT
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

