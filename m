Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF021BF99C
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 15:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgD3NeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 09:34:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41271 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726577AbgD3NeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 09:34:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588253652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L25mv4WATkCBD6beOc1gHUKVW8B48wx+KY4Q0xxB/bg=;
        b=YmTEFhiTjoViIVGkCPiLAIWQw4qoomGHvjVanx/CaDT0brVTb6MNDvhDvGTf5J/xrI6tjg
        sKITS3Z+BQygdZhWt+PvUCKXznpfgmgFdOdyawF0TuHAlfm7mZBcmODc0BaFbq1CI8jCGR
        t4ma9Gl4DOvtz41yhR7mvLTVnn9nQ5I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-b3iax9lRM6CbGgisYcEHDQ-1; Thu, 30 Apr 2020 09:34:11 -0400
X-MC-Unique: b3iax9lRM6CbGgisYcEHDQ-1
Received: by mail-wm1-f70.google.com with SMTP id q5so859443wmc.9
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 06:34:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=L25mv4WATkCBD6beOc1gHUKVW8B48wx+KY4Q0xxB/bg=;
        b=dR0Gz0tq+/D0xcteCVhdj2ZmM5yBvzRchTxvpa6uAK7eTQzE5kAauY6keVRRPxH8Pu
         DZ2cCe5CB1PxF4GRxih45uYH9DJCRFmr07/jGS9BopjX09uWeq+l5V00qVd3irmAHsRU
         hYbClrRgukfSF5++nc6C778o5YJXOzCax07Ra6ykTaxKFFXaR3gQcIwmTs0bTUZOSHT5
         RHM1Lyzqq0nIS7aezb/mkU3ICKdRTCuNofJ/llfo9HNZ9JFIhOtk4/z7AJdv8/rnlX0d
         zj13hAIik4ziYsELYPI734WL6aYLh+yTgBUMt9EyWVpLU90UZFf48N+OqomvBdUTt/In
         9CUA==
X-Gm-Message-State: AGi0Puao1kjO1CmHZUWhVflRctLzAxFFT8+W82g+8VfZmWbBvAxHG4jE
        5tUJYM1rNiTH86DSjoWwZhA1teYDCFQhDPb4YWg5sThlP3DMocp1Yhi9d46rJP/71/rNyeZi+qM
        COOlHmjWTvT9+
X-Received: by 2002:a7b:c642:: with SMTP id q2mr3140495wmk.41.1588253649884;
        Thu, 30 Apr 2020 06:34:09 -0700 (PDT)
X-Google-Smtp-Source: APiQypJIOuyRTQjX2rQXDMTUkV88W2CMXJaf4hJDpw+3HtN0UnU7BvUQ/GKjLOpDu69QLHFb+aC+uw==
X-Received: by 2002:a7b:c642:: with SMTP id q2mr3140465wmk.41.1588253649651;
        Thu, 30 Apr 2020 06:34:09 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v7sm11562227wmg.3.2020.04.30.06.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 06:34:08 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v4 2/7] KVM: X86: Enable fastpath when APICv is enabled
In-Reply-To: <1588055009-12677-3-git-send-email-wanpengli@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com> <1588055009-12677-3-git-send-email-wanpengli@tencent.com>
Date:   Thu, 30 Apr 2020 15:34:06 +0200
Message-ID: <87a72tf67l.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> We can't observe benefit from single target IPI fastpath when APICv is
> disabled, let's just enable IPI and Timer fastpath when APICv is enabled
> for now.
>
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Haiwei Li <lihaiwei@tencent.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/svm/svm.c | 2 +-
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8f8fc65..1e7220e 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3344,7 +3344,7 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
>  
>  static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>  {
> -	if (!is_guest_mode(vcpu) &&
> +	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active &&
>  	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
>  	    to_svm(vcpu)->vmcb->control.exit_info_1)
>  		return handle_fastpath_set_msr_irqoff(vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9b5adb4..f207004 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6585,7 +6585,7 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
>  
>  static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>  {
> -	if (!is_guest_mode(vcpu)) {
> +	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active) {
>  		switch (to_vmx(vcpu)->exit_reason) {
>  		case EXIT_REASON_MSR_WRITE:
>  			return handle_fastpath_set_msr_irqoff(vcpu);

I think that apicv_active checks are specific to APIC MSRs but
handle_fastpath_set_msr_irqoff() can handle any other MSR as well. I'd
suggest to move the check inside handle_fastpath_set_msr_irqoff().

Also, enabling Hyper-V SynIC leads to disabling apicv. It it still
pointless to keep fastpath enabled?

-- 
Vitaly

