Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FB6F18F9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 15:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbfKFOn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 09:43:28 -0500
Received: from mga12.intel.com ([192.55.52.136]:43011 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbfKFOn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 09:43:27 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 06:43:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="196227759"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 06 Nov 2019 06:43:26 -0800
Date:   Wed, 6 Nov 2019 06:43:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com, rkrcmar@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: Re: [Patch v1 1/2] KVM: remember position in kvm->vcpus array
Message-ID: <20191106144326.GA16249@linux.intel.com>
References: <1573047398-7665-1-git-send-email-nitesh@redhat.com>
 <1573047398-7665-2-git-send-email-nitesh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1573047398-7665-2-git-send-email-nitesh@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 08:36:37AM -0500, Nitesh Narayan Lal wrote:
> From: Radim Krčmář <rkrcmar@redhat.com>
> 
> Fetching an index for any vcpu in kvm->vcpus array by traversing
> the entire array everytime is costly.
> This patch remembers the position of each vcpu in kvm->vcpus array
> by storing it in vcpus_idx under kvm_vcpu structure.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  include/linux/kvm_host.h | 11 +++--------
>  virt/kvm/kvm_main.c      |  5 ++++-
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 719fc3e..31c4fde 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -266,7 +266,8 @@ struct kvm_vcpu {
>  	struct preempt_notifier preempt_notifier;
>  #endif
>  	int cpu;
> -	int vcpu_id;
> +	int vcpu_id; /* id given by userspace at creation */
> +	int vcpus_idx; /* index in kvm->vcpus array */

I'd probably prefer vcpu_idx or vcpu_index, but it's not a strong
preference by any means.

>  	int srcu_idx;
>  	int mode;
>  	u64 requests;
> @@ -571,13 +572,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
>  
>  static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_vcpu *tmp;
> -	int idx;
> -
> -	kvm_for_each_vcpu(idx, tmp, vcpu->kvm)
> -		if (tmp == vcpu)
> -			return idx;
> -	BUG();
> +	return vcpu->vcpus_idx;
>  }
>  
>  #define kvm_for_each_memslot(memslot, slots)	\
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67ef3f2..24ab711 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2673,7 +2673,10 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>  		goto unlock_vcpu_destroy;
>  	}
>  
> -	BUG_ON(kvm->vcpus[atomic_read(&kvm->online_vcpus)]);
> +	vcpu->vcpus_idx = atomic_read(&kvm->online_vcpus);
> +

Nit: I'd omit this newline since the assignment and BUG_ON() are directly
related.

> +	BUG_ON(kvm->vcpus[vcpu->vcpus_idx]);

The assignment to kvm->vcpus a few lines below should be updated to use
the new index.

> +
>  
>  	/* Now it's all set up, let userspace reach it */
>  	kvm_get_kvm(kvm);
> -- 
> 1.8.3.1
> 
