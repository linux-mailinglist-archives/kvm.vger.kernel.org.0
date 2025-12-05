Return-Path: <kvm+bounces-65315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 290E4CA6358
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 07:15:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4F81230307B3
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 06:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B1F2F3C1F;
	Fri,  5 Dec 2025 06:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FDvop2kr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774552C1586
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 06:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764915302; cv=none; b=HncGlxPPQDTSjiWhhV7PIqGQeKRoDJzeMy01preaGumO0ZfKNMzTAgs5ogJzm+PWStFo5Y+4nRoK3ShEas6ERm5A72BCrHgVFBp5uK7cQSoaJMc9aowdJQqA7wR0sxjUXZTdfe66CHejCnIj44sssBzLAFzCeTRKCfg+tze7gQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764915302; c=relaxed/simple;
	bh=GumwKOLLjxdUY+U9PG8UB4nTJAOZROVTyv0HwAH+NJs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZDhu98MK29SNu+cPbgdoHRDot+n5r6JF3PSdEQKqYDkAWvxJX3d7EUqK33AE8PM1xa8TUtL95BPmOB8oE8+3m2GlVZpU9xjyYI7hhLnjdBOm2MdFXR9BzXwZp+Br81W3hWkW2otijwPzQ99Q/w8+kYmyCt546+M7XLl91xGYVhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FDvop2kr; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-643165976dcso3901a12.1
        for <kvm@vger.kernel.org>; Thu, 04 Dec 2025 22:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764915299; x=1765520099; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MYmGF9BUSRH4mEvVEhqvGnDMdTX0YZPQ6tkCaTvhKIc=;
        b=FDvop2krnL5umYMPBHJJ5Fzf/1GnS42Y2Gdy3n+aZ+JhS9LbArYZZYUDAhHfVNgRu+
         coZoZk+WjkUwXoNR4rIrvHNVjhrDytGMVrshXiqrUYaQowRPfxPAGuqc7V/aUGCbipvn
         7ZgV+5HXhIDbkdkLigpq52VbrfeZV4L0Rxc/cGe5POwOBqk4t64TcYbNfPiq0O7r9vz6
         APcxbyMe+xtGranujVK8oMybbvFUZ16D62FDaRsOEMrCYasC+bfeCXsy0+Y8tW1vOGT+
         ktPwNeIhZk1gZklZOcDYiUofwQHVELbR/PtDH+V1rzz/Jp4K+fsKH62jURZYgbaLkwQj
         exlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764915299; x=1765520099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MYmGF9BUSRH4mEvVEhqvGnDMdTX0YZPQ6tkCaTvhKIc=;
        b=T5VwueYjOrZb2s4TrXJBcYvOefDvfj8AomsRtNhY3IGL8lPfV1PIdyDuJBBjYsuzGc
         fCR8N4LiHgJm5dbyCb75EyU3ZXyrt52H5BSxVvYdfyKBCCC9VTAz0V6hd1k/EPmOSe1M
         cglLiSz5UySCPVna8j6mjnp3pD+fPz39ZlpRyGLk93sKPF1X36WPCR6puA/RFzHZ6I5L
         Y82ceBZr3Xw0BoJEpTWLYZxO0a3ntjsWIyVgca1CErt5llap1v2Ix/vNnwNJZWLZwDk8
         OtDk8/bFl9SQsoZ6+ZL2l7n6L5yjYG15t8AqHtC0aw4P8u6doH9rzxFzdEfc9JMjpNu7
         Wg/w==
X-Forwarded-Encrypted: i=1; AJvYcCWh9zF6KzabDuufuqpY6uAj60JVW4dep+mu6xBju5M+lkU5vz6teQ741eQdrJ5Nhe5itas=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkpmvtJwvbM7J1B9Y7PoK2wYOACck7irqzyr8E3mpSzG5mXoKk
	4yNEe1NV1mwQpBnLYm+RecSxeCdZONBIImh99adPn91MJ782m4WBlNTuTjEykuEHMW/RGMm33PF
	9l0UwcHW9wx6IA9FWU/RAVst5KUT/ulEGLbtT2e4A
X-Gm-Gg: ASbGncseVWBa8zmgGQm1EXt6dzzQ8reD/Uwsl1bcwzKqacRlGQIT0li1zaW5fRzPhqd
	Xt9wY7uqMXYQX0Wv9Vu2AL5mA9zbHqXo0Xzmw6qr96LMlQba0Qu8AlkrFIc1/iw9pC7KB+lvR23
	kV2a3gIU8xioIlSxR+T3D49PFQC2sHAq+Tfj3Wzx7yBHMmJVJ/GUcNunwzOgfRpm1yTlEnQOzt2
	IHQ4KsGRhPr1TWRgcbovtboXx6ChDluXfC5B0quKjaf7SU8qsie0HJuSqC7zn2FrUyovymqvPc1
	DrmRa7EXX2B6O/LJkBu5c4c6HtCdxeLmGujwghA=
X-Google-Smtp-Source: AGHT+IE56QcyFVfY6S3gA9V7Yi8vr13hsOQ1+k7ljGeNd+lgfMx2o+6KAZhFK244vYm7N0Q6zCR1pPu0l2dc82gRqUU=
X-Received: by 2002:aa7:c918:0:b0:643:bfa:62d0 with SMTP id
 4fb4d7f45d1cf-648ba27210amr5587a12.10.1764915298682; Thu, 04 Dec 2025
 22:14:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807093950.4395-1-yan.y.zhao@intel.com> <20250807094604.4762-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094604.4762-1-yan.y.zhao@intel.com>
From: Sagi Shahar <sagis@google.com>
Date: Fri, 5 Dec 2025 00:14:46 -0600
X-Gm-Features: AQt7F2qhHh96pXvL_KPvHIfsPAsUP_6njQ4Y94IY2QHhfkfnegdLQjZRsgmnehA
Message-ID: <CAAhR5DF=Yzb6ThiLDtktiOnAG3n+u9jZZahJiuUFR9JFCsDw0A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 21/23] KVM: TDX: Preallocate PAMT pages to be used
 in split path
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kas@kernel.org, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vannapurve@google.com, vbabka@suse.cz, 
	thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com, 
	fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, binbin.wu@linux.intel.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 4:48=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Preallocate a page to be used in the split_external_spt() path.
>
> Kernel needs one PAMT page pair for external_spt and one that provided
> directly to the TDH.MEM.PAGE.DEMOTE SEAMCALL.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> RFC v2:
> - Pulled from
>   git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-h=
uge.
> - Implemented the flow of topup pamt_page_cache in
>   tdp_mmu_split_huge_pages_root() (Yan)
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu/mmu.c          |  1 +
>  arch/x86/kvm/mmu/tdp_mmu.c      | 51 +++++++++++++++++++++++++++++++++
>  3 files changed, 54 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 6b6c46c27390..508b133df903 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1591,6 +1591,8 @@ struct kvm_arch {
>  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
>         struct kvm_mmu_memory_cache split_desc_cache;
>
> +       struct kvm_mmu_memory_cache pamt_page_cache;
> +

The latest DPAMT patches use a per-vcpu tdx_prealloc struct to handle
preallocating pages for pamt. I'm wondering if you've considered how
this would work here since some of the calls requiring pamt originate
from user space ioctls and therefore are not associated with a vcpu.

Since the tdx_prealloc is a per vcpu struct there are no race issues
when multiple vcpus need to add pamt pages but here it would be
trickier here because theoretically, multiple threads could split
different pages simultaneously.

>         gfn_t gfn_direct_bits;
>
>         /*
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f23d8fc59323..e581cee37f64 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6848,6 +6848,7 @@ static void mmu_free_vm_memory_caches(struct kvm *k=
vm)
>         kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
>         kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
>         kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
> +       kvm_mmu_free_memory_cache(&kvm->arch.pamt_page_cache);
>  }
>
>  void kvm_mmu_uninit_vm(struct kvm *kvm)
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index eb758aaa4374..064c4e823658 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1584,6 +1584,27 @@ static bool iter_cross_boundary(struct tdp_iter *i=
ter, gfn_t start, gfn_t end)
>                  (iter->gfn + KVM_PAGES_PER_HPAGE(iter->level)) <=3D end)=
;
>  }
>
> +static bool need_topup_mirror_caches(struct kvm *kvm)
> +{
> +       int nr =3D tdx_nr_pamt_pages() * 2;
> +
> +       return kvm_mmu_memory_cache_nr_free_objects(&kvm->arch.pamt_page_=
cache) < nr;
> +}
> +
> +static int topup_mirror_caches(struct kvm *kvm)
> +{
> +       int r, nr;
> +
> +       /* One for external_spt, one for TDH.MEM.PAGE.DEMOTE */
> +       nr =3D tdx_nr_pamt_pages() * 2;
> +
> +       r =3D kvm_mmu_topup_memory_cache(&kvm->arch.pamt_page_cache, nr);
> +       if (r)
> +               return r;
> +
> +       return 0;
> +}
> +
>  static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>                                          struct kvm_mmu_page *root,
>                                          gfn_t start, gfn_t end,
> @@ -1656,6 +1677,36 @@ static int tdp_mmu_split_huge_pages_root(struct kv=
m *kvm,
>                         continue;
>                 }
>
> +               if (is_mirror_sp(root) && need_topup_mirror_caches(kvm)) =
{
> +                       int r;
> +
> +                       rcu_read_unlock();
> +
> +                       if (shared)
> +                               read_unlock(&kvm->mmu_lock);
> +                       else
> +                               write_unlock(&kvm->mmu_lock);
> +
> +                       r =3D topup_mirror_caches(kvm);
> +
> +                       if (shared)
> +                               read_lock(&kvm->mmu_lock);
> +                       else
> +                               write_lock(&kvm->mmu_lock);
> +
> +                       if (r) {
> +                               trace_kvm_mmu_split_huge_page(iter.gfn,
> +                                                             iter.old_sp=
te,
> +                                                             iter.level,=
 r);
> +                               return r;
> +                       }
> +
> +                       rcu_read_lock();
> +
> +                       iter.yielded =3D true;
> +                       continue;
> +               }
> +
>                 tdp_mmu_init_child_sp(sp, &iter);
>
>                 if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
> --
> 2.43.2
>
>

