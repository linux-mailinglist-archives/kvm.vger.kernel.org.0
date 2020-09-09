Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8335B262A27
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgIIIX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:23:29 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23847 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbgIIIX0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Sep 2020 04:23:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599639804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ipg+kGRxf4wxWeQOhvAJYTIzegDq0gtF7D+pA4396Qw=;
        b=hye34L+gA6pRupUUmu0wORcHDDnfHuPyyhSkc/7vgNzOm001FvlwV9kK8tltHtDeT8E6z7
        3iRSvsPmMQTHum5xHoEZ8CP4Mfm3WL987XCvo0ktDMvE8Mv0wfy3fT99IWy9qArjpNOej8
        0e44kih1xtZ+Lyun7K80DH+8/WjpvnI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-jTmYJEzEM46RqodakfVvJQ-1; Wed, 09 Sep 2020 04:23:23 -0400
X-MC-Unique: jTmYJEzEM46RqodakfVvJQ-1
Received: by mail-wr1-f70.google.com with SMTP id r15so681915wrt.8
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 01:23:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ipg+kGRxf4wxWeQOhvAJYTIzegDq0gtF7D+pA4396Qw=;
        b=I82121XNzudXQDO1bBiUtDxsgW5lxaHYYON9Qq4X7wHsR9GRyPtM4PoxjS+iVip/E7
         tbhDNgZuHjYEOGxkn7ykATx/L3nMDJVFgM4cjRZVCZOb/u9k3CAcu6f+CTpFOBRHgz1F
         cdoLnwy8EToLaWtNjjBQTQRuDQqrlZfJ8zbyp6obhUXwoeuF8kbo+dB+8CZcP7Ip12MG
         y2GfKFW1LbirbJMKAdwvApmCx7YxNnys5ctpqjdCKYek//nZTKtoJsnoFzpG2G4qxdvz
         /daevpu0IYDu7pwL/d9aXLVpTctQRZTR5g60MZKQPgdzLpfBrO579+tMfH/TFrYli4Ca
         X4MQ==
X-Gm-Message-State: AOAM5332QDe0l6NoWP/ZeBmv98ulIMqqwKJMdAC9UnnZ8AL3LedumWHC
        241MiSJlhB4klYbs/hMAeNc4hVJfe4/aMhUmy376EHR6eNrEUxVjjhi1sYDPQnsFYDXSz2UnGih
        n/wXesuJt/t7G
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr2493835wmm.38.1599639801896;
        Wed, 09 Sep 2020 01:23:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxe4nQzns/RJMYzARqqL49tYar+YFQfC6QojwjzqbtuqOGYc6Q3M7yHZV1wTiTye79EV4m7mA==
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr2493821wmm.38.1599639801726;
        Wed, 09 Sep 2020 01:23:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m3sm3246714wme.31.2020.09.09.01.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:23:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: SVM: Get rid of handle_fastpath_set_msr_irqoff()
In-Reply-To: <1599620043-12908-1-git-send-email-wanpengli@tencent.com>
References: <1599620043-12908-1-git-send-email-wanpengli@tencent.com>
Date:   Wed, 09 Sep 2020 10:23:20 +0200
Message-ID: <87h7s7mk93.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Analysis from Sean:
>
>  | svm->next_rip is reset in svm_vcpu_run() only after calling 
>  | svm_exit_handlers_fastpath(), which will cause SVM's 
>  | skip_emulated_instruction() to write a stale RIP.
>  

This should only happen when svm->vmcb->control.next_rip is not set by
hardware as skip_emulated_instruction() itself sets 'svm->next_rip'
otherwise, right?

> Let's get rid of handle_fastpath_set_msr_irqoff() in svm_exit_handlers_fastpath()
> to have a quick fix.

which in the light of the whole seeries seems to be appropriate, so:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

>
> Reported-by: Paul K. <kronenpj@kronenpj.dyndns.org>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paul K. <kronenpj@kronenpj.dyndns.org>
> Cc: <stable@vger.kernel.org> # v5.8-rc1+
> Fixes: 404d5d7bff0d (KVM: X86: Introduce more exit_fastpath_completion enum values)
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/svm/svm.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 19e622a..c61bc3b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3349,11 +3349,6 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>  
>  static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>  {
> -	if (!is_guest_mode(vcpu) &&
> -	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
> -	    to_svm(vcpu)->vmcb->control.exit_info_1)
> -		return handle_fastpath_set_msr_irqoff(vcpu);
> -
>  	return EXIT_FASTPATH_NONE;
>  }

-- 
Vitaly

