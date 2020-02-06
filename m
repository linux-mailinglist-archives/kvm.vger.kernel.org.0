Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CA61549B0
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 17:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgBFQv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 11:51:26 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21604 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727060AbgBFQv0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 11:51:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581007885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6wEZC2xS1ICrNAGJ+8QI1N9zsFW9IzwC/0IJCgjt8nk=;
        b=Nq7ytd0eXJdKZ8CPoo1n96CnFlnJhjtZYxcK4REDrfdZ4NLZPjpnPRQjds91J+inHL1pvL
        GSoYApQLM/3CMNgsq/qAA5ECTA9/RMppEXmSAdu+MJOutnfp8hUdKYocgT4pcIjbBbgnHk
        y4GuTS7s+xg3gazFR/xi9tX3G0MpLGs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-pUHK38R_PZekGvQhreMt2Q-1; Thu, 06 Feb 2020 11:51:21 -0500
X-MC-Unique: pUHK38R_PZekGvQhreMt2Q-1
Received: by mail-qt1-f197.google.com with SMTP id l1so4215171qtp.21
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 08:51:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6wEZC2xS1ICrNAGJ+8QI1N9zsFW9IzwC/0IJCgjt8nk=;
        b=pbFX9ObuHMcwqxoJ739b4eUTjGRhoWbW1Ez3SyZufeHwU/pJE3pUphCA29cr3h8E40
         bzJDWwlvEa5GG5ZgAXMLGUXjdiy00JjSGrzzzOOGpYyHvNmQQi4vdkhNJsJltFSY3YtJ
         nkiQA2vM4C7dzjo2H2ozffskz49xxVUBFGK6sN+H6TmFn2vVBBSiSKKC4ZA2Rcm//9E/
         26eFtZNLQFhwDiOT4yLseXQrMQnfZSrkHSlimVroJKdVBXptL2XwjNH07heG8+1mMXGt
         lGyb8OchnPyFG5wVDzH4oR5c5GwjhgqFL0Erp9ijExyq00mWFeKYlDht48SSTQrFl1pK
         GOIQ==
X-Gm-Message-State: APjAAAUqLmXg1Inm11yS3uVGY+Qr46u6plOyXDIyjvasTjvJDCnYagmg
        4esc3Rm2C1CZswohQzAPQcK0go1Xb+zAL899t9Og4oQ1cNYdxlBu+SUnTsdWkOFwXzHflVA3E3v
        EjvVetuvsEaas
X-Received: by 2002:a0c:ed22:: with SMTP id u2mr3142534qvq.13.1581007880665;
        Thu, 06 Feb 2020 08:51:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqx/jX2RKvHGf3JDTGGU+D3o2LP4p21Bk3Kl7+mbxJpFhXmYhA374b5M6RMOGMp7RFtjxv6e0g==
X-Received: by 2002:a0c:ed22:: with SMTP id u2mr3142516qvq.13.1581007880314;
        Thu, 06 Feb 2020 08:51:20 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id v10sm1058913qtj.26.2020.02.06.08.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 08:51:19 -0800 (PST)
Date:   Thu, 6 Feb 2020 11:51:16 -0500
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
Message-ID: <20200206165116.GE695333@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-13-sean.j.christopherson@intel.com>
 <20200206161415.GA695333@xz-x1>
 <20200206162818.GD13067@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200206162818.GD13067@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 08:28:18AM -0800, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 11:14:15AM -0500, Peter Xu wrote:
> > On Tue, Jan 21, 2020 at 02:31:50PM -0800, Sean Christopherson wrote:
> > > Move memslot deletion into its own routine so that the success path for
> > > other memslot updates does not need to use kvm_free_memslot(), i.e. can
> > > explicitly destroy the dirty bitmap when necessary.  This paves the way
> > > for dropping @dont from kvm_free_memslot(), i.e. all callers now pass
> > > NULL for @dont.
> > > 
> > > Add a comment above the code to make a copy of the existing memslot
> > > prior to deletion, it is not at all obvious that the pointer will become
> > > stale during sorting and/or installation of new memslots.
> > 
> > Could you help explain a bit on this explicit comment?  I can follow
> > up with the patch itself which looks all correct to me, but I failed
> > to catch what this extra comment wants to emphasize...
> 
> It's tempting to write the code like this (I know, because I did it):
> 
> 	if (!mem->memory_size)
> 		return kvm_delete_memslot(kvm, mem, slot, as_id);
> 
> 	new = *slot;
> 
> Where @slot is a pointer to the memslot to be deleted.  At first, second,
> and third glances, this seems perfectly sane.
> 
> The issue is that slot was pulled from struct kvm_memslots.memslots, e.g.
> 
> 	slot = &slots->memslots[index];
> 
> Note that slots->memslots holds actual "struct kvm_memory_slot" objects,
> not pointers to slots.  When update_memslots() sorts the slots, it swaps
> the actual slot objects, not pointers.  I.e. after update_memslots(), even
> though @slot points at the same address, it's could be pointing at a
> different slot.  As a result kvm_free_memslot() in kvm_delete_memslot()
> will free the dirty page info and arch-specific points for some random
> slot, not the intended slot, and will set npages=0 for that random slot.

Ah I see, thanks.  Another alternative is we move the "old = *slot"
copy into kvm_delete_memslot(), which could be even clearer imo.
However I'm not sure whether it's a good idea to drop the test-by for
this.  Considering that comment change should not affect it, would you
mind enrich the comment into something like this (or anything better)?

/*
 * Make a full copy of the old memslot, the pointer will become stale
 * when the memslots are re-sorted by update_memslots() in
 * kvm_delete_memslot(), while to make the kvm_free_memslot() work as
 * expected later on, we still need the cached memory slot.
 */

In all cases:

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

