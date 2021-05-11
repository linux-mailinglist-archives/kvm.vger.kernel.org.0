Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75BA337AA40
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 17:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhEKPJt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 11 May 2021 11:09:49 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:38461 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231681AbhEKPJt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 11:09:49 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-mRo8asxAN2uCEyqp3pWptQ-1; Tue, 11 May 2021 11:08:38 -0400
X-MC-Unique: mRo8asxAN2uCEyqp3pWptQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BF201854E30;
        Tue, 11 May 2021 15:08:37 +0000 (UTC)
Received: from bahia.lan (ovpn-112-143.ams2.redhat.com [10.36.112.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 324F1E2E8;
        Tue, 11 May 2021 15:08:28 +0000 (UTC)
Date:   Tue, 11 May 2021 17:08:26 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     QEMU Developers <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtio-fs-list <virtio-fs@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [for-6.1 v3 3/3] virtiofsd: Add support for
 FUSE_SYNCFS request
Message-ID: <20210511170826.73b0b663@bahia.lan>
In-Reply-To: <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
References: <20210510155539.998747-1-groug@kaod.org>
        <20210510155539.998747-4-groug@kaod.org>
        <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kaod.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 May 2021 14:31:14 +0200
Miklos Szeredi <mszeredi@redhat.com> wrote:

> On Mon, May 10, 2021 at 5:55 PM Greg Kurz <groug@kaod.org> wrote:
> >
> > Honor the expected behavior of syncfs() to synchronously flush all data
> > and metadata on linux systems. Simply loop on all known submounts and
> > call syncfs() on them.
> 
> Why not pass the submount's root to the server, so it can do just one
> targeted syncfs?
> 
> E.g. somehting like this in fuse_sync_fs():
> 
> args.nodeid = get_node_id(sb->s_root->d_inode);
> 
> Thanks,
> Miklos
> 

As Vivek already pointed out, there was some misunderstanding on
how submounts were supposed to work. Things got clearer since then :)

So, basically, we have two cases:

1) virtiofsd announces submounts : the d_automount implementation
   creates a new super block and mounts the submount

2) virtiofsd doesn't announce submounts: the client only knows
   about the top-level super block

You suggestion is for case 1) while this series was made with
case 2) in mind, hence the tracking of the super blocks in
the server.

Vivek and I discussed and agreed to address 2) later and
to just focus on 1) for now.

Your suggestion doesn't work with the current code base
because ->sync_fs() is never called on our submounts'
super blocks. This is because they don't have SB_BORN
set, which looks incorrect. A call to vfs_get_tree() would
fix it, but some code refactoring is needed in
fuse_dentry_automount() and virtio_fs_get_tree() for that.

Cheers,

--
Greg

