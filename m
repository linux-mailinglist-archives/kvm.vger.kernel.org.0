Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1566AEC83C
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2019 19:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfKASFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Nov 2019 14:05:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbfKASFx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Nov 2019 14:05:53 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 632C383F42
        for <kvm@vger.kernel.org>; Fri,  1 Nov 2019 18:05:52 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id f16so5576459wrr.16
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2019 11:05:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bW4kAMz70wE8mNzhdtEquIUpa40ChbGszqjVepJPu4U=;
        b=aRvL1SbZE7x9a99GN9Arx4CO2YTcnUF3izeBZrpvsLgmQvmXby/+5d6OVknlrgSQvd
         qNlIpyLgCpydvjaR2oDV0sz8Z1gAdmZZUiGiAOkySWItEhbi947fHLMFGXQhps4MdUxl
         msZVCNh+HRloQGVMjdboxcEWzDNDSc6V68MMyImJfZ2tTqc8Ps9DZUbm57//RULFQmta
         WaQwzIOkwOzuSxa7ubRTpNFOHDZoD+GFQ5U8dpUafCwIjrq7Eg+mtsKtpwlpFYKRiCZ0
         z1GJaXm68Ezkqau8MBjNa39JdDIQOJFH7zGXaUOB9ls7bYICvlbhhUUFiVshimBH1PAG
         tW4w==
X-Gm-Message-State: APjAAAUPwOuTVhF4irgWTzDe7qn0Ymayn5b2wNkBSd3jx/Kqwr/kfpR4
        4QeoffghvwM8jf7Gxd8NdJzn1QGIixa8GTUgD4dplbrTks6Y2rrwk7Lg5FEcSJ0DEqb4S0YM7zL
        3r6SfZaqudIgJ
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr10993853wma.16.1572631551114;
        Fri, 01 Nov 2019 11:05:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxjJm1StaUbWOCA2FKeVNdnigm19E30FnhNyJnO6fb8pFcRPCd3Cx1FIc7nMDW0X28cHg57lw==
X-Received: by 2002:a1c:49c2:: with SMTP id w185mr10993836wma.16.1572631550870;
        Fri, 01 Nov 2019 11:05:50 -0700 (PDT)
Received: from xz-x1.metropole.lan (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id t12sm7612049wrx.93.2019.11.01.11.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 11:05:49 -0700 (PDT)
Date:   Fri, 1 Nov 2019 19:05:45 +0100
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jacob.jun.pan@linux.intel.com, kvm@vger.kernel.org,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v2 10/22] intel_iommu: add virtual command capability
 support
Message-ID: <20191101180544.GF8888@xz-x1.metropole.lan>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-11-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1571920483-3382-11-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 24, 2019 at 08:34:31AM -0400, Liu Yi L wrote:
> This patch adds virtual command support to Intel vIOMMU per
> Intel VT-d 3.1 spec. And adds two virtual commands: alloc_pasid
> and free_pasid.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> ---
>  hw/i386/intel_iommu.c          | 162 ++++++++++++++++++++++++++++++++++++++++-
>  hw/i386/intel_iommu_internal.h |  38 ++++++++++
>  hw/i386/trace-events           |   1 +
>  include/hw/i386/intel_iommu.h  |   6 +-
>  4 files changed, 205 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index e9f8692..88b843f 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -944,6 +944,7 @@ static VTDBus *vtd_find_as_from_bus_num(IntelIOMMUState *s, uint8_t bus_num)
>                  return vtd_bus;
>              }
>          }
> +        vtd_bus = NULL;

I feel like I've commented on this..

Should this be a standalone patch?

>      }
>      return vtd_bus;
>  }
> @@ -2590,6 +2591,140 @@ static void vtd_handle_iectl_write(IntelIOMMUState *s)
>      }
>  }
>  
> +static int vtd_request_pasid_alloc(IntelIOMMUState *s)
> +{
> +    VTDBus *vtd_bus;
> +    int bus_n, devfn;
> +    IOMMUCTXEventData event_data;
> +    IOMMUCTXPASIDReqDesc req;
> +    VTDIOMMUContext *vtd_ic;
> +
> +    event_data.event = IOMMU_CTX_EVENT_PASID_ALLOC;
> +    event_data.data = &req;
> +    req.min_pasid = VTD_MIN_HPASID;
> +    req.max_pasid = VTD_MAX_HPASID;
> +    req.alloc_result = 0;
> +    event_data.length = sizeof(req);

As mentioned in the other thread, do you think we can drop this length
field?

> +    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
> +        vtd_bus = vtd_find_as_from_bus_num(s, bus_n);
> +        if (!vtd_bus) {
> +            continue;
> +        }
> +        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
> +            vtd_ic = vtd_bus->dev_ic[devfn];
> +            if (!vtd_ic) {
> +                continue;
> +            }
> +            iommu_ctx_event_notify(&vtd_ic->iommu_context, &event_data);

Considering that we'll fill in the result into event_data, it could be
a bit misleading to still call it "notify" here because normally it
should only get data from the notifier caller rather than returning a
meaningful value..  Things like SUCCESS/FAIL would be fine, but here
we're returning a pasid from the notifier which seems a bit odd.

Maybe rename it to iommu_ctx_event_deliver()?  Then we just rename all
the references of "notify" thingys into "hook" or something clearer?

> +            if (req.alloc_result > 0) {

I'd suggest we comment on this:

    We'll return the first valid result we got.  It's a bit hackish in
    that we don't have a good global interface yet to talk to modules
    like vfio to deliver this allocation request, so we're leveraging
    this per-device context to do the same thing just to make sure the
    allocation happens only once.

Same to the pasid_free() below, though you can reference the comment
here from there to be simple.

> +                return req.alloc_result;
> +            }
> +        }
> +    }
> +    return -1;
> +}
> +
> +static int vtd_request_pasid_free(IntelIOMMUState *s, uint32_t pasid)
> +{
> +    VTDBus *vtd_bus;
> +    int bus_n, devfn;
> +    IOMMUCTXEventData event_data;
> +    IOMMUCTXPASIDReqDesc req;
> +    VTDIOMMUContext *vtd_ic;
> +
> +    event_data.event = IOMMU_CTX_EVENT_PASID_FREE;
> +    event_data.data = &req;
> +    req.pasid = pasid;
> +    req.free_result = 0;
> +    event_data.length = sizeof(req);
> +    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
> +        vtd_bus = vtd_find_as_from_bus_num(s, bus_n);
> +        if (!vtd_bus) {
> +            continue;
> +        }
> +        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
> +            vtd_ic = vtd_bus->dev_ic[devfn];
> +            if (!vtd_ic) {
> +                continue;
> +            }
> +            iommu_ctx_event_notify(&vtd_ic->iommu_context, &event_data);
> +            if (req.free_result == 0) {
> +                return 0;
> +            }
> +        }
> +    }
> +    return -1;
> +}
> +
> +/*
> + * If IP is not set, set it and return 0
> + * If IP is already set, return -1
> + */
> +static int vtd_vcmd_rsp_ip_check(IntelIOMMUState *s)
> +{
> +    if (!(s->vccap & VTD_VCCAP_PAS) ||
> +         (s->vcrsp & 1)) {
> +        return -1;
> +    }

VTD_VCCAP_PAS is not a IP check, so maybe simply move these chunk out
to vtd_handle_vcmd_write?  Then we can rename this function to
"void vtd_vcmd_ip_set(...)".

> +    s->vcrsp = 1;
> +    vtd_set_quad_raw(s, DMAR_VCRSP_REG,
> +                     ((uint64_t) s->vcrsp));
> +    return 0;
> +}
> +
> +static void vtd_vcmd_clear_ip(IntelIOMMUState *s)
> +{
> +    s->vcrsp &= (~((uint64_t)(0x1)));
> +    vtd_set_quad_raw(s, DMAR_VCRSP_REG,
> +                     ((uint64_t) s->vcrsp));
> +}
> +
> +/* Handle write to Virtual Command Register */
> +static int vtd_handle_vcmd_write(IntelIOMMUState *s, uint64_t val)
> +{
> +    uint32_t pasid;
> +    int ret = -1;
> +
> +    trace_vtd_reg_write_vcmd(s->vcrsp, val);
> +
> +    /*
> +     * Since vCPU should be blocked when the guest VMCD
> +     * write was trapped to here. Should be no other vCPUs
> +     * try to access VCMD if guest software is well written.
> +     * However, we still emulate the IP bit here in case of
> +     * bad guest software. Also align with the spec.
> +     */
> +    ret = vtd_vcmd_rsp_ip_check(s);
> +    if (ret) {
> +        return ret;
> +    }
> +    switch (val & VTD_VCMD_CMD_MASK) {
> +    case VTD_VCMD_ALLOC_PASID:
> +        ret = vtd_request_pasid_alloc(s);
> +        if (ret < 0) {
> +            s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_NO_AVAILABLE_PASID);
> +        } else {
> +            s->vcrsp |= VTD_VCRSP_RSLT(ret);
> +        }
> +        break;
> +
> +    case VTD_VCMD_FREE_PASID:
> +        pasid = VTD_VCMD_PASID_VALUE(val);
> +        ret = vtd_request_pasid_free(s, pasid);
> +        if (ret < 0) {
> +            s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_FREE_INVALID_PASID);
> +        }
> +        break;
> +
> +    default:
> +        s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_UNDEFINED_CMD);
> +        printf("Virtual Command: unsupported command!!!\n");

Perhaps error_report_once()?

> +        break;
> +    }
> +    vtd_vcmd_clear_ip(s);
> +    return 0;
> +}
> +
>  static uint64_t vtd_mem_read(void *opaque, hwaddr addr, unsigned size)
>  {
>      IntelIOMMUState *s = opaque;
> @@ -2879,6 +3014,23 @@ static void vtd_mem_write(void *opaque, hwaddr addr,
>          vtd_set_long(s, addr, val);
>          break;
>  
> +    case DMAR_VCMD_REG:
> +        if (!vtd_handle_vcmd_write(s, val)) {
> +            if (size == 4) {
> +                vtd_set_long(s, addr, val);
> +            } else {
> +                vtd_set_quad(s, addr, val);
> +            }
> +        }
> +        break;
> +
> +    case DMAR_VCMD_REG_HI:
> +        assert(size == 4);

This assert() seems scary, but of course not a problem of this patch
because plenty of that are there in vtd_mem_write..  So we can fix
that later.

Do you know what should happen on bare-metal from spec-wise that when
the guest e.g. writes 2 bytes to these mmio regions?

> +        if (!vtd_handle_vcmd_write(s, val)) {
> +            vtd_set_long(s, addr, val);
> +        }
> +        break;
> +
>      default:
>          if (size == 4) {
>              vtd_set_long(s, addr, val);
> @@ -3617,7 +3769,8 @@ static void vtd_init(IntelIOMMUState *s)
>              s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
>          } else if (!strcmp(s->scalable_mode, "modern")) {
>              s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID
> -                       | VTD_ECAP_FLTS | VTD_ECAP_PSS;
> +                       | VTD_ECAP_FLTS | VTD_ECAP_PSS | VTD_ECAP_VCS;
> +            s->vccap |= VTD_VCCAP_PAS;
>          }
>      }
>  

[...]

> +#define VTD_VCMD_CMD_MASK           0xffUL
> +#define VTD_VCMD_PASID_VALUE(val)   (((val) >> 8) & 0xfffff)
> +
> +#define VTD_VCRSP_RSLT(val)         ((val) << 8)
> +#define VTD_VCRSP_SC(val)           (((val) & 0x3) << 1)
> +
> +#define VTD_VCMD_UNDEFINED_CMD         1ULL
> +#define VTD_VCMD_NO_AVAILABLE_PASID    2ULL

According to 10.4.44 - should this be 1?

-- 
Peter Xu
