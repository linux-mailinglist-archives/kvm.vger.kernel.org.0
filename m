Return-Path: <kvm+bounces-49524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 367DCAD967B
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:36:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FA4518835E0
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0FD24E4AD;
	Fri, 13 Jun 2025 20:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kwaGcAFD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71E725BEEB
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846937; cv=none; b=s5ItESKzsh9ludsIZp4sLufZgA6TaUR4R6Dr7qj9u79+NGnj7xjmJaI6VLpg09ux6V72MAWpgiYUtNjIpndc4I6sdVV3Szt80qYoInLegc6i2C2vnd+1za2xhj8aJAGZwXN9C0CyoTNBYVUQhLOQCqQgbyxARFv9TD3ooXJIc94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846937; c=relaxed/simple;
	bh=TCA/bkZV1eOXGd9TQy3i5G9neadJfD5XdVh30uDYjMM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kdFFXS33azCOtM0KEF+GCPvV3RvDLmO9lgIpUfHHRGDtPh3g218w51+ODOP9sgBTbfsRyybj+IKxxyqCFfSmMgJS2NrODegwUm9PNiu7sE5vdefbjZLYSDbA62Zj2sfldUNkFeRxKD5YS5wOBTgtqBEmEFhijdEgqDIrNsWb6dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kwaGcAFD; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74847a38e5eso1645004b3a.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749846935; x=1750451735; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aD6EYmSk/zIl2SjxJRx3+64lAlSQfo57iDrafX9vuYg=;
        b=kwaGcAFD5R0DY+HeJ3H43pH0k/ABpUOd0HFjgaV9iH0K+/csSwKcTyhk8NVzfnaV2Z
         o0GXmTNxuaUySH5stT+nEknmoMCEk02gb079kYhzDrdav1ngvTTVz+qOeR54GJ9cj+i4
         pMmvy1Vsoa+C5vLPNBq5XGPakG2dMXuSNGItsGWbzj5uA19hy5o/tGK3ARLZ/xCF31Tz
         xJPSAjWE+cmJNk2E3TABuLcgNejsIvbS1ZnyZTYhSJ2yWuU1KbMvuoLFw8ZFK5ltYd9h
         9yTZ7GHeJa46dH8SicGIqvMToz4E/WaOExtKtW3emKx7s6NhS04c1qr0YvMbfOb1o5K1
         ogcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749846935; x=1750451735;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aD6EYmSk/zIl2SjxJRx3+64lAlSQfo57iDrafX9vuYg=;
        b=S+00c1lHUYpdvkSJBEjTfZZFBf4pug+k6Dgl3dh+AcijL7d8gmt8djq0E1E6i4+hCN
         N0qPv3JJQOXNVL0Hq9QVXsZ3uB3hBqRSS/HDl4nuck7eq2IQUKtz0YJ5U2tMMTeUCl37
         ifas8x04TC0zj0bFQB0gZ6HrpORw5whc1bxTHb2f4x8hzN2N1Z5tORFRBDUWfjEl84AJ
         VMkUkf/kiwz3QH3C1/4IXkhVRRHn3rsO9UbZZQ+Vc/ybrtIhuZGs8eHdpdhq14G817cx
         fu5efEnByN7Nx3dc57gIdh+XtYztuNHOxxPfblXav58SkRF/ViNIlzt12RnCyivFSw9c
         IKow==
X-Gm-Message-State: AOJu0YxbydhJjaccoX3/VNDGnhYle6v2NHag2ByATn5+sazInXPjTxHH
	XJPpnVuLuGrvs8NYNabORWaI9x6x0C6sy0gmwWA/rf/REpltD8MHY1ed4duB70KbBt4BeTDa39t
	isnn1eA==
X-Google-Smtp-Source: AGHT+IFQyKC+fuYoxxZ60HlL1zbUz9ZwG4ryuK7MxSum1tmaUoFCTmYa27wuTrzB35IdSIo2hT+LP8d31ms=
X-Received: from pfmm18.prod.google.com ([2002:a05:6a00:2492:b0:748:4f7c:c605])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2ea6:b0:747:ee09:1fdf
 with SMTP id d2e1a72fcca58-7489cf6aaf9mr933541b3a.4.1749846934794; Fri, 13
 Jun 2025 13:35:34 -0700 (PDT)
Date: Fri, 13 Jun 2025 13:35:33 -0700
In-Reply-To: <20250611133330.1514028-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-5-tabba@google.com>
Message-ID: <aEyLlbyMmNEBCAVj@google.com>
Subject: Re: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2025, Fuad Tabba wrote:
> The bool has_private_mem is used to indicate whether guest_memfd is
> supported.

No?  This is at best weird, and at worst flat out wrong:

	if (kvm->arch.supports_gmem &&
	    fault->is_private !=3D kvm_mem_is_private(kvm, fault->gfn))
		return false;

ditto for this code:

	if (kvm_arch_supports_gmem(vcpu->kvm) &&
	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))i
		error_code |=3D PFERR_PRIVATE_ACCESS;

and for the memory_attributes code.  E.g. IIRC, with guest_memfd() mmap sup=
port,
private vs. shared will become a property of the guest_memfd inode, i.e. th=
is will
become wrong:

static u64 kvm_supported_mem_attributes(struct kvm *kvm)
{
	if (!kvm || kvm_arch_supports_gmem(kvm))
		return KVM_MEMORY_ATTRIBUTE_PRIVATE;

	return 0;
}

Instead of renaming kvm_arch_has_private_mem() =3D> kvm_arch_supports_gmem(=
), *add*
kvm_arch_supports_gmem() and then kill off kvm_arch_has_private_mem() once =
non-x86
usage is gone (i.e. query kvm->arch.has_private_mem directly).

And then rather than rename has_private_mem, either add supports_gmem or do=
 what
you did for kvm_arch_supports_gmem_shared_mem() and explicitly check the VM=
 type.

> Rename it to supports_gmem to make its meaning clearer and to decouple me=
mory
> being private from guest_memfd.
>=20
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  arch/x86/kvm/mmu/mmu.c          | 2 +-
>  arch/x86/kvm/svm/svm.c          | 4 ++--
>  arch/x86/kvm/x86.c              | 3 +--
>  4 files changed, 6 insertions(+), 7 deletions(-)

This missed the usage in TDX (it's not a staleness problem, because this se=
ries
was based on 6.16-rc1, which has the relevant code).

arch/x86/kvm/vmx/tdx.c: In function =E2=80=98tdx_vm_init=E2=80=99:
arch/x86/kvm/vmx/tdx.c:627:18: error: =E2=80=98struct kvm_arch=E2=80=99 has=
 no member named =E2=80=98has_private_mem=E2=80=99
  627 |         kvm->arch.has_private_mem =3D true;
      |                  ^
make[5]: *** [scripts/Makefile.build:287: arch/x86/kvm/vmx/tdx.o] Error 1

