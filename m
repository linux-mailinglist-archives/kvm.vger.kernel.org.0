Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE15F1891
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 15:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfKFOZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 09:25:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbfKFOZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 09:25:34 -0500
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 061127C097
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 14:25:34 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id l5so26211990qtj.8
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 06:25:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=31iMCcCmEX1Wa0kDQtfFxRZ0WpCEzjs94AiuqerMIf8=;
        b=F8ri37l3UQKIXdsmxHGGSN6sS8FXasH9Jc8PeXKht2HcVxPwDMzZzpxsf4iRpWmuEG
         bXekG3fjJ+MPYMc1bbNRHsxUgo8Cth0gXYKTBZl0/5ftPjupjgQHBCIH2dnzLxzOYsXd
         BZ0WKe+uPw0SZPT2Q+xAr2XojtmkZWGe605IYy3lfjippAq+ougIemMV5Qm84lTzvBTC
         j+QsvuFccs2dVbZWZi5j2/Z5nzij33XiT5sEJUmqzbZBn854qeRPCG4u8fAtlt335Ob5
         UdDxXShi5Kecq+wj41AtHyiw7j30PtQIVaDPfDIM++Wm3rO4UNkS8hIEFysF0tkDU2uO
         maLA==
X-Gm-Message-State: APjAAAWmfdPbVqHKvDkF5G5fGgOCeaWhhc0EyoHfQy4CtHnaOHb/bGHC
        b08IZE/N70a7u2qNog51mPAPGivajGHkwLgggrMuF2wrODbYY29j/VtyP9EXaMb2yRNBqaIaz2n
        QXQUvsdRQiOdD
X-Received: by 2002:a37:9d0:: with SMTP id 199mr2259459qkj.356.1573050333287;
        Wed, 06 Nov 2019 06:25:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1Kpy20MjAZEmt2B/VsODBQDaTjbkycBeMhd823BpzG029+EschXsAE7qkQQ3+/eJfx8W0tA==
X-Received: by 2002:a37:9d0:: with SMTP id 199mr2259433qkj.356.1573050332945;
        Wed, 06 Nov 2019 06:25:32 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h25sm905409qka.117.2019.11.06.06.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:25:31 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:25:30 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 14/22] vfio/pci: add iommu_context notifier for pasid
 bind/unbind
Message-ID: <20191106142530.GB29717@xz-x1>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-15-git-send-email-yi.l.liu@intel.com>
 <20191104160228.GG3552@umbus.metropole.lan>
 <A2975661238FB949B60364EF0F2C25743A0EF2F1@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A0EF2F1@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 12:22:46PM +0000, Liu, Yi L wrote:
> > From: David Gibson
> > Sent: Tuesday, November 5, 2019 12:02 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v2 14/22] vfio/pci: add iommu_context notifier for pasid
> > bind/unbind
> > 
> > On Thu, Oct 24, 2019 at 08:34:35AM -0400, Liu Yi L wrote:
> > > This patch adds notifier for pasid bind/unbind. VFIO registers this
> > > notifier to listen to the dual-stage translation (a.k.a. nested
> > > translation) configuration changes and propagate to host. Thus vIOMMU
> > > is able to set its translation structures to host.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > Cc: David Gibson <david@gibson.dropbear.id.au>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > >  hw/vfio/pci.c            | 39 +++++++++++++++++++++++++++++++++++++++
> > >  include/hw/iommu/iommu.h | 11 +++++++++++
> > >  2 files changed, 50 insertions(+)
> > >
> > > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> > > index 8721ff6..012b8ed 100644
> > > --- a/hw/vfio/pci.c
> > > +++ b/hw/vfio/pci.c
> > > @@ -2767,6 +2767,41 @@ static void
> > vfio_iommu_pasid_free_notify(IOMMUCTXNotifier *n,
> > >      pasid_req->free_result = ret;
> > >  }
> > >
> > > +static void vfio_iommu_pasid_bind_notify(IOMMUCTXNotifier *n,
> > > +                                         IOMMUCTXEventData *event_data)
> > > +{
> > > +#ifdef __linux__
> > 
> > Is hw/vfio/pci.c even built on non-linux hosts?
> 
> I'm not quite sure. It's based a comment from RFC v1. I think it could somehow
> prevent compiling issue when doing code porting. So I added it. If it's impossible
> to build on non-linux hosts per your experience, I can remove it to make things
> simple.

To my understanding this should not be needed because VFIO doesn't
work with non-linux after all (as said)... while...

> 
> > > +    VFIOIOMMUContext *giommu_ctx = container_of(n, VFIOIOMMUContext, n);
> > > +    VFIOContainer *container = giommu_ctx->container;
> > > +    IOMMUCTXPASIDBindData *pasid_bind =
> > > +                              (IOMMUCTXPASIDBindData *) event_data->data;
> > > +    struct vfio_iommu_type1_bind *bind;
> > > +    struct iommu_gpasid_bind_data *bind_data;
> > > +    unsigned long argsz;
> > > +
> > > +    argsz = sizeof(*bind) + sizeof(*bind_data);
> > > +    bind = g_malloc0(argsz);
> > > +    bind->argsz = argsz;
> > > +    bind->bind_type = VFIO_IOMMU_BIND_GUEST_PASID;
> > > +    bind_data = (struct iommu_gpasid_bind_data *) &bind->data;
> > > +    *bind_data = *pasid_bind->data;
> > > +
> > > +    if (pasid_bind->flag & IOMMU_CTX_BIND_PASID) {
> > > +        if (ioctl(container->fd, VFIO_IOMMU_BIND, bind) != 0) {
> > > +            error_report("%s: pasid (%llu:%llu) bind failed: %d", __func__,
> > > +                         bind_data->gpasid, bind_data->hpasid, -errno);
> > > +        }
> > > +    } else if (pasid_bind->flag & IOMMU_CTX_UNBIND_PASID) {
> > > +        if (ioctl(container->fd, VFIO_IOMMU_UNBIND, bind) != 0) {
> > > +            error_report("%s: pasid (%llu:%llu) unbind failed: %d", __func__,
> > > +                         bind_data->gpasid, bind_data->hpasid, -errno);
> > > +        }
> > > +    }
> > > +
> > > +    g_free(bind);
> > > +#endif
> > > +}
> > > +
> > >  static void vfio_realize(PCIDevice *pdev, Error **errp)
> > >  {
> > >      VFIOPCIDevice *vdev = PCI_VFIO(pdev);
> > > @@ -3079,6 +3114,10 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
> > >                                           iommu_context,
> > >                                           vfio_iommu_pasid_free_notify,
> > >                                           IOMMU_CTX_EVENT_PASID_FREE);
> > > +        vfio_register_iommu_ctx_notifier(vdev,
> > > +                                         iommu_context,
> > > +                                         vfio_iommu_pasid_bind_notify,
> > > +                                         IOMMU_CTX_EVENT_PASID_BIND);
> > >      }
> > >
> > >      return;
> > > diff --git a/include/hw/iommu/iommu.h b/include/hw/iommu/iommu.h
> > > index 4352afd..4f21aa1 100644
> > > --- a/include/hw/iommu/iommu.h
> > > +++ b/include/hw/iommu/iommu.h
> > > @@ -33,6 +33,7 @@ typedef struct IOMMUContext IOMMUContext;
> > >  enum IOMMUCTXEvent {
> > >      IOMMU_CTX_EVENT_PASID_ALLOC,
> > >      IOMMU_CTX_EVENT_PASID_FREE,
> > > +    IOMMU_CTX_EVENT_PASID_BIND,
> > >      IOMMU_CTX_EVENT_NUM,
> > >  };
> > >  typedef enum IOMMUCTXEvent IOMMUCTXEvent;
> > > @@ -50,6 +51,16 @@ union IOMMUCTXPASIDReqDesc {
> > >  };
> > >  typedef union IOMMUCTXPASIDReqDesc IOMMUCTXPASIDReqDesc;
> > >
> > > +struct IOMMUCTXPASIDBindData {
> > > +#define IOMMU_CTX_BIND_PASID   (1 << 0)
> > > +#define IOMMU_CTX_UNBIND_PASID (1 << 1)
> > > +    uint32_t flag;
> > > +#ifdef __linux__
> > > +    struct iommu_gpasid_bind_data *data;
> > 
> > Embedding a linux specific structure in the notification message seems
> > dubious to me.
> 
> Just similar as your above comment in this thread. If we don't want to add
> it there, then here it is also unnecessary.

... I'm not sure but maybe we need this here because I _think_ vt-d
should even work on Windows.  However instead of __linux__ over *data,
should you cover the whole IOMMUCTXPASIDBindData?

-- 
Peter Xu
