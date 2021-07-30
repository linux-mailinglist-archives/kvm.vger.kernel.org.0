Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722743DC0D6
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbhG3WO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbhG3WO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:14:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682D5C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:14:53 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g23-20020a17090a5797b02901765d605e14so16337889pji.5
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vddn+vvtKgOVqzqDSz65GCCZWuHGFXaCgkycC5H7nuc=;
        b=CiiI2ggcFke2Cr1DprT/sGjOE+M7Pnh/YovUHL38sLnQfa3VHnPEYmbKc1Q/XVJJj6
         /GWBpssQk3TAKFZV6gK2nUjZ3tUNYiZGrN4poHwQFadaDARw8sszZk8vdQuvgzS+tKC2
         2wVnjUY/N2dHnrSNXDFaYHLTomommF54LseqJzPdlmfmVaFbVLXqJeJGaAqab4WUQWKX
         yMnCafHV8vOmYwsMZRQR/hRanbpxsJp15hOch+8SIzwEus9nBdhl44DZjbYY606UucQw
         PBht786uWvmBszeKy8ykIOJwvq3PTe6iMUaPn7CVYcwKPtOiv4masIJA/g22ALVtWkmS
         4c6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vddn+vvtKgOVqzqDSz65GCCZWuHGFXaCgkycC5H7nuc=;
        b=oUqa/a7q1cN3VQzLdTljbL+rJ/lGXUqGU0AlwKh523Xlal3djSKIWxxvm1bRsWXTC2
         pFRzF546RNkBtFu8fkB0NeCQoDRFyq0zxDsLtzd8OP6+dGVR5blXrFlP3A+itv2OGFVQ
         6zQmxtmntgx/LzqvqFdujnn03uC3Mzp1ei8QtRwI1TYp0WbqhGHR5b4MEwWOn5Ycb/TY
         tfG2dOE8/+Y1gl3gql3LF5Vz9B0CHQ8u95rf/cwWqvWKn+u5KXKHfIX9SAJbHrQfTn3l
         pdYPSYmTiM3QCW7F/WvKzmzNqZtacPkvZ2suEchiyTbCX5JpDLJ0J8SZ5uQKqq0m9NiG
         hyGg==
X-Gm-Message-State: AOAM531Brgh9YEyKsHTMSK/yKoeADmxnaGR2mz7+jgl0Wp9nl75OaEYE
        Mf3V02QWafJ4bpZb5PCq8PefhA==
X-Google-Smtp-Source: ABdhPJyZ5+BXJu7Tm6hcHq5Ca+eHHgIjoij+V2bh6ieawtkrN8emuis0lJHS2P1caSnA+hF1wWsBOA==
X-Received: by 2002:a63:1359:: with SMTP id 25mr2255674pgt.79.1627683292597;
        Fri, 30 Jul 2021 15:14:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i25sm3464475pfo.20.2021.07.30.15.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:14:51 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:14:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v3 2/3] KVM: x86: On emulation failure, convey the exit
 reason, etc. to userspace
Message-ID: <YQR52JRv8jgj+Dv8@google.com>
References: <20210729133931.1129696-1-david.edmondson@oracle.com>
 <20210729133931.1129696-3-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729133931.1129696-3-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021, David Edmondson wrote:
> Should instruction emulation fail, include the VM exit reason, etc. in
> the emulation_failure data passed to userspace, in order that the VMM
> can report it as a debugging aid when describing the failure.
> 
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  5 ++++
>  arch/x86/kvm/vmx/vmx.c          |  5 +---
>  arch/x86/kvm/x86.c              | 53 ++++++++++++++++++++++++++-------
>  include/uapi/linux/kvm.h        |  7 +++++
>  4 files changed, 56 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index dfb902930cdc..17da43c1aa67 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1630,6 +1630,11 @@ extern u64 kvm_mce_cap_supported;
>  int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
>  int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
>  					void *insn, int insn_len);
> +void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
> +					bool instruction_bytes,
> +					void *data, unsigned int ndata);
> +void kvm_prepare_emulation_failure_exit_with_reason(struct kvm_vcpu *vcpu,
> +						    bool instruction_bytes);
>  
>  void kvm_enable_efer_bits(u64);
>  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fefdecb0ff3d..a8d303c7c099 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5367,10 +5367,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>  
>  		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
>  		    vcpu->arch.exception.pending) {
> -			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -			vcpu->run->internal.suberror =
> -						KVM_INTERNAL_ERROR_EMULATION;
> -			vcpu->run->internal.ndata = 0;
> +			kvm_prepare_emulation_failure_exit_with_reason(vcpu, false);
>  			return 0;
>  		}
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a4fd10604f72..a97bacd8922f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7456,7 +7456,9 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>  
> -static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
> +void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
> +					bool instruction_bytes,
> +					void *data, unsigned int ndata)

'data' should be a 'u64 *', and 'ndata' should be a 'u8' that is actual ndata as
opposed to the size.  The obvious alternative would be to rename ndata to size,
but IMO that's unnecessarily complex, it's much easier to force the caller to work
with u64s.  That also reduces the probablity of KVM mangling data[] by dumping
unrelated fields into a single data[] entry, or by leaving stale chunks (if the
incoming data is not a multiple of 8 bytes).

>  {
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>  	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
> @@ -7464,10 +7466,10 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>  
>  	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
> -	run->emulation_failure.ndata = 0;
> +	run->emulation_failure.ndata = 1; /* Always include the flags. */
>  	run->emulation_failure.flags = 0;
>  
> -	if (insn_size) {
> +	if (instruction_bytes && insn_size) {
>  		run->emulation_failure.ndata = 3;
>  		run->emulation_failure.flags |=
>  			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> @@ -7477,7 +7479,42 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>  		memcpy(run->emulation_failure.insn_bytes,
>  		       ctxt->fetch.data, insn_size);
>  	}
> +
> +	ndata = min((size_t)ndata, sizeof(run->internal.data) -
> +		    run->emulation_failure.ndata * sizeof(u64));
> +	if (ndata) {
> +		unsigned int offset =
> +			offsetof(struct kvm_run, emulation_failure.flags) +
> +			run->emulation_failure.ndata * sizeof(u64);
> +
> +		memcpy((void *)run + offset, data, ndata);
> +		run->emulation_failure.ndata += ndata / sizeof(u64);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);

NAK on exporting this particular helper, it consumes vcpu->arch.emulate_ctxt,
which ideally wouldn't even be visible to vendor code (stupid SVM erratum).  The
emulation context will rarely, if ever, be valid if this is called from vendor code.

The SGX call is effectively guarded by instruction_bytes=false, but that's a
messy approach as the handle_emulation_failure() patch is the _only_ case where
emulate_ctxt can be valid.

> +void kvm_prepare_emulation_failure_exit_with_reason(struct kvm_vcpu *vcpu,
> +						    bool instruction_bytes)
> +{
> +	struct {
> +		__u64 exit_reason;

As mentioned in the prior patch, exit_reason is probably best kept to a u32 at
this time.

> +		__u64 exit_info1;
> +		__u64 exit_info2;
> +		__u32 intr_info;
> +		__u32 error_code;
> +	} exit_reason;

Oooh, you're dumping all the fields in kvm_run.  That took me forever to realize
because the struct is named "exit_reason".  Unless there's a naming conflict,
'data' would be the simplest, and if that's already taken, maybe 'info'?

I'm also not sure an anonymous struct is going to be the easiest to maintain.
I do like that the fields all have names, but on the other hand the data should
be padded so that each field is in its own data[] entry when dumped to userspace.
IMO, the padding complexity isn't worth the naming niceness since this code
doesn't actually care about what each field contains.

> +
> +	static_call(kvm_x86_get_exit_info)(vcpu,
> +					   &exit_reason.exit_reason,
> +					   &exit_reason.exit_info1,
> +					   &exit_reason.exit_info2,
> +					   &exit_reason.intr_info,
> +					   &exit_reason.error_code);
> +
> +	kvm_prepare_emulation_failure_exit(vcpu, instruction_bytes,
> +					   &exit_reason, sizeof(exit_reason));

Retrieiving the exit reason and info should probably be in the inner helper, the
only case where the info will be stale is the VMX !unrestricted_guest
handle_invalid_guest_state() path, but even then I think the last VM-Exit info
would be interesting/relevant.  That should allow for a cleaner API too.

This is what I came up with after a fair bit of massaging.  The get_exit_info()
call is beyond gross, but I still think I like it more than a struct?  A
build-time assertion that the struct size is a multiple of 8 would allay my
concerns over leaking stack state to userspace, so I'm not totally opposed to it.

	struct {
		u32 exit_reason;
		u32 pad1;
		u64 info1;
		u64 info2;
		u32 intr_info;
		u32 pad2;
		u32 error_code;
		u32 pad3;
	} info;
	u64 ninfo = sizeof(info) / sizeof(u64);

	BUILD_BUG_ON(sizeof(info) % sizeof(u64));

	/*
	 * Zero the whole struct used to retrieve the exit info to ensure the
	 * padding does not leak stack data to userspace.
	 */
	memset(&info, 0, sizeof(info));

	static_call(kvm_x86_get_exit_info)(vcpu, &info.exit_reason,
					   &info.info1, &info.info2,
					   &info.intr_info, &info.error_code);



void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
					  u8 ndata);
void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);

static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
					   u8 ndata, u8 *insn_bytes, u8 insn_size)
{
	struct kvm_run *run = vcpu->run;
	u8 ndata_start;
	u64 info[5];

	/*
	 * Zero the whole array used to retrieve the exit info, casting to u32
	 * for select entries will leave some chunks uninitialized.
	 */
	memset(&info, 0, sizeof(info));

	static_call(kvm_x86_get_exit_info)(vcpu, (u32 *)&info[0], &info[1],
					   &info[2], (u32 *)&info[3],
					   (u32 *)&info[4]);

	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;

	/*
	 * There's currently space for 13 entries, but 5 are used for the exit
	 * reason and info.  Restrict to 4 to reduce the maintenance burden
	 * when expanding kvm_run.emulation_failure in the future.
	 */
	if (WARN_ON_ONCE(ndata > 4))
		ndata = 4;

	if (insn_size) {
		ndata_start = 3;
		run->emulation_failure.flags =
			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
		run->emulation_failure.insn_size = insn_size;
		memset(run->emulation_failure.insn_bytes, 0x90,
		       sizeof(run->emulation_failure.insn_bytes));
		memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
	} else {
		/* Always include the flags as a 'data' entry. */
		ndata_start = 1;
		run->emulation_failure.flags = 0;
	}

	memcpy(&run->internal.data[ndata_start], info, ARRAY_SIZE(info));
	memcpy(&run->internal.data[ndata_start + ARRAY_SIZE(info)], data, ndata);
}

static void prepare_emulation_ctxt_failure_exit(struct kvm_vcpu *vcpu)
{
	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;

	prepare_emulation_failure_exit(vcpu, NULL, 0, ctxt->fetch.data,
				       ctxt->fetch.end - ctxt->fetch.data);
}

void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
					  u8 ndata)
{
	prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
}
EXPORT_SYMBOL_GPL(__kvm_prepare_emulation_failure_exit);

void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
{
	__kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
}
EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
