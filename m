Return-Path: <kvm+bounces-46268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C6CAB46A0
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 23:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5DBF19E39B5
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 21:47:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2037299A81;
	Mon, 12 May 2025 21:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oAwcybVB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763BD22338
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 21:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747086414; cv=none; b=CQZSrT5aSo7r783JjzS7GYg5N9UlUgCaCND1a5TihJfNjTWXk1d2wyrwjljCXY+qqdo8Crysge/ij5h0jjUGNMccm2tIg/WwhWZo13Ypt+IWazTRFPA5dC93gOlS8lojTQqdNrS2sIh7pKeqrbM0NA6PrXcujtPofXPYG9Qr+a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747086414; c=relaxed/simple;
	bh=eHjBlSf0Yo67RxAYR+5ZeL9Px5CimRi4shTlnQY8VI8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qdpi891ZBEeUVyaFPQC8wvLImmTwTT7F/76yG0TpzFafbP8HC0kzmR10ZxSakGm/J0VmFdYJ5OMCGbkuN7CO5aJm/NGDZFCnThtWiP6bIKrufguiclv05djEMySeYmQ0DLLfDpSXlOWA+AvNJc+19XgYMkeRbkUj217rjTF9wvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oAwcybVB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a39fa0765so7953487a91.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 14:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747086411; x=1747691211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZyjmXW5jKvAlN/pWhonx8KRiAcF2mwvw/0SN0Q5lTE=;
        b=oAwcybVBkPAwSvSz1YIWMg/6rSlkxWQxyga61AQwFt/HbVogIkctW7HVFY8nGpa0ZD
         OhR+Vbf1LqmoI61Ak5guhikOuw4OtonesWqTGnuq3zmhY9LG752nIczH9TjXBLhmoT1a
         xWUMwofc+sElP5rjMUyE3d3hKFFHndVOfGG5s1bTRcKHIqNb4VCWkYUHEeoaotk3uurV
         Iz386SSUZxhmfbhjjfAM436uX0uOO17yWaH4rTl+//1iUdTpYwBt0M7UJq0AyOvYzIb/
         OZVjyoMwRTaX1GgANKMqZkuLGM7dwR1nV3TDpsOhv6frQdSPNSz2rw/b/JnrUZpaMWgG
         hYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747086411; x=1747691211;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ZyjmXW5jKvAlN/pWhonx8KRiAcF2mwvw/0SN0Q5lTE=;
        b=Pw6e/jS462Zbb1WYIG5Oj7cncrrUA67WZimKewg/Aq8L+GhGKtaAkOmW0kx/wFir4I
         TtixvOe4eKS7pPHKFl1++GzVPdJOaDsnfDQUt2E89GIW6qHemHw3+wg4ndyTaS9kDhZK
         wrdTlLVhS7odIl9lJuvuW0mKuRgTzF5bZWNXxUzauPrgwBpeFaj9nqioD1EdvtBPKVgH
         7E2FaCK6toTcFwzhIeoonv9pLeo83jR0Rz6nu1uaTHPVP4E9J0CthkGb3ZhRUjBEu7b2
         TnEe7Mjmus5zYZK1HnEeOW2x2uctK2z7xptcYxCnCRKmqcILnBq07e27dRa5JYCDXdCy
         GSsg==
X-Forwarded-Encrypted: i=1; AJvYcCX8rY3ClqgI4HciRSAF7s1ZK2IhWpja1KixmyfdhKdMxz85oc8K+UpGGumN43Posfxf9kk=@vger.kernel.org
X-Gm-Message-State: AOJu0YypO/xDb/D1FGyrf/ztctKILXpBdWSP3cHmjUapn2QyrIProkWk
	tBi8sGoNyMVMq1+nsF7uyyS7YmC7PrOvvLOueO5luP/6FnhxDuo5oZHi4LaQiJzP4J1QE2DPNvX
	87Q==
X-Google-Smtp-Source: AGHT+IFQhYV59Z1j+BjuZQ420OFrQUmxJS4zl0EI8unm/GdkiYFWDALZeHSngOByGJrTSeAaw8MU9XM38Gw=
X-Received: from pjbta13.prod.google.com ([2002:a17:90b:4ecd:b0:2fa:15aa:4d1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d85:b0:306:b65e:13a8
 with SMTP id 98e67ed59e1d1-30c3ce03418mr22071502a91.8.1747086411652; Mon, 12
 May 2025 14:46:51 -0700 (PDT)
Date: Mon, 12 May 2025 14:46:50 -0700
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250313203702.575156-1-jon@nutanix.com>
Message-ID: <aCJsSvc4_azZNrKI@google.com>
Subject: Re: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
From: Sean Christopherson <seanjc@google.com>
To: Jon Kohler <jon@nutanix.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Grest <Alexander.Grest@microsoft.com>, Nicolas Saenz Julienne <nsaenz@amazon.es>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, 
	"=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>, Tao Su <tao1.su@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 13, 2025, Jon Kohler wrote:
> ## Summary
> This series introduces support for Intel Mode-Based Execute Control
> (MBEC) to KVM and nested VMX virtualization, aiming to significantly
> reduce VMexits and improve performance for Windows guests running with
> Hypervisor-Protected Code Integrity (HVCI).

...

> ## Testing
> Initial testing has been on done on 6.12-based code with:
>   Guests
>     - Windows 11 24H2 26100.2894
>     - Windows Server 2025 24H2 26100.2894
>     - Windows Server 2022 W1H2 20348.825
>   Processors:
>     - Intel Skylake 6154
>     - Intel Sapphire Rapids 6444Y

This series needs testcases, and lots of 'em.  A short list off the top of my head:

 - New KVM-Unit-Test (KUT) ept_access_xxx testcases to verify KVM does the right
   thing with respect to user and supervisor code fetches when MBEC is:

     1. Supported and Enabled
     2. Supported but Disabled
     3. Unsupported

 - KUT testcases to verify VMLAUNCH/VMRESUME consistency checks.

 - KUT testcases to verify KVM treats WRITABLE+USER_EXEC as an illegal combination,
   i.e. that MBEC doesn't affect the W=1,R=0 behavior.

The access tests in particular absolutely need to be provided along with the next
version.  Unless I'm missing something, this RFC implementation is buggy throughout
due to tracking MBEC on a per-vCPU basis, and all of those bugs should be exposed
by even relative basic testcases.

