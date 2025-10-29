Return-Path: <kvm+bounces-61411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F4BC1CBC5
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 19:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 053AB6279DE
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 17:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF399354AD5;
	Wed, 29 Oct 2025 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GIIuknXq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F172A2857C1
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761760715; cv=none; b=HXAAtABnrKRV85yrtaB4lWDLYdyfsKXmw+YYr787Mf/b18dNLZAA72lH7hIb2aS7yTZUO+bU0Nwe3nsvhX9VeATaJz3NPoyc3RSXfO7/XrndpPzXpMcQ2HIFiWQFUdc3qxL94rYZ6XC/7mnE08wU95zqZ9w1ZO5IBJ0NBqGq1xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761760715; c=relaxed/simple;
	bh=A+2HdjPo2WwvvXwz2EYXetrpNN+HQYJfXx2nsk8Q8PQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X0WrcUa+Vv6jIt26zrrmKbfw+KD3xn2oqNDN94aoZT83WMb2vCnXC/uPF7V6V53+Lj+G2Mejhb4AG+RDzyDpTxj2sYuj+ftkeiFem3cySAhQXl/AvipVjE6I2jzElXaOmORYBWw7DmaqnDzmtfTkWEhlGmGe/OP+RVoFKPnJUsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GIIuknXq; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47721293fd3so1183385e9.1
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 10:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761760712; x=1762365512; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u9mbM1TJeDrfNVQfN5B2xHuKYeF4jWa/ZDtGhcb6GVM=;
        b=GIIuknXqNOje0PiJxoyK40BE9pejhiHMR20QsTNbiKzNyzfGU5bqNHXaGMy81KTsXn
         gJJ6RbG4UHXhCOe8WbH3+48w5YA2SEtImbc7EfdxyZ+L2O70lyPpOrrYXDx5ncPlXoqe
         AhapQhwp8EosYArG4yEvd/QVSmwMZtXW2QuAUONcBuZmaSw4VKNzxDSIQCxZggLlRmrb
         +cvIjz4is48UVPD/W1YnUlHI9JA5o9JqLrB1hkNNQt956CtdBmzh+s3WUuf9idq9aMWy
         IeJBuQQqvjTADDxYj2MWPNl4muXFsZtejd05LX4me0Gk4fVpi/ArB4YGMqeXERMpkUiD
         32fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761760712; x=1762365512;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u9mbM1TJeDrfNVQfN5B2xHuKYeF4jWa/ZDtGhcb6GVM=;
        b=PLUfJHLKPH5uYbmsZQNM/2BQI+q+Xcy4eLP0Q8g2Py0yJ0dRXvDdbyiywf8PfYVnxm
         nW4MTmaAX//85ElGLui4eWU8oNPHIP4FCV4K8Ku1m2lqEx9ThqIeeOrcit/nsMfdO0Lh
         QDbHkbvB8nwV0+uILzmS4SmFZyYSYbvJx4ouNNNiBN12DNrvIki9OEEZ+q/1MoaRiqSc
         O58oboYI3vxdFQsM+p/i8BdNM51FcCZvI/NAIR2eETnzifoIZLEbK32I2HWwBYvqw5QR
         Zq/hZy7WzlZESuKtlNKxapANXxHbIRE5Nuu5UXpvalHyHFDXCAD6W/VFVsgjG1drv5Ri
         KoeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfp7k79UVNXWMfr2b+Ug4YakHxR5cVwYgmXapOdFVWcZ5w+bAb6xiYNbDGzGTXpXM0ymY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw02Uvsa/0RYAQgDCgw/lyBwd9w7S1BtujGHOotZoJavuu5mQd/
	uIZMSm64W9YQ71xXZPwOQefzoHLRNr5FE7BN+k7t9um+MmLSmYoyIdpIMir3pWcQ8YA=
X-Gm-Gg: ASbGncsUqtfWEJgdY8Dvd4P7K9LxzBdsytDXE2s/Gd9eAiNcYG9VNeZ/5TtRPa252M9
	YAgOUEPF8VmjAyRCXIQieS4mZiH8WcbafJaBa8j2pSQc8kMsP0DfDnrgYbZHL0VZ2DEiuRUYURK
	9MsQyh/tJNU0clQeEsqXvjawfpXPrmXuyeC4GXbpsdMaS93Y+Hp2cSqaGgUqAFKxezmS9hnBAZ+
	jXwAQ8juAHRNNbu5z0NKROlgxUrK6GrYhja8Ys24Lujkn9uvfZSeGQCqhU94ct4Fox/RWuTcEfK
	s6SuY5zNVzZWwzPFt4bUWWTsWm4CFcJfYbyI6fnAo+R39n3+AGuRs8cr4wjOOKsgZMJG6AFRq6Z
	RFXmI0ha85SNnmTz3JhlojnCGbg5qBZ6F4FkWLEZcXlzKAPTIQWgUrKX7OpNQVvRXnZk9uk1KWc
	mnpiY7550I+Wnn/qhnQ1NtQZsQeLRU0h/radbL6NctfLk=
X-Google-Smtp-Source: AGHT+IGy8U1c5cK5CgNTx7+CWUBajFDbxrbBWu2QCrhlMuEJK2sD05bVqLryZVTHjp3L+ObQl9SeNg==
X-Received: by 2002:a05:600c:8710:b0:475:d9de:952e with SMTP id 5b1f17b1804b1-47726238877mr5601515e9.1.1761760712154;
        Wed, 29 Oct 2025 10:58:32 -0700 (PDT)
Received: from [192.168.69.201] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4771e196a9asm60312455e9.7.2025.10.29.10.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Oct 2025 10:58:31 -0700 (PDT)
Message-ID: <395c7c86-08b1-4af4-a5ca-012a9aa89339@linaro.org>
Date: Wed, 29 Oct 2025 18:58:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] cpus: Constify some CPUState arguments
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
 Kyle Evans <kevans@freebsd.org>, Warner Losh <imp@bsdimp.com>,
 kvm@vger.kernel.org, Laurent Vivier <laurent@vivier.eu>
References: <20250120061310.81368-1-philmd@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250120061310.81368-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/1/25 07:13, Philippe Mathieu-Daudé wrote:
> This is in preparation of making various CPUClass handlers
> take a const CPUState argument.
> 
> Philippe Mathieu-Daudé (7):
>    qemu/thread: Constify qemu_thread_get_affinity() 'thread' argument
>    qemu/thread: Constify qemu_thread_is_self() argument
>    cpus: Constify qemu_cpu_is_self() argument
>    cpus: Constify cpu_get_address_space() 'cpu' argument
>    cpus: Constify cpu_is_stopped() argument
>    cpus: Constify cpu_work_list_empty() argument
>    accels: Constify AccelOpsClass::cpu_thread_is_idle() argument

ping?

