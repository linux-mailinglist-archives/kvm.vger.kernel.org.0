Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9C7C24B4
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 17:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbfI3Pzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 11:55:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbfI3Pzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 11:55:45 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C92BC04D293
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 15:55:44 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id m16so3983wmg.8
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 08:55:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+BD2ycFwWQSQrKNqGIpv6fduC0ZBdWw0d4zJAy9l8wA=;
        b=qMs0Rid5Kuaoci69aqBSN09XOIltdJVIjwG2usJZXFh4fpe9Rhn1k6xA7LvbE1smiU
         OCbR/picNCLywoKjuTgLf4DnnH2A0GnJ+tqdXi6QcNXaZObyWzBz6WcC8WmN5AO+sbI8
         3FZ4AJwDiHFbdYBOtJD8qP86mkbMMFDt5QJy81DFnIdYmXeZMfLb+Bxl13Qqb69EH3+y
         ZDehzRc6uJ9ZfCP2E8t0jES5wV8s7mGFcoz3kcRZmzK4J/Cxr0SyIzZj7rvaRFVUxXKx
         IL3RBxucWXVYlISUWTUJ8+J4Hcs7PHxnhe56dg5KQMOSaZmUX//iGNssMoT8iQlqu+eL
         N4UQ==
X-Gm-Message-State: APjAAAUBjHUMSETMxINJxdaUPKqfYx2SNM7dIrIom6Y2SEXu1qo+B1pv
        +SKYVuIRhYILmaDLovLNRZ9/TVgHit91AJTSd3go1n6AiXkVolhllvysB/44UO4hSJOvZVjiE8S
        7ALw0NRluSE7X
X-Received: by 2002:a1c:4946:: with SMTP id w67mr17840235wma.131.1569858943192;
        Mon, 30 Sep 2019 08:55:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqybxKRnfhyeednrZhdUQjOiY96vN6kardd7AnGk13SqJ/2yQMIotgeHWc21k6F9JFkOSvQkwA==
X-Received: by 2002:a1c:4946:: with SMTP id w67mr17840224wma.131.1569858942970;
        Mon, 30 Sep 2019 08:55:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x2sm17584453wrn.81.2019.09.30.08.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 08:55:42 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 4/8] KVM: VMX: Optimize vmx_set_rflags() for unrestricted guest
In-Reply-To: <20190930151945.GB14693@linux.intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com> <20190927214523.3376-5-sean.j.christopherson@intel.com> <87muem40wi.fsf@vitty.brq.redhat.com> <20190930151945.GB14693@linux.intel.com>
Date:   Mon, 30 Sep 2019 17:55:41 +0200
Message-ID: <87k19p3hj6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Sep 30, 2019 at 10:57:17AM +0200, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> 
>> > Rework vmx_set_rflags() to avoid the extra code need to handle emulation
>> > of real mode and invalid state when unrestricted guest is disabled.  The
>> > primary reason for doing so is to avoid the call to vmx_get_rflags(),
>> > which will incur a VMREAD when RFLAGS is not already available.  When
>> > running nested VMs, the majority of calls to vmx_set_rflags() will occur
>> > without an associated vmx_get_rflags(), i.e. when stuffing GUEST_RFLAGS
>> > during transitions between vmcs01 and vmcs02.
>> >
>> > Note, vmx_get_rflags() guarantees RFLAGS is marked available.
>> >
>> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> > ---
>> >  arch/x86/kvm/vmx/vmx.c | 28 ++++++++++++++++++----------
>> >  1 file changed, 18 insertions(+), 10 deletions(-)
>> >
>> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> > index 83fe8b02b732..814d3e6d0264 100644
>> > --- a/arch/x86/kvm/vmx/vmx.c
>> > +++ b/arch/x86/kvm/vmx/vmx.c
>> > @@ -1426,18 +1426,26 @@ unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
>> >  void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>> >  {
>> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>> > -	unsigned long old_rflags = vmx_get_rflags(vcpu);
>> > +	unsigned long old_rflags;
>> >  
>> > -	__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
>> > -	vmx->rflags = rflags;
>> > -	if (vmx->rmode.vm86_active) {
>> > -		vmx->rmode.save_rflags = rflags;
>> > -		rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
>> > +	if (enable_unrestricted_guest) {
>> > +		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
>> > +
>> > +		vmx->rflags = rflags;
>> > +		vmcs_writel(GUEST_RFLAGS, rflags);
>> > +	} else {
>> > +		old_rflags = vmx_get_rflags(vcpu);
>> > +
>> > +		vmx->rflags = rflags;
>> > +		if (vmx->rmode.vm86_active) {
>> > +			vmx->rmode.save_rflags = rflags;
>> > +			rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
>> > +		}
>> > +		vmcs_writel(GUEST_RFLAGS, rflags);
>> > +
>> > +		if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
>> > +			vmx->emulation_required = emulation_required(vcpu);
>> >  	}
>> > -	vmcs_writel(GUEST_RFLAGS, rflags);
>> 
>> We're doing vmcs_writel() in both branches so it could've stayed here, right?
>
> Yes, but the resulting code is a bit ugly.  emulation_required() consumes
> vmcs.GUEST_RFLAGS, i.e. the if statement that reads old_rflags would also
> need to be outside of the else{} case.  
>
> This isn't too bad:
>
> 	if (!enable_unrestricted_guest && 
> 	    ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM))
> 		vmx->emulation_required = emulation_required(vcpu);
>
> but gcc isn't smart enough to understand old_rflags won't be used if
> enable_unrestricted_guest, so old_rflags either needs to be tagged with
> uninitialized_var() or explicitly initialized in the if(){} case.
>
> Duplicating a small amount of code felt like the lesser of two evils.
>

I see, thanks for these additional details!

-- 
Vitaly
