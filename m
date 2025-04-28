Return-Path: <kvm+bounces-44597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CB33A9F919
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:02:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ADA037A6138
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 19:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA2472973A2;
	Mon, 28 Apr 2025 19:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iQuiPrLy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EC1269D09
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 19:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745866935; cv=none; b=cGlhMrg5VksOAFciGf92+1fWYFtRgUlRhy/lT/njAJaNncan6Ha3njca5zCswuFrtbPTqKJqRG/Pold0NWY2jDmG5MDE2PMVU8q73ojW/TSKGQTynrrvkO1moxq1mHOVPFYy0P2oZXTWDEQfLfdJZ8k+dVqzHHw5m7U1zFPn5+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745866935; c=relaxed/simple;
	bh=dPbGPFboill6iT76EBtr4PZn6lvH5BMhMgDL2shmMZs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nh9c8aw1Zk7tuiIGBVVIxLsHHrRDghrqocwelV9fgHsasvYnzVO17pQCQXxYF2mVgZN4GjR4AerhqtnSoRfkKKusUzUv3p7yJAKD6rKNsy9VvuCzsrUUPz5o7V8dvDLoFxQ8I9UeTnvrjoEat4S2tj/d6ICGP6gs791CXzA3Ap0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iQuiPrLy; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2242ac37caeso23255ad.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 12:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745866932; x=1746471732; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0d6vKqkeMQuJL7A/bSp8ZFP6OrnkpLdgBb2QvNCbFNU=;
        b=iQuiPrLyQzMczzwkfGmQLBxtixjLOSO60zomBAo3cMFOsYCE41n7K6w6BPAce4HVCy
         fOuSoCs9U1wkhZv7qSaW/AFiiJhNh9cimvtaHIZl8k0+qkWFiGyWPjFBY4yn7TnGR+Kw
         grmEA62eDz5ttqA9WgxqZ1WDP6zwdOiBNpHaxjIt/PTtID/oEcnzAvAoK7eTkVW+PJyn
         DJD/x3SWCu/atUoh4ITJjdkMnnYVt/mJ+ZsIG374vsm2GnF/bzIap0DQmOVKbvFs5daQ
         +mr+QJk1LTuVQm9teLn4N5sNTWL+P29YiXmczoguTi5axlJhyWMsxj6egiuxezujIVUu
         XohQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745866932; x=1746471732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0d6vKqkeMQuJL7A/bSp8ZFP6OrnkpLdgBb2QvNCbFNU=;
        b=Re+gACs9hWYV8Vl/+IMnwo4xGnVFN5bMkCTjM1xwK0HPMe0RmQycTcWYqF2PaqZofA
         IhXD9yRwNEUWL7tJCo0h5E+ClgqZamEr/cHmxwitU4aE9VeGKwYyebzxvS2ilyIgGzlC
         91wxRrldeT1AV0D8BKqgugKrDSGl54QCe3c40Ky8SdfebgwxACwD0JyK72rmNKTK+233
         9w9+saqfLeb8yZmTIGTC5gc93C64pzfJQnCTWmb131EASBhZGdqXQwrtZmQJb1GP8xNo
         UDqDgW7+QRRiXoGybvZynhsFxwuD5jmUWe7ekOMH/cCN2i20GLqZkBTYYg09Vo0uFTyB
         6jBA==
X-Forwarded-Encrypted: i=1; AJvYcCW/HmjIEjl8OmiJo+5SA/vIHxZXf+YSZkGHvGN/kCyUuc2jyZambPNpyoY/nxEUZONQ06U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxCmRXjHEvgF89tgSy4iebZfSKvA40SW0n15LrlWQByhw7dHEc
	+LIYIVCJV/nFulMP0ruWsGnDep41ZeGLZg/51NekGztNZWdu8BL1yr9LqFwgkyrWZpwhJ6T+G+8
	0A4stTVhgntN2ZCJwxKu/+o3Q0fHjbwhk4DDb
X-Gm-Gg: ASbGncttgrQGhADycj7odgqMNAdQ6eIJM1d/21xLw0oIOPbaLsQDdzXgtala7FoATVp
	P2zzS1jOnd6BbBBe6xsIuEQAagWUkXq7Jvq3FtPbFGGlq1AnW/RO4d79WhriXMKcvLIn+faf9ns
	DQaBl6I1eODdAT1pqsWw3V8d0MLozMynjs96ez4bdfbVrJmVnpsnoKVezxy+iOkno=
X-Google-Smtp-Source: AGHT+IGHVt/gKeNNEkBuiDZ/WNCdhRReTsGIQqOMd5cCX92xfcbOewQ1LqrEb8wI4CAhtx4rSrkAMWhGeINdBb7YCZY=
X-Received: by 2002:a17:902:f54c:b0:215:65f3:27ef with SMTP id
 d9443c01a7336-22de6c47e20mr422765ad.12.1745866932074; Mon, 28 Apr 2025
 12:02:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z+6AGxEvBRFkN5mN@yzhao56-desk.sh.intel.com> <diqzh62ezgdh.fsf@ackerleytng-ctop.c.googlers.com>
 <aAmPQssuN9Zba//b@yzhao56-desk.sh.intel.com> <aAm9OHGt6Ag7ztqs@yzhao56-desk.sh.intel.com>
 <c4dae65f-b5e6-44fa-b5ab-8614f1d47cb5@intel.com> <aAnytM/E6sIdvKNq@yzhao56-desk.sh.intel.com>
 <CAGtprH-Ana5A2hz_D+CQ0NYRVxfpR6e0Sojssym-UtUnYpOPqg@mail.gmail.com>
 <diqz7c39zas0.fsf@ackerleytng-ctop.c.googlers.com> <aAsJZuLjOAYriz8v@yzhao56-desk.sh.intel.com>
 <diqzwmb7yi67.fsf@ackerleytng-ctop.c.googlers.com> <aA7UXI0NB7oQQrL2@yzhao56-desk.sh.intel.com>
In-Reply-To: <aA7UXI0NB7oQQrL2@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 28 Apr 2025 12:02:00 -0700
X-Gm-Features: ATxdqUFfs0t7N5eWmI-1jNaKWhFko9iPatrQfOG5_SqVZrK0K5YoR1PgPQdgCTU
Message-ID: <CAGtprH8o=vE+_4maevXmFv4REg2+Ls-kKK8i0vjc7D6OYDCRkw@mail.gmail.com>
Subject: Re: [RFC PATCH 39/39] KVM: guest_memfd: Dynamically split/reconstruct
 HugeTLB page
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Chenyi Qiang <chenyi.qiang@intel.com>, tabba@google.com, 
	quic_eberman@quicinc.com, roypat@amazon.co.uk, jgg@nvidia.com, 
	peterx@redhat.com, david@redhat.com, rientjes@google.com, fvdl@google.com, 
	jthoughton@google.com, seanjc@google.com, pbonzini@redhat.com, 
	zhiquan1.li@intel.com, fan.du@intel.com, jun.miao@intel.com, 
	isaku.yamahata@intel.com, muchun.song@linux.dev, erdemaktas@google.com, 
	qperret@google.com, jhubbard@nvidia.com, willy@infradead.org, 
	shuah@kernel.org, brauner@kernel.org, bfoster@redhat.com, 
	kent.overstreet@linux.dev, pvorel@suse.cz, rppt@kernel.org, 
	richard.weiyang@gmail.com, anup@brainfault.org, haibo1.xu@intel.com, 
	ajones@ventanamicro.com, vkuznets@redhat.com, maciej.wieczor-retman@intel.com, 
	pgonda@google.com, oliver.upton@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 27, 2025 at 6:08=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Fri, Apr 25, 2025 at 03:45:20PM -0700, Ackerley Tng wrote:
> > Yan Zhao <yan.y.zhao@intel.com> writes:
> > ...
> > >
> > > For some memory region, e.g., "pc.ram", it's divided into 2 parts:
> > > - one with offset 0, size 0x80000000(2G),
> > >   positioned at GPA 0, which is below GPA 4G;
> > > - one with offset 0x80000000(2G), size 0x80000000(2G),
> > >   positioned at GPA 0x100000000(4G), which is above GPA 4G.
> > >
> > > For the second part, its slot->base_gfn is 0x100000000, while slot->g=
mem.pgoff
> > > is 0x80000000.
> > >
> >
> > Nope I don't mean to enforce that they are equal, we just need the
> > offsets within the page to be equal.
> >
> > I edited Vishal's code snippet, perhaps it would help explain better:
> >
> > page_size is the size of the hugepage, so in our example,
> >
> >   page_size =3D SZ_2M;
> >   page_mask =3D ~(page_size - 1);
> page_mask =3D page_size - 1  ?
>
> >   offset_within_page =3D slot->gmem.pgoff & page_mask;
> >   gfn_within_page =3D (slot->base_gfn << PAGE_SHIFT) & page_mask;
> >
> > We will enforce that
> >
> >   offset_within_page =3D=3D gfn_within_page;
> For "pc.ram", if it has 2.5G below 4G, it would be configured as follows
> - slot 1: slot->gmem.pgoff=3D0, base GPA 0, size=3D2.5G
> - slot 2: slot->gmem.pgoff=3D2.5G, base GPA 4G, size=3D1.5G
>
> When binding these two slots to the same guest_memfd created with flag
> KVM_GUEST_MEMFD_HUGE_1GB:
> - binding the 1st slot will succeed;
> - binding the 2nd slot will fail.
>
> What options does userspace have in this scenario?

Userspace can create new gmem files that have aligned offsets. But I
see your point, enforcing alignment at binding time will lead to
wastage of memory. i.e. Your example above could be reworked to have:
- slot 1: slot->gmem.pgoff=3D0, base GPA 0, size=3D2.5G, gmem_fd =3D x, gme=
m_size =3D 3G
- slot 2: slot->gmem.pgoff=3D0, base GPA 4G, size=3D1.5G, gmem_fd =3D y,
gmem_size =3D 2G

This will waste 1G of memory as gmem files will have to be hugepage aligned=
.

> It can't reduce the flag to KVM_GUEST_MEMFD_HUGE_2MB. Adjusting the gmem.=
pgoff
> isn't ideal either.
>
> What about something similar as below?
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index d2feacd14786..87c33704a748 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -1842,8 +1842,16 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_m=
emory_slot *slot,
>         }
>
>         *pfn =3D folio_file_pfn(folio, index);
> -       if (max_order)
> -               *max_order =3D folio_order(folio);
> +       if (max_order) {
> +               int order;
> +
> +               order =3D folio_order(folio);
> +
> +               while (order > 0 && ((slot->base_gfn ^ slot->gmem.pgoff) =
& ((1 << order) - 1)))

This sounds better. Userspace will need to avoid this in general or
keep such ranges short so that most of the guest memory ranges can be
mapped at hugepage granularity. So maybe a pr_warn could be spewed
during binding that the alignment is not optimal.

> +                       order--;
> +
> +               *max_order =3D order;
> +       }
>
>         *is_prepared =3D folio_test_uptodate(folio);
>         return folio;
>
>
> > >> Adding checks at binding time will allow hugepage-unaligned offsets =
(to
> > >> be at parity with non-guest_memfd backing memory) but still fix this
> > >> issue.
> > >>
> > >> lpage_info will make sure that ranges near the bounds will be
> > >> fragmented, but the hugepages in the middle will still be mappable a=
s
> > >> hugepages.
> > >>
> > >> [1] https://lpc.events/event/18/contributions/1764/attachments/1409/=
3706/binding-must-have-same-alignment.svg

