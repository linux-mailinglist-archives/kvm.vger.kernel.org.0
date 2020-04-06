Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3634C19FE6F
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 21:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgDFTtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 15:49:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48217 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726084AbgDFTtU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Apr 2020 15:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586202559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3SAc7/INURO0fUmTRoJHT56cMjNB24w7zVKVwcxLIzw=;
        b=Fccr3BnkqEikL0xhcfc5OIJ75fALu1Sxs9FaCxiJ6yY3vfUAO4/+lzVV2lHaxEy/q+0tUC
        PXbrlCmqTLvBqPvhPbUVpiW3FKrdXxKKDEvVB8woCCLlb6Fb2FzK2rMgmzKr2jtYzJFGRY
        WwP8EGa4MZR2vZWl6HNbgpaIvJ2T8xY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-GsFmSVi7MSySav0pKS9sSg-1; Mon, 06 Apr 2020 15:49:16 -0400
X-MC-Unique: GsFmSVi7MSySav0pKS9sSg-1
Received: by mail-qt1-f197.google.com with SMTP id v16so927889qtj.1
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 12:49:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3SAc7/INURO0fUmTRoJHT56cMjNB24w7zVKVwcxLIzw=;
        b=dQCmMl8boCWPbn8bhax3TUNCyIuoAhktDECxesc48j6+BUdoZt+of/lYqvvU34PUui
         CXeKzdF0sBm2h9UaqGe5sdLdTaDsVroa86w0pHY8QobIZsFg8c3u7tCfPZUxD3SJC18K
         sRjbEjD3re4QuJQ8lSE2u0ZswqmOKocuI+UhRI18PokZZf4ysAd7WEwSJ3z0NNeuVNiU
         DpdkPeHxEwtqb64Lei1c66nPJME7DifakKqDx2qmf9st83fs0xwQ+dwiA7rmfkfH2SRW
         ugUbPQ3pbmEC+THbHwAysTa4yhOjT7xs3Rhux47XgFMdOHBo/MRCso7L/58emhMoAJ0r
         WJSg==
X-Gm-Message-State: AGi0Pubg1DZmMvDgfwiTreMCm5piRNgJGd9m5RDTSVwt3Y9gLjwz40Qg
        oC8TlTsu0rU+l089e04XVZIStBbvQuj/7JN2iSnLlY5qDcXK3iZfOZtcy0MuTAP0QbsTadoQ+ET
        gf35Dgnybz34T
X-Received: by 2002:ac8:8d0:: with SMTP id y16mr1270777qth.340.1586202555448;
        Mon, 06 Apr 2020 12:49:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypIsQ+naX+Z38cNb4BpPpyftxPdr6Pz+MXwVkluFeAVGofZZPwR4AZcFrqU7Egyx3/QvySVzMQ==
X-Received: by 2002:ac8:8d0:: with SMTP id y16mr1270746qth.340.1586202555194;
        Mon, 06 Apr 2020 12:49:15 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::3])
        by smtp.gmail.com with ESMTPSA id f138sm2635656qke.105.2020.04.06.12.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 12:49:14 -0700 (PDT)
Date:   Mon, 6 Apr 2020 15:48:40 -0400
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
Subject: Re: [PATCH v2 16/22] intel_iommu: replay pasid binds after context
 cache invalidation
Message-ID: <20200406194840.GS103677@xz-x1>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-17-git-send-email-yi.l.liu@intel.com>
 <20200403144548.GK103677@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A220E44@SHSMSX104.ccr.corp.intel.com>
 <20200403161120.GN103677@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A221BD4@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A221BD4@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 04, 2020 at 12:00:12PM +0000, Liu, Yi L wrote:
> Hi Peter,
> 
> > From: Peter Xu <peterx@redhat.com>
> > Sent: Saturday, April 4, 2020 12:11 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v2 16/22] intel_iommu: replay pasid binds after context cache
> > invalidation
> > 
> > On Fri, Apr 03, 2020 at 03:21:10PM +0000, Liu, Yi L wrote:
> > > > From: Peter Xu <peterx@redhat.com>
> > > > Sent: Friday, April 3, 2020 10:46 PM
> > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > Subject: Re: [PATCH v2 16/22] intel_iommu: replay pasid binds after context
> > cache
> > > > invalidation
> > > >
> > > > On Sun, Mar 29, 2020 at 09:24:55PM -0700, Liu Yi L wrote:
> > > > > This patch replays guest pasid bindings after context cache
> > > > > invalidation. This is a behavior to ensure safety. Actually,
> > > > > programmer should issue pasid cache invalidation with proper
> > > > > granularity after issuing a context cache invalidation.
> > > > >
> > > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > > Cc: Peter Xu <peterx@redhat.com>
> > > > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > Cc: Richard Henderson <rth@twiddle.net>
> > > > > Cc: Eduardo Habkost <ehabkost@redhat.com>
> > > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > > ---
> > > > >  hw/i386/intel_iommu.c          | 51
> > > > ++++++++++++++++++++++++++++++++++++++++++
> > > > >  hw/i386/intel_iommu_internal.h |  6 ++++-
> > > > >  hw/i386/trace-events           |  1 +
> > > > >  3 files changed, 57 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> > > > > index d87f608..883aeac 100644
> > > > > --- a/hw/i386/intel_iommu.c
> > > > > +++ b/hw/i386/intel_iommu.c
> > > > > @@ -68,6 +68,10 @@ static void
> > > > vtd_address_space_refresh_all(IntelIOMMUState *s);
> > > > >  static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier
> > *n);
> > > > >
> > > > >  static void vtd_pasid_cache_reset(IntelIOMMUState *s);
> > > > > +static void vtd_pasid_cache_sync(IntelIOMMUState *s,
> > > > > +                                 VTDPASIDCacheInfo *pc_info);
> > > > > +static void vtd_pasid_cache_devsi(IntelIOMMUState *s,
> > > > > +                                  VTDBus *vtd_bus, uint16_t devfn);
> > > > >
> > > > >  static void vtd_panic_require_caching_mode(void)
> > > > >  {
> > > > > @@ -1853,7 +1857,10 @@ static void
> > vtd_iommu_replay_all(IntelIOMMUState
> > > > *s)
> > > > >
> > > > >  static void vtd_context_global_invalidate(IntelIOMMUState *s)
> > > > >  {
> > > > > +    VTDPASIDCacheInfo pc_info;
> > > > > +
> > > > >      trace_vtd_inv_desc_cc_global();
> > > > > +
> > > > >      /* Protects context cache */
> > > > >      vtd_iommu_lock(s);
> > > > >      s->context_cache_gen++;
> > > > > @@ -1870,6 +1877,9 @@ static void
> > > > vtd_context_global_invalidate(IntelIOMMUState *s)
> > > > >       * VT-d emulation codes.
> > > > >       */
> > > > >      vtd_iommu_replay_all(s);
> > > > > +
> > > > > +    pc_info.flags = VTD_PASID_CACHE_GLOBAL;
> > > > > +    vtd_pasid_cache_sync(s, &pc_info);
> > > > >  }
> > > > >
> > > > >  /**
> > > > > @@ -2005,6 +2015,22 @@ static void
> > > > vtd_context_device_invalidate(IntelIOMMUState *s,
> > > > >                   * happened.
> > > > >                   */
> > > > >                  vtd_sync_shadow_page_table(vtd_as);
> > > > > +                /*
> > > > > +                 * Per spec, context flush should also
> > > > > followed with PASID
> > > > > +                 * cache and iotlb flush. Regards to
> > > > > a device selective
> > > > > +                 * context cache invalidation:
> > > >
> > > > If context entry flush should also follow another pasid cache flush,
> > > > then this is still needed?  Shouldn't the pasid flush do the same
> > > > thing again?
> > >
> > > yes, but how about guest software failed to follow it? It will do
> > > the same thing when pasid cache flush comes. But this only happens
> > > for the rid2pasid case (the IOVA page table).
> > 
> > Do you mean it will not happen when nested page table is used (so it's
> > required for nested tables)?
> 
> no, by the IOVA page table case, I just want to confirm the duplicate
> replay is true. But it is not "only" case. :-) my bad. any scalable mode
> context entry modification will result in duplicate replay as this patch
> enforces a pasid replay after context cache invalidation. But for normal
> guest SVM usage, it won't have such duplicate work as it only modifies
> pasid entry.
> 
> > Yeah we can keep them for safe no matter what; at least I'm fine with
> > it (I believe most of the code we're discussing is not fast path).
> > Just want to be sure of it since if it's definitely duplicated then we
> > can instead drop it.
> 
> yes, it is not fast path. BTW. I guess the iova shadow sync applies
> the same notion. right?

Yes I rem we have similar things, but the same to that - if we can
confirm that it'll be duplicated then I think we should remove that
too.  But feel free to ignore this question for now and keep it.  The
comment explaining that would be helpful, as you already did.  Thanks,

-- 
Peter Xu

