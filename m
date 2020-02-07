Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E462E155DAF
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgBGSR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55907 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727868AbgBGSR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 13:17:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581099474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cPT63VS6JkFJRjpL5MMsWxNfN8Beu47vJy8tbC2r7XM=;
        b=Y/cdiXS9qg198XeYOe6OfszY8IiD737uVmSUJE64TzYvg13u9ESEGkmZF/72192DBYdQL7
        6/T7/mO1JCuDDQjRzkApSoIq1OhrLPvdDdCt1QZxCBDOmdTL/j4gr7tzbI8xPLS+NSxjZ0
        TPF5KfngjJMm20SkOCKHiCB1ZJ8FSQI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-eSsF0h2UMm6CmX1CB76Ebg-1; Fri, 07 Feb 2020 13:17:52 -0500
X-MC-Unique: eSsF0h2UMm6CmX1CB76Ebg-1
Received: by mail-qv1-f71.google.com with SMTP id z9so69328qvo.10
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 10:17:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cPT63VS6JkFJRjpL5MMsWxNfN8Beu47vJy8tbC2r7XM=;
        b=J5nzYCGcZcaLDlMvfTeRcfM7QWzTsqPVxRVDDfx0QJl0Mepv1fEzHXX7SKAKsErR29
         WPVeLAYqQuhLi0YoYzge/rbolWO0Bx9Bw3Np9gVZ/UX0xW1sAhLCl9Bnns8im8cYsxu5
         E2p8JqUJEkt5qaVCic4UIlU28HxNv0FToy/wTPquT5H06uCPcJSjKwcd673HErcu/1Uj
         aH4+wABL7B/8P+o1xvmT08myXZJcpO31MTGxhFsCaALdaTrmlmNQ9jhk9xND7Keo05rI
         Bv+sgAr+vJTDqWlSFIURwsU9Gi76oPgilD/sI8NBnYbcEIfgOmFat2i5dWrMGN3KShki
         vm/Q==
X-Gm-Message-State: APjAAAUo/onFCS6r0PApAdaJoLe4zSxStH5pr+A5KVVKbcVcpy3yaRFv
        isyTS+LfzwgvVVd3Cl40WwFW+sImkmPTo45FshSwKFRnXZASpVgQiw6gCc0vq+wonZivY1NHK9u
        rrBqjmz2ZZN0S
X-Received: by 2002:a05:6214:1253:: with SMTP id q19mr106733qvv.75.1581099472153;
        Fri, 07 Feb 2020 10:17:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqzRox8Bo7fyFYmNOjYNh/V3B0M3O5rtHPF6if8Y080MuT3a3U4ayt/3NWDSUCkErG4IzY/vdw==
X-Received: by 2002:a05:6214:1253:: with SMTP id q19mr106704qvv.75.1581099471868;
        Fri, 07 Feb 2020 10:17:51 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id b24sm1725899qto.71.2020.02.07.10.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 10:17:51 -0800 (PST)
Date:   Fri, 7 Feb 2020 13:17:48 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 12/19] KVM: Move memslot deletion to helper function
Message-ID: <20200207181748.GC720553@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-13-sean.j.christopherson@intel.com>
 <20200206161415.GA695333@xz-x1>
 <20200206162818.GD13067@linux.intel.com>
 <20200206165116.GE695333@xz-x1>
 <20200207175912.GG2401@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200207175912.GG2401@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 09:59:12AM -0800, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 11:51:16AM -0500, Peter Xu wrote:
> > On Thu, Feb 06, 2020 at 08:28:18AM -0800, Sean Christopherson wrote:
> > > On Thu, Feb 06, 2020 at 11:14:15AM -0500, Peter Xu wrote:
> > > > On Tue, Jan 21, 2020 at 02:31:50PM -0800, Sean Christopherson wrote:
> > > > > Move memslot deletion into its own routine so that the success path for
> > > > > other memslot updates does not need to use kvm_free_memslot(), i.e. can
> > > > > explicitly destroy the dirty bitmap when necessary.  This paves the way
> > > > > for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
> > > > > NULL for @dont.
> > > > > 
> > > > > Add a comment above the code to make a copy of the existing memslot
> > > > > prior to deletion, it is not at all obvious that the pointer will become
> > > > > stale during sorting and/or installation of new memslots.
> > > > 
> > > > Could you help explain a bit on this explicit comment?  I can follow
> > > > up with the patch itself which looks all correct to me, but I failed
> > > > to catch what this extra comment wants to emphasize...
> > > 
> > > It's tempting to write the code like this (I know, because I did it):
> > > 
> > > 	if (!mem->memory_size)
> > > 		return kvm_delete_memslot(kvm, mem, slot, as_id);
> > > 
> > > 	new = *slot;
> > > 
> > > Where @slot is a pointer to the memslot to be deleted.  At first, second,
> > > and third glances, this seems perfectly sane.
> > > 
> > > The issue is that slot was pulled from struct kvm_memslots.memslots, e.g.
> > > 
> > > 	slot = &slots->memslots[index];
> > > 
> > > Note that slots->memslots holds actual "struct kvm_memory_slot" objects,
> > > not pointers to slots.  When update_memslots() sorts the slots, it swaps
> > > the actual slot objects, not pointers.  I.e. after update_memslots(), even
> > > though @slot points at the same address, it's could be pointing at a
> > > different slot.  As a result kvm_free_memslot() in kvm_delete_memslot()
> > > will free the dirty page info and arch-specific points for some random
> > > slot, not the intended slot, and will set npages=0 for that random slot.
> > 
> > Ah I see, thanks.  Another alternative is we move the "old = *slot"
> > copy into kvm_delete_memslot(), which could be even clearer imo.
> 
> The copy is also needed in __kvm_set_memory_region() for the MOVE case.

Right.  I actually meant to do all "old = *slot" in any function we
need to cache the data explicitly, with that we also need another one
after calling kvm_delete_memslot() for move.  But with the comment as
you suggested below it looks good to me too.

Thanks,

> 
> > However I'm not sure whether it's a good idea to drop the test-by for
> > this.  Considering that comment change should not affect it, would you
> > mind enrich the comment into something like this (or anything better)?
> > 
> > /*
> >  * Make a full copy of the old memslot, the pointer will become stale
> >  * when the memslots are re-sorted by update_memslots() in
> >  * kvm_delete_memslot(), while to make the kvm_free_memslot() work as
> >  * expected later on, we still need the cached memory slot.
> >  */
> 
> As above, it's more subtle than just the kvm_delete_memslot() case.
> 
> 	/*
> 	 * Make a full copy of the old memslot, the pointer will become stale
> 	 * when the memslots are re-sorted by update_memslots() when deleting
> 	 * or moving a memslot, and additional modifications to the old memslot
> 	 * need to be made after calling update_memslots().
> 	 */
> 

-- 
Peter Xu

