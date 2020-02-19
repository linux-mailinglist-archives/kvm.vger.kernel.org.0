Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E863163E9A
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 09:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgBSINI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 03:13:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57598 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726156AbgBSINH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 03:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582099985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pDctdfwFBrTV0SnkT2kTBlJkAorz8Gzf3oCVSIBpe9U=;
        b=TojOR/Z3keEWNqtTWGjAN1zfgdIMrAEtE+rjkz9+ONN4Gs1ZcZJDqkDkBzX22Fz3qQY+YG
        WFTjl3PV9fhW7pfVoBT0JsGb8VEo3euBC35hP3NLLYudm/GjN0xhQdWe1QZDpzVY1wiHJ0
        uQwa9aEWm0O9IkO8/8J+o48lE40//XU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-rAGKpnOhO6GqQWD6G0XoYw-1; Wed, 19 Feb 2020 03:13:03 -0500
X-MC-Unique: rAGKpnOhO6GqQWD6G0XoYw-1
Received: by mail-wr1-f72.google.com with SMTP id a12so12197764wrn.19
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 00:13:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pDctdfwFBrTV0SnkT2kTBlJkAorz8Gzf3oCVSIBpe9U=;
        b=sFwAbjAqwH9Do9sMnamNa7plaevG0YQ8G4joQ1jikY36UQiA9QXD2u601buPQQFBPh
         LNq/vRqjbBqLCW0OFimuTKkJuy2aQaJS6s12lsICGrXK3djoGG6w2Oz4yAWtKK9VzLSb
         ptNvkr9jYX7uBncriCkxU8LJ7pr4vVuDIZuABtS9/Om4CLfcKd9QAj2BtuKsKf9U14/q
         QgulV21MEDxLglcFv0dz3wfpuz/o+57CRm+sBQ1L7vNj35KXyq9L9YF16Lvc4Z1FEhlN
         mY+yR6iQ71XkpebnQJGuzGNr1KWBDVpyrzVlC4ytDrPo6BqNoJTA+SI2dym2GAfSRtcS
         Upag==
X-Gm-Message-State: APjAAAUPV3szDhsYw5qwf4VEp0/u2hRcz0laB3AGDgdsnv360JDXQ8JE
        EAb6VRK+trmccH95Siiml0GqRuB/K2PwYyS9FK8aP1QEqthN53LG/xbSFr61i5dPTSPn4Yx/jQ4
        ZMnaPuyDtXacm
X-Received: by 2002:a05:600c:242:: with SMTP id 2mr8192405wmj.2.1582099982197;
        Wed, 19 Feb 2020 00:13:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqxpjEJCZzg5P7fZJI3JeqHfbRbkRNT2Atkg70WuxFkAdty0YFL7oK1EcnmuoTOrW/zZjQIx9g==
X-Received: by 2002:a05:600c:242:: with SMTP id 2mr8192383wmj.2.1582099981926;
        Wed, 19 Feb 2020 00:13:01 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id e17sm1881010wrn.62.2020.02.19.00.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 00:13:01 -0800 (PST)
Subject: Re: [PATCH v2 3/3] KVM: x86: Move #PF retry tracking variables into
 emulation context
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200218230310.29410-1-sean.j.christopherson@intel.com>
 <20200218230310.29410-4-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <40c8d560-1a5d-d592-5682-720980ca3dd9@redhat.com>
Date:   Wed, 19 Feb 2020 09:13:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200218230310.29410-4-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/02/20 00:03, Sean Christopherson wrote:
> Move last_retry_eip and last_retry_addr into the emulation context as
> they are specific to retrying an instruction after emulation failure.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

I'm not sure about this, since it's not used by emulate.c.  The other
two patches are good.

Paolo

> ---
>  arch/x86/include/asm/kvm_emulate.h |  4 ++++
>  arch/x86/include/asm/kvm_host.h    |  3 ---
>  arch/x86/kvm/x86.c                 | 11 ++++++-----
>  3 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
> index a4ef19a6e612..a26c8de414e8 100644
> --- a/arch/x86/include/asm/kvm_emulate.h
> +++ b/arch/x86/include/asm/kvm_emulate.h
> @@ -315,6 +315,10 @@ struct x86_emulate_ctxt {
>  	bool gpa_available;
>  	gpa_t gpa_val;
>  
> +	/* Track EIP and CR2/GPA when retrying faulting instruction on #PF. */
> +	unsigned long last_retry_eip;
> +	unsigned long last_retry_addr;
> +
>  	/*
>  	 * decode cache
>  	 */
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9c79c41eb5f6..6312ea32bb41 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -752,9 +752,6 @@ struct kvm_vcpu_arch {
>  
>  	cpumask_var_t wbinvd_dirty_mask;
>  
> -	unsigned long last_retry_eip;
> -	unsigned long last_retry_addr;
> -
>  	struct {
>  		bool halted;
>  		gfn_t gfns[roundup_pow_of_two(ASYNC_PF_PER_VCPU)];
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f88b72932c35..d19eb776f297 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6407,6 +6407,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
>  
>  	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
>  
> +	/* last_retry_{eip,addr} are persistent and must not be init'd here. */
>  	ctxt->gpa_available = false;
>  	ctxt->eflags = kvm_get_rflags(vcpu);
>  	ctxt->tf = (ctxt->eflags & X86_EFLAGS_TF) != 0;
> @@ -6557,8 +6558,8 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>  	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
>  	unsigned long last_retry_eip, last_retry_addr, gpa = cr2_or_gpa;
>  
> -	last_retry_eip = vcpu->arch.last_retry_eip;
> -	last_retry_addr = vcpu->arch.last_retry_addr;
> +	last_retry_eip = ctxt->last_retry_eip;
> +	last_retry_addr = ctxt->last_retry_addr;
>  
>  	/*
>  	 * If the emulation is caused by #PF and it is non-page_table
> @@ -6573,7 +6574,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>  	 * and the address again, we can break out of the potential infinite
>  	 * loop.
>  	 */
> -	vcpu->arch.last_retry_eip = vcpu->arch.last_retry_addr = 0;
> +	ctxt->last_retry_eip = ctxt->last_retry_addr = 0;
>  
>  	if (!(emulation_type & EMULTYPE_ALLOW_RETRY_PF))
>  		return false;
> @@ -6588,8 +6589,8 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>  	if (ctxt->eip == last_retry_eip && last_retry_addr == cr2_or_gpa)
>  		return false;
>  
> -	vcpu->arch.last_retry_eip = ctxt->eip;
> -	vcpu->arch.last_retry_addr = cr2_or_gpa;
> +	ctxt->last_retry_eip = ctxt->eip;
> +	ctxt->last_retry_addr = cr2_or_gpa;
>  
>  	if (!vcpu->arch.mmu->direct_map)
>  		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
> 

