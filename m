Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B1064AB96
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 00:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiLLXa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 18:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbiLLXar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 18:30:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE7D1AA06
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 15:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670887793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KvdpY0GY9VJXBTKJUdqEmXaOsTtoqJbtiUj3fVp/sSo=;
        b=Qtd2FWFBWy+zQ4YEbl8e9zNr0dp+pOAZzgpTGdOAUmP8TOSYzI6TT/NMNU76D3D92iNRK/
        eSi9Fi0w2pzCRpD8iMsaLXacvXL3lYaB3JHh81vwupL64BOxf32Gs7va7BUXgPTkUeS4DW
        HYYZBO+n2YmNAVH4PSKcWbjKZ08gi7A=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-391-gRj7vTN_P1WBcFBcgxdz_w-1; Mon, 12 Dec 2022 18:29:52 -0500
X-MC-Unique: gRj7vTN_P1WBcFBcgxdz_w-1
Received: by mail-io1-f69.google.com with SMTP id t2-20020a6b6402000000b006dea34ad528so905139iog.1
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 15:29:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KvdpY0GY9VJXBTKJUdqEmXaOsTtoqJbtiUj3fVp/sSo=;
        b=wJwbtHItTc9061show9h/gzPzHU/niYtzSF76u0sxv6/anoD/vmF7E8a+U7wGv3Vhi
         zC7Wo4xHh5hulAulrROWrRXnQmaPoslLHb3rx0h4sTx3AeAFjfKTHNK5TeYTmOc2ZGCT
         UW8iQl7qPVUG45zxs1eNywvMN16oMV2imPd3RSoJeZy+h2CymlxEafDzTP1XzWGXr/UW
         itabv7VwTbrqa7r2h9hZUyuSV6nbIfkHI5n8AVSJSHEAdVZBnhSD4Z2P4gE7SM6VDwP6
         M87RVP0lHF3/1acNd3cUD9heb1uLiH3Q2UNWsdJ6P9TXJwbMAizOLTXHheeX1iz66itI
         Y+xQ==
X-Gm-Message-State: ANoB5pliNSitwXucE+RTVgLRYaT4BN2nBKhozhk18kuF/yJNsC0W3eaM
        /BClSYAzbvcRR5sY6IXgY+8vUl/qCq0g3s/4cL/Vxfd9eMcNZ7nPGjuipF6gdb0hXDHWXblciLR
        mXJwJMj8piqkk
X-Received: by 2002:a92:200b:0:b0:2fc:ce26:2bc0 with SMTP id j11-20020a92200b000000b002fcce262bc0mr10108216ile.3.1670887791393;
        Mon, 12 Dec 2022 15:29:51 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5/nTl2MO7BLyupDgKqODA8Ae7bi8W6A830Qtp+hy+40jQChhduAvwC/003NcjO/jC0QF5PJQ==
X-Received: by 2002:a92:200b:0:b0:2fc:ce26:2bc0 with SMTP id j11-20020a92200b000000b002fcce262bc0mr10108209ile.3.1670887791138;
        Mon, 12 Dec 2022 15:29:51 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q10-20020a92050a000000b00302a9c9b4bfsm3291577ile.44.2022.12.12.15.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 15:29:50 -0800 (PST)
Date:   Mon, 12 Dec 2022 16:29:48 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Steven Sistare <steven.sistare@oracle.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Message-ID: <20221212162948.4c7a4586.alex.williamson@redhat.com>
In-Reply-To: <Y5e0icoO89Qnlc/z@ziepe.ca>
References: <20221208094008.1b79dd59.alex.williamson@redhat.com>
        <b265b4ae-b178-0682-66b8-ef74a1489a8e@oracle.com>
        <20221209124212.672b7a9c.alex.williamson@redhat.com>
        <5f494e1f-536d-7225-e2c7-5ec9c993f13a@oracle.com>
        <20221209140120.667cb658.alex.williamson@redhat.com>
        <6914b4eb-cd82-0c3e-6637-c7922092ef11@oracle.com>
        <Y5cqAk1/6ayzmTjg@ziepe.ca>
        <20221212085823.5d760656.alex.williamson@redhat.com>
        <8f29aad0-7378-ef7a-9ac5-f98b3054d5eb@oracle.com>
        <20221212142651.263dd6ae.alex.williamson@redhat.com>
        <Y5e0icoO89Qnlc/z@ziepe.ca>
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

On Mon, 12 Dec 2022 19:08:57 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Mon, Dec 12, 2022 at 02:26:51PM -0700, Alex Williamson wrote:
> > On Mon, 12 Dec 2022 15:59:11 -0500
> > Steven Sistare <steven.sistare@oracle.com> wrote:
> >   
> > > On 12/12/2022 10:58 AM, Alex Williamson wrote:  
> > > > On Mon, 12 Dec 2022 09:17:54 -0400
> > > > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > >     
> > > >> On Sat, Dec 10, 2022 at 09:14:06AM -0500, Steven Sistare wrote:
> > > >>    
> > > >>> Thank you for your thoughtful response.  Rather than debate the degree of
> > > >>> of vulnerability, I propose an alternate solution.  The technical crux of
> > > >>> the matter is support for mediated devices.        
> > > >>
> > > >> I'm not sure I'm convinced about that. It is easy to make problematic
> > > >> situations with mdevs, but that doesn't mean other cases don't exist
> > > >> too eg what happens if userspace suspends and then immediately does
> > > >> something to trigger a domain attachment? Doesn't it still deadlock
> > > >> the kernel?    
> > > > 
> > > > The opportunity for that to deadlock isn't obvious to me, a replay
> > > > would be stalled waiting for invalid vaddrs, but this is essentially
> > > > the user deadlocking themselves.  There's also code there to handle the
> > > > process getting killed while waiting, making it interruptible.  Thanks,    
> > > 
> > > I will submit new patches tomorrow to exclude mdevs.  Almost done.  
> > 
> > I've dropped the removal commits from my next branch in the interim.  
> 
> Woah, please don't do that - I already built and sent pull requests
> assuming this, there are conflicts.

I've done merges both ways with your iommufd pull request and don't see
any conflicts relative to these changes.  Kconfig, Makefile, and
vfio_main.c related to virq integration and group extraction are the
only conflicts.  Besides, it's already pushed and I don't have any
references to the old head, so someone would need to provide it if we
wanted to keep the old hashes.
 
> Why would we not revert everything from 6.2 - that is what we agreed
> to do?

The decision to revert was based on the current interface being buggy,
abandoned, and re-implemented.  It doesn't seem that there's much future
for the current interface, but Steve has stepped up to restrict the
current implementation to non-mdev devices, which resolves your concern
regarding unlimited user blocking of kernel threads afaict, and we'll
see what he does with locked memory.  If it looks ok, then I think it
reduces our urgency to remove it, and in particular, I think negates
our need to remove it from stable when we eventually do so anyway.
Thanks,

Alex

