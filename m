Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DC1262AA6
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgIIIl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:41:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22252 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725975AbgIIIlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 04:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599640913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T36t7fQZrvyiAzT5j5Q2jRiJ36nfS5YR20jv9iVoAto=;
        b=TO8o1zkqOAPz7lusmAiR3Eqq4BLkai6FkVarSKwOeH1C3L0TUaRrUIgQ3Niy3YC6EE6M1F
        r0yBnQt0EKNXEBQ2lVGOkTQXX6+WZUsbovuys5Rhq3aUGNM0AQ2bZNB+Ahi5lBoV+tKL41
        5HFQMUZ6dHar338IMd5a4RZGTrF/F+c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-yHzLGypeMRmMXe0uRurhMA-1; Wed, 09 Sep 2020 04:41:52 -0400
X-MC-Unique: yHzLGypeMRmMXe0uRurhMA-1
Received: by mail-wm1-f72.google.com with SMTP id b14so578408wmj.3
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 01:41:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=T36t7fQZrvyiAzT5j5Q2jRiJ36nfS5YR20jv9iVoAto=;
        b=Is8JdtLnugW2fzw/Ui94fGBYePvB56brddq57Roh10y2kd/OjWqsQ29O/Q5uDEL9UH
         O+f83DQ30fBWcL9fvnmsB2EHq21P33nMXzbhCjvRPVKXL1v/Mz0zHRhLbZTc5YZexKBz
         DDy1tbL+AFg+WvKXr0tNTSQisfCF8KkphFt8VpksoihSILNBzwjbiQCLdNtfeG+MTQol
         5tiHS9CrqY8RaW6P+w4u3Z9DNw4VCs1OtQjggSQTIczfDRINY2KgUYfEORypDdAhO0yS
         WfQzDbadpTuG1rsn9pcvcOFnDgkG9xAKH7dZOzn9axnCp6g/si49kCCCw2oUk+6G0gKQ
         NFEw==
X-Gm-Message-State: AOAM532rdL1g7PcG4P0QV+0WS3WOmgXlBHmfpoXb9sHkk2ox73jgxh5m
        i+fCH1W+xbEl9bQ/Kqg68E661iScCptfVtPzuW+nw9qIjamoMR0oVfDSz8TN4YewXXVx5Q5MS2X
        EQC9aX+/LRXMq
X-Received: by 2002:a05:600c:252:: with SMTP id 18mr2275263wmj.63.1599640910872;
        Wed, 09 Sep 2020 01:41:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlN5J94Y8BYA6qYXY7wIIaOrIgJb7mS6rfcMp2Fpo44YIPTD6vwynEu5UzWqHoGtXWhNv+2Q==
X-Received: by 2002:a05:600c:252:: with SMTP id 18mr2275246wmj.63.1599640910690;
        Wed, 09 Sep 2020 01:41:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l10sm2827473wmh.27.2020.09.09.01.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:41:49 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
Subject: Re: [PATCH 3/3] KVM: SVM: Reenable handle_fastpath_set_msr_irqoff() after complete_interrupts()
In-Reply-To: <1599620139-13019-1-git-send-email-wanpengli@tencent.com>
References: <1599620139-13019-1-git-send-email-wanpengli@tencent.com>
Date:   Wed, 09 Sep 2020 10:41:48 +0200
Message-ID: <87blifmjeb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> Moving the call to svm_exit_handlers_fastpath() after svm_complete_interrupts() 
> since svm_complete_interrupts() consumes rip and reenable the function 
> handle_fastpath_set_msr_irqoff() call in svm_exit_handlers_fastpath().
>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Paul K. <kronenpj@kronenpj.dyndns.org>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/svm/svm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 74bcf0a..ac819f0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3347,6 +3347,11 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>  
>  static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>  {
> +	if (!is_guest_mode(vcpu) &&
> +	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
> +	    to_svm(vcpu)->vmcb->control.exit_info_1)
> +		return handle_fastpath_set_msr_irqoff(vcpu);
> +
>  	return EXIT_FASTPATH_NONE;
>  }
>  
> @@ -3495,7 +3500,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	stgi();
>  
>  	/* Any pending NMI will happen here */
> -	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
>  
>  	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>  		kvm_after_interrupt(&svm->vcpu);
> @@ -3529,6 +3533,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  		svm_handle_mce(svm);
>  
>  	svm_complete_interrupts(svm);
> +	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
>  
>  	vmcb_mark_all_clean(svm->vmcb);
>  	return exit_fastpath;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

