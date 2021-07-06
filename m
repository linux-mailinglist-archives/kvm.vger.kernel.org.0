Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C643BD489
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbhGFMOD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:14:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232759AbhGFLwC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 07:52:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625572160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FATNRVKbS7MyqR3G78NBEKvnKkqBrj1Mp745hyNa6RY=;
        b=S5QefQ+yatX254UItn0EDMWfA1HpouDF2upNmfNGeF8eQW5HD3qyDUtHlU52DZhBZBztje
        3eRanTvU9yKDtCyiZsBZPaX+2NjjPWWvI8xhmILdYp8cE/2WQ8KVuaExyDmGSLn5AKSKP/
        FB16+ucz8M61mcjRR/SH71lh/uSnuV8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-Rz2OQQnhPVqak4NZzz7grA-1; Tue, 06 Jul 2021 07:49:19 -0400
X-MC-Unique: Rz2OQQnhPVqak4NZzz7grA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9078718D6A2C;
        Tue,  6 Jul 2021 11:49:17 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81D7C68D95;
        Tue,  6 Jul 2021 11:49:05 +0000 (UTC)
Message-ID: <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Stas Sergeev <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Date:   Tue, 06 Jul 2021 14:49:04 +0300
In-Reply-To: <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
References: <20210628124814.1001507-1-stsp2@yandex.ru>
         <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-06-28 at 17:29 +0300, Maxim Levitsky wrote:
> On Mon, 2021-06-28 at 15:48 +0300, Stas Sergeev wrote:
> > When returning to user, the special care is taken about the
> > exception that was already injected to VMCS but not yet to guest.
> > cancel_injection removes such exception from VMCS. It is set as
> > pending, and if the user does KVM_SET_REGS, it gets completely canceled.
> > 
> > This didn't happen though, because the vcpu->arch.exception.injected
> > and vcpu->arch.exception.pending were forgotten to update in
> > cancel_injection. As the result, KVM_SET_REGS didn't cancel out
> > anything, and the exception was re-injected on the next KVM_RUN,
> > even though the guest registers (like EIP) were already modified.
> > This was leading to an exception coming from the "wrong place".
> > 
> > This patch makes sure the vcpu->arch.exception.injected and
> > vcpu->arch.exception.pending are in sync with the reality (and
> > with VMCS). Also it adds clearing of pending exception to
> > __set_sregs() the same way it is in __set_regs(). See patch
> > b4f14abd9 that added it to __set_regs().
> > 
> > How to trigger the buggy scenario (that is, without this patch):
> > - Make sure you have the old CPU where shadow page tables
> > are used. Core2 family should be fine for the task. In this
> > case, all PF exceptions produce the exit to monitor.
> > - You need the _TIF_SIGPENDING flag set at the right moment
> > to get kvm_vcpu_exit_request() to return true when the PF
> > exception was just injected. In that case the cancel_injection
> > path is executed.
> > - You need the "unlucky" user-space that executes KVM_SET_REGS
> > at the right moment. This leads to KVM_SET_REGS not clearing
> > the exception, but instead corrupting its context.
> > 
> > v2 changes:
> > - do not add WARN_ON_ONCE() to __set_regs(). As explained by
> > Vitaly Kuznetsov, it can be user-triggerable.
> > - clear pending exception also in __set_sregs().
> > - update description with the bug-triggering scenario.
> 
> I used to know that area very very well, and I basically combed
> the whole thing back and forth, 
> and I have patch series to decouple injected and
> pending exceptions. 
> 
> I'll refresh my memory on this and then I'll review your patch.

Hi!
Sorry for the delayed response.
 
First of all indeed an exception can be either in pending or injected state.
A pending exception is an exception KVM created but that didn't yet change
the guest state. 
 
It still has to be injected to the guest on its current instruction,
thus its not like a pending interrupt.
 
An injected exception is an exception which was already injected to the guest
(or at least attempted an injection but that was aborted)

Since the exception payload is injected prior to pushing the error
code on the stack and then jumping to the exception handler,
the guest state is already modified.

There can be 2 reasons why exception delivery is aborted
like that:
 
1. By KVM (that is cancel_injection), when KVM needs to exit
to userspace due to a signal
 
2. By the CPU, when CPU detects another exception or paging fault,
while delivering this exception.
 
In both cases the exception stays in the 'injected' state, and
has to be injected again (that is why I don't really like the
'injected' term, since it is more like 'injection_started').

Now about the KVM's userspace API where this is exposed:
 
I see now too that KVM_SET_REGS clears the pending exception.
This is new to me and it is IMHO *wrong* thing to do.
However I bet that someone somewhere depends on this,
since this behavior is very old.
 
This doesn't affect qemu since when it does KVM_SET_REGS,
it also does KVM_SET_VCPU_EVENTS afterward, and that 
restores either pending or injected exception state.
(that state is first read with KVM_GET_VCPU_EVENTS ioctl).
 
Also note just for reference that KVM_SET_SREGS has ability
to set a pending interrupt, something that is also redundant
since KVM_SET_VCPU_EVENTS does this.
I recently added KVM_SET_SREGS2 ioctl which now lacks this
ability.

KVM_SET_VCPU_EVENTS/KVM_GET_VCPU_EVENTS allows to read/write
state of both pending and injected exception and on top of that
allows to read/write the exception payload of a pending exception.

You should consider using it to preserve/modify the exception state,
although the later isn't recommended (qemu does this in few places,
but it is a bit buggy, especially in regard to nested guests).

Best regards,
	Maxim Levitsky

