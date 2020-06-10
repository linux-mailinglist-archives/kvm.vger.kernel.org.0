Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB951F57CE
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 17:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgFJP12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 11:27:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29890 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730178AbgFJP11 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 11:27:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591802846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jjvIRHOCxQwRkhqk1V3wNjs78W+1JFnbVDcZpT/Uz1M=;
        b=HZ8e2nEToP3qFCSHhjqh+G+E5chPfMdcamIB+yxhW2bYgMdWrCFCwiyNpHteoi+urdgkcU
        e653gDpiQXwSzyBKAPE6faodynn6z8TXDAlujc3g9sft01Obg9TcVsnLJ2lpG8rZ57HaCi
        aWzDL00CyN8GDF9d3vCsoa1EPGlaIOU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-XzEScm3rPK2fW7Y7Y4v6Og-1; Wed, 10 Jun 2020 11:27:24 -0400
X-MC-Unique: XzEScm3rPK2fW7Y7Y4v6Og-1
Received: by mail-wr1-f70.google.com with SMTP id h6so1243311wrx.4
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 08:27:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jjvIRHOCxQwRkhqk1V3wNjs78W+1JFnbVDcZpT/Uz1M=;
        b=do8kQMNqKa4p/kXEAryIMh/4g5yELdH7Fn2M+Z6BKRHNJ5AfW1sHcGcxOFcT4POPB5
         bswq3ZhRm5IKsGlvmTN2UxnBE29LgNcz0Z0S3zGyPkeBbT5UIyW3+qCH/sd1XkjsUz3o
         LKy4bf6oxqXPMOjYjOOit/pce5281HD5ehw1o/5Bmgb7Y2XprGUXRnBsxtLKCeibpDYp
         jsXY5tp/ZBWMyE/ICtTo92/O6uIy/ilAcTnFA4SXWwUABFYAQOwNjur2KmrcqrYgqJUx
         l68HmidHmf4trekv3/waJIxjKY4KMU/m1A1rcnDQuERz/9Yj3Lb5jVP93dZDEVJ4I6+W
         RyPA==
X-Gm-Message-State: AOAM530CbYq3Fepcc1zlkm8putOfETe0iWY5Y2tigbvfttetKR9hGleW
        G+/1sc+JCunC4eVcmUu4JBGBafpL+Po9DhWb4SHs6UzoB1mFh2O0Om7OzIyKGzPuNQYktGcm1DQ
        rT29jJ5Ud4Ky1
X-Received: by 2002:adf:ab09:: with SMTP id q9mr4235966wrc.79.1591802843364;
        Wed, 10 Jun 2020 08:27:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbXFK9zAEzr9CiGFdxkngWHkdza78QVqblrUuo5Ya87D9rMSPYEpvNBknfprfCSRj30DMcMA==
X-Received: by 2002:adf:ab09:: with SMTP id q9mr4235926wrc.79.1591802843123;
        Wed, 10 Jun 2020 08:27:23 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.134.4])
        by smtp.gmail.com with ESMTPSA id f185sm48624wmf.43.2020.06.10.08.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 08:27:22 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: x86: respect singlestep when emulating
 instruction
To:     Felipe Franciosi <felipe@nutanix.com>
Cc:     kvm@vger.kernel.org, stable@vger.kernel.org
References: <20200519081048.8204-1-felipe@nutanix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cfcd5d5f-eb3e-f6ec-2e28-c48750c1d7b5@redhat.com>
Date:   Wed, 10 Jun 2020 17:27:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200519081048.8204-1-felipe@nutanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/20 10:11, Felipe Franciosi wrote:
> When userspace configures KVM_GUESTDBG_SINGLESTEP, KVM will manage the
> presence of X86_EFLAGS_TF via kvm_set/get_rflags on vcpus. The actual
> rflag bit is therefore hidden from callers.
> 
> That includes init_emulate_ctxt() which uses the value returned from
> kvm_get_flags() to set ctxt->tf. As a result, x86_emulate_instruction()
> will skip a single step, leaving singlestep_rip stale and not returning
> to userspace.
> 
> This resolves the issue by observing the vcpu guest_debug configuration
> alongside ctxt->tf in x86_emulate_instruction(), performing the single
> step if set.
> 
> Signed-off-by: Felipe Franciosi <felipe@nutanix.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c17e6eb9ad43..64cb183636da 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6919,7 +6919,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		if (!ctxt->have_exception ||
>  		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
>  			kvm_rip_write(vcpu, ctxt->eip);
> -			if (r && ctxt->tf)
> +			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
>  				r = kvm_vcpu_do_singlestep(vcpu);
>  			if (kvm_x86_ops.update_emulated_instruction)
>  				kvm_x86_ops.update_emulated_instruction(vcpu);
> 

Queued, thanks.

Paolo

