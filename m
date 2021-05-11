Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810AF37AA6C
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 17:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhEKPRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 11:17:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25612 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231461AbhEKPRk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 11:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620746193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ofC0rBi4DPPTj74xp81sP5GGpV+ugu6+KkhMIEvk3x4=;
        b=dFs6ZPpRnfIBZsTpy4iKK9L2sCJ6LaUqIz1/D6SXHeMh0+V/rBF25OJs2jdNDYdG/4kjUi
        +bv/P7HdrVUVWEA4VpbKdK4/ygaZxAAxcyZaSRXag4LS8AtCZSWCOgj0TKaRGMo9jvGNrg
        XclPVRF3xxD32wz6D40WqOncPHQq2oo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-9CfAL_hqP5iGDNVdAGPIRQ-1; Tue, 11 May 2021 11:16:29 -0400
X-MC-Unique: 9CfAL_hqP5iGDNVdAGPIRQ-1
Received: by mail-qk1-f199.google.com with SMTP id s4-20020a3790040000b02902fa7aa987e8so1609954qkd.14
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 08:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ofC0rBi4DPPTj74xp81sP5GGpV+ugu6+KkhMIEvk3x4=;
        b=s5orpwoTDZKIFI61tlaYWXt9n9FbUr5D4zC51vH3V/QMxgnEmXq5bxXx80u6Sr2QF+
         /Vaz2Rf1oFCb46KqKfCBKwx4jAnp13p5ocfwrUgDXLp8R2rqZg+r4Ez9cRmjoLafxFtH
         OLCeVFAWIJpLDuu959z4m+tt4jiLtBvUIjSySS/R5tiZUiVwBUU1BuSaHQuqRgZ5DUPy
         90eA4K0DPH4dOeGAj8dLgwaIDqX/F2j5RqL/E/CO8vnf660nM04p+6igmWs854cdUsTw
         Y5ksEZS6rnuAx1d0d8nFtcdTUFgdcs8JORpohiwrQdqNKSMYCjIsk0ddzD0/UBDBVRIA
         V73g==
X-Gm-Message-State: AOAM530xkYQYYiHrf8DYUpad8UfIqfrowvcYe0B2ytEBVoGBHE7WmSD/
        MdeA0GCZY+gIf3UKgVXFU3UBMW5Ao7Wlx3Qg1u4eu0MX79sr98NwIX863h3UnXhPAxVlCT/3c0o
        Enwtqh18/hAQn
X-Received: by 2002:a0c:c447:: with SMTP id t7mr30058993qvi.60.1620746189187;
        Tue, 11 May 2021 08:16:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4aJlekwQNcRyqocU4BWwi3mAVhpr5Mu7ViTGISYvK4QWRRRcGQUhLMl9d/MYz4rhlALi3FQ==
X-Received: by 2002:a0c:c447:: with SMTP id t7mr30058966qvi.60.1620746188974;
        Tue, 11 May 2021 08:16:28 -0700 (PDT)
Received: from horse (pool-173-76-174-238.bstnma.fios.verizon.net. [173.76.174.238])
        by smtp.gmail.com with ESMTPSA id b7sm12579971qte.80.2021.05.11.08.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 08:16:28 -0700 (PDT)
Date:   Tue, 11 May 2021 11:16:26 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Greg Kurz <groug@kaod.org>,
        QEMU Developers <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtio-fs-list <virtio-fs@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Virtio-fs] [for-6.1 v3 3/3] virtiofsd: Add support for
 FUSE_SYNCFS request
Message-ID: <20210511151626.GC238488@horse>
References: <20210510155539.998747-1-groug@kaod.org>
 <20210510155539.998747-4-groug@kaod.org>
 <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
 <20210511125409.GA234533@horse>
 <20210511144923.GA238488@horse>
 <CAOssrKeSBnDTa3SF0y49ZuoFMJPr1iq6KqzPCkXYmNsRxXP7vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKeSBnDTa3SF0y49ZuoFMJPr1iq6KqzPCkXYmNsRxXP7vQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 05:08:42PM +0200, Miklos Szeredi wrote:
> On Tue, May 11, 2021 at 4:49 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Tue, May 11, 2021 at 08:54:09AM -0400, Vivek Goyal wrote:
> > > On Tue, May 11, 2021 at 02:31:14PM +0200, Miklos Szeredi wrote:
> > > > On Mon, May 10, 2021 at 5:55 PM Greg Kurz <groug@kaod.org> wrote:
> > > > >
> > > > > Honor the expected behavior of syncfs() to synchronously flush all data
> > > > > and metadata on linux systems. Simply loop on all known submounts and
> > > > > call syncfs() on them.
> > > >
> > > > Why not pass the submount's root to the server, so it can do just one
> > > > targeted syncfs?
> > > >
> > > > E.g. somehting like this in fuse_sync_fs():
> > > >
> > > > args.nodeid = get_node_id(sb->s_root->d_inode);
> > >
> > > Hi Miklos,
> > >
> > > I think current proposal was due to lack of full understanding on my part.
> > > I was assuming we have one super block in client and that's not the case
> > > looks like. For every submount, we will have another superblock known
> > > to vfs, IIUC. That means when sync() happens, we will receive ->syncfs()
> > > for each of those super blocks. And that means file server does not
> > > have to keep track of submounts explicitly and it will either receive
> > > a single targeted SYNCFS (for the case of syncfs(fd)) or receive
> > > multile SYNCFS calls (one for each submount when sync() is called).
> >
> > Tried sync() with submounts enabled and we are seeing a SYNCFS call
> > only for top level super block and not for submounts.
> >
> > Greg noticed that it probably is due to the fact that iterate_super()
> > skips super blocks which don't have SB_BORN flag set.
> >
> > Only vfs_get_tree() seems to set SB_BORN and for our submounts we
> > are not calling vfs_get_tree(), hence SB_BORN is not set. NFS seems
> > to call vfs_get_tree() and hence SB_BORN must be set for submounts.
> >
> > Maybe we need to modify virtio_fs_get_tree() so that it can deal with
> > mount as well as submounts and then fuse_dentry_automount() should
> > probably call vfs_get_tree() and that should set SB_BORN and hopefully
> > sync() will work with it. Greg is planning to give it a try.
> >
> > Does it sound reasonable.
> 
> Just setting SB_BORN sounds much simpler.  What's the disadvantage?

I was little hesitant to set it directly because no other filesystem
seems to be doing it. Hence I assumed that VFS expects filesystems to
not set SB_BORN.

But I do agree that setting SB_BORN in automount code is much simpler
solution.

Thanks
Vivek

