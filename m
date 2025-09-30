Return-Path: <kvm+bounces-59197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47A41BAE242
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 077473AF914
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C89C30BBA2;
	Tue, 30 Sep 2025 17:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TAzc/VoC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DC526A1CF
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759252372; cv=none; b=QTWi7UcUtN8RrtZPHWf3OW3wtksNv7icoxhWPK1QdLaTBON78l6gtjV3Ndm8awhh87HvkgAmbWxfLRqjoaKVlbMPLYI9chr37MDblXWrYHC5qk+sVUp+2k+Tm2b/7Wjt7PaVUwAsTaFTAh97LAM/td2yf11Q/e+ZsPMwiPE/sx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759252372; c=relaxed/simple;
	bh=NxSG+08wULnMAWA0EABldWyptNLUWJJIIYv1l2hsWX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B4KKfYQ0uSDxK0+1pYNVWyKOGQLtJPB+9keD+JZrrwAlV40e/ZBVdhvOLRwuzIi3bdT+m+hlMO8GG3Uy43tGWpqiR6sxWLq5PfH2KMSicLvetyDobrfcvQF4k1ZTVIhwZ2C9sxS881pOULjACGVSp8J1hIp8llE++dYCfxWmVI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TAzc/VoC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759252367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=crxiY9tGRwN9dw+nVFA/3krVGNuaMXqKw46DEWrYr1I=;
	b=TAzc/VoCTgEhJsASa5LXNS04sm+tuJ5HsScMUzj/v3GcuTTUmR4TgnPywSO5xVmSSUGc+2
	LcCjfBKl46xUYfY5feg+UcK362NbH9GaWGxwZRhT1wZL6t8oWJR/bCsxJ+dBBR5wIGr9NR
	4ve43yQRTev0uS5VEzRjUjfauGnje40=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-luBJOaEZMta5LllOIiY_2w-1; Tue, 30 Sep 2025 13:12:45 -0400
X-MC-Unique: luBJOaEZMta5LllOIiY_2w-1
X-Mimecast-MFC-AGG-ID: luBJOaEZMta5LllOIiY_2w_1759252364
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-401dbafbcfaso4238500f8f.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:12:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759252364; x=1759857164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crxiY9tGRwN9dw+nVFA/3krVGNuaMXqKw46DEWrYr1I=;
        b=Xq3LoluPRzekB4m4VQybqj5xo1QqivKgF15wvVR/Dsz0x5Ds9VIlMrVCrw2BtHQp56
         q5xyjpzRCnMWk1IugwhydMZKaJKkWVyVuRBsV1AgXWVceGg5kT4EaoSUQcEj1y6/FT/p
         vpALyiAuus4gH1T5mDFOIXrRt4pa4KEb5e7w6sLR/3wzxAr4ed0BfNJQyyAcRkqeU1/s
         Y1k8+WmF9dCPCUXRiLSKJVLe7R8elP/tev7LJe42tbisecz7W68GUMn9TawCbmkYAoGc
         3O/dQBZajXQ2+6hM9tCdvWDyx0Nafb5leKTlK3t7XLPZSVC//87U5DcGwobAm/4EoLcb
         ikhg==
X-Forwarded-Encrypted: i=1; AJvYcCWSMrmCXFPwOejLVgRb9V7aCcaW2bz1LqRok5AW9F3/qMNqmg1DhJtEerinRBvO5IwMNlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIMH8wwt6pRsS/ZJUv3UqAXj/8pnP3UoMMc7dFZVKJceh+tTCP
	l0eN1P5B6CZMt5n+2wPVdKwBV+diQ8hbZsDa4lV7GIxhL258Z18/PIna6eotYnoz2VAcUKitBDu
	G468sUECGLml0ltRiBcsRu+S8ErXbdJDru6fD0qKRQvow0RxkFAZLVRlz0879D1t26GUH2x1R8K
	0p+ry2Fwvp8r9ND9CNw3lGHHH2pLyJ
X-Gm-Gg: ASbGncsbR/Njwe0v3h12Et/FMWocXvh/ynQeAr2Moromjbjuudxn7QXebyk+xodaShX
	pjY3Ub4HklTyT5SqKWusCQzNB4BtukSyGeo0rT+EvgTKBTHoDT/0ueWsEK3AIexEeme1e4UmDOa
	NYMCAWhKM/ykTeJpEVMh2PgevelhGZkMUrdpXoxXwExmb182Lvtfh0e1XqmMrrfabmvne0Lq6Wo
	qjIPSWSJ+J+fKSvj1ek/Ied8NhUVPQ7
X-Received: by 2002:a05:6000:420a:b0:3f0:9bf0:a369 with SMTP id ffacd0b85a97d-425577f34e9mr452452f8f.14.1759252363934;
        Tue, 30 Sep 2025 10:12:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtaqrr0vVmcivSg/YJxtVy/BjOxhQ3k2UEwlP01pXmVPiJQoN4zRbSjkS6a+a4z9Ide2LvHaou3Ic7hF4LMS8=
X-Received: by 2002:a05:6000:420a:b0:3f0:9bf0:a369 with SMTP id
 ffacd0b85a97d-425577f34e9mr452422f8f.14.1759252363372; Tue, 30 Sep 2025
 10:12:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250925182611.2585933-1-maz@kernel.org>
In-Reply-To: <20250925182611.2585933-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:12:31 +0200
X-Gm-Features: AS18NWBqfCBUwLAI9xj9-s_mUFVswliDzX1ByAR29CS4xYp5lzSZuLHCxRIhhsA
Message-ID: <CABgObfbq2baD2wuDkX3Wyhh7y+n52tGOJcG_f6w+zUU_6aj3Pg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.18
To: Marc Zyngier <maz@kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Ayrton Munoz <ayrton@google.com>, Ben Horgan <ben.horgan@arm.com>, Fuad Tabba <tabba@google.com>, 
	Itaru Kitayama <itaru.kitayama@linux.dev>, James Clark <james.clark@linaro.org>, 
	Jinqian Yang <yangjinqian1@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Keir Fraser <keirf@google.com>, Kunwu Chan <kunwu.chan@linux.dev>, Leo Yan <leo.yan@arm.com>, 
	Li RongQing <lirongqing@baidu.com>, Mark Brown <broonie@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mostafa Saleh <smostafa@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Per Larsen <perlarsen@google.com>, 
	Quentin Perret <qperret@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sascha Bischoff <sascha.bischoff@arm.com>, Sebastian Ene <sebastianene@google.com>, 
	Steven Price <steven.price@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Vincent Donnefort <vdonnefort@google.com>, 
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>, Will Deacon <will@kernel.org>, 
	Yingchao Deng <yingchao.deng@oss.qualcomm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2025 at 8:26=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> Paolo,
>
> Here's the initial set of updates for 6.18.
>
> As expected, we have a bunch of NV follow-ups, fixing a number of
> issues and working around some architectural misfeatures. Of note is
> the addition of a basic framework to run our EL1 tests at EL2 in a
> more or less transparent way. On the pKVM side, the only new thing is
> the FF-A 1.2 support, which I'm sure will change the world as we know
> it </sarcasm>.
>
> As usual, a whole lot of more or less interesting fixes, details in
> the tag below.
>
> Please pull,

Can't complain about more self tests! Pulled, thanks - sorry for the delay.

Paolo

>         M.
>
> The following changes since commit b320789d6883cc00ac78ce83bccbfe7ed58afc=
f0:
>
>   Linux 6.17-rc4 (2025-08-31 15:33:07 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-6.18
>
> for you to fetch changes up to 10fd0285305d0b48e8a3bf15d4f17fc4f3d68cb6:
>
>   Merge branch kvm-arm64/selftests-6.18 into kvmarm-master/next (2025-09-=
24 19:35:50 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 updates for 6.18
>
> - Add support for FF-A 1.2 as the secure memory conduit for pKVM,
>   allowing more registers to be used as part of the message payload.
>
> - Change the way pKVM allocates its VM handles, making sure that the
>   privileged hypervisor is never tricked into using uninitialised
>   data.
>
> - Speed up MMIO range registration by avoiding unnecessary RCU
>   synchronisation, which results in VMs starting much quicker.
>
> - Add the dump of the instruction stream when panic-ing in the EL2
>   payload, just like the rest of the kernel has always done. This will
>   hopefully help debugging non-VHE setups.
>
> - Add 52bit PA support to the stage-1 page-table walker, and make use
>   of it to populate the fault level reported to the guest on failing
>   to translate a stage-1 walk.
>
> - Add NV support to the GICv3-on-GICv5 emulation code, ensuring
>   feature parity for guests, irrespective of the host platform.
>
> - Fix some really ugly architecture problems when dealing with debug
>   in a nested VM. This has some bad performance impacts, but is at
>   least correct.
>
> - Add enough infrastructure to be able to disable EL2 features and
>   give effective values to the EL2 control registers. This then allows
>   a bunch of features to be turned off, which helps cross-host
>   migration.
>
> - Large rework of the selftest infrastructure to allow most tests to
>   transparently run at EL2. This is the first step towards enabling
>   NV testing.
>
> - Various fixes and improvements all over the map, including one BE
>   fix, just in time for the removal of the feature.
>
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>       KVM: arm64: Update stale comment for sanitise_mte_tags()
>
> Ben Horgan (1):
>       KVM: arm64: Fix debug checking for np-guests using huge mappings
>
> Fuad Tabba (10):
>       KVM: arm64: Add build-time check for duplicate DECLARE_REG use
>       KVM: arm64: Rename pkvm.enabled to pkvm.is_protected
>       KVM: arm64: Rename 'host_kvm' to 'kvm' in pKVM host code
>       KVM: arm64: Clarify comments to distinguish pKVM mode from protecte=
d VMs
>       KVM: arm64: Decouple hyp VM creation state from its handle
>       KVM: arm64: Separate allocation and insertion of pKVM VM table entr=
ies
>       KVM: arm64: Consolidate pKVM hypervisor VM initialization logic
>       KVM: arm64: Introduce separate hypercalls for pKVM VM reservation a=
nd initialization
>       KVM: arm64: Reserve pKVM handle during pkvm_init_host_vm()
>       KVM: arm64: Fix page leak in user_mem_abort()
>
> James Clark (1):
>       KVM: arm64: Add trap configs for PMSDSFR_EL1
>
> Jinqian Yang (2):
>       KVM: arm64: Make ID_AA64MMFR1_EL1.{HCX, TWED} writable from userspa=
ce
>       KVM: arm64: selftests: Test writes to ID_AA64MMFR1_EL1.{HCX, TWED}
>
> Keir Fraser (4):
>       KVM: arm64: vgic-init: Remove vgic_ready() macro
>       KVM: arm64: vgic: Explicitly implement vgic_dist::ready ordering
>       KVM: Implement barriers before accessing kvm->buses[] on SRCU read =
paths
>       KVM: Avoid synchronize_srcu() in kvm_io_bus_register_dev()
>
> Marc Zyngier (39):
>       Merge branch kvm-arm64/ffa-1.2 into kvmarm-master/next
>       Merge branch kvm-arm64/pkvm_vm_handle into kvmarm-master/next
>       KVM: arm64: Fix kvm_vcpu_{set,is}_be() to deal with EL2 state
>       Merge branch kvm-arm64/mmio-rcu into kvmarm-master/next
>       Merge branch kvm-arm64/dump-instr into kvmarm-master/next
>       KVM: arm64: Don't access ICC_SRE_EL2 if GICv3 doesn't support v2 co=
mpatibility
>       KVM: arm64: Remove duplicate FEAT_{SYSREG128,MTE2} descriptions
>       KVM: arm64: Add reg_feat_map_desc to describe full register depende=
ncy
>       KVM: arm64: Enforce absence of FEAT_FGT on FGT registers
>       KVM: arm64: Enforce absence of FEAT_FGT2 on FGT2 registers
>       KVM: arm64: Enforce absence of FEAT_HCX on HCRX_EL2
>       KVM: arm64: Convert HCR_EL2 RES0 handling to compute_reg_res0_bits(=
)
>       KVM: arm64: Enforce absence of FEAT_SCTLR2 on SCTLR2_EL{1,2}
>       KVM: arm64: Enforce absence of FEAT_TCR2 on TCR2_EL2
>       KVM: arm64: Convert SCTLR_EL1 RES0 handling to compute_reg_res0_bit=
s()
>       KVM: arm64: Convert MDCR_EL2 RES0 handling to compute_reg_res0_bits=
()
>       KVM: arm64: Add helper computing the state of 52bit PA support
>       KVM: arm64: Account for 52bit when computing maximum OA
>       KVM: arm64: Compute 52bit TTBR address and alignment
>       KVM: arm64: Decouple output address from the PT descriptor
>       KVM: arm64: Pass the walk_info structure to compute_par_s1()
>       KVM: arm64: Compute shareability for LPA2
>       KVM: arm64: Populate PAR_EL1 with 52bit addresses
>       KVM: arm64: Expand valid block mappings to FEAT_LPA/LPA2 support
>       KVM: arm64: Report faults from S1 walk setup at the expected start =
level
>       KVM: arm64: Allow use of S1 PTW for non-NV vcpus
>       KVM: arm64: Allow EL1 control registers to be accessed from the CPU=
 state
>       KVM: arm64: Don't switch MMU on translation from non-NV context
>       KVM: arm64: Add filtering hook to S1 page table walk
>       KVM: arm64: Add S1 IPA to page table level walker
>       KVM: arm64: Populate level on S1PTW SEA injection
>       KVM: arm64: selftest: Expand external_aborts test to look for TTW l=
evels
>       Merge branch kvm-arm64/52bit-at into kvmarm-master/next
>       Merge branch kvm-arm64/gic-v5-nv into kvmarm-master/next
>       Merge branch kvm-arm64/nv-debug into kvmarm-master/next
>       Merge branch kvm-arm64/el2-feature-control into kvmarm-master/next
>       Merge branch kvm-arm64/nv-misc-6.18 into kvmarm-master/next
>       Merge branch kvm-arm64/misc-6.18 into kvmarm-master/next
>       Merge branch kvm-arm64/selftests-6.18 into kvmarm-master/next
>
> Mark Brown (3):
>       KVM: arm64: Expose FEAT_LSFE to guests
>       KVM: arm64: selftests: Remove a duplicate register listing in set_i=
d_regs
>       KVM: arm64: selftests: Cover ID_AA64ISAR3_EL1 in set_id_regs
>
> Mostafa Saleh (2):
>       KVM: arm64: Dump instruction on hyp panic
>       KVM: arm64: Map hyp text as RO and dump instr on panic
>
> Oliver Upton (29):
>       KVM: arm64: nv: Trap debug registers when in hyp context
>       KVM: arm64: nv: Apply guest's MDCR traps in nested context
>       KVM: arm64: nv: Treat AMO as 1 when at EL2 and {E2H,TGE} =3D {1, 0}
>       KVM: arm64: nv: Allow userspace to de-feature stage-2 TGRANs
>       KVM: arm64: nv: Convert masks to denylists in limit_nv_id_reg()
>       KVM: arm64: nv: Don't erroneously claim FEAT_DoubleLock for NV VMs
>       KVM: arm64: nv: Expose FEAT_DF2 to NV-enabled VMs
>       KVM: arm64: nv: Expose FEAT_RASv1p1 via RAS_frac
>       KVM: arm64: nv: Expose FEAT_ECBHB to NV-enabled VMs
>       KVM: arm64: nv: Expose FEAT_AFP to NV-enabled VMs
>       KVM: arm64: nv: Exclude guest's TWED configuration when TWE isn't s=
et
>       KVM: arm64: nv: Expose FEAT_TWED to NV-enabled VMs
>       KVM: arm64: nv: Advertise FEAT_SpecSEI to NV-enabled VMs
>       KVM: arm64: nv: Advertise FEAT_TIDCP1 to NV-enabled VMs
>       KVM: arm64: nv: Expose up to FEAT_Debugv8p8 to NV-enabled VMs
>       KVM: arm64: selftests: Provide kvm_arch_vm_post_create() in library=
 code
>       KVM: arm64: selftests: Initialize VGICv3 only once
>       KVM: arm64: selftests: Add helper to check for VGICv3 support
>       KVM: arm64: selftests: Add unsanitised helpers for VGICv3 creation
>       KVM: arm64: selftests: Create a VGICv3 for 'default' VMs
>       KVM: arm64: selftests: Alias EL1 registers to EL2 counterparts
>       KVM: arm64: selftests: Provide helper for getting default vCPU targ=
et
>       KVM: arm64: selftests: Select SMCCC conduit based on current EL
>       KVM: arm64: selftests: Use hyp timer IRQs when test runs at EL2
>       KVM: arm64: selftests: Use the vCPU attr for setting nr of PMU coun=
ters
>       KVM: arm64: selftests: Initialize HCR_EL2
>       KVM: arm64: selftests: Enable EL2 by default
>       KVM: arm64: selftests: Add basic test for running in VHE EL2
>       KVM: arm64: selftests: Cope with arch silliness in EL2 selftest
>
> Per Larsen (6):
>       KVM: arm64: Correct return value on host version downgrade attempt
>       KVM: arm64: Use SMCCC 1.2 for FF-A initialization and in host handl=
er
>       KVM: arm64: Mark FFA_NOTIFICATION_* calls as unsupported
>       KVM: arm64: Mark optional FF-A 1.2 interfaces as unsupported
>       KVM: arm64: Mask response to FFA_FEATURE call
>       KVM: arm64: Bump the supported version of FF-A to 1.2
>
> Sascha Bischoff (4):
>       KVM: arm64: Enable nested for GICv5 host with FEAT_GCIE_LEGACY
>       arm64: cpucaps: Add GICv5 Legacy vCPU interface (GCIE_LEGACY) capab=
ility
>       KVM: arm64: Use ARM64_HAS_GICV5_LEGACY for GICv5 probing
>       irqchip/gic-v5: Drop has_gcie_v3_compat from gic_kvm_info
>
> Wei-Lin Chang (1):
>       KVM: arm64: ptdump: Don't test PTE_VALID alongside other attributes
>
> Yingchao Deng (1):
>       KVM: arm64: Return early from trace helpers when KVM isn't availabl=
e
>
>  arch/arm64/include/asm/kvm_asm.h                   |   2 +
>  arch/arm64/include/asm/kvm_emulate.h               |  34 +-
>  arch/arm64/include/asm/kvm_host.h                  |   5 +-
>  arch/arm64/include/asm/kvm_nested.h                |  27 +-
>  arch/arm64/include/asm/kvm_pkvm.h                  |   1 +
>  arch/arm64/include/asm/traps.h                     |   1 +
>  arch/arm64/include/asm/vncr_mapping.h              |   2 +
>  arch/arm64/kernel/cpufeature.c                     |  15 +
>  arch/arm64/kernel/image-vars.h                     |   3 +
>  arch/arm64/kernel/traps.c                          |  15 +-
>  arch/arm64/kvm/arm.c                               |  19 +-
>  arch/arm64/kvm/at.c                                | 376 +++++++++++++++=
------
>  arch/arm64/kvm/config.c                            | 358 +++++++++++++--=
-----
>  arch/arm64/kvm/debug.c                             |  25 +-
>  arch/arm64/kvm/emulate-nested.c                    |   1 +
>  arch/arm64/kvm/handle_exit.c                       |   3 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |   4 +-
>  arch/arm64/kvm/hyp/include/nvhe/trap_handler.h     |   3 +-
>  arch/arm64/kvm/hyp/nvhe/Makefile                   |   1 +
>  arch/arm64/kvm/hyp/nvhe/ffa.c                      | 217 ++++++++----
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  14 +
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   9 +-
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                     | 177 +++++++---
>  arch/arm64/kvm/hyp/nvhe/setup.c                    |  12 +-
>  arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  25 +-
>  arch/arm64/kvm/hyp/vhe/switch.c                    |   7 +
>  arch/arm64/kvm/inject_fault.c                      |  27 +-
>  arch/arm64/kvm/mmu.c                               |  16 +-
>  arch/arm64/kvm/nested.c                            |  80 ++++-
>  arch/arm64/kvm/pkvm.c                              |  76 +++--
>  arch/arm64/kvm/ptdump.c                            |  20 +-
>  arch/arm64/kvm/sys_regs.c                          |  55 ++-
>  arch/arm64/kvm/vgic/vgic-init.c                    |  14 +-
>  arch/arm64/kvm/vgic/vgic-v3.c                      |   8 +
>  arch/arm64/kvm/vgic/vgic-v5.c                      |   2 +-
>  arch/arm64/tools/cpucaps                           |   1 +
>  arch/x86/kvm/vmx/vmx.c                             |   7 +
>  drivers/irqchip/irq-gic-v5.c                       |   7 -
>  include/kvm/arm_vgic.h                             |   2 +-
>  include/linux/arm_ffa.h                            |   1 +
>  include/linux/irqchip/arm-vgic-info.h              |   2 -
>  include/linux/kvm_host.h                           |  11 +-
>  tools/testing/selftests/kvm/Makefile.kvm           |   1 +
>  tools/testing/selftests/kvm/arm64/arch_timer.c     |  13 +-
>  .../selftests/kvm/arm64/arch_timer_edge_cases.c    |  13 +-
>  .../testing/selftests/kvm/arm64/external_aborts.c  |  42 +++
>  tools/testing/selftests/kvm/arm64/hello_el2.c      |  71 ++++
>  tools/testing/selftests/kvm/arm64/hypercalls.c     |   2 +-
>  tools/testing/selftests/kvm/arm64/kvm-uuid.c       |   2 +-
>  tools/testing/selftests/kvm/arm64/no-vgic-v3.c     |   2 +
>  tools/testing/selftests/kvm/arm64/psci_test.c      |  13 +-
>  tools/testing/selftests/kvm/arm64/set_id_regs.c    |  44 +--
>  tools/testing/selftests/kvm/arm64/smccc_filter.c   |  17 +-
>  tools/testing/selftests/kvm/arm64/vgic_init.c      |   2 +
>  tools/testing/selftests/kvm/arm64/vgic_irq.c       |   4 +-
>  .../testing/selftests/kvm/arm64/vgic_lpi_stress.c  |   8 +-
>  .../selftests/kvm/arm64/vpmu_counter_access.c      |  75 ++--
>  tools/testing/selftests/kvm/dirty_log_perf_test.c  |  35 --
>  tools/testing/selftests/kvm/dirty_log_test.c       |   1 +
>  tools/testing/selftests/kvm/get-reg-list.c         |   9 +-
>  .../selftests/kvm/include/arm64/arch_timer.h       |  24 ++
>  .../selftests/kvm/include/arm64/kvm_util_arch.h    |   5 +-
>  .../selftests/kvm/include/arm64/processor.h        |  74 ++++
>  tools/testing/selftests/kvm/include/arm64/vgic.h   |   3 +
>  tools/testing/selftests/kvm/include/kvm_util.h     |   7 +-
>  tools/testing/selftests/kvm/lib/arm64/processor.c  | 104 +++++-
>  tools/testing/selftests/kvm/lib/arm64/vgic.c       |  64 ++--
>  tools/testing/selftests/kvm/lib/kvm_util.c         |  15 +-
>  tools/testing/selftests/kvm/lib/x86/processor.c    |   2 +-
>  tools/testing/selftests/kvm/s390/cmma_test.c       |   2 +-
>  tools/testing/selftests/kvm/steal_time.c           |   2 +-
>  virt/kvm/kvm_main.c                                |  43 ++-
>  72 files changed, 1696 insertions(+), 688 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/arm64/hello_el2.c
>


