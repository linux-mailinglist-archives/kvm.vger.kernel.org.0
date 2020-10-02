Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A258B2816CC
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388089AbgJBPjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 11:39:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21376 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388068AbgJBPjD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 11:39:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601653141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mcQvssM4mn2MvNgEPb35OrX0ADz0ykZj2Qejjs7scM4=;
        b=Hn3lBY4/dPXmehqj4mO+0bNWJEfQwa3D3Amlvhtyjpnuxlr91EdGyBmPMsRJVeu7qP9GAp
        INjFSxf4qf/rcD1lpnPddayfOO281UGWgqRisabKh3D/DWYBoXh0dhqfJffQcnN0GnoPcw
        LUIN1wh6MQVnLJANPybO4F3uBCteghM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-m14Ug9LPMBO9JZ-4qlBoxA-1; Fri, 02 Oct 2020 11:38:59 -0400
X-MC-Unique: m14Ug9LPMBO9JZ-4qlBoxA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 726554239D;
        Fri,  2 Oct 2020 15:38:58 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-130.rdu2.redhat.com [10.10.115.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2472473678;
        Fri,  2 Oct 2020 15:38:55 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id A245B224B7D; Fri,  2 Oct 2020 11:38:54 -0400 (EDT)
Date:   Fri, 2 Oct 2020 11:38:54 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, vkuznets@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
Message-ID: <20201002153854.GC3119@redhat.com>
References: <20200720211359.GF502563@redhat.com>
 <20200929043700.GL31514@linux.intel.com>
 <20201001215508.GD3522@redhat.com>
 <20201001223320.GI7474@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001223320.GI7474@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 01, 2020 at 03:33:20PM -0700, Sean Christopherson wrote:
> On Thu, Oct 01, 2020 at 05:55:08PM -0400, Vivek Goyal wrote:
> > On Mon, Sep 28, 2020 at 09:37:00PM -0700, Sean Christopherson wrote:
> > > On Mon, Jul 20, 2020 at 05:13:59PM -0400, Vivek Goyal wrote:
> > > > @@ -10369,6 +10378,36 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(kvm_set_rflags);
> > > >  
> > > > +static inline u32 kvm_error_gfn_hash_fn(gfn_t gfn)
> > > > +{
> > > > +	BUILD_BUG_ON(!is_power_of_2(ERROR_GFN_PER_VCPU));
> > > > +
> > > > +	return hash_32(gfn & 0xffffffff, order_base_2(ERROR_GFN_PER_VCPU));
> > > > +}
> > > > +
> > > > +static void kvm_add_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> > > > +{
> > > > +	u32 key = kvm_error_gfn_hash_fn(gfn);
> > > > +
> > > > +	/*
> > > > +	 * Overwrite the previous gfn. This is just a hint to do
> > > > +	 * sync page fault.
> > > > +	 */
> > > > +	vcpu->arch.apf.error_gfns[key] = gfn;
> > > > +}
> > > > +
> > > > +/* Returns true if gfn was found in hash table, false otherwise */
> > > > +static bool kvm_find_and_remove_error_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
> > > > +{
> > > > +	u32 key = kvm_error_gfn_hash_fn(gfn);
> > > 
> > > Mostly out of curiosity, do we really need a hash?  E.g. could we get away
> > > with an array of 4 values?  2 values?  Just wondering if we can avoid 64*8
> > > bytes per CPU.
> > 
> > We are relying on returning error when guest task retries fault. Fault
> > will be retried on same address if same task is run by vcpu after
> > "page ready" event. There is no guarantee that same task will be
> > run. In theory, this cpu could have a large number of tasks queued
> > and run these tasks before the faulting task is run again. Now say
> > there are 128 tasks being run and 32 of them have page fault
> > errors. Then if we keep 4 values, newer failures will simply
> > overwrite older failures and we will keep spinning instead of
> > exiting to user space.
> > 
> > That's why this array of 64 gfns and add gfns based on hash. This
> > does not completely elimiante the above possibility but chances
> > of one hitting this are very very slim.
> 
> But have you actually tried such a scenario?  In other words, is there good
> justification for burning the extra memory?

Its not easy to try and reproduce. So it is all theory  at this point of time.
If you are worried about memory usage, we can probably reduce the size
of hash table. Say from 64, reduce it to 8. I am fine with that. I think
initially I had a single error_gfn. But Vitaly had concerns about
above scenario, so I implemeted a hash table.

I think reducing hash table size to 8 or 16 probaly is a good middle
ground.

> 
> Alternatively, what about adding a new KVM request type to handle this?
> E.g. when the APF comes back with -EFAULT, snapshot the GFN and make a
> request.  The vCPU then gets kicked and exits to userspace.  Before exiting
> to userspace, the request handler resets vcpu->arch.apf.error_gfn.  Bad GFNs
> simply get if error_gfn is "valid", i.e. there's a pending request.

Sorry, I did not understand the above proposal. Can you please elaborate
a bit more. Part of it is that I don't know much about KVM requests.
Looking at the code it looks like that main loop is parsing if some
kvm request is pending and executing that action.

Don't we want to make sure that we exit to user space when guest retries
error gfn access again. In this case once we get -EFAULT, we will still
inject page_ready into guest. And then either same process or a different
process might run. 

So when exactly code raises a kvm request. If I raise it right when
I get -EFAULT, then kvm will exit to user space upon next entry
time. But there is no guarantee guest vcpu is running the process which
actually accessed the error gfn. And that probably means that register
state of cpu does not mean much and one can not easily figure out
which task tried to access the bad memory and when.

That's why we prepare a list of error gfn and only exit to user space
when error_gfn access is retried so that guest vcpu context is correct.

What am I missing?

Thanks
Vivek

> 
> That would guarantee the error is propagated to userspace, and doesn't lose
> any guest information as dropping error GFNs just means the guest will take
> more page fault exits.
> 
> > > One thought would be to use the index to handle the case of no error gfns so
> > > that the size of the array doesn't affect lookup for the common case, e.g.
> > 
> > We are calculating hash of gfn (used as index in array). So lookup cost
> > is not driven by size of array. Its O(1) and not O(N). We just lookup
> > at one element in array and if it does not match, we return false.
> > 
> > 	u32 key = kvm_error_gfn_hash_fn(gfn);
> > 
> > 	if (vcpu->arch.apf.error_gfns[key] != gfn)
> > 		return 0;
> > 
> > 
> > > 
> > > 	...
> > > 
> > > 		u8 error_gfn_head;
> > > 		gfn_t error_gfns[ERROR_GFN_PER_VCPU];
> > > 	} apf;	
> > > 
> > > 
> > > 	if (vcpu->arch.apf.error_gfn_head == 0xff)
> > > 		return false;
> > > 
> > > 	for (i = 0; i < vcpu->arch.apf.error_gfn_head; i++) {
> > > 		if (vcpu->arch.apf.error_gfns[i] == gfn) {
> > > 			vcpu->arch.apf.error_gfns[i] = INVALID_GFN;
> > > 			return true;
> > > 		}
> > > 	}
> > > 	return true;
> > > 
> > > Or you could even avoid INVALID_GFN altogether by compacting the array on
> > > removal.  The VM is probably dead anyways, burning a few cycles to clean
> > > things up is a non-issue.  Ditto for slow insertion.
> > 
> > Same for insertion. Its O(1) and not dependent on size of array. Also
> > insertion anyway is very infrequent event because it will not be
> > often that error will happen.
> 
> I know, I was saying that if we move to an array then we'd technically be
> subject to O(whatever) search and delete, but that it's irrelevant from a
> performance perspective because the guest is already toast if it hits a bad
> GFN.
> 
> > > > +
> > > > +	if (vcpu->arch.apf.error_gfns[key] != gfn)
> > > > +		return 0;
> > > 
> > > Should be "return false".
> > 
> > Will fix.
> > 
> > Thanks
> > Vivek
> > 
> 

