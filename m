Return-Path: <kvm+bounces-65101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CBCCC9B299
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 11:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5C75B4E3C9C
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 10:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F3D28C009;
	Tue,  2 Dec 2025 10:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d86P3cTp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5A521FF3F
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 10:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764671504; cv=none; b=vA87jx/lRUkmdt6e+KPDinWZ03S9KZhhKqIwj8c1GzIbja6C82+yKsXQEt2U1mflJKY1LP0qIF4dYHDvcrTOXjnhUDoTkq2yqy7pS2pOoaIOT4WkktkKzNFxtYuZdOTYvrHoUUtM7Yz6r9efVJrySceoN2smlIw2RTTgCnG5nf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764671504; c=relaxed/simple;
	bh=fgMjYj4bIL6AZNPeX1R5CQmvPztTnQWt1WpxvYC3K1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eILI7xF1ZYiNRe060ms/KuRYqNwW5aV+2qYI7NzI1zHrY1+EUVrvNvSd9Zc1ZSnXTtr1W6S6EiJiXJ7ZI2L5blXkb8nrPOTmqDNVDxGKjojxMwc+8F0lDPzYhY8E814QPHO83kyX/krIo39+ZqPBA17QWjwaNoxlTyzKFfOd6Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d86P3cTp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764671501;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vQZ1yQVfkBFCjcNblwsqZZNx6M3xDYjpded8RdSmjTQ=;
	b=d86P3cTpec6W43JAPcnMBhltuCbW+utw4OABzMAUri/J3/Oc/GZTNLi+yhsV+E12wxppc4
	quUMniyBaZ3eSgiTW2imVLR6VsuE+hV1xrK+zRfq531GHC4ALQIaa/AQUgv20lUvdEIsx3
	FWWGjII9BYtf0DsiQnXFnvHH6c8pimw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-vR9vv__dOyaVB241QOyKfA-1; Tue, 02 Dec 2025 05:31:40 -0500
X-MC-Unique: vR9vv__dOyaVB241QOyKfA-1
X-Mimecast-MFC-AGG-ID: vR9vv__dOyaVB241QOyKfA_1764671500
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b2f0be2cf0so1545854185a.0
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 02:31:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764671500; x=1765276300;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQZ1yQVfkBFCjcNblwsqZZNx6M3xDYjpded8RdSmjTQ=;
        b=JB1ia2D6fbKsQBMHUswVCsc9u1dGDdUStfYQAxxQZN2DNZGkvbZhnRkMDXR9nE+NZx
         HtYshI6rokehVFcq5on9NlCZ7tYfPHqs8GYJxCejmwUHYRgc4+PfT6ZxwHFoyQKtc6J7
         SzLRdOCTuDCDI3D6SnmIOK2j5lHYFF6Jx5a55rT2N3uuWiz1RPU8EGPyQOO0SX4i1XSI
         ThBm7Tj4x76ZczhCOAQJHgT98Y3ZbOiJHTKDNRyhNVgjGWFBxI4q0KeRgYAUBg3n5BoV
         q+lwaHh59ONvfIrKJLGTrxqOS4KWfHmF9E6W9Ts1cuEA7Q5CtvyjtIYApv91pwHHlRFg
         ruLg==
X-Forwarded-Encrypted: i=1; AJvYcCXMm/aSUU2kGnYQsgli4u9YiL2QTJ4nBvLdcxh9TLKsxkkbubRUgh6OLEB9eFl4WEBqAKw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtazQmLe+Ws5GVhvAzqd0hXuEosH2sRRcJiUnL0KwcjJQlU/AH
	WV8u1a4v8ZH7i4tB4Od9WtkhJXpiUv2crOylCnvLPg56aUhko11vnZ1giu4FeVOi/hNdwsCd+QY
	Zsm9hceUPeMzujMedlBWdQW+nXy7WSNQkIJAQTMtahYqjjS5uNGHqPK+0yYN3Eg==
X-Gm-Gg: ASbGnctS3R+NYC6FJZyrkTCrCM1wsMmqL7DK3F38hV7W8HIgl5b+rC5eqhgMHnKWBMg
	8bZ4j+KwBJDySs39uoETWzHq307CaVZ1NhYkiYiNpz68U7pYw3CjMQkhSKwu4DXGjyIhxQSBYHp
	ax67k5Y62lKXzzCgpFHeAN0cFNzY84Rk3VnpGaAwIG502X2geEs9YLlqkpWS1rBrqaNV+kwhoad
	8BeI3uh5stdd8qAUsgMU/thxuh5g7NszCy5imVC7A/N5RV+smNtqQUzp6hF+Ja4qQ16VSiZH9AV
	jPsuEBMx+ia87klFHLKQ82wUpvHD4kyYhpCpnH/TSb7X4f9ABKQxANe3pXbHulJdzbdWtkhiU4H
	DFkfiJYlwdQRDxLlMHW580n9O4/lNGbCLKsdlkV5sodDdLcdVYQyvgZEPbw==
X-Received: by 2002:a05:620a:4687:b0:8a3:87ef:9245 with SMTP id af79cd13be357-8b33d4c71damr5820819985a.85.1764671499935;
        Tue, 02 Dec 2025 02:31:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEkFzxmwelK7JWWOAoPq9zHQWlUTkFdQtGpxT5OnaUqoncZnDcZ0jY3Vwv2Xy+uzCGGTRumEg==
X-Received: by 2002:a05:620a:4687:b0:8a3:87ef:9245 with SMTP id af79cd13be357-8b33d4c71damr5820816985a.85.1764671499514;
        Tue, 02 Dec 2025 02:31:39 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1c909asm1040500585a.40.2025.12.02.02.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 02:31:39 -0800 (PST)
Message-ID: <a8951572-2d70-413e-90c7-9eb45a5d18a2@redhat.com>
Date: Tue, 2 Dec 2025 11:31:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 08/10] arm64: pmu: count EL2 cycles
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-9-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-9-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> Count EL2 cycles if that's the EL kvm-unit-tests is running at!
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/pmu.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/arm/pmu.c b/arm/pmu.c
> index 2dc0822b..e6c0f05b 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -121,6 +121,8 @@ static struct pmu pmu;
>  #define PMINTENCLR   __ACCESS_CP15(c9, 0, c14, 2)
>  #define PMCCNTR64    __ACCESS_CP15_64(0, c9)
>  
> +#define PMCCFILTR_EL0_DEFAULT	0
> +
>  static inline uint32_t get_id_dfr0(void) { return read_sysreg(ID_DFR0); }
>  static inline uint32_t get_pmcr(void) { return read_sysreg(PMCR); }
>  static inline void set_pmcr(uint32_t v) { write_sysreg(v, PMCR); }
> @@ -206,6 +208,9 @@ static void test_overflow_interrupt(bool overflow_at_64bits) {}
>  #define ID_DFR0_PMU_V3_8_5	0b0110
>  #define ID_DFR0_PMU_IMPDEF	0b1111
>  
> +#define PMCCFILTR_EL0_NSH	BIT(27)
> +#define PMCCFILTR_EL0_DEFAULT	(current_level() == CurrentEL_EL2 ? PMCCFILTR_EL0_NSH : 0)
> +
>  static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa64dfr0_el1); }
>  static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
>  static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
> @@ -246,8 +251,7 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>  #define PMCNTENSET_EL0 sys_reg(3, 3, 9, 12, 1)
>  #define PMCNTENCLR_EL0 sys_reg(3, 3, 9, 12, 2)
>  
> -#define PMEVTYPER_EXCLUDE_EL1 BIT(31)
> -#define PMEVTYPER_EXCLUDE_EL0 BIT(30)
> +#define PMEVTYPER_EXCLUDE_EL0 BIT(30) | (current_level() == CurrentEL_EL2 ? BIT(27) : 0)
>  
>  static bool is_event_supported(uint32_t n, bool warn)
>  {
> @@ -1063,7 +1067,8 @@ static bool check_cycles_increase(void)
>  	/* init before event access, this test only cares about cycle count */
>  	pmu_reset();
>  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> -	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> +
> +	set_pmccfiltr(PMCCFILTR_EL0_DEFAULT);
>  
>  	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
>  	isb();
> @@ -1118,7 +1123,7 @@ static bool check_cpi(int cpi)
>  	/* init before event access, this test only cares about cycle count */
>  	pmu_reset();
>  	set_pmcntenset(1 << PMU_CYCLE_IDX);
> -	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
> +	set_pmccfiltr(PMCCFILTR_EL0_DEFAULT);
>  
>  	if (cpi > 0)
>  		printf("Checking for CPI=%d.\n", cpi);


