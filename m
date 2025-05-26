Return-Path: <kvm+bounces-47707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 74FFBAC3E57
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 13:14:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CA641896BE0
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DEED1F8ADD;
	Mon, 26 May 2025 11:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Jfhx1B3P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8560A72600
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 11:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748258045; cv=none; b=X2NHjW0rc7zw49dzHqD9DYEL8pz+hBQQjw0u8eMFsxnPuRofI4bZcuSWEEa9s728qLXr7L/9t8BBjIcnl4quEziWax/amJq0hRuYwtn76Ynjny8Vy9GEgETNvazQwe6l6zEli4HpCg2mPsI8kp3wp7c6uYVuNGIpSM3z+ewmCYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748258045; c=relaxed/simple;
	bh=VnAgd0ZQRivApTR3Ldr5WYwHCJLxJNgqjBaNl5DS1Ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hVQd/z5q8ZJN54aVIw3bb0uMH4ju77PNqZ0U3aCpY2Ia4vxn04YQbVFCyAOAsOfDcEgPKqRtSICl1Fi//xKOkcIxOD8awvCoWzFAzhhncqtkqb2elzIywYnUOT7Xw+1QgJQLzFf/RgV192src6tpDwtuCS4CmAmj6fsLawl27yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Jfhx1B3P; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a365a6804eso1246772f8f.3
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 04:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748258042; x=1748862842; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1qGPkkOzz/AvcHXID85KRR2dfTKt6dbyAQOGmEwhnXA=;
        b=Jfhx1B3Pvz7gQ9A4b1+ihmbbCLVcUEkJPx5tG1uy9QiKB5QDFmZDLkAi19eUTuLlfx
         9Rd5+1lkrMHCL4xe9d7xVaF3oXL31FMnONihOSqEMm9WDGA08cj5XoZkFDbzW+/jTk8S
         Fvtkt0uh1kj8u9ZVDgjY/NRgC+k4KGoZrKDyFW22ILBY/8GJClANav3y9U6ZVBE+OLZ+
         zcPrH/QjG31aEirRja5RLoxdupCqTa+zcuGU25JmCmu7pZbDAVgXm0EptTSpr5tg9/o6
         Hx+GUu1iI/mIfMJpMxpctROQCAzEdWGrUoOqV9CFQ+R+EWgRQmCLVysZrzXOBo5OTRde
         3FqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748258042; x=1748862842;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1qGPkkOzz/AvcHXID85KRR2dfTKt6dbyAQOGmEwhnXA=;
        b=jvG8lIvCMfL/DXPtW/iXxmj6T2Tmtz/6ZzMH/hJSX+PO+plXPF/oYrwtD5FukSFgsl
         /C3tLG38b5ONbo8550X3oda3bkrjqx1KW7AxZekmFu6LCAoJiGNJr0raPIt/syxt0qmW
         07tygaU3RwOg3uWi4NHHvqiuRF39W5z6VPDUXnAOdTuPYlziQDst9jykYcVwQc1RGW7N
         4SPCQ+osExOVk2oIG4x8Euc6J6R6BLqBSGwm66DCigAYq/zvnj1lHEPhEbNf727qiw29
         VcxBdXmDUGk9t8KqERzRiKqYKtfPj5QiCYc0EHS/6AZhcjc92HOhcT6OXo3eFvuFZORJ
         4X0A==
X-Forwarded-Encrypted: i=1; AJvYcCWvhhIvG+wjDvtlnHdJdeg4t0SmngVv55HNV1H0Wo67ZmCj2SZelb8M6xLDUPjvRnF0fdM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxenG1QLVJnTSJKLbuo5Xy6OVtvy5R9Kb4SMGJ0PMMRzp9NXxWw
	ZUJMzNgsoFT4v/Jp6jJsTVUlYHJwbHxeDL/3Adp/6Bq3/kR6iXVZEvevYVaBHeIWE00=
X-Gm-Gg: ASbGncu3ejbQQeGxXj2tfl2+ryU8Zx7MFrrGkrI6Y0YKrviWOOM9bm01gp3+n2H+hWp
	lZeftTlipOjcda+zRDc9VzJpfmvwV8u8WgpyTLYFZEtE2ldIjuRjPn4jfwsdcYpn/N0lh4ID2ZV
	POh2IbGvXoWub9bv6Rru6mGZNqqHukGUXDPJExwMduOQZc6KjTAvAcx1CiTQ17zdhIEe+P/UifL
	lFhkZme7f6tqDoOJY2sQaJT5h6Dj+7ZbhjhCs6Rcw9qOkXNxePo4KCM4b8r2RAajHCXzHKVjPbx
	Uu0corAMxvn74HpJJbexC/IJfduhgFa6z5eLtMJcOAfNPsV9b2x15W2SE68vC9ooISqWUHe5QHU
	3tLYi
X-Google-Smtp-Source: AGHT+IEohXUMBSqO1qFUGi+04cLdFeL8i/QAY/ZQ64aMi3jtMK4s6/6493H521FOcUTuehMxIQIXpg==
X-Received: by 2002:a05:6000:40d9:b0:3a4:c2e4:11b with SMTP id ffacd0b85a97d-3a4cb4a962amr7086907f8f.51.1748258041562;
        Mon, 26 May 2025 04:14:01 -0700 (PDT)
Received: from localhost (cst2-173-28.cust.vodafone.cz. [31.30.173.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4cc932836sm7397037f8f.39.2025.05.26.04.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 04:14:01 -0700 (PDT)
Date: Mon, 26 May 2025 13:13:59 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>
Cc: Atish Patra <atish.patra@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Palmer Dabbelt <palmer@rivosinc.com>, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv <linux-riscv-bounces@lists.infradead.org>
Subject: Re: [PATCH v3 9/9] RISC-V: KVM: Upgrade the supported SBI version to
 3.0
Message-ID: <20250526-224478e15ee50987124a47ac@orel>
References: <20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com>
 <20250522-pmu_event_info-v3-9-f7bba7fd9cfe@rivosinc.com>
 <DA3KSSN3MJW5.2CM40VEWBWDHQ@ventanamicro.com>
 <61627296-6f94-45ea-9410-ed0ea2251870@linux.dev>
 <DA5YWWPPVCQW.22VHONAQHOCHE@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DA5YWWPPVCQW.22VHONAQHOCHE@ventanamicro.com>

On Mon, May 26, 2025 at 11:00:30AM +0200, Radim Krčmář wrote:
> 2025-05-23T10:16:11-07:00, Atish Patra <atish.patra@linux.dev>:
> > On 5/23/25 6:31 AM, Radim Krčmář wrote:
> >> 2025-05-22T12:03:43-07:00, Atish Patra <atishp@rivosinc.com>:
> >>> Upgrade the SBI version to v3.0 so that corresponding features
> >>> can be enabled in the guest.
> >>>
> >>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> >>> ---
> >>> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> >>> -#define KVM_SBI_VERSION_MAJOR 2
> >>> +#define KVM_SBI_VERSION_MAJOR 3
> >> I think it's time to add versioning to KVM SBI implementation.
> >> Userspace should be able to select the desired SBI version and KVM would
> >> tell the guest that newer features are not supported.

We need new code for this, but it's a good idea.

> >
> > We can achieve that through onereg interface by disabling individual SBI 
> > extensions.
> > We can extend the existing onereg interface to disable a specific SBI 
> > version directly
> > instead of individual ones to save those IOCTL as well.
> 
> Yes, I am all in favor of letting userspace provide all values in the
> BASE extension.

This is covered by your recent patch that provides userspace_sbi.
With that, userspace can disable all extensions that aren't
supported by a given spec version, disable BASE and then provide
a BASE that advertises the version it wants. The new code is needed
for extensions that userspace still wants KVM to accelerate, but then
KVM needs to be informed it should deny all functions not included in
the selected spec version.

Thanks,
drew

