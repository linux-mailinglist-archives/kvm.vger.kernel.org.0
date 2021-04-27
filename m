Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7A536C514
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 13:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbhD0L3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 07:29:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230270AbhD0L3r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 07:29:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619522944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pkqyz+WNpdwlPbhZk3ghmnYGxACPaw6+OWJgfQs3wpk=;
        b=h/fYHdIL+7I4kR+3Zoy240nac8GEUR9XBorJZNYNDi2PsQrunxWtTRMKOaElGBvzJIznWp
        istd6yqFet4DItu8nsY0xmpdPu+qxknWfnW5U+xwx/lUAdEm3ww2MCHXpNB04+moG/h4G/
        zyGbKnciwO783KjXbCr6T1VCiSBx3pg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-h92NcQHINEqH7c3QQp4m9g-1; Tue, 27 Apr 2021 07:29:00 -0400
X-MC-Unique: h92NcQHINEqH7c3QQp4m9g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 477C51936B96;
        Tue, 27 Apr 2021 11:28:56 +0000 (UTC)
Received: from work-vm (ovpn-114-253.ams2.redhat.com [10.36.114.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5AE7361093;
        Tue, 27 Apr 2021 11:28:16 +0000 (UTC)
Date:   Tue, 27 Apr 2021 12:28:13 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     qemu-devel@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [for-6.1 v2 0/2] virtiofsd: Add support for FUSE_SYNCFS request
Message-ID: <YIf1TY4MbAQnCYG0@work-vm>
References: <20210426152135.842037-1-groug@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426152135.842037-1-groug@kaod.org>
User-Agent: Mutt/2.0.6 (2021-03-06)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Greg Kurz (groug@kaod.org) wrote:
> FUSE_SYNCFS allows the client to flush the host page cache.
> This isn't available in upstream linux yet, but the following
> tree can be used to test:

That looks OK to me; but we'll need to wait until syncfs lands in the
upstream kernel; we've got bitten before by stuff changing before it
actaully lands in the kernel.

Dave

> https://gitlab.com/gkurz/linux/-/tree/virtio-fs-sync
> 
> v2: - based on new version of FUSE_SYNCFS
>       https://listman.redhat.com/archives/virtio-fs/2021-April/msg00166.html
>     - propagate syncfs() errors to client (Vivek)
> 
> Greg Kurz (2):
>   Update linux headers to 5.12-rc8 + FUSE_SYNCFS
>   virtiofsd: Add support for FUSE_SYNCFS request
> 
>  include/standard-headers/drm/drm_fourcc.h     | 23 ++++-
>  include/standard-headers/linux/ethtool.h      | 54 ++++++-----
>  include/standard-headers/linux/fuse.h         | 13 ++-
>  include/standard-headers/linux/input.h        |  2 +-
>  .../standard-headers/rdma/vmw_pvrdma-abi.h    |  7 ++
>  linux-headers/asm-generic/unistd.h            |  4 +-
>  linux-headers/asm-mips/unistd_n32.h           |  1 +
>  linux-headers/asm-mips/unistd_n64.h           |  1 +
>  linux-headers/asm-mips/unistd_o32.h           |  1 +
>  linux-headers/asm-powerpc/kvm.h               |  2 +
>  linux-headers/asm-powerpc/unistd_32.h         |  1 +
>  linux-headers/asm-powerpc/unistd_64.h         |  1 +
>  linux-headers/asm-s390/unistd_32.h            |  1 +
>  linux-headers/asm-s390/unistd_64.h            |  1 +
>  linux-headers/asm-x86/kvm.h                   |  1 +
>  linux-headers/asm-x86/unistd_32.h             |  1 +
>  linux-headers/asm-x86/unistd_64.h             |  1 +
>  linux-headers/asm-x86/unistd_x32.h            |  1 +
>  linux-headers/linux/kvm.h                     | 89 +++++++++++++++++++
>  linux-headers/linux/vfio.h                    | 27 ++++++
>  tools/virtiofsd/fuse_lowlevel.c               | 19 ++++
>  tools/virtiofsd/fuse_lowlevel.h               | 13 +++
>  tools/virtiofsd/passthrough_ll.c              | 29 ++++++
>  tools/virtiofsd/passthrough_seccomp.c         |  1 +
>  24 files changed, 267 insertions(+), 27 deletions(-)
> 
> -- 
> 2.26.3
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

