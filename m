Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9EF3F316F
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhHTQZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:25:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhHTQZX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 12:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629476684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w1e4qB5RMU7aXzGNfv+j0VarkguA7CL6ObkynUsQwd8=;
        b=K5qbGTia2DpjNP8QHyyKYtkzJvlkU9M8B9+UPNcX3+Iw9e99L1OZKo8teBx3FUCD2SWGE7
        t0ncRtMaCGl8h0S6IeqvngBwsCzf68N8A6I27FRBIpq75D6FoRIakErvzQQw+3llHaBOXE
        kOllBekIGvqSR5QldPpaAVxW62uwjwY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-fgAnJ1pcPIW7VJ2472vCqg-1; Fri, 20 Aug 2021 12:24:43 -0400
X-MC-Unique: fgAnJ1pcPIW7VJ2472vCqg-1
Received: by mail-il1-f197.google.com with SMTP id c4-20020a056e020cc4b02902242bd90889so5667369ilj.20
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 09:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=w1e4qB5RMU7aXzGNfv+j0VarkguA7CL6ObkynUsQwd8=;
        b=sr9pvzUcxvoGWXhosIdmqYvJB2Pi1XklFNT1OwwDN0kaIAcsH+Ua5EXX5ucgsmBWcA
         QUbHx2sUV/Oey6DVNWmFYs2OFaVsskQxg5DvKEH6btt05PXmKBGp49gRxLh6POQxj3l3
         +NZA1vBP+E63GI64zkN3X0crNmvfWdhrnhP6byAVh4SamG9DoEtC6Zrl5WIszg7NSbLA
         xpbV9IwYpRNotEtXHKIVBpc37T3BeQTiewIb0Nz3pIw6KsimGY6+Ep5GsFG/etCyJ/gB
         iJYZUDoG5v7HdOkSoXgDYNGpnztLc0bedtwW4ab8Lmm1Xr2PtAiM8AFnCqecJ630Xsq0
         bayQ==
X-Gm-Message-State: AOAM531iN/sHK2xMUt2RecYnTIS6noARzGG7jq0HnZfCMXuO4pVILAhF
        X9h6a/SOGWpc9SuNnz8ZkNT5r3bcptGvKUDRo6+ZHoWizWv4icgyohh4JTRHb7CvIpCmr4anKYR
        cQXbSyAxYBs/s
X-Received: by 2002:a05:6602:584:: with SMTP id v4mr16444829iox.85.1629476683141;
        Fri, 20 Aug 2021 09:24:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyinVHTZOgsJMbcLoWYIxOCztJIL/snorIX28ZHrHWywdsK6S4Nu7iVcKJVAvQrf5UrBhbxJw==
X-Received: by 2002:a05:6602:584:: with SMTP id v4mr16444809iox.85.1629476682899;
        Fri, 20 Aug 2021 09:24:42 -0700 (PDT)
Received: from redhat.com (c-73-14-100-188.hsd1.co.comcast.net. [73.14.100.188])
        by smtp.gmail.com with ESMTPSA id q15sm3522157ilm.60.2021.08.20.09.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 09:24:42 -0700 (PDT)
Date:   Fri, 20 Aug 2021 10:24:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Anthony Yznaga <anthony.yznaga@oracle.com>
Cc:     kvm@vger.kernel.org, steven.sistare@oracle.com
Subject: Re: [PATCH] vfio/type1: Fix vfio_find_dma_valid return
Message-ID: <20210820102440.4630b853.alex.williamson@redhat.com>
In-Reply-To: <1629417237-8924-1-git-send-email-anthony.yznaga@oracle.com>
References: <1629417237-8924-1-git-send-email-anthony.yznaga@oracle.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Aug 2021 16:53:57 -0700
Anthony Yznaga <anthony.yznaga@oracle.com> wrote:

> Fix vfio_find_dma_valid to return WAITED on success if it was necessary
> to wait which mean iommu lock was dropped and reacquired.  This allows
> vfio_iommu_type1_pin_pages to recheck vaddr_invalid_count and possibly
> avoid the checking the validity of every vaddr in its list.
> 
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index a3e925a41b0d..7ca8c4e95da4 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -612,6 +612,7 @@ static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
>  			       size_t size, struct vfio_dma **dma_p)
>  {
>  	int ret;
> +	int waited = 0;
>  
>  	do {
>  		*dma_p = vfio_find_dma(iommu, start, size);
> @@ -620,10 +621,10 @@ static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
>  		else if (!(*dma_p)->vaddr_invalid)
>  			ret = 0;
>  		else
> -			ret = vfio_wait(iommu);
> +			ret = waited = vfio_wait(iommu);
>  	} while (ret > 0);
>  
> -	return ret;
> +	return ret ? ret : waited;
>  }
>  
>  /*

How about...

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4f7c174c7a..0e9217687f5c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -612,17 +612,17 @@ static int vfio_wait(struct vfio_iommu *iommu)
 static int vfio_find_dma_valid(struct vfio_iommu *iommu, dma_addr_t start,
 			       size_t size, struct vfio_dma **dma_p)
 {
-	int ret;
+	int ret = 0;
 
 	do {
 		*dma_p = vfio_find_dma(iommu, start, size);
 		if (!*dma_p)
-			ret = -EINVAL;
+			return -EINVAL;
 		else if (!(*dma_p)->vaddr_invalid)
-			ret = 0;
+			return ret;
 		else
 			ret = vfio_wait(iommu);
-	} while (ret > 0);
+	} while (ret == WAITED);
 
 	return ret;
 }

