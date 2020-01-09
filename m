Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F3B135EC9
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387928AbgAIQ4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:56:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38304 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731320AbgAIQ4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 11:56:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578589001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XBEU5CS/Vc8kZY19dgB6cMNAjnA7jgdwFT3l/8agYvI=;
        b=GaOw+1BZirZxEI91iLC+aoztU0cmiDarTt3t7hi+QOD7O33OkjVsPMbeFwS4vpMMwrG2Z0
        ZDZJGUk9BA44go+HmTIMKkqDmj5zCFBNzAF3O1YHBTCY+q+S7QP2HXxy8fZati7sT11Kb8
        UwjKAt7OMxYF4oH5bDYfarheZWgq828=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-VcfvMZO9Mu-e5SS-4M_tGw-1; Thu, 09 Jan 2020 11:56:37 -0500
X-MC-Unique: VcfvMZO9Mu-e5SS-4M_tGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A4DD9CEF8;
        Thu,  9 Jan 2020 16:56:36 +0000 (UTC)
Received: from w520.home (ovpn-116-128.phx2.redhat.com [10.3.116.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17E9A5DA66;
        Thu,  9 Jan 2020 16:56:10 +0000 (UTC)
Date:   Thu, 9 Jan 2020 09:56:10 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200109095610.167cd9f0@w520.home>
In-Reply-To: <20200109110110-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
        <20200109145729.32898-13-peterx@redhat.com>
        <20200109110110-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 9 Jan 2020 11:29:28 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Thu, Jan 09, 2020 at 09:57:20AM -0500, Peter Xu wrote:
> > This patch is heavily based on previous work from Lei Cao
> > <lei.cao@stratus.com> and Paolo Bonzini <pbonzini@redhat.com>. [1]
> > 
> > KVM currently uses large bitmaps to track dirty memory.  These bitmaps
> > are copied to userspace when userspace queries KVM for its dirty page
> > information.  The use of bitmaps is mostly sufficient for live
> > migration, as large parts of memory are be dirtied from one log-dirty
> > pass to another.  However, in a checkpointing system, the number of
> > dirty pages is small and in fact it is often bounded---the VM is
> > paused when it has dirtied a pre-defined number of pages. Traversing a
> > large, sparsely populated bitmap to find set bits is time-consuming,
> > as is copying the bitmap to user-space.
> > 
> > A similar issue will be there for live migration when the guest memory
> > is huge while the page dirty procedure is trivial.  In that case for
> > each dirty sync we need to pull the whole dirty bitmap to userspace
> > and analyse every bit even if it's mostly zeros.
> > 
> > The preferred data structure for above scenarios is a dense list of
> > guest frame numbers (GFN).  
> 
> No longer, this uses an array of structs.
> 
> >  This patch series stores the dirty list in
> > kernel memory that can be memory mapped into userspace to allow speedy
> > harvesting.
> > 
> > This patch enables dirty ring for X86 only.  However it should be
> > easily extended to other archs as well.
> > 
> > [1] https://patchwork.kernel.org/patch/10471409/
> > 
> > Signed-off-by: Lei Cao <lei.cao@stratus.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  Documentation/virt/kvm/api.txt  |  89 ++++++++++++++++++
> >  arch/x86/include/asm/kvm_host.h |   3 +
> >  arch/x86/include/uapi/asm/kvm.h |   1 +
> >  arch/x86/kvm/Makefile           |   3 +-
> >  arch/x86/kvm/mmu/mmu.c          |   6 ++
> >  arch/x86/kvm/vmx/vmx.c          |   7 ++
> >  arch/x86/kvm/x86.c              |   9 ++
> >  include/linux/kvm_dirty_ring.h  |  55 +++++++++++
> >  include/linux/kvm_host.h        |  26 +++++
> >  include/trace/events/kvm.h      |  78 +++++++++++++++
> >  include/uapi/linux/kvm.h        |  33 +++++++
> >  virt/kvm/dirty_ring.c           | 162 ++++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c             | 137 ++++++++++++++++++++++++++-
> >  13 files changed, 606 insertions(+), 3 deletions(-)
> >  create mode 100644 include/linux/kvm_dirty_ring.h
> >  create mode 100644 virt/kvm/dirty_ring.c
> > 
> > diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> > index ebb37b34dcfc..708c3e0f7eae 100644
> > --- a/Documentation/virt/kvm/api.txt
> > +++ b/Documentation/virt/kvm/api.txt
> > @@ -231,6 +231,7 @@ Based on their initialization different VMs may have different capabilities.
> >  It is thus encouraged to use the vm ioctl to query for capabilities (available
> >  with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)
> >  
> > +
> >  4.5 KVM_GET_VCPU_MMAP_SIZE
> >  
> >  Capability: basic
> > @@ -243,6 +244,18 @@ The KVM_RUN ioctl (cf.) communicates with userspace via a shared
> >  memory region.  This ioctl returns the size of that region.  See the
> >  KVM_RUN documentation for details.
> >  
> > +Besides the size of the KVM_RUN communication region, other areas of
> > +the VCPU file descriptor can be mmap-ed, including:
> > +
> > +- if KVM_CAP_COALESCED_MMIO is available, a page at
> > +  KVM_COALESCED_MMIO_PAGE_OFFSET * PAGE_SIZE; for historical reasons,
> > +  this page is included in the result of KVM_GET_VCPU_MMAP_SIZE.
> > +  KVM_CAP_COALESCED_MMIO is not documented yet.
> > +
> > +- if KVM_CAP_DIRTY_LOG_RING is available, a number of pages at
> > +  KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE.  For more information on
> > +  KVM_CAP_DIRTY_LOG_RING, see section 8.3.
> > +
> >  
> >  4.6 KVM_SET_MEMORY_REGION
> >  
> > @@ -5376,6 +5389,7 @@ CPU when the exception is taken. If this virtual SError is taken to EL1 using
> >  AArch64, this value will be reported in the ISS field of ESR_ELx.
> >  
> >  See KVM_CAP_VCPU_EVENTS for more details.
> > +
> >  8.20 KVM_CAP_HYPERV_SEND_IPI
> >  
> >  Architectures: x86
> > @@ -5383,6 +5397,7 @@ Architectures: x86
> >  This capability indicates that KVM supports paravirtualized Hyper-V IPI send
> >  hypercalls:
> >  HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
> > +
> >  8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
> >  
> >  Architecture: x86
> > @@ -5396,3 +5411,77 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
> >  flush hypercalls by Hyper-V) so userspace should disable KVM identification
> >  in CPUID and only exposes Hyper-V identification. In this case, guest
> >  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
> > +
> > +8.22 KVM_CAP_DIRTY_LOG_RING
> > +
> > +Architectures: x86
> > +Parameters: args[0] - size of the dirty log ring
> > +
> > +KVM is capable of tracking dirty memory using ring buffers that are
> > +mmaped into userspace; there is one dirty ring per vcpu.
> > +
> > +One dirty ring is defined as below internally:
> > +
> > +struct kvm_dirty_ring {
> > +	u32 dirty_index;
> > +	u32 reset_index;
> > +	u32 size;
> > +	u32 soft_limit;
> > +	struct kvm_dirty_gfn *dirty_gfns;
> > +	struct kvm_dirty_ring_indices *indices;
> > +	int index;
> > +};
> > +
> > +Dirty GFNs (Guest Frame Numbers) are stored in the dirty_gfns array.
> > +For each of the dirty entry it's defined as:
> > +
> > +struct kvm_dirty_gfn {
> > +        __u32 pad;  
> 
> How about sticking a length here?
> This way huge pages can be dirtied in one go.

Not just huge pages, but any contiguous range of dirty pages could be
reported far more concisely.  Thanks,

Alex

