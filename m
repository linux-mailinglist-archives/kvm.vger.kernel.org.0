Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026CE7D3F53
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbjJWSfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjJWSfb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:35:31 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B67C8F
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:35:29 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id 5614622812f47-3b2e72fe47fso2541217b6e.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1698086128; x=1698690928; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IIoRI2ARPSz8WtQUlc5itQT0gMoQCkpLJtTDznyytSc=;
        b=hCCbONk9aeS3MscLtPA1VLgVMXvUWrQ1ohu9W3XXuT6+KjK/QXVNPCIMNPG09W2MCW
         TsOfEVCohg4FmVYJwXu8D4DTGqpVIyVIFy+lfBywKl0XRHEpZOrlahyM4RVPZVjcr3Hd
         PonBM4simvyuMYbArJwX/8HHFxhnB/eLbKvQIgAtFd7KsE7/JfYknP+HPDfhjE07D9U1
         J1Ot2I450c7zleH8zZcRKt+lhyxw9yxsZHY2re+Sxg1e6rrCpkPBthM69MMg0x4Hu0Up
         X1LHnkcaqokwnxcellEI1Uk0AnakrTGR8nG+tR4jl/5ad7HtG+3WjTWDmSS29dKKiP/U
         OmBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698086128; x=1698690928;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IIoRI2ARPSz8WtQUlc5itQT0gMoQCkpLJtTDznyytSc=;
        b=hSwfoyluwJu+CFo77qqoFSQ+a8624OyQhRDad7Krg7ruG0BOMuPj1O3vjF1Pll95an
         2NHhLfoucp8UM4rhm3DDr1TCDiOli7Y4Yhg+36d9WcrfbLqafyOuRVVxmJvGIBRp3ptI
         ct+XU+tmCa5Mv/6839aJxRGaJG3DeMeH/WG97cYGR7JYFyulADI8miayTvpQmt/BXJc7
         go9PcgNOewQciLPcvSCbuRpYS6Pi+2ZZvwLSHAX6DEh9OPwJfhp7eJFjL3XT4NeXFmtJ
         hE5Cb+zENi4+5pJeBLlvfpSBjYtkWr1jkEhwHv7q9kPb+tZhgTO9m0dX/kHgPCdpuD96
         HGmA==
X-Gm-Message-State: AOJu0Ywdef6UtEWvVpweWjYa9teETgSXa0CkdWNHymNFmPhWGpLqoiTd
        LJPqo+yALGJzqYnVjVKYzBV+RuHjMOUA4HyUYrY=
X-Google-Smtp-Source: AGHT+IF87A5sAEPwDGGscH4VZHk76YpcDJFB/PbHnNeeeYrEYuSNJeTyvaSasLb7bG0Tzfme5ZXN0A==
X-Received: by 2002:a05:6808:158c:b0:3af:9848:1590 with SMTP id t12-20020a056808158c00b003af98481590mr12228373oiw.6.1698086128598;
        Mon, 23 Oct 2023 11:35:28 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id bj6-20020a056808198600b003adcaf28f61sm1593859oib.41.2023.10.23.11.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 11:35:28 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1quzlv-003jZ6-6w;
        Mon, 23 Oct 2023 15:35:27 -0300
Date:   Mon, 23 Oct 2023 15:35:27 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Tina Zhang <tina.zhang@intel.com>
Cc:     iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [RFC PATCH 06/12] iommu: Add mmu_notifier to sva domain
Message-ID: <20231023183527.GM691768@ziepe.ca>
References: <20231017032045.114868-1-tina.zhang@intel.com>
 <20231017032045.114868-8-tina.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231017032045.114868-8-tina.zhang@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Tue, Oct 17, 2023 at 11:20:39AM +0800, Tina Zhang wrote:
> Devices attached to shared virtual addressing (SVA) domain are allowed to
> use the same virtual addresses with processor, and this functionality is
> called shared virtual memory. When shared virtual memory is being used,
> it's the sva domain's responsibility to keep device TLB cache and the CPU
> cache in sync. Hence add mmu_notifier to sva domain.
> 
> Signed-off-by: Tina Zhang <tina.zhang@intel.com>
> ---
>  include/linux/iommu.h | 2 ++
>  1 file changed, 2 insertions(+)

You should look at how arm smmuv3 ended up after I went over it to
make similar changes, I think you should take this patch

https://lore.kernel.org/linux-iommu/20-v1-afbb86647bbd+5-smmuv3_newapi_p2_jgg@nvidia.com/

into this series (maybe drop the arm part)

And copy the same basic structure for how the mmu notifier works.

It would also be nice if alot of the 'if_sva' tests could be avoided,
smmu didn't end up with those..

In the guts of the pasid handling sva shouldn't be special beyond a
different source for the pgd.

Jason
