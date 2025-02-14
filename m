Return-Path: <kvm+bounces-38197-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 457D0A3673A
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 22:08:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 123F01895410
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 21:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419741DC070;
	Fri, 14 Feb 2025 21:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CfkFnYqS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AD517E
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 21:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739567280; cv=none; b=nKEioNm0U3KTysen28c2JJEQF3FUZa3vxZuSgdzpcFBxb3FJNr0FwKDYrTAkNE4j33ewjfgzNOYQNzeDKxjoGUVqisECYq2J/AuI+wPRI06A89FZhD/+Cr4wZjSoyrAEXljCVP/8bfkpucafIDAS3qor6df3Vwcywizid7xJZlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739567280; c=relaxed/simple;
	bh=cTD0YGxM7C/r8VmscZOvQcLrBnZIJ/Bl8PiAHhMhK5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DI46sG/VLaip52S9tWTGAn1+rOxQRSekPPztme1u8CS83zGTJ2D8g/ej0Zw0HubU/BNHIvDQQb4uujJP4JjHf9I5z9gxFkTp7/ldVYVWLk6MvOynVt3Tfrk8x8L9aKY7/SH8Pd4vUL0hLRuJTnUzUdE+dbGCu7dqJtM3Q7tVL7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CfkFnYqS; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220f0382404so23158265ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 13:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739567278; x=1740172078; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fK9Grk2+mxUxJmbNSyLNP4j/EN3bbR5J+pxd4ldMHvY=;
        b=CfkFnYqSuxjoUgaDCgJA2MIXe+8G9DbmV7yG8Jsu4YXkiJVTBCkObzvBjJYf6fRu0o
         9ow4ZgkFRLH8JaGTytYkb9a1Zc52JSB8Zxrs/byGBGO7GJFg4kjcI7QlUoDttbySGUrX
         jvgW98GeozYwa8671Ks1yTb6PGihFZsltsg0lVArp6W+OXDGtLZaBI9YZ3eXfGvlV2ow
         azFsljwdQdJJc2kot0GXCF4jv8fX5A5mACffAZlDtNTs/auVJ3oZnDuPBcDWUzg1+9IP
         LfsEFrHcDx788Tv8gcxkbKePH05kSIVbgcXuC1u/X5mpqsHdmOHBG5rf0PcuLyhM1OsO
         +zAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739567278; x=1740172078;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fK9Grk2+mxUxJmbNSyLNP4j/EN3bbR5J+pxd4ldMHvY=;
        b=dXPTHGXU/IiHC/ufQVTExP9rD3r8Yfi1UuAqMWFwpH5Vtt/x+DXaZIWXupF6/vEkVM
         klAx05QOd7C0LJSnJIGOhqzpJcEyPDTL+jBPOfPrAC7c9fe3vLvDcW0Hb1bU4vGLjeo7
         vMIyum3und9aD4NwIkLgNmHc/HXSv4v5QvPFX2vDsb6THep68+lK4TptLJtQly1wcmiS
         +xm8tnoTB64EZG8+sZkOu001low6O9Qe1q6dkqauFf56xw5x5cDZkHuOx/GpKEMmPBN2
         hLDWUUPaXCuffXofbfh5pfW8fxZ2Ry/zO5evwf1rLGijJUWXWWISZDuELx4Gkkv5ly81
         zK0w==
X-Forwarded-Encrypted: i=1; AJvYcCXP1AWKpYR5YO/8TfsH1UU89fxjTzlVa26WdFdQFnhgt3+FZUaDNVV3zgnUX7hgOLhXaSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ50hJmRnDHz071TKt3A48jljRtWBNcU+1BmOExg4+txiNLKea
	xYmQOqbRybPH8S3O1gz5Fwq3+NTwwykFELe6pNyicuy6m9CSJBVbD9KI66CGQ8uVgy2EJA0+lkU
	giw==
X-Google-Smtp-Source: AGHT+IEB9kfMbLqDRiIWrvbRpSDJvL2ukP7ELBGl34NRPGn22tun5wCq6W7V3vW6ase9xSQ5LQ5KsjA0YD0=
X-Received: from pfbga8.prod.google.com ([2002:a05:6a00:6208:b0:725:e4b6:901f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:394b:b0:1ee:1af5:86a9
 with SMTP id adf61e73a8af0-1ee8cb17bbcmr2046257637.22.1739567278334; Fri, 14
 Feb 2025 13:07:58 -0800 (PST)
Date: Fri, 14 Feb 2025 13:07:57 -0800
In-Reply-To: <20240914101728.33148-9-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240914101728.33148-1-dapeng1.mi@linux.intel.com> <20240914101728.33148-9-dapeng1.mi@linux.intel.com>
Message-ID: <Z6-wrVaVSiI9ZKkD@google.com>
Subject: Re: [kvm-unit-tests patch v6 08/18] x86: pmu: Fix cycles event
 validation failure
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Sat, Sep 14, 2024, Dapeng Mi wrote:
> +static void warm_up(void)
> +{
> +	int i = 8;
> +
> +	/*
> +	 * Since cycles event is always run as the first event, there would be
> +	 * a warm-up state to warm up the cache, it leads to the measured cycles
> +	 * value may exceed the pre-defined cycles upper boundary and cause
> +	 * false positive. To avoid this, introduce an warm-up state before
> +	 * the real verification.
> +	 */
> +	while (i--)
> +		loop();

Use a for-loop.

> +}
> +
>  static void check_counters(void)
>  {
>  	if (is_fep_available())
>  		check_emulated_instr();
>  
> +	warm_up();
>  	check_gp_counters();
>  	check_fixed_counters();
>  	check_rdpmc();
> -- 
> 2.40.1
> 

