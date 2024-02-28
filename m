Return-Path: <kvm+bounces-10187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B71F486A6B4
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:42:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C1761C2612A
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896D1200A8;
	Wed, 28 Feb 2024 02:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ENgPAUD1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539901CFB9
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088114; cv=none; b=jIlYy+uR1PJWMfIWzTSKbD2GUdQa7pwB730RJ/AqNE2Ml70HYcyEuIE6yn1hACj8WyMu8cFRy3uQTuRlTJyOt10gqpV0ZdXS37Wq9oxSQePgpnsDWR4H7r9H9+NWzHN0RTtdGh9VrPGYg6v9rwoqJ/u14kZvdCb+1OKkGWDySLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088114; c=relaxed/simple;
	bh=0nYnhkfXEoXgiOzmvAD6QsOU4Ex9riioYW0HkqLKI3I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hnMgwFSSD0R32rqz796HHIT8rK+plpr8j1pkd7agnbtMhwgqD29l6mUrQrwwNI1ks1w8yA5+4KECfyoZGeIaeWBF0GhbFG/cE6NUryWI/AzE2gPsRm5tNlMMWh+XTCOSgvjhC7kO5lsyIgYDNAl3f98rciqlkktohuMjVoPxyeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ENgPAUD1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1dcaff13db5so23563295ad.3
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088112; x=1709692912; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yZ0WtCwVDO8+ewSeZMQs1E3cZ245daVAR5Xu2LLMu24=;
        b=ENgPAUD1amsVNQu56qAD34wlUMNbFKf4FUuqYOieghOpiD6XxA9B3ujNsnRkzk8BGv
         k+7q8++BCQD+M9Sad+Qqbl3/dMOd0b29tnWiLI+l8/A/fh73Xf2KURapAtkVz4QWI/7F
         41AAxtd2MA+TARP2Q/RW9KcYpjurGnExevLPkEcXNxFK8KyDINeLWtACErB78A1mLzmZ
         e+xpy6nNyolRoZLUlC5PeBe20brCbSnm7gIc0cKEoHL3m7tLExb5K9g75RGv6xxuRsIb
         pFX1O2PYJOQfJ2x4XpcJT/rdq2k6AxOkSMtMMRTToMbbUruZ1RJVjjAkH5UZQLSJ+RYo
         GEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088112; x=1709692912;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yZ0WtCwVDO8+ewSeZMQs1E3cZ245daVAR5Xu2LLMu24=;
        b=n+6AKfK/QG6OMoqN/WvQ49+AXO52M7S5+heh2CGCpVw89h8h/DBVOQL1MEqt25odU1
         Fomk/J51ixqe1KL6FoXE9gy+o2EwaPIcdnRStLTLv5DZ2w80lnl1BcmmAEjCU8PPxq2q
         RprYy2NgXEhx4vaUGtk9g0g70W0Z/Jxb5gxzG/ctzZbMwO3HKlPqaMygfISs0QYfpwbE
         LjF0S5lrEYAPF2UVtAzZ5ncAlUtw2gatS34VfrUzqSJlvQnhNGFw1afvwCC5QZTEwCKr
         erNoFr+McSy81nwEVO6NdZQjovpGz1yAgYdOrx9lvqD+7C1372vGLXnZNPY844yRTQfi
         Q/RQ==
X-Gm-Message-State: AOJu0YyryG5yonvfotvb5Ikwe552471FqXd+V770OeqdJcm89yo/P+cH
	ey+VJveOj67a8WahG2WvtJoGTTC3Z4PJb13JIavgRiQ5hRNli3CR0kI7iCNSC3NKo3YzlBKSAmV
	GUw==
X-Google-Smtp-Source: AGHT+IHT+n9eH6+34c02CKv+xvYBYlsjdHG/QXVBuMrn39hwmZ9Kl8Uiyv0qzfOxyiZ/4SfXMTOE04r4lGw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dac9:b0:1dc:b424:56e0 with SMTP id
 q9-20020a170902dac900b001dcb42456e0mr343078plx.3.1709088112680; Tue, 27 Feb
 2024 18:41:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:32 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-2-seanjc@google.com>
Subject: [PATCH 01/16] KVM: x86/mmu: Exit to userspace with -EFAULT if private
 fault hits emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Exit to userspace with -EFAULT / KVM_EXIT_MEMORY_FAULT if a private fault
triggers emulation of any kind, as KVM doesn't currently support emulating
access to guest private memory.  Practically speaking, private faults and
emulation are already mutually exclusive, but there are edge cases upon
edge cases where KVM can return RET_PF_EMULATE, and adding one last check
to harden against weird, unexpected combinations is inexpensive.

Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          |  8 --------
 arch/x86/kvm/mmu/mmu_internal.h | 13 +++++++++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e4cc7f764980..e2fd74e06ff8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4309,14 +4309,6 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
-					      struct kvm_page_fault *fault)
-{
-	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
-				      PAGE_SIZE, fault->write, fault->exec,
-				      fault->is_private);
-}
-
 static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0669a8a668ca..0eea6c5a824d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -279,6 +279,14 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
+static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
+						     struct kvm_page_fault *fault)
+{
+	kvm_prepare_memory_fault_exit(vcpu, fault->gfn << PAGE_SHIFT,
+				      PAGE_SIZE, fault->write, fault->exec,
+				      fault->is_private);
+}
+
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefetch, int *emulation_type)
 {
@@ -320,6 +328,11 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	else
 		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
 
+	if (r == RET_PF_EMULATE && fault.is_private) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
+		return -EFAULT;
+	}
+
 	if (fault.write_fault_to_shadow_pgtable && emulation_type)
 		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
 
-- 
2.44.0.278.ge034bb2e1d-goog


