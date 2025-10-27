Return-Path: <kvm+bounces-61169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D3E5C0E266
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 14:48:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0E1D42199D
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 13:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A4582E2EEE;
	Mon, 27 Oct 2025 13:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Fh7MzK7Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B292E25C838
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 13:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761572352; cv=none; b=MTM7GQR5hKxjOSbbeRxu92PSmAHDhI2nPkVCrFuMy6J2TUxhP2sSCtFr6g5Zo4+vtxKyNTFxAUf/fzEZXa+KeoY7VetKQYUfWL+AhgHIpwZQbYqQv+NWCEJ2J1GWR7YqLlFO9qdJy/5M5Pw8rqjxfQc49FrhlXaAmxhZyMHwZG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761572352; c=relaxed/simple;
	bh=DrMgdbkeAXpGtDwPpAb/Vgeub4TvwtXcw149FCkVBvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yse8aWTJiMkJIJrlRg+iQgfCvWXLQhjjHiIE8QOy8fe8rvRUOzxzLFLB8f2PxnsBxGalyojPFoBEBa+Tgivhgl7BTifjGumX3eLf+mwSYUdQCrhYiT0GRCEov7Npf3xrRfP1013wx5xT7Y/5v1dtqfVZgDnk324Q/9fqhkPGVJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Fh7MzK7Y; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8a479c772cfso55749685a.0
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 06:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761572346; x=1762177146; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dNkoF/gkgZc4g4sej3nOYR+b3B4yGNdCwv3Dr1zemYE=;
        b=Fh7MzK7YIa7DfDf/NRbhdvQzvCA6wwvJWUy7cBvr4Plz9V7XmagISz2CZLAVlU+ocQ
         ajWNxfUxE+6VWi4sUSN8vH2uhKKMwSekBnzWTU9Ro5YA+ejzwUc3O/uZeANUu4cr//DY
         22Pqy5UNRLrR4Z4Bx4cuHfBs2YG4BE9zj/Tj12HAzm1SPi5iJLPl9EjVm/1w1Sx7BxlV
         7vC87Sprcla+WEO6IBGmwbB6gJ0xm9hUvFbuSQ+jrWHdc3jItvX8vrn8sRch4WipX5+D
         OGNd0wZExyawk793F1cDSxw64TGuh6qslQdgDaH7L2qDQqwkdIQ2IQWMce/4pTHk+3+a
         oHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761572346; x=1762177146;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNkoF/gkgZc4g4sej3nOYR+b3B4yGNdCwv3Dr1zemYE=;
        b=W/8zmkPUFxw5Ivrfa40hScV0CqfrDyHXKcl0iAzu0rCR7cKg+15KUva8CjqiTMUMTV
         nhFOoy5VTC6KNVLdk8XDHtHw4af73y0MaY/KnLY937ywZ5fjrUqKoyp1pevumsIieEP2
         ArU/AblBUpnKu8BQEG0rav3xxQ5yS4VlkYmaM2sNpCxVkxAPTCiTBPI/wT0v4aQ5I+bS
         79ZQcoqCbUiyoU+OFsdP8Fa7wdJ7bu5mBhgOelpVi5S9X7dbwJyeqPEmi/+zNweAfJQM
         QJIz+Hd12s4QhEJWN9m4AmAEzEmvu18BOKMMzZ1K3g7xlfrRJ+w0es7gFSdUg7Om3nuk
         Zc5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVXAlamvZk3vXSJeFez5owARBfNSBTM/Tj/DGUd4uBbF3vJjebBR2h3FwuwM6hEoBVZgvw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwT2m+AftOg9neoYLSx4kcb6UG+v2J4nCtP2+odEGJWDKbA0F74
	zSDNt3IXahnixhriIcbsKVIhLv3Xk3nWuBnBKAclKnJEIq+AwwrsEQMFnRQVWygFxqE=
X-Gm-Gg: ASbGncuk1v6uN+WHrWwRMD072bcrwcNWJHVQQKOlVsfKtvoCcHi4QskojwrnzXHSO7K
	PGRmB69gU1O+OG4hHoEl9JgJKbI+LOwC1apESvoa8Zr9GcwCrbQFi+OR1QjCxZmzfRGjCPopuNB
	JF89Ns9pC5n1M4UxQ1L26qjvbOJa/wJDF9VnXZdiXLo9xej6oWM/oF8UmWPAyow9lvj9tEGyAXQ
	VIgltIvJyjyG2F6dLLWXeWiI5NUbKf33jwgOkLGtPxMkcRX0jQ9SZ+CUUXfG2hHuStkBsgOTKni
	g/Se26Sm7uy1Fddfx13EIJdpHIsGYiNYQ/V6Tbhhpn4kEC4zzCgwyiVstVXCRu+x1KeS/Lxh9Uy
	rA1uiM4bpPHNK+FIzSJnDgIhDRuYTcNKwr4PzX/oSEJU1OmUs4kVYeNtvzfvCPdREBbt9Z3Micl
	ChpGK0RevGBXwm01aZ0wdpL05rfTvf6EVkdr7RCdu9Y4Q2i2vZ7UpfvnFM
X-Google-Smtp-Source: AGHT+IEvPD8Xv+HWH7vG+G5rqjY4Q6Du/D6ZeZRFIO7syuVxh5kiJIEGRCcGkZt+ToBw6XHQJbRf3g==
X-Received: by 2002:a05:620a:372a:b0:88f:315:4c36 with SMTP id af79cd13be357-8906e8b00c8mr4598524085a.2.1761572346084;
        Mon, 27 Oct 2025 06:39:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f2421fc6fsm597656885a.9.2025.10.27.06.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 06:39:05 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vDNRA-00000004F6U-3Inv;
	Mon, 27 Oct 2025 10:39:04 -0300
Date: Mon, 27 Oct 2025 10:39:04 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <20251027133904.GE760669@ziepe.ca>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
 <aP0S5ZF9l3sWkJ1G@devgpu012.nha5.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aP0S5ZF9l3sWkJ1G@devgpu012.nha5.facebook.com>

On Sat, Oct 25, 2025 at 11:11:49AM -0700, Alex Mastro wrote:
> Alex and Jason, during my testing, I found that the behavior of range-based
> (!VFIO_DMA_UNMAP_FLAG_ALL) VFIO_IOMMU_UNMAP_DMA differs slightly when using
> /dev/iommu as the container.
> 
> iommufd treats range-based unmap where there are no hits in the range as an
> error, and the ioctl fails with ENOENT.

> vfio_iommu_type1.c treats this as a success and reports zero bytes unmapped in
> vfio_iommu_type1_dma_unmap.size.

Oh, weird...

What do you think about this:

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index c0360c450880b8..1124f68ec9020d 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -707,7 +707,8 @@ static int iopt_unmap_iova_range(struct io_pagetable *iopt, unsigned long start,
 	struct iopt_area *area;
 	unsigned long unmapped_bytes = 0;
 	unsigned int tries = 0;
-	int rc = -ENOENT;
+	/* If there are no mapped entries then success */
+	int rc = 0;
 
 	/*
 	 * The domains_rwsem must be held in read mode any time any area->pages
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 1542c5fd10a85c..ef5e56672dea56 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -367,6 +367,8 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
 				     &unmapped);
 		if (rc)
 			goto out_put;
+		if (!unmapped)
+			rc = -ENOENT;
 	}
 
 	cmd->length = unmapped;


Thanks,
Jason

