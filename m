Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7539624726E
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 20:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731690AbgHQSmb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 14:42:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:5457 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391029AbgHQSm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 14:42:29 -0400
IronPort-SDR: trug3E0GuLUiuYiFVbVJGT5EkJJPsCyDrtDq/nelkRkhq/tB2kKlAp0ofI9qsNS4frvPa7/GfL
 46bzta7+w5rw==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="239598593"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="239598593"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 11:42:28 -0700
IronPort-SDR: cN77Q3ljGTc6aUVV1f5QieMS4soR0R8SKKcql3u2UTdzm0IpTqLqxbN8GC3Qh+aoTsMsSzG2w1
 OGgqemmETuqQ==
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="319807735"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 11:42:28 -0700
Date:   Mon, 17 Aug 2020 11:42:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix access code passed to gva_to_gpa
Message-ID: <20200817184226.GJ22407@linux.intel.com>
References: <20200817180042.32264-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817180042.32264-1-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 17, 2020 at 02:00:42PM -0400, Paolo Bonzini wrote:
> The PK bit of the error code is computed dynamically in permission_fault
> and therefore need not be passed to gva_to_gpa: only the access bits
> (fetch, user, write) need to be passed down.
> 
> Not doing so causes a splat in the pku test:
> 
>    WARNING: CPU: 25 PID: 5465 at arch/x86/kvm/mmu.h:197 paging64_walk_addr_generic+0x594/0x750 [kvm]
>    Hardware name: Intel Corporation WilsonCity/WilsonCity, BIOS WLYDCRB1.SYS.0014.D62.2001092233 01/09/2020
>    RIP: 0010:paging64_walk_addr_generic+0x594/0x750 [kvm]
>    Code: <0f> 0b e9 db fe ff ff 44 8b 43 04 4c 89 6c 24 30 8b 13 41 39 d0 89
>    RSP: 0018:ff53778fc623fb60 EFLAGS: 00010202
>    RAX: 0000000000000001 RBX: ff53778fc623fbf0 RCX: 0000000000000007
>    RDX: 0000000000000001 RSI: 0000000000000002 RDI: ff4501efba818000
>    RBP: 0000000000000020 R08: 0000000000000005 R09: 00000000004000e7
>    R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000007
>    R13: ff4501efba818388 R14: 10000000004000e7 R15: 0000000000000000
>    FS:  00007f2dcf31a700(0000) GS:ff4501f1c8040000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: 0000000000000000 CR3: 0000001dea475005 CR4: 0000000000763ee0
>    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>    PKRU: 55555554
>    Call Trace:
>     paging64_gva_to_gpa+0x3f/0xb0 [kvm]
>     kvm_fixup_and_inject_pf_error+0x48/0xa0 [kvm]
>     handle_exception_nmi+0x4fc/0x5b0 [kvm_intel]
>     kvm_arch_vcpu_ioctl_run+0x911/0x1c10 [kvm]
>     kvm_vcpu_ioctl+0x23e/0x5d0 [kvm]
>     ksys_ioctl+0x92/0xb0
>     __x64_sys_ioctl+0x16/0x20
>     do_syscall_64+0x3e/0xb0
>     entry_SYSCALL_64_after_hwframe+0x44/0xa9
>    ---[ end trace d17eb998aee991da ]---
> 
> Reported-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Fixes: 897861479c064 ("KVM: x86: Add helper functions for illegal GPA checking and page fault injection")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2db369a64f29..a6e42ce607ca 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10743,9 +10743,13 @@ EXPORT_SYMBOL_GPL(kvm_spec_ctrl_test_value);
>  void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code)

Side topic, 'struct x86_exception' really should be using a u32 for the
error code.  Practically speaking, I expect bits 31:16 will be reserved in
perpetuity, but it's jarring to see 'u16 error_code', and it leads to
pointless discrepancies, e.g. 'u32 access' in ->gva_to_gpa().

>  {
>  	struct x86_exception fault;
> +	const unsigned access_mask =
> +		PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK;

Don't suppose you'd be in the mood to kill the bare 'unsigned'?

  WARNING: Prefer 'unsigned int' to bare use of 'unsigned'

>  
>  	if (!(error_code & PFERR_PRESENT_MASK) ||
> -	    vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, error_code, &fault) != UNMAPPED_GVA) {
> +	    vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva,
> +					    error_code & access_mask,
> +					    &fault) != UNMAPPED_GVA) {

Alternatively, what about capturing the result in a new variable (instead of
defining the mask) to make the wrap suck less (or just overflow like the
current code), e.g.:

        u32 access = error_code &
                     (PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK);

        if (!(error_code & PFERR_PRESENT_MASK) ||
            vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, &fault) != UNMAPPED_GVA) {


>  		/*
>  		 * If vcpu->arch.walk_mmu->gva_to_gpa succeeded, the page
>  		 * tables probably do not match the TLB.  Just proceed
> -- 
> 2.26.2
> 
