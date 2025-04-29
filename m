Return-Path: <kvm+bounces-44809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB5BAA11C9
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 18:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDEF64A301B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D187D247284;
	Tue, 29 Apr 2025 16:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cFA5a6n+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E7923BCF2
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945065; cv=none; b=a23f3cW+Rex8roQvXaSQ+m11Wll4NleOw5EdasTfVi9EsdVoNAUom2YIbAjdba2gJxhua901IOAYDaeMYZN0HZ7FiNveCFAeDdBmrzLcySgl/NZdB9nUKxP+Of4KW3kmggCHe8GwSvp2M5Fnya15fQYN3CaQQDDAXbqeTZv8k7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945065; c=relaxed/simple;
	bh=CpjOGooW90Pa/OTILSH7GCCaeGnurzZ20Kl1lj4maKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CY2XsTTcLXc/6Y3/vfAEGPlvb3Z7bD46suMLssfL/j4zGnRTdQH399mf1bhJBvzFNK1RPV2gNjhIXgs6r5jas45ZtvPHELanesGYV5JY8gJSF0T9n5op79Ui09/5QfTphLhbeCKWR6RHmKdHV33KVfW2MAPAJOZyrMx8M7QBmd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cFA5a6n+; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39ee5ac4321so6717993f8f.1
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 09:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745945057; x=1746549857; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Aibllgg3d4RLW0Us/sHqBYj6oK5QHnm+kKAeGEcic0s=;
        b=cFA5a6n+wOZS3uXy2YyU6eaRJYzkEvlkDRyp/PZBit+nd4nTlr7Oi6cU68n5keOZGW
         f3GZ6ZO/HHdOHerrUlla1SpjdIhC4dMe+VV0UQpOVQqH40mMjLf3TQpwKzXyM0nCH9Uf
         GTZu9a+jbix7DSdZhpwFagQhdKTupczB38wG3VySMtpSC8nb7jgsIdza7b1LCPfxymjI
         pZb8NNozpV2VtPIvT9hq+nY9l+raSlV6mIJYRARgh5Rf9nC4ngyYKiXdBykzNRr0uf7a
         2wU73Ex2rJDIAvqZCj6juztXh/FzUwktIjF9ky53KwbH6uAeDmT2Ehn41ZPFy3QVfkNS
         brwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745945057; x=1746549857;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aibllgg3d4RLW0Us/sHqBYj6oK5QHnm+kKAeGEcic0s=;
        b=GvQL7RCtSoY8gX5+aDCMsbHwxLm6IvwSQCYhv+UFcSjA+rQTco6ObUrHP8ziZ5+O/T
         Myyc1lhKnfu6LTNvxqfBHiLH4Q5NYkAox7ubrioqdZ9uzQ0pmmFQb/j94E6p9Ph5lAHz
         T/yGJxL8jLp/xN32TL3uNKmhbNMAOom14Nx/lWxZ3LUeXUPanPmjZrWV0s4o1sDcbtL3
         WeLJDEmNIhnK0+4n9N0qcl0MiuU4VTHns3+lD6zhwKE8v3BCSPNHve4oO9B0pXOGgnru
         jgq1Qxif7a+GD59Z4RJ0D/CypcrjM31lIsO5kTIIg2CC44DEfMZHOgoy54VT8B+xsxI1
         rWew==
X-Forwarded-Encrypted: i=1; AJvYcCX1jEF6kU+NY2u/SvSc9LuJrUx0rTFaiC0dCOwdlcMIgvMQPU+88Vv/dl93pjzltBNAXrc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUKHMflGwrWCc69bR1dR9KbHrIPSjCmMN7XgJfe4/ofuLw88Yp
	auhPlF+lvVmPU9qgeqNQsxeS4uNmX6T5f8SxKQh9tdAQSeA7ssPE6SOZL445SDg=
X-Gm-Gg: ASbGnctA/w5gMqA+DC1RB7Q2rUQO4L1fqg3BcAhm3ZtH998JmWo70Pq0+T8GcqNIFJm
	ZAPX99o4Gc/Atl/yFGuuTLP4aY7BRlxS9pa0d/wK0PNdHIMM6mYde3Zg9O/sF0g0c+1GJOanFvU
	CuDC4ZxIRSdg0c+giX/Np/7Cm2ceQ49GodXoXTZBvGYbE056FxuxR3chRE1ZT9bIROApJznDkNS
	bywAxI3FdxvF4+xp95/LuPoUBP473rE4dkabWscHKfLcsVf3t1NTEHAS9aTPvKg8ht+PIP+WdR/
	d/Zt+tG5FcG/mMgQARh2EHh2pN/Eha/5NqNE5UZgL62TgNOPp7x7IPsVBwne51SMsxf3BR/wvoR
	yDnbmnmdxrf7Ttw==
X-Google-Smtp-Source: AGHT+IGKLPRuRHQYfOOvaw5wEsg1dJ5YMhJgLvy7JkTalCYHw/P2Z3FbT6NazwojEW5+LMxL5COfaw==
X-Received: by 2002:a5d:47c6:0:b0:3a0:8712:f89b with SMTP id ffacd0b85a97d-3a08f76123bmr87938f8f.20.1745945057523;
        Tue, 29 Apr 2025 09:44:17 -0700 (PDT)
Received: from [192.168.69.226] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073cbf04dsm14660667f8f.52.2025.04.29.09.44.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 09:44:17 -0700 (PDT)
Message-ID: <0d279fa6-97bc-4dc1-b594-a8faf33d6485@linaro.org>
Date: Tue, 29 Apr 2025 18:44:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] hw/hyperv: remove duplication compilation units
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org, manos.pitsidianakis@linaro.org,
 richard.henderson@linaro.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
 <81732388-d0f7-4bdf-ac8a-3537276dc284@linaro.org>
 <174378df-525d-41b1-920f-3797ca300e3f@maciej.szmigiero.name>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <174378df-525d-41b1-920f-3797ca300e3f@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29/4/25 18:39, Maciej S. Szmigiero wrote:
> On 25.04.2025 01:30, Pierrick Bouvier wrote:


>>> Pierrick Bouvier (8):
>>>    hw/hyperv/hv-balloon-stub: common compilation unit
>>>    hw/hyperv/hyperv.h: header cleanup
>>>    hw/hyperv/vmbus: common compilation unit
>>>    hw/hyperv/syndbg: common compilation unit
>>>    hw/hyperv/balloon: common balloon compilation units
>>>    hw/hyperv/hyperv_testdev: common compilation unit
>>>    include/system: make functions accessible from common code
>>>    hw/hyperv/hyperv: common compilation unit
>>>
>>>   include/hw/hyperv/hyperv.h |  3 ++-
>>>   include/system/kvm.h       |  8 ++++----
>>>   hw/hyperv/hyperv.c         |  3 ++-
>>>   hw/hyperv/syndbg.c         |  9 ++++++---
>>>   hw/hyperv/vmbus.c          |  2 +-
>>>   hw/hyperv/meson.build      | 11 ++++++-----
>>>   6 files changed, 21 insertions(+), 15 deletions(-)
>>>
>>
>> @Maciej, this is now ready to be tested :)
> 
> Tested this patch set on a Windows VM with hv-balloon QEMU device
> (which uses VMBus, which in turn uses basic Hyper-V host support).
> 
> No problems encountered, so:
> Tested-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Thank you!

Series queued.

