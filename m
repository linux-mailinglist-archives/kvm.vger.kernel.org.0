Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96CF26C3DD6
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 23:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjCUWsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 18:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCUWs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 18:48:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BF358C0B
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679438861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pkqj6f0mmvcRZY6WGcLhSYjSkEneOC6n3/87lujTtak=;
        b=E/FN7OSole7Ev8l7nlXxXfiOv+0BvbSYc0EIFq1PIkn6bKG/NGYVO7AVFL+JDEM9fHaOEF
        Qt+aI69yOjwrKhArt1HQf/3oVL8wb3E4KrPaS2GNccCm3guPPAuKP7BWE7ifAf41pquv1D
        ekDDyxBxu+wibL72FNvulsJWoDrsJkU=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-YvRNAAzONk2elgjJSGxU6w-1; Tue, 21 Mar 2023 18:47:40 -0400
X-MC-Unique: YvRNAAzONk2elgjJSGxU6w-1
Received: by mail-io1-f71.google.com with SMTP id s1-20020a6bd301000000b0073e7646594aso8517020iob.8
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 15:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679438859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pkqj6f0mmvcRZY6WGcLhSYjSkEneOC6n3/87lujTtak=;
        b=Y5VKq0Bzg2L/fetWHbgrJ7/aGmWgB2/iXBepBwvHRgnO+ZnJg1O9/ddHTwrijdvvA3
         uVMRy4rpbu944RYz3+SiXZI7C50zurjO7rGXdWgH1zXYJQyHNhBv+1zqztI+oFswrmsN
         FxTbdaEJDA6p7hzm3AfPL4xbdb8kLTViAqqeYaUIsSs/+AN1gYlNqgOLj/TV2h9MKYh1
         axzbCM/3gZ3bbnBl4e5z0YYpWwf2MSCPUGfn9OQxICd0AVX4NZzu37zBAc/cE0mXXZm6
         PupoyPS9raz9B5C8ESHrkDDH+eSxPWsmseUn1jvWn70O8TJz8fMtx+w0pWlTKI0Pi5GO
         fa1w==
X-Gm-Message-State: AO0yUKUkHlOHFiUVE+nyxnQRYb2zvCVY+lZ6QfBnFW9sGHW1ubcS+pVk
        YuTicM9abmnIJZyAdVJJRahcc3oVBX5YY6XmfOojM93YFdxJJNcwjpr8ZnIii1hboneD/CfThau
        IgSBZ7TLjO/iU
X-Received: by 2002:a6b:db09:0:b0:74c:bc54:def6 with SMTP id t9-20020a6bdb09000000b0074cbc54def6mr3056441ioc.16.1679438859338;
        Tue, 21 Mar 2023 15:47:39 -0700 (PDT)
X-Google-Smtp-Source: AK7set9EbNNXSPjEUSnoMvgIPdEGf1CXd6ABSfzKBINcdwi6xMSz3jsAv4ymlWXyfvMVdfEnqs2RsA==
X-Received: by 2002:a6b:db09:0:b0:74c:bc54:def6 with SMTP id t9-20020a6bdb09000000b0074cbc54def6mr3056419ioc.16.1679438859071;
        Tue, 21 Mar 2023 15:47:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y16-20020a027310000000b004061d6abcd1sm4452110jab.162.2023.03.21.15.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 15:47:38 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:47:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array
 in VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <20230321164737.62b45132.alex.williamson@redhat.com>
In-Reply-To: <ZBottXxBlOsXmnmX@nvidia.com>
References: <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230316182256.6659bbbd.alex.williamson@redhat.com>
        <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230317091557.196638a6.alex.williamson@redhat.com>
        <ZBiUiEC8Xj9sOphr@nvidia.com>
        <20230320165217.5b1019a4.alex.williamson@redhat.com>
        <ZBjum1wQ1L2AIfhB@nvidia.com>
        <20230321143122.632f7e63.alex.williamson@redhat.com>
        <ZBoYgNq60eDpV9Un@nvidia.com>
        <20230321150112.1c482380.alex.williamson@redhat.com>
        <ZBottXxBlOsXmnmX@nvidia.com>
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

On Tue, 21 Mar 2023 19:20:37 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 21, 2023 at 03:01:12PM -0600, Alex Williamson wrote:
> 
> > > Though it would be nice if qemu didn't need two implementations so Yi
> > > I'd rather see a new info in this series as well and qemu can just
> > > consistently use dev_id and never bdf in iommufd mode.  
> > 
> > We also need to consider how libvirt determines if QEMU has the kernel
> > support it needs to pass file descriptors.  It'd be a lot cleaner if
> > this aligned with the introduction of vfio cdevs.  
> 
> Yes, that would be much better if it was one package.
> 
> But this is starting to grow and we have so many threads that need to
> progress blocked on this cdev enablement :(
> 
> Could we go forward with the cdev main patches and kconfig it to
> experimental or something while the rest of the parts are completed
> and tested through qemu? ie move the vfio-pci reset enablment to after
> the cdev patches?

We need to be able to guarantee that there cannot be any significant
builds of the kernel with vfio cdev support if our intention is to stage
it for libvirt.  We don't have a global EXPERIMENTAL config option any
more.  Adding new code under BROKEN seems wrong.  Fedora ships with
STAGING enabled.  A sternly worded Kconfig entry is toothless.  What is
the proposed mechanism to make this not look like a big uncompiled code
dump?  Thanks,

Alex

