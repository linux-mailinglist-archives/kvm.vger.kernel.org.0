Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86F03A0902
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 03:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbhFIB3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 21:29:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58523 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230303AbhFIB3N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 21:29:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623202038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JGp/0RPvZPb+IOMbTE2NveByUxQDrcE60zp+PyvVOGM=;
        b=bdQsOT25ofsgcHfos1u/KyyXdq4kcpSjw97Y9ypKaEfhTxBqIs97oM2qfcVLbil8LPcpyT
        gRlLk2gU3IJUSCF6Qwo9veOGTxjAK+3MuJJW/XiRTL4P/OwUV6mM9w8cTDjUAkjIfEm443
        hiYx1kih84wq3jXjDysb8+7FAp0VrNY=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-iGce91epNb2d_b5FFoBDNg-1; Tue, 08 Jun 2021 21:27:17 -0400
X-MC-Unique: iGce91epNb2d_b5FFoBDNg-1
Received: by mail-oi1-f200.google.com with SMTP id w9-20020a0568080d49b02901f3febe5739so3814089oik.1
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 18:27:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JGp/0RPvZPb+IOMbTE2NveByUxQDrcE60zp+PyvVOGM=;
        b=r+euYaU+Ukip95OTNXzTHiJTQzodACB1YmQLJVRcaqgmSX3o48VFiRWVAHa6JXD5On
         VwPPeqJoROexQAP2Xb0gjPoLILNvZ6dpQPvt4N7WNmDIYPZ+3SL4BpdRXZZ2Bb1tv3rL
         /mMeVXF1OHjODtoAgy6uYCUY7ju04dlfP7nfa2dHsgVVRndAuSDn1Clfj9yQ3pQP0sgj
         9UUm3FKqCdjhMVHjaoYBG1BURZYtzt8uDaI6IuO0bTkAKjnlpgdvG68JP8QCtajPQ1TN
         HrRzJ7M8qURo4pNA6J1b2nT/IF7UhWjtK/Ai9WEfsB/JxggfZja0wETxjkqmJMhlabRG
         8yZA==
X-Gm-Message-State: AOAM532to+IFOgwH98g6oNGuHzvr25zUC09sJC7AbakjS8IhkghEmDkv
        pgs18rplIAYMJe6ISCCog1Ewc2Isz9UnyYeanHnrRY4XIayqNi4OL/e2OfuNnyeuDld4gLZ3g0T
        lFpo4NGjomNhZ
X-Received: by 2002:a05:6808:65a:: with SMTP id z26mr2084846oih.85.1623202036846;
        Tue, 08 Jun 2021 18:27:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQjbYHx9vbf7buJfv0hZjocAAsik2BDyau0SyM9QI17Tm0zs7xe3LgZX3rYmnKU+ZOsJpHxQ==
X-Received: by 2002:a05:6808:65a:: with SMTP id z26mr2084831oih.85.1623202036662;
        Tue, 08 Jun 2021 18:27:16 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id t14sm3189692ooh.39.2021.06.08.18.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 18:27:16 -0700 (PDT)
Date:   Tue, 8 Jun 2021 19:27:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210608192711.4956cda2.alex.williamson@redhat.com>
In-Reply-To: <20210608224517.GQ1002214@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
        <20210603160809.15845-10-mgurtovoy@nvidia.com>
        <20210608152643.2d3400c1.alex.williamson@redhat.com>
        <20210608224517.GQ1002214@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Jun 2021 19:45:17 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jun 08, 2021 at 03:26:43PM -0600, Alex Williamson wrote:
> > > drivers that specifically opt into this feature and the driver now has
> > > the opportunity to provide a proper match table that indicates what HW
> > > it can properly support. vfio-pci continues to support everything.  
> > 
> > In doing so, this also breaks the new_id method for vfio-pci.    
> 
> Does it? How? The driver_override flag is per match entry not for the
> entire device so new_id added things will work the same as before as
> their new match entry's flags will be zero.

Hmm, that might have been a testing issue; combining driverctl with
manual new_id testing might have left a driver_override in place.
 
> > Sorry, with so many userspace regressions, crippling the
> > driver_override interface with an assumption of such a narrow focus,
> > creating a vfio specific match flag, I don't see where this can go.
> > Thanks,  
> 
> On the other hand it overcomes all the objections from the last go
> round: how userspace figures out which driver to use with
> driver_override and integrating the universal driver into the scheme.
> 
> pci_stub could be delt with by marking it for driver_override like
> vfio_pci.

By marking it a "vfio driver override"? :-\

> But driverctl as a general tool working with any module is not really
> addressable.
> 
> Is the only issue the blocking of the arbitary binding? That is not a
> critical peice of this, IIRC

We can't break userspace, which means new_id and driver_override need
to work as they do now.  There are scads of driver binding scripts in
the wild, for vfio-pci and other drivers.  We can't assume such a
narrow scope.  Thanks,

Alex

