Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EE7618B43
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 23:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiKCWTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 18:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKCWTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 18:19:53 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DEE1D0FC
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 15:19:52 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id k4so2098028qkj.8
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 15:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7cc0SK+9kSst6EnmWFM/zETjtG7gKebs/uq8K8OO6MY=;
        b=JdCZwi2wSUiQJ+PVJnV8YNy6c4RxoppeWif+mfTuqJpezPvM4UkRNzsF8dor1zLjqi
         BklUe6GcG2F6BjYpdz6tNV/UwmMeH2nINlAH1jS2++8K+LqB6vVGB3kHtzOugc+MXhI2
         fbie2AUHhk2V/0VxKtevLQZOXQgd1JIXbj5+DYeKZk5ntTHg8h43XGrh376OeIy6Y0/m
         E4O7Nm2I2RSgTrLYpK8x9eu6gQc9Qhjz5JhOKyHlXPAvjAgoQ8Syix3kBg2FhquySEAD
         q3Vkg8zLYqQH52FjGqdNHdPZhyAHPSA7Sc2R2YkPHTj1dhw2sM5VKBWnA+p77z6u3L+6
         z9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cc0SK+9kSst6EnmWFM/zETjtG7gKebs/uq8K8OO6MY=;
        b=kSVFMDJFYzryjCCK0unXk/ZySOlqe2ZprFwm5LTb/c9zRLK8FojJL7W6uQOb6Bziej
         W9ldPmU2kD6kBNk1FlB1TMSvh+0g9W98/FxIaBH9f/QiHu59zo5zb+I/UJHIwNblhi2B
         395bggWwFkoP8J/DsSswsGl+PMf2WZXlRDjPJLnn7J6Wrlyzw/LhFkTNewGuSQP94xZh
         ceHnUCJpkFu27Th4gOYpuzI24eURjqntCDztk+LZmTk+OIHdjXqMURchQuAHNih5axd3
         05wnP+WQi2pn/hZWKKqrsZFFr2co2dY/aEfAsHkNSZXrxfYBxIHBN+3Dguf04Qt3ugXp
         Wh8g==
X-Gm-Message-State: ACrzQf3Cjsf0/l60EkD59fdZI6n/p06j41HdpZLfpkaKapUNggcmOluq
        hNbQd30J+OYvXJYb8ezcrQ3bdw==
X-Google-Smtp-Source: AMsMyM41qQu/u1Yohq6cIfiQiLJGLTUN7Mx8c3NuNtN+ygfs0R2QG9ij2AXk6A0l8CoriIRjodwMPQ==
X-Received: by 2002:a05:620a:f03:b0:6cf:c0a1:20bc with SMTP id v3-20020a05620a0f0300b006cfc0a120bcmr23720107qkl.663.1667513992034;
        Thu, 03 Nov 2022 15:19:52 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id cx26-20020a05620a51da00b006fa12a74c53sm1579949qkb.61.2022.11.03.15.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 15:19:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oqiYw-008R9b-2u;
        Thu, 03 Nov 2022 19:19:50 -0300
Date:   Thu, 3 Nov 2022 19:19:50 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shang XiaoJing <shangxiaojing@huawei.com>, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        cohuck@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH -next] vfio/mlx5: Switch to use module_pci_driver() macro
Message-ID: <Y2Q+hluS4gr0y5nw@ziepe.ca>
References: <20220922123507.11222-1-shangxiaojing@huawei.com>
 <20221103130742.1f95c45c.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103130742.1f95c45c.alex.williamson@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022 at 01:07:42PM -0600, Alex Williamson wrote:
> On Thu, 22 Sep 2022 20:35:07 +0800
> Shang XiaoJing <shangxiaojing@huawei.com> wrote:
> 
> > Since pci provides the helper macro module_pci_driver(), we may replace
> > the module_init/exit with it.
> > 
> > Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> > ---
> >  drivers/vfio/pci/mlx5/main.c | 13 +------------
> >  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> Nice cleanup.  Yishai?  Thanks,

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
