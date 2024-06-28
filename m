Return-Path: <kvm+bounces-20699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08A9491C940
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:47:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1A251F23444
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 22:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B6F82480;
	Fri, 28 Jun 2024 22:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qTEtxyk+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C471DA5F
	for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719614821; cv=none; b=GnRdKWEY47PyHD/dwcTzt0d2jwzPtNh4dCSf7qaXpVsLy6/DWWeRnCnuwDbT/Y9uH07WmOklkORtRXcY4z/Y73obx0oP/JNSqfeJOx+rtjSiRuzIUOsn+xPUmZhvRQLE6oxkoEgOV4gVXqYcGfm4byE8KIS7hTqehZMW9ySS2iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719614821; c=relaxed/simple;
	bh=1rm+2QXZvWJIdH1pbYM8kEGJ0tmdpnbCYdV+icbh3Wg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o1J/gxBq/i01TmDo4IQzuLhi43+bqNJ5iPjN2cUJUnqXAsyo1pRTb8N5Fd+4/UTPqVCM0S71scSgI9E+fwOLPw2sQ4staTLCvwwWsjjBm5lkvNhq6KwL81biKyfUGQ3HDmzKO7N0G6+V1UU2mZ9usPpM1k3gtm2WbRuDh/8Fy9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qTEtxyk+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-643acc141cbso12528797b3.1
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2024 15:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719614819; x=1720219619; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c553QvwYlm1gsxBaq0BWcW6YmP4giZ2L7AzyIKkPgyc=;
        b=qTEtxyk+5sBHE9npi1Pt2IdbfQgfmqYxfX01uanbur9x4H2nL5u9EmNs10nw8BLtMy
         Pdnb7d0NhntaM9kM8cMIfIdcSGArsCyb+Mizz/uaBPKewrSjgFIJ2AFaEzQyUrgIiv1y
         uVEr+8bCa0gtVJKKO8kE6gXidhEVIGW3LX1vIw/UT9ck2AyBJ57Odz4vmvEsjM4r6dFt
         H++5x01hDQzsNZye8ibRwk6ck0GfaZ5d2VIfb7w0SJmFCUmgJM+qcDiwGxCvB7FMX0Zm
         l9yU08Es+D8qosmGEJkpg3lIIWa485dRG4/r0su5PXQVNRUAzGULL3i22/pV22CKlUXs
         K1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719614819; x=1720219619;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c553QvwYlm1gsxBaq0BWcW6YmP4giZ2L7AzyIKkPgyc=;
        b=qRcbkH8tmlqB4kPQZo359yOPjOq+B6C2qmMHYdTdSks3l5HKFxwAoN4KaoB+DxmBnU
         baHMhHQ52+jKMfRtuoAqRMZJiTaYZBFavZ1sl7cCp86Jz5mD7Io4m0bi28he6MRqxlY2
         dyoEHay8SXxRabxv23c9N9E16WuBSjOAsrA8AXytVnrwTUde3UxYzTJDyaqTMROoYzIK
         7B92VLkJ6Tf1Ijx6GihDnaQhez5CkFJCj1t53ZHJA5Gxoipr1XYiZZgxfifIRkCHpsi6
         EqdHNJH3j0rBmjnhBnvEPx+hRD5vzvggomhEonQzw86I0POqibkjN/uHQPjF68AjXH9A
         u0PA==
X-Forwarded-Encrypted: i=1; AJvYcCXbMdMOgJ30HmKzi9S4V2hiCAdGsD8UI10gCkbg3SolHAuYGAuMbLQRPflePiASMK4gJpgMhoPy35m7Ipb5SSQHZNTx
X-Gm-Message-State: AOJu0YxbJWdTA742LKL5zTdQH4XKjZQyEI6lqSNbjaUhLign43EKkgRn
	D9lanB2fg4566SLuMdtch3YLqW9kcrMyODwzar1TGO39/FCjoCBZj65PHMjYnj5Q94T0xxgBDpc
	yYA==
X-Google-Smtp-Source: AGHT+IGbOFOcq+TOC4/0immBeMnJQ2HimuXSOoFdC2haiG042WexdfLtZnLaiyDfntCqDBCvZMky5p0H+oM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:8303:0:b0:64b:5675:3ff5 with SMTP id
 00721157ae682-64b56754363mr53627b3.2.1719614819050; Fri, 28 Jun 2024 15:46:59
 -0700 (PDT)
Date: Fri, 28 Jun 2024 15:46:57 -0700
In-Reply-To: <5aa86285d1c1d7fe1960e3fe490f4b22273977e6.1718214999.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1718214999.git.reinette.chatre@intel.com> <5aa86285d1c1d7fe1960e3fe490f4b22273977e6.1718214999.git.reinette.chatre@intel.com>
Message-ID: <Zn89YTYQcEEu9Jrw@google.com>
Subject: Re: [PATCH V9 1/2] KVM: selftests: Add x86_64 guest udelay() utility
From: Sean Christopherson <seanjc@google.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: isaku.yamahata@intel.com, pbonzini@redhat.com, erdemaktas@google.com, 
	vkuznets@redhat.com, vannapurve@google.com, jmattson@google.com, 
	mlevitsk@redhat.com, xiaoyao.li@intel.com, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, yuan.yao@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 12, 2024, Reinette Chatre wrote:
> ---
>  .../selftests/kvm/include/x86_64/processor.h    | 17 +++++++++++++++++
>  .../selftests/kvm/lib/x86_64/processor.c        | 11 +++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index c0c7c1fe93f9..383a0f7fa9ef 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -23,6 +23,7 @@
>  
>  extern bool host_cpu_is_intel;
>  extern bool host_cpu_is_amd;
> +extern uint32_t tsc_khz;

This should be guest_tsc_khz, because it most definitely isn't guaranteed to be
the host TSC frequency.  And because it's global, we should try to avoid variable
shadowing, e.g. tsc_scaling_sync.c also defines tsc_khz.

Which, by the by, probably needs to be addressed, i.e. we should probably add a
helper for setting KVM_SET_TSC_KHZ+guest_tsc_khz.

I think it also makes sense to have this be a 64-bit value, even though KVM
*internally* tracks a 32-bit value.  That way we don't have to worry about
casting to avoid truncation.

>  /* Forced emulation prefix, used to invoke the emulator unconditionally. */
>  #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
> @@ -816,6 +817,22 @@ static inline void cpu_relax(void)
>  	asm volatile("rep; nop" ::: "memory");
>  }
>  
> +static inline void udelay(unsigned long usec)
> +{
> +	uint64_t start, now, cycles;
> +
> +	GUEST_ASSERT(tsc_khz);
> +	cycles = tsc_khz / 1000 * usec;
> +
> +	start = rdtsc();
> +	for (;;) {
> +		now = rdtsc();
> +		if (now - start >= cycles)
> +			break;
> +		cpu_relax();

Given that this is guest code, we should omit the PAUSE so that it doesn't trigger
PLE exits, i.e. to make the delay as accurate as possible.  Then this simply becomes:

	start = rdtsc();
	do {
		now = rdtsc();
	} while (now - start < cycles);

