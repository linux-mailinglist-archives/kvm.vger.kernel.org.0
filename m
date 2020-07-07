Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B5E21663E
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 08:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgGGGLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 02:11:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:46685 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgGGGLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 02:11:07 -0400
IronPort-SDR: p0PIgJrCUjLrCw3eYmG7Qwf6TMQF1mEERDcY4k5Xsw/TI0gyOQ6rtcg0Jzhum+ZI34+K66Y1fw
 7Wi47KhbmHfw==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="145643551"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="145643551"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 23:11:06 -0700
IronPort-SDR: Ic5QahZia01aDkIbIo2DsFJbqUaDAzcEjxU8uOBOuZYpCMIDaWYZ82c/A4btsliPneit15TAbl
 P7YTbI4R6aig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="305542613"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jul 2020 23:11:06 -0700
Date:   Mon, 6 Jul 2020 23:11:05 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
Message-ID: <20200707061105.GH5208@linux.intel.com>
References: <20200702174455.282252-1-mlevitsk@redhat.com>
 <20200702181606.GF3575@linux.intel.com>
 <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 05, 2020 at 12:40:25PM +0300, Maxim Levitsky wrote:
> > Rather than compute the mask every time, it can be computed once on module
> > load and stashed in a global.  Note, there's a RFC series[*] to support
> > reprobing bugs at runtime, but that has bigger issues with existing KVM
> > functionality to be addressed, i.e. it's not our problem, yet :-).
> > 
> > [*] https://lkml.kernel.org/r/1593703107-8852-1-git-send-email-mihai.carabas@oracle.com
> 
> Thanks for the pointer!
>  
> Note though that the above code only runs once, since after a single
> successful (non #GP) set of it to non-zero value, it is cleared in MSR bitmap
> for both reads and writes on both VMX and SVM.

For me the performance is secondary to documenting the fact that the host
valid bits are fixed for a given instance of the kernel.  There's enough
going on in kvm_spec_ctrl_valid_bits_host() that's it's not super easy to
see that it's a "constant" value.

> This is done because of performance reasons which in this case are more
> important than absolute correctness.  Thus to some extent the guest checks in
> the above are pointless.
>  
> If you ask me, I would just remove the kvm_spec_ctrl_valid_bits, and pass
> this msr to guest right away and not on first access.

That would unnecessarily penalize guests that don't utilize the MSR as KVM
would need to do a RDMSR on every VM-Exit to grab the guest's value.

One oddity with this whole thing is that by passing through the MSR, KVM is
allowing the guest to write bits it doesn't know about, which is definitely
not normal.  It also means the guest could write bits that the host VMM
can't.

Somehwat crazy idea inbound... rather than calculating the valid bits in
software, what if we throw the value at the CPU and see if it fails?  At
least that way the host and guest are subject to the same rules.  E.g.

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2062,11 +2062,19 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
                        return 1;

-               if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
-                       return 1;
-
+               ret = 0;
                vmx->spec_ctrl = data;
-               if (!data)
+
+               local_irq_disable();
+               if (rdmsrl_safe(MSR_IA32_SPEC_CTRL, &data))
+                       ret = 1;
+               else if (wrmsrl_safe(MSR_IA32_SPEC_CTRL, vmx->spec_ctrl))
+                       ret = 1;
+               else
+                       wrmsrl(MSR_IA32_SPEC_CTRL, data))
+               local_irq_enable();
+
+               if (ret || !vmx->spec_ctrl)
                        break;

                /*

