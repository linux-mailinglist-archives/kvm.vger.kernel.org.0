Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F5AB8185
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 21:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392390AbfISTjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 15:39:17 -0400
Received: from mga07.intel.com ([134.134.136.100]:50290 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392354AbfISTjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 15:39:17 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Sep 2019 12:39:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,524,1559545200"; 
   d="scan'208";a="217417278"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 19 Sep 2019 12:39:15 -0700
Date:   Thu, 19 Sep 2019 12:39:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     James Hogan <jhogan@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/13] KVM: Provide common implementation for generic
 dirty log functions
Message-ID: <20190919193915.GC30495@linux.intel.com>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
 <20190911185038.24341-11-sean.j.christopherson@intel.com>
 <20190919002242.GA19503@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919002242.GA19503@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 19, 2019 at 10:22:42AM +1000, Paul Mackerras wrote:
> On Wed, Sep 11, 2019 at 11:50:35AM -0700, Sean Christopherson wrote:
> > Move the implementations of KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG
> > for CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT into common KVM code.
> > The arch specific implemenations are extremely similar, differing
> > only in whether the dirty log needs to be sync'd from hardware (x86)
> > and how the TLBs are flushed.  Add new arch hooks to handle sync
> > and TLB flush; the sync will also be used for non-generic dirty log
> > support in a future patch (s390).
> > 
> > The ulterior motive for providing a common implementation is to
> > eliminate the dependency between arch and common code with respect to
> > the memslot referenced by the dirty log, i.e. to make it obvious in the
> > code that the validity of the memslot is guaranteed, as a future patch
> > will rework memslot handling such that id_to_memslot() can return NULL.
> 
> I notice you add empty definitions of kvm_arch_sync_dirty_log() for
> PPC, both Book E and Book 3S.  Given that PPC doesn't select
> CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT, why is this necessary?

s390 has a non-empty kvm_arch_sync_dirty_log() but doesn't select
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT.  Patch 11/13 moves s390's call
of kvm_arch_sync_dirty_log() from s390's kvm_vm_ioctl_get_dirty_log() into
the common (but not "generic") kvm_get_dirty_log() so that it's obvious
that kvm_vm_ioctl_get_dirty_log() and kvm_get_dirty_log() are operating on
the same memslot, i.e. aren't independently querying id_to_memslot().

I originally made kvm_arch_sync_dirty_log() opt-in with a __KVM_HAVE_ARCH
macro, but the resulting #ifdeffery felt uglier than having PPC and ARM
provide empty functions.
