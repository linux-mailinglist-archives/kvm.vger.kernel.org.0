Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C6D192C06
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgCYPPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:15:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39777 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727123AbgCYPPv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 11:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585149349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=85Iz7qm55ak28GWxIHEHs8MmNnZEjWo4E+H4mhBr6/Q=;
        b=UEqbnulYudcrnHgP8v6qaA1orvcJkNiQsWhsBbol6IusTRspueNgpEqMrC+qMqq+0EYDVn
        4wgW0IH8MVAMcxVb4GhTs5Le8fFAJR/DrKdHzpsPq8R9THhDGbzv2rACQNHwHyvZoVevhS
        nUjs+w/oUq7o3gtCoTCPr7x3UPpM77c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-nxHcfI5eM_uJfyOQNcSQMg-1; Wed, 25 Mar 2020 11:15:48 -0400
X-MC-Unique: nxHcfI5eM_uJfyOQNcSQMg-1
Received: by mail-wm1-f71.google.com with SMTP id x26so512068wmc.6
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 08:15:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=85Iz7qm55ak28GWxIHEHs8MmNnZEjWo4E+H4mhBr6/Q=;
        b=FQtUSnnOsSyi4IKR7hdJr3vuN2/INv4MHyZBIThujBWZbpE16MaVxkJ/na1ukQE0xc
         mpyimNZMdyCjBJm92EDF28mrSol7Uwgqv4Hq+DnKBM20a6jsuiXYB3SYygXGQt1uX20U
         E5VdJxc8TC5OltL+s6LDNWCFrhM7+r0acWoyS6gckNKK5UYOMQ6SKxPBD9UUxBb1Sbca
         FgOw2V9lBvcF4RY2XDF2sgpXhkIsYQEpqzcvq2+EsGrXY06sz/D8/7olqwrlcr6Docqk
         Shk2gUKGRkCPU2qLRcuK1gRIrVfckESJBDDKh9jbbrvn0ILytbtNBgF/6hlg0avPtkJs
         AU+g==
X-Gm-Message-State: ANhLgQ1FzKgt1aBug2u7yEdqIa4yeYh8baa9Gnw0kLVZ+RyaJUGiKO8H
        f8ygB6n2I/Nh/UhNL9/fwIlhJ3gZjFrC5K/3Vuwgsu1J74Dd8BbnOZD22T0wll+jfDhcEtFiobu
        x4zpE8ga+KNaK
X-Received: by 2002:a1c:1b51:: with SMTP id b78mr3936819wmb.8.1585149347011;
        Wed, 25 Mar 2020 08:15:47 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtvttgse0+xLvAuZ1+Y+vqPJhjVQWmRMDmQ8GkvLI7/TEIhbBiRpP5z+u7oZYO7GONLwyERYg==
X-Received: by 2002:a1c:1b51:: with SMTP id b78mr3936803wmb.8.1585149346812;
        Wed, 25 Mar 2020 08:15:46 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id y80sm10091321wmc.45.2020.03.25.08.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:15:46 -0700 (PDT)
Date:   Wed, 25 Mar 2020 11:15:40 -0400
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
Subject: Re: [PATCH v1 19/22] intel_iommu: process PASID-based iotlb
 invalidation
Message-ID: <20200325151540.GE354390@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-20-git-send-email-yi.l.liu@intel.com>
 <20200324182623.GD127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A202340@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A202340@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 25, 2020 at 01:36:03PM +0000, Liu, Yi L wrote:
> > From: Peter Xu <peterx@redhat.com>
> > Sent: Wednesday, March 25, 2020 2:26 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 19/22] intel_iommu: process PASID-based iotlb invalidation
> > 
> > On Sun, Mar 22, 2020 at 05:36:16AM -0700, Liu Yi L wrote:
> > > This patch adds the basic PASID-based iotlb (piotlb) invalidation
> > > support. piotlb is used during walking Intel VT-d 1st level page
> > > table. This patch only adds the basic processing. Detailed handling
> > > will be added in next patch.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Richard Henderson <rth@twiddle.net>
> > > Cc: Eduardo Habkost <ehabkost@redhat.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > >  hw/i386/intel_iommu.c          | 57
> > ++++++++++++++++++++++++++++++++++++++++++
> > >  hw/i386/intel_iommu_internal.h | 13 ++++++++++
> > >  2 files changed, 70 insertions(+)
> > >
> > > diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c index
> > > b007715..b9ac07d 100644
> > > --- a/hw/i386/intel_iommu.c
> > > +++ b/hw/i386/intel_iommu.c
> > > @@ -3134,6 +3134,59 @@ static bool vtd_process_pasid_desc(IntelIOMMUState
> > *s,
> > >      return (ret == 0) ? true : false;  }
> > >
> > > +static void vtd_piotlb_pasid_invalidate(IntelIOMMUState *s,
> > > +                                        uint16_t domain_id,
> > > +                                        uint32_t pasid) { }
> > > +
> > > +static void vtd_piotlb_page_invalidate(IntelIOMMUState *s, uint16_t domain_id,
> > > +                             uint32_t pasid, hwaddr addr, uint8_t am,
> > > +bool ih) { }
> > > +
> > > +static bool vtd_process_piotlb_desc(IntelIOMMUState *s,
> > > +                                    VTDInvDesc *inv_desc) {
> > > +    uint16_t domain_id;
> > > +    uint32_t pasid;
> > > +    uint8_t am;
> > > +    hwaddr addr;
> > > +
> > > +    if ((inv_desc->val[0] & VTD_INV_DESC_PIOTLB_RSVD_VAL0) ||
> > > +        (inv_desc->val[1] & VTD_INV_DESC_PIOTLB_RSVD_VAL1)) {
> > > +        error_report_once("non-zero-field-in-piotlb_inv_desc hi: 0x%" PRIx64
> > > +                  " lo: 0x%" PRIx64, inv_desc->val[1], inv_desc->val[0]);
> > > +        return false;
> > > +    }
> > > +
> > > +    domain_id = VTD_INV_DESC_PIOTLB_DID(inv_desc->val[0]);
> > > +    pasid = VTD_INV_DESC_PIOTLB_PASID(inv_desc->val[0]);
> > > +    switch (inv_desc->val[0] & VTD_INV_DESC_IOTLB_G) {
> > > +    case VTD_INV_DESC_PIOTLB_ALL_IN_PASID:
> > > +        vtd_piotlb_pasid_invalidate(s, domain_id, pasid);
> > > +        break;
> > > +
> > > +    case VTD_INV_DESC_PIOTLB_PSI_IN_PASID:
> > > +        am = VTD_INV_DESC_PIOTLB_AM(inv_desc->val[1]);
> > > +        addr = (hwaddr) VTD_INV_DESC_PIOTLB_ADDR(inv_desc->val[1]);
> > > +        if (am > VTD_MAMV) {
> > 
> > I saw this of spec 10.4.2, MAMV:
> > 
> >         Independent of value reported in this field, implementations
> >         supporting SMTS must support address-selective PASID-based
> >         IOTLB invalidations (p_iotlb_inv_dsc) with any defined address
> >         mask.
> > 
> > Does it mean we should even support larger AM?
> > 
> > Besides that, the patch looks good to me.
> 
> I don't think so. This field is for second-level table in scalable mode
> and the translation table in legacy mode. For first-level table, it always
> supports page selective invalidation and all the supported masks
> regardless of the PSI support bit and the MAMV field in the CAP_REG.

Yes that's exactly what I wanted to ask...  Let me try again.

I thought VTD_MAMV was only for 2nd level page table, not for
pasid-iotlb invalidations.  So I think we should remove this "if"
check (that corresponds to "we should even support larger AM"), right?

-- 
Peter Xu

