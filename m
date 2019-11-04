Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1343EE58F
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 18:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfKDRIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 12:08:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56140 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727989AbfKDRIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 12:08:43 -0500
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C7FF48535D
        for <kvm@vger.kernel.org>; Mon,  4 Nov 2019 17:08:42 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id v23so19373954qth.20
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 09:08:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uKHKr+sED8/ifki1N84hANz+1qxhCsRrQg1xbOjDuGQ=;
        b=oRFpF/3vJ2hG4VLJU7AUDjZqd66/38SNcLNtGGq4aQgtQrBQzh2VbH6KE+eNx/jTjc
         M21yDSnuwpDF54NxbLC3aBxgbQePwsO+2XvGraCKUkpcPrpL4nTn/xKJJ1R/Z+qjB+nj
         IcQnXQ16yTTeWI0XbnyvrjmoY2c6PHhmykkMy8RYFLQEfSyKZ/qSbuB3KUpU7jOBiU5c
         IM2/L7Y1KUjJ/h18QTMQl3Elw+Z2zunuTY0WVdiU3Gvc64ErlPWP9nbSfFucmW5nHr4v
         DK36zfVfJ2QjFNdP5uVMpMPxK8QiB8571S8ua6Q3RwFPyrewAjnMEbfLRwAgcPV/cJuS
         jxhA==
X-Gm-Message-State: APjAAAVjYRxBFV6zWx7r1yAooUkZ+CDkUepvJ5vC9I2GlUkTZ8qNoo1q
        Q7y4HRuEPdFZHHEEqFGnFROMD86VWVtiq6fTOY26toQRh3rhm6FXOK4/bS76EX+37PhIvs+WcH5
        Xd+wBID6HLn+K
X-Received: by 2002:ac8:109:: with SMTP id e9mr13539983qtg.233.1572887322085;
        Mon, 04 Nov 2019 09:08:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwnZiHtSCIDwnaSbOGiV++99WNwUV0+w//hsZpHrFlaZveBT2pjBpdR3kZqEA9vRmxqY9w+YA==
X-Received: by 2002:ac8:109:: with SMTP id e9mr13539942qtg.233.1572887321714;
        Mon, 04 Nov 2019 09:08:41 -0800 (PST)
Received: from xz-x1.metropole.lan ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id b21sm2620443qtr.67.2019.11.04.09.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 09:08:40 -0800 (PST)
Date:   Mon, 4 Nov 2019 12:08:38 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 13/22] intel_iommu: add PASID cache management
 infrastructure
Message-ID: <20191104170838.GC26023@xz-x1.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-14-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1571920483-3382-14-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 08:34:34AM -0400, Liu Yi L wrote:
> This patch adds a PASID cache management infrastructure based on
> new added structure VTDPASIDAddressSpace, which is used to track
> the PASID usage and future PASID tagged DMA address translation
> support in vIOMMU.
> 
>     struct VTDPASIDAddressSpace {
>         VTDBus *vtd_bus;
>         uint8_t devfn;
>         AddressSpace as;
>         uint32_t pasid;
>         IntelIOMMUState *iommu_state;
>         VTDContextCacheEntry context_cache_entry;
>         QLIST_ENTRY(VTDPASIDAddressSpace) next;
>         VTDPASIDCacheEntry pasid_cache_entry;
>     };
> 
> Ideally, a VTDPASIDAddressSpace instance is created when a PASID
> is bound with a DMA AddressSpace. Intel VT-d spec requires guest
> software to issue pasid cache invalidation when bind or unbind a
> pasid with an address space under caching-mode. However, as
> VTDPASIDAddressSpace instances also act as pasid cache in this
> implementation, its creation also happens during vIOMMU PASID
> tagged DMA translation. The creation in this path will not be
> added in this patch since no PASID-capable emulated devices for
> now.

So is this patch an incomplete version even for the pasid caching
layer for emulated device?

IMHO it would be considered as acceptable to merge something that is
even not ready from hardware pov but at least from software pov it is
complete (so when the hardware is ready we should logically run the
binary directly on them, bugs can happen but that's another story).
However if for this case:

  - it's not even complete as is (in translation functions it seems
    that we don't ever use this cache layer at all),

  - we don't have emulated device supported for pasid yet at all, so
    even further to have this code start to make any sense, and,

  - this is a 400 line patch as standalone :)  Which means that we
    need to start maintain these 400 LOC starting from the day when it
    gets merged, while it's far from even being tested.  Then I don't
    see how to maintain...

With above, I would suggest you put this patch into the future
patchset where you would like to have the first emulated device for
pasid and then you can even test this patch with those ones.  What do
you think?

Thanks,

-- 
Peter Xu
