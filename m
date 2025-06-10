Return-Path: <kvm+bounces-48905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E26FAAD4656
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8324B3A6A19
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7DF2E62A4;
	Tue, 10 Jun 2025 22:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TYFxWtZh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D90328F508
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 22:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749596298; cv=none; b=SN8dV87oiNJmeQQ6SYrSzrM/i2cJscI3tmHyfs1oSrJ/jIbmLNZ0v0HFyp0MVI6COnoSlhksqCi3E3QeQL1zQMoQwEo2EVmRIc+rumi1y8YBELsXkQ2R9TXUANpqDWroEQrVFotAjzbl+KRJOcLtjx4m/nh1M9kPv+JMKXM5hGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749596298; c=relaxed/simple;
	bh=mf4dGNQEE8Vf3ZN6CsMJb1C98fQ9dcsST+qQnEYPAdU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DOEiFKEQrxUJYeNqic1WJ0hmSA/xMLuuoKyAMFaayszC8KHbyMoPig8HwIzRL+DRsK1kaRR0EwfoiI8WgGZ3WKjVQkwmgcAg6j7jjsKFAtnrjy0eemt3mYG4UB2aeQQFzjIyMYQr0oH9Qo2XSs5Gv2dyvI1UYfsR7V6h5p6tYz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TYFxWtZh; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26e73d375aso6679971a12.2
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 15:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749596296; x=1750201096; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=INqA6pUbqyUB4M6DLfIPSDW1OsxCHPz49HW15Ivf0MI=;
        b=TYFxWtZhS3UkwVoUHispTjmFhiytbSw1yoLwYsSG8jq9oCyDdDTVbYt1ku00dzAJaH
         FDzOgJUB7PeX3tfUwisjQPCI44moy/z8o34SVYW5k2hK2O5ZMvZxht9k/TYXCCFmEUYO
         a2iUVY9Gt+g7R4YIKfn59y7KEwgkbuZDKBZGjdn3h3WnmwzDCYopWvegT54crGMQka9F
         /sf75/eVg1mhl1/B6J/6YJc7ugn9zjSbVheUXKVVunIHwCxWNVV+QvcCM4rIODyZL1gw
         2vb+6ALvzIX0bsAoFtevs6fKwSJ8vxSwQqdrsYAxBb/Dpg/97pLekMxq2cqSioBU66+x
         ci4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749596296; x=1750201096;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=INqA6pUbqyUB4M6DLfIPSDW1OsxCHPz49HW15Ivf0MI=;
        b=iE2ay1z6ckprxaoqg4tLJhBy8vli/b0l0EFqZsxiLvBFUtqtZpqvvUsxcXA8RCZFb6
         7uyPd1RrFG8qKpP3pMWmdqMB+4rL/iFzUCkbwdPhsS6NFEDCP1rngsVjjaA5dISFvoxe
         2TvZ2YxWyGfBvc6OPkaElVc5p16UCQpihj3usQoMqCd1kxZxyvBI8PQyDQIAvZgpDcCE
         VMmALccjL4XUPgbmQNwiGyQKKFBWsfeUZtRjdsKKlAF2ahLz26No8Jd0yUXVMiPrZlbl
         zmTxUjI0Ai/tU0KUW+vkqHU5kK3uZYIAWSB94WQ+ZMcofsu9qNACJdwj1haD9TiwmMir
         ZdDw==
X-Gm-Message-State: AOJu0YxMyfmPV3jWCp8KcVYvRhNdP7JUg506G21lXpRa4Gc9WHF92YAL
	imDuJGmUqax6uZOOhnSBtnAnFjV3GMPvJz/J2WBQ1PQzVE0tv5XNqnnytWAL6M3B9Ram5dm8BBw
	mPs8iCw==
X-Google-Smtp-Source: AGHT+IHMOEDiNlakcTKi0BqXOdIFD8cp9FnOaD9FdZ/5gIz3n4JAB+77v2pAu2xRBZ27EtExAHgRcKJEqgA=
X-Received: from pfnj12.prod.google.com ([2002:aa7:83cc:0:b0:746:32ee:a305])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9993:b0:21d:3635:548b
 with SMTP id adf61e73a8af0-21f890eac3cmr787123637.32.1749596296356; Tue, 10
 Jun 2025 15:58:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 15:57:26 -0700
In-Reply-To: <20250610225737.156318-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610225737.156318-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610225737.156318-22-seanjc@google.com>
Subject: [PATCH v2 21/32] KVM: SVM: Rename init_vmcb_after_set_cpuid() to make
 it intercepts specific
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	Manali Shukla <Manali.Shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"

Rename init_vmcb_after_set_cpuid() to svm_recalc_intercepts_after_set_cpuid()
to more precisely describe its role.  Strictly speaking, the name isn't
perfect as toggling virtual VM{LOAD,SAVE} is arguably not recalculating an
intercept, but practically speaking it's close enough.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 710bc5f965dc..1e3250ed2954 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1103,7 +1103,7 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 	}
 }
 
-static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
+static void svm_recalc_intercepts_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -1269,7 +1269,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		sev_init_vmcb(svm);
 
 	svm_hv_init_vmcb(vmcb);
-	init_vmcb_after_set_cpuid(vcpu);
+
+	svm_recalc_intercepts_after_set_cpuid(vcpu);
 
 	vmcb_mark_all_dirty(vmcb);
 
@@ -4518,7 +4519,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
 
-	init_vmcb_after_set_cpuid(vcpu);
+	svm_recalc_intercepts_after_set_cpuid(vcpu);
 }
 
 static bool svm_has_wbinvd_exit(void)
-- 
2.50.0.rc0.642.g800a2b2222-goog


