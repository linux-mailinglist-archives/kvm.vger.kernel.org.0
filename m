Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B20F72E5FA
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241142AbjFMOkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242958AbjFMOkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:40:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F051732
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686667179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+BOQ4Tqi5BD1aEHFPyVALHW8m6Hj0sn3lu1rbLX0rs=;
        b=X0Evc9Fx5zynGM24HuInzv2wiSML25jFAw6FBE0SClo1Cgun59FMW3qOv+gZKCYeeNdrXD
        YWJilTwGP1cgWFibtImclLBN+/C8WxGG8UAFZvjujvlHBAmXINvQD/NtkLkLYHL3dhAc0d
        7S5saawf5/JefeJ/eEEUCyaWODFRXn8=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-R03JERBvOo2vJX_-npnj6A-1; Tue, 13 Jun 2023 10:39:37 -0400
X-MC-Unique: R03JERBvOo2vJX_-npnj6A-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3406661e649so9225515ab.1
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:39:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686667177; x=1689259177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S+BOQ4Tqi5BD1aEHFPyVALHW8m6Hj0sn3lu1rbLX0rs=;
        b=kmjJoi1V9DshLlvEOY0LmxHQjuZc/8hmQmx7jblfTA/JcXSZQdq/2H4X0xmeoy3pO9
         vVpuNm7KHxyoDP+zl1+7nPcJisizbZvoyj2zE5ATNxvLdy61y28AiEhZCDoNnVKwxhb3
         d4HLbPHilEFvPy1jXUeJyPL9s2H4McuaHH+uyEPIQfPoouW3G6VnZhwKDHIJJCNE5BWX
         zuYteCLa+UUz+HX4Dv2j/MjM0Db4ovFXVEKgLW0EzuARo9kBYs9OfqDnEyRffnp/33hi
         t+lcquwlyXwC47plv5YH4F7qly33ln11SOh/hoTxauwNEWY5flyiPyz13xSH4JOufrhP
         wLFw==
X-Gm-Message-State: AC+VfDzt2iG8AGhJGQBxqM17YrWinGTLD94n4BmbqEOyrLDGpMqJEB62
        HvWs34+HmmqN5TM240IBjgZ25EX7jQe9G3V+tfuiBfhPIW5QmK3/AIjnhTGh/8DNVlnYJilZlLf
        qpq91lUsKVebX
X-Received: by 2002:a92:d590:0:b0:33d:72c0:1b4 with SMTP id a16-20020a92d590000000b0033d72c001b4mr10835250iln.10.1686667176907;
        Tue, 13 Jun 2023 07:39:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6lQI1p26NkHPKfSda2Sz1nKZGRDYL+HesOxakQURNBK5DmwF/l7Xzxa63g4qD55bYHlO7/sw==
X-Received: by 2002:a92:d590:0:b0:33d:72c0:1b4 with SMTP id a16-20020a92d590000000b0033d72c001b4mr10835233iln.10.1686667176686;
        Tue, 13 Jun 2023 07:39:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g20-20020a0566380c5400b0041f5a0b7fa1sm3495024jal.144.2023.06.13.07.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 07:39:36 -0700 (PDT)
Date:   Tue, 13 Jun 2023 08:39:35 -0600
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20230613083935.753430ed.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529F0A41AA58AE37BCF8458C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-19-yi.l.liu@intel.com>
        <20230612162726.16f58ea4.alex.williamson@redhat.com>
        <DS0PR11MB752985BA514AFF36CA3A2785C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230613081808.049b9e6d.alex.williamson@redhat.com>
        <DS0PR11MB7529F0A41AA58AE37BCF8458C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jun 2023 14:28:43 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, June 13, 2023 10:18 PM  
> 
> > > > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > > > index 83cc5dc28b7a..e80a8ac86e46 100644
> > > > > --- a/include/linux/vfio.h
> > > > > +++ b/include/linux/vfio.h
> > > > > @@ -66,6 +66,7 @@ struct vfio_device {
> > > > >  	struct iommufd_device *iommufd_device;
> > > > >  	bool iommufd_attached;
> > > > >  #endif
> > > > > +	bool cdev_opened:1;  
> > > >
> > > > Perhaps a more strongly defined data type here as well and roll
> > > > iommufd_attached into the same bit field scheme.  
> > >
> > > Ok, then needs to make iommufd_attached always defined.  
> > 
> > That does not follow.  Thanks,  
> 
> Well, I meant the iommufd_attached now is defined only when
> CONFIG_IOMMUFD is enabled. To toll it with cdev_opened, needs
> to change this.

Understood, but I don't think it's true.  If defined we use one more
bit of the bit field, which is a consideration when we approach filling
it, but we're not using bit-shift operations to address these bits, so
why does it matter if one has compiler conditional usage?  Thanks,

Alex

