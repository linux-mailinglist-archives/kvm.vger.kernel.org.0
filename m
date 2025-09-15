Return-Path: <kvm+bounces-57585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCA8CB580E2
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:37:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D4F81892DA2
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 15:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAA134A322;
	Mon, 15 Sep 2025 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="G1cETgS8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE3C3191D3
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757950011; cv=none; b=cYSfmhboh09QbeuiKnSLPR1n6xrInIdwX0D9oBZUfzmB3fNKcveKxyt4bSWH/7DEZNQD2DnBykZ5xLZawAJtXF85woGsOgDQrx7jEMUhSxI/PgRkwUpsmNffrVgu4yoAuBhJus4Uiy+SYkaePc3aa/7hKYTewOVFDyfuefbgbO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757950011; c=relaxed/simple;
	bh=eiHdDciDni3gYAAZEuLtsnxsboW5Wnfisp7dlGLHlh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PwKOeZrsqQj4T2xG51vkA1NTQy+PI4CvDUr2G56pxFQ8HUlWdKbIzXUpfK2W1/1Ma0EDLf2S02wY+5g3bwHnlM6u/wXoRCJHuiKyFNp5EhMyIJ2piiKFDR1mHZBFnWfetgxJKBtPk8X/zVOt21DsYTuWMpqVnVLHg9tjOHZV+Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=G1cETgS8; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-423fc1532bdso25703495ab.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 08:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1757950009; x=1758554809; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lgIK+urtilm1qOsjSmDUUjKbzrkdpZTbpLIEbKtk/E8=;
        b=G1cETgS8z9jQzC23unMI3KhMgTujIeXJ93VnzAlAK0FhB7FlIWVfT5hufeMJDbBmkW
         dA/NxQNJ0syOFiqk9u8q0IAern/xVbpORLBYIIgmEBtt3SbgW6sYGZo03gYC4uDXaDx7
         dzaXfLrJS2fQuawZuAzVdT+k6iskf4KFlSVBEiaV+LVWS1Y9r4NkKXqv8FwInWq8I8WZ
         ShlFHMVzML26/KiMN0vroETq/yuVoAGsOG4GKO6rVGonHmiv7zMWeZlxPVxtFEUDdPeK
         ZE5SpJpBp041qfIxXYGWNSCYN+l9186qSGFnbTkkbdHYYrM3Bu5pakc8aBK5odlIs5rx
         WeGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757950009; x=1758554809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lgIK+urtilm1qOsjSmDUUjKbzrkdpZTbpLIEbKtk/E8=;
        b=EUa3aNwdUP+SG8NTwn9xly8PUwe72G2a3eDe/wuwVXQSjoGiio3QdFg55docM9PHDR
         hHFhyDhRUswlnB8mzKwknOGpcvWsO2XHJncHG9HjXQhoFF8yr0bWf10EeJdg2eRK94sF
         LIIfLNVNfd6Wkvs08WlkMamuBgvW3SNr43iH/l433+x6yzdDDmR/tTcuzkMQXrU0zT97
         nBo5C3167KSYt47cuBGlqPkiPxExpbxfSHAZ8jPljDlamEWmO49CA7n5ODYyqNox3gEf
         goLGuy/bSs9QC2PAa8jg7A6lqxrCo6S8sAlQeHvglrOgCZUyDYHs5EyAKXZF6X9uJBHM
         RbFA==
X-Forwarded-Encrypted: i=1; AJvYcCVRV+Bx1nSiCWiNvcXbT869x/qDZICWzhbrLSIsn+EDXVbl5Jz3xdrVSJrpgdw5a4RYzTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzC3RTbsm+Wr0r4Uf2Xj2i6oLAsqUwaHzLzZyO9iLaxx/SW4xjy
	KRM+QGELGBEHp4HXg9RJKn5gIC5vwQOEQ8c3bCQJHuOiQwdYTaerR20QNOxt3ruwShk=
X-Gm-Gg: ASbGnct6epdz+2tDrU5pEPzT1eQYaLW+Jajc3BzpBr7KaCNw+cJrKI1p1FYNnkkLkCO
	hNYHObn4JTUZ3nZ+M7ZBBo5AXE2UrkXi+YA/QTABdOMS2BmhAfbQ3yOt5BXCJm1OHGt9vokIN72
	vYcjk+L1n9AiWF+pMC+JREsMLS9ZHvsuBtx99y2nZQHPEdrQLdK0SK1hDarVcH7MYU1rElADhlJ
	nisr4UHiaX6eylvJ0K+1SZ00jCkqOr9aMNQoH+Q5NHROsjjvOLv3Anmactgwx7mixckO7oc+AqF
	oMLCypDedy2J3Dk9R5c5QU+cJtpUzCbYNmo1SVRLbSedV/UZ9pW/TvPZVdVpdzlqYBnqsYH74wx
	Vffb+UeTQHmitiMgmsz9KdVwXkUabSFeCwXA=
X-Google-Smtp-Source: AGHT+IGp645TMnXX5YrOG2zVq4VnjBtkYnO7RTUiSqJt6Cj1uUCLMRmiK6QUARht6yH+1otNnwE4xA==
X-Received: by 2002:a05:6e02:1805:b0:415:fe45:3dfe with SMTP id e9e14a558f8ab-4209d7e0f1bmr156060435ab.3.1757950008836;
        Mon, 15 Sep 2025 08:26:48 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-511f3067b89sm4770679173.38.2025.09.15.08.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 08:26:48 -0700 (PDT)
Date: Mon, 15 Sep 2025 10:26:47 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	kvm-riscv@lists.infradead.org, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] RISC-V: KVM: Fix SBI_FWFT_POINTER_MASKING_PMLEN algorithm
Message-ID: <20250915-ed7932a34b8d58c2f9bdc4ab@orel>
References: <20250915053431.1910941-1-samuel.holland@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915053431.1910941-1-samuel.holland@sifive.com>

On Sun, Sep 14, 2025 at 10:34:20PM -0700, Samuel Holland wrote:
> The implementation of SBI_FWFT_POINTER_MASKING_PMLEN from commit
> aa04d131b88b ("RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN")
> was based on a draft of the SBI 3.0 specification, and is not compliant
> with the ratified version.
> 
> Update the algorithm to be compliant. Specifically, do not fall back to
> a pointer masking mode with a larger PMLEN if the mode with the
> requested PMLEN is unsupported by the hardware.
> 
> Fixes: aa04d131b88b ("RISC-V: KVM: Add support for SBI_FWFT_POINTER_MASKING_PMLEN")
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
> I saw that the RFC version of this patch already made it into
> riscv_kvm_queue, but it needs an update for ratified SBI 3.0. Feel free
> to squash this into the original commit, or I can send a replacement v2
> patch if you prefer.
> 
>  arch/riscv/kvm/vcpu_sbi_fwft.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/riscv/kvm/vcpu_sbi_fwft.c b/arch/riscv/kvm/vcpu_sbi_fwft.c
> index cacb3d4410a54..62cc9c3d57599 100644
> --- a/arch/riscv/kvm/vcpu_sbi_fwft.c
> +++ b/arch/riscv/kvm/vcpu_sbi_fwft.c
> @@ -160,14 +160,23 @@ static long kvm_sbi_fwft_set_pointer_masking_pmlen(struct kvm_vcpu *vcpu,
>  	struct kvm_sbi_fwft *fwft = vcpu_to_fwft(vcpu);
>  	unsigned long pmm;
>  
> -	if (value == 0)
> +	switch (value) {
> +	case 0:
>  		pmm = ENVCFG_PMM_PMLEN_0;
> -	else if (value <= 7 && fwft->have_vs_pmlen_7)
> +		break;
> +	case 7:
> +		if (!fwft->have_vs_pmlen_7)
> +			return SBI_ERR_INVALID_PARAM;
>  		pmm = ENVCFG_PMM_PMLEN_7;
> -	else if (value <= 16 && fwft->have_vs_pmlen_16)
> +		break;
> +	case 16:
> +		if (!fwft->have_vs_pmlen_16)
> +			return SBI_ERR_INVALID_PARAM;
>  		pmm = ENVCFG_PMM_PMLEN_16;
> -	else
> +		break;
> +	default:
>  		return SBI_ERR_INVALID_PARAM;
> +	}
>  
>  	vcpu->arch.cfg.henvcfg &= ~ENVCFG_PMM;
>  	vcpu->arch.cfg.henvcfg |= pmm;
> -- 
> 2.47.2
> 
> base-commit: 7835b892d1d9f52fb61537757aa446fb44984215
> branch: up/kvm-fwft-pmlen
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

