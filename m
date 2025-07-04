Return-Path: <kvm+bounces-51560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59C05AF8BF8
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:38:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBF53188E5F0
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11C082DAFC8;
	Fri,  4 Jul 2025 08:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gqmLkHqD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF3D2DAFB3
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 08:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751617684; cv=none; b=sJ1fpKvZuMSSWGs01Vfcgos34qSKKFcFYPvJ7sNKn04E/g1Z3VUFF09PVhntFjQXps/JTxFr6qh+v4C8jxxdsFps2aMFvqoAeu/wXf766yoD4sp8MZmurwNHMH6wmTzPpjzo93AcdWoDdeKHb2SODJnvmryl58XXxsDvogxx72M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751617684; c=relaxed/simple;
	bh=hSND0AHGMQs+0QZoTOtuHQydPDwPLAS0vqYGP5xVjsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q4wW2wmKH5Pnyy+6O1uK8faUMo4E7EpvnffA5xAbwxJ85speSNgvCC1FiI2XkC3iOLtDtKjFyab0ur0QeGiwjr1uqPWZEaWUgOvXZ3H4KxYbzYv4cLbIXAuikT13tqyAn75UMS36RG63YMCsS+J3c96V/1JEDZ6YZsZ2XpSbkR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gqmLkHqD; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-454aaade1fbso6819365e9.3
        for <kvm@vger.kernel.org>; Fri, 04 Jul 2025 01:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751617680; x=1752222480; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U0A4usibI7eGbC53g5/4tZrjHX/EOioQsgduZ6qqcEw=;
        b=gqmLkHqDVnkMoTr1ZxDEVrKA+WrA/h2PCR6iKql4q7dzTNSIDFCx6A5GpHOhqzRI+3
         k0G804oyi2e6/OL64vjlb2XC6ldAusmj7j5qHq/XBmXImV1IONA5MuS/F9/TkbI2twt3
         8prIUyigE253RQTCUJAemBKtizF74Zp1NkT7cpLrx3c+gzFmfjVDdzuKkLd8A+sz5dGz
         lrwAhf2eAnaBVcq6CmeM8UuPtNit/yVdJa7nE3nRAjAXK1+bwyJJvh5NQ2t2P5na04za
         w5v/kLAj5Z6KYiJoI1D9/idN6l0l35MS7xUIQjs0Dc3K6GYogT8HtrNI9htzqweMpDBo
         dUWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751617680; x=1752222480;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U0A4usibI7eGbC53g5/4tZrjHX/EOioQsgduZ6qqcEw=;
        b=eJNLdFHsWd/IHH4WLBG+UwtYPHLLyQcUYlcTkyNao5SNOcr8sotbrPy1DVDazoVea3
         p/nku9uOQifVzW+g5KT80Opnz5vW5k4FLbZvIcPaQkAl2XE8Rwk/PjDSSPYiJpsuf9aZ
         9cKb8rLjiLYl33vNN0W0M0tcoOlsPLDLESAS9N854J2N8StFg1rqUqFjZ9WB0me5cDx3
         NLRyWExl3uQKJfgZ6lPzEGQawQZ2uEsXtK8xYZTbQzbLRKJFNLH6/9i3b6eR6b7CuG/J
         ShiPsUzRkW9dZM20EQVfJPH9BJlCpXxSmLiNcA/hz52vtPxb3Hw65pi9yyGCfSd9DL6e
         eEmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpb73KMIXJDHvaXaamRQLJ2oeAOdG0o6lcXwfY038iEsWXIgKk8ARSZEuF4iUOINXNpmY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz51Rl+gfh6TKvELdd5MUyl11t/Br4nrxuKW/TFJfuQARYsHrUd
	03tKSjGz2953Wwbu8QOJC4TjY7AeUSSZ3IxZ/+ATvvaSqU8QiEYTgQ+N0amBeXagzEc=
X-Gm-Gg: ASbGncvN9jjAcayZa0zkjb/5z/tjZO6rwkQFNIydtepsMDaAhF7iEYyE9LYjFCF2zB/
	SvXi1lQErvattvf1l6l0PKXs6grEO/zCW/WjxAKqjkrbzJbWgLXY5k4NidCZJVo2XLHzO5ihJOT
	h8r1PD7g/GLFg2uoUtST34uMx+drMaLne/EhfEwx4wzSnoGPNc9h6/uv6XVekWM9KP7KGMyuetl
	1zdSrOrf42JPS1JZy6HsadASHOIghJuDGnrof5kOkK17FC5mmMLOkNg0ZOjCA2walqAJ5vurZaJ
	zXFMWWJ9A9+rOxSsZZzaPdfIB2tlTk33myuTYBW94WdXQ82QCNMS/I/mhUa7bKva9GNRdl0WWGg
	/9pH7ocSuq4VB2uKqJsaqtKJvlh28SA==
X-Google-Smtp-Source: AGHT+IEJWeuXd5bkocPT1GC2uTHAsrEBbH8Qs+f1xwK7OySX9hPisz7u73RvYfTp/652iJy3CmXBxQ==
X-Received: by 2002:a05:600c:1c94:b0:43c:ec97:75db with SMTP id 5b1f17b1804b1-454b4e79819mr10558905e9.11.1751617680441;
        Fri, 04 Jul 2025 01:28:00 -0700 (PDT)
Received: from [192.168.69.218] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454b1634147sm20034405e9.18.2025.07.04.01.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jul 2025 01:27:59 -0700 (PDT)
Message-ID: <0bc1e609-88ea-4994-9815-020ae6389475@linaro.org>
Date: Fri, 4 Jul 2025 10:27:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 28/39] accel: Expose and register
 generic_handle_interrupt()
To: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Mads Ynddal <mads@ynddal.dk>,
 Fabiano Rosas <farosas@suse.de>, Laurent Vivier <lvivier@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250703173248.44995-1-philmd@linaro.org>
 <20250703173248.44995-29-philmd@linaro.org>
 <e8d0edca-f79c-4d6c-b1a3-69ad506bf470@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <e8d0edca-f79c-4d6c-b1a3-69ad506bf470@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/7/25 08:38, Xiaoyao Li wrote:
> On 7/4/2025 1:32 AM, Philippe Mathieu-Daudé wrote:
>> In order to dispatch over AccelOpsClass::handle_interrupt(),
>> we need it always defined, 
> 
> It seems I can only understand it until I see the code to really require 
> it to be mandatory.

See 
https://lore.kernel.org/qemu-devel/acd1d192-f016-48d3-90e1-39d70eac46f5@linaro.org/

> 
> But anyway, the change itself is correct.
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Thanks!

