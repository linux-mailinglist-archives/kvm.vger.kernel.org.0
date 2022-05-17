Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCCB52AB5B
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 20:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352446AbiEQS65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 14:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352449AbiEQS6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 14:58:52 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F19250E1F
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 11:58:48 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id e17so15026317qvj.11
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 11:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5OEZwf1a6NBQqaSeB1PoXjAnNB9RAFDi45J9mVUY6Mc=;
        b=QBzP1DKPQbqGKOwIfmhQEGqpBNec/goHk3M1uethuYOR4H4TVy1TNG+78Yg/EfeA1p
         O+QpBBWuxfJOO+9alDPgCh5Wk9mjLu3Lbb8GCkY7c4qN8WlXwMU0bFf/egc3hRMqfjE+
         EqGiD6xZ/1RHdO8SzKC36Pf9IQqc8EFp5KZQYk+z2Um4RaWmAU2y2Y4r4Mlz/khF4X+Z
         hay1CaKtA7G71htZGUjME3MNwvc90lKl8CGYiub7BwFlRXjiz3qFqFF7MgMpwpN6tHi9
         4GdIvK/cJD17qDjaEhk+0wX+rdctJcJ9XKT12PLSxgUkl+jl5APFbAv2TRNCxKzqzF06
         qorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5OEZwf1a6NBQqaSeB1PoXjAnNB9RAFDi45J9mVUY6Mc=;
        b=UwfSU3lhdOAZkAb9vKajA3tuDDbXUSdAHubZXKl3kqmVR4fh0h6Ho+/9VyaBxG1Q+F
         VLPhsfztPTIZbuEEsFc60fCYlR9HsVpDuKuhrc08/HaTzbQpZkDI3pVAylb6SzxgMzx7
         /OI8puJpav/wnISZJ9xuIRxuWHDsS8MxoFAxIIzf0B6Im5VSoVgTiq44I8FEO+vRgZxI
         QsaRlv5YDq1n0ppGrH0JaFjzYXQIMBs2Kq8nh3OeNKqtv5935EpWTVJoQ5Kv5jpu23Dg
         f6RRwQ4vBLLd5OHViCuNA1/mcI9yv2bJxibEv/fGYqImkR/Xw1Ce5ZfF516Ec5rXsGdJ
         f0HA==
X-Gm-Message-State: AOAM530JdPPJAF4mgv8oBP70wMMjdqzZvIQQkprwKwBM1DYAobLehutF
        DZDK8dO4FBlXSPST9gI+Fb0C8g==
X-Google-Smtp-Source: ABdhPJxr5Ef+82N/c8d7IbPg/4dPHISlmDsbtldITmrHL2THC7jy03ei/LC/QmSZlidmIpqFFDc9SQ==
X-Received: by 2002:ad4:5aa1:0:b0:45a:af34:4dee with SMTP id u1-20020ad45aa1000000b0045aaf344deemr21321686qvg.115.1652813927373;
        Tue, 17 May 2022 11:58:47 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id l18-20020a37f912000000b0069fc13ce20asm8575857qkj.59.2022.05.17.11.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:58:46 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nr2P7-0089GX-Qd; Tue, 17 May 2022 15:58:45 -0300
Date:   Tue, 17 May 2022 15:58:45 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm/vfio: Fix potential deadlock problem in vfio
Message-ID: <20220517185845.GL63055@ziepe.ca>
References: <20220517023441.4258-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517023441.4258-1-wanjiabing@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 10:34:41AM +0800, Wan Jiabing wrote:
> Fix following coccicheck warning:
> ./virt/kvm/vfio.c:258:1-7: preceding lock on line 236
> 
> If kvm_vfio_file_iommu_group() failed, code would goto err_fdput with
> mutex_lock acquired and then return ret. It might cause potential
> deadlock. Move mutex_unlock bellow err_fdput tag to fix it. 
> 
> Fixes: d55d9e7a45721 ("kvm/vfio: Store the struct file in the kvm_vfio_group")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  virt/kvm/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks,
Jason
