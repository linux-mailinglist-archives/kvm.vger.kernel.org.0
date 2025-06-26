Return-Path: <kvm+bounces-50916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBF8EAEA9AB
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:32:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CBA016A034
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C18F26FA46;
	Thu, 26 Jun 2025 22:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tUSJYN23"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2004221FC9
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 22:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750977107; cv=none; b=Be1xrchBYy+yTPpHwsQkqKpXNzq39BscZ8nzszz+7+E5gYcE2ZVZycUrxeh9H350Suu5pjhoScsfEiNnFp/qA/Kwww1MFy2a3rAZtBDY/FaBQY+6lsi+qAwVTjalh0VsB+oGyuGGKPp5fdlUBGS+NfphVpJI3BioZ0TaAUa3sxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750977107; c=relaxed/simple;
	bh=tg7yDN+hDXimXnXN0SHBQlZ1bjq9tztOAM6uN8bxq4w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=uIJB8SUnKx+xkN8G4GJ0nHQanERTfNsYZITL0K29qBY04EAQcxjh/06t257T8KgLzIE9yIMUvktL7JCPUTYAfzJG5JdLScpjnoO+ag8tTvLhKDxdgv3iCQQnQ/2346phn/i6lGP1nxGxRDab2ttPWB+IeORrgM3oayi0T5+ebtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tUSJYN23; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31366819969so1231814a91.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 15:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750977105; x=1751581905; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=76WxR4y5iyuxTg472JdhnT6w9I2JTre3cbttFiZ6d3I=;
        b=tUSJYN23i1b9i/IZMYh4IwCGQwqfWDvXsggVybIbvKw37GYkrBYbA+s6Qc/MwoP9tT
         zVF6QUGhwyUBOeDiMTy0zA9Ooa25g0fSp5cINKZ488qQ6lOq7UCEMmWz5Q/dDNIiRzU2
         SVZnGM1vhAf/rrmb3trS+VKUKU7P0ybzckz+w/v30TYYSatP/nOHFwFQdzV7uEK4RrZv
         JcBYTvZLTe1mfKnA9g+uKJKQtrwL6bKwEOXRVgzgUgTPVsL0HKjnEi9fsHt2E91tjhU2
         GUn+U5qdgsUILEoQIgGLnkHyUnANxpOaSaVLyzQiPNKFcyz/SIbFnWojifvObnuBw9jU
         vV2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750977105; x=1751581905;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=76WxR4y5iyuxTg472JdhnT6w9I2JTre3cbttFiZ6d3I=;
        b=clcgF+gGiIhz0theU/jY/kaGzjM8LeWtDUUkfAWGTOGXh+k0mte5Yw2bxtdQvRcP74
         2lYVXwIxa8grUsEW901HYvmq41tu8kvb24bkDUWoVnr/1WeRpUpJiRwHGF/AW/EJajzz
         zCtghrxBQFY/5NoIzR1IVvuQ1SMiyAbijG7EAmPAzfTApIewhJbIa4QqQq1GZr/FGV7f
         YgOdmGRoq2wXlswbi4Gu6PYRRKHZq9JhGXfCkqyHFziDkL+TavYvP79Ti92dpuQVvRD5
         UWwUb/3/YHtYbO31J1Hmo/eGGy6bAodUK+fxDwowbuDaVYUFbUbEiZZReTtyzAzgsnEq
         /P/A==
X-Gm-Message-State: AOJu0Yxxlx3Ixfx8XK4OHFntfymbz7nSrBiswiEp0CV0eg59/HjkI7Ht
	KnS/d9kYgXVGoy0zSjfkTZndoThAzH330+0DFTliXB/JPBZ6AoYIXsqlpYhQ384UWLbwhaGL8Nu
	yyBPm7A==
X-Google-Smtp-Source: AGHT+IGzbfhHp80ZAoOSq0Oj3noG7KmGJrdhg4whfc7tjCxy1T3FjGMypuiQuR0b1TZFmxEZAjHwoLW4Trs=
X-Received: from pjbss13.prod.google.com ([2002:a17:90b:2ecd:b0:312:dbc:f731])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:278b:b0:316:d69d:49fb
 with SMTP id 98e67ed59e1d1-318c8edb091mr1098184a91.14.1750977104989; Thu, 26
 Jun 2025 15:31:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 26 Jun 2025 15:31:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626223142.865249-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Fixes for 6.16-rcN
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Please pull a random smattering of fixes for 6.16.  Note, the SEV-ES intra-host
migration commits received your "Queued, thanks", but they never showed up in
kvm.git.

Oh, and there's one more fix that is probably a candidate for 6.16, but I'm
waiting for a response from the submitter, as I think we can go with a more
targeted fix: https://lore.kernel.org/all/aFwLpyDYOsHUtCn-@google.com

The following changes since commit 28224ef02b56fceee2c161fe2a49a0bb197e44f5:

  KVM: TDX: Report supported optional TDVMCALLs in TDX capabilities (2025-06-20 14:20:20 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.16-rcN

for you to fetch changes up to fa787ac07b3ceb56dd88a62d1866038498e96230:

  KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush (2025-06-25 09:15:24 -0700)

----------------------------------------------------------------
KVM x86 fixes for 6.16-rcN

 - Reject SEV{-ES} intra-host migration if one or more vCPUs are actively
   being created so as not to create a non-SEV{-ES} vCPU in an SEV{-ES} VM.

 - Use a pre-allocated, per-vCPU buffer for handling de-sparsified vCPU masks
   when emulating Hyper-V hypercalls to fix a "stack frame too large" issue.

 - Allow out-of-range/invalid Xen event channel ports when configuring IRQ
   routing to avoid dictating a specific ioctl() ordering to userspace.

 - Conditionally reschedule when setting memory attributes to avoid soft
   lockups when userspace converts huge swaths of memory to/from private.

 - Add back MWAIT as a required feature for the MONITOR/MWAIT selftest.

 - Add a missing field in struct sev_data_snp_launch_start that resulted in
   the guest-visible workarounds field being filled at the wrong offset.

 - Skip non-canonical address when processing Hyper-V PV TLB flushes to avoid
   VM-Fail on INVVPID.

----------------------------------------------------------------
Binbin Wu (1):
      Documentation: KVM: Fix unexpected unindent warnings

Chenyi Qiang (1):
      KVM: selftests: Add back the missing check of MONITOR/MWAIT availability

David Woodhouse (1):
      KVM: x86/xen: Allow 'out of range' event channel ports in IRQ routing table.

Liam Merwick (1):
      KVM: Allow CPU to reschedule while setting per-page memory attributes

Manuel Andreas (1):
      KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush

Nikunj A Dadhania (1):
      KVM: SVM: Add missing member in SNP_LAUNCH_START command structure

Sean Christopherson (3):
      KVM: SVM: Reject SEV{-ES} intra host migration if vCPU creation is in-flight
      KVM: SVM: Initialize vmsa_pa in VMCB to INVALID_PAGE if VMSA page is NULL
      KVM: x86/hyper-v: Use preallocated per-vCPU buffer for de-sparsified vCPU masks

 Documentation/virt/kvm/api.rst                     | 28 +++++++++++-----------
 arch/x86/include/asm/kvm_host.h                    |  7 +++++-
 arch/x86/kvm/hyperv.c                              |  5 +++-
 arch/x86/kvm/svm/sev.c                             | 12 ++++++++--
 arch/x86/kvm/xen.c                                 | 15 ++++++++++--
 include/linux/psp-sev.h                            |  2 ++
 .../testing/selftests/kvm/x86/monitor_mwait_test.c |  1 +
 virt/kvm/kvm_main.c                                |  3 +++
 8 files changed, 53 insertions(+), 20 deletions(-)

