Return-Path: <kvm+bounces-58082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48467B877A7
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:33:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2C60527846
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A386B235045;
	Fri, 19 Sep 2025 00:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z99SU4Z7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725468F48
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758241995; cv=none; b=gl6lIfGGXAtWWgmGJVipwJoWpYff1OAT+pR9HRG44xdqT7uATK/Rh2ZiWAC8vphIV9PSHPZiXAUjMSB0yEzRhkUJpEOWw7k70TvU6pKmuGsEvxDWQ3+he5cDwBmhr/qErNDALkWsULuywAYgUj0/lwNUIPCsHrZ9oXWe4PdlgDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758241995; c=relaxed/simple;
	bh=7ou8wxMoGQAGbCdOuqhfRktG4I8uJDQLMhLPE0ujZjc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=cSSZjCHrIQaMt+EoEgurGl+Aumj3BLs2JK35n8KHsH4Fh4T1KaenB6jNh95d5vklAD2vLE0FRCXF/CIohHmO5JvGeCIptGZt4JEYyEiywAV4G8Li3FokR6EwMaNYY/XOo7h+1qd9of4zySgXGbJgpjoKNa59pvLfRc3pb/oRHYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z99SU4Z7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b550fab38e9so672625a12.0
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758241994; x=1758846794; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G1cGeGaHWP255DyHLqElEz4ZozH/AyhNkucTFTu+Syc=;
        b=Z99SU4Z7p0bSXq9BO5tdEzM8zWh8bKh6zcPA92XUAftoqwA4RYVWP/y9oprH29Sb2i
         ULob8d7kUJFYnA8C5TSWpC4yvaXF6ya5EG1ULp1lPeweUxzSZ3A0nM+NtsSAjljLP8fd
         ePDERxd4YnVkj7M/Ep1n/AGc5HEVXrMySO4SlfpPAk65NJeBCEaV2NjQ3aMpjIiBjVpO
         DNWTx9HojJmc8Cg9+Jf+rRQfPbFo5637ujZVohpxCdGOWe1JxWOkQH+q947fncII6HxQ
         mgvFp/5pfjGbFoePF7/f/maIw8zPhDKDIE8m9oPIh0Wuy0nZ0pE7ErPqLlOjaXtPzlOm
         c+pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758241994; x=1758846794;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G1cGeGaHWP255DyHLqElEz4ZozH/AyhNkucTFTu+Syc=;
        b=D4XZ1XT7XBudnG160h0RNROiN4Mwcy1F+kbtTzZWbdXsVFEgPZX0WKMZsRoHBPRiED
         hw2O5X07sHYqX5Yi/+d29iplubKPNGEPWPraXC2X8C1h7Pj4ulxtVG/iFQP6a97/BNeq
         uGoCx2KR26QYEGZlSYfKenUr9HwI7oWPScM7JapcP+/2NKZPP7+FH3qBQ25dWxCyWisY
         zYsI0ZmTUPJAe++n5FhSz/0qYvJgYagV9i26klvey5EpRX1+Gi4Uf5nf2MYcOEN8hcY3
         eOV0NdJ0cr0IErUqXFyRyF0IH65yTHk515SuAe2LJWv5L1xg2AYHFSfz1U/QiLwZRq1/
         j88g==
X-Forwarded-Encrypted: i=1; AJvYcCXOSgyEe4XZbTa1Hg4efITk/UoFJ/kKaQPhmahTJfrj/QluulsjDESa9tz1Wd1Q8UcXsjI=@vger.kernel.org
X-Gm-Message-State: AOJu0YziTA3eDQQ3/X4rkkBYBRZUoVrAoKO2wlyKA7Pg4C89S+bWAbfp
	Xg+dXoGZUHyj2Wq1gEl+nyQr/ii5bku56s7olFsT/4+pnGTPxsrHlBGN7KXZ8fCRGV1Qn4AFJDy
	ghvDzEA==
X-Google-Smtp-Source: AGHT+IHhyh8RoFNFrbu7IWcTsJ8pGyYjiNB6Kv85S1lDZyDd2mWZEdW+4zL3DWhvxw7SMmsA++3rAzK4CyQ=
X-Received: from pjv14.prod.google.com ([2002:a17:90b:564e:b0:32d:69b3:b7b0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:5491:b0:251:9f29:453e
 with SMTP id adf61e73a8af0-2926e840fc8mr2025266637.39.1758241993727; Thu, 18
 Sep 2025 17:33:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:32:58 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919003303.1355064-1-seanjc@google.com>
Subject: [PATCH v2 0/5] KVM: Export KVM-internal symbols for sub-modules only
From: Sean Christopherson <seanjc@google.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Tony Krowiak <akrowiak@linux.ibm.com>, 
	Halil Pasic <pasic@linux.ibm.com>, Jason Herne <jjherne@linux.ibm.com>, 
	Harald Freudenberger <freude@linux.ibm.com>, Holger Dengler <dengler@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Use the newfangled EXPORT_SYMBOL_FOR_MODULES() along with some macro
shenanigans to export KVM-internal symbols if and only if KVM has one or
more sub-modules, and only for those sub-modules, e.g. x86's kvm-amd.ko
and/or kvm-intel.ko.

Patch 5 gives KVM x86 the full treatment.  If anyone wants to tackle PPC,
it should be doable to restrict KVM PPC's exports as well.

Based on kvm-x86.  My plan is to take this through the KVM x86 tree as there's
an annoying conflict with an in-flight patch, and except for the vfio-ap
change that's been acked, PPC is the only other architecture that's at all
affected, and KVM PPC is maintained separately.

v2:
 - Omit the x86 patch, for now.
 - Drop "GPL" from KVM's macro to match EXPORT_SYMBOL_FOR_MODULES. [Vlastimil]

v1: https://lkml.kernel.org/r/20250729174238.593070-1-seanjc%40google.com

Sean Christopherson (5):
  KVM: s390/vfio-ap: Use kvm_is_gpa_in_memslot() instead of open coded
    equivalent
  KVM: Export KVM-internal symbols for sub-modules only
  KVM: x86: Move kvm_intr_is_single_vcpu() to lapic.c
  KVM: x86: Drop pointless exports of kvm_arch_xxx() hooks
  KVM: x86: Export KVM-internal symbols for sub-modules only

 arch/powerpc/include/asm/kvm_types.h |  15 ++
 arch/s390/include/asm/kvm_host.h     |   2 +
 arch/s390/kvm/priv.c                 |   8 +
 arch/x86/include/asm/kvm_host.h      |   3 -
 arch/x86/include/asm/kvm_types.h     |  10 ++
 arch/x86/kvm/cpuid.c                 |  10 +-
 arch/x86/kvm/hyperv.c                |   4 +-
 arch/x86/kvm/irq.c                   |  34 +----
 arch/x86/kvm/kvm_onhyperv.c          |   6 +-
 arch/x86/kvm/lapic.c                 |  71 ++++++---
 arch/x86/kvm/lapic.h                 |   4 +-
 arch/x86/kvm/mmu/mmu.c               |  36 ++---
 arch/x86/kvm/mmu/spte.c              |  10 +-
 arch/x86/kvm/mmu/tdp_mmu.c           |   2 +-
 arch/x86/kvm/pmu.c                   |  10 +-
 arch/x86/kvm/smm.c                   |   2 +-
 arch/x86/kvm/x86.c                   | 219 +++++++++++++--------------
 drivers/s390/crypto/vfio_ap_ops.c    |   2 +-
 include/linux/kvm_types.h            |  25 ++-
 virt/kvm/eventfd.c                   |   2 +-
 virt/kvm/guest_memfd.c               |   4 +-
 virt/kvm/kvm_main.c                  | 128 ++++++++--------
 22 files changed, 324 insertions(+), 283 deletions(-)
 create mode 100644 arch/powerpc/include/asm/kvm_types.h


base-commit: c8fbf7ceb2ae3f64b0c377c8c21f6df577a13eb4
-- 
2.51.0.470.ga7dc726c21-goog


