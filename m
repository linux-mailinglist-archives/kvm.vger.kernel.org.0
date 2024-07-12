Return-Path: <kvm+bounces-21587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81833930296
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2BFB1C21327
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 23:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E880813CFB6;
	Fri, 12 Jul 2024 23:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O3E0RzF3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0C3134410
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 23:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828642; cv=none; b=QAP8k1OHqtYliAnL0wcj/JkBfZxv8FgOlyGbi+gzWfasIHEA+BG0hvPwcjK1pdAnQvHazMXSk0u+nYQGRsuzpQhlW3fVG2ANgMm3x2SmEU3rTSxvmufhh4UjQtdY6h8ekD17BSJYSIsw+FMIyvSBSiGbrP6/NRHJf7L0otURjuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828642; c=relaxed/simple;
	bh=Wr2h5A42P94pdCqPl9/PjT045Er8Omv8AATJmSj6YqE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M11YYhr2rA7Q9M/rwdmGv0QdXcK+HEUdIzZsvilBpQGT8cScn+UxJL/xRoembCMIDUKUsHxbK8ysIoyTT1l4LPecqDj6DDQ5iDRJhHWk6VmhHI04f/EasjKFZVCvDZZStYrVuamFtM+AjRk7/43miE21eACFolIY5w5gC4+tDIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O3E0RzF3; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e035949cc4eso4815701276.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720828640; x=1721433440; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0aVSPRfxF0sXEPqrPlgXmebj7I67TFWz+QkySkarfYo=;
        b=O3E0RzF3ifFwYB4ZC1ENVQUWno6RsJqtf69hNgohp+269FO3O+6nk+UX1yz5GkC9mw
         p+cKgywzdeTtWsYwSV1mAkVqtEKcvOhSV/hFjg6Ge9Ex3rYtaB+FHebGjxPqFgbE71Nd
         20QWa5mgUnuRTkMN6B0rwRyZxoIUTGaI7He3JHer57+pJ9qffZxjYdlUcJHaM/j0vTMv
         4Dp3wFL9fauUETZC3vlLHtMAPtMc8C7y/sV/08IZh/eV6+0Dkx7ABW2WFZOgFaDS5KbG
         UEPJ3VAikpBk6sGrD1Bn5uU7kdATF4sn7MWWZO/c9vhjt1Fwbu94iVV4w2mhqpC1CDYe
         X04A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720828640; x=1721433440;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0aVSPRfxF0sXEPqrPlgXmebj7I67TFWz+QkySkarfYo=;
        b=GS79OZkrCWg0AtiHJcEc+9yzB4as6HlGgxIUTpvIVaq2YK/rAilVboeVJDpu74M01X
         +W2o9J7UtUmTvEx/WM6FW6of7TlRWRjmOokPq3slMZvDA3Lh49liA0a+HYrK5hCTzjxH
         hqX6A9uAfMBOKsFL2HVK0bhyG/Kh4dpUOimHF4/YSkZv3WzBqW4hV4zTmV/x73IdCDdK
         JMDPHyy/fgIiiLxOdTOq4aw4sSKLdjehBZya8VF+ez4oyZfYn+woEhDWg5UiGbizRP/z
         SjTPlseHv6Khhw/E+ptFpVp2zgBVCOZ+DR6D3ObL8s63TojDHLtfvHC6j+Wa2dfl3jWb
         Xm0A==
X-Gm-Message-State: AOJu0Yw66xJhX5JCR2Ztf8YyMgbVIGRjixYgHg+rT4yNh3GHMPvCzMdL
	l5DkrzmhvBvB+0OhVLrDMSPbYez+zVgHNUof7Cz5auVqom1DrzohuI/6aChOIToHuldQ/05a7wz
	brw==
X-Google-Smtp-Source: AGHT+IFGWew0XmB9c0tC2o+YJi9cj8VDCzYYdxRJw0fL6BRr99o5BGwnOHpBqTEVJxovZl9ooyW1S6VaUXE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2e0d:b0:e03:2f90:e81d with SMTP id
 3f1490d57ef6-e041b14c989mr797370276.11.1720828639756; Fri, 12 Jul 2024
 16:57:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 16:56:58 -0700
In-Reply-To: <20240712235701.1458888-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712235701.1458888-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712235701.1458888-9-seanjc@google.com>
Subject: [GIT PULL (sort of)] KVM: x86: Static call changes for 6.11
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Here's a massage pull request for the static_call() changes, just in case you
want to go this route instead of applying patches directly after merging
everything else for 6.11 (it was easy to generate this).  If you want to go the
patches route, I'll post 'em next week.

The following changes since commit c1c8a908a5f4c372f8a8dca0501b56ffc8d260fe:

  Merge branch 'vmx' (2024-06-28 22:22:53 +0000)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-static_calls-6.11

for you to fetch changes up to b528de209c858f61953023b405a4abbf9a9933da:

  KVM: x86/pmu: Add kvm_pmu_call() to simplify static calls of kvm_pmu_ops (2024-06-28 15:23:49 -0700)

----------------------------------------------------------------
KVM x86 static_call() cleanup for 6.11

Add kvm_x86_call() and kvm_pmu_call() wrappers for KVM's static_call() usage
to improve readability and make it easier to connect the calls to the vendor
implementations.

----------------------------------------------------------------
Wei Wang (3):
      KVM: x86: Replace static_call_cond() with static_call()
      KVM: x86: Introduce kvm_x86_call() to simplify static calls of kvm_x86_ops
      KVM: x86/pmu: Add kvm_pmu_call() to simplify static calls of kvm_pmu_ops

 arch/x86/include/asm/kvm_host.h |  11 +++--
 arch/x86/kvm/cpuid.c            |   2 +-
 arch/x86/kvm/hyperv.c           |   6 +--
 arch/x86/kvm/irq.c              |   2 +-
 arch/x86/kvm/kvm_cache_regs.h   |  10 ++---
 arch/x86/kvm/lapic.c            |  42 +++++++++---------
 arch/x86/kvm/lapic.h            |   2 +-
 arch/x86/kvm/mmu.h              |   6 +--
 arch/x86/kvm/mmu/mmu.c          |   6 +--
 arch/x86/kvm/mmu/spte.c         |   4 +-
 arch/x86/kvm/pmu.c              |  29 ++++++------
 arch/x86/kvm/smm.c              |  44 +++++++++---------
 arch/x86/kvm/trace.h            |  15 ++++---
 arch/x86/kvm/x86.c              | 324 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------
 arch/x86/kvm/x86.h              |   2 +-
 arch/x86/kvm/xen.c              |   4 +-
 16 files changed, 261 insertions(+), 248 deletions(-)

