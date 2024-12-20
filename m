Return-Path: <kvm+bounces-34203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 106AB9F89D8
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 03:00:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE03E7A0F66
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 02:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657532C859;
	Fri, 20 Dec 2024 02:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4bFefJQs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C90259C
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 02:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734660010; cv=none; b=HnN6B5v/PSJmDr2iuPgYwojaiZggL2fcVoperI3pQzds0Jfzx0a8XEjaikBET5uv3sI8nd/00Iz0f5O19NZvffGpWbOghzOicPkA3krhZZQONUE22c2WySMyNcUJXB1MPectepaMl0DcIxAkwCKnytHEK1KsOcQXxG0oF27n/N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734660010; c=relaxed/simple;
	bh=0MjuE3AuEZUz7bVfrS56wV/0HjYrgzbCPmts/Ynzi1E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lwIce5886bGU9FLLCZe8yZapepgZgVU1ijOU/DdTAAzR4UdW259iLc4xOBM+Twb/GfVMs7JcbtKg1v0L1QK22XR88S0OQP7FgPS4B9HErUP81ieBCGk42XXadwNQjJpKBdAXGO/1Hv19kbInrnacy89nhw1dkWR++j9TTQ47RG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4bFefJQs; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-801d2d2d31cso1013865a12.1
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 18:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734660008; x=1735264808; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdXxUgwcuMnF2ITGt9X/M3zvlV0U58vWorLtLZ2AYkg=;
        b=4bFefJQsbRxS7g9qkKjHM4x+XCNMLqf1CWqkT9J4JzGBAjGyW5HrVglzYPdfgutlIm
         D1ovx3FoeZqPQ2TOs3lM2WY3Cyk1dsU+eNTMrHTnQ7BwPf9a2BWveVosrdMDhkoKSo9i
         IeL4M+W2P6HrDh9RPulOUNMHw+EmBhdjkHzmcCdeaCqtlXxn09d/YiQTVPUt/vZ/hR//
         8lB7RTkRf4SPRo57lv0qE2HokPvMafHqAJeZNuDuZNPl2moTt1kcgj9StoGI7zT1XtfL
         aZBEh44H39Oz9v2huvTgdLtZVtHmhzu8XcflhGwwiLQ9rsjhCiMU6MZatXdBnViR1YT4
         /p9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734660008; x=1735264808;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdXxUgwcuMnF2ITGt9X/M3zvlV0U58vWorLtLZ2AYkg=;
        b=JOAO7ztcoNbve2mfkpPXtz4vGtzRYsPmxmVgp46shKTkG+/gVZ3FE5hH4Xywd0rVLP
         ClMi8QMZyohQH0+GY2q1xEhn+ICpRJm43YsZavY4E+pyTCO6v9UxfUeu0xa88iLrmkm+
         1cXTm2RGGn+sO4iFONGu3dxv31eh8cxhzOM+kkLoiDx3My0QH2zkmgOAwqrStfwDsPHI
         kopSS/mpf7XQDxwEMnSrc9OwgdNdrlJwi9urKlYQQLNsnwKIrVHBkYB7he8+39xEZQGb
         6s+egcw5mYzoGBbDW3M0ghhcK9sigAC3D1zFKhzCycR+dm84bkDN4Pibf6LyfOqNpBKQ
         bCbg==
X-Gm-Message-State: AOJu0Yyk/S9uyFu65FDvQdu0Ek/6mCghZtexqHKEim9qEnFzyRJuR0aB
	oUEaVFMJDzxa2x2SkLJ8DAKcJAnenuvkIy8I1Izyrn3MBNOpIgYme0FgHPQuCXnKyiS28PZ8vuR
	AvA==
X-Google-Smtp-Source: AGHT+IH+R5ytHsRdGnceqedHrQH0tF7mu2K4LzwEtX258bWkGtywSpM4ut3iaMK7ueJ/xdIgU3KBI89MB7Y=
X-Received: from pjbqd4.prod.google.com ([2002:a17:90b:3cc4:b0:2ef:8f54:4254])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:548e:b0:2ee:741c:e9f4
 with SMTP id 98e67ed59e1d1-2f452e220c3mr1822633a91.11.1734660008405; Thu, 19
 Dec 2024 18:00:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 18:00:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220020005.3526402-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Fixes for 6.13-rcN
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

I'm a moron and initially based this on kvm/next, and didn't notice until the
diffstat for the pull request was absurdly large.  As a result, all commits
were *just* rebased, like 5 minutes ago.

I smoke tested the branch, but didn't do anywhere near my usual level of testing.
I'm sending it now, because I suspect it'll be far easier on you to get this
today, and because we've probably got bigger problems if these don't work on
kvm/master.

*sigh*

The following changes since commit 7d4050728c83aa63828494ad0f4d0eb4faf5f97a:

  Merge tag 'vfs-6.13-rc1.fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs (2024-11-27 08:11:46 -0800)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.13-rcN

for you to fetch changes up to 386d69f9f29b0814881fa4f92ac7b8dfa9b4f44a:

  KVM: x86/mmu: Treat TDP MMU faults as spurious if access is already allowed (2024-12-19 17:47:52 -0800)

----------------------------------------------------------------
KVM x86 fixes for 6.13:

 - Disable AVIC on SNP-enabled systems that don't allow writes to the virtual
   APIC page, as such hosts will hit unexpected RMP #PFs in the host when
   running VMs of any flavor.

 - Fix a WARN in the hypercall completion path due to KVM trying to determine
   if a guest with protected register state is in 64-bit mode (KVM's ABI is to
   assume such guests only make hypercalls in 64-bit mode).

 - Allow the guest to write to supported bits in MSR_AMD64_DE_CFG to fix a
   regression with Windows guests, and because KVM's read-only behavior appears
   to be entirely made up.

 - Treat TDP MMU faults as spurious if the faulting access is allowed given the
   existing SPTE.  This fixes a benign WARN (other than the WARN itself) due to
   unexpectedly replacing a writable SPTE with a read-only SPTE.

----------------------------------------------------------------
Sean Christopherson (3):
      KVM: x86: Play nice with protected guests in complete_hypercall_exit()
      KVM: SVM: Allow guest writes to set MSR_AMD64_DE_CFG bits
      KVM: x86/mmu: Treat TDP MMU faults as spurious if access is already allowed

Suravee Suthikulpanit (1):
      KVM: SVM: Disable AVIC on SNP-enabled system without HvInUseWrAllowed feature

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kvm/mmu/mmu.c             | 12 ------------
 arch/x86/kvm/mmu/spte.h            | 17 +++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c         |  5 +++++
 arch/x86/kvm/svm/avic.c            |  6 ++++++
 arch/x86/kvm/svm/svm.c             |  9 ---------
 arch/x86/kvm/x86.c                 |  2 +-
 7 files changed, 30 insertions(+), 22 deletions(-)

