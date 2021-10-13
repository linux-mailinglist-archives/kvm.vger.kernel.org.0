Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C1842C4A5
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 17:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhJMPSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 11:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbhJMPSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 11:18:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D233C061570;
        Wed, 13 Oct 2021 08:16:09 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634138167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U/dOvJviohKdndFAJKTiA4MJwOnU2MzxgmztaO2ZjSU=;
        b=pJeQcqGPCktTLYrG9jfTxsnzHn5kmHeriCsoJQbCZNq0iFHulIzlxVFf3zOcTTBMvpnBHt
        giloiZq1EBI0NseFpdR0feLq8/lh7+Znh26Yop9Qw8EAPy+0RePW6X/G6Q+E6Q+MtdU/mk
        5H3+O9WJYiI4RnhNAABM0ULNN58JZUq1rGPoeajJZpo4KTzpYS/T8We8GzMWu7O6jqzBMg
        OFmlXmiPB79EE/a5Vfy5siRxEeNHJuQtIKZuT41DbnNiVO8uFLdRLRXHvJ+7bfldgpwtjh
        5Sg5LZJCvOMktYoMh3SWlqemUa9LMtoSQ8JwAyEcJUYwKYs9wKG0fIowAfNgfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634138167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U/dOvJviohKdndFAJKTiA4MJwOnU2MzxgmztaO2ZjSU=;
        b=cxJd90R2Bge6t+OLJ0cvlNoRSGBU9GrUUViTQaihHaiWS1U8GWIorrituOEkg5CT0LiYNa
        4Oz/6RB39EyPMgAw==
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 14/31] x86/fpu: Replace KVMs homebrewn FPU copy from user
In-Reply-To: <YWbz0ayrpoxbBo5U@google.com>
References: <20211011215813.558681373@linutronix.de>
 <20211011223611.129308001@linutronix.de> <YWW/PEQyQAwS9/qv@zn.tnic>
 <YWbz0ayrpoxbBo5U@google.com>
Date:   Wed, 13 Oct 2021 17:16:07 +0200
Message-ID: <87pms97y6g.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13 2021 at 14:57, Sean Christopherson wrote:
> On Tue, Oct 12, 2021, Borislav Petkov wrote:
>> On Tue, Oct 12, 2021 at 02:00:19AM +0200, Thomas Gleixner wrote:
>> > --- a/arch/x86/include/asm/fpu/api.h
>> > +++ b/arch/x86/include/asm/fpu/api.h
>> > @@ -116,4 +116,7 @@ extern void fpu_init_fpstate_user(struct
>> >  /* KVM specific functions */
>> >  extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
>> >  
>> > +struct kvm_vcpu;
>> > +extern int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
>> > +
>> >  #endif /* _ASM_X86_FPU_API_H */
>> > --- a/arch/x86/kernel/fpu/core.c
>> > +++ b/arch/x86/kernel/fpu/core.c
>> > @@ -174,7 +174,43 @@ void fpu_swap_kvm_fpu(struct fpu *save,
>> >  	fpregs_unlock();
>> >  }
>> >  EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
>> > -#endif
>> > +
>> > +int fpu_copy_kvm_uabi_to_vcpu(struct fpu *fpu, const void *buf, u64 xcr0,
>> > +			      u32 *vpkru)
>> 
>> Right, except that there's no @vcpu in the args of that function. I
>> guess you could call it
>> 
>> fpu_copy_kvm_uabi_to_buf()
>> 
>> and that @buf can be
>> 
>> vcpu->arch.guest_fpu
>
> But the existing @buf is the userspace pointer, which semantically makes sense
> because the userspace pointer is the "buffer" and the destination @fpu (and @prku)
> is vCPU state, not a buffer.
>
> That said, I also struggled with the lack of @vcpu.  What about prepending vcpu_
> to fpu and to pkru?  E.g.
>
>   int fpu_copy_kvm_uabi_to_vcpu(struct fpu *vcpu_fpu, const void *buf, u64 xcr0,
>   				u32 *vcpu_pkru)

I've renamed them to:

     fpu_copy_kvm_uabi_to_fpstate()
     fpu_copy_fpstate_to_kvm_uabi()

See
https://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git/log/?h=x86/fpu-1

Thanks,

        tglx
