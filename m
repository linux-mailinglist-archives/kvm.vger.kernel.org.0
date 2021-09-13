Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A478A408512
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 09:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbhIMHEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 03:04:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237454AbhIMHEG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 03:04:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631516571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DmQmip+5IO9siRqxDMXPdeE7VXRN9aesxsgPai5q4c8=;
        b=W6grbrjjYh9dZOLq3zIayCsTElr+1A7c1XXct0oZ8Otim92HUWyYiXAGx62siAquskQXVx
        9wlxntrgbLNLfZKNR+VZfztTDrxWeYQxvUdnobefDLTA2NH5Pdau1y0Dy7C/k3EW57hMJ1
        J3CKOVcLckgGRny0JDMhjQx8OQ5QWX0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-Yuhbcm65NA29F5hIuoYIZA-1; Mon, 13 Sep 2021 03:02:49 -0400
X-MC-Unique: Yuhbcm65NA29F5hIuoYIZA-1
Received: by mail-wr1-f70.google.com with SMTP id r7-20020a5d6947000000b0015e0f68a63bso104745wrw.22
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 00:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DmQmip+5IO9siRqxDMXPdeE7VXRN9aesxsgPai5q4c8=;
        b=ApbBqaEb+Dt+ZhD80h3hAPuMGg7K94a6N8rcZ0l38bugnsR5/KldJoeN8McyaboRIl
         ys2QeiHpMYTui+09cOY/jNIY1HHK2NULSrAA5to0oY5vPbZucG0t5wnr6mSwTzWZlqvV
         4+43Ra6pHTS1nw7GxwZMjx/GgYakmU8uJVp58ofujfdturko02HJWEKUCyN3V+JZfjsq
         O2yg/Xebt7ESHcoHUpXn9ZbsQ/Bu/ufR4tfJzy9NeXCsn4GbzI7chxP+QJLFxAOkKemZ
         ApkY/DjE2MZFqv6tuh5rZWy2CZYkjlWtBKHmB65BzR9G/nW6eeidA9zivvIpcGq/+ZFe
         nlDQ==
X-Gm-Message-State: AOAM532itI9xqSyaPLsoVDGwWHvQR+tQ7Zs9qtYCa3DCjiMixWUS3F6A
        WiQLYQbIR6+uwZcSx1VgtwQXBDlZeDsnrpOC9QBq+05pseABfN2H4YrEUwxUxCWW3DuKSmHRfh/
        4MxFodCdD0iv9
X-Received: by 2002:a1c:ac07:: with SMTP id v7mr9398193wme.160.1631516568492;
        Mon, 13 Sep 2021 00:02:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyytOfLrNJ/fWUKhedt0MGFoZXpWHC40WzlmnUyObEMReSAOJa9m8EX9faxmiXT98S3Xpy/Ug==
X-Received: by 2002:a1c:ac07:: with SMTP id v7mr9398166wme.160.1631516568237;
        Mon, 13 Sep 2021 00:02:48 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p13sm6402656wro.8.2021.09.13.00.02.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 00:02:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86: Query vcpu->vcpu_idx directly and drop
 its accessor
In-Reply-To: <20210910183220.2397812-2-seanjc@google.com>
References: <20210910183220.2397812-1-seanjc@google.com>
 <20210910183220.2397812-2-seanjc@google.com>
Date:   Mon, 13 Sep 2021 09:02:46 +0200
Message-ID: <87fsu92c15.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

