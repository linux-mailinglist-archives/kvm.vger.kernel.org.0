Return-Path: <kvm+bounces-50774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 536A3AE9345
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 02:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 078297A8FE6
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:11:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3808854F81;
	Thu, 26 Jun 2025 00:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xad341A2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D388E35957
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896751; cv=none; b=rWi3ZvkGPXK5jjc+91QDoeQygK0jb0NTdE+ZbFnOnDEo4OE8aPO3cQ5tvjmN31Xu3lky19mQv3klvzM6tQzh02JcCB2cptsOk14imxR6R+eM4SnhK5hGKJtq91kFCPbOL5J/5blbiArrghD2i5tasfn0Cbd3Pewmki+Bm0vhOAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896751; c=relaxed/simple;
	bh=OQuE1+mbvlY7kYCA416+0UPNmYM+WCsDdKYrx20KBY4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=kO0i7UoX6GZPzyBfa9sq6doOvc6rb7Y6WwxuIhcpX8cRGaQcJsUjw6/8Jq/+FbvMeL2KaPteOxKD8b0ZEpbU/K9EflXW3jAQM5xukQ4SFppS+rLX+ue/Kjhmld1KyrXfPZtn4kp+qpVOzoJCugLJ3zhZfuc8TbatyzCn59mirhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xad341A2; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747dd44048cso423280b3a.3
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 17:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750896749; x=1751501549; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ty9Yky/2YRmZBC/kRaxnlFXhTAWNXxw17qo7VWYFUnw=;
        b=Xad341A2tTdn7vHCG/v6xeXQMCyvWV7kiR8odzMWQ71s+n2A94Ioawqyb7yHYcAILp
         0RmiSr7zAG5b50i9yi2RtprpxjH5zuUGevm0Wv6w43YZOIIR/yxfM7TDx8rNXIwqG8KB
         fYcaZGNj9t6HE5FH1hRwlyA4aN/HRc57J3mFtBp9vOzATSEkZbnrk98xZgCW4KIUAtXI
         EAVJ5hvN0WOuITRhInwLgVvK7OV8Vn4KVgOCRsLSjAPDMbt0FeOE0PZGMWa4KafUGq87
         5H4pQJcvWC9clIWjbiNPsj8TgTPaYejO93ABVNzwZp7g9mQubXDQ5ie9bTQ+o6L2onyl
         +/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750896749; x=1751501549;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ty9Yky/2YRmZBC/kRaxnlFXhTAWNXxw17qo7VWYFUnw=;
        b=JkAgENLHicJ6+gvaAs75lUQaPo+GPO9AUNk1x6KFgkb9Z1u8MOGEEh+dO8hIU01Qqx
         NkCO5/qvKyfMzjxKLBzzcMESyEWCscOYoF10eToVQVo4BMi2DPLnjPsS8tkN01sHKgCK
         SoRWJZLMZxL9NSnUNe5RSd8ks7Suv+mI0UdEWylFpdWEdMDUZgFYB3m4OKdSTo9Ii6xW
         qm2mlztBsL8flCbFKSeP1vEyQ5VUOONUetHCnDnjA7AblEGfkdl0WTb+BJGlQ4qZXNUC
         7muLsewkuKbMBeeOmxuUEIY4ognamsPIEzcuByJQB84Pzd5XuE6FCcu9tCUEx0Md7hV1
         a3Ug==
X-Gm-Message-State: AOJu0Yyb5zC68c3MmnkUw92rah/7rApxczWNh4HM+8ONTwuyvcdIoaw9
	jqkCTRogeCqqifbbL6NduKCFx+lQ/BSapYHbePV7N7N4AtvCsBKA8hQ93X0Wj1zWuzYQdrkKgvk
	/uFJisg==
X-Google-Smtp-Source: AGHT+IF8TpcPM4+ngzfFRwoy1CLwhMuA7U208BIrPiA30EGA+J604Zlx0v8xnfd75p/sgB3YCcwXzUB7EWM=
X-Received: from pfrh7.prod.google.com ([2002:aa7:9f47:0:b0:748:4f7c:c605])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1256:b0:748:f1ba:9afe
 with SMTP id d2e1a72fcca58-74ad4462128mr7447673b3a.4.1750896748834; Wed, 25
 Jun 2025 17:12:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 25 Jun 2025 17:12:20 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626001225.744268-1-seanjc@google.com>
Subject: [PATCH v5 0/5] KVM: x86: Provide a cap to disable APERF/MPERF read intercepts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

arm64 folks, y'all got pulled in because of selftests changes.  I deliberately
put that patch at the end of the series so that it can be discarded/ignored
without interfering with the x86 stuff.


Jim's series to allow a guest to read IA32_APERF and IA32_MPERF, so that it
can determine the effective frequency multiplier for the physical LPU.

Commit b51700632e0e ("KVM: X86: Provide a capability to disable cstate
msr read intercepts") allowed the userspace VMM to grant a guest read
access to four core C-state residency MSRs. Do the same for IA32_APERF
and IA32_MPERF.

While this isn't sufficient to claim support for
CPUID.6:ECX.APERFMPERF[bit 0], it may suffice in a sufficiently
restricted environment (i.e. vCPUs pinned to LPUs, no TSC multiplier,
and no suspend/resume).

v5:
 - Rebase on top of the MSR interception rework.
 - Support passthrough to L2 on VMX (it was there somewhat unintentionally
   for SVM).
 - Expand the selftest to cover the nested case.
 - Sanity check that the MSRs are inaccesible in the selftest.
 - Add selftests patches to expand the task=>CPU pinning APIs.
 - OR-in the new disabled exits in one batch.

v4:
 - https://lore.kernel.org/all/20250530185239.2335185-1-jmattson@google.com
 - Collect all disabled_exit flags in a u64 [Sean]
 - Improve documentation [Sean]
 - Add pin_task_to_one_cpu() to kvm selftests library [Sean]

v3:
 - https://lore.kernel.org/all/20250321221444.2449974-1-jmattson@google.com
 - Add a selftest

v2:
 - https://lore.kernel.org/all/20250314180117.740591-1-jmattson@google.com
 - Add {IA32_APERF,IA32_MPERF} to vmx_possible_passthrough_msrs[]

v1:
 - https://lore.kernel.org/all/20250225004708.1001320-1-jmattson@google.com

Jim Mattson (3):
  KVM: x86: Replace growing set of *_in_guest bools with a u64
  KVM: x86: Provide a capability to disable APERF/MPERF read intercepts
  KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF

Sean Christopherson (2):
  KVM: selftests: Expand set of APIs for pinning tasks to a single CPU
  KVM: selftests: Convert arch_timer tests to common helpers to pin task

 Documentation/virt/kvm/api.rst                |  23 ++
 arch/x86/include/asm/kvm_host.h               |   5 +-
 arch/x86/kvm/svm/nested.c                     |   4 +-
 arch/x86/kvm/svm/svm.c                        |   7 +-
 arch/x86/kvm/vmx/nested.c                     |   6 +
 arch/x86/kvm/vmx/vmx.c                        |   6 +-
 arch/x86/kvm/x86.c                            |  15 +-
 arch/x86/kvm/x86.h                            |  18 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/include/uapi/linux/kvm.h                |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arch_timer.c      |   7 +-
 .../kvm/arm64/arch_timer_edge_cases.c         |  23 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  31 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  15 +-
 tools/testing/selftests/kvm/lib/memstress.c   |   2 +-
 .../selftests/kvm/x86/aperfmperf_test.c       | 213 ++++++++++++++++++
 17 files changed, 321 insertions(+), 57 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/aperfmperf_test.c


base-commit: 7ee45fdd644b138e7a213c6936474161b28d0e1a
-- 
2.50.0.727.gbf7dc18ff4-goog


