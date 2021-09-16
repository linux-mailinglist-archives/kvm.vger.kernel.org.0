Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C982A40DEDA
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 18:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240417AbhIPQBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 12:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240185AbhIPQBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 12:01:43 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6489C061574
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 09:00:22 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso7912983pjj.0
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 09:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qY0iS8u2LJMGt4Ov6dPslL6Xeqan2bC0+CFm4DC6DyA=;
        b=EGnLDp6iMIbuxmJgrxlgyPdXStg4wUvMU3ujBKbXuvsAXhESpChnmL4Vw/TN4vovg3
         lvGPL5avgzs9VcIFNCzyeY2mCMmw+QWuOvH8kslY0VD5n3RA18dtoh6GQaiwb+Ludaet
         0FS/eQAWNY4+YXz+tThYq/Nz5SLkazkelI2GgqxfpRKkSw1h/JC/S/PUdACom7DaMNvG
         aooa3JQHpsz9s4G2hyFeF9RGVTJFlELpoZRWZCAtJjjykoEh9RUIUg2723L9EWW5uY8r
         GIAl0Ww03i6bf7Rc2Dq58t/td641ijBX5kK9/jY9Z32cE0MoDt99mMmGwY+YqtvQODys
         SPLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qY0iS8u2LJMGt4Ov6dPslL6Xeqan2bC0+CFm4DC6DyA=;
        b=DnShMr5g7dD/ktEAeZ8XsPSASlO1SwCtnMroC0mpRVL+e9nqGE3+JNxlISRq21aIZn
         57m/C4LyPlYAVLy4aIrD5ZrzfT6IYZs1Le/AsPr5whKx8p0EEX3sO6TRm/G0OC2MpUEH
         5/yc5kfmRR5YUw8JSCvfEwmZEcN4PIAfSxpyDtf7xxKrRySNwIqMH54U81gGVObRotlu
         ePe6GlIldjhtvwgF+kqwrp+c9fjagjXMbfnZ4vtPQuZzU0ESllCOseV3QO82s4yduRWf
         tLQSINu57r9JXvWrVDcQcYL5JQygjLqQNL+Ng/9ePLFQRm0vWRHivffqrT/5ksTnAV37
         rUWg==
X-Gm-Message-State: AOAM532b/RgrrMcARTX8uns7AfsH5z+oHALG4Yf5zhjiT1bMtrbFxa7G
        H+y6qxNLfBKXPNNhXyzmbOyOsw==
X-Google-Smtp-Source: ABdhPJxjGy69LL16KLFnGDrccmNfv4kC6HTE9iSk9xrylNW7kFwzlsT1dNtB1k1IoUtYhI0fUFKcNQ==
X-Received: by 2002:a17:903:1104:b0:13a:41f1:6dd5 with SMTP id n4-20020a170903110400b0013a41f16dd5mr5268285plh.48.1631808022058;
        Thu, 16 Sep 2021 09:00:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id cl16sm3300728pjb.23.2021.09.16.09.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 09:00:21 -0700 (PDT)
Date:   Thu, 16 Sep 2021 16:00:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong93@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] kvm: x86: Emulate hypercall instead of fixing
 hypercall instruction
Message-ID: <YUNqEeWg32kNwfO8@google.com>
References: <cover.1631188011.git.houwenlong93@linux.alibaba.com>
 <7893d13e11648be0326834248fcb943088fb0b76.1631188011.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7893d13e11648be0326834248fcb943088fb0b76.1631188011.git.houwenlong93@linux.alibaba.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021, Hou Wenlong wrote:
> It is guest's resposibility to use right instruction for hypercall,
> hypervisor could emulate wrong instruction instead of modifying
> guest's instruction.
> 
> Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> ---
> @@ -8747,16 +8747,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
>  
> -static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
> +static int emulator_hypercall(struct x86_emulate_ctxt *ctxt)
>  {
> +	int ret;
>  	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> -	char instruction[3];
> -	unsigned long rip = kvm_rip_read(vcpu);
> -
> -	static_call(kvm_x86_patch_hypercall)(vcpu, instruction);
>  
> -	return emulator_write_emulated(ctxt, rip, instruction, 3,
> -		&ctxt->exception);
> +	ret = kvm_emulate_hypercall_noskip(vcpu);

I have mixed feelings on calling out of the emulator to do all this work.  One on
hand, I think it's a somewhat silly, arbitrary boundary.  On the other hand, reading
and writing GPRs directly means the emulation context holds stale data, especially
in the case where the hypercall triggers an exit to userspace.

> +	if (ret)
> +		return X86EMUL_CONTINUE;
> +	return X86EMUL_IO_NEEDED;

Unfortunately, simply returning X86EMUL_IO_NEEDED is not sufficient to handle the
KVM_HC_MAP_GPA_RANGE case.  x86_emulate_instruction() doesn't directly act on
X86EMUL_IO_NEEDED, because x86_emulate_insn() doesn't return X86EMUL_*, it returns
EMULATION_FAILED, EMULATION_OK, etc...  x86_emulate_instruction() instead looks
for other signals to differentiate between exception injection, PIO, MMIO, etc...

The IO_NEEDED path would also need to provide an alternative complete_userspace_io
callback, otherwise complete_hypercall_exit() will attempt to skip the instruction
using e.g. vmcs.VM_EXIT_INSTRUCTION_LEN and likely send the guest into the weeds.

In the prior patch, having kvm_emulate_hypercall_noskip() skip the CPL check is
definitely wrong, and skipping Xen/Hyper-V hypercall support is odd, though arguably
correct since Xen/Hyper-V hypercalls should never hit this path.

All of the above are solvable problems, but there is a non-trivial cost in doing
so, especially looking ahead to TDX support, which also needs/wants to split
kvm_emulate_hypercall() but in slightly different ways[*].

I 100% agree that patching the hypercall instruction is awful.  There are myriad
fatal issues with the current approach:

  1. Patches using an emulated guest write, which will fail if RIP is not mapped
     writable, and even injects a #PF into the guest on failure.

  2. Doesn't ensure the write is "atomic", e.g. a hypercall that splits a page
     boundary will be handled as two separate writes, which means that a partial,
     corrupted instruction can be observed by a separate vCPU.
 
  3. Doesn't serialize other CPU cores after updating the code stream.

  4. Completely fails to account for the case where KVM is emulating due to invalid
     guest state with unrestricted_guest=0.  Patching and retrying the instruction
     will result in vCPU getting stuck in an infinite loop.

But, the "support" _so_ awful, especially #1, that there's practically zero chance
that a modern guest kernel can rely on KVM to patch the guest.  E.g. patching fails
on modern Linux due to kernel code being mapped NX (barring admin override).  This
was addressed in the Linux guest back in 2014 by commit c1118b3602c2 ("x86: kvm: use
alternatives for VMCALL vs. VMMCALL if kernel text is read-only").

In other words, odds are very good that only old Linux guest kernels rely on KVM's
patching.  Because of that, my preference is to keep the patching, do our best to
make it suck a little less, and aim to completely remove the patching entirely at
some point in the future.

For #1, inject a #UD instead of #PF if the write fails.  The guest will still likely
die, but the failure signature is much friendlier to debuggers.

For #2 and #3, do nothing as fixing those is non-trivial.

For #4, inject a #UD if the hypercall instruction is already the "right" instruction.
I.e. retroactively define KVM's ABI to be that KVM hypercalls have undefined behavior
in Big Real Mode and other modes that trigger invalid guest state (since the hypercalls
will still work if unrestricted_guest=1).  This can't be an ABI breakage since it does
not work today and can't possibly have ever worked in the past.

I have mostly-complete to do the above (I ran afoul of the NX thing), I'll hopefully get
them out next week.

[*] https://lkml.kernel.org/r/9e1e66787c50232391e20cb4b3d1c5b249e3f910.1625186503.git.isaku.yamahata@intel.com
