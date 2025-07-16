Return-Path: <kvm+bounces-52594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2071B070FF
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:57:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3166565A76
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0B6C2EF9CA;
	Wed, 16 Jul 2025 08:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ckW3Hhe3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4AE28DF1F
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 08:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752656262; cv=none; b=mtPyke9ALTWyyk2xfGF1dPksbOxs03PLSlhm/LimFd+LOGguZFF8qdL3TKTl2hm2NWMTArr4U4Smk6zfOeKyRmoAauOySaA3k/u7xsCtdiDVk6g2qDOlTx19e0YfQod3ZXjrvB0fs1PYiRrRt7QKqKYUa3tE2olLHhjtn15p3e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752656262; c=relaxed/simple;
	bh=bSZvmxVaLzzIexlJjfqAQuaa2x0fZVD8/09A4vIGlmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a62MFKFLDekxP2/TvfJMgTLMc/O3Dnp8l9dlY/IJpqujqGjhRMoajqxR+72r6HpG8lELJAZeSVy7q/z3OM16uHj8kjgXBTEqfP8Wm5XZQ6jWPu3Dmj7tsID6XsQb2QAL4KcedQZkL8lQmkohZ1MyCK6cNlbkD3PNwbnaeK2erpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ckW3Hhe3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752656259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T0pk9pyfgDC9oxEgYm8PZjm4tzUcUb0Zdw4AkU7+zzw=;
	b=ckW3Hhe3PmtRrtjOKFkMpxsxI0wZzWbbcqJhy1TLrfXsJ6AcVGKGMXoZvIs7SLu5omwTxF
	m/2z2guZOtOH2iXjYhladtVTjxbiPhFhC412yX223ri7vIoOuG6kZdRb88UcHz/mAqPToE
	XvgoSrdo6J71OjLseHbZLIyCbP78Cyk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-yVfCUL2INoGPcuouUk0u0A-1; Wed, 16 Jul 2025 04:57:38 -0400
X-MC-Unique: yVfCUL2INoGPcuouUk0u0A-1
X-Mimecast-MFC-AGG-ID: yVfCUL2INoGPcuouUk0u0A_1752656257
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45624f0be48so11507435e9.3
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 01:57:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752656257; x=1753261057;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T0pk9pyfgDC9oxEgYm8PZjm4tzUcUb0Zdw4AkU7+zzw=;
        b=aJZ2qe2BWIHq67bDUyhypSg7jWXNalol2e/6vU6a7iwV7xDw5jpZ1dvxL1QPf8QWw+
         gFKueUvQerg6c1zueqFEuOreBlLFsFTFP40hLASVX5eAdFZceXTOkDSsK3j1VVN1tHI2
         FSP3zIWVd9IJlGnVYSpFfKJi+4NPJLhhHIf9a3Hpk6Q6NfUtmkrY0tSmbCCJCNvld04v
         /JJbJfLaVEhyayvYaQ7yTbvZIQSaFFixRy9AjepfVxkCfHrNg18bk2xX2FQAu9lnq1q8
         uaxj7ss385FB23frcvQfAm2S5zRx+KAgADQLmfmaAwL7vGjhTk9w2HlOOWJNaXsWlp0X
         RpZw==
X-Forwarded-Encrypted: i=1; AJvYcCXUHKiZU8qTNERRPq2kxFS8cGqlyBSJEWjP4POIlcu9ujb625pfErnbkEGYkLjjOHEhnws=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAWS+81iVTKIl+q3AwMvjYr7OfKFyYnx+PPPEWIl7s96EHP8W0
	1UVXNid1QcNc92hJGX/uLQA98kkr9+UUFbQ7kBp1J+3lfW054MYLnDQrwJuD0sgjYsXb0ULUKL6
	g1Zvxd8KXgoeAFGaYDSBsOIh6kmzN5epgtLrxZ4VIQ8hN/xc/sr1wmg==
X-Gm-Gg: ASbGncvq8M9k7suJETXzHmZxbVsrQQUasIXUE3cRlwYojsGvy/aefJVwVdz6acfpB8H
	PtuoNv228SbQab5URpS7ZU5wrnEDNWVf4g27WprCRMquGbu7dvolt0FbuT8QHvGhd/avFKQA4Fo
	O7GBOjhVhgk4zq9cnYHR7cvMIrH9a3w2ETeEHWRhE8hTRrPZEK9v+LEgkrYARVjzpvtkY7pL0GS
	fAelB+XdRMnrgJ3r59NCpEzRw1WrMD072SNmtC4Kikksh9d/CoCVqwvQCZRvXqsDpc0pGD21o+8
	bgxPyeu/1O4ZLkaUQCQUr/h1vLGN45WH
X-Received: by 2002:a05:600c:4586:b0:456:2142:7fa6 with SMTP id 5b1f17b1804b1-4562e03df81mr20025055e9.12.1752656256768;
        Wed, 16 Jul 2025 01:57:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPMQ1MbDi1mPyamg5hDacuZGeQ/q7zkCeqn5pVA9BWS/Ht5qJqtjeEvWW81loE7yxAUxIfwA==
X-Received: by 2002:a05:600c:4586:b0:456:2142:7fa6 with SMTP id 5b1f17b1804b1-4562e03df81mr20024795e9.12.1752656256365;
        Wed, 16 Jul 2025 01:57:36 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:150d:fc00:de3:4725:47c6:6809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e802afasm14522575e9.12.2025.07.16.01.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 01:57:35 -0700 (PDT)
Date: Wed, 16 Jul 2025 04:57:33 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Pei Xiao <xiaopei01@kylinos.cn>
Cc: virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] vhost:  Use ERR_CAST inlined function instead of
 ERR_PTR(PTR_ERR(...))
Message-ID: <20250716045617-mutt-send-email-mst@kernel.org>
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

ERR_PTR is the type so it's appropriate here, I think.


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
> -- 
> 2.25.1


