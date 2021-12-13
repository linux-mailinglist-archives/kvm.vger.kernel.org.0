Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EE047352F
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 20:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242483AbhLMTpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 14:45:55 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36844 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242466AbhLMTpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 14:45:54 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639424753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oufnHXYKWMpsck9vW/q3Ibwbij8WawXCFTeH9I9rutE=;
        b=AdVHW8wKcLlKaHcW57soga9/hHUUYJSl4/azuP4y+lm/R0fb3EQ0Vul6RaObe+VLaEwBjf
        ImZW3vuaVgQmVyvF+I+HFwOxbzZdjhH4Vd8frRofbc66khLlCk43I5EGwWn9W2ZNOCChgO
        znABdaPTmabHl8D2fHiRIiBHXGhYakdewMjVeK+hAoXFOBNMC7CCBBbECzH6altFyHhHrK
        uJCZLsT3kZjSMOYWIrhMIYtJT/GMSX7vIUhYKeF6pF6AUQSf6elaG8cTCd3BJXeMznZcQm
        PB5Dd0SN7RvLTEWtgFRZMZl2BQMXfVBWH7mR+LIaiv2fUtVmcjJqZN3H2VCUbw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639424753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oufnHXYKWMpsck9vW/q3Ibwbij8WawXCFTeH9I9rutE=;
        b=1rFnbcD6r40GZCKT3sispCAVEyEIoKC8iC4oKzuJqDhQcnC6z3dQZH5Ey7yV+51sOmXfxs
        tFVxspyislFrL1Bw==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
Subject: Re: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
In-Reply-To: <022620db-13ad-8118-5296-ae2913d41f1f@redhat.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-11-yang.zhong@intel.com>
 <022620db-13ad-8118-5296-ae2913d41f1f@redhat.com>
Date:   Mon, 13 Dec 2021 20:45:52 +0100
Message-ID: <87y24othjj.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13 2021 at 16:06, Paolo Bonzini wrote:
> On 12/8/21 01:03, Yang Zhong wrote:
>> +		/*
>> +		 * Update IA32_XFD to the guest value so #NM can be
>> +		 * raised properly in the guest. Instead of directly
>> +		 * writing the MSR, call a helper to avoid breaking
>> +		 * per-cpu cached value in fpu core.
>> +		 */
>> +		fpregs_lock();
>> +		current->thread.fpu.fpstate->xfd = data;
>
> This is wrong, it should be written in vcpu->arch.guest_fpu.
>
>> +		xfd_update_state(current->thread.fpu.fpstate);
>
> This is okay though, so that KVM_SET_MSR will not write XFD and WRMSR
> will.
>
> That said, I think xfd_update_state should not have an argument. 
> current->thread.fpu.fpstate->xfd is the only fpstate that should be 
> synced with the xfd_state per-CPU variable.

I'm looking into this right now. The whole restore versus runtime thing
needs to be handled differently.

Thanks,

        tglx
