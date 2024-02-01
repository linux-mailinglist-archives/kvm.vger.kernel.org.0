Return-Path: <kvm+bounces-7677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA3F8452BA
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:29:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FAC51C25D7E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 08:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE6115A48D;
	Thu,  1 Feb 2024 08:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KhJAIdt3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9726159591
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 08:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706776188; cv=none; b=qB+nN+45lMoTwxULRQwD+MUYtB4gTHZHfPMYji9YvgCohjFzh1yQge2Ub7XKaJutcLAe5Jcm6UY6Rt0fqUdoc/OYl0JVt6mVnzvMIlZ0Cl7H9oPlI6KY1M39pBZbgTb9cZPWsK0Ue5TmELC2/xZrsL/lcxaD+9TqNUJMtGRubYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706776188; c=relaxed/simple;
	bh=v+hGC2bF3Nf5l9lcZ2uOTOpTduo3WKTrXxiRGoug7UA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fx03MpDd3f2oCsEtTQJ/gtEv6oDvItt/388KYllnaAfII2phoz4vc+Tc8lIF1f/dmBD8LPRna9BsaP2AHGIcuIEK17xqG226ZiwdOVzqkhble18BqDrm7ArT3NNAvbALmsky+rXCEuzx53KpZ1XU7/klaroNDP1CYw+x0BP9iTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KhJAIdt3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706776186;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mvQ3t1b1ivJLmzpQbMo2uY7w94izskCRDvtsOIIftSI=;
	b=KhJAIdt3avlnwFYVGaIhEfUdpbvZB7HAh3CZKqSQkHnvAU3o3qbn4HiSg7mlILiY4NRNgu
	4AKWcnFlAuGa0e33r4Ik4QI95egmNEOn3cyjxvOQpb8ehVKpGabNXhwgCPZ18/6umcIPT0
	PfAfxQOQsPvdQ0W0MW9cz4NbhRXx4uU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-zwEy0ZAWOEekEkvN-8HLsA-1; Thu, 01 Feb 2024 03:29:44 -0500
X-MC-Unique: zwEy0ZAWOEekEkvN-8HLsA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40fb03d8a39so3772095e9.3
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 00:29:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706776182; x=1707380982;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mvQ3t1b1ivJLmzpQbMo2uY7w94izskCRDvtsOIIftSI=;
        b=ESQq12wStJ1DoaxxO42BDDxTD1JK7edlOV+Ih94zfMH2C40VA2jXvjpRkc9v714rYr
         kCinizxUPGN0Yv8yLgf/eoiJet42MnvxcvWHfsPenmqHEMIhVm8nA9XMX5ddpTHcRnBM
         GnyjKJqHQbLFisoyW/38msHhmoXdsesjlhqtFyInHRUi/9kmJtNqRep/mauh2fwwecvo
         nOPWeQl2nMqJf7DDWL1zEhX16xS3/H3k3qmTTg3KYwLKlRAp/wC/H7GUTI5ZMGq9lsGo
         Fu8lppwOZSZSKmUH6n/o8P8lkMwut7jx4xd/cZAu16ZprSXNzrIynU9MJJEyHmPZV+Mp
         Pd9w==
X-Gm-Message-State: AOJu0Ywdx7ahp9+nFKaYpqUNZ5RKGNQNTDCNIVVbYatUTy2wKGcZhRyB
	3IeSba5Noi79pt/DDVA+Ip7O4rF6fvKB58ZhQK+t8ox/TwVOpBBSlsUcUCTqYtosBeEzQJDJZYa
	uNALL+G05POcrpcdIozF7Se++QA6Vlz1ntutcqaz2QNZ83xw5DpnHIO5jSw==
X-Received: by 2002:a05:600c:41d2:b0:40f:afdc:7477 with SMTP id t18-20020a05600c41d200b0040fafdc7477mr3822285wmh.20.1706776182354;
        Thu, 01 Feb 2024 00:29:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHNDQLfzYQI4T9FsqCEhRvg6ZoySIqDCeBCbmTQSfGq1e5bLw9dmeKixhTiSNBORQCcxAOWfA==
X-Received: by 2002:a05:600c:41d2:b0:40f:afdc:7477 with SMTP id t18-20020a05600c41d200b0040fafdc7477mr3822268wmh.20.1706776182023;
        Thu, 01 Feb 2024 00:29:42 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVwXA/biyzycIzVd+P0rzohqAvgBKY4Y1Fbs9dzml3U5OaENh6NWpA5f4yXY3YJn56B9F67BRqsCXZVxhHpmlb+8l9p3rRJtt4F4FDBEKjVpMuzlZSW2TOOljXKmKAwm/b/7BKd3k/Wx7TJAFYb2xQHveM/Hunx3JuIapKlTPLfeyOo+GWgkgN7tdMc3BOcdkGi1HfbD1NMgHYnVsrWLRS/2MbeRiqjfcUL4O2G992z8LwTKskizVmvNeZSTRx9EHcsHGz/JxRzV/0BFvdoilP1VwvqGlKHkHXCIFvCiF+wUf2x+e8joTU=
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l12-20020a1c790c000000b0040fba120c0bsm446368wme.0.2024.02.01.00.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 00:29:40 -0800 (PST)
Message-ID: <ded71dfc-0233-4f91-9c27-69845836ba44@redhat.com>
Date: Thu, 1 Feb 2024 09:29:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 01/24] configure: Add ARCH_LIBDIR
Content-Language: en-US
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com, anup@brainfault.org, atishp@atishpatra.org,
 pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-27-andrew.jones@linux.dev>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240126142324.66674-27-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Drew,

On 1/26/24 15:23, Andrew Jones wrote:
> Prepare for an architecture which will share the same lib/$ARCH
> directory, but be configured with different arch names for different
> bit widths, i.e. riscv32 -> lib/riscv and riscv64 -> lib/riscv.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Acked-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  Makefile  | 2 +-
>  configure | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 602910dda11b..4f35fffc685b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -10,7 +10,7 @@ include config.mak
>  VPATH = $(SRCDIR)
>  
>  libdirs-get = $(shell [ -d "lib/$(1)" ] && echo "lib/$(1) lib/$(1)/asm")
> -ARCH_LIBDIRS := $(call libdirs-get,$(ARCH)) $(call libdirs-get,$(TEST_DIR))
> +ARCH_LIBDIRS := $(call libdirs-get,$(ARCH_LIBDIR)) $(call libdirs-get,$(TEST_DIR))
>  OBJDIRS := $(ARCH_LIBDIRS)
>  
>  DESTDIR := $(PREFIX)/share/kvm-unit-tests/
> diff --git a/configure b/configure
> index 6ee9b27a6af2..ada6512702a1 100755
> --- a/configure
> +++ b/configure
> @@ -198,6 +198,7 @@ fi
>  arch_name=$arch
>  [ "$arch" = "aarch64" ] && arch="arm64"
>  [ "$arch_name" = "arm64" ] && arch_name="aarch64"
> +arch_libdir=$arch
>  
>  if [ -z "$target" ]; then
>      target="qemu"
> @@ -391,6 +392,7 @@ PREFIX=$prefix
>  HOST=$host
>  ARCH=$arch
>  ARCH_NAME=$arch_name
> +ARCH_LIBDIR=$arch_libdir
>  PROCESSOR=$processor
>  CC=$cross_prefix$cc
>  CFLAGS=$cflags


