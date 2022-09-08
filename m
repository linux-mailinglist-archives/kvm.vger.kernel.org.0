Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663D05B1D38
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 14:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiIHMhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 08:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiIHMhP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 08:37:15 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3786699B58
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 05:37:14 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id d1so13094799qvs.0
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 05:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=WcekcDNFeJzxZPSod6l4pgL2wFziikSEFQBuSo6O52M=;
        b=KKyDjjUP/2p/6f7MjEn3kMEeJ9Uy23+vKM3cRtzBVt8VoKvtO19GZa9khWTOIgKXfU
         i8Wg2YqI7xe6VOUzHA1blR13LADAZdvcQEwpXYTDVgQlqE6jyPfQLsPIW6IFt8PC1Twz
         x1/2IkKExw1n1GVsGI2IcwHf6pcYkgxICIHCs5zME9TCi20awY/+j2rjTx1gBo2XawTZ
         hkPlifBFFpN7SWmfPgwIEuuHCjIW6iQRdS0k/Y45tBs1sBIxtTNCbnlbGq2Q0vhyPQMt
         KUHxfIEXp877QAvYoOIiX2SlcsbptrwrQuaci6jQ2mMpkHWg65mjQ+2UlqkyzZ97Lyu0
         1xuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=WcekcDNFeJzxZPSod6l4pgL2wFziikSEFQBuSo6O52M=;
        b=mH04pBULJkzCP9JKEuXxNIgyBzYpSW73UogOOGi/KnkNjACsCnV844nWnyGDsL7dnR
         YvFfa09TRrIUKOqMFTBndxZwYvRSZ0TgaYJAV2E9YOLxFGWVaVxdTSISQcA8F92pu/0J
         GxhIDOmHEHhfT5//dEss/Eh1y6hfmD7TNe18wnJN0iRiW/D4Xy7LDr/iA08ib3yvfswU
         cB9UuIxTfITTr9Wdt1vh7C/8ln5QjUI994J6vNDH1hS8PHWKmddnXhYdvbmRm+xlUrph
         fCNB5e3+9mgC4/6suOB4/5IQy01oKkbUMUhljaPyi0hl5BTAziNeK+ACLc5PGzN3GVn4
         IuCA==
X-Gm-Message-State: ACgBeo1DscY5mQbEqZ6Q272LObX8XnWPosF6mGJCfU8R4SduL60kOc8G
        mcO4nrUGHXAdNxs3ivICj27uZA==
X-Google-Smtp-Source: AA6agR4iyYT8//K0u4eC6uIKjTIJa5MHHn5Yfbf3X3qv/3RmHXDYo2nTKmbY5oFt97DH+rTTDZyaNQ==
X-Received: by 2002:a05:6214:c66:b0:499:2f1a:1cec with SMTP id t6-20020a0562140c6600b004992f1a1cecmr6905971qvj.93.1662640633361;
        Thu, 08 Sep 2022 05:37:13 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id br7-20020a05622a1e0700b00344f91f6fe0sm14363098qtb.67.2022.09.08.05.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 05:37:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oWGmJ-0090gF-SU;
        Thu, 08 Sep 2022 09:37:07 -0300
Date:   Thu, 8 Sep 2022 09:37:07 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 15/15] vfio: Add struct device to vfio_device
Message-ID: <Yxnh87ZIS2JwvN7D@ziepe.ca>
References: <20220901143747.32858-1-kevin.tian@intel.com>
 <20220901143747.32858-16-kevin.tian@intel.com>
 <50d82b01-86a3-e6a3-06f7-7f98e60131eb@redhat.com>
 <546463b8-54fa-2071-6a9a-e4087eb8bb2c@intel.com>
 <4c9350cd-c2ce-dc84-9a29-210907d2a2a2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c9350cd-c2ce-dc84-9a29-210907d2a2a2@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 11:39:07AM +0200, Eric Auger wrote:

> >> I am not totally clear about remaining 'struct device *dev;' in
> >> vfio_device struct. I see it used in some places. Is it supposed to
> >> disappear at some point?
> >
> > no, Eric. *dev will not disappear, it stores the dev pointet passed in by
> > caller of vfio_init_device().
> 
> yeah I see but you have device->device.parent = device->dev;

IIRC we have a number of these redundancies now, often the drivers
store another copy of the dev too.

A significant use of dev is for printing things, what should be done
here is to create a subsystem wide vfio_warn/etc that takes in the
vfio_device, and then print properly from there. Now that we have a
struct device all the prints should also include the VFIO struct
device name, and then the PCI device perhaps in brackets.

Jason
