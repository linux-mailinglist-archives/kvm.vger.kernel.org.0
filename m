Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B653A27ED71
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 17:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbgI3Pih (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 11:38:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:23518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgI3Pid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 11:38:33 -0400
IronPort-SDR: Rxx2rytSC/4QPVc8Iyb29J00cBh+Xc2UigoX0ZRCbtSjIWnN8KltExgzUup6xSVgZ3noUFLInx
 nnKZir5LJjpg==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="141883719"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="141883719"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 08:38:33 -0700
IronPort-SDR: 3g1ArE64tf93Mj0CVDgjreXVKrPAFugAVt4cjflUfy7T0NmU/tLG2FIYNI7GqHfZhrov/M7hqd
 OH01N6fhRmKw==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="350706648"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 08:38:32 -0700
Date:   Wed, 30 Sep 2020 08:38:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH 04/22] kvm: mmu: Allocate and free TDP MMU roots
Message-ID: <20200930153824.GA32672@linux.intel.com>
References: <20200925212302.3979661-1-bgardon@google.com>
 <20200925212302.3979661-5-bgardon@google.com>
 <20200930060610.GA29659@linux.intel.com>
 <6a5b78f8-0fbe-fbec-8313-f7759e2483b0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a5b78f8-0fbe-fbec-8313-f7759e2483b0@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30, 2020 at 08:26:28AM +0200, Paolo Bonzini wrote:
> On 30/09/20 08:06, Sean Christopherson wrote:
> >> +static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct kvm_mmu_page *root;
> >> +	union kvm_mmu_page_role role;
> >> +
> >> +	role = vcpu->arch.mmu->mmu_role.base;
> >> +	role.level = vcpu->arch.mmu->shadow_root_level;
> >> +	role.direct = true;
> >> +	role.gpte_is_8_bytes = true;
> >> +	role.access = ACC_ALL;
> >> +
> >> +	spin_lock(&vcpu->kvm->mmu_lock);
> >> +
> >> +	/* Search for an already allocated root with the same role. */
> >> +	root = find_tdp_mmu_root_with_role(vcpu->kvm, role);
> >> +	if (root) {
> >> +		get_tdp_mmu_root(vcpu->kvm, root);
> >> +		spin_unlock(&vcpu->kvm->mmu_lock);
> > Rather than manually unlock and return, this can be
> > 
> > 	if (root)
> > 		get_tdp_mmju_root();
> > 
> > 	spin_unlock()
> > 
> > 	if (!root)
> > 		root = alloc_tdp_mmu_root();
> > 
> > 	return root;
> > 
> > You could also add a helper to do the "get" along with the "find".  Not sure
> > if that's worth the code.
> 
> All in all I don't think it's any clearer than Ben's code.  At least in
> his case the "if"s clearly point at the double-checked locking pattern.

Actually, why is this even dropping the lock to do the alloc?  The allocs are
coming from the caches, which are designed to be invoked while holding the
spin lock.

Also relevant is that, other than this code, the only user of
find_tdp_mmu_root_with_role() is kvm_tdp_mmu_root_hpa_for_role(), and that
helper is itself unused.  I.e. the "find" can be open coded.

Putting those two together yields this, which IMO is much cleaner.

static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
{
        union kvm_mmu_page_role role;
	struct kvm *kvm = vcpu->kvm;
        struct kvm_mmu_page *root;

	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);

        spin_lock(&kvm->mmu_lock);

        /* Check for an existing root before allocating a new one. */
        for_each_tdp_mmu_root(kvm, root) {
                if (root->role.word == role.word) {
                        get_tdp_mmu_root(root);
                        spin_unlock(&kvm->mmu_lock);
                        return root;
                }
        }

        root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
        root->root_count = 1;

        list_add(&root->link, &kvm->arch.tdp_mmu_roots);

        spin_unlock(&kvm->mmu_lock);

        return root;
}

