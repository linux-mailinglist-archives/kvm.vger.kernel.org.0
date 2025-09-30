Return-Path: <kvm+bounces-59210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 97350BAE3B6
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B07A07AF81F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 17:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0F91EE02F;
	Tue, 30 Sep 2025 17:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJ6j+gAl"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5310830CB23
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 17:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759254096; cv=none; b=gG2wPh/CVYxKzy1dAzD1hf6hALrw06Fs1Det7Wyfs3ykUHuTO0/FkB6N5s0+1wZhtCk81b/Qh0eAyVHbp8nLkYdir8IcyHepBYPErnn7vJKI9uBxLTYzD48So2CF4pp6alBnRVQmPntnDoFNwWxmTXXt82gn3zmbiXGAfkpdeok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759254096; c=relaxed/simple;
	bh=q64cqrc+DL7CyKWrLWgqNsYA1vpEdUt77jZZdDO8Ftg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s9XjZTksMDWN/18W59jB2prLf3I5m7qp4tW8+DaPDNR9UiMXijWXQPzCpNj9Plm11O+NQohP1VXGRuugEMRrIznvh+NySlNklX8+7/zZyfB4+hX3zeeD6TByxjLuU4aEpXq+9o6cQN2fcrf+nL0KFi/yLhyLBz1yZD81zJtQZgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OJ6j+gAl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759254088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=45rirt6UgKivtF83lr1iNJMWHnfUnLbsHai5065xl0s=;
	b=OJ6j+gAljnzaiF/ZgK08qT8hbbf14xjnuR6NBi+IK4+v2EHn4oYFgS8n0RAj9bhMA4u93G
	ZGwPTDgbvP/L4I+ZTGwBvzpgLn+Pc0CCyQ3pN/Cu6/+Ni4efklG2kJGwHtxkY7T7mF8CZQ
	GctRj0jzxOtYO58V4toHFF/Y9tKxdhQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-DqCbD4ArPlWtse4UI6Oywg-1; Tue, 30 Sep 2025 13:41:27 -0400
X-MC-Unique: DqCbD4ArPlWtse4UI6Oywg-1
X-Mimecast-MFC-AGG-ID: DqCbD4ArPlWtse4UI6Oywg_1759254086
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-40fd1b17d2bso3062516f8f.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 10:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759254085; x=1759858885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45rirt6UgKivtF83lr1iNJMWHnfUnLbsHai5065xl0s=;
        b=pSLRNjqa8WL6IZlu6yp/EsmOUmKJZypnzxIDj9H0QWp6mvhjQupC3T3WH8bP5L9JI+
         3WRPKKsGhvdluxqVrzUqtmB5iNTH2W5cTmkE1IdFNpf+RuFRZoB2LWw+zlywMbyl11d5
         E4ipv6NR/xxKQTb7/aGlJNFhGUGfl/K99ZjVHUAjWjhgBIISLv8GIL7+Y0azAnn8wstf
         nEibtHgRDVxHRIdWs3h8ohO0rdXvyKUEplhn5Zuiq7sx2TAIrvcw+9HFEF9nMMx6jTZj
         2NIhYZFHeYBEzVLp/mjGQcXwLUAvBRPz4aELuhkSqeJs6+oBPwfwctB+j5kX96HuyAFE
         9KMQ==
X-Gm-Message-State: AOJu0YwNXZfVf1+8HUkzKuRCzMvwDKbwRSWvgDvoqAq9Wyd/RlLK7Oh+
	W+pnKjnha9o838BH5TzXWS3lhT3c4h4DUkZY63aOgljqytW6wjBEmnheP0GmFnufymrlK2MVah/
	vvbCLnWmGkuEjytLDJej7LkP0mHAiQW66Oq7J36tOWCtMD4iXHVH6TipB5uiYDi8OxxF6BOEUT2
	SzF7DXZCyc4qFHLY1cn0pLDTe1fBD5/WZvBmO6
X-Gm-Gg: ASbGncum/VIamfvGT+1pRXY6hXtzmybiqd/dsRO20AKgXJCANJnpARlw6omGy3OBkG3
	RpxMG/3qiPT8WkTJUOF+PrHYbDjnkvJoqUD73xKw6ufNbbbExRcKQuICJlbuRrbQWwT8pesmOMY
	jJbPGR+1e71PjsFLModkJV8HMzXRzLe1FOEJSF16d3RjrGX6bACejZrJeXdCNhi13NQu619yFYO
	vLQYGiVSIa0Ks2WoemCHi7VwGkUGXj1
X-Received: by 2002:a05:6000:220b:b0:3fd:2dee:4e3d with SMTP id ffacd0b85a97d-42557818464mr465485f8f.46.1759254085074;
        Tue, 30 Sep 2025 10:41:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4AVn1Ljy0/iRDhxbKeR1WGQmvI/li1TzRCOybb+Gb4L2/1fw4OqXyy8yQekPJ8Ey9rJXuM0TkZ3ZWGI4RuG4=
X-Received: by 2002:a05:6000:220b:b0:3fd:2dee:4e3d with SMTP id
 ffacd0b85a97d-42557818464mr465469f8f.46.1759254084690; Tue, 30 Sep 2025
 10:41:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250927060910.2933942-1-seanjc@google.com> <20250927060910.2933942-11-seanjc@google.com>
In-Reply-To: <20250927060910.2933942-11-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 30 Sep 2025 19:41:13 +0200
X-Gm-Features: AS18NWBECixmY7PRvjINuwNoJ86CKCLh_XttTJvYN7DZsSXRUD-y3wtEVwAKROE
Message-ID: <CABgObfYKWku7=i8b3FE=dRseQrsGbS6pPc_kC+S4Yxv90M1VTA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: Symbol export restrictions for 6.18
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 8:09=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Note!  If possible, and you're feeling generous, please merge this dead l=
ast
> and manually convert any new KVM exports to EXPORT_SYMBOL_FOR_KVM_INTERNA=
L so
> that there are no unwanted exports.
>
> Three new exports are coming in via other kvm-x86 pull requests; I've bee=
n
> "fixing" them as part of the merge into kvm-x86/next (see diff below), so=
 those
> at least have gotten coverage in -next.
>
> Note #2, this is based on the "misc" branch/pull, but includes a backmerg=
e of
> v6.17-rc3.  I posted the patches against kvm-x86/next to avoid an annoyin=
g
> conflict (which I can't even remember at this point), and then didn't rea=
lize
> I needed v6.17-rc3 to pick up the EXPORT_SYMBOL_GPL_FOR_MODULES =3D>
> EXPORT_SYMBOL_FOR_MODULES rename that snuck in until the 0-day bot yelled
> because the branch didn't compile (I only tested when merged on top of
> kvm/next, doh).

I've cherry picked instead of merging it, seems to be the simplest way
to clean up the backmerge.

Paolo

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e96080cba540..3d4ec1806d3e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -695,7 +695,7 @@ u64 kvm_get_user_return_msr(unsigned int slot)
>  {
>         return this_cpu_ptr(user_return_msrs)->values[slot].curr;
>  }
> -EXPORT_SYMBOL_GPL(kvm_get_user_return_msr);
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_get_user_return_msr);
>
>  static void drop_user_return_notifiers(void)
>  {
> @@ -1304,7 +1304,7 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index,=
 u64 xcr)
>                 vcpu->arch.cpuid_dynamic_bits_dirty =3D true;
>         return 0;
>  }
> -EXPORT_SYMBOL_GPL(__kvm_set_xcr);
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(__kvm_set_xcr);
>
>  int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b99eb34174af..83a1b4dbbbd8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2661,7 +2661,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(str=
uct kvm_vcpu *vcpu, gfn_t gfn
>
>         return NULL;
>  }
> -EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_gfn_to_memslot);
>
>  bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>  {
>
> The following changes since commit 1b237f190eb3d36f52dffe07a40b5eb210280e=
00:
>
>   Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-exports-6.18
>
> for you to fetch changes up to aca2a0fa7796cf026a39a49ef9325755a9ead932:
>
>   KVM: x86: Export KVM-internal symbols for sub-modules only (2025-09-24 =
07:01:30 -0700)
>
> ----------------------------------------------------------------
> KVM symbol export restrictions for 6.18
>
> Use the newfangled EXPORT_SYMBOL_FOR_MODULES() along with some macro
> shenanigans to export KVM-internal symbols if and only if KVM has one or
> more sub-modules, and only for those sub-modules, e.g. x86's kvm-amd.ko
> and/or kvm-intel.ko, and PPC's many varieties of sub-modules.
>
> Define the macros in the kvm_types.h so that the core logic is visible ou=
tside
> of KVM, so that the logic can be reused in the future to further restrict
> kernel exports that exist purely for KVM (x86 in particular has a _lot_ o=
f
> exports that are used only by KVM).
>
> ----------------------------------------------------------------
> Sean Christopherson (6):
>       Merge 'v6.17-rc3' into 'exports' to EXPORT_SYMBOL_FOR_MODULES renam=
e
>       KVM: s390/vfio-ap: Use kvm_is_gpa_in_memslot() instead of open code=
d equivalent
>       KVM: Export KVM-internal symbols for sub-modules only
>       KVM: x86: Move kvm_intr_is_single_vcpu() to lapic.c
>       KVM: x86: Drop pointless exports of kvm_arch_xxx() hooks
>       KVM: x86: Export KVM-internal symbols for sub-modules only
>
>  arch/powerpc/include/asm/Kbuild      |   1 -
>  arch/powerpc/include/asm/kvm_types.h |  15 +++++++++
>  arch/s390/include/asm/kvm_host.h     |   2 ++
>  arch/s390/kvm/priv.c                 |   8 +++++
>  arch/x86/include/asm/kvm_host.h      |   3 --
>  arch/x86/include/asm/kvm_types.h     |  10 ++++++
>  arch/x86/kvm/cpuid.c                 |  10 +++---
>  arch/x86/kvm/hyperv.c                |   4 +--
>  arch/x86/kvm/irq.c                   |  34 ++------------------
>  arch/x86/kvm/kvm_onhyperv.c          |   6 ++--
>  arch/x86/kvm/lapic.c                 |  71 +++++++++++++++++++++++++++++=
-------------
>  arch/x86/kvm/lapic.h                 |   4 +--
>  arch/x86/kvm/mmu/mmu.c               |  36 ++++++++++-----------
>  arch/x86/kvm/mmu/spte.c              |  10 +++---
>  arch/x86/kvm/mmu/tdp_mmu.c           |   2 +-
>  arch/x86/kvm/pmu.c                   |  10 +++---
>  arch/x86/kvm/smm.c                   |   2 +-
>  arch/x86/kvm/x86.c                   | 219 +++++++++++++++++++++++++++++=
++++++++++++++++++++++++++++++++++-----------------------------------------=
------------------------
>  drivers/s390/crypto/vfio_ap_ops.c    |   2 +-
>  include/linux/kvm_types.h            |  25 ++++++++++-----
>  virt/kvm/eventfd.c                   |   2 +-
>  virt/kvm/guest_memfd.c               |   4 +--
>  virt/kvm/kvm_main.c                  | 126 +++++++++++++++++++++++++++++=
++++++++-------------------------------------
>  23 files changed, 323 insertions(+), 283 deletions(-)
>  create mode 100644 arch/powerpc/include/asm/kvm_types.h
>


