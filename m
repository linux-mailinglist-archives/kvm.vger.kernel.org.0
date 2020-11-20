Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148D92BA5D9
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 10:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbgKTJSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 04:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgKTJSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 04:18:41 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A53C061A04
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 01:18:40 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id o3so8110920ota.8
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 01:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OtrYQoEiROvCqqv4Jka4JIhMwLKRXKEHuB2b3PjkDRI=;
        b=H9pmf4taWGwhJj0TCPHRqUSjU70cWnKJjp7fPbvY9crHvLcESWQq3LyuXCxK4oLrKU
         cE0KMzfuWCfbRfL+I6J1/V6V741Gq4+hcyfquL+KRX7CcWHTILWoG6kc2xEtShyJEd6T
         7BjZeDAZNI4WxIxvtHfYIUlI9hmefqlvmBIDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OtrYQoEiROvCqqv4Jka4JIhMwLKRXKEHuB2b3PjkDRI=;
        b=DVCiemaC1Rp5MxJcd8ECyruaSqmf+fSlljUEGGq5pymKfWGqAgGZNHEzzrQmmdhzf8
         3XRk9R/74i+BHgJMgKEBP5UYix8UbaLN99avx8BI/yynsw12wOgBh9WubSvEMEvVqbfA
         Ww2Wty+mtGvw0k8O9s8COoWuCrEtYAb3h1oDwWjXuDNPgp5v2qsngemhXfCBjmuIuu1K
         GxMRYcijeMURFISPLygesg96dWS00k0//r3EcGN6agYoX4ko70tKxS43p7uA065yKFuw
         U8+cN0Gwnw9TyNuaUg2Sveu9hF1mhfXdUqE2ZGPxgrg5WQtgDufAjCxGRNtBjxUIbJMn
         sm0w==
X-Gm-Message-State: AOAM530ftzNjIioPae5Saqo4HxjU209vF3oZq4cJrQa4kaFP9KMYh5jx
        cjk6fQgI59PYX+XYNN0l11vl27GN3/cg+UDADUp9PQ==
X-Google-Smtp-Source: ABdhPJwRO5d84BxTeYThG2QPCXAsJdc+1sEa8OQumtyte52NF7Ay2wUea1iF99xa2TqGcNyZBAN0DrcCHGfwp68L+Co=
X-Received: by 2002:a05:6830:3155:: with SMTP id c21mr13756463ots.281.1605863919326;
 Fri, 20 Nov 2020 01:18:39 -0800 (PST)
MIME-Version: 1.0
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
 <20201119144146.1045202-10-daniel.vetter@ffwll.ch> <f1f3a1d8-d62a-6e93-afc1-87a8e51081e9@xs4all.nl>
 <e1f7d30b-2012-0249-66c7-cf9d7d6246ad@xs4all.nl>
In-Reply-To: <e1f7d30b-2012-0249-66c7-cf9d7d6246ad@xs4all.nl>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 20 Nov 2020 10:18:27 +0100
Message-ID: <CAKMK7uEzFAtr9yxjaxi-kiuZhb+hWT3q6E41OegJr+J2-zkT8w@mail.gmail.com>
Subject: Re: [PATCH v6 09/17] media/videbuf1|2: Mark follow_pfn usage as unsafe
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 20, 2020 at 9:28 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 20/11/2020 09:06, Hans Verkuil wrote:
> > On 19/11/2020 15:41, Daniel Vetter wrote:
> >> The media model assumes that buffers are all preallocated, so that
> >> when a media pipeline is running we never miss a deadline because the
> >> buffers aren't allocated or available.
> >>
> >> This means we cannot fix the v4l follow_pfn usage through
> >> mmu_notifier, without breaking how this all works. The only real fix
> >> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
> >> tell everyone to cut over to dma-buf memory sharing for zerocopy.
> >>
> >> userptr for normal memory will keep working as-is, this only affects
> >> the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
> >> videobuf2-dma-sg: Support io userptr operations on io memory").
> >>
> >> Acked-by: Tomasz Figa <tfiga@chromium.org>
> >
> > Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>
> Actually, cancel this Acked-by.
>
> So let me see if I understand this right: VM_IO | VM_PFNMAP mappings can
> move around. There is a mmu_notifier that can be used to be notified when
> that happens, but that can't be used with media buffers since those buffe=
rs
> must always be available and in the same place.
>
> So follow_pfn is replaced by unsafe_follow_pfn to signal that what is att=
empted
> is unsafe and unreliable.
>
> If CONFIG_STRICT_FOLLOW_PFN is set, then unsafe_follow_pfn will fail, if =
it
> is unset, then it writes a warning to the kernel log but just continues w=
hile
> still unsafe.
>
> I am very much inclined to just drop VM_IO | VM_PFNMAP support in the med=
ia
> subsystem. For vb2 there is a working alternative in the form of dmabuf, =
and
> frankly for vb1 I don't care. If someone really needs this for a vb1 driv=
er,
> then they can do the work to convert that driver to vb2.
>
> I've added Mauro to the CC list and I'll ping a few more people to see wh=
at
> they think, but in my opinion support for USERPTR + VM_IO | VM_PFNMAP
> should just be killed off.
>
> If others would like to keep it, then frame_vector.c needs a comment befo=
re
> the 'while' explaining why the unsafe_follow_pfn is there and that using
> dmabuf is the proper alternative to use. That will make it easier for
> developers to figure out why they see a kernel warning and what to do to
> fix it, rather than having to dig through the git history for the reason.

I'm happy to add a comment, but otherwise if you all want to ditch
this, can we do this as a follow up on top? There's quite a bit of
code that can be deleted and I'd like to not hold up this patch set
here on that - it's already a fairly sprawling pain touching about 7
different subsystems (ok only 6-ish now since the s390 patch landed).
For the comment, is the explanation next to unsafe_follow_pfn not good
enough?

So ... can I get you to un-cancel your ack?

Thanks, Daniel

>
> Regards,
>
>         Hans
>
> >
> > Thanks!
> >
> >       Hans
> >
> >> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> >> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> >> Cc: Kees Cook <keescook@chromium.org>
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: John Hubbard <jhubbard@nvidia.com>
> >> Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
> >> Cc: Jan Kara <jack@suse.cz>
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Cc: linux-mm@kvack.org
> >> Cc: linux-arm-kernel@lists.infradead.org
> >> Cc: linux-samsung-soc@vger.kernel.org
> >> Cc: linux-media@vger.kernel.org
> >> Cc: Pawel Osciak <pawel@osciak.com>
> >> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> >> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> >> Cc: Tomasz Figa <tfiga@chromium.org>
> >> Cc: Laurent Dufour <ldufour@linux.ibm.com>
> >> Cc: Vlastimil Babka <vbabka@suse.cz>
> >> Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> >> Cc: Michel Lespinasse <walken@google.com>
> >> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> --
> >> v3:
> >> - Reference the commit that enabled the zerocopy userptr use case to
> >>   make it abundandtly clear that this patch only affects that, and not
> >>   normal memory userptr. The old commit message already explained that
> >>   normal memory userptr is unaffected, but I guess that was not clear
> >>   enough.
> >> ---
> >>  drivers/media/common/videobuf2/frame_vector.c | 2 +-
> >>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
> >>  2 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/media/common/videobuf2/frame_vector.c b/drivers/m=
edia/common/videobuf2/frame_vector.c
> >> index a0e65481a201..1a82ec13ea00 100644
> >> --- a/drivers/media/common/videobuf2/frame_vector.c
> >> +++ b/drivers/media/common/videobuf2/frame_vector.c
> >> @@ -70,7 +70,7 @@ int get_vaddr_frames(unsigned long start, unsigned i=
nt nr_frames,
> >>                      break;
> >>
> >>              while (ret < nr_frames && start + PAGE_SIZE <=3D vma->vm_=
end) {
> >> -                    err =3D follow_pfn(vma, start, &nums[ret]);
> >> +                    err =3D unsafe_follow_pfn(vma, start, &nums[ret])=
;
> >>                      if (err) {
> >>                              if (ret =3D=3D 0)
> >>                                      ret =3D err;
> >> diff --git a/drivers/media/v4l2-core/videobuf-dma-contig.c b/drivers/m=
edia/v4l2-core/videobuf-dma-contig.c
> >> index 52312ce2ba05..821c4a76ab96 100644
> >> --- a/drivers/media/v4l2-core/videobuf-dma-contig.c
> >> +++ b/drivers/media/v4l2-core/videobuf-dma-contig.c
> >> @@ -183,7 +183,7 @@ static int videobuf_dma_contig_user_get(struct vid=
eobuf_dma_contig_memory *mem,
> >>      user_address =3D untagged_baddr;
> >>
> >>      while (pages_done < (mem->size >> PAGE_SHIFT)) {
> >> -            ret =3D follow_pfn(vma, user_address, &this_pfn);
> >> +            ret =3D unsafe_follow_pfn(vma, user_address, &this_pfn);
> >>              if (ret)
> >>                      break;
> >>
> >>
> >
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
