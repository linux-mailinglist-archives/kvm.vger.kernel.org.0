Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF713A2B39
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 14:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhFJMRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 08:17:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23619 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230336AbhFJMRy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 08:17:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623327358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tRQIAiisGIrw+JGfT9AyG3U4rv0tgzEX+Jux94bTB+4=;
        b=eFDDPYIAdd8UNozvHX4Gg81bEUDjpGnE7IXkoArGETo22/qu6nu61fFndN4RBlZiT3GOQJ
        TIDdv1vA2cMTlT5jzjLGenM9oA5D7T91CAZg4alQz5nL2RAUFF1UwJBBG+qGL4TD6AKQbY
        MbJiiZFI2wYVjyiX5M4MdgxjzMQ5wao=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-TGQ-s07iPoS8gmAQpWnuNQ-1; Thu, 10 Jun 2021 08:15:56 -0400
X-MC-Unique: TGQ-s07iPoS8gmAQpWnuNQ-1
Received: by mail-wr1-f70.google.com with SMTP id q15-20020adfc50f0000b0290111f48b865cso820201wrf.4
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 05:15:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tRQIAiisGIrw+JGfT9AyG3U4rv0tgzEX+Jux94bTB+4=;
        b=f8/EuWhwUy86e151kG/mmY+oYV8P270LylOQE1Hj7ETnJIdChyHlUaHjihm2OX4pZl
         ZBbO0MFYlHiRMLIg+eVj1d1lTjfzL0Dee9PqCeHUKUXp0UZTKz+CAw3utw3bXvWS6Mcm
         WpoyihuI7/o/z8I8BzYajbZ9sZ6f3W+YWGoezDL/pdqa8jG3X/K+9xmsU6URI166MaEY
         6qn1NxHNGyNTNoUAvCTuj0ZQxABDBUyWkFDzI8NB6HSSIrsxySKvHBrdDzh+B6W+Q2lQ
         0Emdk8WSEvjlphmRCCx3CRqwytTwrzHGxC/7tBo0JhqarZzjeGPGG+NfzvyVkDq/EQTG
         1P3g==
X-Gm-Message-State: AOAM531vDFp42qrzs4+W/MCPnvDdQGKN0TOKgvdi0f+2MaqKHXYbeu9r
        6y52a49UMDHbIwRodlnERqaes4VCcOkBWHvpOhq4GgRKBVued20hiNVm3IC6V71fxtR6MMr48YX
        OevzneOLjrFM+
X-Received: by 2002:a1c:4c04:: with SMTP id z4mr4130044wmf.47.1623327355625;
        Thu, 10 Jun 2021 05:15:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtpTmN/gbuEuGL+MyLdgwa9rsIkG/gN2oXtnPsR9mIUvPWzyeCECrc6bFL/6s21g8Ac5nCuw==
X-Received: by 2002:a1c:4c04:: with SMTP id z4mr4130021wmf.47.1623327355404;
        Thu, 10 Jun 2021 05:15:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id r4sm3668055wre.84.2021.06.10.05.15.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 05:15:54 -0700 (PDT)
Subject: Re: [PATCHv3 2/2] kvm: x86: implement KVM PM-notifier
To:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        Marc Zyngier <maz@kernel.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210606021045.14159-1-senozhatsky@chromium.org>
 <20210606021045.14159-2-senozhatsky@chromium.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4cb326cf-fba6-9894-980a-34c1a19183f2@redhat.com>
Date:   Thu, 10 Jun 2021 14:15:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210606021045.14159-2-senozhatsky@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/21 04:10, Sergey Senozhatsky wrote:
> Implement PM hibernation/suspend prepare notifiers so that KVM
> can reliably set PVCLOCK_GUEST_STOPPED on VCPUs and properly
> suspend VMs.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>   arch/x86/kvm/Kconfig |  1 +
>   arch/x86/kvm/x86.c   | 36 ++++++++++++++++++++++++++++++++++++
>   2 files changed, 37 insertions(+)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index fb8efb387aff..ac69894eab88 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -43,6 +43,7 @@ config KVM
>   	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>   	select KVM_VFIO
>   	select SRCU
> +	select HAVE_KVM_PM_NOTIFIER if PM
>   	help
>   	  Support hosting fully virtualized guest machines using hardware
>   	  virtualization extensions.  You will need a fairly recent
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b594275d49b5..af1ab527a0cb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -58,6 +58,7 @@
>   #include <linux/sched/isolation.h>
>   #include <linux/mem_encrypt.h>
>   #include <linux/entry-kvm.h>
> +#include <linux/suspend.h>
>   
>   #include <trace/events/kvm.h>
>   
> @@ -5615,6 +5616,41 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
>   	return 0;
>   }
>   
> +#ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
> +static int kvm_arch_suspend_notifier(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i, ret = 0;
> +
> +	mutex_lock(&kvm->lock);
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (!vcpu->arch.pv_time_enabled)
> +			continue;
> +
> +		ret = kvm_set_guest_paused(vcpu);
> +		if (ret) {
> +			kvm_err("Failed to pause guest VCPU%d: %d\n",
> +				vcpu->vcpu_id, ret);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&kvm->lock);
> +
> +	return ret ? NOTIFY_BAD : NOTIFY_DONE;
> +}
> +
> +int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
> +{
> +	switch (state) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +		return kvm_arch_suspend_notifier(kvm);
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +#endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
> +
>   long kvm_arch_vm_ioctl(struct file *filp,
>   		       unsigned int ioctl, unsigned long arg)
>   {
> 

Queued, thanks.

Paolo

