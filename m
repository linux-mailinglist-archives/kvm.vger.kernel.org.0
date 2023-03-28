Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903956CCA73
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 21:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjC1TKk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 15:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjC1TKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 15:10:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B6230D3
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680030595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TyWlyMYo12Ph4alZhZ7htkhRhM6u2cJ70JNCkvZ77kk=;
        b=U2YMS5ZEhWz9wOpd7s+bV5HRYZFEvlnQuX2KhZQ7liLXA6nRiaENnVKu7nF+RW5/oW+qNP
        wSfxI90EQp2WgvEMbnPzNGkCUQ7tIlWXRnxp/icB9KhP121uKmcxhWenL1L62fTHw137oT
        MuucjIqMIrWJXR1arpCg1lQNcY4favc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-h1cf0rKFPxqVX3878f7RgQ-1; Tue, 28 Mar 2023 15:09:53 -0400
X-MC-Unique: h1cf0rKFPxqVX3878f7RgQ-1
Received: by mail-io1-f72.google.com with SMTP id w4-20020a5d9604000000b0074d326b26bcso8238901iol.9
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 12:09:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680030593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TyWlyMYo12Ph4alZhZ7htkhRhM6u2cJ70JNCkvZ77kk=;
        b=wh7GMKFNn9n+D4yxlflXt9N5ezUY27Ff1VocF1mFe7sWrxhNvAYszJI/SkavbTZxYI
         pf5aB9EB+vV8ak7zTMIpvzrRRmYppBBI6F1tLtZcZqPzNPEDcF+X+EoEEouVyQwB9dyV
         9/3sPjigU7jhxRz9wNatIKS0+7xdNH1uJV+lSnCAs+s3Xoi64vnQ4jfaXCrrqCrC70yE
         jCgb7/VR26kXNY6OdCPNdqi07X+N66hKUc1TrC0MV54rWor1nBQXX6WoayaBnDIO7dyf
         PYwxwrxw1mSPjkj1eLpkEOCGAsr/VxwHxAxqw+aoaqDDu4L1H8lRcZrAhMmVDWukmwi3
         Plhw==
X-Gm-Message-State: AAQBX9eoWOBffLli2IW1sVYLZOFUP5ZGVRBLBRiUT7cx+a5Hq/A2HCF/
        6nBjAk0MiO7BRqpQu5+EQylp+MI/bjU+qCammJjYEgrtG4gKegmrZz53BgHxOLNeIxedkkGcl7k
        COsDsU6Za+7Up
X-Received: by 2002:a5e:a807:0:b0:759:95a5:327a with SMTP id c7-20020a5ea807000000b0075995a5327amr9970719ioa.11.1680030592760;
        Tue, 28 Mar 2023 12:09:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350adFeqCticunFGKIu5P/YegCKYF+iyr4sSWve2FbSdhytCLKP/q4euprZAtfzr1TdiDa6uHKw==
X-Received: by 2002:a5e:a807:0:b0:759:95a5:327a with SMTP id c7-20020a5ea807000000b0075995a5327amr9970693ioa.11.1680030592532;
        Tue, 28 Mar 2023 12:09:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g9-20020a025b09000000b00374fa5b600csm9992351jab.0.2023.03.28.12.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 12:09:52 -0700 (PDT)
Date:   Tue, 28 Mar 2023 13:09:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <20230328130949.225bc680.alex.williamson@redhat.com>
In-Reply-To: <ZCMV4zMhpVJJCIKN@nvidia.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
        <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
        <20230328082536.5400da67.alex.williamson@redhat.com>
        <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328084616.3361a293.alex.williamson@redhat.com>
        <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328091801.13de042a.alex.williamson@redhat.com>
        <ZCMV4zMhpVJJCIKN@nvidia.com>
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

On Tue, 28 Mar 2023 13:29:23 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Mar 28, 2023 at 09:18:01AM -0600, Alex Williamson wrote:
> 
> > It's a niche case, but I think it needs to be allowed.  We'd still
> > report the bdf for those devices, but make use of the invalid/null
> > dev-id.  
> 
> IDK, it makes the whole implementation much more complicated. Instead
> of just copying the current dev_set to the output and calling
> vfio_pci_dev_set_resettable() we need to do something more complex..
> 
> Keeping the current ioctl as-is means this IOCTL can be used to do any
> debugging by getting the actual BDF list.
> 
> It means we can make the a new ioctl simple and just return the dev_id
> array without these edge complications. I don't think merging two
> different ioctls is helping make things simple..

OTOH, we already have an ioctl that essentially "does the right thing",
we just want to swap out one return field for another.  So which is
more complicated, adding another ioctl that does not quite the same
thing but still needing to maintain the old ioctl for detailed
information, or making the old ioctl bi-modal to return the appropriate
information for the type of device used to access it?

> It seems like it does what qemu wants: call the new IOCTL, if it
> fails, call the old IOCTL and print out the BDF list to help debug and
> then exit.

Userspace is already dealing with a variable length array for the
return value, why would it ever want to repeat that process to get
debugging info.  Besides, wouldn't QEMU prefer the similarity of making
the same call for groups and cdev and simply keying on the data type of
one field?

> On success use the data in the new ioctl to generate the machine
> configuration to pass the reset grouping into the VM.
> 
> When reset actually comes in just trigger it.

"Just trigger it" is the same in either case.  It seems bold to play
the complexity argument when we already have a function that does 90%
the correct thing where we can share much of the implementation and
userspace code without duplicating, but still relying on a legacy
interface for debugging.  Thanks,

Alex

