Return-Path: <kvm+bounces-51037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 040EAAEC2D6
	for <lists+kvm@lfdr.de>; Sat, 28 Jun 2025 00:52:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5822617B397
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 22:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F3E28A1F5;
	Fri, 27 Jun 2025 22:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nMgHVoDw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535E917C21C
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 22:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751064715; cv=none; b=S0YVdEnrMj8kzkKaLKKKhYl+PnkQQTudtInV9xxJkC7ceRenvNWE0vpsXulepHRPdGmWHQeUguYtph452/iQu2kdZE9sqMkSsybX3jItwRqZOLMW6tYcUXoBoNQUeibhFXk+4gtycc5Pfj+z2EEfa+RhK4CX2UaGTnMUN+LCWZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751064715; c=relaxed/simple;
	bh=SRUPsLnI9deOQiANX6xtUo+nys4meonIOJ5W0zV85XM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xa8nWlreHTBDHlbCnDagdeehGPSzll9lNIlQPf+T8Q5CrA4pOoJLYoJvR16qkINTI+QeHmAuOiexuMyQGKO3SxH6s8y/L24bhw/chvJaODIRuvMa8oJFxynKuFMjZlZtCcVnl+vNZQeef4tfC5y6tZ/sM+0gwF3cyc5WSLZLL2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nMgHVoDw; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b271f3ae786so2681560a12.3
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 15:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751064713; x=1751669513; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zrgbA+YV6Dq47S8g1aMafN9mf4W/rBrO4r5DJKTm4f0=;
        b=nMgHVoDweeb6do3ZdcQ1gYpaSEycnvuQbD38EHB53XGa77lyF6j7XYWxDQJy7k8slI
         2FyrAVsRgCw2xZxMLl4flyMOfmhJMsKKwOeIbjdKFQ8AyvN7uf34xMSYWJ28XECUlzWz
         mU9jAeNiYN4NQo7y2QSijmy+EP6C8FVD4gXBU5VnFOZWRz+pNgKi1q8OaPdhZ/Jd7sQ4
         Uq5aewOZuq11+5UFFXo152dm0gG3EvWiopT29xpMh+dOsTYsKjClxtv8iQ/9tvO6RHgN
         6Cew1B49EWalyADNcvLwZtx9NVNW/y5qEWfaG+ZlKie/fzYyJC4sUNfLSplEKWkyxZ1f
         HfKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751064713; x=1751669513;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrgbA+YV6Dq47S8g1aMafN9mf4W/rBrO4r5DJKTm4f0=;
        b=gMbKEZAQTgNLo2ugXsuVBlRYtutj/tnz2bXtlY0+8pg3nwHwuFSNTmKwwhXZSgMF8U
         64VhzSumr5DbStT2v/s/wnZFww+208NbzaFY/gahQzNA6iAjBo+8ul2C/joehUSXNJKe
         KvajFCM3qnlIljzToPH6TD4HTD2l4hjODxB16e00xGttcZQbGCn0xi5y15ipY/ZWauI2
         SqkDHnKo2gAA7M3FsbN+Z1+SuofxSXBw9+yQoTM0NJ0nhLwdtYcTJe8YDZNDqQr5UBnX
         tqt9D9KZkGWeD5sRb3Ah2WjLkdMiaGN9jc6cQNK2u/t+Hv7dvufkaq0mprZ1T9dJ7m3w
         pJMg==
X-Forwarded-Encrypted: i=1; AJvYcCWYoCqRXmoxlt7vc7+1DLxSSn2FT8VVl0yr71rH5dcD9o7Wq0s1C+Z8NcdJygPt5Lm0Ic4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcqiAICtensAtOcFH+utOwDqA33zh/VpQ/3etB9Hb7dJhs5iW2
	t3OTAR9RTqbeGa8lv6U4+hjiYQ6387yhymoFPc5EF8su61FS8viXBfpeN54hSh0Kkg==
X-Gm-Gg: ASbGncsAsfj6HMRq6IUZCZIJpawSbMsca/By+WEvzO0uRNybFO61j+fPE5zMw4QGDP3
	W7xHgV2Uoy0ASoFtqYX68ylo39SXRMg+S0g4EP7Mfd6tOMc65JwU5UytkpJYNvKZdyPo5SatA4h
	6A0RzQsFRPJkmjazUR4GSf9NRsMIYhXZ47SKS5aR/f86wKN8sp9DilESHLsrTAD6HV6vqPk0sVP
	lc2sqkaVU8PnIoeLpL+IG4eHM6O4BlJOpTcSWfZDs3P64kc4b5jF32X7pzw5+SqiNE2/x+JCH4W
	Rgs9xf1d7C9xnVSB1XvLi2uQO3hEfnfXVRdTLHp8ZEm7Nll44vCUVYtRTiNvTamOva1Rk7zm8CT
	OdPX+uDVpruocSLYgWjFecGWc
X-Google-Smtp-Source: AGHT+IHagFo7VIqD8ggkCrEdYv8lbO7FJ4rzDCefigLIJjtEeVO7DdEuhKw2vqBnIdxWqt+DF7VfQw==
X-Received: by 2002:a05:6a21:62c1:b0:21f:54f0:3b97 with SMTP id adf61e73a8af0-220a12d37e4mr6635186637.15.1751064713393;
        Fri, 27 Jun 2025 15:51:53 -0700 (PDT)
Received: from google.com (111.67.145.34.bc.googleusercontent.com. [34.145.67.111])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557460fsm3272779b3a.93.2025.06.27.15.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 15:51:52 -0700 (PDT)
Date: Fri, 27 Jun 2025 22:51:48 +0000
From: David Matlack <dmatlack@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: alex.williamson@redhat.com, bhelgaas@google.com, vipinsh@google.com,
	kvm@vger.kernel.org, seanjc@google.com, jrhilke@google.com
Subject: Re: [RFC PATCH 3/3] vfio: selftests: Include a BPF script to pair
 with the selftest vfio_flr_test
Message-ID: <aF8ghBgTwMQ7bKiX@google.com>
References: <20250626180424.632628-1-aaronlewis@google.com>
 <20250626180424.632628-4-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250626180424.632628-4-aaronlewis@google.com>

On 2025-06-26 06:04 PM, Aaron Lewis wrote:
> This BPF script is included as a way of verifying where the latency issues are
> coming from in the kernel.
> 
> The test will print how long it took to initialize each device, E.g.:
>   [0x7f61bb888700] '0000:17:0c.2' initialized in 108.6ms.
>   [0x7f61bc089700] '0000:17:0c.1' initialized in 212.3ms.
> 
> That then pairs with the results from this script to show where the latency
> issues are coming from.
> 
>   [pcie_flr] duration = 108ms
>   [vfio_df_ioctl_bind_iommufd] duration = 108ms
>   [pcie_flr] duration = 104ms
>   [vfio_df_ioctl_bind_iommufd] duration = 212ms
> 
> Of note, the second call to vfio_df_ioctl_bind_iommufd() takes >200ms,
> yet both calls to pcie_flr() only take ~100ms.  That indicates the latency
> issue occurs between these two calls.
> 
> Looking further, one of the attempts to lock the mutex in
> vfio_df_ioctl_bind_iommufd() takes ~100ms.
> 
>   [__mutex_lock] duration = 103ms
> 
> And has the callstack.
> 
>   __mutex_lock+5
>   vfio_df_ioctl_bind_iommufd+171
>   __se_sys_ioctl+110
>   do_syscall_64+109
>   entry_SYSCALL_64_after_hwframe+120

Very slick. Can you share the sequence of commands you ran to load this
script, run the test, and get the latency data out of the kernel?

> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../testing/selftests/vfio/vfio_flr_trace.bt  | 83 +++++++++++++++++++
>  1 file changed, 83 insertions(+)
>  create mode 100644 tools/testing/selftests/vfio/vfio_flr_trace.bt

I'm not sure where we should put this to be honest. Did you want to get
this merged or is this just in the series for visibility?

It would be nice to have a corpus of BPF traces checked in that people
can easily use to debug issues and time things while running VFIO
selftests.

Perhaps just put it in its own directory, e.g.
tools/testing/selftests/vfio/bpf?

