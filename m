Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8400D16B85B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 05:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgBYEB4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 24 Feb 2020 23:01:56 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2973 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727402AbgBYEB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 23:01:56 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 3791069C079F54552B1A;
        Tue, 25 Feb 2020 12:01:53 +0800 (CST)
Received: from DGGEMM422-HUB.china.huawei.com (10.1.198.39) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 25 Feb 2020 12:01:51 +0800
Received: from DGGEMM508-MBX.china.huawei.com ([169.254.2.45]) by
 dggemm422-hub.china.huawei.com ([10.1.198.39]) with mapi id 14.03.0439.000;
 Tue, 25 Feb 2020 12:01:44 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: RE: [PATCH v3] KVM: x86: enable dirty log gradually in small chunks
Thread-Topic: [PATCH v3] KVM: x86: enable dirty log gradually in small chunks
Thread-Index: AQHV6sIxsDFZr7X1XEqnl6bLywYnuagqDaUAgAAJSoCAASdD0A==
Date:   Tue, 25 Feb 2020 04:01:43 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BB1D7F1@dggemm508-mbx.china.huawei.com>
References: <20200224032558.2728-1-jianjay.zhou@huawei.com>
 <20200224170538.GH37727@xz-x1> <20200224173853.GF29865@linux.intel.com>
In-Reply-To: <20200224173853.GF29865@linux.intel.com>
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



> -----Original Message-----
> From: Sean Christopherson [mailto:sean.j.christopherson@intel.com]
> Sent: Tuesday, February 25, 2020 1:39 AM
> To: Peter Xu <peterx@redhat.com>
> Cc: Zhoujian (jay) <jianjay.zhou@huawei.com>; kvm@vger.kernel.org;
> pbonzini@redhat.com; wangxin (U) <wangxinxin.wang@huawei.com>;
> Huangweidong (C) <weidong.huang@huawei.com>; Liujinsong (Paul)
> <liu.jinsong@huawei.com>
> Subject: Re: [PATCH v3] KVM: x86: enable dirty log gradually in small chunks
> 
> On Mon, Feb 24, 2020 at 12:05:38PM -0500, Peter Xu wrote:
> > On Mon, Feb 24, 2020 at 11:25:58AM +0800, Jay Zhou wrote:
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > > 3be25ec..0deb8c3 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -7201,7 +7201,8 @@ static void vmx_sched_in(struct kvm_vcpu
> > > *vcpu, int cpu)  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
> > >  				     struct kvm_memory_slot *slot)  {
> > > -	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> > > +	if (!kvm_manual_dirty_log_init_set(kvm))
> > > +		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> > >  	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);  }
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> > > fb5d64e..f816940 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -9956,7 +9956,7 @@ static void kvm_mmu_slot_apply_flags(struct
> > > kvm *kvm,  {
> > >  	/* Still write protect RO slot */
> > >  	if (new->flags & KVM_MEM_READONLY) {
> > > -		kvm_mmu_slot_remove_write_access(kvm, new);
> > > +		kvm_mmu_slot_remove_write_access(kvm, new,
> PT_PAGE_TABLE_LEVEL);
> > >  		return;
> > >  	}
> > >
> > > @@ -9993,8 +9993,20 @@ static void kvm_mmu_slot_apply_flags(struct
> kvm *kvm,
> > >  	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> > >  		if (kvm_x86_ops->slot_enable_log_dirty)
> > >  			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
> > > -		else
> > > -			kvm_mmu_slot_remove_write_access(kvm, new);
> > > +		else {
> 
> Braces need to be added to the "if" part as well.

I think this is acceptable as default since I used the ./scripts/checkpatch.pl to
check the patch and there's no error and warning.
But I'll add it if it would be more clear and enhance readability.

> 
> > > +			int level = kvm_manual_dirty_log_init_set(kvm) ?
> > > +				PT_DIRECTORY_LEVEL : PT_PAGE_TABLE_LEVEL;
> > > +
> > > +			/*
> > > +			 * If we're with initial-all-set, we don't need
> > > +			 * to write protect any small page because
> > > +			 * they're reported as dirty already.  However
> > > +			 * we still need to write-protect huge pages
> > > +			 * so that the page split can happen lazily on
> > > +			 * the first write to the huge page.
> > > +			 */
> > > +			kvm_mmu_slot_remove_write_access(kvm, new, level);
> > > +		}
> > >  	} else {
> > >  		if (kvm_x86_ops->slot_disable_log_dirty)
> > >  			kvm_x86_ops->slot_disable_log_dirty(kvm, new); diff --git
> > > a/include/linux/kvm_host.h b/include/linux/kvm_host.h index
> > > e89eb67..80ada94 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -360,6 +360,13 @@ static inline unsigned long
> *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
> > >  	return memslot->dirty_bitmap + len /
> > > sizeof(*memslot->dirty_bitmap);  }
> > >
> > > +#define KVM_DIRTY_LOG_MANUAL_PROTECT2 (1 << 0) #define
> > > +KVM_DIRTY_LOG_INITIALLY_SET (1 << 1) #define
> > > +KVM_DIRTY_LOG_MANUAL_CAPS (KVM_DIRTY_LOG_MANUAL_PROTECT2
> | \
> > > +				KVM_DIRTY_LOG_INITIALLY_SET)
> > > +
> > > +bool kvm_manual_dirty_log_init_set(struct kvm *kvm);
> 
> For me, INITIALLY_SET is awkward and confusing, e.g. IMO it's not at all obvious
> that kvm_manual_dirty_log_init_set() is a simple accessor.
> 
> Would something like KVM_DIRTY_LOG_START_DIRTY still be accurate?

It depends on which aspect you care about.
I think it is still accurate for the overall (kernel + userspace).

With initial-all-set, the dirty pages reported by kernel side to userspace
will increase, but it would not affect the calculation of real new dirtied pages,
since these pages haven't sent, they will be merged with the migration bitmap
in userspace(so they're not the new dirtied pages from the userspace side
at last, this is the same as without initial-all-set).

It is not needed to start dirty log at once when setting with
KVM_MEM_LOG_DIRTY_PAGES, it needs only just before userspace will use
it. As described in "7.18 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2" of
Documentation/virt/kvm/api.rst:

"                                    ..... Second, in some cases a
large amount of time can pass between a call to KVM_GET_DIRTY_LOG and
userspace actually using the data in the page.  Pages can be modified
during this time, which is inefficient for both the guest and userspace:
the guest will incur a higher penalty due to write protection faults,
while userspace can see false reports of dirty pages.  Manual reprotection
helps reducing this time, improving guest performance and reducing the
number of dirty log false positives. "


Regards,
Jay Zhou

> 
> > > +
> > >  struct kvm_s390_adapter_int {
> > >  	u64 ind_addr;
> > >  	u64 summary_addr;
> > > @@ -493,7 +500,7 @@ struct kvm {
> > >  #endif
> > >  	long tlbs_dirty;
> > >  	struct list_head devices;
> > > -	bool manual_dirty_log_protect;
> > > +	u64 manual_dirty_log_protect;
> > >  	struct dentry *debugfs_dentry;
> > >  	struct kvm_stat_data **debugfs_stat_data;
> > >  	struct srcu_struct srcu;
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> > > 70f03ce..0ffb804 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -858,11 +858,17 @@ static int kvm_vm_release(struct inode *inode,
> struct file *filp)
> > >  	return 0;
> > >  }
> > >
> > > +bool kvm_manual_dirty_log_init_set(struct kvm *kvm) {
> > > +	return kvm->manual_dirty_log_protect &
> > > +KVM_DIRTY_LOG_INITIALLY_SET; }
> >
> > Nit: this can be put into kvm_host.h as inlined.
