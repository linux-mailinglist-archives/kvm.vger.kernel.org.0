Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467836CC208
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 16:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbjC1O0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 10:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjC1O02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 10:26:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B06A260
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 07:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680013541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2++2bLilwQ5MSfsDHwIkCG9/5Hx9PPAC52PhhrFnL/U=;
        b=Kfyqo9Ej4WwwYX1VodPY9I93BVJcqDhGvbyI8f8eQWQy7UtJefEPSzGzsOvLyFaMspLGSp
        +OhlZYbcdtHBDi6JrdF/om2UVpoxMPrXstq86tuuo9Sxbzd8e5NRXUakwAM5ztwLS6DNxt
        Xy9oh2OY8oGo3I1os8nX3zfxD7/t3a0=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-HPQwUSMBPN-TrPd01Yssmw-1; Tue, 28 Mar 2023 10:25:39 -0400
X-MC-Unique: HPQwUSMBPN-TrPd01Yssmw-1
Received: by mail-io1-f71.google.com with SMTP id c83-20020a6bb356000000b00758333e1ddfso7695569iof.14
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 07:25:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680013539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2++2bLilwQ5MSfsDHwIkCG9/5Hx9PPAC52PhhrFnL/U=;
        b=hSboQGwAWsSNHU+DqSbeZteUX0oE1+WSWoNcwPDlBd+uSGNYND3l7yZ339csbIFVLK
         T2X97uYtBv0nwSE8FeKcChlvGFzTQrfOEM4JxOLusdY6GuM0gw8Ll/Fpw6jHhKVQeSwb
         oRIvnjrYQLBfbB+rFUsJV5eh58GCqn8DPGNRZ5P7rKRxIzEG/RK4/xIt3U+9IsaMZT/K
         505PgaKjXx8soAf3fVZc5urK+rLg3OSqZs7QNTRgmrNwcgixr5xFV+FqnhO5lb+b2Fdx
         Z6tadiWmJdiEtLbiP5YPH75jSn8d4S6LpqHS0/muX+X6laRW/ApfSjLyVErTyHb2tNnE
         mlZQ==
X-Gm-Message-State: AAQBX9eoO17bbV+1kk7TZqAQGZj7ltF7zIvgsCxgHTa7A7iCjp6kXBj6
        rL+LkwVnVCFna+O3e9rInOkXSmdrmBG2GxgN0xcnyjfGnSmRQq29n7KPpJ2dKt43gvC0oG926d3
        kAXpIiaT2qoUc
X-Received: by 2002:a5e:a912:0:b0:759:8f29:2e81 with SMTP id c18-20020a5ea912000000b007598f292e81mr11418387iod.18.1680013539084;
        Tue, 28 Mar 2023 07:25:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZNhCzGUUWjFJZ/tLMMjP/R+0PL+tTwRVzFU+D9wh0XaE/b4kJwrSeWZYFILcywbWp9ECxP3g==
X-Received: by 2002:a5e:a912:0:b0:759:8f29:2e81 with SMTP id c18-20020a5ea912000000b007598f292e81mr11418363iod.18.1680013538832;
        Tue, 28 Mar 2023 07:25:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p19-20020a056638217300b003c4eb5cb22csm9381348jak.134.2023.03.28.07.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 07:25:38 -0700 (PDT)
Date:   Tue, 28 Mar 2023 08:25:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <20230328082536.5400da67.alex.williamson@redhat.com>
In-Reply-To: <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
        <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Tue, 28 Mar 2023 06:19:06 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Tuesday, March 28, 2023 11:32 AM
> >   
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Tuesday, March 28, 2023 3:26 AM
> > >
> > > Additionally, VFIO_DEVICE_GET_PCI_HOT_RESET_INFO has a flags arg that
> > > isn't used, why do we need a new ioctl vs defining
> > > VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID.  
> > 
> > Sure. I can follow this suggestion. BTW. I have a doubt here. This new flag
> > is set by user. What if in the future kernel has new extensions and needs
> > to report something new to the user and add new flags to tell user? Such
> > flag is set by kernel. Then the flags field may have two kinds of flags (some
> > set by user while some set by kernel). Will it mess up the flags space?
> >   
> 
> flags in a GET_INFO ioctl is for output.
> 
> if user needs to use flags as input to select different type of info then it should
> be split into multiple GET_INFO cmds.

I don't know that that's actually a rule, however we don't currently
test flags is zero for input, so in this case I think we are stuck with
it only being for output.

Alternatively, should VFIO_DEVICE_GET_PCI_HOT_RESET_INFO automatically
return the dev_id variant of the output and set a flag to indicate this
is the case when called on a device fd opened as a cdev?  Thanks,

Alex

