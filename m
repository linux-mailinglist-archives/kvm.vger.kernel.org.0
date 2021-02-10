Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7748F315E10
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 05:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBJEKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 23:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230263AbhBJEKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 23:10:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C0B964E05;
        Wed, 10 Feb 2021 04:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612930183;
        bh=l2kXST1V8SQbEIgv6UjRYe6nKE73dsovX2h4nrQoK8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NqKFp+LmWgE2y56eNFEzxpijrVU3L1Vxjfxetv0o15PD5/V5eFzkLawIAYCnYfMKH
         lzmGyHoinNJ7MGhBbBswL7+/0k+vIm2aNaVMnGWHvFICGGn/i02axE+74C+qd1B6Wt
         /VzP8AOYMv21uHFEVlLII3lmmO/1SnsjSuMyQCYw8826ejg0nzYIxhRYvI7JkCfS/b
         RyAcVnxTOwG/a4lTRz9IhIWgp7FpclWUL5cnEzjIploBUyuP/xHl6q2vcTOI9nXZ9i
         kX7bY8F8C8tzGbqWujYuKydjG1U/tqsmNzjRPpb077CjmOruiorjiPIjJcjpHYlyph
         LQ7AQJ/Z0kLDw==
Date:   Tue, 9 Feb 2021 21:09:42 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: selftests: Add operand to vmsave/vmload/vmrun in
 svm.c
Message-ID: <20210210040942.GA1726907@ubuntu-m3-large-x86>
References: <20210210031719.769837-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210031719.769837-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 03:17:19AM +0000, Ricardo Koller wrote:
> Building the KVM selftests with LLVM's integrated assembler fails with:
> 
>   $ CFLAGS=-fintegrated-as make -C tools/testing/selftests/kvm CC=clang
>   lib/x86_64/svm.c:77:16: error: too few operands for instruction
>           asm volatile ("vmsave\n\t" : : "a" (vmcb_gpa) : "memory");
>                         ^
>   <inline asm>:1:2: note: instantiated into assembly here
>           vmsave
>           ^
>   lib/x86_64/svm.c:134:3: error: too few operands for instruction
>                   "vmload\n\t"
>                   ^
>   <inline asm>:1:2: note: instantiated into assembly here
>           vmload
>           ^
> This is because LLVM IAS does not currently support calling vmsave,
> vmload, or vmload without an explicit %rax operand.

It is worth noting that this has been fixed in LLVM already, available
in 12.0.0-rc1 (final should be out in about a month or so as far as I am
aware):

http://github.com/llvm/llvm-project/commit/f47b07315a3c308a214119244b216602c537a1b2

> Add an explicit operand to vmsave, vmload, and vmrum in svm.c. Fixing
> this was suggested by Sean Christopherson.
> 
> Tested: building without this error in clang 11. The following patch
> (not queued yet) needs to be applied to solve the other remaining error:
> "selftests: kvm: remove reassignment of non-absolute variables".
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Link: https://lore.kernel.org/kvm/X+Df2oQczVBmwEzi@google.com/
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Yes, same fix as commit f65cf84ee769 ("KVM: SVM: Add register operand to
vmsave call in sev_es_vcpu_load").

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  tools/testing/selftests/kvm/lib/x86_64/svm.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> index 3a5c72ed2b79..827fe6028dd4 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
> @@ -74,7 +74,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
>  	wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
>  
>  	memset(vmcb, 0, sizeof(*vmcb));
> -	asm volatile ("vmsave\n\t" : : "a" (vmcb_gpa) : "memory");
> +	asm volatile ("vmsave %0\n\t" : : "a" (vmcb_gpa) : "memory");
>  	vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg_attr);
>  	vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg_attr);
>  	vmcb_set_seg(&save->ss, get_ss(), 0, -1U, data_seg_attr);
> @@ -131,19 +131,19 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
>  void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
>  {
>  	asm volatile (
> -		"vmload\n\t"
> +		"vmload %[vmcb_gpa]\n\t"
>  		"mov rflags, %%r15\n\t"	// rflags
>  		"mov %%r15, 0x170(%[vmcb])\n\t"
>  		"mov guest_regs, %%r15\n\t"	// rax
>  		"mov %%r15, 0x1f8(%[vmcb])\n\t"
>  		LOAD_GPR_C
> -		"vmrun\n\t"
> +		"vmrun %[vmcb_gpa]\n\t"
>  		SAVE_GPR_C
>  		"mov 0x170(%[vmcb]), %%r15\n\t"	// rflags
>  		"mov %%r15, rflags\n\t"
>  		"mov 0x1f8(%[vmcb]), %%r15\n\t"	// rax
>  		"mov %%r15, guest_regs\n\t"
> -		"vmsave\n\t"
> +		"vmsave %[vmcb_gpa]\n\t"
>  		: : [vmcb] "r" (vmcb), [vmcb_gpa] "a" (vmcb_gpa)
>  		: "r15", "memory");
>  }
> -- 
> 2.30.0.478.g8a0d178c01-goog
> 
