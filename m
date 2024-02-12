Return-Path: <kvm+bounces-8544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 445438510EA
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 11:32:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEC532814AA
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 10:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2EF38F9A;
	Mon, 12 Feb 2024 10:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e+TYG2mD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328D838DDD
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 10:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707733904; cv=none; b=fiae//Q+Qkonv+sEgIuP5wTz0eXG4odosJo8RYgAHsoQN7nm89A1AHFIpu23A50nz4dk62bGYjFSc6s81xhxBwMHR4+AX/M2a/HXNLGRktx39JEQrJb5iIfbn7GNdWH8c8aeHQEnixo//RqyIF3DYN9yir7ZrYwJN4beTOItofQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707733904; c=relaxed/simple;
	bh=czUfwp9Vd0O43dhgHlhoxm7n6b/o2RFsBWH5mKBRF/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jc2xO9R37Qyd282tgYeiL93T52L3E2hBqXarGOewG6fhCSR3hNa+dOALIlOM+0dJCODhmJcgGCOI66D7uRotFWBoaeyDDX3ji0nMQ2C3OsRWVZQYa/3t+pxx00BYyy1yg4ER3fGJQsjPQsrM+qRUCejZhbDOsZfxIOXUPrIQ4Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e+TYG2mD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707733902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1t318SRTxLpDaLWn2G/SymzKj/FNZHT6EAXxG8/aWeU=;
	b=e+TYG2mDEwBUoLFlXNiRku+LXsUet0pbNa+LnEcvRyN4xeGpZfn7Sgo7vilUQfq5LobWiq
	Uo0GnvGdxeR8p2BsuWPnpUUEImKsombBYpFhlFr1H+UYogtVT5CIEq3QRZ12EsYe4ugCAC
	q10uCGO9ImfEAS1lHDJ0MUBiJ2rY/kE=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-crLYnttlNQyA4GnDDZJD9Q-1; Mon, 12 Feb 2024 05:31:39 -0500
X-MC-Unique: crLYnttlNQyA4GnDDZJD9Q-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-46d27678bbeso907855137.1
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 02:31:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707733898; x=1708338698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1t318SRTxLpDaLWn2G/SymzKj/FNZHT6EAXxG8/aWeU=;
        b=DHCRTBBOeXgEZd2e5jCUUzsg3Sp5oDJg9DfFZinqbeIcDUbgLsdVYSNCiw6VTUlfAS
         K5BS1NQ/z5nnECSAuh6sGnXoAcKcgKcLbsu0dXkBgBIZ45vw33b5pp3Cr7W1PIDXjMca
         9ru92BGR7y4G+suSoTd1+Z1YOIVUxBEd2A9VWFGiwRjzY/WG1it3+LaBBLbFWu8iz2Uz
         EkuIcpy/9OdZv2ySl8rGviHjbj+uGj07mujwFkNuENOf+ysluqu61r+WP9DkK1Gl+dJH
         8McP2SOxjO8yQ/OBnUKxrcLBCS7+8d8uS2HBytXR2msmw2myqZNQI9XGCnAMfOnIUUWl
         GVPw==
X-Gm-Message-State: AOJu0YxHn0jK871+difixuV3t6lSBxdjUSZ+F7ENLs4jzDYZs0O2LBf2
	i09kgLMdlvN0PR2OGKNijMUnod5rNgxz2x1BaaV8GRJ29tyVwidJK8y+/vJZkv4XsjOtSXj50JL
	2j81xLcZo+RRkqALg9r2kpInSSbJGv+kByaAUkOpCR9pBWRlq9cS8Wrgrg2uSxekJwNx2vZ99qL
	Z/lR6xiS23Ux9PyKewhUKuVcm4
X-Received: by 2002:a05:6102:3161:b0:46d:240d:438c with SMTP id l1-20020a056102316100b0046d240d438cmr4076043vsm.27.1707733898461;
        Mon, 12 Feb 2024 02:31:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAYvRS4noCaEKl+zyb53gqyWRKi4M0jr6v0+jz+XbYaddB3PAXdhrXxq0wDIZfyRz3n9CnF4Xr88Nf35iyEnE=
X-Received: by 2002:a05:6102:3161:b0:46d:240d:438c with SMTP id
 l1-20020a056102316100b0046d240d438cmr4076001vsm.27.1707733898047; Mon, 12 Feb
 2024 02:31:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-10-michael.roth@amd.com>
In-Reply-To: <20231230172351.574091-10-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Feb 2024 11:31:26 +0100
Message-ID: <CABgObfanrHTL429Cr8tcMGqs-Ov+6LWeQbzghvjQiGu9tz0EUA@mail.gmail.com>
Subject: Re: [PATCH v11 09/35] KVM: x86: Determine shared/private faults based
 on vm_type
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, seanjc@google.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 30, 2023 at 6:24=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> For KVM_X86_SNP_VM, only the PFERR_GUEST_ENC_MASK flag is needed to
> determine with an #NPF is due to a private/shared access by the guest.
> Implement that handling here. Also add handling needed to deal with
> SNP guests which in some cases will make MMIO accesses with the
> encryption bit.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 12 ++++++++++--
>  arch/x86/kvm/mmu/mmu_internal.h | 20 +++++++++++++++++++-
>  2 files changed, 29 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d3fbfe0686a0..61213f6648a1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4331,6 +4331,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu =
*vcpu,
>  static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_faul=
t *fault)
>  {
>         struct kvm_memory_slot *slot =3D fault->slot;
> +       bool private_fault =3D fault->is_private;

I think it's nicer to just make the fault !is_private in
kvm_mmu_do_page_fault().

> +static bool kvm_mmu_fault_is_private(struct kvm *kvm, gpa_t gpa, u64 err=
)
> +{
> +       bool private_fault =3D false;
> +
> +       if (kvm_is_vm_type(kvm, KVM_X86_SNP_VM)) {
> +               private_fault =3D !!(err & PFERR_GUEST_ENC_MASK);
> +       } else if (kvm_is_vm_type(kvm, KVM_X86_SW_PROTECTED_VM)) {
> +               /*
> +                * This handling is for gmem self-tests and guests that t=
reat
> +                * userspace as the authority on whether a fault should b=
e
> +                * private or not.
> +                */
> +               private_fault =3D kvm_mem_is_private(kvm, gpa >> PAGE_SHI=
FT);
> +       }

Any reason to remove the is_private page fault that was there in
previous versions of the patch?  I don't really like having both TDX
and SVM-specific code in this function.

Paolo

> +       return private_fault;
> +}
> +
>  /*
>   * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_pag=
e_fault(),
>   * and of course kvm_mmu_do_page_fault().
> @@ -298,7 +316,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vc=
pu *vcpu, gpa_t cr2_or_gpa,
>                 .max_level =3D KVM_MAX_HUGEPAGE_LEVEL,
>                 .req_level =3D PG_LEVEL_4K,
>                 .goal_level =3D PG_LEVEL_4K,
> -               .is_private =3D kvm_mem_is_private(vcpu->kvm, cr2_or_gpa =
>> PAGE_SHIFT),
> +               .is_private =3D kvm_mmu_fault_is_private(vcpu->kvm, cr2_o=
r_gpa, err),
>         };
>         int r;
>
> --
> 2.25.1
>


