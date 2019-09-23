Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7388BBB17A
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 11:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407211AbfIWJcD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 05:32:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407150AbfIWJcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 05:32:02 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E3BE9C049E10
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 09:32:01 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id r187so7132551wme.0
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 02:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fIlK0Gqa2EqqMHp7X2xV9H/eOYI2l6FvewEZP+gEe0w=;
        b=CAKjAuWXbAdxypMoWu5ulYNELc88OSEXqnXhKY0rV5UuX/ypoF+EWquxma+r8KoLkz
         eRQiYptnB3Tb7CcqshVn1hxmNoPONG+RYLpIgIuDOyxAYrEUIf8g3mq0UQ7ILR5oz08y
         Bs+oSnL5OIn1PnWjJjTRXRwnJsORmyZHb1gQBpNa5lMdRDc15LnJdlBVwQCssXOpIvoC
         oVMYoVHN+B5+1G8pxL2j0tvyZWJ+Qw0GNOVw5x65G5p6E65GnJU0WJ4I4g/DAgG3wkA6
         5s9JjaIeCYIu0INav4Vsf1nuhDW1BE0SjOf5zmsTiNQikLyD1icXceTOgY9uRco1kFeA
         h0aA==
X-Gm-Message-State: APjAAAU1/rf2GqMujdy7MAXZxQqo0+EvPWdCcCGclMR0YSjfzmYOWauG
        mxOrjQwMX34XEMOLIIXF0EebOkZJmGOhEn2baI09eCcTP0mApxWc+q6f3ZYVlcrGutuJXNsSHfH
        YvJukHyOyVw8f
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr20552621wrs.146.1569231120669;
        Mon, 23 Sep 2019 02:32:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzSooD5cgGEoyLBTWPsXxrIrfqpCoWXBwb0C/X63O8YHe+RdRAExbsbPZ1BRXwFPWpIKgMBhQ==
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr20552599wrs.146.1569231120397;
        Mon, 23 Sep 2019 02:32:00 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x5sm19529043wrg.69.2019.09.23.02.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 02:31:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from vmx.c exit handlers
In-Reply-To: <20190920212509.2578-16-aarcange@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com> <20190920212509.2578-16-aarcange@redhat.com>
Date:   Mon, 23 Sep 2019 11:31:58 +0200
Message-ID: <87o8zb8ik1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andrea Arcangeli <aarcange@redhat.com> writes:

> It's enough to check the exit value and issue a direct call to avoid
> the retpoline for all the common vmexit reasons.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a6e597025011..9aa73e216df2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5866,9 +5866,29 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (exit_reason < kvm_vmx_max_exit_handlers
> -	    && kvm_vmx_exit_handlers[exit_reason])
> +	    && kvm_vmx_exit_handlers[exit_reason]) {
> +#ifdef CONFIG_RETPOLINE
> +		if (exit_reason == EXIT_REASON_MSR_WRITE)
> +			return handle_wrmsr(vcpu);
> +		else if (exit_reason == EXIT_REASON_PREEMPTION_TIMER)
> +			return handle_preemption_timer(vcpu);
> +		else if (exit_reason == EXIT_REASON_PENDING_INTERRUPT)
> +			return handle_interrupt_window(vcpu);
> +		else if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
> +			return handle_external_interrupt(vcpu);
> +		else if (exit_reason == EXIT_REASON_HLT)
> +			return handle_halt(vcpu);
> +		else if (exit_reason == EXIT_REASON_PAUSE_INSTRUCTION)
> +			return handle_pause(vcpu);
> +		else if (exit_reason == EXIT_REASON_MSR_READ)
> +			return handle_rdmsr(vcpu);
> +		else if (exit_reason == EXIT_REASON_CPUID)
> +			return handle_cpuid(vcpu);
> +		else if (exit_reason == EXIT_REASON_EPT_MISCONFIG)
> +			return handle_ept_misconfig(vcpu);
> +#endif
>  		return kvm_vmx_exit_handlers[exit_reason](vcpu);

I agree with the identified set of most common vmexits, however, this
still looks a bit random. Would it be too much if we get rid of
kvm_vmx_exit_handlers completely replacing this code with one switch()?

> -	else {
> +	} else {
>  		vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
>  				exit_reason);
>  		dump_vmcs();

-- 
Vitaly
