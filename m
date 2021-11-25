Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4314E45DF7F
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 18:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242241AbhKYRWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 12:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbhKYRUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 12:20:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD16C06137B;
        Thu, 25 Nov 2021 09:03:51 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637859829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WJqCTP2/6XiC+tTJn1InI8IJaP+YIZikDpCUbn4aCJc=;
        b=MLsW4jLq5KnCoWcvj94DX3apZrprm2+khp6onEQyc0u3qYpO5PqxtUErsStDEDsXqlelHd
        KDrNc37gbjzOxov20wf3SwnsqJ0lV+uPqywKURb50xneiNpu6dXLieqVpQfyeUkZl2xU6f
        X9EcWniUjn2hMeoJpJeI+oi1WEmEbwkqv3cfs/v9SVTyF4fMJQvPFVY7MsyNBr4F8UHPu0
        3XpBRKiZkncMsIfyz1jHBbcBC8hlO9GRfwB3UYxRLgJ8bAxTMG+J94dQdvlvgdIgIWa9vX
        EWxNbM99hOB+e4Kr0b9GFYCHCjGTlQHwLRH3UcMfctjDcTzjB+344Vz/+WDnCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637859829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WJqCTP2/6XiC+tTJn1InI8IJaP+YIZikDpCUbn4aCJc=;
        b=kdsBI+c1wwlCaKL+Ekg1Tx8z4sqOBDTPneJEfsqIwFz3lhxY2JaJ/s+gnQAxiI8iwVESTx
        IlsDWVGOQ3+P5hDw==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 02/59] x86/mtrr: mask out keyid bits from
 variable mtrr mask register
In-Reply-To: <draft-87fsrkmy2c.ffs@tglx>
References: <draft-87fsrkmy2c.ffs@tglx>
Date:   Thu, 25 Nov 2021 18:03:49 +0100
Message-ID: <878rxckw0a.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25 2021 at 09:36, Thomas Gleixner wrote:
>>  
>> +			if (boot_cpu_has(X86_FEATURE_TME)) {

cpu_feature_enabled() as Borislav pointed out several times already.

>> +				u64 tme_activate;
>> +
>> +				rdmsrl(MSR_IA32_TME_ACTIVATE, tme_activate);
>> +				if (TME_ACTIVATE_LOCKED(tme_activate) &&
>> +				    TME_ACTIVATE_ENABLED(tme_activate)) {
>> +					phys_addr -= TME_ACTIVATE_KEYID_BITS(tme_activate);
>> +				}
>> +			}
>>  			size_or_mask = SIZE_OR_MASK_BITS(phys_addr);
>>  			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
>>  		} else if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
