Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA651AAADA
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 16:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636845AbgDOOug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 10:50:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54000 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S370969AbgDOOub (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 10:50:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586962230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JmRIH3xrhcbgQHMVx8VHgH6IzBuKHV31f9pg/cYCgHk=;
        b=VqF8wf2eTZlQ4Jl5b3n6AK8R61QoFi9fIGOYXIYg6V+OqopJ0CVnhsx6AEaNkPehFB9zr3
        9OoZRKXqf+sl1AcV0mDIrtJRbHsH0I2yYj05/6S1a4HZGU2vOMNbqbwjqggI4CsPGTAlU2
        cAWt9om0xKSY6hhqOBe/rTAYPktzxMk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-Y8qd1rLUOzGWeMgwijKnWA-1; Wed, 15 Apr 2020 10:50:28 -0400
X-MC-Unique: Y8qd1rLUOzGWeMgwijKnWA-1
Received: by mail-wm1-f71.google.com with SMTP id h184so2300292wmf.5
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:50:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JmRIH3xrhcbgQHMVx8VHgH6IzBuKHV31f9pg/cYCgHk=;
        b=t9Dg4qbL0rPPALWS0EV/c/GfqtnWjIOowbY2L4xPL53suHz5TiEvTykyGKcSH5znBS
         FDCneKuzj8RAQEAJRBq3M6bdfmD7Z7xUGwdg5KzNRZb9HR+yCBgxT7g28/PIqHkCLjNY
         iyaOcxxC5mMP6dPeKba3IpFJuoeUtIVBEXM3m4IIO0w3IqAqAY4LmFq8PCIYnJCzpx1q
         aComcbsnCUclHkgXuZWYtJR4YNggVuu4CpVBFt7TFie0u0VrmnHZBgRJpDIFjTP1eOrE
         9onTJxF6wyHg1xgxaFiL/P9pGp0YIEGeLCaor5LlHPxYYSLt204dhDFBxFQA7aYvHBFR
         Lzzg==
X-Gm-Message-State: AGi0PuYg2QDwT8EPMM0fU3deBSkeZaH5bI3FJ1Dw2vvVEh1+3OFo/J7y
        TBSycIYv+2J31eTOIO/2taDhYJ90NWmmn4zl0totXh//99O3PN4rJEmOwvzxGLTjK9YXmGySXfi
        uMy9+zNfd98gz
X-Received: by 2002:a1c:f306:: with SMTP id q6mr5540439wmq.169.1586962227547;
        Wed, 15 Apr 2020 07:50:27 -0700 (PDT)
X-Google-Smtp-Source: APiQypLcjHfqk25Aa2S/DDiPyO8G1mcE4MUuSHr0Ty2vQ+VKX2bmv150yUNUV66lay4PAfxpJjPUrg==
X-Received: by 2002:a1c:f306:: with SMTP id q6mr5540410wmq.169.1586962227207;
        Wed, 15 Apr 2020 07:50:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id f83sm23262658wmf.42.2020.04.15.07.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:50:26 -0700 (PDT)
Subject: Re: [PATCH v2] kvm: nVMX: reflect MTF VM-exits if injected by L1
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20200414224746.240324-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b57bad1d-d9ba-f380-94b6-a2c113dd6100@redhat.com>
Date:   Wed, 15 Apr 2020 16:50:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200414224746.240324-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/20 00:47, Oliver Upton wrote:
> According to SDM 26.6.2, it is possible to inject an MTF VM-exit via the
> VM-entry interruption-information field regardless of the 'monitor trap
> flag' VM-execution control. KVM appropriately copies the VM-entry
> interruption-information field from vmcs12 to vmcs02. However, if L1
> has not set the 'monitor trap flag' VM-execution control, KVM fails to
> reflect the subsequent MTF VM-exit into L1.
> 
> Fix this by consulting the VM-entry interruption-information field of
> vmcs12 to determine if L1 has injected the MTF VM-exit. If so, reflect
> the exit, regardless of the 'monitor trap flag' VM-execution control.
> 
> Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> ---
>  Parent commit: dbef2808af6c5 ("KVM: VMX: fix crash cleanup when KVM wasn't used")
> 
>  v1 => v2:
>  - removed unused 'struct kvm_vcpu *vcpu' from the signature of helper
>    function
> 
>  arch/x86/kvm/vmx/nested.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cbc9ea2de28f9..0d1400fa1e224 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5533,6 +5533,23 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
>  	return 1 & (b >> (field & 7));
>  }
>  
> +static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
> +{
> +	u32 entry_intr_info = vmcs12->vm_entry_intr_info_field;
> +
> +	if (nested_cpu_has_mtf(vmcs12))
> +		return true;
> +
> +	/*
> +	 * An MTF VM-exit may be injected into the guest by setting the
> +	 * interruption-type to 7 (other event) and the vector field to 0. Such
> +	 * is the case regardless of the 'monitor trap flag' VM-execution
> +	 * control.
> +	 */
> +	return entry_intr_info == (INTR_INFO_VALID_MASK
> +				   | INTR_TYPE_OTHER_EVENT);
> +}
> +
>  /*
>   * Return 1 if we should exit from L2 to L1 to handle an exit, or 0 if we
>   * should handle it ourselves in L0 (and then continue L2). Only call this
> @@ -5633,7 +5650,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>  	case EXIT_REASON_MWAIT_INSTRUCTION:
>  		return nested_cpu_has(vmcs12, CPU_BASED_MWAIT_EXITING);
>  	case EXIT_REASON_MONITOR_TRAP_FLAG:
> -		return nested_cpu_has_mtf(vmcs12);
> +		return nested_vmx_exit_handled_mtf(vmcs12);
>  	case EXIT_REASON_MONITOR_INSTRUCTION:
>  		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_EXITING);
>  	case EXIT_REASON_PAUSE_INSTRUCTION:
> 

Queued, thanks.

Paolo

