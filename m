Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50163F6CA8
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 02:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhHYAhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 20:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHYAhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 20:37:16 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD50C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:36:31 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id c19so7603505qte.7
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5n4/WEdME1CNnh2ShV9eB42jVtKTdc7UfoTthP2zfVw=;
        b=g0QJeow1lWrOjcu+w+EdevZOdtLRJ9gktANW1+Y7ShC3/KK8RCKyUKzG0LgNxqI7Fv
         PG4BsrxtlAC/V2wogYtMhsXDXOEBAMTZHusm62vXL+6qdMMKlwMZFPXSSeGRml6SsQB6
         7SbepII5C+wn5ZCJcaWBz1Ms5+ilRXvwOn3jPi+B+/MnUQ5WOSCpq8aNOT08F66b8o1z
         TgWozEjFgdP4pDmfKA8H4mLydui6Vwsn2C5ITHsrYa3E/NqF/v6CLpMYAb2/6eL7SVs6
         G/Y4Kq6RZ/yUTfroBlGrx59Q5VVKtHmsScYqnqpPP1hHPab/RSrhkLajn0F/YzwYy+hY
         5X1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5n4/WEdME1CNnh2ShV9eB42jVtKTdc7UfoTthP2zfVw=;
        b=mnANaVhKdiPty51l89+bffoSZ8K7slR4vudSmrF4eciCbU3HNDU6bgEiOVP8BtTvWY
         ++3lLWroZlUSb+mPcVmJObZXsWEEYlp8ExQaG59v5vNi/Iyf4rMPil7AmOcMcx7OGNgE
         Xd7bTRRqKYTHiZtFOsPlxYb97cU2Mg9vQlDUr9e3jN5nH3/WGIXveBTLxYEqJG6x8Bqj
         g6VmrvGpEPO8dFfhSwsMdDQO5qUWnfBEge/HigIWsfLm3UqhAdpMtpJerKjPZjzqBiKo
         Wov3wudLVEPz0jjLjEGF+CGdd80n+SImf473I9JFPceDXrd0FUMp9mT3ee/kZrgrpedt
         N6eA==
X-Gm-Message-State: AOAM532qJruInWEjf2bnziCysUmQoctAnHYJKyepT8AjjUciITLgAils
        fWIkJpzPc5xpbJTVmSWahbpxXA==
X-Google-Smtp-Source: ABdhPJyOFSvHDvmGPUelNIQKvgJUWMCYHooDKOX6Fmkn7+RZsdhvBwXISsIxBobQkq8tgiKWdFeIWg==
X-Received: by 2002:a05:622a:50:: with SMTP id y16mr37885858qtw.322.1629851790970;
        Tue, 24 Aug 2021 17:36:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id x21sm11774851qkf.76.2021.08.24.17.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:36:30 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIgu5-004jGu-S0; Tue, 24 Aug 2021 21:36:29 -0300
Date:   Tue, 24 Aug 2021 21:36:29 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/14] vfio/iommu_type1: remove the "external" domain
Message-ID: <20210825003629.GT543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-14-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:48PM +0200, Christoph Hellwig wrote:
> The external_domain concept rather misleading and not actually needed.
> Replace it with a list of mediated groups in struct vfio_iommu and
> document the purpose.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 123 +++++++++++++++-----------------
>  1 file changed, 57 insertions(+), 66 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

> +	/*
> +	 * Tracks the fake iommu groups created by vfio to support mediated
> +	 * devices.  These are not backed by an actual IOMMU.
> +	 */
> +	struct list_head	mediated_groups;

Though again I'd prefer another name to mediated here.. These are
domainless groups?

Jason
