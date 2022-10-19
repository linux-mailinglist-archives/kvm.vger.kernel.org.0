Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B4B605246
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 23:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiJSVxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 17:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiJSVxa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 17:53:30 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3A01946DF
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:53:25 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o21so16106588ple.5
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 14:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LmQWrSQW0LKNFVqDHiPaFtM2LkOlxWeMwLtjmwHy94w=;
        b=IuypjP5jcyXG/slqTu8xmJdF3cD3A/OCZGFN3AAV8/MRYRuRNzz6CNtouHsa/s8EyR
         oQq0Co6YvQmYtHIX5BzccsSjkcYLkQFPveA1WpPwU+qxIRvj4EhBo0wzRY8G/15ySc8J
         w4ddB/qOMIr7MIAgr+zEtFfjDAnDJNppacPH4s9T2+I84xVjDwX/Z1lLK64+hfSp80fS
         hmlqOUF/fryzRn+43DiI9dXHx8N5Ce+uB7PFei2koH8vpzvBa6Nv/u8V5ro5Xk8WeIVA
         1B+FdtgGnDFNdrDCqtPVLkN1xkBAHP+yH9LeP0RA6RUIupBXxrTz0yXlANaaVorw9VSc
         Q3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LmQWrSQW0LKNFVqDHiPaFtM2LkOlxWeMwLtjmwHy94w=;
        b=CmadzdBj8pQ5gE3aY7lXXJ8ebNfXlLRCMqd4Rvj/2ZXBU79kUREas7RgKmnIrVyOs0
         NrD6JrAgyjgF6Bl1bdFM3fGDkJoo5WbX9A4vXFOXA+vh4BNUNEhOiwHZBpQPBLkXlU/l
         wdokSQLnlOGe2N0EJGjMKlhB1t5a3+LVKstexvPaFdWwgbDdoJvFp5lOA3sucpZoGAtC
         E7ToMZWa/XotC1pYJKZgdPRzo4E4QW9OLaY8a4BITXACBrRj/Ep0wbJ3l1hhltDOli+m
         u5xfnjhfD/u2aGqY6FxJeuP6+wHzFMoEfmGPqEu5jd0+p22ArLRWqhEGB9bEeitqxjjJ
         cJng==
X-Gm-Message-State: ACrzQf2K7kDqfxMRCqymzCIyYiZeagmYi3RjkKAKw+KtcGwMD9+7Bh0R
        PLkYxozBXLdVCoHiR/JSwCMKDA==
X-Google-Smtp-Source: AMsMyM459mr2eY9FFIVjlDHVsoahUeZtu9o7sfweH5GReFMu6DRjAYJDPBY7Bf4gxCXmitfURxuxng==
X-Received: by 2002:a17:90a:f190:b0:20a:a8b1:b199 with SMTP id bv16-20020a17090af19000b0020aa8b1b199mr48297286pjb.83.1666216404723;
        Wed, 19 Oct 2022 14:53:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n30-20020aa7985e000000b00562a36c0b32sm11832847pfq.119.2022.10.19.14.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 14:53:24 -0700 (PDT)
Date:   Wed, 19 Oct 2022 21:53:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 23/46] KVM: x86: hyper-v: L2 TLB flush
Message-ID: <Y1Bx0SZY3IlWKY+T@google.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
 <20221004123956.188909-24-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004123956.188909-24-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022, Vitaly Kuznetsov wrote:
> @@ -2225,10 +2264,27 @@ static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
>  
>  static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
>  {
> +	int ret;
> +
>  	trace_kvm_hv_hypercall_done(result);
>  	kvm_hv_hypercall_set_result(vcpu, result);
>  	++vcpu->stat.hypercalls;
> -	return kvm_skip_emulated_instruction(vcpu);
> +	ret = kvm_skip_emulated_instruction(vcpu);
> +
> +	if (unlikely(hv_result_success(result) && is_guest_mode(vcpu)
> +		     && kvm_hv_is_tlb_flush_hcall(vcpu))) {

"&&" goes on the previous line.

> +		struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +		u32 tlb_lock_count;
> +
> +		if (unlikely(kvm_read_guest(vcpu->kvm, hv_vcpu->nested.pa_page_gpa,

Nit, I'd say leave off the "unlikely", the hints almost never provide meaningful
performance benefits, e.g. code generation is identical with and without the
unlikely, and IMO the extra line length and parantheses depth makes the code
harder to read.

> +					    &tlb_lock_count, sizeof(tlb_lock_count))))
> +			kvm_inject_gp(vcpu, 0);

This will inject a #GP on the _next_ instruction.  That seems wrong.  And why #GP
in the first place?  E.g. if userspace yanks out the memslot, injecting #GP into
the guest is less-than-ideal behavior. 

What about reading tlb_lock_count before skipping the hypercall, e.g.

static int kvm_hv_hypercall_complete(struct kvm_vcpu *vcpu, u64 result)
{
	u32 tlb_lock_count = 0;
	int ret;

	if (hv_result_success(result) && is_guest_mode(vcpu) &&
	    kvm_hv_is_tlb_flush_hcall(vcpu) &&
	    kvm_read_guest(vcpu->kvm, to_hv_vcpu(vcpu)->nested.pa_page_gpa,
			   &tlb_lock_count, sizeof(tlb_lock_count)))
		result = HV_STATUS_INVALID_HYPERCALL_INPUT;

	trace_kvm_hv_hypercall_done(result);
	kvm_hv_hypercall_set_result(vcpu, result);
	++vcpu->stat.hypercalls;

	ret = kvm_skip_emulated_instruction(vcpu);

	if (tlb_lock_count)
		kvm_x86_ops.nested_ops->hv_inject_synthetic_vmexit_post_tlb_flush(vcpu);

	return ret;
}

> +
> +		if (tlb_lock_count)

tlb_lock_count will be uninitialized if kvm_read_guest() fails.

> +			kvm_x86_ops.nested_ops->hv_inject_synthetic_vmexit_post_tlb_flush(vcpu);

Ugh, kvm_skip_emulated_instruction() is flawed.  If skipping the emulated instruction
fails, i.e. if EMULTYPE_SKIP emulation fails, then synthesizing a VM-Exit is
technically wrong.  But kvm_skip_emulated_instruction() also returns '0' for a
KVM_EXIT_DEBUG, which happens after skipping the instruction.

Not worth handling here, e.g. nested_svm_vmrun() has the same "bug".  Failure is
effectively limited to old AMD CPUs, and userspace is likely goiing to kill the
VM anyways.
