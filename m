Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE0D3D749F
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 13:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbhG0Lzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 07:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231873AbhG0Lzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 07:55:44 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5787C061760
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 04:55:44 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id 190so11964311qkk.12
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 04:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xGmRZzizcfQYFWuVgpIlcNdw/vWl+k7h2lbS4vofnJw=;
        b=Ni4l0KC28YLJ0zBw4u5zCVT+a0uTq1NH0NX62EZdIAcRxNlVDKkSFtuxBISrSsV2qh
         LMpneYo5qc3DDIvftUiLHYCPBnxnxtTmdreqSCM0yUKYPY/0pgOvq2zUn09d6N0fc5Cm
         bhqQXSrXCXWE+GkrWyF17Zh0mdUMjxPmDr2LgGOMKuNz5bRUFPOEjXyOq0+9b7Dav1cE
         e1vj3HWYddD3EQ8J9DpKYImJheQH8FlLujgHc4r63ggQgvGx9jxszU2TcSARFEDLYD8s
         k/MAe/n/xSSZfft0KE80hVZL/0K1VBzEBeE/0Chf/UbwYimioAmIODew4HbT5td5qNWZ
         RLYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xGmRZzizcfQYFWuVgpIlcNdw/vWl+k7h2lbS4vofnJw=;
        b=To+VvhT/V6QGiuN0ln6WeWlpsxTGXm3avzMfSbzb8ngq7Y5f8XB5NFxsam1RCDqEY9
         Ls0uHle5YVDUCMiBRDPcf546ZlEydHQkmudScHn4ClUsl0owO17dnA1CuRrM17IsGcSM
         I5R+3P4F7JtPfHoCvoQO7t9OdJdRGGqdesVNiUB5THvvc2UyligXyB2Jq7GRdjS5rwwm
         1FyZVTLvF1vs+9RoBQKccMEITTSxjd2muKtjCLgQjpI+yynAfVyDbhywCjwgBG6yIlvH
         LgCNW2xU6XwSnsmoZLpaFDzqZfAgl7XTNqJmFIBUUcHnPrTVzWTFprpwrqOTy6GKUcHk
         Femw==
X-Gm-Message-State: AOAM5316jYt0G5xf1gPZ64nQceOHqPpInG9p2wBwgTwqnKzWYMc3x02I
        LucI1xwwp7aGUYH2fJPM5FcIjQ==
X-Google-Smtp-Source: ABdhPJw+PgC1kl0T4uKspJqLwiD15ss6avKnjHT9BcvPyOnHJWMe0AyIYsLL7GC8glfwyTedjvmJmA==
X-Received: by 2002:a37:9986:: with SMTP id b128mr22397903qke.485.1627386944024;
        Tue, 27 Jul 2021 04:55:44 -0700 (PDT)
Received: from ziepe.ca ([142.162.113.129])
        by smtp.gmail.com with ESMTPSA id u19sm1215976qtx.48.2021.07.27.04.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 04:55:43 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1m8LgU-0090AO-LY; Tue, 27 Jul 2021 08:55:42 -0300
Date:   Tue, 27 Jul 2021 08:55:42 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        zhenyuw@linux.intel.com, swee.yee.fonn@intel.com,
        hkallweit1@gmail.com, fred.gao@intel.com, mjrosato@linux.ibm.com,
        yi.l.liu@intel.com, mgurtovoy@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: use "ssize_t" as a return value instead of
 "size_t"
Message-ID: <20210727115542.GD543798@ziepe.ca>
References: <20210727032433.457-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727032433.457-1-caihuoqing@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 11:24:33AM +0800, Cai Huoqing wrote:
> should use ssize_t when it returns error code and size_t
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/vfio/pci/vfio_pci_igd.c     | 4 ++--
>  drivers/vfio/pci/vfio_pci_private.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

This is a dup of this patch:

https://lore.kernel.org/kvm/0-v3-5db12d1bf576+c910-vfio_rw_jgg@nvidia.com/

Jason
