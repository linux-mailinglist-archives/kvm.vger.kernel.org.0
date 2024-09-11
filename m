Return-Path: <kvm+bounces-26585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7750B975BF9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 294521F21CFA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 20:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7011BE85C;
	Wed, 11 Sep 2024 20:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iTBkhlFJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514B11B9B46
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 20:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726087365; cv=none; b=rIS4ioY85kaNpWB78gwHDGXysbsXMGjJVkPPl+v7RdaWLoaq74xHXoDxhBNIrHS+Q7WDTwDF8rBWRQQQl+sk7Mw8h7bH4K5s+bxHgxYVpZdAFhnu5Un/VGC78p2etSh7HHMSw2isqx0OsbYarbuarMBFtEZi8sH2IYanQn16r9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726087365; c=relaxed/simple;
	bh=RjIjbK/O7AOXgjJl4H0U8PhhFXmA3gdfj48wRxxggdY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gLMlAALbbiHqDZJApa1wN2G/15esHCHDiSGRr8bUAHfFCY3A2YCbf+lPzyCpv67y1PTKWucqBcuOa2I13AlAOVGYy1Zu3Mr1FGHNvWqXOLCpmXJ9nEZww/zLktNRhFXir9/Tw0uPKmxsE1/KNrGAbEMLoSuACj26zA6bLCh+NYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iTBkhlFJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2d87b7618d3so340041a91.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 13:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726087363; x=1726692163; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bmoPUX+JXjpnDZGI5p6xMsNQ8aqKvxbSE8GAbeQD0ic=;
        b=iTBkhlFJ653J/8UGf2qMVfsdiF3zELdIPjzeJSKo++keIaFQcQpV/WWrMNwpCeKNaV
         0CbXJebXEcGM0HUVwkuwyF8A3dMwaW+nE5Ajb5/diKF19l80LBny9lSg3E095m/AnXow
         gaKdy74S0dtFkAo34nDxA2KYpZl2IK/03My4mOXiHm+u7s7/RbVLLAlq7D6bAsI2GKYb
         frZ5+CMtj7dEJz1MNq8rsDpEck1ELJpFlOvO8/H91t1bCHb9vYhwwwf7O9Lf0DFuU5C0
         ixyZonKiJNVpnoVrymsqqzeiW+PbMc5JocyPwTHsdT3xY+NXHmN2x7WuFDiynYfF+meM
         Drhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726087363; x=1726692163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bmoPUX+JXjpnDZGI5p6xMsNQ8aqKvxbSE8GAbeQD0ic=;
        b=gjPZab9lcSaiTc0qnTl67GdDJ45GBfk/jgcL27QzsLP0wDtb2p8quRJ+coI69g7jEM
         D415iGdEDwVYxGXbAnjhUL3F3T4u2+32V1Qpv1c6D3tuuAdvFenTtLSroAYee++TSu6o
         PyUyeZPd4XMEt0NqhDLZemEIysRPLW4/HNtjfUhJrwA5YWZL3C5VKw76k1CsuV7vzM99
         QAPGkzSaydG9ZrWfZACuV4roTfG0bxJj/8WUL7jxij7gmd/2YnVNd6bK033SL8W+kn5y
         HVfNDV4oti+q1Izt7u0rCDai6u0HZ0ZmXpr9M2QjQuJNT4D3iga6vtuK6CFSqIJoipXX
         cSJg==
X-Forwarded-Encrypted: i=1; AJvYcCWdmBIw2qOp5U4pUCHBxYi2OF7LvYwlczJt6yIfyy8MJyOkPUz3vBlIlyW+JwlzfGfbEEI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHt2vfMmb/aFGw22WJ1ifur73wJXDern24zz4ILNz9sgBXcJ13
	H0nGZ4IWJx2W9rIOHS0Bm71KBdJpBITtXriScexxe4K1hdT726mnQ5qU83HFO7dGNg4qG+1eHLF
	PkQ==
X-Google-Smtp-Source: AGHT+IFejIMeELuVO8txo5UGwYsGrFXhMhJbdLyClaj2asDasqbAOd2Ag+P6eX01VQr2edSnhAi2+MXrYfY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:710:b0:2d8:a9a0:3615 with SMTP id
 98e67ed59e1d1-2dba005b566mr856a91.8.1726087363354; Wed, 11 Sep 2024 13:42:43
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Sep 2024 13:41:56 -0700
In-Reply-To: <20240911204158.2034295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240911204158.2034295-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240911204158.2034295-12-seanjc@google.com>
Subject: [PATCH v2 11/13] KVM: selftests: Precisely limit the number of guest
 loops in mmu_stress_test
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

Run the exact number of guest loops required in mmu_stress_test instead
of looping indefinitely in anticipation of adding more stages that run
different code (e.g. reads instead of writes).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/mmu_stress_test.c | 25 ++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index 80863e8290db..9573ed0e696d 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -19,12 +19,15 @@
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
@@ -51,10 +54,18 @@ static void rendezvous_with_boss(void)
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
@@ -68,7 +79,8 @@ static void *vcpu_worker(void *data)
 
 	rendezvous_with_boss();
 
-	run_vcpu(vcpu);
+	/* Stage 0, write all of guest memory. */
+	run_vcpu(vcpu, 0);
 	rendezvous_with_boss();
 #ifdef __x86_64__
 	vcpu_sregs_get(vcpu, &sregs);
@@ -78,7 +90,8 @@ static void *vcpu_worker(void *data)
 #endif
 	rendezvous_with_boss();
 
-	run_vcpu(vcpu);
+	/* Stage 1, re-write all of guest memory. */
+	run_vcpu(vcpu, 1);
 	rendezvous_with_boss();
 
 	return NULL;
-- 
2.46.0.598.g6f2099f65c-goog


