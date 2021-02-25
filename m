Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7940B3252BF
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 16:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhBYPuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 10:50:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232770AbhBYPt5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 10:49:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614268109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N9GLjxM82UmKwC+trKdjUK/mS52WV9a4z9ieR35APG4=;
        b=eJF0gUvHJ2FbB9vLgivRf2N1uM7lJsH7amrEdX9nV3n9ugF+yu8Zi3fYToo7t5Si/l7UD6
        2SI77sBFj8M4Dy4zs5D5l+Qel2oM0vpmDk8+a/K1BIJT38CeUEGGqwcjN+GII7CfU+iukG
        INbfBlCHZPBzoNtAg+ZP2gR/9De1PXM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-xOxUSVHhN9CfceFfHUA_Gg-1; Thu, 25 Feb 2021 10:48:26 -0500
X-MC-Unique: xOxUSVHhN9CfceFfHUA_Gg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B23E8030BB;
        Thu, 25 Feb 2021 15:48:24 +0000 (UTC)
Received: from starship (unknown [10.35.207.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51018189C7;
        Thu, 25 Feb 2021 15:48:21 +0000 (UTC)
Message-ID: <ecf0e5d9213d04d0f168c289e840b966210f99d5.camel@redhat.com>
Subject: Re: [PATCH 0/4] RFC/WIP: KVM: separate injected and pending
 exception +  few more fixes
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Thu, 25 Feb 2021 17:48:20 +0200
In-Reply-To: <20210225154135.405125-1-mlevitsk@redhat.com>
References: <20210225154135.405125-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-02-25 at 17:41 +0200, Maxim Levitsky wrote:
> clone of "kernel-starship-5.11"
> 
> Maxim Levitsky (4):
>   KVM: x86: determine if an exception has an error code only when
>     injecting it.
>   KVM: x86: mmu: initialize fault.async_page_fault in walk_addr_generic
>   KVM: x86: pending exception must be be injected even with an injected
>     event
>   kvm: WIP separation of injected and pending exception
> 
>  arch/x86/include/asm/kvm_host.h |  23 +-
>  arch/x86/include/uapi/asm/kvm.h |  14 +-
>  arch/x86/kvm/mmu/paging_tmpl.h  |   1 +
>  arch/x86/kvm/svm/nested.c       |  57 +++--
>  arch/x86/kvm/svm/svm.c          |   8 +-
>  arch/x86/kvm/vmx/nested.c       | 109 +++++----
>  arch/x86/kvm/vmx/vmx.c          |  14 +-
>  arch/x86/kvm/x86.c              | 377 +++++++++++++++++++-------------
>  arch/x86/kvm/x86.h              |   6 +-
>  include/uapi/linux/kvm.h        |   1 +
>  10 files changed, 374 insertions(+), 236 deletions(-)
> 
> -- 
> 2.26.2
> 
git-publish ate the cover letter, so here it goes:


RFC/WIP: KVM: separate injected and pending exception + few more fixes

This is a result of my deep dive on why do we need special .inject_page_fault
for cases when TDP paging is disabled on the host for running nested guests.

First 3 patches fix relatively small issues I found.
Some of them can be squashed with patch 4 assuming that it is accepted.

Patch 4 is WIP and I would like to hear your feedback on it:

Basically the issue is that during delivery of one exception
we (emulator or mmu) can signal another exception, and if the new exception
is intercepted by the nested guest, we should do VM exit with
former exception signaled in exitintinfo (or equivalent IDT_VECTORING_INFO_FIELD)

We sadly either loose the former exception and signal an VM exit, or deliver
a #DF since we only store either pending or injected exception
and we merge them in kvm_multiple_exception although we shouldn't.

Only later we deliver the VM exit in .check_nested_events when already wrong
data is in the pending/injected exception.

There are multiple ways to fix it, and I choose somewhat hard but I think
the most correct way of dealing with it.

1. I split pending and injected exceptions in kvm_vcpu_arch thus allowing
both to co-exist.

2. I made kvm_multiple_exception avoid merging exceptions, but instead only
setup either pending or injected exception
(there is another bug that we don't deliver triple fault as nested vm exit,
which I'll fix later)

3. I created kvm_deliver_pending_exception which its goal is to
convert the pending exception to injected exception or deliver a VM exit
with both pending and injected exception/interrupt/nmi.

It itself only deals with non-vmexit cases while it calls a new
'kvm_x86_ops.nested_ops->deliver_exception' to deliver exception VM exit
if needed.

The later implementation is simple as it just checks if we should VM exit
and then delivers both exceptions (or interrupt and exception, in case
interrupt delivery was interrupted by exception).
This new callback returns 0 if it had delivered this VM exit,
0 if no vm exit is needed, or -EBUSY when nested run is pending,
in which case the exception delivery will be retried after nested
run is done.

kvm_deliver_pending_exception is called each time we inject pending events
and all exception related code is removed from .check_nested_events which now only deals
with pending interrupts and events such as INIT,NMI,SMI, etc.

New KVM cap is added to expose both pending and injected exception via
KVM_GET_VCPU_EVENTS/KVM_SET_VCPU_EVENTS

If this cap is not enabled, and we have both pending and injected exception
when KVM_GET_VCPU_EVENTS is called, the exception is delivered.

The code was tested with SVM, and it currently seems to pass all the tests I usually
do (including nested migration). KVM unit tests seem to pass as well.

I still almost sure that I broke something since this is far from trivial change,
therefore this is RFC/WIP.

Also VMX side was not yet tested other than basic compile and I am sure that there
are at least few issues that remain to be fixed.

I should also note that with these patches I can boot nested guests with npt=0 without
any changes to .inject_page_fault.

I also wrote 2 KVM unit tests to test for this issue, and for similar issue when
interrupt is lost when delivery of it causes exception.
These tests pass now.

Best regards,
	Maxim Levitsky


