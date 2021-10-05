Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA6D4222D6
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 11:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhJEJ5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 05:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233812AbhJEJ5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 05:57:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC706C06161C;
        Tue,  5 Oct 2021 02:55:59 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633427757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bmn6fbfwZkIlTzBjYvoDp1zcPlgN5COrQVMZmJfTwEI=;
        b=RTMmlBCWfAb6HZkmAxgWOKxmPQBw4qfLKpq+7TMOLihK0S7QRje+Yn/qNaltXTkxmO6t3n
        bVL47Ypnq5pl5xj74rpb5TrLlukVXVwpvCFuErnrbwZm65YlBsM4bWI33Zb29iIBnSmmo9
        MFqmw7NgB6kHCChvLyOvum2cKHptrqB0I5a9N6bS2xUi5ORpBaRIj8MBRQt09lZrUjTU/I
        0DhmqTYtK50dCrYAmEzxv7Qwuqj4uLVILJUcZpZwI1sbN5H1EmLT3nmFNcLg3EJFWe8l4n
        ujFsNjJvtzU2dl2P0Qdb5sW3oAbTYRvPNFFwkUBHbl6AEU4GEMXQ2xTpTT5S6Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633427757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bmn6fbfwZkIlTzBjYvoDp1zcPlgN5COrQVMZmJfTwEI=;
        b=8jomF9fA0hlpuTAblonNYz3gbDHbpUW/rmYa9lkGrOIj9F+nMHmHbx94E43d1Xf1+cs+jK
        d6+f3NGJDAPhQTBg==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>, bp@suse.de,
        luto@kernel.org, mingo@kernel.org, x86@kernel.org
Cc:     len.brown@intel.com, lenb@kernel.org, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v10 10/28] x86/fpu/xstate: Update the XSTATE save
 function to support dynamic states
In-Reply-To: <a5a5812a-6501-ccce-5d42-18131cf26779@redhat.com>
References: <87pmsnglkr.ffs@tglx>
 <a5a5812a-6501-ccce-5d42-18131cf26779@redhat.com>
Date:   Tue, 05 Oct 2021 11:55:56 +0200
Message-ID: <87ee8zg5hv.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 05 2021 at 09:50, Paolo Bonzini wrote:
> On 02/10/21 23:31, Thomas Gleixner wrote:
>> You have two options:
>> 
>>    1) Always allocate the large buffer size which is required to
>>       accomodate all possible features.
>> 
>>       Trivial, but waste of memory.
>> 
>>    2) Make the allocation dynamic which seems to be trivial to do in
>>       kvm_load_guest_fpu() at least for vcpu->user_fpu.
>> 
>>       The vcpu->guest_fpu handling can probably be postponed to the
>>       point where AMX is actually exposed to guests, but it's probably
>>       not the worst idea to think about the implications now.
>> 
>> Paolo, any opinions?
>
> Unless we're missing something, dynamic allocation should not be hard to 
> do for both guest_fpu and user_fpu; either near the call sites of 
> kvm_save_current_fpu, or in the function itself.  Basically adding 
> something like
>
> 	struct kvm_fpu {
> 		struct fpu *state;
> 		unsigned size;
> 	} user_fpu, guest_fpu;
>
> to struct kvm_vcpu.  Since the size can vary, it can be done simply with 
> kzalloc instead of the x86_fpu_cache that KVM has now.
>
> The only small complication is that kvm_save_current_fpu is called 
> within fpregs_lock; the allocation has to be outside so that you can use 
> GFP_KERNEL even on RT kernels.   If the code looks better with 
> fpregs_lock moved within kvm_save_current_fpu, go ahead and do it like that.

I'm reworking quite some of this already and with the new bits you don't
have to do anything in kvm_fpu because the size and allowed feature bits
are going to be part of fpu->fpstate.

Stay tuned.

Thanks,

        tglx
