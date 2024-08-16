Return-Path: <kvm+bounces-24436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20E6D955189
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 21:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFEAFB22223
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 19:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50FF1C4600;
	Fri, 16 Aug 2024 19:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QBlkA24g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87AD1C232C
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 19:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723837076; cv=none; b=pXrqKQJ3nXkHZ+nmjY80gCrSv3bnHCzLv58p4uAPlIixgLsmI52uX6smqvv1DghGQnu/i+0cGgn3Wh9nDeSXAjKVTkZ7H15qoUDcNFbZUdPVz6L9K9vZt5vzWFSk/ZavElJIIIpHkqjpLyMrFcN1NRq7fs1zfRZNsrlYuOJalHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723837076; c=relaxed/simple;
	bh=Of5HpGVVuTUuNfj4AJMT8Y+0YqFufRVSujNfXIl5CBA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ItvNweJGNaGx4ZVRfeR2/YR2ws3RCq+hP+7rT2Y9raST7SMBeLslE2A1nXL2mFIWwjEL8a3jykxql4HODp0WNhscXM/J2T0pq/jUkfL0AKvI6R52eJENJVsHoGO8gHp4umK5FmTwQkFshTIOjaaRowbMa37/B9r8NVI1bmQ+WGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QBlkA24g; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e0bbd1ca079so4061857276.2
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 12:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723837073; x=1724441873; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kMKtRBmBdUEbdDNzAx0RjmHjXksW76vMe5L0MyK/hs0=;
        b=QBlkA24gINfNFXJw+6Bs5mI4n0PBkUwKH8nZraJpv0RA3zDyn8/k27/zF4Mb3C23z0
         zfLQxlWbtFPhu9lz+RjrWLMT3uC98tdth95ECReDaoR9W5RVBXCQuo0dPWfn/4L/2cay
         sGnKi3K2DiIk8JoXFpalemwoHSArnUEuwvvZTcFm0vMGDYXe3ww8heyDNMZKik4RNvRU
         l2LIiZZ3b9C6HW+FQ/dOCku1WbazHnc/y0lHl9Q4p8emnzhDxAKuKLqbmHWLIiHOJUUF
         dHDew7EGLqziwmvBaVxZJ+AXHtSO2wVpVM05AeVB7SxI+UttEmhCN1mlcJiS8ieGYcQ6
         pHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723837073; x=1724441873;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kMKtRBmBdUEbdDNzAx0RjmHjXksW76vMe5L0MyK/hs0=;
        b=YkebjvwcksIOzjjyNDyj5eyIIMASt0jmlihLKKiKntHPX7C/xB7SoblPbHQM8oDF6h
         0j3P7a2IIwb48eEi+552VIKjyUvaYi8y+nvOpX4dkqr8fUmB1jIxzeRPeGbXWurRpvp6
         PT9yBEOXnlk0MSEgok3GLsU3DL3Hs6L3uX5bPXTtDa+iHyiqOZ3RU1TYK6QZEmV1fWEX
         QRH+utqzM0MnZp0JEylgtQz0mrDRjMogRvSxH8PPSgRp6XIJp6H3YzEa7ElABLd6rV5t
         4vled3VlVLQLN0dl6xzH6LbiauOT8R8kaomlPlKWXOf9JAOU/GUo0gZPcYJ8uJISYrlU
         8h4g==
X-Gm-Message-State: AOJu0YxKxOCcfbUsiTN7o/6WEq5KPGqgLWRO5Rn3Cnnn0My6I6RHTjN+
	zHEMe6mstd0LPD6AOXnGDtIm/DykqsItyKa3luVxxB6oVnBuIljCZGXlGz40zDa8EtVpIlJISYA
	Z5Q==
X-Google-Smtp-Source: AGHT+IHXOFjx/mXErXlc00eHtSMRGExz9VV8bSAL/E4iMQhlh4xkfi3KGMIeTACfrjhamsRqjvx47hyJres=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6854:0:b0:e11:5f9f:f069 with SMTP id
 3f1490d57ef6-e1180f677bamr32754276.8.1723837073570; Fri, 16 Aug 2024 12:37:53
 -0700 (PDT)
Date: Fri, 16 Aug 2024 12:37:52 -0700
In-Reply-To: <20240709175145.9986-2-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240709175145.9986-1-manali.shukla@amd.com> <20240709175145.9986-2-manali.shukla@amd.com>
Message-ID: <Zr-qkJirOC_GM9o6@google.com>
Subject: Re: [RFC PATCH v1 1/4] x86/cpufeatures: Add CPUID feature bit for the
 Bus Lock Threshold
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, bp@alien8.de, babu.moger@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 09, 2024, Manali Shukla wrote:
> Malicious guests can cause bus locks to degrade the performance of

I would say "misbehaving", I bet the overwhelming majority of bus locks in practice
are due to legacy/crusty software, not malicious software.

> a system. Non-WB(write-back) and misaligned locked
> RMW(read-modify-write) instructions are referred to as "bus locks" and
> require system wide synchronization among all processors to guarantee
> atomicity.  The bus locks may incur significant performance penalties
> for all processors in the system.
> 
> The Bus Lock Threshold feature proves beneficial for hypervisors
> seeking to restrict guests' ability to initiate numerous bus locks,
> thereby preventing system slowdowns that affect all tenants.

None of this actually says what the feature does.

> Presence of the Bus Lock threshold feature is indicated via CPUID
> function 0x8000000A_EDX[29]
> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 3c7434329661..10f397873790 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -381,6 +381,7 @@
>  #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* Virtual SPEC_CTRL */
>  #define X86_FEATURE_VNMI		(15*32+25) /* Virtual NMI */
>  #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* "" SVME addr check */
> +#define X86_FEATURE_BUS_LOCK_THRESHOLD	(15*32+29) /* "" Bus lock threshold */

I would strongly prefer to enumerate this in /proc/cpuinfo, having to manually
query CPUID to see if a CPU supports a feature I want to test is beyond annoying.

>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
>  #define X86_FEATURE_AVX512VBMI		(16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/
> 
> base-commit: 704ec48fc2fbd4e41ec982662ad5bf1eee33eeb2
> -- 
> 2.34.1
> 

