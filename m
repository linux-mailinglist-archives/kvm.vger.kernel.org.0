Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076F75A7201
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiH3XxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiH3XxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:53:21 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600316F579
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:53:20 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id j17so9820129qtp.12
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=0L9lzbhkZzftrSeDaWijQDCQO9j3SGBYGuP12lwKrD4=;
        b=abU+GXUqXS02jbKnf2PRzA2SplEPWEhWBJXpAj1du50snC84YOMDGmANpop4r2D5RI
         A4U3zwrxmKzP85VmYMfLmMr9d8tg6zzPw06qrOb8xn1+gH+99+F/OqVnG6/Lre9KSBn4
         zo1W9hlGuorJ3UbplvrCJJ7kZsv0daqDi0GQGmd0ruLNnRpZj56ErHB8VXLg1xOm3LHq
         maRIgx82QxWYjhHSesGndBYpHaVl6id5aHSVMfdeECEz4kib+EUHa1ZBuE/1RPBUFsgE
         JcJxShe4TJ5UBGVmwQuxC4y1kwMf2mv/hIY9Ot37rDwVObnAzUnFQD20KAt94BvvUosg
         gM4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=0L9lzbhkZzftrSeDaWijQDCQO9j3SGBYGuP12lwKrD4=;
        b=6sz2j88IQ83f2mfCAERIXM7T8uOkfGuyIre5e0jvI3kUfvU/pe7DYD10fUzOnkuexA
         jBEPsQi9JsTtpsJiPK1Thl20NyCYMxH7qU2hEcp4M0jj3GdFvDDJCi36g2+wT2NY1R5g
         V861RJ0sisKMa85wK9DS46WDFDJIBA3/jM8X4EEWsL4W8f7Q5U7dLVbuNjRzAOZcrvxY
         hXITXPps5R/IrH3aQsIUX/rRSc/FJGXslymJcrWisAjjCXns4NAA8A9n4Sn7ujoyG7Lj
         FhR1A6SPiqFiOD7LJBl35mafZINlo1dcs1q9zIM5A9jo9F8UnDlFXwE/t9S9gJCuU2ts
         NyKg==
X-Gm-Message-State: ACgBeo2498Q6CHD68XSJVtP9gSA7tFrOBCb2eKmxTk/jWjMLfBHtCftW
        /cnAYZ/37+TA0iAyIGzyEEkgGQ==
X-Google-Smtp-Source: AA6agR6SnhQJ6ZIIgoEC6fgDH1kdHhhz4b0pJAYeL3h92b1z66EiWbI66KVBnDlLAl7TgsI8hPuL0g==
X-Received: by 2002:a05:622a:195:b0:344:5630:dcc with SMTP id s21-20020a05622a019500b0034456300dccmr17037439qtw.598.1661903599526;
        Tue, 30 Aug 2022 16:53:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id q13-20020a05620a0d8d00b006b942f4ffe3sm1800753qkl.18.2022.08.30.16.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 16:53:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oTB2j-0040T4-8t;
        Tue, 30 Aug 2022 20:53:17 -0300
Date:   Tue, 30 Aug 2022 20:53:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>,
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
        Cornelia Huck <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 15/15] vfio: Add struct device to vfio_device
Message-ID: <Yw6i7btDKcUDPADP@ziepe.ca>
References: <20220827171037.30297-1-kevin.tian@intel.com>
 <20220827171037.30297-16-kevin.tian@intel.com>
 <20220830161838.4aa47045.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830161838.4aa47045.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 04:18:38PM -0600, Alex Williamson wrote:
> On Sun, 28 Aug 2022 01:10:37 +0800
> Kevin Tian <kevin.tian@intel.com> wrote:
> 
> > From: Yi Liu <yi.l.liu@intel.com>
> > 
> > and replace kref. With it a 'vfio-dev/vfioX' node is created under the
> > sysfs path of the parent, indicating the device is bound to a vfio
> > driver, e.g.:
> > 
> > /sys/devices/pci0000\:6f/0000\:6f\:01.0/vfio-dev/vfio0
> > 
> > It is also a preparatory step toward adding cdev for supporting future
> > device-oriented uAPI.
> 
> Shall we start Documentation/ABI/testing/vfio-dev now?  Thanks.

I always thought that was something to use when adding new custom
sysfs attributes?

Here we are just creating a standard struct device with its standard
sysfs?

Jason
