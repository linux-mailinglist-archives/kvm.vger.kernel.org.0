Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6632B3A4981
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 21:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhFKTkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 15:40:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230312AbhFKTkb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 15:40:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623440312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MOwRQa2gLwRFHwfCcTkT0bHUAUhdYFDJPEsH9OOUliM=;
        b=Z602tDKOmGPeOc1cm0MK6M+b6CAsnwGmkK3uwDFqnC+CMcLvW5oD/9+M0yB36sIJLC0zQc
        H2e7hOo9XK9FywQ6XL+DQh3NDyyXvhckqiWqZH6kbEN4tt/kZ5sWZqYE7sk+7w4gXxyGIH
        +k5DeLXqKoXG7LIacmf02BFK94JQ6FE=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-RTX-dAbpPDuQCLp-Igbfcg-1; Fri, 11 Jun 2021 15:38:31 -0400
X-MC-Unique: RTX-dAbpPDuQCLp-Igbfcg-1
Received: by mail-oi1-f200.google.com with SMTP id w9-20020a0568080d49b02901f3febe5739so3389648oik.1
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 12:38:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MOwRQa2gLwRFHwfCcTkT0bHUAUhdYFDJPEsH9OOUliM=;
        b=JiUAn+3+OEyAkMNgKpIzLeuND75PuPxDr5QWlMMgVub/FoMptrVlMFg29cBatKD3Qb
         4MQIHit4UTv3YLP1TMAQ7wtyyQ5ZUZeB+6X0tJaKzFPNj/EAiGXhgMwDeS4gcUFaeEtB
         bc08de/D7avnq2MgxKHVS3en1xJ1T6GxhYka8O+59p4QiYIDQcEh4WT8SVmfRFhPSLfC
         YA6wAj42yQeACVuidrWjfV2chLB2u3GyBdsR6/ak6y+6G/NIEMAyCWZSQfTUF8HC6KHA
         gZaSPm+Unm3tUkZYKoSqxEBfY/Rfjdot5Nb1Whlcc4PJOMXYkYUVkPyQHPKtPNTu052w
         4T8g==
X-Gm-Message-State: AOAM532ThptIVe0eMELfBcrr0FkQ2pRuN9wr5N2Jyxv1EYFvYptlycwZ
        y2sz3PdKo25mD1/b8NLjsvdissfr0+VluvzNLLkqKRPC9tQzHCpn+HknVgcgzXUNdgVwuoZbhMG
        VVEo505R4phcU
X-Received: by 2002:a05:6808:916:: with SMTP id w22mr3512218oih.138.1623440310971;
        Fri, 11 Jun 2021 12:38:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw+/X+ZxRSrudtHIp7gCblUCXIcvq0N/FGf1Kdsk6TrIngH5RlTuM3lhTNw24Xdq56CnKmKCQ==
X-Received: by 2002:a05:6808:916:: with SMTP id w22mr3512212oih.138.1623440310783;
        Fri, 11 Jun 2021 12:38:30 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id l25sm1191473oie.57.2021.06.11.12.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:38:30 -0700 (PDT)
Date:   Fri, 11 Jun 2021 13:38:28 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210611133828.6c6e8b29.alex.williamson@redhat.com>
In-Reply-To: <20210611164529.GR1002214@nvidia.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
        <YMCy48Xnt/aphfh3@8bytes.org>
        <20210609123919.GA1002214@nvidia.com>
        <YMDC8tOMvw4FtSek@8bytes.org>
        <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <20210611164529.GR1002214@nvidia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Jun 2021 13:45:29 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jun 10, 2021 at 09:38:42AM -0600, Alex Williamson wrote:
> 
> > Opening the group is not the extent of the security check currently
> > required, the group must be added to a container and an IOMMU model
> > configured for the container *before* the user can get a devicefd.
> > Each devicefd creates a reference to this security context, therefore
> > access to a device does not exist without such a context.  
> 
> Okay, I missed that detail in the organization..
> 
> So, if we have an independent vfio device fd then it needs to be
> kept disable until the user joins it to an ioasid that provides the
> security proof to allow it to work?

Yes, the user would effectively get a dummy fd with no device access
until not only that device, but every device in the IOMMU group is
attached to a secure context.  Then we get into questions about whether
devices can be moved between contexts/ioasids within the same ioasidfd
and what that implies to both the device and all other devices within
the group as a device is transitioned and the system is potentially
exposed.
 
> > What happens on detach?  As we've discussed elsewhere in this thread,
> > revoking access is more difficult than holding a reference to the
> > secure context, but I'm under the impression that moving a device
> > between IOASIDs could be standard practice in this new model.  A device
> > that's detached from a secure context, even temporarily, is a
> > problem.  
> 
> This is why I think the single iommu FD is critical, it is the FD, not
> the IOASID that has to authorize the security. You shouldn't move
> devices between FDs, but you can move them between IOASIDs inside the
> same FD.

Right, but that doesn't solve the issue.  Removing a device from one
isolated context, even if to move it to another isolated context within
the same ioasidfd exposes the device and has implications for all
devices within the group.

> > How to label a device seems like a relatively mundane issue relative to
> > ownership and isolated contexts of groups and devices.  The label is
> > essentially just creating an identifier to device mapping, where the
> > identifier (label) will be used in the IOASID interface, right?   
> 
> It looks that way
> 
> > As I note above, that makes it difficult for vfio to maintain that a
> > user only accesses a device in a secure context.  This is exactly
> > why vfio has the model of getting a devicefd from a groupfd only
> > when that group is in a secure context and maintaining references to
> > that secure context for each device.  Split ownership of the secure
> > context in IOASID vs device access in vfio and exposing devicefds
> > outside the group is still a big question mark for me.  Thanks,  
> 
> I think the protection model becomes different once we allow
> individual devices inside a group to be attached to different
> IOASID's.
> 
> Now we just want some general authorization that the user is allowed
> to operate the device_fd.

That's fine for a serial port, but not a device that can do DMA.  The
entire point of vfio is to try to provide secure, DMA capable userspace
drivers.  If we relax enforcement of that isolation we've failed.

> To keep a fairly similar model to the way vfio does things today..
> 
>  - The device_fd is single open, so only one fd exists globally
>
>  - Upon first joining the iommu_fd the group is obtained inside
>    the iommu_fd. This is only possible if no other iommu_fd has
>    obtained the group

vfio_groups have an ownership model, iommu_groups do not.
 
>  - If the group can not be obtained then the device_fd is left
>    inoperable and cannot control the device
> 
>  - If multiple devices in the same group are joined then they all
>    refcount the group
> 
> It is simple, and gives semantics similar to VFIO with the notable
> difference that process can obtain a device FD, it is just inoperable
> until the iommu_fd is attached.
> 
> Removal is OK as if you remove the device_fd from the iommu_fd (only
> allowed by closing it) then a newly opened FD is inoperable.

I don't see how this provides isolation.  If a user only needs to
attach their devicefd to an ioasidfd to have full access to their
device, not even bound by attaching to an ioasid context, then we've
failed.  All devices in a group must be bound to a secure context for
the extent of the time that any device in the group is operated by a
user.  That seems non-negotiable to me.  Thanks,

Alex

