Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B05B5101
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 17:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfIQPHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 11:07:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727962AbfIQPHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 11:07:22 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D9D6185540
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 15:07:21 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id 32so1414804wrk.15
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 08:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M2ROnRjQ6XpEbY6C1uWSxsB5sbZASsuQ60ehBi16Vdg=;
        b=jeoL+nLehqKw0OG5A71ZgX1Z6RJlhNR37igEtMB0DBMaF5g41BH7rm3bACjGUxMquZ
         t+JBFrJrDJcuRJ44fe6ZS7v2Qz48fbE/yKOPpBY2vUWi5g3/fG8SFZQaSsLSnGn6qAo9
         7gGq7fBxWDE04A+7PpAuO6O2eTDRuThNSMVvIx8FNkSatzMP4VrLjQRry49LcRDgpa+C
         SXQPb7jxbxSbK/jdqOsk9TIV5tYPZAPBPYYXhx/M455lEz1Q9TD6Tf90D1yu5BqMUiys
         lb08fwcDroRyaVHWjgVnPUKc3mh5ZO2bMJvNZIzwOaMvWvTzO0mukHmwQDZMwQKAaMM6
         PAXA==
X-Gm-Message-State: APjAAAWXUrxFCmFv0QozYUfHhiv4BJDN+WxRnfDkBjqxUxnx9gS23cgx
        A2kUHaz9ewcyttYsLSSxBk5oxq8q+erDDOA4JouWYKBgbJauqTXyjhwIUeGwEuzDxyFNRJibdXa
        OVDV7i1lLpGwx
X-Received: by 2002:a1c:4945:: with SMTP id w66mr3879982wma.40.1568732840417;
        Tue, 17 Sep 2019 08:07:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzfBL68muJMrD+6aSC2mEoAARgymHATsfuDq2EeQrj/3TNTzPyXY2MqroywfTD46hCjM2QDFA==
X-Received: by 2002:a1c:4945:: with SMTP id w66mr3879960wma.40.1568732840153;
        Tue, 17 Sep 2019 08:07:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id h17sm4388192wme.6.2019.09.17.08.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 08:07:19 -0700 (PDT)
Subject: Re: [PATCH v2 03/14] KVM: x86: Refactor kvm_vcpu_do_singlestep() to
 remove out param
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
 <20190827214040.18710-4-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4a49e819-08bf-7824-f6e1-2f37f2b1a4a4@redhat.com>
Date:   Tue, 17 Sep 2019 17:07:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190827214040.18710-4-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/19 23:40, Sean Christopherson wrote:
> Return the single-step emulation result directly instead of via an out
> param.  Presumably at some point in the past kvm_vcpu_do_singlestep()
> could be called with *r==EMULATE_USER_EXIT, but that is no longer the
> case, i.e. all callers are happy to overwrite their own return variable.

It was actually done for consistency with kvm_vcpu_check_breakpoint.
It's okay to change it.

Paolo

> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c6de5bc4fa5e..fe847f8eb947 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6377,7 +6377,7 @@ static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
>  	return dr6;
>  }
>  
> -static void kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu, int *r)
> +static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_run *kvm_run = vcpu->run;
>  
> @@ -6386,10 +6386,10 @@ static void kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu, int *r)
>  		kvm_run->debug.arch.pc = vcpu->arch.singlestep_rip;
>  		kvm_run->debug.arch.exception = DB_VECTOR;
>  		kvm_run->exit_reason = KVM_EXIT_DEBUG;
> -		*r = EMULATE_USER_EXIT;
> -	} else {
> -		kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);
> +		return EMULATE_USER_EXIT;
>  	}
> +	kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);
> +	return EMULATE_DONE;
>  }
>  
>  int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
> @@ -6410,7 +6410,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  	 * that sets the TF flag".
>  	 */
>  	if (unlikely(rflags & X86_EFLAGS_TF))
> -		kvm_vcpu_do_singlestep(vcpu, &r);
> +		r = kvm_vcpu_do_singlestep(vcpu);
>  	return r == EMULATE_DONE;
>  }
>  EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
> @@ -6613,7 +6613,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>  		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
>  		kvm_rip_write(vcpu, ctxt->eip);
>  		if (r == EMULATE_DONE && ctxt->tf)
> -			kvm_vcpu_do_singlestep(vcpu, &r);
> +			r = kvm_vcpu_do_singlestep(vcpu);
>  		if (!ctxt->have_exception ||
>  		    exception_type(ctxt->exception.vector) == EXCPT_TRAP)
>  			__kvm_set_rflags(vcpu, ctxt->eflags);
> 

