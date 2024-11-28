Return-Path: <kvm+bounces-32628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D75439DB058
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:44:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1465F166F0B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFDA42E822;
	Thu, 28 Nov 2024 00:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vVv115pt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794E61AAC4
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732754632; cv=none; b=DvMMvVLNitoDhGHwfj3t3QZKxnTjCj8eih+dFbDr1K5/eSk9BNqpOeA9n18E+hFMc149OTLQgVHjeouqSl0TNSXG3CJXIZkOSCupuXgoDoDItbls8yvZ4R4cos4LDOgyEcopB3p59+GY6NWE3/bW0mnXIVJf8VzGLi6tArBoTuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732754632; c=relaxed/simple;
	bh=FRVS2g+fG0f7ZYJIgFJENJzs0OeU6x/7e3vS+WJBqvk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zfp+MQD8seJtckNP8T8pCOP8tEcURspqeGvcOxke7rAgcWql+miVqQqySX4pomlHt/yiLqPaR8v/T4MUmj6c2CItr4dGjtTQXFTw0FDwlSPiOfPo2+DYttSG5LwBnVPzUi3AhDqenzpGhge5d21pKzu1OgzQsMzJM+bpVAIQ8Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vVv115pt; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e9ff7aa7eeso1145252a91.1
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732754631; x=1733359431; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wXSz7L/2gLB1nXVbSFWAt9DGwp25yrxYRtHtDBXMeOs=;
        b=vVv115ptRwEuNlic1gAJJK4/+kcJkoiMNDcKeiFEAhXkDWXrppTg3cdfvlZ3ZWb57z
         FXp/BWwPcJckC/DVW/m7sQkZU9oFLUA4zyonj2q+6IbknIDQJ3WBWjEDKnDXWP7+NNcJ
         sleNVJbXc/mqQCDP8TmNhOKSc4RlvfDZLq9GuAu44sHuvSYWHygpT06NVMbeaZ1Qw8db
         /SA5KGsFa3eQ68PDbGN5Kb2XPI2lI/Jw44wrhJ3XUhIN6Cv+SsI5QykUqp/vMdtE57Fk
         6mXa3sGUIXTydl4aXVTxyP6/93gpwzNefzBN+ns7JqN8ynbaKNoNKvJ0N90Toaz8qJaw
         7yHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732754631; x=1733359431;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wXSz7L/2gLB1nXVbSFWAt9DGwp25yrxYRtHtDBXMeOs=;
        b=efLRyW0kgRRef+TP8EBZyDvqGpldu5xkHYIZ3tIIdwpiC+OW3dPmpOo3cHuGeeiE+s
         9DyE+M/SKHOdqvCU3QI+kaC25bIUs0ABl0a9tuPugEX7J00SwHRW6NO9Gn6Ayy2tTOrO
         eS6nzxX/lXb5jeouJa1rknAZXfFlfi54aBklf/JDVUjvh0fhKICXuyRoHF/dAhDICdfS
         7fP9OUgGMkjaB0/ztTP4aLuOqlyy7K3xRbWc/fEQVZ+OHYwzP+eSjaLCbJ83oceZqWFl
         xvWvGxzFrd2qqPsbcDA7PLpMPvh+q99I4gBPvKERnAOgS/jpVQQ7vyNh4c4LJqorYUjc
         rj0Q==
X-Gm-Message-State: AOJu0Yz3LDg8/9MKuleBwe2nSi1oTS+IKcYalJYPitLeFwiX02tDNHZ8
	6Bin/zSNIOznNrkdqT7szspvTKFD7w2kYqKs4UUbpoAXKFJFrlP9GO/yOuN4iaKScDcVitH7jF4
	bFA==
X-Google-Smtp-Source: AGHT+IHtc6j3/IEkFk2MarwmYZptNoBmam/jKP/ZpVGuOWQAsWGuBBWLJG0GeFfwVxzsBB4VbyBz5vgvYEs=
X-Received: from pjbhl3.prod.google.com ([2002:a17:90b:1343:b0:2e5:ef8a:48c4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ad8d:b0:2d8:85fc:464c
 with SMTP id 98e67ed59e1d1-2ee25b3a158mr2128961a91.11.1732754630678; Wed, 27
 Nov 2024 16:43:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:43:40 -0800
In-Reply-To: <20241128004344.4072099-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128004344.4072099-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128004344.4072099-3-seanjc@google.com>
Subject: [PATCH v4 2/6] KVM: x86: Add a helper to check for user interception
 of KVM hypercalls
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Binbin Wu <binbin.wu@linux.intel.com>

Add and use user_exit_on_hypercall() to check if userspace wants to handle
a KVM hypercall instead of open-coding the logic everywhere.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
[sean: squash into one patch, keep explicit KVM_HC_MAP_GPA_RANGE check]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 arch/x86/kvm/x86.c     | 2 +-
 arch/x86/kvm/x86.h     | 5 +++++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 72674b8825c4..6ac6312c4d57 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3640,7 +3640,7 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
 		return 1; /* resume guest */
 	}
 
-	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
 		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
 		return 1; /* resume guest */
 	}
@@ -3723,7 +3723,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 	bool huge;
 	u64 gfn;
 
-	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
 		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
 		return 1;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b2fe4aa04a2..13fe5d6eb8f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10041,7 +10041,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 		u64 gpa = a0, npages = a1, attrs = a2;
 
 		ret = -KVM_ENOSYS;
-		if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE)))
+		if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE))
 			break;
 
 		if (!PAGE_ALIGNED(gpa) || !npages ||
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ec623d23d13d..45dd53284dbd 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -612,4 +612,9 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
+{
+	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
+}
+
 #endif
-- 
2.47.0.338.g60cca15819-goog


