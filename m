Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDB23C1770
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 18:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhGHQyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 12:54:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhGHQyK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 12:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625763088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SYpoSLky/52YWrPuCvWYEFOuiX2LDrIjQnGVL8zOqkg=;
        b=D/aIfJY+ZwISguOkhIojquensr6wszX5I6rk1it0YUnhLI3agPO3H5d081pRohcdcjMmtj
        B+LmtxQWcu6wmaZxmBlcEFMDN0ykPsumSHs+udbXLHvi/Y5KLO6FsEQJTvSZbBpOF53XX7
        0kT3rwvpTlhbBoKUV4TZ23Gp8V+EaYo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-qQehz41XNW2WfBh2xuoGtw-1; Thu, 08 Jul 2021 12:51:27 -0400
X-MC-Unique: qQehz41XNW2WfBh2xuoGtw-1
Received: by mail-ed1-f72.google.com with SMTP id o8-20020aa7dd480000b02903954c05c938so3648611edw.3
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 09:51:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SYpoSLky/52YWrPuCvWYEFOuiX2LDrIjQnGVL8zOqkg=;
        b=DJzLMulwnvb3EIWf4Ls8XT+lF785CNzIpvD9KkSkzkn2zyc19Ip4Aoc1jO6WWkvreN
         O2oZ2LMWd+u+ha4rD1KteytmPb0j8YkjXQa/dbgV+PpNzkHFpy2/IlnJEJxhEWejSLEe
         W1JFWRopdnbWDIeaRJP4daZo2cypcNcI1CHNb1YuKvthraW8nEE36Mj1BoZCjuA4ZHX6
         M8sGYq4e+cUv+RECaETC/122lcYVZLioOLKQZFYWrrD14bN9sGGMZiAxvwdoMMx2v/tL
         RM5G6ypTMbdW9JNGWtEQlrTg0/9uL1LXsxDo8XZGbRs+MNHv8nmm0Ty0Tk8rho1BP1wr
         j3Bg==
X-Gm-Message-State: AOAM531qAhnnmHgjWJzvxAgeJZMdLS5XCOoBa66tNbTibPYW1q8oD/Vv
        taoDv5vtpWVA6pKXpWp1pZz2YPar8KXGhibW3E0DAMqYDhisPyb6DxpF7K9MfMG0DExr/hFF5fe
        abLj44GOaPqpx
X-Received: by 2002:a17:906:60d3:: with SMTP id f19mr32679786ejk.413.1625762785289;
        Thu, 08 Jul 2021 09:46:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKy10UxVtQ7oO9YwYzVTP/mgRlPlJX9CqrvtVvMkjx6B/EzHogyUAAvrBXNOPeRtNzur5mew==
X-Received: by 2002:a17:906:60d3:: with SMTP id f19mr32679767ejk.413.1625762785157;
        Thu, 08 Jul 2021 09:46:25 -0700 (PDT)
Received: from [192.168.10.67] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id h9sm1220167ejk.15.2021.07.08.09.46.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 09:46:24 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/pmu: Clear anythread deprecated bit when 0xa
 leaf is unsupported on the SVM
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210628074354.33848-1-likexu@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7f5d7af0-a48e-5bca-34e2-2a6f2bdab448@redhat.com>
Date:   Thu, 8 Jul 2021 18:44:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628074354.33848-1-likexu@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/06/21 09:43, Like Xu wrote:
> The AMD platform does not support the functions Ah CPUID leaf. The returned
> results for this entry should all remain zero just like the native does:
> 
> AMD host:
>     0x0000000a 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00000000
> (uncanny) AMD guest:
>     0x0000000a 0x00: eax=0x00000000 ebx=0x00000000 ecx=0x00000000 edx=0x00008000
> 
> Fixes: cadbaa039b99 ("perf/x86/intel: Make anythread filter support conditional")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/kvm/cpuid.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 0edda1fc4fe7..b1808e4fc7d5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -765,7 +765,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   
>   		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
>   		edx.split.bit_width_fixed = cap.bit_width_fixed;
> -		edx.split.anythread_deprecated = 1;
> +		if (cap.version)
> +			edx.split.anythread_deprecated = 1;
>   		edx.split.reserved1 = 0;
>   		edx.split.reserved2 = 0;
>   
> 

Queued, thanks.

Paolo

