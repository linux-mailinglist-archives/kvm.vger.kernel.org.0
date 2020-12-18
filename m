Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15AA2DE02A
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 10:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733100AbgLRJA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 04:00:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727017AbgLRJA0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Dec 2020 04:00:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608281940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Pv5xhWNv+Jr5Z9wEnecYSbhnRK82//2103BzAO94wA=;
        b=cAcvZxsz+2iAe2dTNY19WLlNTkdNad/cEtmAPKbD81tAmUYCP8OcZCV/fMuJNWJV+UktId
        j1lwA6ViX59V/duCfDgCxOQOBlX+O5H2SiVN2WD5EEe3awFxESk56wMhj/FHNoRWxFbn0g
        xF0vE+sDKDAf8ONWevEL1Xrpq8get8c=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-RsMFG2wINcSxGYb6EhcWhg-1; Fri, 18 Dec 2020 03:58:57 -0500
X-MC-Unique: RsMFG2wINcSxGYb6EhcWhg-1
Received: by mail-ej1-f72.google.com with SMTP id gs3so552590ejb.5
        for <kvm@vger.kernel.org>; Fri, 18 Dec 2020 00:58:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6Pv5xhWNv+Jr5Z9wEnecYSbhnRK82//2103BzAO94wA=;
        b=PV0h5fOuvunBnyi5wsKAHSbVw36GQjyVN5ouxcorsYOvi/ARuYTcF+KasxPQKJ9J0d
         47m/Ch7WKpgvO9NEzJUl6NQjbESxrVOrfLiosAamhtsaf9V78njzV1FVOi2UD4p0OECl
         Lh8xb+Ij6r4MG5XLU9dyRPvjcw/jODgBi32h3aIatD9bDdH7QxyYDGUUmZdtp2/d6Wi9
         LdiTbMLQp2/O/dT4tn8gxF0eki95zvCOU17sHrvYT8J5FSAegvkvvR7c4w11qjPclZd1
         wKH/WF68kOcvLxRaxCZJnp8McsQaxNyesPIeUJhuEy1qp+B6rz7TTszwVpTh2qBw6pUN
         Ec5w==
X-Gm-Message-State: AOAM533MHdQX5kcs65Infh+X8KWRQPagFf3sNAv/6VBsXU630pIn8+pL
        RvnUf4PI7nyOd1c6KR5W0eO53FIotNntWVnXtMqjTF3NJWaxaag4TbZo+lYIK3HM3SNefxyJMwp
        aUPN4tVAfPvKG
X-Received: by 2002:a17:906:8152:: with SMTP id z18mr2993051ejw.317.1608281936288;
        Fri, 18 Dec 2020 00:58:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrgXG47nCxPB4wUonNQEEbm858INRlgvLBF56TtPDOmxjDE3qiJizYro3OqUQajCxpPCsTfA==
X-Received: by 2002:a17:906:8152:: with SMTP id z18mr2993041ejw.317.1608281936098;
        Fri, 18 Dec 2020 00:58:56 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x16sm5214784ejo.104.2020.12.18.00.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 00:58:55 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
Subject: Re: [PATCH 1/4] KVM: x86/mmu: Use -1 to flag an undefined spte in
 get_mmio_spte()
In-Reply-To: <20201218003139.2167891-2-seanjc@google.com>
References: <20201218003139.2167891-1-seanjc@google.com>
 <20201218003139.2167891-2-seanjc@google.com>
Date:   Fri, 18 Dec 2020 09:58:54 +0100
Message-ID: <87tusjtrqp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Return -1 from the get_walk() helpers if the shadow walk doesn't fill at
> least one spte, which can theoretically happen if the walk hits a
> not-present PTPDR.  Returning the root level in such a case will cause

PDPTR

> get_mmio_spte() to return garbage (uninitialized stack data).  In
> practice, such a scenario should be impossible as KVM shouldn't get a
> reserved-bit page fault with a not-present PDPTR.
>
> Note, using mmu->root_level in get_walk() is wrong for other reasons,
> too, but that's now a moot point.
>
> Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")
> Cc: Ben Gardon <bgardon@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 7 ++++++-
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7a6ae9e90bd7..a48cd12c01d7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3488,7 +3488,7 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>  static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
>  {
>  	struct kvm_shadow_walk_iterator iterator;
> -	int leaf = vcpu->arch.mmu->root_level;
> +	int leaf = -1;
>  	u64 spte;
>  
>  
> @@ -3532,6 +3532,11 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>  	else
>  		leaf = get_walk(vcpu, addr, sptes);
>  
> +	if (unlikely(leaf < 0)) {
> +		*sptep = 0ull;
> +		return reserved;
> +	}

When SPTE=0 is returned from get_mmio_spte(), handle_mmio_page_fault()
will return RET_PF_RETRY -- should it be RET_PF_INVALID instead?

> +
>  	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
>  
>  	for (level = root; level >= leaf; level--) {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 84c8f06bec26..50cec7a15ddb 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1152,8 +1152,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
>  {
>  	struct tdp_iter iter;
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> -	int leaf = vcpu->arch.mmu->shadow_root_level;
>  	gfn_t gfn = addr >> PAGE_SHIFT;
> +	int leaf = -1;
>  
>  	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
>  		leaf = iter.level;

-- 
Vitaly

