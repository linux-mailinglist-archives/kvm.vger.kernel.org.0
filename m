Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06607449AF8
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 18:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237689AbhKHRrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 12:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236862AbhKHRrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 12:47:33 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9050C061714
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 09:44:48 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g19so10751995pfb.8
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 09:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T7qOXVmH67t3UjgmC9OBAXcO6+4+TuLqSP9SMFrXUKA=;
        b=aw5xWNjO2HIMl8DL3l5ICwkJLmnsxQv7NBXLJWfXOxPWdOyG3/SJ3qNmiVHwqnqhti
         YPsr3U15WdTXcWP9izb2z0Us9dCrx9o4s3vAfSAG4bcHK+wGiBuePvsStG7wRfCpZWZD
         aDITPrejfoVadqTZRV+6g6D0JKldtHMEihJBgP1b98/ZELEjau0mw6walrIe94y6de1k
         Ab+o4bf8YZ2DUoLVnCi63nSqEYB7nu8FgUdiPATLbUsryzN+USnemKDeU6hfdfc0+90J
         kXP1iu82afzVciTwNR97nN3bAVSP8E13Zq5gNeiu184vny7+cnoKv5Iz/xcOsvb0dv4R
         IGaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T7qOXVmH67t3UjgmC9OBAXcO6+4+TuLqSP9SMFrXUKA=;
        b=r2+MLjQUUtHztHNxgeCfX4mBJoAs1RSCcPmc9taxgK0SJ60pxxZSiMw4lWfEQWssYt
         iJKxX3RQ30v0Y4SElhW8KpZk9z4w6eyOqpdfRphK0fdCrcbbxusV0CGTQMogIq7717vf
         /fXMl+q13Xerdbn6iaVlonuf8tZJJUzuD8tumVOT2Oy3naDcg36LRG3nfvTBwf79/bLW
         zpr1e5vwGODQM5HC4e+ZzkYQyedC1URL+E4J0L54PeQvMx6Xt56dDFWItyP2EPnS/Vbv
         owN6W0+3g42WB1lIVdBpY6fr4ZFdQCIF0gwef2TgPNFwnknblEJtAF2Qj+MigKvVvm4K
         8bPQ==
X-Gm-Message-State: AOAM53391npO/oX94RAQ6p5L/1IKAhjH7/NoR7hWvGxVwPWMf6GNJvrP
        ER8ZsRdK71IGyA3Km5OWDgri1A==
X-Google-Smtp-Source: ABdhPJwjw6K4kqrSPpv/9FjxKMKy7T04f7UYLZ7U+X1Vx74XuXD0QZkSCLiZ1aVqbFHbCHItZTjfdw==
X-Received: by 2002:a05:6a00:7cc:b0:49f:9cf1:2969 with SMTP id n12-20020a056a0007cc00b0049f9cf12969mr1153867pfu.12.1636393488024;
        Mon, 08 Nov 2021 09:44:48 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y22sm16825866pfi.206.2021.11.08.09.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 09:44:47 -0800 (PST)
Date:   Mon, 8 Nov 2021 17:44:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/7] KVM: X86: Expose IA32_PKRS MSR
Message-ID: <YYliC1kdT9ssX/f7@google.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
 <20210811101126.8973-4-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811101126.8973-4-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021, Chenyi Qiang wrote:
> +	u32           pkrs;

...

> @@ -1115,6 +1117,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  #endif
>  	unsigned long fs_base, gs_base;
>  	u16 fs_sel, gs_sel;
> +	u32 host_pkrs;

As mentioned in the previosu patch, I think it makes sense to track this as a u64
so that the only place in KVM that deas with the u64<=>u32 conversion is the below

	host_pkrs = get_current_pkrs();

>  	int i;
>  
>  	vmx->req_immediate_exit = false;
> @@ -1150,6 +1153,20 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  	 */
>  	host_state->ldt_sel = kvm_read_ldt();
>  
> +	/*
> +	 * Update the host pkrs vmcs field before vcpu runs.
> +	 * The setting of VM_EXIT_LOAD_IA32_PKRS can ensure
> +	 * kvm_cpu_cap_has(X86_FEATURE_PKS) &&
> +	 * guest_cpuid_has(vcpu, X86_FEATURE_PKS)
> +	 */
> +	if (vm_exit_controls_get(vmx) & VM_EXIT_LOAD_IA32_PKRS) {
> +		host_pkrs = get_current_pkrs();
> +		if (unlikely(host_pkrs != host_state->pkrs)) {
> +			vmcs_write64(HOST_IA32_PKRS, host_pkrs);
> +			host_state->pkrs = host_pkrs;
> +		}
> +	}
> +
>  #ifdef CONFIG_X86_64
>  	savesegment(ds, host_state->ds_sel);
>  	savesegment(es, host_state->es_sel);
> @@ -1371,6 +1388,15 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  		vmx->emulation_required = emulation_required(vcpu);
>  }
>  
> +static void vmx_set_pkrs(struct kvm_vcpu *vcpu, u64 pkrs)
> +{

Hrm.  Ideally this would be open coded in vmx_set_msr().  Long term, the RESET/INIT
paths should really treat MSR updates as "normal" host_initiated writes instead of
having to manually handle every MSR.

That would be a bit gross to handle in vmx_vcpu_reset() since it would have to
create a struct msr_data (because __kvm_set_msr() isn't exposed to vendor code),
but since vcpu->arch.pkrs is relevant to the MMU I think it makes sense to
initiate the write from common x86.

E.g. this way there's not out-of-band special code, vmx_vcpu_reset() is kept clean,
and if/when SVM gains support for PKRS this particular path Just Works.  And it would
be an easy conversion for my pipe dream plan of handling MSRs at RESET/INIT via a
list of MSRs+values.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..55881d13620f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11147,6 +11147,9 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
        kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
        kvm_rip_write(vcpu, 0xfff0);

+       if (kvm_cpu_cap_has(X86_FEATURE_PKS))
+               __kvm_set_msr(vcpu, MSR_IA32_PKRS, 0, true);
+
        vcpu->arch.cr3 = 0;
        kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);

> +	if (kvm_cpu_cap_has(X86_FEATURE_PKS)) {
> +		vcpu->arch.pkrs = pkrs;
> +		kvm_register_mark_available(vcpu, VCPU_EXREG_PKRS);
> +		vmcs_write64(GUEST_IA32_PKRS, pkrs);
> +	}
> +}
