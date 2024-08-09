Return-Path: <kvm+bounces-23772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B035F94D6F5
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:10:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67DA3288203
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B039161320;
	Fri,  9 Aug 2024 19:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m1kAB4Wy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2829419D096
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230247; cv=none; b=QoIh2Yo2c/hl9spdryPL6UhcGXfRGY+6mHcd/ble26Y8PWictSdNtI+U+ZrBGcztBmfjoz52V/v4r1CbPUt3vv5ByZXF/WgUoVXuN+kp5LFMkjCp5PTx2EvcmCftD89FTuM2jyuyLq3jEOk7aM9fOYF0OFGoV5bj18ew4DiqzAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230247; c=relaxed/simple;
	bh=RAj0k26L7e6hItfq0DdkXBLRRrgYaa5pBwltIWlH7wA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fcB+StWowb2IEMyqiqfzHzkwnp7fv8d5agmFxO/08+zSMad65+SvaqIDwMIgcrAiBmlvEs/MiaKsHN9/YfEEzOgs/ez9pCcyNWpQanUYdTIRJDOJqjVSLyTczL1te6BrEqQOsmzmUOfX7fkxn6V9aQ6LJaf5Z1hOjFfFn2l5Teo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m1kAB4Wy; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a994e332a8so2108116a12.3
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230246; x=1723835046; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=G4BNuwtJ6NMA4YiBcM1PUSgleR458VStyd6GBZZF8w8=;
        b=m1kAB4WyqvGB5XwCXRyTuFYrHtxBGoNOXUcb6HR14TUPMOgJcXlNK2Bu5GyDZt/qGd
         jkP23gqlrOUwcA6SM3WWw5dipdSzj4GCLBcEkKULOrOexMmjzgDurbmJwjAyozXS1c5Y
         Ftg2l+bMOI1tM2b9qd/ddLvmEogJrRb3Nt5jGiR3xkdDWg6e11OqPx69xLB8Xkbn6kLD
         M8Z2BPmgelXxBUHx7abL6MioJTHEsHVLt6jA5uLnllkEpIJPDAUeobv8x8D++x2/P3N4
         XFtK0tDcZ2r/xtKx2HkuaO/wptfHUo+8HfLASr6H6GT2ILZdKoLKnU/vYK23DEf8gfx7
         CbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230246; x=1723835046;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G4BNuwtJ6NMA4YiBcM1PUSgleR458VStyd6GBZZF8w8=;
        b=k20Ucm+PZjj6tqwjDyYK1UYnTt8uE4VsjWHuEv9EHGmlGzcOpLnzTwginMlPP2uHhp
         VshuP4HA1LQBMat/4mSn3alijm+SR4/RFSALWNLZ1maHJVmjYEhhPJXaYxui4Al7mxN1
         E05b+gz3fOYm9mBPXX3SdpyrcswxhMYsrD0EbgS61jXvU2daHkOU0FlEoWNTRGIxOSx6
         MM272USFf3ARmoUBS3831Vq7/FuAXlLhtitEGWl0hVWG+OCR+pWjFR9XneVVTrLDhe0p
         VRVdA2r0cAOGNCAZtK5yqVtNUNj5xHXJm9kRr9Th0Jooojv8bHSa0f6jKmEqZ5+X/bbZ
         kMPg==
X-Gm-Message-State: AOJu0YyUgn9108BOPoy6JoYjewuGIouNpX4dTJV+aB/XLIP9njXnNxuX
	AERP9Snh6u3Lbz0Q/EsWEuOiyiMoYX7sCjyUdM0SIk7eG1E0CmTHcBQlR1TjzwuMPMHNY9T4jAq
	jow==
X-Google-Smtp-Source: AGHT+IEDzFUCPnHj7AFwv0nC2uk2Vq5ql39xuChh1cZ88t8pY1ewqFSi2d5sUYKbJsHcj8NSBHzLWancOaM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:d64e:0:b0:7c1:89ee:a9fe with SMTP id
 41be03b00d2f7-7c3d2c14841mr4639a12.8.1723230245533; Fri, 09 Aug 2024 12:04:05
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:18 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-22-seanjc@google.com>
Subject: [PATCH 21/22] KVM: x86/mmu: Subsume kvm_mmu_unprotect_page() into the
 and_retry() version
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Fold kvm_mmu_unprotect_page() into kvm_mmu_unprotect_gfn_and_retry() now
that all other direct usage is gone.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 33 +++++++++++++--------------------
 2 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b3a2793fc89c..e2df07b3c411 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2131,7 +2131,6 @@ int kvm_get_nr_pending_nmis(struct kvm_vcpu *vcpu);
 
 void kvm_update_dr7(struct kvm_vcpu *vcpu);
 
-int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
 bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				       bool always_retry);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 59af085a6e8e..300a47801685 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2713,31 +2713,16 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 	write_unlock(&kvm->mmu_lock);
 }
 
-int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
-{
-	struct kvm_mmu_page *sp;
-	LIST_HEAD(invalid_list);
-	int r;
-
-	r = 0;
-	write_lock(&kvm->mmu_lock);
-	for_each_gfn_valid_sp_with_gptes(kvm, sp, gfn) {
-		r = 1;
-		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-	}
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
-	write_unlock(&kvm->mmu_lock);
-
-	return r;
-}
-
 bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				       bool always_retry)
 {
+	struct kvm *kvm = vcpu->kvm;
+	LIST_HEAD(invalid_list);
+	struct kvm_mmu_page *sp;
 	gpa_t gpa = cr2_or_gpa;
 	bool r = false;
 
-	if (!vcpu->kvm->arch.indirect_shadow_pages)
+	if (!kvm->arch.indirect_shadow_pages)
 		goto out;
 
 	if (!vcpu->arch.mmu->root_role.direct) {
@@ -2746,7 +2731,15 @@ bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			goto out;
 	}
 
-	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
+	r = false;
+	write_lock(&kvm->mmu_lock);
+	for_each_gfn_valid_sp_with_gptes(kvm, sp, gpa_to_gfn(gpa)) {
+		r = true;
+		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+	}
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	write_unlock(&kvm->mmu_lock);
+
 out:
 	if (r || always_retry) {
 		vcpu->arch.last_retry_eip = kvm_rip_read(vcpu);
-- 
2.46.0.76.ge559c4bf1a-goog


