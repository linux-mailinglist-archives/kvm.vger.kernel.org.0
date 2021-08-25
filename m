Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7E13F6CA1
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 02:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbhHYAaW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 20:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHYAaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 20:30:16 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CEEC061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:29:31 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id m21so25235830qkm.13
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V5mTUznFCqtdTNIveY/eE2RMb0PnUbEAJ5SnKY3J21Y=;
        b=L2rG1RTSBa8GTG5tJcn5hIeel9gC87noTcVmj+IRDQq8tvUb1P4T+7d/gCwuh3DEgl
         vsaHIlQTAZDIYkeTkXa4hBELmynfDmo1pIHGxT5LaUE7WUBcOYGlm8HLet2w697n8iAU
         4IBWA+cJQqVIq2bNTCBdXxUWW/s+JWecsEGMJjDriPvVp0pz6dqaBXiP4lGUp7Og2h9t
         MEghk8+a41qhRojQGMgNLVZ+mL30OkJaXQAA00A9zR49aSQEJotgeVDjVUfm4YTecK7r
         cOLlXkN4napOx1Ue32UwZRUb1RJccJgwd5q29f61fFIn0q1fG4TFduac33aSbpIUI7DW
         6+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V5mTUznFCqtdTNIveY/eE2RMb0PnUbEAJ5SnKY3J21Y=;
        b=Sof17Ig/T6Ll+HjWivQlkQMHIJ1wnHJvng6yUnNIxK/AZ5cHZt+A/0xvcmBAUfR5D3
         ru8WLqWKEZHFpHCTugjDnvGYoTecCRAKq6XwvrTJX84lyv+RtPnjCrrhaiECBWLLHR4q
         9hIlH1aEksveatUw5Zy2RTwvJsQnaDHUHjePHfGc67ORZ3mAB5yUVQGcyG/isACoOGim
         qwX3n2lHAkL2tPJWQR9c0idU9dgev/yMVV5Hv6zZfLxPyyOVZ4LQeIDAw4IDUX1z0uX5
         tdE5hVR8xzA3NxmoGFe8uUMomBicHrPgAmkvXSe7Sx/4gY+VpUHAmUs4+iD6wniKqwTz
         PpbA==
X-Gm-Message-State: AOAM532dkpMt1ZCibu0Zipxj4hlFdtvOwChysJ8DXakSOIZboNd6efak
        2q6stqhKa+INO1afmRQRKMo9rg==
X-Google-Smtp-Source: ABdhPJzX9dC1361DfA5yptSNWxoZqIKexgKrFu6h0WA/2Q1ILrhp94zPIWccdYsMkxoEZtdlpGUJhw==
X-Received: by 2002:a37:a104:: with SMTP id k4mr29365917qke.382.1629851370856;
        Tue, 24 Aug 2021 17:29:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id t66sm11880569qkc.3.2021.08.24.17.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:29:30 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIgnJ-004jAP-Qi; Tue, 24 Aug 2021 21:29:29 -0300
Date:   Tue, 24 Aug 2021 21:29:29 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 12/14] vfio/spapr_tce: reject mediated devices
Message-ID: <20210825002929.GS543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-13-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:47PM +0200, Christoph Hellwig wrote:
> Unlike the the type1 IOMMU backend, the SPAPR one does not contain any
> support for the magic non-IOMMU backed iommu_group used by mediated
> devices, so reject them in ->attach_group.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio_iommu_spapr_tce.c | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
