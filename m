Return-Path: <kvm+bounces-65090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D823C9ACC8
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 10:11:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 79E644E2810
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 09:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F71C309EE3;
	Tue,  2 Dec 2025 09:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ampCRX0B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508E21BC08F
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 09:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764666682; cv=none; b=pVUg7TFRyLSvAKILDcMKsVlEZnoU2l6XmDsW7FWEHkQ1/fv9k6uAnPRJKyNtYinhVDSJu85p7vKhUP53jHaWdd1OtabWA660cRDqudPWyYXQiVBz5g+xwRPX/4xyOMFaSlJ3QC3vn0h9p7opK0XzNnVJF48UmkO0L4o9pg7l10w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764666682; c=relaxed/simple;
	bh=uEfWvdp/iNY3eVhyQwnpTZp1TCHiSYDNB1SzG6GyEXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BMHmrIQflqAbbGfA0dduYwGxHde8rVQD4FJe9+xnC22mEZSR3ukrN2C6oUEjtLe8bD2zLYGQpMWQ0JWca5iaAndrPEMWJAF8zX1pEav9uihmHTpd7W4OQD3nIZqvX8DmuDrEj9Inklua7FiYpKUvvNN2Jszu87UNqhYpnHPdrwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ampCRX0B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764666677;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z+N3hLgGvGZH88LHMoSGzIAzbnAcNoGeilZxl6S9qyw=;
	b=ampCRX0BYBLclHR1ghMSxBIOnHufw4r8xqpr7o1A1VIEYpeHrxZwqDPO7rKqZ1xASDZDU2
	6Z4rXbenGxJpnReszAkPl993DRcz+B4YS66cJOn9uV7mv5+oRZNaIL8lqROtCxWAE9TRlX
	ZEE9iodlu7bjxlzXllTM6+Kj6aPbmXo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-WsbtJjfPOkiIJk8gRk4TTQ-1; Tue, 02 Dec 2025 04:11:13 -0500
X-MC-Unique: WsbtJjfPOkiIJk8gRk4TTQ-1
X-Mimecast-MFC-AGG-ID: WsbtJjfPOkiIJk8gRk4TTQ_1764666673
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-880444afa2cso63814906d6.1
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 01:11:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764666673; x=1765271473;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+N3hLgGvGZH88LHMoSGzIAzbnAcNoGeilZxl6S9qyw=;
        b=T2kzUzaV3TBCswxlK/P7ZVcZZKisw/VuBvHjD5ippJ1aF+8nSYMzGRrer7xe3hbw+D
         PpeIOmPMkAOqaA/Sy1bpFLz958wyUxHXFP8uKg29vyu34Vjbxw8ogT4xgqBcSuTM/FX2
         lQujmjrrPJWGRAJuVCFmS0S/bKf6wV4qjLmRO1OiwKV0P6Gg7ne5It6bVGT5YtADGW2t
         X+xI8wLe3UbtzSu4rnMH2DmyANMPxhkWm5WBaHk96ql3xmsBC8GqDomMRsfZSRgQpM2t
         oRZjZ2/ILgbikooXSgaLthcNmMeksoQ2bU2RoqCGfpvnk6bUQ6D4RB1+7YWpgFHcX7z8
         mGBw==
X-Forwarded-Encrypted: i=1; AJvYcCUy5B+CD6PpjTBE/fKuGbvqGEWWfkR6X0yE5AVwCW0St/N+xcLwbnA7sPRry/m7ax5VjNk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBVorp1nwrRABJ4/NyliIK+sy4FJVv728cNpwm3G/1bI4w3Ycb
	BhMnL4xMA6xBePP+1cDpMNYQ2TMepW18yYcXIHRFyG8PGzlm3bxSm3U3QcQOsloj68ZiMpWUrkF
	/UaXeIJ/XVmLml8jmfwcfuN3Yoxly+U/bZ7XAFJpcqCt2WJ+McTFutw==
X-Gm-Gg: ASbGncuOP5eIGKAV7jfllMawL4vkbXLujfWqTmdU9B4st9rdFu/pLzWCtQKrVUwRrfa
	cMKqm7tj4g8xKwpyZIem/QGI3hwtV/uQ/kHiRMis1sx7Vh6ePzbDDLyzWnmrRS3pdEdQwTrCpON
	V8pZ+ijSS8kYSsz9THNMfHyBey8YjJkVS04H/+7zIBhgQCljW/NPcXPESrXtm3O9XRUaVbnXLnT
	ea1wgKU14RKhKVVbo1Hwd4Ilh0oGPpDqo1RmXEqGsoFHlE/9oJTDLAx8puaRZbwCpsKw56OggMl
	W7oVcohUemcvT9gaauzGVMcEWRXH9DeVBfNW8nYHQg5zJF9d+OemGfO0JkdXRmRQoKQi2qBG/rq
	SFOpdgQRilzOinMnzxxsKxDuNouEZ3JZOchyB38Mr6nNGadd9jaQ6nJh7TA==
X-Received: by 2002:a05:6214:3905:b0:87d:e456:4786 with SMTP id 6a1803df08f44-8863aff2e7cmr464855036d6.45.1764666673325;
        Tue, 02 Dec 2025 01:11:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgomIk+Tt7VTAgUyOjLDgRSqbCIrSqPRdj1txKlLHoPERXK/vVkPh/c6XqIxIl+6h2XLJjMQ==
X-Received: by 2002:a05:6214:3905:b0:87d:e456:4786 with SMTP id 6a1803df08f44-8863aff2e7cmr464854726d6.45.1764666672896;
        Tue, 02 Dec 2025 01:11:12 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524af138sm102423366d6.3.2025.12.02.01.11.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 01:11:12 -0800 (PST)
Message-ID: <7c8e87c2-6b73-4713-a58d-09c6a2038ffd@redhat.com>
Date: Tue, 2 Dec 2025 10:11:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 06/10] arm64: micro-bench: use smc when
 at EL2
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-7-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-7-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
>
> At EL2, hvc would target the current EL, use smc so that it targets EL3.
>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/micro-bench.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index f47c5fc1..32029c5a 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -282,6 +282,11 @@ static bool mmio_read_user_prep(void)
>  	return true;
>  }
>  
> +static void smc_exec(void)
> +{
> +       asm volatile("mov w0, #0x4b000000; smc #0" ::: "w0");
> +}
> +
>  static void mmio_read_user_exec(void)
>  {
>  	readl(userspace_emulated_addr);
> @@ -300,6 +305,8 @@ static void eoi_exec(void)
>  	write_eoir(spurious_id);
>  }
>  
> +static bool exec_select(void);
> +
>  struct exit_test {
>  	const char *name;
>  	bool (*prep)(void);
> @@ -310,7 +317,7 @@ struct exit_test {
>  };
>  
>  static struct exit_test tests[] = {
> -	{"hvc",			NULL,			hvc_exec,		NULL,		65536,		true},
> +	{"hyp_call",		exec_select,		hvc_exec,		NULL,		65536,		true},
>  	{"mmio_read_user",	mmio_read_user_prep,	mmio_read_user_exec,	NULL,		65536,		true},
>  	{"mmio_read_vgic",	NULL,			mmio_read_vgic_exec,	NULL,		65536,		true},
>  	{"eoi",			NULL,			eoi_exec,		NULL,		65536,		true},
> @@ -320,6 +327,15 @@ static struct exit_test tests[] = {
>  	{"timer_10ms",		timer_prep,		timer_exec,		timer_post,	256,		true},
>  };
>  
> +static bool exec_select(void)
> +{
> +       if (current_level() == CurrentEL_EL2)
> +               tests[0].exec = &smc_exec;
> +       else
> +               tests[0].exec = &hvc_exec;
> +        return true;
> +}
> +
>  struct ns_time {
>  	uint64_t ns;
>  	uint64_t ns_frac;


