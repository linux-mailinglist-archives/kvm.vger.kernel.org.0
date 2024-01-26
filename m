Return-Path: <kvm+bounces-7138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68FA883D8CF
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 12:01:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D746B1F25518
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 11:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7519E17BA6;
	Fri, 26 Jan 2024 11:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cduZuv0M"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAD413AEC
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 11:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706266863; cv=none; b=BG/lV+ijdZbb4VFS/RfxnzOA6iu0bDu6yZQ6fQKYpw1OSBSIQeYJ9hehJ4smgxDVjPSCmf93EhoyM1CpJMqodcogJ6cmQg3RhCC9WQZBZLFA2OEO0AaPN12g5hKFtWfouof/s38IH4cZv9u07KgwLyDiYqguGS1TYQQPCslrpcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706266863; c=relaxed/simple;
	bh=2Kk/JhDn9ums2Gl2pmtY8M5lBtSFaCH5fDViOXSC1mo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QzZCg5CqheeRnlfWmJ4+wmAK5S+TNGr5M0NxdTE5mx4hb+NyUXA9NU7jyMIjvHt4SvcmHvblsyjqcE2IkaVpwlwIhOrHLdrJ9Q3SKf6W56m4EaW8AeZ/gwLOF7MUnM5BL9HC6NXzfOHosYY4F9HYvkIoznwskH3ylnc8TKqPXzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cduZuv0M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706266859;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vz4PWAkydzxt+A7z4COEEylDr902GbpCA3qhDTN+Qeg=;
	b=cduZuv0M4Psp1UTRkyPuFLufaaHbpUVp6kClk7L0pz/gGYWXDFEvBwYXTMqDgx4XYJrzL6
	oJtcRsSZrWX4C+U0RoKsUkpEId1sUnt70DbaNSAhLb7LaGKmTTtMVwQLyPnGTd9J4iarfL
	Y68eDSPDieorlPcNYSQjsIpOXZVERto=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-b7z9HgTmPBaVeBZMNobJ1Q-1; Fri, 26 Jan 2024 06:00:58 -0500
X-MC-Unique: b7z9HgTmPBaVeBZMNobJ1Q-1
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-7d2dfe84153so132602241.3
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 03:00:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706266857; x=1706871657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vz4PWAkydzxt+A7z4COEEylDr902GbpCA3qhDTN+Qeg=;
        b=IL1TFstypU40Hha0HK9UfRtJkDm9t/f2dLC+fIQkYvHQB6IVpTUt4zTRPle7kLikg4
         FCaZ31SMndGi1Bpe4w93pgMEX2JzuKYxXH+jQEn5mOlJrbR0zL7X78Rc2hGG9E2eVpl8
         oPJejT+exCRiKxqsVpcbYsn82ngnXdHBz5bCJjkaopqz5e/geFPISQmbUWi8GcTVWuXw
         Yxq3zbvaScY51HvMBrNz07C36SKJxj5FQNYEPKcT/Bygl+01TxUgeOUvi36CsuAECcsY
         8E3jJ/BcNI94I7obmc9fIw7lLpoc0fl41foGHRPY5fQ7g5vzVeXtWYq86fX24/DS+lcG
         OegQ==
X-Gm-Message-State: AOJu0YxCrthm+EvcQxbTernBT9NAA2HBWwmIIDJ9SiooC9SBclS6dK9Y
	3pjwNl0XbFMS2NW4REb9lgZTSDH2d/gkMnM+IVIK0Hs9cM3Bm2UChiF4kcNBAA0cZgUeWFt/C4j
	T3Y3uTUtaALJDOuG6+CHEmrIBZfm87GS3ko4utyOyp61oaibrUHyrujWbmVsL2Y5zdFiCmLGHRj
	4xXfObAH2NdBuam45nrYjQ6l9GYaS5XO3j
X-Received: by 2002:a67:f7d3:0:b0:46b:2177:3dd5 with SMTP id a19-20020a67f7d3000000b0046b21773dd5mr813798vsp.59.1706266857208;
        Fri, 26 Jan 2024 03:00:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGpXTYAbdzLiIsrnQlBUga5yJGtTPifrKZ94nSeg3N8tWU7X+J3z3U88iJcUhzqazoErnhnGdfkCOzGN9AK1kM=
X-Received: by 2002:a67:f7d3:0:b0:46b:2177:3dd5 with SMTP id
 a19-20020a67f7d3000000b0046b21773dd5mr813761vsp.59.1706266856821; Fri, 26 Jan
 2024 03:00:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126041126.1927228-1-michael.roth@amd.com> <20240126041126.1927228-22-michael.roth@amd.com>
In-Reply-To: <20240126041126.1927228-22-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Jan 2024 12:00:43 +0100
Message-ID: <CABgObfaqjBBt74ZX6LtP=sQgYsu4FRTuKsDZ1ZaFkA5vK1ddCQ@mail.gmail.com>
Subject: Re: [PATCH v2 21/25] KVM: SEV: Make AVIC backing, VMSA and VMCB
 memory allocation SNP safe
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, 
	seanjc@google.com, vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz, 
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	Brijesh Singh <brijesh.singh@amd.com>, Marc Orr <marcorr@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 26, 2024 at 5:45=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> Implement a workaround for an SNP erratum where the CPU will incorrectly
> signal an RMP violation #PF if a hugepage (2MB or 1GB) collides with the
> RMP entry of a VMCB, VMSA or AVIC backing page.
>
> When SEV-SNP is globally enabled, the CPU marks the VMCB, VMSA, and AVIC
> backing pages as "in-use" via a reserved bit in the corresponding RMP
> entry after a successful VMRUN. This is done for _all_ VMs, not just
> SNP-Active VMs.
>
> If the hypervisor accesses an in-use page through a writable
> translation, the CPU will throw an RMP violation #PF. On early SNP
> hardware, if an in-use page is 2MB-aligned and software accesses any
> part of the associated 2MB region with a hugepage, the CPU will
> incorrectly treat the entire 2MB region as in-use and signal a an RMP
> violation #PF.
>
> To avoid this, the recommendation is to not use a 2MB-aligned page for
> the VMCB, VMSA or AVIC pages. Add a generic allocator that will ensure
> that the page returned is not 2MB-aligned and is safe to be used when
> SEV-SNP is enabled. Also implement similar handling for the VMCB/VMSA
> pages of nested guests.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Co-developed-by: Marc Orr <marcorr@google.com>
> Signed-off-by: Marc Orr <marcorr@google.com>
> Reported-by: Alper Gun <alpergun@google.com> # for nested VMSA case
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> [mdr: squash in nested guest handling from Ashish, commit msg fixups]
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>


> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/lapic.c               |  5 ++++-
>  arch/x86/kvm/svm/nested.c          |  2 +-
>  arch/x86/kvm/svm/sev.c             | 32 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c             | 17 +++++++++++++---
>  arch/x86/kvm/svm/svm.h             |  1 +
>  7 files changed, 54 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kv=
m-x86-ops.h
> index 378ed944b849..ab24ce207988 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -138,6 +138,7 @@ KVM_X86_OP(complete_emulated_msr)
>  KVM_X86_OP(vcpu_deliver_sipi_vector)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
>  KVM_X86_OP_OPTIONAL(get_untagged_addr)
> +KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
>
>  #undef KVM_X86_OP
>  #undef KVM_X86_OP_OPTIONAL
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index b5b2d0fde579..5c12af29fd9b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1794,6 +1794,7 @@ struct kvm_x86_ops {
>         unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *=
vcpu);
>
>         gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsi=
gned int flags);
> +       void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
>  };
>
>  struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3242f3da2457..1edf93ee3395 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2815,7 +2815,10 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int ti=
mer_advance_ns)
>
>         vcpu->arch.apic =3D apic;
>
> -       apic->regs =3D (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> +       if (kvm_x86_ops.alloc_apic_backing_page)
> +               apic->regs =3D static_call(kvm_x86_alloc_apic_backing_pag=
e)(vcpu);
> +       else
> +               apic->regs =3D (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT=
);
>         if (!apic->regs) {
>                 printk(KERN_ERR "malloc apic regs error for vcpu %x\n",
>                        vcpu->vcpu_id);
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index dee62362a360..55b9a6d96bcf 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1181,7 +1181,7 @@ int svm_allocate_nested(struct vcpu_svm *svm)
>         if (svm->nested.initialized)
>                 return 0;
>
> -       vmcb02_page =3D alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +       vmcb02_page =3D snp_safe_alloc_page(&svm->vcpu);
>         if (!vmcb02_page)
>                 return -ENOMEM;
>         svm->nested.vmcb02.ptr =3D page_address(vmcb02_page);
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 564091f386f7..f99435b6648f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3163,3 +3163,35 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu =
*vcpu, u8 vector)
>
>         ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
>  }
> +
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> +{
> +       unsigned long pfn;
> +       struct page *p;
> +
> +       if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
> +               return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +
> +       /*
> +        * Allocate an SNP-safe page to workaround the SNP erratum where
> +        * the CPU will incorrectly signal an RMP violation #PF if a
> +        * hugepage (2MB or 1GB) collides with the RMP entry of a
> +        * 2MB-aligned VMCB, VMSA, or AVIC backing page.
> +        *
> +        * Allocate one extra page, choose a page which is not
> +        * 2MB-aligned, and free the other.
> +        */
> +       p =3D alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> +       if (!p)
> +               return NULL;
> +
> +       split_page(p, 1);
> +
> +       pfn =3D page_to_pfn(p);
> +       if (IS_ALIGNED(pfn, PTRS_PER_PMD))
> +               __free_page(p++);
> +       else
> +               __free_page(p + 1);
> +
> +       return p;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 61f2bdc9f4f8..272d5ed37ce7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -703,7 +703,7 @@ static int svm_cpu_init(int cpu)
>         int ret =3D -ENOMEM;
>
>         memset(sd, 0, sizeof(struct svm_cpu_data));
> -       sd->save_area =3D alloc_page(GFP_KERNEL | __GFP_ZERO);
> +       sd->save_area =3D snp_safe_alloc_page(NULL);
>         if (!sd->save_area)
>                 return ret;
>
> @@ -1421,7 +1421,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>         svm =3D to_svm(vcpu);
>
>         err =3D -ENOMEM;
> -       vmcb01_page =3D alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +       vmcb01_page =3D snp_safe_alloc_page(vcpu);
>         if (!vmcb01_page)
>                 goto out;
>
> @@ -1430,7 +1430,7 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
>                  * SEV-ES guests require a separate VMSA page used to con=
tain
>                  * the encrypted register state of the guest.
>                  */
> -               vmsa_page =3D alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO)=
;
> +               vmsa_page =3D snp_safe_alloc_page(vcpu);
>                 if (!vmsa_page)
>                         goto error_free_vmcb_page;
>
> @@ -4900,6 +4900,16 @@ static int svm_vm_init(struct kvm *kvm)
>         return 0;
>  }
>
> +static void *svm_alloc_apic_backing_page(struct kvm_vcpu *vcpu)
> +{
> +       struct page *page =3D snp_safe_alloc_page(vcpu);
> +
> +       if (!page)
> +               return NULL;
> +
> +       return page_address(page);
> +}
> +
>  static struct kvm_x86_ops svm_x86_ops __initdata =3D {
>         .name =3D KBUILD_MODNAME,
>
> @@ -5031,6 +5041,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>
>         .vcpu_deliver_sipi_vector =3D svm_vcpu_deliver_sipi_vector,
>         .vcpu_get_apicv_inhibit_reasons =3D avic_vcpu_get_apicv_inhibit_r=
easons,
> +       .alloc_apic_backing_page =3D svm_alloc_apic_backing_page,
>  };
>
>  /*
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 8ef95139cd24..7f1fbd874c45 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -694,6 +694,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
>  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>  void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
>  void sev_es_unmap_ghcb(struct vcpu_svm *svm);
> +struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
>
>  /* vmenter.S */
>
> --
> 2.25.1
>


