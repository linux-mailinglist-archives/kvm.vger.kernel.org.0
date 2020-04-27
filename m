Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC641B9FB4
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 11:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgD0JU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 05:20:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28490 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726434AbgD0JUZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 05:20:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587979224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/iT1ZSnr3VWE3x+uDoNEdTmOq69Ly4M18udfvhiGRxU=;
        b=fU2qFLIVjumrmw7xos7/exRxGz6GpCU0ZvGkVjJwXqcaEtPB+jxXhVpLvVSFqvINqgBCP4
        jfDRuMLRbDmYmtGbVPpdsJ4hky26X0eRdiA67fTCABEI+EnEIB+dxQdm/+c/edNrxfi/L+
        AB/L7i/kqDXI6mA/SfglVFi/SBL3EXE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-OZlW_XuMMKaWNnxZ6IB_vQ-1; Mon, 27 Apr 2020 05:20:22 -0400
X-MC-Unique: OZlW_XuMMKaWNnxZ6IB_vQ-1
Received: by mail-wm1-f69.google.com with SMTP id b203so8409821wmd.6
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 02:20:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/iT1ZSnr3VWE3x+uDoNEdTmOq69Ly4M18udfvhiGRxU=;
        b=rgA1hXrE4t9p2eC2lsPjzqWEFnXhJTMpXqIRwkl842vdMroowWQ3UJYz5gGAtn42Jb
         cw+lBFnEULMEBAkkCJWtnBaZxAz4FnGO5ENJDwoPZMGbK4nxKrHGb+vAci9jOZ0lPfW/
         r8eG6IfhqLCeQYJw/0LisBEQX5VPcu6zs7zhzCvUzSoK3OhGc6ujMusKGtI7jY6PVzt4
         SClXKsRCTZpgSJaPVbsCpdkbgjkgYfs6LbdSVLo0bgObNRsQIV07Sn+e6P4sMpQUb2p/
         ZkF2iK57xmEZpyIHhOTksx7tgOol5m1UNW7ZxgXWzt0CetHAnxoFRz5/lI3V4FMNGlMG
         Y7qg==
X-Gm-Message-State: AGi0PuY5ZFaOIPtV5mjv/CxWRRmA30rqCgxjxZKkgxaan+cqVEXuLXjP
        oomGpgVucI7L/EEpIDUOTqL9GVSjh39o/zm4Sa5g+Xx2aewAutjqg5TVeeI0H1QJjcJ6QeDfRwW
        bICbuEkxj9bq2
X-Received: by 2002:a7b:c147:: with SMTP id z7mr26867127wmi.52.1587979221551;
        Mon, 27 Apr 2020 02:20:21 -0700 (PDT)
X-Google-Smtp-Source: APiQypJLxRMCB8YEXW9YDI2OLkrBugUH83i4IlZL7wCtXLgz+NY/798+oztf6oqjhyKDB3I0p2eFUw==
X-Received: by 2002:a7b:c147:: with SMTP id z7mr26867111wmi.52.1587979221336;
        Mon, 27 Apr 2020 02:20:21 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id j13sm20977689wrq.24.2020.04.27.02.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 02:20:20 -0700 (PDT)
Date:   Mon, 27 Apr 2020 05:20:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM list <kvm@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4] vhost: disable for OABI
Message-ID: <20200427051918-mutt-send-email-mst@kernel.org>
References: <20200420143229.245488-1-mst@redhat.com>
 <CAMuHMdWaG5EUsbTOMPkj4i50D40T0TLRvB6g-Y8Dj4C0v7KTqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWaG5EUsbTOMPkj4i50D40T0TLRvB6g-Y8Dj4C0v7KTqQ@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 08:45:22AM +0200, Geert Uytterhoeven wrote:
> Hi Michael,
> 
> Thanks for your patch!
> 
> On Mon, Apr 20, 2020 at 5:13 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > vhost is currently broken on the some ARM configs.
> >
> > The reason is that the ring element addresses are passed between
> > components with different alignments assumptions. Thus, if
> > guest selects a pointer and host then gets and dereferences
> > it, then alignment assumed by the host's compiler might be
> > greater than the actual alignment of the pointer.
> > compiler on the host from assuming pointer is aligned.
> >
> > This actually triggers on ARM with -mabi=apcs-gnu - which is a
> > deprecated configuration. With this OABI, compiler assumes that
> > all structures are 4 byte aligned - which is stronger than
> > virtio guarantees for available and used rings, which are
> > merely 2 bytes. Thus a guest without -mabi=apcs-gnu running
> > on top of host with -mabi=apcs-gnu will be broken.
> >
> > The correct fix is to force alignment of structures - however
> > that is an intrusive fix that's best deferred until the next release.
> >
> > We didn't previously support such ancient systems at all - this surfaced
> > after vdpa support prompted removing dependency of vhost on
> > VIRTULIZATION. So for now, let's just add something along the lines of
> >
> >         depends on !ARM || AEABI
> >
> > to the virtio Kconfig declaration, and add a comment that it has to do
> > with struct member alignment.
> >
> > Note: we can't make VHOST and VHOST_RING themselves have
> > a dependency since these are selected. Add a new symbol for that.
> 
> Adding the dependencies to VHOST and VHOST_RING themselves is indeed not
> sufficient.  But IMHO you should still add VHOST_DPN dependencies t
>  these two symbols, so any driver selecting them without fulfilling the
> VHOST_DPN dependency will trigger a Kconfig warning.  Else the
> issue will be ignored silently.

Good point.
For now I'm trying to just get rid of this work around.
If I can't I will add the suggested change.
Thanks!

> > We should be able to drop this dependency down the road.
> >
> > Fixes: 20c384f1ea1a0bc7 ("vhost: refine vhost and vringh kconfig")
> > Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> > Suggested-by: Richard Earnshaw <Richard.Earnshaw@arm.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> -- 
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

