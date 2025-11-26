Return-Path: <kvm+bounces-64625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A87ADC88BE0
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:50:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2E3A34E79A6
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B71731B126;
	Wed, 26 Nov 2025 08:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PueVqVgd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ptoYS5Lt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874E330EF6B
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 08:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764146989; cv=none; b=WkU8KoKiW5F8HOFL8Py2lY3r+TezcHmMwCz1PElJMMNnClD6UbUDmzPSn9xq+D1eORY64w7euZ8Kmg0b0Y3o0LvABu9fVG4VCPi3V6T2lSe1h7QLxFG+zQzr2veZIEtQfYlDoGiMOXwQejPd8a4twTHJmzkKR/vaOy1OQs3Jwh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764146989; c=relaxed/simple;
	bh=GtIS4acw8rrEMJ8MIsIp5PSmm/Ru1HTC9pGgaBOaBRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S+OtYG4/rfn2ySwQYidfGKFiGZFKtSU+MyJ6JKPwSAh6l15XKF7n6CrXf3pZgMVPBBRxPCTjIv5pm/nNOUrv9dyOlr6kSuXH1wxE93t072pThO8hFT2atu9dJejmLdt/DvL9hk6dYAyHagUX0ahWv2s1TLiJ38IAoAXCexOGBTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PueVqVgd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ptoYS5Lt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764146985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CvkDwPnPC1QwlSEww0+jdB5oNq+gda7BPV1+7Y+Q5Yg=;
	b=PueVqVgd3xyA+Ag5EoSM3CHNIi+SLoHT+UPxj8dcW9okih6ZJjSdp3A2i6fWYDbODdqaUT
	2RobMYed2cggbPhhi7LctO6LOshZEgrwPbSHXhgJfBmcgg+LV0FEigoDzqMfBIdJSeyPEo
	uXBKS2yFultO14GnPkJ6P96MZaIvleA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-CAVeXTDsPxOi974FNiux9g-1; Wed, 26 Nov 2025 03:49:43 -0500
X-MC-Unique: CAVeXTDsPxOi974FNiux9g-1
X-Mimecast-MFC-AGG-ID: CAVeXTDsPxOi974FNiux9g_1764146983
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b3155274eso2899040f8f.0
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 00:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764146982; x=1764751782; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CvkDwPnPC1QwlSEww0+jdB5oNq+gda7BPV1+7Y+Q5Yg=;
        b=ptoYS5LtH7mLWE8urVSWDxgn0pvsCO0RT3jgQCyJwTqh4P5WPoVWB5sscrTpIOJpyN
         j8UXK3FI2BiehJbDFYDNYK01LEduzICSO6sO6rs0HvT8wmO68DP1hVDmHwaP7iMdtddI
         ZVEnmmU/fCUGTgZSsp07wasaCneFI7CN6STbsU2GuOg4jPwBPX5Qvp0RtGa+qZQ9DpeV
         v7Hj6DRMonVfm/U75CiXPWIU8imO3AlVS2+jA8EkltAhr0kLppZqrpF86p1FT1u/pRdv
         TW/e3Wj2ZvwxSUdRAaA+uAt8ez0qXv3F09TOq2g6kxumSqZ/nQ0hF8sOQ41BkIwN3alG
         dt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764146982; x=1764751782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CvkDwPnPC1QwlSEww0+jdB5oNq+gda7BPV1+7Y+Q5Yg=;
        b=KhUTu/+ur2fozoLcdxvmyXYA4KLZ3gCc4NIfn5tlwt2BSoY0Y1CoboEp2eky1zAX38
         dRo9+AgBiBYKI0B1hbbgQoTB7CEtyH/Yrt1fk2NJh/SWRi5bB/HeAi4TZUKkma8dHO8B
         Spadyvba0U/HQuc5bm8/J4dafkxlhFqrUb5XyMhO0J5SKxrljLqibZ63iuQ5vvKzeaxI
         7S0Gqw4t14V2TkR33VqyPNo4L0FSeRcNAvHSEwpuotPexkuccB9hWxZ4dsy6zlqr5YFw
         5QLdnxrEqaY2Pv+jsQbpo4MpwVa9N+B9IPXgBbQXgrPEIiGBsPL/ZDyVVW0jX6pMLsi2
         0pcQ==
X-Gm-Message-State: AOJu0YwCEmDVr5kxMP5l2BMqA54rRjPn8Wlra5FuAV5RhHgJDkrzsALY
	3I6COAJJEo+8hYAEzj9ZiMqCDZeipuOV7flZ+36Pm4skmRZVPpjCYZA8O/fabns3NqbF5fYi1LB
	EDEgFmxyouyvck+ZKyFgsHzhoLnflw0anksXqnunxII3mvD18O8ixPVnfUw3rgRHeO7zdkzmN55
	kp5gPx1emninxltxm5Mwf6r/XJfnd0
X-Gm-Gg: ASbGnctPq1YP3BDOUNoetrlmdTFxIGnL051fHnWxrGgn4V0xM2B3k8U4nvHGc+IhwNv
	N2+v8szR7f0jbEhq/1+ffv4U7Q4seuBeDE09rLLXGa7WrCDRTkil3Ow/tCW0rBukNpb70C8+cRP
	2xT7lYHqPhX4JopYchaeN6CYGFDutgiLnSn0u3zPVFtKtYrg75ZKwQjEY+HjUbPTrGrcWesQIDz
	AU5zplfbw/d7C25A4GaC/n2glaIjSuzXI7ZOGIEECvR4+VcabVTU2w5/dtGPpccOQgnvSg=
X-Received: by 2002:a05:6000:228a:b0:42b:2eb3:c90f with SMTP id ffacd0b85a97d-42cc1ac98b4mr19694142f8f.10.1764146982510;
        Wed, 26 Nov 2025 00:49:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHN+lO7dc6gsJciGx2fkWFuRtlo+JdAxOuRnM5+V/Y5m9/X365TMIwFra9p6w6FE9rSxGuToDngN6QevqxNTWs=
X-Received: by 2002:a05:6000:228a:b0:42b:2eb3:c90f with SMTP id
 ffacd0b85a97d-42cc1ac98b4mr19694118f8f.10.1764146982092; Wed, 26 Nov 2025
 00:49:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com> <20251126014455.788131-4-seanjc@google.com>
In-Reply-To: <20251126014455.788131-4-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 26 Nov 2025 09:49:30 +0100
X-Gm-Features: AWmQ_blzgp5kWEv0y85hJme6CjdRofWtp9yVTnqi78sQA_Q6XBLZ0w7XSPxo5_U
Message-ID: <CABgObfZ4QhxnkT4vuzeayor4rpRU9yQVejiEPe6wGFTOt9F+Wg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.19
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 2:45=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> The bulk of the vendor agnostic x86 changes for 6.19.  There are multiple
> noteworthy changes, though nothing stands out as being _that_ much more
> interesting than the rest.
>
> The following changes since commit 211ddde0823f1442e4ad052a2f30f050145cca=
da:
>
>   Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.19
>
> for you to fetch changes up to c09816f2afce0f89f176c4bc58dc57ec9f204998:
>
>   KVM: x86: Remove unused declaration kvm_mmu_may_ignore_guest_pat() (202=
5-11-20 07:26:35 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 misc changes for 6.19:
>
>  - Fix an async #PF bug where KVM would clear the completion queue when t=
he
>    guest transitioned in and out of paging mode, e.g. when handling an SM=
I and
>    then returning to paged mode via RSM.
>
>  - Fix a bug where TDX would effectively corrupt user-return MSR values i=
f the
>    TDX Module rejects VP.ENTER and thus doesn't clobber host MSRs as expe=
cted.
>
>  - Leave the user-return notifier used to restore MSRs registered when
>    disabling virtualization, and instead pin kvm.ko.  Restoring host MSRs=
 via
>    IPI callback is either pointless (clean reboot) or dangerous (forced r=
eboot)
>    since KVM has no idea what code it's interrupting.
>
>  - Use the checked version of {get,put}_user(), as Linus wants to kill th=
em
>    off, and they're measurably faster on modern CPUs due to the unchecked
>    versions containing an LFENCE.
>
>  - Fix a long-lurking bug where KVM's lack of catch-up logic for periodic=
 APIC
>    timers can result in a hard lockup in the host.
>
>  - Revert the periodic kvmclock sync logic now that KVM doesn't use a
>    clocksource that's subject to NPT corrections.
>
>  - Clean up KVM's handling of MMIO Stale Data and L1TF, and bury the latt=
er
>    behind CONFIG_CPU_MITIGATIONS.
>
>  - Context switch XCR0, XSS, and PKRU outside of the entry/exit fastpath =
as
>    the only reason they were handled in the faspath was to paper of a bug=
 in
>    the core #MC code that has long since been fixed.
>
>  - Add emulator support for AVX MOV instructions to play nice with emulat=
ed
>    devices whose PCI BARs guest drivers like to access with large multi-b=
yte
>    instructions.
>
> ----------------------------------------------------------------
> Binbin Wu (1):
>       KVM: x86: Add a helper to dedup loading guest/host XCR0 and XSS
>
> Brendan Jackman (1):
>       KVM: x86: Unify L1TF flushing under per-CPU variable
>
> Chang S. Bae (1):
>       KVM: x86: Refactor REX prefix handling in instruction emulation
>
> Chao Gao (1):
>       KVM: x86: Allocate/free user_return_msrs at kvm.ko (un)loading time
>
> Hou Wenlong (1):
>       KVM: x86: Don't disable IRQs when unregistering user-return notifie=
r
>
> Lei Chen (3):
>       Revert "x86: kvm: introduce periodic global clock updates"
>       Revert "x86: kvm: rate-limit global clock updates"
>       KVM: x86: remove comment about ntp correction sync for
>
> Maxim Levitsky (2):
>       KVM: x86: Fix a semi theoretical bug in kvm_arch_async_page_present=
_queued()
>       KVM: x86: Don't clear async #PF queue when CR0.PG is disabled (e.g.=
 on #SMI)
>
> Paolo Bonzini (9):
>       KVM: x86: Add support for emulating MOVNTDQA
>       KVM: x86: Move Src2Shift up one bit (use bits 36:32 for Src2 in the=
 emulator)
>       KVM: x86: Improve formatting of the emulator's flags table
>       KVM: x86: Move op_prefix to struct x86_emulate_ctxt (from x86_decod=
e_insn())
>       KVM: x86: Share emulator's common register decoding code
>       KVM: x86: Add x86_emulate_ops.get_xcr() callback
>       KVM: x86: Add AVX support to the emulator's register fetch and writ=
eback
>       KVM: x86: Add emulator support for decoding VEX prefixes
>       KVM: x86: Enable support for emulating AVX MOV instructions
>
> Pawan Gupta (1):
>       x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
>
> Sean Christopherson (18):
>       KVM: x86: Add a helper to dedup reporting of unhandled VM-Exits
>       KVM: TDX: Explicitly set user-return MSRs that *may* be clobbered b=
y the TDX-Module
>       KVM: x86: WARN if user-return MSR notifier is registered on exit
>       KVM: x86: Leave user-return notifier registered on reboot/shutdown
>       KVM: x86: Use "checked" versions of get_user() and put_user()
>       KVM: x86: WARN if hrtimer callback for periodic APIC timer fires wi=
th period=3D0
>       KVM: x86: Grab lapic_timer in a local variable to cleanup periodic =
code
>       KVM: VMX: Use on-stack copy of @flags in __vmx_vcpu_run()
>       x86/bugs: Decouple ALTERNATIVE usage from VERW macro definition
>       x86/bugs: Use an x86 feature to track the MMIO Stale Data mitigatio=
n
>       KVM: VMX: Handle MMIO Stale Data in VM-Enter assembly via ALTERNATI=
VES_2
>       x86/bugs: KVM: Move VM_CLEAR_CPU_BUFFERS into SVM as SVM_CLEAR_CPU_=
BUFFERS
>       KVM: VMX: Bundle all L1 data cache flush mitigation code together
>       KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATION=
S=3Dn
>       KVM: SVM: Handle #MCs in guest outside of fastpath
>       KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of the fastpath
>       KVM: x86: Load guest/host XCR0 and XSS outside of the fastpath run =
loop
>       KVM: x86: Load guest/host PKRU outside of the fastpath run loop
>
> Yue Haibing (1):
>       KVM: x86: Remove unused declaration kvm_mmu_may_ignore_guest_pat()
>
> fuqiang wang (2):
>       KVM: x86: Explicitly set new periodic hrtimer expiration in apic_ti=
mer_fn()
>       KVM: x86: Fix VM hard lockup after prolonged inactivity with period=
ic HV timer
>
>  arch/x86/include/asm/cpufeatures.h   |   5 ++
>  arch/x86/include/asm/hardirq.h       |   4 +-
>  arch/x86/include/asm/kvm_host.h      |   7 +--
>  arch/x86/include/asm/nospec-branch.h |  30 ++++++------
>  arch/x86/kernel/cpu/bugs.c           |  22 ++++-----
>  arch/x86/kvm/emulate.c               | 319 +++++++++++++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------=
------------------------
>  arch/x86/kvm/fpu.h                   |  66 +++++++++++++++++++++++++++
>  arch/x86/kvm/hyperv.c                |   2 +-
>  arch/x86/kvm/kvm_emulate.h           |  20 ++++++--
>  arch/x86/kvm/lapic.c                 |  44 ++++++++++++------
>  arch/x86/kvm/mmu.h                   |   2 -
>  arch/x86/kvm/mmu/mmu.c               |   2 +-
>  arch/x86/kvm/mmu/paging_tmpl.h       |   2 +-
>  arch/x86/kvm/mmu/spte.c              |   2 +-
>  arch/x86/kvm/svm/svm.c               |  27 ++++-------
>  arch/x86/kvm/svm/vmenter.S           |   6 ++-
>  arch/x86/kvm/vmx/nested.c            |   2 +-
>  arch/x86/kvm/vmx/run_flags.h         |  10 ++--
>  arch/x86/kvm/vmx/tdx.c               |  65 ++++++++++----------------
>  arch/x86/kvm/vmx/tdx.h               |   1 -
>  arch/x86/kvm/vmx/vmenter.S           |  29 +++++++-----
>  arch/x86/kvm/vmx/vmx.c               | 264 +++++++++++++++++++++++++++++=
+++++++++++++++++++++++++--------------------------------------------------=
--
>  arch/x86/kvm/x86.c                   | 259 +++++++++++++++++++++++++++++=
++++++++++++++++++++++-----------------------------------------------------
>  arch/x86/kvm/x86.h                   |  16 ++++++-
>  24 files changed, 706 insertions(+), 500 deletions(-)
>


