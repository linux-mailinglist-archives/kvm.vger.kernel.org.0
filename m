Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F87B75D4EC
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 21:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbjGUT0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 15:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjGUT0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 15:26:31 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D8C3A84
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 12:26:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-2640a8ceefdso1308823a91.3
        for <kvm@vger.kernel.org>; Fri, 21 Jul 2023 12:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1689967579; x=1690572379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xr6a3wPaSbxEaGpekcRzvtgOYy20EpF6cLmCTWGM/d8=;
        b=PapxbFN9nlQZ0hbhKVwwawBN6LdJjW3Jxp3CpwEUvmqx8VSIfzvyAWjZmPM7Kc45gi
         qopDwV5z676Si5veJkfi0qrd8a5xaySsryWYloQnQkx318xKe2pYBW9+lqkzldmdemE1
         99prBRal3lq3NgQTCz4ZW//9sRY8xNIj5NBo9hLhMiknT0FEv9J2i7fnVBCc6RRf9Znf
         uwsKZ1RZ5VKXjQYWscKe/M+wHdFj68hEhUuwbDqS0RyuhUHk9xpOWf2qzUNm03raJDUF
         LRxvhcmz1Sp9N4r1u6RxuFKGIRB8KKPMrUgr5brHzLqEYPIE9mcLBomKV+bnZZ4ylsbl
         XTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689967579; x=1690572379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xr6a3wPaSbxEaGpekcRzvtgOYy20EpF6cLmCTWGM/d8=;
        b=gvhTonLq5S3ST7zANNnylOPvkIUaiC8+9tVEfNLyKyCWhvbrMaUoXUqMfRSz2L+OIT
         G4boc9GWnqibk4QGBN49jwZKyj7GcNxztNdCbxpMCCs33S6stA2zu1Sq0j33t+Sd5WIi
         9yTX2sZRm8feYsDzccYvrPNpCSFAbXcFSIIUjFYt8VJUrgULi35BzHXM2fbq1u9PYeZg
         VN9U5bP17QK+byE6SmLY1kF8o2ypInVE1MsXb77YZDTGOhZUzxHvI65UlAjXf365/DAP
         4cASvf0tqiWPiEB+qUrkS2+f9PXPFw3bdL1is9DwNajuyoYil5Mtdi0grvQZUfXs+DzW
         HLbA==
X-Gm-Message-State: ABy/qLYotv4ZqpJqE0YJJ48VusHSU+TqbkKhNdjV9trKh9MtspxI12vE
        a1ITYuaVDa/t/eiHywKDJm/KYQ==
X-Google-Smtp-Source: APBJJlGqDcvhn/GzUoUrWJEAu6LLTtj6nE8lbyEgpTLg48+TgijhmiTggNpW3leZ2HelRF+2igrYUQ==
X-Received: by 2002:a17:90a:bb09:b0:260:fd64:a20 with SMTP id u9-20020a17090abb0900b00260fd640a20mr2495306pjr.9.1689967579259;
        Fri, 21 Jul 2023 12:26:19 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id e23-20020a17090ab39700b002609cadc56esm2802248pjr.11.2023.07.21.12.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 12:26:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qMvlZ-003IDP-Dp;
        Fri, 21 Jul 2023 16:26:17 -0300
Date:   Fri, 21 Jul 2023 16:26:17 -0300
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
Subject: Re: [PATCH v3 2/5] mmu_notifiers: Fixup comment in
 mmu_interval_read_begin()
Message-ID: <ZLrb2Xq/ZgDgVPNf@ziepe.ca>
References: <cover.b24362332ec6099bc8db4e8e06a67545c653291d.1689842332.git-series.apopple@nvidia.com>
 <06fa82756e4d6458895962a7743cc7f162658a54.1689842332.git-series.apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06fa82756e4d6458895962a7743cc7f162658a54.1689842332.git-series.apopple@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 06:39:24PM +1000, Alistair Popple wrote:
> The comment in mmu_interval_read_begin() refers to a function that
> doesn't exist and uses the wrong call-back name. The op for mmu
> interval notifiers is mmu_interval_notifier_ops->invalidate() so fix
> the comment up to reflect that.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  mm/mmu_notifier.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
