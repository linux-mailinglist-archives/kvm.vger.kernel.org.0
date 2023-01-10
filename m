Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C56E6645B4
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238534AbjAJQMs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbjAJQMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:12:46 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B83544CA
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:12:45 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-4c15c4fc8ccso160400407b3.4
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MgwAknOlctLrMePUkU2P1GVEL5JmSpDoBM+ewSVabLo=;
        b=Ykez1Dv/5AXnlGRthGgQGK7VkSC+/gF2BPHJE3Y/bgrRyksdD9EBdP6lYPu6qVEBzt
         w2lvoH+Xi5o/C6w7XHUlhiIsSmnmOUXE1BkcMkugRd9OXUzTMIzMf09cbA1pTrMC1jLZ
         Sg1fYWy1wF7qZaj+eEMVxAWcw2CwMsoJvCge/cfnm1rc5h5DFN5Vvlz13fITfa8HlDSD
         pYTo2fE6t4umSph1jPPwqESiuKCCWmbP4b7TVEHh5I5xMLNgL83ZeeE12TNpqRnnUSuc
         5Mx29/H9Z24Y1tyTAtFWsM9c4HelvnMUL/ztyFac8DyGMr6KsOj2YFYpEYrKYDyUjGoA
         jtHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MgwAknOlctLrMePUkU2P1GVEL5JmSpDoBM+ewSVabLo=;
        b=Svkmz44932RbQmZTez8YGOQNrZl9GAfETyRFLMRk41Pvtu2jPbha1pHivA/cR2SIs6
         gDixooXUYpXxcwsu/l3w1Tz0EsfjbcK5Vm6iZ+ocaBFk4qbJM2o0dn7tdTrma8MWBkUi
         1BMMWzdAacMwzctZCV4UwpHPCWshwtT+fL7RUrQdZztKpaJAWPeqryaDx4ym5Wly/Pkf
         sHoNYmT7Rf02J+nDoFeGHolUd8T0YNDOSPzqI7cz/omO1/sDaWd8lVPMKNjek1184psI
         iJGGWuCT7Oy+surUG+syBfLMcfZsCbIKr1XelRaCUQ11g1YL3yS1+jt7tCVxPQKc9Ah6
         A6zA==
X-Gm-Message-State: AFqh2kros/rhrkuO6KMdH6v0EsufnXkr/uloOFfJU2woJ2/xf//1l17m
        uukVmL+Mgjj5sLAkaP6zsAMAAA==
X-Google-Smtp-Source: AMrXdXsuSEzI44k2qcLpE72UZZhdBtulKRMTc8zthZKV8IXvS0s88CzrCP5eZzn+A17YdxSUVPnA8A==
X-Received: by 2002:a05:7500:6a06:b0:ef:bcca:6a03 with SMTP id jv6-20020a0575006a0600b000efbcca6a03mr3043243gab.52.1673367164756;
        Tue, 10 Jan 2023 08:12:44 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id l23-20020a37f917000000b006fc2b672950sm7352446qkj.37.2023.01.10.08.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:12:44 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pFHEx-008QMx-MO;
        Tue, 10 Jan 2023 12:12:43 -0400
Date:   Tue, 10 Jan 2023 12:12:43 -0400
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
Subject: Re: [PATCH 3/4] vfio-mdev: move the mtty usage documentation
Message-ID: <Y72Oe//xESaLdTLn@ziepe.ca>
References: <20230110091009.474427-1-hch@lst.de>
 <20230110091009.474427-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110091009.474427-4-hch@lst.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 10:10:08AM +0100, Christoph Hellwig wrote:
> Move the documentation on how to use mtty to samples/vfio-mdev/README.rst
> as it is in no way related to the vfio API.  This matches how the bpf
> and pktgen samples are documented.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  .../driver-api/vfio-mediated-device.rst       | 100 ------------------
>  samples/vfio-mdev/README.rst                  | 100 ++++++++++++++++++
>  2 files changed, 100 insertions(+), 100 deletions(-)
>  create mode 100644 samples/vfio-mdev/README.rst

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
