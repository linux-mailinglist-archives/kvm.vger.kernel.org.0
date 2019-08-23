Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73EC9AB46
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 11:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbfHWJYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 05:24:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33842 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730868AbfHWJYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 05:24:00 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 340B386668
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 09:24:00 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id k15so4533771wrw.18
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 02:24:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hcVR7FpzlOfLuA+3zYp3tlZljPrqrhIJeuvuUSrYtwk=;
        b=VttbEmtw+r7wPH6q1EsojlU4pt3FDoy6hOZqAdtct4tE3zhjTlOXKLWxyQz6RlphjP
         Cw9RdWjBwUMYlUkVoY8RA1Vo7F5s98YWLgxwJdVr0dBQQEMPYOs3GxETW9Lts8O/du4m
         dCcrqdvTYd137xpjgl4D+vzPJfwe3sl0hCNRshETQBvKeoIwxARHWySnL8U9tFdSQkWt
         TLJ/uO2lxSs2sR//IF2SDih5LO3P4jKFuqdKXl9bKkU+adpCLqmRDQ12hbPfGqM1veHe
         bRmTg4y77tRx6v/liQfGBg98hdmQNmU4t4gtky9hm3TtcD2H5wMphznlDqbjkU8s+0fD
         sFcA==
X-Gm-Message-State: APjAAAUWRxgQhiqo4moFk7tWyDY9hyOXftD0kpBUBoaPYy/MVhHT6y/Z
        E9rmjrqkvjOfYzuVrMNck37QMjTmDJX5t7J1CznMJLUgDvGZTSZlI5pCITzR1z3WXsIAvRib9kD
        C0VzEj7w/HGYT
X-Received: by 2002:adf:ea51:: with SMTP id j17mr4247431wrn.184.1566552238964;
        Fri, 23 Aug 2019 02:23:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzYqf4b3JLBFjXbtwI1PAc24WOpxRJRamvN7DOCq4zItdjMSIuewcjlLL1CC26yfkJwXCe8mA==
X-Received: by 2002:adf:ea51:: with SMTP id j17mr4247414wrn.184.1566552238757;
        Fri, 23 Aug 2019 02:23:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f17sm2173101wmj.27.2019.08.23.02.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 02:23:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [RESEND PATCH 02/13] KVM: x86: Clean up handle_emulation_failure()
In-Reply-To: <20190823010709.24879-3-sean.j.christopherson@intel.com>
References: <20190823010709.24879-1-sean.j.christopherson@intel.com> <20190823010709.24879-3-sean.j.christopherson@intel.com>
Date:   Fri, 23 Aug 2019 11:23:57 +0200
Message-ID: <87a7c0p74i.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> When handling emulation failure, return the emulation result directly
> instead of capturing it in a local variable.  Future patches will move
> additional cases into handle_emulation_failure(), clean up the cruft
> before so there isn't an ugly mix of setting a local variable and
> returning directly.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cd425f54096a..c6de5bc4fa5e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6207,24 +6207,22 @@ EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>  
>  static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  {
> -	int r = EMULATE_DONE;
> -
>  	++vcpu->stat.insn_emulation_fail;
>  	trace_kvm_emulate_insn_failed(vcpu);
>  
>  	if (emulation_type & EMULTYPE_NO_UD_ON_FAIL)
>  		return EMULATE_FAIL;
>  
> +	kvm_queue_exception(vcpu, UD_VECTOR);
> +
>  	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) {
>  		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
>  		vcpu->run->internal.ndata = 0;
> -		r = EMULATE_USER_EXIT;
> +		return EMULATE_USER_EXIT;
>  	}
>  
> -	kvm_queue_exception(vcpu, UD_VECTOR);
> -
> -	return r;
> +	return EMULATE_DONE;
>  }
>  
>  static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t cr2,

No functional change,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Just for self-education, what sane userspace is supposed to do when it
sees KVM_EXIT_INTERNAL_ERROR other than kill the guest? Why does it make
sense to still prepare to inject '#UD'?

-- 
Vitaly
