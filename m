Return-Path: <kvm+bounces-33464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E10189EC184
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 02:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C146169863
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 01:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF013139CF2;
	Wed, 11 Dec 2024 01:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OkcAzRH8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579782451E2
	for <kvm@vger.kernel.org>; Wed, 11 Dec 2024 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733880786; cv=none; b=XP07h0wWGjM+ZchGr22BuuSZvEzx0iLZMDZfJ1rE227p+8tvIyoDjIgMttqSwwJ6k7zWJdUPu5xCxsIAkUeh7Cwr2TY9b1Wv0nHlTqiWlWgdL8Ko3BGJtRs20DtU16CSKB7RAJ06te8q6IWv1p6YOnexXE80RLHBiTqf3nkYK4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733880786; c=relaxed/simple;
	bh=uiLSkfoYikjxzNNPE91pULEMWx/aZZhxKXpCVFkXC9A=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Ic1p/1SOP/Mmb9aSHDMi3Yo47gbiUTSQfSfOes2y0dBa4Nz/pbkj43gTMeOMqA2e3h/0vXeVWzafPZEd60Nm+lq3Q144++crLJkU/5IKYlu+J5FSBl1ntVPncIF1cE0rSd0xJgOv17nSld5INaVuzUtjCLgEY8lZCAmID9aN22g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OkcAzRH8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee36569f4cso6335822a91.2
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 17:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733880785; x=1734485585; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S0GM8PD/UxcwHjc3Q+9N5jJw/x8Oe5hUuW4U5Y6mpX8=;
        b=OkcAzRH8sG2S2iNxQzFGhuUbFVkcW7zy1KnlVK3XHFS9jPh+hrON4jVWzD4U4bHFsZ
         PrygSqRn1x8CWmFP2xP0T5RT72tbBRonXiOCmqzzL+JQVu6pMUCbMvczbJxaMfYdhnXy
         lGIE9hetnIzfLKT7CXQLGIftMXt48CdznJBfADqSDlk4C9lrwNC5v+1bjUun/ZWfcpQM
         2z+K03QzTjI0P0iPcr1DfTgH/euUgJ6PvlEDKX7jhOr3qHgMIaXxTV3Y+a5ajiEJ7FWM
         RXO1eyp7LMU2ZBU+3wuX+hKJAeOJkNqh5vCTsR6zLXvnuVeSmOhxXNldBi2N2CfH4XOc
         rP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733880785; x=1734485585;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S0GM8PD/UxcwHjc3Q+9N5jJw/x8Oe5hUuW4U5Y6mpX8=;
        b=QzPaAGJwtrdw5Prd241wkXbIKrBWxbFn9ydJWC0C0CD/DVeyHEsw81x67fgbmL2iqx
         noFfah01BGv9YB0T6MXevj24rsYIkMCVrI5nyZpd8k8x6VZl6k5nrWRU6/4//0pB4Awl
         jtP0AWl4M2WVk0EF4PRUkWzrz5IqcrHuoTh66+huMmNjfe4ba1A21IuTXIIKMzBDDBoH
         KSAPX1PhKsS6YbcB7aKjuMvP7KyvAxEMLm8IHSLNesvvR1TPSUcP2OZLad8GNp1NKIHd
         1VXT+mpUL1qCpHskRdr2C0+rv5b4AU+iC5+sShoVE/7D5A9g230NpkxmupfujwodYGEF
         9tSw==
X-Gm-Message-State: AOJu0YywIl/4klbAVxxqINKAVGSYPjqLNsY3xHsq847bTyfEidGRfAf5
	2jy7HJS4mmuI7UP6msTtKrTtsQGjLkQbZvx9Lq/UcH7sA4LLad7IMIcZuLkYjR/v/rIzi70HF2Z
	WXw==
X-Google-Smtp-Source: AGHT+IENj0FzInkrDWVMNmBSkctAQAVJ7Y0SFirI4QVP6zzjY6m+DpZUmJ/HClMFz/Vos443aUuZzGxni+Q=
X-Received: from pjbpl11.prod.google.com ([2002:a17:90b:268b:b0:2ef:7352:9e97])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d4f:b0:2ee:863e:9fe8
 with SMTP id 98e67ed59e1d1-2f127feca46mr1713618a91.18.1733880784699; Tue, 10
 Dec 2024 17:33:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Dec 2024 17:32:57 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241211013302.1347853-1-seanjc@google.com>
Subject: [PATCH 0/5] KVM: x86: Address xstate_required_size() perf regression
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a hilarious/revolting performance regression (relative to older CPU
generations) in xstate_required_size() that pops up due to CPUID _in the
host_ taking 3x-4x longer on Emerald Rapids than Skylake.

The issue rears its head on nested virtualization transitions, as KVM
(unnecessarily) performs runtime CPUID updates, including XSAVE sizes,
multiple times per transition.  And calculating XSAVE sizes, especially
for vCPUs with a decent number of supported XSAVE features and compacted
format support, can add up to thousands of cycles.

To fix the immediate issue, cache the CPUID output at kvm.ko load.  The
information is static for a given CPU, i.e. doesn't need to be re-read
from hardware every time.  That's patch 1, and eliminates pretty much all
of the meaningful overhead.

Patch 2 is a minor cleanup to try and make the code easier to read.

Patch 3 fixes a wart in CPUID emulation where KVM does a moderately
expensive (though cheap compared to CPUID, lol) MSR lookup that is likely
unnecessary for the vast majority of VMs.

Patches 4 and 5 address the problem of KVM doing runtime CPUID updates
multiple times for each nested VM-Enter and VM-Exit, at least half of
which are completely unnecessary (CPUID is a mandatory intercept on both
Intel and AMD, so ensuring dynamic CPUID bits are up-to-date while running
L2 is pointless).  The idea is fairly simple: lazily do the CPUID updates
by deferring them until something might actually consume guest the relevant
bits.

This applies on the cpu_caps overhaul[*], as patches 3-5 would otherwise
conflict, and I didn't want to think about how safe patch 5 is without
the rework.

That said, patch 1, which is the most important and tagged for stable,
applies cleanly on 6.1, 6.6, and 6.12 (and the backport for 5.15 and
earlier shouldn't be too horrific).

Side topic, I can't help but wonder if the CPUID latency on EMR is a CPU
or ucode bug.  For a number of leaves, KVM can emulate CPUID faster than
the CPUID can execute the instruction.  I.e. the entire VM-Exit => emulate
=> VM-Enter sequence takes less time than executing CPUID on bare metal.
Which seems absolutely insane.  But, it shouldn't impact guest performance,
so that's someone else's problem, at least for now.

[*] https://lore.kernel.org/all/20241128013424.4096668-1-seanjc@google.com

Sean Christopherson (5):
  KVM: x86: Cache CPUID.0xD XSTATE offsets+sizes during module init
  KVM: x86: Use for-loop to iterate over XSTATE size entries
  KVM: x86: Apply TSX_CTRL_CPUID_CLEAR if and only if the vCPU has RTM
    or HLE
  KVM: x86: Query X86_FEATURE_MWAIT iff userspace owns the CPUID feature
    bit
  KVM: x86: Defer runtime updates of dynamic CPUID bits until CPUID
    emulation

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            | 63 ++++++++++++++++++++++++---------
 arch/x86/kvm/cpuid.h            | 10 +++++-
 arch/x86/kvm/lapic.c            |  2 +-
 arch/x86/kvm/smm.c              |  2 +-
 arch/x86/kvm/svm/sev.c          |  2 +-
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              | 22 +++++++++---
 9 files changed, 78 insertions(+), 28 deletions(-)


base-commit: 06a4919e729761be751366716c00fb8c3f51d37e
-- 
2.47.0.338.g60cca15819-goog


