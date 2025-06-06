Return-Path: <kvm+bounces-48631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D39C9ACFD86
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 09:32:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 312D21898EF2
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 07:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97248283FE4;
	Fri,  6 Jun 2025 07:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ENZ3u1KR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0254117E4
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 07:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749195150; cv=none; b=uI5zyDlRbnRAsS976F7tKSfk4kA0C1tA2XVv2TCuCgT4m0J/qNxq1qdi7dRp2MOk2hrkAKcf8TFg6cOIRx/k1jq58SBp/85hBDuVuoAZEORJWlFpSmCwl5/B3GUtnVbLgdNLSHG98NyypTrNtOkAB87cUcYfr0N16RtpTN34Qr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749195150; c=relaxed/simple;
	bh=OU19RnKagnqkf8XnYXLJNZp/nY3+adAcR/V1vK/aJwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nMmgRDp2SKnNIz7iu7mG9FKJTCorg3JBaBJ/wAY9m4mO/lgWlIwO5yzdNNM6e/Qq6YJ2YzT7MqXpYaWlyRZQrk5bDui/Gkmi+8rWntNnBGTTmV46XRtIEDfeGS16vz8YS58AgvKxmv5bkkVat4rgAbxMjPAnRD5ICIomyP9G9pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ENZ3u1KR; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-47e9fea29easo250661cf.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 00:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749195148; x=1749799948; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7kvMY5ZW2Vp5tdjNn8It/0HBAvvjd3PqQU3fhP/KrU=;
        b=ENZ3u1KRCEr+DctmNBqUUYrmC8Rnu7mtyKtmPb+O9cU1AEPW0RCUVyhPMXUByR7NI8
         TWd7+bGW+Fh9uJFFrrfQ/0H5kwdSfUTHbM0FIsc6AislLBONfIilwSCTIlMNZ/LYeNbw
         +Ux67NoIAmi/JnUF1ZhTMVxhjGqAbknPmQZpog8/y/tOdB8b9xmsbeft9ij6ad8vBn5E
         Pd0PZtpse3MMfUaCKTJ4kx9KBuedGit8ytejhb44KGpbE7BAFIAIYXe2fcvlaAzqdtDB
         Kt0O8Ms+HcdxCGUePM++g+2V0cijyFrEqcmLhwnuDeDh2urbztSnR6WM47bhyTR3I0VH
         bt3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749195148; x=1749799948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7kvMY5ZW2Vp5tdjNn8It/0HBAvvjd3PqQU3fhP/KrU=;
        b=kkU5vMPr70zbh75nkDyC32khAkNAIqEMYPfaOz1n1KpJuzhzUu8bHv1CbQq+1X/Fkr
         VyX7hhQIP3n+Tfya8dr1hTvzlPzdh8uQGv1HB1iZU6bDLAwSNeDRb/WK8oO9EzqiEby2
         iNzWFpq6Hd031n8zrCmaWIiKX8A5KX+umpI7mQqFCVAjoHToScoNXYupcP3DOivpqVI9
         8DmhnsZIetgTpwRwG8QQoXeGub3KvZroyPdaKmaaU1oSjcf6hUyyaNF0URYd8d7kIcca
         hZASAk/s0XqBrVT9vIBau5GbRhw0+J6UBRcqFo6258gnuyYwTjVM+cpMsWhvvD442IpA
         SjcQ==
X-Gm-Message-State: AOJu0YyZv11GfZRVKGFkLs2roiE8XUS5jvZQbW1issCDuVUwXpAQMugW
	SWnXW1b+oGNZkx+DhU7cZuFXyhwC/5uYm2H8D8QupGRccsVjXMhgTPgS/+Og6ULzX8zAof/9GlS
	DeZO5IjTEDeOGLTru7sx4/+8qBgPac856vip0g2xT
X-Gm-Gg: ASbGncvL6DgoW7tc+SsVKMK9Q72KtjSzFSvLTMH8B2OwczSVzJncYI5ct/YcyTsMsSq
	CefjOekyTE/+iIqFK2UnwqceR2fHuX+741RcPDdrBkCMMz2lqFrFXgX/b8od5+ywaDUDmk7DgkX
	SES54x4tigkJoySn8SCkITpu2vz9MTTUAqHb2JrM4VujM=
X-Google-Smtp-Source: AGHT+IERI6/rZZc+T/Y/BCqimMsrHrMBugbnphXsLYAS4v8oVORX4EwdR5wAo6IhPMIeThscJU2dXoYklEdFCyQufTc=
X-Received: by 2002:a05:622a:2517:b0:480:dde:aa4c with SMTP id
 d75a77b69052e-4a5baa657e2mr2990431cf.4.1749195147273; Fri, 06 Jun 2025
 00:32:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-15-tabba@google.com>
 <CADrL8HVtsJugNRgzgyiOwpOtSAi4iz3LNcjt8kDinUp99jWyYw@mail.gmail.com>
In-Reply-To: <CADrL8HVtsJugNRgzgyiOwpOtSAi4iz3LNcjt8kDinUp99jWyYw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Jun 2025 08:31:50 +0100
X-Gm-Features: AX0GCFt0ub1lyERvNyPbCD_BOwFtXCNX4pHBzmnsUAgp6hMKn_u9cHKW_CPEy3g
Message-ID: <CA+EHjTx-RKrn5Bwi9daTx-VAHLLxPpjo+wYMhi9MysWtvsM97w@mail.gmail.com>
Subject: Re: [PATCH v11 14/18] KVM: arm64: Handle guest_memfd-backed guest
 page faults
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi James,

On Thu, 5 Jun 2025 at 18:21, James Houghton <jthoughton@google.com> wrote:
>
> On Thu, Jun 5, 2025 at 8:38=E2=80=AFAM Fuad Tabba <tabba@google.com> wrot=
e:
> >
> > Add arm64 support for handling guest page faults on guest_memfd backed
> > memslots. Until guest_memfd supports huge pages, the fault granule is
> > restricted to PAGE_SIZE.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
>
> Hi Fuad, sorry for not getting back to you on v10. I like this patch
> much better than the v9 version, thank you! Some small notes below.
>
> > ---
> >  arch/arm64/kvm/mmu.c | 93 ++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 90 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index ce80be116a30..f14925fe6144 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1508,6 +1508,89 @@ static void adjust_nested_fault_perms(struct kvm=
_s2_trans *nested,
> >         *prot |=3D kvm_encode_nested_level(nested);
> >  }
> >
> > +#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT=
 | KVM_PGTABLE_WALK_SHARED)
> > +
> > +static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > +                     struct kvm_s2_trans *nested,
> > +                     struct kvm_memory_slot *memslot, bool is_perm)
> > +{
> > +       bool logging, write_fault, exec_fault, writable;
> > +       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_MEMABORT=
_FLAGS;
> > +       enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
> > +       struct kvm_pgtable *pgt =3D vcpu->arch.hw_mmu->pgt;
> > +       struct page *page;
> > +       struct kvm *kvm =3D vcpu->kvm;
> > +       void *memcache;
> > +       kvm_pfn_t pfn;
> > +       gfn_t gfn;
> > +       int ret;
> > +
> > +       ret =3D prepare_mmu_memcache(vcpu, !is_perm, &memcache);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (nested)
> > +               gfn =3D kvm_s2_trans_output(nested) >> PAGE_SHIFT;
> > +       else
> > +               gfn =3D fault_ipa >> PAGE_SHIFT;
> > +
> > +       logging =3D memslot_is_logging(memslot);
>
> AFAICT, `logging` will always be `false` for now, so we can simplify
> this function quite a bit. And IMHO, it *should* be simplified, as it
> cannot be tested.

Ack.

> > +       write_fault =3D kvm_is_write_fault(vcpu);
> > +       exec_fault =3D kvm_vcpu_trap_is_exec_fault(vcpu);
> > +
> > +       if (write_fault && exec_fault) {
> > +               kvm_err("Simultaneous write and execution fault\n");
> > +               return -EFAULT;
> > +       }
> > +
> > +       if (is_perm && !write_fault && !exec_fault) {
> > +               kvm_err("Unexpected L2 read permission error\n");
> > +               return -EFAULT;
> > +       }
>
> I think, ideally, these above checks should be put into a separate
> function and shared with user_mem_abort(). (The VM_BUG_ON(write_fault
> && exec_fault) that user_mem_abort() does seems fine to me, I don't see a
> real need to change it to -EFAULT.)

I would like to do that, however, I didn't want to change
user_mem_abort(), and regarding the VM_BUG_ON, see David's feedback to
V10:

https://lore.kernel.org/all/ed1928ce-fc6f-4aaa-9f54-126a8af12240@redhat.com=
/



> > +
> > +       ret =3D kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
> > +       if (ret) {
> > +               kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZ=
E,
> > +                                             write_fault, exec_fault, =
false);
> > +               return ret;
> > +       }
> > +
> > +       writable =3D !(memslot->flags & KVM_MEM_READONLY) &&
> > +                  (!logging || write_fault);
> > +
> > +       if (nested)
> > +               adjust_nested_fault_perms(nested, &prot, &writable);
> > +
> > +       if (writable)
> > +               prot |=3D KVM_PGTABLE_PROT_W;
> > +
> > +       if (exec_fault ||
> > +           (cpus_have_final_cap(ARM64_HAS_CACHE_DIC) &&
> > +            (!nested || kvm_s2_trans_executable(nested))))
> > +               prot |=3D KVM_PGTABLE_PROT_X;
> > +
> > +       kvm_fault_lock(kvm);
> > +       if (is_perm) {
> > +               /*
> > +                * Drop the SW bits in favour of those stored in the
> > +                * PTE, which will be preserved.
> > +                */
> > +               prot &=3D ~KVM_NV_GUEST_MAP_SZ;
> > +               ret =3D KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt,=
 fault_ipa, prot, flags);
>
> I think you should drop this `is_perm` path, as it is an optimization
> for dirty logging, which we don't currently do. :)
>
> When we want to add dirty logging support, we probably ought to move
> this mapping code (the lines kvm_fault_lock() and kvm_fault_unlock())
> into its own function and share it with user_mem_abort().

Ack.

> > +       } else {
> > +               ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_i=
pa, PAGE_SIZE,
> > +                                            __pfn_to_phys(pfn), prot,
> > +                                            memcache, flags);
> > +       }
> > +       kvm_release_faultin_page(kvm, page, !!ret, writable);
> > +       kvm_fault_unlock(kvm);
> > +
> > +       if (writable && !ret)
> > +               mark_page_dirty_in_slot(kvm, memslot, gfn);
> > +
> > +       return ret !=3D -EAGAIN ? ret : 0;
> > +}
> > +
> >  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa=
,
> >                           struct kvm_s2_trans *nested,
> >                           struct kvm_memory_slot *memslot, unsigned lon=
g hva,
> > @@ -1532,7 +1615,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, =
phys_addr_t fault_ipa,
> >         enum kvm_pgtable_prot prot =3D KVM_PGTABLE_PROT_R;
> >         struct kvm_pgtable *pgt;
> >         struct page *page;
> > -       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_HANDLE_F=
AULT | KVM_PGTABLE_WALK_SHARED;
> > +       enum kvm_pgtable_walk_flags flags =3D KVM_PGTABLE_WALK_MEMABORT=
_FLAGS;
> >
> >         if (fault_is_perm)
> >                 fault_granule =3D kvm_vcpu_trap_get_perm_fault_granule(=
vcpu);
> > @@ -1959,8 +2042,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu=
)
> >                 goto out_unlock;
> >         }
> >
> > -       ret =3D user_mem_abort(vcpu, fault_ipa, nested, memslot, hva,
> > -                            esr_fsc_is_permission_fault(esr));
> > +       if (kvm_slot_has_gmem(memslot))
> > +               ret =3D gmem_abort(vcpu, fault_ipa, nested, memslot,
> > +                                esr_fsc_is_permission_fault(esr));
> > +       else
> > +               ret =3D user_mem_abort(vcpu, fault_ipa, nested, memslot=
, hva,
> > +                                    esr_fsc_is_permission_fault(esr));
>
> I like this split! Thank you!

Thank you for your reviews!

Cheers,
/fuad

>
> >         if (ret =3D=3D 0)
> >                 ret =3D 1;
> >  out:
> > --
> > 2.49.0.1266.g31b7d2e469-goog
> >

