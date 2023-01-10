Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2C56645BC
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238703AbjAJQNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238618AbjAJQNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:13:24 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888BB59313
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:13:20 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id h21so11153037qta.12
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x8HdjYl9d3A5UtRZZkaER81XKdNBCzjQfeC6yGsuOrE=;
        b=glorSvP3ZSYKGS7bWfRrFsfu0+VqZWJfDLXm9Nu4k+vbYlF5rvIImpO6BFuNNI9FF0
         yxC8H9WniS/t3aDYYeHak6HeFWKKQRlUyKZjToSVBYQourQc8HqrbHTdJRmakOUA9UU8
         8xAnSM6cWKd50XBmlr9eilRJ7JcTT+u6l1Gnop/7GnaGY1Laq0fd9WlpPorODYhxVfcs
         LrJbgGpFOwFd0uHBdKblaiO9SVAEJoS4B7/Zku31cpyFHy875YbOK3Qpg7cFeK684Rsa
         JaAif+UKa/lR95ogFltO1kC09ec26jdxDDjt7D15Kyw47ul/Wjpi/POQxZDHuPNOvKmA
         An1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8HdjYl9d3A5UtRZZkaER81XKdNBCzjQfeC6yGsuOrE=;
        b=vG8saAv3Tm2+Qhx0lz/5tphK0/PqQn0ApB2GpQlKVLse3vEGMtyPpGLcq8ohd8g/gJ
         XCR3yyJT9TzLcrpGUcdj1uqj/nyVdI3d7q8B+O3iYsiZYKWpJa1NM+eukLQK7OPdPEIM
         HWfUvb+PmN90geMEIT4PbqjRUkN9yY2PU0Me2w4ZH9ebZu8hAIXRUyqX0o0GsJKnlhOc
         kwVGkJKGhZMX8BAi87QG8kWd8WvIDNVzivyGAsUBiTlPz+3iei1UFOIMMP6ywG3IMaTZ
         CqiTWSagcIJqwvHUxmzeD2LGtmFd+jb/Egmvz5Z6cat+VOPvST5Qe6UjFUTXgN+WVBTv
         3KSQ==
X-Gm-Message-State: AFqh2koFfjAK5bTyWxfCMUdo8NDMrz61IQoEkMJvy9vr8k4KeCueAwjS
        +Cj9yP3o+weHg5PXLsaN71pE71QGBuyeE8Yt
X-Google-Smtp-Source: AMrXdXtMTCcpIMSNjkZMw3QSJmgRN4agNH6+vzFUc4k0HFtCs58JlRHYTzMqvszrW5N4t34mYrT2fw==
X-Received: by 2002:ac8:6f0d:0:b0:3ad:fdb5:46c3 with SMTP id bs13-20020ac86f0d000000b003adfdb546c3mr9489350qtb.8.1673367199720;
        Tue, 10 Jan 2023 08:13:19 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id m19-20020ac84453000000b003a6847d6386sm6146855qtn.68.2023.01.10.08.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:13:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pFHFW-008QNo-NC;
        Tue, 10 Jan 2023 12:13:18 -0400
Date:   Tue, 10 Jan 2023 12:13:18 -0400
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
Subject: Re: [PATCH 4/4] vfio-mdev: remove an non-existing driver from
 vfio-mediated-device
Message-ID: <Y72Onk1zCjXoVD47@ziepe.ca>
References: <20230110091009.474427-1-hch@lst.de>
 <20230110091009.474427-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110091009.474427-5-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 10:10:09AM +0100, Christoph Hellwig wrote:
> The nvidia mdev driver does not actually exist anywhere in the tree.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/driver-api/vfio-mediated-device.rst | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
