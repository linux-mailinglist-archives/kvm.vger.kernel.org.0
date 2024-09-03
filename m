Return-Path: <kvm+bounces-25742-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE4C3969F76
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:54:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 94496B23EEA
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 13:54:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFBAA1CFA9;
	Tue,  3 Sep 2024 13:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GG8loTNV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0D77462
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 13:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371637; cv=none; b=i1BddSHogalX3PysLDm0zyUkbyZhOLRo8wNFu7AsXnca2d5rDuSgOUYMd1P3FW4HJ9Aj42nlen5n2yrL/gs5mnG2cEelZ7xTXoDIbqFzAUo82ydZYxpCpmqALYhyRkqCI3ks92kF9XHj7+P2eIA3Gm6KUSzzRJnL+BB/I9uDuok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371637; c=relaxed/simple;
	bh=TND3D06whl7dBZdpnrkZD4ptAQD1PmZ89KpJBB+Pu3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hfln2ttLEOFGSkKR0A01ScCHUIxoTk+D24694jib96KFOKSJGnwFWe6AqgOUkDZ7tDXgWgkS77u0k9MlLmCJdbtZtHcpzIvKxmrRrHhBPAI65k5pyAgzKT+VTmOSIYHGfnHc4dIhHvTD1UarZcukoR2MSNkPqD176HArTwNInkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GG8loTNV; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42bb72a5e0bso47373765e9.1
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 06:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725371634; x=1725976434; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AbJKNCwW/XpaAMYQoJPQUSxctQzqjFRdpARUfLirEpY=;
        b=GG8loTNV3tVkKEV+XkByQ8WySngutPEcsiwRtHpruExV77VkgfdBDcdrIdqm1nIYQm
         EL/4BiinNTq/aUYIqvS+vu+BQ2jskz/fa7gwrOej6/vj+jxVYVWuD9FrB56xtpQQQp8Z
         NyIFpmAz+7pICXbF/Njs8Hqufwl2ZdoYxlKi55ZdzgQL2oM8M5budlXTdTdHK7/kSDqN
         87W5EPr8X+qWqAxxghG0gZMxRLXwGDgepb1GuAlOrDUMedudxDtH+t50nWbL4c4dx7rw
         Y5vSFy30+S8Q4NXNnamtHiunJSerw/VC2xGSW2TFFrTtxFks4rLHJF2yyn2Kof7YkAsY
         LRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725371634; x=1725976434;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AbJKNCwW/XpaAMYQoJPQUSxctQzqjFRdpARUfLirEpY=;
        b=eYybARtzFzPajX0lGzdLglTTHXFTxdoQFeIZLVHLYVF6/Or8m+8C3IBLuM6F8pzxEj
         oYEDi3kL0mGv25aICJQGq2uATuyViyDa8H4xhDJpwlqhVFSbP2AGYZ8N8rko4iaLruLj
         6prRlPiYjriaHBbGRt+GN2aMm3BXwjOUg310Hb52g48flgBguZr0F+nWapUfqGO20Ozx
         KrzxfQtt1b9E/VyH5deGokXxdzIuO5hmo2w+QcRQyFPKv/VTQMYEDzD/8ASqgIb03A7+
         zuBDuLW3Vf0PG/qCuG/Zpl91xDVEvmkU0hF2u6BZ4crrytyte+CvWu+Za5qWTj3810Oh
         PMXQ==
X-Gm-Message-State: AOJu0YxtXo0xIfrrWdPkjGJWC5zsZW0MzrvxY7sd2DFN8HL7bh2EW0sF
	xrpTFKFxctxmrRzn5mX4ijQzbJYPys/cMZsOnUqMLhCuz5lTvq2G7Eund3PjHrM=
X-Google-Smtp-Source: AGHT+IEUYoaZvJnfZeEq74yOlruRr1tUBL9ks7J5HN7w7+TgPUK1V2KlMyFoulnkYZpepftzW7ipow==
X-Received: by 2002:a05:600c:a4c:b0:426:5dc8:6a63 with SMTP id 5b1f17b1804b1-42bb01e6ca3mr102390735e9.30.1725371634275;
        Tue, 03 Sep 2024 06:53:54 -0700 (PDT)
Received: from [192.168.1.67] ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42b9e7b7f87sm179620455e9.1.2024.09.03.06.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2024 06:53:53 -0700 (PDT)
Message-ID: <7a061449-3bbf-4cc5-a9db-ecc1f01af784@linaro.org>
Date: Tue, 3 Sep 2024 15:53:53 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kvm/i386: make kvm_filter_msr() and related
 definitions private to kvm module
To: Ani Sinha <anisinha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20240903134441.40549-1-anisinha@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240903134441.40549-1-anisinha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/9/24 15:44, Ani Sinha wrote:
> kvm_filer_msr() is only used from i386 kvm module. Make it static so that its
> easy for developers to understand that its not used anywhere else.
> Same for QEMURDMSRHandler, QEMUWRMSRHandler and KVMMSRHandlers defintions.

"definitions".

> 
> CC: philmd@linaro.org
> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> ---
>   target/i386/kvm/kvm.c      | 12 +++++++++++-
>   target/i386/kvm/kvm_i386.h | 11 -----------
>   2 files changed, 11 insertions(+), 12 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


