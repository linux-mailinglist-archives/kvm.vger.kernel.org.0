Return-Path: <kvm+bounces-23766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 449DA94D6EA
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:08:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 648CF1C223F3
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADBEF19ADBA;
	Fri,  9 Aug 2024 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eY/ryirv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755351607B3
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230236; cv=none; b=fpXEnaSQ3IM6CMHO0my+BEgHH/vyTZOYVznn6mPUliBhHZz+LjCeiBU+VKGTilZBcIRRkdFJhXWUxC2sVNKk3Ex/AWk1hl5XAs6E2FfrUWHOh8r7sHdURYhp729TZ6V4V6PcDOG5UxPvBnhqjVBBWb7iZhMMHXfAVXjf1qeXlQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230236; c=relaxed/simple;
	bh=KQRLdya5684hxmBaKQMKjQM37jKdGg0h9k1yv0K/BzQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AWb5fDXv6C3cDFNzAOBoOfOoQLjhWvXI8lqsAZeZ1crvp+0jFhEEITuXgeM9Xjo4YK1s9XT8G0OG3M3No2o1OCiaeXIhEMa7iSlvYJttV+DP/RpU/wtanDtdLOvB9nlzdKbxoI/68LD994VLNLOr/3HT1RPOtYu+vtAlv7llf6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eY/ryirv; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc658a161bso19773625ad.0
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230235; x=1723835035; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cEDePGFWarkq0p5GsDOTFsBMJqTP6fc9aq5ikFn/88E=;
        b=eY/ryirv0gekqLbSvXNIgRIDVVLESnaEOtcs5bBWyn/JTKnrTu7G77qrV5ehukr29R
         q0n8XHUDsFL1yYhFTxh11CeM8eG1azt++6JizKLF6d5DrTFl1aQykvjSgwpt9+AAAAQP
         HDzqLvQrHMuX98rDnxz6TB/B9sO2/hXrirGrhVUvrI9JfxLF8eoLVN6ChnDpRoOofWcJ
         Se/U27kFxDc/+NasBZYOhfnAjJ9evcKsdFM2z996b1FdPD1cgRy+SsAa85IvrZjqVqCF
         PUr2Df5lOyhBYw6nmywrY+riTK4aAPglze24U1DLzQKWpj/LysQhpUZe0zebipbvuTZ7
         JDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230235; x=1723835035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cEDePGFWarkq0p5GsDOTFsBMJqTP6fc9aq5ikFn/88E=;
        b=mDPVLAhwHifXVFjGzDtfIH79daof2mKKaesYs4J5iXX0BG+snhadQk7DlvKLa3ZAiP
         TurOd5LHXnvq6hDA/Z3ArcarLpO7pn8LeksA8jij6Z0peRs+4/F8B6QlGHKuft1bHp69
         zSpvJ75a/ZgI0uoTWcW8OXK76MApmI+w+hX+OLJoNZlBM7KOHeVYBB3pveVH4sbUNdNz
         JOreNlWG5cTYgmaZHLpDFQ/0E8I6x9twkrxNlrdYjh/PeX9H8NgAsRroBAx4yCyq645y
         IOxserLzDmJ8Y8uT9VTMrLDWmdaaY4vz8OSD/UNmk18z3fZjnzknA1Zl0oPQFlUJHKaU
         ik9Q==
X-Gm-Message-State: AOJu0Yw9LzTqYNlvkUiOCTAGrbRV6wnWJgITUVwPwvcwFcVvH4saFhkQ
	1f5zx8GYz+r62Ms5xkHA7wZ7SDGBrbnCTcyLIzCUbqNnL2hIN+SxduAivdRFrURvPWAbQt86V+g
	Yow==
X-Google-Smtp-Source: AGHT+IGcq0KW3D4A3WQypd2J8Gl2rA30J53XcmsY9Nzx5KvXDePBctQ+y9HgClPMmimHKkgZewLGtj2KVP8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c405:b0:1fb:82f5:6631 with SMTP id
 d9443c01a7336-200ae5aa8f5mr1239735ad.9.1723230234728; Fri, 09 Aug 2024
 12:03:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:12 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-16-seanjc@google.com>
Subject: [PATCH 15/22] KVM: x86/mmu: Move event re-injection unprotect+retry
 into common path
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Move the event re-injection unprotect+retry logic into
kvm_mmu_write_protect_fault(), i.e. unprotect and retry if and only if
the #PF actually hit a write-protected gfn.  Note, there is a small
possibility that the gfn was unprotected by a different tasking between
hitting the #PF and acquiring mmu_lock, but in that case, KVM will resume
the guest immediately anyways because KVM will treat the fault as spurious.

As a bonus, unprotecting _after_ handling the page fault also addresses the
case where the installing a SPTE to handle fault encounters a shadowed PTE,
i.e. *creates* a read-only SPTE.

Opportunstically add a comment explaining what on earth the intent of the
code is, as based on the changelog from commit 577bdc496614 ("KVM: Avoid
instruction emulation when event delivery is pending").

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f64ad36ca9e0..d3c0220ff7ee 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2753,23 +2753,6 @@ bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa)
 	return r;
 }
 
-static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
-{
-	gpa_t gpa;
-	int r;
-
-	if (vcpu->arch.mmu->root_role.direct)
-		return 0;
-
-	gpa = kvm_mmu_gva_to_gpa_write(vcpu, gva, NULL);
-	if (gpa == INVALID_GPA)
-		return 0;
-
-	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
-
-	return r;
-}
-
 static void kvm_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	trace_kvm_mmu_unsync_page(sp);
@@ -4640,8 +4623,6 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	if (!flags) {
 		trace_kvm_page_fault(vcpu, fault_address, error_code);
 
-		if (kvm_event_needs_reinjection(vcpu))
-			kvm_mmu_unprotect_page_virt(vcpu, fault_address);
 		r = kvm_mmu_page_fault(vcpu, fault_address, error_code, insn,
 				insn_len);
 	} else if (flags & KVM_PV_REASON_PAGE_NOT_PRESENT) {
@@ -6037,8 +6018,15 @@ static int kvm_mmu_write_protect_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * execute the instruction.  If no shadow pages were zapped, then the
 	 * write-fault is due to something else entirely, i.e. KVM needs to
 	 * emulate, as resuming the guest will put it into an infinite loop.
+	 *
+	 * For indirect MMUs, i.e. if KVM is shadowing the current MMU, try to
+	 * unprotect the gfn and retry if an event is awaiting reinjection.  If
+	 * KVM emulates multiple instructions before completing even injection,
+	 * the event could be delayed beyond what is architecturally allowed,
+	 * e.g. KVM could inject an IRQ after the TPR has been raised.
 	 */
-	if (direct && (is_write_to_guest_page_table(error_code)) &&
+	if (((direct && is_write_to_guest_page_table(error_code)) ||
+	     (!direct && kvm_event_needs_reinjection(vcpu))) &&
 	    kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa))
 		return RET_PF_FIXED;
 
-- 
2.46.0.76.ge559c4bf1a-goog


