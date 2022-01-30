Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2F74A36A6
	for <lists+kvm@lfdr.de>; Sun, 30 Jan 2022 15:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354991AbiA3O3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jan 2022 09:29:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354990AbiA3O3R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 30 Jan 2022 09:29:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643552956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xZ8Bb3OLQ5Ki+babJAgzafxxNgyDnDE0Uiome1ZxJDU=;
        b=X4x+6j0Rru55OgX7iqmw8hoWoJFwlcotVgJN/pfAMVZhGnNWp9lFC7gKMbi03Ze24IgGup
        8JPBfg1hHVGbHV6M4EIyI79IecQbP2lFpN/OGRaYWMNTEdKbJOKUkGM1Mn9GvjbfJBvRlS
        DstcIoBkP4iqiGxdrWOp+HP1DpgDKrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-0RUYqhY-Mg2j0Mw9Qo7x-A-1; Sun, 30 Jan 2022 09:29:14 -0500
X-MC-Unique: 0RUYqhY-Mg2j0Mw9Qo7x-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85CB2814243;
        Sun, 30 Jan 2022 14:29:13 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A80B784A11;
        Sun, 30 Jan 2022 14:29:03 +0000 (UTC)
Message-ID: <11324ba7075ce90dee9d424c78db0bf97b1c4444.camel@redhat.com>
Subject: Re: Why do we need KVM_REQ_GET_NESTED_STATE_PAGES after all
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gilbert <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>
Date:   Sun, 30 Jan 2022 16:29:02 +0200
In-Reply-To: <CALMp9eT2cP7kdptoP3=acJX+5_Wg6MXNwoDh42pfb21-wdXvJg@mail.gmail.com>
References: <fc6bea3249f26e8dd973ce1bd1e3f6f42c142469.camel@redhat.com>
         <CALMp9eT2cP7kdptoP3=acJX+5_Wg6MXNwoDh42pfb21-wdXvJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-01-27 at 11:39 -0800, Jim Mattson wrote:
> On Thu, Jan 27, 2022 at 8:04 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > I would like to raise a question about this elephant in the room which I wanted to understand for
> > quite a long time.
> > 
> > For my nested AVIC work I once again need to change the KVM_REQ_GET_NESTED_STATE_PAGES code and once
> > again I am asking myself, maybe we can get rid of this code, after all?
> 
> We (GCE) use it so that, during post-copy, a vCPU thread can exit to

Thank you very much for a very detailed response!

> userspace and demand these pages from the source itself, rather than
> funneling all demands through a single "demand paging listener"
That is something I didn't think of!

The question is however, can that happen between setting the nested state
and running a vCPU first time. 

I guess it is possible in therory that you set the nested state, then run 1 vCPU, 
which faults and exits to userspace,
then userspace populates the faulted memory which triggers memslots update,
and only then you run another vCPU for first time.
needs will be need when this request is processed, and it will fail if they aren't.



> thread, which I believe is the equivalent of qemu's userfaultfd "fault
> handler" thread. Our (internal) post-copy mechanism scales quite well,
> because most demand paging requests are triggered by an EPT violation,
> which happens to be a convenient place to exit to userspace. Very few
> pages are typically demanded as a result of
> kvm_vcpu_{read,write}_guest, where the vCPU thread is so deep in the
> kernel call stack that it has to request the page via the demand
> paging listener thread. With nested virtualization, the various vmcs12
> pages consulted directly by kvm (bypassing the EPT tables) were a
> scalability issue.
I assume that you patched all these calls to exit to userspace for the
demand paging scheme you are using.

> 
> (Note that, unlike upstream, we don't call nested_get_vmcs12_pages
> directly from VMLAUNCH/VMRESUME emulation; we always call it as a
> result of this request that you don't like.)
Also I guess something specific to your downstream patches.


> 
> As we work on converting from our (hacky) demand paging scheme to
> userfaultfd, we will have to solve the scalability issue anyway
> (unless someone else beats us to it). Eventually, I expect that our
> need for this request will go away.

Great!

The question is, if we remove it now, will that affect you?

What if we depricate it (add option to keep the current behavier,
but keep an module param to revert back to old behavier, with
the eventual goal of removing it.


> 
> Honestly, without the exits to userspace, I don't really see how this
> request buys you anything upstream. When I originally submitted it, I
> was prepared for rejection, but Paolo said that qemu had a similar
> need for it, and I happily never questioned that assertion.

Exactly! I didn't questioned it as well, because I didn't knew MMU at all,
and it is one of the harderst KVM parts - who knows what it caches,
and what magic it needs to be up to date.

But now, I don't think there are still large areas of MMU that I don't understand,
thus I started asking myself why it is need.

That request is a ripe source of bugs. Just off my hand, Vitaly spent at least a week
understanding why after vmcb01/02 split, eVMCS stopped working, only to figure out that
KVM_REQ_GET_NESTED_STATE_PAGES might not be called after nested entry since there
could be nested VM exit before we even enter the guest, and since then one more
hack has to be added to work that around (nothing against the hack, its not the
root cause of the problem).

I also indirectly caused and fixed a CVE like issue, which started 
 with the patch that added KVM_REQ_GET_NESTED_STATE_PAGES to SVM - 
it made KVM switch to nested msr bitmap
and back then there was no vmcb01/02 split. Problem is that back then
we didn't cancel that request if we have VM exit right after VM entry,
so it would be still pending on VM entry, and it will switch to nested MSR bitmap
even if we are no longer nested - then I added patch to free the nested state
on demand, and boom - we have L1 using freed (and usualy zeroed) MSR bitmap - free
access to all host msrs from L1...

There is another hidden issue in this request, that it makes it impossible to
handle failure gracefully.

If for example, loading nested state pages needs to allocate memory and that
fails, we could just fail the nested VM entry if that request wasn't there.
While this is not ideal for the nested guest, it likely to survive, and
might even retry entering the nested guest.

On the other hand during the request if something fails, nested state is
already loaded, and all we can do is to kill the L1.


Thanks again!
Best regards,
	Maxim Levitsky

> 




