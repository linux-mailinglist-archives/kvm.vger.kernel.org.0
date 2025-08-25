Return-Path: <kvm+bounces-55669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F407EB34B75
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:06:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2084C173B5E
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 20:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B4562877EA;
	Mon, 25 Aug 2025 20:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U/6GKrcz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEB0283FD0
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 20:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756152388; cv=none; b=ohEJrWGGq2BfVpEPnY8BVCXEZo4z6p7h5GEZEOOZv9EeiUpj03B+AXn5K8V1xZ40PFtJff6U9zxMhfkWbmRu5Xzx2HZ6xj377TkEpIbIx87kCtS80T8ZkjOe14Es39Jn7TCP890SgqGhU8iyY0ULidod7NdaXlATh7r8pwkGT3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756152388; c=relaxed/simple;
	bh=e6UMH6C4QXeee3JknmCO2I9Y/5OAkfG/m9YVXqh8/eg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=X3uS8FBcYB2ebNdt9g9FThg2Epy1wkOXfvgJfARwxKl1LJ3AUgqAyPzDWZbtRenB5XThHt2t27YBxa7/9Gwg5Ge0yzKWgVUm8Z02EJwNjy//7xXYzIJ8bSIGoC/j3txOXpZNuyVnR1fymYkOgvhEiwu/3N9sERDKstPWcoH8Ovs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U/6GKrcz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3251d634cdbso3172943a91.1
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 13:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756152385; x=1756757185; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8pR7rIORhhha7uQoj/L4UbVHOw9HCPKdRxBVZAbw60c=;
        b=U/6GKrcziuMZ4ZNF4VS5URgcKX/rVLyTK/K79IwfLFkINOSFzJt4zy319jcUaT2h9Q
         ccQPA0lYTIIJ0XviX9VG1/lJyRUkxwojEHcTT3t70mBD4gK1/2SXChpXQGo+XBVKEFSm
         9l0Mg38k6xaokP35fXia8lpIvIGuH9Sdt2sU1MqW/Wsif2bZ72FamQslTM8l88dPMphl
         P8rQpeqz0OlMDrViTB23fX4DtScA/gO4/EPIVgElvP6q+p5i/pgvqbuIMXQIbfMEWkXf
         4UQ/IRDhQdOH41elIoduRkwttyqGLIMBs1fvkUMZi012qdf99BIqviyouvYX4e9rJMQ7
         1u+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756152385; x=1756757185;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8pR7rIORhhha7uQoj/L4UbVHOw9HCPKdRxBVZAbw60c=;
        b=nIhoaD66IehcEwWohWIwIdZw32i+xS3aWMVWnfKTmWcyCKtTu23LWcvt2t4YHbmmjL
         jfBQFTcpcqzJ+uj3ny7bkP5GHlhVzhzUaPhP/zgY12Bp7Dk7CSldvm8Xt+Lcix/uB0jo
         NjNzy4iwhoGJIxzmO/GmQXGkiO+XuQVazM1mqzoTMOCy6yoHPz4SMOTYfflqKbL2xH4n
         FoaAQ6A5k/faP8S6aN/3sCYG0VtAXGAL3C4grWXLDFE0a5bRbCmQ4tm441asfB2B8VPo
         xLqyOaNrUaWxHPxPctQ1el8GBZeJ7obVZjzUtlso8k18kezGtuaqNKmwjoNn1+jCVjno
         M1Dg==
X-Forwarded-Encrypted: i=1; AJvYcCXQMIFKTTKNe/yGy8EDo2ZPRmHlsBGb1b9deEb543R3vwKNYv9l9XlpA2HpMP1lWpjgCqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRO8I24c7Cn7JaJRyJYnFtMfr1rk9WIAQmjV1E2EBKr28vu8Dr
	fMhnI8uLszP0YnMn9v6HvfYoigtneEV9XxWQOG6EIQmYkjr3tU25UvNuDogoq4kDIVvyTAeTfOq
	W4pjYVg==
X-Google-Smtp-Source: AGHT+IEXEoKFvYTs3DYHIb6MyIfVoxfIwlslpUf6Y9Z1lNFDWyuIZVc83JO2uwlvd4IbE+BY+ZPFpeZDEbc=
X-Received: from pjkk5.prod.google.com ([2002:a17:90b:57e5:b0:325:9fa7:5d07])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ccd:b0:324:eac4:2968
 with SMTP id 98e67ed59e1d1-32515ee13cdmr17210596a91.33.1756152385445; Mon, 25
 Aug 2025 13:06:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 25 Aug 2025 13:06:17 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250825200622.3759571-1-seanjc@google.com>
Subject: [PATCH 0/5] Drivers: hv: Fix NEED_RESCHED_LAZY and use common APIs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andy Lutomirski <luto@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-hyperv@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix a bug where MSHV root partitions don't honor NEED_RESCHED_LAZY, and then
deduplicate the TIF related MSHV code by turning the "kvm" entry APIs into
more generic "virt" APIs (which ideally would have been done when MSHV root
support was added).

Assuming all is well, maybe this could go through the tip tree?

The Hyper-V stuff and non-x86 architectures are compile-tested only.

Sean Christopherson (5):
  Drivers: hv: Move TIF pre-guest work handling fully into mshv_common.c
  Drivers: hv: Handle NEED_RESCHED_LAZY before transferring to guest
  entry/kvm: KVM: Move KVM details related to signal/-EINTR into KVM
    proper
  entry: Rename "kvm" entry code assets to "virt" to genericize APIs
  Drivers: hv: Use common "entry virt" APIs to do work before running
    guest

 MAINTAINERS                                 |  2 +-
 arch/arm64/kvm/Kconfig                      |  2 +-
 arch/arm64/kvm/arm.c                        |  3 +-
 arch/loongarch/kvm/Kconfig                  |  2 +-
 arch/loongarch/kvm/vcpu.c                   |  3 +-
 arch/riscv/kvm/Kconfig                      |  2 +-
 arch/riscv/kvm/vcpu.c                       |  3 +-
 arch/x86/kvm/Kconfig                        |  2 +-
 arch/x86/kvm/vmx/vmx.c                      |  1 -
 arch/x86/kvm/x86.c                          |  3 +-
 drivers/hv/Kconfig                          |  1 +
 drivers/hv/mshv.h                           |  2 --
 drivers/hv/mshv_common.c                    | 22 ---------------
 drivers/hv/mshv_root_main.c                 | 31 ++++-----------------
 include/linux/{entry-kvm.h => entry-virt.h} | 19 +++++--------
 include/linux/kvm_host.h                    | 17 +++++++++--
 include/linux/rcupdate.h                    |  2 +-
 kernel/entry/Makefile                       |  2 +-
 kernel/entry/{kvm.c => virt.c}              | 15 ++++------
 kernel/rcu/tree.c                           |  6 ++--
 virt/kvm/Kconfig                            |  2 +-
 21 files changed, 49 insertions(+), 93 deletions(-)
 rename include/linux/{entry-kvm.h => entry-virt.h} (83%)
 rename kernel/entry/{kvm.c => virt.c} (66%)


base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
-- 
2.51.0.261.g7ce5a0a67e-goog


