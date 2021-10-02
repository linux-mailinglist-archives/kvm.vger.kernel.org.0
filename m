Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FCB41FE41
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 23:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhJBVdi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 17:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhJBVdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Oct 2021 17:33:37 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E617C061714;
        Sat,  2 Oct 2021 14:31:51 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633210309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=XAgRQtFBHsbRzmJ/Hn8rU+rglpQXhDRVc8VEErk4l88=;
        b=OOgOM7YtXOhLWRkpS5/up6YJYIb5XY/mVgEOq+HXp4S6UaTts/077HIUsyQhhrCfBZLm4h
        DcOhfXVkTGWfTIIui0TKbEg39RwGDEPWsbRZ29VbZcUHUt2KpdPqnUbq8gHXTK7Kt9hs0C
        bqed1yCUaWPPFs4XtzvEyrJDD8ACNcAznsLRzqecIaJBqMJM/nxtdt3Z5yW2ho/sY22J0H
        nrfYSLoejZuxwOYt/Voa/BTRfsJR0oAMq4/jclJmKGsCVrwaZeIvKXr5/DupT//1HGfLrA
        bJJIW8bfUoxtdEFko5JHO5/bZ0QCfO1VcGYXlxgSOh5t48DJ9G9SquVWuRg0Zw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633210309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to; bh=XAgRQtFBHsbRzmJ/Hn8rU+rglpQXhDRVc8VEErk4l88=;
        b=j6gtvaQTt1AY/2a2N7nrXZ1imOK6vuHY0DcXRKP3J/EuzAYA3QGu/iPDFJFkM0k2wP3Sjp
        f9BQfS+vxRUDRDCg==
To:     "Chang S. Bae" <chang.seok.bae@intel.com>, bp@suse.de,
        luto@kernel.org, mingo@kernel.org, x86@kernel.org
Cc:     len.brown@intel.com, lenb@kernel.org, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v10 10/28] x86/fpu/xstate: Update the XSTATE save
 function to support dynamic states
In-Reply-To: <87tui04urt.ffs@tglx>
Date:   Sat, 02 Oct 2021 23:31:48 +0200
Message-ID: <87pmsnglkr.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 01 2021 at 17:41, Thomas Gleixner wrote:
> On Wed, Aug 25 2021 at 08:53, Chang S. Bae wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 74dde635df40..7c46747f6865 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -9899,11 +9899,16 @@ static void kvm_save_current_fpu(struct fpu *fpu)
>>  	 * KVM does not support dynamic user states yet. Assume the buffer
>>  	 * always has the minimum size.

I have to come back to this because that assumption is just broken.

create_vcpu()
   vcpu->user_fpu = alloc_default_fpu_size();
   vcpu->guest_fpu = alloc_default_fpu_size();

vcpu_task()
   get_amx_permission()
   use_amx()
     #NM
     alloc_larger_state()
   ...
   kvm_arch_vcpu_ioctl_run()
     kvm_arch_vcpu_ioctl_run()
       kvm_load_guest_fpu()
         kvm_save_current_fpu(vcpu->arch.user_fpu);
           save_fpregs_to_fpstate(fpu);         <- Out of bounds write

Adding a comment that KVM does not yet support dynamic user states does
not cut it, really.

Even if the above is unlikely, it is possible and has to be handled
correctly at the point where AMX support is enabled in the kernel
independent of guest support.

You have two options:

  1) Always allocate the large buffer size which is required to
     accomodate all possible features.

     Trivial, but waste of memory.

  2) Make the allocation dynamic which seems to be trivial to do in
     kvm_load_guest_fpu() at least for vcpu->user_fpu.

     The vcpu->guest_fpu handling can probably be postponed to the
     point where AMX is actually exposed to guests, but it's probably
     not the worst idea to think about the implications now.

Paolo, any opinions?

Thanks,

        tglx
