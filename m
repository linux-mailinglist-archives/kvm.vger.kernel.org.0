Return-Path: <kvm+bounces-58916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E628ABA5996
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 08:10:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6AFC4A2F74
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 06:10:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0F426B2DA;
	Sat, 27 Sep 2025 06:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DEfWRyvY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC4625FA2D
	for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 06:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758953359; cv=none; b=GX3mJANJw1pslN4iQrlhvXUpONT8oIwKELn7JK4wBX5oSIgPmhnLaWMRkKWKCB7qmbBtl8Sc6BK90xDoPbbzdKLKsHhniD2qeirEz4QZv0+7l/fOtDHOAvCAv8X3L5oHlctDe1D7zyv+C8xzvMPHl5nCt5J7bclytUoN/DjcbhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758953359; c=relaxed/simple;
	bh=o0BbC2pN1ozixKbwbJH/Iyudfi7nVWKaRJSLd8JEjLE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=obAjrHalUmPwfrRBdbreqwHpWcZLt/sv1BeHRc7bMNxZAF0TBEBo6q6qHvPHS7/fzWskmH+H12c2UG3trnn6RN0GVMOfqq+dpPwQkKncfR+JAi5uuJtsuBR3HY5pX1+WmpjSeNdScwQ27jpgKqk29Rr/f0FFMGdPsXS9BV0n3cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DEfWRyvY; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b5535902495so2210395a12.0
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 23:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758953357; x=1759558157; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsL/e8R/ghCBGnCvNsP7ZU90niFQkxMQKHjSZWm5HrU=;
        b=DEfWRyvYySlrESVwNSxcmw0B0yHco1QiCE1HNFkEvkEKtZ/1Z6Vs5Xj8bFsIhnVCE/
         g5w8W2HQMRKhcGRb+nXzc3XfAZExQCWQFdRpuGM4MyJXyfUkKiee23i1k72osYZNJOon
         hi8WUYHi07ieAnwghx0R7VXCrhWTtOCJg3rjTFHmqJNazPAVkgPPpI+B+A9vc1A2qrTg
         EeUcRPbBzgK/gTxArgK39Wd+bHswYUf9qUGN5vT/hYKohV79SDTs99OKItNQ4zt04pkK
         iIyNbvTaoJ7/xO3Yh5OYORc7UOMve8eAMmpOJbxPy54pT6XM6VOAJtoMZRKyiR0otyoz
         nFMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758953357; x=1759558157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZsL/e8R/ghCBGnCvNsP7ZU90niFQkxMQKHjSZWm5HrU=;
        b=Uqx4ees6ZmN2MfQnPXNpXQafXLfPHKdGC/WW/rA8Ptf+l7VaMjAmzPcCaNcl+2dIK+
         0vj3Vt10vSL3w8q3uk2FX/GDQnU9LSKzHojEurPoj3OiTjfkOuVWnZMAiTcFf9shF5vF
         5VBTAsf1wR24q/IHeIgmb7eVbL75TFnSfOBJkeVPR+NSLrCtdU2iVgS/dv7f3lAQzHzF
         kp23v+bEfWi7tDjZ3qhGKbl14NlUU4ejccMT61MPoPyymO6EC4d0Sz/G8AWgfD+LuPir
         5gM2aIgYsomZl5ftOVBkM7Nk3WC+HJSglpEEV0ffyRcfjkuDTKoLqPV2u0Mp/7T1i9MU
         J27A==
X-Gm-Message-State: AOJu0YzqxMoGSpCDzd+n9pPqjIG5ye5T+rwnB5kKwzxQUaUv0r9gQTZZ
	eUjklmpjDcmvdE1SYdKh2xzQF1CaSUzPouKorHQJRUJoqqWUs7YkVRk5oO725iBjcnF0IZdeIo3
	D2Ca8jg==
X-Google-Smtp-Source: AGHT+IFzUG74DCfTMMKmvVhE59/okPGbyTRBhlvt2MTCztRHcb59t0mDLE9TX07FYxgOLiSpWHRkxkLPPMc=
X-Received: from pgbct7.prod.google.com ([2002:a05:6a02:2107:b0:b57:eab0:b1e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3396:b0:2b1:c9dc:6dab
 with SMTP id adf61e73a8af0-2e7d2e45e02mr12555233637.48.1758953356730; Fri, 26
 Sep 2025 23:09:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Sep 2025 23:09:03 -0700
In-Reply-To: <20250927060910.2933942-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250927060910.2933942-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.18
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Recover TDP MMU NX huge pages under read lock, and fix two (interruptible)
deadlocks in prefaulting and in the TDX anti-zero-step code (there's a
selftest from Yan for the prefaulting case that I'll send along later).

The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.18

for you to fetch changes up to 2bc2694fe20bf06eb73524426e3f4581d7b28923:

  KVM: TDX: Do not retry locally when the retry is caused by invalid memslot (2025-09-10 12:06:35 -0700)

----------------------------------------------------------------
KVM x86 MMU changes for 6.18

 - Recover possible NX huge pages within the TDP MMU under read lock to
   reduce guest jitter when restoring NX huge pages.

 - Return -EAGAIN during prefault if userspace concurrently deletes/moves the
   relevant memslot to fix an issue where prefaulting could deadlock with the
   memslot update.

 - Don't retry in TDX's anti-zero-step mitigation if the target memslot is
   invalid, i.e. is being deleted or moved, to fix a deadlock scenario similar
   to the aforementioned prefaulting case.

----------------------------------------------------------------
Sean Christopherson (2):
      KVM: x86/mmu: Return -EAGAIN if userspace deletes/moves memslot during prefault
      KVM: TDX: Do not retry locally when the retry is caused by invalid memslot

Vipin Sharma (3):
      KVM: x86/mmu: Track possible NX huge pages separately for TDP vs. Shadow MMU
      KVM: x86/mmu: Rename kvm_tdp_mmu_zap_sp() to better indicate its purpose
      KVM: x86/mmu: Recover TDP MMU NX huge pages using MMU read lock

 arch/x86/include/asm/kvm_host.h |  39 ++++++----
 arch/x86/kvm/mmu/mmu.c          | 165 ++++++++++++++++++++++++++--------------
 arch/x86/kvm/mmu/mmu_internal.h |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  49 +++++++++---
 arch/x86/kvm/mmu/tdp_mmu.h      |   3 +-
 arch/x86/kvm/vmx/tdx.c          |  11 +++
 virt/kvm/kvm_main.c             |   1 +
 7 files changed, 192 insertions(+), 82 deletions(-)

