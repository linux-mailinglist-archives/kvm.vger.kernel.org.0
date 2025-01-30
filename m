Return-Path: <kvm+bounces-36894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E5E0A22763
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 02:08:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1279E16570B
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 01:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E062288DB;
	Thu, 30 Jan 2025 01:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aJ6Hgs6U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4721DA5F
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 01:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738199313; cv=none; b=mBpKmUVUi1v3Y4TFro9/rZ+klE5lWehIex58whQHTSxpHcDH2+oQmG59KvC8q6Tz8FnYrBSQDAff7T7TZXPVeS8fkoAXQgNd9qi9ucUG7bJuwTS0nh2lPvr6eCFcFKLiabB3Vhl7zU9urtqz37AQCNE1hOouW+XCIe0tPJ/icuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738199313; c=relaxed/simple;
	bh=3bVFGY9QT4BopDtVjaJpCSBGeel8QZQOrPMDFvWCRH0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Z8LNlKM37BGDyDMybauIXjlZGJ3lr0VpyCSzQDwKunspNEACTijQk4KqWUP+QYZJr7bwjXkAPLMh/0MGoYamr+j+EaX4Ax3uvaCh62OyDepmyC8sDWgHWM86+hOl/l1SwCSHaE3x9VZFStQOOPogEU0iMfjQ6zalbYC8aqcmZLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aJ6Hgs6U; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee5616e986so629717a91.2
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738199311; x=1738804111; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rc2C9OSGqh03u9AzmrBpK1aeARz9rL8/Sym1bmsKMYw=;
        b=aJ6Hgs6Ui27zgpVfei26VL4biHntFPYvcPen5BHRrpr93U8azGblOD3iesFmBonKC2
         kmQzrbRYckkcKoJE9jcC7sZyrgfuh/AQIndOOM5mPIYSbvWBaExnVpEmv4HoWkRMZWvG
         jU2agM53HAvU8cvsO6Vdj7AWhsyrRYNQh2EZCsR1aZKLJQkBL6z2CnaMcQUMfHTtcTSY
         qHWC+F5dJsprFshguOHSVzJ82BhKpQBrHoS1AvTobPtJS36PF09+s8wICReGoabW5QNB
         zGleYJ5KKr8bUv5xQkfpcyKzaHg7m426t3uWYyzTix/aelGtuFkWZozZY0RU1pipEgnI
         IajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738199311; x=1738804111;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rc2C9OSGqh03u9AzmrBpK1aeARz9rL8/Sym1bmsKMYw=;
        b=mIAsVW5FXNttL7gE1qxXyTGU1536t0CPfwiE9cyPPkxYBI+IrRGHzhlnTASBEvfzNI
         JBQ0k34p3GYEow7Zw7oTbeHQkYG8B8mvq7FfhBmn9gpQuhzwvRgTdJtIbnJrfS/OnxT3
         wK5uRlzQBy+2af6ZKM+RRz9PAFWUqcnu91VxWhVzvcBqxw+59MBAjbWvaY1VEOITVMx7
         s+NGqmnD5CjRmvYqZFjkynAAvWXghGdP2d3A/X/8CSlqekN3SQjHqSHlx6NLucpPxCHc
         JeJNGZiCzYL9/5bJjq8eEmEZzC13Z5HmB2KCYS9R5NFpeAG9QoqwGxFA00+liQcMsDuH
         UDkQ==
X-Gm-Message-State: AOJu0YxI9I4yFbcCN/k3xv++JSmZj27FnHo47neoMUGYJ7U55yMA5uKU
	Y3lUpD2jAeO2YkHXGEtEw3ILgskaIiBgTtQofNU3znpUS9ijWtOvORcfB2B5YCGf11fQ2KDnCg/
	KZg==
X-Google-Smtp-Source: AGHT+IEPTQavdniKSS4fFn5TSLdnEp2tGG2VCyWzDf4ixkR6pQ/JrmIhNA3s//IUDoICtd7D5Ar15LzvgUs=
X-Received: from pfbea24.prod.google.com ([2002:a05:6a00:4c18:b0:72d:35be:2e97])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d04e:b0:1db:eb82:b22f
 with SMTP id adf61e73a8af0-1ed7a5c42c6mr8074352637.5.1738199311326; Wed, 29
 Jan 2025 17:08:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 29 Jan 2025 17:08:25 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250130010825.220346-1-seanjc@google.com>
Subject: [PATCH] KVM: nSVM: Enter guest mode before initializing nested NPT MMU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

When preparing vmcb02 for nested VMRUN (or state restore), "enter" guest
mode prior to initializing the MMU for nested NPT so that guest_mode is
set in the MMU's role.  KVM's model is that all L2 MMUs are tagged with
guest_mode, as the behavior of hypervisor MMUs tends to be significantly
different than kernel MMUs.

Practically speaking, the bug is relatively benign, as KVM only directly
queries role.guest_mode in kvm_mmu_free_guest_mode_roots(), which SVM
doesn't use, and in paths that are optimizations (mmu_page_zap_pte() and
shadow_mmu_try_split_huge_pages()).

And while the role is incorprated into shadow page usage, because nested
NPT requires KVM to be using NPT for L1, reusing shadow pages across L1
and L2 is impossible as L1 MMUs will always have direct=1, while L2 MMUs
will have direct=0.

Hoist the TLB processing and setting of HF_GUEST_MASK to the beginning
of the flow instead of forcing guest_mode in the MMU, as nothing in
nested_vmcb02_prepare_control() between the old and new locations touches
TLB flush requests or HF_GUEST_MASK, i.e. there's no reason to present
inconsistent vCPU state to the MMU.

Fixes: 69cb877487de ("KVM: nSVM: move MMU setup to nested_prepare_vmcb_control")
Cc: stable@vger.kernel.org
Reported-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c    |  2 +-
 arch/x86/kvm/svm/nested.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 74fa38ebddbf..3ff55a18347d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5524,7 +5524,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	union kvm_mmu_page_role root_role;
 
 	/* NPT requires CR0.PG=1. */
-	WARN_ON_ONCE(cpu_role.base.direct);
+	WARN_ON_ONCE(cpu_role.base.direct || !cpu_role.base.guest_mode);
 
 	root_role = cpu_role.base;
 	root_role.level = kvm_mmu_get_tdp_level(vcpu);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d77b094d9a4d..04c375bf1ac2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -646,6 +646,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	u32 pause_count12;
 	u32 pause_thresh12;
 
+	nested_svm_transition_tlb_flush(vcpu);
+
+	/* Enter Guest-Mode */
+	enter_guest_mode(vcpu);
+
 	/*
 	 * Filled at exit: exit_code, exit_code_hi, exit_info_1, exit_info_2,
 	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
@@ -762,11 +767,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		}
 	}
 
-	nested_svm_transition_tlb_flush(vcpu);
-
-	/* Enter Guest-Mode */
-	enter_guest_mode(vcpu);
-
 	/*
 	 * Merge guest and host intercepts - must be called with vcpu in
 	 * guest-mode to take effect.

base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 
2.48.1.262.g85cc9f2d1e-goog


