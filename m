Return-Path: <kvm+bounces-47511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4C0AC1990
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5DAC1C06C9E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:19:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F8842745E;
	Fri, 23 May 2025 01:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MgjUU5oM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D092DCBE8
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747963082; cv=none; b=RJPCynSoi5IPKo0K98bkifHQCijjya4ScnfWnkASu+LXSzDnCyhUqdPVoRn2OpezwUPjUE5JoMxkIQaRFaftzA/WiMtoWHgv+8VLCxtBaPsf7Rgd/WO4R+pBPfcitw9/AiX+5OL5uGPkVhiP3lp1l7jfP2cksr5hXqUy1sLRVSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747963082; c=relaxed/simple;
	bh=VHYSXt4MW3NbsJsKpwBSo5idIoAb+O8kLYXZPCvalbI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MiR2VX+2WJnyBLX7IDiyrdG1kNK51dKVJxYnCzqXPLvd2sUjHUl4nn8J7vfLfZ1WnQSdeds8KSEApLu/UOgp/qV09f6SvLo3PuU7hSwBr33ThQn4Uy37EpsajWXFYU65+QWSikX7/JO1rGZrWjlH2yd0uKJ8ziBBHkEAr7xrBMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MgjUU5oM; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b1ffc678adfso5542256a12.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747963080; x=1748567880; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/6TGufpgmnIWonhexAf99yIaa0C5IiD3M3PEVoWB6gU=;
        b=MgjUU5oMTdlq/HuQI/mGk3/fpl5cd1zeSf2UNZ2bzEEcCSoGkEBRHcycmikdzXICFy
         fLb6m4cuVrcMZ/sTKmifup5hfuDYDR8ote72m/RpkOpM0L3mElLkQ7caXEton/OtFSkf
         8jUDNraVJ3KkmxelEJ7Y+iPepiWxGfBZU36SETg69UMuNVtq87f6ADfODfkAp+6R4QUZ
         d2kuQMkxrblYCUiVskx2rohz8hFiYJikWQZ4ailoUoHuCa34TSRTdP1wKRz5X7GJgIoT
         XWF6+1/9d4yuc+F8JHp+7R7dX9JgTNRcdGY3a3GJvyOfLNPAi8dlyi0t0BjLtHF9UJXq
         nc+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747963080; x=1748567880;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/6TGufpgmnIWonhexAf99yIaa0C5IiD3M3PEVoWB6gU=;
        b=b0eIsxbGIQJVDrLKfCHIe3ezTPt26yQj+gr2UmvssHROf+75viBhDhwJ3jmGmFTohw
         0clC65aENzl8Ovb8uwrODmEh0qy9pxarvGXprNhyC5j2/xHlaaCQDyHZtNkBAaNNEpLu
         hf317X2ih4HX+MiCzT5gUrlfX4AFhpvBeReDfzeIL+Jv7SoJ525wP7Rx74V/wj/CbRE1
         VtQmgk5TEGegsLhB+lVZOsFOFCbJXGe6sTf/v5B2Sph6tLwPtRhylPBcflQiUNd4OzIr
         K+is9iOnvaUOQSEh4H5/KJHZnYY9Uqi/KIgXXjHBicKBHqGAg7TILB2qhrvXIkVEQswA
         iBQA==
X-Gm-Message-State: AOJu0YxNOLMxw85V+tY01Av4HRzezW4iYUyMevOMY40Wh89BDwy3ib+y
	M1wO2BtGwMOqhbiZBhRXn1UCXuAtDUZuXfhwy3vCh6BfWZ1AzfT6Eg0JKFqAw9wXu6iFuU2BAfz
	mDuYyLw==
X-Google-Smtp-Source: AGHT+IGug742RXIndm/ryegU7zGXhh2aNA7YcKndLjtrq0JcxtSyyhQNKI+c2ukrA4CNLVaoDcXsYWwdA/0=
X-Received: from pfbbe8.prod.google.com ([2002:a05:6a00:1f08:b0:730:90b2:dab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4ccc:b0:1f5:5aac:f345
 with SMTP id adf61e73a8af0-216219e24ebmr48347635637.36.1747963080022; Thu, 22
 May 2025 18:18:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 18:17:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523011756.3243624-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: VMX: Fix MMIO Stale Data Mitigation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Borislav Petkov <bp@alien8.de>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix KVM's mitigation of the MMIO Stale Data bug, as the current approach
doesn't actually detect whether or not a guest has access to MMIO.  E.g.
KVM_DEV_VFIO_FILE_ADD is entirely optional, and obviously only covers VFIO
devices, and so is a terrible heuristic for "can this vCPU access MMIO?"

To fix the flaw (hopefully), track whether or not a vCPU has access to MMIO
based on the MMU it will run with.  KVM already detects host MMIO when
installing PTEs in order to force host MMIO to UC (EPT bypasses MTRRs), so
feeding that information into the MMU is rather straightforward.

Note, I haven't actually verified this mitigates the MMIO Stale Data bug, but
I think it's safe to say no has verified the existing code works either.

All that said, and despite what the subject says, my real interest in this
series it to kill off kvm_arch_{start,end}_assignment().  I.e. preciesly
identifying MMIO is a means to an end.  Because as evidenced by the MMIO mess
and other bugs (e.g. vDPA device not getting device posted interrupts),
keying off KVM_DEV_VFIO_FILE_ADD for anything is a bad idea.

The last two patches of this series depend on the stupidly large device
posted interrupts rework:

  https://lore.kernel.org/all/20250523010004.3240643-1-seanjc@google.com

which in turn depends on a not-tiny prep series:

  https://lore.kernel.org/all/20250519232808.2745331-1-seanjc@google.com

Unless you care deeply about those patches, I honestly recommend just ignoring
them.  I posted them as part of this series, because post two patches that
depends on *four* series seemed even more ridiculousr :-)

Side topic: Pawan, I haven't forgotten about your mmio_stale_data_clear =>
cpu_buf_vm_clear rename, I promise I'll review it soon.

Sean Christopherson (5):
  KVM: x86: Avoid calling kvm_is_mmio_pfn() when kvm_x86_ops.get_mt_mask
    is NULL
  KVM: x86/mmu: Locally cache whether a PFN is host MMIO when making a
    SPTE
  KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps MMIO into the
    guest
  Revert "kvm: detect assigned device via irqbypass manager"
  VFIO: KVM: x86: Drop kvm_arch_{start,end}_assignment()

 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/irq.c              |  9 +------
 arch/x86/kvm/mmu/mmu_internal.h |  3 +++
 arch/x86/kvm/mmu/spte.c         | 43 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/mmu/spte.h         | 10 ++++++++
 arch/x86/kvm/vmx/run_flags.h    | 10 +++++---
 arch/x86/kvm/vmx/vmx.c          |  8 +++++-
 arch/x86/kvm/x86.c              | 18 --------------
 include/linux/kvm_host.h        | 18 --------------
 virt/kvm/vfio.c                 |  3 ---
 10 files changed, 68 insertions(+), 57 deletions(-)


base-commit: 1f0486097459e53d292db749de70e587339267f5
-- 
2.49.0.1151.ga128411c76-goog


