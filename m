Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011F819439E
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgCZPyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:54:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:24209 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727345AbgCZPyI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 11:54:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585238046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S5DJ6QK01BmwdDk552tAG2Zi2XOLg5i0a0o7HaVOz+w=;
        b=FymMQPHiw2m/8m0bSZ6IsPRxsEtPSYGN5x4vzRaLz2QedNbttqpAmRktWP1o1cRfSMf2l9
        WHWhseTzW6uGqlVb0Jc/sTnA9xyqUkRGNt70epqW2lIDD4XlzrlkuIJVDJSEyq7IaMGZgc
        p7uPAGoORbwPykl7kTF0FH50zqnffvA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-AI9s_4YRN5W6LRMGpvqW5A-1; Thu, 26 Mar 2020 11:54:05 -0400
X-MC-Unique: AI9s_4YRN5W6LRMGpvqW5A-1
Received: by mail-wr1-f70.google.com with SMTP id o18so3248893wrx.9
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 08:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S5DJ6QK01BmwdDk552tAG2Zi2XOLg5i0a0o7HaVOz+w=;
        b=V2iJN5tYxOI+JxYq8TfGoMV8fy4k8E2fJ2CzpCpc2sGJKhUjHZeJqKpz6rJlsCn2Dx
         wqgcZMIR9vTEvJa0R3362jYrn56zo2XXoFFt4IvgNgjbC1OFGyLMeBxsIlyjVJo5LqWk
         Nz9aVHdG6ybDQ63Q+oNp/M8ToW+8rfOFpgemJ2EmwVThrQt2uDAQEXJ+xo3AS4CdrPIE
         8YRttI+qSGDxrS9jJr6qGsJYQWnn+d9Bx4X4FXeZeGtJTiPk1Pr3jpK/bTyMc6Zz6fc6
         mZEKMbtrkQAmh2UjamAo27iikFNvrD/oP9cnQZBuaGKWXuQXbqKUrK0eLe3TYPqq/2oF
         lRqw==
X-Gm-Message-State: ANhLgQ3CmFzPNv8aU9LAI3PzzxE3Rj+abIMWJRM/IasYyOvl1LmgXU9g
        cdPyD9nuCvZ12H0VXDOyic/XKEuJmULsNEhbPKey0B0GtyoJ466hboFarx8L29cVnlYNFdOnpRh
        wGsxG/nk5hvoB
X-Received: by 2002:a1c:4805:: with SMTP id v5mr581358wma.98.1585238044054;
        Thu, 26 Mar 2020 08:54:04 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtlFQYlQd328+mMi3dIqX4jAyny83CHtgc3eyoWdwWwcS51fQ3CqxyWFrS9r3K7zirLruw+Xg==
X-Received: by 2002:a1c:4805:: with SMTP id v5mr581316wma.98.1585238043713;
        Thu, 26 Mar 2020 08:54:03 -0700 (PDT)
Received: from xz-x1 (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id a13sm4149275wrh.80.2020.03.26.08.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 08:54:02 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:53:58 -0400
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
Subject: Re: [PATCH v1 12/22] intel_iommu: add PASID cache management
 infrastructure
Message-ID: <20200326155358.GE422390@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-13-git-send-email-yi.l.liu@intel.com>
 <20200324173209.GW127076@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A20213D@SHSMSX104.ccr.corp.intel.com>
 <20200325145209.GA354390@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A203F2C@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A204614@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A204614@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 26, 2020 at 01:57:10PM +0000, Liu, Yi L wrote:
> > From: Liu, Yi L
> > Sent: Thursday, March 26, 2020 2:15 PM
> > To: 'Peter Xu' <peterx@redhat.com>
> > Subject: RE: [PATCH v1 12/22] intel_iommu: add PASID cache management
> > infrastructure
> > 
> > > From: Peter Xu <peterx@redhat.com>
> > > Sent: Wednesday, March 25, 2020 10:52 PM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [PATCH v1 12/22] intel_iommu: add PASID cache management
> > > infrastructure
> > >
> > > On Wed, Mar 25, 2020 at 12:20:21PM +0000, Liu, Yi L wrote:
> > > > > From: Peter Xu <peterx@redhat.com>
> > > > > Sent: Wednesday, March 25, 2020 1:32 AM
> > > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Subject: Re: [PATCH v1 12/22] intel_iommu: add PASID cache
> > > > > management infrastructure
> > > > >
> > > > > On Sun, Mar 22, 2020 at 05:36:09AM -0700, Liu Yi L wrote:
> > > > > > This patch adds a PASID cache management infrastructure based on
> > > > > > new added structure VTDPASIDAddressSpace, which is used to track
> > > > > > the PASID usage and future PASID tagged DMA address translation
> > > > > > support in vIOMMU.
> [...]
> > > > >
> > > > > <START>
> > > > >
> > > > > > +    /*
> > > > > > +     * Step 2: loop all the exisitng vtd_dev_icx instances.
> > > > > > +     * Ideally, needs to loop all devices to find if there is any new
> > > > > > +     * PASID binding regards to the PASID cache invalidation request.
> > > > > > +     * But it is enough to loop the devices which are backed by host
> > > > > > +     * IOMMU. For devices backed by vIOMMU (a.k.a emulated devices),
> > > > > > +     * if new PASID happened on them, their vtd_pasid_as instance could
> > > > > > +     * be created during future vIOMMU DMA translation.
> > > > > > +     */
> > > > > > +    QLIST_FOREACH(vtd_dev_icx, &s->vtd_dev_icx_list, next) {
> > > > > > +        VTDPASIDAddressSpace *vtd_pasid_as;
> > > > > > +        VTDPASIDCacheEntry *pc_entry;
> > > > > > +        VTDPASIDEntry pe;
> > > > > > +        VTDBus *vtd_bus = vtd_dev_icx->vtd_bus;
> > > > > > +        uint16_t devfn = vtd_dev_icx->devfn;
> > > > > > +        int bus_n = pci_bus_num(vtd_bus->bus);
> > > > > > +
> > > > > > +        /* i) fetch vtd_pasid_as and check if it is valid */
> > > > > > +        vtd_pasid_as = vtd_add_find_pasid_as(s, vtd_bus,
> > > > > > +                                             devfn, pasid);
> > > > >
> > > > > I don't feel like it's correct here...
> > > > >
> > > > > Assuming we have two devices assigned D1, D2.  D1 uses PASID=1, D2
> > > > > uses
> > > PASID=2.
> > > > > When invalidating against PASID=1, are you also going to create a
> > > > > VTDPASIDAddressSpace also for D2 with PASID=1?
> > > >
> > > > Answer is no. Before going forward, let's see if the below flow looks good to you.
> > > >
> > > > Let me add one more device besides D1 and D2. Say device D3 which
> > > > also uses PASID=1. And assume it begins with no PASID usage in guest.
> > > >
> > > > Then the flow from scratch is:
> > > >
> > > > a) guest IOMMU driver setup PASID entry for D1 with PASID=1,
> > > >    then invalidates against PASID #1
> > > > b) trap to QEMU, and comes to this function. Since there is
> > > >    no previous pasid cache invalidation, so the Step 1 of this
> > > >    function has nothing to do, then goes to Step 2 which is to
> > > >    loop all assigned devices and check if the guest pasid entry
> > > >    is present. In this loop, should find D1's pasid entry for
> > > >    PASID#1 is present. So create the VTDPASIDAddressSpace and
> > > >    initialize its pasid_cache_entry and pasid_cache_gen fields.
> > > > c) guest IOMMU driver setup PASID entry for D2 with PASID=2,
> > > >    then invalidates against PASID #2
> > > > d) same with b), only difference is the Step 1 of this function
> > > >    will loop the VTDPASIDAddressSpace created in b), but its
> > > >    pasid is 1 which is not the target of current pasid cache
> > > >    invalidation. Same with b), in Step 2, it will create a
> > > >    VTDPASIDAddressSpace for D2+PASID#2
> > > > e) guest IOMMU driver setup PASID entry for D3 with PASID=1,
> > > >    then invalidates against PASID #1
> > > > f) trap to QEMU and comes to this function. Step 1 loops two
> > > >    VTDPASIDAddressSpace created in b) and d), and it finds there
> > > >    is a VTDPASIDAddressSpace whose pasid is 1. vtd_flush_pasid()
> > > >    will check if the cached pasid entry is the same with the one
> > > >    in guest memory. In this flow, it should be the same, so
> > > >    vtd_flush_pasid() will do nothing for it. Then comes to Step 2,
> > > >    it loops D1, D2, D3.
> > > >    - For D1, no need to do more since there is already a
> > > >      VTDPASIDAddressSpace created for D1+PASID#1.
> > > >    - For D2, its guest pasid entry for PASID#1 is not present, so
> > > >      no need to do anything for it.
> > > >    - For D3, its guest pasid entry for PASID#1 is present and it
> > > >      is exactly the reason for this invalidation. So create a
> > > >      VTDPASIDAddressSpace for and init the pasid_cache_entry and
> > > >      pasid_cache_gen fields.
> > > >
> > > > > I feel like we shouldn't create VTDPASIDAddressSpace only if it
> > > > > existed, say, until when we reach vtd_dev_get_pe_from_pasid() below with
> > retcode==0.
> > > >
> > > > You are right. I think I failed to destroy the VTDAddressSpace when
> > > > vtd_dev_get_pe_from_pasid() returns error. Thus the code won't
> > > > create a VTDPASIDAddressSpace for D2+PASID#1.
> > >
> > > OK, but that free() is really not necessary...  Please see below.
> > >
> > > >
> > > > > Besides this...
> > > > >
> > > > > > +        pc_entry = &vtd_pasid_as->pasid_cache_entry;
> > > > > > +        if (s->pasid_cache_gen == pc_entry->pasid_cache_gen) {
> > > > > > +            /*
> > > > > > +             * pasid_cache_gen equals to s->pasid_cache_gen means
> > > > > > +             * vtd_pasid_as is valid after the above s->vtd_pasid_as
> > > > > > +             * updates in Step 1. Thus no need for the below steps.
> > > > > > +             */
> > > > > > +            continue;
> > > > > > +        }
> > > > > > +
> > > > > > +        /*
> > > > > > +         * ii) vtd_pasid_as is not valid, it's potentailly a new
> > > > > > +         *    pasid bind. Fetch guest pasid entry.
> > > > > > +         */
> > > > > > +        if (vtd_dev_get_pe_from_pasid(s, bus_n, devfn, pasid,
> > > > > > + &pe)) {
> > > >
> > > > Yi: should destroy pasid_as as there is no valid pasid entry. Thus
> > > > to ensure all the pasid_as in hash table are valid.
> > > >
> > > > > > +            continue;
> > > > > > +        }
> > > > > > +
> > > > > > +        /*
> > > > > > +         * iii) pasid entry exists, update pasid cache
> > > > > > +         *
> > > > > > +         * Here need to check domain ID since guest pasid entry
> > > > > > +         * exists. What needs to do are:
> > > > > > +         *   - update the pc_entry in the vtd_pasid_as
> > > > > > +         *   - set proper pc_entry.pasid_cache_gen
> > > > > > +         *   - pass down the latest guest pasid entry config to host
> > > > > > +         *     (will be added in later patch)
> > > > > > +         */
> > > > > > +        if (domain_id == vtd_pe_get_domain_id(&pe)) {
> > > > > > +            vtd_fill_in_pe_in_cache(s, vtd_pasid_as, &pe);
> > > > > > +        }
> > > > > > +    }
> > > > >
> > > > > <END>
> > > > >
> > > > > ... I'm a bit confused on the whole range between <START> and
> > > > > <END> on how it differs from the vtd_replay_guest_pasid_bindings() you're
> > going to introduce.
> > > > > Shouldn't the replay code do similar thing?  Can we merge them?
> > > >
> > > > Yes, there is similar thing which is to create VTDPASIDAddressSpace
> > > > per the guest pasid entry presence.
> > > >
> > > > But there are differences. For one, the code here is to loop all
> > > > assigned devices for a specific PASID. While the logic in
> > > > vtd_replay_guest_pasid_bindings() is to loop all assigned devices
> > > > and the PASID tables behind them. For two, the code here only cares
> > > > about the case which guest pasid entry from INVALID->VALID.
> > > > The reason is in Step 1 of this function, VALID->INVALID and
> > > > VALID->VALID cases are already covered. While the logic in
> > > > vtd_replay_guest_pasid_bindings() needs to cover all the three cases.
> > > > The last reason I didn't merge them is in
> > > > vtd_replay_guest_pasid_bindings() it needs to divide the pasid entry
> > > > fetch into two steps and check the result (if fetch pasid directory
> > > > entry failed, it could skip a range of PASIDs). While the code in
> > > > this function, it doesn't care about it, it only cares if there is a
> > > > valid pasid entry for this specific pasid.
> > > >
> > > > >
> > > > > My understanding is that we can just make sure to do it right once
> > > > > in the replay code (the three cases: INVALID->VALID,
> > > > > VALID->INVALID,
> > > > > VALID->VALID), then no matter whether it's DSI/PSI/GSI, we call
> > > > > VALID->the
> > > > > replay code probably with VTDPASIDCacheInfo* passed in, then the
> > > > > replay code
> > > will
> > > > > know what to look after.
> > > >
> > > > Hmmm, let me think more to abstract the code between the <START> and
> > > > <END> to be a helper function to be called by
> > > > vtd_replay_guest_pasid_bindings(). Also, in that case, I need to
> > > > apply the two step concept in the replay function.
> > >
> > > ... I think your vtd_sm_pasid_table_walk() is already suitable for
> > > this because it allows to specify "start" and "end" pasid.  Now you're
> > > always passing in the (0, VTD_MAX_HPASID) tuple, here you can simply
> > > pass in (pasid, pasid+1).  But I think you need to touch up
> > > vtd_sm_pasid_table_walk() a bit to make sure it allows the pasid to be
> > > not aliged to VTD_PASID_TBL_ENTRY_NUM.
> > >
> > > Another thing is I think vtd_sm_pasid_table_walk_one() didn't really
> > > check vtd_pasid_table_walk_info.did domain information...  When that's
> > > fixed, this case is the same as the DSI walk with a specific pasid
> > > range.
> > 
> > got it, let me refactor them (PSI and replay).
> > 
> > > And again, please also consider to use VTDPASIDCacheInfo to be used
> > > directly during the page walk, so vtd_pasid_table_walk_info can be
> > > replaced I think, because IIUC VTDPASIDCacheInfo contains all
> > > information the table walk will need.
> > 
> > yes, no need to have the walk_info structure.
> I'm not quite get here. Why cache_gen increase only happen in PSI
> hook? I think cache_gen used to avoid drop all pasid_as when a pasid
> cache reset happened.

(Is this paragraph for the other thread?  Let me know if it's not, or
 I'll skip it)

> 
> 
> Today, I'm trying to replace vtd_pasid_table_walk_info with
> VTDPASIDCacheInfo. But I found it may be a little bit strange.
> The vtd_pasid_table_walk_info include vtd_bus/devfn/did and a
> flag to indicate if did is useful.

vtd_pasid_table_walk_info.flags can only be either
VTD_PASID_TABLE_DID_SEL_WALK or nothing, but IIUC that's the same as
checking against VTDPASIDCacheInfo.flags with:

    (VTD_PASID_CACHE_DOMSI | VTD_PASID_CACHE_PASIDSI)

> The final user of the walk
> info is vtd_sm_pasid_table_walk_one() which only cares about
> the the vtd_bus/devfn/did. But VTDPASIDCacheInfo has an extra
> pasid field and also has multiple flag definitions

We can simply ignore the pasid field when walking the pasid table?
Just like we'll also ignore the domain id field if flag not set.

> , which are
> not necessary for the table work. So it appears to me use
> separate structure would be better. Maybe I can show you when
> sending out the code.

I still keep my previous comment that I think VTDPASIDCacheInfo can do
all the work, especially because all the pasid table walk triggers
from a pasid flush, so we can really reuse exactly the same
VTDPASIDCacheInfo structure that we just allocated, iiuc.

> 
> > > >
> > > > > > +
> > > > > > +    vtd_iommu_unlock(s);
> > > > > >      return 0;
> > > > > >  }
> > > > > >
> > > > > > +/**
> > > > > > + * Caller of this function should hold iommu_lock  */ static
> > > > > > +void vtd_pasid_cache_reset(IntelIOMMUState *s) {
> > > > > > +    VTDPASIDCacheInfo pc_info;
> > > > > > +
> > > > > > +    trace_vtd_pasid_cache_reset();
> > > > > > +
> > > > > > +    pc_info.flags = VTD_PASID_CACHE_GLOBAL;
> > > > > > +
> > > > > > +    /*
> > > > > > +     * Reset pasid cache is a big hammer, so use
> > > > > > +     * g_hash_table_foreach_remove which will free
> > > > > > +     * the vtd_pasid_as instances, indicates the
> > > > > > +     * cached pasid_cache_gen would be set to 0.
> > > > > > +     */
> > > > > > +    g_hash_table_foreach_remove(s->vtd_pasid_as,
> > > > > > +                           vtd_flush_pasid, &pc_info);
> > > > >
> > > > > Would this make sure the per pasid_as pasid_cache_gen will be reset to zero?
> > > I'm
> > > > > not very sure, say, what if the memory is stall during a reset and
> > > > > still have the
> > > old
> > > > > data?
> > > > >
> > > > > I'm not sure, but I feel like we should simply drop all pasid_as
> > > > > here, rather than using the same code for a global pasid invalidation.
> > > >
> > > > I see. Maybe I can get another helper function which always returns
> > > > true, and replace vtd_flush_pasid with the new function. This should
> > > > ensure all pasid_as are dropped. How do you think?
> > >
> > > g_hash_table_remove_all() might be easier. :)
> > 
> > right. I'll make it.
> 
> Sorry to reclaim my reply here. I think here still needs a function (say
> vtd_flush_pasid) to check if needs to notify host do unbind. e.g. If guest
> unbind a pasid in guest, and issues a GSI (pasid cache), remove_all()
> will drop all pasid_as, this would be a problem. The guest unbind will
> not be propagated to host. And even we add a replay after it, it can
> only shadow the bindings in guest to host, but cannot figure out an
> unbind. But I agree with you that vtd_pasid_cache_reset() should drop
> all pasid_as but also needs to notify host properly.

Agreed, anyway we should not depend on the pasid entry but we should
simply loop over all items and force unbind all of them before the
g_hash_table_remove_all().

-- 
Peter Xu

