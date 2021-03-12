Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC3433961D
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 19:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhCLSS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 13:18:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232840AbhCLSSs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 13:18:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615573127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJ3Ss3R70JXhCunPWVxdQ3105vW2rrXZHKhhTA4PdBY=;
        b=cKphart8ZNV8DvzcqqCwweXiH2gaGXbphLUqN4ZUbBxhVxOp6DzfdIkBYJXDfOt2lXYn6F
        HelQMeHufW+5LvwfF+lTz2p1IF4ocwUWBm3YfNvLXECZ+II9JjBhQcUun3P+ZHyIGp2cAr
        15zqlJTkLtuK+EogsP5vAHtzvQoMNjk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-5e32ikRfNviipTHQBCs4qg-1; Fri, 12 Mar 2021 13:18:45 -0500
X-MC-Unique: 5e32ikRfNviipTHQBCs4qg-1
Received: by mail-wr1-f70.google.com with SMTP id g2so11526091wrx.20
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 10:18:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BJ3Ss3R70JXhCunPWVxdQ3105vW2rrXZHKhhTA4PdBY=;
        b=mTws4bfPeAPyb6RgKRb39+65OUwbMm6loW8n02hT0hmyPzsmNANpdA/P5fEe4jF57z
         pNIK/F+UcGduaf1O33tmU+cGRz41/KZnZrmLWG6FHTgqAp61uROyFBygJ0TdRQaWvKUW
         9eMFVKAva1cBaKIGth+niKMiVy2A3KMF2MzUINhaEYs4rckAcpro2c8vC+0Fh9UeS2tW
         ckLH3SGWTjAbpE08sriXPi97HQgt9kqSPoi0jHszwXB3h4d5lC5BhoTlduPuqqrBJxJC
         L2ccEcG+QnQ3C3yi8iwVjXlsQPcBEoX29DU17d0gwkIb4e83lChBH4wtl6RXibLZqOYE
         rGMw==
X-Gm-Message-State: AOAM530M0VFI6lWPD9COoxog2K7f3xLUAJq2F+Z12Sz/R4r7hqeoPHX7
        ZzhBbg4U9r3ktJVfHvm8bDJDc2TpBYmJDx8hB25drNoaNqOI1Dt8cOCBKAicupeM2ardKLGFtGw
        UdYDJN2+Obv0f
X-Received: by 2002:a5d:4d8a:: with SMTP id b10mr15451707wru.395.1615573124646;
        Fri, 12 Mar 2021 10:18:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJRfu0Hef7xY914AeQTLdcPMnoepxXCXfrLPv0s9jE8R3JYGEE98Etac9sVbTdQKNlS47H7w==
X-Received: by 2002:a5d:4d8a:: with SMTP id b10mr15451691wru.395.1615573124448;
        Fri, 12 Mar 2021 10:18:44 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c9sm8863667wrr.78.2021.03.12.10.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 10:18:43 -0800 (PST)
Subject: Re: [PATCH v4] KVM: kvmclock: Fix vCPUs > 64 can't be
 online/hotpluged
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <1614130683-24137-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <aa6ea700-84d2-932a-ae12-d25e37738bd7@redhat.com>
Date:   Fri, 12 Mar 2021 19:18:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614130683-24137-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/02/21 02:37, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> # lscpu
> Architecture:          x86_64
> CPU op-mode(s):        32-bit, 64-bit
> Byte Order:            Little Endian
> CPU(s):                88
> On-line CPU(s) list:   0-63
> Off-line CPU(s) list:  64-87
> 
> # cat /proc/cmdline
> BOOT_IMAGE=/vmlinuz-5.10.0-rc3-tlinux2-0050+ root=/dev/mapper/cl-root ro
> rd.lvm.lv=cl/root rhgb quiet console=ttyS0 LANG=en_US .UTF-8 no-kvmclock-vsyscall
> 
> # echo 1 > /sys/devices/system/cpu/cpu76/online
> -bash: echo: write error: Cannot allocate memory
> 
> The per-cpu vsyscall pvclock data pointer assigns either an element of the
> static array hv_clock_boot (#vCPU <= 64) or dynamically allocated memory
> hvclock_mem (vCPU > 64), the dynamically memory will not be allocated if
> kvmclock vsyscall is disabled, this can result in cpu hotpluged fails in
> kvmclock_setup_percpu() which returns -ENOMEM. It's broken for no-vsyscall
> and sometimes you end up with vsyscall disabled if the host does something
> strange. This patch fixes it by allocating this dynamically memory
> unconditionally even if vsyscall is disabled.
> 
> Fixes: 6a1cac56f4 ("x86/kvm: Use __bss_decrypted attribute in shared variables")
> Reported-by: Zelin Deng <zelin.deng@linux.alibaba.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: stable@vger.kernel.org#v4.19-rc5+
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v3 -> v4:
>   * fix kernel test robot report WARNING
> v2 -> v3:
>   * allocate dynamically memory unconditionally
> v1 -> v2:
>   * add code comments
> 
>   arch/x86/kernel/kvmclock.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index aa59374..1fc0962 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -268,21 +268,20 @@ static void __init kvmclock_init_mem(void)
>   
>   static int __init kvm_setup_vsyscall_timeinfo(void)
>   {
> -#ifdef CONFIG_X86_64
> -	u8 flags;
> +	kvmclock_init_mem();
>   
> -	if (!per_cpu(hv_clock_per_cpu, 0) || !kvmclock_vsyscall)
> -		return 0;
> +#ifdef CONFIG_X86_64
> +	if (per_cpu(hv_clock_per_cpu, 0) && kvmclock_vsyscall) {
> +		u8 flags;
>   
> -	flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
> -	if (!(flags & PVCLOCK_TSC_STABLE_BIT))
> -		return 0;
> +		flags = pvclock_read_flags(&hv_clock_boot[0].pvti);
> +		if (!(flags & PVCLOCK_TSC_STABLE_BIT))
> +			return 0;
>   
> -	kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
> +		kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
> +	}
>   #endif
>   
> -	kvmclock_init_mem();
> -
>   	return 0;
>   }
>   early_initcall(kvm_setup_vsyscall_timeinfo);
> 

Queued, thanks.

Paolo

