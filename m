Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72ABA4A403F
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 11:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358198AbiAaKco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 05:32:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358196AbiAaKcj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Jan 2022 05:32:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643625158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAH5ETVYxx8pt7aU1IYIr3iQ7RuOXhoEnYJSd66DDDY=;
        b=dPu4r+Ssgc9Aoo8SU80SEGQPwBmORGcknS96Fb6YmuqgXhj2rpr9P3zyzlYWa1IBAqISfk
        vsjgDxosblqq8K4alySRLbJHa7rz4SVeKXJpRORh/gJ7CHM+K9SOXIki9T1YeCIdHfX+c6
        VLJgF4jEX19lmVQCgqyAZCqpz7XH/YU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-YIg2ulqiM767r_BEZmPbKg-1; Mon, 31 Jan 2022 05:32:35 -0500
X-MC-Unique: YIg2ulqiM767r_BEZmPbKg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B5318144E2;
        Mon, 31 Jan 2022 10:32:34 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 57BE0752B8;
        Mon, 31 Jan 2022 10:31:57 +0000 (UTC)
Message-ID: <5de8aeb0adab563667d784bab6fbd235f0208ee0.camel@redhat.com>
Subject: Re: Why do we need KVM_REQ_GET_NESTED_STATE_PAGES after all
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gilbert <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Mingwei Zhang <mizhang@google.com>
Date:   Mon, 31 Jan 2022 12:31:55 +0200
In-Reply-To: <CALMp9eSX8sgyF_CkKQuYP6P5ZGN+t82bmmk9aTfBivSh1+yHiQ@mail.gmail.com>
References: <fc6bea3249f26e8dd973ce1bd1e3f6f42c142469.camel@redhat.com>
         <CALMp9eT2cP7kdptoP3=acJX+5_Wg6MXNwoDh42pfb21-wdXvJg@mail.gmail.com>
         <11324ba7075ce90dee9d424c78db0bf97b1c4444.camel@redhat.com>
         <CALMp9eSX8sgyF_CkKQuYP6P5ZGN+t82bmmk9aTfBivSh1+yHiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-01-30 at 15:46 -0800, Jim Mattson wrote:
> On Sun, Jan 30, 2022 at 6:29 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > On Thu, 2022-01-27 at 11:39 -0800, Jim Mattson wrote:
> > > On Thu, Jan 27, 2022 at 8:04 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > > I would like to raise a question about this elephant in the room which I wanted to understand for
> > > > quite a long time.
> > > > 
> > > > For my nested AVIC work I once again need to change the KVM_REQ_GET_NESTED_STATE_PAGES code and once
> > > > again I am asking myself, maybe we can get rid of this code, after all?
> > > 
> > > We (GCE) use it so that, during post-copy, a vCPU thread can exit to
> > 
> > Thank you very much for a very detailed response!
> > 
> > > userspace and demand these pages from the source itself, rather than
> > > funneling all demands through a single "demand paging listener"
> > That is something I didn't think of!
> > 
> > The question is however, can that happen between setting the nested state
> > and running a vCPU first time.
> > 
> > I guess it is possible in therory that you set the nested state, then run 1 vCPU,
> > which faults and exits to userspace,
> > then userspace populates the faulted memory which triggers memslots update,
> > and only then you run another vCPU for first time.
> > needs will be need when this request is processed, and it will fail if they aren't.
> 
> That isn't quite how our post-copy works.  There is no memslots
> update. When post-copy starts, the source sends a bitmap of dirty
> pages to the destination. This bitmap is installed in kvm via a
> Google-local ioctl. Then, all vCPUs on the destination start running,
> while the source pushes dirty pages to the destination. As EPT
> violations occur for cold mappings at the destination, we check the
> bitmap to see if we need to demand the page from the source
> out-of-band. We know that the page will eventually come across, but we
> need it *now*, so that the vCPU thread that incurred the EPT violation
> can resume. If the page is in the dirty bitmap, the vCPU thread that
> incurred the EPT violation will exit to userspace and request the page
> from the source. When the page arrives, we overwrite the stale page in
> the memslot and clear the bit in the dirty page bitmap.
> 
> For cases where kvm needs a dirty page to do software page walks or
> instruction emulation or whatever, the vCPU thread sends a request to
> the "demand page listener" thread via a netlink socket and then
> blocks, waiting for the bit to clear in the dirty bitmap. For various
> reasons, including the serialization on the listener thread and the
> unreliability of the netlink socket, we didn't want to have all of the
> vmcs12 pages use the netlink request path. (This concern may be
> largely moot, since modification of most pages hanging off of the VMCS
> while the (v)CPU is in VMX non-root mode leads to undefined behavior.)
> 
> > > thread, which I believe is the equivalent of qemu's userfaultfd "fault
> > > handler" thread. Our (internal) post-copy mechanism scales quite well,
> > > because most demand paging requests are triggered by an EPT violation,
> > > which happens to be a convenient place to exit to userspace. Very few
> > > pages are typically demanded as a result of
> > > kvm_vcpu_{read,write}_guest, where the vCPU thread is so deep in the
> > > kernel call stack that it has to request the page via the demand
> > > paging listener thread. With nested virtualization, the various vmcs12
> > > pages consulted directly by kvm (bypassing the EPT tables) were a
> > > scalability issue.
> > I assume that you patched all these calls to exit to userspace for the
> > demand paging scheme you are using.
> > 
> > > (Note that, unlike upstream, we don't call nested_get_vmcs12_pages
> > > directly from VMLAUNCH/VMRESUME emulation; we always call it as a
> > > result of this request that you don't like.)
> > Also I guess something specific to your downstream patches.
> > 
> > 
> > > As we work on converting from our (hacky) demand paging scheme to
> > > userfaultfd, we will have to solve the scalability issue anyway
> > > (unless someone else beats us to it). Eventually, I expect that our
> > > need for this request will go away.
> > 
> > Great!
> > 
> > The question is, if we remove it now, will that affect you?
> 
> No. By the time we get to 5.17, I don't expect any of our current
> post-copy scheme to survive.
> 
> > What if we depricate it (add option to keep the current behavier,
> > but keep an module param to revert back to old behavier, with
> > the eventual goal of removing it.
> 
> Don't bother on our account. :-)
> > > Honestly, without the exits to userspace, I don't really see how this
> > > request buys you anything upstream. When I originally submitted it, I
> > > was prepared for rejection, but Paolo said that qemu had a similar
> > > need for it, and I happily never questioned that assertion.
> > 
> > Exactly! I didn't questioned it as well, because I didn't knew MMU at all,
> > and it is one of the harderst KVM parts - who knows what it caches,
> > and what magic it needs to be up to date.
> 
> The other question, which may have been what motivated Paolo to keep
> the GET_NESTED_VMCS12_PAGES request, is whether or not the memslots
> have been established before userspace calls the ioctl for
> SET_NESTED_STATE. If not, it is impossible to do any GPA->HPA lookups
> for VMCS12 fields that are necessary for the vCPU to enter VMX
> non-root mode as part of SET_NESTED_STATE. The only field I can think
> of off the top of my head is the VMCS12 APIC-access address, which,
> sadly, has to be backed by an L1 memslot, even though the page is
> never accessed. (VMware always sets the APIC-access address to 0, for
> all VMCSs, at L1 or L2. That makes things a lot easier.) If the
> memslots are established before SET_NESTED_STATE, this isn't a
> problem, but I don't recall that constraint being documented anywhere.

This is the exactly only reason for KVM_REQ_GET_NESTED_STATE_PAGES and what it does.
The only thing KVM_REQ_GET_NESTED_STATE_PAGES buy us is exactly this - ability to
set memslots after setting the nested state.
 
This is indeed not documented, but there is hope that none of the userspace relies on this
(the opposite is also not documented)
 
Qemu AFAIK doesn't rely on this - I can't be 100% sure because the code is complex and I 
could have missed some corner case like that virtio-mem case Paolo mentioned to me 
(I checked it, and there seems to be no reason for it to set memslots after migration).
 
Practically speaking, memslots can update any moment, but there is no reason to have different
memslots between sending the migration state and restoring it. As soon as restore of the migration
state is complete, yes there could be memslots modifications, in theory even before the VM runs,
but these modifications can't not make memory that a nested VMCS/VMCB reference available again,
which is the only thing that KVM_REQ_GET_NESTED_STATE_PAGES buys us.
 
TL;DR - no matter how userspace modifies the memslots after the migration,
it must restore the memslots that contain pages that are referenced by the nested state,
exactly as is.

The only change to userspace expected behavier by removing the KVM_REQ_GET_NESTED_STATE_PAGES
would be that userspace would have to restore those memslots prior to setting the nested state
(but not the memory itself contained within, as it can be later brought in via userfaltd).


About the referenced pages:
In addition to apic access page, there are more pages that are referenced from vmcb/vmcs:
There is apic backing page for both AVIC/APICv which we map and passthrough to the guest,
there is PIR descriptior for APICv, there is the msr bitmap, and io bitmap,
there are msr load/store lists on VMX, and probably more).


> 
> > But now, I don't think there are still large areas of MMU that I don't understand,
> > thus I started asking myself why it is need.
> > 
> > That request is a ripe source of bugs. Just off my hand, Vitaly spent at least a week
> > understanding why after vmcb01/02 split, eVMCS stopped working, only to figure out that
> > KVM_REQ_GET_NESTED_STATE_PAGES might not be called after nested entry since there
> > could be nested VM exit before we even enter the guest, and since then one more
> > hack has to be added to work that around (nothing against the hack, its not the
> > root cause of the problem).
> > 
> > I also indirectly caused and fixed a CVE like issue, which started
> >  with the patch that added KVM_REQ_GET_NESTED_STATE_PAGES to SVM -
> > it made KVM switch to nested msr bitmap
> > and back then there was no vmcb01/02 split. Problem is that back then
> > we didn't cancel that request if we have VM exit right after VM entry,
> > so it would be still pending on VM entry, and it will switch to nested MSR bitmap
> > even if we are no longer nested - then I added patch to free the nested state
> > on demand, and boom - we have L1 using freed (and usualy zeroed) MSR bitmap - free
> > access to all host msrs from L1...
> > 
> > There is another hidden issue in this request, that it makes it impossible to
> > handle failure gracefully.
> > 
> > If for example, loading nested state pages needs to allocate memory and that
> > fails, we could just fail the nested VM entry if that request wasn't there.
> > While this is not ideal for the nested guest, it likely to survive, and
> > might even retry entering the nested guest.
> > 
> > On the other hand during the request if something fails, nested state is
> > already loaded, and all we can do is to kill the L1.
> 
> I apologize for all of that pain.

No problem. IMHO the request was created out of abundance of caution 
(which I understand very well), and back then nobody could predict the issues it will create,
but as it stands now, it might be better to remove it that keep on adding more code to the mess.

I btw tested the attached patch a bit more and it seems to survive so far.

Best regards,
	Maxim Levitsky


> 
> > Thanks again!
> > Best regards,
> >         Maxim Levitsky
> > 
> > 
> > 
> > 


