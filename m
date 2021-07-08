Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241C13C1785
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 18:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhGHQ7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 12:59:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229469AbhGHQ7W (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 12:59:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625763400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8zOv/MDfEWcH9s0zWRUnQQNA4xFdmSTmuagPnlN1tB8=;
        b=bjHx1/WJo87LgGxoipNOzW0CG5a/I/XjDZdTiY+pHjrPCyHT3jI4ruRYMZDq5ONaA6leL0
        T8sKZB70L0Ecl0dQBm9NmVPCeqlO8iGKapIh42VbCc9z0HRzJrAziltZ/9F62DpFW8TB8w
        xaAhEwQki70pOthdUS1lTtz/CUePdBg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-bqT-sPcMNq-S1m9sr0uhpw-1; Thu, 08 Jul 2021 12:56:39 -0400
X-MC-Unique: bqT-sPcMNq-S1m9sr0uhpw-1
Received: by mail-wr1-f69.google.com with SMTP id p4-20020a5d63840000b0290126f2836a61so2219191wru.6
        for <kvm@vger.kernel.org>; Thu, 08 Jul 2021 09:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8zOv/MDfEWcH9s0zWRUnQQNA4xFdmSTmuagPnlN1tB8=;
        b=dtkEwtGA3fnLCyDA5oEgCER4fIU0k1SAk17I/pJK2lqaWexN8vURIApydjgkZyNoHd
         Izj4ty40oA33tSJZ1f8zJHU7gr51ovf23FrZDKX0aOzuRB3RwIAo/taouC6F5g/Q7th1
         g6L4FEFERSdaLGqKPpvMpHTMczriW0SLTSiuJoaMfZhNJ2imaiy7chIlZkRNnL4lVDsp
         TTM3rpKQXiR/7MZafkE1LA5FBL4gYDJPclIXT/H2FQ7CN40P2/NhUhi/zZ5994tK8WXW
         yZ2fbWVt53nRWz/lS5kxDHejug+nweFdoFKKFzChpzuDgQWGSgccJ9nltmcreyK6WZy/
         ElMw==
X-Gm-Message-State: AOAM533llcMjtpXY4hNoOqR+a3xTO2HxktmRjXbb+CzhklZwTJQ2S0/Q
        rDovyWp3hUAuuES8M5MMcuUzRoXM4WQRP9U0PdHC5RaWji2AMSJH5MWL3sZekPLTjIk4jkgbbyP
        +5KckGGoq98YAQSU6OBaPgjavPkddpEjbdBa/qTDD/yPcMl3+dIX/3mhKtr8wh0ah
X-Received: by 2002:a17:907:ea5:: with SMTP id ho37mr31944257ejc.109.1625762903219;
        Thu, 08 Jul 2021 09:48:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3a5F1wHTH5P/QRmbTxUMdjhRN2uE1z7VdPPF6Jl7c6aaYv8oJSi/bC2ELxd8i4zc3tObZCg==
X-Received: by 2002:a17:907:ea5:: with SMTP id ho37mr31944235ejc.109.1625762903030;
        Thu, 08 Jul 2021 09:48:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g17sm1552964edb.37.2021.07.08.09.48.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 09:48:22 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Also reload the debug registers before
 kvm_x86->run() when the host is using them
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
References: <20210628172632.81029-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <46e0aaf1-b7cd-288f-e4be-ac59aa04908f@redhat.com>
Date:   Thu, 8 Jul 2021 18:48:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628172632.81029-1-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/06/21 19:26, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> When the host is using debug registers but the guest is not using them
> nor is the guest in guest-debug state, the kvm code does not reset
> the host debug registers before kvm_x86->run().  Rather, it relies on
> the hardware vmentry instruction to automatically reset the dr7 registers
> which ensures that the host breakpoints do not affect the guest.
> 
> But there are still problems:
> 	o The addresses of the host breakpoints can leak into the guest
> 	  and the guest may use these information to attack the host.

I don't think this is true, because DRn reads would exit (if they don't, 
switch_db_regs would be nonzero).  But otherwise it makes sense to do at 
least the DR7 write, and we might as well do all of them.

> 	o It violates the non-instrumentable nature around VM entry and
> 	  exit.  For example, when a host breakpoint is set on
> 	  vcpu->arch.cr2, #DB will hit aftr kvm_guest_enter_irqoff().
> 
> Beside the problems, the logic is not consistent either. When the guest
> debug registers are active, the host breakpoints are reset before
> kvm_x86->run(). But when the guest debug registers are inactive, the
> host breakpoints are delayed to be disabled.  The host tracing tools may
> see different results depending on there is any guest running or not.

More precisely, the host tracing tools may see different results 
depending on what the guest is doing.

Queued (with fixed commit message), thanks!

Paolo

> To fix the problems, we also reload the debug registers before
> kvm_x86->run() when the host is using them whenever the guest is using
> them or not.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/x86.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b594275d49b5..cce316655d3c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9320,7 +9320,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	if (test_thread_flag(TIF_NEED_FPU_LOAD))
>   		switch_fpu_return();
>   
> -	if (unlikely(vcpu->arch.switch_db_regs)) {
> +	if (unlikely(vcpu->arch.switch_db_regs || hw_breakpoint_active())) {
>   		set_debugreg(0, 7);
>   		set_debugreg(vcpu->arch.eff_db[0], 0);
>   		set_debugreg(vcpu->arch.eff_db[1], 1);
> 

