Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED21DC1D83
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 10:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbfI3I5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 04:57:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727845AbfI3I5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 04:57:21 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8528658
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 08:57:20 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id v18so4195201wro.16
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 01:57:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=UcGS+56mom6fO6gLbiJPlRBT9sCimqwfenBjQlqeMP8=;
        b=PCdf28YiuvfDbuRfEvQaRtT4NislMiLpWpdXGmr3Yl/goP9bm9LynB+cUaGM619l+u
         2i+F8GQIcfaQaRY3+6kPOnBXYHuG+H+LUT38vi8666osAzthcZcRZeWA7pNGxF4O8/UR
         oh6lK8mMIxgo4rj0mrJXUrLHEq+j/c4JF0LJoTr+XAImd2WJdwvv5Qdv+VMEzqJXyXyv
         w4rgXrr/nk4Q397xOi6ht9osfYwMY2bhwXsVNLdlfzX4gBJfc9NylCo26sDiEQ22mSc6
         U7CGkrKJAfMgBxK7lbhHuqQ2xIpPb6ik29v7DmQRE5bqjY+dJC9wXC16c8dENjJKMQpW
         8asg==
X-Gm-Message-State: APjAAAWaD7VdsDcjQVinC/X5y7R3KQARXKJWxY7AQdaSwXnWKdaOE+ix
        wtc2e+6L7VXtTT4DVf9RGwWtZS1RgqYSo71zJLRZGZ0Ukm8/7ObnR8knMwgkfcdBZ71l4o54ITi
        PtthL0xMCX+V9
X-Received: by 2002:a5d:43d0:: with SMTP id v16mr12498641wrr.390.1569833839155;
        Mon, 30 Sep 2019 01:57:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyqL/jNuwbLiXJECMuYDQFS2oi5pGvfRx0tVhTeQLsW0ZtP4yOYtHzkJVvLfzz5xWcWat0nuQ==
X-Received: by 2002:a5d:43d0:: with SMTP id v16mr12498621wrr.390.1569833838927;
        Mon, 30 Sep 2019 01:57:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a14sm16815711wmm.44.2019.09.30.01.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 01:57:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 4/8] KVM: VMX: Optimize vmx_set_rflags() for unrestricted guest
In-Reply-To: <20190927214523.3376-5-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com> <20190927214523.3376-5-sean.j.christopherson@intel.com>
Date:   Mon, 30 Sep 2019 10:57:17 +0200
Message-ID: <87muem40wi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Rework vmx_set_rflags() to avoid the extra code need to handle emulation
> of real mode and invalid state when unrestricted guest is disabled.  The
> primary reason for doing so is to avoid the call to vmx_get_rflags(),
> which will incur a VMREAD when RFLAGS is not already available.  When
> running nested VMs, the majority of calls to vmx_set_rflags() will occur
> without an associated vmx_get_rflags(), i.e. when stuffing GUEST_RFLAGS
> during transitions between vmcs01 and vmcs02.
>
> Note, vmx_get_rflags() guarantees RFLAGS is marked available.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 28 ++++++++++++++++++----------
>  1 file changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 83fe8b02b732..814d3e6d0264 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1426,18 +1426,26 @@ unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
>  void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	unsigned long old_rflags = vmx_get_rflags(vcpu);
> +	unsigned long old_rflags;
>  
> -	__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
> -	vmx->rflags = rflags;
> -	if (vmx->rmode.vm86_active) {
> -		vmx->rmode.save_rflags = rflags;
> -		rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
> +	if (enable_unrestricted_guest) {
> +		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
> +
> +		vmx->rflags = rflags;
> +		vmcs_writel(GUEST_RFLAGS, rflags);
> +	} else {
> +		old_rflags = vmx_get_rflags(vcpu);
> +
> +		vmx->rflags = rflags;
> +		if (vmx->rmode.vm86_active) {
> +			vmx->rmode.save_rflags = rflags;
> +			rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
> +		}
> +		vmcs_writel(GUEST_RFLAGS, rflags);
> +
> +		if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
> +			vmx->emulation_required = emulation_required(vcpu);
>  	}
> -	vmcs_writel(GUEST_RFLAGS, rflags);

We're doing vmcs_writel() in both branches so it could've stayed here, right?

> -
> -	if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
> -		vmx->emulation_required = emulation_required(vcpu);
>  }
>  
>  u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly
