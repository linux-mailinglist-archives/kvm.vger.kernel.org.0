Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C10316273F
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 14:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgBRNkE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 18 Feb 2020 08:40:04 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:2582 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726567AbgBRNkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 08:40:04 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id B1470B7E6F5B4204B9EF;
        Tue, 18 Feb 2020 21:39:43 +0800 (CST)
Received: from DGGEMM422-HUB.china.huawei.com (10.1.198.39) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 18 Feb 2020 21:39:42 +0800
Received: from DGGEMM528-MBX.china.huawei.com ([169.254.8.16]) by
 dggemm422-hub.china.huawei.com ([10.1.198.39]) with mapi id 14.03.0439.000;
 Tue, 18 Feb 2020 21:39:36 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "peterx@redhat.com" <peterx@redhat.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: RE: [PATCH] KVM: x86: enable dirty log gradually in small chunks
Thread-Topic: [PATCH] KVM: x86: enable dirty log gradually in small chunks
Thread-Index: AQHV5kqezhdNltl9dkyyI6w50CaTlKggTY0AgACgi6A=
Date:   Tue, 18 Feb 2020 13:39:36 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BAF9BDD@DGGEMM528-MBX.china.huawei.com>
References: <20200218110013.15640-1-jianjay.zhou@huawei.com>
 <24b21aee-e038-bc55-a85e-0f64912e7b89@redhat.com>
In-Reply-To: <24b21aee-e038-bc55-a85e-0f64912e7b89@redhat.com>
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

Hi Paolo,

> -----Original Message-----
> From: Paolo Bonzini [mailto:pbonzini@redhat.com]
> Sent: Tuesday, February 18, 2020 7:40 PM
> To: Zhoujian (jay) <jianjay.zhou@huawei.com>; kvm@vger.kernel.org
> Cc: peterx@redhat.com; wangxin (U) <wangxinxin.wang@huawei.com>;
> linfeng (M) <linfeng23@huawei.com>; Huangweidong (C)
> <weidong.huang@huawei.com>
> Subject: Re: [PATCH] KVM: x86: enable dirty log gradually in small chunks
> 
> On 18/02/20 12:00, Jay Zhou wrote:
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
> 
> This is a good idea, but could userspace expect the bitmap to be 0 for pages
> that haven't been touched? 

The userspace gets the bitmap information only from the kernel side.
It depends on the kernel side to distinguish whether the pages have been touched
I think, which using the rmap to traverse for now. I haven't the other ideas yet, :-(

But even though the userspace gets 1 for pages that haven't been touched, these
pages will be filtered out too in the kernel space KVM_CLEAR_DIRTY_LOG ioctl
path, since the rmap does not exist I think.

> I think this should be added as a new bit to the
> KVM_ENABLE_CAP for KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2.  That is:
> 
> - in kvm_vm_ioctl_check_extension_generic, return 3 for
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 (better: define two constants
> KVM_DIRTY_LOG_MANUAL_PROTECT as 1 and
> KVM_DIRTY_LOG_INITIALLY_SET as 2).
> 
> - in kvm_vm_ioctl_enable_cap_generic, allow bit 0 and bit 1 for cap->args[0]
> 
> - in kvm_vm_ioctl_enable_cap_generic, check "if
> (!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET))".

Thanks for the details! I'll add them in the next version.

Regards,
Jay Zhou

> 
> Thanks,
> 
> Paolo
> 
> 
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
> >  			goto out_free;
> >  	}
> >
> >

