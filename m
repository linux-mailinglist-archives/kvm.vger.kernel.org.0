Return-Path: <kvm+bounces-25403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B6DC0964EAF
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 21:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC0EA1C22068
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 19:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C17F91B8E93;
	Thu, 29 Aug 2024 19:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ORwYCAlE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC841B6542
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 19:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724959317; cv=none; b=PikwnNT6o+XB7PvHhI0kuLnjoRmThx0jc3kxHo58861vXA+s1i9GCADTHPM3B9umkkcVPjBZAOK89OHt0D+qtIoFU3cJavspnX9YAq/HyA3N0C1YOrJRqKFPpJRFibH15/HJatoi+n3XSNyFNDc3EiT9F4DBdEawUFXdpUxTX7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724959317; c=relaxed/simple;
	bh=XEdd/HsBepXNYvDiQ9Af7TG7vQwNFjie6noIbGQcL5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T6qOHJHhT+sRkpqVue4PEAgB+hok+3EF/NwGH2POHsYYW/kKwNIGgI7JGUCQGzflh1XLnhH6A0RoS6SwtvZ1Fu/jkuRBz5DuP85efTDMuuimudb+dqOFD51C2XM5PHWCAxBL5u7G5A509b8RPgBtw5hf5KTF8peX6C5JWISIR5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ORwYCAlE; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5334491702cso827e87.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724959313; x=1725564113; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XtYmS9ziQ+XBhfl3YdNZ87YkAlH4hGP3vnWtNfxEJKQ=;
        b=ORwYCAlE/6u+HwMuz6OEKH+58TgadKxgH5HomB3k3WwQJOY9eUkGQbnRFaXcZcauW1
         5K025Ycr3kBL3L56wKc9f5JZruQwI8X84sfO4beHhGz49cCV5JWs9P8oGXXW1VFPNEGH
         aI/uvJ9bpASRtzYh4Cyg7S/PPCjXwVZ/310FF75sJyOsHV930S+3WNGW44Hp2RiDmuVZ
         wRTAsZutqsMcUgovTayAw/WfpX7QClQgOPauASWj9HCpaDfJam19UM2F9U+NhS5RKWa3
         TOEAtb928w4WBEzgtV+koDVZqo5a09AYx8gGR98IiKX9CGJHzQUrGbaD4p0HIG0sh2lV
         bUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724959313; x=1725564113;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XtYmS9ziQ+XBhfl3YdNZ87YkAlH4hGP3vnWtNfxEJKQ=;
        b=wv9yzWBQwV3icZZ2qdwbyyR1/fFqnc30cIYC8/1Sc6LaeEflGB7fcCO/qK9ZLN6NPE
         r6ul6EtPLTjTlr4r5BbbqeBOBr3HGX0An6TU+mkwnn+L9IEzt2mxD+Sh0w7AWp+QHa5c
         Q0ObyM5/RBHoRiqz/83BA/fH2Lv8idtOgLLrSMgLPn5Hrc/j3t3IgbrmCT+pL+DOtRYa
         9qQoo+FcppjV17Orb14x0KQ9m99Tk0BCTSQ1uiikOAUGDYmKM9bvGkpcjMsfpa7v/lFK
         V/YLwB+NR6GZQhZJqGK3YsA4Pu7qBf//HxCZT1NdIBcNymSSkraN6vmzAuXUfSNlL5JW
         CKbA==
X-Forwarded-Encrypted: i=1; AJvYcCWEC0gcFXDVtZZoGFEYz8+zIidHGV/yzvxI3T1L/hEJ0Pg+Itzw/B6q+vBtNdNb4ItIX2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIGuy8KAvKjSSjT7Je5kYHhkU1Stddc/CNVo4k5FvMDDUJBj2p
	RmIstpWtExMF99Rwok5/XXSPS5vqw3GJXGxUfB976nBbZ9NgCI7yoqzS8OpJqgqTy2un1TtIhOb
	g06FLLXBYU8L3zBoWJwbHIMwcMEpz3+eWjnwK
X-Google-Smtp-Source: AGHT+IGPGsmRJGrjlfmPy0Q890/rIIpu+Epc0j8/i49ZLk24mfPdNhJtw1ZZE/u7EAIS8O2vn2KBYv7g9erpJjM6yjo=
X-Received: by 2002:a05:6512:3a8e:b0:533:4620:ebe6 with SMTP id
 2adb3069b0e04-535455b9261mr19389e87.4.1724959313018; Thu, 29 Aug 2024
 12:21:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240826204353.2228736-1-peterx@redhat.com> <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n> <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
 <20240828142422.GU3773488@nvidia.com> <CACw3F53QfJ4anR0Fk=MHJv8ad_vcG-575DX=bp7mfPpzLgUxbQ@mail.gmail.com>
 <20240828234958.GE3773488@nvidia.com>
In-Reply-To: <20240828234958.GE3773488@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 29 Aug 2024 12:21:39 -0700
Message-ID: <CACw3F52dyiAyo1ijKfLUGLbh+kquwoUhGMwg4-RObSDvqxreJw@mail.gmail.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Gavin Shan <gshan@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, 
	Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Sean Christopherson <seanjc@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Hildenbrand <david@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Alex Williamson <alex.williamson@redhat.com>, 
	ankita@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 4:50=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Wed, Aug 28, 2024 at 09:10:34AM -0700, Jiaqi Yan wrote:
> > On Wed, Aug 28, 2024 at 7:24=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com=
> wrote:
> > >
> > > On Tue, Aug 27, 2024 at 05:42:21PM -0700, Jiaqi Yan wrote:
> > >
> > > > Instead of removing the whole pud, can driver or memory_failure do
> > > > something similar to non-struct-page-version of split_huge_page? So
> > > > driver doesn't need to re-fault good pages back?
> > >
> > > It would be far nicer if we didn't have to poke a hole in a 1G mappin=
g
> > > just for memory failure reporting.
> >
> > If I follow this, which of the following sounds better? 1. remove pud
> > and rely on the driver to re-fault PFNs that it knows are not poisoned
> > (what Peter suggested), or 2. keep the pud and allow access to both
> > good and bad PFNs.
>
> In practice I think people will need 2, as breaking up a 1G mapping
> just because a few bits are bad will destroy the VM performance.
>

Totally agreed.

> For this the expectation would be for the VM to co-operate and not
> keep causing memory failures, or perhaps for the platform to spare in
> good memory somehow.

Yes, whether a VM gets into a memory-error-consumption loop
maliciously or accidentally, a reasonable VMM should have means to
detect and break it.

>
> > Or provide some knob (configured by ?) so that kernel + driver can
> > switch between the two?
>
> This is also sounding reasonable, especially if we need some
> alternative protocol to signal userspace about the failed memory
> besides fault and SIGBUS.

To clarify, what on my mind is a knob say named
"sysctl_enable_hard_offline", configured by userspace.

To apply to Ankit's memory_failure_pfn patch[*]:

static int memory_failure_pfn(unsigned long pfn, int flags)
{
  struct interval_tree_node *node;
  int res =3D MF_FAILED;
  LIST_HEAD(tokill);

  mutex_lock(&pfn_space_lock);
   for (node =3D interval_tree_iter_first(&pfn_space_itree, pfn, pfn); node=
;
         node =3D interval_tree_iter_next(node, pfn, pfn)) {
    struct pfn_address_space *pfn_space =3D
      container_of(node, struct pfn_address_space, node);

    if (pfn_space->ops)
      pfn_space->ops->failure(pfn_space, pfn);

    collect_procs_pgoff(NULL, pfn_space->mapping, pfn, &tokill);

    if (sysctl_enable_hard_offline)
      unmap_mapping_range(pfn_space->mapping, pfn << PAGE_SHIFT,
                                             PAGE_SIZE, 0);

    res =3D MF_RECOVERED;
  }
  mutex_unlock(&pfn_space_lock);

  if (res =3D=3D MF_FAILED)
    return action_result(pfn, MF_MSG_PFN_MAP, res);

  flags |=3D MF_ACTION_REQUIRED | MF_MUST_KILL;
  kill_procs(&tokill, true, false, pfn, flags);

  return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
}

I think we still want to attempt to SIGBUS userspace, regardless of
doing unmap_mapping_range or not.

[*] https://lore.kernel.org/lkml/20231123003513.24292-2-ankita@nvidia.com/#=
t

>
> Jason

