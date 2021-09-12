Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A361A407CF0
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 12:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhILKuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 06:50:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229639AbhILKus (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 06:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631443774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VlVv06mE5W7NWyznLz/NOTF3NqAx+EBDkVQ/LY3IlHQ=;
        b=G/ISI2L2kRAIRFRlmZdieny3NXvUKYWJUuxQ+KyhPy5iDRl+a9bG8/nzF2HMuVM4CNPVhR
        mMhMbX4PoUECkeoIB3WBhF8VcYVrrXXVo8IS8s2KZzinDp7iBB90SKml8CtaUmCVcAAzeg
        XiV2fvWMJ2uNUrHhaAdmMmJ2m+YHe/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-n7dthmQUNj-IEtHfzXg7Pg-1; Sun, 12 Sep 2021 06:49:33 -0400
X-MC-Unique: n7dthmQUNj-IEtHfzXg7Pg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E73AC1006AA0;
        Sun, 12 Sep 2021 10:49:31 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B5F65C25A;
        Sun, 12 Sep 2021 10:49:29 +0000 (UTC)
Message-ID: <30f1a856342bc0a45f92558923f9dc22ba453a8b.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: x86: Query vcpu->vcpu_idx directly and drop
 its accessor
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 12 Sep 2021 13:49:28 +0300
In-Reply-To: <20210910183220.2397812-2-seanjc@google.com>
References: <20210910183220.2397812-1-seanjc@google.com>
         <20210910183220.2397812-2-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-10 at 11:32 -0700, Sean Christopherson wrote:
> Read vcpu->vcpu_idx directly instead of bouncing through the one-line
> wrapper, kvm_vcpu_get_idx(), and drop the wrapper.  The wrapper is a
> remnant of the original implementation and serves no purpose; remove it
> before it gains more users.
> 
> Back when kvm_vcpu_get_idx() was added by commit 497d72d80a78 ("KVM: Add
> kvm_vcpu_get_idx to get vcpu index in kvm->vcpus"), the implementation
> was more than just a simple wrapper as vcpu->vcpu_idx did not exist and
> retrieving the index meant walking over the vCPU array to find the given
> vCPU.
> 
> When vcpu_idx was introduced by commit 8750e72a79dd ("KVM: remember
> position in kvm->vcpus array"), the helper was left behind, likely to
> avoid extra thrash (but even then there were only two users, the original
> arm usage having been removed at some point in the past).
> 
> No functional change intended.
> 
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/hyperv.c    | 7 +++----
>  arch/x86/kvm/hyperv.h    | 2 +-
>  include/linux/kvm_host.h | 5 -----
>  3 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index fe4a02715266..04dbc001f4fc 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -939,7 +939,7 @@ static int kvm_hv_vcpu_init(struct kvm_vcpu *vcpu)
>  	for (i = 0; i < ARRAY_SIZE(hv_vcpu->stimer); i++)
>  		stimer_init(&hv_vcpu->stimer[i], i);
>  
> -	hv_vcpu->vp_index = kvm_vcpu_get_idx(vcpu);
> +	hv_vcpu->vp_index = vcpu->vcpu_idx;
>  
>  	return 0;
>  }
> @@ -1444,7 +1444,6 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
>  	switch (msr) {
>  	case HV_X64_MSR_VP_INDEX: {
>  		struct kvm_hv *hv = to_kvm_hv(vcpu->kvm);
> -		int vcpu_idx = kvm_vcpu_get_idx(vcpu);
>  		u32 new_vp_index = (u32)data;
>  
>  		if (!host || new_vp_index >= KVM_MAX_VCPUS)
> @@ -1459,9 +1458,9 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
>  		 * VP index is changing, adjust num_mismatched_vp_indexes if
>  		 * it now matches or no longer matches vcpu_idx.
>  		 */
> -		if (hv_vcpu->vp_index == vcpu_idx)
> +		if (hv_vcpu->vp_index == vcpu->vcpu_idx)
>  			atomic_inc(&hv->num_mismatched_vp_indexes);
> -		else if (new_vp_index == vcpu_idx)
> +		else if (new_vp_index == vcpu->vcpu_idx)
>  			atomic_dec(&hv->num_mismatched_vp_indexes);
>  
>  		hv_vcpu->vp_index = new_vp_index;
> diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> index 730da8537d05..ed1c4e546d04 100644
> --- a/arch/x86/kvm/hyperv.h
> +++ b/arch/x86/kvm/hyperv.h
> @@ -83,7 +83,7 @@ static inline u32 kvm_hv_get_vpindex(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
>  
> -	return hv_vcpu ? hv_vcpu->vp_index : kvm_vcpu_get_idx(vcpu);
> +	return hv_vcpu ? hv_vcpu->vp_index : vcpu->vcpu_idx;
>  }
>  
>  int kvm_hv_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host);
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e4d712e9f760..31071ad821e2 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -721,11 +721,6 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
>  	return NULL;
>  }
>  
> -static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
> -{
> -	return vcpu->vcpu_idx;
> -}
> -
>  #define kvm_for_each_memslot(memslot, slots)				\
>  	for (memslot = &slots->memslots[0];				\
>  	     memslot < slots->memslots + slots->used_slots; memslot++)	\

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

