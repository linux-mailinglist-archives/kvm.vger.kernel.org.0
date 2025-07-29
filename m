Return-Path: <kvm+bounces-53649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B826B151E5
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 19:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92030545329
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 17:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04958204863;
	Tue, 29 Jul 2025 17:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fvoXTomE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2149298264
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 17:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753809149; cv=none; b=nOn176Uzizetd9+QwMWBppIwCpDCnm+3UiAMctHollrwhZGbi4YCK1v4Gs9b0VC/3dH9yqN9ceV0QgELklULoEqwkARgZG3NBouA2zHcT3OEPSxQxir26cy8tSaFQ7SF4tJTBXAdPm93NRjMn609YQWoXtbvydCigqSr1GuU0Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753809149; c=relaxed/simple;
	bh=QxS610P9TAVXS9lebAX19Bdflwa8g+HAo15HaEZhiKE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bIhCLU7LEqHXYWAHaCO9a1fB9HwpVdWxql26yocDF5pyt96zJz5p0ZJA66fctDb/n+/5EVy8B1M1ayh/OrorpniXcI0+mObN4viRs1EIzlOptABhF/d/nbIfaiFxU0yCH/wRuZs9RX3hXGCp6lQLXJ7Ecjc4mNMZ+JRsjy3GPFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fvoXTomE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753809145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hVEV/TSm1W1PFMOSwee9B8OOxzTuIcz20KTJ/vy5N8Y=;
	b=fvoXTomEuzlGCEYd4CMPc8b1lWWHDcrlDBV456kIElPW8huxQtiKOD/TharyZO3+E3rwlE
	t4jzyueUK+PfNPVKWDqZIItdstr1Bl0Soz8ocozhg1/KvtPjjuNbFEkMleg9BdwiL2mY4Y
	lrcQzAaWRliagQXKeQG6CbedtmCqAbQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-CCh0WbovOvOSbj-YylUTMg-1; Tue, 29 Jul 2025 13:12:24 -0400
X-MC-Unique: CCh0WbovOvOSbj-YylUTMg-1
X-Mimecast-MFC-AGG-ID: CCh0WbovOvOSbj-YylUTMg_1753809143
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7882c0992so1416797f8f.0
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 10:12:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753809143; x=1754413943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hVEV/TSm1W1PFMOSwee9B8OOxzTuIcz20KTJ/vy5N8Y=;
        b=eRLEarjW121gzJPowRxnf1WzUWURcpmPcsXATyTQ91ahVSlAYtn6mwuwcK2aA2DAQd
         Kc96xIra4fmowkaY8Oqz85gH0QTOjr0BNpNM5WpCPVzcWV+0oAauG0+WQSAIqd0dGFl0
         7P0fVaH1BQQECsAwAJyOcMoTKPEuKvlErzkWKNtp8TL9vyMajOtWCRzNsS+Phr1L3ySL
         jKUJ0ZUSCxMNYdyeseAZRRmuynRvM+TVzXNRyvBR8RQcQJ98mZ6r3YkJZUViSyqKccsw
         TBDlQlgDdn+P52QI59d0PDMQcLEPPGOiUqZC6AOO2yI+MQ/7ZR30bwBaWx/xiEJeJA8n
         7+pg==
X-Forwarded-Encrypted: i=1; AJvYcCWcg20jTbCL8qN6F7hnQQ5UizSww6BqLUeWMGYzXaZTv+ap+6P0ZJAmOX5tZFLCFTQ4XvQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1rZ76ixGBuhwjivrflXoGAxY9w/hLPrhDXSTuo6xXkrI9MHwt
	R7hHNdejNvoWU1rSBhWQ7zvHCbwkb4XJQM4g3Wo82auOm8blXBHm9AqQqWwOxpFEHuxBHBIxlMW
	AnzUXt11Jh2uJ2RPaJSSR71A6B3AFiPo6mwgIZ3JDbVE6Skm+BkyBb+zOzIXd6sdCm1Hqgk1t8n
	KLMfqeLyX+PihQzN0MlLSVAxSJXGA9
X-Gm-Gg: ASbGncvQAgb9enSPgXZPx8Fqq1+nnHHZw2nsJ2FvFh0h4T76U9dk/5X/bqU+3Hgivv9
	PhfdzxxojJXw/vlQCUouiMHazwSN8pFqJpzmGr4jkuv7dufdc3ZbUEmbj4m1687hdF54zzb3zaT
	664VaAhXFO+fEp/kR+m07GKg==
X-Received: by 2002:a05:6000:4305:b0:3b7:8fcd:d14d with SMTP id ffacd0b85a97d-3b79501078emr312317f8f.46.1753809142794;
        Tue, 29 Jul 2025 10:12:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuiVZnrQB35ydxSwvUCpk0QJExlXpkA5D8EwlqwQR5GaLwV32atgJyeUyqBcgRlQ9q+bEIF74jDHcNM9Iww6w=
X-Received: by 2002:a05:6000:4305:b0:3b7:8fcd:d14d with SMTP id
 ffacd0b85a97d-3b79501078emr312293f8f.46.1753809142307; Tue, 29 Jul 2025
 10:12:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aIe-v1QP-VvaOONC@linux.dev>
In-Reply-To: <aIe-v1QP-VvaOONC@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 29 Jul 2025 19:12:07 +0200
X-Gm-Features: Ac12FXzWw606ViTdS_zZBEZxmMgUBcTeg2CGOllmPTkMWZGmW7scTxSdHaxwzW8
Message-ID: <CABgObfZZxW2seq+B9OdSPG71-SywbTkmUEw1xKONX73QLjDTjQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 changes for 6.17, round #1
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 8:17=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Paolo,
>
> Here's the first round of changes for 6.17.
>
> A very unusual inclusion that you should know about is the GICv5 host dri=
ver.
> Thomas was OK with the driver going through the kvmarm tree [*] as there =
aren't
> any conflicts and Sascha's series adds some KVM support on top.
>
> Otherwise, we've got the usual mix (details in the tag) with some reducti=
on
> of the NV v. non-NV feature gap.

Pulled, thanks.

Paolo

> Please pull.
>
> Thanks,
> Oliver
>
> [*]: https://lore.kernel.org/all/87y0slur4t.ffs@tglx/
>
> The following changes since commit 86731a2a651e58953fc949573895f2fa6d4568=
41:
>
>   Linux 6.16-rc3 (2025-06-22 13:30:08 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-6.17
>
> for you to fetch changes up to 18ec25dd0e97653cdb576bb1750c31acf2513ea7:
>
>   KVM: arm64: selftests: Add FEAT_RAS EL2 registers to get-reg-list (2025=
-07-28 08:28:05 -0700)
>
> ----------------------------------------------------------------
> KVM/arm64 changes for 6.17, round #1
>
>  - Host driver for GICv5, the next generation interrupt controller for
>    arm64, including support for interrupt routing, MSIs, interrupt
>    translation and wired interrupts.
>
>  - Use FEAT_GCIE_LEGACY on GICv5 systems to virtualize GICv3 VMs on
>    GICv5 hardware, leveraging the legacy VGIC interface.
>
>  - Userspace control of the 'nASSGIcap' GICv3 feature, allowing
>    userspace to disable support for SGIs w/o an active state on hardware
>    that previously advertised it unconditionally.
>
>  - Map supporting endpoints with cacheable memory attributes on systems
>    with FEAT_S2FWB and DIC where KVM no longer needs to perform cache
>    maintenance on the address range.
>
>  - Nested support for FEAT_RAS and FEAT_DoubleFault2, allowing the guest
>    hypervisor to inject external aborts into an L2 VM and take traps of
>    masked external aborts to the hypervisor.
>
>  - Convert more system register sanitization to the config-driven
>    implementation.
>
>  - Fixes to the visibility of EL2 registers, namely making VGICv3 system
>    registers accessible through the VGIC device instead of the ONE_REG
>    vCPU ioctls.
>
>  - Various cleanups and minor fixes.
>
> ----------------------------------------------------------------
> Ankit Agrawal (5):
>       KVM: arm64: Rename the device variable to s2_force_noncacheable
>       KVM: arm64: Assume non-PFNMAP/MIXEDMAP VMAs can be mapped cacheable
>       KVM: arm64: Block cacheable PFNMAP mapping
>       KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
>       KVM: arm64: Expose new KVM cap for cacheable PFNMAP
>
> David Woodhouse (1):
>       KVM: arm64: vgic-its: Return -ENXIO to invalid KVM_DEV_ARM_VGIC_GRP=
_CTRL attrs
>
> Kuninori Morimoto (2):
>       arm64: kvm: sys_regs: use string choices helper
>       arm64: kvm: trace_handle_exit: use string choices helper
>
> Lorenzo Pieralisi (30):
>       dt-bindings: interrupt-controller: Add Arm GICv5
>       arm64/sysreg: Add GCIE field to ID_AA64PFR2_EL1
>       arm64/sysreg: Add ICC_PPI_PRIORITY<n>_EL1
>       arm64/sysreg: Add ICC_ICSR_EL1
>       arm64/sysreg: Add ICC_PPI_HMR<n>_EL1
>       arm64/sysreg: Add ICC_PPI_ENABLER<n>_EL1
>       arm64/sysreg: Add ICC_PPI_{C/S}ACTIVER<n>_EL1
>       arm64/sysreg: Add ICC_PPI_{C/S}PENDR<n>_EL1
>       arm64/sysreg: Add ICC_CR0_EL1
>       arm64/sysreg: Add ICC_PCR_EL1
>       arm64/sysreg: Add ICC_IDR0_EL1
>       arm64/sysreg: Add ICH_HFGRTR_EL2
>       arm64/sysreg: Add ICH_HFGWTR_EL2
>       arm64/sysreg: Add ICH_HFGITR_EL2
>       arm64: Disable GICv5 read/write/instruction traps
>       arm64: cpucaps: Rename GICv3 CPU interface capability
>       arm64: cpucaps: Add GICv5 CPU interface (GCIE) capability
>       arm64: Add support for GICv5 GSB barriers
>       irqchip/gic-v5: Add GICv5 PPI support
>       irqchip/gic-v5: Add GICv5 IRS/SPI support
>       irqchip/gic-v5: Add GICv5 LPI/IPI support
>       irqchip/gic-v5: Enable GICv5 SMP booting
>       of/irq: Add of_msi_xlate() helper function
>       PCI/MSI: Add pci_msi_map_rid_ctlr_node() helper function
>       irqchip/gic-v3: Rename GICv3 ITS MSI parent
>       irqchip/msi-lib: Add IRQ_DOMAIN_FLAG_FWNODE_PARENT handling
>       irqchip/gic-v5: Add GICv5 ITS support
>       irqchip/gic-v5: Add GICv5 IWB support
>       docs: arm64: gic-v5: Document booting requirements for GICv5
>       arm64: Kconfig: Enable GICv5
>
> Marc Zyngier (28):
>       arm64: smp: Support non-SGIs for IPIs
>       KVM: arm64: Add helper to identify a nested context
>       arm64: smp: Fix pNMI setup after GICv5 rework
>       KVM: arm64: Make RVBAR_EL2 accesses UNDEF
>       KVM: arm64: Don't advertise ICH_*_EL2 registers through GET_ONE_REG
>       KVM: arm64: Define constant value for ICC_SRE_EL2
>       KVM: arm64: Define helper for ICH_VTR_EL2
>       KVM: arm64: Let GICv3 save/restore honor visibility attribute
>       KVM: arm64: Expose GICv3 EL2 registers via KVM_DEV_ARM_VGIC_GRP_CPU=
_SYSREGS
>       KVM: arm64: Condition FGT registers on feature availability
>       KVM: arm64: Advertise FGT2 registers to userspace
>       KVM: arm64: selftests: get-reg-list: Simplify feature dependency
>       KVM: arm64: selftests: get-reg-list: Add base EL2 registers
>       KVM: arm64: Document registers exposed via KVM_DEV_ARM_VGIC_GRP_CPU=
_SYSREGS
>       arm64: sysreg: Add THE/ASID2 controls to TCR2_ELx
>       KVM: arm64: Convert TCR2_EL2 to config-driven sanitisation
>       KVM: arm64: Convert SCTLR_EL1 to config-driven sanitisation
>       KVM: arm64: Convert MDCR_EL2 to config-driven sanitisation
>       KVM: arm64: Tighten the definition of FEAT_PMUv3p9
>       KVM: arm64: Check for SYSREGS_ON_CPU before accessing the CPU state
>       KVM: arm64: Filter out HCR_EL2 bits when running in hypervisor cont=
ext
>       KVM: arm64: Make RAS registers UNDEF when RAS isn't advertised
>       KVM: arm64: Remove the wi->{e0,}poe vs wr->{p,u}ov confusion
>       KVM: arm64: Follow specification when implementing WXN
>       KVM: arm64: vgic-v3: Fix ordering of ICH_HCR_EL2
>       KVM: arm64: Clarify the check for reset callback in check_sysreg_ta=
ble()
>       KVM: arm64: Enforce the sorting of the GICv3 system register table
>       KVM: arm64: selftest: vgic-v3: Add basic GICv3 sysreg userspace acc=
ess test
>
> Oliver Upton (42):
>       arm64: Detect FEAT_SCTLR2
>       arm64: Detect FEAT_DoubleFault2
>       KVM: arm64: Treat vCPU with pending SError as runnable
>       KVM: arm64: nv: Respect exception routing rules for SEAs
>       KVM: arm64: nv: Honor SError exception routing / masking
>       KVM: arm64: nv: Add FEAT_RAS vSError sys regs to table
>       KVM: arm64: nv: Use guest hypervisor's vSError state
>       KVM: arm64: nv: Advertise support for FEAT_RAS
>       KVM: arm64: nv: Describe trap behavior of SCTLR2_EL1
>       KVM: arm64: Wire up SCTLR2_ELx sysreg descriptors
>       KVM: arm64: Context switch SCTLR2_ELx when advertised to the guest
>       KVM: arm64: Enable SCTLR2 when advertised to the guest
>       KVM: arm64: Describe SCTLR2_ELx RESx masks
>       KVM: arm64: Factor out helper for selecting exception target EL
>       KVM: arm64: nv: Ensure Address size faults affect correct ESR
>       KVM: arm64: Route SEAs to the SError vector when EASE is set
>       KVM: arm64: nv: Take "masked" aborts to EL2 when HCRX_EL2.TMEA is s=
et
>       KVM: arm64: nv: Honor SError routing effects of SCTLR2_ELx.NMEA
>       KVM: arm64: nv: Enable vSErrors when HCRX_EL2.TMEA is set
>       KVM: arm64: Advertise support for FEAT_SCTLR2
>       KVM: arm64: Advertise support for FEAT_DoubleFault2
>       KVM: arm64: Don't retire MMIO instruction w/ pending (emulated) SEr=
ror
>       KVM: arm64: selftests: Add basic SError injection test
>       KVM: arm64: selftests: Test SEAs are taken to SError vector when EA=
SE=3D1
>       KVM: arm64: selftests: Add SCTLR2_EL1 to get-reg-list
>       KVM: arm64: selftests: Catch up set_id_regs with the kernel
>       KVM: arm64: Populate ESR_ELx.EC for emulated SError injection
>       KVM: arm64: selftests: Test ESR propagation for vSError injection
>       KVM: arm64: Commit exceptions from KVM_SET_VCPU_EVENTS immediately
>       KVM: arm64: Disambiguate support for vSGIs v. vLPIs
>       KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
>       KVM: arm64: vgic-v3: Allow access to GICD_IIDR prior to initializat=
ion
>       Documentation: KVM: arm64: Describe VGICv3 registers writable pre-i=
nit
>       Merge branch 'kvm-arm64/cacheable-pfnmap' into kvmarm/next
>       Merge branch 'kvm-arm64/doublefault2' into kvmarm/next
>       Merge tag 'irqchip-gic-v5-host' into kvmarm/next
>       Merge branch 'kvm-arm64/gcie-legacy' into kvmarm/next
>       Merge branch 'kvm-arm64/misc' into kvmarm/next
>       Merge branch 'kvm-arm64/config-masks' into kvmarm/next
>       Merge branch 'kvm-arm64/el2-reg-visibility' into kvmarm/next
>       Merge branch 'kvm-arm64/vgic-v4-ctl' into kvmarm/next
>       KVM: arm64: selftests: Add FEAT_RAS EL2 registers to get-reg-list
>
> Raghavendra Rao Ananta (2):
>       KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap
>       KVM: arm64: selftests: Add test for nASSGIcap attribute
>
> Sascha Bischoff (5):
>       irqchip/gic-v5: Skip deactivate for forwarded PPI interrupts
>       irqchip/gic-v5: Populate struct gic_kvm_info
>       arm64/sysreg: Add ICH_VCTLR_EL2
>       KVM: arm64: gic-v5: Support GICv3 compat
>       KVM: arm64: gic-v5: Probe for GICv5
>
>  Documentation/arch/arm64/booting.rst               |   41 +
>  .../interrupt-controller/arm,gic-v5-iwb.yaml       |   78 ++
>  .../bindings/interrupt-controller/arm,gic-v5.yaml  |  267 +++++
>  Documentation/virt/kvm/api.rst                     |   13 +-
>  Documentation/virt/kvm/devices/arm-vgic-v3.rst     |   80 +-
>  MAINTAINERS                                        |   10 +
>  arch/arm64/Kconfig                                 |    1 +
>  arch/arm64/include/asm/barrier.h                   |    3 +
>  arch/arm64/include/asm/el2_setup.h                 |   45 +
>  arch/arm64/include/asm/kvm_emulate.h               |   51 +-
>  arch/arm64/include/asm/kvm_host.h                  |   36 +-
>  arch/arm64/include/asm/kvm_mmu.h                   |   18 +
>  arch/arm64/include/asm/kvm_nested.h                |    2 +
>  arch/arm64/include/asm/smp.h                       |   24 +-
>  arch/arm64/include/asm/sysreg.h                    |   71 +-
>  arch/arm64/include/asm/vncr_mapping.h              |    2 +
>  arch/arm64/kernel/cpufeature.c                     |   26 +-
>  arch/arm64/kernel/smp.c                            |  142 ++-
>  arch/arm64/kvm/Makefile                            |    3 +-
>  arch/arm64/kvm/arch_timer.c                        |    2 +-
>  arch/arm64/kvm/arm.c                               |   16 +-
>  arch/arm64/kvm/at.c                                |   80 +-
>  arch/arm64/kvm/config.c                            |  255 +++-
>  arch/arm64/kvm/emulate-nested.c                    |   49 +-
>  arch/arm64/kvm/guest.c                             |   62 +-
>  arch/arm64/kvm/handle_exit.c                       |   24 +-
>  arch/arm64/kvm/hyp/exception.c                     |   16 +-
>  arch/arm64/kvm/hyp/include/hyp/switch.h            |   53 +-
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |   49 +-
>  arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   53 +-
>  arch/arm64/kvm/hyp/vhe/switch.c                    |   14 +-
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |    6 +
>  arch/arm64/kvm/inject_fault.c                      |  235 ++--
>  arch/arm64/kvm/mmio.c                              |   12 +-
>  arch/arm64/kvm/mmu.c                               |  105 +-
>  arch/arm64/kvm/nested.c                            |  109 +-
>  arch/arm64/kvm/sys_regs.c                          |  207 +++-
>  arch/arm64/kvm/sys_regs.h                          |    2 +-
>  arch/arm64/kvm/trace_handle_exit.h                 |    2 +-
>  arch/arm64/kvm/vgic-sys-reg-v3.c                   |  127 +-
>  arch/arm64/kvm/vgic/vgic-init.c                    |   30 +-
>  arch/arm64/kvm/vgic/vgic-its.c                     |    3 +
>  arch/arm64/kvm/vgic/vgic-kvm-device.c              |   70 +-
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   33 +-
>  arch/arm64/kvm/vgic/vgic-v3-nested.c               |    2 +-
>  arch/arm64/kvm/vgic/vgic-v4.c                      |    4 +-
>  arch/arm64/kvm/vgic/vgic-v5.c                      |   52 +
>  arch/arm64/kvm/vgic/vgic.c                         |    4 +-
>  arch/arm64/kvm/vgic/vgic.h                         |   48 +
>  arch/arm64/tools/cpucaps                           |    4 +-
>  arch/arm64/tools/sysreg                            |  514 +++++++-
>  drivers/irqchip/Kconfig                            |   12 +
>  drivers/irqchip/Makefile                           |    5 +-
>  drivers/irqchip/irq-gic-common.h                   |    2 -
>  ...3-its-msi-parent.c =3D> irq-gic-its-msi-parent.c} |  168 ++-
>  drivers/irqchip/irq-gic-its-msi-parent.h           |   12 +
>  drivers/irqchip/irq-gic-v3-its.c                   |    1 +
>  drivers/irqchip/irq-gic-v5-irs.c                   |  822 +++++++++++++
>  drivers/irqchip/irq-gic-v5-its.c                   | 1228 ++++++++++++++=
++++++
>  drivers/irqchip/irq-gic-v5-iwb.c                   |  284 +++++
>  drivers/irqchip/irq-gic-v5.c                       | 1137 ++++++++++++++=
++++
>  drivers/irqchip/irq-gic.c                          |    2 +-
>  drivers/irqchip/irq-msi-lib.c                      |    5 +-
>  drivers/of/irq.c                                   |   22 +-
>  drivers/pci/msi/irqdomain.c                        |   20 +
>  include/asm-generic/msi.h                          |    1 +
>  include/kvm/arm_vgic.h                             |    9 +-
>  include/linux/irqchip/arm-gic-v5.h                 |  394 +++++++
>  include/linux/irqchip/arm-vgic-info.h              |    4 +
>  include/linux/irqdomain.h                          |    3 +
>  include/linux/msi.h                                |    1 +
>  include/linux/of_irq.h                             |    5 +
>  include/uapi/linux/kvm.h                           |    1 +
>  tools/testing/selftests/kvm/Makefile.kvm           |    2 +-
>  .../testing/selftests/kvm/arm64/external_aborts.c  |  330 ++++++
>  tools/testing/selftests/kvm/arm64/get-reg-list.c   |  203 +++-
>  tools/testing/selftests/kvm/arm64/mmio_abort.c     |  159 ---
>  tools/testing/selftests/kvm/arm64/set_id_regs.c    |   14 +-
>  tools/testing/selftests/kvm/arm64/vgic_init.c      |  259 ++++-
>  .../selftests/kvm/include/arm64/processor.h        |   10 +
>  80 files changed, 7589 insertions(+), 681 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controlle=
r/arm,gic-v5-iwb.yaml
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controlle=
r/arm,gic-v5.yaml
>  create mode 100644 arch/arm64/kvm/vgic/vgic-v5.c
>  rename drivers/irqchip/{irq-gic-v3-its-msi-parent.c =3D> irq-gic-its-msi=
-parent.c} (59%)
>  create mode 100644 drivers/irqchip/irq-gic-its-msi-parent.h
>  create mode 100644 drivers/irqchip/irq-gic-v5-irs.c
>  create mode 100644 drivers/irqchip/irq-gic-v5-its.c
>  create mode 100644 drivers/irqchip/irq-gic-v5-iwb.c
>  create mode 100644 drivers/irqchip/irq-gic-v5.c
>  create mode 100644 include/linux/irqchip/arm-gic-v5.h
>  create mode 100644 tools/testing/selftests/kvm/arm64/external_aborts.c
>  delete mode 100644 tools/testing/selftests/kvm/arm64/mmio_abort.c
>


