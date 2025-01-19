Return-Path: <kvm+bounces-35925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC2CEA162E6
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2025 17:28:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD5501649C3
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2025 16:28:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65BDA1DF74E;
	Sun, 19 Jan 2025 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=sslab.ics.keio.ac.jp header.i=@sslab.ics.keio.ac.jp header.b="DiXTQZFH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700C01552E3
	for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 16:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737304087; cv=none; b=p0BIo1yvoO+RbPuuIJxKQ+3GiRTgDscRsr5DCC2y6O95MOkNB6BXu8es9xw9YzhMDNQAfLI5//AXZLL6GMpXZI5cCmAOl8sw9Cj0gzYqdxDziV5rH1t1ers+rRw+7AN0oZPtsH+nr4UcCEr1Gz6vBBC/IXdpxQQysQ8KR6sOT6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737304087; c=relaxed/simple;
	bh=/4si3pI3PSm7YJqMDJWO6oO0UM+zHDLK1aDous38f4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f7KVak32V7GDQZBS8eNoBt5N0GJU1TWMiuRR2fxk05n4Uajvanvu0JDl8EkPtNGC9624j6e+2JjRpbwsRvWiGYrGHRHKHqvQJbVcv7zWxYZSNy9vYvdoYQGJggrg3bMpxE55UHrXghDOr19POLt1dkjhEIvoRsistS6Fr8Q26tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sslab.ics.keio.ac.jp; spf=none smtp.mailfrom=sslab.ics.keio.ac.jp; dkim=pass (1024-bit key) header.d=sslab.ics.keio.ac.jp header.i=@sslab.ics.keio.ac.jp header.b=DiXTQZFH; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sslab.ics.keio.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sslab.ics.keio.ac.jp
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f43d17b0e3so6729874a91.0
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2025 08:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google; t=1737304084; x=1737908884; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=snZH8XfRlyi2k+V8MAtXkadSoU1vzCD/EgFRaVm518E=;
        b=DiXTQZFHMTZKyNQbIJTHbkpeqoj93A875vvYHxanS3OX36REbKP5mZE3CGs+jDi8pw
         38NbzlHDVt7twPpHPKY7jxqbmx5xxZBcfG7Hd5wlFXqwOocY9d4MajcFI2aAxIjLZZmj
         lMH9rApIS0IbgeM4DnSeHlFnoiZWfd/DnsScQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737304084; x=1737908884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=snZH8XfRlyi2k+V8MAtXkadSoU1vzCD/EgFRaVm518E=;
        b=Zw/ZNrATI71s3WD3MqkF08XORlmpSFyDysiYEaanMa8OftbFGCdZxyFnoluw3+O2S/
         vDQExHitJo7cQWmqDiKyc9j1+pv/COStr1XJt0NbIzfinGdKAtaW1ZylMExA+Hub2k4j
         OscVnprV5htaI3Q+jEiC28JIxMLMLgFLDStsm9Bs7gF49Oy4KRRhvGCvOJkrLm33pdwg
         3PyRY/0C2OAewXbk09NNf3lc1uzGYxlWHK0znqXKu7sBBT6aPGQh9z8AmBsKPDLDAAD+
         4frwi7xRHXZxDA7qcG24GJOXHJxlB8/RITJypgzcRg4RU5nCwZmJaJLEKOlEtEoEkSOM
         8fJA==
X-Forwarded-Encrypted: i=1; AJvYcCWQkLS9M8wDklpiGriBp3a+ZUGhjc0LVltn6DsFm8jq1kLdSZjuPP03Ezu9jNy1NlUrRVc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRlySFFcDSqaSdcxTCQ9ksz3uaoFA3TZYY3PEm8yjlOs736DEK
	zr2WaGslqR36kJSBw9kSg/a1oB8nE56bbE3IqKVnDnsDVdCd/DH/k3WKNkm4Fd8=
X-Gm-Gg: ASbGncstLadDg/kxGCxIkFRlBwevg3JesvOjf3DbdT5p/TgUkn+3xIozZ9c9ufTOONH
	Dz1o0cjkWo5CqQWpI8XZyR51F2YnXWHJCwVHu0fsZYo/cA589YnoZeXYLPsAaA+yW3KI2QMRW5H
	Vq4kmfbqiBqfkmsmF4nM0LeLKq8/LkAZklUBRhR/Z6Y8UIXqDQFLs4GEWxJbz2CSPI36sJeYzzf
	gtjeI0DsefgIWomfQV3Ees6ZwYfgQ1bRxrXImHpR3pgnu7ielSEJ/rVBsnYJslsJJ4FkXmcX6jp
	GiLV/RUoX7vGKH2PHBhS2N8H6spXN38=
X-Google-Smtp-Source: AGHT+IEW4ntUF55sqc+yIS9AXd8mkMN5CUu4fCQ4/TxEXUT1tq/21UzBAuqtCWeYuX8sM8+h7I9DAA==
X-Received: by 2002:a05:6a21:7886:b0:1e1:ae9a:6311 with SMTP id adf61e73a8af0-1eb21479b92mr12731205637.4.1737304084528;
        Sun, 19 Jan 2025 08:28:04 -0800 (PST)
Received: from saraba.tapir-shark.ts.net ([131.113.100.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dab7f190fsm5391625b3a.26.2025.01.19.08.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2025 08:28:04 -0800 (PST)
From: Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
To: seanjc@google.com
Cc: kentaishiguro@sslab.ics.keio.ac.jp,
	kvm@vger.kernel.org,
	pbonzini@redhat.com,
	vkuznets@redhat.com
Subject: Re: [RFC] Para-virtualized TLB flush for PV-waiting vCPUs
Date: Mon, 20 Jan 2025 01:27:49 +0900
Message-Id: <20250119162749.665030-1-kentaishiguro@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <Z4rM2abMZvurfFDO@google.com>
References: <Z4rM2abMZvurfFDO@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thank you for your comments.
I understood the scenario of why my previous change was unsafe.

Also, I like the concept of KVM_VCPU_IN_HOST for tracking whether a vCPU is
scheduled out because it can be helpful to understand the vCPU's situation
from guests.

I have tested the attached changes, but I found that the performance
improvement was somewhat limited. The boundary-checking code prevents
KVM from setting KVM_VCPU_IN_HOST and KVM_VCPU_PREEMPTED, which may be
contributing to this limitation.  I think this is a conservative
approach to avoid using stale TLB entries.
I referred to this patch:
https://lore.kernel.org/lkml/20220614021116.1101331-1-sashal@kernel.org/
Since PV waiting causes the most significant overhead, is it possible to
allow guests to perform PV flush if vCPUs are PV waiting and scheduled out?

> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index a1efa7907a0b..e3a6e6ecf70b 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -70,6 +70,7 @@ struct kvm_steal_time {
>  
>  #define KVM_VCPU_PREEMPTED          (1 << 0)
>  #define KVM_VCPU_FLUSH_TLB          (1 << 1)
> +#define KVM_VCPU_IN_HOST           (1 << 2)
>  
>  #define KVM_CLOCK_PAIRING_WALLCLOCK 0
>  struct kvm_clock_pairing {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index acdd72e89bb0..5e3dc209e86c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5018,8 +5018,11 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>         struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
>         struct kvm_steal_time __user *st;
>         struct kvm_memslots *slots;
> -       static const u8 preempted = KVM_VCPU_PREEMPTED;
>         gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> +       u8 preempted = KVM_VCPU_IN_HOST;
> +
> +       if (vcpu->preempted)
> +               preempted |= KVM_VCPU_PREEMPTED;
>  
>         /*
>          * The vCPU can be marked preempted if and only if the VM-Exit was on
> @@ -5037,7 +5040,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>         if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
>                 return;
>  
> -       if (vcpu->arch.st.preempted)
> +       if (vcpu->arch.st.preempted == preempted)
This code may clear KVM_VCPU_FLUSH_TLB.
https://lore.kernel.org/lkml/20200803121849.869521189@linuxfoundation.org/
>                 return;
>  
>         /* This happens on process exit */
> @@ -5055,7 +5058,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>         BUILD_BUG_ON(sizeof(st->preempted) != sizeof(preempted));
>  
>         if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
> -               vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
> +               vcpu->arch.st.preempted = preempted;
>  
>         mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
>  }
> @@ -5064,7 +5067,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>         int idx;
>  
> -       if (vcpu->preempted) {
> +       if (vcpu->preempted || !kvm_xen_msr_enabled(vcpu->kvm)) {
>                 /*
>                  * Assume protected guests are in-kernel.  Inefficient yielding
>                  * due to false positives is preferable to never yielding due



---
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kernel/kvm.c                |  2 +-
 arch/x86/kvm/x86.c                   | 11 +++++++----
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index a1efa7907a0b..6ef06c3f234b 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -70,6 +70,7 @@ struct kvm_steal_time {
 
 #define KVM_VCPU_PREEMPTED          (1 << 0)
 #define KVM_VCPU_FLUSH_TLB          (1 << 1)
+#define KVM_VCPU_IN_HOST           (1 << 2)
 
 #define KVM_CLOCK_PAIRING_WALLCLOCK 0
 struct kvm_clock_pairing {
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 21e9e4845354..17ea1111a158 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -668,7 +668,7 @@ static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
 		 */
 		src = &per_cpu(steal_time, cpu);
 		state = READ_ONCE(src->preempted);
-		if ((state & KVM_VCPU_PREEMPTED)) {
+		if ((state & KVM_VCPU_PREEMPTED) || (state & KVM_VCPU_IN_HOST)) {
 			if (try_cmpxchg(&src->preempted, &state,
 					state | KVM_VCPU_FLUSH_TLB))
 				__cpumask_clear_cpu(cpu, flushmask);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c79a8cc57ba4..27b558ae1ad2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5019,8 +5019,11 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
 	struct kvm_steal_time __user *st;
 	struct kvm_memslots *slots;
-	static const u8 preempted = KVM_VCPU_PREEMPTED;
 	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
+	u8 preempted = KVM_VCPU_IN_HOST;
+
+	if (vcpu->preempted)
+		preempted |= KVM_VCPU_PREEMPTED;
 
 	/*
 	 * The vCPU can be marked preempted if and only if the VM-Exit was on
@@ -5038,7 +5041,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
-	if (vcpu->arch.st.preempted)
+	if (vcpu->arch.st.preempted == preempted)
 		return;
 
 	/* This happens on process exit */
@@ -5056,7 +5059,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(sizeof(st->preempted) != sizeof(preempted));
 
 	if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
-		vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
+		vcpu->arch.st.preempted = preempted;
 
 	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
@@ -5065,7 +5068,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
-	if (vcpu->preempted) {
+	if (vcpu->preempted || !kvm_xen_msr_enabled(vcpu->kvm)) {
 		/*
 		 * Assume protected guests are in-kernel.  Inefficient yielding
 		 * due to false positives is preferable to never yielding due
-- 
2.25.1


