Return-Path: <kvm+bounces-32620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5B39DAFED
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:47:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E045165B38
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40891990C5;
	Wed, 27 Nov 2024 23:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sQyitDF/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707E5139D07
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 23:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732751223; cv=none; b=RQ6gL9Brjl09HtrIuuQotOYy6+oxSHXsBoZjgs3WHnKAVA2TaDEskYRb2+a3m/YngsmboY6afyMt/FnQHPqmJ9on4zgEzNq/FOVxbc1fp/0zgcX08Qe3uvOuNsTCjp+4tDSz7DjdPQ9CjYGi1Z26idlQobkh2TVriCACHpSQFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732751223; c=relaxed/simple;
	bh=nd3J865/YZ+2VEz7ghltJB+9oC6ZlC3mBxeZJDrtEh0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Vy1m1tIbSf5IwtH3hg5afDsANejuJcfq9iM08BchKzlwFmXSWNvALNq9vVhwBJiPgm4t1+XutRv5hKXPHcTxUDNP+axdtvvZq+KN6oefIdSjiidwIXb3rLZWW6L6HyodH+Dre6GeBBaZjy2N1vdZiUYyw7sgxHb6LsjJnyCpPmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sQyitDF/; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ea69eeb659so158494a12.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 15:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732751222; x=1733356022; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PIulGb3qmhZUHKLGlDgu3ych7aY/kTKi7wptAAkUHH4=;
        b=sQyitDF/OkqWa7Zjai6v2DSN9JI1ZMP+c9yRQ28QWL09S8a5PqdHkkS0hvr4oKC+Bh
         AmUJJPdIcp873jRhDqO5cSxNEYPSf1X4ndIHMdJTLPlwJ2GkrqzYyr1q++4ANQj8Zopo
         /XFJ6q6a0jQSJGXfOYZfSY+RMfV52jl7A2NR+H/6yt2W3KliydRF702cBp0DmmhFcfEQ
         TrH4dfz+tRvMu7trINdeDTDLw8oMMCAxkFF24H0dALTNuLMXJyXvWqpqi9emgDsmiPJ1
         vCWxFrfNu0jcNVSX5UQI/WVmEhC3yT6Qb4u0LleMJTbdRMQpybGy0AAs5RVVtq8ptkTZ
         5bXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732751222; x=1733356022;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PIulGb3qmhZUHKLGlDgu3ych7aY/kTKi7wptAAkUHH4=;
        b=eGh9NW54mU+oRqmjHLJkEh0RK3Vhv8uns2WxCtupk1JkB1G0ffneFDXne1shYRZxZz
         7xtf6pWs1wXZ0ymJoWUBj878AgffaloDKbo3dfJdiOZYEjLMsDPSByCVtEo2udQCRTfn
         ve8mLpy9bvjoX3M6+nuDhFgao6fxxR6kWAMlA4Px5zLp1UFNsEDC+ytKcNwP7jOLdtej
         4n80F4TTwS6S0+wIqlZJWLuoxoEk18mEeH5LAIPUoeihGVH87Z/HqB/IZ3837L4xAC2i
         DL5ejiLl7Ye++rtV36btvAnfWLP8rv3Qpt5WAMlL+iQiZND/gTpi9GICoDYE1bbidAWu
         oCrw==
X-Gm-Message-State: AOJu0YxT0wbwheqvdDYMsGv6Fi5GGmARzx8N2oMmUIq/tkCB98WWriHl
	+oTn5TFTQ1Ng821pok6RYYQQCTaTWK1u5Sm2ebL4Npj5cCO0Ka0omIImy/lmzV4nTeo1zqL3ic/
	2sw==
X-Google-Smtp-Source: AGHT+IEBfEA3SFEJ/e7q4DLhCeeHP2mhmWlaClqCNg6lR6N/PIHK+FBp/M05m9sAjCkl7gaROt6CrfMX15c=
X-Received: from pgbcw5.prod.google.com ([2002:a05:6a02:4285:b0:7fc:1f6a:c14a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2583:b0:1e0:d380:fe71
 with SMTP id adf61e73a8af0-1e0e09e2467mr8155703637.0.1732751221766; Wed, 27
 Nov 2024 15:47:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 15:46:59 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241127234659.4046347-1-seanjc@google.com>
Subject: [PATCH] KVM: SVM: Macrofy SEV=n versions of sev_xxx_guest()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Define sev_{,es_,snp_}guest() as "false" when SEV is disabled via Kconfig,
i.e. when CONFIG_KVM_AMD_SEV=n.  Despite the helpers being __always_inline,
gcc-12 is somehow incapable of realizing that the return value is a
compile-time constant and generates sub-optimal code.

Opportunistically clump the paths together to reduce the amount of
ifdeffery.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.h | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 43fa6a16eb19..2f5d8b105eb0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -358,39 +358,32 @@ static __always_inline struct kvm_sev_info *to_kvm_sev_info(struct kvm *kvm)
 	return &to_kvm_svm(kvm)->sev_info;
 }
 
+#ifdef CONFIG_KVM_AMD_SEV
 static __always_inline bool sev_guest(struct kvm *kvm)
 {
-#ifdef CONFIG_KVM_AMD_SEV
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 
 	return sev->active;
-#else
-	return false;
-#endif
 }
-
 static __always_inline bool sev_es_guest(struct kvm *kvm)
 {
-#ifdef CONFIG_KVM_AMD_SEV
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 
 	return sev->es_active && !WARN_ON_ONCE(!sev->active);
-#else
-	return false;
-#endif
 }
 
 static __always_inline bool sev_snp_guest(struct kvm *kvm)
 {
-#ifdef CONFIG_KVM_AMD_SEV
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 
 	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
 	       !WARN_ON_ONCE(!sev_es_guest(kvm));
+}
 #else
-	return false;
+#define sev_guest(kvm) false
+#define sev_es_guest(kvm) false
+#define sev_snp_guest(kvm) false
 #endif
-}
 
 static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
 {

base-commit: 4d911c7abee56771b0219a9fbf0120d06bdc9c14
-- 
2.47.0.338.g60cca15819-goog


