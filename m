Return-Path: <kvm+bounces-38839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DF45A3EF09
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 09:50:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22FFC7A9C6C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 08:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D7620103F;
	Fri, 21 Feb 2025 08:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="RCZSbF1C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED515200B99
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 08:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740127720; cv=none; b=LEcf1yIYT+stlbCexeZOuki8Q5Mzwn4nCiWr7wGUJoFeU9Q9N4p3l9oxJLXT1iis81HDrPBgJVptWTFJSGgF0LERQ3EMiTRfSY4KFZAEtqfTs5hdfZ9SO+PGPjfe1KGFLYClfxoJFvb0pboFJq1bY+e/RsuCUwd9xkJ/hbMakys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740127720; c=relaxed/simple;
	bh=wVYapxCMC/kTRVahqm1fT3otHcdCdXHu4xqn/TV+qbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5RUKBmP/M8PPfkGlfBjcaj8mUuj/11rNM6+gFd+hVQq9Un3UYUoDKATh4sKR4CxLYwhxi9szBgigAHlvfoO62SlZwL9CqXrGkXFqLwtC/URDVYQIhwu8vCY6KpqMUPvIeuG9iWUTuCb/Xg4lWUcGAjKXUsYniCr0BhNNjALh8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=RCZSbF1C; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-439846bc7eeso11324395e9.3
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 00:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1740127717; x=1740732517; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eb6L/xHidvDmAG1R9QTqFpwECa6Y0bk51MMmtIvM9Cw=;
        b=RCZSbF1CJgaBCQ4iXdH4/N3lcOY4r3ObZV3IgTjvmp+UM8WGvp1j3DFSXuFZtVFefn
         0ccpTM53QLnbtHazAl0xH4LvafTf40Ao8IsfuCpCLI46l6SA0xsPMLpoFLnqFGMioIcm
         uaHIgNNB41UWsEu7mL3DaAAlu8NEK7CS2deoDH7H3Z2CTByj3GoOf3uYUxMyVxFS5u8y
         WLcgIjU0A8DxL+LcfySm6RjIf0U3X7zGOV8VUuMfSb8EtHk+uQ57f2TgTC+x0Qb4IU5j
         ROB80MSGZurb43ftMpDPusjlJH8703FWI7ZZbF5+zwIXSpmHJUKtFCIbDgOVvg5G7VfH
         D3yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740127717; x=1740732517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eb6L/xHidvDmAG1R9QTqFpwECa6Y0bk51MMmtIvM9Cw=;
        b=cj4OWuMGFFJhLj9UvHLrcI1s/fw7Fg+wQwyeQMdWQO+15d1lzkNXuqYme2z6NbK2Gh
         LRyLPIOGmh4EJ/AtcrfgNPtnCXgBwuBWJ5BRgG4/Joy/orbrPypB5i7Yu66keI3PdeVp
         nK+wY1C2yHlSYQmUb15NybBnzSCG0ErF5qsW/28mOBFU9aa8GLNYYkjy4R0eCwgetB/I
         SMNlvmEcL6G8GCQNwXkAK0F4menyoiY+xUiV73NRGWATp/zosczEtUc9Dyj3HHUFq43C
         SLU6El+0Kr4TUwWprQJ7+4h/KlLsrlT2It9+HENFcB1E01R/XSQ3JsNTZa0zOs3pHijr
         EXmg==
X-Gm-Message-State: AOJu0YxP27u9ZIvQdRrPaVBJShKDR8uwMZj12R0Y2GTwXkl0SmB5hnNT
	fkIhdXMEVE4TxieQzFCsYu+l8tHVNAwWDGL+rLKbKl/hqIqHXX7kQ3VayMM94Vo=
X-Gm-Gg: ASbGncuSGY5+YYC3+zNRBrHuVJsW/i1SxgwX8XDAT35thqOb5pYjGpjiew8qrByk9kQ
	Pw8ry2yAZueW2lvei+pUDnjv6DoMBsrlFl52msM/f6+3pz+f/WdYp9EXJ3XAHGgqF75UUCrpiYS
	yRA3XW4YVaGjNimxJAASL0ULTe+Rv+U+a5ZJZ/aXPkZaFWfdIvSmrp3RU82jZ49Yum9PdsBZf6w
	By3Fl47Or+BHHA8gZL0gTG2wTps4gzE020xZCpSleNO8chLtGreOWFyJ0yhFBTsG51uCEooegmE
	QYKoQ8Qx/mfm/A==
X-Google-Smtp-Source: AGHT+IEmKwIiCas8gnM3ECDACjRObkNtwFp5OGkI6nJMo+z84lLQ2XlgjtN3xZ0C8moXXb7kNGSbfQ==
X-Received: by 2002:a05:600c:4691:b0:439:88bb:d006 with SMTP id 5b1f17b1804b1-439af7f96e9mr12091815e9.6.1740127717179;
        Fri, 21 Feb 2025 00:48:37 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f771dsm22594105f8f.81.2025.02.21.00.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 00:48:36 -0800 (PST)
Date: Fri, 21 Feb 2025 09:48:35 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu
Subject: Re: [PATCH v2] RISC-V: KVM: Optimize comments in
 kvm_riscv_vcpu_isa_disable_allowed
Message-ID: <20250221-c503f28d950aa5268874b43c@orel>
References: <20250221025929.31678-1-duchao@eswincomputing.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250221025929.31678-1-duchao@eswincomputing.com>

On Fri, Feb 21, 2025 at 02:59:29AM +0000, Chao Du wrote:
> The comments for EXT_SVADE are a bit confusing. Optimize it to make it
> more clear.

nit: s/Optimize it to make it more clear./Clarify it./

> 
> Signed-off-by: Chao Du <duchao@eswincomputing.com>
> ---
>  arch/riscv/kvm/vcpu_onereg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index f6d27b59c641..43ee8e33ba23 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -203,7 +203,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	case KVM_RISCV_ISA_EXT_SVADE:
>  		/*
>  		 * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero.
> -		 * Svade is not allowed to disable when the platform use Svade.
> +		 * Svade can't be disabled unless we support Svadu.
>  		 */
>  		return arch_has_hw_pte_young();
>  	default:
> -- 
> 2.34.1

Otherwise,

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

