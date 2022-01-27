Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE4549E203
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 13:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236444AbiA0MIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 07:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiA0MIn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 07:08:43 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536F2C061747;
        Thu, 27 Jan 2022 04:08:43 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id me13so5239247ejb.12;
        Thu, 27 Jan 2022 04:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=97GY31DTJYjnJBte88PVOVi9Qok7H45EklJId7cgZ4k=;
        b=XIUB/6X9M6TwnPEqYwM/86uQqEaRNWk2KCOd+169EGmYnD/EJTRy1g+tJ8npwmnnZN
         J+ub3I5xg9X4pqXrHkXguZE7c3NlpwdTDcpnzX3VvemnykDpMBWp2mm/Hhe2TdqJ4GGy
         EjAL+HhSeAbUSxKXM9HiLoK+weAH861gi2VJhZdceI78FC8ak6fLZekHBpZ4kIIeqZ28
         tNgHid9bAkR3VGcZ70Km40IDRCLIWolFJkXABebBpqeb8613cZOrHA/uJ+ZpWzc/HavG
         9blCptnEzfH5InWRwh1jFTTJyz+sOjhAqP9ISPgd/XPokOEQBv0Ax2LZfOZeVSAany2G
         BRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=97GY31DTJYjnJBte88PVOVi9Qok7H45EklJId7cgZ4k=;
        b=4I4Vefxo+L/3CVUX/uH2dRrcQQ9LwLxfNz4B48lkfu8vJm5FoEjiG4jzShVD63gJQ/
         we18wX05pxygucuLjujHY50PwZj2VhdB3Vgh5q1C8db3jc02qIWLocdpGTcSKKOxM/Gm
         RHbZn6+QWIL2ODumz2rfpBTe6VpIHYNdbj/jh2jgf7oQU6a5BEifP5fu/UqtavOmJKXi
         kD6uewl64SKfhfwWaNgAhaP+pMRCkvxFUo4SMWXVOOj491uXLaCV62vflvyGgsa6YwmS
         ZQZwFI7Y6Is8BOayKP2PrUMPV4n/1YuqgqnBA7j3OrhZsW9dj0iwf0L7+drEyldZnoI/
         Ux1w==
X-Gm-Message-State: AOAM533nEzFPEIpD2Jur1CMtpClnJSuAe9YLmunzA0GbFYBFm/Fsdvbf
        M8ut27E1I39n8WGi3V82XNQ=
X-Google-Smtp-Source: ABdhPJzp8cdNeyShJLx8FB4AtundNCq017//RJLrM6lfi+9VqvGuJgxeCMAnnTKI3TdZaK9DpCrxJQ==
X-Received: by 2002:a17:907:1627:: with SMTP id hb39mr1274038ejc.492.1643285321764;
        Thu, 27 Jan 2022 04:08:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id m22sm7116683ejn.194.2022.01.27.04.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 04:08:41 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3f71c29a-2167-cb16-e2e9-79563250163e@redhat.com>
Date:   Thu, 27 Jan 2022 13:08:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] KVM: eventfd: Fix false positive RCU usage warning
Content-Language: en-US
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>, kvm@vger.kernel.org
Cc:     Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
References: <ab1358b84c60e6c942c270e3fe1a32bfa3177f3c.1641264282.git.houwenlong93@linux.alibaba.com>
 <f98bac4f5052bad2c26df9ad50f7019e40434512.1643265976.git.houwenlong.hwl@antgroup.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <f98bac4f5052bad2c26df9ad50f7019e40434512.1643265976.git.houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/27/22 07:54, Hou Wenlong wrote:
> From: Hou Wenlong <houwenlong93@linux.alibaba.com>
> 
> Fix the following false positive warning:
>   =============================
>   WARNING: suspicious RCU usage
>   5.16.0-rc4+ #57 Not tainted
>   -----------------------------
>   arch/x86/kvm/../../../virt/kvm/eventfd.c:484 RCU-list traversed in non-reader section!!
> 
>   other info that might help us debug this:
> 
>   rcu_scheduler_active = 2, debug_locks = 1
>   3 locks held by fc_vcpu 0/330:
>    #0: ffff8884835fc0b0 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x88/0x6f0 [kvm]
>    #1: ffffc90004c0bb68 (&kvm->srcu){....}-{0:0}, at: vcpu_enter_guest+0x600/0x1860 [kvm]
>    #2: ffffc90004c0c1d0 (&kvm->irq_srcu){....}-{0:0}, at: kvm_notify_acked_irq+0x36/0x180 [kvm]
> 
>   stack backtrace:
>   CPU: 26 PID: 330 Comm: fc_vcpu 0 Not tainted 5.16.0-rc4+
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x44/0x57
>    kvm_notify_acked_gsi+0x6b/0x70 [kvm]
>    kvm_notify_acked_irq+0x8d/0x180 [kvm]
>    kvm_ioapic_update_eoi+0x92/0x240 [kvm]
>    kvm_apic_set_eoi_accelerated+0x2a/0xe0 [kvm]
>    handle_apic_eoi_induced+0x3d/0x60 [kvm_intel]
>    vmx_handle_exit+0x19c/0x6a0 [kvm_intel]
>    vcpu_enter_guest+0x66e/0x1860 [kvm]
>    kvm_arch_vcpu_ioctl_run+0x438/0x7f0 [kvm]
>    kvm_vcpu_ioctl+0x38a/0x6f0 [kvm]
>    __x64_sys_ioctl+0x89/0xc0
>    do_syscall_64+0x3a/0x90
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Since kvm_unregister_irq_ack_notifier() does synchronize_srcu(&kvm->irq_srcu),
> i.e. kvm->irq_ack_notifier_list is protected by kvm->irq_srcu. And
> kvm->irq_srcu SRCU read lock is held in kvm_notify_acked_irq(), it's
> a false positive warning. Use hlist_for_each_entry_srcu() instead of
> hlist_for_each_entry_rcu() as it also checkes if the right lock is held.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> ---
>   virt/kvm/eventfd.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2ad013b8bde9..59b1dd4a549e 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -463,8 +463,8 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
>   	idx = srcu_read_lock(&kvm->irq_srcu);
>   	gsi = kvm_irq_map_chip_pin(kvm, irqchip, pin);
>   	if (gsi != -1)
> -		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
> -					 link)
> +		hlist_for_each_entry_srcu(kian, &kvm->irq_ack_notifier_list,
> +					  link, srcu_read_lock_held(&kvm->irq_srcu))
>   			if (kian->gsi == gsi) {
>   				srcu_read_unlock(&kvm->irq_srcu, idx);
>   				return true;
> @@ -480,8 +480,8 @@ void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
>   {
>   	struct kvm_irq_ack_notifier *kian;
> 
> -	hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
> -				 link)
> +	hlist_for_each_entry_srcu(kian, &kvm->irq_ack_notifier_list,
> +				  link, srcu_read_lock_held(&kvm->irq_srcu))
>   		if (kian->gsi == gsi)
>   			kian->irq_acked(kian);
>   }
> --
> 2.31.1
> 

Queued, thanks.

Paolo
