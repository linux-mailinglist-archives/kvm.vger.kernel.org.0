Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB6A4C43FC
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 12:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238266AbiBYLzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 06:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiBYLzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 06:55:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CE9711F03BE
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 03:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645790089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t5OTJjVGSzfVZo0LlaA0N3es7e6jixcsuOulO2sU+rA=;
        b=AQYVR86r6//rqVZtF99QZ0E+dohZ9iT2Lk5bM2yX3YVceXuSmaireyrq7PLIQvUNOoOZ3a
        2jVxyrG69cfxuORQcH3A+sGMQ5mr3RP9D9vVtSXaFnvzjZB67vplFXbuSItNngLp583s32
        CIiPF++G/27CWNFSXCrf1R+PwWg/apM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-rsf0rFMTOmqVr3qfIlnjhg-1; Fri, 25 Feb 2022 06:54:48 -0500
X-MC-Unique: rsf0rFMTOmqVr3qfIlnjhg-1
Received: by mail-wm1-f70.google.com with SMTP id l31-20020a05600c1d1f00b00380e3425ba7so1219821wms.9
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 03:54:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=t5OTJjVGSzfVZo0LlaA0N3es7e6jixcsuOulO2sU+rA=;
        b=UndaGk1kWCGS4wO90HtG5ZYQo0MRDEmOBPYB7mu1QWIZyxuiiVAUw9MXqMTPcyWoEg
         aheRXbBEqvahXikmFgamDSdhDxOKVQwAs9Y3IlsOKN+Fi35YAQnAaLUpbY/xWyGS5QmQ
         0ZWBhef0frY/FboUx4zFPt7rLdi/CRmevGwNm+SASdqZPIbvj7puw0t+eiK0Lu8nVpO/
         XJwbXx8+Ax0wAVFWLnBH+wLQYYFONxXOkzXPa/3YepFH35G7l/7a0MrBlZScDW5DkYf+
         7rZ7mQhOaWv0vpXhyPTRn7jWhOgNC1bRJizQ9f6Q7AcRZmgQrg7Pav/GPryZpHIX8an2
         3TTw==
X-Gm-Message-State: AOAM531ihpOKbIY29PRg0vEzClIDpoTjQti1bPNjgWHAEvsDTmfbfeCU
        Hq/N7qMRHTITGsSEhRT8B+/n4JTTTIx8ErfkCvqymAAFY0+FuRBnMlkxN8X3sFz5n4T4Zbh76Mw
        5o26d5qJ7JDvs
X-Received: by 2002:adf:f583:0:b0:1ed:b63a:819a with SMTP id f3-20020adff583000000b001edb63a819amr5604884wro.104.1645790087504;
        Fri, 25 Feb 2022 03:54:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx67U1WsbeuQteN9nrhAbsubtGnfNd/1oqIV+gK/6870hFcNOQHb1ZChGRuWDFLIWE1FHqSlw==
X-Received: by 2002:adf:f583:0:b0:1ed:b63a:819a with SMTP id f3-20020adff583000000b001edb63a819amr5604867wro.104.1645790087246;
        Fri, 25 Feb 2022 03:54:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id i15-20020a05600011cf00b001edc2966dd4sm2017169wrx.47.2022.02.25.03.54.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 03:54:46 -0800 (PST)
Message-ID: <c7681cf8-7b99-eb43-0195-d35adb011f21@redhat.com>
Date:   Fri, 25 Feb 2022 12:54:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] KVM: VMX: Enable Notify VM exit
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Tao Xu <tao3.xu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220223062412.22334-1-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220223062412.22334-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/22 07:24, Chenyi Qiang wrote:
> Nested handling
> - Nested notify VM exits are not supported yet. Keep the same notify
>    window control in vmcs02 as vmcs01, so that L1 can't escape the
>    restriction of notify VM exits through launching L2 VM.
> - When L2 VM is context invalid, synthesize a nested
>    EXIT_REASON_TRIPLE_FAULT to L1 so that L1 won't be killed due to L2's
>    VM_CONTEXT_INVALID happens.
> 
> Notify VM exit is defined in latest Intel Architecture Instruction Set
> Extensions Programming Reference, chapter 9.2.
> 
> TODO: Allow to change the window size (to enable the feature) at runtime,
> which can make it more flexible to do management.

I only have a couple questions, any changes in response to the question
I can do myself.

> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 1dfe23963a9e..f306b642c3e1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2177,6 +2177,9 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>   	if (cpu_has_vmx_encls_vmexit())
>   		vmcs_write64(ENCLS_EXITING_BITMAP, INVALID_GPA);
>   
> +	if (notify_window >= 0)
> +		vmcs_write32(NOTIFY_WINDOW, notify_window);

Is a value of 0 valid?  Should it be changed to the recommended value of
128000 in hardware_setup()?

> +	case EXIT_REASON_NOTIFY:
> +		return nested_cpu_has2(vmcs12,
> +			SECONDARY_EXEC_NOTIFY_VM_EXITING);

This should be "return false" since you don't expose the secondary
control to L1 (meaning, it will never be set).

> +		 * L0 will synthensize a nested TRIPLE_FAULT to kill L2 when
> +		 * notify VM exit occurred in L2 and NOTIFY_VM_CONTEXT_INVALID is
> +		 * set in exit qualification. In this case, if notify VM exit
> +		 * occurred incident to delivery of a vectored event, the IDT
> +		 * vectoring info are recorded in VMCS. Drop the pending event
> +		 * in vmcs12, otherwise L1 VMM will exit to userspace with
> +		 * internal error due to delivery event.
>  		 */
> -		vmcs12_save_pending_event(vcpu, vmcs12);
> +		if (to_vmx(vcpu)->exit_reason.basic != EXIT_REASON_NOTIFY)
> +			vmcs12_save_pending_event(vcpu, vmcs12);

I would prefer to call out the triple fault here:

                 /*
                  * Transfer the event that L0 or L1 may have wanted to inject into
                  * L2 to IDT_VECTORING_INFO_FIELD.
                  *
                  * Skip this if the exit is due to a NOTIFY_VM_CONTEXT_INVALID
                  * exit; in that case, L0 will synthesize a nested TRIPLE_FAULT
                  * vmexit to kill L2.  No IDT vectoring info is recorded for
                  * triple faults, and __vmx_handle_exit does not expect it.
                  */
                 if (!(to_vmx(vcpu)->exit_reason.basic == EXIT_REASON_NOTIFY)
                       && kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu))
                         vmcs12_save_pending_event(vcpu, vmcs12);

What do you think?

Paolo

