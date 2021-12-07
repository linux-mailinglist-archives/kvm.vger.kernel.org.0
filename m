Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C616746C6F7
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237640AbhLGV4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237599AbhLGV4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 16:56:09 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED701C061574
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 13:52:38 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id p18so148339plf.13
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 13:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JL5qJjLDIgnSytq1wNjOFcMLN1rjFpWCLXQ/+cciUx4=;
        b=sRP8AhuHh6wBBEYwse3kd2LliqTLfwmgG+jGMK4vDLAAfe5ICx1xLyGebN6NMyv/19
         7f7GXv+c2f2hb8kDfYGC60Ip18tJvrwgj1J1TVERddzP6X4MWYBXnNNY/bVzWXhOkTaA
         eTyO2VJQOpeijanG2otlEWU4uA2GUkvqqtpK1M+HD78bpkpEF4TdQ1B72ymXN8ynYLV6
         5+JyruYVhYPKPRGtIlabDFcVOx5VPz/osizl4P2n5P/yteoQ8Wks/aypdCzqNYgbOUMM
         BEzqDuxa5jKlMcfs7POdeUNQ5fVfhB6P5xJWcRTnqoPYZ2QSaiDqII32tgoCnKGn/AR3
         CtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JL5qJjLDIgnSytq1wNjOFcMLN1rjFpWCLXQ/+cciUx4=;
        b=ihaIc4jgnCU40tmlTFUVM2Wm24Q6ASs2PYxV96s/bZWk5RUUmmrw4dKM0lMFxrq270
         a4Bf00d//2YCeRN7FlGfNPkQl1DrSE94Io7iiBoPDcSQ9TluZyusPehknEaF5p+lk4+a
         7LNkV5ky0+59I9OI9gSPDebpzU0Xvzhaj5mWr7wmdBuoU3VPeNZ1I9i3zPlIMIiyEKAl
         F+HU0IUwz9qmdzPR9/yolzwBR6LHJLcWVfA7sGcAQmJle15TQU2DGo0dPqySVJCOQ59/
         RDH1R2tQT0Y/+W7rvf10fdxd8yIdCxFvGddC+UIH7/WMBJgnw/vlM0iGL5Tzwyglj/mO
         k3AQ==
X-Gm-Message-State: AOAM530aiNtHarYBlapLiY17iUvxncJz6eHm7dK0KemFCEndyrZkyrgg
        ErEV/MFI7Wyk5binYm/11NsXdQ==
X-Google-Smtp-Source: ABdhPJy1JgCb31VDgMUgAmidG1E0PGeDHIl1Yd4BxetgT7PLTi67ct2dNj9AK8WwG5/BAT24bp6SIQ==
X-Received: by 2002:a17:90a:98f:: with SMTP id 15mr2113559pjo.166.1638913958297;
        Tue, 07 Dec 2021 13:52:38 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j127sm737620pfg.14.2021.12.07.13.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 13:52:37 -0800 (PST)
Date:   Tue, 7 Dec 2021 21:52:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/4] KVM: X86: Handle implicit supervisor access with SMAP
Message-ID: <Ya/XoYTsEvkPqRuh@google.com>
References: <20211207095039.53166-1-jiangshanlai@gmail.com>
 <20211207095039.53166-4-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207095039.53166-4-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021, Lai Jiangshan wrote:
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index b70b36734bc0..0cb2c52377c8 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -252,23 +252,26 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  				  unsigned pte_access, unsigned pte_pkey,
>  				  unsigned pfec)
>  {
> -	int cpl = static_call(kvm_x86_get_cpl)(vcpu);
>  	unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
>  
>  	/*
> -	 * If CPL < 3, SMAP prevention are disabled if EFLAGS.AC = 1.
> +	 * If explicit supervisor accesses, SMAP is disabled

Slight reword, and each clause can fit on one line.

	 * For explicit supervisor accesses, SMAP is disabled if EFLAGS.AC = 1.
	 *
	 * For implicit supervisor accesses, SMAP cannot be overridden.

> +	 * if EFLAGS.AC = 1.
>  	 *
> -	 * If CPL = 3, SMAP applies to all supervisor-mode data accesses
> -	 * (these are implicit supervisor accesses) regardless of the value
> -	 * of EFLAGS.AC.
> +	 * If implicit supervisor accesses, SMAP can not be disabled
> +	 * regardless of the value EFLAGS.AC.
>  	 *
> -	 * This computes (cpl < 3) && (rflags & X86_EFLAGS_AC), leaving
> +	 * SMAP works on supervisor accesses only, and not_smap can
> +	 * be set or not set when user access with neither has any bearing
> +	 * on the result.

This is quite jumbled, I'd just drop it entirely, the interesting bits are
the rules for implicit vs. explicit and the blurb below that describes the magic.

> +	 *
> +	 * This computes explicit_access && (rflags & X86_EFLAGS_AC), leaving

Too many &&, the logic below is a bitwise &, not a logical &&.

>  	 * the result in X86_EFLAGS_AC. We then insert it in place of
>  	 * the PFERR_RSVD_MASK bit; this bit will always be zero in pfec,
>  	 * but it will be one in index if SMAP checks are being overridden.
>  	 * It is important to keep this branchless.

Heh, so important that it incurs multiple branches and possible VMREADs in
vmx_get_cpl() and vmx_get_rflags().  And before static_call, multiple retpolines
to boot.  Probably a net win now as only the first permission_fault() check for
a given VM-Exit be penalized, but the comment is amusing nonetheless.

>  	 */
> -	unsigned long not_smap = (cpl - 3) & (rflags & X86_EFLAGS_AC);
> +	u32 not_smap = (rflags & X86_EFLAGS_AC) & vcpu->arch.explicit_access;

I really, really dislike shoving this into vcpu->arch.  I'd much prefer to make
this a property of the access, even if that means adding another param or doing
something gross with @access (@pfec here).

>  	int index = (pfec >> 1) +
>  		    (not_smap >> (X86_EFLAGS_AC_BIT - PFERR_RSVD_BIT + 1));
>  	bool fault = (mmu->permissions[index] >> pte_access) & 1;
