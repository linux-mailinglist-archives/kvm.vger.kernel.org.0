Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054E518C8D4
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 09:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCTINA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 04:13:00 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:34894 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726697AbgCTIM7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 04:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584691978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8MAqyKfJ2pHFLOBo7NW3E2Ykhz/QSuq5efa4hJ0jsIk=;
        b=gNtKi/k9K+67e5lA1VjEJaHE4B5WIEC5FmSGGwZisqnlfP9DZJzNJvdmJTnl6PAP2R4yXJ
        +79Rv2u86jRBHhRETXKUW9qZDybWsJGVJInGDex5zBqpSI+zzd+dNT1sVvHH9HTiepBOSd
        KueihLgrp2ISrFZxpVJ3GtlpfIkMy9s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-tyaOxDRDOMaZqNnRvGlzAA-1; Fri, 20 Mar 2020 04:12:54 -0400
X-MC-Unique: tyaOxDRDOMaZqNnRvGlzAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B401018B9FC1;
        Fri, 20 Mar 2020 08:12:52 +0000 (UTC)
Received: from [10.36.113.142] (ovpn-113-142.ams2.redhat.com [10.36.113.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C90F66EF9D;
        Fri, 20 Mar 2020 08:12:49 +0000 (UTC)
Subject: Re: [PATCH v5 22/23] KVM: arm64: GICv4.1: Allow non-trapping WFI when
 using HW SGIs
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-23-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <01014c0e-0151-302c-2a7a-fc60f63fba27@redhat.com>
Date:   Fri, 20 Mar 2020 09:12:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-23-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> Just like for VLPIs, it is beneficial to avoid trapping on WFI when the
> vcpu is using the GICv4.1 SGIs.
> 
> Add such a check to vcpu_clear_wfx_traps().
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index f658dda12364..a30b4eec7cb4 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -89,7 +89,8 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
>  static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.hcr_el2 &= ~HCR_TWE;
> -	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count))
> +	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
> +	    vcpu->kvm->arch.vgic.nassgireq)
>  		vcpu->arch.hcr_el2 &= ~HCR_TWI;
>  	else
>  		vcpu->arch.hcr_el2 |= HCR_TWI;
> 

