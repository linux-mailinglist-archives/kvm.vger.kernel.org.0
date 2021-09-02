Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685693FF351
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 20:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347041AbhIBSki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhIBSkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:40:37 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A88C061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 11:39:38 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id r13so2345763pff.7
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 11:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9mAuR07OfJtECJWZylMyQMHOfdpdyw9F5Bfyp/4I0Fs=;
        b=h51hmAcrxCY+OGzq8Gpj6/9Yl65jFqtCezp7R/OkM30OeH8UEYe/BQVn6LRCg9lP6z
         CgqINfkgupRKGWlA9a79I+FCECGxz+NSn8xcDjILXnntFUgLXDBNAi8rz/SK5LLgIT6k
         6DHjGNI/IcKN13c1IMTRLqdTvol5yjDsVSyxJXbOYbTJKauL+r7pf48kaZnZQcBPvfl9
         2l6+7LZmbDlHMROXLBPJgykKLAMUnJGC+xkqHhTTkHo39LN9XUFsxxd7bheXOTyzulME
         lOFMjSy6J6CBU1l5icvYXzyonlfveSl9xoTg81HPE6AfgDlJp/7O9fFcb/vHVo9/leHt
         DnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9mAuR07OfJtECJWZylMyQMHOfdpdyw9F5Bfyp/4I0Fs=;
        b=ikCRuiprPGcaBUAPQMH5axRqk8mJB/GbckYL26urBqP+IOm1wxJPGrJLGF6W2/kRNg
         8jOdombQbK4ZEtiqItqrFwR4W7yARRmMhwJCojIuMPrmbY3iKtUriXeErXkrxuU5d4T5
         5KpV094mxFAXI2b22ShoJ+CyaLvUkAnvN5pNHNiogL3gLEjgtPrlbFaWW0qsqJYaPgbe
         SSY0D+PUXjT+F0+2GzMkj9xtdkgYLgQBenP8nX8lzMlwmq/jcQRW2EXYTAL7CT3q3faB
         XV0+87d2TdNfQ42C29NbcZgDCCVB8l3Fh05aGQ7qUAOt1S5Lg8DwHcA5NJu3lMCrCBVs
         Mylw==
X-Gm-Message-State: AOAM532w9yWGgOOD7BlOW8wHe6se+ISNxoA/Isy/IbSBip23dh+yacbP
        ey9qJHkbwuaFmXPokmP7bmsuaQ==
X-Google-Smtp-Source: ABdhPJxIZp0aOCRkqfN3ew+CA1Ki3cu/Zx38LyC3RZHYa4MM78qK+lyZz0Dsir5Z+8WivY0brF/uGA==
X-Received: by 2002:a63:4622:: with SMTP id t34mr4614406pga.293.1630607977806;
        Thu, 02 Sep 2021 11:39:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l12sm3376784pgc.41.2021.09.02.11.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 11:39:37 -0700 (PDT)
Date:   Thu, 2 Sep 2021 18:39:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v4 3/4] KVM: x86: On emulation failure, convey the exit
 reason, etc. to userspace
Message-ID: <YTEaZVjZwhOD0gMi@google.com>
References: <20210813071211.1635310-1-david.edmondson@oracle.com>
 <20210813071211.1635310-4-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813071211.1635310-4-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 13, 2021, David Edmondson wrote:
> -static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
> +static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
> +					   u8 ndata, u8 *insn_bytes, u8 insn_size)
>  {
> -	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> -	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
>  	struct kvm_run *run = vcpu->run;
> +	u8 ndata_start;
> +	u64 info[5];
> +
> +	/*
> +	 * Zero the whole array used to retrieve the exit info, casting to u32
> +	 * for select entries will leave some chunks uninitialized.
> +	 */
> +	memset(&info, 0, sizeof(info));
> +
> +	static_call(kvm_x86_get_exit_info)(vcpu, (u32 *)&info[0], &info[1],
> +					   &info[2], (u32 *)&info[3],
> +					   (u32 *)&info[4]);
>  
>  	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -	run->emulation_failure.ndata = 0;
> +
> +	/*
> +	 * There's currently space for 13 entries, but 5 are used for the exit
> +	 * reason and info.  Restrict to 4 to reduce the maintenance burden
> +	 * when expanding kvm_run.emulation_failure in the future.
> +	 */
> +	if (WARN_ON_ONCE(ndata > 4))
> +		ndata = 4;
> +
> +	/* Always include the flags as a 'data' entry. */
> +	ndata_start = 1;
>  	run->emulation_failure.flags = 0;
>  
>  	if (insn_size) {
> -		run->emulation_failure.ndata = 3;
> +		ndata_start += (sizeof(run->emulation_failure.insn_size) +
> +				sizeof(run->emulation_failure.insn_bytes)) /
> +			sizeof(u64);

Hrm, I like the intent, but the end result ends up being rather convoluted and
unnecessarily scary, e.g. this would do the wrong thing if the combined size of
the fields is not a multiple of 8.  That's obviously is not true, but relying on
insn_size/insn_bytes being carefully selected while simultaneously obscuring that
dependency is a bit mean.  What about a compile-time assertion with a more reader
friendly literal for bumping the count?

		BUILD_BUG_ON((sizeof(run->emulation_failure.insn_size) +
			      sizeof(run->emulation_failure.insn_bytes) != 16));
		ndata_start += 2;

>  		run->emulation_failure.flags |=
>  			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
>  		run->emulation_failure.insn_size = insn_size;
>  		memset(run->emulation_failure.insn_bytes, 0x90,
>  		       sizeof(run->emulation_failure.insn_bytes));
> -		memcpy(run->emulation_failure.insn_bytes,
> -		       ctxt->fetch.data, insn_size);
> +		memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
>  	}
> +
> +	memcpy(&run->internal.data[ndata_start], info, sizeof(info));

Oof, coming back to this code after some time away, "ndata_start" is confusing.
I believe past me thought that it would help convey that "info" is lumped into
the arbitrary data, but for me at least it just ends up making the interaction
with @data and @ndata more confusing.  Sorry for the bad suggestion :-/

What about info_start?  IMO, that makes the memcpy more readable.  Another option
would be to have the name describe the number of "ABI enries", but I can't come
up with a variable name that's remotely readable.

	memcpy(&run->internal.data[info_start], info, sizeof(info));
	memcpy(&run->internal.data[info_start + ARRAY_SIZE(info)], data,
	       ndata * sizeof(data[0]));


> +	memcpy(&run->internal.data[ndata_start + ARRAY_SIZE(info)], data,
> +	       ndata * sizeof(u64));

Not that it really matters, but it's probably better to use sizeof(data[0]) or
sizeof(*data).  E.g. if we do screw up the param in the future, we only botch the
output formatting, as opposed to dumping kernel stack data to userspace.

> +
> +	run->emulation_failure.ndata = ndata_start + ARRAY_SIZE(info) + ndata;
>  }
>  
> +static void prepare_emulation_ctxt_failure_exit(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +
> +	prepare_emulation_failure_exit(vcpu, NULL, 0, ctxt->fetch.data,
> +				       ctxt->fetch.end - ctxt->fetch.data);
> +}
> +
> +void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
> +					  u8 ndata)
> +{
> +	prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
> +}
> +EXPORT_SYMBOL_GPL(__kvm_prepare_emulation_failure_exit);
> +
> +void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
> +{
> +	__kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
> +}
> +EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
> +
>  static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -7502,16 +7551,14 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  
>  	if (kvm->arch.exit_on_emulation_error ||
>  	    (emulation_type & EMULTYPE_SKIP)) {
> -		prepare_emulation_failure_exit(vcpu);
> +		prepare_emulation_ctxt_failure_exit(vcpu);
>  		return 0;
>  	}
>  
>  	kvm_queue_exception(vcpu, UD_VECTOR);
>  
>  	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -		vcpu->run->internal.ndata = 0;
> +		prepare_emulation_ctxt_failure_exit(vcpu);
>  		return 0;
>  	}
>  
> @@ -12104,9 +12151,7 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
>  	 * doesn't seem to be a real use-case behind such requests, just return
>  	 * KVM_EXIT_INTERNAL_ERROR for now.
>  	 */
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -	vcpu->run->internal.ndata = 0;
> +	kvm_prepare_emulation_failure_exit(vcpu);
>  
>  	return 0;
>  }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6c79c1ce3703..e86cc2de7b5c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -397,6 +397,12 @@ struct kvm_run {
>  		 * "ndata" is correct, that new fields are enumerated in "flags",
>  		 * and that each flag enumerates fields that are 64-bit aligned
>  		 * and sized (so that ndata+internal.data[] is valid/accurate).
> +		 *
> +		 * Space beyond the defined fields may be used to

Please run these out to 80 chars.  Even 80 is a soft limit, it's ok to run over
a bit if the end result is (subjectively) prettier. 

> +		 * store arbitrary debug information relating to the
> +		 * emulation failure. It is accounted for in "ndata"
> +		 * but otherwise unspecified and is not represented in

Explicitly state the format is unspecified?

> +		 * "flags".

And also explicitly stating the debug info isn't ABI, e.g.

		 * Space beyond the defined fields may be used to store arbitrary
		 * debug information relating to the emulation failure. It is
		 * accounted for in "ndata" but the format is unspecified and
		 * is not represented in "flags".  Any such info is _not_ ABI!

>  		 */
>  		struct {
>  			__u32 suberror;
> @@ -408,6 +414,7 @@ struct kvm_run {
>  					__u8  insn_bytes[15];
>  				};
>  			};
> +			/* Arbitrary debug data may follow. */
>  		} emulation_failure;
>  		/* KVM_EXIT_OSI */
>  		struct {
> -- 
> 2.30.2
> 
