Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E510342D937
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 14:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhJNMZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 08:25:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42224 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhJNMZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 08:25:28 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634214202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YwI7m0J6NAsfOtaqDDCa38Lq/fRTd3LlM1uOlxJdIdo=;
        b=rFtJCGEuXURyoUtpGRqElZVniK+OUx4a9u7Ua4mNRONx/gI5Qm4MPn3EqnrXo5cq4LREO9
        dtvubUEW+/V3vKsDbRV/1Gor7sWNCIXuW3M6IyRojrdhNXOjScYYZBJ8BTXgQYPuhLEv7e
        M8lKuAWbX615oCOrL+i305aOqHGxzHgjsC0acipXPhGfL3RHhGRweXoQJgA8+bbaONIntz
        V6jpY2wB9uUK7xM21sVhwmHaYjjzRG59coHY13w8KV84xGRfV1KbAKpxpA3DzEp7DaaTZl
        7TkNIYFjn6OPp4KYZyRUMuU7muvshIZndac4wv/1Qa8BAY1WpZDihgdco8KZDA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634214202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YwI7m0J6NAsfOtaqDDCa38Lq/fRTd3LlM1uOlxJdIdo=;
        b=4a0WVEMEljUmVdIc4eDWM0WwVnoCOUgiooA5+kF2pPMnfp5NcKoan4/HQJF3eH8CoIQe+8
        ND4uIokZ4idgXcBg==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com>
Date:   Thu, 14 Oct 2021 14:23:21 +0200
Message-ID: <875ytz7q2u.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On Thu, Oct 14 2021 at 08:50, Paolo Bonzini wrote:
> On 13/10/21 16:06, Thomas Gleixner wrote:
>>> - the guest value stored in vcpu->arch.
>>>
>>> - the "QEMU" value attached to host_fpu.  This one only becomes zero if
>>> QEMU requires AMX (which shouldn't happen).
>> 
>> I don't think that makes sense.
>> 
>> First of all, if QEMU wants to expose AMX to guests, then it has to ask
>> for permission to do so as any other user space process. We're not going
>> to make that special just because.
>
> Hmm, I would have preferred if there was no need to enable AMX for the 
> QEMU FPU.  But you're saying that guest_fpu needs to swap out to 
> current->thread.fpu if the guest is preempted, which would require 
> XFD=0; and affect QEMU operation as well.

Exactly. If we don't enable it for QEMY itself, then this is creating
just a horrible inconsistency which requires nasty hacks. I'm not at
all interested in those as I just got rid of quite some and made the
code consistent.

> In principle I don't like it very much; it would be nicer to say "you 
> enable it for QEMU itself via arch_prctl(ARCH_SET_STATE_ENABLE), and for 
> the guests via ioctl(KVM_SET_CPUID2)".  But I can see why you want to 
> keep things simple, so it's not a strong objection at all.

Errm.

   qemu()
     read_config()
     if (dynamic_features_passthrough())
	request_permission(feature)             <- prctl(ARCH_SET_STATE_ENABLE)

     create_vcpu_threads()
       ....

       vcpu_thread()
	 kvm_ioctl(ENABLE_DYN_FEATURE, feature) <- KVM ioctl

That's what I lined out, right?

>> Anything else will just create more problems than it solves. Especially
>> #NM handling (think nested guest) and the XFD_ERR additive behaviour
>> will be a nasty playground and easy to get wrong.
>> 
>> Not having that at all makes life way simpler, right?
>
> It is simpler indeed, and it makes sense to start simple.  I am not sure 
> if it will hold, but I agree it's better for the first implementation.

KISS is a very reasonable engineering principle :)

If there is a real world use case and a proper technical justification
for doing the dynamic buffer allocation then I'm happy to discuss that.

Thanks,

        tglx

