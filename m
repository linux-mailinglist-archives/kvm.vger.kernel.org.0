Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB50D3E5741
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbhHJJnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 05:43:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238036AbhHJJn0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 05:43:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628588584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cpDfHpt47hSc6AzAlRlILCO+aeSunbJpr3KnIZBUh34=;
        b=Rsk1gNzCC6Nl09XQ1/Hz1jTj1fsSKnRCA/FZebUdoYQXnd7onUK4nkUmOMPFLO/f6rEgpS
        CXqe/xC5vGYV0CeQP2VhpBEtvSys749kAvF+mfS/kNPxzQaLoeOtF0l1pe6dnYk54sz1ZB
        t5SLWWLznNlHuFPBeKDFFl8O1hoKItA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-CeW0Qe3XPuGolndfHyIHjw-1; Tue, 10 Aug 2021 05:43:03 -0400
X-MC-Unique: CeW0Qe3XPuGolndfHyIHjw-1
Received: by mail-ed1-f69.google.com with SMTP id ec47-20020a0564020d6fb02903be5e0a8cd2so4163048edb.0
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 02:43:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cpDfHpt47hSc6AzAlRlILCO+aeSunbJpr3KnIZBUh34=;
        b=irUcjmiEcsfCYbVWhC7+hKPK1zGloE5Wxx+HXZm7Vwr8CCEDNvE6uiTLEHiYAIo24T
         U/+TGvqqbrELbZSsVd038xCFXmsEbDl/BgI0cPElxYuuT7v0+GN9Ty4OqmaCa7XjDE07
         WZ0Xphwxm7BYjtMMcGMEz1FLjfcSWqwQdVmCIg2YoPW/pPItVPLBoyfypHbp6oH5c3JD
         bMumXkN6a+bZ5SqHttCh65JjoFghFisu7VewOgZCJ5mQByBnFRmzRyakH9efCVl6iD4c
         o+1cW5GVN4pGPBkjjMzF1CPxUgrZXZOgZ7I2wLysUkAhyCCNZC0TcGcfQBLyghr6wnTI
         KoIg==
X-Gm-Message-State: AOAM5309DrrCQYiWSnZdX2NTi2Bzy35h7IjEl0Kc+2JkM4Qb2S0XFukG
        +gkqvvOepG3quZoHK0Nj6eo7T1Zb25DEGiMVp7sipTBoiIvSaQXsCVgExq5WIobzqptFMz4+73P
        mBEX+ZTRCXi6V2JKEpKtb41307b9BTg3kdKfJ7qlTBwH/On0GUwpAKkfzuutfZPzY
X-Received: by 2002:a17:906:3812:: with SMTP id v18mr6279596ejc.399.1628588581989;
        Tue, 10 Aug 2021 02:43:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwshe3Nr/y/JjFhXpv/U0BEpDz3J+0tIi/LJKdYwEGZZpuzz3TeCA4ZKQ2rJ26vHlscD2Si4A==
X-Received: by 2002:a17:906:3812:: with SMTP id v18mr6279567ejc.399.1628588581742;
        Tue, 10 Aug 2021 02:43:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id o23sm9346857eds.75.2021.08.10.02.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:43:01 -0700 (PDT)
Subject: Re: [PATCH V2 3/3] KVM: X86: Reset DR6 only when
 KVM_DEBUGREG_WONT_EXIT
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <YRFdq8sNuXYpgemU@google.com>
 <20210809174307.145263-1-jiangshanlai@gmail.com>
 <20210809174307.145263-3-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0a5243de-9fc2-388f-ea4d-377261d64430@redhat.com>
Date:   Tue, 10 Aug 2021 11:42:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210809174307.145263-3-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/21 19:43, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> The commit efdab992813fb ("KVM: x86: fix escape of guest dr6 to the host")
> fixed a bug by reseting DR6 unconditionally when the vcpu being scheduled out.
> 
> But writing to debug registers is slow, and it can be shown in perf results
> sometimes even neither the host nor the guest activate breakpoints.
> 
> It'd be better to reset it conditionally and this patch moves the code of
> reseting DR6 to the path of VM-exit and only reset it when
> KVM_DEBUGREG_WONT_EXIT which is the only case that DR6 is guest value.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/x86.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d2aa49722064..f40cdd7687d8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4309,12 +4309,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   
>   	static_call(kvm_x86_vcpu_put)(vcpu);
>   	vcpu->arch.last_host_tsc = rdtsc();
> -	/*
> -	 * If userspace has set any breakpoints or watchpoints, dr6 is restored
> -	 * on every vmexit, but if not, we might have a stale dr6 from the
> -	 * guest. do_debug expects dr6 to be cleared after it runs, do the same.
> -	 */
> -	set_debugreg(0, 6);
>   }
>   
>   static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
> @@ -9630,6 +9624,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
>   		kvm_update_dr0123(vcpu);
>   		kvm_update_dr7(vcpu);
> +		/* Reset Dr6 which is guest value. */

Better keep the rationale from the original comment,

	/*
	 * do_debug expects dr6 to be cleared after it runs, so do
	 * not leave the guest value in the host DR6.
	 */

Paolo

> +		set_debugreg(DR6_RESERVED, 6);
>   	}
>   
>   	/*
> 

