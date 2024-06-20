Return-Path: <kvm+bounces-20156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE5491109F
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 20:17:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9272528D376
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 18:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86991BB68C;
	Thu, 20 Jun 2024 18:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="St2w1jjR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA5A172BAB
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718907206; cv=none; b=td6NnFIGCyn+1y17KiBVJgEIuIaEZITshzwVRrwaU15ILEbji7KbKEkzg7C8KUQC+txVZwncYZXbPTtcMO+Cp+SU84PWsGo5f9JW9y2JVjd8D914+dYjnvDw+lPYjXZ/HyXKCQXRfdNy2NVMiFqYzmonjw/2N+/Qs8poSIoIOsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718907206; c=relaxed/simple;
	bh=EkQ74mIuZ5fmAIpUTCR52YETFKCZ1LkD1Q4d79bF9gI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YsvErkrBaMBDFyZEgBltJZG+Not7lqZENA7+ZFnvoR7F7xcfX07YlFrHMwXrwSqHCcPWYPe66DwwPvx5ZiWrjKQcfrOiVTPiVY47wxFZirXLhCBN13hF5SJZwx0RrDvFzqUkCSF4Tri185GVlhC4qK6oRfI4AHZiYfqlWtwBpSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=St2w1jjR; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62f3c5f5bf7so19493707b3.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 11:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718907202; x=1719512002; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YMf6bHWa3WYlKn5BTDJ8mzHqJJrcfbUTWWG9rzjzXEI=;
        b=St2w1jjRjO4uZZSFZ9k4T5xNJnYnC+c/kYAw3sdPqGE7OFISQl6Aeg0J3JllT9fAvn
         aJhC3UfH0Q1U4+dOf99osMmDpxXoF4wbiJ8fUxCs8R8d8F1XYR0np+qrkRskBXDlofm3
         KNH5BNsweARlm0q8n/ge/ZjAx5GKumcplAbD43HXsrilidl4kXY0nOwjR/CiVO83vMYF
         a8bO+UeMXPWrtUkOpcb70+gUUpHwDcrQ2JwR4C7Vc3M5QZtPoOS2jxGMfrRlFGt4AOfN
         YrTIoXDio0DboFDIcLb51KxjsRkoDHpmEk0QLZAWGibUA5sSl1/Ga+3QPha1/wnDM5Uk
         srHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718907202; x=1719512002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YMf6bHWa3WYlKn5BTDJ8mzHqJJrcfbUTWWG9rzjzXEI=;
        b=leJiyGRHZ06yv85g1BOX+HOESOUEyjod1WnshOM1RrLks/nnbXxijpft3AhnX49fLg
         /iXRzAyDkn9fxf5GZ4LQzO/9ErJqL+KewJfabV01dPgJwIRDSP6Tr05uH4/snD2vCrz8
         yaoZ+XULiehnpK8i8PHtGFGrQlQrk71pWHje7Y2ypZgEV9JbJrSm//VNszEHB6bmx/+Y
         Ts+vxRx4rZxbdXdAPeRmFZUFoO42ptoaUN5PWb3qQHl4ssrafaVEroGdmsiG/Q2UY+K5
         c85vEcJEUUNYeEj4AVKfp229g97qqazf+HDSpDliex+/91bL7duhBauM3W5IN194qCpm
         RMPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeTlxbDFUX2LYKONTsYeDMgNCHxhHdJas3NI9+mDZ2lgpnC28OCgKaVLEu9SZFvOqTtvHGngYs04HYPbzcZctNZ6B0
X-Gm-Message-State: AOJu0YziJDL9Nvbw1PLwowohQtEyqo9qPGNZtZ9cHTJLrXyZgPoEONtz
	Of/ZjR+zOQxyTgfNjZ/TZRy0aGZFG06L4/zdUQSfP1zcmbk/2IDDg7g9HCUDOt77uaEXFPT1WOp
	Jwg==
X-Google-Smtp-Source: AGHT+IHj65srhREZE1E3IcSiXfDYLsTilyE3EaAXWu2gQuzsizOP8c6SaYdY5Ud/AiA3ZvB3NTHF6q9xvZ8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:fc5:b0:62d:48f:30e8 with SMTP id
 00721157ae682-63a8dc09c71mr14779407b3.1.1718907202341; Thu, 20 Jun 2024
 11:13:22 -0700 (PDT)
Date: Thu, 20 Jun 2024 11:13:21 -0700
In-Reply-To: <20240619182128.4131355-3-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240619182128.4131355-1-dapeng1.mi@linux.intel.com> <20240619182128.4131355-3-dapeng1.mi@linux.intel.com>
Message-ID: <ZnRxQSG_wnZma3H9@google.com>
Subject: Re: [PATCH 2/2] selftests: kvm: Reduce verbosity of "Random seed" messages
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 20, 2024, Dapeng Mi wrote:
> Huge number of "Random seed:" messages are printed when running
> pmu_counters_test. It leads to the regular test output is totally
> flooded by these over-verbose messages.
> 
> Downgrade "Random seed" message printing level to debug and prevent it
> to be printed in normal case.

I completely agree this is annoying, but the whole point of printing the seed is
so that the seed is automatically captured if a test fails, e.g. so that the
failure can be reproduced if it is dependent on some random decision.

Rather than simply hiding the message, what if print the seed if and only if it
changes?

--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Jun 2024 10:29:53 -0700
Subject: [PATCH] KVM: selftests: Print the seed for the guest pRNG iff it has
 changed

Print the guest's random seed during VM creation if and only if the seed
has changed since the seed was last printed.  The vast majority of tests,
if not all tests at this point, set the seed during test initialization
and never change the seed, i.e. printing it every time a VM is created is
useless noise.

Snapshot and print the seed during early selftest init to play nice with
tests that use the kselftests harness, at the cost of printing an unused
seed for tests that change the seed during test-specific initialization,
e.g. dirty_log_perf_test.  The kselftests harness runs each testcase in a
separate process that is forked from the original process before creating
each testcase's VM, i.e. waiting until first VM creation will result in
the seed being printed by each testcase despite it never changing.  And
long term, the hope/goal is that setting the seed will be handled by the
core framework, i.e. that the dirty_log_perf_test wart will naturally go
away.

Reported-by: Yi Lai <yi1.lai@intel.com>
Reported-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index ad00e4761886..56b170b725b3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -21,6 +21,7 @@
 
 uint32_t guest_random_seed;
 struct guest_random_state guest_rng;
+static uint32_t last_guest_seed;
 
 static int vcpu_mmap_sz(void);
 
@@ -434,7 +435,10 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	slot0 = memslot2region(vm, 0);
 	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
 
-	pr_info("Random seed: 0x%x\n", guest_random_seed);
+	if (guest_random_seed != last_guest_seed) {
+		pr_info("Random seed: 0x%x\n", guest_random_seed);
+		last_guest_seed = guest_random_seed;
+	}
 	guest_rng = new_guest_random_state(guest_random_seed);
 	sync_global_to_guest(vm, guest_rng);
 
@@ -2319,7 +2323,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
-	guest_random_seed = random();
+	guest_random_seed = last_guest_seed = random();
+	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
 	kvm_selftest_arch_init();
 }

base-commit: c81b138d5075c6f5ba3419ac1d2a2e7047719c14
-- 

