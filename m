Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CE6365F7A
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 20:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhDTSfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 14:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbhDTSfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 14:35:25 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21DBC06138A
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 11:34:53 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q2so1829099pfk.9
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 11:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HOAau7F7C1WE5mO/IR/06RptFwDX5f0bRMnajXJC4iU=;
        b=WwuoMxyRACRSbor0BtgQzaEtAn1J1Dip4k22ccvT6wymV0eI6NuGDkyR7YSSZ2AK67
         ol8nSLnW2oZdBADoxLB3c3Q/Rj3DB40jzUE3l0QqJeJh+iIV48BqRahSvvN83YJ7DSPH
         Lt4mJryidXI44vL9yQHDtA8YIt5hFMA9BmPFbC3CkFcDm89z+5I1Cj2BE6fSZlVnl15E
         ap1A/ql4pZ57y5FNKF4advDzNjQxMUXDkauHQLi//M2YEcs42hj3lY6Doar4anlwp99X
         fsG1FCktaUN99BT1CiMGTaL6cDBkUFJa1Supb8V/M2JxUqf1D9jMgZQfb4O2roVPfvwN
         k/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HOAau7F7C1WE5mO/IR/06RptFwDX5f0bRMnajXJC4iU=;
        b=nqLYKMyzbt0SzRP9jzh+ro2KpEaRTV21vh+O/SoWtu1o4p6TRKIbgh6M92shVfKOKs
         BjC5SSxIuN7EW52QqQ61YrIxu/wTj5e3WibuQnz6vjA0i0WIh4KSRNIRYZWVvGnFkQtX
         PQ/+5hS6EPIEgDpslg+wPWOVRuZGBGKMuYZvviMwbEGGhIPChvWJEjgAL6H48afYG/Cn
         dlgevi24DxWhXCgOo2oI5ISi8AalbVxiq9wRyQF39op9jI2vHQCzI8hE8wy1i0TfqUiF
         nfvL7dXfcziflr+Ig2MSNLVIq5CZSWS1hMIc1rWVarXBqmSrzDfgAmSVBw7JNGyGiJ3C
         PGxg==
X-Gm-Message-State: AOAM530TZcK78BgKMhkRAeyjvb1Xce1pZ91uTTxacQvCHCB0nhCeAf7U
        n0KE+1Dbm4Al7OiMaLZa++s8ng==
X-Google-Smtp-Source: ABdhPJx7nmBra0lkVSPiioAR/AnfrN0BZgpdOKdhmtyEi7YwvzP1i3CMH+jIFqg+Sji1oZ1LzJrh5Q==
X-Received: by 2002:a63:5b14:: with SMTP id p20mr6770239pgb.111.1618943693228;
        Tue, 20 Apr 2021 11:34:53 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id u1sm3112611pjj.19.2021.04.20.11.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:34:52 -0700 (PDT)
Date:   Tue, 20 Apr 2021 18:34:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     david.edmondson@oracle.com, jmattson@google.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] kvm: x86: Allow userspace to handle emulation errors
Message-ID: <YH8eyGMC3A9+CKTo@google.com>
References: <20210416131820.2566571-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416131820.2566571-1-aaronlewis@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 16, 2021, Aaron Lewis wrote:
> +7.24 KVM_CAP_EXIT_ON_EMULATION_FAILURE
> +--------------------------------------
> +
> +:Architectures: x86
> +:Parameters: args[0] whether the feature should be enabled or not
> +
> +With this capability enabled, the in-kernel instruction emulator packs the exit
> +struct of KVM_INTERNAL_ERROR with the instruction length and instruction bytes
> +when an error occurs while emulating an instruction.  This allows userspace to
> +then take a look at the instruction and see if it is able to handle it more
> +gracefully than the in-kernel emulator.

As alluded to later in the thread, I don't think we should condition the extra
information on this capability.  By crafting the struct overlay to be backwards
compatibile, KVM can safely dump all the new information, even for old VMMs.
An old VMM may not programmatically use the data, but I suspect most VMMs at
least dump all info, e.g. QEMU does:

    if (kvm_check_extension(kvm_state, KVM_CAP_INTERNAL_ERROR_DATA)) {
        int i;

        for (i = 0; i < run->internal.ndata; ++i) {
            fprintf(stderr, "extra data[%d]: %"PRIx64"\n",
                    i, (uint64_t)run->internal.data[i]);
        }
    }

This would be a way to feed more info to the poor sod that has to debug
emulation failures :-)

> +
> +When this capability is enabled use the emulation_failure struct instead of the
> +internal struct for the exit struct.  They have the same layout, but the
> +emulation_failure struct matches the content better.

This documentation misses the arguably more important details of what exactly
"EXIT_ON_EMULATION_FAILURE" means.  E.g. it should call out the KVM still exits
on certain types (skip) even if this capability is not enabled, and that KVM
will _never_ exit if VMware #GP emulation fails.

> +
>  8. Other capabilities.
>  ======================
> @@ -7119,8 +7124,29 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)

...

>  }
>  EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
>  
> +static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
> +{
> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> +	u64 insn_size = ctxt->fetch.end - ctxt->fetch.data;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;

Grab vcpu->run in a local variable.

> +	vcpu->run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
> +	vcpu->run->emulation_failure.ndata = 0;
> +	if (kvm->arch.exit_on_emulation_error && insn_size > 0) {

I definitely think this should not be conditioned on exit_on_emulation_error.

No need for "> 0", it's an unsigned value.

> +		vcpu->run->emulation_failure.ndata = 3;
> +		vcpu->run->emulation_failure.flags =

Flags needs to be zeroed when insn_size==0.  And use |= for new flags so that,
if we add new flags, the existing code doesn't need to be modified.

> +			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
> +		vcpu->run->emulation_failure.insn_size = insn_size;
> +		memcpy(vcpu->run->emulation_failure.insn_bytes,
> +		       ctxt->fetch.data, sizeof(ctxt->fetch.data));

Doesn't truly matter, but I think it's less confusing to copy over insn_size
bytes.

> +	}


	...
	struct kvm_run *kvm_run = vcpu->run;

	kvm_run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
	kvm_run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
	kvm_run->emulation_failure.ndata = 1;
	kvm_run->emulation_failure.flags = 0;

	if (insn_size) {
		kvm_run->emulation_failure.ndata = 3;
		kvm_run->emulation_failure.flags |=
			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
		kvm_run->emulation_failure.insn_size = insn_size;
		memcpy(kvm_run->emulation_failure.insn_bytes, ctxt->fetch.data, insn_size);
	}

> +}
