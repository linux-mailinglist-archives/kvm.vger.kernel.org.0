Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C192F7D8B
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 15:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732902AbhAOODA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 09:03:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732783AbhAOOC7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 09:02:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610719293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8obwFRnUY2hSrjdvhpue+R7Q613/wQ2X9QDQ56e5dwU=;
        b=J36ZYFRbfRVC0bXawc+D+/rfPco1B/6byF4FSRqT/Gp/f4kLaQlfXYJGaYhhi1VsnLBcCP
        UI/P65m/OP3N5xz7ZZCa+S+1FJsxhHHUzuBY+yKigv79I0e5YLs0AE+1C8CIt7QEN6VDeK
        lK3kZvkE/Cus2D197e6Wu/THSePvDwA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-vmZ04IPnNDislwUOuAIigA-1; Fri, 15 Jan 2021 09:01:31 -0500
X-MC-Unique: vmZ04IPnNDislwUOuAIigA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A92F18C9F40;
        Fri, 15 Jan 2021 14:01:29 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25E6E6F920;
        Fri, 15 Jan 2021 14:01:26 +0000 (UTC)
Subject: Re: [PATCH 6/6] KVM: arm64: Upgrade PMU support to ARMv8.4
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>, kernel-team@android.com,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20210114105633.2558739-1-maz@kernel.org>
 <20210114105633.2558739-7-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ec06055b-56ad-1589-7a5d-95d9f47466ce@redhat.com>
Date:   Fri, 15 Jan 2021 15:01:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210114105633.2558739-7-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/14/21 11:56 AM, Marc Zyngier wrote:
> Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
> pretty easy. All that is required is support for PMMIR_EL1, which
> is read-only, and for which returning 0 is a valid option.
> 
> Let's just do that and adjust what we return to the guest.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 8f79ec1fffa7..2f4ecbd2abfb 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1051,10 +1051,10 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  		/* Limit debug to ARMv8.0 */
>  		val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
>  		val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
> -		/* Limit guests to PMUv3 for ARMv8.1 */
> +		/* Limit guests to PMUv3 for ARMv8.4 */
>  		val = cpuid_feature_cap_perfmon_field(val,
>  						      ID_AA64DFR0_PMUVER_SHIFT,
> -						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_1 : 0);
> +						      kvm_vcpu_has_pmu(vcpu) ? ID_AA64DFR0_PMUVER_8_4 : 0);
>  		break;
>  	case SYS_ID_DFR0_EL1:
>  		/* Limit guests to PMUv3 for ARMv8.1 */
what about the debug version in aarch32 state. Is it on purpose that you
leave it as 8_1?

Thanks

Eric
> @@ -1496,6 +1496,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	{ SYS_DESC(SYS_PMINTENSET_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
>  	{ SYS_DESC(SYS_PMINTENCLR_EL1), access_pminten, reset_unknown, PMINTENSET_EL1 },
> +	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
>  
>  	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
>  	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
> 

