Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0C9BA88EC
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbfIDOkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 10:40:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:53895 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730067AbfIDOkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 10:40:47 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 07:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="185133289"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 04 Sep 2019 07:40:45 -0700
Date:   Wed, 4 Sep 2019 07:40:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 1/2] KVM: VMX: Disable posted interrupts for odd IRQs
Message-ID: <20190904144045.GA24079@linux.intel.com>
References: <20190904133511.17540-1-graf@amazon.com>
 <20190904133511.17540-2-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904133511.17540-2-graf@amazon.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 04, 2019 at 03:35:10PM +0200, Alexander Graf wrote:
> We can easily route hardware interrupts directly into VM context when
> they target the "Fixed" or "LowPriority" delivery modes.
> 
> However, on modes such as "SMI" or "Init", we need to go via KVM code
> to actually put the vCPU into a different mode of operation, so we can
> not post the interrupt
> 
> Add code in the VMX PI logic to explicitly refuse to establish posted
> mappings for advanced IRQ deliver modes. This reflects the logic in
> __apic_accept_irq() which also only ever passes Fixed and LowPriority
> interrupts as posted interrupts into the guest.
> 
> This fixes a bug I have with code which configures real hardware to
> inject virtual SMIs into my guest.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> 
> ---
> 
> v1 -> v2:
> 
>   - Make error message more unique
>   - Update commit message to point to __apic_accept_irq()
> ---
>  arch/x86/kvm/vmx/vmx.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 570a233e272b..8029fe658c30 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7401,6 +7401,28 @@ static int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
>  			continue;
>  		}
>  
> +		switch (irq.delivery_mode) {
> +		case dest_Fixed:
> +		case dest_LowestPrio:
> +			break;
> +		default:
> +			/*
> +			 * For non-trivial interrupt events, we need to go
> +			 * through the full KVM IRQ code, so refuse to take
> +			 * any direct PI assignments here.
> +			 */

IMO, a beefy comment is unnecessary, anyone that is digging through this
code has hopefully read the PI spec or at least understands the basic
concepts.  I.e. it should be obvious that PI can't be used for SMI, etc...

> +			ret = irq_set_vcpu_affinity(host_irq, NULL);
> +			if (ret < 0) {
> +				printk(KERN_INFO
> +				    "non-std IRQ failed to recover, irq: %u\n",
> +				    host_irq);
> +				goto out;
> +			}
> +
> +			continue;

Using a switch to filter out two types is a bit of overkill.  It also
probably makes sense to perform the deliver_mode checks before calling
kvm_intr_is_single_vcpu().  Why not simply something like this?  The
existing comment and error message are even generic enough to keep as is.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c030c96fc81a..e0111a271a5e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7372,7 +7372,9 @@ static int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
                 */

                kvm_set_msi_irq(kvm, e, &irq);
-               if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
+               if ((irq.delivery_mode != dest_Fixed &&
+                    irq.delivery_mode != dest_LowestPrio) ||
+                   !kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
                        /*
                         * Make sure the IRTE is in remapped mode if
                         * we don't handle it in posted mode.

> +		}
> +
>  		vcpu_info.pi_desc_addr = __pa(vcpu_to_pi_desc(vcpu));
>  		vcpu_info.vector = irq.vector;
>  
> -- 
> 2.17.1
> 
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 
> 
