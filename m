Return-Path: <kvm+bounces-8505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2116084FFEE
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D78EF28A039
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C408D38F99;
	Fri,  9 Feb 2024 22:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PSiNohpa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FB7381CF
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517747; cv=none; b=b+gSfmaDLKpBA/ENTeCtuRtPLIqtF0ZJrbx5X+x/FW5WiE0FMkKWvyb56/gX3pdUd9kzjBsa1nGoImT5vhrTO4N7CSmz4WA75Stpg7HoPcAQVDhLjoz7vSswVbf/uvdQAbi5q67Jszs3sTe9NrKidlFLLWdm2G8KlyIRWL90z1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517747; c=relaxed/simple;
	bh=I+1ReO9gJD+nyzCjrY4TEB+E2DVWxf90KoNj+96Bxgs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DgQZ7X67bNiXyfrKfYU5eKi1j5eox7sYE2gjSqXD/eWOnyRYOpJgJhO5PqyrB7m63BJFpVnDxzl0DxJsdSUyyK7HjW1pkvDMTIOqn/95jXccTDfzwSGB/iy9LGsQ9mxhsJjp1QHZ6eBweuiwGV4WYDIjBbVkE4z3agwwZ0Qf1B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PSiNohpa; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26ce0bbso2676433276.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517744; x=1708122544; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7bcloJ+2HwTb1M9xznBR1nyxmyl4elTRFFxAIRR6UOg=;
        b=PSiNohpayclniZ5o4jJNQhNEQ6poxFoV0Ma84p/699pC92QSuRExaK3Je5jW8clhur
         CUQmpVQQ2tkaUHZaZUbOVBFDmQjjsSdXQHLIFT7xE+pmxb9rI97qDfJwKhpW8lDfB+bj
         Ge7w/sIi2OgjQ2MRSRNK74RtXQHcwVrEjicKTrQeAu7g2Vgv03IYSJANbSfDCur/r59P
         v8yI5CxzuKmNWnoITfxKCEFmFqIdc+VbZ2/eOYeCvwg2B0LWz9/PIkwxnrONZICIq2at
         lZx6kp5cr+UCiCBLW78nK96kVaW7eSMIP3MJ0jZno0AX1tI5qWjtzGJKMvmIKgm6Ajx1
         elew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517744; x=1708122544;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7bcloJ+2HwTb1M9xznBR1nyxmyl4elTRFFxAIRR6UOg=;
        b=lW1HNUh+ihmxuFa/N2quHT+fV/uv08xio7DDSzwGZEhZE0eraS/6ZFjJjU7gIUAnGj
         jCvfVBVGF+oYvrs5w33XMsvGcBrZIM5/DPE75F+bgLgI4Uo7z0MW4wSSWlt/7zbB6rED
         +dM7T61Vsk8YBVQYTLMooQoH3eFhYrwHwIv7cFF6evBez9tziRRNpmXRufdipyDiZ7TQ
         UZqpWtJ74uEXhhfZzrvIWbPiXMzPRyNGwzABEv1DqXjg4D4J5A1LiS+IJFD6PnGb/Q/R
         SZAS2AdkGvCnrRxAzzTe23SAXftin3Tqt57C5C2isGxaaHEzul9me/AsUfMHQclk5pLX
         7tUA==
X-Gm-Message-State: AOJu0YyTSTjqetw6G2CAGc3KJK896F6KQZF0f0NUj02ZYFFXqYLUftx+
	qfSOpFPuYXRyZfwiCJRTndwLavzeUgqWikbhIWKZLIECcrwcL4Pi4sr+70DtHwPyJ39CabEJNfA
	Rig==
X-Google-Smtp-Source: AGHT+IHoPP9F/FG0S8lg28wlaICJLTHfT7pqorkLv+VVBdmv+vZIIS4hGeCOwHN/Ul4rpe86EXtlJpBC1ko=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:dc6:f78d:435a with SMTP id
 v3-20020a056902108300b00dc6f78d435amr109630ybu.11.1707517744631; Fri, 09 Feb
 2024 14:29:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:28:56 -0800
In-Reply-To: <20240209222858.396696-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209222858.396696-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209222858.396696-3-seanjc@google.com>
Subject: [PATCH v4 2/4] KVM: x86/mmu: Move private vs. shared check above slot
 validity checks
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Friedrich Weber <f.weber@proxmox.com>, 
	Kai Huang <kai.huang@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	Michael Roth <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Prioritize private vs. shared gfn attribute checks above slot validity
checks to ensure a consistent userspace ABI.  E.g. as is, KVM will exit to
userspace if there is no memslot, but emulate accesses to the APIC access
page even if the attributes mismatch.

Fixes: 8dd2eee9d526 ("KVM: x86/mmu: Handle page fault for private memory")
Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
Cc: Chao Peng <chao.p.peng@linux.intel.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 166cef0c3ff4..50bfaa53f3f2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4360,11 +4360,6 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 			return RET_PF_EMULATE;
 	}
 
-	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
-		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
-		return -EFAULT;
-	}
-
 	if (fault->is_private)
 		return kvm_faultin_pfn_private(vcpu, fault);
 
@@ -4403,6 +4398,11 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	struct kvm_memory_slot *slot = fault->slot;
 	int ret;
 
+	if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)) {
+		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
+		return -EFAULT;
+	}
+
 	fault->mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-- 
2.43.0.687.g38aa6559b0-goog


