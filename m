Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDF03D7E09
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhG0SxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:53:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229453AbhG0SxN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 14:53:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627411993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pywaGuqiWa+m7IiTARlllehIqVu1cJ37vlNw1KlZgMk=;
        b=M9ur1aRiiiQjgCaGe+rgz0Q+693/HPJ6+cetAo9uf9Cg3MEv9VSBUbH/Ru4Nh1u4uopbhk
        MGmlBplY3tmeBs6LHjhWa8o9K2MJdcF1/7OCZ6rwxnLnX5plRLkagi0TErLd0cH71eP656
        B4YNbv44NF5Pjumy/u+5yMGP0NvYsE0=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-QDsplI6cMymhTFA0lsrAeQ-1; Tue, 27 Jul 2021 14:53:11 -0400
X-MC-Unique: QDsplI6cMymhTFA0lsrAeQ-1
Received: by mail-oo1-f69.google.com with SMTP id u5-20020a4a97050000b029026a71f65966so43495ooi.2
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 11:53:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pywaGuqiWa+m7IiTARlllehIqVu1cJ37vlNw1KlZgMk=;
        b=RoB1III1/HJgPXJul+YSsxRafvffNNQa/MPzm24guHMDWvFrfwNAWW2PuFwLBHX2qp
         WPqci08JC0/yeaBxtnqN2ZjiUqLUVV3QSa5p+4PEXPVTxXRsGyP2U4xhsoIo+OYhQKOG
         R4pR8eb1ZIZVbXZ9X1sL0qRd9+257iWk/F3Fkjop6qlCWOa0be92jg6dCuqCsvQSNzI1
         Zw4Mt8AHCTmKpsIBp1eVvgkURM+SoINU5o9BBdrVv4Yb9hUAzGG+rIvVQk4dE+E/XuaO
         S3aTeCakns3pkkKDlzmz1dF+R9FqYlCLdvQoV/VsQjWEGzvt/n1ODXHVyY43UH3ybRJX
         yC0A==
X-Gm-Message-State: AOAM5311lDvRWZMkHWYOI8FjSiU5FIUuhUj/vt5USiWSj65unlX5Y4wc
        acO4+KPMh2vbjy6jas3iO3E9ge0bj44RSipF9o0o9KYcAdDWQ5Op9AzcrzGvtD0b9zkT3wukJXv
        bwQr726fna3Gs
X-Received: by 2002:a05:6830:11d3:: with SMTP id v19mr17222653otq.98.1627411991238;
        Tue, 27 Jul 2021 11:53:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQACTDPYwC/EEIPJP2/Eptj4nf31Vq9hx3nse0SZ0K8pyRgSXydLLBvOMzEu23g7Kl+qQZQA==
X-Received: by 2002:a05:6830:11d3:: with SMTP id v19mr17222644otq.98.1627411991056;
        Tue, 27 Jul 2021 11:53:11 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id a7sm613602ooo.9.2021.07.27.11.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:53:10 -0700 (PDT)
Date:   Tue, 27 Jul 2021 12:53:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio/mdev: don't warn if ->request is not set
Message-ID: <20210727125309.292b30c0.alex.williamson@redhat.com>
In-Reply-To: <20210727173209.GG1721383@nvidia.com>
References: <20210726143524.155779-1-hch@lst.de>
        <20210726143524.155779-3-hch@lst.de>
        <87zgu93sxz.fsf@redhat.com>
        <20210726230906.GD1721383@nvidia.com>
        <20210726172831.3a7978fd.alex.williamson@redhat.com>
        <87wnpc47j3.fsf@redhat.com>
        <20210727173209.GG1721383@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 27 Jul 2021 14:32:09 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jul 27, 2021 at 08:04:16AM +0200, Cornelia Huck wrote:
> > On Mon, Jul 26 2021, Alex Williamson <alex.williamson@redhat.com> wrote:
> >   
> > > On Mon, 26 Jul 2021 20:09:06 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >  
> > >> On Mon, Jul 26, 2021 at 07:07:04PM +0200, Cornelia Huck wrote:
> > >>   
> > >> > But I wonder why nobody else implements this? Lack of surprise removal?    
> > >> 
> > >> The only implementation triggers an eventfd that seems to be the same
> > >> eventfd as the interrupt..
> > >> 
> > >> Do you know how this works in userspace? I'm surprised that the
> > >> interrupt eventfd can trigger an observation that the kernel driver
> > >> wants to be unplugged?  
> > >
> > > I think we're talking about ccw, but I see QEMU registering separate
> > > eventfds for each of the 3 IRQ indexes and the mdev driver specifically
> > > triggering the req_trigger...?  Thanks,
> > >
> > > Alex  
> > 
> > Exactly, ccw has a trigger for normal I/O interrupts, CRW (machine
> > checks), and this one.  
> 
> If it is a dedicated eventfd for 'device being removed' why is it in
> the CCW implementation and not core code?

The CCW implementation (likewise the vfio-pci implementation) owns the
IRQ index address space and the decision to make this a signal to
userspace rather than perhaps some handling a device might be able to
do internally.  For instance an alternate vfio-pci implementation might
zap all mmaps, block all r/w access, and turn this into a surprise
removal.  Another implementation might be more aggressive to sending
SIGKILL to the user process.  This was the thought behind why vfio-core
triggers the driver request callback with a counter, leaving the policy
to the driver.

> Is PCI doing the same?

Yes, that's where this handling originated.  Thanks,

Alex

