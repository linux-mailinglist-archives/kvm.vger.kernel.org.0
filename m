Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35254340C50
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 18:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhCRR6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 13:58:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232425AbhCRR6H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 13:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616090287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NUujWEdLnxg/Su0lhfLLn7VIR47iTJj/vAGzVkr8zsY=;
        b=TADYfvHfeOr0w6o7a1ReSbOkMKR00+mkjNu1O+TvUxYAnUx5IQpNKklcYCbNzY7fHuR69v
        1Am/jkI2TXQicKB4m3AVztr5kvm5rFWpyu7ERHjr6rvoExoKSMmq8WXfwwxs9KeOdM2VnZ
        uSd7ab4jkgTKEfhaav+Q9FZ4kEGDHc0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-kMJ5jY8nN4umkC_F_z0CvA-1; Thu, 18 Mar 2021 13:58:05 -0400
X-MC-Unique: kMJ5jY8nN4umkC_F_z0CvA-1
Received: by mail-wr1-f72.google.com with SMTP id s10so20473386wre.0
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 10:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NUujWEdLnxg/Su0lhfLLn7VIR47iTJj/vAGzVkr8zsY=;
        b=rQ2R0wfyazLqRxb5k9cOmY+MDoqWRNYP7sh1SCNOX27FL0gCSkGnkRNDNPHO16ejSW
         yJ/k2OoUjVmzaif6GE/N3FYq4keE3u9crM4Fs37OOa/66KyleGqPJtNJhDDuo8zM3HLp
         uwnDxUY9I4raKX8VRPGPZpdaonIcFFIFCR5VAyywksV75yn2b3XEZ5hiaNmu3EAlRFuu
         K5UmnTbwq5FX0DSxYNiDXvSPnoEFjXiY5Joi72xKFhfItwaij9A5b6w4FQIwsv4z13KA
         WWjYD1VHFBBVmCdSGrjKMYdYYIZBhF0RdsvgfHza7QXC/cWjUFj7/Ytme7BO72CcJein
         rc2w==
X-Gm-Message-State: AOAM530kfhlIRrzEPkeBhNZ/kRgmgpDi/s8IuwiR4sXM4yZCLCWwDU92
        Iuv4JGu3DEi5GdRIUsYRUqrMnAwqME75HrEEZbbsKFlXR9j7huV6Cg09e/kKmsHh60INsk8FRhd
        CEQTNrdMdWbS3
X-Received: by 2002:a5d:4523:: with SMTP id j3mr517813wra.288.1616090284410;
        Thu, 18 Mar 2021 10:58:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4tbalu94oyS6kMqkgi9n+rYLk3Fss0fWDkq7nC7UEFTh52j6TbkhqNPncJCSNoqcmhKeWGA==
X-Received: by 2002:a5d:4523:: with SMTP id j3mr517790wra.288.1616090284226;
        Thu, 18 Mar 2021 10:58:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e8sm2962600wme.14.2021.03.18.10.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 10:58:03 -0700 (PDT)
Subject: Re: [PATCH v3] x86/kvm: Fix broken irq restoration in kvm_wait
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1615791328-2735-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a2b010b4-6c90-b2c8-49e7-810bb76b6c27@redhat.com>
Date:   Thu, 18 Mar 2021 18:58:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1615791328-2735-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/03/21 07:55, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> After commit 997acaf6b4b59c (lockdep: report broken irq restoration), the guest
> splatting below during boot:
> 
>   raw_local_irq_restore() called with IRQs enabled
>   WARNING: CPU: 1 PID: 169 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x26/0x30
>   Modules linked in: hid_generic usbhid hid
>   CPU: 1 PID: 169 Comm: systemd-udevd Not tainted 5.11.0+ #25
>   RIP: 0010:warn_bogus_irq_restore+0x26/0x30
>   Call Trace:
>    kvm_wait+0x76/0x90
>    __pv_queued_spin_lock_slowpath+0x285/0x2e0
>    do_raw_spin_lock+0xc9/0xd0
>    _raw_spin_lock+0x59/0x70
>    lockref_get_not_dead+0xf/0x50
>    __legitimize_path+0x31/0x60
>    legitimize_root+0x37/0x50
>    try_to_unlazy_next+0x7f/0x1d0
>    lookup_fast+0xb0/0x170
>    path_openat+0x165/0x9b0
>    do_filp_open+0x99/0x110
>    do_sys_openat2+0x1f1/0x2e0
>    do_sys_open+0x5c/0x80
>    __x64_sys_open+0x21/0x30
>    do_syscall_64+0x32/0x50
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> The irqflags handling in kvm_wait() which ends up doing:
> 
> 	local_irq_save(flags);
> 	safe_halt();
> 	local_irq_restore(flags);
> 
> which triggered a new consistency checking, we generally expect
> local_irq_save() and local_irq_restore() to be pared and sanely
> nested, and so local_irq_restore() expects to be called with
> irqs disabled.
> 
> This patch fixes it by playing local_irq_disable()/enable() directly.
> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v2 -> v3:
>   * per Sean's suggestion
> 
>   arch/x86/kernel/kvm.c | 23 ++++++++++-------------
>   1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 5e78e01..72dbb74 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -836,28 +836,25 @@ static void kvm_kick_cpu(int cpu)
>   
>   static void kvm_wait(u8 *ptr, u8 val)
>   {
> -	unsigned long flags;
> -
>   	if (in_nmi())
>   		return;
>   
> -	local_irq_save(flags);
> -
> -	if (READ_ONCE(*ptr) != val)
> -		goto out;
> -
>   	/*
>   	 * halt until it's our turn and kicked. Note that we do safe halt
>   	 * for irq enabled case to avoid hang when lock info is overwritten
>   	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
>   	 */
> -	if (arch_irqs_disabled_flags(flags))
> -		halt();
> -	else
> -		safe_halt();
> +	if (irqs_disabled()) {
> +		if (READ_ONCE(*ptr) == val)
> +			halt();
> +	} else {
> +		local_irq_disable();
>   
> -out:
> -	local_irq_restore(flags);
> +		if (READ_ONCE(*ptr) == val)
> +			safe_halt();
> +
> +		local_irq_enable();
> +	}
>   }
>   
>   #ifdef CONFIG_X86_32
> 

Queued, thanks.

Paolo

