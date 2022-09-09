Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BC45B433A
	for <lists+kvm@lfdr.de>; Sat, 10 Sep 2022 01:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiIIXxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 19:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiIIXxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 19:53:15 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF4211B013
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 16:53:14 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id d1so2479141qvs.0
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 16:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=I7AGr5kxvD7L8BGImkaiYYIcWYTyuHALX3Uwn5SFGes=;
        b=dABIJEmzczJA9TeUEwB/vqlw1on+BNexewwg9hQHdtE1Pf+5Eir7ZuRo5Ra74CBI2Y
         mcA+UH3eeO9aAd0QqE0L7SFCTjpphtpc0ELtMYBKyyRw1a/HWDzHyUcOactrzkgR2sl3
         L0nOmencTRW6FHXiEoY9iZZ+c/WYo/U0AzzN4UAFPlTI1iRVRUWqtRTHaf8sCXXZzJnf
         NJL3l99mu6NE5Asx87J+/QD6IeeyB3qXivdFsvkAKE6TbTRWix12Dqc9T+JmjOGbnts9
         4TFjGIVIDOrRXIamT7vOV1TzgaehJPaax4ZVZ8nlHpjlkRagg2W3Kahrivj4XNmSdY7D
         YIBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=I7AGr5kxvD7L8BGImkaiYYIcWYTyuHALX3Uwn5SFGes=;
        b=tB8+/KPpt8cqhZgSUokv/2OfcWKIPsYUa//dYCWYsDWDw0q6EVIHqz9ygbumV7YBSe
         EpxCVA1vQ0uDjQKGaeTM5v3iQNYpD9mG5b484Zr1heBZffW5g74pJvEKkPiILl9/hCLj
         jRPcufJAN5IaZGm6pslzLrnVOy9SnHBnkWBsd1nMQZci0TaDyoKEZX4NAfDmj+xaZCcO
         iBQ3A5usMyxaOwyo1z0gn0c1nmNWO2duJ2hfZp+/TuLXGsEh6j0FJuoxqpDZk7P9CMMw
         5h+6JeKaJL3QCoNb44Mz4OsYW2ije+R1rZLjgj5M++blsULnM6wouirmHbMhxal+Apo2
         nr7Q==
X-Gm-Message-State: ACgBeo1XKIVmB3ocFGJPFMbMu7bxVkCiBU3tOwUs8isaxvCABw04BXvS
        Cazw1u4aybWs+B/8oX4l384ToQ==
X-Google-Smtp-Source: AA6agR5hWM2GJ5zXaAdZz8/5jyfYnTB6f4lRkH4YbMaWcByENpIrNcfVlyo+HaeUh7LK3d+xbRkfaQ==
X-Received: by 2002:a0c:f445:0:b0:4a6:9f4a:9a66 with SMTP id h5-20020a0cf445000000b004a69f4a9a66mr14581963qvm.65.1662767593396;
        Fri, 09 Sep 2022 16:53:13 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id fz16-20020a05622a5a9000b00342fc6a8e25sm1348798qtb.50.2022.09.09.16.53.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 16:53:12 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oWno8-00A0GS-4S;
        Fri, 09 Sep 2022 20:53:12 -0300
Date:   Fri, 9 Sep 2022 20:53:12 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Ethan Zhao <haifeng.zhao@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
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
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v3 01/15] vfio: Add helpers for unifying vfio_device life
 cycle
Message-ID: <YxvR6PHywJCTgp3z@ziepe.ca>
References: <20220909102247.67324-1-kevin.tian@intel.com>
 <20220909102247.67324-2-kevin.tian@intel.com>
 <acbaf0f2-91d4-3eae-5716-244893ca34c7@linux.intel.com>
 <BN9PR11MB5276E41114EEE687975C698F8C439@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276E41114EEE687975C698F8C439@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 08:42:25AM +0000, Tian, Kevin wrote:

> I think it's quite common to have an alloc() helper initialize refcount, e.g.
> vfio_group_alloc() both initialize its user refcount and also call
> device_initialize()  to gets kref initialized. Similar example in
> ib_alloc_device(), etc.

Right, it is quite a good/common pattern to have an allocation function
return a refcount to the caller.

I don't know of any naming standard for this however.

Jason
