Return-Path: <kvm+bounces-28271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A919970CE
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BD8FB256C1
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56806205E0B;
	Wed,  9 Oct 2024 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="icjC7PP7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55729204F78
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728489023; cv=none; b=EvyVqHRaOtO7bkPjDZvgRhI7nJF8y2aKMEWUjXyOSTiveuFKq9uSRN5KAdzPmDCZ/wJHEPOyWYekfFR3X26xyhxkIz7xxmvRARfgOvN2YgSZLmjPypS0aB8bA56OV9ckFXUQj6hL6+u9m9FYiuL5Hm8xD52vMkYWcrOTJbiYyAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728489023; c=relaxed/simple;
	bh=itS1mlB5ofbsTPJgxID6BNl/jc/V5lwuHkPPw41X7OE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B9yAUuP8xMcdM7H8vTMY94jXgUtlg8a1atvLjUx+RbmwaHuW3IUWeo7XGJR1gOof39LCgz4PR1Rw8fnOTYQ7VwerT+tkfDew289HrW96oNqb87E96pDaNtw2luSLIvqUs1/9+RVfu9T5iYshaZG9bYH4St1c5lwZPQereMXNW9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=icjC7PP7; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e3231725c9so103847b3.1
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728489020; x=1729093820; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HIeWF4AKDrrEZVf143SgWaofUVl00+qhbF3Z20PXTUE=;
        b=icjC7PP79stHSqasPNDzLPn/8fDaP9+O/ZBr8baTbexc2BiRHAE/aamlJuYaw69h9G
         OBbEV1FO2juBTxepKFTQINzYSissy2JL9RM9gErpQJ8lKbs+n6TuXamepmL2ESsDFU86
         498jv/bxBDya5muONfvcGyBnWJCc0jBwRtdb1hjnfA3AsN5Qfx+nAVhJIQng+peNeAOf
         1EghiUNqHDoJL9rdwwqdgTZqa+UM7zhtSSTIUsnJkVZo66Rkvn9ws82yZoty43a3motv
         3kYrZA9fJDVDVX/z5mujdyIasP8XS1dKQuDgPz8hbnf73j0bgapX72FHQEtweOhQOoFX
         HrxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728489020; x=1729093820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HIeWF4AKDrrEZVf143SgWaofUVl00+qhbF3Z20PXTUE=;
        b=j5F7bVMMWKTxcCNgYlB8Q1F4aRWJySkpH943ReafoavOCX1gHkxbWdHZ9SNUL9Wd1P
         o+Z/HirqxMX/twXutEOjydonYCJEsyaDtjdtBmWJOVZrjxY/AbzJ0XqeGpsEXvyqMeqI
         VqGZkRdoSl63sFBDVJ8JitdF9Z8RAHA9Xr94hB8GVvaDiDBrwk8rdm8euVEHLwkqeP0n
         Cxa5iDozsrfytTBFWzcJza/CTY264elhj5bvlkXKDYd6iVJjx/Dq37L5P8w5z53OEfQi
         Bub5XB8KLtRyTLLMl58VkBcS3irqDnNVlijInNT6WCZ4yq0ZyUWghMEVVDa5nzn31fZ7
         KLGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbiYaJdemmq1MdigBqwsuqsGpSvxJzb39+Lr5Dctd/du6PAv4XGZZ/fl+sY+hUt3xZduk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+W6R2RyYMTklQglvZUE6jJEaGKS5cJOin7WuuvjTZ5s80YxNX
	P4sGIiHQJnxONcrraIpVHqDad6mhUZRiIm+KJQLVk6Fu24c0F8DYSkBDcZmpn5oK8qeznAX1fIX
	1lQ==
X-Google-Smtp-Source: AGHT+IGckGzXTau4NGP/kAJ156CIPWl2QZt/eqMK5BUWyK8KyKg1g8Tc1FgMI3mqgA8yRsZ3clSiNLLsE+M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2093:b0:6d4:30f0:3a74 with SMTP id
 00721157ae682-6e322171640mr503647b3.6.1728489020502; Wed, 09 Oct 2024
 08:50:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  9 Oct 2024 08:49:51 -0700
In-Reply-To: <20241009154953.1073471-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc0.187.ge670bccf7e-goog
Message-ID: <20241009154953.1073471-13-seanjc@google.com>
Subject: [PATCH v3 12/14] KVM: selftests: Precisely limit the number of guest
 loops in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Run the exact number of guest loops required in mmu_stress_test instead
of looping indefinitely in anticipation of adding more stages that run
different code (e.g. reads instead of writes).

Reviewed-by: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 25 ++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 656a837c7f49..c6bf18cb7c89 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -20,12 +20,15 @@
 static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 {
 	uint64_t gpa;
+	int i;
 
-	for (;;) {
+	for (i = 0; i < 2; i++) {
 		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
 			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
-		GUEST_SYNC(0);
+		GUEST_SYNC(i);
 	}
+
+	GUEST_ASSERT(0);
 }
 
 struct vcpu_info {
@@ -52,10 +55,18 @@ static void rendezvous_with_boss(void)
 	}
 }
 
-static void run_vcpu(struct kvm_vcpu *vcpu)
+static void assert_sync_stage(struct kvm_vcpu *vcpu, int stage)
+{
+	struct ucall uc;
+
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
+	TEST_ASSERT_EQ(uc.args[1], stage);
+}
+
+static void run_vcpu(struct kvm_vcpu *vcpu, int stage)
 {
 	vcpu_run(vcpu);
-	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
+	assert_sync_stage(vcpu, stage);
 }
 
 static void *vcpu_worker(void *data)
@@ -69,7 +80,8 @@ static void *vcpu_worker(void *data)
 
 	rendezvous_with_boss();
 
-	run_vcpu(vcpu);
+	/* Stage 0, write all of guest memory. */
+	run_vcpu(vcpu, 0);
 	rendezvous_with_boss();
 #ifdef __x86_64__
 	vcpu_sregs_get(vcpu, &sregs);
@@ -79,7 +91,8 @@ static void *vcpu_worker(void *data)
 #endif
 	rendezvous_with_boss();
 
-	run_vcpu(vcpu);
+	/* Stage 1, re-write all of guest memory. */
+	run_vcpu(vcpu, 1);
 	rendezvous_with_boss();
 
 	return NULL;
-- 
2.47.0.rc0.187.ge670bccf7e-goog


