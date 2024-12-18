Return-Path: <kvm+bounces-34067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E3239F6AE5
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 17:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5292166120
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C14E1C5CA2;
	Wed, 18 Dec 2024 16:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wU3BQzpo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FEC1E0DED
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 16:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734538715; cv=none; b=bU4w/Gc2OtwNFlNWfuospbL3ez5t5uIHaI8QV7n3Ew6Nc4uPXxyza3MshOL2YUgmo+tLp7k2xgTLoD2Ey6hY7xVaZMlhB1WESGOqg0RWhXxNAPz++JXilxggGXOggs1G3YcDcUToS456Yh3MCQlR8IpeqNMTXi/HR0ukE6TE1G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734538715; c=relaxed/simple;
	bh=KQoziINuv57BM6Oc9ouARF5UzCa8UhzfMO7Xk6Zv5lg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hf+wOEeIhcKfybXKxTwLWpzYVjh+hV+TqQv5vREPDsMneHy1JXrWW1OyF4wWfSULAfkc61po9raR4tm65t8h17VfUkXysE/uJ+t1B+dVIm4e5/Kf2veJuLS/+Ti62IIfb8kzhdhedPXWiB/rooZ/Q684e6/wO6zUigFJ/vX749A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wU3BQzpo; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43634b570c1so35846075e9.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 08:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734538711; x=1735143511; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9fO8nMjzZFLc8R8WzCO9PefY3tpK9vwCpbuaZ4XFGiY=;
        b=wU3BQzpoFtuu01xnMZRF1TjK/Hp1PYbMnZfOkHaZ+JAsJFplS7Z2rk+wUnpfBmJyjX
         Xpvhgibyv5KsEwJVYv3U7/JbLen0NCdWV0IgYtKCpIxkf8pelP0sggWAPIy7PScBSH8V
         ZpHcsW9SJMhEmQHROToiM3GsXylNIDmyGZaa0YkzEJb0WgxXseZVi8eKzjWa6W+KCRzz
         gashnCpEuZvdAiQuTVjosABBzd/uFzjdnPvlWT1EHnGH/wdj30Ud4UkGO8hRUkplNPo+
         UIifzfZC13LtbC1xRPz7Q8UQLPr7RX/QJBQG/TI8bLzR62M0GDpGSE9CVkjxx676imsm
         kNsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734538711; x=1735143511;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9fO8nMjzZFLc8R8WzCO9PefY3tpK9vwCpbuaZ4XFGiY=;
        b=pfyDn1Fwn4jWeQVs4vVjpawzEJIk47M8M+0/41QOJW7Bms9vsrPH6zG6IdSMVhXA/q
         djJuXMczryCiKcxWg2+2GQ3ezDe0oLmXuurdZ2uk+WQTBNgr/91eTbrHkaktRbKnt+wp
         Ay00zP3hVb0CB+IHaYL/B73UzWlwL7WVB7oO6cQDQSNzj3P4gwYP44CPIdy+Cz4V7F2h
         EUBKGG1NKVH5UGeZvV6fqiUbp6I3NDpTrURQEyVBM5Kzt0o0N+JldrQOBeu0mFWSS4Ek
         N4TNnCJnfOa3EUMQ5xpZlnAnLymaAUh54/D+XQqiiiNQRPJhsD91+zvkyM5bzU0Txthl
         QOmw==
X-Forwarded-Encrypted: i=1; AJvYcCVkvRfWY5G+G4iGRocM7DTXPONMkDRlnrkC+sfPszNqLnr8oJkS3QRXWvs595wNHjYKM+8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0LotNZI/h7eHZZ/lyPSvvGYqtsHYzhOMAX7Abj05eJ/hD28IB
	rv6jqXcSO7xVSxg4sNzWQqVukHWGIvbr+QdN3TBju2b8fA/l4ooIjBlTnMSprdA=
X-Gm-Gg: ASbGncuXmwca33lD6qTK2GJH191S3fMBM3VcF/UBHFnRl3OnHmhMbpKAtWOcKJHTNnI
	XAGvJgVzSzKr+Xd1s6/diONVFq9hBanemxyqdfGPPfbHu2X+3YLTLzeNTqO+akc9/lSS/ksn2Iv
	vtc/Di64nD3ibnp3+Pah/RgbpdJuEkEedXm6uKwFnH5m5F1OKKnOHoAIE4+mpeKOItzSL2kel6W
	cfFeqzXBY5o5iT+V6wdTm0Ju/cNJomHcLqzmXUD/xMQWVGBdrxwHKPwKSHmGVoHW+M2HpJJ
X-Google-Smtp-Source: AGHT+IHKmuvMJW7nt1Lc5C2c7tw2Z7JNAi6p9+cbthJj4Q2DIpLHipgLC7L9mplOXcKwdUSugJuFvA==
X-Received: by 2002:a05:600c:190f:b0:434:9e1d:7626 with SMTP id 5b1f17b1804b1-436553f4992mr27309735e9.25.1734538711536;
        Wed, 18 Dec 2024 08:18:31 -0800 (PST)
Received: from [192.168.1.117] ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b015absm24745605e9.13.2024.12.18.08.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 08:18:31 -0800 (PST)
Message-ID: <027fccdc-4ae8-4761-907a-3810b8e30cbb@linaro.org>
Date: Wed, 18 Dec 2024 17:18:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] target/i386/sev: Reduce system specific declarations
To: qemu-devel@nongnu.org
Cc: Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, David Hildenbrand <david@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-ppc@nongnu.org, Zhao Liu <zhao1.liu@intel.com>, qemu-s390x@nongnu.org,
 Yanan Wang <wangyanan55@huawei.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Halil Pasic <pasic@linux.ibm.com>
References: <20241218155913.72288-1-philmd@linaro.org>
 <20241218155913.72288-3-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20241218155913.72288-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/12/24 16:59, Philippe Mathieu-Daudé wrote:
> "system/confidential-guest-support.h" is not needed,
> remove it. Reorder #ifdef'ry to reduce declarations
> exposed on user emulation.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/i386/sev.h  | 29 ++++++++++++++++-------------
>   hw/i386/pc_sysfw.c |  2 +-
>   2 files changed, 17 insertions(+), 14 deletions(-)


> +#if !defined(CONFIG_USER_ONLY)
>   
>   #define TYPE_SEV_COMMON "sev-common"
>   #define TYPE_SEV_GUEST "sev-guest"
> @@ -45,18 +55,6 @@ typedef struct SevKernelLoaderContext {
>       size_t cmdline_size;
>   } SevKernelLoaderContext;
>   
> -#ifdef CONFIG_SEV
> -bool sev_enabled(void);
> -bool sev_es_enabled(void);
> -bool sev_snp_enabled(void);
> -#else
> -#define sev_enabled() 0
> -#define sev_es_enabled() 0
> -#define sev_snp_enabled() 0
> -#endif
> -
> -uint32_t sev_get_cbit_position(void);
> -uint32_t sev_get_reduced_phys_bits(void);
>   bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp);
>   
>   int sev_encrypt_flash(hwaddr gpa, uint8_t *ptr, uint64_t len, Error **errp);

The motivation is to reduce system-specific definitions
exposed to user-mode in target/i386/cpu.c, like hwaddr &co,
but I'm not there yet and have too many local patches so
starting to send what's ready.

> @@ -68,4 +66,9 @@ void sev_es_set_reset_vector(CPUState *cpu);
>   
>   void pc_system_parse_sev_metadata(uint8_t *flash_ptr, size_t flash_size);
>   
> +#endif /* !CONFIG_USER_ONLY */
> +
> +uint32_t sev_get_cbit_position(void);
> +uint32_t sev_get_reduced_phys_bits(void);
> +
>   #endif


