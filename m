Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D44568EE3
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 18:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiGFQSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 12:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiGFQSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 12:18:16 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E88827FE3
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 09:18:15 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id z13so18910417qts.12
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 09:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z5AtWZPe7XoqBJU6Mk4sFJpC18BYt1O5VeJ13XcQzX4=;
        b=Ewz99xqh8v2JGDRnfSIbSELjNOHHdsxNwR3glx8EoOGGev5aohpcw6bWI/kSKPXG0P
         eN6PsAah0mHTRNi3bHI/PD93M4mNRFT9xFR7Xp1ALIJ7MO5UqM1gbfU0vtFnJL4eAXBj
         7HrxdcAznMe+kLEOERuVkQ9iw6gfkPre8defoP11IpiTfUbN7erJSe1v4uTtXgHQMNYK
         qNiR89H3qjJgEivlIv3cciUWJwZPYmnvfH/tVJ18bh+iMtLrA+MY48Ku6YwKjZlJHlyQ
         gsVePEmk9eXsyuDLBOad6mIO/zu+2ZipibQZ/do77BtbkNy7IWxAJErql/N1oRbG6ebq
         Ozqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z5AtWZPe7XoqBJU6Mk4sFJpC18BYt1O5VeJ13XcQzX4=;
        b=t2oizlf0PNpuzLr38abXyT/9ndecVPcEimPPuWjYwYxFGdNRztiPmWFSyevOXkoPv7
         3BQS3xf/dMT0mSMfacKpgpqQyA93asUrkmKiJtlp/+YoqkbZ3r7FX0vn3REedBFtFl9h
         xDaNVk5hIndFlNBQEucqKyzXtebyBEPL8eee738zoPQrmoZScMsW8KVX1KlRv/wgdtN5
         3021xUtxoCkmL+4h34TsyGMSLSqNz1jBnyAzkA8S9PKy7XbZZ/8aGXgdhm9IAyLfLqMv
         6aeOOzt/Fn6lFx5Qpe+zmjv8I1+sO2mwh/RSY+fbg17mWBvrrjc6C8NE9c3eodvBvm80
         ZHCw==
X-Gm-Message-State: AJIora9oCL0gK9vNQJaC4k+oaEVV4pO/zwgUz9kX8N83M1GDcc6drr3Q
        T1XnczUz0l/C0fZVSZSv3sg03g==
X-Google-Smtp-Source: AGRyM1uj3Zv5IfAsAH88CBXvJ1B+xqPgTHtuEYaKAMVSg+irD6dNO967VZRHDnXBhdHxHFqYCJ6SLg==
X-Received: by 2002:a05:622a:450:b0:31d:3a5d:fc50 with SMTP id o16-20020a05622a045000b0031d3a5dfc50mr22010953qtx.433.1657124294361;
        Wed, 06 Jul 2022 09:18:14 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id v18-20020a05620a441200b006a701d8a43bsm24578677qkp.79.2022.07.06.09.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 09:18:13 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o97jA-0076he-VG; Wed, 06 Jul 2022 13:18:12 -0300
Date:   Wed, 6 Jul 2022 13:18:12 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Longfang Liu <liulongfang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vfio: hisi_acc_vfio_pci: fix integer overflow check in
 hisi_acc_vf_resume_write()
Message-ID: <20220706161812.GJ23621@ziepe.ca>
References: <YsP+2CWqMudArkqF@kili>
 <20220705180649.GI23621@ziepe.ca>
 <20220706055124.GA2338@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706055124.GA2338@kadam>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 08:51:24AM +0300, Dan Carpenter wrote:
> On Tue, Jul 05, 2022 at 03:06:49PM -0300, Jason Gunthorpe wrote:
> > On Tue, Jul 05, 2022 at 12:05:28PM +0300, Dan Carpenter wrote:
> > > The casting on this makes the integer overflow check slightly wrong.
> > > "len" is an unsigned long. "*pos" and "requested_length" are signed
> > > long longs.  Imagine "len" is ULONG_MAX and "*pos" is 2.
> > > "ULONG_MAX + 2 = 1". 
> > 
> > I wonder if this can happen, len is a kernel controlled value bounded
> > by a memory allocation..
> > 
> 
> Oh.  Smatch uses a model which says that all read/writes come from
> vfs_write().  The problem with tracking kernel read/writes is that
> recursion is tricky.  So Smatch just deletes those from the DB.

Oh, maybe I got it wrong, len is the user input, so yes that does look
bad

> > This code was copy and pasted from drivers/vfio/pci/mlx5/main.c, so it
> > should be fixed too
> 
> Sure.
> 
> I created a static checker warning for this type of thing but it didn't
> catch the issue in drivers/vfio/pci/mlx5/main.c because Smatch says that
> the bug is impossible.  Which is true.

How come it is different?

Jason
