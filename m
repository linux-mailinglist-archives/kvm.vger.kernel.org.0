Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232CA17024F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 16:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgBZPZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 10:25:54 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33873 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727311AbgBZPZy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Feb 2020 10:25:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582730753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U+z6Jmk37TO/JaUjHTxF02ZLLvook79vbYaUXiu4fF8=;
        b=DqeVtxPzVcynfs2Nt8sH24gD6GwxSS+qnfFFH9cnJsiWh/IQo5ZaH96U3mwm6sFMC2C3O6
        psyjIqFrf86daV7v0gbIUUveufJFtI1Bn3WurM/Dh9Dwe+Mve/BLSz4Lt4tYXvG22FeUWI
        iTrY43Lw1d4hDMKjqTyuq7TZPvVwxQE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-AmbUIj2nPpmizid_uCwHDw-1; Wed, 26 Feb 2020 10:25:36 -0500
X-MC-Unique: AmbUIj2nPpmizid_uCwHDw-1
Received: by mail-wm1-f70.google.com with SMTP id w3so777531wmg.4
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 07:25:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=U+z6Jmk37TO/JaUjHTxF02ZLLvook79vbYaUXiu4fF8=;
        b=p1K5UaWfi47COii2UlKq9AW7n80nlLRXS6v3oKh+ctqmbqZlC/gTRBwFsjPYDnPwlk
         7/d2XZms/IUPOynHGvJdPhUl6fueYe8g6ZnIVQp3pcuZhca0ANr+W9sV7Px4aabeXXfk
         lnCBNPIxtfDhIlqxK1srH87RWKwlFUYV3kN2Ej9C/UtFfrhWpb5BsULA/1mmXg41SODK
         3VA/Ez+13T5pL/H+D7+lMj95WThTbEMSP/znSBP1rXL/CfT7HUp2bVniY16J0Hu6E9uD
         /KVNWL6Wyb/El8kLxu8lNYcSxcPqwmGmrf7uqBUa7fBPsStsDHdK6t9cLovCwwS6Vrrh
         PODg==
X-Gm-Message-State: APjAAAW2GMmvlLVeKlQ0IY2zs1bYKcYshi4rO1Qk0iC6aHipBL9b9BsX
        aWWLP7ydFd+5QWtdmSOJON+cwrsjsF/ibWuvA7zE29sSxxYC2bQgBP3oUFKwtmzdxQKMUsDiqyZ
        eTDMxw1WbY23n
X-Received: by 2002:a7b:c152:: with SMTP id z18mr6060542wmi.70.1582730735616;
        Wed, 26 Feb 2020 07:25:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqwow62T9Dz43AXGv3wZglGVVzoT5IckHTRkmaSdRsxu4S9ICwu8weBpiLeEjtXHZGEBc5XURw==
X-Received: by 2002:a7b:c152:: with SMTP id z18mr6060530wmi.70.1582730735411;
        Wed, 26 Feb 2020 07:25:35 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n5sm3639043wrq.40.2020.02.26.07.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 07:25:34 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/13] KVM: x86: Refactor emulated exception injection to take the emul context
In-Reply-To: <20200218232953.5724-6-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com> <20200218232953.5724-6-sean.j.christopherson@intel.com>
Date:   Wed, 26 Feb 2020 16:25:34 +0100
Message-ID: <875zftjrpt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Invert the vcpu->context derivation in inject_emulated_exception() in
> preparation for dynamically allocating the emulation context.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 772e704e8083..79d1113ad6e7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6399,9 +6399,10 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
>  	}
>  }
>  
> -static bool inject_emulated_exception(struct kvm_vcpu *vcpu)
> +static bool inject_emulated_exception(struct x86_emulate_ctxt *ctxt)
>  {
> -	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> +
>  	if (ctxt->exception.vector == PF_VECTOR)
>  		return kvm_propagate_fault(vcpu, &ctxt->exception);
>  
> @@ -6806,7 +6807,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  				 */
>  				WARN_ON_ONCE(ctxt->exception.vector == UD_VECTOR ||
>  					     exception_type(ctxt->exception.vector) == EXCPT_TRAP);
> -				inject_emulated_exception(vcpu);
> +				inject_emulated_exception(ctxt);
>  				return 1;
>  			}
>  			return handle_emulation_failure(vcpu, emulation_type);
> @@ -6860,7 +6861,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  
>  	if (ctxt->have_exception) {
>  		r = 1;
> -		if (inject_emulated_exception(vcpu))
> +		if (inject_emulated_exception(ctxt))
>  			return r;
>  	} else if (vcpu->arch.pio.count) {
>  		if (!vcpu->arch.pio.in) {

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

