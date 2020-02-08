Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5EBA1561F9
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 01:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgBHAmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 19:42:36 -0500
Received: from mga07.intel.com ([134.134.136.100]:61094 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgBHAmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 19:42:36 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 16:42:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,415,1574150400"; 
   d="scan'208";a="346332007"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 07 Feb 2020 16:42:34 -0800
Date:   Fri, 7 Feb 2020 16:42:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
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
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 15/19] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20200208004233.GA15581@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-16-sean.j.christopherson@intel.com>
 <20200206200200.GC700495@xz-x1>
 <20200206212120.GF13067@linux.intel.com>
 <20200206214106.GG700495@xz-x1>
 <20200207194532.GK2401@linux.intel.com>
 <20200208001832.GA823968@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200208001832.GA823968@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 07:18:32PM -0500, Peter Xu wrote:
> On Fri, Feb 07, 2020 at 11:45:32AM -0800, Sean Christopherson wrote:
> > +Vitaly for HyperV
> > 
> > On Thu, Feb 06, 2020 at 04:41:06PM -0500, Peter Xu wrote:
> > > On Thu, Feb 06, 2020 at 01:21:20PM -0800, Sean Christopherson wrote:
> > > > On Thu, Feb 06, 2020 at 03:02:00PM -0500, Peter Xu wrote:
> > > > > But that matters to this patch because if MIPS can use
> > > > > kvm_flush_remote_tlbs(), then we probably don't need this
> > > > > arch-specific hook any more and we can directly call
> > > > > kvm_flush_remote_tlbs() after sync dirty log when flush==true.
> > > > 
> > > > Ya, the asid_flush_mask in kvm_vz_flush_shadow_all() is the only thing
> > > > that prevents calling kvm_flush_remote_tlbs() directly, but I have no
> > > > clue as to the important of that code.
> > > 
> > > As said above I think the x86 lockdep is really not necessary, then
> > > considering MIPS could be the only one that will use the new hook
> > > introduced in this patch...  Shall we figure that out first?
> > 
> > So I prepped a follow-up patch to make kvm_arch_dirty_log_tlb_flush() a
> > MIPS-only hook and use kvm_flush_remote_tlbs() directly for arm and x86,
> > but then I realized x86 *has* a hook to do a precise remote TLB flush.
> > There's even an existing kvm_flush_remote_tlbs_with_address() call on a
> > memslot, i.e. this exact scenario.  So arguably, x86 should be using the
> > more precise flush and should keep kvm_arch_dirty_log_tlb_flush().
> > 
> > But, the hook is only used when KVM is running as an L1 on top of HyperV,
> > and I assume dirty logging isn't used much, if at all, for L1 KVM on
> > HyperV?
> > 
> > I see three options:
> > 
> >   1. Make kvm_arch_dirty_log_tlb_flush() MIPS-only and call
> >      kvm_flush_remote_tlbs() directly for arm and x86.  Add comments to
> >      explain when an arch should implement kvm_arch_dirty_log_tlb_flush().
> > 
> >   2. Change x86 to use kvm_flush_remote_tlbs_with_address() when flushing
> >      a memslot after the dirty log is grabbed by userspace.
> > 
> >   3. Keep the resulting code as is, but add a comment in x86's
> >      kvm_arch_dirty_log_tlb_flush() to explain why it uses
> >      kvm_flush_remote_tlbs() instead of the with_address() variant.
> > 
> > I strongly prefer to (2) or (3), but I'll defer to Vitaly as to which of
> > those is preferable.
> > 
> > I don't like (1) because (a) it requires more lines code (well comments),
> > to explain why kvm_flush_remote_tlbs() is the default, and (b) it would
> > require even more comments, which would be x86-specific in generic KVM,
> > to explain why x86 doesn't use its with_address() flush, or we'd lost that
> > info altogether.
> > 
> 
> I proposed the 4th solution here:
> 
> https://lore.kernel.org/kvm/20200207223520.735523-1-peterx@redhat.com/
> 
> I'm not sure whether that's acceptable, but if it can, then we can
> drop the kvm_arch_dirty_log_tlb_flush() hook, or even move on to
> per-slot tlb flushing.

This effectively is per-slot TLB flushing, it just has a different name.
I.e. s/kvm_arch_dirty_log_tlb_flush/kvm_arch_flush_remote_tlbs_memslot.
I'm not opposed to that name change.  And on second and third glance, I
probably prefer it.  That would more or less follow the naming of
kvm_arch_flush_shadow_all() and kvm_arch_flush_shadow_memslot().

I don't want to go straight to kvm_arch_flush_remote_tlb_with_address()
because that loses the important distinction (on x86) that slots_lock is
expected to be held.
