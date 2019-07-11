Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC9B657B4
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 15:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbfGKNKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 09:10:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39359 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfGKNKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 09:10:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so6235298wrt.6
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 06:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FiuN+XnDBBJITQMQwf721aloUuk3Jn7a7n9skSDHh3I=;
        b=UlEkGrceCH/hufgSdi68bCUv6KBOu3Xjqihh9TrUtygGhMM1nB2H8CALwGbGqI8l8r
         htyEcYyyeNqLkO4JklMPJ9SYNV0z8yEvyXBu46UGx+s8WlZCPsMRU89p2OGsLeTYPaaK
         TNK7aW2GD3f5+SjBCIBvmduvbu/W1CGUWCSfhK1H4/lL0CN/jAaKzlk7g7PSZ7No5rN9
         u0wJdOmUghly/Sdd568vy/goxuLUtIi27ml/zepkO3qxOEsRE53YLSDmtCyoR4fzEfCb
         n8dMDK43X9C8L0erxTPUmjumc7ZO4n3msXPoq4lkGCcin7eAt8txMWJBAWARQ327N9bZ
         M1jg==
X-Gm-Message-State: APjAAAUDdID2QnnMmzk39SUsNg7f8wxJYu6wp7kWTKtXhYbHvWZdywnm
        OucHfbyLD85aDmslHV/PEPKr6A==
X-Google-Smtp-Source: APXvYqxR7Qh8r2I/zLG2QckJQkHLE0Nhlz0gBvURrcfXGKww/cBfc35JJNT6YivGCKlTf2PvRRWS0A==
X-Received: by 2002:a05:6000:11c6:: with SMTP id i6mr326246wrx.193.1562850635448;
        Thu, 11 Jul 2019 06:10:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id v5sm5268773wre.50.2019.07.11.06.10.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 06:10:34 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Unconditionally enable irqs in guest context
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Wei Yang <w90p710@gmail.com>
References: <20190710160734.4559-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4a15b4aa-53ba-8625-95fa-294969e2a35a@redhat.com>
Date:   Thu, 11 Jul 2019 15:10:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710160734.4559-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/19 18:07, Sean Christopherson wrote:
> On VMX, KVM currently does not re-enable irqs until after it has exited
> the guest context.  As a result, a tick that fires in the window between
> VM-Exit and guest_exit_irqoff() will be accounted as system time.  While
> said window is relatively small, it's large enough to be problematic in
> some configurations, e.g. if VM-Exits are consistently occurring a hair
> earlier than the tick irq.
> 
> Intentionally toggle irqs back off so that guest_exit_irqoff() can be
> used in lieu of guest_exit() in order to avoid the save/restore of flags
> in guest_exit().  On my Haswell system, "nop; cli; sti" is ~6 cycles,
> versus ~28 cycles for "pushf; pop <reg>; cli; push <reg>; popf".
> 
> Fixes: f2485b3e0c6c0 ("KVM: x86: use guest_exit_irqoff")
> Reported-by: Wei Yang <w90p710@gmail.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/svm.c | 10 +---------
>  arch/x86/kvm/x86.c | 11 +++++++++++
>  2 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 5270711e787f..98b848fcf3e3 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6184,15 +6184,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
>  
>  static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  {
> -	kvm_before_interrupt(vcpu);
> -	local_irq_enable();
> -	/*
> -	 * We must have an instruction with interrupts enabled, so
> -	 * the timer interrupt isn't delayed by the interrupt shadow.
> -	 */
> -	asm("nop");
> -	local_irq_disable();
> -	kvm_after_interrupt(vcpu);
> +
>  }
>  
>  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2e302e977dac..32561032f7e6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8042,7 +8042,18 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	kvm_x86_ops->handle_exit_irqoff(vcpu);
>  
> +	/*
> +	 * Consume any pending interrupts, including the possible source of
> +	 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
> +	 * An instruction is required after local_irq_enable() to fully unblock
> +	 * interrupts on processors that implement an interrupt shadow, the
> +	 * stat.exits increment will do nicely.
> +	 */
> +	kvm_before_interrupt(vcpu);
> +	local_irq_enable();
>  	++vcpu->stat.exits;
> +	local_irq_disable();
> +	kvm_after_interrupt(vcpu);
>  
>  	guest_exit_irqoff();
>  	if (lapic_in_kernel(vcpu)) {
> 

Queued, thanks.

Paolo
