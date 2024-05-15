Return-Path: <kvm+bounces-17435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49B398C68F8
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 16:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B58C1C22054
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 14:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD68015575C;
	Wed, 15 May 2024 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="kKc2DyFb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF2C13F00B
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 14:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715784272; cv=none; b=LH0AF/dAVHMzZdl+4CAMROsrKsXx1SOXSJ+/lxIZZ9XkkYbkNNvTmy2fsA29qK9ZNtott1TKvyotAwFlEjNvChXEYLJfjvmNdNWI0Eci2qlprGzGvbC6kL3znJD5GsfvCUdKTbLDK3OF3TVe1Le40Pn1Cj5h/B5ThU/gV2eaViE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715784272; c=relaxed/simple;
	bh=lMzyHfnpC4T+4bjfP7bXfPMeksfJLuvwbWMEw8T/bSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M4alwwXaqiS51ipNKJKkkl8OIL2ETXNaXYNk4FxZxxc2J6YKd+LA9J9ucW6qi7xnSQTaKS3r6FVwwWpJ1a9RvzWz8VgxBeCEYKdgbm8QxkhLOZyE4l72AxB/u1u8XhysO8CLQe+dC8ZZ4ioPJpn2eX8zstKJ+nugXEcsujfciGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=kKc2DyFb; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-420160f8f52so22820095e9.0
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 07:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1715784268; x=1716389068; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NMIK0NQemQWzzjDGIwmh1trz/io3IdAU24yfPO3k8fI=;
        b=kKc2DyFbYLOGVTkdQYhF1NUR8lFlNUV04JIqZsIu9OHVbssJZGvDQ8i3IPmKjrOkGL
         D+zQ1AOvS0tmX1l07GA51ajSyGoJleab1shEZljdI26F7fxlOsikyZLOHKBZL2QJeJFz
         cdmBF05nnUpuiIfDrBCQYU6Rg0kP9is60vFXvOEdnF/LuuGO/mkHCLAk0dT5JnXFQevL
         Z65i8fBD/rzh5FQ1idtIbmj6UQlwB6bmqZPaWLNlCLim8TRDRGTStLTYbkqfAbhqhDvX
         BpQ7j8maJbXhRqKU28Q5drrR9jW+F+Pwtnn+3SsgksP7V3MbOhfzTAarhFjsgWs6Fj28
         Fljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715784268; x=1716389068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NMIK0NQemQWzzjDGIwmh1trz/io3IdAU24yfPO3k8fI=;
        b=Pj+jU+dZaCIYzmPehUYWJUhpILGzG1Jy8Arxbx79i/z5esqhQyH/pHnoCJfkDfgBNW
         Q5SZ1z6LmaBR08fJUsk+jhyG9oTr0p/Yp2WLf7ZhsqBs43C31XRVA2Xg5SWlJXRNEnWB
         bQJFymTnA+KOsShGRjpiI5EKhvYfccKfEd+pjWpg7HP90Kr5l/3f+KoNKbIq6ZvOuwBs
         5cHCV+L+7cF1YjnLLC9BHagjupURZC6axVImVxFwwPTRz7PDuiWyqxQUkOAQybg0A2hg
         lCU7XZoR3q+/LW6QDmfGqdODmDoi4DPb00x4oJ7YSHxZS1PA8H4GVAB7UXDi09TMWmTs
         X+8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWpXfjedOqFbvurc43CFLeJISkWhWRXg7v6GdZj3y9eflm0M6ul6X41vNOx5IDhZR4dtb4dKBATHC1hsWHpLQysdEZy
X-Gm-Message-State: AOJu0YzEGaTvGYybXNnft4+gOJCzUwlBJO4Jd3FgIToz8JFrvxbuxCi2
	93/zNNTo66QsG9+E5t+S0MXE5OJFWYlbeUBEtaoqw3QP0JzN6bThJIbkeHsfzGw=
X-Google-Smtp-Source: AGHT+IHU0jEE+jRRMoojb2vcpjR5IdcbD+9YnNlRVXV0c5cOfgwkSmGkSAgkG/zEMA1irkOlP7fcog==
X-Received: by 2002:a05:600c:3b26:b0:41c:73d:62fe with SMTP id 5b1f17b1804b1-41fead7a82emr94966095e9.41.1715784268570;
        Wed, 15 May 2024 07:44:28 -0700 (PDT)
Received: from localhost (cst2-173-78.cust.vodafone.cz. [31.30.173.78])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41fccee9673sm237195135e9.33.2024.05.15.07.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 May 2024 07:44:28 -0700 (PDT)
Date: Wed, 15 May 2024 16:44:27 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com, 
	apatel@ventanamicro.com, greentime.hu@sifive.com, vincent.chen@sifive.com
Subject: Re: [kvmtool PATCH v2 1/1] riscv: Fix the hart bit setting of AIA
Message-ID: <20240515-354702b661f7e6351b92cb21@orel>
References: <20240515091902.28368-1-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515091902.28368-1-yongxuan.wang@sifive.com>

On Wed, May 15, 2024 at 05:19:02PM GMT, Yong-Xuan Wang wrote:
> In AIA spec, each hart (or each hart within a group) has a unique hart
> number to locate the memory pages of interrupt files in the address
> space. The number of bits required to represent any hart number is equal
> to ceil(log2(hmax + 1)), where hmax is the largest hart number among
> groups.
> 
> However, if the largest hart number among groups is a power of 2, QEMU
> will pass an inaccurate hart-index-bit setting to Linux. For example, when
> the guest OS has 4 harts, only ceil(log2(3 + 1)) = 2 bits are sufficient
> to represent 4 harts, but we passes 3 to Linux. The code needs to be
> updated to ensure accurate hart-index-bit settings.
> 
> Additionally, a Linux patch[1] is necessary to correctly recover the hart
> index when the guest OS has only 1 hart, where the hart-index-bit is 0.
> 
> [1] https://lore.kernel.org/lkml/20240415064905.25184-1-yongxuan.wang@sifive.com/t/
> 
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
> Changelog
> v2:
> - update commit message
> ---
>  riscv/aia.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/riscv/aia.c b/riscv/aia.c
> index fe9399a8ffc1..21d9704145d0 100644
> --- a/riscv/aia.c
> +++ b/riscv/aia.c
> @@ -164,7 +164,7 @@ static int aia__init(struct kvm *kvm)
>  	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_nr_sources_attr);
>  	if (ret)
>  		return ret;
> -	aia_hart_bits = fls_long(kvm->nrcpus);
> +	aia_hart_bits = fls_long(kvm->nrcpus - 1);
>  	ret = ioctl(aia_fd, KVM_SET_DEVICE_ATTR, &aia_hart_bits_attr);
>  	if (ret)
>  		return ret;
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

