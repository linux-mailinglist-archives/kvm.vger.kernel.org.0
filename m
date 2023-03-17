Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20796BECBE
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 16:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjCQPRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 11:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjCQPRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 11:17:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D35399EC
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 08:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679066167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rao+xNWRizX0LhN/4wRd+0JAP8O4y7cKTfv6w4e7mjg=;
        b=Jm4S42/kbzBOuNOeiBAvMkCCgjY7U5hkgELWKioMy6BnKVRP6PbULVop/mWT1Wnyq0T+ti
        bZsmqlkItrQLFBr2S3+qCBfvz5OUS61UctA/QPOTzim98XAgmx5eNLZpkw3R8GDdg2pObk
        LN/pk/v34MMp597aCBlx5mZsuJg4CPo=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-VIzzCpp3MweKPXbOjWIF5Q-1; Fri, 17 Mar 2023 11:16:05 -0400
X-MC-Unique: VIzzCpp3MweKPXbOjWIF5Q-1
Received: by mail-io1-f70.google.com with SMTP id z6-20020a056602080600b007407df88db0so2655943iow.23
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 08:16:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679066161;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rao+xNWRizX0LhN/4wRd+0JAP8O4y7cKTfv6w4e7mjg=;
        b=3IFHNC+PGnK5TiN0CN3Hz+RQnYgqG+Hk/gXlniWYloSSPD2kxh+Wpr7IWpVGNLhJUc
         bJBInhI4cqF28O0s0q8rkyu8jqu1nWHOFAmxUkaUs/8TDdH+gMhhP4z7VxlIktgigdWd
         HsIlfl5acnLEZRRMCmGrzWlN7M+FQvBfetB0X5Szl6F+isgrV85OX7zr8/UFTgfjw1Az
         3HDwgjuqWMRcFyefxyxNeVR+0apVMXfCnNWZX/47MmcHAGuIrbJAVAA4MqecNpJtBPLx
         DHUtmMctccjGG2zH1FYrPiQyj2mFZ3E6KufE0ei8gPN8ryRXbXhDWIpVzvkTLMSKZANI
         KGTQ==
X-Gm-Message-State: AO0yUKXg4JBxeoBx/ghr2LtEAYTkxiD+B107LnC9pt3/Dtml/5CtXFH1
        gzfTxHDqoW1XXsT60+l7E0KFFp4nDeZfM7YXTHM5mH4fTG9zdZ5wfvNdWfFHKsNTPqVzQ4Z+x3u
        OWt7l46wfaKSx
X-Received: by 2002:a92:d6c4:0:b0:323:29e2:a19 with SMTP id z4-20020a92d6c4000000b0032329e20a19mr121701ilp.19.1679066161234;
        Fri, 17 Mar 2023 08:16:01 -0700 (PDT)
X-Google-Smtp-Source: AK7set80NGJKORot4gljugv8vYBR/BBkOhmUyaZ4ioD6GUgk2kD4aof7c53go0lOXTZ/o0x4VYZ9Cw==
X-Received: by 2002:a92:d6c4:0:b0:323:29e2:a19 with SMTP id z4-20020a92d6c4000000b0032329e20a19mr121668ilp.19.1679066160983;
        Fri, 17 Mar 2023 08:16:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i7-20020a05663815c700b00406147dad72sm761750jat.104.2023.03.17.08.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 08:16:00 -0700 (PDT)
Date:   Fri, 17 Mar 2023 09:15:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
Message-ID: <20230317091557.196638a6.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
        <20230308132903.465159-13-yi.l.liu@intel.com>
        <20230315165311.01f32bfe.alex.williamson@redhat.com>
        <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230316124532.30839a94.alex.williamson@redhat.com>
        <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230316182256.6659bbbd.alex.williamson@redhat.com>
        <BN9PR11MB5276D5A71E43EA4CDD1C960A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Mar 2023 00:57:23 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson
> > Sent: Friday, March 17, 2023 8:23 AM
> > 
> > On Thu, 16 Mar 2023 23:29:21 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > > From: Alex Williamson
> > > > Sent: Friday, March 17, 2023 2:46 AM
> > > >
> > > > On Wed, 15 Mar 2023 23:31:23 +0000
> > > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > > >  
> > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Sent: Thursday, March 16, 2023 6:53 AM
> > > > > > I'm afraid this proposal reduces or eliminates the handshake we have
> > > > > > with userspace between VFIO_DEVICE_GET_PCI_HOT_RESET_INFO  
> > and  
> > > > > > VFIO_DEVICE_PCI_HOT_RESET, which could promote userspace to  
> > ignore  
> > > > the  
> > > > > > _INFO ioctl altogether, resulting in drivers that don't understand the
> > > > > > scope of the reset.  Is it worth it?  What do we really gain?  
> > > > >
> > > > > Jason raised the concern whether GET_PCI_HOT_RESET_INFO is actually
> > > > > useful today.
> > > > >
> > > > > It's an interface on opened device. So the tiny difference is whether the
> > > > > user knows the device is resettable when calling GET_INFO or later  
> > when  
> > > > > actually calling PCI_HOT_RESET.  
> > > >
> > > > No, GET_PCI_HOT_RESET_INFO conveys not only whether a  
> > PCI_HOT_RESET  
> > > > can
> > > > be performed, but equally important the scope of the reset, ie. which
> > > > devices are affected by the reset.  If we de-emphasize the INFO
> > > > portion, then this easily gets confused as just a variant of
> > > > VFIO_DEVICE_RESET, which is explicitly a device-level cscope reset.  In
> > > > fact, I'd say the interface is not only trying to validate that the
> > > > user has sufficient privileges for the reset, but that they explicitly
> > > > acknowledge the scope of the reset.
> > > >  
> > >
> > > IMHO the usefulness of scope is if it's discoverable by the management
> > > stack which then can try to assign devices with affected reset to a same
> > > user.  
> > 
> > Disagree, the user needs to know the scope of reset.  Take for instance
> > two function of a device configured onto separate buses within a VM.
> > The VMM needs to know that a hot-reset of one will reset the other.
> > That's not obvious to the VMM without some understanding of PCI/e
> > topology and analysis of the host system.  The info ioctl simplifies
> > that discovery for the VMM and the handshake of passing the affected
> > groups makes sure that the info ioctl remains relevant.  
> 
> If that is the intended usage then I don't see why this proposal will
> promote userspace to ignore the _INFO ioctl. It should be always
> queried no matter how the reset ioctl itself is designed. The motivation
> of calling _INFO is not from the reset ioctl asking for an array of fds.

The VFIO_DEVICE_PCI_HOT_RESET ioctl requires a set of group (or cdev)
fds that encompass the set of affected devices reported by the
VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl, so I don't agree with the
last sentence above.

This proposal seems to be based on some confusion about the difference
between VFIO_DEVICE_RESET and VFIO_DEVICE_PCI_HOT_RESET, and therefore
IMO, proliferates that confusion by making the scope argument optional,
which I see as a key difference.  This therefore makes the behavior of
the ioctl less intuitive, easier to get wrong, and I expect we'll see
users unitentionally resetting devices beyond the desired scope if the
group/device fd array is allowed to be empty.  Thanks,

Alex

