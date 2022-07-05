Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBC6567627
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 20:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbiGESGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 14:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiGESGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 14:06:52 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937161D321
        for <kvm@vger.kernel.org>; Tue,  5 Jul 2022 11:06:51 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id z7so9301641qko.8
        for <kvm@vger.kernel.org>; Tue, 05 Jul 2022 11:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NBfVoJSUJjdQQlb25uPxwtrVG2zP5XJD8q80sb5lV4A=;
        b=QbXbIjGWJFR+vFj17KgXaWRRm9RVaUzey5ETHrNx1L1E4Y6/IIPUz6tWo/LsvxFUEr
         4sFAAU1qp1ba2RESZKKr8qk1sqglr8vWSJMskPCRS4d6dqav4StSexv3Yz1Wpu9d42T9
         sx5vqagJhApayuqVLlqblgUhC9atwJF7xReaVTKbE007GkuyOi9am0XjnV0SLOj4megt
         tdOzfWNqnwJXJs8m6EFjBAXznAczO6SgooHn0073jjOTupESoQRFlbDCj55ZoCnTkhnZ
         Zyc1OZNDoYSDFs4h01UNG7ay5CAcM3i+qvf/pd9geSTMoAXBNE23C2xssZzj4ha/PUvN
         cwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NBfVoJSUJjdQQlb25uPxwtrVG2zP5XJD8q80sb5lV4A=;
        b=OxVdF1c4U3JRX8BQiwcKFI4P3WPnYesuzpykG121sJ8QSRDqiyGJMQ5dAYotitM8Q5
         iVH42dvO0bpCTFjyiGcta13UfTkJlKAKZvLy/uLR50ZhAy66dFmEgjHun/Me6NowDyEP
         GZVf+t77OmVNtjqve+YoYyOi5HMZ5EVCum9SIeae7ZrhoKGLIEtt6OkUnt1nDtfv6ept
         8t72F0+zihkaMHuyINniPTvk9gjJjFDq8Hy0xpdPy6vekOBWjvLyqWSkxmVXr5kNIgvR
         BCpKtPz4Jf183vtUKfHf0I2quvUligG+XzoY2njuKmch+0Xm24a22UMh+mnsK2IsorgL
         CAcQ==
X-Gm-Message-State: AJIora86Yk4Mp7Z7mVWrHNNe6xZG+m1pQIl65mboUDfdwv93JyKFf2dT
        oWH9fkEd9IgdVDk84dyRPTAkBj+Vy0gaqw==
X-Google-Smtp-Source: AGRyM1sz5Y2Ey5Cegzao8aWSyWOyIu98uEGQKAoalzRTmZGcTM98fT2ExQGr6cRp/IkcMKw3R7WcZw==
X-Received: by 2002:a05:620a:7f6:b0:6af:2bef:2f67 with SMTP id k22-20020a05620a07f600b006af2bef2f67mr24446278qkk.595.1657044410618;
        Tue, 05 Jul 2022 11:06:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id bm14-20020a05620a198e00b006b2849cdd37sm7277258qkb.113.2022.07.05.11.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 11:06:50 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o8mwj-006aGy-Kt; Tue, 05 Jul 2022 15:06:49 -0300
Date:   Tue, 5 Jul 2022 15:06:49 -0300
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
Message-ID: <20220705180649.GI23621@ziepe.ca>
References: <YsP+2CWqMudArkqF@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsP+2CWqMudArkqF@kili>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 05, 2022 at 12:05:28PM +0300, Dan Carpenter wrote:
> The casting on this makes the integer overflow check slightly wrong.
> "len" is an unsigned long. "*pos" and "requested_length" are signed
> long longs.  Imagine "len" is ULONG_MAX and "*pos" is 2.
> "ULONG_MAX + 2 = 1". 

I wonder if this can happen, len is a kernel controlled value bounded
by a memory allocation..

> Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---

This code was copy and pasted from drivers/vfio/pci/mlx5/main.c, so it
should be fixed too

> It is strange that we are doing:
> 
> 	pos = &filp->f_pos;
>
> instead of using the passed in value of pos.  

IIRC the way we have the struct file configured the pos argument is
NULL.

Jason
