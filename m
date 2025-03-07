Return-Path: <kvm+bounces-40433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DCCB1A57362
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A4CD1778E6
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B032571A1;
	Fri,  7 Mar 2025 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JnIW4UkA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42BD187346
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741381935; cv=none; b=GCEvoyrMznIYT5rVWMcSv9BLdvwHbkZZhsXJmej7TreeSr4oHFp9TXsEhYBDKrEL9+i5L02gJx/9y7XJraj2zZFnf+X+dppa2DJGjJp4+CAaCpEoQ0BUDaFaVxr8xSTPUF0H6pHE4r333sDmhPN9U67mzT3rvs6bH/uQHZMN48I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741381935; c=relaxed/simple;
	bh=sQWNAB2iw5kTLaHZ8V3vpevUpfJJGo/WthIZ7bg0uuw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZrKO/EyDocV28zSolCm/gVVTFaZT1RlofNPx99nEeZYvaWOneOFpYG+jrxPYDBEDKeP5eAIniffRmz9h17OajLCowToOTlhzfbA5SJiGIVToMH56itcAHXXWttjM61Cq7HbDS5ui1JnFbkXqODCthfMCWIvRJRNM3jZv1dhJv3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JnIW4UkA; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43bcc04d4fcso14251645e9.2
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 13:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741381932; x=1741986732; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l64+I2Ef5txlgYNJJZ7ulgkakQ+zvNIWx2E9yaYadXc=;
        b=JnIW4UkA4GENtrI2nWTO7VqTmQoil+T9EbEDPHScuH5yaqfJkoBpnBOoO9Ba4hKUhm
         dQnwOF/OM4ddKz2DG7iJrHTvlPAnGZub3ngDS6OUJ/MT7R+d9LChQpWnvZZem42xztNN
         7/iMx03TUIQswPUZxQISrXpmR6medGkTRWkUwYdfpgQNe4b/TLU/DCHJB+BW2PMjHIne
         Wk22hhw8icLDdpmjbQcWV54fZIf01DGopt3Jw+XJZvipsOrZQXe3x8AwsN1AM8IlrxE9
         o7xXXUhxTuCPwFv/aJWtcBNUin93xcsMGgW9ysVDnwPsySJt/tg3Ur2a+KuUVNIezwDC
         YHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741381932; x=1741986732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l64+I2Ef5txlgYNJJZ7ulgkakQ+zvNIWx2E9yaYadXc=;
        b=qwaW0EQnCGT+OAGiXLUnhIgIzudLG6uhhQrap6rwz89E+XJJyKMqL8mHWG8eQ5dSdC
         Ae2kFsdM4saBo6pbLFs6JUsJun5MMcJHoxKBkj2DfYTOjs0GtTGfsdGORWPOAOBDCXkT
         8myQTJiedH4hAeIFUZ5V1jzKj2wWju1FloaVklrXRJk6ieWq4oG/N5bUaSzaxCoqG70L
         YM6wMqzywIpoGZJxvBjEGNDvunLNPTAxeWeMAN+9Ba+OdAyJqnRVF3naEH/OzcvUAaYt
         30OsU26dsIWx0XQ7UPz9pwAsa9kVSp9HX074W3gZbZm1EJPwUAw/rRZ4JrHGJnvfR9JU
         TK3w==
X-Forwarded-Encrypted: i=1; AJvYcCU/yc3VJq40u9pVFOD9ccylNZgrESKKUqJVacNdDQzhOUFAW1hIRQS5WpUk+RagHnyDFSg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC/fVrev7UtRYSYoxAfDk9E0UiD/+oYjv3L6qiQpxReZY9wSzu
	3eQuYvZZxBu5Hrf1k445aGR2jXAryVv3/sbYfTqArTfGDMI5a5PJ9SPbHeT+xLQ=
X-Gm-Gg: ASbGncsnSu2X8Sfi6Tk37gPcZMUJgInE02uC09Qe2V+PBfBR6wjuiBx+vzz5dEOQ+5n
	EJ6EN7QK0ZOmPUPktUlZOU3cow0wAVKOMaeS/RV0cJDfkSmgaaT7C+Vv1jTaPC6aMKcvVEjr0Yc
	59RBMd0cuHrGGhhiH5AtW4Zonq7QqfEHGPcwm+aKIpEalKVlPOe7t8wVkUkXuAoxq+AwLXSlbSG
	RIsYzPRsxc9EcvmlArVB09GFWgbdRdNcslaShPV9W6IuWllxFp+CoSDHDhMllBEGebwd3i3rVbV
	jgNaxiBaKIoh1k+pv6Wm1o1cFZKCcvoVJekMt3aw5ED0LwTTUfmbZyLQAjkhGl9vGz9um6KQSOc
	Vf6R+cUYsNdw9
X-Google-Smtp-Source: AGHT+IGMHinE/FosS8DiGLzc8NSoY80Ag05j+jkWNdrl93TrEoYsCnm/CTh9yxyf5sjzV/B5gSbRjA==
X-Received: by 2002:a05:600c:1ca5:b0:439:9b3f:2de1 with SMTP id 5b1f17b1804b1-43c601e129fmr35212005e9.15.1741381931945;
        Fri, 07 Mar 2025 13:12:11 -0800 (PST)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd435c6f4sm91146665e9.34.2025.03.07.13.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 13:12:11 -0800 (PST)
Message-ID: <083ec6f1-dac6-4ef1-8c4a-5d8c399154c3@linaro.org>
Date: Fri, 7 Mar 2025 22:12:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/14] system: Declare qemu_[min/max]rampagesize() in
 'system/hostmem.h'
To: qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, qemu-ppc@nongnu.org,
 Thomas Huth <thuth@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Zhenzhong Duan <zhenzhong.duan@intel.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Auger <eric.auger@redhat.com>, qemu-s390x@nongnu.org,
 Jason Herne <jjherne@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20250307180337.14811-1-philmd@linaro.org>
 <20250307180337.14811-7-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250307180337.14811-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 19:03, Philippe Mathieu-Daudé wrote:
> Both qemu_minrampagesize() and qemu_maxrampagesize() are
> related to host memory backends. Move their prototype
> declaration to "system/hostmem.h".

   qemu_minrampagesize()
      -> find_min_backend_pagesize()
          -> object_dynamic_cast(obj, TYPE_MEMORY_BACKEND)


   qemu_maxrampagesize()
      -> find_max_backend_pagesize()
         -> object_dynamic_cast(obj, TYPE_MEMORY_BACKEND)

Having:

include/system/hostmem.h:23:#define TYPE_MEMORY_BACKEND "memory-backend"


> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/exec/ram_addr.h    | 3 ---
>   include/system/hostmem.h   | 3 +++
>   hw/ppc/spapr_caps.c        | 1 +
>   hw/s390x/s390-virtio-ccw.c | 1 +
>   hw/vfio/spapr.c            | 1 +
>   5 files changed, 6 insertions(+), 3 deletions(-)


