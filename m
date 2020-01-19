Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E66F141D06
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 09:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgASI5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 03:57:00 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39631 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726538AbgASI47 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 19 Jan 2020 03:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579424217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYiSqZsoUxk59GYwuuinpJvpzr3CUrQGX17TAVKUd9M=;
        b=A1y/VT3Yl1i6wWESiR37hNHMSb3iWDaH5fcBkefnGTa/l98L3ca2zPCqTR+6fEGs1Ng9w1
        oYDsw9daHwD0UTCfYhjdGw4s2b+I/Uv5dhqAgSVmSgYCcT3u6dfVwobTsdoeAa3D4CJfv6
        hlIFYonf8HuVQTcilBsvNoDaOmAZ1zY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-nuAaLx2NOaimQ1bXWQYzjA-1; Sun, 19 Jan 2020 03:56:56 -0500
X-MC-Unique: nuAaLx2NOaimQ1bXWQYzjA-1
Received: by mail-wr1-f70.google.com with SMTP id d8so12538712wrq.12
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 00:56:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XYiSqZsoUxk59GYwuuinpJvpzr3CUrQGX17TAVKUd9M=;
        b=tFVFiQyQTz9OCVlZ1FEtUifXggmQ8ccfUib++nL4lsDqDMILEKbxMsEJJ/eTGQ2ADK
         t1i5lvtMS7DphuxepHQdtMiKpbbDSa8wATiy7J43tLvENgbRVt/iMuNC/sOEN5hiilyy
         pIVfoWqvBxeKP19509UiyPV+ujJFJA5unZxpdlH2+YJLkcZfxrMK490FxN8PEUSRejbn
         z7EHrKAwPY4hO+ErSzuzvbYWy1OkdPHg4gO0Qa/e+sZ2BuE8oeC7NetUq3l2+gq1NDD5
         9JBTc0ZJIvmCs4cWKIml9fu7xSN6zKGvd5TP5zpG14xHCjGsTIOwWU0XE+ds9o3T9V2e
         Qulg==
X-Gm-Message-State: APjAAAWmfBA1RMJsrr9wJrHSwESYzKveERZUAL6Ms4CyEtg6bt5W05QE
        1JX1IX1m9HU5llssOrhG09VHPw9z48xyPc37a4ioTl34x+p8pI/Jaw5RiHohXDKP5Y1vMQwvOvU
        e7IBbHuU5WUoS
X-Received: by 2002:adf:f382:: with SMTP id m2mr12511195wro.163.1579424214878;
        Sun, 19 Jan 2020 00:56:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqy3hpEI4LdGbyyH/gPG8rwa4h0D4DwMMEfXfH8wq9gklCIDI9UZ6ixaqsOjHzN9nRy9aKqi1w==
X-Received: by 2002:adf:f382:: with SMTP id m2mr12511177wro.163.1579424214481;
        Sun, 19 Jan 2020 00:56:54 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o4sm42040694wrw.97.2020.01.19.00.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 00:56:53 -0800 (PST)
Subject: Re: [PATCH RFC 2/3] x86/kvm/hyper-v: move VMX controls sanitization
 out of nested_enable_evmcs()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-3-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c4bdb57-08fb-2c2d-9234-b7efffeb72ed@redhat.com>
Date:   Sun, 19 Jan 2020 09:54:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200115171014.56405-3-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/01/20 18:10, Vitaly Kuznetsov wrote:
> With fine grained VMX feature enablement QEMU>=4.2 tries to do KVM_SET_MSRS
> with default (matching CPU model) values and in case eVMCS is also enabled,
> fails.
> 
> It would be possible to drop VMX feature filtering completely and make
> this a guest's responsibility: if it decides to use eVMCS it should know
> which fields are available and which are not. Hyper-V mostly complies to
> this, however, there is at least one problematic control:
> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
> which Hyper-V enables. As there is no 'apic_addr_field' in eVMCS, we
> fail to handle this properly in KVM. It is unclear how this is supposed
> to work, genuine Hyper-V doesn't expose the control so it is possible that
> this is just a bug (in Hyper-V).

Yes, it most likely is and it would be nice if Microsoft fixed it, but I
guess we're stuck with it for existing Windows versions.  Well, for one
we found a bug in Hyper-V and not the converse. :)

There is a problem with this approach, in that we're stuck with it
forever due to live migration.  But I guess if in the future eVMCS v2
adds an apic_address field we can limit the hack to eVMCS v1.  Another
possibility is to use the quirks mechanism but it's overkill for now.

Unless there are objections, I plan to apply these patches.

Paolo


> Move VMX controls sanitization from nested_enable_evmcs() to vmx_get_msr(),
> this allows userspace to keep setting controls it wants and at the same
> time hides them from the guest.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/evmcs.c | 38 ++++++++++++++++++++++++++++++++------
>  arch/x86/kvm/vmx/evmcs.h |  1 +
>  arch/x86/kvm/vmx/vmx.c   | 10 ++++++++--
>  3 files changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 89c3e0caf39f..b5d6582ba589 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -346,6 +346,38 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>         return 0;
>  }
>  
> +void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
> +{
> +	u32 ctl_low = (u32)*pdata, ctl_high = (u32)(*pdata >> 32);
> +	/*
> +	 * Enlightened VMCS doesn't have certain fields, make sure we don't
> +	 * expose unsupported controls to L1.
> +	 */
> +
> +	switch (msr_index) {
> +	case MSR_IA32_VMX_PINBASED_CTLS:
> +	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
> +		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
> +		break;
> +	case MSR_IA32_VMX_EXIT_CTLS:
> +	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
> +		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> +		break;
> +	case MSR_IA32_VMX_ENTRY_CTLS:
> +	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> +		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> +		break;
> +	case MSR_IA32_VMX_PROCBASED_CTLS2:
> +		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
> +		break;
> +	case MSR_IA32_VMX_VMFUNC:
> +		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
> +		break;
> +	}
> +
> +	*pdata = ctl_low | ((u64)ctl_high << 32);
> +}
> +
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  			uint16_t *vmcs_version)
>  {
> @@ -356,11 +388,5 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  	if (vmcs_version)
>  		*vmcs_version = nested_get_evmcs_version(vcpu);
>  
> -	vmx->nested.msrs.pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
> -	vmx->nested.msrs.entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> -	vmx->nested.msrs.exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> -	vmx->nested.msrs.secondary_ctls_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
> -	vmx->nested.msrs.vmfunc_controls &= ~EVMCS1_UNSUPPORTED_VMFUNC;
> -
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
> index 07ebf6882a45..b88d9807a796 100644
> --- a/arch/x86/kvm/vmx/evmcs.h
> +++ b/arch/x86/kvm/vmx/evmcs.h
> @@ -201,5 +201,6 @@ bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
>  uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
>  int nested_enable_evmcs(struct kvm_vcpu *vcpu,
>  			uint16_t *vmcs_version);
> +void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
>  
>  #endif /* __KVM_X86_VMX_EVMCS_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e3394c839dea..8eb74618b8d8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1849,8 +1849,14 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_VMX_BASIC ... MSR_IA32_VMX_VMFUNC:
>  		if (!nested_vmx_allowed(vcpu))
>  			return 1;
> -		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
> -				       &msr_info->data);
> +		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
> +				    &msr_info->data))
> +			return 1;
> +		if (!msr_info->host_initiated &&
> +		    vmx->nested.enlightened_vmcs_enabled)
> +			nested_evmcs_filter_control_msr(msr_info->index,
> +							&msr_info->data);
> +		break;
>  	case MSR_IA32_RTIT_CTL:
>  		if (pt_mode != PT_MODE_HOST_GUEST)
>  			return 1;
> 

