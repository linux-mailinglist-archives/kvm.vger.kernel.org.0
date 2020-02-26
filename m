Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300121706A8
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 18:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgBZRwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 12:52:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21656 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726875AbgBZRwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 12:52:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582739542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/RdTTd6K7JTQ5wyPAoL2rrTSkPB95hn/2+5eY5OdPYc=;
        b=gxPJggkxBGVtVhJpz/wY2egC/0/wBStibEFoZKnb/OHViVG8vCjiEPAUDi2naR2LIKpFvp
        Yol08pmnoX5jCiR8/xwThpn8dFg2usV5o/MBVC5sj3b2ikfDwaHXi3eeUjWeTjRlgpjSPw
        uwEF/jw5tVDjnUs2BDZCpT3MXNUFhzU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-R4Lm9WQFNAuhhPSpQcc4yg-1; Wed, 26 Feb 2020 12:52:18 -0500
X-MC-Unique: R4Lm9WQFNAuhhPSpQcc4yg-1
Received: by mail-wm1-f69.google.com with SMTP id r19so1022wmh.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 09:52:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/RdTTd6K7JTQ5wyPAoL2rrTSkPB95hn/2+5eY5OdPYc=;
        b=VLe9jyCehIuDAUSH/cTXaT/EKAyXbYnwlNlHeaOsAyCyoaNLYbmwV7L+hEQ13xeg+b
         ePAFsimZoUi66sGStGHYo5Sptjp4HUNxMwGwWhl+j2ym3Ld/lRbz+Ba6GNc7g45KrQLe
         Tl9UtBvczX5AyLmdmrSbUUamvVazaF62W+KSnw4mimsKhITicYA4Qtql5+Aa2rY/IW7G
         sQQs7TUPeLGLe/VEDVH5QWBZmj4hDtHM20nRnIz3/R555FVxdg1CZ0MYbkSp2gzZyKG1
         EdoCrYl74QRd0HEllSwhYhQH2IRBLhBsHGVmBaaluF6OQxfqhCW5Ostx7XGcXutBeXfW
         cFFA==
X-Gm-Message-State: APjAAAXLoJNU73lC/RQR0ue6WnhMja97zM4/3ijTT2YzZZHKpQU4uhaa
        PruRg2GHL5hrrTvjcwf9r7GU8HCgYHHa7bZTnzLKv/oKqZBq0UUD7kLYR3JvOrgd3twPuOMp4Ct
        FZNfOYJd22ONB
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr36871wmi.51.1582739537225;
        Wed, 26 Feb 2020 09:52:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqz8ppifS6KUqwVMO25OvROjuof04E1Nq3/ZOCz+8OkVlU7zGHWWPvWAptHeVlGwliFuK37uyQ==
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr36795wmi.51.1582739536070;
        Wed, 26 Feb 2020 09:52:16 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h3sm4383322wrb.23.2020.02.26.09.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:52:15 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 11/13] KVM: x86: Add helper to "handle" internal emulation error
In-Reply-To: <20200218232953.5724-12-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com> <20200218232953.5724-12-sean.j.christopherson@intel.com>
Date:   Wed, 26 Feb 2020 18:52:14 +0100
Message-ID: <87o8tli6cx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Add a helper to set the appropriate error codes in vcpu->run when
> emulation fails (future patches will add additional failure scenarios).
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 32 ++++++++++++++------------------
>  1 file changed, 14 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e1eaca65756b..7bffdc6f9e1b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6491,6 +6491,14 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>  
> +static int internal_emulation_error(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +	vcpu->run->internal.ndata = 0;
> +	return 0;
> +}
> +
>  static int handle_emulation_failure(struct x86_emulate_ctxt *ctxt,
>  				    int emulation_type)
>  {
> @@ -6504,21 +6512,13 @@ static int handle_emulation_failure(struct x86_emulate_ctxt *ctxt,
>  		return 1;
>  	}
>  
> -	if (emulation_type & EMULTYPE_SKIP) {
> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -		vcpu->run->internal.ndata = 0;
> -		return 0;
> -	}
> +	if (emulation_type & EMULTYPE_SKIP)
> +		return internal_emulation_error(vcpu);
>  
>  	kvm_queue_exception(vcpu, UD_VECTOR);
>  
> -	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) {
> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -		vcpu->run->internal.ndata = 0;
> -		return 0;
> -	}
> +	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0)
> +		return internal_emulation_error(vcpu);
>  
>  	return 1;
>  }
> @@ -8986,12 +8986,8 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
>  
>  	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
>  				   has_error_code, error_code);
> -	if (ret) {
> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -		vcpu->run->internal.ndata = 0;
> -		return 0;
> -	}
> +	if (ret)
> +		return internal_emulation_error(vcpu);
>  
>  	kvm_rip_write(vcpu, ctxt->eip);
>  	kvm_set_rflags(vcpu, ctxt->eflags);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

