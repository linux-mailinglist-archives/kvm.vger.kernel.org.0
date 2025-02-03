Return-Path: <kvm+bounces-37120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 45225A255AC
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 10:19:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C64C7A3EF3
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 923CE1FF1D0;
	Mon,  3 Feb 2025 09:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBvQglgj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B731FC7D7;
	Mon,  3 Feb 2025 09:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738574379; cv=none; b=Yt5ifwFstF3IEF95yYw3cbjLj5PuR6Awt3tSsmaBywvyZRGmWd8uGH8pXtTKqMyQhbW3pg1Hz24HPMt9azy8q1K1m7flbQYJ1X7RFdK7kTkQietgpqmfpyC8taKqYoHYuwsIA0UEZE5q8GvW3AXIGMQjHJzuGhM0W86G3tAmhEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738574379; c=relaxed/simple;
	bh=QG1j/uPDOlngUuMw3IpvTBZt6YxgpFGDuwZACukdpR8=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=JmxM7SlH/SMX/AV7ltYe7zdsyASRFt8mwL3G7Iqm9QzyRXl0ORuQCP5Djd2AEA870Nq0G8Ezf+HozveEcbnkCt4VtlQSMSWAUBDerMLvvkCkxeTeKVmvc2KT9V2/UiXscD2kZrWCotfFtz6KcCuE+iOJ013mYQFEmPtIyu9Mxuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hBvQglgj; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aaf60d85238so636301066b.0;
        Mon, 03 Feb 2025 01:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738574376; x=1739179176; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NH2KGEe/ION4dSm1dq1NvkG5nnjpuo59yW8PRs/x17I=;
        b=hBvQglgjGkD4yR+ZDHI7AWHZHWPmNydPZjasz/JJ4jG3Q61USM1lE6aybmpBMRRkK1
         pABPfRAAeMSGaEun4ujHs3MrIT3tH2Kcx4dReQ/XjZGq2ewKCtgAlrrycfSfOzN/Fmve
         3P/mi9d6RL1PcuBQCPuV4LW08cwwC8jNY5w+o6MOxJq1uS7JOlTQjWx/lWXM9zcTUOby
         beqoS5MWkZnOpy72PuHjWW5NCTauz56og6urnaTGonLUPcAreX+lH3w4rGqi31vn46z9
         LvOCNugrmxRsLyWeBeNj8RKn7YCioyZo2wWrYaoLZ8JNDhnRyJQbaxWM4Wg3MOL6295D
         U+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738574376; x=1739179176;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NH2KGEe/ION4dSm1dq1NvkG5nnjpuo59yW8PRs/x17I=;
        b=XZaoyXk9zh/sKoWU34Wtn7okdFwS8W3s0pN+T+86hdjNLPrOTIbIFcvPLuR9TPgASw
         zZ5iUjxEzNKXy1JoW0gcp37cWzxr3V6bONcYHmtjM1ia/RChRNYu229XeycD8EITdTqg
         yl9J+iKiqJ/bzNypExeNq2qzb5P1uJUyHkCnreborVZAvD1QGad3YuDpdZfQRbmtpQcB
         gWy7FZ7CO6XXJ6PKSuoDtk95x+gj+G/gle0z9cJP0RzNyhrAoS2KwFFpW/140aQCd8Nv
         AylVITZUIWwiWKalfms9J1DoLgP8IgvZJZP4AmIfTobikF2rANXYdKSVYOvsf/QQOaWa
         tV+g==
X-Forwarded-Encrypted: i=1; AJvYcCXin5K48IzocpMWTGHsf8xBaSrtqRbSY09cNLEDPn9Vfw8RPXPUWU5cJY8rtznDOHFtpY7sgNzAu3JvEEo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaBM0L7RacJP9lM0QAOXvB+QEo0b1QdYvc8M7PkI4abSCEJPP2
	EXIwUfxclOTOC+cCcP+XXuXq0VKko3mtTzR1QyBfwJocYrX4cXsQ
X-Gm-Gg: ASbGncthrkmN2otApNDV2nsVMKsfNwKUB6NO2KleTGg1PMPbG5Zb81IFLWD0oaou0Nd
	WXSaIsoU1UBoDydUuCVwwydvQJSFWZia79dXRYZLrlH39KujBjH/n+mhVmfu4q28YI2k3bvKiEI
	PWj5uswse1JAbwk1pOj7DkoCaTPl/llLGivQh0VVQEWVnH3Ny8g24kKVX8rvAq/qCtYvzQpj6OF
	1pvJK+dByrLk21ualJ3UfTRGnC4G5CV0edGjf27BVPbR/Dp+76OyJRDzEdBHsG5mKuNUEKa+vPO
	/zK7UTBBoP0oK2T8R9xAOMkO5VXeXPN6Q/hu00C1UkDYRDNp
X-Google-Smtp-Source: AGHT+IEzC4s4fpSKKKvdh3+OVtklxfGVBCXamEAYUW9rD7/B9jxbbdhDEBKbvcZ9fbz3S5bXlaw+gg==
X-Received: by 2002:a17:906:c143:b0:ab6:597a:f5d7 with SMTP id a640c23a62f3a-ab6cfce750fmr2402712566b.24.1738574375140;
        Mon, 03 Feb 2025 01:19:35 -0800 (PST)
Received: from [192.168.14.180] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47cf29fsm720251866b.38.2025.02.03.01.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 01:19:34 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <bfa86e2b-536a-411e-b7a8-b9ca4da4d362@xen.org>
Date: Mon, 3 Feb 2025 09:19:33 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 4/5] KVM: x86/xen: Bury xen_hvm_config behind
 CONFIG_KVM_XEN=y
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com,
 Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
References: <20250201011400.669483-1-seanjc@google.com>
 <20250201011400.669483-5-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250201011400.669483-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 01:13, Sean Christopherson wrote:
> Now that all references to kvm_vcpu_arch.xen_hvm_config are wrapped with
> CONFIG_KVM_XEN #ifdefs, bury the field itself behind CONFIG_KVM_XEN=y.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

