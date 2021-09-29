Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9E141CA03
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 18:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345461AbhI2QYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 12:24:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25861 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233501AbhI2QYw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 12:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632932590;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+j4qNtz3r10+MbmLFcntFcdy8mpU9rKxm1btg9WBj6Q=;
        b=GQ913PaV010mfrOqvnDU8fhnsA4qVi9p+kjxdwivKzDyKxwosM+iBeKdKHJAyyd9q+lMBX
        ozVjgaepZM8PdBiSYnsBvDyKZXvsd4fV82oClMaL41KeFfUNHlisvbzsHyW2DUw8QgrY97
        946lhbct9QBFRe0KRVek8MkVLnerUDs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-mRPaCm31PxKWn8VBrGcpMA-1; Wed, 29 Sep 2021 12:23:09 -0400
X-MC-Unique: mRPaCm31PxKWn8VBrGcpMA-1
Received: by mail-wm1-f72.google.com with SMTP id 70-20020a1c0149000000b0030b7dd84d81so1464727wmb.3
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=+j4qNtz3r10+MbmLFcntFcdy8mpU9rKxm1btg9WBj6Q=;
        b=4HKHf5QP5RhRgKLPEfSmPwhhXuKkHwPhRBptExrLhybQPEZYqyh6Y42HICbgvEcmVW
         p1jYtmI8cZy7xgBF2bc8Ee6jzMCAJAVVNOeMv8hXlhB4DMjvlMZf9GEpgL4wyPETbKDy
         ARcgttFX+mcVh/aoIyDHQH+CZOhWvTzSSWgJCtsfzPhvu10ZS8juxdhbepHaKY1E9JZp
         V3Q5zUJt5Y8lfgjx53l52qHb13F9Ju6NraA+gU21od2gnpZCA52dOWtw+9ueKsVemzzS
         ezHfZps+ma87fZ8EEJxfKZUmfwydtgmjHqy64WdD8gboD7zRa1Y49aZOGetV02C21TH6
         v3SA==
X-Gm-Message-State: AOAM530ED7jDk8T+6pIepBnTn3tjNhR6btgF1/Sp23WfvSq5DWy7RPvQ
        3Acm7E8UNkRS10IlsacTotqMKFuXOfyotZgniywGEZESIuwI4mrO5dtILlxh4SemoJd+dvOo4cF
        cCp+NkT+CSXVS
X-Received: by 2002:adf:de02:: with SMTP id b2mr1006136wrm.42.1632932588226;
        Wed, 29 Sep 2021 09:23:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwx3JwfLqcKKCKR9kwsjaIijoJNrYWdDJUODQjYSa6EdVLozQeoWHYLjcTq72gUKI26harjsg==
X-Received: by 2002:adf:de02:: with SMTP id b2mr1006106wrm.42.1632932588013;
        Wed, 29 Sep 2021 09:23:08 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id u1sm362768wrn.66.2021.09.29.09.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 09:23:07 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 02/10] KVM: arm64: vgic-v3: Check redist region is not
 above the VM IPA size
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-3-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <01a03d81-e98b-a504-f4b7-e4a56ffa78d5@redhat.com>
Date:   Wed, 29 Sep 2021 18:23:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-3-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 9/28/21 8:47 PM, Ricardo Koller wrote:
> Verify that the redistributor regions do not extend beyond the
> VM-specified IPA range (phys_size). This can happen when using
> KVM_VGIC_V3_ADDR_TYPE_REDIST or KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS
> with:
>
>   base + size > phys_size AND base < phys_size
>
> Add the missing check into vgic_v3_alloc_redist_region() which is called
> when setting the regions, and into vgic_v3_check_base() which is called
> when attempting the first vcpu-run. The vcpu-run check does not apply to
> KVM_VGIC_V3_ADDR_TYPE_REDIST_REGIONS because the regions size is known
> before the first vcpu-run. Note that using the REDIST_REGIONS API
> results in a different check, which already exists, at first vcpu run:
> that the number of redist regions is enough for all vcpus.
>
> Finally, this patch also enables some extra tests in
> vgic_v3_alloc_redist_region() by calculating "size" early for the legacy
> redist api: like checking that the REDIST region can fit all the already
> created vcpus.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 6 ++++--
>  arch/arm64/kvm/vgic/vgic-v3.c      | 4 ++++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index a09cdc0b953c..9be02bf7865e 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -796,7 +796,9 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
>  	struct vgic_dist *d = &kvm->arch.vgic;
>  	struct vgic_redist_region *rdreg;
>  	struct list_head *rd_regions = &d->rd_regions;
> -	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
> +	int nr_vcpus = atomic_read(&kvm->online_vcpus);
> +	size_t size = count ? count * KVM_VGIC_V3_REDIST_SIZE
> +			    : nr_vcpus * KVM_VGIC_V3_REDIST_SIZE;

This actually fixes the  vgic_dist_overlap(kvm, base, size=0)

in case the number of online-vcpus at that time is less than the final
one (1st run), if count=0 (legacy API) do we ever check that the RDIST
(with accumulated vcpu rdists) does not overlap with dist.
in other words shouldn't we call vgic_dist_overlap(kvm, base, size)
again in vgic_v3_check_base().

Thanks

Eric

>  	int ret;
>  
>  	/* cross the end of memory ? */
> @@ -840,7 +842,7 @@ static int vgic_v3_alloc_redist_region(struct kvm *kvm, uint32_t index,
>  
>  	rdreg->base = VGIC_ADDR_UNDEF;
>  
> -	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
> +	ret = vgic_check_iorange(kvm, &rdreg->base, base, SZ_64K, size);
>  	if (ret)
>  		goto free;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 21a6207fb2ee..27ee674631b3 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -486,6 +486,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
>  			rdreg->base)
>  			return false;
> +
> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> +			kvm_phys_size(kvm))
> +			return false;
>  	}
>  
>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))

