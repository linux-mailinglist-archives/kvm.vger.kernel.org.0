Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F64732987
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 10:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243808AbjFPIJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 04:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242492AbjFPIJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 04:09:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E9D2684;
        Fri, 16 Jun 2023 01:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686902961; x=1718438961;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FIZHMugeg2xPHdpjXSgKrP/iomfabUS8UnyZHeA6vAc=;
  b=ZdwSuFmLTFV5cEUXGj6RLwqtoAwmCmcDc/ejbM8Bq5PiVtwO/2A3EdHt
   nXAihHm3hAql2RoUecuA0U+hU36efKFLSGHga5C4PxOnI+mxRKuu0zoFD
   O6Zd4Qdl6+g+YwcqyO0AWLjAAn09Yh8t0NFn0r34Zx9cH6sIV3K8UQZHu
   CikIXTup6w4e8jaWiBUg96RNInyNOkA5JGWRTR6c2ONJSK1U9Kov1WGex
   aGHoUDGqa8shveQJH7jScqKg3kqUl0HcSaizBXSGc87JrD0k8PO6FcF+/
   9Bn1LyTUTkK7c1rWDP7DtrrrnFB2QieyAEX8YHu4XNnuFuAYY1xEa+yfI
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="361682426"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="361682426"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 01:09:21 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="746106659"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="746106659"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga001.jf.intel.com with ESMTP; 16 Jun 2023 01:09:18 -0700
Date:   Fri, 16 Jun 2023 16:09:17 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com
Subject: Re: [PATCH v3 09/11] KVM: x86/mmu: serialize vCPUs to zap gfn when
 guest MTRRs are honored
Message-ID: <20230616080917.fhekzs2fyhqtbitx@yy-desk-7060>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
 <20230616023945.7570-1-yan.y.zhao@intel.com>
 <20230616074550.g2ikzbni2rjy7dfw@yy-desk-7060>
 <ZIwROWti5d0sCFwT@yzhao56-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIwROWti5d0sCFwT@yzhao56-desk.sh.intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 03:37:29PM +0800, Yan Zhao wrote:
> On Fri, Jun 16, 2023 at 03:45:50PM +0800, Yuan Yao wrote:
> > > +/*
> > > + * Add @range into kvm->arch.mtrr_zap_list and sort the list in
> > > + * "length" ascending + "start" descending order, so that
> > > + * ranges consuming more zap cycles can be dequeued later and their
> > > + * chances of being found duplicated are increased.
> > > + */
> > > +static void kvm_add_mtrr_zap_list(struct kvm *kvm, struct mtrr_zap_range *range)
> > > +{
> > > +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> > > +	u64 len = range->end - range->start;
> > > +	struct mtrr_zap_range *cur, *n;
> > > +	bool added = false;
> > > +
> > > +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> > > +
> > > +	if (list_empty(head)) {
> > > +		list_add(&range->node, head);
> > > +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > > +		return;
> > > +	}
> > > +
> > > +	list_for_each_entry_safe(cur, n, head, node) {
> > > +		u64 cur_len = cur->end - cur->start;
> > > +
> > > +		if (len < cur_len)
> > > +			break;
> > > +
> > > +		if (len > cur_len)
> > > +			continue;
> > > +
> > > +		if (range->start > cur->start)
> > > +			break;
> > > +
> > > +		if (range->start < cur->start)
> > > +			continue;
> > > +
> > > +		/* equal len & start, no need to add */
> > > +		added = true;
> >
> > Possible/worth to ignore the range already covered
> > by queued range ?
>
> I may not get you correctly, but
> the "added" here means an queued range with exactly same start + len
> found, so free and drop adding the new range here.

I mean drop adding three B below if A already in the queue:

|------A--------|
|----B----|

|------A--------|
      |----B----|

|------A--------|
  |----B----|

>
> >
> > > +		kfree(range);
> > > +		break;
> > > +	}
> > > +
> > > +	if (!added)
> > > +		list_add_tail(&range->node, &cur->node);
> > > +
> > > +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > > +}
> > > +
> > > +static void kvm_zap_mtrr_zap_list(struct kvm *kvm)
> > > +{
> > > +	struct list_head *head = &kvm->arch.mtrr_zap_list;
> > > +	struct mtrr_zap_range *cur = NULL;
> > > +
> > > +	spin_lock(&kvm->arch.mtrr_zap_list_lock);
> > > +
> > > +	while (!list_empty(head)) {
> > > +		u64 start, end;
> > > +
> > > +		cur = list_first_entry(head, typeof(*cur), node);
> > > +		start = cur->start;
> > > +		end = cur->end;
> > > +		list_del(&cur->node);
> > > +		kfree(cur);
> > > +		spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > > +
> > > +		kvm_zap_gfn_range(kvm, start, end);
> > > +
> > > +		spin_lock(&kvm->arch.mtrr_zap_list_lock);
> > > +	}
> > > +
> > > +	spin_unlock(&kvm->arch.mtrr_zap_list_lock);
> > > +}
> > > +
> > > +static void kvm_zap_or_wait_mtrr_zap_list(struct kvm *kvm)
> > > +{
> > > +	if (atomic_cmpxchg_acquire(&kvm->arch.mtrr_zapping, 0, 1) == 0) {
> > > +		kvm_zap_mtrr_zap_list(kvm);
> > > +		atomic_set_release(&kvm->arch.mtrr_zapping, 0);
> > > +		return;
> > > +	}
> > > +
> > > +	while (atomic_read(&kvm->arch.mtrr_zapping))
> > > +		cpu_relax();
> > > +}
> > > +
> > > +static void kvm_mtrr_zap_gfn_range(struct kvm_vcpu *vcpu,
> > > +				   gfn_t gfn_start, gfn_t gfn_end)
> > > +{
> > > +	struct mtrr_zap_range *range;
> > > +
> > > +	range = kmalloc(sizeof(*range), GFP_KERNEL_ACCOUNT);
> > > +	if (!range)
> > > +		goto fail;
> > > +
> > > +	range->start = gfn_start;
> > > +	range->end = gfn_end;
> > > +
> > > +	kvm_add_mtrr_zap_list(vcpu->kvm, range);
> > > +
> > > +	kvm_zap_or_wait_mtrr_zap_list(vcpu->kvm);
> > > +	return;
> > > +
> > > +fail:
> > > +	kvm_clear_mtrr_zap_list(vcpu->kvm);
> > A very small chance race condition that incorrectly
> > clear the queued ranges which have not been zapped by another thread ?
> > Like below:
> >
> > Thread A                         |  Thread B
> > kvm_add_mtrr_zap_list()          |
> >                                  |  kvm_clear_mtrr_zap_list()
> > kvm_zap_or_wait_mtrr_zap_list()  |
> >
> > Call kvm_clear_mtrr_zap_list() here looks unnecessary, other
> > threads(B here) who put thing in the queue will take care them well.
>
> > > +   kvm_zap_gfn_range(vcpu->kvm, gfn_start, gfn_end);
>
> Yes, if gfn_start and gfn_end here are not 0 and ~0ULL, the
> kvm_clear_mtrr_zap_list() is not necessary.
> Though in reality, they are always 0-~0ULL, I agree dropping the
> kvm_clear_mtrr_zap_list() here is better.
>
> Thanks!
