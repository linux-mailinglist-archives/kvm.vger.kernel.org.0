Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8754363129
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 08:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfGIGjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 02:39:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41811 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGIGjZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 02:39:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id q4so8923788pgj.8
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 23:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bvGqzmcw85h3EbwUOHcoxh9t8Yk2J5NOzQ0lH/a3moQ=;
        b=koghTuuf52ddxcnHEhmyk9HaNH3r2OXE6yqjBWy8QGOTKcm7GnrTEWMpC+wZ7P79QB
         e6gMLMLRLlCknhoxpqk4lSU6cWuAj9sp6WWnZl9bg6WiejEmjcKyTv4JEUwhIkUYZwJz
         1lwVU9YMaVKmID9a4W2xvc+T5lnUe6oxYT6L7nfRlUQD0TqRUKPpgngb614zNPEAceiC
         CukKUmGfAMCpHQFjf+A4J7V8x/aNP18U4pzdUIkew/IWNjTY74ZxAiW/uD63V2z38CWk
         p9ewt/156ehOf63ODFVBcCyOoqORv+pcs0GjaeX23HuIq1h9Rr3hJeTfV/Xn0CKRxMsV
         iwTg==
X-Gm-Message-State: APjAAAViQ+DYw2zVvQUXUrAf8Kouhw5oP4PR/4jJRADMc9c3tkn+LFbL
        AYe4jI+gvwwHpfGP52AfAZUIhQ==
X-Google-Smtp-Source: APXvYqypfurbejdMOJ1Medej7i0dk2eLFxg8NJWviCiTCRv+NoOMnKKnWZnE44W7uK96RiV2pNJ67w==
X-Received: by 2002:a63:7a01:: with SMTP id v1mr29157315pgc.310.1562654364336;
        Mon, 08 Jul 2019 23:39:24 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m4sm40725235pff.108.2019.07.08.23.39.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 23:39:23 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Tue, 9 Jul 2019 14:39:15 +0800
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 11/18] intel_iommu: create VTDAddressSpace per BDF+PASID
Message-ID: <20190709063915.GG5178@xz-x1>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-12-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1562324511-2910-12-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 07:01:44PM +0800, Liu Yi L wrote:

[...]

> +/**
> + * This function finds or adds a VTDAddressSpace for a device when
> + * it is bound to a pasid
> + */
> +static VTDAddressSpace *vtd_add_find_pasid_as(IntelIOMMUState *s,
> +                                              PCIBus *bus,
> +                                              int devfn,
> +                                              uint32_t pasid,
> +                                              bool allocate)
> +{
> +    char key[32];
> +    char *new_key;
> +    VTDAddressSpace *vtd_pasid_as;
> +    uint16_t sid;
> +
> +    sid = vtd_make_source_id(pci_bus_num(bus), devfn);
> +    vtd_get_pasid_key(&key[0], 32, pasid, sid);
> +    vtd_pasid_as = g_hash_table_lookup(s->vtd_pasid_as, &key[0]);
> +
> +    if (!vtd_pasid_as && allocate) {
> +        new_key = g_malloc(32);
> +        vtd_get_pasid_key(&new_key[0], 32, pasid, sid);
> +        /*
> +         * Initiate the vtd_pasid_as structure.
> +         *
> +         * This structure here is used to track the guest pasid
> +         * binding and also serves as pasid-cache mangement entry.
> +         *
> +         * TODO: in future, if wants to support the SVA-aware DMA
> +         *       emulation, the vtd_pasid_as should be fully initialized.
> +         *       e.g. the address_space and memory region fields.
> +         */

I'm not very sure about this part.  IMHO all those memory regions are
used to inlay the whole IOMMU idea into QEMU's memory API framework.
Now even without the whole PASID support we've already have a workable
vtd_iommu_translate() that will intercept device DMA operations and we
can try to translate the IOVA to anything we want.  Now the iommu_idx
parameter of vtd_iommu_translate() is never used (I'd say until now I
still don't sure on whether the "iommu_idx" idea is the best we can
have... I've tried to debate on that but... anyway I assume for Intel
we can think it as the "pasid" information or at least contains it),
however in the further we can have that PASID/iommu_idx/whatever
passed into this translate() function too, then we can walk the 1st
level page table there if we found that this device had enabled the
1st level mapping (or even nested).  I don't see what else we need to
do to play with extra memory regions.

Conclusion: I feel like SVA can use its own structure here instead of
reusing VTDAddressSpace, because I think those memory regions can
probably be useless.  Even it will, we can refactor the code later,
but I really doubt it...

> +        vtd_pasid_as = g_malloc0(sizeof(VTDAddressSpace));
> +        vtd_pasid_as->iommu_state = s;
> +        vtd_pasid_as->bus = bus;
> +        vtd_pasid_as->devfn = devfn;
> +        vtd_pasid_as->context_cache_entry.context_cache_gen = 0;
> +        vtd_pasid_as->pasid = pasid;
> +        vtd_pasid_as->pasid_allocated = true;
> +        vtd_pasid_as->pasid_cache_entry.pasid_cache_gen = 0;
> +        g_hash_table_insert(s->vtd_pasid_as, new_key, vtd_pasid_as);
> +    }
> +    return vtd_pasid_as;
> +}

Regards,

-- 
Peter Xu
