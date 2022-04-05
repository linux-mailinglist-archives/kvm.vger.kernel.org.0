Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BED4F497E
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391347AbiDEWSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573394AbiDETGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 15:06:15 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD50E1706C
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 12:04:14 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id i4so364278qti.7
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 12:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p4sIUWeO6+P4zWNNUhdcwFoqQbff1GSzTj3PyXvmiEQ=;
        b=nmqu50EBRX36s361/cDtv8BTMjCMfqpX08sQhZFrt8sYSEBPwE1vgZ4nW0w4EdNOZv
         o+tA8EKhpRSdQR3Dv6ZeNplzb/6/d4P/pYo8hMuSFtnnHbT18NbIqrDKWGWRuzj0sX33
         NwkCKPzO9uzXxgwt6mzZTzUipt/2LtQXBV9/6/aCHm68I4zhTPhv8T6Xk7CqblW0d9at
         77T1IBaxtpT6vZINZsj5yY7V5fK3TqnoQBl+RnTQQqZTftcLpRRB8gnwvPgzdCfnGiPk
         34ATgiHVCSNNKC4vBPleRiNh9Mj27XotB+bI/48+eyL/b5gKJFVKWfht+KhNDWMMBTx/
         hSzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p4sIUWeO6+P4zWNNUhdcwFoqQbff1GSzTj3PyXvmiEQ=;
        b=TtLozT5kNaU+ADBbY/9fAfoChCdR7t6o8s4Eo5V7VVxJO8Fzu5ixm7utcgGqLYiZ42
         3WcYweKLXAdR00Ryl+Ik13vpf84ij5Et6r4Q2Z+NnYJf/0+NGipIfIAmLWduYATphlmt
         RjdYh2TKMYpfVQeGDR2EEjhZ+Y3wPfEbBggy60t/aMwHa6RJrqVyyXWzRMXMAgLo96aO
         Gs6jU1AtRl7Bh18I0/1dlmotNGsF4Q3RWFFlv2Xtl64A64fyTbHwNPSWAAxr/UmsoDXN
         ADF4UL1c5ie6sZike1u5FUKzKLbB9auDno8CMXcEFymn0l8EzRua1VhWHxFj3eOeDLh3
         iPzw==
X-Gm-Message-State: AOAM5307hbY4m8atoFB7uyiU8TDDI/lxSY2R4vz5GRNI47OMX20VyMqV
        PwbqQDXfplC9xzEsEGxJFdji1g==
X-Google-Smtp-Source: ABdhPJw89QndTutZv11VxczePEqDQB0+l7F3uU5v+rVSKfMzarjpMx65Se4MSU9B2AhnbihAOWRqBA==
X-Received: by 2002:a05:620a:2452:b0:699:9df2:665d with SMTP id h18-20020a05620a245200b006999df2665dmr3178998qkn.668.1649185453843;
        Tue, 05 Apr 2022 12:04:13 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id p16-20020a05620a22b000b0067b7b158985sm8057701qkh.128.2022.04.05.12.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 12:04:13 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nboTL-00DBjA-Ix; Tue, 05 Apr 2022 16:04:11 -0300
Date:   Tue, 5 Apr 2022 16:04:11 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     alex.williamson@redhat.com, iommu@lists.linux-foundation.org,
        cohuck@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: Stop using iommu_present()
Message-ID: <20220405190411.GT64706@ziepe.ca>
References: <537103bbd7246574f37f2c88704d7824a3a889f2.1649160714.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537103bbd7246574f37f2c88704d7824a3a889f2.1649160714.git.robin.murphy@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022 at 01:11:54PM +0100, Robin Murphy wrote:
> IOMMU groups have been mandatory for some time now, so a device without
> one is necessarily a device without any usable IOMMU, therefore the
> iommu_present() check is redundant (or at best unhelpful).
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>
> ---
>  drivers/vfio/vfio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
