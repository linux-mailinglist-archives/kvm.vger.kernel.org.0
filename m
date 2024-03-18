Return-Path: <kvm+bounces-12005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F52987EE61
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 18:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F2931C210AE
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 17:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C271A54F9C;
	Mon, 18 Mar 2024 17:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N8SQeZpt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBEE55775
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710781588; cv=none; b=DKiHenQ7r1EUhP5hHQlATgHN4Hg7zwN82taj1cApNNYhbtU+Fb6MU3maH+KBuw0a/wacoYaDDTvSTOoG022glbhq6dMtSk7E1iIvdYIjljVVLxxsAoZX+W85sYTfO2lLv9PGyplFj5yN5eLTCoiyr6+NpRlXBTESmDZGbxTr+uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710781588; c=relaxed/simple;
	bh=wO1r7n/fmpmHJNO7C7t/Fiaw0aLE27GJ1ob1HSjzT3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N7ILR0SbVfxD+RDTrO0JQ9Scal0FYrLvFwiEPKAUaWIZJ0i2kTHu4AQdqSW7weGqZZzw/tjri/zaxae8qvs0sz25XDU0d3R+srwifdoFzDoOQGJhrJFGswmPfCGeKn5bC0sevHkkWOiAA6hT/vvrM2QiHz0iUuAv+XsfUrJKTdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N8SQeZpt; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-78850ab4075so191230585a.1
        for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 10:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710781586; x=1711386386; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NF57ccWL2fW0MRBAd8FHi6iAKCBMMg0jPBtwttJtVt4=;
        b=N8SQeZptvvmikZA4xjGSuj8uYPzcV08ejaE9iBQg5iB6YJw3n7+qMystifpaLVMtzc
         TTFaiHEndxxwAxLCqNlFuLjMnAUwjsewhKxJxTkvTbvNcoP/oYWIbTPYp6LE/s8fbsQd
         WTHn4823RhG6JMzbtiRRGGWNQp2BIwYT4hV2U9jsJ7+khIBmZqGcIuc/MKZYThWJYd2m
         JMn2zw32DpLkEggvq/8SV9kgzma06pu+rFDTP7qoaSSMjbVn/06lvrU2ctix0nZkPRdx
         adx6xXNlk0ZHsSlxfvAEyMEaJBrC2tuGMx2WJq03qCb85Wa0TIJXkTAE4Lddwrp9m+EC
         bsWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710781586; x=1711386386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NF57ccWL2fW0MRBAd8FHi6iAKCBMMg0jPBtwttJtVt4=;
        b=SVh9B/5FZPMcijLN/je3wNKJu4QPyZ2iL6qOOngf9RimYmvrI3VueVZ9zaVaiCB0xe
         0qNreig2n18KwktSA2YdE7jZjJeGMKhWvhQV/3NarlRmDbVhFNvA8j5I8ABe0zCz9yd+
         ULE4eiN14bcdYIz8252tRRG9HynbopCeaDZTzWwR/hff3xY+Gnx2YTKsuOi9Ztc9Xe3s
         UbzOQgzlY1wbDy5zW29XaIMNbOmCUJc3YMpyzxa67E+C6BT6qOY8P/37OEaW9YbyTkJJ
         9pJT2Q04fqSR1wbQWJEgYk1QhVavrlZUpDN6e0/ByXS50guCcc09gC5DrJcOWGsNf58l
         IJvA==
X-Forwarded-Encrypted: i=1; AJvYcCW3/HvST9NlwiHIhGcaRweK+DWDCHtfBYSXr5rMHzWAjF6DLeAJnKAw3vGBaWqGk1PgKW9ohtCpeK4AhbxcdZoAnLUe
X-Gm-Message-State: AOJu0Yy/E+yToGgeVF+/p3Db2LvBF6EJJ6psJAtBRmZgv3IW0fS5Ux4U
	UUyeVgFAWigHtSkDsZaUHMev2c2oGPn0QGMANvrtTRAnVEheNnvRRU8ifrAtSZslmSh/cCA2Q6/
	vdmdnkF2Vyzj1N/ObkRkQc1H4UZB0BSHFQZlU
X-Google-Smtp-Source: AGHT+IGchNmpKqEvOsyJsORM6Rdk76HLItKpY9KUt3EAsDMcebiP7GEsuPfgxQ4qtBtUYHV/dqgAjPV9ICe9FSECPPA=
X-Received: by 2002:ad4:5699:0:b0:690:ca65:3393 with SMTP id
 bd25-20020ad45699000000b00690ca653393mr11918853qvb.33.1710781585330; Mon, 18
 Mar 2024 10:06:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com> <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com> <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com> <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com> <ZeXAOit6O0stdxw3@google.com>
 <ZeYbUjiIkPevjrRR@google.com> <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
In-Reply-To: <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 18 Mar 2024 10:06:11 -0700
Message-ID: <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
Subject: Re: folio_mmapped
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Quentin Perret <qperret@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, keirf@google.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 12:17=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 04.03.24 20:04, Sean Christopherson wrote:
> > On Mon, Mar 04, 2024, Quentin Perret wrote:
> >>> As discussed in the sub-thread, that might still be required.
> >>>
> >>> One could think about completely forbidding GUP on these mmap'ed
> >>> guest-memfds. But likely, there might be use cases in the future wher=
e you
> >>> want to use GUP on shared memory inside a guest_memfd.
> >>>
> >>> (the iouring example I gave might currently not work because
> >>> FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
> >>> guest_memfd will likely not be detected as shmem; 8ac268436e6d contai=
ns some
> >>> details)
> >>
> >> Perhaps it would be wise to start with GUP being forbidden if the
> >> current users do not need it (not sure if that is the case in Android,
> >> I'll check) ? We can always relax this constraint later when/if the
> >> use-cases arise, which is obviously much harder to do the other way
> >> around.
> >
> > +1000.  At least on the KVM side, I would like to be as conservative as=
 possible
> > when it comes to letting anything other than the guest access guest_mem=
fd.
>
> So we'll have to do it similar to any occurrences of "secretmem" in
> gup.c. We'll have to see how to marry KVM guest_memfd with core-mm code
> similar to e.g., folio_is_secretmem().
>
> IIRC, we might not be able to de-reference the actual mapping because it
> could get free concurrently ...
>
> That will then prohibit any kind of GUP access to these pages, including
> reading/writing for ptrace/debugging purposes, for core dumping purposes
> etc. But at least, you know that nobody was able to optain page
> references using GUP that might be used for reading/writing later.
>

There has been little discussion about supporting 1G pages with
guest_memfd for TDX/SNP or pKVM. I would like to restart this
discussion [1]. 1G pages should be a very important usecase for guest
memfd, especially considering large VM sizes supporting confidential
GPU/TPU workloads.

Using separate backing stores for private and shared memory ranges is
not going to work effectively when using 1G pages. Consider the
following scenario of memory conversion when using 1G pages to back
private memory:
* Guest requests conversion of 4KB range from private to shared, host
in response ideally does following steps:
    a) Updates the guest memory attributes
    b) Unbacks the corresponding private memory
    c) Allocates corresponding shared memory or let it be faulted in
when guest accesses it

Step b above can't be skipped here, otherwise we would have two
physical pages (1 backing private memory, another backing the shared
memory) for the same GPA range causing "double allocation".

With 1G pages, it would be difficult to punch KBs or even MBs sized
hole since to support that:
1G page would need to be split (which hugetlbfs doesn't support today
because of right reasons), causing -
        - loss of vmemmap optimization [3]
        - losing ability to reconstitute the huge page again,
especially as private pages in CVMs are not relocatable today,
increasing overall fragmentation over time.
              - unless a smarter algorithm is devised for memory
reclaim to reconstitute large pages for unmovable memory.

With the above limitations in place, best thing could be to allow:
 - single backing store for both shared and private memory ranges
 - host userspace to mmap the guest memfd (as this series is trying to do)
 - allow userspace to fault in memfd file ranges that correspond to
shared GPA ranges
     - pagetable mappings will need to be restricted to shared memory
ranges causing higher granularity mappings (somewhat similar to what
HGM series from James [2] was trying to do) than 1G.
 - Allow IOMMU also to map those pages (pfns would be requested using
get_user_pages* APIs) to allow devices to access shared memory. IOMMU
management code would have to be enlightened or somehow restricted to
map only shared regions of guest memfd.
 - Upon conversion from shared to private, host will have to ensure
that there are no mappings/references present for the memory ranges
being converted to private.

If the above usecase sounds reasonable, GUP access to guest memfd
pages should be allowed.

[1] https://lore.kernel.org/lkml/CAGtprH_H1afUJ2cUnznWqYLTZVuEcOogRwXF6uBAe=
HbLMQsrsQ@mail.gmail.com/
[2] https://lore.kernel.org/lkml/20230218002819.1486479-2-jthoughton@google=
.com/
[3] https://docs.kernel.org/mm/vmemmap_dedup.html



> --
> Cheers,
>
> David / dhildenb
>

