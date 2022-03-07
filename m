Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B054D07FD
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 20:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245167AbiCGTxm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 14:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbiCGTxj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 14:53:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 696E72CCB2
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 11:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646682762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iFbyRAhrzPJ35m4rXo3BdXpPkOXNFqEyv1VvtxCidZQ=;
        b=jFLimqnENX2TR+7bzNt1xhS0ld1VUPt32LUGqYqczLeNjdaICeGze6rUwK38LTwJjyBgfT
        ay21zHfYZnVIeQfOv6Zk/iCBlLlcfGyUPYN4vt+oJYLrcERlCN100+MDYLuIq8iadzq8nx
        uyIP0fG67YbHIWzNc+ZGZMfji4kzPbQ=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-YjethO8APsu43NxurEu_6w-1; Mon, 07 Mar 2022 14:52:41 -0500
X-MC-Unique: YjethO8APsu43NxurEu_6w-1
Received: by mail-oi1-f199.google.com with SMTP id g5-20020a0568080dc500b002d73eb5c37fso10327856oic.16
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 11:52:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iFbyRAhrzPJ35m4rXo3BdXpPkOXNFqEyv1VvtxCidZQ=;
        b=dyuY7v9ase7/EmCGA9iRZhYY4WPOy/D6RpzugHM/Z3pM4hHduhcTQfu9s6w6nqAZ1g
         MpS1yKU72hZavcF09ibFAWD2BvnBXoMymPJEhkT/lXtJMIXw+gEj3KrrB15k5prepzBi
         7w0xwGiuvFj8p/60zb4IiXCxEfCglAOmTyx4lBG4fNAy1MltaHUIHNPFcwV238sSb5oZ
         vuOPHzr9QhTMewoRJB99iTntc7sxeUJTQAvEP/Hr24sZJctEcACPyK5P7erz3epETAyF
         U/wlmdgqOZ8hFK1DTxpwLoUFlN1jNC7nijCn/fgD0+H5MH3b8BgffpwrbOguxAPcU99B
         iNTg==
X-Gm-Message-State: AOAM533YQonzH2j1OiCD083dpG6x+eOUI6rhzVa6a3S8OFpJz+wYops6
        Mse54GXmP8lGZUFAkW/L+2nL4Kpb8SMV7aZfbqnxzIldtHVl9wAcHt2oSmwnrbEaUqn5zA/uqg8
        Gjn255xOmLw5W
X-Received: by 2002:a05:6870:a986:b0:da:b3f:3277 with SMTP id ep6-20020a056870a98600b000da0b3f3277mr342130oab.295.1646682761027;
        Mon, 07 Mar 2022 11:52:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0o5c3OjTqpzOiX0FaElSIgrmfr2mM6c5nUGHrH+xd+UeH8aVo4Q4lHgUzzZO76/LqpgApLg==
X-Received: by 2002:a05:6870:a986:b0:da:b3f:3277 with SMTP id ep6-20020a056870a98600b000da0b3f3277mr342120oab.295.1646682760849;
        Mon, 07 Mar 2022 11:52:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u21-20020a056870951500b000d9b9ac69cdsm5373410oal.1.2022.03.07.11.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 11:52:40 -0800 (PST)
Date:   Mon, 7 Mar 2022 12:52:39 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220307125239.7261c97d.alex.williamson@redhat.com>
In-Reply-To: <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
        <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
        <20220304205720.GE219866@nvidia.com>
        <20220307120513.74743f17.alex.williamson@redhat.com>
        <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Mar 2022 19:29:06 +0000
Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: 07 March 2022 19:05
> > To: Jason Gunthorpe <jgg@nvidia.com>
> > Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> > kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org; cohuck@redhat.com;
> > mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> > <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> > <prime.zeng@hisilicon.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> > Subject: Re: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
> > migration
> > 
> > On Fri, 4 Mar 2022 16:57:20 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Thu, Mar 03, 2022 at 11:01:30PM +0000, Shameer Kolothum wrote:  
> > > > From: Longfang Liu <liulongfang@huawei.com>
> > > >
> > > > VMs assigned with HiSilicon ACC VF devices can now perform live  
> > migration  
> > > > if the VF devices are bind to the hisi_acc_vfio_pci driver.
> > > >
> > > > Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> > > > Signed-off-by: Shameer Kolothum  
> > <shameerali.kolothum.thodi@huawei.com>  
> > > > ---
> > > >  drivers/vfio/pci/hisilicon/Kconfig            |    7 +
> > > >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 1078 ++++++++++++++++-
> > > >  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  114 ++
> > > >  3 files changed, 1181 insertions(+), 18 deletions(-)
> > > >  create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> > > >
> > > > diff --git a/drivers/vfio/pci/hisilicon/Kconfig  
> > b/drivers/vfio/pci/hisilicon/Kconfig  
> > > > index dc723bad05c2..2a68d39f339f 100644
> > > > --- a/drivers/vfio/pci/hisilicon/Kconfig
> > > > +++ b/drivers/vfio/pci/hisilicon/Kconfig
> > > > @@ -3,6 +3,13 @@ config HISI_ACC_VFIO_PCI
> > > >  	tristate "VFIO PCI support for HiSilicon ACC devices"
> > > >  	depends on ARM64 || (COMPILE_TEST && 64BIT)
> > > >  	depends on VFIO_PCI_CORE
> > > > +	depends on PCI && PCI_MSI  
> > >
> > > PCI is already in the depends from the 2nd line in
> > > drivers/vfio/pci/Kconfig, but it is harmless
> > >  
> > > > +	depends on UACCE || UACCE=n
> > > > +	depends on ACPI  
> > >
> > > Scratching my head a bit on why we have these  
> > 
> > Same curiosity from me, each of the CRYPTO_DEV_HISI_* options selected
> > also depend on these so they seem redundant.  
> 
> Yes, they are redundant now since we have added CRYPTO_DEV_HISI_ drivers
> as "depends" now. I will remove that.
>  
> > I think we still require acks from Bjorn and Zaibo for select patches
> > in this series.  
> 
> I checked with Ziabo. He moved projects and is no longer looking into crypto stuff.
> Wangzhou and LiuLongfang now take care of this. Received acks from Wangzhou
> already and I will request Longfang to provide his. Hope that's ok.

Maybe a good time to have them update MAINTAINERS as well.  Thanks,

Alex

