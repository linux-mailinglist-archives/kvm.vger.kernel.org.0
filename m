Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46DE63051
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 08:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfGIGMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 02:12:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33013 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfGIGMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 02:12:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id m4so8901281pgk.0
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 23:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nvrrdFwLavFegQ89jBa6tFS05TG/raQM37KhZRycP+U=;
        b=oZcm/6321qfL0UvrqAFCaGyXXPrheMidDRuuU/JIRH1P2ljo45SgXwF70OOfn8gjET
         3423Z/BZct0NHD6uue669PQlLmiKRqySW3XLDm3r7NEHBE6tdAg/oLo7lp9VFxwe8Ofx
         ccpsl4xPcvq5WMnsYlezyNSlxgqy4/OrEPMkpO6c3z3JjR+3RXhIhAgc5GP4d+trGp11
         8HPIwZ7VtsA2n2ij+UkAd7mtE1y4RB/VrqVeKpRYwYG1xUucWiv1OG3X9c2wfQFXltgO
         XKS2vA/o0vTgQUV/piUY9qpVOBC7/g5yrRSm97/kn6DcUhMl3rk0iHLYFu+WybwKLv4E
         AJPg==
X-Gm-Message-State: APjAAAVMAgvTPQnw/lGm5L3/fy+G2T/lUSQlrVXgzBQL7aKFqTr3Spe+
        XnSMbvNKyIgnhJY3vPa1dXwS9w==
X-Google-Smtp-Source: APXvYqw/Xmo/GQdncSlnPMpnScbCTZIkWo24q1AKPaW+ouX5tU2i+uKwkwvTaM1mb1pqSkIInxZajQ==
X-Received: by 2002:a17:90a:fe5:: with SMTP id 92mr14385283pjz.35.1562652772796;
        Mon, 08 Jul 2019 23:12:52 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p13sm2739247pjb.30.2019.07.08.23.12.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 23:12:51 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Tue, 9 Jul 2019 14:12:40 +0800
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 10/18] intel_iommu: tag VTDAddressSpace instance with
 PASID
Message-ID: <20190709061240.GF5178@xz-x1>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-11-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1562324511-2910-11-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 07:01:43PM +0800, Liu Yi L wrote:
> This patch introduces new fields in VTDAddressSpace for further PASID support
> in Intel vIOMMU. In old time, each device has a VTDAddressSpace instance to
> stand for its guest IOVA address space when vIOMMU is enabled. However, when
> PASID is exposed to guest, device will have multiple address spaces which
> are tagged with PASID. To suit this change, VTDAddressSpace should be tagged
> with PASIDs in Intel vIOMMU.
> 
> To record PASID tagged VTDAddressSpaces, a hash table is introduced. The
> data in the hash table can be used for future sanity check and retrieve
> previous PASID configs of guest and also future emulated SVA DMA support
> for emulated SVA capable devices. The lookup key is a string and its format
> is as below:
> 
> "rsv%04dpasid%010dsid%06d" -- totally 32 bytes

Can we make it simply a struct?

        struct pasid_key {
                uint32_t pasid;
                uint16_t sid;
        }

Also I think we don't need to keep reserved bits because it'll be a
structure that'll only be used by QEMU so we can extend it easily in
the future when necessary.

[...]

> +static int vtd_pasid_cache_dsi(IntelIOMMUState *s, uint16_t domain_id)
> +{
> +    VTDPASIDCacheInfo pc_info;
> +
> +    trace_vtd_pasid_cache_dsi(domain_id);
> +
> +    pc_info.flags = VTD_PASID_CACHE_DOMSI;
> +    pc_info.domain_id = domain_id;
> +
> +    /*
> +     * use g_hash_table_foreach_remove(), which will free the
> +     * vtd_pasid_as instances.
> +     */
> +    g_hash_table_foreach_remove(s->vtd_pasid_as, vtd_flush_pasid, &pc_info);
> +    /*
> +     * TODO: Domain selective PASID cache invalidation
> +     * may be issued wrongly by programmer, to be safe,
> +     * after invalidating the pasid caches, emulator
> +     * needs to replay the pasid bindings by walking guest
> +     * pasid dir and pasid table.
> +     */

It seems to me that this is still unchanged for the whole series.
It's fine for RFC, but just a reminder that please either comment on
why we don't have something or implement what we need here...

[...]

>  /* Unmap the whole range in the notifier's scope. */
>  static void vtd_address_space_unmap(VTDAddressSpace *as, IOMMUNotifier *n)
>  {
> @@ -3914,6 +4076,8 @@ static void vtd_realize(DeviceState *dev, Error **errp)
>                                       g_free, g_free);
>      s->vtd_as_by_busptr = g_hash_table_new_full(vtd_uint64_hash, vtd_uint64_equal,
>                                                g_free, g_free);
> +    s->vtd_pasid_as = g_hash_table_new_full(&g_str_hash, &g_str_equal,
> +                                     g_free, hash_pasid_as_free);

Can use g_free() and drop hash_pasid_as_free()?

Also, this patch only tries to drop entries of the hash table but the
hash table is never inserted or used.  I would suggest that you put
that part to be with this patch as a whole otherwise it's hard to
clarify how this hash table will be used.

Regards,

-- 
Peter Xu
