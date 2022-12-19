Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E086065147F
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 21:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232433AbiLSU4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 15:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbiLSU4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 15:56:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE33268
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 12:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671483331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pVE31Z9vgMIM4n4CZuPkgWLhGbg23ogF+83o3Mf6Ae0=;
        b=H/erSMgj3d3FQnoSHnK9Rs/DApdJxSEVcRxBZJfqvi5Z5IxeEGx7kfeFKUq1ue81CSXWJH
        vJSI9V/aR2qnw4RTTAfg/lV5jwLGJ3w/iKVfv4TmQ0aKchxB9oYDA4ltKKiopgZSTbhCsx
        MoCIw+rsc8y+gYsPpWMhxlqOfyyMXkk=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-651-XaeY8VgFMa2EnskGLnGIBg-1; Mon, 19 Dec 2022 15:55:30 -0500
X-MC-Unique: XaeY8VgFMa2EnskGLnGIBg-1
Received: by mail-il1-f198.google.com with SMTP id a11-20020a92c54b000000b003034a80704fso7252270ilj.1
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 12:55:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pVE31Z9vgMIM4n4CZuPkgWLhGbg23ogF+83o3Mf6Ae0=;
        b=KAwUeEncn5/4r7upmteQWfRU2+ilqKH7ovKJYk9cvwbdHZRR6vlK/DxjpZ1xEdPcVm
         40egqfJOMSUaivCd7jNRWH920UXygG6+/gyXwLhQ8621ZVYBgj9XcUTxHM27yY9JsaUe
         dpjqjDgEWvkJ7TLe3WqjRdY4peUshJ2MgZ3Q/VIhdIC+zolBdms0gAnIAJqGtCY5bCFW
         V8uW7pVcwBH40nf3rpFFj7TECSMXqVl9dCEwzeLe1d/LLzTMF4sw4FA/QSs1K7IKBKaI
         8WATCSSlSKdWgcthPKYFReOOVZrBwzk8csus75FCKC836bi7BDtwES4L5l3Qk0GOl891
         1q2Q==
X-Gm-Message-State: AFqh2kr+rz/KjbtPnRd4Xoksg1l+i02hUxzOTRl8sqJXKT4LnKlO9/Jv
        Fuk/RwnjJWy/3kjSnpN7DsL4cj8EzlcLin+INcsP0zKnnH7F+PYbI5RvgBtON/5YXzNfTSJgoYC
        GOYs0eMFZBtjO
X-Received: by 2002:a92:dc4e:0:b0:306:dc09:fe46 with SMTP id x14-20020a92dc4e000000b00306dc09fe46mr9111469ilq.3.1671483329073;
        Mon, 19 Dec 2022 12:55:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXusKSsIXdEYsSZ81uJk+FjCWYqFqhedv2n4xYkan44Uhk514qMh9+ZBKgGxiXD2kzyfJt5rnA==
X-Received: by 2002:a92:dc4e:0:b0:306:dc09:fe46 with SMTP id x14-20020a92dc4e000000b00306dc09fe46mr9111459ilq.3.1671483328749;
        Mon, 19 Dec 2022 12:55:28 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r1-20020a02b101000000b00363fbcad265sm3855259jah.25.2022.12.19.12.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 12:55:27 -0800 (PST)
Date:   Mon, 19 Dec 2022 13:55:25 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V6 0/7] fixes for virtual address update
Message-ID: <20221219135525.74e22f6a.alex.williamson@redhat.com>
In-Reply-To: <247466ea-65a9-0b57-a85d-2ef5a700a48e@oracle.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
        <247466ea-65a9-0b57-a85d-2ef5a700a48e@oracle.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Mon, 19 Dec 2022 13:42:06 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> Alex, Jason, any comments before I post the (hopefully final) version?

I like Kevin's comments, nothing additional from me.  Thanks,

Alex

> On 12/16/2022 1:50 PM, Steve Sistare wrote:
> > Fix bugs in the interfaces that allow the underlying memory object of an
> > iova range to be mapped in a new address space.  They allow userland to
> > indefinitely block vfio mediated device kernel threads, and do not
> > propagate the locked_vm count to a new mm.  Also fix a pre-existing bug
> > that allows locked_vm underflow.
> > 
> > The fixes impose restrictions that eliminate waiting conditions, so
> > revert the dead code:
> >   commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
> >   commit 487ace134053 ("vfio/type1: implement notify callback")
> >   commit ec5e32940cc9 ("vfio: iommu driver notify callback")
> > 
> > Changes in V2 (thanks Alex):
> >   * do not allow group attach while vaddrs are invalid
> >   * add patches to delete dead code
> >   * add WARN_ON for never-should-happen conditions
> >   * check for changed mm in unmap.
> >   * check for vfio_lock_acct failure in remap
> > 
> > Changes in V3 (ditto!):
> >   * return errno at WARN_ON sites, and make it unique
> >   * correctly check for dma task mm change
> >   * change dma owner to current when vaddr is updated
> >   * add Fixes to commit messages
> >   * refactored new code in vfio_dma_do_map
> > 
> > Changes in V4:
> >   * misc cosmetic changes
> > 
> > Changes in V5 (thanks Jason and Kevin):
> >   * grab mm and use it for locked_vm accounting
> >   * separate patches for underflow and restoring locked_vm
> >   * account for reserved pages
> >   * improve error messages
> > 
> > Changes in V6:
> >   * drop "count reserved pages" patch
> >   * add "track locked_vm" patch
> >   * grab current->mm not group_leader->mm
> >   * simplify vfio_change_dma_owner
> >   * fix commit messages
> > 
> > Steve Sistare (7):
> >   vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
> >   vfio/type1: prevent underflow of locked_vm via exec()
> >   vfio/type1: track locked_vm per dma
> >   vfio/type1: restore locked_vm
> >   vfio/type1: revert "block on invalid vaddr"
> >   vfio/type1: revert "implement notify callback"
> >   vfio: revert "iommu driver notify callback"
> > 
> >  drivers/vfio/container.c        |   5 -
> >  drivers/vfio/vfio.h             |   7 --
> >  drivers/vfio/vfio_iommu_type1.c | 226 ++++++++++++++++++----------------------
> >  include/uapi/linux/vfio.h       |  15 +--
> >  4 files changed, 111 insertions(+), 142 deletions(-)
> >   
> 

