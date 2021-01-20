Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8612FD0AA
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 13:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbhATMsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 07:48:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729582AbhATLfe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 06:35:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611142447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RwYNo9IWwhys7vzm7QOjLE4bc02/uzxG8yBwDPjWddA=;
        b=dOhTU4n/nfzrOl9rXjxY94n1MYQ3HIhuKjCQvk5xDFcUBsqMuuvcyx3r8NIYTZC/zzMjZ5
        NzwNKJJG3wviM9jaNh96r0ji7MwK6C3InyIzXUp99Cdpfecxy1vCdMKIvNpj0rN878ylBN
        q8TRETYrsuwan1lsFQ7gCMwJijpAmUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-5GqPwyl0Mu6EELqPjIFWWg-1; Wed, 20 Jan 2021 06:34:05 -0500
X-MC-Unique: 5GqPwyl0Mu6EELqPjIFWWg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E14A107ACE3;
        Wed, 20 Jan 2021 11:34:04 +0000 (UTC)
Received: from localhost (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23D7971CA1;
        Wed, 20 Jan 2021 11:34:01 +0000 (UTC)
Date:   Wed, 20 Jan 2021 12:34:00 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 3/4] KVM: Define KVM_USER_MEM_SLOTS in arch-neutral
 include/linux/kvm_host.h
Message-ID: <20210120123400.7936e526@redhat.com>
In-Reply-To: <YAcU6swvNkpPffE7@google.com>
References: <20210115131844.468982-1-vkuznets@redhat.com>
        <20210115131844.468982-4-vkuznets@redhat.com>
        <YAHLRVhevn7adhAz@google.com>
        <87wnwa608c.fsf@vitty.brq.redhat.com>
        <YAcU6swvNkpPffE7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jan 2021 09:20:42 -0800
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Jan 18, 2021, Vitaly Kuznetsov wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> >   
> > > On Fri, Jan 15, 2021, Vitaly Kuznetsov wrote:  
> > >> Memory slots are allocated dynamically when added so the only real
> > >> limitation in KVM is 'id_to_index' array which is 'short'. Define
> > >> KVM_USER_MEM_SLOTS to the maximum possible value in the arch-neutral
> > >> include/linux/kvm_host.h, architectures can still overtide the setting
> > >> if needed.  
> > >
> > > Leaving the max number of slots nearly unbounded is probably a bad idea.  If my
> > > math is not completely wrong, this would let userspace allocate 6mb of kernel
> > > memory per VM.  Actually, worst case scenario would be 12mb since modifying
> > > memslots temporarily has two allocations.  
> > 
> > Yea I had thought too but on the other hand, if your VMM went rogue and
> > and is trying to eat all your memory, how is allocating 32k memslots
> > different from e.g. creating 64 VMs with 512 slots each? We use
> > GFP_KERNEL_ACCOUNT to allocate memslots (and other per-VM stuff) so
> > e.g. cgroup limits should work ...  
> 
> I see it as an easy way to mitigate the damage.  E.g. if a containers use case
> is spinning up hundreds of VMs and something goes awry in the config, it would
> be the difference between consuming tens of MBs and hundreds of MBs.  Cgroup
> limits should also be in play, but defense in depth and all that. 
> 
> > > If we remove the arbitrary limit, maybe replace it with a module param with a
> > > sane default?  
> > 
> > This can be a good solution indeed. The only question then is what should
> > we pick as the default? It seems to me this can be KVM_MAX_VCPUS
> > dependent, e.g. 4 x KVM_MAX_VCPUS would suffice.  
> 
> Hrm, I don't love tying it to KVM_MAX_VPUCS.  Other than SynIC, are there any
> other features/modes/configuration that cause the number of memslots to grop

(NV)DIMMs in QEMU also consume slot/device but do not depend on vCPUs number.
Due current slot limit only 256 DIMMs are allowed. But if vCPUs start consuming
extra memslots, they will contend over possible slots.

> with the number of vCPUs?  But, limiting via a module param does effectively
> require using KVM_MAX_VCPUS, otherwise everyone that might run Windows guests
> would have to override the default and thereby defeat the purpose of limiting by
> default.
> 
> Were you planning on adding a capability to check for the new and improved
> memslots limit, e.g. to know whether or not KVM might die on a large VM?
> If so, requiring the VMM to call an ioctl() to set a higher (or lower?) limit
> would be another option.  That wouldn't have the same permission requirements as
> a module param, but it would likely be a more effective safeguard in practice,
> e.g. use cases with a fixed number of memslots or a well-defined upper bound
> could use the capability to limit themselves.
Currently QEMU uses KVM_CAP_NR_MEMSLOTS to get limit, and depending on place the
limit is reached it either fails gracefully (i.e. it checks if free slot is
available before slot allocation) or aborts (in case where it tries to allocate
slot without check).
New ioctl() seems redundant as we already have upper limit check
(unless it would allow go over that limit, which in its turn defeats purpose of
the limit).


> Thoughts?  An ioctl() feels a little over-engineered, but I suspect that adding
> a module param that defaults to N*KVM_MAX_VPCUS will be a waste, e.g. no one
> will ever touch the param and we'll end up with dead, rarely-tested code.
> 

