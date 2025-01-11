Return-Path: <kvm+bounces-35190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1C3A09FFB
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 02:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA7D53A940E
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73C5D1CFBC;
	Sat, 11 Jan 2025 01:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lxJdgJzO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0214C83
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 01:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736558694; cv=none; b=I0+SbQQgNV6zfLzWj8Mdd6alVog3S+39mtnCpDyc28QRkif5K2b7brCxji5XmcF50l4TVl6KERkQxESpRJ1HabWLeZPsuSi8LZBu4DX1o+TaTRPSoFRxNKGHzNzzWeiC033/mfk6S2U90SJHqTQhQZo5xfT2dHb+TdaqNo2Wmw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736558694; c=relaxed/simple;
	bh=TNA4ediMoh+0GARbkBQh+cxo7semdS4NBzhtyKW9kfI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hdJgM1vVYYtgcJG26p3mM3PElcJDvAXhK9msr9tBES5KfWiUQx1BOsXuUVJ/kW86NpKpU+EAqB6CF7NGqYgpWN4qHAiZ1/di97S/wIcfJZJ5pSvAAWpte/MJWrQdYxF8m+sCVe9JyIEmHdVKDkCjMyGbds/ebseja0UoyNcHuMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lxJdgJzO; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so4840171a91.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736558692; x=1737163492; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wth181Oju/yKYvdF4NH88lRCMZbnQWr4S1ULRikLXgA=;
        b=lxJdgJzOTw7b+gIL917XVl2NMU2FtnYSTQnmMh/ZoyIp4kmtYxEpHpUFCsrgO17XR1
         nBVtkyX9CakSct0i7M6XpUkewhlFeAunU6eLBloHRnzHrjdLFVnuBqQ+a3Y8wfjCEHbp
         BcxbHI/14InkNmoATSZM7tquIoZ114Wd+zHzaGXdvai1wHghp6xqdjrz252NlsGwb8lK
         uTbZz/I7Hr5gPB19K9FqCNLSlxi6Bip12rkFyihM17WHb8jIdzH2HxsUkfBp2dgyi0l7
         0mQWeoosbc27N6mQ+KtnhjDcgENaxUJIzBPHqmjlcyJZ03LeYqJ9NjxiTyC2tEgUKUuE
         5zLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736558692; x=1737163492;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wth181Oju/yKYvdF4NH88lRCMZbnQWr4S1ULRikLXgA=;
        b=U4kS5JlH4hDaaRR9BhE+dZjKzw06+SVK+MLyhsHUUug04Vbztbou/FIUdK5DnyDAoF
         jvyuBiaTej/riMym91EmHxR7JjAeTYPCMWOFiNqZnYdRvR6/21yRGCE+NGGW1CvH7vXg
         +tZWUzQ40FflKOA4//GnVu5mS/U2p+WvOw84V6euLDJXdv+4FosUeMQIF7/HqlRxVF7C
         BRasY6JxmVH7gu5jCczMsDSwDjjxz8eCbe2Oi+rIj78N/zKeQ3FTWRKGZZwGs7ixNEer
         KebJDa+w3eSxYIXThQk3VcPN9ikuuqPUfSTVYB0KZ3u0tdLsi+eFuH4FSidbBC0zqTnd
         0lMQ==
X-Gm-Message-State: AOJu0YzROwGXcYZaY3Z1ESfCZHcFBJIllfZueDdllkb0e9qiM0FN1MAu
	EzxF5X2WSTH1xpAyFlo38/tbfwC6kiC06uQNEVZwF5hW37J7lnRPA4DQo/nUrXYxGjzgVFa5EKP
	2yA==
X-Google-Smtp-Source: AGHT+IEfMuWFVKhsS9utsiRr0qZN46F4y7a5kx/arb7GLt+tjCHLQTHDuOdaekKI3i56eThn0gAXDuFPjYQ=
X-Received: from pfef19.prod.google.com ([2002:a05:6a00:2293:b0:725:e39e:1055])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:230a:b0:725:ef4b:de30
 with SMTP id d2e1a72fcca58-72d21f4b537mr18483242b3a.14.1736558692541; Fri, 10
 Jan 2025 17:24:52 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:24:45 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111012450.1262638-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: Add a kvm_run flag to signal need for completion
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman <mpe@ellerman.id.au>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a flag to kvm_run, KVM_RUN_NEEDS_COMPLETION, that is set by KVM to
inform userspace that KVM_RUN needs to be re-invoked prior to state
save/restore.  The current approach of relying on KVM developers to
update documentation, and on VMM developers to read said documentation,
is brittle and error prone.

Note, this series is *very* lightly tested (borderline RFC).

Sean Christopherson (5):
  KVM: x86: Document that KVM_EXIT_HYPERCALL requires completion
  KVM: Clear vcpu->run->flags at start of KVM_RUN for all architectures
  KVM: Add a common kvm_run flag to communicate an exit needs completion
  KVM: selftests: Provide separate helper for KVM_RUN with
    immediate_exit
  KVM: selftests: Rely on KVM_RUN_NEEDS_COMPLETION to complete userspace
    exits

 Documentation/virt/kvm/api.rst                | 77 ++++++++++++-------
 arch/arm64/kvm/arm.c                          |  1 -
 arch/arm64/kvm/handle_exit.c                  |  2 +-
 arch/powerpc/kvm/book3s_emulate.c             |  1 +
 arch/powerpc/kvm/book3s_hv.c                  |  5 +-
 arch/powerpc/kvm/book3s_pr.c                  |  2 +
 arch/powerpc/kvm/booke.c                      |  1 +
 arch/x86/include/uapi/asm/kvm.h               |  7 +-
 arch/x86/kvm/x86.c                            |  3 +-
 include/uapi/linux/kvm.h                      |  3 +
 .../testing/selftests/kvm/include/kvm_util.h  | 13 +++-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  6 +-
 .../testing/selftests/kvm/lib/ucall_common.c  |  2 +-
 .../testing/selftests/kvm/lib/x86/processor.c |  8 +-
 .../kvm/x86/nested_exceptions_test.c          |  3 +-
 .../kvm/x86/triple_fault_event_test.c         |  3 +-
 virt/kvm/kvm_main.c                           |  4 +
 17 files changed, 90 insertions(+), 51 deletions(-)


base-commit: 10b2c8a67c4b8ec15f9d07d177f63b563418e948
-- 
2.47.1.613.gc27f4b7a9f-goog


