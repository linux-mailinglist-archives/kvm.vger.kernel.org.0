Return-Path: <kvm+bounces-11374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BACE98768A1
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:36:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76621283A35
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 16:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E8CCA7D;
	Fri,  8 Mar 2024 16:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G/C/jfsA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788C336D
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 16:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709915805; cv=none; b=tGzQUjVp5e2TrR6ZNjVnSK66/tRDyaqrnRIHtTgQhvsrOuoaNa6hxyjgt9mHMGvlaNasFLurBArqKFIbKO2cs6yirZgA8IUjxSNidG5FqNPL+OcJ/WTizVJFJML3V38q6LIrTQotQecl80J3v41AKPp/ypKvrSk6LGDRZ7H16N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709915805; c=relaxed/simple;
	bh=ywXHNPt2WafPXHYgxl5TS/GcRmGFOh53LxwTN0fsK8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qqIZc5pP9R/GlzQsudKQf0zm+ENa95z0j+42zEGQRWDUN0tHFuH4l1q2SiMfHCLxMifDF08qkJtutsTpr3Ri90N+UrkKnnBztF7HcHpwWRcSDzDZ4i3/SjBCCzsNzWNstP+EOMdS25hEHa+i8ADPtGjRZUDBKOxq/zd1eg8uIS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G/C/jfsA; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d21cdbc85bso28077741fa.2
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 08:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709915801; x=1710520601; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9kxjdR3vDvQpz/Ip9aq8t0PMrvrtVnYJozoO1Wh7/Qc=;
        b=G/C/jfsAevIYx+bv9is01b79V9SnK+YmZhAbvNiP6+WjwLumGe+sAJeW+4D+ai5T8h
         Nk4Kuv3I5VjLDGcK0F/zkKY8XKPM+tywoU0uRuj12EvRiW13QQJ1MjfXS+fQdpTjjcvj
         rqu/Tx+gt+/Tg8OtgFJRnGoHE6b9BElzuxZakVW2UPBk2spfXXUcCLumc9jsgIRjt2Vw
         fmjRmvrlmSHBt2lAxkmr2rInHW7qlA+xdr6Ws4YzSDimioe2TR21ocfGtAnMKURARkHy
         qSofD8GgHkqtn53V+/TvtDhDEepf3TAUOIX3+xb4YgJrUe6AB/QCRw6hTC742jVdU72v
         x00A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709915801; x=1710520601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kxjdR3vDvQpz/Ip9aq8t0PMrvrtVnYJozoO1Wh7/Qc=;
        b=tfx/c1CyDIV6HkKW9rUK1cfisBxQlVWXbsYOyL72dbLM7j289lFvAtVIx+ACTyzxHt
         kBHVxKY9aYXnm8JZkJNzzLzX0hrPZ1pccKL3TEv5gPQeMZ42m90T2yU4soKb1Nx2NLZ+
         wnbByM3+zaGPl0IAdJE2awB52BazEG+Nrwm/Wdwc3fcdrxBWc0NjJ8XTkesUnXDkQw3M
         Ne5twSPeqSmNLJR/KMvgHW6DHtR+bYOXTA8DE1Y/fDr5CbmXKiIy0cmWHIPPMbIatX+i
         G5btGDggerpUeP75cwKzhChTneS/17Q/3o1oK7SGFKiAFtIJW+rlK+rgFhLw5zbJRYYu
         yRaA==
X-Forwarded-Encrypted: i=1; AJvYcCW1pFmoObU0JYCHwG6GDgpCMAW2z3b+vdfzH/NZBkdQwOQyIzYE1zsxrhAzDDT6S4BAjL3DznM+Q/BnYwMd9+z9/dE0
X-Gm-Message-State: AOJu0YxIA/Vu9o5KDQyPk/9wtdl0ooxo/TOU16Aw8A1GozfVAXjlOW1U
	bqd5ObvSE6Gm+rO4F4mqeAxZ5hL2QzBzo25/xqEhhbKu/YUgKDUdrZ1jweipgM0=
X-Google-Smtp-Source: AGHT+IEnDDdRzw+0WCAVFDAwMmQG+okbkjKuymonjjKaw1bTTp+uHBxxsuWDU3q+JUa4jsjl+CpT6w==
X-Received: by 2002:a2e:3e15:0:b0:2d2:73d1:d259 with SMTP id l21-20020a2e3e15000000b002d273d1d259mr3176513lja.23.1709915801587;
        Fri, 08 Mar 2024 08:36:41 -0800 (PST)
Received: from [192.168.69.100] (cvl92-h01-176-184-49-62.dsl.sta.abo.bbox.fr. [176.184.49.62])
        by smtp.gmail.com with ESMTPSA id r19-20020a05600c35d300b0041316e91c99sm3000008wmq.1.2024.03.08.08.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Mar 2024 08:36:40 -0800 (PST)
Message-ID: <17444096-9602-43e1-9042-2a7ce02b5e79@linaro.org>
Date: Fri, 8 Mar 2024 17:36:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/21] Introduce smp.modules for x86 in QEMU
Content-Language: en-US
To: Zhao Liu <zhao1.liu@linux.intel.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Zhenyu Wang <zhenyu.z.wang@intel.com>,
 Zhuocheng Ding <zhuocheng.ding@intel.com>, Babu Moger <babu.moger@amd.com>,
 Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240227103231.1556302-1-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27/2/24 11:32, Zhao Liu wrote:

> ---
> Zhao Liu (20):
>    hw/core/machine: Introduce the module as a CPU topology level
>    hw/core/machine: Support modules in -smp
>    hw/core: Introduce module-id as the topology subindex
>    hw/core: Support module-id in numa configuration

Patches 1-4 queued, thanks!

