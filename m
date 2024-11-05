Return-Path: <kvm+bounces-30710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B705C9BC9A8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:55:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47A181F22BE6
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E32C61D150C;
	Tue,  5 Nov 2024 09:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KlFNyvb2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FAF1367
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 09:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730800509; cv=none; b=T4AUng6AzPcjQEXavMRijUtVng+/FHQMZsKyheHeq02NwAhgJ8fUXjFtx69OnhdSJ2TcHAxtUyp3bDWwvZ5VNZAbFB6XizhVIc7Id/Z5ZtA4Mq/LUJF97VKOUU1v+tM0ZGhzf80gLWE1juzzmqn9mZHmDMj0w+UlTDlsPsOKnmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730800509; c=relaxed/simple;
	bh=wPrZG7Z9PHiRsM1LbgP4kdxYbYVMFfj9trOU4/Sp7tU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YS+8dq/em5QeM8s2O6q9lly2CyLXJ5b9KSpOzZeNCXqvr+Mnq4xKi5jKQ5h7NBWIyRXvDv47DVQgSVZf67GYt6xKn3hBGBITrd0Jp6KJBNjevNibMVLRt71S8EY2Qpb5m0TZ5UjGH/0aKZ/G37Zcstp8l6Ymyp7haX0jPtcSUT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KlFNyvb2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730800506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UMnqGPsLhzGV3tgVD4vrw9ZCnrqJY7nkw/coAWDxYBU=;
	b=KlFNyvb2rlsi5SlXExePAqDhQuo+sJne2orU1wFo0/+82f5wWcc+IwQ/A6yk1u9y0pjLf2
	2xhPqKJ09+/vGloOvzCfZ0KBqIJNc/C6HWVEz6xDyq60+u8l6dXYWywVubFHtM4q+lJZ1B
	LLeLACXxwmG7UgiNsXrusaFVpT3+fvQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-zWb_nl9NOi-qQsjMIl7PsQ-1; Tue, 05 Nov 2024 04:55:05 -0500
X-MC-Unique: zWb_nl9NOi-qQsjMIl7PsQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43157cff1d1so38764165e9.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 01:55:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730800504; x=1731405304;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UMnqGPsLhzGV3tgVD4vrw9ZCnrqJY7nkw/coAWDxYBU=;
        b=tSWn5bePOLCgVOqg2SUxRQxCtD5x9ChvSZRulIS78vMiMbKc2qg7lsjdhqIODG67yb
         aYRBfIBBf3jwa+KlkT5av2B5X2Ittw2di8S7TbKdTXAL9BcfbxxPsNVXti/tPbVA56HJ
         Dycvzgt+WrGdIqYjGdH9jtYa2u4R7uXpeWMlj8tLuJyRCMNm029LfmZPlAv9fqUwyOw/
         WHObbuioCdrgpbyDXMNodN9Lyyw6cP9CDtErvQbHAVRn7TWIStsHL8aHm27vRWsEkOUh
         JhW3CvARzgQBN+n6PxdGW3GBFhiL6lMYGoGL63gZXrd5Y7TH4iDzY/2cnzVh0eOmXHvX
         /EAQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1+D4+9TWHEVnqWaahPQz4hmTmkIVz4o3sHYrNYR0GB7Kxvqmh11Tgh8ooxwO/PnTKbJo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzke/r04yLrSXxk2gCjYGzwlnGUjUD1KBmGbiVx1WtfxSPpc78M
	8HWg3u6sU0tEQSTde83HFYXQ+pnQDHMqacHzYDu3YhYgdKU42DjtgzjiytlTt/XwYiaZW98+8zb
	5HpBiKmAdLxF9GHgEeOVzS7osre8U/EjR8Y/EppUq+Is2IlpQWA==
X-Received: by 2002:a05:600c:45d1:b0:42c:b220:4778 with SMTP id 5b1f17b1804b1-4327b821a22mr158161475e9.33.1730800503783;
        Tue, 05 Nov 2024 01:55:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgqZFAj5cEWzunmN2i2lkUEud/B8H9xs4ZPFK/2z7oRNWRWjBDLSYk9rN11tAiGxKN6zWUOw==
X-Received: by 2002:a05:600c:45d1:b0:42c:b220:4778 with SMTP id 5b1f17b1804b1-4327b821a22mr158161165e9.33.1730800503384;
        Tue, 05 Nov 2024 01:55:03 -0800 (PST)
Received: from [192.168.10.3] ([151.49.226.83])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-431bd947c0esm220011165e9.24.2024.11.05.01.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 01:55:02 -0800 (PST)
Message-ID: <8cd78103-5f49-4cbd-814d-a03a82a59231@redhat.com>
Date: Tue, 5 Nov 2024 10:55:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 45/60] i386/tdx: Don't get/put guest state for TDX VMs
To: Xiaoyao Li <xiaoyao.li@intel.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-46-xiaoyao.li@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241105062408.3533704-46-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/24 07:23, Xiaoyao Li wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Don't get/put state of TDX VMs since accessing/mutating guest state of
> production TDs is not supported.
> 
> Note, it will be allowed for a debug TD. Corresponding support will be
> introduced when debug TD support is implemented in the future.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>

This should be unnecessary now that QEMU has 
kvm_mark_guest_state_protected().

Paolo

> ---
>   target/i386/kvm/kvm.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index c39e879a77e9..e47aa32233e6 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5254,6 +5254,11 @@ int kvm_arch_put_registers(CPUState *cpu, int level, Error **errp)
>   
>       assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
>   
> +    /* TODO: Allow accessing guest state for debug TDs. */
> +    if (is_tdx_vm()) {
> +        return 0;
> +    }
> +
>       /*
>        * Put MSR_IA32_FEATURE_CONTROL first, this ensures the VM gets out of VMX
>        * root operation upon vCPU reset. kvm_put_msr_feature_control() should also
> @@ -5368,6 +5373,12 @@ int kvm_arch_get_registers(CPUState *cs, Error **errp)
>           error_setg_errno(errp, -ret, "Failed to get MP state");
>           goto out;
>       }
> +
> +    /* TODO: Allow accessing guest state for debug TDs. */
> +    if (is_tdx_vm()) {
> +        return 0;
> +    }
> +
>       ret = kvm_getput_regs(cpu, 0);
>       if (ret < 0) {
>           error_setg_errno(errp, -ret, "Failed to get general purpose registers");


