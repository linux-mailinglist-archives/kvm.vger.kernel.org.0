Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223426617CC
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 19:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbjAHSIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 13:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236162AbjAHSIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 13:08:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9F460D8
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 10:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673201268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTf5PU9DkBq3cJnr0rfouR0Ki+jixnDZ8xbnkzYq8a8=;
        b=T+JaaHUqEntW61GjwFDJz7PRJKL3XUuVLxIkBViWFJ0iYRy+R00S9K/+51le9SfzBlU8CW
        nfEZCSAwLlVUg2YpKE7QcGn3+RO3rK/J05f/QDl6qVh0o7M790/DaBKduU4RHYmcrTxrXS
        tRO2Ol44f8mQJ23xbqbNadTjQ+C5Xoc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-88-LA-hYvfeNcqXNYJVxHGNJg-1; Sun, 08 Jan 2023 13:07:44 -0500
X-MC-Unique: LA-hYvfeNcqXNYJVxHGNJg-1
Received: by mail-ej1-f71.google.com with SMTP id qk40-20020a1709077fa800b007eeb94ecdb5so4040708ejc.12
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 10:07:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KTf5PU9DkBq3cJnr0rfouR0Ki+jixnDZ8xbnkzYq8a8=;
        b=vjeNf2tC1g1fWJol8bsmipVkpkHSHM2QYqBZqKJ6fPeePQpd4wqAhwKNJWqd5ZSMXc
         aFi9Ffras2mgw3wzeNScKD2H58qyoKAAiMc/q6BJ6PAgP5R0pYkOt0sjtM9JMgVuqteR
         RwD5a8MN0R+SshvyCZoy/qjbTLroDFLOOZ93OjksEGFzKtxOlEmBkzM+b/zFkMJkdC6o
         O3VpbfnWhwv+21eYYNK+Z72WJP23UQw7T9Glqo21My6ZS1GsMShY3aB+LZnUEkf87fjo
         HyhfEtjZrfX9pS2awHjPx2Pl7aJyvD7T/3Je0H+v781NXQo3O8YC1YhqeYaHrGEig77s
         Yepg==
X-Gm-Message-State: AFqh2kovGJzlFGp2xSM5GCPVDEFvdgeMr2oIAmZrqe8QMVmcELmqspgK
        ugKkLCGgVxej0k/lK0EH15C/ZtggMw+3TxCqbgaBpwtDwhoUtBmBlKr0fHEgRPQmL7cdJxpQ7x5
        h/ImqUf6Fs5Gl
X-Received: by 2002:a05:6402:5167:b0:497:1b2:5f88 with SMTP id d7-20020a056402516700b0049701b25f88mr7891482ede.16.1673201263901;
        Sun, 08 Jan 2023 10:07:43 -0800 (PST)
X-Google-Smtp-Source: AMrXdXshWuvWvz6+gViRZUO8dIbFsnYlnt5CBvHZi0yROoV2o6BosPlbQN9ZjCO1iAMwCAwcXg1xGg==
X-Received: by 2002:a05:6402:5167:b0:497:1b2:5f88 with SMTP id d7-20020a056402516700b0049701b25f88mr7891471ede.16.1673201263694;
        Sun, 08 Jan 2023 10:07:43 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id l10-20020aa7d94a000000b0048ebf8a5736sm2770651eds.21.2023.01.08.10.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 10:07:43 -0800 (PST)
Message-ID: <5e50b87a4c7d19f9386bac1aa7061675018a2caa.camel@redhat.com>
Subject: Re: [PATCH 5/6] KVM: VMX: Always intercept accesses to unsupported
 "extended" x2APIC regs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Orr <marcorr@google.com>, Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Sun, 08 Jan 2023 20:07:41 +0200
In-Reply-To: <20230107011025.565472-6-seanjc@google.com>
References: <20230107011025.565472-1-seanjc@google.com>
         <20230107011025.565472-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-01-07 at 01:10 +0000, Sean Christopherson wrote:
> Don't clear the "read" bits for x2APIC registers above SELF_IPI (APIC regs
> 0x400 - 0xff0, MSRs 0x840 - 0x8ff).  KVM doesn't emulate registers in that
> space (there are a smattering of AMD-only extensions) and so should
> intercept reads in order to inject #GP.  When APICv is fully enabled,
> Intel hardware doesn't validate the registers on RDMSR and instead blindly
> retrieves data from the vAPIC page, i.e. it's software's responsibility to
> intercept reads to non-existent MSRs.
> 
> Fixes: 8d14695f9542 ("x86, apicv: add virtual x2apic support")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 38 ++++++++++++++++++++------------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c788aa382611..82c61c16f8f5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4018,26 +4018,17 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  		vmx_set_msr_bitmap_write(msr_bitmap, msr);
>  }
>  
> -static void vmx_reset_x2apic_msrs(struct kvm_vcpu *vcpu, u8 mode)
> -{
> -	unsigned long *msr_bitmap = to_vmx(vcpu)->vmcs01.msr_bitmap;
> -	unsigned long read_intercept;
> -	int msr;
> -
> -	read_intercept = (mode & MSR_BITMAP_MODE_X2APIC_APICV) ? 0 : ~0;
> -
> -	for (msr = 0x800; msr <= 0x8ff; msr += BITS_PER_LONG) {
> -		unsigned int read_idx = msr / BITS_PER_LONG;
> -		unsigned int write_idx = read_idx + (0x800 / sizeof(long));
> -
> -		msr_bitmap[read_idx] = read_intercept;
> -		msr_bitmap[write_idx] = ~0ul;
> -	}
> -}
> -
>  static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
>  {
> +	/*
> +	 * x2APIC indices for 64-bit accesses into the RDMSR and WRMSR halves
> +	 * of the MSR bitmap.  KVM emulates APIC registers up through 0x3f0,
> +	 * i.e. MSR 0x83f, and so only needs to dynamically manipulate 64 bits.
> +	 */
The above comment is better to be placed down below, near the actual write,
otherwise it is confusing.

> +	const int read_idx = APIC_BASE_MSR / BITS_PER_LONG_LONG;
> +	const int write_idx = read_idx + (0x800 / sizeof(u64));
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	u64 *msr_bitmap = (u64 *)vmx->vmcs01.msr_bitmap;
>  	u8 mode;
>  
>  	if (!cpu_has_vmx_msr_bitmap())
> @@ -4058,7 +4049,18 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
>  
>  	vmx->x2apic_msr_bitmap_mode = mode;
>  
> -	vmx_reset_x2apic_msrs(vcpu, mode);
> +	/*
> +	 * Reset the bitmap for MSRs 0x800 - 0x83f.  Leave AMD's uber-extended
> +	 * registers (0x840 and above) intercepted, KVM doesn't support them.

I don't think AMD calls them uber-extended. Just extended.

From a quick glance, these could have beeing very useful for VFIO passthrough of INT-X interrupts,
removing the need to mask the interrupt on per PCI device basis - instead you can just leave
the IRQ pending in ISR, while using SEOI and IER to ignore this pending bit for host.

I understand that the days of INT-X are long gone (and especially days of shared IRQ lines...)
and every sane device uses MSI/-X instead, but still.


> +	 * Intercept all writes by default and poke holes as needed.  Pass
> +	 * through all reads by default in x2APIC+APICv mode, as all registers
> +	 * except the current timer count are passed through for read.
> +	 */
> +	if (mode & MSR_BITMAP_MODE_X2APIC_APICV)
> +		msr_bitmap[read_idx] = 0;
> +	else
> +		msr_bitmap[read_idx] = ~0ull;
> +	msr_bitmap[write_idx] = ~0ull;
>  
>  	/*
>  	 * TPR reads and writes can be virtualized even if virtual interrupt

Other than the note about the comment,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky

