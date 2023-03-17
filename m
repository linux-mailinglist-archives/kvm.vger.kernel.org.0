Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0076C6BDD8A
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 01:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCQAXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 20:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCQAXu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 20:23:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E7F6EBA2
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 17:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679012581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XSyAHP79zbLTHByO1UMWkwG5VhqMvodcFmqqMUfSNXU=;
        b=G5iAY90fvDh3VZrLRrZDMlpBWYaAHZtVo9BYOHAk3hCzxfL97jt4niJ/Xg1wpgYrKE3DYu
        VU/dj5pMr65G4JCUBy8jkTJeqQmt/0U5XgaP5l0Ca87bKYncW58F0ueeln28aQilXD6FLO
        YEEBYTy4Pef/W3x0+uVlvnL5M08YvAc=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-dFOgjMZqMgq8zhlvxa5_EA-1; Thu, 16 Mar 2023 20:23:00 -0400
X-MC-Unique: dFOgjMZqMgq8zhlvxa5_EA-1
Received: by mail-io1-f71.google.com with SMTP id n42-20020a056602342a00b0074cde755b99so1757742ioz.16
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 17:23:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679012579;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XSyAHP79zbLTHByO1UMWkwG5VhqMvodcFmqqMUfSNXU=;
        b=hyHqT//tTeX7U6h5YqsCt/y+xOvXavIVcxp/7gmEI91vtGFqNb0UqWwzmKNIAx6Jqf
         7BTvU9AgcorCN3+RaCbElrwG7BBcFAbQXxuVmLC4vIn/+z7cY/WI2jY2vavAD6Z5lPhC
         wuUxyZaSTNM+v042VUXwItN1whXSlH2s+O0O7637KqNGpxgkbdFEmOz0kfcwRgCTyIII
         tQE8mdRt7Iflyikqraw0188CXfbsf9bspbrSiHv/ACf9wRmOT/Nev2rfOqeL48eNOqSD
         rOXCb+QehnCVKFfqPQL6upLuiwBP/6OV8fI6pRBOjMyjic3LCjrlhrdP+07gIGN/VCGq
         1w4g==
X-Gm-Message-State: AO0yUKVwi1yaP1dCfpBR7VTgjnfzPgRjTZY9741+AaBtto63+JLXTYZa
        MWt7uyG08hFZaVU0bQKWnyUEYQZsUADzgjde4yJ/CCTERB2Dx+IwTbHkynXEgPAcErJYdV8rzNW
        r2SqJh5+ZzGiU
X-Received: by 2002:a05:6e02:1151:b0:317:eef2:f5cc with SMTP id o17-20020a056e02115100b00317eef2f5ccmr8697406ill.10.1679012579505;
        Thu, 16 Mar 2023 17:22:59 -0700 (PDT)
X-Google-Smtp-Source: AK7set/iT+8IeRFfmQPOt1YsJVElfStX87uq3MIp8yFcWKSg+oPhoPMe5gX/E9CYwiObV9svKZZ9jA==
X-Received: by 2002:a05:6e02:1151:b0:317:eef2:f5cc with SMTP id o17-20020a056e02115100b00317eef2f5ccmr8697382ill.10.1679012579260;
        Thu, 16 Mar 2023 17:22:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q16-20020a0566380d1000b003c2b76fcdf2sm230584jaj.52.2023.03.16.17.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 17:22:58 -0700 (PDT)
Date:   Thu, 16 Mar 2023 18:22:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
Message-ID: <20230316182256.6659bbbd.alex.williamson@redhat.com>
In-Reply-To: <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
        <20230308132903.465159-13-yi.l.liu@intel.com>
        <20230315165311.01f32bfe.alex.williamson@redhat.com>
        <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230316124532.30839a94.alex.williamson@redhat.com>
        <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On Thu, 16 Mar 2023 23:29:21 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson
> > Sent: Friday, March 17, 2023 2:46 AM
> > 
> > On Wed, 15 Mar 2023 23:31:23 +0000
> > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Thursday, March 16, 2023 6:53 AM
> > > > I'm afraid this proposal reduces or eliminates the handshake we have
> > > > with userspace between VFIO_DEVICE_GET_PCI_HOT_RESET_INFO and
> > > > VFIO_DEVICE_PCI_HOT_RESET, which could promote userspace to ignore  
> > the  
> > > > _INFO ioctl altogether, resulting in drivers that don't understand the
> > > > scope of the reset.  Is it worth it?  What do we really gain?  
> > >
> > > Jason raised the concern whether GET_PCI_HOT_RESET_INFO is actually
> > > useful today.
> > >
> > > It's an interface on opened device. So the tiny difference is whether the
> > > user knows the device is resettable when calling GET_INFO or later when
> > > actually calling PCI_HOT_RESET.  
> > 
> > No, GET_PCI_HOT_RESET_INFO conveys not only whether a PCI_HOT_RESET
> > can
> > be performed, but equally important the scope of the reset, ie. which
> > devices are affected by the reset.  If we de-emphasize the INFO
> > portion, then this easily gets confused as just a variant of
> > VFIO_DEVICE_RESET, which is explicitly a device-level cscope reset.  In
> > fact, I'd say the interface is not only trying to validate that the
> > user has sufficient privileges for the reset, but that they explicitly
> > acknowledge the scope of the reset.
> >   
> 
> IMHO the usefulness of scope is if it's discoverable by the management
> stack which then can try to assign devices with affected reset to a same
> user.

Disagree, the user needs to know the scope of reset.  Take for instance
two function of a device configured onto separate buses within a VM.
The VMM needs to know that a hot-reset of one will reset the other.
That's not obvious to the VMM without some understanding of PCI/e
topology and analysis of the host system.  The info ioctl simplifies
that discovery for the VMM and the handshake of passing the affected
groups makes sure that the info ioctl remains relevant.

OTOH, I really haven't seen any evidence that the null-array concept
provides significant simplification for userspace, especially without
compromising the user's understanding of the scope of the provided
reset.  Thanks,

Alex

