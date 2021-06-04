Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFA339BBCB
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 17:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhFDP2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 11:28:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59296 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229675AbhFDP2L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 11:28:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622820384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cnlp4NT59C1lbKlOOtPNARWk0nt3/Bc4USIsMgJ3F/s=;
        b=YA+RFoWG02sSDtuZJ2b6wq1JJsTfXazRH8KBUwT8JCVr89r4I94/8BjymtIg0Pf/OJJzff
        7JPg6TduQvXRysSDp5z2jAFr2P+DhmwHpCxWEb7oX55ELd8d9WHVHSw/LxRSdoYe58QSYn
        CjrMNdOOVfty5MJwCMtWmcqUS4C5Lho=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-H-1pn-6bNUaNJQeNGkHHRA-1; Fri, 04 Jun 2021 11:26:22 -0400
X-MC-Unique: H-1pn-6bNUaNJQeNGkHHRA-1
Received: by mail-il1-f198.google.com with SMTP id 15-20020a920d0f0000b02901c54acae19eso6681329iln.23
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 08:26:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Cnlp4NT59C1lbKlOOtPNARWk0nt3/Bc4USIsMgJ3F/s=;
        b=jHNaAYWbz/hMo01OUwSil7gQee1/DJdVmHBKr6HjekMia1B/t8pJdjjRsrTli7x1j3
         4iwkdTQiIXkE0cd9pq1UFWI2wVjz49TF6Qlcd7JjMHWDLsc2+eSSuQdZu2p/zVGm0YGf
         rxBf1+jenIbvv4tFOgMBKZDX+5DhWO03kgzFjgDKb0ErFuRxU8w7rd5H+AWbQNYvsl/L
         yVvCnCzk15ym/SU35XID+ckG0V/t0sEtf4/X9VfoTXPaQICWuwaWbIiDSN67Xg6/u6Uh
         8svlLJhNnIFHb7CzjgvqCwwONgrbKJCXFRWwsfGYf3fql2qD0+VZ48pUsbcuZr9GFGtR
         V1Rg==
X-Gm-Message-State: AOAM5336xdVCGtlbmz899sTNNfTovF6O2xhtwj9g2cPckEDaHfaLJPbt
        3ePQA+Dy8PRRzy0fBRoWsyZRlvR6532YdZS9jRbRzACEC+QzIMQ/pUAlBiFVdWfCJyrxhizSykK
        BqB9HMBjgFCHR
X-Received: by 2002:a92:1901:: with SMTP id 1mr4431841ilz.237.1622820382123;
        Fri, 04 Jun 2021 08:26:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytV7IHrrQ9TrO5WGLSgtz4HPoOXVeF1qXN+c3eDfItb7Gtmxe5A63obJpbAcW06e9tden5Rg==
X-Received: by 2002:a92:1901:: with SMTP id 1mr4431821ilz.237.1622820381869;
        Fri, 04 Jun 2021 08:26:21 -0700 (PDT)
Received: from redhat.com (c-73-14-100-188.hsd1.co.comcast.net. [73.14.100.188])
        by smtp.gmail.com with ESMTPSA id l13sm59605ilc.53.2021.06.04.08.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 08:26:21 -0700 (PDT)
Date:   Fri, 4 Jun 2021 09:26:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
        Jason Wang <jasowang@redhat.com>,
        "Bonzini, Paolo" <pbonzini@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604092620.16aaf5db.alex.williamson@redhat.com>
In-Reply-To: <20210604122830.GK1002214@nvidia.com>
References: <20210602130053.615db578.alex.williamson@redhat.com>
        <20210602195404.GI1002214@nvidia.com>
        <20210602143734.72fb4fa4.alex.williamson@redhat.com>
        <20210602224536.GJ1002214@nvidia.com>
        <20210602205054.3505c9c3.alex.williamson@redhat.com>
        <20210603123401.GT1002214@nvidia.com>
        <20210603140146.5ce4f08a.alex.williamson@redhat.com>
        <20210603201018.GF1002214@nvidia.com>
        <20210603154407.6fe33880.alex.williamson@redhat.com>
        <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210604122830.GK1002214@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Cc +Paolo]

On Fri, 4 Jun 2021 09:28:30 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Jun 04, 2021 at 08:38:26AM +0000, Tian, Kevin wrote:
> > > I think more to drive the replacement design; if we can't figure out
> > > how to do something other than backwards compatibility trickery in the
> > > kernel, it's probably going to bite us.  Thanks,  
> > 
> > I'm a bit lost on the desired flow in your minds. Here is one flow based
> > on my understanding of this discussion. Please comment whether it
> > matches your thinking:
> > 
> > 0) ioasid_fd is created and registered to KVM via KVM_ADD_IOASID_FD;
> > 
> > 1) Qemu binds dev1 to ioasid_fd;
> > 
> > 2) Qemu calls IOASID_GET_DEV_INFO for dev1. This will carry IOMMU_
> >      CACHE info i.e. whether underlying IOMMU can enforce snoop;
> > 
> > 3) Qemu plans to create a gpa_ioasid, and attach dev1 to it. Here Qemu
> >     needs to figure out whether dev1 wants to do no-snoop. This might
> >     be based a fixed vendor/class list or specified by user;
> > 
> > 4) gpa_ioasid = ioctl(ioasid_fd, IOASID_ALLOC); At this point a 'snoop'
> >      flag is specified to decide the page table format, which is supposed
> >      to match dev1;  
> 
> > 5) Qemu attaches dev1 to gpa_ioasid via VFIO_ATTACH_IOASID. At this 
> >      point, specify snoop/no-snoop again. If not supported by related 
> >      iommu or different from what gpa_ioasid has, attach fails.  
> 
> Why do we need to specify it again?

My thought as well.

> If the IOASID was created with the "block no-snoop" flag then it is
> blocked in that IOASID, and that blocking sets the page table format.
> 
> The only question is if we can successfully attach a device to the
> page table, or not.
> 
> The KVM interface is a bit tricky because Alex said this is partially
> security, wbinvd is only enabled if someone has a FD to a device that
> can support no-snoop. 
> 
> Personally I think this got way too complicated, the KVM interface
> should simply be
> 
> ioctl(KVM_ALLOW_INCOHERENT_DMA, ioasidfd, device_label)
> ioctl(KVM_DISALLOW_INCOHERENT_DMA, ioasidfd, device_label)
> 
> and let qemu sort it out based on command flags, detection, whatever.
> 
> 'ioasidfd, device_label' is the security proof that Alex asked
> for. This needs to be some device in the ioasidfd that declares it is
> capabale of no-snoop. Eg vfio_pci would always declare it is capable
> of no-snoop.
> 
> No kernel call backs, no kernel auto-sync/etc. If qemu mismatches the
> IOASID block no-snoop flag with the KVM_x_INCOHERENT_DMA state then it
> is just a kernel-harmless uerspace bug.
> 
> Then user space can decide which of the various axis's it wants to
> optimize for.

Let's make sure the KVM folks are part of this decision; a re-cap for
them, KVM currently automatically enables wbinvd emulation when
potentially non-coherent devices are present which is determined solely
based on the IOMMU's (or platform's, as exposed via the IOMMU) ability
to essentially force no-snoop transactions from a device to be cache
coherent.  This synchronization is triggered via the kvm-vfio device,
where QEMU creates the device and adds/removes vfio group fd
descriptors as an additionally layer to prevent the user from enabling
wbinvd emulation on a whim.

IIRC, this latter association was considered a security/DoS issue to
prevent a malicious guest/userspace from creating a disproportionate
system load.

Where would KVM stand on allowing more direct userspace control of
wbinvd behavior?  Would arbitrary control be acceptable or should we
continue to require it only in association to a device requiring it for
correct operation.

A wrinkle in "correct operation" is that while the IOMMU may be able to
force no-snoop transactions to be coherent, in the scenario described
in the previous reply, the user may intend to use non-coherent DMA
regardless of the IOMMU capabilities due to their own optimization
policy.  There's a whole spectrum here, including aspects we can't
determine around the device driver's intentions to use non-coherent
transactions, the user's policy in trading hypervisor overhead for
cache coherence overhead, etc.  Thanks,

Alex

