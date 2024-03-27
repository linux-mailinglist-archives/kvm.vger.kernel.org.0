Return-Path: <kvm+bounces-12883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7830488EA01
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1803B1F337D3
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7441304AF;
	Wed, 27 Mar 2024 15:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AqFEAUAg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91F33BBE5
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711555027; cv=none; b=gZ5VPq/AS0QCfO2RfFIdzlo9Vi2UWZopQG9epfnf9e+Z1w86LqeHk7poWRO/+lYSner+akRE6XI13UGQYPJcChUYvhbEfu7vTTocAycLV+Rb80oNIsrhPuM0/PgnWfEnJYF3kLE1M16w3AKFFmVdZo9GFUuRTaRZkLugpM7tqc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711555027; c=relaxed/simple;
	bh=xolD+KStM6h/UiYhVPWl/rlwdm70NGrlHVhiiIw3IFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d8zRVPpsahlOGf/At5xSEYUSlEHvpfmGEziEoSQUFWRM0vifKN0X3BD+mKebau/UVm9doR4o0mX7Vr2H7NCfYy4PxY+l/OYBirQN/3DlIntKyXh3Bf23HbFG5KVMg0EHZECt7nV4c7w5OZL+bpZfnb5XN85RagEnCVzLxUO7gPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AqFEAUAg; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-41488f9708fso23724825e9.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 08:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711555023; x=1712159823; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9RZc0Oa6GSoT+Kr5s8/A3SHBWT32jBMU5zycY9Q3gRs=;
        b=AqFEAUAg66OUCs4cvNCII+1BXiKdoqKW+IocND8dKdLVxBKb2jl6Xi4c4SyKiltTJo
         h8OlMJTLUepTzlcFbBY3mwFCWlhfk9zpUeK5jmqG45l+FsVcbXjn17IFVPsCuQUySXjC
         sHJFcuoLGs1ajVhaSq1gXP6fsNp+EoFbobYOCIlmCxp+XaCPFU/mEC4xslfYlzN8dLLI
         2z+R24xeb6FvNJZniDeEq3wG3MhaTzgfXIY6orDDofB6VcvRRGWAzNZeUe7jPZ9fUMQC
         QzEfYEzL/fxHF85rvvHyYbdh/VtwSPgDgmRTg8ln9Bk2JKaWCF74BJTq2bKvEmOAcmO1
         cMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711555023; x=1712159823;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9RZc0Oa6GSoT+Kr5s8/A3SHBWT32jBMU5zycY9Q3gRs=;
        b=VSj3y4uQM0R7GxympmOj+hh6Zcg+5T926Hx7I6js4ggsUfdf56UzbC6/Nv/x4t/8pA
         Yo0paksvMP5jiarbQgEa/1EWMY9S5kkFK8D9IRhz1DCYqtWqTFV6qerF4hIyHG5+vg1/
         ktNVpM/pcZp0Hb9GlFBp1vLUbNWgs4BNaR2PSfYp/zn3wlLDCpEbALLGH5NpxL7OrWfs
         pzEMlXMoIywok6/MdnHI5sZG6nDLjPoz7YfKX/DzGh9UQiL3y9DLP0X5vaKKASdU7ur2
         7VDha93MwiQFPhTQPJzCa7gRjD3oXQz79uK9c1F4I1aHDBHmUinZFH7RWGY2Wz4+9gSd
         RMBQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/9qwxAkHqYn5WcnPSM62Emm0O9gt+rBEW+Xew0/qr0XbtN8kQEskYlF7EX6KqDyLgRUmrMvJTUBljuX4upqIDPCSp
X-Gm-Message-State: AOJu0YzfSGffvANcIJHFTNyXoj1S86QFvx2IoJCQUIT0x4ldK/iBGzKk
	eHhbqmPcslyD/xgqPHcKIsC5Got/zCB7qhf5qwPT8dw6uUZi59mC8TjiIJuaCts=
X-Google-Smtp-Source: AGHT+IGs2esijcve1nRhIVXtWvFzpZT8RBRfuKIIZL72paxU0tXDteZDw9GkTgvgK4Lg2nhkK5RElA==
X-Received: by 2002:adf:f78e:0:b0:33e:c7e7:cc6 with SMTP id q14-20020adff78e000000b0033ec7e70cc6mr246826wrp.2.1711555023034;
        Wed, 27 Mar 2024 08:57:03 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:73fa:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:73fa:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id x3-20020adfcc03000000b0033e41e1ad93sm15104926wrh.57.2024.03.27.08.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 08:57:02 -0700 (PDT)
Message-ID: <540c12cb-f42d-469d-b3de-a52155298dda@suse.com>
Date: Wed, 27 Mar 2024 17:57:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] x86/alternatives: Catch late X86_FEATURE modifiers
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
 Ashish Kalra <ashish.kalra@amd.com>, Joerg Roedel <joro@8bytes.org>,
 Michael Roth <michael.roth@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
References: <20240327154317.29909-1-bp@alien8.de>
 <20240327154317.29909-3-bp@alien8.de>
From: Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <20240327154317.29909-3-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 27.03.24 г. 17:43 ч., Borislav Petkov wrote:
> From: "Borislav Petkov (AMD)" <bp@alien8.de>
> 
> After alternatives have been patched, changes to the X86_FEATURE flags
> won't take effect and could potentially even be wrong.
> 
> Warn about it.
> 
> This is something which has been long overdue.
> 
> Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>

nit: While cleaning this bit mind if you also switch 
alternatives_patched to a bool?



