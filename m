Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69136DC7F7
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 16:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjDJOmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 10:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjDJOmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 10:42:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF30B30DA
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 07:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681137684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dONRC9HtKL/GspXEC12wUQrG7qQwFgtFDXnmhXkq9zg=;
        b=Iai7KxdvuTn74YlYepiafdbIlhrpeQmb7mcHZOWYjr9Y2Dsj+IH6EhD3HUIyEjZKtfC4yg
        qFqj3qFDQ3Nlf6Ae62kaZN/a/Dzf9f/GK2LPod8y64GN/qiUvr0zQAyUJpPhqHynUmf+6v
        lFPKaYz2ihemLj1WIKM5YjqIdKKMswY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-d3YCR6aPNDuQzEe2ciUYMQ-1; Mon, 10 Apr 2023 10:41:23 -0400
X-MC-Unique: d3YCR6aPNDuQzEe2ciUYMQ-1
Received: by mail-il1-f197.google.com with SMTP id a3-20020a92c543000000b0032651795968so18484908ilj.19
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 07:41:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681137683; x=1683729683;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dONRC9HtKL/GspXEC12wUQrG7qQwFgtFDXnmhXkq9zg=;
        b=V/QjWF5C/6HOblOjCaT0xfRt7QMgSvBCWL3qQLAbLpyehZIXUeq0cgbNhTZgqRK0qP
         /hJbPrqIYvrYbsoEWrZVu/28G+mxM6MoHXy89QwRSsbScyE+9t6rDYJji8EsfygLJQQZ
         7zyjwt54Apr/xF48xksEpdBG00ujGwLcBcRJ64qJ0BWXeK40zlxir+sYVUQcw2RkdT7W
         5g08pZdxok4sNkSLMpF6PqHr01uxVa5C5y2SZ/oKJ40EVscL+YvDsQf/hCW6hM/slCPp
         s0GBGPOaUvWd/yt7UiRdw9V5OiW2vv2ym5uKb+NcozyUlZiWWL1y1ylYNTPIW1ck4dh5
         obmQ==
X-Gm-Message-State: AAQBX9eDm+Bi0k1TLozX8ZOo8oYfY/G3J8EOtq1nOd/fNdQEF8mTcjdf
        nynct4ig4tjYQaiPQK1QA5N6iUBBrlp6tSwX4JaFc85QPCZrcElw8W3v1CXJz4q2J2W+yH1ORU5
        1OEz1K1x6nbje
X-Received: by 2002:a05:6602:25d5:b0:74d:771:6ed5 with SMTP id d21-20020a05660225d500b0074d07716ed5mr6833600iop.21.1681137683016;
        Mon, 10 Apr 2023 07:41:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350blVL+ZATHmuWAsdL6ecOUcA15qMfGx9qDZU2dPurXS6S+nHpcIDUqvh4MmE9dSGa4ICBuUjA==
X-Received: by 2002:a05:6602:25d5:b0:74d:771:6ed5 with SMTP id d21-20020a05660225d500b0074d07716ed5mr6833593iop.21.1681137682766;
        Mon, 10 Apr 2023 07:41:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m17-20020a056638261100b003eafd76dc3fsm3331755jat.23.2023.04.10.07.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 07:41:22 -0700 (PDT)
Date:   Mon, 10 Apr 2023 08:41:15 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230410084115.3c6604f1.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529BE00767D7ABC1136BF7CC3959@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230403090151.4cb2158c.alex.williamson@redhat.com>
        <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407060335.7babfeb8.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407075155.3ad4c804.alex.williamson@redhat.com>
        <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407091401.1c847419.alex.williamson@redhat.com>
        <DS0PR11MB7529A9D103F88381F84CF390C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407150721.395eabc4.alex.williamson@redhat.com>
        <SN7PR11MB75407463181A0D7A4F21D546C3979@SN7PR11MB7540.namprd11.prod.outlook.com>
        <20230408082018.04dcd1e3.alex.williamson@redhat.com>
        <81a3e148-89de-e399-fefa-0785dac75f85@intel.com>
        <20230409072951.629af3a7.alex.williamson@redhat.com>
        <DS0PR11MB7529BE00767D7ABC1136BF7CC3959@DS0PR11MB7529.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Apr 2023 08:48:54 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Sunday, April 9, 2023 9:30 PM  
> [...]
> > > yeah, needs to move the iommu group creation back to vfio_main.c. This
> > > would be a prerequisite for [1]
> > >
> > > [1] https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com/
> > >
> > > I'll also try out your suggestion to add a capability like below and link
> > > it in the vfio_device_info cap chain.
> > >
> > > #define VFIO_DEVICE_INFO_CAP_PCI_BDF          5
> > >
> > > struct vfio_device_info_cap_pci_bdf {
> > >          struct vfio_info_cap_header header;
> > >          __u32   group_id;
> > >          __u16   segment;
> > >          __u8    bus;
> > >          __u8    devfn; /* Use PCI_SLOT/PCI_FUNC */
> > > };
> > >  
> > 
> > Group-id and bdf should be separate capabilities, all device should
> > report a group-id capability and only PCI devices a bdf capability.  
> 
> ok. Since this is to support the device fd passing usage, so we need to
> let all the vfio device drivers report group-id capability. is it? So may
> have a below helper in vfio_main.c. How about the sample drivers?
> seems not necessary for them. right?

The more common we can make it, the better, but if it ends up that the
individual drivers need to initialize the capability then it would
probably be limited to those driver with a need to expose the group.
Sample drivers for the purpose of illustrating the interface and of
course anything based on vfio-pci-core which exposes hot-reset.  Thanks

Alex

