Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE44B1335
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 17:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244476AbiBJQkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 11:40:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244457AbiBJQkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 11:40:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16DEEE87
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644511222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tz8Fgr8nJXv+exGrZ4WdoY4zs94Ls810DBab8zeLSKs=;
        b=SsxMWHh2gC7tRFuNJdq8bRWp+89JKlOail/R0Svq6X37znq4nzHBdS5x0WBvyGNN/JQcL9
        23cE1mvBX9k+hsT1+Mv7MaN7CWNSA/pbM4A1CkOmuEENAgsCjySvw5g2wzUhqB+8ieibue
        29d1dff4Lz1OQ0L3VUIwShGTL1jxnxc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-rEuXC0bLNiSI0YJlLzk3aQ-1; Thu, 10 Feb 2022 11:40:21 -0500
X-MC-Unique: rEuXC0bLNiSI0YJlLzk3aQ-1
Received: by mail-ed1-f70.google.com with SMTP id b26-20020a056402139a00b004094fddbbdfso3671347edv.12
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 08:40:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tz8Fgr8nJXv+exGrZ4WdoY4zs94Ls810DBab8zeLSKs=;
        b=7KBxepCqXrnUzkr5EsR3NCO5I5WS/cBk997yuqSn4bBAq/8C6a+Z6Nc/cFJobkpKxK
         d4BqMXc6q0TS1F9MupBNFLeLdPin365BZzJT58pIR4kdr/C+b8oNjPXyZCEMXGbAh4oJ
         Q+WNcX6dSgjzGTdgrXwPsJIpdHc9I+vq03NY9udOvirxT75Cz+YU+0AbC0Nq4bcbKkXH
         ZtOFvN9Iirh+n3e2DU+QdGtuEZHP7uytscm5bb42VasBH0bebRnOcw2zkHNnZgZ8aM5S
         Oy/uFDwJeiwWNPk+HoYF9303F+5EqcmP++qqKiMg9SqD8e9/ZG6wbB+XoklEOcikioPz
         mX9A==
X-Gm-Message-State: AOAM530xb1f4IPc3p5MKwPqhwPgfyeoaHWFTg7uHAz4Nb6YoV0gHOaUs
        EYg9RwcXY6SSHynIvmqiXSNbFMUOdV+LgfcbeWmoCXhAzGG0Fp83rsD3wzRksg9u5dTicnSdqcw
        56JmizXmSC565
X-Received: by 2002:a05:6402:42c8:: with SMTP id i8mr9465277edc.166.1644511219342;
        Thu, 10 Feb 2022 08:40:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyLk+u/iygKmOfXLPpll1kst7dtiAPscR/RpDhGskAHu349wSPACXZnR76gXZHjFeT0eMkwqQ==
X-Received: by 2002:a05:6402:42c8:: with SMTP id i8mr9465262edc.166.1644511219166;
        Thu, 10 Feb 2022 08:40:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id o10sm4079237ejj.6.2022.02.10.08.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:40:18 -0800 (PST)
Message-ID: <322ee640-891c-0c87-d864-237a6dcce402@redhat.com>
Date:   Thu, 10 Feb 2022 17:40:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH MANUALSEL 5.10 1/6] KVM: eventfd: Fix false positive RCU
 usage warning
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <20220209185714.48936-1-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220209185714.48936-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/9/22 19:57, Sasha Levin wrote:
> From: Hou Wenlong <houwenlong93@linux.alibaba.com>
> 
> [ Upstream commit 6a0c61703e3a5d67845a4b275e1d9d7bc1b5aad7 ]

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

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
> kvm->irq_ack_notifier_list is protected by kvm->irq_srcu. In fact,
> kvm->irq_srcu SRCU read lock is held in kvm_notify_acked_irq(), making it
> a false positive warning. So use hlist_for_each_entry_srcu() instead of
> hlist_for_each_entry_rcu().
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> Message-Id: <f98bac4f5052bad2c26df9ad50f7019e40434512.1643265976.git.houwenlong.hwl@antgroup.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   virt/kvm/eventfd.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index c2323c27a28b5..518cd8dc390e2 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -451,8 +451,8 @@ bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
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
> @@ -468,8 +468,8 @@ void kvm_notify_acked_gsi(struct kvm *kvm, int gsi)
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

