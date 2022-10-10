Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB15A5FA8C5
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 01:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJJX6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 19:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJJX6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 19:58:30 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE637FF8E
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 16:58:29 -0700 (PDT)
Date:   Mon, 10 Oct 2022 23:58:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665446307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tJgXiOuOI7U3DY9sZFhuqwx5chq6qTsB325P2CjKdDc=;
        b=HZMVvaBpF2m+Ss6FCRCp/9rR7nIJsfpoweAwc8larWgJI53LHTAFKK0pRUnVFtCBBBgZmr
        48g+4JRNb7elWjUk/mzTRhuJuc9WmICZJQohwTcW89qQrD9Ll39FFM75UMhHnAZD/Xr+Bc
        XiV5WMHoYpPkXW5xBB8WnbpmUS3gdsw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Peter Xu <peterx@redhat.com>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, james.morse@arm.com,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        seanjc@google.com, shan.gavin@gmail.com
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0SxnoT5u7+1TCT+@google.com>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com>
 <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0SvexjbHN78XVcq@xz-m1.local>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022 at 07:49:15PM -0400, Peter Xu wrote:
> On Mon, Oct 10, 2022 at 11:18:55PM +0000, Oliver Upton wrote:
> > On Fri, Oct 07, 2022 at 10:31:49AM -0400, Peter Xu wrote:
> > 
> > [...]
> > 
> > > > - In kvm_vm_ioctl_enable_dirty_log_ring(), set 'dirty_ring_allow_bitmap' to
> > > >   true when the capability is KVM_CAP_DIRTY_LONG_RING_ACQ_REL
> > > 
> > > What I wanted to do is to decouple the ACQ_REL with ALLOW_BITMAP, so mostly
> > > as what you suggested, except..
> > 
> > +1
> > 
> > > > 
> > > >   static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 cap, u32 size)
> > > >   {
> > > >     :
> > > >     mutex_lock(&kvm->lock);
> > > > 
> > > >     if (kvm->created_vcpus) {
> > > >        /* We don't allow to change this value after vcpu created */
> > > >        r = -EINVAL;
> > > >     } else {
> > > >        kvm->dirty_ring_size = size;
> > > 
> > > .. here I'd not set dirty_ring_allow_bitmap at all so I'd drop below line,
> > > instead..
> > > 
> > > >        kvm->dirty_ring_allow_bitmap = (cap == KVM_CAP_DIRTY_LOG_RING_ACQ_REL);
> > > >        r = 0;
> > > >     }
> > > > 
> > > >     mutex_unlock(&kvm->lock);
> > > >     return r;
> > > >   }
> > > > - In kvm_vm_ioctl_check_extension_generic(), KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP
> > > >   is always flase until KVM_CAP_DIRTY_LOG_RING_ACQ_REL is enabled.
> > > > 
> > > >   static long kvm_vm_ioctl_check_extension_generic(...)
> > > >   {
> > > >     :
> > > >     case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
> > > >         return kvm->dirty_ring_allow_bitmap ? 1 : 0;
> > > 
> > > ... here we always return 1, OTOH in kvm_vm_ioctl_enable_cap_generic():
> > > 
> > >       case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
> > >            if (kvm->dirty_ring_size)
> > >                 return -EINVAL;
> > >            kvm->dirty_ring_allow_bitmap = true;
> > >            return 0;
> > > 
> > > A side effect of checking dirty_ring_size is then we'll be sure to have no
> > > vcpu created too.  Maybe we should also check no memslot created to make
> > > sure the bitmaps are not created.
> > 
> > I'm not sure I follow... What prevents userspace from creating a vCPU
> > between enabling the two caps?
> 
> Enabling of dirty ring requires no vcpu created, so as to make sure all the
> vcpus will have the ring structures allocated as long as ring enabled for
> the vm.  Done in kvm_vm_ioctl_enable_dirty_log_ring():
> 
> 	if (kvm->created_vcpus) {
> 		/* We don't allow to change this value after vcpu created */
> 		r = -EINVAL;
> 	} else {
> 		kvm->dirty_ring_size = size;
> 		r = 0;
> 	}
> 
> Then if we have KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP checking
> dirty_ring_size first then we make sure we need to configure both
> ALLOW_BITMAP and DIRTY_RING before any vcpu creation.

Ah, right. Sorry, I had the 'if' condition inverted in my head.

> > 
> > > Then if the userspace wants to use the bitmap altogether with the ring, it
> > > needs to first detect KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP and enable it
> > > before it enables KVM_CAP_DIRTY_LOG_RING.
> > > 
> > > One trick on ALLOW_BITMAP is in mark_page_dirty_in_slot() - after we allow
> > > !vcpu case we'll need to make sure it won't accidentally try to set bitmap
> > > for !ALLOW_BITMAP, because in that case the bitmap pointer is NULL so
> > > set_bit_le() will directly crash the kernel.
> > > 
> > > We could keep the old flavor of having a WARN_ON_ONCE(!vcpu &&
> > > !ALLOW_BITMAP) then return, but since now the userspace can easily trigger
> > > this (e.g. on ARM, a malicious userapp can have DIRTY_RING &&
> > > !ALLOW_BITMAP, then it can simply trigger the gic ioctl to trigger host
> > > warning), I think the better approach is we can kill the process in that
> > > case.  Not sure whether there's anything better we can do.
> > 
> > I don't believe !ALLOW_BITMAP && DIRTY_RING is a valid configuration for
> > arm64 given the fact that we'll dirty memory outside of a vCPU context.
> 
> Yes it's not, but after Gavin's current series it'll be possible, IOW a
> malicious app can leverage this to trigger host warning, which is IMHO not
> wanted.
> 
> > 
> > Could ALLOW_BITMAP be a requirement of DIRTY_RING, thereby making
> > userspace fail fast? Otherwise (at least on arm64) your VM is DOA on the
> > target. With that the old WARN() could be preserved, as you suggest.
> 
> It's just that x86 doesn't need the bitmap, so it'll be a pure waste there
> otherwise.  It's not only about the memory that will be wasted (that's
> guest mem size / 32k), but also the sync() process for x86 will be all
> zeros and totally meaningless - note that the sync() of bitmap will be part
> of VM downtime in this case (we need to sync() after turning VM off), so it
> will make x86 downtime larger but without any benefit.

Ah, my follow-up [1] missed by just a few minutes :)

I think this further drives the point home -- there's zero need for the
bitmap with dirty ring on x86, so why even support it? The proposal of
ALLOW_BITMAP && DIRTY_RING should be arm64-specific. Any other arch that
needs to dirty memory outside of a vCPU context can opt-in to the
behavior.

[1]: https://lore.kernel.org/kvm/Y0SuJee3oWL2QCqM@google.com/

--
Thanks,
Oliver
