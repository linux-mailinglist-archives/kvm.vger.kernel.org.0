Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA3C472C6F
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 13:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbhLMMkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 07:40:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:34742 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhLMMka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 07:40:30 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639399229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EpBecaDs8+vtbv/9pJevHVEwRrggPN7/5F3+DVdz3vE=;
        b=bjp/Pe0eO5BZ4+PSqiDnNTYnvk7cZRj5bWIs6W9Xptm7WvDp3+WB4zQewsD/SVd9wW7MzZ
        VqkS9CTMaOFdxX/pUPGZAylimVfqCLx6+0lyZfRsjXPOXswDMeoRS1tplOMfjTjQQ0e0AX
        p2lxthgdE3sesh6VqhNKYbwoA0unHEHKoDRNONTrIvgQ8u1gDt73NlCN5xHYZJbC8JUdhX
        qkMU2DTiRI0+PeqJrstBCkGEIRjN4Od1BlMMce4FOLFz4Yo9hV5yNS8uoSkCTq1+Hih052
        Tdo89qqkLWmqf1GT/P20C1mmqCJ89hpmaqbLPSL5ZV9wZU+aPwvN0W7QKiHvFQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639399229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EpBecaDs8+vtbv/9pJevHVEwRrggPN7/5F3+DVdz3vE=;
        b=s6V3rVQGql8NCneb8+Vh2L/caDyWLUanhnsiTldNZC7q+0q+tuWt2MrCJ5VguY9evNeHjy
        AmOZSQ9dRmtuWUCA==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
Subject: Re: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
In-Reply-To: <08107331-34b9-b33d-67ee-300f216341e0@redhat.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com> <87bl1kvmqg.ffs@tglx>
 <08107331-34b9-b33d-67ee-300f216341e0@redhat.com>
Date:   Mon, 13 Dec 2021 13:40:28 +0100
Message-ID: <874k7cvfsz.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13 2021 at 11:43, Paolo Bonzini wrote:
> On 12/13/21 11:10, Thomas Gleixner wrote:
>> On Fri, Dec 10 2021 at 17:30, Paolo Bonzini wrote:
>>> I think fpu_copy_uabi_to_guest_fpstate (and therefore
>>> copy_uabi_from_kernel_to_xstate) needs to check that the size is
>>> compatible with the components in the input.
>> 
>> fpu_copy_uabi_to_guest_fpstate() expects that the input buffer is
>> correctly sized. We surely can add a size check there.
>
> fpu_copy_guest_fpstate_to_uabi is more problematic because that one
> writes memory.  For fpu_copy_uabi_to_guest_fpstate, we know the input
> buffer size from the components and we can use it to do a properly-sized
> memdup_user.
>
> For fpu_copy_guest_fpstate_to_uabi we can just decide that KVM_GET_XSAVE
> will only save up to the first 4K.  Something like the following might
> actually be good for 5.16-rc; right now, header.xfeatures might lead
> userspace into reading uninitialized or unmapped memory:

If user space supplies a 4k buffer and reads beyond the end of the
buffer then it's hardly a kernel problem.

That function allows to provide a short buffer and fill it up to the
point where the buffer ends with the real information.

Thanks,

        tglx
