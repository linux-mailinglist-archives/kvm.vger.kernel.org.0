Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252F05A7259
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiHaAWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiHaAWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:22:36 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7BD9D642
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:22:34 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id j17so9859756qtp.12
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Lh16XHf3++MO2LHtmJix5HtkGiD8BuHOsdyLRFTSe/A=;
        b=XOSFBC16BR5ImEycq6Wxwt1WfjQIyjlHjo1i7V7SOlXSW7tiL+kBgt85+T6v4LbJL0
         qpcT3EFRoQSSF59qi4Crv72crwblNLEVb88+boK4Qw0Gs/leowXS/n7K6EjwDf7a/HER
         q2sBk9M9X08hJphAz+SsXYOzkqISAcKFgWTVN449dwieuLckpF7BA14iO5l3RzFjXP4o
         gyl6FF0GxEX+/UPEyTric08qzhnPSPhsonOcIUIG7An6PY2X/GggY3Irn3C+2HX48htF
         JrguD1dDyhidTXj/hx3ft/CekMn3SB332Z09qXmb7OuMbunnSgJPt4pmcsFpQLNd4Qko
         FcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Lh16XHf3++MO2LHtmJix5HtkGiD8BuHOsdyLRFTSe/A=;
        b=7lNGYxElHIqVJmC4QoxUIfckek9PG5+R7tIGSMo0J1PtPMOsmCMweXDDtWFCS+kZhC
         HQoNryepsPynG9YZEtkab2EQL2aA2ocrDC6JQagnzUf7U4laXN1B0NFLjr+KN5nTZ/gR
         fgilCOCk4fJUc7Z+K8OWSP7oGmVWMvCmsE4FFFlfS8InGBg+Il2CQmDdavNGawA8TdRk
         kY19oz+tqGVSEjWPyYELeumyyJNajjYrAmXs/OqB0/5QqNhW3rAfwwEK8RmpUP9QUshB
         91qDn9AKVt5evQrYKmFgBzVI1ZpyFpmdKiwgRqsa4DR4OZ2Odz4YxRD8nD5A6bgshF6h
         RaBQ==
X-Gm-Message-State: ACgBeo07gQ59GTXbMf97C7F3SjU+njkSQNT6QdBDrIhTYYk8yVecm6PW
        He4mBXVG2pT4EegFkUq5M3lFFA==
X-Google-Smtp-Source: AA6agR7GGtySRj3a31twDnb1mH9EFCJRgojy3h78HnLRKB2gSIxypXh8P0l2OQoGAZF+RRxoexfLDw==
X-Received: by 2002:a05:622a:5c8a:b0:344:ba8f:8892 with SMTP id ge10-20020a05622a5c8a00b00344ba8f8892mr16671557qtb.297.1661905353877;
        Tue, 30 Aug 2022 17:22:33 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id bk42-20020a05620a1a2a00b006aedb35d8a1sm9280435qkb.74.2022.08.30.17.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 17:22:32 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oTBV0-0040ym-RW;
        Tue, 30 Aug 2022 21:22:30 -0300
Date:   Tue, 30 Aug 2022 21:22:30 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Kevin Tian <kevin.tian@intel.com>
Cc:     Zhenyu Wang <zhenyuw@linux.intel.com>,
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
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 10/15] vfio/fsl-mc: Use the new device life cycle helpers
Message-ID: <Yw6pxrS1zb5JKt8q@ziepe.ca>
References: <20220827171037.30297-1-kevin.tian@intel.com>
 <20220827171037.30297-11-kevin.tian@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827171037.30297-11-kevin.tian@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 28, 2022 at 01:10:32AM +0800, Kevin Tian wrote:
> From: Yi Liu <yi.l.liu@intel.com>
> 
> Export symbol of vfio_release_device_set() so fsl-mc @init can handle
> the error path cleanly instead of assuming certain vfio core API can
> help release device_set afterwards.

I think you should leave it as is, the "device_set" cleanup is just
something handled completely internally to vfio

If ops->init fails then we expect the core code to clean the
device_set, and it does because it calls vfio_init_device() already.

Having a single weirdly placed release in the driver is pretty
confusing, IMHO.

Jason
