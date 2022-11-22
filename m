Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4126340DC
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiKVQFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbiKVQFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:05:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3014F399
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ex5aAmkYWdXhcvqwK9J+B9+pLZO8eR1z7ZNRkzKKtGU=;
        b=f8Keew045Jo9EnauNE8Zb1nOHciSQgQ0JjTVenJRenzFjCBeYVJ1FEu8IPuP5cNCxN9U+W
        TkhIRXDzAqsZJuv9oUzrj+ZGk6+xbeXaAoTSsf04/MTaeSxXpvYNhkqhvMt5O9mMLtMVgR
        Rp+MRO/0mhYrRP8WXKI1IOoazXJ486w=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-157-KB5KW4U-PJ-F4h8GZtrldg-1; Tue, 22 Nov 2022 11:04:27 -0500
X-MC-Unique: KB5KW4U-PJ-F4h8GZtrldg-1
Received: by mail-ej1-f69.google.com with SMTP id hq18-20020a1709073f1200b007ade8dd3494so8374457ejc.2
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:04:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ex5aAmkYWdXhcvqwK9J+B9+pLZO8eR1z7ZNRkzKKtGU=;
        b=Pw7zdLpozJY1pbd8L8e3/+kskbCSoJLX5Rp9tmcFCUWnl1msv5dCugBTHTO+icStAI
         HX1VxFxny8slMBFhJGTRHSKtRtVxoDzdCIyETTtTTZj2FGtunH6tqlDW/5lebvsvL/x5
         ZAZH0tVgyx5VfbY7maDIa5i/lO/eWlOAyN/qJM8cR0muDcplkpK0i26DiR3yh8FDbkdL
         fBCmoYkC1+xWGS0f4OMA2QFTVDYQ2l2XfGCYlhjRE+qJHBBdFCAdPRgvOxFNvl0tacFo
         vZ/BjoXvFvVK4z6tP74N1NBZgqL9NU/w3TUpxeyRhJH6C0S/fzfxL5NpJ0/GWbffQmDS
         9XwQ==
X-Gm-Message-State: ANoB5plHZCMrZ7cXzstLm7o2oEabc84zv/0RbjPLkIDJ52RsStTmYdv1
        mAqv7HJK8d9EdOCEUk+wTeraUL3CpShlotTSmA9lTccMVtoPPTjeRvC3XNrkIQJBL8k++RZaNBi
        21enFb3OWilQm
X-Received: by 2002:a17:906:2d49:b0:7ae:16a9:e4d7 with SMTP id e9-20020a1709062d4900b007ae16a9e4d7mr19977077eji.574.1669133066291;
        Tue, 22 Nov 2022 08:04:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6NfJfbfBssy5H5hJkYlPqp+XhG5mueCLLcFmgHVT5HpbCNMGTWZf9upo2bZUmrFMOYOvgaKA==
X-Received: by 2002:a17:906:2d49:b0:7ae:16a9:e4d7 with SMTP id e9-20020a1709062d4900b007ae16a9e4d7mr19977061eji.574.1669133066078;
        Tue, 22 Nov 2022 08:04:26 -0800 (PST)
Received: from ovpn-194-185.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id et8-20020a056402378800b00463bc1ddc76sm6468737edb.28.2022.11.22.08.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 08:04:25 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Subject: Re: [PATCH v2 1/6] KVM: x86: hyper-v: Use common code for hypercall
 userspace exit
In-Reply-To: <20221121234026.3037083-2-vipinsh@google.com>
References: <20221121234026.3037083-1-vipinsh@google.com>
 <20221121234026.3037083-2-vipinsh@google.com>
Date:   Tue, 22 Nov 2022 17:04:24 +0100
Message-ID: <87edtvou0n.fsf@ovpn-194-185.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vipin Sharma <vipinsh@google.com> writes:

> Remove duplicate code to exit to userspace for hyper-v hypercalls and
> use a common place to exit.
>

"No functional change intended." as it was suggested by Sean :-)

> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/hyperv.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 2c7f2a26421e..0b6964ed2e66 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2503,14 +2503,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> -		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> -		vcpu->run->hyperv.u.hcall.input = hc.param;
> -		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
> -		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
> -		vcpu->arch.complete_userspace_io =
> -				kvm_hv_hypercall_complete_userspace;
> -		return 0;
> +		goto hypercall_userspace_exit;
>  	case HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST:
>  		if (unlikely(hc.var_cnt)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> @@ -2569,14 +2562,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  			ret = HV_STATUS_OPERATION_DENIED;
>  			break;
>  		}
> -		vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> -		vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> -		vcpu->run->hyperv.u.hcall.input = hc.param;
> -		vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
> -		vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
> -		vcpu->arch.complete_userspace_io =
> -				kvm_hv_hypercall_complete_userspace;
> -		return 0;
> +		goto hypercall_userspace_exit;
>  	}
>  	default:
>  		ret = HV_STATUS_INVALID_HYPERCALL_CODE;
> @@ -2585,6 +2571,15 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  
>  hypercall_complete:
>  	return kvm_hv_hypercall_complete(vcpu, ret);
> +
> +hypercall_userspace_exit:
> +	vcpu->run->exit_reason = KVM_EXIT_HYPERV;
> +	vcpu->run->hyperv.type = KVM_EXIT_HYPERV_HCALL;
> +	vcpu->run->hyperv.u.hcall.input = hc.param;
> +	vcpu->run->hyperv.u.hcall.params[0] = hc.ingpa;
> +	vcpu->run->hyperv.u.hcall.params[1] = hc.outgpa;
> +	vcpu->arch.complete_userspace_io = kvm_hv_hypercall_complete_userspace;
> +	return 0;
>  }
>  
>  void kvm_hv_init_vm(struct kvm *kvm)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

