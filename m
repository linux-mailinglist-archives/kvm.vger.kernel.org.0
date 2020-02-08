Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA342156223
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 01:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgBHAxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 19:53:43 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51822 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727144AbgBHAxm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 19:53:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581123221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JXjXMB8+l02t7W3QCunMDZ6uJP1WKNZJHojqnKutHCk=;
        b=Vqlp4/ohAvccGiOcPkyJ8QyOYrst1QTsHXgOppkDoKtY26h9OZFrm5dbz5aCY43OciDEqr
        0M1eWlbqXmpFdb2dzzRWvBNIsxRqWpnjkFBqy7FFZCCbuV1EQnw+17GAGI/NSb/LKCMOiF
        SUYkgF0CibpuDodpFF5ssCWogXBu+rE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-JDik142TOgWxWdifFEVazA-1; Fri, 07 Feb 2020 19:53:39 -0500
X-MC-Unique: JDik142TOgWxWdifFEVazA-1
Received: by mail-qk1-f200.google.com with SMTP id v2so681403qkf.4
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 16:53:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JXjXMB8+l02t7W3QCunMDZ6uJP1WKNZJHojqnKutHCk=;
        b=W6mV+VVSSm8hRie43Onhv6HFvNb2h+LebTibYq95z/sQALIO+fxPClYPPtRTg0rWsf
         78w0hh3B2RHM7mhWZWry1Y6gAzl2lcL4j23pYVGl0o65G8qOjcvFRna4L8I6f6BYAXDJ
         M1EwZveLWEjihLKaNnZtx319Hx3XU9UuVWnrrHa4fy1vHLq3sIXHLwlY7Tp9fWqVKTVS
         gHtOIhdXNqEve+ZTz0mCC0ZvDGotjHk8x0VZ8G20n8Lviw5pk7kxM3t0HAQi1MgdYCM3
         BTu0OH8twzM4yEJk7aQZslksDYXT7EtfiK1Odg1HWBqqWnjBQlyfk96Ies0ezfqu0OfC
         hsRw==
X-Gm-Message-State: APjAAAWI7Ed1Daqe3D7t2E14ow5HGdAbBpuLi53ocP1S4V65fm2ulQbN
        a7PdoIklNkVDjSfVYmeCEi9wAouNzoEYoAzN2dWjStOG7LX5pwT/7QKtrVRfswfP7MtYNKjADyM
        Qv+aYSdpjrFQX
X-Received: by 2002:ac8:6ec5:: with SMTP id f5mr969422qtv.137.1581123218872;
        Fri, 07 Feb 2020 16:53:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqzfBGlw4CUmZPsPxFOLtL7frnrx1mxODS7RRyVx/ZknrCPjZQV1DWO/22HCN4/PJDeBYQRbmw==
X-Received: by 2002:ac8:6ec5:: with SMTP id f5mr969400qtv.137.1581123218590;
        Fri, 07 Feb 2020 16:53:38 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id m27sm2307107qta.21.2020.02.07.16.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 16:53:37 -0800 (PST)
Date:   Fri, 7 Feb 2020 19:53:34 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
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
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200208005334.GB823968@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
 <20200206200200.GC700495@xz-x1>
 <20200206212120.GF13067@linux.intel.com>
 <20200206214106.GG700495@xz-x1>
 <20200207194532.GK2401@linux.intel.com>
 <20200208001832.GA823968@xz-x1>
 <20200208004233.GA15581@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200208004233.GA15581@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 04:42:33PM -0800, Sean Christopherson wrote:
> On Fri, Feb 07, 2020 at 07:18:32PM -0500, Peter Xu wrote:
> > On Fri, Feb 07, 2020 at 11:45:32AM -0800, Sean Christopherson wrote:
> > > +Vitaly for HyperV
> > > 
> > > On Thu, Feb 06, 2020 at 04:41:06PM -0500, Peter Xu wrote:
> > > > On Thu, Feb 06, 2020 at 01:21:20PM -0800, Sean Christopherson wrote:
> > > > > On Thu, Feb 06, 2020 at 03:02:00PM -0500, Peter Xu wrote:
> > > > > > But that matters to this patch because if MIPS can use
> > > > > > kvm_flush_remote_tlbs(), then we probably don't need this
> > > > > > arch-specific hook any more and we can directly call
> > > > > > kvm_flush_remote_tlbs() after sync dirty log when flush==true.
> > > > > 
> > > > > Ya, the asid_flush_mask in kvm_vz_flush_shadow_all() is the only thing
> > > > > that prevents calling kvm_flush_remote_tlbs() directly, but I have no
> > > > > clue as to the important of that code.
> > > > 
> > > > As said above I think the x86 lockdep is really not necessary, then
> > > > considering MIPS could be the only one that will use the new hook
> > > > introduced in this patch...  Shall we figure that out first?
> > > 
> > > So I prepped a follow-up patch to make kvm_arch_dirty_log_tlb_flush() a
> > > MIPS-only hook and use kvm_flush_remote_tlbs() directly for arm and x86,
> > > but then I realized x86 *has* a hook to do a precise remote TLB flush.
> > > There's even an existing kvm_flush_remote_tlbs_with_address() call on a
> > > memslot, i.e. this exact scenario.  So arguably, x86 should be using the
> > > more precise flush and should keep kvm_arch_dirty_log_tlb_flush().
> > > 
> > > But, the hook is only used when KVM is running as an L1 on top of HyperV,
> > > and I assume dirty logging isn't used much, if at all, for L1 KVM on
> > > HyperV?
> > > 
> > > I see three options:
> > > 
> > >   1. Make kvm_arch_dirty_log_tlb_flush() MIPS-only and call
> > >      kvm_flush_remote_tlbs() directly for arm and x86.  Add comments to
> > >      explain when an arch should implement kvm_arch_dirty_log_tlb_flush().
> > > 
> > >   2. Change x86 to use kvm_flush_remote_tlbs_with_address() when flushing
> > >      a memslot after the dirty log is grabbed by userspace.
> > > 
> > >   3. Keep the resulting code as is, but add a comment in x86's
> > >      kvm_arch_dirty_log_tlb_flush() to explain why it uses
> > >      kvm_flush_remote_tlbs() instead of the with_address() variant.
> > > 
> > > I strongly prefer to (2) or (3), but I'll defer to Vitaly as to which of
> > > those is preferable.
> > > 
> > > I don't like (1) because (a) it requires more lines code (well comments),
> > > to explain why kvm_flush_remote_tlbs() is the default, and (b) it would
> > > require even more comments, which would be x86-specific in generic KVM,
> > > to explain why x86 doesn't use its with_address() flush, or we'd lost that
> > > info altogether.
> > > 
> > 
> > I proposed the 4th solution here:
> > 
> > https://lore.kernel.org/kvm/20200207223520.735523-1-peterx@redhat.com/
> > 
> > I'm not sure whether that's acceptable, but if it can, then we can
> > drop the kvm_arch_dirty_log_tlb_flush() hook, or even move on to
> > per-slot tlb flushing.
> 
> This effectively is per-slot TLB flushing, it just has a different name.
> I.e. s/kvm_arch_dirty_log_tlb_flush/kvm_arch_flush_remote_tlbs_memslot.
> I'm not opposed to that name change.  And on second and third glance, I
> probably prefer it.  That would more or less follow the naming of
> kvm_arch_flush_shadow_all() and kvm_arch_flush_shadow_memslot().

Note that the major point of the above patchset is not about doing tlb
flush per-memslot or globally.  It's more about whether we can provide
a common entrance for TLB flushing.  Say, after that series, we should
be able to flush TLB on all archs (majorly, including MIPS) as:

  kvm_flush_remote_tlbs(kvm);

And with the same idea we can also introduce the ranged version.

> 
> I don't want to go straight to kvm_arch_flush_remote_tlb_with_address()
> because that loses the important distinction (on x86) that slots_lock is
> expected to be held.

Sorry I'm still puzzled on why that lockdep is so important and
special for x86...  For example, what if we move that lockdep to the
callers of the kvm_arch_dirty_log_tlb_flush() calls so it protects
even more arch (where we do get/clear dirty log)?  IMHO the callers
must be with the slots_lock held anyways no matter for x86 or not.

Thanks,

-- 
Peter Xu

