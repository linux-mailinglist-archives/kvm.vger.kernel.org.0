Return-Path: <kvm+bounces-36614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC08BA1CC97
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 17:16:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB71A1882B0A
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 16:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F1B615748F;
	Sun, 26 Jan 2025 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jLxkabZ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244CB13B58B;
	Sun, 26 Jan 2025 16:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737908155; cv=none; b=MZwAjEiMfsUnXGFhszqBhrPsEHJr2AducQvLKdl+2slV+8kl3xLzAgD9VgHT31AKLH27dPq6LAsnjmEUlLNLq7mvrcxosF8HDFa8cIfAGwBHhwkFDc2huYtzaJ9nVww3XY3yjBjq5tg7V4SttijMa4ScsvVUjBzuj7UncTecw/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737908155; c=relaxed/simple;
	bh=wK1MkugI5+uukJSX4Cid8gKDFtHolEMoMsrekTCIrwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R8RRCYH2PuFFUW0xw9nkQVAvoCygLKeV/rWMDnnaO17af+ypxvn2EZsfJqBHEj2r4/r0T6mLYiilRt/1waH7ImSmNWiPYcVW65EiUM4DegmKtRWq1F0to7jQhvlV9dpcxFryTnoE0JS3kJbnGu+tn0cDbN8K3HdvveL2lDEzKg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jLxkabZ3; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4361b0ec57aso38811445e9.0;
        Sun, 26 Jan 2025 08:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737908152; x=1738512952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=S98w0iqP0qfLXfLNYIVgIcrJ6tLTBGo//hibTZKl+Ys=;
        b=jLxkabZ3khRIj+RpGYGyvTDfnQQDUkHd1Xw/vQu5IY7DV2RGcvQb1qfxGwC1iKS8SS
         64SlxZCAo0abvvTxvRdIpvY29iKmWlVzdeTVBTXM+3gCZdwKl+mVvcVXwmukiPM35nOD
         pqVP6QNMOkZYN5im/pUDgFteA0x0wTeiMxqcWIuvkPcS2QC0BgfBKOCa2T1/iLxrQZku
         i0hsPlGpXNvOJj1a+dQwIEbCaQmgTdjSGo/x+wWgHwU1Si00ZPmiv2Bt4MDkyzP6mlog
         MI1q7+wbvHzYlSL8qLieSJrq6SrEaqnls4KyGMb6QRI1ITysjR9FnRfjRzLS3VRK7tR7
         6NUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737908152; x=1738512952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S98w0iqP0qfLXfLNYIVgIcrJ6tLTBGo//hibTZKl+Ys=;
        b=wj8lxU0vDtbwyDEeLiESaSjit5XaNlNcPWnn/zVw3ia+DGU+Anb4ccUh9Kub4ReD4P
         /eph8v6KWLY3CenGZKD+P/Ax206q7zd8t/WP6cmCPB46nm8qPyAsOWfvwSqEB8iJTu3H
         oOE/JV2VIa3n5LOKIOEaiTh99/CoT/3KT7z7/Yj15ZY7GAfW1G2goyvcb7NVflX7McGd
         UNfaI0RM+mAWKPhfrJAAwyyu+VA36hLUkaJJVx6RbqHeAFTxKlAlGKadyT6jjdGS62je
         vkn2GxA7AEKk9oH610JfaLMFM99nZrjnnVNrYB1rQ6ioqCtKBKU7AeoVxe5qhNqgIGbH
         Ex3w==
X-Forwarded-Encrypted: i=1; AJvYcCVBjFt+1DeV9A+YhovwHtY1gBed2OC35WQg+GeHRVkxeZprLsyLzSvHVqlgQ5u0WCS5sdM=@vger.kernel.org, AJvYcCWVue7w14PunggpI426wtatqG3cvy5R146njRLCSFyr5v/r2Sy+EO7CYTsniQ4aLTun5QohlVBrRLtMtBBn@vger.kernel.org
X-Gm-Message-State: AOJu0YwXer95jeODZizTSDAxaofMIt2P8NmqLaUK84dhwlg4XnmzTno6
	kK4ZWCW0xJfLRnQqgOMAaplb8lbyBInMAnP292cg+DPfDT2WNNF9
X-Gm-Gg: ASbGnctC7TIy9K8h9XNmWy8ML/+ngTsA21IxenpRVGIkjSSoQXmKF77pa6Q1V73pyYr
	i4cCiSztlaJso7B7Fj/h15rCcWBcBIi5/MbELtuEoIzks0GH8RxArLVARh60TCijNqVLDlnMlGh
	1hmuhfu+yZV6It+RqH9d8aZn3Dval/St6dq6E9vQ0wNCj1rzjuqJnWWoyRapd1bVKs5LfHTZg3V
	NEdRUA/5jYuCwhamHXGal1/A7gK4gCdsXc+lzrg8X+H0zFWIz1xrXDYz0O0a4QFFKsAQhHS/cNi
	Xoi2PCR9i5x72WEYZr4siAGEnm8PPjMu+/Y59YXuoOlkUq6Y8hWM4UzesyMX
X-Google-Smtp-Source: AGHT+IHIGXjHuA7Vq+jDhgrFRUcT9bAAu8eW78TAfq4ZyNw5QOit1AH/NYsYuqWncHpZQuDHYTjYGQ==
X-Received: by 2002:a05:600c:1da1:b0:434:a815:2b57 with SMTP id 5b1f17b1804b1-4389141c4ebmr285594765e9.20.1737908152132;
        Sun, 26 Jan 2025 08:15:52 -0800 (PST)
Received: from ?IPV6:2a00:23c7:df82:3001:20f1:15b5:79c7:cb20? ([2a00:23c7:df82:3001:20f1:15b5:79c7:cb20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a188673sm8281574f8f.46.2025.01.26.08.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 08:15:51 -0800 (PST)
Message-ID: <c1399dbe-3987-4236-9b21-fe54e99651d5@gmail.com>
Date: Sun, 26 Jan 2025 16:15:50 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2] KVM: x86: Update Xen TSC leaves during CPUID emulation
To: Fred Griffoul <fgriffo@amazon.co.uk>, kvm@vger.kernel.org
Cc: griffoul@gmail.com, vkuznets@redhat.com,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>,
 Paul Durrant <paul@xen.org>, linux-kernel@vger.kernel.org
References: <20250124150539.69975-1-fgriffo@amazon.co.uk>
Content-Language: en-US
From: "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20250124150539.69975-1-fgriffo@amazon.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/01/2025 15:05, Fred Griffoul wrote:
> The Xen emulation in KVM modifies certain CPUID leaves to expose
> TSC information to the guest.
> 
> Previously, these CPUID leaves were updated whenever guest time changed,
> but this conflicts with KVM_SET_CPUID/KVM_SET_CPUID2 ioctls which reject
> changes to CPUID entries on running vCPUs.
> 
> Fix this by updating the TSC information directly in the CPUID emulation
> handler instead of modifying the vCPU's CPUID entries.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
> ---
>   arch/x86/kvm/cpuid.c | 16 ++++++++++++++++
>   arch/x86/kvm/x86.c   |  3 +--
>   arch/x86/kvm/x86.h   |  1 +
>   arch/x86/kvm/xen.c   | 23 -----------------------
>   arch/x86/kvm/xen.h   | 13 +++++++++++--
>   5 files changed, 29 insertions(+), 27 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


