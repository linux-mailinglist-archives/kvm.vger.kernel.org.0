Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B819730AA28
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 15:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhBAOp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 09:45:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25695 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231152AbhBAOpZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 09:45:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612190636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zO1OziphBgebiueshJ1sNrFKTni87S/tUnj1XzD01UI=;
        b=PuC8dfNkEwQlXC7CtJGmK/20jkxrHGz8oSdmOoPjbHIVphMSpqA0lYdS4LwOfZwf57A8bG
        7dmglE/GVkvvhApyCd+ZUnoqUSLns9As50ruf25rkDLt9YHlUPSmhKfQtNDKrI8jAsG5wZ
        L5BAXWra1EBGkNnPKdjyjU1GUbHhWWg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-F1r1Lm8wOFGK5kYNUH3DTQ-1; Mon, 01 Feb 2021 09:43:55 -0500
X-MC-Unique: F1r1Lm8wOFGK5kYNUH3DTQ-1
Received: by mail-wm1-f72.google.com with SMTP id u1so4918773wml.2
        for <kvm@vger.kernel.org>; Mon, 01 Feb 2021 06:43:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zO1OziphBgebiueshJ1sNrFKTni87S/tUnj1XzD01UI=;
        b=lkejoWP3GpFIAWp70wwMhKwwcb7pSDNH9mYrqFM7jqFIr00+vNqF2OVzxQLXkdon1B
         AjY8E9+SmO/oi/dVm9pA7quR6T1HXlOMK2OpRgeNgFKQktKw0sxGMddbA1Bw6U9Iajr8
         KARyykFPZTcIbKqgJjrDiEurrdHIFwl2bPA4bXunGLx51TqnMMIqZ2NdhsrMnvgzLPWg
         YXs4KA8D9R0IMb6rOhq5BLDE0U+T/J3h1tXpr3QnKdx3pXGB4AhhtkBYaJMdFpQA1wed
         jrcnUCt7M3zZRrNhFWcMD5nzVqEgmKpEiT2EvmQK/fs2dRNPci6obLpBIXAoUkrhaChR
         7YtA==
X-Gm-Message-State: AOAM533fpBB3HOvXy3moHB2km655v/ZvAPgbAqss8dqhm9MHKTeFXLIp
        MBs+c5eGH+GAI7vRzMARFBGqCbOVz5gKGXjnQiGwJhGG1e641cNdY/0Mg/OEbGCYo0PhYOqmZEK
        63U3woJCywuf8
X-Received: by 2002:a05:6000:234:: with SMTP id l20mr18444166wrz.212.1612190633693;
        Mon, 01 Feb 2021 06:43:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuXTXobU6V4dlGwxCuARDIdcyljxLtersvGpuHS4HxSC9xa5oCXv0AYgwegMAApnKO/nP6TQ==
X-Received: by 2002:a05:6000:234:: with SMTP id l20mr18444144wrz.212.1612190633447;
        Mon, 01 Feb 2021 06:43:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h15sm27313629wrt.10.2021.02.01.06.43.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 06:43:52 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Supplement __cr4_reserved_bits() with
 X86_FEATURE_PCID check
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20210201142843.108190-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c35f656d-1fff-8c5b-42a5-575c161e4209@redhat.com>
Date:   Mon, 1 Feb 2021 15:43:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210201142843.108190-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/21 15:28, Vitaly Kuznetsov wrote:
> Commit 7a873e455567 ("KVM: selftests: Verify supported CR4 bits can be set
> before KVM_SET_CPUID2") reveals that KVM allows to set X86_CR4_PCIDE even
> when PCID support is missing:
> 
> ==== Test Assertion Failure ====
>    x86_64/set_sregs_test.c:41: rc
>    pid=6956 tid=6956 - Invalid argument
>       1	0x000000000040177d: test_cr4_feature_bit at set_sregs_test.c:41
>       2	0x00000000004014fc: main at set_sregs_test.c:119
>       3	0x00007f2d9346d041: ?? ??:0
>       4	0x000000000040164d: _start at ??:?
>    KVM allowed unsupported CR4 bit (0x20000)
> 
> Add X86_FEATURE_PCID feature check to __cr4_reserved_bits() to make
> kvm_is_valid_cr4() fail.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/x86.h | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index c5ee0f5ce0f1..0f727b50bd3d 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -425,6 +425,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
>   		__reserved_bits |= X86_CR4_UMIP;        \
>   	if (!__cpu_has(__c, X86_FEATURE_VMX))           \
>   		__reserved_bits |= X86_CR4_VMXE;        \
> +	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
> +		__reserved_bits |= X86_CR4_PCIDE;       \
>   	__reserved_bits;                                \
>   })
>   
> 

Queued, thanks.

Paolo

