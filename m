Return-Path: <kvm+bounces-24975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B60C095D9F8
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D77841C21874
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:57:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0C11C9446;
	Fri, 23 Aug 2024 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ub1SjW0j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F971C8719
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457414; cv=none; b=MWScr9y7bpLgknMgy9WkJ23XE8mEO4X2biqfLINWHNLyMQD+Fe1jfMPQ/+5eYnhnWmqPG0B4e6RXH1o79U+l44la0MepJxTEw5lDqxkz3x7ykyEw4xAfvpSLBkHt18x2waGNkdB49/FF6pkylo1+ZTrO3lzG9/pxx/5irzuRpd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457414; c=relaxed/simple;
	bh=o0GK5SfNb+HDWC/3OWCLXCmTajLtKXMehqGGfRWDulA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=q6xRz+zppFIiJ36XFAxVikfd0aSswuM/vxOnvnBJpEEy59k7ezpruh9nX+b9C115polafgqtSUfxr2r8ios7oaONAD1GcADkEkPkxMTPc9qEkKtAgIGiR7zkFAA5lVRBH44cqGAiBF8xaVtCB1RNndsNgMagcTknTAV1441iQKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ub1SjW0j; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e11703f1368so3562133276.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457412; x=1725062212; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hyZPxc962VEyo6REh9f3Mb5ZmDJ2auwWgyLRHO8GyG4=;
        b=Ub1SjW0jHBNycj56/a8aR/l0/F4ELGFOIS9YFh29A3kE2VZCtOpzJSlIthWiy6fgOK
         y4SGXdt2VCTudaaiywWT+AUeJH7G7qQv/7gnGYZYbBqT7uqibrbdJCXmU+iGtxH+JlGX
         0IcQ5eF0s3xfl6/XNLzlJoR4L3aFxQpP9VVBejQ4MugVJGlNqTAJTh03YuKhl5B6alVX
         geRQny92tNBqkYF1/fk8ilkE2p1WAKaMZn5g5X6vQRf8KeX2gcAWS0LHyORKZmDpkVHN
         pG8jSG7yKAPGo/BT21vEyXbiHWdIjTLGiyVICvRI2RZpesjDai9N7bv1sZCQWExgfC6A
         Ox3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457412; x=1725062212;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hyZPxc962VEyo6REh9f3Mb5ZmDJ2auwWgyLRHO8GyG4=;
        b=AQWMIEvl8NyHrN58sBWk1AWBHJIKA88OxTd8vQeBgNZBB9wjuSEy5ZRyNNm9kS7L7O
         rgdT8NrIuWQ+Bg7+H5ijpzrtWIpEbhpYb6drdVO55p3tNYBkggzqNwtXJV46lo+kkhxK
         whnB20L0EX3zw7aqvG8awC4d2B4P/tAeoFIKtzj32m1yQFo0JoBxXKwP1qE40P5QnFpR
         qccThkmBTkAmmkBzmKpsEw0zT8hcZSUlC+F8Q8SJzvuPJEJ/jhovwNPM/b+UPIEwu0y5
         4efInTpc9Nr+t2Ii4PNLkDwuHZ551xY9bjsGHORHmoP+d5yGwQkEcFt8TqOs8G07c9sw
         2Tag==
X-Gm-Message-State: AOJu0YyC3zfm47FpG/NMdWYYggUvTsZ5/TE095hv8SRjiE/JsC4HU8QI
	Syu1kET8LCjpC2/t2KhRsaCUrhaIw2H4Y87wvU86I3aLW/P0tglVHNxpdb5OQHZkySNfGX+BEKT
	Cl/6AJj4Qnw==
X-Google-Smtp-Source: AGHT+IF5yfV7xUb+YzY+RoB100zJevheaiUVTqLFzqezKizbf0dLZpl93Ii6sd0WGS0MZSLPAurxlRBjIgmlyg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:6b48:0:b0:e16:5990:8922 with SMTP id
 3f1490d57ef6-e17a83afe36mr6228276.1.1724457412225; Fri, 23 Aug 2024 16:56:52
 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:56:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823235648.3236880-1-dmatlack@google.com>
Subject: [PATCH v2 0/6] KVM: x86/mmu: Optimize TDP MMU huge page recovery
 during disable-dirty-log
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Rework the TDP MMU disable-dirty-log path to batch TLB flushes and
recover huge page mappings, rather than zapping and flushing for every
potential huge page mapping.

With this series, dirty_log_perf_test shows a decrease in the time it takes to
disable dirty logging, as well as a decrease in the number of vCPU faults:

 $ ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 64 -e -b 4g

 Before: Disabling dirty logging time: 14.334453428s (131072 flushes)
 After:  Disabling dirty logging time: 4.794969689s  (76 flushes)

 Before: 393,599      kvm:kvm_page_fault
 After:  262,575      kvm:kvm_page_fault

v2:
 - Use a separate iterator to walk down to child SPTEs during huge page
   recovery [Sean]
 - Return SHADOW_NONPRESENT_VALUE in error conditions in
   make_huge_spte() [Vipin][off-list]

v1: https://lore.kernel.org/kvm/20240805233114.4060019-8-dmatlack@google.com/

David Matlack (6):
  KVM: x86/mmu: Drop @max_level from kvm_mmu_max_mapping_level()
  KVM: x86/mmu: Batch TLB flushes when zapping collapsible TDP MMU SPTEs
  KVM: x86/mmu: Refactor TDP MMU iter need resched check
  KVM: x86/mmu: Recover TDP MMU huge page mappings in-place instead of
    zapping
  KVM: x86/mmu: Rename make_huge_page_split_spte() to make_small_spte()
  KVM: x86/mmu: WARN if huge page recovery triggered during dirty
    logging

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu/mmu.c          |  16 ++--
 arch/x86/kvm/mmu/mmu_internal.h |   3 +-
 arch/x86/kvm/mmu/spte.c         |  43 +++++++++--
 arch/x86/kvm/mmu/spte.h         |   5 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 129 +++++++++++++++++---------------
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 arch/x86/kvm/x86.c              |  18 ++---
 8 files changed, 128 insertions(+), 94 deletions(-)


base-commit: 728d17c2cb8cc5f9ac899173d0e9a67fb8887622
-- 
2.46.0.295.g3b9ea8a38a-goog


