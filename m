Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E69192B99
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 15:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgCYO44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 10:56:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:26803 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727236AbgCYO4z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 10:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585148213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FgpVoXWbEKslcRBhKxnhvTc9Ht1yp2ZJ8I8pykrMRVU=;
        b=QyxkaEseltQDqJQVC3ShD/OzyXekvFGZPtyuuE0/BBspGoENj/GoTFfpBYQrjPT+wjVlA4
        HSZgTXfaCcmpCeojTVDMrbJtdvT7thx5moID5bueY+fFNKVEQqFKCJ3SwwrSDOPmU0ZP1l
        QUJpNxDc+efqd4c/vtX1dqVhk3vTvuk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-ZzOlvrQOP_6oPbL8-vEWDw-1; Wed, 25 Mar 2020 10:56:52 -0400
X-MC-Unique: ZzOlvrQOP_6oPbL8-vEWDw-1
Received: by mail-wm1-f72.google.com with SMTP id n25so777564wmi.5
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 07:56:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FgpVoXWbEKslcRBhKxnhvTc9Ht1yp2ZJ8I8pykrMRVU=;
        b=Fd6DahJ1n3BOxtNUaM3ZzxWF8BV48qpgXwDo1oGl2L+TxR+ZVPIOu0fjGaSgY3RgSv
         IljauUO264AdHXp8lwzipBDEFgRODTkEuoo9VQALgVUVUvnDLnpbkFNcUx65NJaZaKo0
         1WbXa1BVK57Lq9XWhMC9ykz//e5qP/082PB6Uw5KLdNlOuymB+0aag83tbuWjYXKhUuP
         qvrJaIk+bHaxdgS771mWvJA7VQ2wgZXboc3wuq4Hqwyfqp6NxicsIs74khRk37hg6M8R
         2bNi3zNNeEUd0Wlvsg155H6Bi3+evGr/MFzmJrIzhFZTIonr5OnI+/PHshoz+cSAPV7Y
         jdXg==
X-Gm-Message-State: ANhLgQ1RIrfv3KDh58Inyddp34aXRDGkIoIJkQoeyNwldcOkXulzbjuX
        BUbLIMzZkBCDL3CRLj65NiO7xgH8miPwq4ZtMhKZYv6PriH+duWWNTfEZ/4VqN32E3eGbuQQTGw
        BNE2ltiHx2J7h
X-Received: by 2002:a1c:a908:: with SMTP id s8mr4026784wme.133.1585148211218;
        Wed, 25 Mar 2020 07:56:51 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vswJ0Oq78RJOfqKLvu5siSZGVUHFaIEy7pUVbXr0KFQJTqtwb/24Gqj9LPvLXCRW7qXAXc5xg==
X-Received: by 2002:a1c:a908:: with SMTP id s8mr4026772wme.133.1585148210989;
        Wed, 25 Mar 2020 07:56:50 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id a8sm8809545wmb.39.2020.03.25.07.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 07:56:50 -0700 (PDT)
Date:   Wed, 25 Mar 2020 10:56:46 -0400
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
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v1 14/22] intel_iommu: bind/unbind guest page table to
 host
Message-ID: <20200325145646.GB354390@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-15-git-send-email-yi.l.liu@intel.com>
 <20200324174642.GY127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A2021CD@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A2021CD@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 25, 2020 at 12:42:58PM +0000, Liu, Yi L wrote:
> > From: Peter Xu
> > Sent: Wednesday, March 25, 2020 1:47 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 14/22] intel_iommu: bind/unbind guest page table to host
> > 
> > On Sun, Mar 22, 2020 at 05:36:11AM -0700, Liu Yi L wrote:
> > > This patch captures the guest PASID table entry modifications and
> > > propagates the changes to host to setup dual stage DMA translation.
> > > The guest page table is configured as 1st level page table (GVA->GPA)
> > > whose translation result would further go through host VT-d 2nd level
> > > page table(GPA->HPA) under nested translation mode. This is the key
> > > part of vSVA support, and also a key to support IOVA over 1st- level
> > > page table for Intel VT-d in virtualization environment.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Richard Henderson <rth@twiddle.net>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > ---
> > >  hw/i386/intel_iommu.c          | 98
> > +++++++++++++++++++++++++++++++++++++++---
> > >  hw/i386/intel_iommu_internal.h | 25 +++++++++++
> > >  2 files changed, 118 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c index
> > > c985cae..0423c83 100644
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
> > > +static inline uint32_t vtd_pe_get_fl_aw(VTDPASIDEntry *pe) {
> > > +    return 48 + ((pe->val[2] >> 2) & VTD_SM_PASID_ENTRY_FLPM) * 9; }
> > > +
> > > +static inline dma_addr_t vtd_pe_get_flpt_base(VTDPASIDEntry *pe) {
> > > +    return pe->val[2] & VTD_SM_PASID_ENTRY_FLPTPTR; }
> > > +
> > >  static inline bool vtd_pdire_present(VTDPASIDDirEntry *pdire)  {
> > >      return pdire->val & 1;
> > > @@ -1856,6 +1867,81 @@ static void
> > vtd_context_global_invalidate(IntelIOMMUState *s)
> > >      vtd_iommu_replay_all(s);
> > >  }
> > >
> > > +/**
> > > + * Caller should hold iommu_lock.
> > > + */
> > > +static int vtd_bind_guest_pasid(IntelIOMMUState *s, VTDBus *vtd_bus,
> > > +                                int devfn, int pasid, VTDPASIDEntry *pe,
> > > +                                VTDPASIDOp op) {
> > > +    VTDHostIOMMUContext *vtd_dev_icx;
> > > +    HostIOMMUContext *host_icx;
> > > +    DualIOMMUStage1BindData *bind_data;
> > > +    struct iommu_gpasid_bind_data *g_bind_data;
> > > +    int ret = -1;
> > > +
> > > +    vtd_dev_icx = vtd_bus->dev_icx[devfn];
> > > +    if (!vtd_dev_icx) {
> > > +        return -EINVAL;
> > > +    }
> > > +
> > > +    host_icx = vtd_dev_icx->host_icx;
> > > +    if (!host_icx) {
> > > +        return -EINVAL;
> > > +    }
> > > +
> > > +    if (!(host_icx->stage1_formats
> > > +             & IOMMU_PASID_FORMAT_INTEL_VTD)) {
> > > +        error_report_once("IOMMU Stage 1 format is not
> > > + compatible!\n");
> > 
> > Shouldn't we fail with this?
> 
> oh, yes. no need to go further though host should also fail it.
> 
> > > +    }
> > > +
> > > +    bind_data = g_malloc0(sizeof(*bind_data));
> > > +    bind_data->pasid = pasid;
> > > +    g_bind_data = &bind_data->bind_data.gpasid_bind;
> > > +
> > > +    g_bind_data->flags = 0;
> > > +    g_bind_data->vtd.flags = 0;
> > > +    switch (op) {
> > > +    case VTD_PASID_BIND:
> > > +    case VTD_PASID_UPDATE:
> > 
> > Is VTD_PASID_UPDATE used anywhere?
> > 
> > But since it's called "UPDATE"... I really want to confirm with you that the bind() to
> > the kernel will handle the UPDATE case, right?  I mean, we need to unbind first if
> > there is an existing pgtable pointer.
> 
> I guess you mean host kernel. right? Actually, it's fine. host kernel
> only needs to fill in the latest pgtable pointer and permission configs
> to the pasid entry and then issue a cache invalidation. No need to do
> unbind firstly since kernel always needs to flush cache after modifying
> a pasid entry (includes valid->valid).

Great.

> 
> > 
> > If the answer is yes, then I think we're good, but we really need to comment it
> > somewhere about the fact.
> > 
> > > +        g_bind_data->version = IOMMU_UAPI_VERSION;
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
> > > +        ret = host_iommu_ctx_bind_stage1_pgtbl(host_icx, bind_data);
> > > +        break;
> > > +    case VTD_PASID_UNBIND:
> > > +        g_bind_data->version = IOMMU_UAPI_VERSION;
> > > +        g_bind_data->format = IOMMU_PASID_FORMAT_INTEL_VTD;
> > > +        g_bind_data->gpgd = 0;
> > > +        g_bind_data->addr_width = 0;
> > > +        g_bind_data->hpasid = pasid;
> > > +        g_bind_data->gpasid = pasid;
> > > +        g_bind_data->flags |= IOMMU_SVA_GPASID_VAL;
> > > +        ret = host_iommu_ctx_unbind_stage1_pgtbl(host_icx, bind_data);
> > > +        break;
> > > +    default:
> > > +        error_report_once("Unknown VTDPASIDOp!!!\n");
> > > +        break;
> > > +    }
> > > +
> > > +    g_free(bind_data);
> > > +
> > > +    return ret;
> > > +}
> > > +
> > >  /* Do a context-cache device-selective invalidation.
> > >   * @func_mask: FM field after shifting
> > >   */
> > > @@ -2481,10 +2567,10 @@ static inline void
> > > vtd_fill_in_pe_in_cache(IntelIOMMUState *s,
> > >
> > >      pc_entry->pasid_entry = *pe;
> > >      pc_entry->pasid_cache_gen = s->pasid_cache_gen;
> > > -    /*
> > > -     * TODO:
> > > -     * - send pasid bind to host for passthru devices
> > > -     */
> > > +    vtd_bind_guest_pasid(s, vtd_pasid_as->vtd_bus,
> > > +                         vtd_pasid_as->devfn,
> > > +                         vtd_pasid_as->pasid,
> > > +                         pe, VTD_PASID_BIND);
> > >  }
> > >
> > >  /**
> > > @@ -2574,11 +2660,13 @@ static gboolean vtd_flush_pasid(gpointer key,
> > gpointer value,
> > >       * - when pasid-base-iotlb(piotlb) infrastructure is ready,
> > >       *   should invalidate QEMU piotlb togehter with this change.
> > >       */
> > > +
> > >      return false;
> > >  remove:
> > > +    vtd_bind_guest_pasid(s, vtd_bus, devfn,
> > > +                         pasid, NULL, VTD_PASID_UNBIND);
> > >      /*
> > >       * TODO:
> > > -     * - send pasid bind to host for passthru devices
> > >       * - when pasid-base-iotlb(piotlb) infrastructure is ready,
> > >       *   should invalidate QEMU piotlb togehter with this change.
> > >       */
> > > diff --git a/hw/i386/intel_iommu_internal.h
> > > b/hw/i386/intel_iommu_internal.h index 01fd95c..4451acf 100644
> > > --- a/hw/i386/intel_iommu_internal.h
> > > +++ b/hw/i386/intel_iommu_internal.h
> > > @@ -516,6 +516,20 @@ typedef struct VTDRootEntry VTDRootEntry;
> > > #define VTD_SM_CONTEXT_ENTRY_RSVD_VAL0(aw)  (0x1e0ULL |
> > ~VTD_HAW_MASK(aw))
> > >  #define VTD_SM_CONTEXT_ENTRY_RSVD_VAL1      0xffffffffffe00000ULL
> > >
> > > +enum VTD_DUAL_STAGE_UAPI {
> > > +    UAPI_BIND_GPASID,
> > > +    UAPI_NUM
> > > +};
> > > +typedef enum VTD_DUAL_STAGE_UAPI VTD_DUAL_STAGE_UAPI;
> > > +
> > > +enum VTDPASIDOp {
> > > +    VTD_PASID_BIND,
> > > +    VTD_PASID_UNBIND,
> > > +    VTD_PASID_UPDATE,
> > 
> > Same here (whether to drop?).
> >
> If above reply doesn't make sense, may drop it.

Your reply makes perfect sense, but still, could we drop it because
it's not used? :)

I suggest drop UPDATE, then either:

  - comment at VTD_PASID_BIND that when binding exists, we'll update
    the entry so the caller does not need to call unbind, or,

  - rename BIND to BIND_UPDATE to show that

What do you think?

-- 
Peter Xu

