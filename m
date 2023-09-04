Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99437910AE
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 07:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351859AbjIDFFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 01:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242273AbjIDFFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 01:05:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05AFC5
        for <kvm@vger.kernel.org>; Sun,  3 Sep 2023 22:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693803921; x=1725339921;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tI9k2EMY2feJ2LVHM6pGvYt/+Gf2/l3SonByZWvwW5o=;
  b=Q817Q6uIB596N/L3HPYSQmC1Qn0rzAl+2dnF2WyZO6TyyaeBRuj8YRNz
   Du3kxxhzAzEs2Hm5cdSD0rg6WgrlO9DrhBIVG+tvXRVqoNWRJeHAHV/pA
   6+mP2rNeFI9NtbhnOmKL0AtiWjrgO3U5p/v4q18pCtN+E8TkPmMP8qr0e
   y6N5pcrgXcZ8yiZeLu1J6/OqCZFfwp7H/SV4XApXOQXbpaUjJJ07SeiRW
   tZGgUSynUNGlOmncsqUIPSELAA3z8dFqv2oFYJl0OQpOBnY+s3dEKSYSH
   W9ZCsBiuJrR5csqMUDWseqipAxI3xthdbMWXhJZchnzQbeuLjx8v/Yw5S
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="379230468"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="379230468"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2023 22:05:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="830769558"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="830769558"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2023 22:05:19 -0700
Date:   Mon, 4 Sep 2023 13:02:40 +0800
From:   Tao Su <tao1.su@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, chao.gao@intel.com,
        guang.zeng@intel.com, yi1.lai@intel.com
Subject: Re: [PATCH 2/2] KVM: x86: Clear X2APIC_ICR_UNUSED_12 after
 APIC-write VM-exit
Message-ID: <ZPVk8DgxqGJhwxrE@linux.bj.intel.com>
References: <20230904013555.725413-1-tao1.su@linux.intel.com>
 <20230904013555.725413-3-tao1.su@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904013555.725413-3-tao1.su@linux.intel.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 09:35:55AM +0800, Tao Su wrote:
> When IPI virtualization is enabled, a WARN is triggered if bit12 of ICR
> MSR is set after APIC-write VM-exit. The reason is kvm_apic_send_ipi()
> thinks the APIC_ICR_BUSY bit should be cleared because KVM has no delay,
> but kvm_apic_write_nodecode() doesn't clear the APIC_ICR_BUSY bit.
> 
> Since bit12 of ICR is no longer BUSY bit but UNUSED bit in x2APIC mode,
> and SDM has no detail about how hardware will handle the UNUSED bit12
> set, we tested on Intel CPU (SRF/GNR) with IPI virtualization and found
> the UNUSED bit12 was also cleared by hardware without #GP. Therefore,
> the clearing of bit12 should be still kept being consistent with the
> hardware behavior.
> 
> Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
> Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> Tested-by: Yi Lai <yi1.lai@intel.com>
> ---
>  arch/x86/kvm/lapic.c | 27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index a983a16163b1..09a376aeb4a0 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1482,8 +1482,17 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
>  {
>  	struct kvm_lapic_irq irq;
>  
> -	/* KVM has no delay and should always clear the BUSY/PENDING flag. */
> -	WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
> +	/*
> +	 * In non-x2apic mode, KVM has no delay and should always clear the
> +	 * BUSY/PENDING flag. In x2apic mode, KVM should clear the unused bit12
> +	 * of ICR since hardware will also clear this bit. Although
> +	 * APIC_ICR_BUSY and X2APIC_ICR_UNUSED_12 are same, they mean different
> +	 * things in different modes.
> +	 */
> +	if (!apic_x2apic_mode(apic))
> +		WARN_ON_ONCE(icr_low & APIC_ICR_BUSY);
> +	else
> +		WARN_ON_ONCE(icr_low & X2APIC_ICR_UNUSED_12);
>  
>  	irq.vector = icr_low & APIC_VECTOR_MASK;
>  	irq.delivery_mode = icr_low & APIC_MODE_MASK;
> @@ -2429,13 +2438,12 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>  	 * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
>  	 * xAPIC, ICR writes need to go down the common (slightly slower) path
>  	 * to get the upper half from ICR2.
> +	 *
> +	 * TODO: optimize to just emulate side effect w/o one more write
>  	 */
>  	if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
> -		val = kvm_lapic_get_reg64(apic, APIC_ICR);

Sorry for the mistake, I notice this line is removed accidentally, I will add it back in the
next version.

> -		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
> -		trace_kvm_apic_write(APIC_ICR, val);
> +		kvm_x2apic_icr_write(apic, val);
>  	} else {
> -		/* TODO: optimize to just emulate side effect w/o one more write */
>  		val = kvm_lapic_get_reg(apic, offset);
>  		kvm_lapic_reg_write(apic, offset, (u32)val);
>  	}
> @@ -3122,7 +3130,12 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
>  
>  int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
>  {
> -	data &= ~APIC_ICR_BUSY;
> +	/*
> +	 * The Delivery Status Bit(bit 12) is removed in x2apic mode, but this
> +	 * bit is also cleared by hardware, so keep consistent with hardware
> +	 * behavior to clear this bit.
> +	 */
> +	data &= ~X2APIC_ICR_UNUSED_12;
>  
>  	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
>  	kvm_lapic_set_reg64(apic, APIC_ICR, data);
> -- 
> 2.34.1
> 
