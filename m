Return-Path: <kvm+bounces-64585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B070CC87BC1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 02:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 068033B3603
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 01:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45A430B51A;
	Wed, 26 Nov 2025 01:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yhje+meb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341F930AD11
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 01:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764121505; cv=none; b=oyYnP334Kj1X3bR0qRK9yc89aS1uD3wONwbDE6f7AMv8X5G4nZpCXuNiaRHWMlZS48H679xmaP9mjN5yM/atHkkka2lir/+ybBm/eHjTvI3UBaMWPcpcmNJQztPSy7OrCRYLf/bvohB6Z7HfUiou8uQvuR67uT1tAupedkS2dqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764121505; c=relaxed/simple;
	bh=6cGaSX0tm/ZxflAIsea1RVRyirIpkkmgcFPCtq2Catg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=szGuA0wtgGAZninzOsqF2fHOjUhYV8q7ysmpqPsZMbmDLIimXUqVRDV7sbjKKISXu36ahohRMkdyY2FeIzUPlKuV6jRmsxM4PcFLfKi4iSAXHuYq7JaJNItEZK2yhWcsn/85lNYdsSM5gWzM3QJ0ZHuggnMHk4+lS/9sa7vvPPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yhje+meb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b89c1ce9cfso5961417b3a.2
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 17:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764121503; x=1764726303; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mMPycMQPziYt+7qURYKYTX+YJcS6HgmKfNKwkzpqvmc=;
        b=yhje+mebNb33rz8RFl7tqO2QcMRueOrxiymc8bMEGeYWtG1qnho+4kjlyM2SeGjlva
         xOVDbfoCKLLdr43uAHm0+ZuzpmDZDiT2Oemtje0n8CoDXRLY8hHOXeoyzh9rXt3Gvo3J
         m/ZNNVXyaFm6ZH/cJhYqU3eXP5HxhBPCGU/us2tKkxR/ICS0fDD99s3Jay+tikJzrD82
         BG1GaZUyLait85cXYRu8eoWJYUjetnq6pNc8qyzuEXI63VzofVlekoDyjOItGqZKoeDf
         rmio/faO0BrHt9syviWWwuT/AzdQ32GDvEIBUexAZCWlDGiVem1u60FoG4JvOJriyWFx
         SmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764121503; x=1764726303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mMPycMQPziYt+7qURYKYTX+YJcS6HgmKfNKwkzpqvmc=;
        b=ZPrOCz2revUePDWRbTJ6UhlsMjb/Zke1MZW+NAi3jEchh6kp9bywX/hB995ywDmDUn
         p+UZHLFouwNRZOzcQiKQUzr628KV7PDBTrhKyntgMkVuDid5FM9GtEUwujDTWWoS9Q6D
         ge1Oo3YnibEKq4xTHeo+TM8/hsvfLP+otW6rklTkfP4aU3qk67C9LzWCZ6HQXR4a5IUg
         6XlybtaNKxneE+35jQu4JK91P8l/GD2Fv6rYxZcjQMm4bqDgwq3Z7WcEJZTI5hh/Eoib
         Uu/bn8WvrVjPKYK0eCcv0CUDNmsxwOAjowlrdlc+zD0EhXz8iS1FE9BPUIVrVFweFf6t
         clJg==
X-Gm-Message-State: AOJu0Yxlz84Vq8W++htpdvlLnttbMvd4BmJsWKUg+7u3i/zEeqeB3f+R
	ltyeHpDkU7yBlo8P9MTsfgsxuOPMToxlEEp/1RqYjbjatxENJNgogtbQAv19+5ARm9rgP2q0NQI
	tmoqtbA==
X-Google-Smtp-Source: AGHT+IFn9UPtmuPIZR1jRdkwJpAsnuse5fY9NylfSjgywKX3w1ZCfzOvJyQbThpiwaWgz0SR+MD11jxdRCE=
X-Received: from pgax1.prod.google.com ([2002:a05:6a02:2e41:b0:bc2:5111:9774])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a26:b0:35e:d336:2818
 with SMTP id adf61e73a8af0-3637db13178mr5932875637.17.1764121503441; Tue, 25
 Nov 2025 17:45:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 Nov 2025 17:44:50 -0800
In-Reply-To: <20251126014455.788131-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251126014455.788131-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Misc changes for 6.19
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

The bulk of the vendor agnostic x86 changes for 6.19.  There are multiple
noteworthy changes, though nothing stands out as being _that_ much more
interesting than the rest.

The following changes since commit 211ddde0823f1442e4ad052a2f30f050145ccada:

  Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.19

for you to fetch changes up to c09816f2afce0f89f176c4bc58dc57ec9f204998:

  KVM: x86: Remove unused declaration kvm_mmu_may_ignore_guest_pat() (2025-11-20 07:26:35 -0800)

----------------------------------------------------------------
KVM x86 misc changes for 6.19:

 - Fix an async #PF bug where KVM would clear the completion queue when the
   guest transitioned in and out of paging mode, e.g. when handling an SMI and
   then returning to paged mode via RSM.

 - Fix a bug where TDX would effectively corrupt user-return MSR values if the
   TDX Module rejects VP.ENTER and thus doesn't clobber host MSRs as expected.

 - Leave the user-return notifier used to restore MSRs registered when
   disabling virtualization, and instead pin kvm.ko.  Restoring host MSRs via
   IPI callback is either pointless (clean reboot) or dangerous (forced reboot)
   since KVM has no idea what code it's interrupting.

 - Use the checked version of {get,put}_user(), as Linus wants to kill them
   off, and they're measurably faster on modern CPUs due to the unchecked
   versions containing an LFENCE.

 - Fix a long-lurking bug where KVM's lack of catch-up logic for periodic APIC
   timers can result in a hard lockup in the host.

 - Revert the periodic kvmclock sync logic now that KVM doesn't use a
   clocksource that's subject to NPT corrections.

 - Clean up KVM's handling of MMIO Stale Data and L1TF, and bury the latter
   behind CONFIG_CPU_MITIGATIONS.

 - Context switch XCR0, XSS, and PKRU outside of the entry/exit fastpath as
   the only reason they were handled in the faspath was to paper of a bug in
   the core #MC code that has long since been fixed.

 - Add emulator support for AVX MOV instructions to play nice with emulated
   devices whose PCI BARs guest drivers like to access with large multi-byte
   instructions.

----------------------------------------------------------------
Binbin Wu (1):
      KVM: x86: Add a helper to dedup loading guest/host XCR0 and XSS

Brendan Jackman (1):
      KVM: x86: Unify L1TF flushing under per-CPU variable

Chang S. Bae (1):
      KVM: x86: Refactor REX prefix handling in instruction emulation

Chao Gao (1):
      KVM: x86: Allocate/free user_return_msrs at kvm.ko (un)loading time

Hou Wenlong (1):
      KVM: x86: Don't disable IRQs when unregistering user-return notifier

Lei Chen (3):
      Revert "x86: kvm: introduce periodic global clock updates"
      Revert "x86: kvm: rate-limit global clock updates"
      KVM: x86: remove comment about ntp correction sync for

Maxim Levitsky (2):
      KVM: x86: Fix a semi theoretical bug in kvm_arch_async_page_present_queued()
      KVM: x86: Don't clear async #PF queue when CR0.PG is disabled (e.g. on #SMI)

Paolo Bonzini (9):
      KVM: x86: Add support for emulating MOVNTDQA
      KVM: x86: Move Src2Shift up one bit (use bits 36:32 for Src2 in the emulator)
      KVM: x86: Improve formatting of the emulator's flags table
      KVM: x86: Move op_prefix to struct x86_emulate_ctxt (from x86_decode_insn())
      KVM: x86: Share emulator's common register decoding code
      KVM: x86: Add x86_emulate_ops.get_xcr() callback
      KVM: x86: Add AVX support to the emulator's register fetch and writeback
      KVM: x86: Add emulator support for decoding VEX prefixes
      KVM: x86: Enable support for emulating AVX MOV instructions

Pawan Gupta (1):
      x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well

Sean Christopherson (18):
      KVM: x86: Add a helper to dedup reporting of unhandled VM-Exits
      KVM: TDX: Explicitly set user-return MSRs that *may* be clobbered by the TDX-Module
      KVM: x86: WARN if user-return MSR notifier is registered on exit
      KVM: x86: Leave user-return notifier registered on reboot/shutdown
      KVM: x86: Use "checked" versions of get_user() and put_user()
      KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0
      KVM: x86: Grab lapic_timer in a local variable to cleanup periodic code
      KVM: VMX: Use on-stack copy of @flags in __vmx_vcpu_run()
      x86/bugs: Decouple ALTERNATIVE usage from VERW macro definition
      x86/bugs: Use an x86 feature to track the MMIO Stale Data mitigation
      KVM: VMX: Handle MMIO Stale Data in VM-Enter assembly via ALTERNATIVES_2
      x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM as SVM_CLEAR_CPU_BUFFERS
      KVM: VMX: Bundle all L1 data cache flush mitigation code together
      KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n
      KVM: SVM: Handle #MCs in guest outside of fastpath
      KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of the fastpath
      KVM: x86: Load guest/host XCR0 and XSS outside of the fastpath run loop
      KVM: x86: Load guest/host PKRU outside of the fastpath run loop

Yue Haibing (1):
      KVM: x86: Remove unused declaration kvm_mmu_may_ignore_guest_pat()

fuqiang wang (2):
      KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()
      KVM: x86: Fix VM hard lockup after prolonged inactivity with periodic HV timer

 arch/x86/include/asm/cpufeatures.h   |   5 ++
 arch/x86/include/asm/hardirq.h       |   4 +-
 arch/x86/include/asm/kvm_host.h      |   7 +--
 arch/x86/include/asm/nospec-branch.h |  30 ++++++------
 arch/x86/kernel/cpu/bugs.c           |  22 ++++-----
 arch/x86/kvm/emulate.c               | 319 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------
 arch/x86/kvm/fpu.h                   |  66 +++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.c                |   2 +-
 arch/x86/kvm/kvm_emulate.h           |  20 ++++++--
 arch/x86/kvm/lapic.c                 |  44 ++++++++++++------
 arch/x86/kvm/mmu.h                   |   2 -
 arch/x86/kvm/mmu/mmu.c               |   2 +-
 arch/x86/kvm/mmu/paging_tmpl.h       |   2 +-
 arch/x86/kvm/mmu/spte.c              |   2 +-
 arch/x86/kvm/svm/svm.c               |  27 ++++-------
 arch/x86/kvm/svm/vmenter.S           |   6 ++-
 arch/x86/kvm/vmx/nested.c            |   2 +-
 arch/x86/kvm/vmx/run_flags.h         |  10 ++--
 arch/x86/kvm/vmx/tdx.c               |  65 ++++++++++----------------
 arch/x86/kvm/vmx/tdx.h               |   1 -
 arch/x86/kvm/vmx/vmenter.S           |  29 +++++++-----
 arch/x86/kvm/vmx/vmx.c               | 264 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------
 arch/x86/kvm/x86.c                   | 259 +++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------
 arch/x86/kvm/x86.h                   |  16 ++++++-
 24 files changed, 706 insertions(+), 500 deletions(-)

