Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7048E2CB86E
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 10:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387937AbgLBJQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 04:16:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42970 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387875AbgLBJQP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Dec 2020 04:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606900488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U9a9tAI3X6AQ7BbNAQh41bnDnft76uo4aSQuO918v3A=;
        b=GjV/fhrlefvtntyljA4WlfAd1Hi+Ua9oU+rmijj8b0U13+zJTwRRz+zFtfdmOSyW80sBSn
        8LGYhrArTkFYuTpR8VoML8ZFNB1lF9Nmedo95pd8fMZjH3P8eDcsV0C0xoqop0scLJgphr
        w9PgjXlViEZBWV4x/Q8hwKLmlxKSUBc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-KWmSXfneO_yN9FMMzWt9mQ-1; Wed, 02 Dec 2020 04:14:46 -0500
X-MC-Unique: KWmSXfneO_yN9FMMzWt9mQ-1
Received: by mail-wm1-f70.google.com with SMTP id a205so2320028wme.9
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 01:14:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U9a9tAI3X6AQ7BbNAQh41bnDnft76uo4aSQuO918v3A=;
        b=SE8L6z1DfKEgBpAMK3ewRi9yEgE9A+kjyBUcnXaG93eJi8+RWW/HYfRrLzpItmGZJt
         7IlVhrJdSxt3VdUr0Ssi+l8osRe7qZm73zQbAJppB5XrINwXCp+JUCzvnsfd9Fb48HNX
         doFEf7xFkHUm9q5kFnjEZkay6D4BfSmzZUF79g4pDUTk6hKkM3cLzeecnf6GvBVP4Lw6
         o6c+FXbdOHuzzBFt8pGBT7tfoXrDAe/wLMCmDeMnkog12cT8OP5ZncoTRACC1VbufVRz
         yrkSc0+MQB2z+ipbpRDiaOERIoU/oHaQdNfxGPLQ4DDA9FCOAPf4JgFLHFYxyPdQOMcZ
         bIQw==
X-Gm-Message-State: AOAM530gPLaXd5gjTwoeaYiNmpDxwU1P8BB0OPME4BhRzMCVoOeDfN8X
        bYPdTl9WbPeP44fMznblr8uj1rmlwBVrONqnu3+DXbOjY0P8KNbqju8K966lQqFq153vnHs0vlt
        3paee488G4w+R
X-Received: by 2002:adf:e502:: with SMTP id j2mr2176102wrm.73.1606900484142;
        Wed, 02 Dec 2020 01:14:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzd3N1Nm5NWQ2An7EyFTzWrqD8MOKunvrEEb+jceRXUA4xdhvoPsOzOY8Ht3HU/mYz2O+pQ+w==
X-Received: by 2002:adf:e502:: with SMTP id j2mr2176087wrm.73.1606900483978;
        Wed, 02 Dec 2020 01:14:43 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id l13sm1247289wrm.24.2020.12.02.01.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 01:14:43 -0800 (PST)
Date:   Wed, 2 Dec 2020 10:14:41 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        kernel-janitors@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] vhost_vdpa: return -EFAULT if copy_to_user() fails
Message-ID: <20201202091441.sjds7e42j5ivdcfi@steredhat>
References: <X8c32z5EtDsMyyIL@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <X8c32z5EtDsMyyIL@mwanda>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 02, 2020 at 09:44:43AM +0300, Dan Carpenter wrote:
>The copy_to_user() function returns the number of bytes remaining to be
>copied but this should return -EFAULT to the user.
>
>Fixes: 1b48dc03e575 ("vhost: vdpa: report iova range")
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>---
> drivers/vhost/vdpa.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>index d6a37b66770b..ef688c8c0e0e 100644
>--- a/drivers/vhost/vdpa.c
>+++ b/drivers/vhost/vdpa.c
>@@ -344,7 +344,9 @@ static long vhost_vdpa_get_iova_range(struct vhost_vdpa *v, u32 __user *argp)
> 		.last = v->range.last,
> 	};
>
>-	return copy_to_user(argp, &range, sizeof(range));
>+	if (copy_to_user(argp, &range, sizeof(range)))
>+		return -EFAULT;
>+	return 0;
> }
>
> static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>-- 
>2.29.2
>
>_______________________________________________
>Virtualization mailing list
>Virtualization@lists.linux-foundation.org
>https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

