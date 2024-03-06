Return-Path: <kvm+bounces-11170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73714873D17
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:15:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E6D12826C8
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B7E13D2F5;
	Wed,  6 Mar 2024 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tL0M19P1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42EF8004B
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 17:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709745299; cv=none; b=IU7IXMGNQyBEIiCKP79Z7fo7F86kw9E+pfWtL12GMwt2abXwOLZ1EInCBFlqWsHNjoOawfI31A3va5HJkdai5s9XmxtwZXOS9b5sGnztwUc1ELpb6B3AR1inxohaYE4x/Krd8cUrTRGD0u1kzWvQYj8bBgGSkz39a+XVcsrivwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709745299; c=relaxed/simple;
	bh=mUr75854v2eMC/fVa0K7Sdpa0NTt3zcYo9kTmdwaYzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vf6quOIAqPDLX9PFoINEGBWEe1iox7EYB8xyoafYq6HvsicJvO/ffRKFGXId7Auv51ZIARRvGAbY0Ys/OQW0g9stoLCbg8Z5o2NO3OiFKLU3jQypXvs4x9FOXHfANKUQH/nl7UrCXlhYlTYq9NNuNcqRhKi61rk1QHwbEchhDdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tL0M19P1; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a293f2280c7so2755766b.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 09:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709745296; x=1710350096; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XjsyNthJQ6LEz6SX9rxTBbqUR1TTwhwhwoVKkXhpUAw=;
        b=tL0M19P1k/Ud8mqqQLwXTtdXIke0vRStby+C91rPxTpdxUpmCzzdCRtsTQZgfwsxmp
         vd7ih17JmjdwDeOoLCq2r22cv/kDLKOWyaMEoChannSOHGDd8kh8Hvv2rmBZ9ExNP2y2
         x8bUwHkoow/6eHpvwAIQ/GUOKwrgLH1Dybmrk8OFoii6APVj44Xjr438M8BFL9iquMTO
         8M0vxvv4Oy9Q4Bs1tKtyWXtq0zEqteFyvWfhRmBufj3KKxMtap2GUdvJoiWrtvDWwCSw
         eNJx//YDCXTi7DPyle5EiCDN9Qvx/enVGqq4oN+KV9quwmtGjekWjngKbyv5yiTmviHZ
         sIjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709745296; x=1710350096;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XjsyNthJQ6LEz6SX9rxTBbqUR1TTwhwhwoVKkXhpUAw=;
        b=Z7LFsyNDy0md2r5WIU038kzNjCKcvDa/QaOU2SNFeQpxil3b25PAHXfg9V8g0JOY6O
         dKVN6ImMvBd4Zy4B99xyMAxxDw2cZiOHaO0sYESlqwI6rUjS47o1caaVssJXAIev7JWO
         OTFv7MR/d+6EBQquM40dlbXcyLYziKYtV4/c+a8gdAexppA/NEGyhh6IEpk776t1fHyq
         uoUWuDZKOVXhbyK7jT9Wm49LlDgcFQWVJTVywkfbvf3DuybnVzay8Y5HlXK1UcRUSTgT
         4cGadnsxPaspgb4iho0xA8cF4w6ao5n9vCw0P9wnR7jW8Pilp6XCAHZ6KngbnVYarUSh
         07JA==
X-Forwarded-Encrypted: i=1; AJvYcCVTF4PXcYh99Pv1F8mq4o239sJgmI33g3v2rcC7Y6FfeCYIF1Fu+Ok7uWoE3OjaBCrgxe1hDVfIiJXbg2gtbIOtsvsV
X-Gm-Message-State: AOJu0YyBRy408ENH5jZ/2Kxexy3nL6ee0euXdxPYY516qpsrpYepl2U4
	zfTytKQY05ME+OGckN66pwvYxfjeNPkUQXL/4v7datSYa1Rb4mkm/kayNDBefYg=
X-Google-Smtp-Source: AGHT+IEzDMCAv1jmeGC0ooiGaix7vjr0dWNnW+e2K3+cHwRyHziRS4ipyA3ZMUpeB9SviZ5lAMKGMA==
X-Received: by 2002:a17:906:b154:b0:a45:da1:9375 with SMTP id bt20-20020a170906b15400b00a450da19375mr7102659ejb.30.1709745295992;
        Wed, 06 Mar 2024 09:14:55 -0800 (PST)
Received: from [192.168.69.100] (vau06-h02-176-184-43-100.dsl.sta.abo.bbox.fr. [176.184.43.100])
        by smtp.gmail.com with ESMTPSA id m26-20020a17090607da00b00a441ff174a3sm7372337ejc.90.2024.03.06.09.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 09:14:55 -0800 (PST)
Message-ID: <68c4a4ad-cc49-4917-b1d6-d0f28b611c05@linaro.org>
Date: Wed, 6 Mar 2024 18:14:52 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 v2 10/19] hw/xen: Rename 'ram_memory' global
 variable as 'xen_memory'
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, David Woodhouse
 <dwmw@amazon.co.uk>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
 Anthony Perard <anthony.perard@citrix.com>, kvm@vger.kernel.org,
 Thomas Huth <thuth@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S. Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-11-philmd@linaro.org>
 <84F1C2D8-4963-4815-8079-B44081234D41@infradead.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <84F1C2D8-4963-4815-8079-B44081234D41@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/11/23 16:49, David Woodhouse wrote:
> On 14 November 2023 09:38:06 GMT-05:00, "Philippe Mathieu-Daudé" <philmd@linaro.org> wrote:
>> To avoid a potential global variable shadow in
>> hw/i386/pc_piix.c::pc_init1(), rename Xen's
>> "ram_memory" as "xen_memory".
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
> Well OK, but aren't you going to be coming back later to eliminate global variables which are actually per-VM?
> 
> Or is that the point, because *then* the conflicting name will actually matter?

Eh I wasn't thinking about running 2 Xen VMs in the same QEMU process,
but this is a good test case. I was thinking of running a Xen guest VM
and another TCG VM in the same process.

So IIUC xen_memory should be part of PCMachineState.

> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>

Thanks!


