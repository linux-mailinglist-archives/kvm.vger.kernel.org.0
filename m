Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD4C37AA41
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 17:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhEKPKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 11:10:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231681AbhEKPKD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 11:10:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620745736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=49kahAQprPmYeKDXygdVGf4FQORhI+AIe0OnMoT5N28=;
        b=BAQDKNUfk2rtd9aYFFYgAdy8Y3dPtt8UO71ZO8mTo//ai9VwNS/aFwXTR6Vl87I0Ow7K7F
        fElVdhChczTl9A4E49pofLRiV/PsIFOPvKFVNab3W8qrciDGvc5zEsBUfk1t03LvASN9Bl
        fYphKrKBw2Ky6K5krNWUBxVgf3Abzs4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-4h124zxxP2Oq-DGPaOraSg-1; Tue, 11 May 2021 11:08:55 -0400
X-MC-Unique: 4h124zxxP2Oq-DGPaOraSg-1
Received: by mail-qk1-f197.google.com with SMTP id u9-20020a05620a4549b02902e956c2a3c8so14580690qkp.20
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 08:08:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=49kahAQprPmYeKDXygdVGf4FQORhI+AIe0OnMoT5N28=;
        b=ZTyZPMMhasujp3F+F0sPaGk8d/WKPTij7DrGTBPqljZiWxswgUaANEk6zcTJC5KZ3I
         rSh1Mh7aVNs+a7EuEl+LWArsqSDhT3Gv0n0zuWUcjjZebnfy26t9rWr39py7QfDhvbZo
         rs7PdiU7S1h2d1fTDrv8AG+8BwbFNSpd0j8mwPqrS/qaVtXTThNUCljAIwPh75V03TD1
         Cc/AfJiDds2V48Qlc+GSj0IQASsQCNSvXOmz658BJo/exVwhy3FrxR+/HbPBBjgm8R8q
         V7uaLKcKuHLmh7vKm75cgv9JYseD5gRpc8Wvjbd/jwK0cD3Rco+FbIk/+cNxU82nsy0e
         LtNQ==
X-Gm-Message-State: AOAM532yfasTfzoUA+1Q9og/KsTFVYUpyBho2alKzksqtFzALZW03sjY
        EPi6D91MO0CJDnxIzDepzV05wX1LcD/o0sYRHwqhO3jYWWyK3ViwycRlRkq47os+KVhhGmK3ACI
        kc3yxExM/foizY0B6+UKpLNMbN4ON
X-Received: by 2002:a37:a8cb:: with SMTP id r194mr29059210qke.349.1620745734480;
        Tue, 11 May 2021 08:08:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyMkx1TTUlss+FHShRAvIazFJyZrxg6Bt6L36IOaHhdOoSUCA7ytQ5Nab8GVEketRaFrW7a2tPwNSbYHK2WIbc=
X-Received: by 2002:a37:a8cb:: with SMTP id r194mr29059176qke.349.1620745734136;
 Tue, 11 May 2021 08:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210510155539.998747-1-groug@kaod.org> <20210510155539.998747-4-groug@kaod.org>
 <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
 <20210511125409.GA234533@horse> <20210511144923.GA238488@horse>
In-Reply-To: <20210511144923.GA238488@horse>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Tue, 11 May 2021 17:08:42 +0200
Message-ID: <CAOssrKeSBnDTa3SF0y49ZuoFMJPr1iq6KqzPCkXYmNsRxXP7vQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [for-6.1 v3 3/3] virtiofsd: Add support for
 FUSE_SYNCFS request
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Greg Kurz <groug@kaod.org>,
        QEMU Developers <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtio-fs-list <virtio-fs@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 4:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, May 11, 2021 at 08:54:09AM -0400, Vivek Goyal wrote:
> > On Tue, May 11, 2021 at 02:31:14PM +0200, Miklos Szeredi wrote:
> > > On Mon, May 10, 2021 at 5:55 PM Greg Kurz <groug@kaod.org> wrote:
> > > >
> > > > Honor the expected behavior of syncfs() to synchronously flush all data
> > > > and metadata on linux systems. Simply loop on all known submounts and
> > > > call syncfs() on them.
> > >
> > > Why not pass the submount's root to the server, so it can do just one
> > > targeted syncfs?
> > >
> > > E.g. somehting like this in fuse_sync_fs():
> > >
> > > args.nodeid = get_node_id(sb->s_root->d_inode);
> >
> > Hi Miklos,
> >
> > I think current proposal was due to lack of full understanding on my part.
> > I was assuming we have one super block in client and that's not the case
> > looks like. For every submount, we will have another superblock known
> > to vfs, IIUC. That means when sync() happens, we will receive ->syncfs()
> > for each of those super blocks. And that means file server does not
> > have to keep track of submounts explicitly and it will either receive
> > a single targeted SYNCFS (for the case of syncfs(fd)) or receive
> > multile SYNCFS calls (one for each submount when sync() is called).
>
> Tried sync() with submounts enabled and we are seeing a SYNCFS call
> only for top level super block and not for submounts.
>
> Greg noticed that it probably is due to the fact that iterate_super()
> skips super blocks which don't have SB_BORN flag set.
>
> Only vfs_get_tree() seems to set SB_BORN and for our submounts we
> are not calling vfs_get_tree(), hence SB_BORN is not set. NFS seems
> to call vfs_get_tree() and hence SB_BORN must be set for submounts.
>
> Maybe we need to modify virtio_fs_get_tree() so that it can deal with
> mount as well as submounts and then fuse_dentry_automount() should
> probably call vfs_get_tree() and that should set SB_BORN and hopefully
> sync() will work with it. Greg is planning to give it a try.
>
> Does it sound reasonable.

Just setting SB_BORN sounds much simpler.  What's the disadvantage?

Thanks,
Miklos

