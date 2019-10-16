Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 685D8D9836
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 19:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393811AbfJPRHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 13:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47784 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388559AbfJPRHB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 13:07:01 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A238B87642
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 17:07:00 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id c188so1226405wmd.9
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 10:07:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gs7j7P97MguiwVXLFd4gwkovHtcAde4RLohzpgnXT0M=;
        b=lmF1EIuWSt59T4NRWKD0cY79U9m4/NldpFEB1l7F3pXYEEcl/CTs1qPGudfqpzwfuB
         3mcYLVHf+FXRsUHTW1fLj5+ep9kydsIF+Ir5tixiqszi/wbMmQ0peufSmwuIEaR/DKb4
         5wrQnni2xKOpZXE5a4Kqhxu+4QInyjKzKtzlT0UNQXdXQ4qLVDQKFoooDKgDQ9Jxkoww
         f52lfy1jgEZEvSzepIYZLepX7OCryV+S4RXhDd1xGxH72k2TydtIgxXrEtPYmvFeDL+A
         oTRE+6FgguyjM9Q6pSE1Hh/F8vZqe0F9f6nhDSfBgpTcKiUcdQM3wrgJykq+Kp1U2sDM
         dDgQ==
X-Gm-Message-State: APjAAAXPl1JBhJtDxxrKzI22qNwHhA4/7OH6juBZnfy3z/VLffiZMKyx
        GsRrqs7DRz1xcAFriXDC7QCutQblh8NfWyWrj3nFwLuwHS1/LBCmhBKBEUuNyG0A4EDpUS1VYii
        ChynScaJUtFbO
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr4584938wma.44.1571245618959;
        Wed, 16 Oct 2019 10:06:58 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyTOPCffn6fos0yiy5ZNrUHWqJEU8VeKDXOXKziUzRHJm9s4opmF4QO5ABHTLAraHwRok8b9A==
X-Received: by 2002:a05:600c:2503:: with SMTP id d3mr4584913wma.44.1571245618706;
        Wed, 16 Oct 2019 10:06:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id e18sm35106204wrv.63.2019.10.16.10.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 10:06:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     suleiman@google.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: clear kvmclock MSR on reset
In-Reply-To: <1570704617-32285-1-git-send-email-pbonzini@redhat.com>
References: <1570704617-32285-1-git-send-email-pbonzini@redhat.com>
Date:   Wed, 16 Oct 2019 19:06:57 +0200
Message-ID: <87wod439hq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> After resetting the vCPU, the kvmclock MSR keeps the previous value but it is
> not enabled.  This can be confusing, so fix it.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f26f8be4e621..a55252c69118 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2533,6 +2533,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  static void kvmclock_reset(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.pv_time_enabled = false;
> +	vcpu->arch.time = 0;
>  }
>  
>  static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
> @@ -2698,8 +2699,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_KVM_SYSTEM_TIME: {
>  		struct kvm_arch *ka = &vcpu->kvm->arch;
>  
> -		kvmclock_reset(vcpu);
> -
>  		if (vcpu->vcpu_id == 0 && !msr_info->host_initiated) {
>  			bool tmp = (msr == MSR_KVM_SYSTEM_TIME);
>  
> @@ -2713,14 +2712,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
>  
>  		/* we verify if the enable bit is set... */
> +		vcpu->arch.pv_time_enabled = false;
>  		if (!(data & 1))
>  			break;
>  
>  		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
>  		     &vcpu->arch.pv_time, data & ~1ULL,
>  		     sizeof(struct pvclock_vcpu_time_info)))
> -			vcpu->arch.pv_time_enabled = false;
> -		else
>  			vcpu->arch.pv_time_enabled = true;

Hm, are you sure you didn't want to write !kvm_gfn_to_hva_cache_init()?

>  
>  		break;

-- 
Vitaly
