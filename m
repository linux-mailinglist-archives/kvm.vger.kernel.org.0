Return-Path: <kvm+bounces-58926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B97E4BA5F29
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 14:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A14977AC00F
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 12:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5DD2E1EF4;
	Sat, 27 Sep 2025 12:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eZjSpAQ1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380BD2D73AD
	for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 12:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758976349; cv=none; b=BQIVS9tjvL3D1mSUjXXA87IVIMPSn8aDbTiXLnAlpPG8AWGNHXI3ge0YLpq5ieP3M7DaBnlDjWlwhuV05ZpmQXu2TBAbL6mpCLyYL5IYnnfuoC3ejV2IBRfIhQjoj8Wft2yLt645xr7aak+6logxgwzhOE6cFv4Wu7L1TXKaxKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758976349; c=relaxed/simple;
	bh=QXJo14oGqcFFPaCG1vYqjTuy/Ifc9HqL82bjZYd26vg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgaxkTzXT9ZJDYzEfQjnT7pIMmsQOByQDPyl75U0fVjJy2TB+7UUMplDiHfKMuo4oK+r2VSGFWrstvwvvmAhnQLd0GISSi8VZ3mizCfslAj8PHOYlXwRgLxQ0LIQc+2DkkJu83XhR2dLX+dbmSxk6gcOuen5SsZ7GcyJqDGke3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eZjSpAQ1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758976347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FvwU/ByFIKVGNfDOxaWsoSUUnpO5CypDPAdcRbhjc68=;
	b=eZjSpAQ12n9oz9+25HBiyiOLEp1LbS7KiHYV7ZykggsSKZS2N1v1dCNdatBNweJSStClbm
	4zcHLfPVWtSlfQfH1mUSVzZWDpmpIXcphyBLa7o9RpINC62AcAGmMW7QJ40ji9FrlTGVwQ
	jVKGLftnswICrowm6mSv/d3vKp5/Dj8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-bbDpVY2pPqiNHeK0UHHARQ-1; Sat, 27 Sep 2025 08:32:25 -0400
X-MC-Unique: bbDpVY2pPqiNHeK0UHHARQ-1
X-Mimecast-MFC-AGG-ID: bbDpVY2pPqiNHeK0UHHARQ_1758976344
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46dee484548so17936835e9.2
        for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 05:32:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758976344; x=1759581144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FvwU/ByFIKVGNfDOxaWsoSUUnpO5CypDPAdcRbhjc68=;
        b=G8DAxMEPN9Dooy0WBtljoHHMZxF7qtw8Ls3KMcpZqnN6pOgJcg87XloMR1LeARKHIb
         PJhr/wr6KU9JY+O1XwdN/1GKYLKZfCHlvpeo3Qz5IUIma9KvM4VFmvJd7A3yC8ybJCMC
         rLVrvhtE4NKd6eWwFZtPmrvV9k3jivWI74/I1gFhXrOnAsRTm+1ZGvcC2wXSjkK3Lv3W
         ZVyI36M6dWUmlWeLRVW3n110uNKxgMZJ8twp9bSuZQa/YQwXnFWetHQ5OgVKrmYy6bAM
         3z+Je+SLdpvTuuJX91fPz+FIYWjSo/HVCMkPHAniaZN3Bujl96vYArtzebeuYWJhuno3
         3J6Q==
X-Forwarded-Encrypted: i=1; AJvYcCU9fA8hV/9/XVnRGkEMteZQwRMRxlg+tpt07JENX3j0ink2xHGmk8T5OG44DAaUUL3FUp0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0foE0bwBEHvwSZWyWCcFYKe3P2HOtMFCbPEhHwCLnJSFtxMGA
	ZmL9jTxhq/2fhRFSOFoisA04Sru70eRsMy8LCbelMhAqyiYCfrciybiQzBT+JlCUS+VIxStSTnR
	mV0uoiSCok0DRbwx31876rzAC69lfoAPVybrWo0aBjV0zA4QVEdNB1w==
X-Gm-Gg: ASbGncussI1AYLDMhnEgZ91vR840fY10QcUqM1JcsQFk/1TL5vAis7yNnl7HMX7dfKJ
	vh5qJa1pYKHGhSL4fyg/piHztYmq5KhFI4HcS07cYnS7mtuzlbMDuD1ULKWV3Ztf/sx96vwl524
	KaEEaAvzdcmj+rAb6WrtsirnwirIh0OVPvu/JxiRd1WAWAL+BRRd1xr0cEJ5PseYHJF2W4Iq/ni
	+lA0qJLe/ihM9CNXjaoSCLKTdJcZlHJzNO0ymSDBO5FfnTDwJuZvq7RX0aoAkbGvxsN3XEhWtKT
	9Xdgtt5TcHwWrs7e7xEwmiS3VNZsmhx+dzM=
X-Received: by 2002:a05:600c:1553:b0:46e:39e4:1721 with SMTP id 5b1f17b1804b1-46e39e41ae1mr61745025e9.12.1758976344224;
        Sat, 27 Sep 2025 05:32:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTY0fdZdgXRDviUIBptO6FxVugLlKfaDdRO18KVHiVelnbnrO1C0c8G8WlptAx2IChMWMgtw==
X-Received: by 2002:a05:600c:1553:b0:46e:39e4:1721 with SMTP id 5b1f17b1804b1-46e39e41ae1mr61744795e9.12.1758976343755;
        Sat, 27 Sep 2025 05:32:23 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e33b562d8sm111137435e9.0.2025.09.27.05.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Sep 2025 05:32:23 -0700 (PDT)
Date: Sat, 27 Sep 2025 08:32:20 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: Set s.num in GET_VRING_GROUP
Message-ID: <20250927083043-mutt-send-email-mst@kernel.org>
References: <aNfXvrK5EWIL3avR@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNfXvrK5EWIL3avR@stanley.mountain>

On Sat, Sep 27, 2025 at 03:25:34PM +0300, Dan Carpenter wrote:
> The group is supposed to be copied to the user, but it wasn't assigned
> until after the copy_to_user().  Move the "s.num = group;" earlier.
> 
> Fixes: ffc3634b6696 ("vduse: add vq group support")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> This goes through the kvm tree I think.


Thanks for the patch!

IIUC this was in my tree for next, but more testing
and review found issues (like this one) so I dropped it for now.

>  drivers/vhost/vdpa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 6305382eacbb..25ab4d06e559 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -667,9 +667,9 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
>  		group = ops->get_vq_group(vdpa, idx);
>  		if (group >= vdpa->ngroups || group > U32_MAX || group < 0)
>  			return -EIO;
> -		else if (copy_to_user(argp, &s, sizeof(s)))
> -			return -EFAULT;
>  		s.num = group;
> +		if (copy_to_user(argp, &s, sizeof(s)))
> +			return -EFAULT;
>  		return 0;
>  	}
>  	case VHOST_VDPA_GET_VRING_DESC_GROUP:
> -- 
> 2.51.0


