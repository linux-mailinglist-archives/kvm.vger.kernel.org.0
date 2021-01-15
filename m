Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F242F7BD6
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732666AbhAONG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:06:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732815AbhAONGZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610715898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7c420dPECbiXPZhECKBffZnsx/9MKvakAMA3MQ54v9c=;
        b=E1lWawuUCsQu2u4uUEPmNIXOXhP3oDi+bBxy1cUI4qPK+os2yRuMFsi7oDFMf9FSu3Y9XF
        lyjPmIF/m6FV/g5MQ2hj4/tCTqeles6WqD0CviBejn4EB2uzLwL90EzME9UK/EmDJvOp6p
        GQtNUc363k/BSJkddFWny07PeWDh1Ug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-LBE-i0UNM52kNqy9mYLSlg-1; Fri, 15 Jan 2021 08:04:54 -0500
X-MC-Unique: LBE-i0UNM52kNqy9mYLSlg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A1DD9CDA2;
        Fri, 15 Jan 2021 13:04:53 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7994C6A8E7;
        Fri, 15 Jan 2021 13:04:50 +0000 (UTC)
Subject: Re: [PATCH 3/6] KVM: arm64: Add handling of AArch32 PCMEID{2,3} PMUv3
 registers
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210114105633.2558739-1-maz@kernel.org>
 <20210114105633.2558739-4-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <aba855dc-6300-fced-e063-34e5323454a7@redhat.com>
Date:   Fri, 15 Jan 2021 14:04:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210114105633.2558739-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/14/21 11:56 AM, Marc Zyngier wrote:
> Despite advertising support for AArch32 PMUv3p1, we fail to handle
> the PMCEID{2,3} registers, which conveniently alias with with the top
s/with with/with
> bits of PMCEID{0,1}_EL1.
> 
> Implement these registers with the usual AA32(HI/LO) aliasing
> mechanism.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arch/arm64/kvm/sys_regs.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index ce08d28ab15c..2bea0494b81d 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -685,14 +685,18 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			  const struct sys_reg_desc *r)
>  {
> -	u64 pmceid;
> +	u64 pmceid, mask, shift;
>  
>  	BUG_ON(p->is_write);
>  
>  	if (pmu_access_el0_disabled(vcpu))
>  		return false;
>  
> +	get_access_mask(r, &mask, &shift);
> +
>  	pmceid = kvm_pmu_get_pmceid(vcpu, (p->Op2 & 1));
> +	pmceid &= mask;
> +	pmceid >>= shift;
>  
>  	p->regval = pmceid;
>  
> @@ -1895,8 +1899,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovs },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 4), access_pmswinc },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
> +	{ AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
> +	{ AA32(LO), Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_evcntr },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_evtyper },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_evcntr },
> @@ -1904,6 +1908,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pminten },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
>  	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovs },
> +	{ AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 4), access_pmceid },
> +	{ AA32(HI), Op1( 0), CRn( 9), CRm(14), Op2( 5), access_pmceid },
>  
>  	/* PRRR/MAIR0 */
>  	{ AA32(LO), Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, MAIR_EL1 },
> 

