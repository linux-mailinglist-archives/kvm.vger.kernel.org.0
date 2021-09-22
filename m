Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C20E4141A6
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 08:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhIVGZm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 02:25:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232631AbhIVGZl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 02:25:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632291852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1o72rZ3J4EUS5ZaXq1DHK1qEjD5sQ31Ny28qqm6SkjQ=;
        b=eMlmFzb/DnGJih4KMicfFXizrJANNVkZwnBQmjmZsx0Jp2DCDIAYnzIFFjmkf0hIMOX2Zd
        /ayplsZCUIB70EogFzjJDmR78iJq4CLau8OBdRlOKZ8OoVuVDZGlzLkdxkNL1K1sexgUKt
        QofZd/GGZ07GkGtyegTMYwf2KCPMxzk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-C5ts04ZMPUSIvbJSfQfq_g-1; Wed, 22 Sep 2021 02:24:10 -0400
X-MC-Unique: C5ts04ZMPUSIvbJSfQfq_g-1
Received: by mail-wr1-f70.google.com with SMTP id x7-20020a5d6507000000b0015dada209b1so1108547wru.15
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 23:24:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1o72rZ3J4EUS5ZaXq1DHK1qEjD5sQ31Ny28qqm6SkjQ=;
        b=AyyU8kprjnPmmCcTmzs4vCOAF35HVDyfSdV7zAudb31seXPBegr0w5hyY/ax54W/Dy
         qom/7u1W/1Fl/kQS/gLMoZBDvINKTBrn78Jp35shvX1HR5xmAc4vK/SXtha8dUsYIXnR
         YNeyycODWx5KWPA+l7Rr1UYv2I6xLSXmIlAZRApVrWb+RQeCi53RjU6uDlvgX8EJoCHp
         cJpJeApTEqfK81ISuy636lLdxh+/vuYCM/U9wQFN3SnfhREqDjRmg1F/V/t/Ev8g7CZr
         blmB9J+Cbk1u0O1Zhm/ztM0Ji63L7IhsGwaLvdVZOfoMs9GouvBypvTVUtAFXztLwb1r
         FthA==
X-Gm-Message-State: AOAM530KP14qvfPPudia4wt04fgKuy8meskGYS11FZwdsfyqH+u824kn
        Xiwfnd7K9j+Xkl6yhvn69wmlWL8NPTM92n0xMYrML77bDFqpPRYjKTeSd6L3Lb0e92K3x2O0F2x
        1qwQ9pdH3LLjy
X-Received: by 2002:a1c:448a:: with SMTP id r132mr8797131wma.105.1632291849605;
        Tue, 21 Sep 2021 23:24:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQTq0zGwJ27i2S0Z0f0XPnoR50fJdudIkaF4OKBHHQ4AgCyC4Ha/kLdM9RRJcXFpLjepRj8g==
X-Received: by 2002:a1c:448a:: with SMTP id r132mr8797078wma.105.1632291849339;
        Tue, 21 Sep 2021 23:24:09 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z13sm1236395wrs.90.2021.09.21.23.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 23:24:08 -0700 (PDT)
Subject: Re: [PATCH v3 03/16] KVM: x86: Register Processor Trace interrupt
 hook iff PT enabled in guest
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <459f2af0-d4ea-955e-fb2b-e118140ee9bf@redhat.com>
Date:   Wed, 22 Sep 2021 08:24:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922000533.713300-4-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/21 02:05, Sean Christopherson wrote:
> Override the Processor Trace (PT) interrupt handler for guest mode if and
> only if PT is configured for host+guest mode, i.e. is being used
> independently by both host and guest.  If PT is configured for system
> mode, the host fully controls PT and must handle all events.
> 
> Fixes: 8479e04e7d6b ("KVM: x86: Inject PMI for KVM guest")
> Cc: stable@vger.kernel.org
> Cc: Like Xu <like.xu.linux@gmail.com>
> Reported-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Reported-by: Artem Kashkanov <artem.kashkanov@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/vmx/vmx.c          | 1 +
>   arch/x86/kvm/x86.c              | 5 ++++-
>   3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 09b256db394a..1ea4943a73d7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1494,6 +1494,7 @@ struct kvm_x86_init_ops {
>   	int (*disabled_by_bios)(void);
>   	int (*check_processor_compatibility)(void);
>   	int (*hardware_setup)(void);
> +	bool (*intel_pt_intr_in_guest)(void);
>   
>   	struct kvm_x86_ops *runtime_ops;
>   };
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fada1055f325..f19d72136f77 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7896,6 +7896,7 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
>   	.disabled_by_bios = vmx_disabled_by_bios,
>   	.check_processor_compatibility = vmx_check_processor_compat,
>   	.hardware_setup = hardware_setup,
> +	.intel_pt_intr_in_guest = vmx_pt_mode_is_host_guest,
>   
>   	.runtime_ops = &vmx_x86_ops,
>   };
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb6015f97f9e..ffc6c2d73508 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8305,7 +8305,7 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
>   	.is_in_guest		= kvm_is_in_guest,
>   	.is_user_mode		= kvm_is_user_mode,
>   	.get_guest_ip		= kvm_get_guest_ip,
> -	.handle_intel_pt_intr	= kvm_handle_intel_pt_intr,
> +	.handle_intel_pt_intr	= NULL,
>   };
>   
>   #ifdef CONFIG_X86_64
> @@ -11061,6 +11061,8 @@ int kvm_arch_hardware_setup(void *opaque)
>   	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
>   	kvm_ops_static_call_update();
>   
> +	if (ops->intel_pt_intr_in_guest && ops->intel_pt_intr_in_guest())
> +		kvm_guest_cbs.handle_intel_pt_intr = kvm_handle_intel_pt_intr;
>   	perf_register_guest_info_callbacks(&kvm_guest_cbs);
>   
>   	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> @@ -11091,6 +11093,7 @@ int kvm_arch_hardware_setup(void *opaque)
>   void kvm_arch_hardware_unsetup(void)
>   {
>   	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
> +	kvm_guest_cbs.handle_intel_pt_intr = NULL;
>   
>   	static_call(kvm_x86_hardware_unsetup)();
>   }
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

