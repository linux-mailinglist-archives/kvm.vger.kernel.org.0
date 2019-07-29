Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430547929A
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 19:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbfG2Ruq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 13:50:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:29243 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbfG2Ruq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 13:50:46 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 10:50:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,323,1559545200"; 
   d="scan'208";a="173324183"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jul 2019 10:50:45 -0700
Date:   Mon, 29 Jul 2019 10:50:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH RESEND] KVM: X86: Use IPI shorthands in kvm guest when
 support
Message-ID: <20190729175044.GI21120@linux.intel.com>
References: <1564121727-30020-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1564121727-30020-1-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 26, 2019 at 02:15:27PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> IPI shorthand is supported now by linux apic/x2apic driver, switch to 
> IPI shorthand for all excluding self and all including self destination 
> shorthand in kvm guest, to avoid splitting the target mask into serveral 
> PV IPI hypercalls.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Nadav Amit <namit@vmware.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> Note: rebase against tip tree's x86/apic branch
> 
>  arch/x86/kernel/kvm.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index b7f34fe..87b73b8 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -34,7 +34,9 @@
>  #include <asm/hypervisor.h>
>  #include <asm/tlb.h>
>  
> +static struct apic orig_apic;

Copying the entire struct apic to snapshot two functions is funky,
explicitly capturing the two functions would be more intuitive.

Tangentially related, kvm_setup_pv_ipi() can be annotated __init,
which means the function snapshots can be __ro_after_init.

That being said, can't we just remove kvm_send_ipi_all() and
kvm_send_ipi_allbutself()?  AFAICT, the variations that lead to shorthand
are only used when apic_use_ipi_shorthand is true.  If that isn't the
case, fixing the callers in the APIC code seems like the correct thing to
do.

>  static int kvmapf = 1;
> +DECLARE_STATIC_KEY_FALSE(apic_use_ipi_shorthand);
>  static int __init parse_no_kvmapf(char *arg)
>  {
> @@ -507,12 +509,18 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
>  
>  static void kvm_send_ipi_allbutself(int vector)
>  {
> -	kvm_send_ipi_mask_allbutself(cpu_online_mask, vector);
> +	if (static_branch_likely(&apic_use_ipi_shorthand))
> +		orig_apic.send_IPI_allbutself(vector);
> +	else
> +		kvm_send_ipi_mask_allbutself(cpu_online_mask, vector);
>  }
>  
>  static void kvm_send_ipi_all(int vector)
>  {
> -	__send_ipi_mask(cpu_online_mask, vector);
> +	if (static_branch_likely(&apic_use_ipi_shorthand))
> +		orig_apic.send_IPI_all(vector);
> +	else
> +		__send_ipi_mask(cpu_online_mask, vector);
>  }
>  
>  /*
> @@ -520,6 +528,8 @@ static void kvm_send_ipi_all(int vector)
>   */
>  static void kvm_setup_pv_ipi(void)
>  {
> +	orig_apic = *apic;
> +
>  	apic->send_IPI_mask = kvm_send_ipi_mask;
>  	apic->send_IPI_mask_allbutself = kvm_send_ipi_mask_allbutself;
>  	apic->send_IPI_allbutself = kvm_send_ipi_allbutself;
> -- 
> 2.7.4
> 
