Return-Path: <kvm+bounces-53616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DDCAB14ADA
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 11:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC47016F07E
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 09:11:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F5A287262;
	Tue, 29 Jul 2025 09:11:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E9410F1;
	Tue, 29 Jul 2025 09:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753780305; cv=none; b=cjmf8SW0zSmwa91sCyQVIp8Su0lc+w9WdYbiVteywwt+GnYxiPLLeZY6rnUH/36dhMunz9h5QcGIlPwx8uriHsCIYEaI2ULOrKsGyqHJKP4Xls4P4N4vd/gNc4j6+Ie66AYX/SKTPI22B7a/ohtp0dkY7NjCpu51FPvgs4xUXlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753780305; c=relaxed/simple;
	bh=AooAinBEhVQgX4xQPKEnqfkbfDa2o/pfSJaoO6cyeHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ryBWMy5bPmckrtSPAmaS7BITikF7iCEYgNZIPS1PpzOwBniVI7syy+o0pWa++595NtEcp81N/n0cDXcA1SjHre+jaWMK97yGr49vhwsxAMvVMNmoJswZelY2OffMtjBQw6mSHBcVWEyLf0zoQTU3IFATrqeN53WS/Cvf1AkUYEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61571192c3aso471477a12.2;
        Tue, 29 Jul 2025 02:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780302; x=1754385102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mTe0pbkq2BTo76Iwyv7UU0Sc/vWsm4BTTYdkBS408H0=;
        b=Fmu4dnGBQ5M1G7nqdnBsroK8y0vdWXLlytt21Kbx6HR38E0dbEKLEVuh6qv/+geU2J
         dkuA3eWlkCD758dzpNgEnDYUgI9UWWMSbvI5wy5Jg+tbeQFvfhcgVk22fbzODDBn6w8z
         iL8khJD8ZTPBDYoiC56atG6wgZmgphwOfQx5DvxNZOI7TE0325QFXurTR2vVAhDFCz2X
         UXH2+BSqdGMheG+6Kt1Nv1CV3eGysFH2Xfk9ov+iEIpf6MRA8RmFcOYTZlLVX14oE4cv
         fcaf5/NB05eSFnfC7pj8mvr04hYB2FnsAnr9JJiiUcFJ0dmmySjiY1E1mCWLAZ2Gz1s5
         2b3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMj7F1+/V/6xTIHvDTT10CT+oX/vdikNxybT9zRqzc9fjfUQVzBFFqq6+4xbLcOcfKAGxuHpC9@vger.kernel.org, AJvYcCVkj3KHk8Thcym5Ny3cclRYwBZM6iN2qdKRUDs1IFz0GKI69QN2uv2tzPzQlDKinurbEN0=@vger.kernel.org, AJvYcCXSGDQFq4SFLMC3XC77RprBPgjTAYa7U9xXrWLbzHjGntVftXgKcaCd+w3Plt2cB2LlKWWHmthHopHKD+7d@vger.kernel.org
X-Gm-Message-State: AOJu0YxToQstf0JIimob1wN7hRlIYyUDwbU4iJCJyQMKNy0iF8HaTt2V
	dUI2D98t67n+zqCjg8HMRPIA1RUc4deejbmKLue+UrFhfAlPUbd6KtRe
X-Gm-Gg: ASbGncvUc4R7Hmi0VQQ4a/1LZeuA/nOy2vvqswHbYJy8kvOJROf263eNv+NE3TNlaPK
	DmuA1Sa7VGnIPH42avQGLAgGijgp3tKiPtNo1VWyNb1q/MNo/j//AwgKom6zQ5bYwvRtX2jtdxX
	0UZJFcf6lwLF9f4yxrwZ0NXPqouGAJx4dQMZz121X0deqnEgAR2UJkQisaKpFcTIr9TmuZ7Yj5s
	31F5lyv8qvTu/rIJ4nrnH/zS2jYy3rNxc/iaZTCXirfVnmNZcJ+nbnq2F8ByWMjS1wD/k2vQu4y
	ZDcSUeyojHCkvH7pOx4QQZlea6hVaI16MCKbDOCIHC11iFf+WqkQasZbVpj9xtiJzhIHGn6Ik3n
	Y3ewvsrwRbBQ+CVVctO+MdQPa
X-Google-Smtp-Source: AGHT+IHiUSyBteGKx3hNSMSmlbFFC29cVQsp80PeSD3fki0Wu7eWgmkZiAy6HP138mxj1vsKT47V7g==
X-Received: by 2002:a05:6402:2348:b0:615:357d:5630 with SMTP id 4fb4d7f45d1cf-615357d569dmr8322665a12.28.1753780301941;
        Tue, 29 Jul 2025 02:11:41 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:74::])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61542a59c99sm2146959a12.1.2025.07.29.02.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 02:11:41 -0700 (PDT)
Date: Tue, 29 Jul 2025 02:11:39 -0700
From: Breno Leitao <leitao@debian.org>
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	sgarzare@redhat.com, will@kernel.org, JAEHOON KIM <jhkim@linux.ibm.com>
Subject: Re: [PATCH] vhost: initialize vq->nheads properly
Message-ID: <nswdjfxtogobamp7bqktyrihl4w6xs2jnvxjofdvqoxqtvjp5s@vrsdmzuvsvx4>
References: <20250729073916.80647-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729073916.80647-1-jasowang@redhat.com>

On Tue, Jul 29, 2025 at 03:39:16PM +0800, Jason Wang wrote:
> Commit 7918bb2d19c9 ("vhost: basic in order support") introduces
> vq->nheads to store the number of batched used buffers per used elem
> but it forgets to initialize the vq->nheads to NULL in
> vhost_dev_init() this will cause kfree() that would try to free it
> without be allocated if SET_OWNER is not called.
> 
> Reported-by: JAEHOON KIM <jhkim@linux.ibm.com>
> Reported-by: Breno Leitao <leitao@debian.org>
> Fixes: 7918bb2d19c9 ("vhost: basic in order support")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Tested-by: Breno Leitao <leitao@debian.org>

