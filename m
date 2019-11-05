Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7342EFAEE
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 11:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388534AbfKEKXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 05:23:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40066 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388525AbfKEKXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 05:23:21 -0500
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38A8283F51
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 10:23:21 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id f16so470309wmb.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 02:23:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L2DCL6AJUoTx12g/nBt+5+g+jRrLNYmCpns9Ml6NzII=;
        b=BibuzYv+KsX2ro1BIXWJits5fq9InXNw7wHHjltfUt6xiEUt2BMwjNSK8zULD9sNue
         gSRGMVyLJDjUbMHCJaEFXcM8MxrIgNkjxhfSJ+sponSEx6GaRyHEcRNjc50MQgat3oto
         ewPxP4KtEuFAbxVqk87639pAMT97kMV9JVJGNeiHl8WJgeIIU6Wh8ip07vqUoXvJrRNh
         tmPIgNWfHa+EldSJ5t2lzPvIZbmwvjImdjroXHfX+9ZXRuyxzkpTSN55fVfjl8NJYMF8
         wxj+d705fJTGi4VWr0NI6jF7aUQgf+8EOGOir4hkqUjvIc9c6Um3RHG6BzpZRSfQAYY1
         q/6Q==
X-Gm-Message-State: APjAAAVY5x5WoBCtb30U9sGHa6qvfSQzmgZTkOqi2T5v5csycQRzKpa8
        3VG7eM1L36tzuds64whGHtwWQWAhuP/o63aPJ9OmPzXXEb1xexenanb/f/J5ssXyoS4N+2Me2tQ
        kcrbxn2NI4aBB
X-Received: by 2002:a05:600c:214b:: with SMTP id v11mr3615909wml.149.1572949399789;
        Tue, 05 Nov 2019 02:23:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqzBZkub82r+YaidAWnAVsPcUzN7WWqgOtKY4bu/OLSPh9FFpp+MoOYAmoKCvjjxybqwhQOC/A==
X-Received: by 2002:a05:600c:214b:: with SMTP id v11mr3615883wml.149.1572949399478;
        Tue, 05 Nov 2019 02:23:19 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w9sm21506531wrt.85.2019.11.05.02.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 02:23:18 -0800 (PST)
Subject: Re: [PATCH 13/13] x86: retpolines: eliminate retpoline from msr event
 handlers
To:     Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191104230001.27774-1-aarcange@redhat.com>
 <20191104230001.27774-14-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <306784c2-25b0-9f25-c9e0-c23aaee11e4f@redhat.com>
Date:   Tue, 5 Nov 2019 11:21:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104230001.27774-14-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/19 00:00, Andrea Arcangeli wrote:
> It's enough to check the value and issue the direct call.
> 
> After this commit is applied, here the most common retpolines executed
> under a high resolution timer workload in the guest on a VMX host:
> 
> [..]
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_rax+33
>     do_syscall_64+89
>     entry_SYSCALL_64_after_hwframe+68
> ]: 267
> @[]: 2256
> @[
>     trace_retpoline+1
>     __trace_retpoline+30
>     __x86_indirect_thunk_rax+33
>     __kvm_wait_lapic_expire+284
>     vmx_vcpu_run.part.97+1091
>     vcpu_enter_guest+377
>     kvm_arch_vcpu_ioctl_run+261
>     kvm_vcpu_ioctl+559
>     do_vfs_ioctl+164
>     ksys_ioctl+96
>     __x64_sys_ioctl+22
>     do_syscall_64+89
>     entry_SYSCALL_64_after_hwframe+68
> ]: 2390
> @[]: 33410
> 
> @total: 315707
> 
> Note the highest hit above is __delay so probably not worth optimizing
> even if it would be more frequent than 2k hits per sec.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/events/intel/core.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index fcef678c3423..937363b803c1 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3323,8 +3323,19 @@ static int intel_pmu_hw_config(struct perf_event *event)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_RETPOLINE
> +static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr);
> +static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr);
> +#endif
> +
>  struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
>  {
> +#ifdef CONFIG_RETPOLINE
> +	if (x86_pmu.guest_get_msrs == intel_guest_get_msrs)
> +		return intel_guest_get_msrs(nr);
> +	else if (x86_pmu.guest_get_msrs == core_guest_get_msrs)
> +		return core_guest_get_msrs(nr);
> +#endif
>  	if (x86_pmu.guest_get_msrs)
>  		return x86_pmu.guest_get_msrs(nr);
>  	*nr = 0;
> 

Queued, thanks.

Paolo
