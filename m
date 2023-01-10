Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7747A6645AF
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbjAJQMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjAJQMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:12:15 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B9E544CA
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:12:14 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id v14so11278948qtq.3
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eUQYg3dBDnO89rOefi3wBE7nm9H0hG8wxIWiNipOYyk=;
        b=JPGEBvzlxBAbSi/AHoIpkV9vr/mdXPT3xHGGLmduIDko5fsMh1fXMQwNszCP2YkP5F
         NSu9akVDPKRz2H/6Cqt6A6GMwgtTwgcjsAJ0DeHgBiMf1aws6o3OpvC2j1CDQrRa4H/e
         ld4YkRI5GSKBZt0YGU3CERDvSrF7xATImPdr3N4wh2laFOCK57nypcg4ltkOmalWR16+
         Qx2DeG9o5NCHdOFpb5G4EBvPK+DfNMS9Avii+DQ2B4exeKfOwRg0RBibRoVdABWGMv/p
         nKjS+L4ygThbMwD0p+bLtDIzqGxI4zvDjYdKh5Y36k3BpVPdSBVLNbyN8Mi8r1YiDNer
         oxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eUQYg3dBDnO89rOefi3wBE7nm9H0hG8wxIWiNipOYyk=;
        b=3/FgFqXVSbhszPv/s5FO658UtcIW6NuzHAZ0wZcirVEjwHYI88NvYQt+OQZ4PDf09k
         wGPObutBEIOZR9azEAJYEb7p1E3kLQwB82TuMODD48pTQFBL4BJ8pbQ0qbQPNyqcTXIY
         bmNynNzjTeKBW/33cFuqlQv+glWe5W2/53G/Pm+kgEGKlRk3HWC60kIpWFShR4kRsBBk
         /gxu5w9xgfn6gGlsYpdhso4WY8uwAPsi+pplXFaO/nRNOtpCT7EL4Ymk7j3vS3dLDIQa
         siFb/Ayj3CJA3tlkMSjYl5JcK5q6Ukq0FQA4lg7e0VDbiQAeII1Xr4wWMQlmcAwbXkY6
         LoMw==
X-Gm-Message-State: AFqh2krM6L2jCEvd2EqBIPi2K4e35FcGwyjkvt64ILtvhrJXQo6fBJ5p
        ckK+r6d88P0S4rHpP4+ZzmEtcA==
X-Google-Smtp-Source: AMrXdXuELvPZIEFqhFQ2jC/MpgC7MDU3Amu0QT95WZLi9x/ENgvf1dLev0KIaL0jB3Y0XEeWikzHxw==
X-Received: by 2002:a05:622a:4188:b0:3a7:e4ae:7937 with SMTP id cd8-20020a05622a418800b003a7e4ae7937mr100629467qtb.6.1673367133440;
        Tue, 10 Jan 2023 08:12:13 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id t13-20020ac8738d000000b003434d3b5938sm6223850qtp.2.2023.01.10.08.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:12:12 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pFHES-008QM4-8B;
        Tue, 10 Jan 2023 12:12:12 -0400
Date:   Tue, 10 Jan 2023 12:12:12 -0400
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
Subject: Re: [PATCH 2/4] vfio-mdev: turn VFIO_MDEV into a selectable symbol
Message-ID: <Y72OXIQJI6yE60i6@ziepe.ca>
References: <20230110091009.474427-1-hch@lst.de>
 <20230110091009.474427-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110091009.474427-3-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 10:10:07AM +0100, Christoph Hellwig wrote:
> VFIO_MDEV is just a library with helpers for the drivers.  Stop making
> it a user choice and just select it by the drivers that use the helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/s390/vfio-ap.rst    | 1 -
>  arch/s390/Kconfig                 | 6 ++++--
>  arch/s390/configs/debug_defconfig | 1 -
>  arch/s390/configs/defconfig       | 1 -
>  drivers/gpu/drm/i915/Kconfig      | 2 +-
>  drivers/vfio/mdev/Kconfig         | 8 +-------
>  samples/Kconfig                   | 6 +++---
>  7 files changed, 9 insertions(+), 16 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
