Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610AC75D4E2
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 21:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbjGUTZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 15:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjGUTZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 15:25:52 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148512D7F
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 12:25:51 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-666ecf9a081so1995070b3a.2
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 12:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1689967550; x=1690572350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MMsZNxLO6ied/G62NsNmuJtbpPqA/ZDXuniKdHv3YB4=;
        b=XQzjypm8qf/fouvehrBkEZjx7rraTNYkUvdCKXn1r1gfZnRnhcrrwzmNXN35Uu7gzI
         8oZahINtXmo9uCfjOT5mfF9tPFqadYED4ml2Rvg4gr4OGGmk2vfi6ALPhCVFDbYVbCVR
         bizj8weYssavNq2IYvHIenQVmt+p9+kOYvZhgrRMHxTk+VUEpNpnyoTxavBUyIHeBvaf
         qo1QRc6+YoA80RoGKZsLsD7vsvUGziFJq2u5Wn3UEGI6GwRgyCcJvjby4g2TfS0YmrN7
         IaJoLwJh5sfemxuaaNtQypWoArXN7KcGOCwTG4BZdi4RfD5EEjDf6oZVJxfS3TMV68DT
         4znQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689967550; x=1690572350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MMsZNxLO6ied/G62NsNmuJtbpPqA/ZDXuniKdHv3YB4=;
        b=B2bG1efp9doPjZNpHlXa5BTf1rXlVTvHX+/rV6a7NohuU11hhyfee92dbpnqIwDY7i
         lOGM4AVuKBBYxMV7D43ZsaQMuIQoQRqyq294M+gUK3jY+jNxWP7lK9S+P5+NrBktGk0Z
         wi1UgiT4OeiekL0qnvJ1QBlJoBmLFTiYDrJaBivIDrJqE5nV3DvoSEVAxSuwyK3vSy0K
         NFYUy0AheCtYgXcPSfPP8rcnrB5AHjlNXZGntU0Ytpvjvkofu2r4uI3osmRAN4y6urKK
         psFn/vG0hGvKbWprFQIJcSlI98J4VJyOiS/rJ8AepWQpBJfO3kTY0EykAE+8tcb/UYM0
         GZKQ==
X-Gm-Message-State: ABy/qLbqCRJAk2CtFeT0WkRV2aUIEB5dnpL02d/+d8zJvhIV8TPa6QrU
        l/VpPbHQg9hQooqGygAObbvc7A==
X-Google-Smtp-Source: APBJJlEp8s38SXROq49pagsC5pVvuYXs5UAkGBJHAYanGZ9PMcBXp3bCvAhBUtgXgds2MFlgz7aUow==
X-Received: by 2002:a17:90b:2308:b0:262:f06d:c0fc with SMTP id mt8-20020a17090b230800b00262f06dc0fcmr2530695pjb.7.1689967550531;
        Fri, 21 Jul 2023 12:25:50 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id d5-20020a17090a8d8500b0025bd4db25f0sm2845416pjo.53.2023.07.21.12.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 12:25:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qMvl5-003ID1-Uq;
        Fri, 21 Jul 2023 16:25:47 -0300
Date:   Fri, 21 Jul 2023 16:25:47 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     akpm@linux-foundation.org, ajd@linux.ibm.com,
        catalin.marinas@arm.com, fbarrat@linux.ibm.com,
        iommu@lists.linux.dev, jhubbard@nvidia.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        nicolinc@nvidia.com, npiggin@gmail.com, robin.murphy@arm.com,
        seanjc@google.com, will@kernel.org, x86@kernel.org,
        zhi.wang.linux@gmail.com, sj@kernel.org
Subject: Re: [PATCH v3 1/5] arm64/smmu: Use TLBI ASID when invalidating
 entire range
Message-ID: <ZLrbu6vk6x7l6xwJ@ziepe.ca>
References: <cover.b24362332ec6099bc8db4e8e06a67545c653291d.1689842332.git-series.apopple@nvidia.com>
 <082390057ec33969c81d49d35aa3024d7082b0bd.1689842332.git-series.apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <082390057ec33969c81d49d35aa3024d7082b0bd.1689842332.git-series.apopple@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 06:39:23PM +1000, Alistair Popple wrote:
> The ARM SMMU has a specific command for invalidating the TLB for an
> entire ASID. Currently this is used for the IO_PGTABLE API but not for
> ATS when called from the MMU notifier.
> 
> The current implementation of notifiers does not attempt to invalidate
> such a large address range, instead walking each VMA and invalidating
> each range individually during mmap removal. However in future SMMU
> TLB invalidations are going to be sent as part of the normal
> flush_tlb_*() kernel calls. To better deal with that add handling to
> use TLBI ASID when invalidating the entire address space.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
