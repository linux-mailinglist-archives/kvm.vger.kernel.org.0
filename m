Return-Path: <kvm+bounces-43253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E410BA888A4
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 18:32:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C79418994B6
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 16:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5575B28469E;
	Mon, 14 Apr 2025 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VrppPEBy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6B42522B8
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 16:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744648360; cv=none; b=tuz+EcTOPPoF89OHz2gLSuU+1bdgfnionvWYnRJ8DcD2PVJ5lhsK1TXGeHJlxjmEyJ9/Dp5ODz8ztEFkEd93U60TQiVnRvtqiKhtjTB0sCjSegqoBRIm4uc5iiEirTOa6rrhRvBCOeJ/ypqJrr3yO/uHzK/yUqtJudB2UlEcXmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744648360; c=relaxed/simple;
	bh=LxeEjXsTzyjmpn+ReNlLxMKLEF/tsQrcB3L0UMTB9is=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GOrTDWn29XpKA4E2LiYUl6cruO3nhdW47pzCusm4iZKLhivawLHmpnMSLSVEqIVbytX/40S/RqRWABU75CaToIgDPcTa/omhPd8IfYstOmPoLaQA0evtHbEOB6cvghr7n2vt15i++4RdvdyoSZcVIUfIay3DHWDveOtfaSmcRXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VrppPEBy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744648356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=psPpYVaNQlJBPoNb/90nh8sbsObK4AuLZcGNe09lj5c=;
	b=VrppPEByuDEadsvSH+p/M1HnQCMj2v5XF6AtS80foymTitPpmiIE2Wd7OklxnBTn8KptjP
	cMjxNz1BJIYJykiYD3CB73znx6OgDQqRRwARqkF/FoecqbhK0Nmhp1qdoAywk9Rs0p/YYk
	4KZxmYhS1mgx26NWN4iNlWa6vHVGH2A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-edv66KK9N5yzJTsHxjH3EA-1; Mon, 14 Apr 2025 12:32:35 -0400
X-MC-Unique: edv66KK9N5yzJTsHxjH3EA-1
X-Mimecast-MFC-AGG-ID: edv66KK9N5yzJTsHxjH3EA_1744648354
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d22c304adso23780055e9.0
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 09:32:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744648354; x=1745253154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=psPpYVaNQlJBPoNb/90nh8sbsObK4AuLZcGNe09lj5c=;
        b=Pea73OAo+nnYbC4DiThsYnflIAHVUzb47beGWJml2/Kr4edbzBexeIDNvdJO5iaMyg
         J28jzFrwXJG7PUYQieHyNYV6FErEMJ+AfsEgvrn7LG+yTH5AJkofGkedq7InnEK4E099
         G3SyOyVIx74DhzNJsK8zK1TvlAX7zaTZC2sDb8cm/Y8nf0jClamDdwRftr1dzgoXyMN5
         QCBCX19XHO3SvLlhZAeotpbBwWL9SZ4nEm89fWXEqCkpVzwWB0xP2LSWCi1Fc3IprvqX
         EZtEw9tJGNWBWZMVGlnSmyeKEqboQB6wdbrdygHXLFRTHooJLhWnMDVA9x0bqlvTtPzd
         8WnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXN1WiyFOnZy5mvBzp6Wb8hb0JZz5TyT4+WklwLTijoI9JPi3QYugC1KVwuL1MMpkZDLxU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoTp++gLG8knRamk9SBdvaEhRsH9w+US4icVgkXQD7gdguOosb
	De2PQbdMIu0FROv7yWIo730ry1lNTXLsr5cM1GRJTh7n2I0hQ0ZQRcRqRX8TBOsoh3ke+VuIHmh
	000JKR8twX8zzv2NAOKbN72+u8CMkf+oes+093Aa4miFSHmTpnA==
X-Gm-Gg: ASbGncuKevRN8H3kgdNW5lq0P7VyrArR1DI7XOFLDezYix1glBc7qoPFxfigXgaHbIn
	4M2fydprcpR2wojMLDXJTnsXSpxbj9VxfkKUoWO1LWk8g91n+VtndwxOVppMhHUdrGsfao9gsUW
	6fjDJzbSItuyM1Q2AgaFQQHjHlEna57mhdhkQDk+XAIVgWXfNNcUh6yWTCzJ2CS5tI/po0Pm+Lz
	V5Q9eq23JU3pnXVlwqeHyOsNphi2hDdsPmJP4YMjy5tY3hCXC23sp6bpoYkeJiMWhdAPSbipR9f
	CH2fnA==
X-Received: by 2002:a05:6000:248a:b0:39e:cbca:8a72 with SMTP id ffacd0b85a97d-39edc3059aamr38188f8f.12.1744648353750;
        Mon, 14 Apr 2025 09:32:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErshira9b65DJz4U+YOoZ2EfEQ5MJmWz7qS8OqJT6VLSYpu4hvsslk7OCkkLLr5Vcu2G6UIQ==
X-Received: by 2002:a05:6000:248a:b0:39e:cbca:8a72 with SMTP id ffacd0b85a97d-39edc3059aamr38167f8f.12.1744648353322;
        Mon, 14 Apr 2025 09:32:33 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f233a2a13sm179644545e9.10.2025.04.14.09.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 09:32:32 -0700 (PDT)
Date: Mon, 14 Apr 2025 12:32:29 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org,
	netdev@vger.kernel.org, jasowang@redhat.com,
	michael.christie@oracle.com, pbonzini@redhat.com,
	stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
	joe.jin@oracle.com, si-wei.liu@oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 9/9] vhost: add WARNING if log_num is more than limit
Message-ID: <20250414123119-mutt-send-email-mst@kernel.org>
References: <20250403063028.16045-1-dongli.zhang@oracle.com>
 <20250403063028.16045-10-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403063028.16045-10-dongli.zhang@oracle.com>

On Wed, Apr 02, 2025 at 11:29:54PM -0700, Dongli Zhang wrote:
> Since long time ago, the only user of vq->log is vhost-net. The concern is
> to add support for more devices (i.e. vhost-scsi or vsock) may reveals
> unknown issue in the vhost API. Add a WARNING.
> 
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>


Userspace can trigger this I think, this is a problem since
people run with reboot on warn.
Pls grammar issues in comments... I don't think so.

> ---
>  drivers/vhost/vhost.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 494b3da5423a..b7d51d569646 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2559,6 +2559,15 @@ static int get_indirect(struct vhost_virtqueue *vq,
>  		if (access == VHOST_ACCESS_WO) {
>  			*in_num += ret;
>  			if (unlikely(log && ret)) {
> +				/*
> +				 * Since long time ago, the only user of
> +				 * vq->log is vhost-net. The concern is to
> +				 * add support for more devices (i.e.
> +				 * vhost-scsi or vsock) may reveals unknown
> +				 * issue in the vhost API. Add a WARNING.
> +				 */
> +				WARN_ON_ONCE(*log_num >= vq->dev->iov_limit);
> +
>  				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
>  				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
>  				++*log_num;
> @@ -2679,6 +2688,15 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
>  			 * increment that count. */
>  			*in_num += ret;
>  			if (unlikely(log && ret)) {
> +				/*
> +				 * Since long time ago, the only user of
> +				 * vq->log is vhost-net. The concern is to
> +				 * add support for more devices (i.e.
> +				 * vhost-scsi or vsock) may reveals unknown
> +				 * issue in the vhost API. Add a WARNING.
> +				 */
> +				WARN_ON_ONCE(*log_num >= vq->dev->iov_limit);
> +
>  				log[*log_num].addr = vhost64_to_cpu(vq, desc.addr);
>  				log[*log_num].len = vhost32_to_cpu(vq, desc.len);
>  				++*log_num;
> -- 
> 2.39.3


