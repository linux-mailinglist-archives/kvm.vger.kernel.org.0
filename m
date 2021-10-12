Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56642AB17
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 19:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhJLRtS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 13:49:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:57340 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhJLRtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 13:49:14 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634060831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Pt0nUixj+nNGzPG7e+TJ6uIXoIYUMGSVKNi17eRKbU=;
        b=tFzEvHitcwTLlWKDxYNIuNC2NG99XNXXnwpic6ifCYx2HJd64cfAgvBcRSqChheQb0wecu
        rK56LYUTOZp1ceKWLPwfnaB5D1o+NifL3YxioGrAuq1WqZF1vvEiGptP39pNaUZw+POSyf
        mErEPf9xCfqvrNimQjmYgyLGhyTlhgmpURtzhKIVaxtbpsPAgFFi0gjwtuYEqFcRXiyMj8
        I/769am+eNY8Ec0H2Ziyr94AVn6JnwjyMScfrs6pSwQYVTBM+hlBSmro1qMHxlKXxD1Z9m
        apN4mrDt2vrYooqJDNbIvIzHcUMFoB6p94+3VvWB1eJyNHao/4E237Udi0htnw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634060831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Pt0nUixj+nNGzPG7e+TJ6uIXoIYUMGSVKNi17eRKbU=;
        b=Kca+CCZFIKulP5gI2x6P7YmS/Yj/Uhqeo7yZPuyM5J4iowUEAyTXut5KqBrejOhI0brdGh
        Vjwc8ozmGoRnZ9DQ==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org
Subject: Re: [patch 16/31] x86/fpu: Replace KVMs homebrewn FPU copy to user
In-Reply-To: <0d222978-014a-cdcb-f8aa-5b3179cb0809@redhat.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.249593446@linutronix.de>
 <0d222978-014a-cdcb-f8aa-5b3179cb0809@redhat.com>
Date:   Tue, 12 Oct 2021 19:47:10 +0200
Message-ID: <87fst6b0f5.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12 2021 at 19:36, Paolo Bonzini wrote:
> On 12/10/21 02:00, Thomas Gleixner wrote:
>> 
>> -	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
>> -		memset(guest_xsave, 0, sizeof(struct kvm_xsave));
>> -		fill_xsave((u8 *) guest_xsave->region, vcpu);
>> -	} else {
>> -		memcpy(guest_xsave->region,
>> -			&vcpu->arch.guest_fpu->state.fxsave,
>> -			sizeof(struct fxregs_state));
>> -		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] =
>> -			XFEATURE_MASK_FPSSE;
>> -	}
>
> After the patch, this final assignment is not done in the else case:

Doh.

>> +
>> +	if (cpu_feature_enabled(X86_FEATURE_XSAVE)) {
>> +		__copy_xstate_to_uabi_buf(mb, &kstate->xsave, pkru,
>> +					  XSTATE_COPY_XSAVE);
>> +	} else {
>> +		memcpy(&ustate->fxsave, &kstate->fxsave, sizeof(ustate->fxsave));
>> +	}
>> +}
>
> This leaves the xstate_bv set to 0 instead of XFEATURE_MASK_FPSSE. 
> Resuming a VM then fails if you save on a non-XSAVE machine and restore 
> it on an XSAVE machine.

Yup.

> The memset(guest_xsave, 0, sizeof(struct kvm_xsave)) also is not 
> reproduced, you can make it unconditional for simplicity; this is not a 
> fast path.

Duh, I should have mentioned that in the changelog. The buffer is
allocated with kzalloc() soe the memset is redundant, right?

Thanks,

        tglx
