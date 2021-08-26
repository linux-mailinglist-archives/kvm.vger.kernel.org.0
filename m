Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9EA3F8C06
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 18:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243083AbhHZQYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 12:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243072AbhHZQYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 12:24:21 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DA7C0613C1
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 09:23:34 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 17so3532248pgp.4
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 09:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cr6/zwxvFT060RSzezsHpgYecFKnegANyyYpx1rGGgk=;
        b=uNY4uwBlkIObxedN9T7czrSSQ8+WkGVy+7iyGhT2QeDpnuklcKX8rriKe6JkwQHEYH
         R5RSvD+JfWj31OFDSZKcDqvcxL2bk12TnP46mH9tDqW2f4FPJTA/idWD1Fha49Mzkwz7
         GkmSMPGe4APTTk4wRDKtLy0qWKpzUkE2cwMy6eBLQ7VuxvUQ+o9cPxgAV0xb6zh+ow3t
         D6e4jkzKEpeKRgqP7Dvz8aEK9Kj599LEZEhdBA+TsMPsgqXralkZnR/sNlmchcSYX0Y8
         nG5Ai0koCXynnxG62A8FxxdvewBzzD79RJ/wT5Zhtq+zBd1ujr5ctcYwq8Re4A3yPgjA
         DJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cr6/zwxvFT060RSzezsHpgYecFKnegANyyYpx1rGGgk=;
        b=gZS7b3ugcxkC0yBiJeHd3di6wUYTpZTWi9VxIedw58nEwSTVfIzoZckv7N9dAQnW2K
         EZnNnxL2gf9a5c97aO9luj/INhF3vPnhx6BKjCv9T2j4XKBDLHgQqGSWHf6G9Sm1e50+
         PQ/qYIHrg+W/5f9IpmLw602IE+x6VoAgYfiszP14leo0e3B4JdOdKWSqAzUTex7vdzSl
         brPNawU8DPhF49U6397p0UEOZYL8lQHOsy3b5znzfeR028+30PMEVHzp/y0UxdgRzo6e
         TieQyMsHk6cDGqF1mLWgI7C2Gnr+SvP+GaeD3Mqm5SssNj6IU0SORGiwaH1WqOGEAguJ
         /M8w==
X-Gm-Message-State: AOAM532tzcaQ0VluASsovE1Cq+e0f1GOwbx7PJBJYtrgzG03kv37+hGN
        N7GqBfqOOZwEFMcIo8DxJQkwjQ==
X-Google-Smtp-Source: ABdhPJzgUzoqaXbTLoNg7TkATbYE+7I5G/QVg9ZvB+a0/4dCbtt4U8oj73oQ/a1uhyE3aXxUmUkyWQ==
X-Received: by 2002:a62:b414:0:b029:32e:3ef0:7735 with SMTP id h20-20020a62b4140000b029032e3ef07735mr4451329pfn.61.1629995013329;
        Thu, 26 Aug 2021 09:23:33 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w14sm163145pge.40.2021.08.26.09.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 09:23:32 -0700 (PDT)
Date:   Thu, 26 Aug 2021 16:23:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] VMX: nSVM: enter protected mode prior to returning
 to nested guest from SMM
Message-ID: <YSfAAYN/Ng/L1IMa@google.com>
References: <20210826095750.1650467-1-mlevitsk@redhat.com>
 <20210826095750.1650467-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826095750.1650467-3-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021, Maxim Levitsky wrote:
> SMM return code switches CPU to real mode, and
> then the nested_vmx_enter_non_root_mode first switches to vmcs02,
> and then restores CR0 in the KVM register cache.
> 
> Unfortunately when it restores the CR0, this enables the protection mode
> which leads us to "restore" the segment registers from
> "real mode segment cache", which is not up to date vs L2 and trips
> 'vmx_guest_state_valid check' later, when the
> unrestricted guest mode is not enabled.

I suspect this is slightly inaccurate.  When loading vmcs02, vmx_switch_vmcs()
will do vmx_register_cache_reset(), which also causes the segment cache to be
reset.  enter_pmode() will still load stale values, but they'll come from vmcs02,
not KVM's segment register cache.

> This happens to work otherwise, because after we enter the nested guest,
> we restore its register state again from SMRAM with correct values
> and that includes the segment values.
> 
> As a workaround to this if we enter protected mode first,
> then setting CR0 won't cause this damage.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0c2c0d5ae873..805c415494cf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7507,6 +7507,13 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  	}
>  
>  	if (vmx->nested.smm.guest_mode) {
> +
> +		/*
> +		 * Enter protected mode to avoid clobbering L2's segment
> +		 * registers during nested guest entry
> +		 */
> +		vmx_set_cr0(vcpu, vcpu->arch.cr0 | X86_CR0_PE);

I'd really, really, reaaaally like to avoid stuffing state.  All of the instances
I've come across where KVM has stuffed state for something like this were just
papering over one symptom of an underlying bug.

For example, won't this now cause the same bad behavior if L2 is in Real Mode?

Is the problem purely that emulation_required is stale?  If so, how is it stale?
Every segment write as part of RSM emulation should reevaluate emulation_required
via vmx_set_segment().

Oooooh, or are you talking about the explicit vmx_guest_state_valid() in prepare_vmcs02()?
If that's the case, then we likely should skip that check entirely.  The only part
I'm not 100% clear on is whether or not it can/should be skipped for vmx_set_nested_state().

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..20bd84554c1f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2547,7 +2547,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
         * which means L1 attempted VMEntry to L2 with invalid state.
         * Fail the VMEntry.
         */
-       if (CC(!vmx_guest_state_valid(vcpu))) {
+       if (from_vmentry && CC(!vmx_guest_state_valid(vcpu))) {
                *entry_failure_code = ENTRY_FAIL_DEFAULT;
                return -EINVAL;
        }


If we want to retain the check for the common vmx_set_nested_state() path, i.e.
when the vCPU is truly being restored to guest mode, then we can simply exempt
the smm.guest_mode case (which also exempts that case when its set via
vmx_set_nested_state()).  The argument would be that RSM is going to restore L2
state, so whatever happens to be in vmcs12/vmcs02 is stale.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..ac30ba6a8592 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2547,7 +2547,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
         * which means L1 attempted VMEntry to L2 with invalid state.
         * Fail the VMEntry.
         */
-       if (CC(!vmx_guest_state_valid(vcpu))) {
+       if (!vmx->nested.smm.guest_mode && CC(!vmx_guest_state_valid(vcpu))) {
                *entry_failure_code = ENTRY_FAIL_DEFAULT;
                return -EINVAL;
        }
