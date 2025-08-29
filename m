Return-Path: <kvm+bounces-56374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3137BB3C506
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 00:38:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D616B5A506F
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8080D2D0C72;
	Fri, 29 Aug 2025 22:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xk8sFVhd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270B82C21DC
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 22:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756507046; cv=none; b=K3FttBKrfF1A8qnemnfwE9Xr2t0o5eUv38KToBe5vTf01RYOkKcdsFckWCuGh/Zg4e/uHq4czN5bvj9pFgvJKaJchDEYXgge4Vxc3FDzdMrDjIM3mTy8yRrV0MB0+Ddt2y1AGUlbztIL9RllEYI2a0pO8he7jK+LS2ehg2VwUNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756507046; c=relaxed/simple;
	bh=z6vGngIIcGCT7ZzMgVudO2z4DzL5woL13xEbimUJToQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ehlHsyROpD7Uzo02SUex4gCBLwcFouegWiJGTeZ1zF9S96e27vJjCq+vh8N90x9XZ29RfWdct2ix+cnO6HVh6VSZEwn0WDI01/WRSgemgy+Y6RDFhSZ4ZFO7xX4NTT6rKZyOS/DhMLbN+pOoJ71zJivvkuyI0LY9+o8TB8mOe5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xk8sFVhd; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24458345f5dso30479795ad.3
        for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 15:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756507044; x=1757111844; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oBha0DQ5TEq7Q5aJy2SiEJVauu9+79TwM56RJDaNXqY=;
        b=Xk8sFVhd6vNb0fRqNkJJ1tZhLMci3kUyJ3lkW3O5Nwhx63zV4qDjtdQHeaoQSB8FvM
         X8zVcgJttXpjNKX5zC5gjpjIg0AHF8g9Lr9YHe35p1obK+7hmnd//3GJ6D9+slyUhWrc
         IIz+xc4alQFYn8fAbjY3a/CGX6Zi483PjcQ+E6NRW5CTRU2CAXTRxqfAdJUYMvfo2uHS
         LM5f4xYAPHi0jFeChCG/DyDLeSgdQCLZeBfe2FjxuNfoxRAgpOVNsj0+FUAfpYkYpk01
         +w6Dzy0hJET3PrmjwTcJ4VFIq/5y9jSOO6lV4aPlRJEJgyB969MOaFog1QcX+DrOZ71Q
         b1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756507044; x=1757111844;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oBha0DQ5TEq7Q5aJy2SiEJVauu9+79TwM56RJDaNXqY=;
        b=kklHil0w3dnJXpcUfpUi9whgaAx/FXV5Z+EcyZ3R8qdbh3vg7SoGfo9DzBz+Tq9Sor
         Y+kTKyK0dduMvWNRGACEEd+MK1Co85mItkLw+CK9SlpV8PFotSox/pDYCRRk8jiG4UI7
         7rreaJBsT2RwoytdyvIeJw3KU8mfNtTt4Km/iRH3veGPHfPfPos7fF/VPgur4pifz/Op
         opWggtNnxeGl+0ifDNZX9XMoR42EQ/DJApgn1XBPXt+DihTyCDdFe2UK93mwElItrqgQ
         hi7DSLKHY0ATOTbHmuV5b8lbr0/BG1t0cReKJD2JSVkg1dNJ4I4f6tloqd14oM2STJYb
         XR3g==
X-Forwarded-Encrypted: i=1; AJvYcCW3hUjR3FoFqjDoV8+k7qhYMHAFmFbj1RSGnaEJQN67GnC4pMJZ1lXYxPwtb70gVILR/gs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKz2mAVHIgb7iTupYJDzAQMENpGBcMIgeCkHy47ZEItlfwIaWh
	PlsxKT4cb7Onnm+Z0En+OQb1UnFLKcBMOqVfDxTuiOE8TV9Xj0QehTOD+4J20eEQXua1WXtunQt
	lWi28Jg==
X-Google-Smtp-Source: AGHT+IEdG40n/Pf6Aqwl8NxJqLfES++zClmZ4cDp0azslUAVzVKCgCL8aWMYeTpx/xhE0iI1d6KUPOyEmjc=
X-Received: from plbkn7.prod.google.com ([2002:a17:903:787:b0:248:cd27:2afd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:190:b0:246:e8cc:8cef
 with SMTP id d9443c01a7336-24944870a4emr4004555ad.3.1756507044432; Fri, 29
 Aug 2025 15:37:24 -0700 (PDT)
Date: Fri, 29 Aug 2025 15:37:23 -0700
In-Reply-To: <20250829142556.72577-4-aqibaf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829142556.72577-1-aqibaf@amazon.com> <20250829142556.72577-4-aqibaf@amazon.com>
Message-ID: <aLIroyJSWQ26wnY4@google.com>
Subject: Re: [PATCH 3/9] KVM: selftests: Add pthread_attr_setaffinity_np fallback
From: Sean Christopherson <seanjc@google.com>
To: Aqib Faruqui <aqibaf@amazon.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nh-open-source@amazon.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Aug 29, 2025, Aqib Faruqui wrote:
> The pthread_attr_setaffinity_np function is a GNU extension that may not
> be available in non-glibc C libraries. Some KVM selftests use this
> function for CPU affinity control.
> 
> Add a function declaration and weak stub implementation for non-glibc
> builds. This allows tests to build, with the affinity setting being a
> no-op and errno set for the caller when the actual function is not available.

Except this isn't a fallback, for all intents and purposes it silently breaks
the test.  A "fallback" is generally something that provides roughly equivalent
functionality.  This particular test will still pass because forced preemption
isn't strictly necessary, but this is still gross.  

Luckily, KVM selftests already provides APIs to pin tasks, just use those and
the problem naturally goes away.

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 29 Aug 2025 15:31:44 -0700
Subject: [PATCH] KVM: selftests: Use KVM's task pinning APIs in steal_time
 time

Use pin_self_to_cpu() and pin_task_to_cpu() to pin the vCPU thread and
the stealer thread to pCPU0 in the steal_time.  Eliminating the usage of
pthread_attr_setaffinity_np() in particular allows building the test
again non-glibc C libraries.

Reported-by: Aqib Faruqui <aqibaf@amazon.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/steal_time.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index cce2520af720..663c99c81703 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -341,9 +341,7 @@ int main(int ac, char **av)
 {
 	struct kvm_vcpu *vcpus[NR_VCPUS];
 	struct kvm_vm *vm;
-	pthread_attr_t attr;
 	pthread_t thread;
-	cpu_set_t cpuset;
 	unsigned int gpages;
 	long stolen_time;
 	long run_delay;
@@ -353,11 +351,7 @@ int main(int ac, char **av)
 	verbose = ac > 1 && (!strncmp(av[1], "-v", 3) || !strncmp(av[1], "--verbose", 10));
 
 	/* Set CPU affinity so we can force preemption of the VCPU */
-	CPU_ZERO(&cpuset);
-	CPU_SET(0, &cpuset);
-	pthread_attr_init(&attr);
-	pthread_attr_setaffinity_np(&attr, sizeof(cpu_set_t), &cpuset);
-	pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
+	pin_self_to_cpu(0);
 
 	/* Create a VM and an identity mapped memslot for the steal time structure */
 	vm = vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
@@ -389,7 +383,9 @@ int main(int ac, char **av)
 
 		/* Steal time from the VCPU. The steal time thread has the same CPU affinity as the VCPUs. */
 		run_delay = get_run_delay();
-		pthread_create(&thread, &attr, do_steal_time, NULL);
+		pthread_create(&thread, NULL, do_steal_time, NULL);
+		pin_task_to_cpu(thread, 0);
+
 		do
 			sched_yield();
 		while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS);

base-commit: ecbcc2461839e848970468b44db32282e5059925
--

