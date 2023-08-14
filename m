Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D541C77BF52
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 19:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjHNRwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 13:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjHNRwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 13:52:07 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FF4195
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:52:06 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-40f0b412b78so35649491cf.3
        for <kvm@vger.kernel.org>; Mon, 14 Aug 2023 10:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1692035525; x=1692640325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t1hvwKn0H2/PSZbR/GuIJU8CyNs4zCnJXFN0bPnDDdo=;
        b=WqkPJVkEzuJiuWpVE0xvrcozBY6JRrVXbB15phXMk0uV2pBPmu5MxooBqyy4BoTlZe
         F1guXaemacE9gvxE2gszsGmpQ0/9y+xXNY8lmigpX73Ev797+3wjgFcciGhpUIrhtg5a
         EdsWWn5R0nyka0voliDSW35s6leLT93sIhtjsfMZKBH+bW48AMzarHiVDi/dMd4W9c+N
         ZFXbBCt7swL8urtEBQLlIpm/qmW3nEYHGPamzgpZH0+SmsXKweJ4yDZwtdvc/KIwbpOz
         qDTSe1T5c2S7YXCoqgRXJ03L82/rQM6kshsuAc7lc36XK+kDptFa55Inz33tG/Y26yAW
         aDxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692035525; x=1692640325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t1hvwKn0H2/PSZbR/GuIJU8CyNs4zCnJXFN0bPnDDdo=;
        b=UXftETThozf24Fe9VgZFSFgp6iZZYKRnx3j74ngo7dN4Z1jbgrVGGA9pQy00A8VkZP
         NPBHxIy8kB/hs7b2FG4dklbDcWMvM6g/LHdOrahXzywoWCRNawYB+iUKlMGHqTrJmqVQ
         hMlziGQqPMnGCA+GbpmY5rSGf7DMsZHs1m3cR2jBAywLf456SSs9hxoa2gXxj0SOG/tP
         Q+WINHCf4gWBPAwi32G3N7Ie6OU9PbXOQewm0AtBGBOklukKd68SWHaw7FnqT3BRHRlB
         JrNzpP++obsK7FLQECwFvl1lWePxXjv++5qNZyHj8wNji1nLYI4wjXap8UMNFj8p7TD0
         sDgw==
X-Gm-Message-State: AOJu0YzmdvNaeZ+eF6UxEon2b8v2US5zpuFqg3mhLdCQlOlOCiryawt9
        FaWc5+pGZGaj27fVbWPX4bqAag==
X-Google-Smtp-Source: AGHT+IHtvhyjY1M4UiRth3J5O18+VLDvzJc4L+UzfAki1qDfw/nksYwiXhRbm5fSVj+QoTS+yY0ZQA==
X-Received: by 2002:a05:622a:552:b0:40f:fe6b:6b5b with SMTP id m18-20020a05622a055200b0040ffe6b6b5bmr15011085qtx.66.1692035525779;
        Mon, 14 Aug 2023 10:52:05 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id pc5-20020a05620a840500b0076d0312b8basm3147781qkn.131.2023.08.14.10.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 10:52:05 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qVbjY-0070E4-Di;
        Mon, 14 Aug 2023 14:52:04 -0300
Date:   Mon, 14 Aug 2023 14:52:04 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     kvm@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 3/4] vfio: use __aligned_u64 in struct
 vfio_iommu_type1_info
Message-ID: <ZNppxC7HRLgd9hyk@ziepe.ca>
References: <20230809210248.2898981-1-stefanha@redhat.com>
 <20230809210248.2898981-4-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809210248.2898981-4-stefanha@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 05:02:47PM -0400, Stefan Hajnoczi wrote:
> The memory layout of struct vfio_iommu_type1_info is
> architecture-dependent due to a u64 field and a struct size that is not
> a multiple of 8 bytes:
> - On x86_64 the struct size is padded to a multiple of 8 bytes.
> - On x32 the struct size is only a multiple of 4 bytes, not 8.
> - Other architectures may vary.
> 
> Use __aligned_u64 to make memory layout consistent. This reduces the
> chance of holes that result in an information leak and the chance that
> 32-bit userspace on a 64-bit kernel breakage.
> 
> This patch increases the struct size on x32 but this is safe because of
> the struct's argsz field. The kernel may grow the struct as long as it
> still supports smaller argsz values from userspace (e.g. applications
> compiled against older kernel headers).
> 
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  include/uapi/linux/vfio.h       |  3 ++-
>  drivers/vfio/vfio_iommu_type1.c | 11 ++---------
>  2 files changed, 4 insertions(+), 10 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
