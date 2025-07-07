Return-Path: <kvm+bounces-51691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 506EBAFBA61
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 20:09:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C76D4A539C
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 18:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1652F264A86;
	Mon,  7 Jul 2025 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e041tUKA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF39194C96
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 18:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751911780; cv=none; b=nGxriFpOdAOYHB+1/7UZIWsaRkvQL1J7fOT5hksLjpnbxMFgVRG1WKEo2qh9BCE9lXH5tUJtrzZX0CJ/TWl7vF2BsTNmlQjV4iIGwXsMfs0RkrCu7XaN3GZ7olvoTGbN3lQqGMG4pYclMj6iWw6AyejKQQhe73qHvaBswYZEu7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751911780; c=relaxed/simple;
	bh=PXvVCyvgHb0eHBfQ0bThDfdbXMaikQlhmHXanhLrTdw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CAXoIHOL37UmlYADu7195WdhAzuaobPr974Gegx0FBCSEzo+XMCWsiLTYeF3V4dprVu/xRLKEaqOag28x6oK079zVW3wC0j8H0Y8PSx8k3BIUadGyZ0OTjbTRY66QpQtyQglBY1c27haKbH4dS0gKePxHP042Ip7Z8V1oWNjxow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e041tUKA; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-711d4689084so33883247b3.0
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 11:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751911777; x=1752516577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXvVCyvgHb0eHBfQ0bThDfdbXMaikQlhmHXanhLrTdw=;
        b=e041tUKA2RUHgU1A/PX4XENmCCATfpqbwVkWm5XRnZrNUQer4xIieucZloUvC3yi3A
         66c0RhmtEP1awHOlmIF4N/bdUm/Qz+lPEHL17Wrc6JLDnr+p6ZGR8ID1TwV5JqvS/krG
         FKSn7LUMkBvY3kUMdciO59x/1JjG6Tk4KJji+Y2z0lzFu5K93LTbzBfU9IecKiT0UGOJ
         C6kzP4haB/GassxPnZQVNqlOqc2PVE4SExdpFdM4iMZbDCymhfxERzB+koaMivXipUNM
         PsIQryNkN+T3PA2V0rlaFpe0NIOP146z+bIZrR68DDeUAfY0htR3YnLX5zcDu2t1bVqH
         ovoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751911777; x=1752516577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PXvVCyvgHb0eHBfQ0bThDfdbXMaikQlhmHXanhLrTdw=;
        b=igwl+PJpDJpao8M80axf3Iv0mTnO97sEifmDAyF/PieRv0xriiGie/awyrEsRVQLqP
         ebAAoMOrcZRngdedDIavcDbkjrwiKK0bWgjMBsGSyVWuS1QGTEzp6cIbpE19LELr/pOA
         9iYUr0sVfR2hUIg4dopi0mfdM/UyQaQJuA75JEz1IIEDoZ+q9OGr8Z9mRhuuAyj5voVx
         IArcpV0Jv7iAPFou5B8eWouXbTlYkiWtRMC9Qtgm4PdfIO3Hsf6xQw/B2kllqYnCjd6a
         zABRTZYa7vOwz+4Q4rXdIoSmhpwcLRMp6NDETZtBI2UjVOWdqHcrqbTvaITXRS+f8oRJ
         hZtA==
X-Gm-Message-State: AOJu0YxBKMpr4BwXxwylir8+9VbI6WJqzs9JK+7mG6f5dkk7Z4SATEEO
	/YPLJz3CLJXQiQZUeGuOy6Dh03aDKrBvjmVHB6nnDzWEwLbFf/s0kQe5y8mEnPoyJq/4/9OFoMr
	5C8BzmRGxmg8JJva0Gf7M+1dw9cuZMxZKhXue5L4NaFtxFDk1Q5+aUBvnuZPXXA==
X-Gm-Gg: ASbGnctgrlJ42Suj+F0V/lA5naGbvFhyIlcFKOiq9PazA6wNdMZE0qIuya9HVU+EVy9
	KQAvweQ57rx3zQhUqz8dFIsgdMudazsZH8KgqvHDUXnSYyz4FmE8Zq9LI8P8guoLW9dyM+axwOf
	5tsSLtbeWo2PPpnJmG7AdCsNGRcP3pXrfwt+TdS4cNFBM7Gkvh04QDOXGRkGshMS8ltOxKS3WAH
	g==
X-Google-Smtp-Source: AGHT+IHw3HaZiyB/1y8CtGslDwQWQzV0+e50NJs7lEmDy5dHXsDu2ggjTmBQ1yT/1DSW6T5pgUsirP3gLE9OKHg0VWE=
X-Received: by 2002:a05:690c:941c:b0:714:583:6d05 with SMTP id
 00721157ae682-7179e42c376mr6996117b3.32.1751911777302; Mon, 07 Jul 2025
 11:09:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <782bb82a0d2d62b616daebb77dc3d9e345fb76fa.1747264138.git.ackerleytng@google.com>
In-Reply-To: <782bb82a0d2d62b616daebb77dc3d9e345fb76fa.1747264138.git.ackerleytng@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 7 Jul 2025 11:08:59 -0700
X-Gm-Features: Ac12FXwKcvqRRUd0nsd7X92g5DnBajTeAMgxLisNdzU_VSoAb0b8Kq03tT52h7g
Message-ID: <CADrL8HW-vMqkocOxWURRB5vdi+Amx5QE6sNQOJx4hpD5L2rp5w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 18/51] mm: hugetlb: Cleanup interpretation of
 map_chg_state within alloc_hugetlb_folio()
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jun.miao@intel.com, kai.huang@intel.com, 
	keirf@google.com, kent.overstreet@linux.dev, kirill.shutemov@intel.com, 
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com, 
	mail@maciej.szmigiero.name, maz@kernel.org, mic@digikod.net, 
	michael.roth@amd.com, mpe@ellerman.id.au, muchun.song@linux.dev, 
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev, palmer@dabbelt.com, 
	pankaj.gupta@amd.com, paul.walmsley@sifive.com, pbonzini@redhat.com, 
	pdurrant@amazon.co.uk, peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, 
	qperret@google.com, quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, seanjc@google.com, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 4:43=E2=80=AFPM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>
> Interpreting map_chg_state inline, within alloc_hugetlb_folio(),
> improves readability.
>
> Instead of having cow_from_owner and the result of
> vma_needs_reservation() compute a map_chg_state, and then interpreting
> map_chg_state within alloc_hugetlb_folio() to determine whether to
>
> + Get a page from the subpool or
> + Charge cgroup reservations or
> + Commit vma reservations or
> + Clean up reservations
>
> This refactoring makes those decisions just based on whether a
> vma_reservation_exists. If a vma_reservation_exists, the subpool had
> already been debited and the cgroup had been charged, hence
> alloc_hugetlb_folio() should not double-debit or double-charge. If the
> vma reservation can't be used (as in cow_from_owner), then the vma
> reservation effectively does not exist and vma_reservation_exists is
> set to false.
>
> The conditions for committing reservations or cleaning are also
> updated to be paired with the corresponding conditions guarding
> reservation creation.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Change-Id: I22d72a2cae61fb64dc78e0a870b254811a06a31e

Hi Ackerley,

Can you help me better understand how useful the refactors in this and
the preceding patch are for the series as a whole?

It seems like you and Peter had two different, but mostly equivalent,
directions with how this code should be refactored[1]. Do you gain
much by replacing Peter's refactoring strategy? If it's mostly a
stylistic thing, maybe it would be better to remove these patches just
to get the number of patches to review down.

The logic in these two patches looks good to me, and I think I do
slightly prefer your approach. But if we could drop these patches
(i.e., mail them separately), that's probably better.

[1]: https://lore.kernel.org/linux-mm/20250107204002.2683356-5-peterx@redha=
t.com/

