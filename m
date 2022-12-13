Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D78D64ABF4
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 01:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiLMAFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 19:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbiLMAFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 19:05:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AC314D1C
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670889867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c778WIu0rf4lDSvaM7X5iaolCDnqS9bySCeUPtXdp1o=;
        b=V3KBLxq9LHdLp16GacKqWMDSiSlUZy3EVoAYHB/mil6zRzGSof+IIDE9+AnxN6cDtQv2wX
        5J4H21cZddg09BALvNc+zi+kiO54ldh+vgY1hQAmbYvKTZE3Aiq72zidAVq5yOLXnajd6f
        46qe+9e1owM6IPZo6dn5d6MaojhB0Cc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-wEWHpHvdPiW2wKFGseDbnA-1; Mon, 12 Dec 2022 19:04:26 -0500
X-MC-Unique: wEWHpHvdPiW2wKFGseDbnA-1
Received: by mail-io1-f69.google.com with SMTP id n10-20020a6b590a000000b006e03471b3eeso921782iob.11
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 16:04:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c778WIu0rf4lDSvaM7X5iaolCDnqS9bySCeUPtXdp1o=;
        b=1jkaOL7ahTDgQg2qkANoN91NZptG0LcOOaOyW0Sq1K1UU2SjJx4oD1SB7fR32PKOcU
         d9IWcSiGO+a3U6nBdgA91R0i4Jt8uL/XHAyiJ9K/OaftsApYQ4PZSa/I+rXViegexJaf
         0bnHPCnk/BOl5JpnmJliqfspDVtjSaCUu2/sgwOFOLxn11TU1vbv01CUPf0lrwG3BwpN
         UeuDZjNMiVstykh4vMxESkpziigbayR6AH6ZhqeOfRARG9iRz2pcql0lqMlsi0KQ5Ojl
         V+/CFSSPityXKADAd29w1EVsYcirBgOk9CxcBDJ/gTMN8WGMuY4vr+lJl/OHSWWS4sUd
         6xcw==
X-Gm-Message-State: ANoB5pnbCBzr5+9DVvM8pDznMoasfc223tEAIBM0dmeCb0OBdYAGFP3b
        z5XQmQUTu3Y3dJUJW1MYKbxtwQG2P1E/7vTjjqqn4cx3+wzUZOZb8NwIL7Fu3j/cWlzSSNaYCyP
        N2A+Rt+d5re6w
X-Received: by 2002:a6b:fb0a:0:b0:6df:5a37:ed5 with SMTP id h10-20020a6bfb0a000000b006df5a370ed5mr9510094iog.17.1670889865975;
        Mon, 12 Dec 2022 16:04:25 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5b+C3pNMyB9AHrQTMwkLB3S92Ro4t65xIeqTIY0TV6w+kdpwaeeT0A8eYFHZySo1idjjdX9w==
X-Received: by 2002:a6b:fb0a:0:b0:6df:5a37:ed5 with SMTP id h10-20020a6bfb0a000000b006df5a370ed5mr9510082iog.17.1670889865683;
        Mon, 12 Dec 2022 16:04:25 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i189-20020a6bb8c6000000b006dfb7d199dasm4640362iof.7.2022.12.12.16.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 16:04:25 -0800 (PST)
Date:   Mon, 12 Dec 2022 17:04:24 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Steven Sistare <steven.sistare@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <20221212170424.204bdb9a.alex.williamson@redhat.com>
In-Reply-To: <Y5e6zB3tW2D/ULlQ@ziepe.ca>
References: <20221209124212.672b7a9c.alex.williamson@redhat.com>
        <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
        <20221209140120.667cb658.alex.williamson@redhat.com>
        <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com>
        <Y5cqAk1/6ayzmTjg@ziepe.ca>
        <20221212085823.5d760656.alex.williamson@redhat.com>
        <8f29aad0-7378-ef7a-9ac5-f98b3054d5eb@oracle.com>
        <20221212142651.263dd6ae.alex.williamson@redhat.com>
        <Y5e0icoO89Qnlc/z@ziepe.ca>
        <20221212162948.4c7a4586.alex.williamson@redhat.com>
        <Y5e6zB3tW2D/ULlQ@ziepe.ca>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 12 Dec 2022 19:35:40 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Mon, Dec 12, 2022 at 04:29:48PM -0700, Alex Williamson wrote:
> > On Mon, 12 Dec 2022 19:08:57 -0400
> > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >   
> > > On Mon, Dec 12, 2022 at 02:26:51PM -0700, Alex Williamson wrote:  
> > > > On Mon, 12 Dec 2022 15:59:11 -0500
> > > > Steven Sistare <steven.sistare@oracle.com> wrote:
> > > >     
> > > > > On 12/12/2022 10:58 AM, Alex Williamson wrote:    
> > > > > > On Mon, 12 Dec 2022 09:17:54 -0400
> > > > > > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > > > >       
> > > > > >> On Sat, Dec 10, 2022 at 09:14:06AM -0500, Steven Sistare wrote:
> > > > > >>      
> > > > > >>> Thank you for your thoughtful response.  Rather than debate the degree of
> > > > > >>> of vulnerability, I propose an alternate solution.  The technical crux of
> > > > > >>> the matter is support for mediated devices.          
> > > > > >>
> > > > > >> I'm not sure I'm convinced about that. It is easy to make problematic
> > > > > >> situations with mdevs, but that doesn't mean other cases don't exist
> > > > > >> too eg what happens if userspace suspends and then immediately does
> > > > > >> something to trigger a domain attachment? Doesn't it still deadlock
> > > > > >> the kernel?      
> > > > > > 
> > > > > > The opportunity for that to deadlock isn't obvious to me, a replay
> > > > > > would be stalled waiting for invalid vaddrs, but this is essentially
> > > > > > the user deadlocking themselves.  There's also code there to handle the
> > > > > > process getting killed while waiting, making it interruptible.  Thanks,      
> > > > > 
> > > > > I will submit new patches tomorrow to exclude mdevs.  Almost done.    
> > > > 
> > > > I've dropped the removal commits from my next branch in the interim.    
> > > 
> > > Woah, please don't do that - I already built and sent pull requests
> > > assuming this, there are conflicts.  
> > 
> > I've done merges both ways with your iommufd pull request and don't see
> > any conflicts relative to these changes.  Kconfig, Makefile, and
> > vfio_main.c related to virq integration and group extraction are the
> > only conflicts.   
> 
> I got an extra hunk in the header file
> 
> > Besides, it's already pushed and I don't have any references to the
> > old head, so someone would need to provide it if we wanted to keep
> > the old hashes.  
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/tag/?h=for-linus-iommufd-merged
> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/commit/?h=for-linus-iommufd-merged&id=e9a1f0f32d86c05f01878a0448384a46a453abc7

Ok, I do still have that reference around.  Thanks.

> > > Why would we not revert everything from 6.2 - that is what we agreed
> > > to do?  
> > 
> > The decision to revert was based on the current interface being buggy,
> > abandoned, and re-implemented.  It doesn't seem that there's much future
> > for the current interface, but Steve has stepped up to restrict the
> > current implementation to non-mdev devices, which resolves your concern
> > regarding unlimited user blocking of kernel threads afaict, and we'll
> > see what he does with locked memory.    
> 
> Except nobody has seen this yet, and it can't go into 6.2 at this
> point (see Linus's rather harsh remarks on late work for v6.2)

We already outlined earlier in this thread the criteria that prompted
us to tag the revert for stable, which was Steve's primary objection in
the short term.  I can't in good faith push forward with a revert,
including stable, if Steve is working on a proposal to resolve the
issues prompting us to accelerate the code removal.  Depending on the
scope of Steve's proposal, I think we might be able to still consider
this a fix for v6.2.  Thanks,

Alex

