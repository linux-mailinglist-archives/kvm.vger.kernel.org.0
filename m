Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5877F2F7D8D
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 15:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733055AbhAOODE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 09:03:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732783AbhAOODC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 09:03:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610719296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wR0ZOXj1CL5xBSwSHiAU/pRR3SrX7XQb4/oR0asLAWI=;
        b=NeC/noIpjEIte+8+TAkTRZiOchxtpsy7XWXIAphxb12wpmdxHlIwRAYL0k6ZQiBUmYU/4F
        thyn5JpzoLq11Xt3eOpkGIdXYJxTO4WGxvHL9kUPCEeis1pFlSBVDpmN3hOyqrIXMC7zkn
        6ZcYN5VSZ4i4LE8zlLJx2OASMQnjbX4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-mo4GxPgLOQi8BfUM27e34g-1; Fri, 15 Jan 2021 09:01:32 -0500
X-MC-Unique: mo4GxPgLOQi8BfUM27e34g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9A57A0CA3;
        Fri, 15 Jan 2021 14:01:30 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D04485D9E3;
        Fri, 15 Jan 2021 14:01:28 +0000 (UTC)
Subject: Re: [PATCH 5/6] KVM: arm64: Limit the debug architecture to ARMv8.0
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210114105633.2558739-1-maz@kernel.org>
 <20210114105633.2558739-6-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0abf9e50-4122-45aa-04e4-34cdc3627f57@redhat.com>
Date:   Fri, 15 Jan 2021 15:01:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210114105633.2558739-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/14/21 11:56 AM, Marc Zyngier wrote:
> Let's not pretend we support anything but ARMv8.0 as far as the
> debug architecture is concerned.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/sys_regs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index dda16d60197b..8f79ec1fffa7 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1048,6 +1048,9 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  				 FEATURE(ID_AA64ISAR1_GPI));
>  		break;
>  	case SYS_ID_AA64DFR0_EL1:
> +		/* Limit debug to ARMv8.0 */
> +		val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
> +		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
>  		/* Limit guests to PMUv3 for ARMv8.1 */
>  		val = cpuid_feature_cap_perfmon_field(val,
>  						      ID_AA64DFR0_PMUVER_SHIFT,
> 

