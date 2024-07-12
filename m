Return-Path: <kvm+bounces-21583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1786E93028E
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:58:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5D4E1F2297C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 23:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951AF136649;
	Fri, 12 Jul 2024 23:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U0HThBE4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6BF13775F
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 23:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828633; cv=none; b=NcUCHMJ5i6iUFbe/MCbTv+/8pAMZ9Hpm9rxIGjp0gzEmdI1XX79w4rhtiPauAAFziwh8kpSBbLYXQModcba/+KP09OiZs7T5ryrUodUvrbFlf3fBOS7uBboTn/r6iXW5Xq93AcP2yL+iwJBSXa6ovGcfnOs54RZrRAXcfH63sVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828633; c=relaxed/simple;
	bh=1tc/SxgnGQzs/wfQKgsplyHPjx9j9umDf1cy6BRBm/s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MrZB4PCZyOSua0cNLGqyiyTC6Kl5G27Iy0mKJ3zja82hzdg0P4QW2dA3xIAnx7fhkykUowJ8YomwCPJ29xn162i8Yv9JAAu0iVVXOV8EgSioFvZHsMzj9grYDhjFtniGP9jWq4V02DiVruccxbAUAe+StxBOqoweAeB2JJ2kFcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U0HThBE4; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-778702b9f8fso1435823a12.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720828632; x=1721433432; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LPdW5y0JyvKpaTGQ10x+xv6Pv2kVXNdt0axaqxmhT+Y=;
        b=U0HThBE4aAOB8duHJizN/fd+SZV7Ey5SANY+mWuKf15vQLtw4h0tGvDxV1MUsrAjYB
         BidNHC5E2DQfgp79ND2Ad3gpAMM3KvwXlBEtRTpn3GFJqnlhEBqJDB0hSPP2jnLLWAFv
         fb6JFYUJYwifp0pPBD3QrhOPGgPIc7UmkLrcsxPXuaaTx5EP3pPjRMA/d0gguOQdTT0U
         /iFDAHm+hOlIuRnkAZbpLTdguzaCMxhjU7m81fqoA9gCAFtGtQ6iwouVe08HXoxFv0E0
         PoAPLKI/Dfvk6LbJ5G7lZ69tV6PlZ+M5IBFl8rQcSXrY9lGAKmUi9dYa9DpZ16QAZlvm
         j6gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720828632; x=1721433432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LPdW5y0JyvKpaTGQ10x+xv6Pv2kVXNdt0axaqxmhT+Y=;
        b=Jl/51n3WY/SJOZVCWonbBAMS3tG6uOaK8lZ3oMiHULg065RDsXrRb9Vg5XQQzSD417
         YyiU4U7XNSt8cmQcrc8gVo0L1uAwicJyHfOIsWjAxFJtcn20bpyanzPbWr17dUYm15gI
         VWSc+E72s2qkRL3Tbwyw8WiQUDVTv9zMu6BUoCdK673AEnTsQf68RCQ8CrejUI5SyW8C
         PkEcvhs9n6eNDio7ZNwEeEDwMKsBApxR3Sr++h/VuPwj+3hGiH9PFnjvhyF986eyJQK+
         ZaLkkkxYbDLpKdIQD1HLCxuH8uRtnRYrySFTGTlfaPjiJkprfNYIPRtso86fIEMzkAaD
         STyA==
X-Gm-Message-State: AOJu0Yy9ZLIg6a6l1oFP4ThdNlh+QfXZa7ieszxWqZEvSNlWQKDRc+Ze
	dpkTRXFRTMS4jhfEAasXb4cJgsmO3u1Ghy6xxOX7rmeEeOiN9L35rqu9evgcFBtiADqnCnN7bwY
	sEQ==
X-Google-Smtp-Source: AGHT+IGfR1Xzo3E60ZmaVC6PTp9lLtuRsOsi3lkFYdmCRlW4PvFCYaeBL4UD9MNG3P7Wwb2nGk6v4XuGmoQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6789:0:b0:6e3:a2ac:efd4 with SMTP id
 41be03b00d2f7-78a0e532eaemr8743a12.6.1720828631848; Fri, 12 Jul 2024 16:57:11
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 16:56:54 -0700
In-Reply-To: <20240712235701.1458888-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240712235701.1458888-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712235701.1458888-5-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.11
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

I got nothing for this one.

The following changes since commit c3f38fa61af77b49866b006939479069cd451173:

  Linux 6.10-rc2 (2024-06-02 15:44:56 -0700)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.11

for you to fetch changes up to 0089c055b56024edf90e85dc852440b713ce8cb5:

  KVM: x86/mmu: Avoid reacquiring RCU if TDP MMU fails to allocate an SP (2024-06-14 09:25:03 -0700)

----------------------------------------------------------------
KVM x86 MMU changes for 6.11

 - Don't allocate kvm_mmu_page.shadowed_translation for shadow pages that can't
   hole leafs SPTEs.

 - Unconditionally drop mmu_lock when allocating TDP MMU page tables for eager
   page splitting to avoid stalling vCPUs when splitting huge pages.

 - Misc cleanups

----------------------------------------------------------------
David Matlack (4):
      KVM: x86/mmu: Always drop mmu_lock to allocate TDP MMU SPs for eager splitting
      KVM: x86/mmu: Hard code GFP flags for TDP MMU eager split allocations
      KVM: x86/mmu: Unnest TDP MMU helpers that allocate SPs for eager splitting
      KVM: x86/mmu: Avoid reacquiring RCU if TDP MMU fails to allocate an SP

Hou Wenlong (1):
      KVM: x86/mmu: Only allocate shadowed translation cache for sp->role.level <= KVM_MAX_HUGEPAGE_LEVEL

Liang Chen (1):
      KVM: x86: invalid_list not used anymore in mmu_shrink_scan

Sean Christopherson (1):
      KVM: x86/mmu: Rephrase comment about synthetic PFERR flags in #PF handler

 arch/x86/kvm/mmu/mmu.c         | 17 ++++-----
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +-
 arch/x86/kvm/mmu/tdp_mmu.c     | 78 +++++++++++++-----------------------------
 3 files changed, 35 insertions(+), 63 deletions(-)

