Return-Path: <kvm+bounces-11817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F339087C319
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 19:55:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E18FB210FB
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC462757F5;
	Thu, 14 Mar 2024 18:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f7PJ+qXM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1EA74C0E
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 18:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710442503; cv=none; b=k9fzkTWYuimyufQvu3Q3WXsYZZyP20EIGEwDgmmrIq/DZPmPM6NARt/Lb/x8URvkaFgBlYkbln4Q0re2KvpYyD4E4bnYUSJxjSNzAI8/VGItQ6pQNlCgve8tNiTy9vEnmSw3rrWjh25Cskej+OijRZPWgHStENhETJh+2xUfYYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710442503; c=relaxed/simple;
	bh=MFdEORqspMm/N9RlMn5fTaPR58EUdK/aeU0l5TOmLDo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eKpb6H06jYHUaWuwOqWKS+HIdflJcrxpiqYep3e+nCUrn1/LFQEY5hs+H75pz+btl6D2NZKL4rJOMDwVp+NCWhIISi/njZpGEWPMfEQ4n45lsLL9qd1tWIoUg7y9W6f2+DGcVIsC+NXYzh+81Tk0mIp4L0ClfB3P5OPthOyOjAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f7PJ+qXM; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a2b53b99eso28935747b3.3
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 11:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710442501; x=1711047301; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4WDWsHDCvZpCR8WqPi8av5n4xNVj7Fxl1eqlGJ2Tas=;
        b=f7PJ+qXMv7ly+D3nEIwSNtwg3+NAurmrAKs06sHMYAmszr7A2w0CyV1RKkyubtNyNB
         4q4QaGcFWUVMRHRgXSVPn8zpppgs7HpvWuSLdXodu79BG5BgcVg3CIOgPtAfuzVqtpaq
         Ej869Fy/S9Bnz4OQj8BE0PrtzybncxMCsHrH0B1kUVq75usUjDBXDxdcWRTUzfqmiM0X
         35kAxHx1e41X9MrjlhcC7h9/zdl3FmqnzIv+2lCp1sammI8shguxA+G1BiTKXO+cf2Bt
         tber7rlrADxjVDG0YG+Cf9AXXCB+kPimLRjlAJWvrFllVpxza4TdvPRoxAGVemOa3RVK
         WUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710442501; x=1711047301;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h4WDWsHDCvZpCR8WqPi8av5n4xNVj7Fxl1eqlGJ2Tas=;
        b=cX0WWhJHbv6WGxc1roakTMeSUDbfVZGM44N4v1dMaT0DIiJA9+yLHnSvVBl7HATL5q
         sn8wAyvz3TrPKnjs6Fl+wDn/6Aih0oRz0i0qYs7rcnu3KpT31SddIX9SG4/ebtzU+zzM
         16hnLMZv5ijCvSjg0a0IHQhAbTEX1RrdgiNiwcy9Gr/YFVrrimxc5H8kAA+p/97xmrdf
         2cxbdMy+PNs/YZJGfPfVwYF2Ajlfgcm8klLNhnUCFZe9RmoTxbPkAOuKGwUQZRO1qifX
         /qAM4XhUGTisNVqApT8gAYpyt69YqnYUt0IX6HmShrFiiVTHRvpNJgrE6A0SRQNCR0DK
         afpA==
X-Gm-Message-State: AOJu0YyC5XWlT3pQoua/hpPF1rVafhmCzKhKXzni4NKiI0lFZNUZIgWu
	fRB3MBIJM+SAnpurDwcn2Ii+Lcs7TDMd1l4m5sjX/pF+SvYo88Jb/vL0P9edYC/g8u1/A4bh11x
	ogg==
X-Google-Smtp-Source: AGHT+IFSm4RhRIx0QXZ8OxfpsWijUgWYXTmtFB0hVLldiIhRPyFdnJKaLCsSUgStdv4wldRmubDOyukR16M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2408:b0:dc2:1f34:fac4 with SMTP id
 dr8-20020a056902240800b00dc21f34fac4mr3803ybb.2.1710442501355; Thu, 14 Mar
 2024 11:55:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 11:54:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314185459.2439072-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: selftests: Introduce vcpu_arch_put_guest()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The end goal of this series is to add a regression test for commit
910c57dfa4d1 ("KVM: x86: Mark target gfn of emulated atomic instruction
as dirty"), *without* polluting the common dirty_log_test.c code with
gory x86 details.

The regression test requires forcing KVM to emulate a guest atomic RMW
access, which is done via a magic instruction prefix/opcode that is
guarded by an off-by-default KVM module param.

To allow x86 to (a) detect the param, (b) shove in the unique instruction,
and (c) do all of that conditionally so that selftests doesn't test _only_
the forced emulation path, this series provides a pseudo-RNG instance for
all tests, and a new arch hook for doing "interesting" guest writes
(vcpu_arch_put_guest()).

Tested on x86 and ARM, compile tested on s390 and RISC-V.

Sean Christopherson (5):
  KVM: selftests: Provide a global pseudo-RNG instance for all tests
  KVM: selftests: Provide an API for getting a random bool from an RNG
  KVM: selftests: Add global snapshot of
    kvm_is_forced_emulation_enabled()
  KVM: selftests: Add vcpu_arch_put_guest() to do writes from guest code
  KVM: selftests: Randomly force emulation on x86 writes from guest code

 .../selftests/kvm/dirty_log_perf_test.c       |  9 ++++----
 tools/testing/selftests/kvm/dirty_log_test.c  | 22 ++++--------------
 .../selftests/kvm/include/kvm_util_base.h     |  3 +++
 .../testing/selftests/kvm/include/memstress.h |  1 -
 .../testing/selftests/kvm/include/test_util.h | 19 +++++++++++++++
 .../kvm/include/x86_64/kvm_util_arch.h        | 23 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  9 ++++++++
 tools/testing/selftests/kvm/lib/memstress.c   | 10 ++------
 .../selftests/kvm/lib/x86_64/processor.c      |  3 +++
 .../selftests/kvm/x86_64/pmu_counters_test.c  |  3 ---
 .../kvm/x86_64/userspace_msr_exit_test.c      | 10 ++------
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  5 ++--
 12 files changed, 72 insertions(+), 45 deletions(-)


base-commit: e9a2bba476c8332ed547fce485c158d03b0b9659
-- 
2.44.0.291.gc1ea87d7ee-goog


