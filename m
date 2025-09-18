Return-Path: <kvm+bounces-58019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0557EB85800
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E7641B2692C
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 15:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C166430FF1D;
	Thu, 18 Sep 2025 15:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CbjL9Her"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A908D30CB54
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758208155; cv=none; b=LlzcDXNQoAgNgVyGiR2qRU4Mf0BjuDvrLZEi2+Dh8yQi+Lz0SPI8VlR7N1A89dypMj09yPg6wmizWU1flJvwXYigxKnmrraEpI+wzBoix1DJtFoyHCW+MlRNQwseVc5CmizFUyoBnpchOewVGEY+g7sKkPt/TYLOCeLYXyUR8Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758208155; c=relaxed/simple;
	bh=48WfDspnNYYwY+nqsrybAAO10uUojF00QMRofRzWMNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2pLDNU6zwL/7Y8yqjyMIOZMhznvqxuIzPW2UZ4x3K8rfPZdnK7aWX0uHM4qSFAHTWy1+OGCHf0aCVDFJZZeF5O62uw14AxImNfgET8Bw12Y4lGhZhIdlJ3Y59AU6ddlQXY3XYOoTpIDym4v0QEC73U/boYyQQ8/Q/cnhlKMH18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CbjL9Her; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758208151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Okp6kP9+YlujH23hoSs0Wy/CFE9uS+Y/4tNJyV9DleU=;
	b=CbjL9Her5yuI5edkX7ROGHGFTq0qx5K0LDnUBUY5j368MEszgg0Zf3LmT5AeBBgZX5I9BK
	y8GC9uw6fOPYUiQiCESOkpAPbdiMPGOTDBsh2zz5HWjuQYNjw6zfVZTWUnKEqBVtjQyTPf
	4Sm2qyqCkT/o51h5hTfLWsoZcPXaM+c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-BlHdc0nRPuOGCn4zcz2zaQ-1; Thu, 18 Sep 2025 11:09:10 -0400
X-MC-Unique: BlHdc0nRPuOGCn4zcz2zaQ-1
X-Mimecast-MFC-AGG-ID: BlHdc0nRPuOGCn4zcz2zaQ_1758208149
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45cb604427fso6841135e9.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 08:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758208149; x=1758812949;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Okp6kP9+YlujH23hoSs0Wy/CFE9uS+Y/4tNJyV9DleU=;
        b=Kpw7rEQ2V78R1KlF51FUlyrUhgPd6/ggmCAFj3xxyiCuHEoxARgD/Fxfbn+OGnsiTM
         shAabVdXvUPT+a4CUoPGb6+Om+uwzV6Ziyb+586GgXulgOtrbbnNzqwC56C+RaCzSfxF
         oRw3vmh2dBr0b3oOkaG3urc1f2791tVKBsuSXL+K1kpbzWxIzbgGIKBzHXqhs9BRek8X
         kIc8d6nTC0Dr9R4A6G28Zszn/qaAJ4nEheoxAc458JEfK/KL8wM3yVcArP3wrvsXTIru
         nzkfgQnBY6grVAZ0aZ5ZEOX/SSYccVYaByBOyoq+oIOdSx67aqDVTtEMfjDnZgqJSY2b
         hrxA==
X-Forwarded-Encrypted: i=1; AJvYcCVb6YBywLcUGBBc9iJAub7sDBcdGaOzdPUtiUviEj+pVoAjjwN+Y6Mz+QOYzTcYaMcT4rw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt1TTIXVa8cku3CVg6XS0CpafyAP4Teu1WH5+ttGnFoyNMa6ch
	8KEK6mpfDHjKo9Zt43c0q3zFyYPkOZJqsrJQ/QMYGgBAcwEL6z4HTnhkaY6yiUk0Bg/SuCmRtGF
	3VPgp/ACabF17WvSJV2iqJi1WkhLNfYAn4GAToUKwemf7Ob3FWc4zwQ==
X-Gm-Gg: ASbGncvAZWEro96po9FJcFG9LLsL4DRLyarfhEGheKz0Op7BuTrieU6m8BZI5oZJwTy
	pB89Ox5RgMH0akdvfP2KG72DjCODsIKvkx9rn6ROsiZ0KEd16fHGr/OJvqxyH5jqHEN1Z6vrFNP
	QOAuh9e/BQVNI4f2hrLO8u9CJOQLEZxglNrPbbF2k4Syf/qdWO8ERR2TCGHWuvgl1iM9qiaF2UM
	nAkIQRtqp+ksj2AhB0jVZkVJO35x6Q0lp/s7jgGmh6MCn2WtNzDhyuXOb2jV0BHpF/DYAtwijEA
	IKU2UWChGV7xLsVQV9fv3B5WASmkLjNVUdY=
X-Received: by 2002:a05:600c:3b0f:b0:45f:28c9:c4aa with SMTP id 5b1f17b1804b1-46202a0e8b9mr57240885e9.9.1758208149051;
        Thu, 18 Sep 2025 08:09:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4pxOb15HbXf6kQkik0F3fAf2Q1845KsjAT75QUOI8d0zEUi3a3iP8sUQbUJhBuS6AvT6fxg==
X-Received: by 2002:a05:600c:3b0f:b0:45f:28c9:c4aa with SMTP id 5b1f17b1804b1-46202a0e8b9mr57240595e9.9.1758208148642;
        Thu, 18 Sep 2025 08:09:08 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f4f9f41csm52209105e9.15.2025.09.18.08.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 08:09:08 -0700 (PDT)
Date: Thu, 18 Sep 2025 11:09:05 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited
 task
Message-ID: <20250918110828-mutt-send-email-mst@kernel.org>
References: <20250827194107.4142164-1-seanjc@google.com>
 <20250827201059.EmmdDFB_@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250827201059.EmmdDFB_@linutronix.de>

On Wed, Aug 27, 2025 at 10:10:59PM +0200, Sebastian Andrzej Siewior wrote:
> On 2025-08-27 12:41:04 [-0700], Sean Christopherson wrote:
> > Michael,
> 
> Sean,
> 
> would the bellow work by chance? It is a quick shot but it looks
> symmetrical…
> 
> diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
> index bc738fa90c1d6..27107dcc1cbfe 100644
> --- a/kernel/vhost_task.c
> +++ b/kernel/vhost_task.c
> @@ -100,6 +100,7 @@ void vhost_task_stop(struct vhost_task *vtsk)
>  	 * freeing it below.
>  	 */
>  	wait_for_completion(&vtsk->exited);
> +	put_task_struct(vtsk->task);
>  	kfree(vtsk);
>  }
>  EXPORT_SYMBOL_GPL(vhost_task_stop);
> @@ -148,7 +149,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
>  		return ERR_CAST(tsk);
>  	}
>  
> -	vtsk->task = tsk;
> +	vtsk->task = get_task_struct(tsk);
>  	return vtsk;
>  }
>  EXPORT_SYMBOL_GPL(vhost_task_create);
> 
> Sebastian


So how about switching to this approach then?
Instead of piling up fixes like we seem to do now ...
Sean?

-- 
MST


