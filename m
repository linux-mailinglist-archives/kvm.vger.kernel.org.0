Return-Path: <kvm+bounces-11401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 049B2876D39
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 23:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27D6E1C216A4
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 22:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4234D9E2;
	Fri,  8 Mar 2024 22:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J20CrFvZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D986481A8
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 22:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709937435; cv=none; b=DdYV8jfkI+cBL419LDvrqXewWl+h6uhm9aufJX1E1NMF9lAo/Ucu2VkgJ4crSkkHUNtdfdU9WQ04Z7nJks9diawhgBU33lG1j/PNaVI8U1jtt/dwkP36rXDV6grN+BQ6ISZwF1LzyEQt5IA84zD++nDiZLVhM8WnVcldi/D/6GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709937435; c=relaxed/simple;
	bh=+Mx8x0RKehjpvpIa67zvs9eYpE3yNU6uZXEUU3WUBiU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XM4ThQEmqVQYXUVumCQO4qT+hadWq8pAQ8N+e9ZQreFaKDEacw/0r48MbEG9zsN5cKKh5T9luesC2PIaCTWANKuFhXM04Evg2yxglFaVa9KKyPFfVoZFU44MP7HFNiQU9QO/p8V9aviLBz8eLXPRAbXWhjemRPx3YwZGYKt/pso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J20CrFvZ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dced704f17cso4387691276.1
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 14:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709937433; x=1710542233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2QorUrh9s78MFlbkgk+2a0MGamPQnWjhl5BhttVxHT0=;
        b=J20CrFvZGeztmZVHhdz4tfVy5TMFKKuQQ+OQSoco4NTOI1NQww6MpoCAZye3kIRWq6
         m/Zx8hlxzpnygvxh6atcdHBAXCDBwZJ6zXAMjft6Brfu1tIDiwqxYImQitzLczT0a+mo
         y6ZU7gmsy5SD25MreSmvcyA8h+Fxfh2XrrcyYc3N/4wGXzsfyogbaa+i7IgtW7r/SAZB
         xCpYCFhWiWje9SbEtDCeGugeU/Tfip6tYfbuMN7i1y9oQ915wm3ncu3XvcFKskvhXW1t
         Ee4ANOtCawHoKsM7407/WIQZxRuT2LRiLQ0uqOYeMcmnj6rTUnx7BvrS0wR+tnd6DpUB
         T1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709937433; x=1710542233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2QorUrh9s78MFlbkgk+2a0MGamPQnWjhl5BhttVxHT0=;
        b=HLN23DY+JDrfV58XUYLNR2LDV77WmCdj+P9RpDkxLHpq/k9HKA8zEym3O8RL3GwaXT
         G1WGGAEJFbDzSovcFRQZ5eFNcwWUVraUBVzGdFj7zee+ZiNJZ+xS7hKDojyBbnMv7EER
         mnz59PyhmzcNTDuy8WEpTAiu3QjTNJVHkydP3l5p7LsanXUXIJ6cdRg60W046Bm+5oVc
         975qnFaEdwa9dSUHHFxYGtQNaX5r/Pdy7Xq3jbhSrMhDL4eJgSa8rsnQtPWtLG6pdjTw
         nbiY/xnrSe0qziyLA9PbqjKpGdM0UO/pugzqCxwepy42HBHAMW2xEH8VIWmh+vwjFUFo
         UYDQ==
X-Gm-Message-State: AOJu0Yx8Za5YDzAFNrf+8+Mj+8yrXSRehQBemS0jHDcEBfvRJqjq+Hlm
	OSLsNUT0XB++A89z2S3YUG263mUoTAoSKAYhFUbTG40B3loOMxRdnXYfPmWQ7N64sggOYfeRE9d
	+7Q==
X-Google-Smtp-Source: AGHT+IEI79YhxvtlJm7Zj+ji/MtKdfxoMRxsviUcAfzTW3v6x2QkbtNfLILHtv9K8jhD+h6yG0bu8Hf8Pls=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dcc9:0:b0:dc7:6cfa:dc59 with SMTP id
 y192-20020a25dcc9000000b00dc76cfadc59mr3304ybe.4.1709937433095; Fri, 08 Mar
 2024 14:37:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 14:36:56 -0800
In-Reply-To: <20240308223702.1350851-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240308223702.1350851-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A variety of one-off cleanups and fixes, along with two medium sized series to
(1) improve the "force immediate exit" code and (2) clean up the "vCPU preempted
in-kernel" checks used for directed yield.

The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:

  Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.9

for you to fetch changes up to 78ccfce774435a08d9c69ce434099166cc7952c8:

  KVM: SVM: Rename vmplX_ssp -> plX_ssp (2024-02-27 12:22:43 -0800)

----------------------------------------------------------------
KVM x86 misc changes for 6.9:

 - Explicitly initialize a variety of on-stack variables in the emulator that
   triggered KMSAN false positives (though in fairness in KMSAN, it's comically
   difficult to see that the uninitialized memory is never truly consumed).

 - Fix the deubgregs ABI for 32-bit KVM, and clean up code related to reading
   DR6 and DR7.

 - Rework the "force immediate exit" code so that vendor code ultimately
   decides how and when to force the exit.  This allows VMX to further optimize
   handling preemption timer exits, and allows SVM to avoid sending a duplicate
   IPI (SVM also has a need to force an exit).

 - Fix a long-standing bug where kvm_has_noapic_vcpu could be left elevated if
   vCPU creation ultimately failed, and add WARN to guard against similar bugs.

 - Provide a dedicated arch hook for checking if a different vCPU was in-kernel
   (for directed yield), and simplify the logic for checking if the currently
   loaded vCPU is in-kernel.

 - Misc cleanups and fixes.

----------------------------------------------------------------
John Allen (1):
      KVM: SVM: Rename vmplX_ssp -> plX_ssp

Julian Stecklina (2):
      KVM: x86: Clean up partially uninitialized integer in emulate_pop()
      KVM: x86: rename push to emulate_push for consistency

Mathias Krause (1):
      KVM: x86: Fix broken debugregs ABI for 32 bit kernels

Nikolay Borisov (1):
      KVM: x86: Use mutex guards to eliminate __kvm_x86_vendor_init()

Sean Christopherson (14):
      KVM: x86: Make kvm_get_dr() return a value, not use an out parameter
      KVM: x86: Open code all direct reads to guest DR6 and DR7
      KVM: x86: Plumb "force_immediate_exit" into kvm_entry() tracepoint
      KVM: VMX: Re-enter guest in fastpath for "spurious" preemption timer exits
      KVM: VMX: Handle forced exit due to preemption timer in fastpath
      KVM: x86: Move handling of is_guest_mode() into fastpath exit handlers
      KVM: VMX: Handle KVM-induced preemption timer exits in fastpath for L2
      KVM: x86: Fully defer to vendor code to decide how to force immediate exit
      KVM: x86: Move "KVM no-APIC vCPU" key management into local APIC code
      KVM: x86: Sanity check that kvm_has_noapic_vcpu is zero at module_exit()
      KVM: Add dedicated arch hook for querying if vCPU was preempted in-kernel
      KVM: x86: Rely solely on preempted_in_kernel flag for directed yield
      KVM: x86: Clean up directed yield API for "has pending interrupt"
      KVM: Add a comment explaining the directed yield pending interrupt logic

Thomas Prescher (1):
      KVM: x86/emulator: emulate movbe with operand-size prefix

 arch/x86/include/asm/kvm-x86-ops.h |   1 -
 arch/x86/include/asm/kvm_host.h    |   8 +--
 arch/x86/include/asm/svm.h         |   8 +--
 arch/x86/kvm/emulate.c             |  45 +++++++--------
 arch/x86/kvm/kvm_emulate.h         |   2 +-
 arch/x86/kvm/lapic.c               |  27 ++++++++-
 arch/x86/kvm/smm.c                 |  15 ++---
 arch/x86/kvm/svm/svm.c             |  25 ++++-----
 arch/x86/kvm/trace.h               |   9 ++-
 arch/x86/kvm/vmx/nested.c          |   2 +-
 arch/x86/kvm/vmx/vmx.c             |  85 +++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.h             |   2 -
 arch/x86/kvm/x86.c                 | 110 ++++++++++++-------------------------
 include/linux/kvm_host.h           |   1 +
 virt/kvm/kvm_main.c                |  21 ++++++-
 15 files changed, 184 insertions(+), 177 deletions(-)

