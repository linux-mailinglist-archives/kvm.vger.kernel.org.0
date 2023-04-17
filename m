Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC376E5161
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 22:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjDQUHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 16:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjDQUHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 16:07:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877014692
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 13:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681762007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uJkreuNWxZEE44fygt5zWJA+zq6jhPLH5gKQqPjNWJQ=;
        b=Xla5ZkPsZPKIc6iceJ5yI579cJ/vPfYTS7feRDTt2FNYgmE4F92GfPV67YucZXjE0ao60z
        YQWmSaq2o/1TLchHDaHrCtzESaygjqpQus7Q4aCnzWAfVklcdGrq6vHu6AqCkRmncK5/w5
        muYxHPeYsrCiyXMKxzMFWqJ6EQ0Jbjk=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-O08avEEHMYqiq8gJ3lu0Qg-1; Mon, 17 Apr 2023 16:06:46 -0400
X-MC-Unique: O08avEEHMYqiq8gJ3lu0Qg-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-329614db215so15125095ab.2
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 13:06:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681762005; x=1684354005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uJkreuNWxZEE44fygt5zWJA+zq6jhPLH5gKQqPjNWJQ=;
        b=RpSMK/iZY58EzwwbewLbu0IFclhgRXkoOkh0ymclQO5daA5yHt24WqrwbvU9s6P5gc
         Nu8GrswVS41MVsfyc1Co3xU/nPgE0Y2ocIAZ/J26NFewJafZpIcIm1YMOKxNpixLAZKl
         +wof3JF6m2V9FfHWs2QAOACgRU+UDNHzPLnRgCPK7pTVghdLXXVQi5AVgOcXMNRmA8f3
         z5J3btCtEWyZ5F98UhM0SKl5RIYi/qmZQN1lvlnx0HvyIImSiop5uAyC39d/Z51xWMS8
         xV3fXSX+SSnbhfo/rT/nW3k/wyAt2EyUKqfZ+jmmwJlNj6rQ/ZBqNi5IwPdjkbeeEPHA
         UY9A==
X-Gm-Message-State: AAQBX9dC0HMGVAlGSEgy6qddtg5j+Z9DzNc49pxgjBT22B4dQbafUjBl
        YeN1a0+fzGIfhn+TT5xob9l/rV13s5W+fpDwcjm7Fy98/NauDZIyDK4JXntA5qJ4I5jm2w2MEkI
        SgUumGAcryX5X
X-Received: by 2002:a92:c9c3:0:b0:32a:ea4e:97d1 with SMTP id k3-20020a92c9c3000000b0032aea4e97d1mr5286321ilq.10.1681762005501;
        Mon, 17 Apr 2023 13:06:45 -0700 (PDT)
X-Google-Smtp-Source: AKy350YnqbcCParzLbuNdjYNdpgBYhVf9e7CqwAl3G3qqrikIx+WLx6VM5MZjUBX5I9Y6yBJY1EJeg==
X-Received: by 2002:a92:c9c3:0:b0:32a:ea4e:97d1 with SMTP id k3-20020a92c9c3000000b0032aea4e97d1mr5286281ilq.10.1681762005206;
        Mon, 17 Apr 2023 13:06:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k14-20020a056e02134e00b003291bea8c7fsm3361811ilr.81.2023.04.17.13.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 13:06:44 -0700 (PDT)
Date:   Mon, 17 Apr 2023 14:06:42 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230417140642.650fc165.alex.williamson@redhat.com>
In-Reply-To: <ZD2erN3nKbnyqei9@nvidia.com>
References: <20230412105045.79adc83d.alex.williamson@redhat.com>
        <ZDcPTTPlni/Mi6p3@nvidia.com>
        <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230414111043.40c15dde.alex.williamson@redhat.com>
        <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230417130140.1b68082e.alex.williamson@redhat.com>
        <ZD2erN3nKbnyqei9@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 17 Apr 2023 16:31:56 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Apr 17, 2023 at 01:01:40PM -0600, Alex Williamson wrote:
> > Yes, it's not trivial, but Jason is now proposing that we consider
> > mixing groups, cdevs, and multiple iommufd_ctxs as invalid.  I think
> > this means that regardless of which device calls INFO, there's only one
> > answer (assuming same set of devices opened, all cdev, all within same
> > iommufd_ctx).  Based on what I explained about my understanding of INFO2
> > and Jason agreed to, I think the output would be:
> > 
> > flags: NOT_RESETABLE | DEV_ID
> > {
> >   { valid devA-id,  devA-BDF },
> >   { valid devC-id,  devC-BDF },
> >   { valid devD-id,  devD-BDF },
> >   { invalid dev-id, devE-BDF },
> > }
> > 
> > Here devB gets dropped because the kernel understands that devB is
> > unopened, affected, and owned.  It's therefore not a blocker for
> > hot-reset.  
> 
> I don't think we want to drop anything because it makes the API
> ill suited for the debugging purpose.
> 
> devb should be returned with an invalid dev_id if I understand your
> example. Maybe it should return with -1 as the dev_id instead of 0, to
> make the debugging a bit better.
> 
> Userspace should look at only NOT_RESETTABLE to determine if it
> proceeds or not, and it should use the valid dev_id list to iterate
> over the devices it has open to do the config stuff.

If an affected device is owned, not opened, and not interfering with
the reset, what is it adding to the API to report it for debugging
purposes?  I'm afraid this leads into expanding "invalid dev-id" into an
errno or bitmap of error conditions that the user needs to parse.

> > OTOH, devE is unopened, affected, and un-owned, and we
> > previously agreed against the opportunistic un-opened/un-owned loophole.  
> 
> NOT_RESETABLE should be returned in this case, yes.
> 
> If we want to enable userspace to use the loophole it should be an
> additional flag. RESETABLE_FOR_NOW or something

Ugh, please no.  It's always a volatile result, but a volatile result
that relies on device state outside the scope or control of the user is
not even worthwhile imo.  Thanks,

Alex

