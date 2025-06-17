Return-Path: <kvm+bounces-49675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 27729ADC16F
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 07:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7BC87A9023
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 05:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897F0241662;
	Tue, 17 Jun 2025 05:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="TA9KJORP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9187A23B609
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 05:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750137120; cv=none; b=dU0Iaw92Gl9Fm8276gzZm5qhMBg87696NVRLM3bVqg5r0+ysfG4rqbl71KO8ZiA0WTNFlP439rbMk/IgZcA6Av9KLHG6GajpL3De/fX0IVFSRawNP7bMcoMOJG5eTXpqpQ2/X/1jqRgEh/iVGnWS1UDh/8VOV+/SPGhMuj2DEEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750137120; c=relaxed/simple;
	bh=ds1qWENB4/EfMuMzsEqk2+KyiHUWHV0G/Mw0w3x91BA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UlYn6ti8BVgPaBOk7hSB0eILBPJyTuVJ14TtSVsuPc7EralFTvhIgaHZWf50XPc/kOXXQd4wG/1h97WGPPORCaltvF/BALR9sU/KLI4ud/NlHOFtS6hEP0BxhsWaeHK5lasvUG4o5wPWiBJNLC2oW5sFWq0A5sy3Dg0E0fNbATU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=TA9KJORP; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-54998f865b8so4982545e87.3
        for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 22:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750137117; x=1750741917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJCxQUuDgSRC23cRyBpITmZ8zn0TiHdfZp3CAyimNtU=;
        b=TA9KJORPUIEXUvEtZk6MOxfQwWhNft45lev1EorGgJI3jnkVB9dDxgLKSDVS8MaZ19
         n4b2Bx3DI5vxp9L+MAjWmENq5FQMMgY9B8o5A5WD1VKzzMFp6qKPkw7AnYuCvDOjgxvq
         oc2Rzn7yd3c6rDr1/sQ0B3xUffT5DQKq0XSo7qSPwNqo65vdyWlm4p6O+azfo42yFxmH
         WGrr/EZkApXpd32Jr4elAql0HdYs9kzuhBZND6ogB0+CBLe/B6wHh3MLb5SI9vgBxh14
         CI/qum3MZScqLK/uHlSwPMZKePfkNJ8kCYyb3enzl7oQ3ItQcKlfl2gy9QptKnDKk65O
         En5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750137117; x=1750741917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJCxQUuDgSRC23cRyBpITmZ8zn0TiHdfZp3CAyimNtU=;
        b=LAhFF7XOSSoYcV/qbKBcTcE7crL+WEyVjLWcaL6sGUjMc9ub+Br62PG+SCoyHKRiGu
         55vW/cTUIqyAduUzWcuV9j7EXr6An5su+s1Yyn8ajl3oXtbnABiQi/ZYiElvfp0wjMle
         lPXGEerqE3fFyaQDpCgVSyVX17rqOvhQUEKowieMcY9WN5vB65wx1s146IzjIRhrZ6I3
         mz8wRNLV3VXp21ENMyO0OFUvCSoi5PhEmMg77rx3Q+Qykbwbcj/TpKfrZ25uOi2FF8ni
         xKfCmJmPc9dUwibG6S+umb/VylmkF64Fni9fGKQ5uOQ25uqHTMWJi/4VsEf+ZN5ZOm4Z
         fGKA==
X-Forwarded-Encrypted: i=1; AJvYcCUwO9Rb8LQ2nQZ/fW7z5zfHSlRAu3ISGNICVz+u1iaFK96AVbQutFnHPIMcgrMwvBpNd4g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxab7i8z+XRCOFNBmqXMGZvbZG4CC3Eht0cURYOXdC8dmtnpTL+
	OSV4tQ8FpUKWdbT0kEXd5hC4wzLHS17CySjpe9nvLrCXasB5B2cJWuoHiPxoQx0Nwm4dSyzt0PE
	PKEeGp4ytDRbRn91Hwhhg9EoDVfY71jRALVlh9bTdxA==
X-Gm-Gg: ASbGncsqiyJXW7aG2Cz8ozF8wbKy6pj8qET0qc0uDkHyv947alGEfC217gt3DrYLdXa
	7EPTGw3Vm7tOLBoX4h2T/eoDt+ZihRikV58HuP+Tkay0OlkBoQwoJTHnncakvqqNF6q8Ll2Fttr
	i4+OO1AyKgtwBzzqcZd50ZO2+QNM2VMgFxt6BX9qZ2ybR2
X-Google-Smtp-Source: AGHT+IFF31OseKeg+1+tXl1/uZdgG5l/sH+Q1irushanNELnnE/mrtKhIny1W9anKbFNm3mBC7SPQuEFa23oEv1coCQ=
X-Received: by 2002:a05:6512:108d:b0:553:25e9:7f3c with SMTP id
 2adb3069b0e04-553b6f158a4mr3010133e87.37.1750137116723; Mon, 16 Jun 2025
 22:11:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250613065743.737102-1-apatel@ventanamicro.com>
 <20250613065743.737102-13-apatel@ventanamicro.com> <63b76a34-7475-4a3c-b86d-c355ff928091@linux.dev>
 <c10155a2-5886-42de-9517-9ee6390f6581@linux.dev>
In-Reply-To: <c10155a2-5886-42de-9517-9ee6390f6581@linux.dev>
From: Anup Patel <apatel@ventanamicro.com>
Date: Tue, 17 Jun 2025 10:41:43 +0530
X-Gm-Features: AX0GCFvQNlZ9Q6MiIJm3wL1raeFFLRwcBp5EofZnzMWWZEDWdY6Iwn7SQwQuIXo
Message-ID: <CAK9=C2VPNC8_dxVxbrdvz7k_yG=XdKHhFk1b57+r6ORvWqNMWA@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] RISC-V: KVM: Pass VMID as parameter to
 kvm_riscv_hfence_xyz() APIs
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 15, 2025 at 12:48=E2=80=AFAM Atish Patra <atish.patra@linux.dev=
> wrote:
>
>
>
> On 6/14/25 12:12 PM, Atish Patra wrote:
> >
> > On 6/12/25 11:57 PM, Anup Patel wrote:
> >> Currently, all kvm_riscv_hfence_xyz() APIs assume VMID to be the
> >> host VMID of the Guest/VM which resticts use of these APIs only
> >> for host TLB maintenance. Let's allow passing VMID as a parameter
> >> to all kvm_riscv_hfence_xyz() APIs so that they can be re-used
> >> for nested virtualization related TLB maintenance.
> >>
> >> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> >> ---
> >>   arch/riscv/include/asm/kvm_tlb.h  | 17 ++++++---
> >>   arch/riscv/kvm/gstage.c           |  3 +-
> >>   arch/riscv/kvm/tlb.c              | 61 ++++++++++++++++++++---------=
--
> >>   arch/riscv/kvm/vcpu_sbi_replace.c | 17 +++++----
> >>   arch/riscv/kvm/vcpu_sbi_v01.c     | 25 ++++++-------
> >>   5 files changed, 73 insertions(+), 50 deletions(-)
> >>
> >> diff --git a/arch/riscv/include/asm/kvm_tlb.h b/arch/riscv/include/
> >> asm/kvm_tlb.h
> >> index f67e03edeaec..38a2f933ad3a 100644
> >> --- a/arch/riscv/include/asm/kvm_tlb.h
> >> +++ b/arch/riscv/include/asm/kvm_tlb.h
> >> @@ -11,9 +11,11 @@
> >>   enum kvm_riscv_hfence_type {
> >>       KVM_RISCV_HFENCE_UNKNOWN =3D 0,
> >>       KVM_RISCV_HFENCE_GVMA_VMID_GPA,
> >> +    KVM_RISCV_HFENCE_GVMA_VMID_ALL,
> >>       KVM_RISCV_HFENCE_VVMA_ASID_GVA,
> >>       KVM_RISCV_HFENCE_VVMA_ASID_ALL,
> >>       KVM_RISCV_HFENCE_VVMA_GVA,
> >> +    KVM_RISCV_HFENCE_VVMA_ALL
> >>   };
> >>   struct kvm_riscv_hfence {
> >> @@ -59,21 +61,24 @@ void kvm_riscv_fence_i(struct kvm *kvm,
> >>   void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
> >>                       unsigned long hbase, unsigned long hmask,
> >>                       gpa_t gpa, gpa_t gpsz,
> >> -                    unsigned long order);
> >> +                    unsigned long order, unsigned long vmid);
> >>   void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
> >> -                    unsigned long hbase, unsigned long hmask);
> >> +                    unsigned long hbase, unsigned long hmask,
> >> +                    unsigned long vmid);
> >>   void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
> >>                       unsigned long hbase, unsigned long hmask,
> >>                       unsigned long gva, unsigned long gvsz,
> >> -                    unsigned long order, unsigned long asid);
> >> +                    unsigned long order, unsigned long asid,
> >> +                    unsigned long vmid);
> >>   void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
> >>                       unsigned long hbase, unsigned long hmask,
> >> -                    unsigned long asid);
> >> +                    unsigned long asid, unsigned long vmid);
> >>   void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
> >>                      unsigned long hbase, unsigned long hmask,
> >>                      unsigned long gva, unsigned long gvsz,
> >> -                   unsigned long order);
> >> +                   unsigned long order, unsigned long vmid);
> >>   void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
> >> -                   unsigned long hbase, unsigned long hmask);
> >> +                   unsigned long hbase, unsigned long hmask,
> >> +                   unsigned long vmid);
> >>   #endif
> >> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
> >> index 9c7c44f09b05..24c270d6d0e2 100644
> >> --- a/arch/riscv/kvm/gstage.c
> >> +++ b/arch/riscv/kvm/gstage.c
> >> @@ -117,7 +117,8 @@ static void gstage_tlb_flush(struct kvm_gstage
> >> *gstage, u32 level, gpa_t addr)
> >>       if (gstage->flags & KVM_GSTAGE_FLAGS_LOCAL)
> >>           kvm_riscv_local_hfence_gvma_vmid_gpa(gstage->vmid, addr,
> >> BIT(order), order);
> >>       else
> >> -        kvm_riscv_hfence_gvma_vmid_gpa(gstage->kvm, -1UL, 0, addr,
> >> BIT(order), order);
> >> +        kvm_riscv_hfence_gvma_vmid_gpa(gstage->kvm, -1UL, 0, addr,
> >> BIT(order), order,
> >> +                           gstage->vmid);
> >>   }
> >>   int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
> >> diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
> >> index 349fcfc93f54..3c5a70a2b927 100644
> >> --- a/arch/riscv/kvm/tlb.c
> >> +++ b/arch/riscv/kvm/tlb.c
> >> @@ -251,6 +251,12 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vc=
pu)
> >>                   kvm_riscv_local_hfence_gvma_vmid_gpa(d.vmid, d.addr,
> >>                                        d.size, d.order);
> >>               break;
> >> +        case KVM_RISCV_HFENCE_GVMA_VMID_ALL:
> >> +            if (kvm_riscv_nacl_available())
> >> +                nacl_hfence_gvma_vmid_all(nacl_shmem(), d.vmid);
> >> +            else
> >> +                kvm_riscv_local_hfence_gvma_vmid_all(d.vmid);
> >> +            break;
> >>           case KVM_RISCV_HFENCE_VVMA_ASID_GVA:
> >>               kvm_riscv_vcpu_pmu_incr_fw(vcpu,
> >> SBI_PMU_FW_HFENCE_VVMA_ASID_RCVD);
> >>               if (kvm_riscv_nacl_available())
> >> @@ -276,6 +282,13 @@ void kvm_riscv_hfence_process(struct kvm_vcpu *vc=
pu)
> >>                   kvm_riscv_local_hfence_vvma_gva(d.vmid, d.addr,
> >>                                   d.size, d.order);
> >>               break;
> >> +        case KVM_RISCV_HFENCE_VVMA_ALL:
> >> +            kvm_riscv_vcpu_pmu_incr_fw(vcpu,
> >> SBI_PMU_FW_HFENCE_VVMA_RCVD);
> >> +            if (kvm_riscv_nacl_available())
> >> +                nacl_hfence_vvma_all(nacl_shmem(), d.vmid);
> >> +            else
> >> +                kvm_riscv_local_hfence_vvma_all(d.vmid);
> >> +            break;
> >>           default:
> >>               break;
> >>           }
> >> @@ -328,14 +341,13 @@ void kvm_riscv_fence_i(struct kvm *kvm,
> >>   void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm *kvm,
> >>                       unsigned long hbase, unsigned long hmask,
> >>                       gpa_t gpa, gpa_t gpsz,
> >> -                    unsigned long order)
> >> +                    unsigned long order, unsigned long vmid)
> >>   {
> >> -    struct kvm_vmid *v =3D &kvm->arch.vmid;
> >>       struct kvm_riscv_hfence data;
> >>       data.type =3D KVM_RISCV_HFENCE_GVMA_VMID_GPA;
> >>       data.asid =3D 0;
> >> -    data.vmid =3D READ_ONCE(v->vmid);
> >> +    data.vmid =3D vmid;
> >>       data.addr =3D gpa;
> >>       data.size =3D gpsz;
> >>       data.order =3D order;
> >> @@ -344,23 +356,28 @@ void kvm_riscv_hfence_gvma_vmid_gpa(struct kvm
> >> *kvm,
> >>   }
> >>   void kvm_riscv_hfence_gvma_vmid_all(struct kvm *kvm,
> >> -                    unsigned long hbase, unsigned long hmask)
> >> +                    unsigned long hbase, unsigned long hmask,
> >> +                    unsigned long vmid)
> >>   {
> >> -    make_xfence_request(kvm, hbase, hmask, KVM_REQ_TLB_FLUSH,
> >> -                KVM_REQ_TLB_FLUSH, NULL);
> >> +    struct kvm_riscv_hfence data =3D {0};
> >> +
> >> +    data.type =3D KVM_RISCV_HFENCE_GVMA_VMID_ALL;
> >> +    data.vmid =3D vmid;
> >> +    make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
> >> +                KVM_REQ_TLB_FLUSH, &data);
> >>   }
> >>   void kvm_riscv_hfence_vvma_asid_gva(struct kvm *kvm,
> >>                       unsigned long hbase, unsigned long hmask,
> >>                       unsigned long gva, unsigned long gvsz,
> >> -                    unsigned long order, unsigned long asid)
> >> +                    unsigned long order, unsigned long asid,
> >> +                    unsigned long vmid)
> >>   {
> >> -    struct kvm_vmid *v =3D &kvm->arch.vmid;
> >>       struct kvm_riscv_hfence data;
> >>       data.type =3D KVM_RISCV_HFENCE_VVMA_ASID_GVA;
> >>       data.asid =3D asid;
> >> -    data.vmid =3D READ_ONCE(v->vmid);
> >> +    data.vmid =3D vmid;
> >>       data.addr =3D gva;
> >>       data.size =3D gvsz;
> >>       data.order =3D order;
> >> @@ -370,15 +387,13 @@ void kvm_riscv_hfence_vvma_asid_gva(struct kvm
> >> *kvm,
> >>   void kvm_riscv_hfence_vvma_asid_all(struct kvm *kvm,
> >>                       unsigned long hbase, unsigned long hmask,
> >> -                    unsigned long asid)
> >> +                    unsigned long asid, unsigned long vmid)
> >>   {
> >> -    struct kvm_vmid *v =3D &kvm->arch.vmid;
> >> -    struct kvm_riscv_hfence data;
> >> +    struct kvm_riscv_hfence data =3D {0};
> >>       data.type =3D KVM_RISCV_HFENCE_VVMA_ASID_ALL;
> >>       data.asid =3D asid;
> >> -    data.vmid =3D READ_ONCE(v->vmid);
> >> -    data.addr =3D data.size =3D data.order =3D 0;
> >> +    data.vmid =3D vmid;
> >>       make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
> >>                   KVM_REQ_HFENCE_VVMA_ALL, &data);
> >>   }
> >> @@ -386,14 +401,13 @@ void kvm_riscv_hfence_vvma_asid_all(struct kvm
> >> *kvm,
> >>   void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
> >>                      unsigned long hbase, unsigned long hmask,
> >>                      unsigned long gva, unsigned long gvsz,
> >> -                   unsigned long order)
> >> +                   unsigned long order, unsigned long vmid)
> >>   {
> >> -    struct kvm_vmid *v =3D &kvm->arch.vmid;
> >>       struct kvm_riscv_hfence data;
> >>       data.type =3D KVM_RISCV_HFENCE_VVMA_GVA;
> >>       data.asid =3D 0;
> >> -    data.vmid =3D READ_ONCE(v->vmid);
> >> +    data.vmid =3D vmid;
> >>       data.addr =3D gva;
> >>       data.size =3D gvsz;
> >>       data.order =3D order;
> >> @@ -402,16 +416,21 @@ void kvm_riscv_hfence_vvma_gva(struct kvm *kvm,
> >>   }
> >>   void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
> >> -                   unsigned long hbase, unsigned long hmask)
> >> +                   unsigned long hbase, unsigned long hmask,
> >> +                   unsigned long vmid)
> >>   {
> >> -    make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_VVMA_ALL,
> >> -                KVM_REQ_HFENCE_VVMA_ALL, NULL);
> >> +    struct kvm_riscv_hfence data =3D {0};
> >> +
> >> +    data.type =3D KVM_RISCV_HFENCE_VVMA_ALL;
> >> +    data.vmid =3D vmid;
> >> +    make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE,
> >> +                KVM_REQ_HFENCE_VVMA_ALL, &data);
> >>   }
> >>   int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64
> >> nr_pages)
> >>   {
> >>       kvm_riscv_hfence_gvma_vmid_gpa(kvm, -1UL, 0,
> >>                          gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT,
> >> -                       PAGE_SHIFT);
> >> +                       PAGE_SHIFT, READ_ONCE(kvm->arch.vmid.vmid));
> >>       return 0;
> >>   }
> >> diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/
> >> vcpu_sbi_replace.c
> >> index b17fad091bab..b490ed1428a6 100644
> >> --- a/arch/riscv/kvm/vcpu_sbi_replace.c
> >> +++ b/arch/riscv/kvm/vcpu_sbi_replace.c
> >> @@ -96,6 +96,7 @@ static int kvm_sbi_ext_rfence_handler(struct
> >> kvm_vcpu *vcpu, struct kvm_run *run
> >>       unsigned long hmask =3D cp->a0;
> >>       unsigned long hbase =3D cp->a1;
> >>       unsigned long funcid =3D cp->a6;
> >> +    unsigned long vmid;
> >>       switch (funcid) {
> >>       case SBI_EXT_RFENCE_REMOTE_FENCE_I:
> >> @@ -103,22 +104,22 @@ static int kvm_sbi_ext_rfence_handler(struct
> >> kvm_vcpu *vcpu, struct kvm_run *run
> >>           kvm_riscv_vcpu_pmu_incr_fw(vcpu, SBI_PMU_FW_FENCE_I_SENT);
> >>           break;
> >>       case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA:
> >> +        vmid =3D READ_ONCE(vcpu->kvm->arch.vmid.vmid);
> >>           if ((cp->a2 =3D=3D 0 && cp->a3 =3D=3D 0) || cp->a3 =3D=3D -1=
UL)
> >> -            kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask);
> >> +            kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase, hmask, vmid);
> >
> > This patch doesn't apply cleanly on 6.16-rc1.
> >
> > <<<<<<< HEAD
> >                  if (cp->a2 =3D=3D 0 && cp->a3 =3D=3D 0)
> >                          kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase,
> > hmask);
> > =3D=3D=3D=3D=3D=3D=3D
> >                  vmid =3D READ_ONCE(vcpu->kvm->arch.vmid.vmid);
> >                  if ((cp->a2 =3D=3D 0 && cp->a3 =3D=3D 0) || cp->a3 =3D=
=3D -1UL)
> >                          kvm_riscv_hfence_vvma_all(vcpu->kvm, hbase,
> > hmask, vmid);
> >  >>>>>>> 57ec61198cc1 (RISC-V: KVM: Pass VMID as parameter to
> > kvm_riscv_hfence_xyz() APIs)
> > else
> >                          kvm_riscv_hfence_vvma_gva(vcpu->kvm, hbase, hm=
ask,
> >                                                    cp->a2, cp->a3,
> > PAGE_SHIFT, vmid);
> >                  kvm_riscv_vcpu_pmu_incr_fw(vcpu,
> > SBI_PMU_FW_HFENCE_VVMA_SENT);
> > break;
> >          case SBI_EXT_RFENCE_REMOTE_SFENCE_VMA_ASID:
> > <<<<<<< HEAD
> >                  if (cp->a2 =3D=3D 0 && cp->a3 =3D=3D 0)
> > kvm_riscv_hfence_vvma_asid_all(vcpu->kvm,
> >                                                         hbase, hmask,
> > cp->a4);
> > =3D=3D=3D=3D=3D=3D=3D
> >                  vmid =3D READ_ONCE(vcpu->kvm->arch.vmid.vmid);
> >                  if ((cp->a2 =3D=3D 0 && cp->a3 =3D=3D 0) || cp->a3 =3D=
=3D -1UL)
> > kvm_riscv_hfence_vvma_asid_all(vcpu->kvm, hbase, hmask,
> >                                                         cp->a4, vmid);
> >  >>>>>>> 57ec61198cc1 (RISC-V: KVM: Pass VMID as parameter to
> > kvm_riscv_hfence_xyz() APIs)
> >
> >
>
> ohh you already queued the PATCH1 from v1 of this series. If I try to
> rebase on top of riscv_kvm_queue, I see the following error in b4 shazam.
>
> ---
> Patch failed at 0008 RISC-V: KVM: Factor-out MMU related declarations
> into separate headers.
> ----
>

Yes, first two patches are fixes for Linux-6.16

Regards,
Anup

