Return-Path: <kvm+bounces-14224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D813C8A0A94
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 09:52:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 935D2283EA1
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 07:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA09713FD67;
	Thu, 11 Apr 2024 07:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Brid/Efv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36C913E898
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 07:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712821924; cv=none; b=eThSBN+axHuqWWIgPWSybCbZ7KSPbGeolJneWdC8fS00CaXHTEFQrdqhK1UBU5T/e+21YDyTmHTBMkjZQVzjv0Uv8BkTNAPwIdmybXCEJXcFKYnIksYTSp57cNRxkh4JsThMD3AhMstM5t5ggcv7PIV7NLCivOeSGV1mGc3bZWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712821924; c=relaxed/simple;
	bh=uDspxJbGbVmTpe5ehFGnNxMLeJRhwfjuSWIncvjIfB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PgQqN2R1bpR0xNucubmhJ8Q/cavf2cu8KQceoWOen/KRy+um4q3YFIcmnKXMnfMF88387To5YxySERhruRk7KpnFdH/OC+xKGcjrfBwjzHVPMXkIg6wotidpZtdnrWfKJOX+JBpiOiEHMTC7zq+0d7SQVxCMB/eEi/gxThoC/HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Brid/Efv; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-416c4767ae6so10528615e9.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 00:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712821920; x=1713426720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sqJVN8B7lUiTu5YOxrrZVz9WRBkVSsIVZdER6/FdIc8=;
        b=Brid/EfvA+v/wztQziSVyQPTtcRsXEWcdr5N5O4BRBVrxoMiLp1PM3NFTBcGiM8KvV
         hZXyj/7Ox8Ce1NT0U/rRzVZ4J5hk8uqmTTfNdqfJFNALYLcQOoiWQnsdKTS2a8q1JuTx
         hTrf5nRn7ZBe0X6muyn//WGTEe1VMFz/GVdJN68cNr/Kp2N0II9Qjagp0kZm60E9NnBn
         zfvsvloT3aBkVVyw4VRtYipxwSVSuZXZwA5O5o1J0XM7LuuEL86EoNYZARObUuc+6UI+
         sZUYqXxFxV7puBMCBKo00wjq6uTnFOqmNl92Tisqi/in0XrDCuKBwkqiUL71FoOOzYU8
         1gHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712821920; x=1713426720;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sqJVN8B7lUiTu5YOxrrZVz9WRBkVSsIVZdER6/FdIc8=;
        b=cTqzGMAj4iHylndhAQBOxWeNGLTdXy9spjyDF+6QPmNIvp0Pjeo4sGU3XYRvZb8tp9
         x9RDzqq3+iReEkr+hVBwSHVuXkDnZdQdE6+mmyiWExZYMxrh5w/fMbAZyIc0IEhiF9B4
         1JN9uMworG1aQttBpuubggXGSuyRethyv3O4xRHHhNPA3gYB/Z6az9lyV/wCtcPfiZly
         biwzGLJ+xklmaMxFnYZxI3vk4EFtuMHTfe2mV377vLoTjMa5oG3rbu1eQhPDzgQ0cm4u
         nxbQ4KTln2vzKB7vNAOJgdxgz9eHugskcl6jl5mAnt7DiSuZhwt1GRpqUv1vU518DcAS
         598g==
X-Forwarded-Encrypted: i=1; AJvYcCXvLQahsXLbpmH1d3x9dmBqyvSyUrnM1NNxmjOlv0H11GgfYKznQU6sgIv8n/wQ89eelR2084cQ1L4mVY1h87z+0HST
X-Gm-Message-State: AOJu0YxUn6wIufo58KPm/Cb2aa+hEK/APxV3pa5m/Qzo0ouRS+hwoZ3o
	zDd5NZuCIvHeMcO6TWTP62/UaXO8UXlq3KmN/LyscK64Nt5RdaeW6NWnND8zJso=
X-Google-Smtp-Source: AGHT+IFf17+MMypJznF+85hUqLciVFTr5scwjdz1ej9n/0Tx2DQ/HP1qnZRk3j7qU/Ga6Oj2mOsMsA==
X-Received: by 2002:a05:600c:1911:b0:416:5d63:e651 with SMTP id j17-20020a05600c191100b004165d63e651mr3285028wmq.37.1712821920164;
        Thu, 11 Apr 2024 00:52:00 -0700 (PDT)
Received: from ?IPV6:2a10:bac0:b000:7318:7285:c2ff:fedd:7e3a? ([2a10:bac0:b000:7318:7285:c2ff:fedd:7e3a])
        by smtp.gmail.com with ESMTPSA id l23-20020a05600c1d1700b004163ee3922csm4709253wms.38.2024.04.11.00.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 00:51:59 -0700 (PDT)
Message-ID: <8263d92e-4496-4085-aef5-41c94dc39c52@suse.com>
Date: Thu, 11 Apr 2024 10:51:58 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
To: Alexandre Chartre <alexandre.chartre@oracle.com>, x86@kernel.org,
 kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
 pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
 konrad.wilk@oracle.com, peterz@infradead.org, gregkh@linuxfoundation.org,
 seanjc@google.com, andrew.cooper3@citrix.com, dave.hansen@linux.intel.com,
 kpsingh@kernel.org, longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <20240411072445.522731-1-alexandre.chartre@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11.04.24 г. 10:24 ч., Alexandre Chartre wrote:
> When a system is not affected by the BHI bug then KVM should
> configure guests with BHI_NO to ensure they won't enable any
> BHI mitigation.
> 
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> ---
>   arch/x86/kvm/x86.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 984ea2089efc..f43d3c15a6b7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1678,6 +1678,9 @@ static u64 kvm_get_arch_capabilities(void)
>   	if (!boot_cpu_has_bug(X86_BUG_GDS) || gds_ucode_mitigated())
>   		data |= ARCH_CAP_GDS_NO;
>   
> +	if (!boot_cpu_has_bug(X86_BUG_BHI))
> +		data |= ARCH_CAP_BHI_NO;
> +
>   	return data;
>   }
>   

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

