Return-Path: <kvm+bounces-46101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 320F0AB2095
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 02:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56E6A1BA1DDA
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 00:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA33212D67;
	Sat, 10 May 2025 00:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J8t84OcN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341BF19D071
	for <kvm@vger.kernel.org>; Sat, 10 May 2025 00:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746837683; cv=none; b=if5ssRTwndLNIcu2D1cj6UXBu3yUqeLsemgNZNMY0AFtaVyIQaKxDlGqMRF/r6pW4tAuYX53TVl78RhsIRvOmpQvvzy+MrpAAWIf3cYNJixdsv27k5AGvV28iq4Z3I9plbUFXKxh9zNXyOQaHegIaefsiNL9g/qiYULHUuq4pmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746837683; c=relaxed/simple;
	bh=73CHZ/lq1sMu5gZn1AeOKB8NNBFxh7Dkdc7JMuA6LdE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ahDYBHuJ8NiyYmdNAxXxelhKUOEtyw50oA0gYS97EoKWOaKcNj8TdIKVlWG4ItKX8Ct+5xfzeAXBmPBrj1NotjNr4UCwEqwy92tXfUhcY/DKaBIWoYKf/t9BTxuzVV32HkDMmp5ftDpMMoxWB0GDm9o6yu/uym5aJ3MkwmabRuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J8t84OcN; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22e1eafa891so73295ad.0
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 17:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746837681; x=1747442481; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBjonWDXiwuQILtTm7x6j214UCIpmModdeV3pdwiOBc=;
        b=J8t84OcNGeDWJ+cSg6yC6TLTMaLLpfr3r11WZAJAvcgAu3T3WkWJKNVr7DJiArdiS9
         Bnl8IoGON8FU3XU1YvNqZvGXZRmMiDM8XNbdaaYYOdelcFU1SbJkUvpZmPnHpiT95PGV
         ndmFcB7AVH7yCl7n0L019ISJmnZoElg2HuB9GQJrNHbCv6bp3ih+CjxuWS42F+EsYVh7
         Dktncy8CXDPFJguwvZgE8TiUMF7vbrgO4aTp2fCccfwNx4Wf4VtGgp05EqWQCf3rQ0BO
         EEn1Kjoc1skTeHpSRH10V5m1FIIyoE9e0w0pHRYrKr13RY4A9SmAXuzNkexW2wGdZBsw
         buaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746837681; x=1747442481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SBjonWDXiwuQILtTm7x6j214UCIpmModdeV3pdwiOBc=;
        b=szBFeT25UlopGdwFWtz6ZbpDZfHy1JKSTguAn0fzTnb2wsClF0aJKVdUpIwq4Jqlsm
         jfemqeUF8AGw9NrQQxVx0nqnrUhd4r/qEq4CINhRrGB+7p3SsfKfavky6VallseCUDQd
         93lAaDYsG5e3ytWdTAqR8G+8N5NsKZK1aBBOJHJfkuKoDnMOeOQbVNXUcqa526TL7XZn
         folexQygkReWiC/j83WgcYiEQAdMxckvYV/SP9TIJb+qy8aXYEyDs5R4nJ74HHhmTZmc
         tb0I5PN6evTYiX130y5XkQO7IN8xqQ8Fb3CmyP5nxWpCvGePnNKF1oLThXyU0sZhWGRu
         HbDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgvewoMmzyBqEpdjF2boeFZz11QwJHJx3p7z507sLY6AlPppoAABeoFgwh1yjm8uhDSws=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUQfw/bc1MMZ//pu6SNRjmtYkDcHpg9j8Qbavyjk9Q6WKoB7tO
	cwTgJPBJTCe71sCFc6Zmt4zeNR9BURCSBWB08x6gu3CN+dIXlJTIyQqHnQLP7IYPwVkpSFuhTwV
	yzOsME28rT6UpF3Lj86hQQBRG18bYMA/fanvx
X-Gm-Gg: ASbGncsV9D7z7cYVPx48a4MR4JZraiMXkMKUcCfZ35f9DZ2aQnGqbzOcMerUDyXp6a/
	dAIVdAqT8MTNKoBB/DKRmUcjfx2oZxdOI2mavKBMwS5DpqikEyUa5JOHXx/2PbZCNjZOnXfRpxr
	o4Njgm0bP4VdyViYuf6v4IkKR/XPQtJCqyTbhMs9g8yMMX6OEBPsS2sS8XNgF6tLgCTA==
X-Google-Smtp-Source: AGHT+IGz6/tGqcv09JHVcdip+PWSS/pI3uTDyapYVQeSj5kq9IPPE6er0FMBtSr5k1778akK9t5wu6TehjWbdJSuiK4=
X-Received: by 2002:a17:902:ecc9:b0:216:6ecd:8950 with SMTP id
 d9443c01a7336-22ff6e92954mr498655ad.19.1746837680928; Fri, 09 May 2025
 17:41:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com> <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
 <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com> <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
 <aBmmirBzOZfmMOJj@yzhao56-desk.sh.intel.com> <CAGtprH9fDMiuk3JGSS12M-wFoqRj+sjdtEHJFS_5QfKX7aGkRQ@mail.gmail.com>
 <aBsNsZsWuVl4uo0j@yzhao56-desk.sh.intel.com> <CAGtprH-+Bo4hFxL+THiMgF5V4imdVVb0OmRhx2Uc0eom9=3JPA@mail.gmail.com>
 <aBwJHE/zRDvV41fH@yzhao56-desk.sh.intel.com> <CAGtprH9hwj7BvSm4DgRkHmdPnmi-1-FMH5Z7xK1VBh=s4W8VYA@mail.gmail.com>
 <aB10gNcmsw0TSrqh@yzhao56-desk.sh.intel.com> <CAGtprH8=-70DU2e52OJe=w0HfuW5Zg6wGHV32FWD_hQzYBa=fA@mail.gmail.com>
 <8d8f4d0ec970fc7c16341ee994d177d9e042c860.camel@intel.com>
In-Reply-To: <8d8f4d0ec970fc7c16341ee994d177d9e042c860.camel@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 9 May 2025 17:41:06 -0700
X-Gm-Features: ATxdqUFkjNsyopjZSsChhmV3FeqMlTB5k3Xs3nRCEQhvIc667JWsLMcn9mx-uM8
Message-ID: <CAGtprH8sn48pNC29SSNqCCV88O8mjU1JiOFvLbLrm_7LGjGRuQ@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>, 
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "Du, Fan" <fan.du@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 9, 2025 at 4:45=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
>
> On Fri, 2025-05-09 at 07:20 -0700, Vishal Annapurve wrote:
> > I might be wrongly throwing out some terminologies here then.
> > VM_PFNMAP flag can be set for memory backed by folios/page structs.
> > udmabuf seems to be working with pinned "folios" in the backend.
> >
> > The goal is to get to a stage where guest_memfd is backed by pfn
> > ranges unmanaged by kernel that guest_memfd owns and distributes to
> > userspace, KVM, IOMMU subject to shareability attributes. if the
> > shareability changes, the users will get notified and will have to
> > invalidate their mappings. guest_memfd will allow mmaping such ranges
> > with VM_PFNMAP flag set by default in the VMAs to indicate the need of
> > special handling/lack of page structs.
>
> I see the point about how operating on PFNs can allow smoother transition=
 to a
> solution that saves struct page memory, but I wonder about the wisdom of
> building this 2MB TDX code against eventual goals.

This discussion was more in response to a few questions from Yan [1].

My point of this discussion was to ensure that:
1) There is more awareness about the future roadmap.
2) There is a line of sight towards supporting guest memory (at least
guest private memory) without page structs.

No need to solve these problems right away, but it would be good to
ensure that the design choices are aligned towards the future
direction.

One thing that needs to be resolved right away is - no refcounts on
guest memory from outside guest_memfd [2]. (Discounting the error
situations)

[1] https://lore.kernel.org/lkml/aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com=
/
[2] https://lore.kernel.org/lkml/CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=3Dh2j=
ry-NRD7_6OA@mail.gmail.com/

>
> We were thinking to enable 2MB TDX huge pages on top of:
> 1. Mmap shared pages
> 2. In-place conversion
> 3. 2MB huge page support
>
> Where do you think struct page-less guestmemfd fits in that roadmap?

Ideally the roadmap should be:
1. mmap support
2. Huge page support in guest memfd with in-place conversion
3. 2MB huge page EPT mappings support
4. private memory without page structs
5. private/shared memory without page structs

There should be newer RFC series landing soon for 1 and 2. In my
opinion, as long as hugepage EPT support is reviewed, tested and is
stable enough, it can land upstream sooner than 2 as well.

>
> >
> > As an intermediate stage, it makes sense to me to just not have
> > private memory backed by page structs and use a special "filemap" to
> > map file offsets to these private memory ranges. This step will also
> > need similar contract with users -
> >    1) memory is pinned by guest_memfd
> >    2) users will get invalidation notifiers on shareability changes
> >
> > I am sure there is a lot of work here and many quirks to be addressed,
> > let's discuss this more with better context around. A few related RFC
> > series are planned to be posted in the near future.
>
> Look forward to collecting more context, and thanks for your patience whi=
le we
> catch up. But why not an iterative approach? We can't save struct page me=
mory on
> guestmemfd huge pages until we have guestmemfd huge pages.

