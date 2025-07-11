Return-Path: <kvm+bounces-52074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D42E2B0101B
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 02:17:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 227905C202D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 00:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364BEA937;
	Fri, 11 Jul 2025 00:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C9LpqlqV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBD310E9
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 00:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752193066; cv=none; b=AdnupMeWZsifl/j0eiWeQ9na52k31otliTLanpcqXEChsOmkkjLGC1uHwl1Cx+09pYlWBjD+zvqb92pqMDaD1oaHDjr9O31+HnE89HAovxI/X9ktkOUZSJ0y9kbzpks0qEYe1PTjyeQVj/BsAo9dySBwg6Bx81H0AFoNL+0Ocgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752193066; c=relaxed/simple;
	bh=gzuJyy5LPOLZLpUEIrwAAEyUavZJ21RHRnkuzHpL1Ww=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Rsze23urSlb9A2SSnpII6jC/TWJnvNlI8mH35JwE5SlzlF+585s61NcbCmhSmn05qTfGSgdvyiUxPaOezWTLjlaEy5XAE3RffxNmNVSgWlQAT0lQ9AZ4kfucvyb6psir7g+OMCVh14txRbHWio21h0q2qHMxM/GM6YAMCoohCtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C9LpqlqV; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2382607509fso8778605ad.3
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 17:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752193064; x=1752797864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KTm8ocd8HMxz4+WBaGOnNEf1mS7UKR80R4y8U9u2Fb4=;
        b=C9LpqlqVdDo3aOuF9kd0Kptap2iX93uJ8r/sIvhuG7ILpy2FYoL4TDrfkz49STjIVD
         OvhuxbEMHYeKiayMRppYqtRSlolwJ+ruO+eB3XtxBdLKPUjpeojrdB96BNR1v9FVrh4J
         OwvAfx94Il/mL61w01m2wiOkbHBZxplEyTPuE5lso/35L6t9cnaHRlIFRprLBh7TlbGs
         o2uHtDJKuMdpXXsjpL3PZNcAsYa8cqVfxL8u1G1W4N9dvyUawh7+5TMQm5FR72s9ANpu
         02IkFEHPPY/LW/jiGdOvODuuH9SZIYPoVeMHiNxLn64ix69AwpLU9/keOAKMzI2kQwJ0
         kapA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752193064; x=1752797864;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KTm8ocd8HMxz4+WBaGOnNEf1mS7UKR80R4y8U9u2Fb4=;
        b=jtfRiAJr88cjguLpT0x51OBNE3jKd8FH1P8nlFRjuWmgWenEL11YDB8rEFh1/q8SRV
         S1xWBn/S4OsCL6IsVEal5Zbp4l4qaSw1teLjsyIaYyS2J88YvFn6irzc5CO3EcVLT2TV
         jf/ciAYkIjq1s1ORsnFWXAK/SDMx/FwkfJxnMrxU6VBiVGYvqbEW84yMaWS/GwwdqHks
         fpiQG4gGwpWKIIexWdjFvP5UgsyoJYzWiq1sg+SqhoZQsydl+o9KP2fe44heYcRy4VBB
         dcZk8/7Y+bbDjpfYTn00A88QjwjF77nmhyQw0nit8MhxXZCiyGzmYqFqNExym+UfBOIu
         u54A==
X-Forwarded-Encrypted: i=1; AJvYcCV5cdrucoKO1jzGSNKmFZ3l+My4TBZbZ8CBRVX2OvmlhhGYHVf222uQvwQ11/ibX8+dUgg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwQe3lYHlryIZIEbM8nVfy7gF0E8GRLqnQU3KyiBxQggnmVjrb
	W7pAuJjPNlGH+koPvKdnlNTTSCVlgbpY0n4+0wGhGEXrRgQNyeb31WNbKgd5TGSdA2/bsmXysFc
	AI1aSY6ASJzq++tXli334aQ==
X-Google-Smtp-Source: AGHT+IEIEyMnGAkXk3IBWC3l9C1RTrV75MlmJIaaSbleQAMN8HR1ryUd9jJFTByosBEiTXMioDNXiQEzUSGyv05h
X-Received: from pjbss13.prod.google.com ([2002:a17:90b:2ecd:b0:313:285a:5547])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ebc9:b0:226:38ff:1d6a with SMTP id d9443c01a7336-23dede2d365mr13878775ad.7.1752193064378;
 Thu, 10 Jul 2025 17:17:44 -0700 (PDT)
Date: Fri, 11 Jul 2025 00:17:42 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250711001742.1965347-1-jthoughton@google.com>
Subject: [PATCH] KVM: selftests: Fix signedness issue with vCPU mmap size check
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>, Venkatesh Srinivas <venkateshs@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Check that the return value of KVM_GET_VCPU_MMAP_SIZE is non-negative
before comparing with sizeof(vcpu_run). If KVM_GET_VCPU_MMAP_SIZE fails,
it will return -1, and `-1 > sizeof(vcpu_run)` is true, so the ASSERT
passes.

There are no other locations in tools/testing/selftests/kvm that make
the same mistake.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a055343a7bf75..7f870c99e64e0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -24,7 +24,7 @@ uint32_t guest_random_seed;
 struct guest_random_state guest_rng;
 static uint32_t last_guest_seed;
 
-static int vcpu_mmap_sz(void);
+static size_t vcpu_mmap_sz(void);
 
 int open_path_or_exit(const char *path, int flags)
 {
@@ -1307,14 +1307,14 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t base, uint64_t size,
 }
 
 /* Returns the size of a vCPU's kvm_run structure. */
-static int vcpu_mmap_sz(void)
+static size_t vcpu_mmap_sz(void)
 {
 	int dev_fd, ret;
 
 	dev_fd = open_kvm_dev_path_or_exit();
 
 	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
-	TEST_ASSERT(ret >= sizeof(struct kvm_run),
+	TEST_ASSERT(ret >= 0 && ret >= sizeof(struct kvm_run),
 		    KVM_IOCTL_ERROR(KVM_GET_VCPU_MMAP_SIZE, ret));
 
 	close(dev_fd);
@@ -1355,7 +1355,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	TEST_ASSERT_VM_VCPU_IOCTL(vcpu->fd >= 0, KVM_CREATE_VCPU, vcpu->fd, vm);
 
 	TEST_ASSERT(vcpu_mmap_sz() >= sizeof(*vcpu->run), "vcpu mmap size "
-		"smaller than expected, vcpu_mmap_sz: %i expected_min: %zi",
+		"smaller than expected, vcpu_mmap_sz: %zi expected_min: %zi",
 		vcpu_mmap_sz(), sizeof(*vcpu->run));
 	vcpu->run = (struct kvm_run *) mmap(NULL, vcpu_mmap_sz(),
 		PROT_READ | PROT_WRITE, MAP_SHARED, vcpu->fd, 0);
-- 
2.50.0.727.gbf7dc18ff4-goog


