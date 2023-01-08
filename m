Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896F66617D7
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 19:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbjAHSKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 13:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbjAHSKS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 13:10:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AFC626E
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 10:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673201380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TcK/oOjYX5olPMBFZAkzj53ornHTRUc3nsjwLPHRVNY=;
        b=IJhDXD9cTAlylkX6A69iNqRuEH+//RQzVh1eGOY03nMrXutl1ZK2z8OCQ6HUT1DoXuygrU
        MyUUueXWUjNs/LTnKr8IFrXN8HmfvxXbUXKmtS+fD4ommqJJi8bOP0qiSZTLmZR0aIYt11
        dTl0o1Ppot71X1ZGSItYJwLIiNUtuIM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-661-4JlKgMxKPoKNDfWWK4v3jw-1; Sun, 08 Jan 2023 13:09:38 -0500
X-MC-Unique: 4JlKgMxKPoKNDfWWK4v3jw-1
Received: by mail-ed1-f72.google.com with SMTP id z8-20020a056402274800b0048a31c1746aso3981549edd.0
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 10:09:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TcK/oOjYX5olPMBFZAkzj53ornHTRUc3nsjwLPHRVNY=;
        b=KnjhK5L778mgx3rI6ctxmTJ71FfvHawQ1BdbSKBBhoAF5SFtJixXGElt98Zeb3a6gV
         XzJqHZCR+0yediIrSkddbrxfqkEMysdgI8EqodNQFWuqfr4058gJWRTYxBwj7VTLbcTp
         XCECeKIjIt2B/yUSrC3oPN2v8sybiEJCpoUHOWVEv9lFqI+kMciQ2fsX+Ixf3BMzWUMo
         8MMR4QNpH0ZJcV/EHd3szUpfKZrMqF+boEckAPqUabfJ0WpvJSXseWnZUCrAB508iTE0
         /ZPWIZGunKwf+I7sVLM6gusX4Wt1djLfTM54slAjc9d9qV1DEL1+nZcBQWLIUgLLrDcP
         OAiw==
X-Gm-Message-State: AFqh2kp0S+6fv1a1kN4dz2EsemM8HyR5IuomZglOwldBl6EBjx68x5P3
        4pqzicrkxQxKdENgEIat66ZZUfpDjNwDU0yXFLBrIXWaCNEENbc6XGzYOShazF5AsKuYxIzRswi
        xq7o6JDVoqnRf
X-Received: by 2002:a05:6402:520b:b0:48b:58be:472c with SMTP id s11-20020a056402520b00b0048b58be472cmr42900790edd.18.1673201377729;
        Sun, 08 Jan 2023 10:09:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuQdO/gpZDZRWbq2rrQQYyC4A6CTYQDwzTVeWlNSzQ8BgxwlZGcOJGPiaY/cNazc5AD182pNQ==
X-Received: by 2002:a05:6402:520b:b0:48b:58be:472c with SMTP id s11-20020a056402520b00b0048b58be472cmr42900781edd.18.1673201377523;
        Sun, 08 Jan 2023 10:09:37 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id u13-20020aa7db8d000000b004833aac6ef9sm2751139edt.62.2023.01.08.10.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 10:09:37 -0800 (PST)
Message-ID: <20b6eec1cfa10f0499fc4cd53670503c42d74699.camel@redhat.com>
Subject: Re: [PATCH 6/6] KVM: VMX: Intercept reads to invalid and write-only
 x2APIC registers
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Orr <marcorr@google.com>, Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Sun, 08 Jan 2023 20:09:35 +0200
In-Reply-To: <20230107011025.565472-7-seanjc@google.com>
References: <20230107011025.565472-1-seanjc@google.com>
         <20230107011025.565472-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2023-01-07 at 01:10 +0000, Sean Christopherson wrote:
> Intercept reads to invalid (non-existent) and write-only x2APIC registers
> when configuring VMX's MSR bitmaps for x2APIC+APICv.  When APICv is fully
> enabled, Intel hardware doesn't validate the registers on RDMSR and
> instead blindly retrieves data from the vAPIC page, i.e. it's software's
> responsibility to intercept reads to non-existent and write-only MSRs.
> 
> Fixes: 8d14695f9542 ("x86, apicv: add virtual x2apic support")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 82c61c16f8f5..1be2bc7185be 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4031,7 +4031,7 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
>  	u64 *msr_bitmap = (u64 *)vmx->vmcs01.msr_bitmap;
>  	u8 mode;
>  
> -	if (!cpu_has_vmx_msr_bitmap())
> +	if (!cpu_has_vmx_msr_bitmap() || WARN_ON_ONCE(!lapic_in_kernel(vcpu)))
>  		return;
>  
>  	if (cpu_has_secondary_exec_ctrls() &&
> @@ -4053,11 +4053,11 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
>  	 * Reset the bitmap for MSRs 0x800 - 0x83f.  Leave AMD's uber-extended
>  	 * registers (0x840 and above) intercepted, KVM doesn't support them.
>  	 * Intercept all writes by default and poke holes as needed.  Pass
> -	 * through all reads by default in x2APIC+APICv mode, as all registers
> -	 * except the current timer count are passed through for read.
> +	 * through reads for all valid registers by default in x2APIC+APICv
> +	 * mode, only the current timer count needs on-demand emulation by KVM.
>  	 */
>  	if (mode & MSR_BITMAP_MODE_X2APIC_APICV)
> -		msr_bitmap[read_idx] = 0;
> +		msr_bitmap[read_idx] = ~kvm_lapic_readable_reg_mask(vcpu->arch.apic);
>  	else
>  		msr_bitmap[read_idx] = ~0ull;
>  	msr_bitmap[write_idx] = ~0ull;

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


