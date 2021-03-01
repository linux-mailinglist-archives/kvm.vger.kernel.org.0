Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2003285A7
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 17:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236482AbhCAQ4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 11:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbhCAQxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 11:53:03 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73524C061793
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 08:52:22 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id e6so11967068pgk.5
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 08:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T/RvTXXj1fHhS6pDebXjXsLRHzgREZZdses7ac9FecU=;
        b=qqLG0esrfyaJDCgXtQXSlHVnvaAwNLscOcf1wClK2t1DcHXsQALrKEdQnWPWPa97SB
         U8ElHWdhGW4bHBVJcDUOdRKGk7cVWfkpv1tNHOlvJmeE+V20enPJib5bSSFZjve/i6cV
         2E8ZqlG6a2RwgIZ8IMqMUOCLpw3ar88QdExj6JQks3thivP+y2EffqFY59F7AhmNfWgI
         TXTl0wNwhKN6NoRKHzV00sPFaeZ7JZNV68RdPtnoZEIXrZT2oKnR8QBV0XEA3NiBLoM9
         LppvH/Yg//JHCH24rOTVVaznN/8jeRMw+aWYBiYdzBIyxm5aoAZcGsey/ZoA3YC7g8IU
         rd9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T/RvTXXj1fHhS6pDebXjXsLRHzgREZZdses7ac9FecU=;
        b=ADFFVUI6RZqCEnhOCCE51DfFBkezY69NQ1N6LEIE5qKRGHzfvvJst2VQKOjMPvms0S
         HM/ZfoYvqYQpWq2lzde96q2eSirCugkvw/1swUykq/OXPIVEgzLCaNoRVJHgYJNxpKYQ
         IF8CL/ppR3KwSJRjYuyPP5brHUEHDxNU0bA71c6oIViq6bbP3X8/19B+nx5es94OoKIN
         0npcGcGMZ3ZDiNrwOUQ1kTUrTeTBGpQ/HyZrAc3Ji3U3LAYoacB+YpGzBFSMfUgI0yYP
         sGRlPlhygrzPDq17PmrprYCPZwEV5C7lixZ87eO9mv+pAoyIGLFBfUhh5pt+xMKZu+qB
         3VtA==
X-Gm-Message-State: AOAM531akFxQ/v3JDG4hqoN8+iyhf6V/YZRLKlCBkm36/p/fjfeHl8iJ
        S6AsBhr4/tyJnULsm/bFEPIpQg==
X-Google-Smtp-Source: ABdhPJxNWfRBWWn7dXFAd3ZRYsqgpInq6d5ZBvZ+K7Updq8rGL/NbEEMAOIjrNU7xOL2tUG0cRwjIg==
X-Received: by 2002:a63:ee55:: with SMTP id n21mr14279404pgk.372.1614617541221;
        Mon, 01 Mar 2021 08:52:21 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id y3sm18295223pfp.77.2021.03.01.08.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 08:52:20 -0800 (PST)
Date:   Mon, 1 Mar 2021 08:52:13 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [PATCH 19/25] KVM: VMX: Add basic handling of VM-Exit from SGX
 enclave
Message-ID: <YD0bvUPfTRsxnTfT@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
 <918aaa770de5d98cf81cce8b6cdb6faad32cbeb7.1614590788.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <918aaa770de5d98cf81cce8b6cdb6faad32cbeb7.1614590788.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 01, 2021, Kai Huang wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 50810d471462..df8e338267aa 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1570,12 +1570,18 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
>  
>  static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
>  {
> +	if (to_vmx(vcpu)->exit_reason.enclave_mode) {
> +		kvm_queue_exception(vcpu, UD_VECTOR);

Rereading my own code, I think it would be a good idea to add a comment here
explaining that injecting #UD is technically wrong, but avoids giving guest
userspace an easy way to DoS the guest.  The EPT misconfig is a good example;
guest userspace could have executed a simple MOV <reg>, <mem> instruction, in
which case injecting a #UD is bizarre behavior.  But, the alternative is exiting
to userspace with KVM_INTERNAL_ERROR_EMULATION, which is all but guaranteed to
kill the guest.

If KVM, specifically handle_emulation_failure(), ever gains a more sophisticated
mechanism for handling userspace emulation errors, this should be updated too.

	/*
	 * Emulation of instructions in SGX enclaves is impossible as RIP does
	 * not point  tthe failing instruction, and even if it did, the code
	 * stream is inaccessible.  Inject #UD instead of exiting to userspace
	 * so that guest userspace can't DoS the guest simply by triggering
	 * emulation (enclaves are CPL3 only).
	 */

> +		return false;
> +	}
>  	return true;
>  }

...

> @@ -5384,6 +5415,9 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>  {
>  	gpa_t gpa;
>  
> +	if (!vmx_can_emulate_instruction(vcpu, NULL, 0))
> +		return 1;
> +
>  	/*
>  	 * A nested guest cannot optimize MMIO vmexits, because we have an
>  	 * nGPA here instead of the required GPA.
> -- 
> 2.29.2
> 
