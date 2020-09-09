Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2144F2634D9
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgIIRnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 13:43:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47012 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727055AbgIIRnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 13:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599673428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aY1iOV2epsIPFBnkecmASmCcKT+HKO22FFgSQgRrr4E=;
        b=MK6zqmG5mNHDMJiKIoIVNgEiwgtK3y2zk+R9Yf3KSDozq94l4we8gsROaFNe9pOZISc3D2
        E0G0hUN0ZXZxrXNBjuivBwlT4xItk0cwEfeZNainENrbUcVCwe1z+KluI2Q+eSdfmx9uwj
        nJGDNYzShzI+10MJfmpx12FQVDcmuvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-c5JX7vmOOOqtwUU9podEJw-1; Wed, 09 Sep 2020 13:43:44 -0400
X-MC-Unique: c5JX7vmOOOqtwUU9podEJw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EBF01091063;
        Wed,  9 Sep 2020 17:43:42 +0000 (UTC)
Received: from [10.36.115.123] (ovpn-115-123.ams2.redhat.com [10.36.115.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9DE210013D0;
        Wed,  9 Sep 2020 17:43:39 +0000 (UTC)
Subject: Re: [PATCH v3 4/5] KVM: arm64: Mask out filtered events in
 PCMEID{0,1}_EL1
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, graf@amazon.com,
        kernel-team@android.com
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-5-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <735f5464-3a45-8dc0-c330-ac5632bcb4b4@redhat.com>
Date:   Wed, 9 Sep 2020 19:43:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200908075830.1161921-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 9/8/20 9:58 AM, Marc Zyngier wrote:
> As we can now hide events from the guest, let's also adjust its view of
> PCMEID{0,1}_EL1 so that it can figure out why some common events are not
> counting as they should.
Referring to my previous comment should we filter the cycle counter out?
> 
> The astute user can still look into the TRM for their CPU and find out
> they've been cheated, though. Nobody's perfect.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 29 +++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c |  5 +----
>  include/kvm/arm_pmu.h     |  5 +++++
>  3 files changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 67a731bafbc9..0458860bade2 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -765,6 +765,35 @@ static int kvm_pmu_probe_pmuver(void)
>  	return pmuver;
>  }
>  
> +u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
> +{
> +	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
> +	u64 val, mask = 0;
> +	int base, i;
> +
> +	if (!pmceid1) {
> +		val = read_sysreg(pmceid0_el0);
> +		base = 0;
> +	} else {
> +		val = read_sysreg(pmceid1_el0);
> +		base = 32;
> +	}
> +
> +	if (!bmap)
> +		return val;
> +
> +	for (i = 0; i < 32; i += 8) {
s/32/4?

Thanks

Eric
> +		u64 byte;
> +
> +		byte = bitmap_get_value8(bmap, base + i);
> +		mask |= byte << i;
> +		byte = bitmap_get_value8(bmap, 0x4000 + base + i);
> +		mask |= byte << (32 + i);
> +	}
> +
> +	return val & mask;
> +}
> +
>  bool kvm_arm_support_pmu_v3(void)
>  {
>  	/*
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 077293b5115f..20ab2a7d37ca 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -769,10 +769,7 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	if (pmu_access_el0_disabled(vcpu))
>  		return false;
>  
> -	if (!(p->Op2 & 1))
> -		pmceid = read_sysreg(pmceid0_el0);
> -	else
> -		pmceid = read_sysreg(pmceid1_el0);
> +	pmceid = kvm_pmu_get_pmceid(vcpu, (p->Op2 & 1));
>  
>  	p->regval = pmceid;
>  
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 6db030439e29..98cbfe885a53 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -34,6 +34,7 @@ struct kvm_pmu {
>  u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
>  u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
> +u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
>  void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
>  void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
>  void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
> @@ -108,6 +109,10 @@ static inline int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
>  {
>  	return 0;
>  }
> +static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
> +{
> +	return 0;
> +}
>  #endif
>  
>  #endif
> 

