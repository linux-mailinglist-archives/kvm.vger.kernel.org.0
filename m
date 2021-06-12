Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E6B3A4FCF
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 18:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhFLQ7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Jun 2021 12:59:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230372AbhFLQ7S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Jun 2021 12:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623517037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=shhxkeyT6sH5lJV4f12+U24GPPhn47S3juDgxTTkERI=;
        b=aoatqcD4IDqiQcGVyVmhTcM+WDiodee0qJYFOG7Rv5p8ecN/eVoyGesLMnuMmaOLOQ55dU
        sZPwopSQ+Ee4oCUVWv+ZRyiTOyCj8AEg2eB32r+pEH9/e+yBbQRoVk/KcAeBqe4RczRerD
        9B16zWSewqfq/LOKc64/DevlaFE2b/Q=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-V7g0M3XTOfWX3WCORLaFkA-1; Sat, 12 Jun 2021 12:57:15 -0400
X-MC-Unique: V7g0M3XTOfWX3WCORLaFkA-1
Received: by mail-oi1-f198.google.com with SMTP id x22-20020a05680801d6b02901f96b55896fso652147oic.4
        for <kvm@vger.kernel.org>; Sat, 12 Jun 2021 09:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=shhxkeyT6sH5lJV4f12+U24GPPhn47S3juDgxTTkERI=;
        b=ZJEknbeNPh2G7s4gpCQj7OMeZ2TtIvMmlnoHq53vTLfMhxv+1t1PuKQAdBBvCv2CVC
         fMxv4WsqZUczb1WZ6irEmDEIuVCGeP0zGKaTPsglJ7VWkNbVnFY1CF93xmMlhd460e3B
         0WwM2cKpQny08kYxq0+pMLxz5/guwAONfsfiyI36Kz1uD1E8VyDuSwPivJ6YQk/X0AFz
         Wv2FtXL+LW/e4CaPoteUc0XatAjxhmaoeEjOtS1cxEZJaaWJmad0GMzPlCZPCxzsMLqB
         wgJEnMwDhcV26xytoQd7yRUrYYKK20oqOIVra4fIjmZ4jKRTpopAnynY1aweEp5L9zIi
         ph/A==
X-Gm-Message-State: AOAM5323FfzW6f8Zw+rYMrC8ne9TGkbdGbc0AJa+WNiLLRi6L5AOX2un
        LjKTQOMkP78gOJKBeBTIt1VNdveW/F2W6A8rsPT5Y2LXmKh3nPhX1Jlu4YPybrg+B/sM6Ql30Cz
        g2DvjC/sjb3aX
X-Received: by 2002:a9d:7a55:: with SMTP id z21mr7445189otm.207.1623517035266;
        Sat, 12 Jun 2021 09:57:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuTiKSVBxMD+ahZaJ1En1PUkcexZpbiOJtftxlXbhzmxQW4kNWjPJHfTiwexjJMeyyHeq+vg==
X-Received: by 2002:a9d:7a55:: with SMTP id z21mr7445167otm.207.1623517034995;
        Sat, 12 Jun 2021 09:57:14 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id z5sm441638oth.6.2021.06.12.09.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 09:57:14 -0700 (PDT)
Date:   Sat, 12 Jun 2021 10:57:11 -0600
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
Message-ID: <20210612105711.7ac68c83.alex.williamson@redhat.com>
In-Reply-To: <20210612012846.GC1002214@nvidia.com>
References: <20210609123919.GA1002214@nvidia.com>
        <YMDC8tOMvw4FtSek@8bytes.org>
        <20210609150009.GE1002214@nvidia.com>
        <YMDjfmJKUDSrbZbo@8bytes.org>
        <20210609101532.452851eb.alex.williamson@redhat.com>
        <20210609102722.5abf62e1.alex.williamson@redhat.com>
        <20210609184940.GH1002214@nvidia.com>
        <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
        <20210611164529.GR1002214@nvidia.com>
        <20210611133828.6c6e8b29.alex.williamson@redhat.com>
        <20210612012846.GC1002214@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Jun 2021 22:28:46 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Jun 11, 2021 at 01:38:28PM -0600, Alex Williamson wrote:
> 
> > That's fine for a serial port, but not a device that can do DMA.
> > The entire point of vfio is to try to provide secure, DMA capable
> > userspace drivers.  If we relax enforcement of that isolation we've
> > failed.  
> 
> I don't understand why the IOASID matters at all in this. Can you
> explain? What is the breach of isolation?

I think we're arguing past each other again.  VFIO does not care one
iota how userspace configures IOASID domains for devices.  OTOH, VFIO
must be absolutely obsessed that the devices we're providing userspace
access to are isolated and continue to be isolated for the extent of
that access.  Given that we define that a group is the smallest set of
devices that can be isolated, that means that for a device to be
isolated, the group needs to be isolated.

VFIO currently has a contract with the IOMMU backend that a group is
attached to an IOMMU context (container) and from that point forward,
all devices within that group are known to be isolated.

I'm trying to figure out how a device based interface to the IOASID can
provide that same contract or whether VFIO needs to be able to monitor
the IOASID attachments of the devices in a group to control whether
device access is secure.

As I outlined to Kevin, I think it makes a lot of sense to maintain a
group interface to the IOASID where registering a group signifies a
hand-off of responsibility to the IOASIDfd that it is responsible for
the isolation of those devices.  From there we can determine the value
of exposing VFIO device fds directly and whether any of the VFIO
interfaces for attaching devices to IOASIDs make sense versus switching
to the IOASIDfd at that point.

Otherwise, for a device centric VFIO/IOASID model, I need to understand
exactly when and how VFIO can know that it's safe to provide access to
a device and how the IOASID model guarantees the ongoing safety of that
access, which must encompass the safety relative to the entire group.

For example, is it VFIO's job to BIND every device in the group?  Does
binding the device represent the point at which the IOASID takes
responsibility for the isolation of the device?  If instead it's the
ATTACH of a device that provides the isolation, how is VFIO supposed to
handle device access across a group when one device is DETACH'd by the
user?  If ATTACH is the point where isolation is guaranteed, can a
DETACH occur through the IOASIDfd rather than the VFIOfd?  It seems
like the IOASIDfd is going to need ways to manipulate device:IOASID
mappings outside of VFIO, so again I wonder if we should switch to an
IOASID uAPI at that point rather than using VFIO.  Thanks,

Alex

