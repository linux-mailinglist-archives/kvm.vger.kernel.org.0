Return-Path: <kvm+bounces-17907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 406978CB8EA
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 04:28:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7185B1C22AE7
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 02:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5335057CB0;
	Wed, 22 May 2024 02:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JPwTSCAz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0694415C0
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 02:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716344912; cv=none; b=cNL3FoG/E659iTHRIQMSl8zU/W45mh7bYGV7laAuI6sXq1/TGx7I7hzWubLYiKsnKoYwzD3xh5zAwf7Yo7FhpDTMVU2IoMtmP6H54WtLBA98IT5YoFQ2bOgRQA60483G3pxOZ9CKeU5Fo3LchOD7RNcoJ0yLsd7bFJdPIG8pc+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716344912; c=relaxed/simple;
	bh=3gAy88p21L6Wk9rM/10Z4It1sofQrFGW8GYnqHBWB1g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=JUVagSoE6m7iu9HBez6iCPQjc5PL6ulGxlBPGvIXS5PDaTbzkHc31hCSWi1rOzzVrAWXRz+LzUY8QjxDG93suLaS+gMqLBgUwmfNItPc1QzjmvKrwISYTXW8jXsBhjwupVSthaHghLKsQB8Xx6jtS7ciJ37bKBpFXVH3k4JHiF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JPwTSCAz; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627e6fe0303so3148157b3.2
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 19:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716344910; x=1716949710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7V+Ka0fjINsI8Z4RPlt1zj8ARVt5k6DEGgyn88Anuto=;
        b=JPwTSCAzawGYeL/otUQuh8sSBUi64GdyoRbPbXdRpP2nSQfS25JC7b7Q2DMzOiH00g
         yWT2UJqcTDIaDC0fGdce6aoY7HMyehgz6j5OSt2bEfMFufqfoPpKiSCK/JoVs1VlBggh
         ZuHugSfV1OhMTpK8DSZs+3yJL3uHhBc88WvdQiZOlYQdoVRm1lp5t/fanaUwaMMaX+cf
         op2Unaph8MDjmHjQ9AvCTnGFHVO9d8D1e3ONk5/sb1PKFe8wTu2k+EvN6fyiyf+mmlv8
         Zd9RW5lgiisFDxwkSnoKttlYXHWY09YG7dcEQbTeP4H7x3mGUs+cLPbTmd9Ub7fSD+KJ
         yCRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716344910; x=1716949710;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7V+Ka0fjINsI8Z4RPlt1zj8ARVt5k6DEGgyn88Anuto=;
        b=C6VrUvVG4E9n0S86rUdePzRfi85GMJGGKkV81pSn0Rj6f+z/b/H3TfsRkbFS8O3Lgn
         q+0kEtpUpVam5v+daT+6WbUB7tPykMRHmJdFL5qJlzle2nu57uL+8RjVw1jrXXx2X9Cs
         6qgG6Q2YBr0BynY3jD/+9uckxbqL+hYre2m2cs5tcVq6v+Fxfom2/ZmwBvjq5NsQ0Zc/
         xsiC+W1eQyx6qtTK4CFFZub8OLQ1UbPLZ8N2w3eHzQs5CTp3SPcRX3Gc7D1Qm8zzhfs1
         Jbe4YBnm6Vjru7nZmRN/d0xS9cjUokgs1ljKzePFhBctPf+Whh5AltWQ0Wj3ESjUKMtX
         2Z3w==
X-Gm-Message-State: AOJu0Ywol3ioK5gzl1LAr5UW+P9SLaTclmpFJlwscki2yV9Chb0UZ2iR
	c0vscg+PP911BAE0qqCl4psyY5DS3cwbpU2+g/VvoBNsVBcr9l8HoiPy7ymuWzCUjWleyyIescY
	+9A==
X-Google-Smtp-Source: AGHT+IH/n4GXytNCOSFbsnT6ItllhNo6Jqx8JvHkCrwnClOG72WXl8cojbyFHcHm6SRI5VO4PWTRfvrC+58=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d80d:0:b0:622:c964:a590 with SMTP id
 00721157ae682-627e46d40c7mr2134497b3.1.1716344909979; Tue, 21 May 2024
 19:28:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 19:28:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522022827.1690416-1-seanjc@google.com>
Subject: [PATCH v2 0/6] KVM: Register cpuhp/syscore callbacks when enabling virt
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Register KVM's cpuhp and syscore callbacks when enabling virtualization in
hardware, as the sole purpose of said callbacks is to disable and re-enable
virtualization as needed.

The primary motivation for this series is to simplify dealing with enabling
virtualization for Intel's TDX, which needs to enable virtualization
when kvm-intel.ko is loaded, i.e. long before the first VM is created.  TDX
doesn't _need_ to keep virtualization enabled, but doing so is much simpler
for KVM (see patch 3).

That said, this is a nice cleanup on its own, assuming I haven't broken
something.  By registering the callbacks on-demand, the callbacks themselves
don't need to check kvm_usage_count, because their very existence implies a
non-zero count.

The meat is in patch 1.  Patches 2 renames the helpers so that patch 3 is
less awkward.  Patch 3 adds a module param to enable virtualization when KVM
is loaded.  Patches 4-6 are tangentially related x86 cleanups to registers
KVM's "emergency disable" callback on-demand, same as the syscore callbacks.

Moderately well tested on x86, though I haven't (yet) done due dilegence on
the suspend/resume and cphup paths.  Compile tested on other architectures,
but that's all for this version.

v2:
 - Use a dedicated mutex to avoid lock inversion issues between kvm_lock and
   the cpuhp lock.
 - Register emergency disable callbacks on-demand. [Kai]
 - Drop an unintended s/junk/ign rename. [Kai]
 - Decrement kvm_usage_count on failure. [Chao]

v1: https://lore.kernel.org/all/20240425233951.3344485-1-seanjc@google.com

Sean Christopherson (6):
  KVM: Register cpuhp and syscore callbacks when enabling hardware
  KVM: Rename functions related to enabling virtualization hardware
  KVM: Add a module param to allow enabling virtualization when KVM is
    loaded
  KVM: Add arch hooks for enabling/disabling virtualization
  x86/reboot: Unconditionally define cpu_emergency_virt_cb typedef
  KVM: x86: Register "emergency disable" callbacks when virt is enabled

 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/include/asm/reboot.h   |   2 +-
 arch/x86/kvm/svm/svm.c          |   5 +-
 arch/x86/kvm/vmx/main.c         |   2 +
 arch/x86/kvm/vmx/vmx.c          |   6 +-
 arch/x86/kvm/vmx/x86_ops.h      |   1 +
 arch/x86/kvm/x86.c              |  10 ++
 include/linux/kvm_host.h        |   2 +
 virt/kvm/kvm_main.c             | 258 ++++++++++++++++----------------
 9 files changed, 150 insertions(+), 139 deletions(-)


base-commit: 4aad0b1893a141f114ba40ed509066f3c9bc24b0
-- 
2.45.0.215.g3402c0e53f-goog


