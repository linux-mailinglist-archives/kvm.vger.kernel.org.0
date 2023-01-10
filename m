Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F486645AA
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjAJQLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjAJQLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:11:38 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C4453729
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:11:37 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-476e643d1d5so160412597b3.1
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LuLL/xW/bc4GjQaeQyZKueQ0wk66WBE0L/jRgACLBJI=;
        b=JwtYIwPX0X6DrJYSYColvSL1d2HfNydQu1+JZAeEN5VHCL87Y+lZBYkXaOeT3Bzkkx
         7NlPUmjOhXtWUcEwWIIEdQbkg5zsfAnNYcM3+Si2VPv5rYvKie8aJW9pSM9IYRan9IWL
         fKAFA3Tp45mugqQ9tkrjUe3JhSDAec0ThFPGG8l3T/9VLLHQ9W0h1+RRZZxzGkJdipy5
         72RaNXLZ3a4hh27GQRToUGeAoKlFIg8BnJXve3ioNV+raiiWr5y3TBMWQXmF6TPNPFsX
         mN1ZlQ4FuZisyh1ZfUm0E2KMdkcpSnkJS2I/U4/NDMsNXeKL+n97dgaf7suk2GAtwJrd
         wKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LuLL/xW/bc4GjQaeQyZKueQ0wk66WBE0L/jRgACLBJI=;
        b=Bx0N4c3tJZnGPU8zQa0jKWDz7zR8ZNmyTzZH2MyVjePGU8a4iY7VB/r6Jdw0jgTHp4
         NwR1d07M3V8VSp6HkWnSNt9reXdInjI3A1QRTrKnViykee9X+KboEadgnsC7SzKtcm+S
         HHsh56dgHaoZ7U1r7joCY0E8scYdpnOMMwD4axFYKXvaEpkmbMF/IR2ZgSij5IwiM+Ux
         hWDl1c24Y7Sbp7MXFKosdIZSM6HoHsUjLDpfVQfySgf+vcdAiEFEZGz5c2ZVAMxcV2Q+
         oUaO3e9y9yXfBh7LT5dda3bQtkepvHqWL1kqteJutQjyOP9gpJFe6UZtS6vtNgBKwhsO
         Zcqg==
X-Gm-Message-State: AFqh2kojYm5UhPJ2AZ5gs8dcDVA9mx259hqpCFVo0yZ4s3oOxwX75bvQ
        ff+9rNMJ8cEnMl0GMAB4g6OevA==
X-Google-Smtp-Source: AMrXdXtfmrz3fXJ9b7HUyCfXVFfON5rLhQo9Xkp7TZG+Th/gH6Ar4roPtsB5A+UiEgJBmqGqhmUlAQ==
X-Received: by 2002:a05:7500:6583:b0:f0:3a58:7714 with SMTP id iq3-20020a057500658300b000f03a587714mr1169364gab.65.1673367096237;
        Tue, 10 Jan 2023 08:11:36 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id v1-20020a05620a0f0100b006faf76e7c9asm7451630qkl.115.2023.01.10.08.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:11:35 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pFHDq-008QLA-Ro;
        Tue, 10 Jan 2023 12:11:34 -0400
Date:   Tue, 10 Jan 2023 12:11:34 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH 1/4] vfio-mdev: allow building the samples into the kernel
Message-ID: <Y72ONmN9vaxOiuYh@ziepe.ca>
References: <20230110091009.474427-1-hch@lst.de>
 <20230110091009.474427-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110091009.474427-2-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 10:10:06AM +0100, Christoph Hellwig wrote:
> There is nothing in the vfio-mdev sample drivers that requires building
> them as modules, so remove that restriction.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  samples/Kconfig | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
