Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFE96D12D0
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbjC3XGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjC3XGY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:06:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B701FF1D
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 16:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680217535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TMatgO6BH6GC06VsPyDFmO7jcdjVEhbN0H0T7ElgUC8=;
        b=VIm4K6Y4Hq8o/1n7jQlGeEclrWTZEunqbGYNIaQnvg5067/nctbdKzZv4UYhqIGsqXLI5m
        6OolLnCQkl93nbRZ04JlegCiy+tjHbagYgh5jZB340LZ4jSVPwwOZxkaPA9fky97zY3lw4
        6Eb84RrFIPXNC2CfhnzUXi/FQTjGka4=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-z1O1dQk6MYuIqUYPcEAclg-1; Thu, 30 Mar 2023 19:05:34 -0400
X-MC-Unique: z1O1dQk6MYuIqUYPcEAclg-1
Received: by mail-io1-f69.google.com with SMTP id i3-20020a6b5403000000b0075c881c4ddeso6647089iob.13
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 16:05:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680217533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TMatgO6BH6GC06VsPyDFmO7jcdjVEhbN0H0T7ElgUC8=;
        b=qPUqmBj798lJ+cFO8BYDJVQVzaZvFV3ct623vsI5gIjBsX/LRNB1R1vkAPHniydTCC
         TMidwhLhFhXwNfzON/pB0M/7SLiHsT0SRBuDiaJ1ftM3RJ0OI9s+fDeMpLuRKe2d67Os
         OKHYHOIiHajMO8nduLq9U+NgDQuBINmrjKrbxB87u5SspJhy9SEFo2m0WmfdO7pae+Yn
         stMFCBOGOJHH01eUHG1zIDC27sSVMWR7t+h5u3ZX7jiuyu+RLeZvfCFIvdzEGoePhoAh
         2SSoj0AbVL0ZiGth+/zd60IqmFclK7w7Zym6hV3/+rFXLpsKKlwaKkxp+QwUtz+D62dX
         645w==
X-Gm-Message-State: AO0yUKV6lxgUjBnI78PoYqJfyN1MBwkKFUUjmE5HjrsYGI8x6Hh4mgiP
        MxvUpJ6zqhh8J0bkGeo4i87+2ClCFiJiM6hjys/jilVZGu5sjQ6aQMG4war8WtehlJZx/0lf6+y
        7n0rZpcCVZZay
X-Received: by 2002:a5e:d606:0:b0:750:6c44:3454 with SMTP id w6-20020a5ed606000000b007506c443454mr18191676iom.12.1680217533758;
        Thu, 30 Mar 2023 16:05:33 -0700 (PDT)
X-Google-Smtp-Source: AK7set8/aJ7IpuNBdq7qV6Sm6acZzS/OWNOFTVCSNmhDCnhCPHu0seHdmhZKi6cwPTOuCTVmWl7Umw==
X-Received: by 2002:a5e:d606:0:b0:750:6c44:3454 with SMTP id w6-20020a5ed606000000b007506c443454mr18191668iom.12.1680217533461;
        Thu, 30 Mar 2023 16:05:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n2-20020a02a182000000b003b778515852sm213023jah.168.2023.03.30.16.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 16:05:32 -0700 (PDT)
Date:   Thu, 30 Mar 2023 17:05:31 -0600
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
Message-ID: <20230330170531.3b66c05a.alex.williamson@redhat.com>
In-Reply-To: <ZCYQ5zhmjg/xQmTZ@nvidia.com>
References: <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328084616.3361a293.alex.williamson@redhat.com>
        <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328091801.13de042a.alex.williamson@redhat.com>
        <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328100027.3b843b91.alex.williamson@redhat.com>
        <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20230329094944.50abde4e.alex.williamson@redhat.com>
        <DS0PR11MB75298AF9A9ACAEBDD5D445ECC38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <ZCYQ5zhmjg/xQmTZ@nvidia.com>
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

On Thu, 30 Mar 2023 19:44:55 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Mar 30, 2023 at 12:48:03PM +0000, Liu, Yi L wrote:
> > +	/*
> > +	 * If dev_id is needed, fill in the dev_id field, otherwise
> > +	 * fill in group_id.
> > +	 */
> > +	if (fill->require_devid) {
> > +		/*
> > +		 * Report the devices that are opened as cdev and have
> > +		 * the same iommufd with the fill->iommufd.  Otherwise,
> > +		 * just fill in an IOMMUFD_INVALID_ID.
> > +		 */
> > +		vdev = vfio_pci_find_device_in_devset(dev_set, pdev);
> > +		if (vdev && !vfio_device_cdev_opened(vdev) &&
> > +		    fill->iommufd == vfio_iommufd_physical_ictx(vdev))
> > +			vfio_iommufd_physical_devid(vdev, &fill->devices[fill->cur].dev_id);
> > +		fill->devices[fill->cur].dev_id = IOMMUFD_INVALID_ID;  
> 
> This needs an else?
> 
> I suggest to check for VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID on input
> as well. I know the old kernels don't enforce this but at least we
> could start enforcing it going forward so that the group path would
> reject it to catch userspace bugs.
> 
> May as well fix it up to fully validate the flags

Is this under the guise of "if nobody complains it's ok, otherwise
revert" plan?  We report dev-id based on the nature of the device, not
the provided flags, so I'm not sure I follow how this protects the group
path, unless we've failed to clear the output flags on that path with
this change.  Thanks,

Alex


