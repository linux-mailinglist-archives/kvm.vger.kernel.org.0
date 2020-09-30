Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66DE27DFBB
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 06:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgI3EzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 00:55:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:31011 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725320AbgI3EzM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 00:55:12 -0400
IronPort-SDR: jOYmpoi3BxEnB105Yduqe/PoXneGFYipkazUrRxfLYfA828YGB9WHaFLgV3I5xxej1SHSigmA6
 p8dNLqilqEbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="141767286"
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="141767286"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:55:10 -0700
IronPort-SDR: IAJJo5M+pPLzNlpO4DFYzHrLsiEpU4dcZqKJL8hCYBH0T0Mf4g0OeAIh5qLzDP4VHokRLCVdhq
 LEuDcfo2JQJQ==
X-IronPort-AV: E=Sophos;i="5.77,321,1596524400"; 
   d="scan'208";a="495478578"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 21:55:09 -0700
Date:   Tue, 29 Sep 2020 21:55:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 01/22] kvm: mmu: Separate making SPTEs from set_spte
Message-ID: <20200930045508.GA29405@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-2-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925212302.3979661-2-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 25, 2020 at 02:22:41PM -0700, Ben Gardon wrote:
> +static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
> +		    unsigned int pte_access, int level,
> +		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
> +		    bool can_unsync, bool host_writable)
> +{
> +	u64 spte = 0;
> +	struct kvm_mmu_page *sp;
> +	int ret = 0;
> +
> +	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
> +		return 0;
> +
> +	sp = sptep_to_sp(sptep);
> +
> +	spte = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
> +			 can_unsync, host_writable, sp_ad_disabled(sp), &ret);
> +	if (!spte)
> +		return 0;

This is an impossible condition.  Well, maybe it's theoretically possible
if page track is active, with EPT exec-only support (shadow_present_mask is
zero), and pfn==0.  But in that case, returning early is wrong.

Rather than return the spte, what about returning 'ret', passing 'new_spte'
as a u64 *, and dropping the bail early path?  That would also eliminate
the minor wart of make_spte() relying on the caller to initialize 'ret'.

> +
> +	if (spte & PT_WRITABLE_MASK)
> +		kvm_vcpu_mark_page_dirty(vcpu, gfn);
> +
>  	if (mmu_spte_update(sptep, spte))
>  		ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
>  	return ret;
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 
