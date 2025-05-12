Return-Path: <kvm+bounces-46139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9C9AB3042
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 09:09:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBD113B51F3
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 07:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7A92566C4;
	Mon, 12 May 2025 07:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OTjxxVDt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D432E255F50
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 07:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747033772; cv=none; b=d3yVn+QPGckTektkR0v5zExtHoAyeMeaT83emNBSbz1M+wSMWAa1SRDFsN2pdhNpTOR0Xda4HxOrjd8rsK7vknf95z1ofj8dFJQ5W4GtEsrl9YCDp91M9VWsuf+9WYWNYvASS8fj/Ik0f1rW5WMJdg0dZW/H6KgF/15ViFyL75E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747033772; c=relaxed/simple;
	bh=+0UL+4ECd5ggGsQ+5dDpr+JU2V8Gxp3IpSWXJSEWr7k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k4e6X2/KvzXxxUqeRrT9LOcV9q5hdFrjR/qObeHxvupgzt6JUxMd10SAni2pgWLxpTcgs9orYu7zf1kf4z6YRChPQsKdI5lqzzsavyA9AhK9flxlbW9JuKSaHBegxoAiJ/pbU7dQwhhS+IbFlp1EAAkHW+zI+RcNfXoLemjCNS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OTjxxVDt; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4774611d40bso431861cf.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 00:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747033769; x=1747638569; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XSmTOYCiVv7/OshHrbhVrhF4ObIKGNu6xZWV2038bpM=;
        b=OTjxxVDt+73t5r0FKcHN4JPf5zRpnDJjlmNn08R0FPbBgTEz7MQQvobSMkubRS0T2g
         S9adq9hcwNYAuNfrnl5WRU+U17EMvBlp/Ow7X/eJ5e1eq998TnbaKOKq+bZJhNYVuNfz
         5CD2IHXQKGBq5B3+k+cHlTjBQXWtnjjbIKnAWNDin5vOc5Awo2WBe9FGFbR2AZXgjqcC
         VhIT/mkbrIVmKJO6NqlTCwDJFh2+cKU3ukHyJu++YLwbpWYylbjBrLUrOqHx3pfcEDx/
         9WUDIFQPAWVevMtWryK+P5yhTBH/JCuqDJ7f+IlKbC8mEF7GOApNao7WUSa8PqjfDG+w
         5kbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747033769; x=1747638569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XSmTOYCiVv7/OshHrbhVrhF4ObIKGNu6xZWV2038bpM=;
        b=oNufR/W9vykBRhbO3BomVdbj/hsaF4joFEg7KUtuRSGn9TGH2VUAGI6tixejocz9Cm
         kz5ZdN8VemzAhOuUPRBHBvLHYBMjGPmmbW8z3HHjOWU3C38AwnsGwyID/nq/jyVP1ff2
         awzfBzz+Ihp/LBZPjTyD34mI3nNLcUE+dPodkLptE8aQnJ0lmZYooU6Ct5w8dJKdNXb3
         OqO1ZD6DJNahHnuvlCtSL3lEjTkQ16ujJ5L2Aqare9BqoQrXBY8tnUM+qljg51DWkibv
         Cupm1Hiee3CY4ZHdYj8jDRIx/W7/Gr+8B8nF5NrJAbIoKP73RCpP3UytXnwgpxDozQhs
         hjfw==
X-Forwarded-Encrypted: i=1; AJvYcCXWJsYyRODIp5bIA+RWsn6y/lr/fdU3/ZvhIrqmI4pSE3i4xdedBCqhraYDhJBzduxqzR8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx02yEU67H9n+dIm2EqlPmlHinAbeX07LHs76rXySQ7RXyTvLFJ
	26YBPSkWobbArVKwuJ2MfORxigtuhX3tRO7c7Wa1LhWQpcbX9hQ8GIs0JF3EBWFgH6AM1+bx1TO
	MkvA4c86FtGmyDX+68pcjkdxzYwvrbfwNVmpi
X-Gm-Gg: ASbGncsMSrLyq4dub/AvIvJELVzsS1I3HZMfmbK9JDtkmAv1EZ7L7ehSIvqMWKYpfLW
	O6Su/W5amaLfO2upmbklnxU7/PoMc0HuKrKu0V+qxfHRjTdlhgcGqHSQ+kXUhPzrO1XHpYH2kp1
	V0TgFMyMRTuYz0AOwu9TMalWiWC9/WOywx+ANc7FCM/xRt
X-Google-Smtp-Source: AGHT+IFWkn43x0P4nlxGLXdV3CrSVT40wPdseY7NOjafRyvqEjQ9QNxnsrVcDogvYXeKprPQ5Mqc/SYgP14o+2RK6eY=
X-Received: by 2002:ac8:5889:0:b0:494:5923:8bcd with SMTP id
 d75a77b69052e-49462d40c04mr6781711cf.3.1747033769418; Mon, 12 May 2025
 00:09:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com> <20250430165655.605595-9-tabba@google.com>
 <CADrL8HVO6s7V0c0Jv0gJ58Wk4NKr3F+sqS4i2dFw069P6ot7Fg@mail.gmail.com> <702d9951-ac26-4ee4-8a78-d5104141c2e4@redhat.com>
In-Reply-To: <702d9951-ac26-4ee4-8a78-d5104141c2e4@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 May 2025 08:08:52 +0100
X-Gm-Features: AX0GCFv-MyXwz1MDe12JSf9b8ojiBGKwn87SyNuOsfPf6zdJXpwsIjIp3k07lFM
Message-ID: <CA+EHjTyCQJccwGim_xe5xSv7ihLANRdcrwhrMAib+ByBzVAwSg@mail.gmail.com>
Subject: Re: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi James.

On Sun, 11 May 2025 at 09:03, David Hildenbrand <david@redhat.com> wrote:
>
> On 09.05.25 22:54, James Houghton wrote:
> > On Wed, Apr 30, 2025 at 9:57=E2=80=AFAM Fuad Tabba <tabba@google.com> w=
rote:
> >> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vm=
a)
> >> +{
> >> +       struct kvm_gmem *gmem =3D file->private_data;
> >> +
> >> +       if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
> >> +               return -ENODEV;
> >> +
> >> +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=3D
> >> +           (VM_SHARED | VM_MAYSHARE)) {
> >> +               return -EINVAL;
> >> +       }
> >> +
> >> +       vm_flags_set(vma, VM_DONTDUMP);
> >
> > Hi Fuad,
> >
> > Sorry if I missed this, but why exactly do we set VM_DONTDUMP here?
> > Could you leave a small comment? (I see that it seems to have
> > originally come from Patrick? [1]) I get that guest memory VMAs
> > generally should have VM_DONTDUMP; is there a bigger reason?
>
> (David replying)
>
> I assume because we might have inaccessible parts in there that SIGBUS
> on access.

That was my thinking.

> get_dump_page() does ignore any errors, though (returning NULL), so
> likely we don't need VM_DONTDUMP.

In which case I'll remove this from the next respin.

Thanks,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

