Return-Path: <kvm+bounces-12676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 296AF88BD63
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:14:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B63C1C35D12
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8928A4D9ED;
	Tue, 26 Mar 2024 09:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RQ6XVPE9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115D017722
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 09:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711444447; cv=none; b=nJl/a5XKAqxfS+hslo5aHR9RuZTGy2qT2q7CGPK52/1XR8ugnzoe/Fb0RYBkzhbweyafMNG1iHs5j0lZsfPRFqVZ/S0B2AspiYxLDvTTbNcCAwtDi+HUqHjzE2OBJr9kmGQI7Fxd6DTsLRHDCKsAOGPo81dpnvcKwr3aJEBmZug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711444447; c=relaxed/simple;
	bh=Nyzas+7pL7py1pTGH/MhzQ+AEz8LHlMXCuBlUPhwpnI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h6cRvdqO2odxCXlK5jqYwmtACgiEJ4NgN0Vpq7Y1I+hECYzN+5pQt/tPv/XK4veuWiVhxXku6flOe/2Qiz0LflBQ6Itww19MaQ6qnqXX1Q7DiJqeIjVK84D6Imhmjr2ZZD8DTPCyKS/bFnV+SFVIN5Wp5xVfR2NXx4syUMXGMQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RQ6XVPE9; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a44665605f3so611544266b.2
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 02:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1711444444; x=1712049244; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=80pTN3Pi1mOy+OTtxAhf9i0drPCS5DYfkcTdcyK7AYI=;
        b=RQ6XVPE9MB6VLvKPIZSwp5bz00+pjuY90eRnAxgQ1Hr2WFn3u4FiiUESA4TJGXWA5C
         gRcCw07boQrdGhRjU/fWHtFTp2i7UCe4uvFNXzM2uaEPFGz4I2Mr6D6db0erVhx8EsBd
         T6ugZGzHEa+4TfMNWElADbptJFWMBcC3vxsNFF/u50hbA9vncotRDUdjVH+BIPvEAoik
         sRP8Xy+KPPO459CWufF8hXr0jfE1SCmYksgjOqH/en0mM07u9734ajhfN/OojkkogCfS
         POXFON5rFmqcoztjzNLbouM1jdM04mh7lHsjhoKu2B2rjmcl9Lyv5gvmE+uyo3C1KHd9
         AQqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711444444; x=1712049244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80pTN3Pi1mOy+OTtxAhf9i0drPCS5DYfkcTdcyK7AYI=;
        b=C9n4ztnYqzkCp5b42Bmn+Q0WBCLNrTV9ykMfPuV3Yk0JU6wfZWunsYJSR9Ac/dWL21
         eJYExTD8Rmxa/5AnYHhYUsYlxqcN3+XyLMm7fQi31GcaPZDzgyRR6Vt8Z1HHTGpeeB8I
         pM2Fy+11Iz574i2CiT+XcyXnlAFBCCVEKFrJk4nPpq4lGS7nBBQ/y/zX6vaTomJIpInM
         LROG+VQEjj5vZspNeKYFysnKxYc8iXW6CFTuI3XEjzvGN/SiiKcCsXGDNrTpFfs5qpvU
         mRMh0JE6270EhegKsXSMpQA2mhLeM9+r0cPAQVItYAEVT+3Ki2L9D+CK01DyUV/UlbaH
         Av/A==
X-Forwarded-Encrypted: i=1; AJvYcCWnuBvEXFaBw4MfQ1pQ2I20Ex9CGpRQ1f+aJP6KQ4OeLR/qab0YsifgDGAgUdplRA+GsxEKanDwezd5l9Mcr8paNma2
X-Gm-Message-State: AOJu0YwQOJ/O1qNPBDvreybyk4VkhlHi80MBOYU86mr4fVd8W3kntIzJ
	uLlFCfYAdKw973DnazmG10cUHXRTOrgxdo7RcmCP2evx2tgXH3ozP1pGg24Y2tQ=
X-Google-Smtp-Source: AGHT+IHii7GVTroBEyV2Yq5EsNGC9r6CIUTe998wWntew3iEcd/nSCTrqULSdLqHWnWjBWcGxE08bw==
X-Received: by 2002:a17:906:c259:b0:a46:53e9:aef9 with SMTP id bl25-20020a170906c25900b00a4653e9aef9mr6064275ejb.65.1711444444217;
        Tue, 26 Mar 2024 02:14:04 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id m21-20020a17090679d500b00a4739efd7cesm4041021ejo.60.2024.03.26.02.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 02:14:03 -0700 (PDT)
Date: Tue, 26 Mar 2024 10:14:02 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v2 02/10] kvmtool: Fix absence of __packed
 definition
Message-ID: <20240326-b646443507379ee185f916d0@orel>
References: <20240325153141.6816-1-apatel@ventanamicro.com>
 <20240325153141.6816-3-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325153141.6816-3-apatel@ventanamicro.com>

On Mon, Mar 25, 2024 at 09:01:33PM +0530, Anup Patel wrote:
> The absence of __packed definition in kvm/compiler.h cause build
> failer after syncing kernel headers with Linux-6.8 because the
> kernel header uapi/linux/virtio_pci.h uses __packed for structures.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  include/kvm/compiler.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/kvm/compiler.h b/include/kvm/compiler.h
> index 2013a83..dd8a22a 100644
> --- a/include/kvm/compiler.h
> +++ b/include/kvm/compiler.h
> @@ -1,6 +1,8 @@
>  #ifndef KVM_COMPILER_H_
>  #define KVM_COMPILER_H_
>  
> +#include <linux/compiler.h>
> +
>  #ifndef __compiletime_error
>  # define __compiletime_error(message)
>  #endif
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

