Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F346C59C16A
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 16:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbiHVOLE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 10:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbiHVOLD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 10:11:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCA12627
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 07:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661177461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X2uShgSizptZrajnSXWdWy/DzzK5uu1vpmTZwlLsqw8=;
        b=UdIxlLm+fhRSc4yeA+By5cDUwri+Ex8PcfAe3x0/CL2FzBxyOPFekljVf7lVZ74bpqiusT
        luyuQ3HlDFJETTSwajZt3wNHjNye+LEkAkd/FjZrZLfmoZzpGxqJrr7XlPbTaytyy2L4DS
        ACw1uI2U/4bVtmdQpm80Kq5AUvFBZZY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-SitTk1waMhiN8fMSWyRiXA-1; Mon, 22 Aug 2022 10:11:00 -0400
X-MC-Unique: SitTk1waMhiN8fMSWyRiXA-1
Received: by mail-qk1-f200.google.com with SMTP id bi16-20020a05620a319000b006bc2334be53so1713988qkb.14
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 07:11:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=X2uShgSizptZrajnSXWdWy/DzzK5uu1vpmTZwlLsqw8=;
        b=nZbUEmYZ2LJYfNr426eYtsg2zgy3jxWjd/uh1m7Oubm3abejK06bptXsQkXR5rS4yu
         tH/Y65gfvDQGVly36e7toE+7AuoVvoP+MyxDHhOJ2q0O9nLnjBWwX+Y3FW4pLM6CE2Hz
         mPJmKwJc0lpB0Yv11x9C5N+QLSEzNbE2m73/nWSZ5yzJ8V3Zf3UijyWwLYuHRnbf+bOh
         xk4ZSr3mqdsPEXCtX0tEMyVRq5PHDJZb38Z/hlCI3CI9ROF1KaBDsGWOwab2gW7Mj5Ly
         EYTDlEUrQjmDo6oLQOc31v4FUERRhCqSpZdkjay+/UWJo+hsm0ubv/pwoWTM/joy5GK2
         SwEg==
X-Gm-Message-State: ACgBeo2GePJ8yIsW4GW+YPm71XjjJwVQSRXMwWSCGuIrcCQ8n13yvtBr
        7zBnNipOgMPLA0zyEtBrtWZE3DDGgPDO1ZCIjRuESEmqITVOcQqKro1wgoBQVVYJXkeppRxg56o
        rJAoZKZdR/y2N
X-Received: by 2002:a05:620a:bc3:b0:6a7:9e01:95ac with SMTP id s3-20020a05620a0bc300b006a79e0195acmr12771032qki.91.1661177459519;
        Mon, 22 Aug 2022 07:10:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6Q81+6KZjfmeiklX8+2y5Q7aXdyjYPcNKEVMQ/86HJlDYbRQBSpa49qa01I9iy9t47K7UYiw==
X-Received: by 2002:a05:620a:bc3:b0:6a7:9e01:95ac with SMTP id s3-20020a05620a0bc300b006a79e0195acmr12770993qki.91.1661177458994;
        Mon, 22 Aug 2022 07:10:58 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a248700b006bb0f9b89cfsm11573580qkn.87.2022.08.22.07.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 07:10:58 -0700 (PDT)
Date:   Mon, 22 Aug 2022 10:10:56 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Leonardo Bras Soares Passos <lsoaresp@redhat.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay
 kvm_vm_ioctl to the commit phase
Message-ID: <YwOOcC72KKABKgU+@xz-m1.local>
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com>
 <Yv6baJoNikyuZ38R@xz-m1.local>
 <CAJ6HWG6maoPjbP8T5qo=iXCbNeHu4dq3wHLKtRLahYKuJmMY-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJ6HWG6maoPjbP8T5qo=iXCbNeHu4dq3wHLKtRLahYKuJmMY-g@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 18, 2022 at 09:55:20PM -0300, Leonardo Bras Soares Passos wrote:
> On Thu, Aug 18, 2022 at 5:05 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Tue, Aug 16, 2022 at 06:12:50AM -0400, Emanuele Giuseppe Esposito wrote:
> > > +static void kvm_memory_region_node_add(KVMMemoryListener *kml,
> > > +                                       struct kvm_userspace_memory_region *mem)
> > > +{
> > > +    MemoryRegionNode *node;
> > > +
> > > +    node = g_malloc(sizeof(MemoryRegionNode));
> > > +    *node = (MemoryRegionNode) {
> > > +        .mem = mem,
> > > +    };
> >
> > Nit: direct assignment of struct looks okay, but maybe pointer assignment
> > is clearer (with g_malloc0?  Or iirc we're suggested to always use g_new0):
> >
> >   node = g_new0(MemoryRegionNode, 1);
> >   node->mem = mem;
> >
> > [...]
> >
> > > +/* for KVM_SET_USER_MEMORY_REGION_LIST */
> > > +struct kvm_userspace_memory_region_list {
> > > +     __u32 nent;
> > > +     __u32 flags;
> > > +     struct kvm_userspace_memory_region entries[0];
> > > +};
> > > +
> > >  /*
> > >   * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
> > >   * other bits are reserved for kvm internal use which are defined in
> > > @@ -1426,6 +1433,8 @@ struct kvm_vfio_spapr_tce {
> > >                                       struct kvm_userspace_memory_region)
> > >  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
> > >  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
> > > +#define KVM_SET_USER_MEMORY_REGION_LIST _IOW(KVMIO, 0x49, \
> > > +                                     struct kvm_userspace_memory_region_list)
> >
> > I think this is probably good enough, but just to provide the other small
> > (but may not be important) piece of puzzle here.  I wanted to think through
> > to understand better but I never did..
> >
> > For a quick look, please read the comment in kvm_set_phys_mem().
> >
> >                 /*
> >                  * NOTE: We should be aware of the fact that here we're only
> >                  * doing a best effort to sync dirty bits.  No matter whether
> >                  * we're using dirty log or dirty ring, we ignored two facts:
> >                  *
> >                  * (1) dirty bits can reside in hardware buffers (PML)
> >                  *
> >                  * (2) after we collected dirty bits here, pages can be dirtied
> >                  * again before we do the final KVM_SET_USER_MEMORY_REGION to
> >                  * remove the slot.
> >                  *
> >                  * Not easy.  Let's cross the fingers until it's fixed.
> >                  */
> >
> > One example is if we have 16G mem, we enable dirty tracking and we punch a
> > hole of 1G at offset 1G, it'll change from this:
> >
> >                      (a)
> >   |----------------- 16G -------------------|
> >
> > To this:
> >
> >      (b)    (c)              (d)
> >   |--1G--|XXXXXX|------------14G------------|
> >
> > Here (c) will be a 1G hole.
> >
> > With current code, the hole punching will del region (a) and add back
> > region (b) and (d).  After the new _LIST ioctl it'll be atomic and nicer.
> >
> > Here the question is if we're with dirty tracking it means for each region
> > we have a dirty bitmap.  Currently we do the best effort of doing below
> > sequence:
> >
> >   (1) fetching dirty bmap of (a)
> >   (2) delete region (a)
> >   (3) add region (b) (d)
> >
> > Here (a)'s dirty bmap is mostly kept as best effort, but still we'll lose
> > dirty pages written between step (1) and (2) (and actually if the write
> > comes within (2) and (3) I think it'll crash qemu, and iiuc that's what
> > we're going to fix..).
> >
> > So ideally the atomic op can be:
> >
> >   "atomically fetch dirty bmap for removed regions, remove regions, and add
> >    new regions"
> >
> > Rather than only:
> >
> >   "atomically remove regions, and add new regions"
> >
> > as what the new _LIST ioctl do.
> >
> > But... maybe that's not a real problem, at least I didn't know any report
> > showing issue with current code yet caused by losing of dirty bits during
> > step (1) and (2).  Neither do I know how to trigger an issue with it.
> >
> > I'm just trying to still provide this information so that you should be
> > aware of this problem too, at the meantime when proposing the new ioctl
> > change for qemu we should also keep in mind that we won't easily lose the
> > dirty bmap of (a) here, which I think this patch does the right thing.
> >
> 
> Thanks for bringing these details Peter!
> 
> What do you think of adding?
> (4) Copy the corresponding part of (a)'s dirty bitmap to (b) and (d)'s
> dirty bitmaps.

Sounds good to me, but may not cover dirty ring?  Maybe we could move on
with the simple but clean scheme first and think about a comprehensive
option only if very necessary.  The worst case is we need one more kvm cap
but we should still have enough.

Thanks,

-- 
Peter Xu

