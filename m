Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0681153F2A5
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 01:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiFFXia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 19:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbiFFXi3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 19:38:29 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA689B0412
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 16:38:27 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id d128so4231492qkg.8
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 16:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SU1Bpkz24VutH49VA7lUe4kyWhTSzOg82FW0ZiHgnzQ=;
        b=WUJN3PF98AmhnA9EnEIdGSfQ5ddQCk1y/4KLpggWx8LwpBQi4LI4gzsx6iazkzR8PZ
         cEfJk//4+Lnkx7Mko3HcmLj6+pnY/fOX7GfVZGwcM9We0Zc6O6MtTUsRjz6d10a/dk0j
         5A1rEl7jBhWHvzx4R7XAkT/NianJ6tYTcRYGSkN0RBiJVzefXBSVFUNLCPnmM+cAaEhy
         L7zMeGOack3Dn6a7dqz6pg8urZjq0mve71gJxnafaNfgNPJGtTCKQi2F93fG2N2L5VRo
         y/P3npTUwVoVAd2aPR78f0TyInxB0HJ1H0/vAhR6M0nAXppHqovFRhUMa2qfhtTKnOE6
         MxYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SU1Bpkz24VutH49VA7lUe4kyWhTSzOg82FW0ZiHgnzQ=;
        b=nevRiIPz0RxvigGg+B2amr+VcsOMumAvm8xixGiMj1s0Et63V7Oo04iMqBDukctYOQ
         lFu2EEBCee5p60QJovlOAVm4ar00u1gL8mRFHDQm6YIhNYXRIj7erNmae8xIZfx2LRqW
         NGB5qCpfnO93BF4GRv36Y6V3dT9otdv4UPYPYKF0Xqx8CDUShmTyiiql3ZkO2kM0q1va
         wsRkwGfBM0p0uTJptsK++pRUBxfOBCDg6rt3xrXOfHxMc0W1JHo+SLXFs9AHXbpk+LYo
         7/yZZ5vJzj4oRs6a+OowKcVQtzm9RKaVy4tKYAZZ4P5Q94V4ZwXzKm/tgo86irHE/o80
         tNgw==
X-Gm-Message-State: AOAM5320mG0DgYl74CHUest2u0kZglzOcOIOFyQPnJiZ4PQk3SLs77lQ
        cTsRJX0Tb0o7UDElzDTlkU8low==
X-Google-Smtp-Source: ABdhPJzNb5TbcgQHOD4e1Y+ahg3esfZR81+kv/1bIwhxqm8jBZqA+IHLjSD8w4ADYCCosG/B97s89w==
X-Received: by 2002:a05:620a:25cb:b0:6a1:136:a7ed with SMTP id y11-20020a05620a25cb00b006a10136a7edmr17667931qko.531.1654558706881;
        Mon, 06 Jun 2022 16:38:26 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id n79-20020a374052000000b0069fc13ce23dsm12539098qka.110.2022.06.06.16.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 16:38:26 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nyMIj-002ps2-KS; Mon, 06 Jun 2022 20:38:25 -0300
Date:   Mon, 6 Jun 2022 20:38:25 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 4/8] vfio/mdev: remove mdev_{create,remove}_sysfs_files
Message-ID: <20220606233825.GE3932382@ziepe.ca>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603063328.3715-5-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 08:33:24AM +0200, Christoph Hellwig wrote:
> Just fold these two trivial helpers into their only callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 12 ++++++++++--
>  drivers/vfio/mdev/mdev_private.h |  3 ---
>  drivers/vfio/mdev/mdev_sysfs.c   | 28 ----------------------------
>  3 files changed, 10 insertions(+), 33 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
