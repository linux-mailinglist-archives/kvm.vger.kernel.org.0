Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968266C4AC7
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 13:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjCVMhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 08:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjCVMhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 08:37:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D02552F65
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 05:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679488583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZEVZq83wbVrBX6YIpe57knDSAk+ax7b8c1a6ITeMnnE=;
        b=UawpxgmV2rbZhpnXEH+mMAM9lBdGX8bHhC/yUKgRwR/Q/D4CqpkjFD2HIXPlNRPAAwNgDR
        iW/NdZVumrBRDgjFGsuR6eXC5PiAjkQdwyfquu0o7nyHJpfVhApmrqwtQtJj0ZsIesMgqA
        KfdYicN6f7nfJ5VcRt0Q/HWjNG2846c=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-fYNXPQ_4MPSqQHf6SMiQOQ-1; Wed, 22 Mar 2023 08:36:22 -0400
X-MC-Unique: fYNXPQ_4MPSqQHf6SMiQOQ-1
Received: by mail-il1-f199.google.com with SMTP id n9-20020a056e02100900b00325c9240af7so107521ilj.10
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 05:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679488581;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZEVZq83wbVrBX6YIpe57knDSAk+ax7b8c1a6ITeMnnE=;
        b=Nh5Bsvpk+BAMqHM/mE/iES/g46rcGHvVXpDKlr4uB2LK5sUM76+CwIG5qMx+0j4Y0C
         W0qHoWAhtKg0zJDoodB0ipbQ31xoGAvcSzeGkya15Aj0t5WK9TY2f0zOw3NQQ+68s8Jt
         9mt95L5ffZVGvvrSpXd5DMxWGXaXMXUpHOaU0QNcKOiSEA2a78qs8QpuJarLcMk+VvxW
         TJM2GFo/816y2sMu60Fhmm/W4GTGooilLMDuNcVFUYnWK9EgObpelzbwd4BJrX23FP/o
         sHVPuDgPuoD3bJbnaH2pmHGDWShI39xCyBgi1wJQLYenyv2FhepPGniQNKjtXg/Q9MbE
         n7+Q==
X-Gm-Message-State: AO0yUKUekPLtowPW6qgPEjzXb2F2ZrOV8b1c1ZJFr5kzptGsqla/akZx
        7HEwBETuh2puYk+kjmOWFGEm+u4xCN4fUEvpl1jBZjA0vkpYLsKy277yX2XTfi1RQWxf7iFfiG/
        Pp71FAqNuowzi
X-Received: by 2002:a6b:5b15:0:b0:73d:eb4b:345e with SMTP id v21-20020a6b5b15000000b0073deb4b345emr4250333ioh.6.1679488581506;
        Wed, 22 Mar 2023 05:36:21 -0700 (PDT)
X-Google-Smtp-Source: AK7set+s1bVDw/httDHazd/bVKfPTyFl2eUE5yP3x7lZIEV1uxid79azuha2BxjfoT9XqWVJ/KVk0w==
X-Received: by 2002:a6b:5b15:0:b0:73d:eb4b:345e with SMTP id v21-20020a6b5b15000000b0073deb4b345emr4250309ioh.6.1679488581235;
        Wed, 22 Mar 2023 05:36:21 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f29-20020a02241d000000b003a69bd12c6dsm4820604jaa.58.2023.03.22.05.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 05:36:20 -0700 (PDT)
Date:   Wed, 22 Mar 2023 06:36:14 -0600
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
Message-ID: <20230322063614.571699e4.alex.williamson@redhat.com>
In-Reply-To: <ZBr0JD7nPBM6Zr1z@nvidia.com>
References: <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230317091557.196638a6.alex.williamson@redhat.com>
        <ZBiUiEC8Xj9sOphr@nvidia.com>
        <20230320165217.5b1019a4.alex.williamson@redhat.com>
        <ZBjum1wQ1L2AIfhB@nvidia.com>
        <20230321143122.632f7e63.alex.williamson@redhat.com>
        <ZBoYgNq60eDpV9Un@nvidia.com>
        <20230321150112.1c482380.alex.williamson@redhat.com>
        <ZBottXxBlOsXmnmX@nvidia.com>
        <20230321164737.62b45132.alex.williamson@redhat.com>
        <ZBr0JD7nPBM6Zr1z@nvidia.com>
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

On Wed, 22 Mar 2023 09:27:16 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 21, 2023 at 04:47:37PM -0600, Alex Williamson wrote:
> > On Tue, 21 Mar 2023 19:20:37 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Tue, Mar 21, 2023 at 03:01:12PM -0600, Alex Williamson wrote:
> > >   
> > > > > Though it would be nice if qemu didn't need two implementations so Yi
> > > > > I'd rather see a new info in this series as well and qemu can just
> > > > > consistently use dev_id and never bdf in iommufd mode.    
> > > > 
> > > > We also need to consider how libvirt determines if QEMU has the kernel
> > > > support it needs to pass file descriptors.  It'd be a lot cleaner if
> > > > this aligned with the introduction of vfio cdevs.    
> > > 
> > > Yes, that would be much better if it was one package.
> > > 
> > > But this is starting to grow and we have so many threads that need to
> > > progress blocked on this cdev enablement :(
> > > 
> > > Could we go forward with the cdev main patches and kconfig it to
> > > experimental or something while the rest of the parts are completed
> > > and tested through qemu? ie move the vfio-pci reset enablment to after
> > > the cdev patches?  
> > 
> > We need to be able to guarantee that there cannot be any significant
> > builds of the kernel with vfio cdev support if our intention is to stage
> > it for libvirt.  We don't have a global EXPERIMENTAL config option any
> > more.  Adding new code under BROKEN seems wrong.  Fedora ships with
> > STAGING enabled.  A sternly worded Kconfig entry is toothless.  What is
> > the proposed mechanism to make this not look like a big uncompiled code
> > dump?  Thanks,  
> 
> I would suggest a sternly worded kconfig and STAGING.
> 
> This isn't such a big issue, we are trying to say that a future
> released qemu is not required to work on older kernels with a STAGING
> kconfig mark.
> 
> IOW we are saying that qemu release X.0 with production iommufd
> requires kernel version > x.y and just lightly reflecting this into
> the kconfig.
> 
> qemu should simply not support iommufd if it finds itself on a old
> kernel.

Inferring features based on kernel versions doesn't work in a world
where downstreams backport features to older kernels.  Thanks,

Alex

