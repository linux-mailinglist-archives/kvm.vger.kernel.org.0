Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAAF175D794
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 00:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjGUWhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 18:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjGUWhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 18:37:16 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC5D35A1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:37:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5704991ea05so24932957b3.1
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 15:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689979033; x=1690583833;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nb2s/VVy5vEUTAq5dFAiQTgXU9RDEXhEPes4mc/LgaE=;
        b=hrnZx3bQTbAYbnZBbI23Btu4RUwP0QbpLJBgafmTuZQTWWdqjy6qmocK+eAwwcxsYP
         IJ5OcEGMQ0ZxJ8xGPp7nhAvW1orYdk6aPUb2klwpOm9t8sVVeYbZElO3aUY7ln7UZR6H
         K/rnzg1O+9xEJO4ZV2GHYtq9xPGElvC5PKdHH6KLqy7qbfkdMelBTwPBySWMlss2tDMK
         9RhIMG5wuOba8ReovgRtw1d1mJi6byKm6rb1EajIXUK71ea32K93XWu8f/093LZBTz85
         poWUEnh3I0h+V20ryx8r5FnL0DC+3B2yixtnsHDQMr/AQqPPK7OgZqiqA5tUKl+mEIG7
         YEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689979033; x=1690583833;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nb2s/VVy5vEUTAq5dFAiQTgXU9RDEXhEPes4mc/LgaE=;
        b=WN6LObHpGruuxJKMVLyFw06rMBuqE8LcZ3+b12xO4hTDO9ThguD87HPjw4E27KUq70
         okv24a+A7vzVePrhxF1CgqoPF4E0d3vXZlRntBtw34+Ejiq5UL/yhrkNSnJvAYHIR1Wq
         abSSyDSOZ/y0vWHpALHP2pSUJ3I2YjD45xOUyZA88YZG/IEBXODoTBd0Ih30T6ow0Uf+
         he2YC6jWQPSC3nzImSdsptOwoirUoXsqT66HdFTBNAfNWBVjTJLq2xoEZqkk2VLtA0vs
         Vd5fRoSywHOQ/H90x3XicFcLYQ1Mroqo9lD8ieZ5yw2xyRhCZg73DY2J2btxvlu0Lo85
         6YjA==
X-Gm-Message-State: ABy/qLbKk0HbUNg2ZY+j5odSPORID3Xx7W+1vKwSTbBEA2fKEi76286C
        Qvk4TAahbz39FN/9fBZKnIg5ahzTmeM=
X-Google-Smtp-Source: APBJJlF9/qI5AuU2qayHl35iJ1tMcnwLxcDahs8C4ipF5LJ8Rjje1k32sYbKXzUUCtzE/5INK/CAd8UeuAI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102f:b0:c22:38c2:43de with SMTP id
 x15-20020a056902102f00b00c2238c243demr23100ybt.11.1689979033628; Fri, 21 Jul
 2023 15:37:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Jul 2023 15:37:11 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230721223711.2334426-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/mmu: Guard against collision with KVM-defined PFERR_IMPLICIT_ACCESS
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an assertion in kvm_mmu_page_fault() to ensure the error code provided
by hardware doesn't conflict with KVM's software-defined IMPLICIT_ACCESS
flag.  In the unlikely scenario that future hardware starts using bit 48
for a hardware-defined flag, preserving the bit could result in KVM
incorrectly interpreting the unknown flag as KVM's IMPLICIT_ACCESS flag.

WARN so that any such conflict can be surfaced to KVM developers and
resolved, but otherwise ignore the bit as KVM can't possibly rely on a
flag it knows nothing about.

Fixes: 4f4aa80e3b88 ("KVM: X86: Handle implicit supervisor access with SMAP")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Note, Isaku already posted an RFC version of this, but that doesn't have
Isaku's SoB, so I'm taking the easy (for me) route so that this can land
sooner than later.

https://lore.kernel.org/all/0d71b1cdd5d901478cbfd421b4b0071cce44e16a.1689893403.git.isaku.yamahata@intel.com

 arch/x86/kvm/mmu/mmu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..ef554fe9f477 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5742,6 +5742,17 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	int r, emulation_type = EMULTYPE_PF;
 	bool direct = vcpu->arch.mmu->root_role.direct;
 
+	/*
+	 * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP
+	 * checks when emulating instructions that triggers implicit access.
+	 * WARN if hardware generates a fault with an error code that collides
+	 * with the KVM-defined value.  Clear the flag and continue on, i.e.
+	 * don't terminate the VM, as KVM can't possibly be relying on a flag
+	 * that KVM doesn't know about.
+	 */
+	if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
+		error_code &= ~PFERR_IMPLICIT_ACCESS;
+
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 

base-commit: fdf0eaf11452d72945af31804e2a1048ee1b574c
-- 
2.41.0.487.g6d72f3e995-goog

