Return-Path: <kvm+bounces-32738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C709DB459
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 09:54:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70674B2275F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 08:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377E214F115;
	Thu, 28 Nov 2024 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="mJpAY+BC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC63D1531EF
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 08:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732784088; cv=none; b=IP0SJ+oz/YV+9jxJEmS5Dy1Q2Fhozc9ra2ymGWTUNIQyaD8ICggJ0oCp+ekcsAtfY95LdNTjMqsIpuK24ru0W9p0epcyAJemHcsS4a+8kLkLa3EVUwWvtuddabamBxnNISnaX3dugRTnb6a8zuFC79tgoblsKgCzHAirUrWAcJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732784088; c=relaxed/simple;
	bh=h9K4BWfaJ1EiWfgoH2ZK2XnoeiC9er1wzw7T6GcNN0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQZUHU8DN8T65oM6BiHxL3Bv02E89AcmB8gDM4KLxbdiWtxjwjwlXN1xQtjfH8KuADmIfU+rmEEmkbQh7L/gjs26G1zuGoF9Z1b0VtgDvdIJCoSHphuwcwI/Odrun7r74Q/cWBz0hNT5LLY7JkMWTS0nz8x1AvDLR0Iv9SaVhGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=mJpAY+BC; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-434a8640763so4945335e9.1
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1732784085; x=1733388885; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=taBVx576Mb1d9PyRzDmNA5pfsmrnP1DVnZEuUXxBBrg=;
        b=mJpAY+BCgSK3XUoYZe270d21yJ768dmZQJ76qqTJmrIWYtoMg0bHhQcpv/TWC8Rztv
         PmeHuCR6A6djRwnafXjhff6WLyUBTV0GjnAFRpfNTtRbPuB93mopg8ALrdCCkHFHay26
         /qnN22M7496DV/1INCJdKT3+k7RS3m+zio6yNSTy2y9aWFYLWrCX98tYqIW6k9XYkUCF
         C9TDk67GtSWgWVNfMG2CUwl7Wey9KgxHIbf/pZBj3XppcqLLJW30w/mUx4ZEnmhGDbqa
         FHwmW/L1o4gSGYtKubiWmR87YokUcLgqS3csBVvljvBC+gEaOJTeK6CIv30DEL44cwTF
         GQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732784085; x=1733388885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=taBVx576Mb1d9PyRzDmNA5pfsmrnP1DVnZEuUXxBBrg=;
        b=hn4Hpuhccgibol41Xa2Gzet9tD87Nq1W4d1OfS5kWjRAh/oywsZHi4Ihrr71H+2tpf
         FejI5DS8VQynnbPaEICnC26lwDlPisV70ZpSmBwcwq2VER4kMfz324957bxta/USdfJq
         IzkaPqCjQL/GQJ85iMu0TWK2oaOE/1MZQxQyyiKLDsXpAVBTo3TzNO6kZ0Zajkb6cE2N
         GVCBnHg7bHLXeFE2sw15GLpsy442wBJnOx/O2uyJ3qLons8uDtqSNsseqn5LOjuwLp3U
         1J087vIsz0hppPvV5ztkeGLQLaXHQDZul7B9KPJXVIGMGajPY6bwNQ8zfSd5b5a0D39v
         pOtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTQOY7AsAZLyPRAcTaXl06tRk9YeXvCK8cDF5gxxD4/K94FidS6IxDp2vBwBS+qXXDl/c=@vger.kernel.org
X-Gm-Message-State: AOJu0YymqJVSgC2+APK3T/uugZryHfjL/D9aDBU4xFSIjNLAtRhSDBxc
	HcK/bT/78Kc5fr3HV9N3var15u7s1eb+ERkGmtnHxR562L2gpJymZmteS7ng9KY=
X-Gm-Gg: ASbGnctSsRQavuXFnC3SWIWYweuPG2MzYcKxzl+4cJ6fSQhPD6vDE9YuQcKYqk1bqnz
	7/dS7iB0wA02fgoBgv3zxxM1D8n+m1yESoX4H2i6XSZssqKuMgWGdhpST4vXQxsK1NHRg0FKLjf
	yNJaLL/WpxPl85ea915TEovzWeIunZm1f1A1FscTIHj92ZTefE5s7RUEVFpTxEG3jNLg1ed5uja
	lijuMldZH0CYlMSu4FmM6opvT3BQOUPbnlA46GSZrCamX1zTHknzFd/9r75MH0D9oA/DbF1gcbo
	vYZGx2ZHlVEbFuOJ5RusXrvlg0NrbLwenSU=
X-Google-Smtp-Source: AGHT+IEntdOWnTKPyyviVSOvyKSQxfhN3cgjS0CqUnt2K/m/lFqUeDFCwz3Y0hrrEdviqAlNmfKsKg==
X-Received: by 2002:a05:600c:314d:b0:434:a75b:5f6c with SMTP id 5b1f17b1804b1-434a9dbea45mr66592635e9.10.1732784085239;
        Thu, 28 Nov 2024 00:54:45 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434b0dbfa2csm15280125e9.17.2024.11.28.00.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2024 00:54:44 -0800 (PST)
Date: Thu, 28 Nov 2024 09:54:44 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, linux-kernel@vger.kernel.org, 
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 3/4] RISC-V: KVM: Allow Ziccrse extension for Guest/VM
Message-ID: <20241128-9f7234d55cedf2afd881f82a@orel>
References: <cover.1732762121.git.zhouquan@iscas.ac.cn>
 <77198ab759eb01ca490f4c2199910e778b57d372.1732762121.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77198ab759eb01ca490f4c2199910e778b57d372.1732762121.git.zhouquan@iscas.ac.cn>

On Thu, Nov 28, 2024 at 11:22:07AM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Extend the KVM ISA extension ONE_REG interface to allow KVM user space
> to detect and enable Ziccrse extension for Guest/VM.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
> index 340618131249..f7afb4267148 100644
> --- a/arch/riscv/include/uapi/asm/kvm.h
> +++ b/arch/riscv/include/uapi/asm/kvm.h
> @@ -179,6 +179,7 @@ enum KVM_RISCV_ISA_EXT_ID {
>  	KVM_RISCV_ISA_EXT_SSNPM,
>  	KVM_RISCV_ISA_EXT_SVVPTC,
>  	KVM_RISCV_ISA_EXT_ZABHA,
> +	KVM_RISCV_ISA_EXT_ZICCRSE,
>  	KVM_RISCV_ISA_EXT_MAX,
>  };
>  
> diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
> index 9a30a98f30bc..ed8e17da1536 100644
> --- a/arch/riscv/kvm/vcpu_onereg.c
> +++ b/arch/riscv/kvm/vcpu_onereg.c
> @@ -64,6 +64,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
>  	KVM_ISA_EXT_ARR(ZFHMIN),
>  	KVM_ISA_EXT_ARR(ZICBOM),
>  	KVM_ISA_EXT_ARR(ZICBOZ),
> +	KVM_ISA_EXT_ARR(ZICCRSE),
>  	KVM_ISA_EXT_ARR(ZICNTR),
>  	KVM_ISA_EXT_ARR(ZICOND),
>  	KVM_ISA_EXT_ARR(ZICSR),
> @@ -157,6 +158,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
>  	case KVM_RISCV_ISA_EXT_ZFA:
>  	case KVM_RISCV_ISA_EXT_ZFH:
>  	case KVM_RISCV_ISA_EXT_ZFHMIN:
> +	case KVM_RISCV_ISA_EXT_ZICCRSE:
>  	case KVM_RISCV_ISA_EXT_ZICNTR:
>  	case KVM_RISCV_ISA_EXT_ZICOND:
>  	case KVM_RISCV_ISA_EXT_ZICSR:
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

