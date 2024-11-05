Return-Path: <kvm+bounces-30712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7B9B9BC9E7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 11:06:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94DAB283F1B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 10:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F7271D1738;
	Tue,  5 Nov 2024 10:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cVQt8vKf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848163C6BA
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 10:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801196; cv=none; b=eaYfTqfc/GJd2aM23DReRPO8K6/cWhcfL7U9/YWgW7VxTSJNBrDyJ7Z7ax6nQbWdL7Kw+2eLqIZxH/yMQ0eIVJWMR0Agpub33p3eNtIe2pfsv7fHHSkuT8I7FJ4T3G45syZS9FbBWQE22dZOvmxtg25b3Z2HLrMAl0r5tXbkXR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801196; c=relaxed/simple;
	bh=SNC9ZcP0f78d1GeDNtaCGV2ARMz/CCfcinjf+HYAlXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=stvKb6hvToOTEHFoK21jXE2Xx5svcANvkqM4D6XbT9pPNca/e2bSH7UFVZGzLsWrgLkQHo9fma93QXlkcVwXji4wTeHB6FB1tLrCpa62JkqN6Al80lNCn3lBibKLRfuUZWgZS4yNCeP5VHGxvs0/y6ENOqPAjvP4N7T5L2Dthco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cVQt8vKf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730801193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XZPvhcuJHfCOWq+j9Md42ETSyHpdcPFaThVvV/LbXzE=;
	b=cVQt8vKfqVpZ55333je5ZjapmStSZqTGTdmC7yDB5OBK3blKYsbQkklFC4Ux/n2piTYRFQ
	8Sbg+slepY6x+Smazuy+61evsXEMHBSe39DaXs1ZrTd+a5AXaBLkr5j2wkVxB+/VIWsuYY
	R17ouFoCaQpvitSW8dxruIKXAApgYTk=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-AxwuYQCiP9-qkAytyGtRUA-1; Tue, 05 Nov 2024 05:06:32 -0500
X-MC-Unique: AxwuYQCiP9-qkAytyGtRUA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-539f7abe2e6so3670156e87.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 02:06:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730801190; x=1731405990;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XZPvhcuJHfCOWq+j9Md42ETSyHpdcPFaThVvV/LbXzE=;
        b=X1GVJUtw7eTzncwv9bP1zlk86eumuncwT9Qc+hdneNAdfaKplYR//JI8uaXaAzXWEY
         ap/z5eEp9wqQtxOQC+K8zx2FyhYnpG+zff9EwkLP4RjnEBqQt2ZUaIZye03J4DhtkX5v
         RTZRHzcmsG1sid66eMd/pMCa6IicBzjJ5WIx6OChwB5gQPjeW9jsLH4qG9mESBLEeKNv
         bDy+0Esd8QDhpOw/GFvZyRmJfDizxXmjaQ5be4UbAxGeSjyiDlxu+SwLvj2TIrqH/LsK
         qsSTxk0nnVXcm5QxLjB7dAAj/vdjuRUQ1IcCDWKHsA5hn3eXXNbcPZ8owuyLDUKPjJp4
         SdRw==
X-Forwarded-Encrypted: i=1; AJvYcCV7OXY4xqTKEgiwkpHPEaheNR87riwvbCDp0LWcWv5luIvdhZD1xIsfeOOkXROyTmykntg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzloJiLfy2R5ReR3kengzeuDSY2obDz86Rw81NEn5iAAC6mJ84y
	HwXtOpVxTIgU6UKYU2tm6BFG7wsL0eeFOr8V7jen8Cq1Nvxkz035vHkkmpa27MREZJ2eFwRkZ2C
	0zf3ngbZX9z7+i1TvVs3R1bbg4rz304xXUqC7ER0hLNqk6x9Oiw==
X-Received: by 2002:a05:6512:1597:b0:536:54d6:e6d6 with SMTP id 2adb3069b0e04-53b7ecdece7mr11504255e87.17.1730801190535;
        Tue, 05 Nov 2024 02:06:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbBOWcZ9md7aDTKXWzaypt+PdgsAprKXQDHggukLZ6pVucb+I6yIyWVUgVdzGCVkOZl/i70A==
X-Received: by 2002:a05:6512:1597:b0:536:54d6:e6d6 with SMTP id 2adb3069b0e04-53b7ecdece7mr11504222e87.17.1730801190046;
        Tue, 05 Nov 2024 02:06:30 -0800 (PST)
Received: from [192.168.10.3] ([151.49.226.83])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4327d5c65b8sm180496055e9.18.2024.11.05.02.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 02:06:29 -0800 (PST)
Message-ID: <82b74218-f790-4300-ab3b-9c41de1f96b8@redhat.com>
Date: Tue, 5 Nov 2024 11:06:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 34/60] i386/tdx: implement tdx_cpu_realizefn()
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
 <20241105062408.3533704-35-xiaoyao.li@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241105062408.3533704-35-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/24 07:23, Xiaoyao Li wrote:
> +static void tdx_cpu_realizefn(X86ConfidentialGuest *cg, CPUState *cs,
> +                              Error **errp)
> +{
> +    X86CPU *cpu = X86_CPU(cs);
> +    uint32_t host_phys_bits = host_cpu_phys_bits();
> +
> +    if (!cpu->phys_bits) {
> +        cpu->phys_bits = host_phys_bits;
> +    } else if (cpu->phys_bits != host_phys_bits) {
> +        error_setg(errp, "TDX only supports host physical bits (%u)",
> +                   host_phys_bits);
> +    }
> +}

This should be already handled by host_cpu_realizefn(), which is reached 
via cpu_exec_realizefn().

Why is it needed earlier, but not as early as instance_init?  If 
absolutely needed I would do the assignment in patch 33, but I don't 
understand why it's necessary.

Either way, the check should be in tdx_check_features.

Paolo

>   static int tdx_validate_attributes(TdxGuest *tdx, Error **errp)
>   {
>       if ((tdx->attributes & ~tdx_caps->supported_attrs)) {
> @@ -733,4 +749,5 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
>       klass->kvm_init = tdx_kvm_init;
>       x86_klass->kvm_type = tdx_kvm_type;
>       x86_klass->cpu_instance_init = tdx_cpu_instance_init;
> +    x86_klass->cpu_realizefn = tdx_cpu_realizefn;
>   }


