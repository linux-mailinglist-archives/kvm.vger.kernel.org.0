Return-Path: <kvm+bounces-15709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FF3F8AF632
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 20:03:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 775F228F50F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A6E140367;
	Tue, 23 Apr 2024 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O9nFDAEh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDA113E040
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 18:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713895300; cv=none; b=Mqr/0B7prHDwevIw6064XmbLs9QN+bSv5Lnm0W8s/gjWIYTphKA1JRp/uzw6STYSbKWNOLyLGdVY6+dalTUWV1NmHbJp6eReFpmCS4AK+Qy21x3RfHHCrBFBzJFjQl99ceWceW9YQLOU/Moost8JANP+FagOxmx7/A42VZ7Ard4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713895300; c=relaxed/simple;
	bh=jsJaw3ZYxiPqWsp27rxMmLDLSRi++1z8rq0U1HejC+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qArJ3EtSQrdqRDLb64Jt35J+GR72vfmYkzJ9O2uQtKEPsJbJPLqfbkRW1SnHiRKQlQ76KU9WhRjlcp9ftco5k7HXPGi9rmZ5XS6gG4k9viUtiXxNjJk0DVUqTSFH0zZPRWE8+oUkVvfBeiytkXyOQ5AwLO51hCLbwisDt1fueUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O9nFDAEh; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a51a7d4466bso641786566b.2
        for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 11:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713895297; x=1714500097; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYd986yAlnoub0nueWozFbEO//b4P9P5e47HvH7hRoQ=;
        b=O9nFDAEhWONNPfw9EyP7NVMbAhHHeqv56mCgDkmlYIpHbTMkqmTCSwecTBcJenxLd/
         bbYczNY/XOeQSlMiLaOQxi04XFt74FQPop8sbpH1WS+q8GFQjG453yyKvD5TnM61tQN6
         P2mDaw3+GpwIgygO7FmG+pkVGwiDv4HAltPkTMEMlKLXU0pUjpL7JvqKPYYlQ6z2pAJE
         qdKAgpe8orWwpmpv8oxS4l3a5lWAe7ettmoaQ86vk6pvSZXMyPy2F61zL2xE7uI+XseW
         Uy0IMN4TA1GORJztQAb8OTyscZkMVsM2vlYQrwJeT36HaBc5b5JYgiij9SKlHPlj4Wd/
         8pvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713895297; x=1714500097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fYd986yAlnoub0nueWozFbEO//b4P9P5e47HvH7hRoQ=;
        b=Mk1bNADYQfP8MbJc0KGwTUlU6EUwj5Xd6BgGkpfpE+84aRdnGrkoBmSUvij0IAtd0k
         yGNJpaucperbX7nmZ5OwcBLflcW+uGnI9UZ+K/1jd/s/oOATJTt0YXbmTXf7DolXtqNM
         GOFFwHPBPlFa7uxrA9Ql6eglvHHyzIX/ECETbK7ycrFouGORAS4qYIQTNDia4Rd+x/iH
         M0nbisVF5dM6T+XjLeMOdUAlMEFrwlOfzZwLiwhT3N1D582W4kpBHnSfIHDNL5OnVCk9
         VYdAla1UbcYdJvUMzwwFFLLYe0Oz5Y92w0cuXNh1q5wC2aa71nGAvZOiKVyZFHr3mnhN
         tbXA==
X-Forwarded-Encrypted: i=1; AJvYcCX26cmRY0qtKcRTdLfanfk95ISE25dO16EBx62bDGlkxhziQrYP3jN5rXtgQeojiIzsidUIaiijC9GVyM08+5vdR2qJ
X-Gm-Message-State: AOJu0YwFe+82HzX6lUtX8nSXZEEu2L7FChFdX3E4WZyCouQzpZErM+Up
	dBavflLqRXp9zHgquPLrH1HSxYXkNSS2xWi59G81BejakVVEZ58ZArSXqrSnwtxB71M+ku//Bms
	Qz9uh8n/pk16BTLGpL6uQsRcUeuj2jF9ioZ3g
X-Google-Smtp-Source: AGHT+IG3wJzFDKHqIR/QF4W/JNcdNCmr8FHAXEnRHjyRm8pyiSKRbC7jm5Uu5Q2DvzXyDeUG011T15LcrqD3rNHRCIg=
X-Received: by 2002:a17:906:458:b0:a58:78ac:7511 with SMTP id
 e24-20020a170906045800b00a5878ac7511mr45840eja.16.1713895296878; Tue, 23 Apr
 2024 11:01:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418030703.38628-1-lirongqing@baidu.com> <ZicA3732THkl-B1u@google.com>
 <CAMkAt6oP2CM+EtSNtCw7+V72UsPTHRZ04t7d21j0jQsj8wkW8w@mail.gmail.com>
In-Reply-To: <CAMkAt6oP2CM+EtSNtCw7+V72UsPTHRZ04t7d21j0jQsj8wkW8w@mail.gmail.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Tue, 23 Apr 2024 11:00:58 -0700
Message-ID: <CAJD7tkZzHQUOH3EiJ_Zn33dya+pumnohoKA7AnnVm4GE+WcOhg@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Consider NUMA affinity when allocating per-CPU save_area
To: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Li RongQing <lirongqing@baidu.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 23, 2024 at 6:30=E2=80=AFAM Peter Gonda <pgonda@google.com> wro=
te:
>
> On Mon, Apr 22, 2024 at 6:29=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > +Tom, Mike, and Peter
> >
> > On Thu, Apr 18, 2024, Li RongQing wrote:
> > > save_area of per-CPU svm_data are dominantly accessed from their
> > > own local CPUs, so allocate them node-local for performance reason
> > >
> > > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > > ---
> > >  arch/x86/kvm/svm/sev.c | 6 +++---
> > >  arch/x86/kvm/svm/svm.c | 2 +-
> > >  arch/x86/kvm/svm/svm.h | 6 +++++-
> > >  3 files changed, 9 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 61a7531..cce8ec7 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -3179,13 +3179,13 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_=
vcpu *vcpu, u8 vector)
> > >       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, 1);
> > >  }
> > >
> > > -struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
> > > +struct page *snp_safe_alloc_page_node(struct kvm_vcpu *vcpu, int nod=
e)
> > >  {
> > >       unsigned long pfn;
> > >       struct page *p;
> > >
> > >       if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> > > -             return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > > +             return alloc_pages_node(node, GFP_KERNEL_ACCOUNT | __GF=
P_ZERO, 0);
> > >
> > >       /*
> > >        * Allocate an SNP-safe page to workaround the SNP erratum wher=
e
> > > @@ -3196,7 +3196,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcp=
u *vcpu)
> > >        * Allocate one extra page, choose a page which is not
> > >        * 2MB-aligned, and free the other.
> > >        */
> > > -     p =3D alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1);
> > > +     p =3D alloc_pages_node(node, GFP_KERNEL_ACCOUNT | __GFP_ZERO, 1=
);
> >
> > This made me realize the existing code is buggy.  The allocation for th=
e per-CPU
> > save area shouldn't be accounted.
> >
> > Also, what's the point of taking @vcpu?  It's a nice enough flag to say=
 "this
> > should be accounted", but it's decidely odd.
> >
> > How about we fix both in a single series, and end up with this over 3-4=
 patches?
> > I.e. pass -1 where vcpu is non-NULL, and the current CPU for the save a=
rea.
>
> Looks good to me. Internally we already use GFP_KERNEL for these
> allocations. But we had an issue with split_page() and memcg
> accounting internally. Yosry submitted the following:
>
> +  if (memcg_kmem_charge(p, GFP_KERNEL_ACCOUNT, 0)) {
> +    __free_page(p);
> +    return NULL;
> +  }
>
> Not sure if this is an issue with our kernel or if we should use
> split_page_memcg() here? It was suggested internally but we didn't
> want to backport it.

The referenced internal code is in an older kernel where split_page()
was buggy and did not handle memcg charging correctly (did not call
split_page_memcg()). So we needed to make the allocation with
GFP_KERNEL, then manually account the used page after splitting and
freeing the unneeded page.

AFAICT, this is not needed upstream and the current code is fine.

>
> >
> > struct page *snp_safe_alloc_page(int cpu)
> > {
> >         unsigned long pfn;
> >         struct page *p;
> >         gfp_t gpf;
> >         int node;
> >
> >         if (cpu >=3D 0) {
> >                 node =3D cpu_to_node(cpu);
> >                 gfp =3D GFP_KERNEL;
> >         } else {
> >                 node =3D NUMA_NO_NODE;
> >                 gfp =3D GFP_KERNEL_ACCOUNT
> >         }

FWIW, from the pov of someone who has zero familiarity with this code,
passing @cpu only to make inferences about the GFP flags and numa
nodes is confusing tbh.

Would it be clearer to pass in the gfp flags and node id directly? I
think it would make it clearer why we choose to account the allocation
and/or specify a node in some cases but not others.

> >         gfp |=3D __GFP_ZERO;
> >
> >         if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
> >                 return alloc_pages_node(node, gfp, 0);
> >
> >         /*
> >          * Allocate an SNP-safe page to workaround the SNP erratum wher=
e
> >          * the CPU will incorrectly signal an RMP violation #PF if a
> >          * hugepage (2MB or 1GB) collides with the RMP entry of a
> >          * 2MB-aligned VMCB, VMSA, or AVIC backing page.
> >          *
> >          * Allocate one extra page, choose a page which is not
> >          * 2MB-aligned, and free the other.
> >          */
> >         p =3D alloc_pages_node(node, gfp, 1);
> >         if (!p)
> >                 return NULL;
> >
> >         split_page(p, 1);
> >
> >         pfn =3D page_to_pfn(p);
> >         if (IS_ALIGNED(pfn, PTRS_PER_PMD))
> >                 __free_page(p++);
> >         else
> >                 __free_page(p + 1);
> >
> >         return p;
> > }
> >

