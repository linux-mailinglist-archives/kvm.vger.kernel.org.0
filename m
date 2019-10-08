Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4962FD00BD
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 20:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbfJHSgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 14:36:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:24214 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfJHSgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 14:36:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 11:36:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,272,1566889200"; 
   d="scan'208";a="393433585"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 08 Oct 2019 11:36:36 -0700
Date:   Tue, 8 Oct 2019 11:36:34 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] selftests: kvm: fix sync_regs_test with newer gccs
Message-ID: <20191008183634.GF14020@linux.intel.com>
References: <20191008180808.14181-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008180808.14181-1-vkuznets@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 08, 2019 at 08:08:08PM +0200, Vitaly Kuznetsov wrote:
> Commit 204c91eff798a ("KVM: selftests: do not blindly clobber registers in
>  guest asm") was intended to make test more gcc-proof, however, the result
> is exactly the opposite: on newer gccs (e.g. 8.2.1) the test breaks with
> 
> ==== Test Assertion Failure ====
>   x86_64/sync_regs_test.c:168: run->s.regs.regs.rbx == 0xBAD1DEA + 1
>   pid=14170 tid=14170 - Invalid argument
>      1	0x00000000004015b3: main at sync_regs_test.c:166 (discriminator 6)
>      2	0x00007f413fb66412: ?? ??:0
>      3	0x000000000040191d: _start at ??:?
>   rbx sync regs value incorrect 0x1.
> 
> Apparently, compile is still free to play games with registers even
> when they have variables attaches.
> 
> Re-write guest code with 'asm volatile' by embedding ucall there and
> making sure rbx is preserved.
> 
> Fixes: 204c91eff798a ("KVM: selftests: do not blindly clobber registers in guest asm")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/x86_64/sync_regs_test.c     | 21 ++++++++++---------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> index 11c2a70a7b87..5c8224256294 100644
> --- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
> @@ -22,18 +22,19 @@
>  
>  #define VCPU_ID 5
>  
> +#define UCALL_PIO_PORT ((uint16_t)0x1000)
> +
> +/*
> + * ucall is embedded here to protect against compiler reshuffling registers
> + * before calling a function. In this test we only need to get KVM_EXIT_IO
> + * vmexit and preserve RBX, no additional information is needed.
> + */
>  void guest_code(void)
>  {
> -	/*
> -	 * use a callee-save register, otherwise the compiler
> -	 * saves it around the call to GUEST_SYNC.
> -	 */
> -	register u32 stage asm("rbx");
> -	for (;;) {
> -		GUEST_SYNC(0);
> -		stage++;
> -		asm volatile ("" : : "r" (stage));
> -	}
> +	asm volatile("1: in %[port], %%al\n"
> +		     "add $0x1, %%rbx\n"
> +		     "jmp 1b"
> +		     : : [port] "d" (UCALL_PIO_PORT) : "rax", "rbx");
>  }

To make the code truly bulletproof, is it possible to rename guest_code()
to guest_code_wrapper() and then export 1: as guest_code?  VM-Enter will
jump directly to the relevant code and gcc can't touch rbx.  E.g.:

	asm volatile("1: ..."
		     ".global guest_code"
		     "guest_code: " _ASM_PTR " 1b");

Not sure if that works with how the selftests are compiled.  It may also
be possible to simply replace '1' with 'guest_code'.

>  
>  static void compare_regs(struct kvm_regs *left, struct kvm_regs *right)
> -- 
> 2.20.1
> 
