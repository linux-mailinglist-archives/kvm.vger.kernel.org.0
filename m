Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 582DA13D602
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 09:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbgAPIhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 03:37:37 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57934 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731011AbgAPIhg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Jan 2020 03:37:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579163854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x5EZSe+9Pt81JQl4mryCnHZI8SvnSuTdiu5y1K9dQzI=;
        b=T+xMzKjikTRtoru8fwSuW4Hi5/qw48xswuEcj/X1OpRUV4HLkC5WtgEbmvaiR8K+RbE3Ls
        JLfS0w75QU/btINasbN5Q7v8Uh6Erz7y8YnXfQ/Xo+XfNzIUprEN9h6W44qLfGBwEj7jQs
        OhADWhp9U8+dxnJu/MoqihiqsSekZ0U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-wvHMRMeiNlGLddyr3JVZUQ-1; Thu, 16 Jan 2020 03:37:33 -0500
X-MC-Unique: wvHMRMeiNlGLddyr3JVZUQ-1
Received: by mail-wr1-f71.google.com with SMTP id f17so9028637wrt.19
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 00:37:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=x5EZSe+9Pt81JQl4mryCnHZI8SvnSuTdiu5y1K9dQzI=;
        b=ac5wilghT09hNMCxBTvPyhfInVfHcGuMvyhlP8puqYCHYuSi2KRw7DB/vaCbn4xdNG
         K2/gpGQOcUHLq0VVmu6WyHXQH9/hU8skN0JBu5LHieO63C7CXWbSn1Ow+LvMCigweIMs
         mB97kJVMVScR2s81hMYksX92m8uD+w8vdVMmXRxYLlj4divOGoN+wrNlgdHTb6IL2ysG
         kibhNo4RgkfTp50MjLwuJSowEoDUaDOqQ0+26l6WxKzJuz4ECJKytNoqpnvqJJevRDc2
         v6a4bi1rSisSnMdAEQBPY3pYb3nQirpKn9ufYvIks4qx/n2B0hvQVQsaQB5VkYMcX+/h
         IUgA==
X-Gm-Message-State: APjAAAUjUPzOKP/M1aFGN3ObzL4XXulgBPrDC0wMPKvw3ySqUEjQsHgI
        K1d48pyUldm7vH1O1pqBeNCzmI44TwL0cSPJJv4HQMG1rYFcfl27j4NRcpF/AFBppepSkRLI9ol
        KwC03b3OGsGUY
X-Received: by 2002:a05:600c:149:: with SMTP id w9mr4684892wmm.132.1579163852040;
        Thu, 16 Jan 2020 00:37:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqxAS0c5V9EBFob+4qrLfpmDyD0TOeBaQJ7jQklcM2mmRbvfERzK+oeo9lfKXgGGs+WtPAgdmg==
X-Received: by 2002:a05:600c:149:: with SMTP id w9mr4684872wmm.132.1579163851810;
        Thu, 16 Jan 2020 00:37:31 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e18sm28618279wrr.95.2020.01.16.00.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 00:37:31 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization out of nested_enable_evmcs()
In-Reply-To: <A93CDB6E-0E46-4AA8-9B45-8F2EE3C723F5@oracle.com>
References: <20200115171014.56405-1-vkuznets@redhat.com> <20200115171014.56405-3-vkuznets@redhat.com> <A93CDB6E-0E46-4AA8-9B45-8F2EE3C723F5@oracle.com>
Date:   Thu, 16 Jan 2020 09:37:29 +0100
Message-ID: <87a76niypi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

>> On 15 Jan 2020, at 19:10, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> 
>> With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
>> with default (matching CPU model) values and in case eVMCS is also enabled,
>> fails.
>> 
>> It would be possible to drop VMX feature filtering completely and make
>> this a guest's responsibility: if it decides to use eVMCS it should know
>> which fields are available and which are not. Hyper-V mostly complies to
>> this, however, there is at least one problematic control:
>> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
>> which Hyper-V enables. As there is no 'apic_addr_field' in eVMCS, we
>> fail to handle this properly in KVM. It is unclear how this is supposed
>> to work, genuine Hyper-V doesn't expose the control so it is possible that
>> this is just a bug (in Hyper-V).
>
> Have you tried contacted someone at Hyper-V team about this?
>

Yes, I have.

>> 
>> Move VMX controls sanitization from nested_enable_evmcs() to vmx_get_msr(),
>> this allows userspace to keep setting controls it wants and at the same
>> time hides them from the guest.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> arch/x86/kvm/vmx/evmcs.c | 38 ++++++++++++++++++++++++++++++++------
>> arch/x86/kvm/vmx/evmcs.h |  1 +
>> arch/x86/kvm/vmx/vmx.c   | 10 ++++++++--
>> 3 files changed, 41 insertions(+), 8 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
>> index 89c3e0caf39f..b5d6582ba589 100644
>> --- a/arch/x86/kvm/vmx/evmcs.c
>> +++ b/arch/x86/kvm/vmx/evmcs.c
>> @@ -346,6 +346,38 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>>        return 0;
>> }
>> 
>> +void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
>> +{
>> +	u32 ctl_low = (u32)*pdata, ctl_high = (u32)(*pdata >> 32);
>
> Nit: I dislike defining & initialising multiple local vars on same line.
>
>> +	/*
>> +	 * Enlightened VMCS doesn't have certain fields, make sure we don't
>> +	 * expose unsupported controls to L1.
>> +	 */
>> +
>> +	switch (msr_index) {
>> +	case MSR_IA32_VMX_PINBASED_CTLS:
>> +	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
>> +		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
>> +		break;
>> +	case MSR_IA32_VMX_EXIT_CTLS:
>> +	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
>> +		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
>> +		break;
>> +	case MSR_IA32_VMX_ENTRY_CTLS:
>> +	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
>> +		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
>> +		break;
>> +	case MSR_IA32_VMX_PROCBASED_CTLS2:
>> +		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
>> +		break;
>> +	case MSR_IA32_VMX_VMFUNC:
>> +		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
>> +		break;
>> +	}
>> +
>> +	*pdata = ctl_low | ((u64)ctl_high << 32);
>> +}
>> +
>> int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>> 			uint16_t *vmcs_version)
>> {
>> @@ -356,11 +388,5 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>> 	if (vmcs_version)
>> 		*vmcs_version = nested_get_evmcs_version(vcpu);
>> 
>> -	vmx->nested.msrs.pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
>> -	vmx->nested.msrs.entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
>> -	vmx->nested.msrs.exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
>> -	vmx->nested.msrs.secondary_ctls_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
>> -	vmx->nested.msrs.vmfunc_controls &= ~EVMCS1_UNSUPPORTED_VMFUNC;
>> -
>> 	return 0;
>> }
>> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
>> index 07ebf6882a45..b88d9807a796 100644
>> --- a/arch/x86/kvm/vmx/evmcs.h
>> +++ b/arch/x86/kvm/vmx/evmcs.h
>> @@ -201,5 +201,6 @@ bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
>> uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>> int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>> 			uint16_t *vmcs_version);
>> +void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
>> 
>> #endif /* __KVM_X86_VMX_EVMCS_H */
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index e3394c839dea..8eb74618b8d8 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1849,8 +1849,14 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> 	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
>> 		if (!nested_vmx_allowed(vcpu))
>> 			return 1;
>> -		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
>> -				       &msr_info->data);
>> +		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
>> +				    &msr_info->data))
>> +			return 1;
>> +		if (!msr_info->host_initiated &&
>> +		    vmx->nested.enlightened_vmcs_enabled)
>> +			nested_evmcs_filter_control_msr(msr_info->index,
>> +							&msr_info->data);
>> +		break;
>
> Nit: It seems more elegant to me to put the call to nested_evmcs_filter_control_msr() inside vmx_get_vmx_msr().
>

Sure, will move it there (in case we actually decide to merge this)

> The patch itself makes sense to me and looks correct.
> Reviewed-by: Liran Alon <liran.alon@oracle.com>

Thanks!

-- 
Vitaly

