Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1515C53F2BE
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 01:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiFFXql (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 19:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiFFXqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 19:46:39 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF98C03A9
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 16:46:39 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id x16so8254661qtw.12
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 16:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j1H7IqILsLgN2CLXPDKK6acRAfuZh56Xcw12qco3jXo=;
        b=bc9kiCl7t9BZtFVHNxzFELos2shypIE0YUTZCngM0Yp7jg9XtY9c6eUzlTZP2E1Jk5
         AXxKO4dl1Ci4IwS1k/Sh25q55jcee0jvpBKkK95nwry1tJxmgXCek/f5NPaXEhFIuWw+
         4ppyLgdp95IsMou+3NZPE4LClKvKT/DTg56fW9rT9uxjn/L9KpsViEA+dYagM/H74iqz
         PSm9+uW7uTYReIf6JlsHjyweJ0+MaCdVncu97/sSvSqrDeNIudGRAYg5bXmOFBfW8INF
         g/haibEx0ibK72fG0Oi2l0qAsZXAPcwu+MjNxjQpYDlwYQc1j6SktB/0rZzAb4vMeQSa
         QmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j1H7IqILsLgN2CLXPDKK6acRAfuZh56Xcw12qco3jXo=;
        b=usBIOZ4K1NIjWnFjJuXDSgLnGskBGevjoN6IWGP+lEFZn9maaOwrnZEASpkrEYGg6m
         Bftd4VINJ5nQM6PNAk5G8ih3fQ9y5Nhoa3DJ7jYBw6iCKymozIljqhWd3j1Yvx/aw+Zy
         FcGmv7m+Rf8XfkhmCquV2gGTJ4WrlubO9E/KyTBF+Z5cgoCGXYyRo2M6UGH8/BU/ZTE4
         aRfiWk0XKykQlEjs1Nsc7PyExVPWj5DQFkk7wMR+ytzM70AZ8sRBLexImSgEBQMglvmX
         trTj69vrqeINVgQ3TmYawU/ynwywUJbQZWfWfIKqqs0BwvXMHJWnKnNFo2mS4hdW+xbq
         H68Q==
X-Gm-Message-State: AOAM532Xg+pEmMD4TOtFVNsGTKqhey8OBpM8q+69Wpx2nLU347tLHFEp
        Zn49IsAD65HgLDrauklCj3HPEg==
X-Google-Smtp-Source: ABdhPJz68POlk+9eI9qP8Z7p2wfePXMmY+ovCyRTsxy5OMhFkzf6KgrRPgaa4PQPV7u/FDrTKaAJuA==
X-Received: by 2002:ac8:5f0b:0:b0:2f9:3e0c:b569 with SMTP id x11-20020ac85f0b000000b002f93e0cb569mr20105545qta.663.1654559198226;
        Mon, 06 Jun 2022 16:46:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id cb24-20020a05622a1f9800b002fc8a2c14c0sm11031129qtb.66.2022.06.06.16.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 16:46:37 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nyMQf-002q3r-3h; Mon, 06 Jun 2022 20:46:37 -0300
Date:   Mon, 6 Jun 2022 20:46:37 -0300
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
Subject: Re: [PATCH 8/8] vfio/mdev: remove mtype_get_parent_dev
Message-ID: <20220606234637.GI3932382@ziepe.ca>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603063328.3715-9-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 08:33:28AM +0200, Christoph Hellwig wrote:
> Just open code the dereferences in the only user.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/s390/cio/vfio_ccw_ops.c |  3 +--
>  drivers/vfio/mdev/mdev_core.c   | 10 ----------
>  include/linux/mdev.h            |  2 --
>  3 files changed, 1 insertion(+), 14 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
