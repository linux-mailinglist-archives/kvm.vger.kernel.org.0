Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD308F189D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 15:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbfKFO16 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 09:27:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58376 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726945AbfKFO16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 09:27:58 -0500
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C1461859FE
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 14:27:57 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id u23so26203659qtb.22
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 06:27:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F+Qn6CyJx76tnRGRBhaBq2PcYvQUuntn1zr+y079x5g=;
        b=XFDHYYKcesRAdphTXdBJv6zGDK17vG1oa1UHps2/hmamWaMuRpI3ojvVXdC/AaJCpK
         K1sfcDX6BxwSFPzFYdfeDCalsP3siQoz6PNbP7qDDT4hELoUlq9NUX0LMxiexctBfSUm
         YdK+/qcB5zG6SXuLytxcOY1hFWiwM8oe561mWl2aAo+Kr6jbskQIP7dQsl3sUyX1eLJv
         aihakcPDWsGE0IcIqK0tEq1Q2pwJhUCN0TbIOPOHukiZJ/CBTfuJp7x4OIPifXLmktrG
         gOgYLTfO1ZgEeKQz8kTawSta/Kv2Yo3Ig9kW4YB+3rPIIoxD1Hc2WkGaTule4hrY1PhC
         2+jA==
X-Gm-Message-State: APjAAAUsPRYCRFVNT1dW/PF4L3VOv54hlQ6iLS7Pf22wlQrRXa1o997s
        fBRX5QHJtlPsrkw+dQm0dWBUPIhY3Ak/Rt54Ki6yiNsfuAZfJIO3mfYzz3TsVDheLxh0dpHw/AQ
        PEcZWxVkS1azY
X-Received: by 2002:a0c:d2b4:: with SMTP id q49mr2358000qvh.135.1573050477046;
        Wed, 06 Nov 2019 06:27:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqzdQX5lZeTrvzfdffsUSxXAyNg6fbC9M02lk8p46D67QyqunBvsXiuXwOTv/GXYGGtTABIjRA==
X-Received: by 2002:a0c:d2b4:: with SMTP id q49mr2357970qvh.135.1573050476749;
        Wed, 06 Nov 2019 06:27:56 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id z3sm13464408qtu.83.2019.11.06.06.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 06:27:56 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:27:54 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 15/22] intel_iommu: bind/unbind guest page table to host
Message-ID: <20191106142754.GC29717@xz-x1>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-16-git-send-email-yi.l.liu@intel.com>
 <20191104202559.GA12619@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A0EEF4D@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A0EEF4D@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 08:10:59AM +0000, Liu, Yi L wrote:
> > From: Peter Xu [mailto:peterx@redhat.com]
> > Sent: Tuesday, November 5, 2019 4:26 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v2 15/22] intel_iommu: bind/unbind guest page table to host
> > 
> > On Thu, Oct 24, 2019 at 08:34:36AM -0400, Liu Yi L wrote:
> > > This patch captures the guest PASID table entry modifications and
> > > propagates the changes to host to setup nested translation. The
> > > guest page table is configured as 1st level page table (GVA->GPA)
> > > whose translation result would further go through host VT-d 2nd
> > > level page table(GPA->HPA) under nested translation mode. This is
> > > a key part of vSVA support.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > >  hw/i386/intel_iommu.c          | 81
> > ++++++++++++++++++++++++++++++++++++++++++
> > >  hw/i386/intel_iommu_internal.h | 20 +++++++++++
> > >  2 files changed, 101 insertions(+)
> > >
> > > diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> > > index d8827c9..793b0de 100644
> > > --- a/hw/i386/intel_iommu.c
> > > +++ b/hw/i386/intel_iommu.c
> > > @@ -41,6 +41,7 @@
> > >  #include "migration/vmstate.h"
> > >  #include "trace.h"
> > >  #include "qemu/jhash.h"
> > > +#include <linux/iommu.h>
> > >
> > >  /* context entry operations */
> > >  #define VTD_CE_GET_RID2PASID(ce) \
> > > @@ -695,6 +696,16 @@ static inline uint16_t
> > vtd_pe_get_domain_id(VTDPASIDEntry *pe)
> > >      return VTD_SM_PASID_ENTRY_DID((pe)->val[1]);
> > >  }
> > >
> > > +static inline uint32_t vtd_pe_get_fl_aw(VTDPASIDEntry *pe)
> > > +{
> > > +    return 48 + ((pe->val[2] >> 2) & VTD_SM_PASID_ENTRY_FLPM) * 9;
> > > +}
> > > +
> > > +static inline dma_addr_t vtd_pe_get_flpt_base(VTDPASIDEntry *pe)
> > > +{
> > > +    return pe->val[2] & VTD_SM_PASID_ENTRY_FLPTPTR;
> > > +}
> > > +
> > >  static inline bool vtd_pdire_present(VTDPASIDDirEntry *pdire)
> > >  {
> > >      return pdire->val & 1;
> > > @@ -1850,6 +1861,67 @@ static void
> > vtd_context_global_invalidate(IntelIOMMUState *s)
> > >      vtd_iommu_replay_all(s);
> > >  }
> > >
> > > +static void vtd_bind_guest_pasid(IntelIOMMUState *s, VTDBus *vtd_bus,
> > > +            int devfn, int pasid, VTDPASIDEntry *pe, VTDPASIDOp op)
> > > +{
> > > +#ifdef __linux__
> > > +    VTDIOMMUContext *vtd_ic;
> > > +    IOMMUCTXEventData event_data;
> > > +    IOMMUCTXPASIDBindData bind;
> > > +    struct iommu_gpasid_bind_data *g_bind_data;
> > > +
> > > +    vtd_ic = vtd_bus->dev_ic[devfn];
> > > +    if (!vtd_ic) {
> > > +        return;
> > > +    }
> > > +
> > > +    g_bind_data = g_malloc0(sizeof(*g_bind_data));
> > > +    bind.flag = 0;
> > > +    g_bind_data->flags = 0;
> > > +    g_bind_data->vtd.flags = 0;
> > > +    switch (op) {
> > > +    case VTD_PASID_BIND:
> > > +    case VTD_PASID_UPDATE:
> > > +        g_bind_data->version = IOMMU_GPASID_BIND_VERSION_1;
> > > +        g_bind_data->format = IOMMU_PASID_FORMAT_INTEL_VTD;
> > > +        g_bind_data->gpgd = vtd_pe_get_flpt_base(pe);
> > > +        g_bind_data->addr_width = vtd_pe_get_fl_aw(pe);
> > > +        g_bind_data->hpasid = pasid;
> > > +        g_bind_data->gpasid = pasid;
> > > +        g_bind_data->flags |= IOMMU_SVA_GPASID_VAL;
> > > +        g_bind_data->vtd.flags =
> > > +                             (VTD_SM_PASID_ENTRY_SRE_BIT(pe->val[2]) ? 1 : 0)
> > > +                           | (VTD_SM_PASID_ENTRY_EAFE_BIT(pe->val[2]) ? 1 : 0)
> > > +                           | (VTD_SM_PASID_ENTRY_PCD_BIT(pe->val[1]) ? 1 : 0)
> > > +                           | (VTD_SM_PASID_ENTRY_PWT_BIT(pe->val[1]) ? 1 : 0)
> > > +                           | (VTD_SM_PASID_ENTRY_EMTE_BIT(pe->val[1]) ? 1 : 0)
> > > +                           | (VTD_SM_PASID_ENTRY_CD_BIT(pe->val[1]) ? 1 : 0);
> > > +        g_bind_data->vtd.pat = VTD_SM_PASID_ENTRY_PAT(pe->val[1]);
> > > +        g_bind_data->vtd.emt = VTD_SM_PASID_ENTRY_EMT(pe->val[1]);
> > > +        bind.flag |= IOMMU_CTX_BIND_PASID;
> > > +        break;
> > > +
> > > +    case VTD_PASID_UNBIND:
> > > +        g_bind_data->gpgd = 0;
> > > +        g_bind_data->addr_width = 0;
> > > +        g_bind_data->hpasid = pasid;
> > > +        bind.flag |= IOMMU_CTX_UNBIND_PASID;
> > > +        break;
> > > +
> > > +    default:
> > > +        printf("Unknown VTDPASIDOp!!\n");
> > 
> > Please don't use printf()..  Here assert() suits.
> 
> Will correct it. Thanks.
> 
> > 
> > > +        break;
> > > +    }
> > > +    if (bind.flag) {
> > 
> > Will this be untrue?  If not, assert() works too.
> 
> yes, it is possible. If an unknown VTDPASIDOp, then no switch case
> will initiate bind.flag.

Then should it be a programming error?  If so we should still use
assert(), I think...

> 
> > > +        event_data.event = IOMMU_CTX_EVENT_PASID_BIND;
> > > +        bind.data = g_bind_data;
> > > +        event_data.data = &bind;
> > > +        iommu_ctx_event_notify(&vtd_ic->iommu_context, &event_data);
> > > +    }
> > > +    g_free(g_bind_data);
> > > +#endif
> > > +}
> > > +
> > >  /* Do a context-cache device-selective invalidation.
> > >   * @func_mask: FM field after shifting
> > >   */
> > > @@ -2528,12 +2600,17 @@ static gboolean vtd_flush_pasid(gpointer key,
> > gpointer value,
> > >                  pc_entry->pasid_cache_gen = s->pasid_cache_gen;
> > >                  if (!vtd_pasid_entry_compare(&pe, &pc_entry->pasid_entry)) {
> > >                      pc_entry->pasid_entry = pe;
> > > +                    vtd_bind_guest_pasid(s, vtd_bus, devfn,
> > > +                                     pasid, &pe, VTD_PASID_UPDATE);
> > >                      /*
> > >                       * TODO: when pasid-base-iotlb(piotlb) infrastructure is
> > >                       * ready, should invalidate QEMU piotlb togehter with this
> > >                       * change.
> > >                       */
> > >                  }
> > > +            } else {
> > > +                vtd_bind_guest_pasid(s, vtd_bus, devfn,
> > > +                                  pasid, NULL, VTD_PASID_UNBIND);
> > 
> > Please see the reply in the other thread on vtd_flush_pasid().  I've
> > filled in where I feel like this UNBIND should exist, I feel like your
> > current code could miss some places where you should unbind but didn't.
> 
> I've replied in that thread regards to your comments. May you
> reconsider it here. Hope, it suits what you thought. If still
> something missed, pls feel free to point out.

Ok let's wait to see your next version.  Thanks,

-- 
Peter Xu
