Return-Path: <kvm+bounces-9587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A412861E98
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 22:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CC86B23BB6
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8985A14938A;
	Fri, 23 Feb 2024 21:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tln3zlM6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA3A143C7B
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 21:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708722913; cv=none; b=FFnnv7uGkDuLLAhyy6PhJ7S5j1+KV66T4VWfkOKVhKoUhblPCccFcCpm0Wb9DaQpEi9RsMJoWYPaGX6hot7e5KGZB2aUOiL/9MUBYMRX/idRzg0qYB1UZG7F7HAi6iCWBlMIlrP9xJuY3eK14ZVC3X55Iz/32i9/NjRuNwFMQpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708722913; c=relaxed/simple;
	bh=+0WaxtfD1vqOSIN4udZF0ovEeRsC84FbHnJOBPb+zkE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=R0sBkf7Gjf0cwX7jgjPKbKMCrCT0EpPU3RSxxBDbhgrMWxnjwSz26sFhW/mq2l2IqsFNoQU6kKXhkuY9yK4whfa3BFKZryWNwewRJ6JdLOabjyKVzpGJ/Ynat8n1NWyCAyxhDyjCv7nYo2ZqHamHobg/nv4XJwkG+FZSVsKCrX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tln3zlM6; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e4cce1df30so511872b3a.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 13:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708722912; x=1709327712; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ThK88zue8GNITt8rUbbFtND5su1NoXeP0vADQsaZtQ=;
        b=tln3zlM6yedG2fyGP7nMd+jbK8gSWrs3EwusvIIDV+qjLeYUxfu9DUHz+q+7nHqfwN
         FpbRBBJ15NnsWCjtjL6X91VsoBhkPGJhrPfWovTTqywDRn2FfLjngVa0n0lAJFm21ref
         GUdYYH9Ytah76G6XNoAxN6d89KE3Z3c1QTTOQrIrxrt1wdaVMjxvDPzc/w8TRgvzM2nt
         qlaiY9BGnm7nBESrhfHeBBr+5A9sYCfQR6k/0rVFSsI9xwyUQb1Hu0y+70gfy9v7zhRi
         hJujoUNs5QaXBFT7lZuCot7nw6SuN6f/VJu7HibPwCsuFry5nO3Gd2EjyNljPJ3sQTEk
         UwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708722912; x=1709327712;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ThK88zue8GNITt8rUbbFtND5su1NoXeP0vADQsaZtQ=;
        b=xIB7G/awqIRHVLun3EPPvrFoEOumLjT3AxCF6VBB7sqpoU9tzpL9aKcBgjprrJERep
         8aEUZefRD2v02yCFXRUjDuPqorVgimNAmHj4SvfkuImaQZhxGI4XZ2lu5e1cllDIEcxG
         umEO3YA1mSv2t2EpwEVtp5sPGc70V6Sz6hNg5brpG2WKAbHvSghuKLlJvV9SV9PSNCjl
         B34fs2bDM5vSMH9P9BA6bS1zcP1V2/95Awl16uN1KnOF9VV/VBqZKIoxQr9WC8HjjU1F
         j5d946PSXX9fvRlrJgZRxT3nM892KzZC8ubGGCWGMTlgQsuizvXFyRbawv4met2qPvvo
         IQLQ==
X-Gm-Message-State: AOJu0YySEUA4flMuYupIqpxg5v0HnLYLi5UKfRanqvCjweXQPMe+TOLR
	j+B3CLH1snjHZcW/OInwY8BRhS9klq1NhaPxEPaOoz8/YGUey2afXZgfVFLf/k0sytpEC0df5Rv
	g5g==
X-Google-Smtp-Source: AGHT+IFnRqQ9Ip4giF4SYFt4PQige1puzsn+4jMkz+howHVeOccb0ece5cfhr31wlJ/8Rq8OhiyjDY+RjPA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3c86:b0:6e4:8b79:f5c6 with SMTP id
 lm6-20020a056a003c8600b006e48b79f5c6mr59831pfb.5.1708722911728; Fri, 23 Feb
 2024 13:15:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 13:15:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223211508.3348529-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU(ish) fixes for 6.8
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Two more MMU-related fixes for 6.8.  The first, and worst, fixes a data
corruption bug during live migration due to KVM failing to mark a memslot
dirty when emulating an atomic access.  Luckily, our userspace caught the
corruption during checksumming after the final pause, but I've no idea if
QEMU-based VMs have such protection.

The second fixes a long-standing, but recently exposed, issue where yielding
mmu_lock to vCPUs attempting to fault in memory that is _currently_ being
zapped/modified can bog down the invalidation task due it constantly yielding
to vCPUS (which end up doing nothing).

The following changes since commit 9895ceeb5cd61092f147f8d611e2df575879dd6f:

  Merge tag 'kvmarm-fixes-6.8-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2024-02-16 12:02:38 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.8-2

for you to fetch changes up to d02c357e5bfa7dfd618b7b3015624beb71f58f1f:

  KVM: x86/mmu: Retry fault before acquiring mmu_lock if mapping is changing (2024-02-23 10:14:34 -0800)

----------------------------------------------------------------
KVM x86 fixes for 6.8, round 2:

 - When emulating an atomic access, mark the gfn as dirty in the memslot
   to fix a bug where KVM could fail to mark the slot as dirty during live
   migration, ultimately resulting in guest data corruption due to a dirty
   page not being re-copied from the source to the target.

 - Check for mmu_notifier invalidation events before faulting in the pfn,
   and before acquiring mmu_lock, to avoid unnecessary work and lock
   contention.  Contending mmu_lock is especially problematic on preemptible
   kernels, as KVM may yield mmu_lock in response to the contention, which
   severely degrades overall performance due to vCPUs making it difficult
   for the task that triggered invalidation to make forward progress.

   Note, due to another kernel bug, this fix isn't limited to preemtible
   kernels, as any kernel built with CONFIG_PREEMPT_DYNAMIC=y will yield
   contended rwlocks and spinlocks.

   https://lore.kernel.org/all/20240110214723.695930-1-seanjc@google.com

----------------------------------------------------------------
Sean Christopherson (2):
      KVM: x86: Mark target gfn of emulated atomic instruction as dirty
      KVM: x86/mmu: Retry fault before acquiring mmu_lock if mapping is changing

 arch/x86/kvm/mmu/mmu.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c       | 10 ++++++++++
 include/linux/kvm_host.h | 26 ++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

