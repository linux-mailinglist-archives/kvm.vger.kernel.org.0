Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245753522F6
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 00:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhDAW4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 18:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbhDAW4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 18:56:11 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5728C0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 15:56:11 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j25so2490544pfe.2
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 15:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZTTgS3U28JACFf7bOON3o/EXQcrX2RuFhdzGfYRYroc=;
        b=tY5qBxY2DUXqPbQLNw6gCVq/u0kDRkwgTcdMmt9ByBsMDaRgyHBOJCZEykozzIsIj6
         pRadBCBnBG//S3AEUMZbqMOovaagVUzcL5IoXwPaefCBC9p7l1/mzla66n1Qyv0LGe3h
         YFw8+r3TJEiGF+cR+xr9mMgUrmqJtsS6WoOeYkmOsWJv7VJX7GJFvbi23NNMomMQkXMY
         usiZnrDiI1eBgFTGoeoUoHIIKm01pia6mMy+KTkpVDF1LOGEu0bDyCD3hieyamHd8fOH
         kqW0haXzowD4LTELobikYX29ZuW6BypXf4pF8G9VbZhtNF0UKTL9yTFH9TUphBFLo96F
         KrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZTTgS3U28JACFf7bOON3o/EXQcrX2RuFhdzGfYRYroc=;
        b=E+GoHNEzrU9OVuyW8S/cOEpGsvz/xib9GhAAptqNUmxelM5lOJ1487SI6pfS4EflXR
         s/HM6tQjdAJLn7TrSlpvH5kW3/4q73JopZ72yVN5BthAN9FnmjvoYHzndaE6qVZ4kcy9
         xPQtXtsGUP0YN5Xf/JsbxgR6eTb11bi3PSBX5oHS0kLufN9/C729w9wouu0xePG2CJep
         klXF21bqlpG2CZbY7m6G38hrqoHhM2MgH4Qon7W2RPkD3vcDphNktOrm2tsLXwdO50J1
         6CS0SE+21fiWY0BUp/8ejeIYPwR1ppQBXVFFpA6SMgQHP0lO4SeguPJik7Dx7cO5SIip
         mNrg==
X-Gm-Message-State: AOAM533olW/Vf6Ork9Cnpep6W6tumf7jO+81Hpztp+xGPMG7L0o899Ge
        GEq7U9Aw5HPUePeunUbrFLEROA==
X-Google-Smtp-Source: ABdhPJw4zb31BAWzNmtQ+kn86mj77dDS0dJB+7RYwW45A/mZ3N/bbP1toV7L4Yv69L+/sikeyYvXNQ==
X-Received: by 2002:a05:6a00:170c:b029:225:8851:5b3c with SMTP id h12-20020a056a00170cb029022588515b3cmr9612952pfc.0.1617317771076;
        Thu, 01 Apr 2021 15:56:11 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r9sm6331943pgg.12.2021.04.01.15.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 15:56:10 -0700 (PDT)
Date:   Thu, 1 Apr 2021 22:56:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 3/4] KVM: x86: correctly merge pending and injected
 exception
Message-ID: <YGZPhq9YI2m/OSBu@google.com>
References: <20210401143817.1030695-1-mlevitsk@redhat.com>
 <20210401143817.1030695-4-mlevitsk@redhat.com>
 <c4f06a75-412c-d546-9ce7-4bf4cc49d102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4f06a75-412c-d546-9ce7-4bf4cc49d102@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Paolo Bonzini wrote:
> On 01/04/21 16:38, Maxim Levitsky wrote:
> > +static int kvm_do_deliver_pending_exception(struct kvm_vcpu *vcpu)
> > +{
> > +	int class1, class2, ret;
> > +
> > +	/* try to deliver current pending exception as VM exit */
> > +	if (is_guest_mode(vcpu)) {
> > +		ret = kvm_x86_ops.nested_ops->deliver_exception_as_vmexit(vcpu);
> > +		if (ret || !vcpu->arch.pending_exception.valid)
> > +			return ret;
> > +	}
> > +
> > +	/* No injected exception, so just deliver the payload and inject it */
> > +	if (!vcpu->arch.injected_exception.valid) {
> > +		trace_kvm_inj_exception(vcpu->arch.pending_exception.nr,
> > +					vcpu->arch.pending_exception.has_error_code,
> > +					vcpu->arch.pending_exception.error_code);
> > +queue:
> 
> If you move the queue label to the top of the function, you can "goto queue" for #DF as well and you don't need to call kvm_do_deliver_pending_exception again.  In fact you can merge this function and kvm_deliver_pending_exception completely:
> 
> 
> static int kvm_deliver_pending_exception_as_vmexit(struct kvm_vcpu *vcpu)
> {
> 	WARN_ON(!vcpu->arch.pending_exception.valid);
> 	if (is_guest_mode(vcpu))
> 		return kvm_x86_ops.nested_ops->deliver_exception_as_vmexit(vcpu);
> 	else
> 		return 0;
> }
> 
> static int kvm_merge_injected_exception(struct kvm_vcpu *vcpu)
> {
> 	/*
> 	 * First check if the pending exception takes precedence
> 	 * over the injected one, which will be reported in the
> 	 * vmexit info.
> 	 */
> 	ret = kvm_deliver_pending_exception_as_vmexit(vcpu);
> 	if (ret || !vcpu->arch.pending_exception.valid)
> 		return ret;
> 
> 	if (vcpu->arch.injected_exception.nr == DF_VECTOR) {
> 		...
> 		return 0;
> 	}
> 	...
> 	if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
> 	    || (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
> 		...
> 	}
> 	vcpu->arch.injected_exception.valid = false;
> }
> 
> static int kvm_deliver_pending_exception(struct kvm_vcpu *vcpu)
> {
> 	if (!vcpu->arch.pending_exception.valid)
> 		return 0;
> 
> 	if (vcpu->arch.injected_exception.valid)
> 		kvm_merge_injected_exception(vcpu);
> 
> 	ret = kvm_deliver_pending_exception_as_vmexit(vcpu));
> 	if (ret || !vcpu->arch.pending_exception.valid)

I really don't like querying arch.pending_exception.valid to see if the exception
was morphed to a VM-Exit.  I also find kvm_deliver_pending_exception_as_vmexit()
to be misleading; to me, that reads as being a command, i.e. "deliver this
pending exception as a VM-Exit".

It' also be nice to make the helpers closer to pure functions, i.e. pass the
exception as a param instead of pulling it from vcpu->arch.

Now that we have static_call, the number of calls into vendor code isn't a huge
issue.  Moving nested_run_pending to arch code would help, too.  What about
doing something like:

static bool kvm_l1_wants_exception_vmexit(struct kvm_vcpu *vcpu, u8 vector)
{
	return is_guest_mode(vcpu) && kvm_x86_l1_wants_exception(vcpu, vector);
}

	...

	if (!kvm_x86_exception_allowed(vcpu))
		return -EBUSY;

	if (kvm_l1_wants_exception_vmexit(vcpu, vcpu->arch...))
		return kvm_x86_deliver_exception_as_vmexit(...);

> 		return ret;
> 
> 	trace_kvm_inj_exception(vcpu->arch.pending_exception.nr,
> 				vcpu->arch.pending_exception.has_error_code,
> 				vcpu->arch.pending_exception.error_code);
> 	...
> }
> 
