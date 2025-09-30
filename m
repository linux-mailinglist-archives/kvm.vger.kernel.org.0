Return-Path: <kvm+bounces-59215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 955EABAE463
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 20:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3ECE9162886
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC4B726F2B2;
	Tue, 30 Sep 2025 18:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PkIKp/94"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADE5264A72
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 18:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759255616; cv=none; b=UDHQ39de8BIWLbGgafFGBg43vVO4tWDTJU/FdZN1r/NUKVn13wMgzV4UNyCTOkFSPUkTFzCmOcXOxW2iRD2x94fsb3u8tY92F5d0SCXPqXoNb8it2LH5h/9IRG28xleTcyWEJsBhIftz4JLUeLwrmeo3TP+o/ylWsCKaVE/AQl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759255616; c=relaxed/simple;
	bh=qFcz1dV1YGGPk7jg3gWKC4lRk+QuKsYSd+GQEOqxKLU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T9Hl2NIGNMpChhRj2evoWvyNp2GFjifr140Rt45gi4yteMO8MPdN9a+l7GRjOCL/yVFjREO2OUM0qtcieK0IL/uQq3g1HFq8K/RLvh2HaEJr6/qo4tUPtAsSDydsWcvZzS8JJvryvNEj0K4RXc1yVGMNwofdlcybq3bJMwEs8DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PkIKp/94; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759255613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpKm0dFrjXQg6quBiOiFQMH07voE6dne+t2Mqkp3Nf0=;
	b=PkIKp/94EVdk1gkUk4c1tqbgqbIFfnnCO7CGJVuFQumNbj517olLCRqJ1r+j90gQ7jfLn/
	P0l8sMFb2vmxOhlqP0/a3qM0K9+pGUiSgR7iNzHKZPZEAbcy1HOw8KcEDsyb6c0tckMHdA
	Sq59heParo+z9VKM+3gcwuhQtaXtetU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-wh2uOl4uPMaBuHXeAqUWiA-1; Tue, 30 Sep 2025 14:06:49 -0400
X-MC-Unique: wh2uOl4uPMaBuHXeAqUWiA-1
X-Mimecast-MFC-AGG-ID: wh2uOl4uPMaBuHXeAqUWiA_1759255605
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e36686ca1so48939915e9.2
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 11:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759255605; x=1759860405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JpKm0dFrjXQg6quBiOiFQMH07voE6dne+t2Mqkp3Nf0=;
        b=ldj7r/uWrtWmzeiOAB8Kpp1GYlRMKOAl3toBiJ5DJmONkVPo3zfgMX7rmrqprVLBcH
         vdHingRryRoAwGzJRD1PfBDLXtdhrnGNvpDaKlw7V/ldWWSyGVh0zmUIg1SbnJva2AGP
         6OSN8mbz4MJI5e43xrKR3hBQLCqhY4mTKUbjqB8D8CxYJW93GiFRLtMGlG1ECOSC4iHv
         n45NAK6L8mhAEYXfD9RglS+Jq1xvrDLKkSxaE58EWK8G+Hwj70KVdBqCEqHkSDJLX41q
         YVZUe1mrXm0Zcr/jxDsc1TUKoM5Js1b4odb2UCaTvfBQ65LycjHsnFbNMcVkqLNwDv86
         WXMg==
X-Gm-Message-State: AOJu0Yzi5p+E94JEbzFvbDFQZ1WcH2g4FlFnc+Qb1zEqIbfFZmcBkqKl
	W/hcBF4qiLjm6rO7UI7APkgH+qqTLfxe9tMX7EbXpk2Dny8/S48EuX2ZN5rXZg3wz39sPu4iZIh
	MKgF92XUl0U8K6rpcxscgfigbZhn8icKPz3WNaPIhKallbr0KWrD5hMB0JHJh6jMbUy+HaUffmJ
	W70O8kQI9oVRPZP12WUBR89YEPEc6J
X-Gm-Gg: ASbGncv42ARpL98vbaYKRz+s/ZEV4AW3XXkbF5XU9A46Wsh45lHV/xGSH5xEyEUfDRM
	B6pbm1GTL/0Oyb1r/oWoQ4vXE+EyubYYhwlXbdVw+FzDy+hQFscKJQOSxvNhun/MRmEaviMHuQY
	TAO5hEGOblsA+iz45WN64q9crDhl6lol4Zgen14UHcQlub/8VuU6y5TIsCCd9+u7XTHQ1ZGuh6Y
	lfH0DWJ6X+phNezGfdPWf6QV8pQiiaI
X-Received: by 2002:a05:6000:2285:b0:3e9:f852:491 with SMTP id ffacd0b85a97d-42557817472mr569272f8f.56.1759255604806;
        Tue, 30 Sep 2025 11:06:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkuzDUpH3hJ/eEx8518guHOciZDxN6WeZpJBg9+T12QvmaKMXeXJMMKkBMA+oLH0g9N3BU1CkrtvsILn1x44I=
X-Received: by 2002:a05:6000:2285:b0:3e9:f852:491 with SMTP id
 ffacd0b85a97d-42557817472mr569251f8f.56.1759255604355; Tue, 30 Sep 2025
 11:06:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com> <20250927060910.2933942-9-seanjc@google.com>
In-Reply-To: <20250927060910.2933942-9-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 20:06:32 +0200
X-Gm-Features: AS18NWAHjDdEagGw10QIXV6IzbJLHbiWXe-YR-HydnFS0OfX3BCgx8lOFDBBiws
Message-ID: <CABgObfZ4wn++Ab2Jtwk7F+kBtRctrodqfnEpTgv6zZJpnOODgQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.18
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Lots and lots (and lots) of prep work for CET and FRED virtualization, an=
d for
> mediated vPMU support (about 1/3 of that series is in here, as it didn't =
make
> the cut this time around, and the cleanups are worthwhile on their own).
>
> Buried in here is also support for immediate forms of RDMSR/WRMSRNS, and
> fastpath exit handling for TSC_DEADLINE writes on AMD.
>
> The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0=
b9:
>
>   Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-misc-6.18
>
> for you to fetch changes up to 86bcd23df9cec9c2df520ae0982033e301d3c184:
>
>   KVM: x86: Fix hypercalls docs section number order (2025-09-22 07:51:36=
 -0700)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM x86 changes for 6.18
>
>  - Don't (re)check L1 intercepts when completing userspace I/O to fix a f=
law
>    where a misbehaving usersepace (a.k.a. syzkaller) could swizzle L1's
>    intercepts and trigger a variety of WARNs in KVM.
>
>  - Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2 guests, as the MSR i=
s
>    supposed to exist for v2 PMUs.
>
>  - Allow Centaur CPU leaves (base 0xC000_0000) for Zhaoxin CPUs.
>
>  - Clean up KVM's vector hashing code for delivering lowest priority IRQs=
.
>
>  - Clean up the fastpath handler code to only handle IPIs and WRMSRs that=
 are
>    actually "fast", as opposed to handling those that KVM _hopes_ are fas=
t, and
>    in the process of doing so add fastpath support for TSC_DEADLINE write=
s on
>    AMD CPUs.
>
>  - Clean up a pile of PMU code in anticipation of adding support for medi=
ated
>    vPMUs.
>
>  - Add support for the immediate forms of RDMSR and WRMSRNS, sans full
>    emulator support (KVM should never need to emulate the MSRs outside of
>    forced emulation and other contrived testing scenarios).
>
>  - Clean up the MSR APIs in preparation for CET and FRED virtualization, =
as
>    well as mediated vPMU support.
>
>  - Rejecting a fully in-kernel IRQCHIP if EOIs are protected, i.e. for TD=
X VMs,
>    as KVM can't faithfully emulate an I/O APIC for such guests.
>
>  - KVM_REQ_MSR_FILTER_CHANGED into a generic RECALC_INTERCEPTS in prepara=
tion
>    for mediated vPMU support, as KVM will need to recalculate MSR interce=
pts in
>    response to PMU refreshes for guests with mediated vPMUs.
>
>  - Misc cleanups and minor fixes.
>
> ----------------------------------------------------------------
> Bagas Sanjaya (1):
>       KVM: x86: Fix hypercalls docs section number order
>
> Chao Gao (1):
>       KVM: x86: Zero XSTATE components on INIT by iterating over supporte=
d features
>
> Dapeng Mi (5):
>       KVM: x86/pmu: Correct typo "_COUTNERS" to "_COUNTERS"
>       KVM: x86: Rename vmx_vmentry/vmexit_ctrl() helpers
>       KVM: x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h hea=
der
>       KVM: VMX: Add helpers to toggle/change a bit in VMCS execution cont=
rols
>       KVM: x86/pmu: Use BIT_ULL() instead of open coded equivalents
>
> Ewan Hai (1):
>       KVM: x86: allow CPUID 0xC000_0000 to proceed on Zhaoxin CPUs
>
> Jiaming Zhang (1):
>       Documentation: KVM: Call out that KVM strictly follows the 8254 PIT=
 spec
>
> Liao Yuanhong (2):
>       KVM: x86: Use guard() instead of mutex_lock() to simplify code
>       KVM: x86: hyper-v: Use guard() instead of mutex_lock() to simplify =
code
>
> Sagi Shahar (1):
>       KVM: TDX: Reject fully in-kernel irqchip if EOIs are protected, i.e=
. for TDX VMs
>
> Sean Christopherson (34):
>       KVM: x86: Don't (re)check L1 intercepts when completing userspace I=
/O
>       KVM: SVM: Emulate PERF_CNTR_GLOBAL_STATUS_SET for PerfMonV2
>       KVM: SVM: Skip fastpath emulation on VM-Exit if next RIP isn't vali=
d
>       KVM: x86: Add kvm_icr_to_lapic_irq() helper to allow for fastpath I=
PIs
>       KVM: x86: Only allow "fast" IPIs in fastpath WRMSR(X2APIC_ICR) hand=
ler
>       KVM: x86: Drop semi-arbitrary restrictions on IPI type in fastpath
>       KVM: x86: Unconditionally handle MSR_IA32_TSC_DEADLINE in fastpath =
exits
>       KVM: x86: Acquire SRCU in WRMSR fastpath iff instruction needs to b=
e skipped
>       KVM: x86: Unconditionally grab data from EDX:EAX in WRMSR fastpath
>       KVM: x86: Fold WRMSR fastpath helpers into the main handler
>       KVM: x86/pmu: Move kvm_init_pmu_capability() to pmu.c
>       KVM: x86/pmu: Add wrappers for counting emulated instructions/branc=
hes
>       KVM: x86/pmu: Calculate set of to-be-emulated PMCs at time of WRMSR=
s
>       KVM: x86/pmu: Rename pmc_speculative_in_use() to pmc_is_locally_ena=
bled()
>       KVM: x86/pmu: Open code pmc_event_is_allowed() in its callers
>       KVM: x86/pmu: Drop redundant check on PMC being globally enabled fo=
r emulation
>       KVM: x86/pmu: Drop redundant check on PMC being locally enabled for=
 emulation
>       KVM: x86/pmu: Rename check_pmu_event_filter() to pmc_is_event_allow=
ed()
>       KVM: x86: Push acquisition of SRCU in fastpath into kvm_pmu_trigger=
_event()
>       KVM: x86: Add a fastpath handler for INVD
>       KVM: x86: Rename local "ecx" variables to "msr" and "pmc" as approp=
riate
>       KVM: x86: Use double-underscore read/write MSR helpers as appropria=
te
>       KVM: x86: Manually clear MPX state only on INIT
>       KVM: x86: Move kvm_irq_delivery_to_apic() from irq.c to lapic.c
>       KVM: x86: Make "lowest priority" helpers local to lapic.c
>       KVM: x86: Move vector_hashing into lapic.c
>       KVM: VMX: Setup canonical VMCS config prior to kvm_x86_vendor_init(=
)
>       KVM: SVM: Check pmu->version, not enable_pmu, when getting PMC MSRs
>       KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities
>       KVM: x86: Rework KVM_REQ_MSR_FILTER_CHANGED into a generic RECALC_I=
NTERCEPTS
>       KVM: x86: Use KVM_REQ_RECALC_INTERCEPTS to react to CPUID updates
>       KVM: x86/pmu: Move initialization of valid PMCs bitmask to common x=
86
>       KVM: x86/pmu: Restrict GLOBAL_{CTRL,STATUS}, fixed PMCs, and PEBS t=
o PMU v2+
>       KVM: x86: Don't treat ENTER and LEAVE as branches, because they are=
n't
>
> Thomas Huth (1):
>       arch/x86/kvm/ioapic: Remove license boilerplate with bad FSF addres=
s
>
> Xin Li (5):
>       x86/cpufeatures: Add a CPU feature bit for MSR immediate form instr=
uctions
>       KVM: x86: Rename handle_fastpath_set_msr_irqoff() to handle_fastpat=
h_wrmsr()
>       KVM: x86: Add support for RDMSR/WRMSRNS w/ immediate on Intel
>       KVM: VMX: Support the immediate form of WRMSRNS in the VM-Exit fast=
path
>       KVM: x86: Advertise support for the immediate form of MSR instructi=
ons
>
> Yang Weijiang (2):
>       KVM: x86: Rename kvm_{g,s}et_msr()* to show that they emulate guest=
 accesses
>       KVM: x86: Add kvm_msr_{read,write}() helpers
>
> Yury Norov (1):
>       kvm: x86: simplify kvm_vector_to_index()
>
>  Documentation/virt/kvm/api.rst                     |   6 +
>  Documentation/virt/kvm/x86/hypercalls.rst          |   6 +-
>  arch/x86/include/asm/cpufeatures.h                 |   1 +
>  arch/x86/include/asm/kvm-x86-ops.h                 |   2 +-
>  arch/x86/include/asm/kvm_host.h                    |  31 +-
>  arch/x86/include/asm/msr-index.h                   |  16 +-
>  arch/x86/include/uapi/asm/vmx.h                    |   6 +-
>  arch/x86/kernel/cpu/scattered.c                    |   1 +
>  arch/x86/kvm/cpuid.c                               |  13 +-
>  arch/x86/kvm/emulate.c                             |  13 +-
>  arch/x86/kvm/hyperv.c                              |  12 +-
>  arch/x86/kvm/ioapic.c                              |  15 +-
>  arch/x86/kvm/irq.c                                 |  57 ----
>  arch/x86/kvm/irq.h                                 |   4 -
>  arch/x86/kvm/kvm_emulate.h                         |   3 +-
>  arch/x86/kvm/lapic.c                               | 169 ++++++++---
>  arch/x86/kvm/lapic.h                               |  15 +-
>  arch/x86/kvm/pmu.c                                 | 169 +++++++++--
>  arch/x86/kvm/pmu.h                                 |  60 +---
>  arch/x86/kvm/reverse_cpuid.h                       |   5 +
>  arch/x86/kvm/smm.c                                 |   4 +-
>  arch/x86/kvm/svm/pmu.c                             |   8 +-
>  arch/x86/kvm/svm/svm.c                             |  30 +-
>  arch/x86/kvm/vmx/capabilities.h                    |   3 -
>  arch/x86/kvm/vmx/main.c                            |  14 +-
>  arch/x86/kvm/vmx/nested.c                          |  29 +-
>  arch/x86/kvm/vmx/pmu_intel.c                       |  85 +++---
>  arch/x86/kvm/vmx/tdx.c                             |   5 +
>  arch/x86/kvm/vmx/vmx.c                             |  91 ++++--
>  arch/x86/kvm/vmx/vmx.h                             |  13 +
>  arch/x86/kvm/vmx/x86_ops.h                         |   2 +-
>  arch/x86/kvm/x86.c                                 | 334 ++++++++++++---=
------
>  arch/x86/kvm/x86.h                                 |   5 +-
>  .../testing/selftests/kvm/x86/pmu_counters_test.c  |   8 +-
>  34 files changed, 715 insertions(+), 520 deletions(-)
>


