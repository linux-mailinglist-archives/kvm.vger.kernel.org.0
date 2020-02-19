Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 357D2163D54
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 07:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgBSG6s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 19 Feb 2020 01:58:48 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2583 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726163AbgBSG6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 01:58:48 -0500
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 70648AF3B0A2123914F7;
        Wed, 19 Feb 2020 14:58:44 +0800 (CST)
Received: from DGGEMM528-MBX.china.huawei.com ([169.254.8.16]) by
 DGGEMM403-HUB.china.huawei.com ([10.3.20.211]) with mapi id 14.03.0439.000;
 Wed, 19 Feb 2020 14:58:34 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: RE: [PATCH] KVM: x86: enable dirty log gradually in small chunks
Thread-Topic: [PATCH] KVM: x86: enable dirty log gradually in small chunks
Thread-Index: AQHV5kqezhdNltl9dkyyI6w50CaTlKgg8IOAgAEdM1A=
Date:   Wed, 19 Feb 2020 06:58:33 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BAFEC8D@DGGEMM528-MBX.china.huawei.com>
References: <20200218110013.15640-1-jianjay.zhou@huawei.com>
 <20200218212303.GH28156@linux.intel.com>
In-Reply-To: <20200218212303.GH28156@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.228.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

> -----Original Message-----
> From: Sean Christopherson [mailto:sean.j.christopherson@intel.com]
> Sent: Wednesday, February 19, 2020 5:23 AM
> To: Zhoujian (jay) <jianjay.zhou@huawei.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; peterx@redhat.com;
> wangxin (U) <wangxinxin.wang@huawei.com>; linfeng (M)
> <linfeng23@huawei.com>; Huangweidong (C) <weidong.huang@huawei.com>
> Subject: Re: [PATCH] KVM: x86: enable dirty log gradually in small chunks
> 
> On Tue, Feb 18, 2020 at 07:00:13PM +0800, Jay Zhou wrote:
> > It could take kvm->mmu_lock for an extended period of time when
> > enabling dirty log for the first time. The main cost is to clear all
> > the D-bits of last level SPTEs. This situation can benefit from manual
> > dirty log protect as well, which can reduce the mmu_lock time taken.
> > The sequence is like this:
> >
> > 1. Set all the bits of the first dirty bitmap to 1 when enabling
> >    dirty log for the first time
> > 2. Only write protect the huge pages
> > 3. KVM_GET_DIRTY_LOG returns the dirty bitmap info 4.
> > KVM_CLEAR_DIRTY_LOG will clear D-bit for each of the leaf level
> >    SPTEs gradually in small chunks
> >
> > Under the Intel(R) Xeon(R) Gold 6152 CPU @ 2.10GHz environment, I did
> > some tests with a 128G windows VM and counted the time taken of
> > memory_global_dirty_log_start, here is the numbers:
> >
> > VM Size        Before    After optimization
> > 128G           460ms     10ms
> >
> > Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c   |  5 +++++
> >  include/linux/kvm_host.h |  5 +++++
> >  virt/kvm/kvm_main.c      | 10 ++++++++--
> >  3 files changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > 3be25ec..a8d64f6 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7201,7 +7201,12 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu,
> > int cpu)  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
> >  				     struct kvm_memory_slot *slot)  {
> > +#if CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > +	if (!kvm->manual_dirty_log_protect)
> > +		kvm_mmu_slot_leaf_clear_dirty(kvm, slot); #else
> >  	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> > +#endif
> 
> The ifdef is unnecessary, this is in VMX (x86) code, i.e.
> CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT is guaranteed to be
> defined.

I agree.

> 
> >  	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);  }
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h index
> > e89eb67..fd149b0 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -360,6 +360,11 @@ static inline unsigned long
> *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
> >  	return memslot->dirty_bitmap + len / sizeof(*memslot->dirty_bitmap);
> > }
> >
> > +static inline void kvm_set_first_dirty_bitmap(struct kvm_memory_slot
> > +*memslot) {
> > +	bitmap_set(memslot->dirty_bitmap, 0, memslot->npages); }
> 
> I'd prefer this be open coded with a comment, e.g. "first" is misleading because
> it's really "initial dirty bitmap for this memslot after enabling dirty logging".

kvm_create_dirty_bitmap allocates twice size as large as the actual dirty bitmap
size, and there is kvm_second_dirty_bitmap to get the second part of the map,
this is the reason why I use first_dirty_bitmap here, which means the first part
(not first time) of the dirty bitmap.

I'll try to be more clear if this is misleading...

> > +
> >  struct kvm_s390_adapter_int {
> >  	u64 ind_addr;
> >  	u64 summary_addr;
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> > 70f03ce..08565ed 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -862,7 +862,8 @@ static int kvm_vm_release(struct inode *inode,
> struct file *filp)
> >   * Allocation size is twice as large as the actual dirty bitmap size.
> >   * See x86's kvm_vm_ioctl_get_dirty_log() why this is needed.
> >   */
> > -static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
> > +static int kvm_create_dirty_bitmap(struct kvm *kvm,
> > +				struct kvm_memory_slot *memslot)
> >  {
> >  	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
> >
> > @@ -870,6 +871,11 @@ static int kvm_create_dirty_bitmap(struct
> kvm_memory_slot *memslot)
> >  	if (!memslot->dirty_bitmap)
> >  		return -ENOMEM;
> >
> > +#if CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> 
> The ifdef is unnecessary, manual_dirty_log_protect always exists and is
> guaranteed to be false if
> CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=n.  This isn't exactly a
> hot path so saving the uop isn't worth the #ifdef.

After rereading the code, I think you're right.

> 
> > +	if (kvm->manual_dirty_log_protect)
> > +		kvm_set_first_dirty_bitmap(memslot);
> > +#endif
> > +
> >  	return 0;
> >  }
> >
> > @@ -1094,7 +1100,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >
> >  	/* Allocate page dirty bitmap if needed */
> >  	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
> > -		if (kvm_create_dirty_bitmap(&new) < 0)
> > +		if (kvm_create_dirty_bitmap(kvm, &new) < 0)
> 
> Rather than pass @kvm, what about doing bitmap_set() in
> __kvm_set_memory_region() and
> s/kvm_create_dirty_bitmap/kvm_alloc_dirty_bitmap to make it clear that the
> helper is only responsible for allocation?  And opportunistically drop the
> superfluous "< 0", e.g.
> 
> 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
> 		if (kvm_alloc_dirty_bitmap(&new))
> 			goto out_free;
> 
> 		/*
> 		 * WORDS!
> 		 */
> 		if (kvm->manual_dirty_log_protect)
> 			bitmap_set(memslot->dirty_bitmap, 0, memslot->npages);
> 	}

Seems to be more clear, thanks for the suggestion.

Regards,
Jay Zhou

> >  			goto out_free;
> >  	}
> >
> > --
> > 1.8.3.1
> >
> >
