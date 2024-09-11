Return-Path: <kvm+bounces-26581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9116C975BF1
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 595DA2830FB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23801BD50F;
	Wed, 11 Sep 2024 20:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MtGCBl3Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8681BD03B
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087357; cv=none; b=dOVJgJiw6KuJiJm52YPVEZu30Rb5aP0M4UyUytpDWyUj9bQsU4RNKY6qrbvfCMhRiZjK7CGKd32IfG4qSawVo7jZFjuq4MiYuKJbt42PU2ic+RZ5CEbHJJ0gaBy+kmduITM/SCq8k1mwjT4r47/IEtS5sDAj1k93ltI0GNFy7cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087357; c=relaxed/simple;
	bh=9BzyYeYR+XG9DqVDsSkYPxqvMFHUbhRYSHXP8tVaSKk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GrRf2c/Vj1yO49QsCFGpQObdexZWpVmuSqEhJcqSv7lhT+XvvUIeAXBqbBQv8QNPAhG+o2CNt3yzMHPqaz4s8Qj6wW4ABJV0AGLdCCFjiTPSI8a8i/uy2XSKrDTWbXZDAu6OXdMHlSoDIbYO3SQlFwuWqrvlb1XTbLOQRW9ZgrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MtGCBl3Z; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b47ff8a5c4so13682567b3.2
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087355; x=1726692155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mDeUl+tBis0dtonBgnOqcF+rjd+/029ZvfofLpY6Be0=;
        b=MtGCBl3Z6W/CVToh1/SufPs65i7e3nmvVlQOyWOYUFBtnxZlyocSMPAz/tuPnYN+wK
         0dvGMnuQ6I38g+pcBfZlG4jgCA6IXkMDHnX83SG903fdlYH2hlzJhA4gB/lXuga528bC
         6kiW2XiNpllBm7wRi5UiBA1v5EM88ssIOdSvIN9D7GvhL1m8T811T5BJqnu7H9ZhV4T3
         aEJA8/7XJYMzxp9xrGIwC5N6dxoaFQWQYHm8/H+LSUr6VrI2zKd0RCvTmBGLABBvpJmy
         oK3EV+A4LIxBdWfok3DATc20YMm6BWHrAshaqMcx5LFrj56wa3TZ3JRl4X6DIIIBLJ14
         0I5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087355; x=1726692155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mDeUl+tBis0dtonBgnOqcF+rjd+/029ZvfofLpY6Be0=;
        b=PJ4klNVQhJ3YB3+dmWdp4Mmssg5A9/muvr3g+XHCWgawtBP4e+i7Hr8c9Sajlv6ngb
         zGpJu2KWimo62kKHKk85KQhZO056XraW0a5F2rRbD1diuEt3QYPRq7y6f6e8MPUH7FnN
         3dC4+WkGOz1rUJui5rqQkGvTQJ3Gk59wl2FESPCi2pD8X15I6Ed6Qu2A3jXmfR1XrI0z
         9RzE+np519noiQWrPiNzkRPQp0dDiupJsMxQoD95u1SN1E626vWdZjU6rXmjfH1OYowl
         CtgCtrjKm5q1qMM5KDA2noIDzmi3oypFU4rexMjkkpnpbxZ04GZXN1M2PaEoOtYS2brE
         9YfQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8AhnynLTukAjZs7eWlb81sdWG+cRZzuUidUuIitgvFHv25Al0vV4Mzmfq4KUUycVq/zA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr3Apbnmu76a/WuxIOYfKpArfT0Zk0GwBFVK7un01UoUkFvK/I
	oCfQQy5tJcANcpKHuox2NWffb0/ZhAB3FE91PxidZxRsHhOcVOwUAU3pf6WVLSsk6fG6p41MxuO
	+qw==
X-Google-Smtp-Source: AGHT+IGxqix6H/PLMvvIcFrC3JMaLMXEJXlPHwcg40gW3P6CGrRnyhAhRYR7DkVEhB/fpO0WlA4G6vBj/5E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9108:0:b0:e16:4e62:8a17 with SMTP id
 3f1490d57ef6-e1d9db9ca04mr3916276.2.1726087355066; Wed, 11 Sep 2024 13:42:35
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:52 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-8-seanjc@google.com>
Subject: [PATCH v2 07/13] KVM: selftests: Only muck with SREGS on x86 in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Try to get/set SREGS in mmu_stress_test only when running on x86, as the
ioctls are supported only by x86 and PPC, and the latter doesn't yet
support KVM selftests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 0b9678858b6d..847da23ec1b1 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -59,10 +59,10 @@ static void run_vcpu(struct kvm_vcpu *vcpu)
 
 static void *vcpu_worker(void *data)
 {
+	struct kvm_sregs __maybe_unused sregs;
 	struct vcpu_info *info = data;
 	struct kvm_vcpu *vcpu = info->vcpu;
 	struct kvm_vm *vm = vcpu->vm;
-	struct kvm_sregs sregs;
 
 	vcpu_args_set(vcpu, 3, info->start_gpa, info->end_gpa, vm->page_size);
 
@@ -70,12 +70,12 @@ static void *vcpu_worker(void *data)
 
 	run_vcpu(vcpu);
 	rendezvous_with_boss();
+#ifdef __x86_64__
 	vcpu_sregs_get(vcpu, &sregs);
-#ifdef __x86_64__
 	/* Toggle CR0.WP to trigger a MMU context reset. */
 	sregs.cr0 ^= X86_CR0_WP;
-#endif
 	vcpu_sregs_set(vcpu, &sregs);
+#endif
 	rendezvous_with_boss();
 
 	run_vcpu(vcpu);
-- 
2.46.0.598.g6f2099f65c-goog


