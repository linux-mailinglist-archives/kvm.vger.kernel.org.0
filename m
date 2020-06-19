Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA28200807
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 13:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbgFSLqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 07:46:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37077 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731384AbgFSLqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 07:46:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592567177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/txUJLTsCGWI2jJ+EPr2kRf/3k5YaazR3qPt83U1j94=;
        b=U1IYLVp3X4DEbgAQgF1+313sCK8NHkI6sNT7f/i3BpB9Gw64ujqO4aoC9ByfnULLTjH4MX
        yU0QYYazjwekHUYeEqzCf7NJxSeTE18Tebn/9uhJxstkur24PFlZawqI9Z5779rWy9ywq8
        Po9pnHSCA8FA0pasX3wAPNQdtRf1wAo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-xDJ8Eh66NZGGogM0H_MxPQ-1; Fri, 19 Jun 2020 07:46:15 -0400
X-MC-Unique: xDJ8Eh66NZGGogM0H_MxPQ-1
Received: by mail-wm1-f72.google.com with SMTP id y15so2603934wmi.0
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 04:46:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/txUJLTsCGWI2jJ+EPr2kRf/3k5YaazR3qPt83U1j94=;
        b=f9pY6ESVY2QPlTSRdx8V9REEkWswW5Mfe9RyovjWPEpRK7pmU1A8GErqqn32n9XUd2
         1LL4XU88DqBjmo3fUAtoFo5ZBONM3K/doOCzO2BZeiVYZZ/yr0h5aT+nZHzDg8z8okgE
         4i17iWiJIF2KMD3T25i55C7n045TvRITO4fOmbs+KvdpyJzI5Owp3wBe8nl42Ko6RVTt
         da2e/jtBxaAkoeuirOOdhTLx8sN7IpW1UvVv/6AWmZBw8hNpsCeCUmcoZpZYTIM+qdqa
         qWAqF/BvEDtv99lmsweFhEDExNkCIyIl1UWtYgZM8cnPbesF3JF7XppK3Er1pEQXeHHC
         NdPg==
X-Gm-Message-State: AOAM531bwaVpphqz2Jq467p4WbJ3oRYIUGoTsh1RKO4e93/iyEnmeov9
        nstXtdFa18gZ64YyaErk0CGaGSt+FNCkF5PkirXVhfx5ZIjXBKpCC1a5yVB5aweeGEqKcfkd6yC
        xeCLUyrOSupUq
X-Received: by 2002:a5d:4903:: with SMTP id x3mr3831862wrq.351.1592567174591;
        Fri, 19 Jun 2020 04:46:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyE+AprZveIUH1rr2brcb+FX1fg23kiEzxeBsxNbpesGWafMAFpRcl46POsQmCIkorW834sw==
X-Received: by 2002:a5d:4903:: with SMTP id x3mr3831839wrq.351.1592567174362;
        Fri, 19 Jun 2020 04:46:14 -0700 (PDT)
Received: from redhat.com (bzq-79-178-18-124.red.bezeqint.net. [79.178.18.124])
        by smtp.gmail.com with ESMTPSA id d2sm7036388wrs.95.2020.06.19.04.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 04:46:13 -0700 (PDT)
Date:   Fri, 19 Jun 2020 07:46:10 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        cohuck@redhat.com, david@redhat.com, mdroth@linux.vnet.ibm.com,
        pasic@linux.ibm.com, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v3 9/9] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200619074432-mutt-send-email-mst@kernel.org>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
 <20200619020602.118306-10-david@gibson.dropbear.id.au>
 <20200619101245.GC700896@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200619101245.GC700896@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 19, 2020 at 11:12:45AM +0100, Daniel P. Berrangé wrote:
> On Fri, Jun 19, 2020 at 12:06:02PM +1000, David Gibson wrote:
> > The default behaviour for virtio devices is not to use the platforms normal
> > DMA paths, but instead to use the fact that it's running in a hypervisor
> > to directly access guest memory.  That doesn't work if the guest's memory
> > is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> > 
> > So, if a host trust limitation mechanism is enabled, then apply the
> > iommu_platform=on option so it will go through normal DMA mechanisms.
> > Those will presumably have some way of marking memory as shared with the
> > hypervisor or hardware so that DMA will work.
> > 
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  hw/core/machine.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/hw/core/machine.c b/hw/core/machine.c
> > index a71792bc16..8dfc1bb3f8 100644
> > --- a/hw/core/machine.c
> > +++ b/hw/core/machine.c
> > @@ -28,6 +28,8 @@
> >  #include "hw/mem/nvdimm.h"
> >  #include "migration/vmstate.h"
> >  #include "exec/host-trust-limitation.h"
> > +#include "hw/virtio/virtio.h"
> > +#include "hw/virtio/virtio-pci.h"
> >  
> >  GlobalProperty hw_compat_5_0[] = {
> >      { "virtio-balloon-device", "page-poison", "false" },
> > @@ -1165,6 +1167,15 @@ void machine_run_board_init(MachineState *machine)
> >           * areas.
> >           */
> >          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> > +
> > +        /*
> > +         * Virtio devices can't count on directly accessing guest
> > +         * memory, so they need iommu_platform=on to use normal DMA
> > +         * mechanisms.  That requires disabling legacy virtio support
> > +         * for virtio pci devices
> > +         */
> > +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy", "on");
> > +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform", "on");
> >      }
> 
> Silently changing the user's request configuration like this is a bad idea.
> The "disable-legacy" option in particular is undesirable as that switches
> the device to virtio-1.0 only mode, which exposes a different PCI ID to
> the guest.
> 
> If some options are incompatible with encryption, then we should raise a
> fatal error at startup, so applications/admins are aware that their requested
> config is broken.
> 
> Regards,
> Daniel

Agreed - my suggestion is an on/off/auto property, auto value
changes automatically, on/off is validated.


> -- 
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

