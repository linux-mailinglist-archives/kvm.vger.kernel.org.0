Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF6839E7AC
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 21:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbhFGTn1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 15:43:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231548AbhFGTnY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 15:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623094892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ktL5nWqTPLu4372fp6dA+Wp9VnIRyo2M4rsP7gUhK4E=;
        b=Lh2IycNwMqSAgwbuTF16WDt0FOMEsvcjDCslH07JHCbTYzYTpY+qs/g9bMTLNLuv+w2e0x
        Ssgi+Ty1r+FaQ9sPuXqQFCgbycF4h1cimNkTKDo8784pwIUwryKV4S4AiP4j2Th39V12ja
        EN/t0ZvmrGmKbh5Lu+B8QoidQwdit38=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-YqtA1nRmP122lUfrpmMRvA-1; Mon, 07 Jun 2021 15:41:30 -0400
X-MC-Unique: YqtA1nRmP122lUfrpmMRvA-1
Received: by mail-ot1-f69.google.com with SMTP id m20-20020a0568301e74b02903e419b82f75so5336585otr.23
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 12:41:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktL5nWqTPLu4372fp6dA+Wp9VnIRyo2M4rsP7gUhK4E=;
        b=MvAC/l26BLIwHphDGkrAIV5dbYIo8n7tltFTWlcON7bh/fmZJeYmHb3Lo0bIDa9fZ1
         3HkzNvqgcUYJ9XWFjNwcysHstIluWAs7VhQ4Va/+OPLbOYpgeVrSLz0nXWJw0MmTG/Q1
         tN8+FkUqBTTjQUTV7Lv5j6KCMQ5OyFp2eWQkzh14WyAp2Y9qOnSDgROq8Zh0C1mvN5IO
         9LyH/zyCFXfLLtF6z39phU4ZjB0gk1G3snCgNs/jTTUWDCD4arp41xaeW8bzBrFMuEqz
         ac53AomNu3wOoLLY1hH6e0bs3mJqi0LTuYUKDhyVli2n3SjeF30MYBhetub5g1mZZ4f1
         XKTA==
X-Gm-Message-State: AOAM531qptCkOPaWij94Fmh2OPnqYBMcq31SbeR4fXT0JHPeqWMp5h2F
        Y9IS0R+gswkcibqWvJfDp+0DPILP/Ewvb1ODolyj6DKQnaJih1OL2nj+I32DwUFrrccbzMc7l6n
        wOQobcHRc1k0R
X-Received: by 2002:aca:3102:: with SMTP id x2mr537467oix.1.1623094890138;
        Mon, 07 Jun 2021 12:41:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFosBz4IUOZGFguQH5//THCuRP/IrBVZiu1yVwVFAaZQAbRyF2bu+8LlE0J5GnSsN+9iyoow==
X-Received: by 2002:aca:3102:: with SMTP id x2mr537457oix.1.1623094889890;
        Mon, 07 Jun 2021 12:41:29 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id r83sm2421065oih.48.2021.06.07.12.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 12:41:29 -0700 (PDT)
Date:   Mon, 7 Jun 2021 13:41:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210607134128.58c2ea31.alex.williamson@redhat.com>
In-Reply-To: <20210607190802.GO1002214@nvidia.com>
References: <20210604155016.GR1002214@nvidia.com>
        <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
        <20210604160336.GA414156@nvidia.com>
        <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
        <20210604172207.GT1002214@nvidia.com>
        <20210604152918.57d0d369.alex.williamson@redhat.com>
        <20210604230108.GB1002214@nvidia.com>
        <20210607094148.7e2341fc.alex.williamson@redhat.com>
        <20210607181858.GM1002214@nvidia.com>
        <20210607125946.056aafa2.alex.williamson@redhat.com>
        <20210607190802.GO1002214@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Jun 2021 16:08:02 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jun 07, 2021 at 12:59:46PM -0600, Alex Williamson wrote:
> 
> > > It is up to qemu if it wants to proceed or not. There is no issue with
> > > allowing the use of no-snoop and blocking wbinvd, other than some
> > > drivers may malfunction. If the user is certain they don't have
> > > malfunctioning drivers then no issue to go ahead.  
> > 
> > A driver that knows how to use the device in a coherent way can
> > certainly proceed, but I suspect that's not something we can ask of
> > QEMU.  QEMU has no visibility to the in-use driver and sketchy ability
> > to virtualize the no-snoop enable bit to prevent non-coherent DMA from
> > the device.  There might be an experimental ("x-" prefixed) QEMU device
> > option to allow user override, but QEMU should disallow the possibility
> > of malfunctioning drivers by default.  If we have devices that probe as
> > supporting no-snoop, but actually can't generate such traffic, we might
> > need a quirk list somewhere.  
> 
> Compatibility is important, but when I look in the kernel code I see
> very few places that call wbinvd(). Basically all DRM for something
> relavent to qemu.
> 
> That tells me that the vast majority of PCI devices do not generate
> no-snoop traffic.

Unfortunately, even just looking at devices across a couple laptops
most devices do support and have NoSnoop+ set by default.  I don't
notice anything in the kernel that actually tries to set this enable (a
handful that actively disable), so I assume it's done by the firmware.
It's not safe for QEMU to make an assumption that only GPUs will
actually make use of it.

> > > I think it makes the software design much simpler if the security
> > > check is very simple. Possessing a suitable device in an ioasid fd
> > > container is enough to flip on the feature and we don't need to track
> > > changes from that point on. We don't need to revoke wbinvd if the
> > > ioasid fd changes, for instance. Better to keep the kernel very simple
> > > in this regard.  
> > 
> > You're suggesting that a user isn't forced to give up wbinvd emulation
> > if they lose access to their device?    
> 
> Sure, why do we need to be stricter? It is the same logic I gave
> earlier, once an attacker process has access to wbinvd an attacker can
> just keep its access indefinitely.
> 
> The main use case for revokation assumes that qemu would be
> compromised after a device is hot-unplugged and you want to block off
> wbinvd. But I have a hard time seeing that as useful enough to justify
> all the complicated code to do it...

It's currently just a matter of the kvm-vfio device holding a reference
to the group so that it cannot be used elsewhere so long as it's being
used to elevate privileges on a given KVM instance.  If we conclude that
access to a device with the right capability is required to gain a
privilege, I don't really see how we can wave aside that the privilege
isn't lost with the device.

> For KVM qemu can turn on/off on hot plug events as it requires to give
> VM security. It doesn't need to rely on the kernel to control this.

Yes, QEMU can reject a hot-unplug event, but then QEMU retains the
privilege that the device grants it.  Releasing the device and
retaining the privileged gained by it seems wrong.  Thanks,

Alex

