Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23BE73598D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 11:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfFEJS4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 5 Jun 2019 05:18:56 -0400
Received: from mga17.intel.com ([192.55.52.151]:23736 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbfFEJSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 05:18:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 02:18:55 -0700
X-ExtLoop1: 1
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga008.fm.intel.com with ESMTP; 05 Jun 2019 02:18:55 -0700
Received: from fmsmsx155.amr.corp.intel.com (10.18.116.71) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 5 Jun 2019 02:18:54 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 FMSMSX155.amr.corp.intel.com (10.18.116.71) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 5 Jun 2019 02:18:54 -0700
Received: from shsmsx101.ccr.corp.intel.com ([169.254.1.10]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.134]) with mapi id 14.03.0415.000;
 Wed, 5 Jun 2019 17:18:52 +0800
From:   "Zhang, Tina" <tina.zhang@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "Lv, Zhiyuan" <zhiyuan.lv@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [RFC PATCH v2 1/3] vfio: Use capability chains to handle device
 specific irq
Thread-Topic: [RFC PATCH v2 1/3] vfio: Use capability chains to handle
 device specific irq
Thread-Index: AQHVGrx1sbtkzcdtCkGKiqXjrLufOqaL7AoAgADZGxA=
Date:   Wed, 5 Jun 2019 09:18:52 +0000
Message-ID: <237F54289DF84E4997F34151298ABEBC87646B5C@SHSMSX101.ccr.corp.intel.com>
References: <20190604095534.10337-1-tina.zhang@intel.com>
 <20190604095534.10337-2-tina.zhang@intel.com>
 <20190605040446.GW9684@zhen-hp.sh.intel.com>
In-Reply-To: <20190605040446.GW9684@zhen-hp.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNGRmZTQ5OGItMTlmNi00ZDk5LTgxMzMtYWE4NDdhYzYxMTc2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidmRQNDY1WE5uandSRmZ5SFI3RTlpUHFrQlVsdG5JN2NjY0c0OUJHMmlNTjhhNGN4aXV4bnBBNkMrdUp3VGwxRiJ9
x-ctpclassification: CTP_NT
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Zhenyu Wang [mailto:zhenyuw@linux.intel.com]
> Sent: Wednesday, June 5, 2019 12:05 PM
> To: Zhang, Tina <tina.zhang@intel.com>
> Cc: intel-gvt-dev@lists.freedesktop.org; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; kraxel@redhat.com; zhenyuw@linux.intel.com; Lv,
> Zhiyuan <zhiyuan.lv@intel.com>; Wang, Zhi A <zhi.a.wang@intel.com>; Tian,
> Kevin <kevin.tian@intel.com>; Yuan, Hang <hang.yuan@intel.com>;
> alex.williamson@redhat.com
> Subject: Re: [RFC PATCH v2 1/3] vfio: Use capability chains to handle device
> specific irq
> 
> On 2019.06.04 17:55:32 +0800, Tina Zhang wrote:
> > Caps the number of irqs with fixed indexes and uses capability chains
> > to chain device specific irqs.
> >
> > VFIO vGPU leverages this mechanism to trigger primary plane and cursor
> > plane page flip event to the user space.
> >
> > Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> > ---
> >  include/uapi/linux/vfio.h | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 02bb7ad6e986..9b5e25937c7d 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -444,11 +444,31 @@ struct vfio_irq_info {
> >  #define VFIO_IRQ_INFO_MASKABLE		(1 << 1)
> >  #define VFIO_IRQ_INFO_AUTOMASKED	(1 << 2)
> >  #define VFIO_IRQ_INFO_NORESIZE		(1 << 3)
> > +#define VFIO_IRQ_INFO_FLAG_CAPS		(1 << 4) /* Info
> supports caps */
> >  	__u32	index;		/* IRQ index */
> > +	__u32	cap_offset;	/* Offset within info struct of first cap */
> >  	__u32	count;		/* Number of IRQs within this index */
> 
> This would break ABI for get irq info. I think irq cap chain can just follow
> vfio_irq_info.
> 
> >  };
> >  #define VFIO_DEVICE_GET_IRQ_INFO	_IO(VFIO_TYPE, VFIO_BASE +
> 9)
> >
> > +/*
> > + * The irq type capability allows irqs unique to a specific device or
> > + * class of devices to be exposed.
> > + *
> > + * The structures below define version 1 of this capability.
> > + */
> > +#define VFIO_IRQ_INFO_CAP_TYPE      3
> > +
> > +struct vfio_irq_info_cap_type {
> > +	struct vfio_info_cap_header header;
> > +	__u32 type;     /* global per bus driver */
> > +	__u32 subtype;  /* type specific */
> > +};
> > +
> > +#define VFIO_IRQ_TYPE_GFX				(1)
> > +#define VFIO_IRQ_SUBTYPE_GFX_PRI_PLANE_FLIP		(1)
> > +#define VFIO_IRQ_SUBTYPE_GFX_CUR_PLANE_FLIP		(2)
> > +
> 
> Really need to split for different planes? I'd like a
> VFIO_IRQ_SUBTYPE_GFX_DISPLAY_EVENT
> so user space can probe change for all.
User space can choose to user different handlers according to the specific event. For example, user space might not want to handle every cursor event due to performance consideration. Besides, it can reduce the probe times, as we don't need to probe twice to make sure if both cursor plane and primary plane have been updated.
Thanks.

BR,
Tina

> 
> >  /**
> >   * VFIO_DEVICE_SET_IRQS - _IOW(VFIO_TYPE, VFIO_BASE + 10, struct
> vfio_irq_set)
> >   *
> > @@ -550,7 +570,8 @@ enum {
> >  	VFIO_PCI_MSIX_IRQ_INDEX,
> >  	VFIO_PCI_ERR_IRQ_INDEX,
> >  	VFIO_PCI_REQ_IRQ_INDEX,
> > -	VFIO_PCI_NUM_IRQS
> > +	VFIO_PCI_NUM_IRQS = 5	/* Fixed user ABI, IRQ indexes >=5
> use   */
> > +				/* device specific cap to define content */
> >  };
> >
> >  /*
> > --
> > 2.17.1
> >
> 
> --
> Open Source Technology Center, Intel ltd.
> 
> $gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827
