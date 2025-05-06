Return-Path: <kvm+bounces-45557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3B4AABAA7
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4A2117DA4B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD1B287508;
	Tue,  6 May 2025 05:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jeYtJG+M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88A3280033
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 05:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746508119; cv=none; b=AzbfTV3zxUDLxoFQLzCmjh/dFX2PxSQKSEh25Mq6DUoXjCeTyNXvsBQweDnnf7NAp8XexQC33fK6ziP+6XMT+Fdp3AoB/6cMQ8lUIbTGFttmtAe8DvySIEYCQAnMMldcVGnT1LdRRLhQ57Ez+SR+Cfz0PnrRCd4tE1e3VH7NuDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746508119; c=relaxed/simple;
	bh=rUsBS9Oa+C0VRUO/HZpkAD8ejfWfMt7BVTl5jvD7mZc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H6yET6/lXZnEKHaDdyb3fU5qa+RgtP7kXvi853tbAkYcewB6hwJcuBZsahiDsnmtCYdlbqdybkCw2t/gDp4V3jwLPuW/CsCfWHoMlt/mGpjnEJQIb05A/Qa3ujA5/ePKidsd914NJvuL/whOQh77WOuRBzTL2Bm9PDSnU2KEywg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jeYtJG+M; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22e1eafa891so101165ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 22:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746508117; x=1747112917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rUsBS9Oa+C0VRUO/HZpkAD8ejfWfMt7BVTl5jvD7mZc=;
        b=jeYtJG+MZSSqtKmZPbzmlq7/N4upIBK5yre7j04KIS6ownbMsnnQlpd++8c+WGxbxj
         hFsSBhw9XmLNPB4/+UOVRWUoxbu8cmcM2FeAZb7/tWzFB1cERWFesIUFyKAF2yMy7z4R
         j4mFkofmfh1PTruqA7veDWeTP2rZy2OjNZUgV1+IBCMDuGzj+TDHT+8TUtKwJQuPcJQ0
         UKfdEK0WCO/514p84iYlrWlgQOPkccfSO5/NSxY9PJ2pGAw+eZfVm6L4f1bG0+4ShZQH
         bQNGhWsBLQ7dnV17m2c4g7aCktBMw5M52adpTt4nY7gsmcbZizJvaNqy3lwRD4K0PBfN
         J1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746508117; x=1747112917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rUsBS9Oa+C0VRUO/HZpkAD8ejfWfMt7BVTl5jvD7mZc=;
        b=WddR6XpVoqb0YjCh0mlwGoSPgZOTVQEvsMTZxHM53RUHh1VbPHL5U7pBnhlKOjp+Rd
         CubAe9IZhe4T6tmXob36CAVVgAbQv5MadMWk9D3CjOAuAaWoGij8r41oVvO6m3Rv+kCG
         3rX0W8K1iQf+ZwYnY2ClEr/u8q4MijzrOf72usUOmgyYFDJiBRmnay0v2uacWf4stm9Y
         HL6wY9WogZ5PBbc0HkUKiHxFbeDlklM9C6+MbrN1/UKMF1h9AcS5oQr29VjRebDmDr8k
         4qiPX8lc7XiUujgzIWX/jSnVKOMOzUWkp4sfZx+i8A4b+taD1ivhU7UTEd7ezwy14yxB
         IaMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcuYqR4pPkJL7/nzGL2dDzGI2nR80Zv2YonX+5BSOuZw3VceoCtuvkkfz7LUz2Zcmqdrc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbuCk9YCEMplKEIdowushhFYU/ST3luPi1CicJVY8OLJCYaTwG
	AUx+Yj9UPr8XciX9KsfauIVh3q1BX0U8eS6wHakYd0sDyzEh/6kQvLbSjH5cBTF8V6+xZGfG4EH
	UjDHPXjNrlPvO0M328gUvN5TCR2AP+fQiZmsV
X-Gm-Gg: ASbGncuOb03GbS3eeG3E9W/dRuP+0FY/6ni0RGIfiwuNk4sJGOHl4yqzW3BiBPGJLvj
	8S9++2WgchmPKVGFSoLSPvyPkPvpdQjurdfNttx3P7zTuGoH+wQmo5Ce7ilBxb1oUY2bb5b202v
	nEUTV6AINC0MjkPL4ZpKjeNyNEJoHJv843T4REkI8vO6E+NlzyuLSD748=
X-Google-Smtp-Source: AGHT+IEkmVHrS+IeESYp9Bj0DUHQ0GCYSuq6HTfd9DWzMVCD5BSFldlOTCzMt/mb/B9tNXB4lUPvZrR+FyGxHBMd0tI=
X-Received: by 2002:a17:903:32c1:b0:220:c905:689f with SMTP id
 d9443c01a7336-22e3b2cf6a1mr1180265ad.25.1746508116581; Mon, 05 May 2025
 22:08:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250424030033.32635-1-yan.y.zhao@intel.com> <20250424030603.329-1-yan.y.zhao@intel.com>
 <CAGtprH9_McMDepbuvWMLRvHooPdtE4RHog=Dgr_zFXT5s49nXA@mail.gmail.com>
 <aBAiCBmON0g0Qro1@yzhao56-desk.sh.intel.com> <CAGtprH_ggm8N-R9QbV1f8mo8-cQkqyEta3W=h2jry-NRD7_6OA@mail.gmail.com>
 <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com>
In-Reply-To: <aBldhnTK93+eKcMq@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 5 May 2025 22:08:24 -0700
X-Gm-Features: ATxdqUG39x19IjwosYztIXaovUZ6HU5KeKyPyCUt-tTIluSky-qf1VEpEVHS-Wg
Message-ID: <CAGtprH9wi6zHJ5JeuAnjZThMAzxxibJGo=XN1G1Nx8txZRg8_w@mail.gmail.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge pages
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com, 
	dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com, 
	ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com, 
	david@redhat.com, vbabka@suse.cz, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, zhiquan1.li@intel.com, fan.du@intel.com, 
	jun.miao@intel.com, ira.weiny@intel.com, isaku.yamahata@intel.com, 
	xiaoyao.li@intel.com, binbin.wu@linux.intel.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 5:56=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> Sorry for the late reply, I was on leave last week.
>
> On Tue, Apr 29, 2025 at 06:46:59AM -0700, Vishal Annapurve wrote:
> > On Mon, Apr 28, 2025 at 5:52=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com>=
 wrote:
> > > So, we plan to remove folio_ref_add()/folio_put_refs() in future, onl=
y invoking
> > > folio_ref_add() in the event of a removal failure.
> >
> > In my opinion, the above scheme can be deployed with this series
> > itself. guest_memfd will not take away memory from TDX VMs without an
> I initially intended to add a separate patch at the end of this series to
> implement invoking folio_ref_add() only upon a removal failure. However, =
I
> decided against it since it's not a must before guest_memfd supports in-p=
lace
> conversion.
>
> We can include it in the next version If you think it's better.

Ackerley is planning to send out a series for 1G Hugetlb support with
guest memfd soon, hopefully this week. Plus I don't see any reason to
hold extra refcounts in TDX stack so it would be good to clean up this
logic.

>
> > invalidation. folio_ref_add() will not work for memory not backed by
> > page structs, but that problem can be solved in future possibly by
> With current TDX code, all memory must be backed by a page struct.
> Both tdh_mem_page_add() and tdh_mem_page_aug() require a "struct page *" =
rather
> than a pfn.
>
> > notifying guest_memfd of certain ranges being in use even after
> > invalidation completes.
> A curious question:
> To support memory not backed by page structs in future, is there any coun=
terpart
> to the page struct to hold ref count and map count?
>

I imagine the needed support will match similar semantics as VM_PFNMAP
[1] memory. No need to maintain refcounts/map counts for such physical
memory ranges as all users will be notified when mappings are
changed/removed.

Any guest_memfd range updates will result in invalidations/updates of
userspace, guest, IOMMU or any other page tables referring to
guest_memfd backed pfns. This story will become clearer once the
support for PFN range allocator for backing guest_memfd starts getting
discussed.

[1] https://elixir.bootlin.com/linux/v6.14.5/source/mm/memory.c#L6543

