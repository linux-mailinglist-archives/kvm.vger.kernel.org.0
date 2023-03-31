Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE676D2172
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 15:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjCaNZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 09:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjCaNZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 09:25:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 996861D2CA
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680269084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+8R/ww5NOtTKrVVMJPiSWlsWr2SqxpSfsL4A0mGzuN8=;
        b=f3TOej65joYJnKO8kvSN83V4kQXyTw9O0kzc0Y23gonUHXICeH080TWqYGCo87er2BupM7
        uVfX9Yha2DgkexqBKW4rSs/XiojvOdIiwe5eIl2V8CY1h/PZVOzXZmWYUsNRbLVCKacXe/
        GoDm4nrJj5sYY8zkUAuB9b7Jg+t683Y=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-MjqRrLp9OPq8jsUnADTJeQ-1; Fri, 31 Mar 2023 09:24:43 -0400
X-MC-Unique: MjqRrLp9OPq8jsUnADTJeQ-1
Received: by mail-io1-f71.google.com with SMTP id i3-20020a6b5403000000b0075c881c4ddeso7637631iob.13
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680269082;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+8R/ww5NOtTKrVVMJPiSWlsWr2SqxpSfsL4A0mGzuN8=;
        b=fe+qZMbxpmmPZvP41uqwjcolhf4U8Ah8AHYSg56SavsljSrEJkTR8Vz5d4+kSKS+rx
         3mJEBGvdlxNAN2YxrLQT2HFltqzyDkr6iyh2ROYIpbRLVEDAjoSmApN9YUIoCEE40x9i
         VCrqGPzIFHg1gby1uaeL2Kg2ZvW2JxH08t9yQ1LhEkr2fCvwNrQ4sOb4hG5/TK8rRKV9
         mKR+HkcOZ0CGGUXmxazzcDULCjb73pbMaQpxCAUXSt6QNQ7r7n9hEIJZluLrGdbuBKlk
         GJteRCVHF3C4mf/y2hCo6WXg9OdQTwpz7TJA+BocRP1C2u91U2Na4bgAIyEGOzitgeGR
         1J2A==
X-Gm-Message-State: AAQBX9cAWM2CFyn1GX8SwzuJdvAAudCPLEjgE2gQvt61d/58gGm9vALy
        ecc7k9Jh8eG9Ea85Axcu6Y0+2Rb+so456ytTiNoyZ2KuBToIA1OmlTkMM7AND1bKOBoK9oIcbmZ
        V+9Pygh8t/nmh
X-Received: by 2002:a92:d991:0:b0:316:e39f:1212 with SMTP id r17-20020a92d991000000b00316e39f1212mr19103846iln.4.1680269082224;
        Fri, 31 Mar 2023 06:24:42 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZYiLus2ZjBk8rYsb82E2FTq2uUos7BcYFTyirHTyJsodUs0w1TIkUKf/w5l3uKHhzr7I1mnQ==
X-Received: by 2002:a92:d991:0:b0:316:e39f:1212 with SMTP id r17-20020a92d991000000b00316e39f1212mr19103815iln.4.1680269081970;
        Fri, 31 Mar 2023 06:24:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x11-20020a92300b000000b00325daf836fdsm617030ile.17.2023.03.31.06.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 06:24:41 -0700 (PDT)
Date:   Fri, 31 Mar 2023 07:24:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Jiang, Yanting" <yanting.jiang@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v2 00/10] Introduce new methods for verifying ownership
 in vfio PCI hot reset
Message-ID: <20230331072438.21c9243b.alex.williamson@redhat.com>
In-Reply-To: <MW4PR11MB6763D4F64127A5205D3B6567E88F9@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <MW4PR11MB6763D4F64127A5205D3B6567E88F9@MW4PR11MB6763.namprd11.prod.outlook.com>
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

On Fri, 31 Mar 2023 03:14:23 +0000
"Jiang, Yanting" <yanting.jiang@intel.com> wrote:

> > 
> > VFIO_DEVICE_PCI_HOT_RESET requires user to pass an array of group fds to
> > prove that it owns all devices affected by resetting the calling device. This series
> > introduces several extensions to allow the ownership check better aligned with
> > iommufd and coming vfio device cdev support.
> > 
> > First, resetting an unopened device is always safe given nobody is using it. So
> > relax the check to allow such devices not covered by group fd array. [1]
> > 
> > When iommufd is used we can simply verify that all affected devices are bound
> > to a same iommufd then no need for the user to provide extra fd information.
> > This is enabled by the user passing a zero-length fd array and moving forward
> > this should be the preferred way for hot reset. [2]
> > 
> > However the iommufd method has difficulty working with noiommu devices
> > since those devices don't have a valid iommufd, unless the noiommu device is in
> > a singleton dev_set hence no ownership check is required. [3]
> > 
> > For noiommu backward compatibility a 3rd method is introduced by allowing the
> > user to pass an array of device fds to prove ownership. [4]
> > 
> > As suggested by Jason [5], we have this series to introduce the above stuffs to
> > the vfio PCI hot reset. Per the dicussion in [6], this series also adds a new _INFO
> > ioctl to get hot reset scope for given device.
> >   
> Tested NIC passthrough on Intel platform.
> Result looks good hence, 
> Tested by: Jiang, Yanting <yanting.jiang@intel.com>

I'm not aware of any userspace that exercises this reset ioctl in cdev
mode.  Is this regression testing only?  Thanks,

Alex

