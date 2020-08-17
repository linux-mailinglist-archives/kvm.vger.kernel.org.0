Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2113246E42
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 19:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389823AbgHQRWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 13:22:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:61735 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389816AbgHQRWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 13:22:36 -0400
IronPort-SDR: TAUe2uTwTVI6nPrDPM+SOMtrutA4JDauDBigh/U55F5qq9w9+97Q7BzZarL1C7Rn3NjAvft8TQ
 gm2SPDPrU8Rg==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="134818255"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="134818255"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 10:22:35 -0700
IronPort-SDR: nEoLZbUtp34BoUYd5WmOxfMcLgAQPMgFE8tvVUJU8KClPVVBi0dLi9d3gco++TBY/fY3P1cqiZ
 TCzf3cLJNS9Q==
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="292496184"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 10:22:34 -0700
Date:   Mon, 17 Aug 2020 10:22:33 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Subject: Re: [PATCH v3 7/9] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
Message-ID: <20200817172233.GF22407@linux.intel.com>
References: <20200710154811.418214-1-mgamal@redhat.com>
 <20200710154811.418214-8-mgamal@redhat.com>
 <20200715230006.GF12349@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715230006.GF12349@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 04:00:08PM -0700, Sean Christopherson wrote:
> On Fri, Jul 10, 2020 at 05:48:09PM +0200, Mohammed Gamal wrote:
> > Check guest physical address against it's maximum physical memory. If
> > the guest's physical address exceeds the maximum (i.e. has reserved bits
> > set), inject a guest page fault with PFERR_RSVD_MASK set.
> > 
> > This has to be done both in the EPT violation and page fault paths, as
> > there are complications in both cases with respect to the computation
> > of the correct error code.
> > 
> > For EPT violations, unfortunately the only possibility is to emulate,
> > because the access type in the exit qualification might refer to an
> > access to a paging structure, rather than to the access performed by
> > the program.
> > 
> > Trapping page faults instead is needed in order to correct the error code,
> > but the access type can be obtained from the original error code and
> > passed to gva_to_gpa.  The corrections required in the error code are
> > subtle. For example, imagine that a PTE for a supervisor page has a reserved
> > bit set.  On a supervisor-mode access, the EPT violation path would trigger.
> > However, on a user-mode access, the processor will not notice the reserved
> > bit and not include PFERR_RSVD_MASK in the error code.
> > 
> > Co-developed-by: Mohammed Gamal <mgamal@redhat.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++---
> >  arch/x86/kvm/vmx/vmx.h |  3 ++-
> >  2 files changed, 23 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 770b090969fb..de3f436b2d32 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -4790,9 +4790,15 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> >  
> >  	if (is_page_fault(intr_info)) {
> >  		cr2 = vmx_get_exit_qual(vcpu);
> > -		/* EPT won't cause page fault directly */
> > -		WARN_ON_ONCE(!vcpu->arch.apf.host_apf_flags && enable_ept);
> > -		return kvm_handle_page_fault(vcpu, error_code, cr2, NULL, 0);
> > +		if (enable_ept && !vcpu->arch.apf.host_apf_flags) {
> > +			/*
> > +			 * EPT will cause page fault only if we need to
> > +			 * detect illegal GPAs.
> > +			 */
> > +			kvm_fixup_and_inject_pf_error(vcpu, cr2, error_code);
> 
> This splats when running the PKU unit test, although the test still passed.
> I haven't yet spent the brain power to determine if this is a benign warning,
> i.e. simply unexpected, or if permission_fault() fault truly can't handle PK
> faults.
> 
>   WARNING: CPU: 25 PID: 5465 at arch/x86/kvm/mmu.h:197 paging64_walk_addr_generic+0x594/0x750 [kvm]
>   Hardware name: Intel Corporation WilsonCity/WilsonCity, BIOS WLYDCRB1.SYS.0014.D62.2001092233 01/09/2020
>   RIP: 0010:paging64_walk_addr_generic+0x594/0x750 [kvm]
>   Code: <0f> 0b e9 db fe ff ff 44 8b 43 04 4c 89 6c 24 30 8b 13 41 39 d0 89
>   RSP: 0018:ff53778fc623fb60 EFLAGS: 00010202
>   RAX: 0000000000000001 RBX: ff53778fc623fbf0 RCX: 0000000000000007
>   RDX: 0000000000000001 RSI: 0000000000000002 RDI: ff4501efba818000
>   RBP: 0000000000000020 R08: 0000000000000005 R09: 00000000004000e7
>   R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000007
>   R13: ff4501efba818388 R14: 10000000004000e7 R15: 0000000000000000
>   FS:  00007f2dcf31a700(0000) GS:ff4501f1c8040000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000000 CR3: 0000001dea475005 CR4: 0000000000763ee0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   PKRU: 55555554
>   Call Trace:
>    paging64_gva_to_gpa+0x3f/0xb0 [kvm]
>    kvm_fixup_and_inject_pf_error+0x48/0xa0 [kvm]
>    handle_exception_nmi+0x4fc/0x5b0 [kvm_intel]
>    kvm_arch_vcpu_ioctl_run+0x911/0x1c10 [kvm]
>    kvm_vcpu_ioctl+0x23e/0x5d0 [kvm]
>    ksys_ioctl+0x92/0xb0
>    __x64_sys_ioctl+0x16/0x20
>    do_syscall_64+0x3e/0xb0
>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>   ---[ end trace d17eb998aee991da ]---

Looks like this series got pulled for 5.9, has anyone looked into this?
