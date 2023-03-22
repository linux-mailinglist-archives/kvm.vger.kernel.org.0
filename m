Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913BD6C4A59
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 13:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjCVMYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 08:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjCVMYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 08:24:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560051B2C0
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 05:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679487814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lWxjY/lbB315S8Voovgb8sq9ON3lgCJYfSAXwg6j0gU=;
        b=G7j42k3GEJBePElKRkLQ9sF33zKv6vYbVuBUb7jJI20NWxdE5goU5YEQqn2+Vk9HX//Bau
        s8m9qu97SigyX5Qwhfyq4S2EbheKe0efRArzSTFvcqftr9HWJbIgY6nA6F2t+7Dagcge28
        HrVvwXf5wp+Zia4PFRpQKNpiDJIdeGY=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-S3uSHDqpO8SLYK2jMkcs2g-1; Wed, 22 Mar 2023 08:23:29 -0400
X-MC-Unique: S3uSHDqpO8SLYK2jMkcs2g-1
Received: by mail-io1-f72.google.com with SMTP id h136-20020a6bb78e000000b00758b105cdd3so837433iof.23
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 05:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679487809;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lWxjY/lbB315S8Voovgb8sq9ON3lgCJYfSAXwg6j0gU=;
        b=R/8ipfe4QlwSkd0e0lQXQayg9YXUHktjKhX3W1GWT9dF+ALFG91iDULV4Y66qhoJpq
         9bWIyvUMQ9tNh6gvYxPzS7olQvKYnQtbVIzYFfVQBEyV6p0RU8QMAjdNknlpED9GXQQx
         DUB8Q1PUG0oUh+r1MWDEsQ3YU+bbqB0TUn4FoAXApJmjTgLeXmYReHGPGkb6deAI6FGH
         /cwgSVsaipCvlh9Uv3OEyWWp8SfgG4Dry2ORUNmHQqkkz+hNSj0zZOjuTYftTmd3Vail
         uRXuLwTJJzSklG2I7sIQDyKSt16wD9y17ltCN3+zmDztk1q5eC9THrmL8qWRAZMckUuB
         EYjg==
X-Gm-Message-State: AO0yUKVnai4oaiGylu7/jn/EIAsqmLf43sKNbNNeWBNEUs3rPtHSkv6q
        cBdLvU8NUDlxfsYGP196RF+DEczGNrm0EnvGL3JdgdAbKc/c57TtVQQFPKHY4iorpZsn62/QiQp
        OlLKEt33S1CbA
X-Received: by 2002:a92:c647:0:b0:316:e6e7:c124 with SMTP id 7-20020a92c647000000b00316e6e7c124mr4351308ill.15.1679487809120;
        Wed, 22 Mar 2023 05:23:29 -0700 (PDT)
X-Google-Smtp-Source: AK7set8IQazyOy8MSGW6Fp0jsbHol/yxfq5hFcwO+LPli/AV1KbdKr/2K6g6/4ie3Y5AyD77NDQShA==
X-Received: by 2002:a92:c647:0:b0:316:e6e7:c124 with SMTP id 7-20020a92c647000000b00316e6e7c124mr4351287ill.15.1679487808774;
        Wed, 22 Mar 2023 05:23:28 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p36-20020a056638192400b004062f11d2d9sm4889802jal.130.2023.03.22.05.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 05:23:28 -0700 (PDT)
Date:   Wed, 22 Mar 2023 06:23:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
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
Message-ID: <20230322062325.2b4667af.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB752996D3DCB2F0CE6728F4B8C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
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
        <20230321164737.62b45132.alex.williamson@redhat.com>
        <DS0PR11MB752996D3DCB2F0CE6728F4B8C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
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

On Wed, 22 Mar 2023 04:42:16 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, March 22, 2023 6:48 AM
> > 
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
> Just out of curious, is the BDF mapping gap only for cdev or it also
> exists in the traditional group path?

The group path doesn't support passing file descriptors, getting access
to the device files requires a full container configuration, which
implies significant policy decisions in libvirt.  Even if groups were
passed, QEMU would need to know the device name, ie. BDF in string
format, to get the device from the group.

> IMHO, if it is only a gap for cdev, maybe
> we can use CONFIG_VFIO_DEVICE_CDEV to stage it. This kconfig is N by
> default. I think it won't change until one day the whole ecosystem is
> updated.

See the "toothless" comment above, disabling vfio cdev support by
default because we don't have feature parity in reset support does not
provide any guarantees to libvirt that it can effectively take
advantage of passing cdev fds to QEMU.  Thanks,

Alex

