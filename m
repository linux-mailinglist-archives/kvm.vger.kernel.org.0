Return-Path: <kvm+bounces-64629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D607C88C61
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 140483B7F03
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8BE31E0EF;
	Wed, 26 Nov 2025 08:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LMS6vo0v";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PHjkUBji"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B2631CA54
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 08:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764147136; cv=none; b=gghIIHE90hvDbNvwbvXsGPhjuCwketLnkGeDTzFXh3jJfIft/EMQvGtnHPvAGJFx7Mt/L5zBAM+RlF1Kp6CoMJlwXIrwbFsD60EAZ494nVuPvupERlgpsPeXIsovIBiVPXQe7F8rO5S7+NvEMp6gcJzLS7mnVgJJq7lQEXUkYjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764147136; c=relaxed/simple;
	bh=+4mJTbIpcsjlI4fVYTZgbf/cGRMoiBvPvo8dfrQNyY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QC74V9ec7Ut6eqUxudmKxK9fBd5/kHE3UUiVI6gXJ8WWf0W2H3ZkBX48GXP59t/0ta9yBVnMFIR0fDg/hplADq9MNkezrz6LV/FChOkUYFE83d8VGbE1btVUoft/2IvifgkLgn/i6Qq+VIljXvoHf908DD5F1dEoKTM/5qa9eH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LMS6vo0v; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PHjkUBji; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764147133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/XweevMyZ/FZh1UTL4StmJpSLmRzyhgm8NOhokJOi2o=;
	b=LMS6vo0vlSRptTk/gt5tPc5p8pq6AD1mWNPSWT4E7OphDA+azk/dPaxhltAwH4EHIy+PUm
	5PtDqYRLtlKnksnQjhv8U3RAPNhj39elEATpNFpcjaO1oVj99t2CGUArYSPm7IW08eSiLz
	HVxEh49EaIPXdvX9+7Ckg7KR2dfNozQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-t_HwRm_COdWmkTKugnmEJA-1; Wed, 26 Nov 2025 03:52:01 -0500
X-MC-Unique: t_HwRm_COdWmkTKugnmEJA-1
X-Mimecast-MFC-AGG-ID: t_HwRm_COdWmkTKugnmEJA_1764147120
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so38989915e9.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 00:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764147119; x=1764751919; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XweevMyZ/FZh1UTL4StmJpSLmRzyhgm8NOhokJOi2o=;
        b=PHjkUBjig7GKrU0Vstuq6HCQ/qKVcaibXvcOmcmTG2BaEzSOEY2XPcOUu6Nu2DnpKA
         Gv+PCy/RU5Vic0dFXpUOf9N5pyqbDaD4BvRFlWeOLjwTs1OTNuAuVq39xPGTnZizjFOE
         9BxL8LlCSxj/b/slRH1De+J2ALuOqsQAUW0osK/cWxlQX1CxywLOS3BGr+fuB63uxwyT
         kVtb2N5vfHSyX7PSrezZfoNN/HwSiNVdIy7AOsfR6mMq7iSJJlEkiOmBV6o1g3pPNhw4
         mzE8/dwLQOZKEWpJLIp+MahMItysqxJ8zwppa8F0h4ib8TXyXN1BML39HPOqNj91Chmt
         egCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764147119; x=1764751919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/XweevMyZ/FZh1UTL4StmJpSLmRzyhgm8NOhokJOi2o=;
        b=u5B1rq9AOKvyuYaQNv2ZyHEEJFh7oNxj7PqUhjDNDNxCyZ2Uz8orC5iNdez7gAxmVm
         ieNkd8oqokaBIsIHkk3zKfOlM0rdT9DDihXcvjRXIr+ak16M+1q7rNwD1S6a772vums2
         FojX60Sz6qHKovg3nkeqqv3y/7nduk45ioznuEHeCbL5g4T72vgzjhQVwmwL+wncOpyr
         YNu6EANvBKySZtVN6xurpDythbh2hIVE7ex4z+QPZKlryBa7aCW6DJ0+h+bYur6Qkqy5
         G40LUsq0uauHL9rToduGoXnhkVar48vCBTVdYMq1EjY16cZb0YwXID/XCZWc8J+u5xJD
         /Pcg==
X-Gm-Message-State: AOJu0Yz67ybb+t/r4BFJmyHjQqzbKIBNWdl42U7Ww+WXv+zor4jIWYxu
	E4W3sEwdYfqiYyTogZy/gN4F5cIeOJ9H2oKH0utAE/yzysc8XPREXh8KENkV8Knc38pXNKni8eK
	txF8WRhmopkPpCQW1vJTLojv7v2fv7/cYyazSxCJ1RsKuAyDM9TqhadfgCKHai9kBhP++eQcwM/
	/NkhxW+YR83VcNATKTMHuAM3+H6JWlWysCTjeq
X-Gm-Gg: ASbGncvcvsbCrPnNCT1AMWztcNELhL+XDxF0saZajL3EDMJH5/DZLpdwxWEVs0y/QQn
	2NLxAwBd1PqHLwNlRfuEq2V4NYXG0HjuP3V4PoSbtIe3jVYmWy0RZmEeFtVJONZWbUKen3Xx64D
	xXO45pevzWhLQfr3Vh1CL3Ahs8iAydw5UUDttso3iwKPX/mPknSAV1U7EdZ0j3pLwHuktIlSNla
	3OnMh0JnKEmFGNp1cRcv3/vfdjoem1/vdgzgVHs65J/K1m/R5/4BXOtX2Weh3Q7n5B6FRA=
X-Received: by 2002:a05:600c:4fcc:b0:471:9da:5252 with SMTP id 5b1f17b1804b1-477c01ebe2amr180373975e9.29.1764147119358;
        Wed, 26 Nov 2025 00:51:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGlkL2k4Nse/tJwSLeYPcYWkcsGytRvIIZBEJ0M/+QqV9ZfQcGhjR0b1yzszAro5qHYea+Fh4eJvKulRcvj0Iw=
X-Received: by 2002:a05:600c:4fcc:b0:471:9da:5252 with SMTP id
 5b1f17b1804b1-477c01ebe2amr180373835e9.29.1764147118981; Wed, 26 Nov 2025
 00:51:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126014455.788131-1-seanjc@google.com> <20251126014455.788131-8-seanjc@google.com>
In-Reply-To: <20251126014455.788131-8-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 26 Nov 2025 09:51:47 +0100
X-Gm-Features: AWmQ_bl26uyZrMHkNTaLyHfoNc23kGBi_E1KmkVtYLVxnXdNLqPaqbR9bwKp7yo
Message-ID: <CABgObfa-O0zma=ShnCdXJiLwm81OJq+oer0zCFJsmiPoufzo3g@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: TDX changes for 6.19
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2025 at 2:45=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please pull a large overhaul of lock-related TDX code (particularly in th=
e
> S-EPT and mirror SPTE code), along with a few fixes and cleanups.
>
> *Huge* kudos to Rick, Yan, Binbin, Ira, and Kai (hopefully I didn't forge=
t
> anyone) for their meticulous reviews, testing and debug, clever testcases=
,
> and help determining exactly what scenarios KVM needs to deal with in ter=
ms
> of avoiding lock contention in the TDX Module.
>
> P.S. There are few one-off TDX changes in the "vmx" pull request.  I don'=
t
>      expect to have a dedicated TDX pull request for most releases, I cre=
ated
>      one this time around because of the scope of the overhaul.
>
> The following changes since commit 6146a0f1dfae5d37442a9ddcba012add260bce=
b0:
>
>   Linux 6.18-rc4 (2025-11-02 11:28:02 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-tdx-6.19
>
> for you to fetch changes up to 398180f93cf3c7bb0ee3f512b139ad01843f3ddf:
>
>   KVM: TDX: Use struct_size to simplify tdx_get_capabilities() (2025-11-1=
3 08:30:07 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM TDX changes for 6.19:
>
>  - Overhaul the TDX code to address systemic races where KVM (acting on b=
ehalf
>    of userspace) could inadvertantly trigger lock contention in the TDX-M=
odule,
>    which KVM was either working around in weird, ugly ways, or was simply
>    oblivious to (as proven by Yan tripping several KVM_BUG_ON()s with cle=
ver
>    selftests).
>
>  - Fix a bug where KVM could corrupt a vCPU's cpu_list when freeing a vCP=
U if
>    creating said vCPU failed partway through.
>
>  - Fix a few sparse warnings (bad annotation, 0 !=3D NULL).
>
>  - Use struct_size() to simplify copying capabilities to userspace.
>
> ----------------------------------------------------------------
> Dave Hansen (2):
>       KVM: TDX: Remove __user annotation from kernel pointer
>       KVM: TDX: Fix sparse warnings from using 0 for NULL
>
> Rick Edgecombe (1):
>       KVM: TDX: Take MMU lock around tdh_vp_init()
>
> Sean Christopherson (27):
>       KVM: Make support for kvm_arch_vcpu_async_ioctl() mandatory
>       KVM: Rename kvm_arch_vcpu_async_ioctl() to kvm_arch_vcpu_unlocked_i=
octl()
>       KVM: TDX: Drop PROVE_MMU=3Dy sanity check on to-be-populated mappin=
gs
>       KVM: x86/mmu: Add dedicated API to map guest_memfd pfn into TDP MMU
>       KVM: x86/mmu: WARN if KVM attempts to map into an invalid TDP MMU r=
oot
>       Revert "KVM: x86/tdp_mmu: Add a helper function to walk down the TD=
P MMU"
>       KVM: x86/mmu: Rename kvm_tdp_map_page() to kvm_tdp_page_prefault()
>       KVM: TDX: Return -EIO, not -EINVAL, on a KVM_BUG_ON() condition
>       KVM: TDX: Fold tdx_sept_drop_private_spte() into tdx_sept_remove_pr=
ivate_spte()
>       KVM: x86/mmu: Drop the return code from kvm_x86_ops.remove_external=
_spte()
>       KVM: TDX: WARN if mirror SPTE doesn't have full RWX when creating S=
-EPT mapping
>       KVM: TDX: Avoid a double-KVM_BUG_ON() in tdx_sept_zap_private_spte(=
)
>       KVM: TDX: Use atomic64_dec_return() instead of a poor equivalent
>       KVM: TDX: Fold tdx_mem_page_record_premap_cnt() into its sole calle=
r
>       KVM: TDX: ADD pages to the TD image while populating mirror EPT ent=
ries
>       KVM: TDX: Fold tdx_sept_zap_private_spte() into tdx_sept_remove_pri=
vate_spte()
>       KVM: TDX: Combine KVM_BUG_ON + pr_tdx_error() into TDX_BUG_ON()
>       KVM: TDX: Derive error argument names from the local variable names
>       KVM: TDX: Assert that mmu_lock is held for write when removing S-EP=
T entries
>       KVM: TDX: Add macro to retry SEAMCALLs when forcing vCPUs out of gu=
est
>       KVM: TDX: Add tdx_get_cmd() helper to get and validate sub-ioctl co=
mmand
>       KVM: TDX: Convert INIT_MEM_REGION and INIT_VCPU to "unlocked" vCPU =
ioctl
>       KVM: TDX: Use guard() to acquire kvm->lock in tdx_vm_ioctl()
>       KVM: TDX: Don't copy "cmd" back to userspace for KVM_TDX_CAPABILITI=
ES
>       KVM: TDX: Guard VM state transitions with "all" the locks
>       KVM: TDX: Bug the VM if extending the initial measurement fails
>       KVM: TDX: Use struct_size to simplify tdx_get_capabilities()
>
> Thorsten Blum (1):
>       KVM: TDX: Check size of user's kvm_tdx_capabilities array before al=
locating
>
> Yan Zhao (2):
>       KVM: TDX: Drop superfluous page pinning in S-EPT management
>       KVM: TDX: Fix list_add corruption during vcpu_load()
>
>  arch/arm64/kvm/arm.c               |   6 +
>  arch/loongarch/kvm/Kconfig         |   1 -
>  arch/loongarch/kvm/vcpu.c          |   4 +-
>  arch/mips/kvm/Kconfig              |   1 -
>  arch/mips/kvm/mips.c               |   4 +-
>  arch/powerpc/kvm/Kconfig           |   1 -
>  arch/powerpc/kvm/powerpc.c         |   4 +-
>  arch/riscv/kvm/Kconfig             |   1 -
>  arch/riscv/kvm/vcpu.c              |   4 +-
>  arch/s390/kvm/Kconfig              |   1 -
>  arch/s390/kvm/kvm-s390.c           |   4 +-
>  arch/x86/include/asm/kvm-x86-ops.h |   1 +
>  arch/x86/include/asm/kvm_host.h    |   7 +-
>  arch/x86/kvm/mmu.h                 |   3 +-
>  arch/x86/kvm/mmu/mmu.c             |  87 ++++-
>  arch/x86/kvm/mmu/tdp_mmu.c         |  50 +--
>  arch/x86/kvm/vmx/main.c            |   9 +
>  arch/x86/kvm/vmx/tdx.c             | 712 ++++++++++++++++++-------------=
------
>  arch/x86/kvm/vmx/tdx.h             |   8 +-
>  arch/x86/kvm/vmx/x86_ops.h         |   1 +
>  arch/x86/kvm/x86.c                 |  13 +
>  include/linux/kvm_host.h           |  14 +-
>  virt/kvm/Kconfig                   |   3 -
>  virt/kvm/kvm_main.c                |   6 +-
>  24 files changed, 496 insertions(+), 449 deletions(-)
>


