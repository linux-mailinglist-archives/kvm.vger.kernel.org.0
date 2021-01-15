Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9D22F7BE1
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388593AbhAONGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:06:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732463AbhAONGw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:06:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610715925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vWLhTMNMfb5OQjwqjkp1CSuMt4hrhA8u/fDfTDp0riM=;
        b=idyClVvRMMcYz36exbAgEGCUahlwh+l4im9RPnKnImviE03gpoV5zOsJ52ltqqCA3eFcCS
        DT//NA6SWK+VGm1XlgxAJSWaZsYaIrxnr3XTpGrDGL109ud68GfW8QlNKUBKE8u/OG0jS7
        spaIUSP9OdtnDqEHoizmZz3BqiNSie4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-pMEY7HlWP7yscBvQ2Vnpzg-1; Fri, 15 Jan 2021 08:05:21 -0500
X-MC-Unique: pMEY7HlWP7yscBvQ2Vnpzg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECC8C8144ED;
        Fri, 15 Jan 2021 13:05:19 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D4CA77BF6;
        Fri, 15 Jan 2021 13:05:17 +0000 (UTC)
Subject: Re: [PATCH 2/6] KVM: arm64: Fix AArch32 PMUv3 capping
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210114105633.2558739-1-maz@kernel.org>
 <20210114105633.2558739-3-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <444b17ec-e737-f6ae-400d-fd2142dfb175@redhat.com>
Date:   Fri, 15 Jan 2021 14:05:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210114105633.2558739-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/14/21 11:56 AM, Marc Zyngier wrote:
> We shouldn't expose *any* PMU capability when no PMU has been
> configured for this VM.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0c0832472c4a..ce08d28ab15c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1048,8 +1048,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  	} else if (id == SYS_ID_DFR0_EL1) {
>  		/* Limit guests to PMUv3 for ARMv8.1 */
>  		val = cpuid_feature_cap_perfmon_field(val,
> -						ID_DFR0_PERFMON_SHIFT,
> -						ID_DFR0_PERFMON_8_1);
> +						      ID_DFR0_PERFMON_SHIFT,
> +						      kvm_vcpu_has_pmu(vcpu) ? ID_DFR0_PERFMON_8_1 : 0);
nit: Maybe you could use the same layout for SYS_ID_AA64DFR0_EL1
andremove cap there.

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric



>  	}
>  
>  	return val;
> 

