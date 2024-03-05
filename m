Return-Path: <kvm+bounces-11005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 229D08720CB
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:50:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9AC72B235DF
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1A486126;
	Tue,  5 Mar 2024 13:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ZRYqpTdU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E3B85C70
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646594; cv=none; b=nxPlKfHmelmbEiToq/U+ZTIuk0eJC/rIHTMuB2TdqoB+ey6AQO0LZMM4AmUmWvO1cr/z56HVCEnFxYP6bOoGKgHNFAoYJbUzUq+feqrPecWPc+CVDwKVEI3UCxf18M1MpOHoiU6q0L1R/JzeKgcFv8M7ivVhZaBzWOS8LXXFTV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646594; c=relaxed/simple;
	bh=6AComI2PwegoJTdvsBhjQcYMUeF/26dWipLm9tFEEDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rVqcn/fGu8NvnqPMO5aY7OmY6EJXkn7SD7M3sE57ozki5KvJVpFDf+IrBWgRMLxC8x91x5491Sg2X3VqwvJAji4d3Y/VkkVS4wHtRgMmey54H02iQ6hpPkV56XAlzAAIvfaZp7ilDxi0rDuM50TLopuKryl/YOeN65/M50Rdzw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ZRYqpTdU; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a4595bd5f8cso135335266b.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709646591; x=1710251391; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2YK+IIJxNnOvnoKo5nYctzuLxHvmtvPM8lORcAAbnwc=;
        b=ZRYqpTdU8vFqTh9q3Zi9aerTu4/F1PMS3U6DELKGuUY1HEzK0E8REwtpDudVix6iZg
         FoqC1o1UuTutjWJtJc/2KBrC5Y2TTFhVu7NULFxa0T5CKz7OddE1SJLRKSWXUiTaPk9t
         YaPjGCc1Y2621lOBU+NmsepZpdnA6ha7STNPImXL/oi94mV/KjKFUw1vGDU+h1mg5PVB
         aPQMwZhQ5zDXnx58ufxU0n43tXNgtUr1xoAC//4ktHSw4kb514OOrKvQkoVn6FVQkks3
         N3a9Ru1z00czYiiEa+dPi7FsbIJpuvKYc6C9HCMVb52d+6aOgA6WDjXcH3HHT+diIeVJ
         HWvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646591; x=1710251391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YK+IIJxNnOvnoKo5nYctzuLxHvmtvPM8lORcAAbnwc=;
        b=RFD7WSRm09iuLh1ioTvSUvAmd7nkNUMnav6eyW44Iiso3f9zvCtygEQOG/nwbtnac5
         u+8x4BRcAzoPZnpZwh94MwEMu1SvXGZaB8ZeLS8krxJcqOCmiluDEUnE/+Jz7ERglZMF
         aqOPjS05ZW9TmCpz3SfCUPT8/hcCcGCTVVqZQgEZs8hOWdMdstvekY3tRrVvF47IMOfU
         qL91u9OAlWSq1Hmi+iskRyRecNL3yaih0xkWZAQUjNb5WUTC9iQGHINcagVaup+vlmbK
         eYp32nvPwpQY/UoAHz+l5L0iO2ysdZmCWGoAo2J0l8ztKiBYmLDdW6RbugLC38aX/5xP
         JsWA==
X-Forwarded-Encrypted: i=1; AJvYcCVX/Zu6NbMX0zvlX2hBKUeITP/qE3QipIPrPBe20IBa2fEBFX0KZxQg0dT/NVdbD1gt94uYGUIiH/GdlHqSq0DIoRon
X-Gm-Message-State: AOJu0YyTbmFoipWyCscPedu/fjq1n41KALTGUmh5oBNNG7pZPbGnes1F
	JonHQU6NsGWk4p6HNmAA7xG6zms6oCzTp7fRIAChBdnJfp0OKzbuZyJbwiXoB4M=
X-Google-Smtp-Source: AGHT+IHoNhg3TapRQmRqQt4iU9gKg19SiXdIlpmcpCu/4c4DWUn6Ve5YD7eHnbbpf+O8A070MD3Pag==
X-Received: by 2002:a17:906:ff53:b0:a43:5bc6:17f3 with SMTP id zo19-20020a170906ff5300b00a435bc617f3mr8967534ejb.6.1709646590950;
        Tue, 05 Mar 2024 05:49:50 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ub10-20020a170907c80a00b00a443a72b136sm6237912ejc.177.2024.03.05.05.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 05:49:50 -0800 (PST)
Date: Tue, 5 Mar 2024 14:49:49 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Anup Patel <apatel@ventanamicro.com>
Cc: Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com, 
	maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Atish Patra <atishp@atishpatra.org>, Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH 06/10] riscv: Add Zfh[min] extensions support
Message-ID: <20240305-73825a2f931646d505e2072f@orel>
References: <20240214122141.305126-1-apatel@ventanamicro.com>
 <20240214122141.305126-7-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214122141.305126-7-apatel@ventanamicro.com>

On Wed, Feb 14, 2024 at 05:51:37PM +0530, Anup Patel wrote:
> When the Zfh[min] extensions are available expose it to the guest
> via device tree so that guest can use it.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  riscv/fdt.c                         | 2 ++
>  riscv/include/kvm/kvm-config-arch.h | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/riscv/fdt.c b/riscv/fdt.c
> index 44058dc..7687624 100644
> --- a/riscv/fdt.c
> +++ b/riscv/fdt.c
> @@ -29,6 +29,8 @@ struct isa_ext_info isa_info_arr[] = {
>  	{"zbkc", KVM_RISCV_ISA_EXT_ZBKC},
>  	{"zbkx", KVM_RISCV_ISA_EXT_ZBKX},
>  	{"zbs", KVM_RISCV_ISA_EXT_ZBS},
> +	{"zfh", KVM_RISCV_ISA_EXT_ZFH},
> +	{"zfhmin", KVM_RISCV_ISA_EXT_ZFHMIN},
>  	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
>  	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
>  	{"zicntr", KVM_RISCV_ISA_EXT_ZICNTR},
> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> index ae648ce..f1ac56b 100644
> --- a/riscv/include/kvm/kvm-config-arch.h
> +++ b/riscv/include/kvm/kvm-config-arch.h
> @@ -64,6 +64,12 @@ struct kvm_config_arch {
>  	OPT_BOOLEAN('\0', "disable-zbs",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBS],	\
>  		    "Disable Zbs Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zfh",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFH],	\
> +		    "Disable Zfh Extension"),				\
> +	OPT_BOOLEAN('\0', "disable-zfhmin",				\
> +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZFHMIN],	\
> +		    "Disable Zfhmin Extension"),			\
>  	OPT_BOOLEAN('\0', "disable-zicbom",				\
>  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
>  		    "Disable Zicbom Extension"),			\
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

