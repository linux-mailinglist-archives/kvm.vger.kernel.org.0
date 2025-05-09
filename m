Return-Path: <kvm+bounces-46089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2BFCAB1CD9
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 21:01:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B97153B0D39
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 19:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1A3239E82;
	Fri,  9 May 2025 19:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ey8F0b1i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBC91DE4D8
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 19:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746817278; cv=none; b=Drbw33F7eski9/kn01CPZDZzIV4y9P/dThsijjckf/l82qWQ0PDo3vZDcdhktiq5Op281hkr6N5O/CvjHTW7WE3WV7GNKxdPKItvveKricPCBCzKsrAw2dHoJkDet66dLNcD4UlqY7/ZiBnLjVco+UuSa0sfpPwNcM5+2vPK4dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746817278; c=relaxed/simple;
	bh=wdfsqsckqhMGnjMh738/zfexAs8ObzwNX0Y2Uh4s3xw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YLPcweh+6BiMXnREpWBPD6E7xQcylqWOoXrAtonkh08vF0U15zuKzsmOMFt2FMe1cJdSuDtxs2MQ+bac+C75hBvsKZqxfC11ABt9oJGIA2f/wFMfqbOLRCPmTHMgiFdIyBm37+87Lop5wSUrZHbEmcQJvE3JoN6hlqkrpKzDA0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ey8F0b1i; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30c54b4007cso500685a91.3
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 12:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746817276; x=1747422076; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZOp4IXBb/syBVOduCVpjLE8qaedTDykguJc6N1WRR7Y=;
        b=Ey8F0b1iaZqtVbczn/dnA5cWYeAgY0KTwJSS+V1jB8FVpA97xcUFBGlHZLyiwtcOYX
         rVVSR/ScqmKXMD1AWjCGc2FWAs3a4NoTJQSmtSOmHOZ7zZHYbIkbnLhgfeflzHxP/6/J
         2v04LT0I1BC5fgKTyhbN8145qU1nxM3yv8hLKYyGcKranAA2LgLrh51dtguySqXUvUac
         d3cJci6j+qKx9e6O7muGVAKtQN+uzj8Y0B1xwgKB0Jur6ZXFJE4QmPepFgHi4bXLyg1h
         oL/DhDKaJ2DnXR3NofsvMrvvOM70tDnMYtvrk84HUnbpEA09WB0QWTdUQL04UiONRc3c
         YopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746817276; x=1747422076;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZOp4IXBb/syBVOduCVpjLE8qaedTDykguJc6N1WRR7Y=;
        b=b6GXndAaG6lAn0BKEO+hHbaFAIidimLoSv3jjntu5fsJ0jU5Uw4KJiIiTdijqetniC
         TnVqpNHUj9d8P3NbxJgpCwaftv9329pEwsWsCWrKxZ0ZjPMzQGt97hsJcczUXMRwiwJg
         6kjAcvo/O1UEXwqEEz9fObRfRLyHO4EolWJCn8qmYDTQsWCaoTAmYREZnterdiVPVEfu
         GO+oQ3NbYXTd7ZPbS2wETrdsPL2fIjH7o9G5mWTPjriKMFJs7yvxOv1CEQLO6WvSDdO4
         2nToikPgJZk+IcRfxtz/B6/vFsia66y5vK2ohpSrD9mOVeOi230F7BX6CuxDRzP1b7ny
         VLgw==
X-Gm-Message-State: AOJu0Yy7mu4VQ3YfeDH/LkLwFHr/px3Ag55H4nzcTxKkF/a+GbYA0/hC
	f4tTvzq4z35gjoCA+h9UN4hnVHnNq5b89B8xqoCAXzye1N6vv4mZ+yXhGL0rPBaAg4Uex8YCiWb
	B3A==
X-Google-Smtp-Source: AGHT+IHCrDyEz8O6bZis7LOBWSaBNV9yXvdcRsP9akFy28mpxZXtdyL2qSdZfjeySCSUfDuZJgBWCfKjjOY=
X-Received: from pjbee7.prod.google.com ([2002:a17:90a:fc47:b0:2f8:49ad:406c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d2cc:b0:2fe:b937:2a51
 with SMTP id 98e67ed59e1d1-30c3d653adbmr6222867a91.33.1746817276439; Fri, 09
 May 2025 12:01:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 May 2025 12:01:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <20250509190108.1582362-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Fixes for 6.15-rcN
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a random variety of fixes for 6.15.  The SRSO change is the
most urgent fix, everything else has either existed for some time, or isn't
actively causing problems.

The following changes since commit 2d7124941a273c7233849a7a2bbfbeb7e28f1caa:

  Merge tag 'kvmarm-fixes-6.15-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2025-04-24 13:28:53 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.15-rcN

for you to fetch changes up to e3417ab75ab2e7dca6372a1bfa26b1be3ac5889e:

  KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1 VM count transitions (2025-05-08 07:17:10 -0700)

----------------------------------------------------------------
KVM x86 fixes for 6.15-rcN

 - Forcibly leave SMM on SHUTDOWN interception on AMD CPUs to avoid causing
   problems due to KVM stuffing INIT on SHUTDOWN (KVM needs to sanitize the
   VMCB as its state is undefined after SHUTDOWN, emulating INIT is the
   least awful choice).

 - Track the valid sync/dirty fields in kvm_run as a u64 to ensure KVM
   KVM doesn't goof a sanity check in the future.

 - Free obsolete roots when (re)loading the MMU to fix a bug where
   pre-faulting memory can get stuck due to always encountering a stale
   root.

 - When dumping GHCB state, use KVM's snapshot instead of the raw GHCB page
   to print state, so that KVM doesn't print stale/wrong information.

 - When changing memory attributes (e.g. shared <=> private), add potential
   hugepage ranges to the mmu_invalidate_range_{start,end} set so that KVM
   doesn't create a shared/private hugepage when the the corresponding
   attributes will become mixed (the attributes are commited *after* KVM
   finishes the invalidation).

 - Rework the SRSO mitigation to enable BP_SPEC_REDUCE only when KVM has at
   least one active VM.  Effectively BP_SPEC_REDUCE when KVM is loaded led
   to very measurable performance regressions for non-KVM workloads.

----------------------------------------------------------------
Dan Carpenter (1):
      KVM: x86: Check that the high 32bits are clear in kvm_arch_vcpu_ioctl_run()

Mikhail Lobanov (1):
      KVM: SVM: Forcibly leave SMM mode on SHUTDOWN interception

Sean Christopherson (2):
      KVM: x86/mmu: Prevent installing hugepages when mem attributes are changing
      KVM: SVM: Set/clear SRSO's BP_SPEC_REDUCE on 0 <=> 1 VM count transitions

Tom Lendacky (1):
      KVM: SVM: Update dump_ghcb() to use the GHCB snapshot fields

Yan Zhao (1):
      KVM: x86/mmu: Check and free obsolete roots in kvm_mmu_reload()

 arch/x86/kvm/mmu.h     |  3 ++
 arch/x86/kvm/mmu/mmu.c | 70 +++++++++++++++++++++++++++++++++++-----------
 arch/x86/kvm/smm.c     |  1 +
 arch/x86/kvm/svm/sev.c | 32 ++++++++++++---------
 arch/x86/kvm/svm/svm.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.h |  2 ++
 arch/x86/kvm/x86.c     |  4 +--
 7 files changed, 150 insertions(+), 37 deletions(-)

