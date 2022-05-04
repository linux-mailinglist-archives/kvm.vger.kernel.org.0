Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7463451B23A
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 00:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiEDWwA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 18:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235261AbiEDWv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 18:51:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D3D0527EC
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651704501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xOeJYvGSOMJD3tTL/lLoRftgg1kVko3RAGSpsjhKUO4=;
        b=HoiqYeIliOFsN7DtJzKTJzJ4pECNKcoujEMtP89awmReKGzwjDXF3geH7T5PtL5X0moG+o
        2RwEd7JUls537yx6PZFaoaZnJ8l3vF/8zP+wOXL8q7LpwN8oXGA9mpJhnPHAE0o3JKqXLI
        tSo16r92D4xBwPAq6WlcsF8+bWLCLtc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-srXI6vO8O1uGx4zFDPvKLg-1; Wed, 04 May 2022 18:48:19 -0400
X-MC-Unique: srXI6vO8O1uGx4zFDPvKLg-1
Received: by mail-il1-f198.google.com with SMTP id j4-20020a92c204000000b002caad37af3fso1442002ilo.22
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:48:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xOeJYvGSOMJD3tTL/lLoRftgg1kVko3RAGSpsjhKUO4=;
        b=FwfFmf0otJnjxmSH7zqMspmNslDhiIR3VY4Qn6YdbSMub5magto8xfYA6yPc4iltHw
         YZ1NIzoX+B+tSATP5cnVRIA++YFD4UC1q/4v955pEZGEstnJe8/TV7/LETpj+cjlSHuO
         KcPr4HCk1HuKFbPe9RKGaXN+BoXY8uC8axwhfhXutwpIXZIEwQpvN8lC+zzYzcBgGjh+
         DD1rRvhcX0/JUNuyK35KxJ84dTgqHKZu9Or00aZi6FppV5YC0yKjQ8uAP+Vm12X91C9B
         jPH0IswfecuXV0Kx8IGKwi4Ib4w/hP0Ckqjqm9DFWORQqvfSDGopxf+cCAlJDEHxc05I
         +XNA==
X-Gm-Message-State: AOAM530Fsd57taQPAwY5guFC6hLuEoOmYXJuldRmkUxZsAPQNTbSH9pg
        VadbATuYSvKw8yt0lpEL9UfrMlv8EWINpvnswFa0DMRi3U3yNKG6bCbX6qcR87l1SLkaTeXa6OQ
        vrNNORM4yF/1Y
X-Received: by 2002:a5d:9448:0:b0:657:24e0:c0b2 with SMTP id x8-20020a5d9448000000b0065724e0c0b2mr9082789ior.167.1651704499227;
        Wed, 04 May 2022 15:48:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwv7opUQwDW4a+DX12v3ZS3+a6b1pREiCVADRhe7RFeKSIfVEiN8HcWu3icEqj+XWft2nvRLg==
X-Received: by 2002:a5d:9448:0:b0:657:24e0:c0b2 with SMTP id x8-20020a5d9448000000b0065724e0c0b2mr9082781ior.167.1651704499005;
        Wed, 04 May 2022 15:48:19 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i13-20020a056e0212cd00b002cde6e352cesm15508ilm.24.2022.05.04.15.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 15:48:18 -0700 (PDT)
Date:   Wed, 4 May 2022 16:48:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, saeedm@nvidia.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH mlx5-next 0/5] Improve mlx5 live migration driver
Message-ID: <20220504164817.348f5fd3.alex.williamson@redhat.com>
In-Reply-To: <20220504213309.GM49344@nvidia.com>
References: <20220427093120.161402-1-yishaih@nvidia.com>
        <4295eaec-9b11-8665-d3b4-b986a65d1d47@nvidia.com>
        <20220504141919.3bb4ee76.alex.williamson@redhat.com>
        <20220504213309.GM49344@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 4 May 2022 18:33:09 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, May 04, 2022 at 02:19:19PM -0600, Alex Williamson wrote:
> 
> > > This may go apparently via your tree as a PR from mlx5-next once you'll 
> > > be fine with.  
> > 
> > As Jason noted, the net/mlx5 changes seem confined to the 2nd patch,
> > which has no other dependencies in this series.  Is there something
> > else blocking committing that via the mlx tree and providing a branch
> > for the remainder to go in through the vfio tree?  Thanks,  
> 
> Our process is to not add dead code to our non-rebasing branches until
> we have an ack on the consumer patches.
> 
> So you can get a PR from Leon with everything sorted out including the
> VFIO bits, or you can get a PR from Leon with just the shared branch,
> after you say OK.

As long as Leon wants to wait for some acks in the former case, I'm fine
with either, but I don't expect to be able to shoot down the premise of
the series.  You folks are the experts how your device works and there
are no API changes on the vfio side for me to critique here.  Thanks,

Alex

