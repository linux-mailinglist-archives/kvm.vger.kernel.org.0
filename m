Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE742193F65
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 14:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgCZNC6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 09:02:58 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:23437 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbgCZNC6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 09:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585227776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aFL1ls+s+Uuiosop9UleN9TMvWOg15DAPu9qEfNR8Rg=;
        b=IBaR9beZaie5rXWs828DDBjlnBpE/2NlAKeHjY8gvW9FSKN9/p8feXKh7w9YlYhF3wsCxx
        Jh0JxJ+qO3X8IEyGsrxpBC4eOnkGyGVpDey3E60ng76c7MKMpUb8I0o/m+h3WBhRwSXE1s
        Frr/ZRpfYcU0h2GP9JZ8ZAEx5TOMLCs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-KxIYgBPNO9S9MKt88D5XbA-1; Thu, 26 Mar 2020 09:02:54 -0400
X-MC-Unique: KxIYgBPNO9S9MKt88D5XbA-1
Received: by mail-wm1-f69.google.com with SMTP id f207so2426130wme.6
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 06:02:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aFL1ls+s+Uuiosop9UleN9TMvWOg15DAPu9qEfNR8Rg=;
        b=pvFqHOL2un8EPkPsCa97o1bSiw5/3VNDz0g19ZwJWnZhzOmxkaAZHEbHxWmyQwyddL
         /vS6h3PEyUzveZwXtiy4G2NHFgBfjgiuCHgXbeKPACxLAhZE+ISrBcBlYr1FE3QxV0aN
         tsGI2jzwPVXv83xL7TLF8XkHME/q60rtR9u58bdPPZMTvDStgRnyiNWQJG2T4g05Su7X
         EwqVzQmO5oEPQmZCPngaHYGmeRcTnXMA1WOTxnqD+3jgnxgLbSXhfPjtrqwhf23RuDjB
         a4yKEAs+4WwarBeM93XajnND93gGAm/vW4OKwULPN69cQtSsIDRd/QXdIYbIPd+nE2ps
         7l7w==
X-Gm-Message-State: ANhLgQ0IQCQnEDhIBXzEB9JRh/W2bX1wk1xpkpeSfkU9QANI3+s2wlgC
        BUY1Ap7jGBSn+AO7fsUlxdtLqzFVf9oLFPg+I4gib7wpDT6hn8BiupSGFyUFwnW5pzA/eSgXPSt
        O+4a/WitMOVCH
X-Received: by 2002:a1c:1b0e:: with SMTP id b14mr3051562wmb.8.1585227773278;
        Thu, 26 Mar 2020 06:02:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtMgRy6rIRFIPEDHNzKZwjriK2grTT250mENOTsiMhkAWF5QKOJ25G/UwMdgEy1VCjOXC5BLQ==
X-Received: by 2002:a1c:1b0e:: with SMTP id b14mr3051540wmb.8.1585227773049;
        Thu, 26 Mar 2020 06:02:53 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id n9sm3506624wru.50.2020.03.26.06.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 06:02:52 -0700 (PDT)
Date:   Thu, 26 Mar 2020 09:02:48 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [PATCH v1 20/22] intel_iommu: propagate PASID-based iotlb
 invalidation to host
Message-ID: <20200326130248.GB422390@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-21-git-send-email-yi.l.liu@intel.com>
 <20200324183423.GE127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A2022C5@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A203E63@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A203E63@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 05:41:39AM +0000, Liu, Yi L wrote:
> > From: Liu, Yi L
> > Sent: Wednesday, March 25, 2020 9:22 PM
> > To: 'Peter Xu' <peterx@redhat.com>
> > Subject: RE: [PATCH v1 20/22] intel_iommu: propagate PASID-based iotlb
> > invalidation to host
> > 
> > > From: Peter Xu <peterx@redhat.com>
> > > Sent: Wednesday, March 25, 2020 2:34 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [PATCH v1 20/22] intel_iommu: propagate PASID-based iotlb
> > > invalidation to host
> > >
> > > On Sun, Mar 22, 2020 at 05:36:17AM -0700, Liu Yi L wrote:
> > > > This patch propagates PASID-based iotlb invalidation to host.
> > > >
> > > > Intel VT-d 3.0 supports nested translation in PASID granular.
> > > > Guest SVA support could be implemented by configuring nested
> > > > translation on specific PASID. This is also known as dual stage DMA
> > > > translation.
> > > >
> > > > Under such configuration, guest owns the GVA->GPA translation which
> > > > is configured as first level page table in host side for a specific
> > > > pasid, and host owns GPA->HPA translation. As guest owns first level
> > > > translation table, piotlb invalidation should be propagated to host
> > > > since host IOMMU will cache first level page table related mappings
> > > > during DMA address translation.
> > > >
> > > > This patch traps the guest PASID-based iotlb flush and propagate it
> > > > to host.
> > > >
> > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > Cc: Peter Xu <peterx@redhat.com>
> > > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > Cc: Richard Henderson <rth@twiddle.net>
> > > > Cc: Eduardo Habkost <ehabkost@redhat.com>
> > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > ---
> > > >  hw/i386/intel_iommu.c          | 139
> > > +++++++++++++++++++++++++++++++++++++++++
> > > >  hw/i386/intel_iommu_internal.h |   7 +++
> > > >  2 files changed, 146 insertions(+)
> > > >
> > > > diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c index
> > > > b9ac07d..10d314d 100644
> > > > --- a/hw/i386/intel_iommu.c
> > > > +++ b/hw/i386/intel_iommu.c
> > > > @@ -3134,15 +3134,154 @@ static bool
> > > vtd_process_pasid_desc(IntelIOMMUState *s,
> > > >      return (ret == 0) ? true : false;  }
> > > >
> > > > +/**
> > > > + * Caller of this function should hold iommu_lock.
> > > > + */
> > > > +static void vtd_invalidate_piotlb(IntelIOMMUState *s,
> > > > +                                  VTDBus *vtd_bus,
> > > > +                                  int devfn,
> > > > +                                  DualIOMMUStage1Cache
> > > > +*stage1_cache) {
> > > > +    VTDHostIOMMUContext *vtd_dev_icx;
> > > > +    HostIOMMUContext *host_icx;
> > > > +
> > > > +    vtd_dev_icx = vtd_bus->dev_icx[devfn];
> > > > +    if (!vtd_dev_icx) {
> > > > +        goto out;
> > > > +    }
> > > > +    host_icx = vtd_dev_icx->host_icx;
> > > > +    if (!host_icx) {
> > > > +        goto out;
> > > > +    }
> > > > +    if (host_iommu_ctx_flush_stage1_cache(host_icx, stage1_cache)) {
> > > > +        error_report("Cache flush failed");
> > >
> > > I think this should not easily be triggered by the guest, but just in
> > > case... Let's use
> > > error_report_once() to be safe.
> > 
> > Agreed.
> > 
> > > > +    }
> > > > +out:
> > > > +    return;
> > > > +}
> > > > +
> > > > +static inline bool vtd_pasid_cache_valid(
> > > > +                          VTDPASIDAddressSpace *vtd_pasid_as) {
> > > > +    return vtd_pasid_as->iommu_state &&
                    ^^^^^^^^^^^^^^^^^^^^^^^^^

> > >
> > > This check can be dropped because always true?
> > >
> > > If you agree with both the changes, please add:
> > >
> > > Reviewed-by: Peter Xu <peterx@redhat.com>
> > 
> > I think the code should ensure all the pasid_as in hash table is valid. And we can
> > since all the operations are under protection of iommu_lock.
> > 
> Peter,
> 
> I think my reply was wrong. pasid_as in has table may be stale since
> the per pasid_as cache_gen may be not identical with the cache_gen
> in iommu_state. e.g. vtd_pasid_cache_reset() only increases the
> cache_gen in iommu_state. So there will be pasid_as in hash table
> which has cached pasid entry but its cache_gen is not equal to the
> one in iommu_state. For such pasid_as, we should treat it as stale.
> So I guess the vtd_pasid_cache_valid() is still necessary.

I guess you misread my comment. :)

I was saying the "vtd_pasid_as->iommu_state" check is not needed,
because iommu_state was always set if the address space is created.
vtd_pasid_cache_valid() is needed.

Also, please double confirm that vtd_pasid_cache_reset() should drop
all the address spaces (as I think it should), not "only increase the
cache_gen".  IMHO you should only increase the cache_gen in the PSI
hook (vtd_pasid_cache_psi()) only.

Thanks,

-- 
Peter Xu

