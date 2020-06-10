Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7C11F5147
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 11:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgFJJjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 05:39:43 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41896 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727842AbgFJJjm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 05:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591781981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0H9JvbVSTDy5EkcBxAYDLVdpZdU6drMIY4wiOG5g/Cg=;
        b=LgiZoQ7hpFwiFWah2o9PgSn0JevR3usDy5lrzkxVlB19C6JdmrOlkwVSfNasly0s21KdXN
        amguAYByArB1UQZPDUG+iOSvVsT3eJwVPpiB9YhsJFvM59zm9QlR1RKq6D+76veH9Z2+YM
        co9vAqol/9yoSdQ00zVju5giMu5E/O0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91--omjCFaDO9eYMTB64tF_MQ-1; Wed, 10 Jun 2020 05:39:40 -0400
X-MC-Unique: -omjCFaDO9eYMTB64tF_MQ-1
Received: by mail-wr1-f71.google.com with SMTP id l1so839405wrc.8
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 02:39:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0H9JvbVSTDy5EkcBxAYDLVdpZdU6drMIY4wiOG5g/Cg=;
        b=lCELSCm40Xs1u8s0mHs7gqR+jQsbz4dpOgUNIy0PDB9kEVw06Sn5LdhUaoCGXunG9x
         l8yUzHnujRESnL9sIxzxOhaUlUA4ks2xx3o4aDjmWB+Qp/E5ds0U+8vj3/VN3P/bxaCA
         57GXW7nea0QDZkl2ks4U/svaoECXyOmxDR2BWCkh+rZYEFMJJpGaBi0tOTbUSRa8WGxA
         RlRml/f7GCTVVeqEIEKPklqtqKD7v4nOrls+qiFxW4VTuWJ1ymDFt9YXbtiDNNBL8sWt
         rN988XqISM7rXUW/gjRkOJYnc/GAxBrv5YUaNblx5Hnb87iFgZCuDIVt2wt8JP8NpToB
         bfDw==
X-Gm-Message-State: AOAM5317f2hJp9VI62dqFJYSDmtsqPRVh6joO9CN43EWXW1fcfnyIhSC
        krm2Hy1KpUE/ZVsJ9oi59YmNuAxt9z03XVQpq7topFQ0r/4gq46pHaQi02GwvJtrBURpUXzM9eC
        dXC1RisAIJW0D
X-Received: by 2002:adf:f2c2:: with SMTP id d2mr2548441wrp.424.1591781978384;
        Wed, 10 Jun 2020 02:39:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxymu+fkfSsDo8znawTJ6c4VcvlNi7tdHuvNBBytAhcUZ0W/2OrQ3nbVPMH2Y9nzbPs1nQa3w==
X-Received: by 2002:adf:f2c2:: with SMTP id d2mr2548422wrp.424.1591781978220;
        Wed, 10 Jun 2020 02:39:38 -0700 (PDT)
Received: from redhat.com ([212.92.121.57])
        by smtp.gmail.com with ESMTPSA id c70sm5964690wme.32.2020.06.10.02.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 02:39:37 -0700 (PDT)
Date:   Wed, 10 Jun 2020 05:39:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vhost_vdpa: Fix potential underflow in vhost_vdpa_mmap()
Message-ID: <20200610053926-mutt-send-email-mst@kernel.org>
References: <20200610085852.GB5439@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610085852.GB5439@mwanda>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 11:58:52AM +0300, Dan Carpenter wrote:
> The "vma->vm_pgoff" variable is an unsigned long so if it's larger than
> INT_MAX then "index" can be negative leading to an underflow.  Fix this
> by changing the type of "index" to "unsigned long".
> 
> Fixes: ddd89d0a059d ("vhost_vdpa: support doorbell mapping via mmap")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks!

> ---
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 7580e34f76c10..a54b60d6623f0 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -818,7 +818,7 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
>  	struct vdpa_device *vdpa = v->vdpa;
>  	const struct vdpa_config_ops *ops = vdpa->config;
>  	struct vdpa_notification_area notify;
> -	int index = vma->vm_pgoff;
> +	unsigned long index = vma->vm_pgoff;
>  
>  	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
>  		return -EINVAL;
> -- 
> 2.26.2

