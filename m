Return-Path: <kvm+bounces-36479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CEBAA1B5D4
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:26:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91971162A01
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 12:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC9921B1AC;
	Fri, 24 Jan 2025 12:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FKA5BfYo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBFA219A8D
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 12:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737721554; cv=none; b=rvplOh2F/wEz3YipHQLqqtzd5a2Rp8bf/w5qD6xvfK3snzOHK3IQNj+giCk+MxvrcXIhWBHKd9FcrgQAMf/Kb8+WmwueOSulPlFGcjEIpLW+5WG4dsllNZcCWsovuHcDwc6HtAwo/wp91VoD/tFGmdG5GeQmpn9IMKQciUZYS4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737721554; c=relaxed/simple;
	bh=e/UIWGNlrSkh0tQjrgtAF9wXOvtMx88B4b0MguP0bsk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQcDQuEBx1coIi9nMqHmH14PRK0jIC80ig6RVu/L+56xp3ULSwIiUkpJXWy3E+cV9vv/xvwaKzpYAlp4k4cQLt/9+v7/n3cj1V4/YyW+41t1LuZ8nDoa6owOMqWKstKYOEJ1CjoPSi9Yli2bQeAirWSBVXcYC0UlUEyM2/oq5d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FKA5BfYo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737721551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vnxustz4Ozr1581LgCiIqLuONz0VD0Xhn2cHUTkQB6k=;
	b=FKA5BfYoieS2sMN4n1xMeISXNQNC123hzqSquM14YLhgZz4pqGjeFZWU6e1IXo+5HI90nJ
	UF+2DoxJeMUseFxjUPW8BQ+6e2p7tk2lEH+ss0xU7yYr7JPrCBhTcKtUwUxtIDso9hSQ6E
	ESLJZzG0FGoJJRwvro4PacZ8mgyLmio=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-Eh7GofVxPjeNLCRQWqAuew-1; Fri, 24 Jan 2025 07:25:50 -0500
X-MC-Unique: Eh7GofVxPjeNLCRQWqAuew-1
X-Mimecast-MFC-AGG-ID: Eh7GofVxPjeNLCRQWqAuew
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385e2579507so923823f8f.1
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 04:25:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737721549; x=1738326349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vnxustz4Ozr1581LgCiIqLuONz0VD0Xhn2cHUTkQB6k=;
        b=Rh26xAnbBLQQ7jCdZ2xsqg3kz6ErB2hCvUyGQhESBXFLrcGbEQccbKDnmNWF7JQ3n9
         4oQg8frMjnNVNS73FRElomLlNW+y1+sOi+Bcc/R1ks3SMSGuYZpVQdCfCzp7HOpCytyX
         5n1OlfeW1noTYkNMhCGk2ez+zzi0S98mdS8NMtDA88FRrZRwpQ2RIVlSNlSsZGF9cCky
         xFXhmqSw9s/9lEmAKsgLnPS4TA+8ueEBlt8PC2g1ibrVl1/xYThotCOp5nlyDLzZenU8
         7ebtP2KeJohasbLEiKg2pi5xsqTnvQDjzmRcKwnvC8gxFo36IFxIS61qt4Y2hQe5nDZb
         tD6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWBdpr2yJF33t69jJsbL3HQ/UEuz1kKfTT8tZAWHXnEVc8p6XBw6O11KHR1frNHpxrUdc4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa4grNsdagAHCyMK24J/vOdxjNli0PaoNPHHDQvGmCRrjL2mjS
	bzfH7xfR6/6Rx+7gQdZwmKs23UVfVwFcnYiV9Qw25SgOcohluOpDz9vQ3GLfKxM48/GT4yyxHBs
	JCguvTjJivR5v+hONLjAeEo1Q0/RQieepQYxJrVktfPwA/waSHA==
X-Gm-Gg: ASbGncvtALu2MceBdC8UgmDAKp8R9/Dy7saHKLexR+IE2u3Uj6Pl1S6Crl8iXqkEuYH
	/iyqL9MSIlACRDyRjaSdeOQ8D7HADTVL2q4qbN2QsIgvG+ur4/eVWKa1ImdT7ndd2VhvkPOYeFZ
	DzyKgIqnC5Psau2ztYIPEKmcImFGAY8djuPZ5jeY/u28ysFw1ugvv6ffBMsLIPjuanz01CD88pp
	hjmp+JruUdje4ofBrM40FEAS2zxu5mLKgYvFVqW0rXzU2QoCvVvl8nzkRGwuhzURhG8yYXrKq4F
	vu75OzZW2eIbGi7sDBxewYD6pJdI5n2kb2ZFJ13k/g==
X-Received: by 2002:a5d:59a8:0:b0:385:fa26:f0d8 with SMTP id ffacd0b85a97d-38bf5655a0amr26933466f8f.8.1737721548968;
        Fri, 24 Jan 2025 04:25:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEleHjBU1+JpAle5FPfNcGEhVnYCT++PmivrmNNIqSuFMQtW8TMMrtNdpuy5xp0Gzpzpftjpg==
X-Received: by 2002:a5d:59a8:0:b0:385:fa26:f0d8 with SMTP id ffacd0b85a97d-38bf5655a0amr26933442f8f.8.1737721548584;
        Fri, 24 Jan 2025 04:25:48 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bb0d4sm2603769f8f.69.2025.01.24.04.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 04:25:47 -0800 (PST)
Date: Fri, 24 Jan 2025 13:25:46 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org, Ani Sinha
 <anisinha@redhat.com>, Dongjiu Geng <gengdongjiu1@gmail.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] acpi/ghes: Cleanup the code which gets ghes ged
 state
Message-ID: <20250124132546.4ff1d643@imammedo.users.ipa.redhat.com>
In-Reply-To: <200501cb372d5121c44128a79b8775e529dc46e6.1737560101.git.mchehab+huawei@kernel.org>
References: <cover.1737560101.git.mchehab+huawei@kernel.org>
	<200501cb372d5121c44128a79b8775e529dc46e6.1737560101.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 22 Jan 2025 16:46:24 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Move the check logic into a common function and simplify the
> code which checks if GHES is enabled and was properly setup.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  hw/acpi/ghes-stub.c    |  4 ++--
>  hw/acpi/ghes.c         | 33 +++++++++++----------------------
>  include/hw/acpi/ghes.h |  9 +++++----
>  target/arm/kvm.c       |  2 +-
>  4 files changed, 19 insertions(+), 29 deletions(-)
> 
> diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
> index 7cec1812dad9..fbabf955155a 100644
> --- a/hw/acpi/ghes-stub.c
> +++ b/hw/acpi/ghes-stub.c
> @@ -16,7 +16,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
>      return -1;
>  }
>  
> -bool acpi_ghes_present(void)
> +AcpiGhesState *acpi_ghes_get_state(void)
>  {
> -    return false;
> +    return NULL;
>  }
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index 961fc38ea8f5..5d29db3918dd 100644
> --- a/hw/acpi/ghes.c
> +++ b/hw/acpi/ghes.c
> @@ -420,10 +420,6 @@ static void get_hw_error_offsets(uint64_t ghes_addr,
>                                   uint64_t *cper_addr,
>                                   uint64_t *read_ack_register_addr)
>  {
> -    if (!ghes_addr) {
> -        return;
> -    }
> -
>      /*
>       * non-HEST version supports only one source, so no need to change
>       * the start offset based on the source ID. Also, we can't validate
> @@ -451,10 +447,6 @@ static void get_ghes_source_offsets(uint16_t source_id, uint64_t hest_addr,
>      uint64_t err_source_struct, error_block_addr;
>      uint32_t num_sources, i;
>  
> -    if (!hest_addr) {
> -        return;
> -    }
> -
>      cpu_physical_memory_read(hest_addr, &num_sources, sizeof(num_sources));
>      num_sources = le32_to_cpu(num_sources);
>  
> @@ -513,7 +505,6 @@ void ghes_record_cper_errors(const void *cper, size_t len,
>                               uint16_t source_id, Error **errp)
>  {
>      uint64_t cper_addr = 0, read_ack_register_addr = 0, read_ack_register;
> -    AcpiGedState *acpi_ged_state;
>      AcpiGhesState *ags;
>  
>      if (len > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
> @@ -521,13 +512,10 @@ void ghes_record_cper_errors(const void *cper, size_t len,
>          return;
>      }
>  
> -    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> -                                                       NULL));
> -    if (!acpi_ged_state) {
> -        error_setg(errp, "Can't find ACPI_GED object");
> +    ags = acpi_ghes_get_state();

1)

> +    if (!ags) {
>          return;
>      }
> -    ags = &acpi_ged_state->ghes_state;
>  
>      if (!ags->hest_lookup) {
>          get_hw_error_offsets(le64_to_cpu(ags->hw_error_le),
> @@ -537,11 +525,6 @@ void ghes_record_cper_errors(const void *cper, size_t len,
>                                  &cper_addr, &read_ack_register_addr, errp);
>      }
>  
> -    if (!cper_addr) {
> -        error_setg(errp, "can not find Generic Error Status Block");
> -        return;
> -    }
> -
>      cpu_physical_memory_read(read_ack_register_addr,
>                               &read_ack_register, sizeof(read_ack_register));
>  
> @@ -605,7 +588,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
>      return 0;
>  }
>  
> -bool acpi_ghes_present(void)
> +AcpiGhesState *acpi_ghes_get_state(void)
>  {
>      AcpiGedState *acpi_ged_state;
>      AcpiGhesState *ags;
> @@ -614,8 +597,14 @@ bool acpi_ghes_present(void)
>                                                         NULL));
>  
>      if (!acpi_ged_state) {
> -        return false;
> +        return NULL;
>      }
>      ags = &acpi_ged_state->ghes_state;
> -    return ags->present;

> +    if (!ags->present) {
> +        return NULL;
> +    }

redundant check,  check below vvvv should be sufficient

> +    if (!ags->hw_error_le && !ags->hest_addr_le) {
> +        return NULL;
> +    }
> +    return ags;
>  }
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> index 2e8405edfe27..64fe2b5bea65 100644
> --- a/include/hw/acpi/ghes.h
> +++ b/include/hw/acpi/ghes.h
> @@ -91,10 +91,11 @@ void ghes_record_cper_errors(const void *cper, size_t len,
>                               uint16_t source_id, Error **errp);
>  
>  /**
> - * acpi_ghes_present: Report whether ACPI GHES table is present
> + * acpi_ghes_get_state: Get a pointer for ACPI ghes state
>   *
> - * Returns: true if the system has an ACPI GHES table and it is
> - * safe to call acpi_ghes_memory_errors() to record a memory error.
> + * Returns: a pointer to ghes state if the system has an ACPI GHES table,
> + * it is enabled and it is safe to call acpi_ghes_memory_errors() to record
> + * a memory error. Returns false, otherwise.
>   */
> -bool acpi_ghes_present(void);
> +AcpiGhesState *acpi_ghes_get_state(void);
>  #endif
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index da30bdbb2349..0283089713b9 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -2369,7 +2369,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>  
>      assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
>  
> -    if (acpi_ghes_present() && addr) {
> +    if (acpi_ghes_get_state() && addr) {

double lookup, 1sh here and then in [1],
suggest store state here and pass it as an argument to down the call chain
(i.e. to acpi_ghes_memory_errors() and below)

>          ram_addr = qemu_ram_addr_from_host(addr);
>          if (ram_addr != RAM_ADDR_INVALID &&
>              kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {


