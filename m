Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130214F804B
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 15:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbiDGNSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 09:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiDGNSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 09:18:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D77D3FCBC7
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 06:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649337410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gxyncrlt7RLqQpANAvK4gzaM+JXpQZHWGLpD+x9q3MA=;
        b=TYC4EHITELAGr6eLkJHpeKnZnE4WR77j8Yc86YLxPHXbVaW5hCxbYM71CCVJRNNZPU8Dxw
        lEDhQ24nYn5lFoQUXVU18Dl/zDtlPkvbFwwNPO0MB4nXxhUIIPj676O0UbC9F6P462Ay+K
        1SWrlkooksr5uTLucCoHLBqoDRjeb50=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-QV_Epb19P4-gzoNS1dAgfQ-1; Thu, 07 Apr 2022 09:16:41 -0400
X-MC-Unique: QV_Epb19P4-gzoNS1dAgfQ-1
Received: by mail-ej1-f72.google.com with SMTP id sd5-20020a1709076e0500b006e6e277d2b4so3045098ejc.14
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 06:16:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Gxyncrlt7RLqQpANAvK4gzaM+JXpQZHWGLpD+x9q3MA=;
        b=GdkslXN7BO4Uoj9De1RnFYgn5nfe0IHLUYLLJpXqE7gKnRTB2rm/z+J0jpicIATvvB
         KFa/T6Fq2x1Azd9kMJdqAVMyX6megM1GHALKJu6IGw4NzAMQg/9ae1N9h032A1AdNT1C
         OjR3Xx7HhIySBuFWAWll6Hh8ZgHb5m1FDKWcYBMMUrno83m8hDV8LDxVpdEJE83h43lx
         Rp2FcVD4COe7IDKUuAeDEhPb5Q5KB8OsjBvChNK9Pqxw6NzmLxjhdmq7IPXK6vIe86Uv
         rdvmaXYrZiHWUDpwZkoB77eSP7dYgeU4zGy+sLONemBSUOhjfV8dgunFStWfJDp8e6i4
         lLHQ==
X-Gm-Message-State: AOAM530oxINDP5oOt7p3ut03Qd0Cn1xsPYaah9P1DhgHtouHVIy8YKO7
        8xroD4IX0YovziAdauM+o6sScOuEymDp5NmSrJ+AskX3gUJ5LZtKMmrfPclZDzIbyMptds0SPGJ
        f9y823yfXfS+9
X-Received: by 2002:aa7:cdd9:0:b0:41d:10cc:7904 with SMTP id h25-20020aa7cdd9000000b0041d10cc7904mr1448207edw.202.1649337400063;
        Thu, 07 Apr 2022 06:16:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSCWSdtJiIqzDwM2V1SeuLpq3+XDTTs55SIcCItVNZ2TH0esp8yd9rxn8N4YUvHnk6+VUcOQ==
X-Received: by 2002:aa7:cdd9:0:b0:41d:10cc:7904 with SMTP id h25-20020aa7cdd9000000b0041d10cc7904mr1448183edw.202.1649337399863;
        Thu, 07 Apr 2022 06:16:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k12-20020a170906054c00b006e8289dc23csm1354640eja.9.2022.04.07.06.16.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 06:16:38 -0700 (PDT)
Message-ID: <adea5393-cbe9-3344-0ef5-461a72321f72@redhat.com>
Date:   Thu, 7 Apr 2022 15:16:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 091/104] KVM: TDX: Handle TDX PV CPUID hypercall
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <e3621e9893796d2bd8ea8b1f16c1616ae9df3f37.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <e3621e9893796d2bd8ea8b1f16c1616ae9df3f37.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Wire up TDX PV CPUID hypercall to the KVM backend function.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 53f59fb92dcf..f7c9170d596a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -893,6 +893,30 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
> +{
> +	u32 eax, ebx, ecx, edx;
> +
> +	/* EAX and ECX for cpuid is stored in R12 and R13. */
> +	eax = tdvmcall_p1_read(vcpu);
> +	ecx = tdvmcall_p2_read(vcpu);
> +
> +	kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
> +
> +	/*
> +	 * The returned value for CPUID (EAX, EBX, ECX, and EDX) is stored into
> +	 * R12, R13, R14, and R15.
> +	 */
> +	tdvmcall_p1_write(vcpu, eax);
> +	tdvmcall_p2_write(vcpu, ebx);
> +	tdvmcall_p3_write(vcpu, ecx);
> +	tdvmcall_p4_write(vcpu, edx);
> +
> +	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +
> +	return 1;
> +}
> +
>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
> @@ -904,6 +928,9 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   		return tdx_emulate_vmcall(vcpu);
>   
>   	switch (tdvmcall_exit_reason(vcpu)) {
> +	case EXIT_REASON_CPUID:
> +		return tdx_emulate_cpuid(vcpu);
> +
>   	default:
>   		break;
>   	}

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

but I don't think tdvmcall_*_{read,write} add much.

Paolo

