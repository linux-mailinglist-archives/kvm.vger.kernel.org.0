Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9F411104D7
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 20:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfLCTNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 14:13:30 -0500
Received: from mga04.intel.com ([192.55.52.120]:21877 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfLCTN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 14:13:29 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2019 11:13:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,274,1571727600"; 
   d="scan'208";a="213538054"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 03 Dec 2019 11:13:28 -0800
Date:   Tue, 3 Dec 2019 11:13:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191203191328.GD19877@linux.intel.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129213505.18472-5-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 29, 2019 at 04:34:54PM -0500, Peter Xu wrote:
> +static void mark_page_dirty_in_ring(struct kvm *kvm,
> +				    struct kvm_vcpu *vcpu,
> +				    struct kvm_memory_slot *slot,
> +				    gfn_t gfn)
> +{
> +	u32 as_id = 0;

Redundant initialization of as_id.

> +	u64 offset;
> +	int ret;
> +	struct kvm_dirty_ring *ring;
> +	struct kvm_dirty_ring_indexes *indexes;
> +	bool is_vm_ring;
> +
> +	if (!kvm->dirty_ring_size)
> +		return;
> +
> +	offset = gfn - slot->base_gfn;
> +
> +	if (vcpu) {
> +		as_id = kvm_arch_vcpu_memslots_id(vcpu);
> +	} else {
> +		as_id = 0;

The setting of as_id is wrong, both with and without a vCPU.  as_id should
come from slot->as_id.  It may not be actually broken in the current code
base, but at best it's fragile, e.g. Ben's TDP MMU rewrite[*] adds a call
to mark_page_dirty_in_slot() with a potentially non-zero as_id.

[*] https://lkml.kernel.org/r/20190926231824.149014-25-bgardon@google.com

> +		vcpu = kvm_get_running_vcpu();
> +	}
> +
> +	if (vcpu) {
> +		ring = &vcpu->dirty_ring;
> +		indexes = &vcpu->run->vcpu_ring_indexes;
> +		is_vm_ring = false;
> +	} else {
> +		/*
> +		 * Put onto per vm ring because no vcpu context.  Kick
> +		 * vcpu0 if ring is full.
> +		 */
> +		vcpu = kvm->vcpus[0];

Is this a rare event?

> +		ring = &kvm->vm_dirty_ring;
> +		indexes = &kvm->vm_run->vm_ring_indexes;
> +		is_vm_ring = true;
> +	}
> +
> +	ret = kvm_dirty_ring_push(ring, indexes,
> +				  (as_id << 16)|slot->id, offset,
> +				  is_vm_ring);
> +	if (ret < 0) {
> +		if (is_vm_ring)
> +			pr_warn_once("vcpu %d dirty log overflow\n",
> +				     vcpu->vcpu_id);
> +		else
> +			pr_warn_once("per-vm dirty log overflow\n");
> +		return;
> +	}
> +
> +	if (ret)
> +		kvm_make_request(KVM_REQ_DIRTY_RING_FULL, vcpu);
> +}
