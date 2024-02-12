Return-Path: <kvm+bounces-8546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D00A851193
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 11:55:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 903461C23596
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 10:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC763C06A;
	Mon, 12 Feb 2024 10:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M4V85FiM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC743B791
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 10:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707735046; cv=none; b=Mte65NRkK8FkOSCKCG0/Ua4phsmhatcX2oyj5zoJ1Lyx/aLmiz04Qzq1ATAIvgNxQHCfnyqvU97pQRmGMMSnFMKOQmUKevDr2xPnkHcKW9JIjoHpsIe6xblHxTH9lLz80biKUbrZQXOl2Yi/GaEV9qIKXSpjBdZeN1sCrh8HkXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707735046; c=relaxed/simple;
	bh=Lr66KmZnVLS82nRgdt+beezb2jJBazpmkeYHKLN/A9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pFjz+Gwu6LaT8AtAV3UmxKP29jXaWteRu2ldS+o6lU6fS3KvndyzrezATo7EMf96HvlL3vMCsIc5hScQor4FVk4LUhtyoOBdhXJgVapfqsUvSXiQ6dHYH/zY6P3G3D4UMOSDIW+AHzoKB6GbH6OjYrGFi289qLlKC6QPmeRFnZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M4V85FiM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707735042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CGzi02Tn24h+4KX7saOQvUPo/IOGq4TShidAZaCvX4Q=;
	b=M4V85FiMpVf9ad8urNi0YLTZhEIaligdCP40ZSJMQuB/+e88t892IdYfQf7tpsPXcVVIRU
	lNvneXKfh6Qhgysh2A7uaPzLn4Ky6H1JlxEvfcY/5k919GzwiqhcwaaOXwTehtM2Yrwi0x
	SLJyCK4L9RQwg6lRXGq9H4HAyCbo0Jc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-5hYobLO1OtuxNWEA1YJFqw-1; Mon, 12 Feb 2024 05:50:40 -0500
X-MC-Unique: 5hYobLO1OtuxNWEA1YJFqw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a2f1d0c3389so196036566b.0
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 02:50:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707735040; x=1708339840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CGzi02Tn24h+4KX7saOQvUPo/IOGq4TShidAZaCvX4Q=;
        b=u9Jic3yjgKk7IRcyyXo49JFjqbyFrnp74lAPlPjbpF5AqhXiDOnTo0W1/qYfCQjGl+
         dru4/jtQVFcrU/wMAuPdMF7sM1SxvNOstjewwhOBcjpazgcT0KBSI/fRHhIE3Dk7DW5l
         Jy+bpBYaS6Oa4wROf+EHeEhIQSXUM54hi91YCg3LyVqm5xhXvDhHfd1yfgbpsde6sq8T
         LPyBjincbs8+qCMcTnkyfzJwg8tCV6ech0xL8VHAeh0o/k24IXixR6IzO7D6gSI3UANy
         xZrYgt6Ogx1vXFp+mzClmA10U50zwqMycDxg+WCUDCklrR4UHg+C/n8YhIgv/ByCif89
         gEiw==
X-Gm-Message-State: AOJu0Yw0TKYLqfmy8PxCAsOPWyuV0gCxOr18y/VV6xRR2a/EvWdO8QUR
	KiznwhwnjGMgeuHjUUllWVjuOROva5cuQZ490KJKP2U47lhLlSWbBoKZ5xDTWCaTHjdb8pJOnyf
	GNgRPl+JJjD7/wM4I1oPDbZ+G9VlNkggOe5RMRib48l6kdxsVamKGKO1Iu57fCkEjU+tQI0lpAD
	qZupxqFFaZ7nEB03XJychhkQKw
X-Received: by 2002:a17:906:3507:b0:a3c:2293:6500 with SMTP id r7-20020a170906350700b00a3c22936500mr3694510eja.62.1707735039887;
        Mon, 12 Feb 2024 02:50:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEs/dTfWeYlV2h3bAXvOeCpDOIaWG7ELxlYs012S707SouVNragOMr+4A+e87Se2En7qrc/XFhuu59BW51wQ4A=
X-Received: by 2002:a17:906:3507:b0:a3c:2293:6500 with SMTP id
 r7-20020a170906350700b00a3c22936500mr3694493eja.62.1707735039576; Mon, 12 Feb
 2024 02:50:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231230172351.574091-1-michael.roth@amd.com> <20231230172351.574091-31-michael.roth@amd.com>
In-Reply-To: <20231230172351.574091-31-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Feb 2024 11:50:26 +0100
Message-ID: <CABgObfYX74NwYPV8dHGfLjBBp5JMGsN5OSQaJrgHQTghVdrD1g@mail.gmail.com>
Subject: Re: [PATCH v11 30/35] KVM: x86: Add gmem hook for determining max NPT
 mapping level
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

On Sat, Dec 30, 2023 at 6:32=E2=80=AFPM Michael Roth <michael.roth@amd.com>=
 wrote:
>         int max_order, r;
> +       u8 max_level;
>
>         if (!kvm_slot_can_be_private(fault->slot)) {
>                 kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> @@ -4321,8 +4322,15 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu=
 *vcpu,
>                 return r;
>         }
>
> -       fault->max_level =3D min(kvm_max_level_for_order(max_order),
> -                              fault->max_level);
> +       max_level =3D kvm_max_level_for_order(max_order);
> +       r =3D static_call(kvm_x86_gmem_max_level)(vcpu->kvm, fault->pfn,
> +                                               fault->gfn, &max_level);

Might as well pass &fault->max_level directly to the callback, with no
change to the vendor-specific code.

I'll include the MMU part in a generic series to be the base for both
Intel TDX and AMD SEV-SNP, and will do that change.

Paolo

> +       if (r) {
> +               kvm_release_pfn_clean(fault->pfn);
> +               return r;
> +       }
> +
> +       fault->max_level =3D min(max_level, fault->max_level);
>         fault->map_writable =3D !(fault->slot->flags & KVM_MEM_READONLY);
>
>         return RET_PF_CONTINUE;
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 85f63b6842b6..5eb836b73131 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4315,3 +4315,30 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_=
t end)
>                 pfn +=3D use_2m_update ? PTRS_PER_PMD : 1;
>         }
>  }
> +
> +int sev_gmem_max_level(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *ma=
x_level)
> +{
> +       int level, rc;
> +       bool assigned;
> +
> +       if (!sev_snp_guest(kvm))
> +               return 0;
> +
> +       rc =3D snp_lookup_rmpentry(pfn, &assigned, &level);
> +       if (rc) {
> +               pr_err_ratelimited("SEV: RMP entry not found: GFN %llx PF=
N %llx level %d error %d\n",
> +                                  gfn, pfn, level, rc);
> +               return -ENOENT;
> +       }
> +
> +       if (!assigned) {
> +               pr_err_ratelimited("SEV: RMP entry is not assigned: GFN %=
llx PFN %llx level %d\n",
> +                                  gfn, pfn, level);
> +               return -EINVAL;
> +       }
> +
> +       if (level < *max_level)
> +               *max_level =3D level;
> +
> +       return 0;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f26b8c2a8be4..f745022f7454 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5067,6 +5067,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>         .alloc_apic_backing_page =3D svm_alloc_apic_backing_page,
>
>         .gmem_prepare =3D sev_gmem_prepare,
> +       .gmem_max_level =3D sev_gmem_max_level,
>         .gmem_invalidate =3D sev_gmem_invalidate,
>  };
>
> --
> 2.25.1
>


