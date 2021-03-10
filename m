Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB097333AE1
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 11:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhCJK67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 05:58:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231197AbhCJK65 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 05:58:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615373937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=adwrvd9iCZQ2p6SHxT/WFVR0wYYyROHqLlc5N4YbBd4=;
        b=EAdGfMHTz3Te9Gz2J0QYVeRBe713H2Ji9x7npCG2PvlSm8S2+uaU7deKnGsbLxlJxYYT/h
        9k34oOTiNvo+C9CsC+t4wiaJO/+ePaxF1Mk2tscgwqvd27cK9jKnByBKQ6nIKub+l3FSvB
        XGQfkCfYbT16T4Njp5U4Gh9EOMHABxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-06h5cfBuNhS2RDj-Vp_Ozw-1; Wed, 10 Mar 2021 05:58:53 -0500
X-MC-Unique: 06h5cfBuNhS2RDj-Vp_Ozw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD20584BA40;
        Wed, 10 Mar 2021 10:58:50 +0000 (UTC)
Received: from [10.36.112.254] (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 046B06062F;
        Wed, 10 Mar 2021 10:58:46 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] KVM: arm64: Fix exclusive limit for IPA size
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210310104208.3819061-1-maz@kernel.org>
 <20210310104208.3819061-3-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ddcb2d37-c16b-6972-b0c3-d98a957828d7@redhat.com>
Date:   Wed, 10 Mar 2021 11:58:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310104208.3819061-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/10/21 11:42 AM, Marc Zyngier wrote:
> When registering a memslot, we check the size and location of that
> memslot against the IPA size to ensure that we can provide guest
> access to the whole of the memory.
> 
> Unfortunately, this check rejects memslot that end-up at the exact
> limit of the addressing capability for a given IPA size. For example,
> it refuses the creatrion of a 2GB memslot at 0x8000000 with a 32bit
creation
> IPA space.
> 
> Fix it by relaxing the check to accept a memslot reaching the
> limit of the IPA space.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
stable + Fixes?
> ---
>  arch/arm64/kvm/mmu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 77cb2d28f2a4..8711894db8c2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1312,8 +1312,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	 * Prevent userspace from creating a memory region outside of the IPA
>  	 * space addressable by the KVM guest IPA space.
>  	 */
> -	if (memslot->base_gfn + memslot->npages >=
> -	    (kvm_phys_size(kvm) >> PAGE_SHIFT))
> +	if ((memslot->base_gfn + memslot->npages) > (kvm_phys_size(kvm) >> PAGE_SHIFT))
>  		return -EFAULT;
>  
>  	mmap_read_lock(current->mm);
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

