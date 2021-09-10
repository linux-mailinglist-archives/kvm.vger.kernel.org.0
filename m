Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5F540735D
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 00:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhIJWaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 18:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhIJWaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 18:30:09 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BF3C061756
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 15:28:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y17so3108887pfl.13
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 15:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4upt3twKDfZzhgS0KgOjUOkdNu2DrvH+oHdfHKvpBis=;
        b=ijf1cAa06KmG8VG4yG/vZj+aKdYQHscgegBlH1jKsvQ6Olz+GvbOeVuG/VZzCXTKpg
         1caEROaD1K+MxvAqmwSEhnxizRgmKKWg9iOjRiozofTqfKug6x4aTGevh7FD91sp6txx
         ctJcUmm3qc9e2W0+XN9tBq/Eu1EWiueXeIDzQnQdAlKroh3d5Ox4AqoUbSWLGLVT4JGh
         uJSQsMYkjApL6Swo2Tt/Q7sK8d0JE4RfVEC+WqrPHjOG735oCN7GFv9qr9yBOkBiVSZl
         ATbdKldN1HnauUXPEJ6FgT6HZzCO5StEKyrLE9VGVZBJ+kSAAPXFexsw4Zdetmapf/ym
         AfNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4upt3twKDfZzhgS0KgOjUOkdNu2DrvH+oHdfHKvpBis=;
        b=ixiXsvU7oeyZsh9IGU7LBLH/Zp89AfS/YRpv+2AB4iipqM9SL6/a36+zHE7NQVwvzB
         iWIYzxzJucA6rKiHeaQxW1r4XrKmsWF3xgxnDCmYtxFhGj6fab4OBJQlPfbON9aJMX7G
         FpyakfywY3aAYmgTFMU8S2fKWQj5s7Rqms4BDFD6XSDS5eW7d+amqXFYI8D4J+8GkFR6
         foF0XYH6aRR7zBWsDUT/7LIKh4UoKd7dJ6tfvXHLCHfnsWnnHIHGcrSUKCS1atlNv9wr
         kTq0EvtNd27wn/QyS3YMcP/zrNbETsbuAVkE2+2VOcO/Jmc3LvrgIccjvhyvBB4CrX3A
         rlyg==
X-Gm-Message-State: AOAM533EY1BCf+sjZAIZ+L5Gtyoz/gaJU+PhkGu+RP/VW8Xmy4lyyBYL
        Clg6aRuoDSQgCeah8UthV8xWCg==
X-Google-Smtp-Source: ABdhPJybrp1lFRB62MiX2OEEesSapj9DXuY35HgMvFjaHgw34dnJ1mADN2UED3P1jGz9j10NtpsZ3Q==
X-Received: by 2002:a63:f913:: with SMTP id h19mr9284584pgi.351.1631312937535;
        Fri, 10 Sep 2021 15:28:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x65sm494491pfb.29.2021.09.10.15.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 15:28:57 -0700 (PDT)
Date:   Fri, 10 Sep 2021 22:28:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v4 5/6] KVM: x86: Support interrupt dispatch in x2APIC
 mode with APIC-write VM exit
Message-ID: <YTvcJZSd1KQvNmaz@google.com>
References: <20210809032925.3548-1-guang.zeng@intel.com>
 <20210809032925.3548-6-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809032925.3548-6-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021, Zeng Guang wrote:
> Since IA x86 platform introduce features of IPI virtualization and
> User Interrupts, new behavior applies to the execution of WRMSR ICR

What do User Interrupts have to do with anything?

> register that causes APIC-write VM exit instead of MSR-write VM exit
> in x2APIC mode.

Please lead with what support is actually being added, and more directly state
what the new behavior actually is, e.g. when should KVM expect these types of
traps.  The shortlog helps a bit, but APIC-write is somewhat ambiguous without
the context that it refers to the trap-like exits, not exception-like exits on
the WRMSR itself.

Peeking ahead, this probably should be squashed with the next patch that adds
IPI virtualizatio support.  Without that patch's code that disables ICR MSR
intercepts for IPIv, this patch makes zero sense.

I'm not totally opposed to splitting IPIv support into two patches, I just don't
like splitting out this tiny subset that makes zero sense without the IPIv
code/context.  I assume you took this approach so that the shortlog could be
"KVM: VMX:" for the IPIv code.  IMO it's perfectly ok to keep that shortlog even
though there are minor changes outside of vmx/.  VMX is the only user of
kvm_apic_write_nodecode(), so it's not wrong to say it affects only VMX.

> This requires KVM to emulate writing 64-bit value to offset 300H on
> the virtual-APIC page(VICR) for guest running in x2APIC mode when

Maybe stylize that as vICR to make it stand out as virtual ICR?

> APIC-wrtie VM exit occurs. Prevoisely KVM doesn't consider this
       ^^^^^                 ^^^^^^^^^^
       write                 Previously

> situation as CPU never produce APIC-write VM exit in x2APIC mode before.
> 
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/kvm/lapic.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index ba5a27879f1d..0b0f0ce96679 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2188,7 +2188,14 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>  	/* hw has done the conditional check and inst decode */
>  	offset &= 0xff0;
>  
> -	kvm_lapic_reg_read(vcpu->arch.apic, offset, 4, &val);

Probably worth snapshotting vcpu->arch.apic.

> +	if (apic_x2apic_mode(vcpu->arch.apic) && (offset == APIC_ICR)) {


A comment here would be _extremely_ helpful.  IIUC, this path is reached when IPIv
is enabled for all ICR writes that can't be virtualized, e.g. broadcast IPIs.

And I'm tempted to say this should WARN and do nothing if KVM gets an exit on
anything except ICR writes.

> +		u64 icr_val = *((u64 *)(vcpu->arch.apic->regs + offset));

Maybe just bump "val" to a u64?

Rather than open code this, can't this be:

		kvm_lapic_reg_read(apic, offset, 8, &val);
> +
> +		kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR2, (u32)(icr_val>>32));
> +		val = (u32)icr_val;

Hmm, this is the third path that open codes the ICR2:ICR split.  I think it's
probably worth adding a helper (patch below), and this can become:

void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
{
	struct kvm_lapic *apic = vcpu->arch.apic;
	u64 val = 0;

	/* hw has done the conditional check and inst decode */
	offset &= 0xff0;

	/* TODO: optimize to just emulate side effect w/o one more write */
	if (apic_x2apic_mode(apic)) {
		if (WARN_ON_ONCE(offset != APIC_ICR))
			return 1;

		kvm_lapic_reg_read(apic, offset, 8, &val);
		kvm_lapic_reg_write64(apic, offset, val);
	} else {
		kvm_lapic_reg_read(apic, offset, 4, &val);
		kvm_lapic_reg_write(apic, offset, val);
	}
}

There is some risk my idea will backfire if the CPU traps other WRMSRs, but even
then the pedant in me thinks the code for that should be:


	if (apic_x2apic_mode(apic)) {
		int size = offset == APIC_ICR ? 8 : 4;

		kvm_lapic_reg_read(apic, offset, size, &val);
		kvm_lapic_reg_write64(apic, offset, val);
	} else {
		...
	}

or worst case scenario, move the APIC_ICR check back so that the non-ICR path
back to "if (apic_x2apic_mode(vcpu->arch.apic) && (offset == APIC_ICR))" so that
it naturally falls into the 4-byte read+write.

> +	} else {
> +		kvm_lapic_reg_read(vcpu->arch.apic, offset, 4, &val);
> +	}
>  
>  	/* TODO: optimize to just emulate side effect w/o one more write */
>  	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
> -- 
> 2.25.1


From c7641cf0c2ea2a1c5e6dda4007f8d285595ff82d Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Sep 2021 15:07:57 -0700
Subject: [PATCH] KVM: x86: Add a helper to handle 64-bit APIC writes to ICR

Add a helper to handle 64-bit APIC writes, e.g. for x2APIC WRMSR, to
deduplicate the handling of ICR writes, which KVM needs to emulate as
back-to-back writes to ICR2 and then ICR.  Future support for IPI
virtualization will add yet another path where KVM must handle a 64-bit
APIC write.

Opportunistically fix the comment; ICR2 holds the destination (if there's
no shorthand), not the vector.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb00921203..5f526ee10301 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2183,6 +2183,14 @@ void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);

+static int kvm_lapic_reg_write64(struct kvm_lapic *apic, u32 reg, u64 data)
+{
+	/* For 64-bit ICR writes, set ICR2 (dest) before ICR (command). */
+	if (reg == APIC_ICR)
+		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	return kvm_lapic_reg_write(apic, reg, (u32)data);
+}
+
 /* emulate APIC access in a trap manner */
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
@@ -2794,10 +2802,7 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	if (reg == APIC_ICR2)
 		return 1;

-	/* if this is ICR write vector before command */
-	if (reg == APIC_ICR)
-		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
-	return kvm_lapic_reg_write(apic, reg, (u32)data);
+	return kvm_lapic_reg_write64(apic, reg, data);
 }

 int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
@@ -2828,10 +2833,7 @@ int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 reg, u64 data)
 	if (!lapic_in_kernel(vcpu))
 		return 1;

-	/* if this is ICR write vector before command */
-	if (reg == APIC_ICR)
-		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
-	return kvm_lapic_reg_write(apic, reg, (u32)data);
+	return kvm_lapic_reg_write64(apic, reg, data);
 }

 int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
--

