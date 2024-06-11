Return-Path: <kvm+bounces-19362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82B549046B8
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 00:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7B951C22EEC
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 22:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05A13154C03;
	Tue, 11 Jun 2024 22:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2a5V6PEa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF98915253B
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 22:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718143522; cv=none; b=Y4DYHvXgOwJgQA0Cg8YCokK1A53N/4dZykQOiDlskL3gSx0/gfcPojqa6msXWyk6nmsutERA2LSGo5GkyepfIsdsUk6aDOOZjLIxu/Nk6d/+n1NRHtHAqgOX8xCZFmkcFYsderwOtvjcBkk28KGmy9N1mocP9M+b4HKcOPN9xXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718143522; c=relaxed/simple;
	bh=M+uIk2k0k+n1ds60ygOLnFneNJc0H1MERPC7zF0DsYs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=UCB8/eJvB/2Z39PtqYNMtn/ZWu/f8iy5z/JjqtDo9g8H4NX0kdullXIFTy3Xt5FkqtJ4XjBGrKw1Poo43fmh5MWDVg9K/8nSL46sNGuwie0sBn3batp73EqzE5S0qjvdJLdmvbvUVkbdgVCynYmH7BNsaHuwufJgiq5VsC08xVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2a5V6PEa; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62fa71fbfc4so1628337b3.2
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 15:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718143520; x=1718748320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XGxkwmBASUxJCEjljUwh+YlmkF32vNneG4rTs8TlKsA=;
        b=2a5V6PEacaViltOrXgnhtXVnW2p9uHuavdnFTC+57PcHGlZHIB/PSucvQIZ5dhIXZk
         Dl9iKh1+B+L8v1Th94P0whOWnd5WqXCCxqg7aAm/pSVZx9qbWIroYhZVCwy0rr7yxv3h
         NE+P65ygIpLdWMabT4Up8MfNALtJaOz1Odpk8PSeJgzQeNjC6DgpI4WPKRMUF3c4VQrz
         EnkPCPeADjbwPBjSsJyKJy3cCvoan0HIKHW6tGKQ9wnVVKdrsb/QrjpB+uZcEZleIKZ8
         tOjX6KZy0271vuOPsnoUZH2M1wVJsPTmd4qQc50+cLR4m6SWuUzPxKdBI5WPIPyCmPNq
         kR5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718143520; x=1718748320;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XGxkwmBASUxJCEjljUwh+YlmkF32vNneG4rTs8TlKsA=;
        b=fPTE4jMydJgcYJKl+0Y4EjHuPxfiyzaMYb3W/uLOubQ+vA8pT6BNLCbGA3UGm6ElXC
         wBinAvZR19rqa3BqZQNhJ9YVBX+umJpbe6BmDk27eVIN67HfFG1AKEw+CK7vFu0UrR3p
         krcw2JBmE24Vqko82WVa20kVJpy+R20ILCmGBsX4PlOZbOQSs1Ihuz/gIVa37bv8TP7k
         e8jXMZIOq80uxdyXovOiIzxH+NYQDcoZhUB2raYf0vHaVm4wG7K5adO+27ou2o3aUehj
         SMcJom40JrxFEcCBHY1s6lyfkQbZz2cN8jHXNxLvKQ4pBm9OGgFvME80Bs9mipQPMfjp
         BsVg==
X-Gm-Message-State: AOJu0YyhRQGZlXMn47PCzIr40mG4bF1nh2fHgK3hGH51DqW3pB4cSWmP
	MRwdb/CI4Jdmq4P7Iv9bT9Mrupgv46LSrdu8paWzLtj6KCWfLNleFoak/tPR5kw5I/yJhM7uGJI
	6pxj8kqvWTA==
X-Google-Smtp-Source: AGHT+IHHpPpl3/ti2Ir9DDWDsQx8qjoQU8keZMwhg9H/Fe8paRbng8c09F6kvjdpZKDFLsK22KIPHShsNHPQ+w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:690c:d8f:b0:62d:cb6:1cff with SMTP id
 00721157ae682-62fb9acc2c3mr159757b3.1.1718143519607; Tue, 11 Jun 2024
 15:05:19 -0700 (PDT)
Date: Tue, 11 Jun 2024 15:05:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240611220512.2426439-1-dmatlack@google.com>
Subject: [PATCH v4 0/4] KVM: x86/mmu: Rework TDP MMU eager page splitting SP allocations
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>, 
	Bibo Mao <maobibo@loongson.cn>
Content-Type: text/plain; charset="UTF-8"

Rework the TDP MMU eager page splitting code to always drop mmu_lock
when allocation shadow pages, to avoid causing lock contention with vCPU
threads during CLEAR_DIRTY_LOG (where mmu_lock is held for write).

The first patch changes KVM to always drop mmu_lock lock and the
subsequent patches clean up and simplify the code now that conditional
locking is gone.

v4:
 - Use kmem_cache_zalloc() instead of __GFP_ZERO [Sean]
 - Move mmu_lock and RCU acquire/release into the loop [Sean]
 - Avoid unnecessary reaquire of RCU read lock [Sean]

v3: https://lore.kernel.org/kvm/20240509181133.837001-1-dmatlack@google.com/
 - Only drop mmu_lock during TDP MMU eager page splitting. This fixes
   the performance regression without regressing CLEAR_DIRTY_LOG
   performance on other architectures from frequent lock dropping.

v2: https://lore.kernel.org/kvm/20240402213656.3068504-1-dmatlack@google.com/
 - Rebase onto kvm/queue [Marc]

v1: https://lore.kernel.org/kvm/20231205181645.482037-1-dmatlack@google.com/

Cc: Bibo Mao <maobibo@loongson.cn>
Cc: Sean Christopherson <seanjc@google.com>

David Matlack (4):
  KVM: x86/mmu: Always drop mmu_lock to allocate TDP MMU SPs for eager
    splitting
  KVM: x86/mmu: Hard code GFP flags for TDP MMU eager split allocations
  KVM: x86/mmu: Unnest TDP MMU helpers to allocate SPs for eager
    splitting
  KVM: x86/mmu: Avoid reacquiring RCU if TDP MMU fails to allocate an SP

 arch/x86/kvm/mmu/tdp_mmu.c | 78 ++++++++++++--------------------------
 1 file changed, 24 insertions(+), 54 deletions(-)


base-commit: af0903ab52ee6d6f0f63af67fa73d5eb00f79b9a
-- 
2.45.2.505.gda0bf45e8d-goog


