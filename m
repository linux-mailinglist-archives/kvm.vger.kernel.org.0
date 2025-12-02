Return-Path: <kvm+bounces-65093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E3AC9AD17
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 10:17:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0A461346ED7
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 09:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1731530C344;
	Tue,  2 Dec 2025 09:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WqiE+zR0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D87E30BB86
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 09:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764667011; cv=none; b=SEPgsWqLinmThljkwY4bs3jXC+eGEtwVFNbV6y68L+zDe0zNX1+IL4KWiIqWivhaN5eeMbphP5iNftPSx8nDH4C+rdEwuqmN+/q3BL42XhKmf0bTKFER7vfe6I7uM6ek+Z4GISdNuY2j4fqWLn08CS8CA/oUcTMVJAI9sAAeKuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764667011; c=relaxed/simple;
	bh=mzqNBOpcLYerEcH5Q2GlKCwR0gaYp1181Z84TNL0evM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L2Zs6KzA2h9ZV8Bw/lWuoh4hlqtjwNX0U6CvbG7gbTJkaeJTgBG0Li4lnpjwRx6NoaEFbxZ/J2ObMTsp7us2DpqkeeSKQPeu5xVgO/s/a2kOkYKc2Rge25655co1UW1FxZy9twnI3eXgZkxtkRYTZ8o4OgeklDIqwAsBfZ/ZHfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WqiE+zR0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764667008;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nO1OzCggv5Us6LpGbd3LZnEAwWb1hr2QplQRbye96P4=;
	b=WqiE+zR04wYotabOab4T+jthfwMVbthqhoEgbSokgP7sttaPIxlQOeZwxkhE39SDA92g/7
	HJvKH7VGUcws/3MftkgikdnIvrAh4D8mn3f2RvCcr31opotC/dl8fnghhQ55jfE+QUIMai
	O8FSkYjimbxD8vDlHE3VlgSsrQvudoY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-4kSRP50hOC2ZQAaNfu2qrQ-1; Tue, 02 Dec 2025 04:16:45 -0500
X-MC-Unique: 4kSRP50hOC2ZQAaNfu2qrQ-1
X-Mimecast-MFC-AGG-ID: 4kSRP50hOC2ZQAaNfu2qrQ_1764667005
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-880441e0f93so121763096d6.1
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 01:16:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764667005; x=1765271805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nO1OzCggv5Us6LpGbd3LZnEAwWb1hr2QplQRbye96P4=;
        b=NmC7GbUOKWT4hbYx/dl+LAxWrgxESPEUtFxuZs1P0qt0zDrPwxwk3fN7uiauE4FxRj
         vbTyCCF0XOEdN9zLnTFH7TmKu8HQPJ9fSqNXLZVpOU6Z7mqlB5qAtOBPpZ3Jvu+5eU4d
         YRLBjEOtNbHe9q47p0HESKPr4J/DtdcZZsUPwsGi6A+TU7GRF1hWMISMumkGnRU6vKxn
         hZW0KEsLcObK5tFiu+ok2awgkC81cym8Y2/NZUmYDHIUx8bhd6QXsuK8t6oLIeAmXBfv
         EgdXIksp+CeldB/XedU8ZK6mepJuNLhLNPmpTp/bGlCYBQAaCx2fm84qDmkPtPIBtLqC
         bvFw==
X-Forwarded-Encrypted: i=1; AJvYcCVi0TgaQOtVJY0WAQRkOkIsm1zkeHAGHfabvY2kQpmUN4PeTdnhGqNai2UAvDGa07YQwls=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ3u9hrg3sKgBfS1Lr8dYxYIAv5Lyq21ktMiRK+Y97LAyRUYvY
	3+AWl5+tHVv1qYlRmk/O6C4wb569K1r8sDrGpvXUcephNAUyW9jL1umA4nASCQqF7BjjD0ohetJ
	ATBOuhmUMkfWOYnKI0NlMp2fZZzC/9NHVAUPQXeCo19ONXi/bbJFnXLScZJBTgQ==
X-Gm-Gg: ASbGncuNBB+NY6u/+Rns0cdCntN6sMCmWR52ED0sixcmncAvgv3wqgMHXlDcMx/yaju
	/GmyH6SMhAYjdqNqvB16WWoa6DpvH8htXzkSjsg0h+c6tZ7UNg1DYbLhVi0QN3xRF5N6vgaudj9
	rYqi8JTpqoFLYZAKzp8pTLX0Sj8zjumNzqjvQgSAa3lwV0vJ5gF/fhrsc1oCGUpWafjifP6o2kT
	tdA0ziMSonyqZT6fDmAzN2V5vxPPcB6hPso8zuIuHXf6e4Z4XLwJ4Gp5ltPLqpmbaDtVe0eHtnQ
	kUC9yv9RttRPjzKHJgNLvSK6hgxV19U/AK8w4buzCZgUeJRZ03weheA47Y7mrWnYSxy/KnyJugi
	JL6nowvYJc2e8CFwfLOvTyAvGJpk1jhSVkRzPAIYYZvud4t0WGp2kJmkIgg==
X-Received: by 2002:a05:6214:1248:b0:882:4580:a86f with SMTP id 6a1803df08f44-8880db021c1mr29191606d6.6.1764667005015;
        Tue, 02 Dec 2025 01:16:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGP9KNEjOZYxyZznBw4V2byRMo0JTnBVwuhJhps/sxAJFUEHYQNXcEnamOc4VWRu0BX+pj4Eg==
X-Received: by 2002:a05:6214:1248:b0:882:4580:a86f with SMTP id 6a1803df08f44-8880db021c1mr29191386d6.6.1764667004575;
        Tue, 02 Dec 2025 01:16:44 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b494d5sm99219806d6.27.2025.12.02.01.16.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 01:16:44 -0800 (PST)
Message-ID: <5160dadb-1ff3-487e-bd0b-9f643c3d9ec3@redhat.com>
Date: Tue, 2 Dec 2025 10:16:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 07/10] arm64: selftest: update test for
 running at EL2
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-8-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-8-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
>
> Remove some hard-coded assumptions that this test is running at EL1.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  arm/selftest.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/arm/selftest.c b/arm/selftest.c
> index 1553ed8e..01691389 100644
> --- a/arm/selftest.c
> +++ b/arm/selftest.c
> @@ -232,6 +232,7 @@ static void user_psci_system_off(struct pt_regs *regs)
>  	__user_psci_system_off();
>  }
>  #elif defined(__aarch64__)
> +static unsigned long expected_level;
>  
>  /*
>   * Capture the current register state and execute an instruction
> @@ -276,8 +277,7 @@ static bool check_regs(struct pt_regs *regs)
>  {
>  	unsigned i;
>  
> -	/* exception handlers should always run in EL1 */
> -	if (current_level() != CurrentEL_EL1)
> +	if (current_level() != expected_level)
>  		return false;
>  
>  	for (i = 0; i < ARRAY_SIZE(regs->regs); ++i) {
> @@ -301,7 +301,11 @@ static enum vector check_vector_prep(void)
>  		return EL0_SYNC_64;
>  
>  	asm volatile("mrs %0, daif" : "=r" (daif) ::);
> -	expected_regs.pstate = daif | PSR_MODE_EL1h;
> +	expected_regs.pstate = daif;
> +	if (current_level() == CurrentEL_EL1)
> +		expected_regs.pstate |= PSR_MODE_EL1h;
> +	else
> +		expected_regs.pstate |= PSR_MODE_EL2h;
>  	return EL1H_SYNC;
>  }
>  
> @@ -317,8 +321,8 @@ static bool check_und(void)
>  
>  	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, unknown_handler);
>  
> -	/* try to read an el2 sysreg from el0/1 */
> -	test_exception("", "mrs x0, sctlr_el2", "", "x0");
> +	/* try to read an el3 sysreg from el0/1/2 */
> +	test_exception("", "mrs x0, sctlr_el3", "", "x0");
>  
>  	install_exception_handler(v, ESR_EL1_EC_UNKNOWN, NULL);
>  
> @@ -429,6 +433,10 @@ int main(int argc, char **argv)
>  	if (argc < 2)
>  		report_abort("no test specified");
>  
> +#if defined(__aarch64__)
> +	expected_level = current_level();
nit I would directly use current_level() in the calling function,
check_regs() to avoid that #ifdef

Eric
> +#endif
> +
>  	report_prefix_push(argv[1]);
>  
>  	if (strcmp(argv[1], "setup") == 0) {


