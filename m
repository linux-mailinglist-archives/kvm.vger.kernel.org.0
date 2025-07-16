Return-Path: <kvm+bounces-52596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F994B07106
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:59:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9281C17ED80
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7A92EFD93;
	Wed, 16 Jul 2025 08:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cKNUcUFW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7590A2857E2
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 08:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752656343; cv=none; b=osvC61tfZ/h/3qCttFxhnPgsHsd/jvDh36j+v50/i7G7B4V7SuYrG+iWKq7YooQDzfjy0xykQXZB7eyzFjiN7g2nht7WFGcIUHPMIXHec5b23ufs8uYJSWD466lhACcvbHHGaT8Nj95/9gh84VNKTLGperUf96hMVidYR/Xpe/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752656343; c=relaxed/simple;
	bh=k/xKLRmdytdD5dFxCZPED+uv6Wm4lSnJRb0jKkIgcTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCjZKXR/Z0zF/oJGPzcTK0IcBCyRV1mxNsmNgiY3UDr+Cx/s64IlqjwlYr9hAvCA5a/ifCWYffNVaXWq3S5eKuUYjyp4PaycFgUOXV5K+AxWRElpmAfrYJUErXhs/iR/3DWDcpbDzfGCvq/rxbAdNl3yJGiS8r6qTloZVAcIoSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cKNUcUFW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752656340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BzMG3VIcZp7IpI2SiaxGZq52jq3kQ6ab3CdN8rN3Rxw=;
	b=cKNUcUFWAouNwDAl0gOf3bF/rOaPZpi0uczTTXYDi9TUxmGA0erBytO1CPNorJfFLp3crX
	ncgSHATox774TBfo41j/SBVvSTvo/MWt/pr1ELOAjyET8JkhLcDejjYOk3se7yJzVqZR9r
	QIvAV0ltViE7Oo6GeOohBVl4sItdbN0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-85eCymQ1OA-ZmyDaet6cxA-1; Wed, 16 Jul 2025 04:58:58 -0400
X-MC-Unique: 85eCymQ1OA-ZmyDaet6cxA-1
X-Mimecast-MFC-AGG-ID: 85eCymQ1OA-ZmyDaet6cxA_1752656338
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a4eb6fcd88so4191890f8f.1
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 01:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752656337; x=1753261137;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BzMG3VIcZp7IpI2SiaxGZq52jq3kQ6ab3CdN8rN3Rxw=;
        b=gTlcPcCA6eYAhNAzhz75sdtWi9LgwD5p+WKmElEZln5H5WDEuNCyDu2cgC19fCY5jt
         MOY/6M2NGtyCpgt7Hptu5dWp26FZXkJGLHWJURzwkkqcdGppqQ6A/okfxy4zcohLHRTJ
         QPGoriZ8YbEcbjP4tnuuRYkVfhBDNOxjBuA4UvNkYwpqxA+IoZhI/wZxxNCAqi0zTGiV
         bRARN1U8YqWJfonpUUkGVIq3oT6f7FFBKkCojVR4Pu6ccRiYfj3QesZpAtFZDVcrSopS
         i+fLesZ3J3RJIfn26y/BZjoG/sVZwAzAjyNEh5oa2BDb2aTf/eEzsQec7uD/miD9XcpW
         TxXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5L28HWK5zQQM/uHO64ym85mCToh/SzTPTc/xkgUMqMqCpJAg04hTxuHA4YYW45LNSa0g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXf3dvr2uaOuPnXyjpdJr8jJsrmzc9SLStQEFAkvjHnPA0b5qM
	snr5/tWJkRjB/hMfNHvuS3mCTwRz0fzxQXfNu2S42JXDuJFAZsjgOfO+X0m01qTY5Jzr7y3yDEW
	bNrK9oqEDmmPDRMt37fWW8JhJIKxaaJ2WpHoXqj1SGadn6II/+1Sasu4ckXDLoA==
X-Gm-Gg: ASbGncv3DFYsBWSK/O6O8KPkdJQrnPCF/L2UD7rUqqiQWaCnA6/LIu8poKQ9cCa2ycp
	nC1SaCtNheZvmjSzvD4DY+5spZ52+BOB3sJnrGvRBvdeSt3K+nWzOOnwd9+r6GJNGm2RE7tvk5v
	hBNpzOVVu7rfaDL3lUmLdnNCA5Nue14K47Fl7lBwiZdfZV/ehSptbdQq6BXuBJLH87JejgK/Mbz
	9I9mAIzxw6/RRteov8x43Du+rDAlPjeCP/42z4IY9GVYW5Ga2pHTYb8Zzo3Bg9x19eP79+HhIek
	TadkZCpMeOmH0ZYeSS5WyT4nGqvMtHLB
X-Received: by 2002:a05:6000:2087:b0:3a6:e1e7:2a88 with SMTP id ffacd0b85a97d-3b60e518b33mr1415219f8f.57.1752656337277;
        Wed, 16 Jul 2025 01:58:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgFM5T6msjvz4eBt9JJxEEAvHAo5VJrH/1JPYb+hX9XJmhxEwUw9K86spL5EHzREJnWORrmA==
X-Received: by 2002:a05:6000:2087:b0:3a6:e1e7:2a88 with SMTP id ffacd0b85a97d-3b60e518b33mr1415197f8f.57.1752656336811;
        Wed, 16 Jul 2025 01:58:56 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:150d:fc00:de3:4725:47c6:6809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e0d76fsm17596638f8f.64.2025.07.16.01.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 01:58:56 -0700 (PDT)
Date: Wed, 16 Jul 2025 04:58:54 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] vhost:  Use ERR_CAST inlined function instead of
 ERR_PTR(PTR_ERR(...))
Message-ID: <20250716045841-mutt-send-email-mst@kernel.org>
References: <1a8499a5da53e4f72cf21aca044ae4b26db8b2ad.1749020055.git.xiaopei01@kylinos.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a8499a5da53e4f72cf21aca044ae4b26db8b2ad.1749020055.git.xiaopei01@kylinos.cn>

On Wed, Jun 04, 2025 at 02:55:48PM +0800, Pei Xiao wrote:
> cocci warning:
> ./kernel/vhost_task.c:148:9-16: WARNING: ERR_CAST can be used with tsk
> 
> Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...)).
> 
> Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
> ---
>  kernel/vhost_task.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
> index 2f844c279a3e..8c4a82c0bdbe 100644
> --- a/kernel/vhost_task.c
> +++ b/kernel/vhost_task.c
> @@ -111,7 +111,7 @@ EXPORT_SYMBOL_GPL(vhost_task_stop);
>   * @arg: data to be passed to fn and handled_kill
>   * @name: the thread's name
>   *
> - * This returns a specialized task for use by the vhost layer or ERR_PTR() on
> + * This returns a specialized task for use by the vhost layer or ERR_CAST() on
>   * failure. The returned task is inactive, and the caller must fire it up
>   * through vhost_task_start().
>   */
> @@ -145,7 +145,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
>  	tsk = copy_process(NULL, 0, NUMA_NO_NODE, &args);
>  	if (IS_ERR(tsk)) {
>  		kfree(vtsk);
> -		return ERR_PTR(PTR_ERR(tsk));
> +		return ERR_CAST(tsk);
>  	}
>  
>  	vtsk->task = tsk;

I applied just this chunk.

> -- 
> 2.25.1


