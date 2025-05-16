Return-Path: <kvm+bounces-46881-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA034ABA529
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD9361C007B9
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6F6422FDE7;
	Fri, 16 May 2025 21:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i2+ELMPA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4C028003A
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747431007; cv=none; b=KVQ63kWs35Dkf+xBEWFDTz2ZCJhuWAr/AykzRMpOg0zhJHlMxwY7OwLxJNH9ylFymZ5zBMcRknS+BNKHI0d/te/bgoB5LYpeByUUecI+muHciJ1MhN9BzraWz3JvqpyI+C4qbtxMJ1hEStW8gJrTz99QrZoL8jSz41OfWD/02dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747431007; c=relaxed/simple;
	bh=yy9jU5bFQ6MywiVXwQiQCMbVNQv3vhTHbAibmHLnyL4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=I++11FNAeRsVPdVzlfjx7FfczQEfXYgYwg8syB30ePxjwH/lJPYNt33VGBWZGQU0ZuYE2a2o5THmEwypeVu9VQy4A1/OxcygDsw5b4ZdD6XIQFjXjEF1UgyMAv5A8w2PdikSDcvybu+fxaRXwQGq6KA5PZ7AEa/paCQ8Q3KpX8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i2+ELMPA; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74244ba183cso2189472b3a.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747431003; x=1748035803; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=16vfcjowGUMTa5d9+ULCqQIsoViPLGh6MjBdiOthySQ=;
        b=i2+ELMPACbekzui9NGjQ82s6vW8mMqUTNVmVoPCzkf63yiV0cB8cPc62BsiGOLUy4H
         jmdkwrnFsQirqD0jDJ2Vf10UemenmM8EFc42GAv7qMa/I3KHTKoXOKRUyq5djU24vNnm
         VfxouAH6IU35vdgTm05bGpZ6q0bii0UVK94uTJmcuqdBR+s8O0cc7LJkWHakOzf153e/
         /NGfkL0y65xo5D+CMWuwqHOZZRk1iBbzXe2mak/UwI942PMBsLkNwrY0HXVURw5wCRyB
         tLhxXKBYXwO1dXYG/o/QK93bb67qz6k3sPJrF0AVR8VV7hIeOpD/31df2YmF13LH2O/X
         igrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747431003; x=1748035803;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=16vfcjowGUMTa5d9+ULCqQIsoViPLGh6MjBdiOthySQ=;
        b=pkwivHwxT+7QtOCBbkZ8BTtouPltq0ystXIOlZHjEdt+xy0C2/nq0O+C7h9VOW+SKM
         A/STFa6Bc6tGXF54K6vSCTQ6Ye5NsY8L1CRZq/vQJX2uVsJs5mpQqx99N7Tjm+VhoL6t
         LPPld3c+wWT7tsqj2tAwNrrHrw7Ru82uQrDp6Vo17xH54Rk05M50wagsiYjixLqmZOr6
         2tKdLelbTzsxkom6uwdlJTpCE940667pz/URibtWHFeANC7NeNXyQSRJytMcDJoUQ0oM
         bSy3L0bOO8HIFIbSeK32HJlrY4H+BlVHAKgn/Ie/0q7jC6MY2tn62kuH7/xY+9sc9E24
         fe3A==
X-Forwarded-Encrypted: i=1; AJvYcCVwKCB7YdwnoI0WSlpPNnmiCcvlAaJXgVcFFfh/ifcqfnL07EAVB5nsvcDLWYgE36CY6DM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdFUXeZ78v7RB5jKy+6pAzEw63gdSYT8hnLJGZi04UQCCh3i5l
	NgBkF8B4y54Vs4p0kLIqBcrN6PplrzKKZFtize+m0RqGO1QrJf5cQl56YOpbFmODk5UKhfo6piG
	r1H76og==
X-Google-Smtp-Source: AGHT+IHAOqNtgLvjhczBzscm3RgIFYldzuw2M2zw628mwDpHkkpQXjnCtK0C58qctj3mP1IxalTn5fBd2FM=
X-Received: from pfbjt23.prod.google.com ([2002:a05:6a00:91d7:b0:736:38af:afeb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:894:b0:736:4ebd:e5a
 with SMTP id d2e1a72fcca58-742a98b4e97mr6495370b3a.20.1747431003224; Fri, 16
 May 2025 14:30:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:28:25 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516212833.2544737-1-seanjc@google.com>
Subject: [PATCH v2 0/8] x86, KVM: Optimize SEV cache flushing
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, Zheyun Shen <szy0127@sjtu.edu.cn>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Kevin Loughlin <kevinloughlin@google.com>, 
	Kai Huang <kai.huang@intel.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

This is the combination of Kevin's WBNOINVD series[1] with Zheyun's targeted
flushing series[2].  The combined goal is to use WBNOINVD instead of WBINVD
when doing cached maintenance to prevent data corruption due to C-bit aliasing,
and to reduce the number of cache invalidations by only performing flushes on
CPUs that have entered the relevant VM since the last cache flush.

Assuming I get the appropate acks (and that I didn't manage to break anything
when rebasing), my plan is to take this through the kvm-x86 tree in the 6.17
timeframe.

v2:
 - Add a missing -ENOMEM in __sev_guest_init(). [Tom]
 - Collect reviews. [Kai, Tom]
 - Fix stub prototypes. [Zheyun]
 - Kill off dead pr_err() code on DRM's wbinvd_on_all_cpus() usage.

v1: https://lore.kernel.org/all/20250227014858.3244505-1-seanjc@google.com

[1] https://lore.kernel.org/all/20250201000259.3289143-1-kevinloughlin@google.com
[2] https://lore.kernel.org/all/20250128015345.7929-1-szy0127@sjtu.edu.cn

Kevin Loughlin (2):
  x86, lib: Add WBNOINVD helper functions
  KVM: SEV: Prefer WBNOINVD over WBINVD for cache maintenance efficiency

Sean Christopherson (3):
  drm/gpu: Remove dead checks on wbinvd_on_all_cpus()'s return value
  x86, lib: Drop the unused return value from wbinvd_on_all_cpus()
  KVM: x86: Use wbinvd_on_cpu() instead of an open-coded equivalent

Zheyun Shen (3):
  KVM: SVM: Remove wbinvd in sev_vm_destroy()
  x86, lib: Add wbinvd and wbnoinvd helpers to target multiple CPUs
  KVM: SVM: Flush cache only on CPUs running SEV guest

 arch/x86/include/asm/smp.h           | 23 ++++++--
 arch/x86/include/asm/special_insns.h | 19 ++++++-
 arch/x86/kvm/svm/sev.c               | 81 +++++++++++++++++++---------
 arch/x86/kvm/svm/svm.h               |  1 +
 arch/x86/kvm/x86.c                   | 11 +---
 arch/x86/lib/cache-smp.c             | 26 ++++++++-
 drivers/gpu/drm/drm_cache.c          |  9 ++--
 7 files changed, 125 insertions(+), 45 deletions(-)


base-commit: 7ef51a41466bc846ad794d505e2e34ff97157f7f
-- 
2.49.0.1112.g889b7c5bd8-goog


