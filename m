Return-Path: <kvm+bounces-9588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBCB861E9B
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 22:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACBB0B24742
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 21:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D613A149391;
	Fri, 23 Feb 2024 21:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HlbjI3CN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F24143C7B
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 21:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708722954; cv=none; b=rMboEzx8+XXDyHn3mj5VN0dBJzf/QgKa5bRkUP32emt/QmbCrfpQ8laIbD+FjpWEwa4yZIyi0XeacLeSv23rSrr+XQiVEibBAo0o5uFEPqU9rlVxw+Hl7SsB6obgFuZLfmcIEArTZm6zHwRO47+SNxbEaILpGp0r67gHbRpJPFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708722954; c=relaxed/simple;
	bh=vgHxZxdMlXYTUmj6SGTpWgAAujf2GaWOR9BetERwlp4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OWW5qg0IouagT8J257dLFTHvIOkG1o1RwJmJk+yaePx88CZQgF0K4BYFrIRtbw+h4zz7KIHLLdD5UcVUo7aZW7+RYtbjkj3c/lp+WNHFwBCQ5BvWO/9ywwgO+9KrIkz3fBdUN1Shd9TD94X+V4aAptq3FN9ujlkuUQSwIw1EO3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HlbjI3CN; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1dc6e067b22so5994085ad.3
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 13:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708722952; x=1709327752; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WzAzDf1ZbW9X9RCNcoDXQaNNm7qLPyl0zY/VDFk5I2g=;
        b=HlbjI3CNGSSAPTUGYpR0n8+ABBxVJEF4N8WpcTbdIM1WjEhuDlaBCqfBI8tuKx5rJv
         7rYtFr8zdH80xhm/TT6eS/qKMhLXw3nQS0o/MZ4HBfGMbITHDNdmu+wXUTN6QfcwTPNT
         BK+PbHTtjf+OemT4nFGZRMB5O/9+trRIB98RdiKC3EtCxYC4EYuFzXgey9M9+5Z15I0j
         raIPo4/BEnAcaudlLL0BCHd7PTHT9qv4W+ZK63j+WSZmU3YqdxmcF+zuO26sMgWKbKH3
         HV3lSdfWzq8wSagdtOELmtncLrzaPZbQdCxxb1IzSdpJm/aBvgh0r8aSBChaGQWy8lk2
         CZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708722952; x=1709327752;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WzAzDf1ZbW9X9RCNcoDXQaNNm7qLPyl0zY/VDFk5I2g=;
        b=hGL96lERsWiRiOHM4XoRlpkalaE3+VL8lB2XmW8qJpbioh1GpB4qpKfg+ZkaBAyEp7
         oJu5O5hSjbuB8H4IzotC0NtTnoOtxd/V9cENO9pwtGb6gfcpZjPOGMfq2aJU7jC3/AIv
         y4jyYXMHo2YHVNRDMTsk0mQN+zHuZXAcdt+5vPlNeTrrsYjxagex496mlzNptD2w9EKV
         cpd4MWr4vubOZkBYI+pewmtv8ar00Ks06foDKoVBoaw2ZUg2KA0En3Hsoo7Acy+q3i4l
         cln9vR5YbY+N+dYqz2FOOM+fQ23C75J6dQ5IckRrlpsw+9o6Q6Xz14Hy/vzA+1kLsqa1
         cQfg==
X-Gm-Message-State: AOJu0YxfezjI/dbjrfb1w8130wUk0e/i0/fzP5OflawqJzsvmFR3QbeF
	z97IQcGsW/JNLd7T8+ikCt80JIMCdVJm8Z5uwTF7v11AjFYHFUHjqoYrjK1G5FOBy1qCKqXQLcJ
	djw==
X-Google-Smtp-Source: AGHT+IHXxYB9Bt9Iy9x5nV+0dv8ES3RsQ7Ivy1Tcf1t0D4/P73qHBKHakR11vGvruAvizlYJnpUH2KjapCM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2347:b0:1db:d7bf:45 with SMTP id
 c7-20020a170903234700b001dbd7bf0045mr3740plh.4.1708722951221; Fri, 23 Feb
 2024 13:15:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Feb 2024 13:15:47 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223211547.3348606-1-seanjc@google.com>
Subject: [GIT PULL] KVM: GUEST_MEMFD fixes for 6.8
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Minor fixes related GUEST_MEMFD.  I _just_ posted these, and they've only
been in -next for one night, but I am sending this now to ensure you see it
asap, as patch 1 in particular affects KVM's ABI, i.e. really should land
in 6.8 before GUEST_MEMFD support is officially released.

The following changes since commit c48617fbbe831d4c80fe84056033f17b70a31136:

  Merge tag 'kvmarm-fixes-6.8-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2024-02-21 05:18:56 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-guest_memfd_fixes-6.8

for you to fetch changes up to 2dfd2383034421101300a3b7325cf339a182d218:

  KVM: selftests: Add a testcase to verify GUEST_MEMFD and READONLY are exclusive (2024-02-22 17:07:06 -0800)

----------------------------------------------------------------
KVM GUEST_MEMFD fixes for 6.8:

 - Make KVM_MEM_GUEST_MEMFD mutually exclusive with KVM_MEM_READONLY to
   avoid creating ABI that KVM can't sanely support.

 - Update documentation for KVM_SW_PROTECTED_VM to make it abundantly
   clear that such VMs are purely a development and testing vehicle, and
   come with zero guarantees.

 - Limit KVM_SW_PROTECTED_VM guests to the TDP MMU, as the long term plan
   is to support confidential VMs with deterministic private memory (SNP
   and TDX) only in the TDP MMU.

 - Fix a bug in a GUEST_MEMFD negative test that resulted in false passes
   when verifying that KVM_MEM_GUEST_MEMFD memslots can't be dirty logged.

----------------------------------------------------------------
Sean Christopherson (5):
      KVM: Make KVM_MEM_GUEST_MEMFD mutually exclusive with KVM_MEM_READONLY
      KVM: x86: Update KVM_SW_PROTECTED_VM docs to make it clear they're a WIP
      KVM: x86/mmu: Restrict KVM_SW_PROTECTED_VM to the TDP MMU
      KVM: selftests: Create GUEST_MEMFD for relevant invalid flags testcases
      KVM: selftests: Add a testcase to verify GUEST_MEMFD and READONLY are exclusive

 Documentation/virt/kvm/api.rst                       |  5 +++++
 arch/x86/kvm/Kconfig                                 |  7 ++++---
 arch/x86/kvm/x86.c                                   |  2 +-
 tools/testing/selftests/kvm/set_memory_region_test.c | 12 +++++++++++-
 virt/kvm/kvm_main.c                                  |  8 +++++++-
 5 files changed, 28 insertions(+), 6 deletions(-)

