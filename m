Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE3062EB1
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 05:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfGIDTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 23:19:16 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43356 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfGIDTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 23:19:15 -0400
Received: by mail-pf1-f193.google.com with SMTP id i189so8553757pfg.10
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2019 20:19:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9uUeJaiLlZUAr8WH1k6RmwXX3zjFWC96L+aS8xHJ5UU=;
        b=Sym7eVtqu26ZwhoZMpqzb5TZXAlePZYy7S1+p54RMzL5bXb1/sS/PMR4J2XGGnuIpX
         kdHnILP0fd6C2YYt/pZZGeK4lWYXIx2f9wiNaw5YgoN7mp0+fti12T6jwQgPmL7qdbVT
         DKAU4TCPqeFFR7FfXrkveoSygITyyek+CF63jmOx7iQJl976mGPDLm21XGeYZqUEe+Nx
         k7OqUVrpjfaXN1EvQGKS3wBsfDFPJ9NR4WvqR6dK1KdF34hasQJsIIHNs01ofBwIFO2G
         BnDcafGQ5OK81Vi2UVDPbca/AZ13dxomSlvDvdBsl03F6YynLpuzwfdwJNrEOLQvZVYS
         THyw==
X-Gm-Message-State: APjAAAXu+EruLPqFi8Q0Ox7d3H4OBa1Yv1X6oruyRHElFsskSSf7V0+I
        f5PVLZh3GdpkebHDB6z4t5smjA==
X-Google-Smtp-Source: APXvYqweMw2qgR2X/fz79vTFVtFx0V+H4u71qNaTh3WO5l6/BAwUYUrTjyT8g6W0+1z68/pGxOQzTw==
X-Received: by 2002:a17:90a:214e:: with SMTP id a72mr30704625pje.0.1562642354404;
        Mon, 08 Jul 2019 20:19:14 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 65sm20448940pff.148.2019.07.08.20.19.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 20:19:13 -0700 (PDT)
From:   Peter Xu <zhexu@redhat.com>
X-Google-Original-From: Peter Xu <peterx@redhat.com>
Date:   Tue, 9 Jul 2019 11:19:02 +0800
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, tianyu.lan@intel.com,
        kevin.tian@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v1 06/18] intel_iommu: support virtual command emulation
 and pasid request
Message-ID: <20190709031902.GD5178@xz-x1>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-7-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1562324511-2910-7-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 05, 2019 at 07:01:39PM +0800, Liu Yi L wrote:
> This patch adds virtual command support to Intel vIOMMU per Intel VT-d 3.1
> spec. This patch adds two virtual commands: alloc_pasid and free_pasid.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> ---
>  hw/i386/intel_iommu.c          | 139 ++++++++++++++++++++++++++++++++++++++++-
>  hw/i386/intel_iommu_internal.h |  30 +++++++++
>  hw/i386/trace-events           |   1 +
>  include/hw/i386/intel_iommu.h  |   6 +-
>  4 files changed, 174 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 3160a05..3cf250d 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -932,11 +932,19 @@ static VTDBus *vtd_find_as_from_bus_num(IntelIOMMUState *s, uint8_t bus_num)
>                  s->vtd_as_by_bus_num[bus_num] = vtd_bus;
>                  return vtd_bus;
>              }
> +            vtd_bus = NULL;

Can move to ...
>          }

... here?

>      }
>      return vtd_bus;
>  }
>  
> +static PCIBus *vtd_find_pci_bus_from_bus_num(IntelIOMMUState *s,
> +                                             uint8_t bus_num)
> +{
> +    VTDBus *vtd_bus = vtd_find_as_from_bus_num(s, bus_num);
> +    return vtd_bus ? vtd_bus->bus : NULL;
> +}
> +
>  /* Given the @iova, get relevant @slptep. @slpte_level will be the last level
>   * of the translation, can be used for deciding the size of large page.
>   */
> @@ -2579,6 +2587,103 @@ static void vtd_handle_iectl_write(IntelIOMMUState *s)
>      }
>  }
>  
> +static int vtd_request_pasid_alloc(IntelIOMMUState *s)
> +{
> +    PCIBus *bus;
> +    int bus_n, devfn;
> +
> +    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
> +        bus = vtd_find_pci_bus_from_bus_num(s, bus_n);
> +        if (!bus) {
> +            continue;
> +        }
> +        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
> +            if (pci_device_is_ops_set(bus, devfn)) {
> +                return pci_device_request_pasid_alloc(bus, devfn,
> +                                                      VTD_MIN_HPASID,
> +                                                      VTD_MAX_HPASID);

Ah so here I see why pci_device_is_ops_set() is necessary... you
wanted to find a device that is vfio-pci and supports PASID.  This is
a bit awkward but indeed I don't know what's a better option to make
it a clearer interface if we can't let IOMMU to talk directly to vfio.

THe thing is that VFIO_IOMMU_PASID_REQUEST seems to be defined per
VFIO container, while VT-d spec is of course defining PASID allocation
as globally.  More context on how the pasid address space will be
defined and considerations behind (not only for this series, but for
the big picture of SVA work) would be greatly welcomed.

> +            }
> +        }
> +    }
> +    return -1;
> +}
> +
> +static int vtd_request_pasid_free(IntelIOMMUState *s, uint32_t pasid)
> +{
> +    PCIBus *bus;
> +    int bus_n, devfn;
> +
> +    for (bus_n = 0; bus_n < PCI_BUS_MAX; bus_n++) {
> +        bus = vtd_find_pci_bus_from_bus_num(s, bus_n);
> +        if (!bus) {
> +            continue;
> +        }
> +        for (devfn = 0; devfn < PCI_DEVFN_MAX; devfn++) {
> +            if (pci_device_is_ops_set(bus, devfn)) {
> +                return pci_device_request_pasid_free(bus, devfn, pasid);
> +            }
> +        }
> +    }
> +    return -1;
> +}
> +
> +/* Handle write to Virtual Command Register */
> +static void vtd_handle_vcmd_write(IntelIOMMUState *s)
> +{
> +    uint32_t status = vtd_get_long_raw(s, DMAR_VCRSP_REG);
> +    uint32_t val = vtd_get_long_raw(s, DMAR_VCMD_REG);
> +    uint32_t pasid;
> +    int ret = -1;
> +
> +    trace_vtd_reg_write_vcmd(status, val);

Could we use s->vcrsp directly instead of using DMAR_VCRSP_REG?

> +
> +    switch (val & VTD_VCMD_CMD_MASK) {
> +    case VTD_VCMD_ALLOC_PASID:
> +        if (!(s->vccap & VTD_VCCAP_PAS) ||
> +             (s->vcrsp & 1)) {

Nit: we can consider to offer some helpers for them.

Also, I think we should check vcrsp&1 at the entry for all vcmds. [1]

> +            break;
> +        }
> +        s->vcrsp = 1;
> +        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
> +                         ((uint64_t) s->vcrsp));

Do we really need to emulate the "In Progress" like this?  The vcpu is
blocked here after all, and AFAICT all the rest of vcpus should not
access these registers because obviously these registers cannot be
accessed concurrently...

I think the IP bit is useful when some new vcmd would take plenty of
time so that we can do the long vcmds in async way.  However here it
seems not the case?

> +        ret = vtd_request_pasid_alloc(s);
> +        if (ret < 0) {
> +            s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_NO_AVAILABLE_PASID);
> +        } else {
> +            s->vcrsp |= VTD_VCRSP_RSLT(ret);
> +        }
> +        s->vcrsp &= (~((uint64_t)(0x1)));
> +        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
> +                         ((uint64_t) s->vcrsp));
> +        break;
> +
> +    case VTD_VCMD_FREE_PASID:
> +        if (!(s->vccap & VTD_VCCAP_PAS) ||
> +             (s->vcrsp & 1)) {
> +            break;
> +        }
> +        s->vcrsp &= 1;
> +        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
> +                         ((uint64_t) s->vcrsp));

Same here on IP bit emulation.  IMHO we can drop these and this
function can be greatly simplified.  Your call. :)

> +        pasid = VTD_VCMD_PASID_VALUE(val);
> +        ret = vtd_request_pasid_free(s, pasid);
> +        if (ret < 0) {
> +            s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_FREE_INVALID_PASID);
> +        }
> +        s->vcrsp &= (~((uint64_t)(0x1)));
> +        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
> +                         ((uint64_t) s->vcrsp));
> +        break;
> +
> +    default:
> +        s->vcrsp |= VTD_VCRSP_SC(VTD_VCMD_UNDEFINED_CMD);

(IMHO you can simply do s/|=/=/ here if you handle IP well at the
 entry of the function)

> +        vtd_set_quad_raw(s, DMAR_VCRSP_REG,
> +                         ((uint64_t) s->vcrsp));
> +        printf("Virtual Command: unsupported command!!!\n");
> +        break;
> +    }
> +}
> +
>  static uint64_t vtd_mem_read(void *opaque, hwaddr addr, unsigned size)
>  {
>      IntelIOMMUState *s = opaque;
> @@ -2620,6 +2725,15 @@ static uint64_t vtd_mem_read(void *opaque, hwaddr addr, unsigned size)
>          val = s->iq >> 32;
>          break;
>  
> +    case DMAR_VCRSP_REG:
> +        val = s->vcrsp;
> +        break;
> +
> +    case DMAR_VCRSP_REG_HI:
> +        assert(size == 4);
> +        val = s->vcrsp >> 32;
> +        break;

If you're always with vtd_set_quad_raw()s then IMHO you can drop these
lines?  vtd_mem_read() has a default to handle all these.

> +
>      default:
>          if (size == 4) {
>              val = vtd_get_long(s, addr);
> @@ -2868,6 +2982,21 @@ static void vtd_mem_write(void *opaque, hwaddr addr,
>          vtd_set_long(s, addr, val);
>          break;
>  
> +    case DMAR_VCMD_REG:
> +        if (size == 4) {
> +            vtd_set_long(s, addr, val);
> +        } else {
> +            vtd_set_quad(s, addr, val);
> +        }
> +        vtd_handle_vcmd_write(s);

IMHO you should do vtd_handle_vcmd_write() first and let it return a
value, when returning true you update the regisers using vtd_set_*()
otherwise you should skip (e.g., when IP is set in vcmd result reg).

> +        break;
> +
> +    case DMAR_VCMD_REG_HI:
> +        assert(size == 4);
> +        vtd_set_long(s, addr, val);
> +        vtd_handle_vcmd_write(s);

Same here?

> +        break;
> +
>      default:
>          if (size == 4) {
>              vtd_set_long(s, addr, val);
> @@ -3579,7 +3708,8 @@ static void vtd_init(IntelIOMMUState *s)
>              s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
>          } else if (!strcmp(s->sm_model, "scalable")) {
>              s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_PASID
> -                       | VTD_ECAP_FLTS;
> +                       | VTD_ECAP_FLTS | VTD_ECAP_VCS;
> +            s->vccap |= VTD_VCCAP_PAS;
>          } else {
>              printf("\n!!!!! Invalid sm_model config !!!!!\n"
>                  "Please config sm_model=[\"legacy\"|\"scalable\"]\n"
> @@ -3641,6 +3771,13 @@ static void vtd_init(IntelIOMMUState *s)
>       * Interrupt remapping registers.
>       */
>      vtd_define_quad(s, DMAR_IRTA_REG, 0, 0xfffffffffffff80fULL, 0);
> +
> +    /*
> +     * Virtual Command Definitions
> +     */
> +    vtd_define_quad(s, DMAR_VCCAP_REG, s->vccap, 0, 0);
> +    vtd_define_quad(s, DMAR_VCMD_REG, 0, 0xffffffffffffffffULL, 0);
> +    vtd_define_quad(s, DMAR_VCRSP_REG, 0, 0, 0);
>  }
>  
>  /* Should not reset address_spaces when reset because devices will still use
> diff --git a/hw/i386/intel_iommu_internal.h b/hw/i386/intel_iommu_internal.h
> index adae198..f5a2f0d 100644
> --- a/hw/i386/intel_iommu_internal.h
> +++ b/hw/i386/intel_iommu_internal.h
> @@ -85,6 +85,12 @@
>  #define DMAR_MTRRCAP_REG_HI     0x104
>  #define DMAR_MTRRDEF_REG        0x108 /* MTRR default type */
>  #define DMAR_MTRRDEF_REG_HI     0x10c
> +#define DMAR_VCCAP_REG          0xE00 /* Virtual Command Capability Register */
> +#define DMAR_VCCAP_REG_HI       0xE04
> +#define DMAR_VCMD_REG           0xE10 /* Virtual Command Register */
> +#define DMAR_VCMD_REG_HI        0xE14
> +#define DMAR_VCRSP_REG          0xE20 /* Virtual Command Reponse Register */
> +#define DMAR_VCRSP_REG_HI       0xE24
>  
>  /* IOTLB registers */
>  #define DMAR_IOTLB_REG_OFFSET   0xf0 /* Offset to the IOTLB registers */
> @@ -192,6 +198,7 @@
>  #define VTD_ECAP_SRS                (1ULL << 31)
>  #define VTD_ECAP_PASID              (1ULL << 40)
>  #define VTD_ECAP_SMTS               (1ULL << 43)
> +#define VTD_ECAP_VCS                (1ULL << 44)
>  #define VTD_ECAP_SLTS               (1ULL << 46)
>  #define VTD_ECAP_FLTS               (1ULL << 47)
>  
> @@ -314,6 +321,29 @@ typedef enum VTDFaultReason {
>  
>  #define VTD_CONTEXT_CACHE_GEN_MAX       0xffffffffUL
>  
> +/* VCCAP_REG */
> +#define VTD_VCCAP_PAS               (1UL << 0)
> +#define VTD_MIN_HPASID              200

Comment this value a bit?

> +#define VTD_MAX_HPASID              0xFFFFF
> +
> +/* Virtual Command Register */
> +enum {
> +     VTD_VCMD_NULL_CMD = 0,
> +     VTD_VCMD_ALLOC_PASID,

Shall we spell " = 1" explicitly if defined in spec?

> +     VTD_VCMD_FREE_PASID,

Same here.

Regards,

-- 
Peter Xu
