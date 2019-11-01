Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1210EEC520
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 15:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfKAOzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 10:55:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727334AbfKAOzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 10:55:08 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 28A898553A
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 14:55:08 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id e25so5651775wra.9
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 07:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=k15X9zqJVfW3oC0HT7dnDU0xGIS3I2u3p6fKi7ClOn0=;
        b=dqRd8jMU/qvL2Z+IwQqjvt3a9yjrux4viw5n6wlOgmw/4ztaJvyiXv2nr+a7uAueeG
         jaW2vZP+yZGDg4WSDkkjGip5oezRAPz7y958g1Lf02KQwngmOoTrO5W1J2XQDlmp9DqY
         qe4TclpIxy/2GsoIhy4AUSXpRM7AhE+ha2nKGcoDfNzwYX8GM2agOP99hnDnGT7AiDzR
         397Mwzo0+BcGmV1zbKfZ8UzQz4WYPrZTz4ryywxU6tywVmRstskcInikTmmq+9CNb1ZN
         2BZHM4dBNyfdwm3QvWzK+FDhQ/2/S+0yiEsId1dXG1zkH1lORLYAO9Q0I0i3giEmSYZs
         ScFQ==
X-Gm-Message-State: APjAAAUxXGxoayw+gAEVDWzsS2D8flirZBYgy5TTW3lOEhwifyK1ohTA
        Hno8vSh/zke1VOfAyNehd4kZsj2ClsopGTI3apNBv2Q7ddvYJkdR2vpA7yGn3iPixHWMnOP8i7l
        s+WVIVFop59Sw
X-Received: by 2002:a7b:c747:: with SMTP id w7mr11206531wmk.62.1572620106485;
        Fri, 01 Nov 2019 07:55:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwSAkwj4/WJI+mK4RnP3iTmSlwbqfZTGcpQ6d11+q5qMJ/2ycB4ozpO4qLetVrQ6gMGRzVoeQ==
X-Received: by 2002:a7b:c747:: with SMTP id w7mr11206506wmk.62.1572620106261;
        Fri, 01 Nov 2019 07:55:06 -0700 (PDT)
Received: from xz-x1.metropole.lan ([91.217.168.176])
        by smtp.gmail.com with ESMTPSA id l18sm8252323wrn.48.2019.11.01.07.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 07:55:05 -0700 (PDT)
Date:   Fri, 1 Nov 2019 15:55:03 +0100
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 08/22] intel_iommu: provide get_iommu_context() callback
Message-ID: <20191101145503.GB8888@xz-x1.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-9-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1571920483-3382-9-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 08:34:29AM -0400, Liu Yi L wrote:
> This patch adds get_iommu_context() callback to return an iommu_context
> Intel VT-d platform.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/i386/intel_iommu.c         | 57 ++++++++++++++++++++++++++++++++++++++-----
>  include/hw/i386/intel_iommu.h | 14 ++++++++++-
>  2 files changed, 64 insertions(+), 7 deletions(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 67a7836..e9f8692 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -3288,22 +3288,33 @@ static const MemoryRegionOps vtd_mem_ir_ops = {
>      },
>  };
>  
> -VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn)
> +static VTDBus *vtd_find_add_bus(IntelIOMMUState *s, PCIBus *bus)
>  {
>      uintptr_t key = (uintptr_t)bus;
> -    VTDBus *vtd_bus = g_hash_table_lookup(s->vtd_as_by_busptr, &key);
> -    VTDAddressSpace *vtd_dev_as;
> -    char name[128];
> +    VTDBus *vtd_bus;
>  
> +    vtd_iommu_lock(s);

Why explicitly take the IOMMU lock here?  I mean, it's fine to take
it, but if so why not take it to cover the whole vtd_find_add_as()?

For now it'll be fine in either way because I believe iommu_lock is
not really functioning when we're still with BQL here, however if you
add that explicitly then I don't see why it's not covering that.

> +    vtd_bus = g_hash_table_lookup(s->vtd_as_by_busptr, &key);
>      if (!vtd_bus) {
>          uintptr_t *new_key = g_malloc(sizeof(*new_key));
>          *new_key = (uintptr_t)bus;
>          /* No corresponding free() */
> -        vtd_bus = g_malloc0(sizeof(VTDBus) + sizeof(VTDAddressSpace *) * \
> -                            PCI_DEVFN_MAX);
> +        vtd_bus = g_malloc0(sizeof(VTDBus) + PCI_DEVFN_MAX * \
> +                    (sizeof(VTDAddressSpace *) + sizeof(VTDIOMMUContext *)));

Should this be as simple as g_malloc0(sizeof(VTDBus) since [1]?

Otherwise the patch looks sane to me.

>          vtd_bus->bus = bus;
>          g_hash_table_insert(s->vtd_as_by_busptr, new_key, vtd_bus);
>      }
> +    vtd_iommu_unlock(s);
> +    return vtd_bus;
> +}

[...]

>  struct VTDBus {
>      PCIBus* bus;		/* A reference to the bus to provide translation for */
> -    VTDAddressSpace *dev_as[0];	/* A table of VTDAddressSpace objects indexed by devfn */
> +    /* A table of VTDAddressSpace objects indexed by devfn */
> +    VTDAddressSpace *dev_as[PCI_DEVFN_MAX];
> +    /* A table of VTDIOMMUContext objects indexed by devfn */
> +    VTDIOMMUContext *dev_ic[PCI_DEVFN_MAX];

[1]

>  };
>  
>  struct VTDIOTLBEntry {
> @@ -282,5 +293,6 @@ struct IntelIOMMUState {
>   * create a new one if none exists
>   */
>  VTDAddressSpace *vtd_find_add_as(IntelIOMMUState *s, PCIBus *bus, int devfn);
> +VTDIOMMUContext *vtd_find_add_ic(IntelIOMMUState *s, PCIBus *bus, int devfn);
>  
>  #endif
> -- 
> 2.7.4
> 

Regards,

-- 
Peter Xu
