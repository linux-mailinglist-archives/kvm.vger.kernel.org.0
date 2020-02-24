Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A35A716ADB0
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 18:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgBXRiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 12:38:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:26531 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727108AbgBXRiy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 12:38:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 09:38:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,480,1574150400"; 
   d="scan'208";a="409945745"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 24 Feb 2020 09:38:53 -0800
Date:   Mon, 24 Feb 2020 09:38:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Jay Zhou <jianjay.zhou@huawei.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, wangxinxin.wang@huawei.com,
        weidong.huang@huawei.com, liu.jinsong@huawei.com
Subject: Re: [PATCH v3] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200224173853.GF29865@linux.intel.com>
References: <20200224032558.2728-1-jianjay.zhou@huawei.com>
 <20200224170538.GH37727@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224170538.GH37727@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 12:05:38PM -0500, Peter Xu wrote:
> On Mon, Feb 24, 2020 at 11:25:58AM +0800, Jay Zhou wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 3be25ec..0deb8c3 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7201,7 +7201,8 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
> >  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
> >  				     struct kvm_memory_slot *slot)
> >  {
> > -	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> > +	if (!kvm_manual_dirty_log_init_set(kvm))
> > +		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> >  	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
> >  }
> >  
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index fb5d64e..f816940 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9956,7 +9956,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
> >  {
> >  	/* Still write protect RO slot */
> >  	if (new->flags & KVM_MEM_READONLY) {
> > -		kvm_mmu_slot_remove_write_access(kvm, new);
> > +		kvm_mmu_slot_remove_write_access(kvm, new, PT_PAGE_TABLE_LEVEL);
> >  		return;
> >  	}
> >  
> > @@ -9993,8 +9993,20 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
> >  	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> >  		if (kvm_x86_ops->slot_enable_log_dirty)
> >  			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
> > -		else
> > -			kvm_mmu_slot_remove_write_access(kvm, new);
> > +		else {

Braces need to be added to the "if" part as well.

> > +			int level = kvm_manual_dirty_log_init_set(kvm) ?
> > +				PT_DIRECTORY_LEVEL : PT_PAGE_TABLE_LEVEL;
> > +
> > +			/*
> > +			 * If we're with initial-all-set, we don't need
> > +			 * to write protect any small page because
> > +			 * they're reported as dirty already.  However
> > +			 * we still need to write-protect huge pages
> > +			 * so that the page split can happen lazily on
> > +			 * the first write to the huge page.
> > +			 */
> > +			kvm_mmu_slot_remove_write_access(kvm, new, level);
> > +		}
> >  	} else {
> >  		if (kvm_x86_ops->slot_disable_log_dirty)
> >  			kvm_x86_ops->slot_disable_log_dirty(kvm, new);
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index e89eb67..80ada94 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -360,6 +360,13 @@ static inline unsigned long *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
> >  	return memslot->dirty_bitmap + len / sizeof(*memslot->dirty_bitmap);
> >  }
> >  
> > +#define KVM_DIRTY_LOG_MANUAL_PROTECT2 (1 << 0)
> > +#define KVM_DIRTY_LOG_INITIALLY_SET (1 << 1)
> > +#define KVM_DIRTY_LOG_MANUAL_CAPS (KVM_DIRTY_LOG_MANUAL_PROTECT2 | \
> > +				KVM_DIRTY_LOG_INITIALLY_SET)
> > +
> > +bool kvm_manual_dirty_log_init_set(struct kvm *kvm);

For me, INITIALLY_SET is awkward and confusing, e.g. IMO it's not at all
obvious that kvm_manual_dirty_log_init_set() is a simple accessor.

Would something like KVM_DIRTY_LOG_START_DIRTY still be accurate?

> > +
> >  struct kvm_s390_adapter_int {
> >  	u64 ind_addr;
> >  	u64 summary_addr;
> > @@ -493,7 +500,7 @@ struct kvm {
> >  #endif
> >  	long tlbs_dirty;
> >  	struct list_head devices;
> > -	bool manual_dirty_log_protect;
> > +	u64 manual_dirty_log_protect;
> >  	struct dentry *debugfs_dentry;
> >  	struct kvm_stat_data **debugfs_stat_data;
> >  	struct srcu_struct srcu;
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 70f03ce..0ffb804 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -858,11 +858,17 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
> >  	return 0;
> >  }
> >  
> > +bool kvm_manual_dirty_log_init_set(struct kvm *kvm)
> > +{
> > +	return kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET;
> > +}
> 
> Nit: this can be put into kvm_host.h as inlined.
