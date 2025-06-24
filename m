Return-Path: <kvm+bounces-50492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0520BAE66E5
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:46:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CE347B7014
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 13:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FC319B5B1;
	Tue, 24 Jun 2025 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ie4BZVsD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6281291C0F
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 13:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772725; cv=none; b=WuLYcSNCa5824o61wy7V80Yl9NropVLpSlZS+8mHz68PnDiKaYp4viYf1Ng+wMtvIyeMwr+Ul1gl2zLIVuQlw6uMyQsPc4m3nxdV1cKsCSmupkBNFzBi3pXH8Xsi5q6LXvSATQwlgLIpzZ1Yf1u9yvwLzAs34NxE6Rf/DjrzvNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772725; c=relaxed/simple;
	bh=GhI68Gy4cRPXeBqql/DtpMXFO8eaM2MI/m57WTrNKGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSZh3V7bM3EgBGGUEi5TOeuhxU4nFd3ZRxB4wPgvAgmn6FGgcoHtPF5dBcOMBewIF3eWtgh27/kmCuMqgM1FG5FIWPLacf+RzCGVRk1BOgPEuk3JuMXVnJddCKlYlxfFWQ/qdN0YoQQUyPwh0q3xLIIHQyomFvdGIvLfO5gz+ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ie4BZVsD; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a6e2d85705so305978f8f.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 06:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750772721; x=1751377521; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hhHOBARS9lr0Jne2Zdn1kpqzowPhY12GIzjucW3MJHM=;
        b=ie4BZVsDTW97BhRYTPEka/0m1gIr5AXXDdFKxvk1/4Dhe3VnpCOVF4NqEoCrhA99aG
         /gVFZbNr04Vkfn1R0AAwx73GFGEuZEj+YeIX7IqaAy0RoeNzVAz5yJAmYN1WyjbD5Iwk
         RvbcUMrnkW0uIMKsEuSsksuzlAeGw+xPp6nFoz2Bm6HjbmtCasrJyccePZ6OWw83sA6T
         ec1x/cs6vHa7Lncv2wzdqdyubNZsIzN1dT4nXK54MaesmomxFQXgYgjp+qkgIJOTY6uF
         J/NQJo0j7ZWgzG8n4K95M1AzU7UuutsD07t3/jURYcFca/3AVVZH7cOqPY9yH7ztEI2E
         xkag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772721; x=1751377521;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhHOBARS9lr0Jne2Zdn1kpqzowPhY12GIzjucW3MJHM=;
        b=ZKahXfxnCInxDKz+LyvXZrSYaDJnuvQODGja38feVhmxZfpaLuWqtcfClz1SxMoLrk
         vrejnEcML5th7NZ22kvDOaRxsJlN9kXGThlQjnuS7LriYCLHgI8Bjzys5nNEJCblTky/
         UMlwx0ti3PipccQPTrGrc36Fgd9NGviUTAuluc6VPDyd/DP2+MAbPNVrapXzYmHBnjY+
         OWMrzGN0P24bJGP7YRJzc1ezFO1zbwWFPh+khv0ngcERBCd+BR3ht+vZginOtZk++CIi
         8pNrh85dhLT+DNfS6b5ufZcl9dm99KpNGZ+dThxP6yFk8+vuhF314OdZ/AllIV73C0FS
         HtUA==
X-Forwarded-Encrypted: i=1; AJvYcCU+LWubtj02D1ijC9lYnlsfhRvXQZcCQ5HNJNKTzalAoA1gFU6hZqn9HImCneoDKiqQ6F8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdFMPntMba99oSfq3Y4ZW8KPmjTA6UklewThiIHXBb8zWrhJrE
	UDVY+JdNhgmqKx38uWyriWFNeDrCJjDjQSxMPbpzQx1UEv8OsSgFOTaUtKROezVQQ64=
X-Gm-Gg: ASbGncvQVSCFDcpDXe57AWHmgDkjidEU7ld93Dn1FSrl6inAFGshCSJu68JLFF3QKyr
	/elr5tL8qd0MUkVBMlOlfU4tzK2bp9oJcc2HFrmfnW7VEDMkgpL4VoqLXRsM4k5jowo0Ri6+bPI
	6it860PRq1kLHfr4L0go9d+6dGngT/hLa4vSdPPhpld26cl/11VKxpgbgV/O/CRxjFhUoTv14QQ
	PRfVW/H07zmlnXBAjucuTd94f8eY9TSKrqZGgL3KUkSM7r7eQtB5VrS8/VKmMRB+0c9QLbhSgM3
	cWV6MhjkyKNhzNGhkRZ5I5VwzJ33Ne2QYqxOMcOo0/c50sN1cw==
X-Google-Smtp-Source: AGHT+IEU5StVqiMNMsimuk7TXSreScYWyjj3lITH71NZEaq/8EdSLIayk4NRO4nj9hFeb35RGbbQ/A==
X-Received: by 2002:a05:6000:2405:b0:3a5:1410:71c0 with SMTP id ffacd0b85a97d-3a6d12e1329mr12765077f8f.38.1750772721155;
        Tue, 24 Jun 2025 06:45:21 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::5485])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453632312a3sm153049215e9.1.2025.06.24.06.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:45:20 -0700 (PDT)
Date: Tue, 24 Jun 2025 15:45:19 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 1/5] RISC-V: KVM: Provide UAPI for Zicbop block size
Message-ID: <20250624-c01c528dd9ec524ed3f5e17e@orel>
References: <cover.1750164414.git.zhouquan@iscas.ac.cn>
 <553bacc4f66e815975bb8ee0e4696397407b0a82.1750164414.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <553bacc4f66e815975bb8ee0e4696397407b0a82.1750164414.git.zhouquan@iscas.ac.cn>

On Tue, Jun 17, 2025 at 09:10:22PM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> We're about to allow guests to use the Zicbop extension.
> KVM userspace needs to know the cache block size in order to
> properly advertise it to the guest. Provide a virtual config
> register for userspace to get it with the GET_ONE_REG API, but
> setting it cannot be supported, so disallow SET_ONE_REG.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 11 +++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 5f59fd226cc5..0863ca178066 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -55,6 +55,7 @@ struct kvm_riscv_config {
>  	unsigned long mimpid;
>  	unsigned long zicboz_block_size;
>  	unsigned long satp_mode;
> +	unsigned long zicbop_block_size;
>  };
>  
>  /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 2e1b646f0d61..b08a22eaa7a7 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -256,6 +256,11 @@ static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
>  			return -ENOENT;
>  		reg_val = riscv_cboz_block_size;
>  		break;
> +	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
> +		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOP))

I realize this is the same as what we do for zicbom and zicboz, but I
think we should actually check riscv_isa_extension_available(NULL, ZICBOP)
instead. The reason is that we otherwise create an ioctl order dependency
on the VMM.

I suggest adding a patch to this series, which would come first, to change
zicbom and zicboz block size registers to depend on the host, not the
guest, isa. The patch should also change the reg list filtering in
copy_config_reg_indices() to use the host isa. And then this patch should
change to also use the host isa. Also, this patch is missing the reg list
filtering for zicbop, so it should be added too.

Thanks,
drew

> +			return -ENOENT;
> +		reg_val = riscv_cbop_block_size;
> +		break;
>  	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
>  		reg_val = vcpu->arch.mvendorid;
>  		break;
> @@ -347,6 +352,12 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
>  		if (reg_val != riscv_cboz_block_size)
>  			return -EINVAL;
>  		break;
> +	case KVM_REG_RISCV_CONFIG_REG(zicbop_block_size):
> +		if (!riscv_isa_extension_available(vcpu->arch.isa, ZICBOP))
> +			return -ENOENT;
> +		if (reg_val != riscv_cbop_block_size)
> +			return -EINVAL;
> +		break;
>  	case KVM_REG_RISCV_CONFIG_REG(mvendorid):
>  		if (reg_val == vcpu->arch.mvendorid)
>  			break;
> -- 
> 2.34.1
> 

