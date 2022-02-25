Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8BB4C47CE
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 15:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241752AbiBYOo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 09:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiBYOoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 09:44:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F99B1FEDA9
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 06:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645800261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=38BODecDhesVl9jpdYIHZFI7lHOcsXVLQj6WlTlICL4=;
        b=gfYjLT9in6VWPZnJFmiysLHezbTWrZoFERpWQRE0jKuxUGtqO3rZ+DaU/LDi+L+9H5FtT6
        Yy7Pi7Gt5fuIuwPd06OwUJrgY4aN1xbI4eEYE3uNiI9DEgWI6GQmDEcYBa00vaVFmEkwNl
        0WDZzWSmMfaHm6lXm8xfYKDmbs27/ko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-201-Oyt-b35CMfGP-7ElCxJH_w-1; Fri, 25 Feb 2022 09:44:18 -0500
X-MC-Unique: Oyt-b35CMfGP-7ElCxJH_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C57EFC80;
        Fri, 25 Feb 2022 14:44:15 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13DD927CC5;
        Fri, 25 Feb 2022 14:44:06 +0000 (UTC)
Message-ID: <91235d07cad41a75282df7fc222514dc1e991118.camel@redhat.com>
Subject: Re: [PATCH v6 5/9] KVM: x86: Add support for vICR APIC-write
 VM-Exits in x2APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>
Date:   Fri, 25 Feb 2022 16:44:05 +0200
In-Reply-To: <20220225082223.18288-6-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
         <20220225082223.18288-6-guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-25 at 16:22 +0800, Zeng Guang wrote:
> Upcoming Intel CPUs will support virtual x2APIC MSR writes to the vICR,
> i.e. will trap and generate an APIC-write VM-Exit instead of intercepting
> the WRMSR.  Add support for handling "nodecode" x2APIC writes, which
> were previously impossible.
> 
> Note, x2APIC MSR writes are 64 bits wide.
> 
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/kvm/lapic.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 629c116b0d3e..e4bcdab1fac0 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -67,6 +67,7 @@ static bool lapic_timer_advance_dynamic __read_mostly;
>  #define LAPIC_TIMER_ADVANCE_NS_MAX     5000
>  /* step-by-step approximation to mitigate fluctuation */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
> +static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
>  
>  static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
>  {
> @@ -2227,10 +2228,28 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
>  /* emulate APIC access in a trap manner */
>  void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>  {
> -	u32 val = kvm_lapic_get_reg(vcpu->arch.apic, offset);
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +	u64 val;
> +
> +	if (apic_x2apic_mode(apic)) {
> +		/*
> +		 * When guest APIC is in x2APIC mode and IPI virtualization
> +		 * is enabled, accessing APIC_ICR may cause trap-like VM-exit
> +		 * on Intel hardware. Other offsets are not possible.
> +		 */
> +		if (WARN_ON_ONCE(offset != APIC_ICR))
> +			return;
>  
> -	/* TODO: optimize to just emulate side effect w/o one more write */
> -	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
> +		kvm_lapic_msr_read(apic, offset, &val);
> +		if (val & APIC_ICR_BUSY)
> +			kvm_x2apic_icr_write(apic, val);
> +		else
> +			kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
I don't fully understand the above code.

First of where kvm_x2apic_icr_write is defined?

Second, I thought that busy bit is not used in x2apic mode?
At least in intel's SDM, section 10.12.9 'ICR Operation in x2APIC Mode'
this bit is not defined.


Best regards,
	Maxim Levitsky


> +	} else {
> +		val = kvm_lapic_get_reg(apic, offset);
> +		/* TODO: optimize to just emulate side effect w/o one more write */
> +		kvm_lapic_reg_write(apic, offset, (u32)val);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
>  


