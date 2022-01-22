Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C370496C26
	for <lists+kvm@lfdr.de>; Sat, 22 Jan 2022 12:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbiAVLcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jan 2022 06:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiAVLct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jan 2022 06:32:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBA4C06173B
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 03:32:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40F1360BA4
        for <kvm@vger.kernel.org>; Sat, 22 Jan 2022 11:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61B5C004E1;
        Sat, 22 Jan 2022 11:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642851167;
        bh=da9dcIw8+ZO22yZ/mXsw9PbOSUJDP1ZUMBvg+J6Y+LA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ks68lFAOpH1zQrQYK3tbSAH07QNmXRSUZ4HSHotHR3Nj1uIYk5ArtYW7tvlRVILTN
         ftPzxhl8DyhRKH4cCo4hHkZvaMW0WRK0axAZH6PD7A8Um57lfA4wYLp+WxHof65hm1
         +Wf42STgLh9fyfkUST91YxTU+W4vz8TIMmXTpGpu8iqjvNUj1f/W/fjpNj2sGXCAXW
         6LUKYH2e4mCpS+RO4Fo7EQh7EHQyyeYhkfn7bDPLCYhqMwzUnGIipmj30Lv49rNyKG
         /T15PE7c3cJYa2m+98qqZaQq1CnX85Tb3KtAt6po8Uskt35+Qx3VjjWunx/3r8CJuZ
         4SPcOLyPAr73Q==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nBEdR-0025B5-Og; Sat, 22 Jan 2022 11:32:45 +0000
MIME-Version: 1.0
Date:   Sat, 22 Jan 2022 11:32:45 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Restrict SEIS workaround to known
 broken systems
In-Reply-To: <CAMj1kXEmNpTGtZU=ZkOTpYpG7bdaubUx3-Zzpf-D1unjk43AYQ@mail.gmail.com>
References: <20220122103912.795026-1-maz@kernel.org>
 <CAMj1kXEmNpTGtZU=ZkOTpYpG7bdaubUx3-Zzpf-D1unjk43AYQ@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <8d8b93e7251b0373d897a2f9222b0520@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ardb@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-01-22 11:14, Ard Biesheuvel wrote:
> On Sat, 22 Jan 2022 at 11:39, Marc Zyngier <maz@kernel.org> wrote:
>> 
>> Contrary to what df652bcf1136 ("KVM: arm64: vgic-v3: Work around GICv3
>> locally generated SErrors") was asserting, there is at least one other
>> system out there (Cavium ThunderX2) implementing SEIS, and not in
>> an obviously broken way.
>> 
>> So instead of imposing the M1 workaround on an innocent bystander,
>> let's limit it to the two known broken Apple implementations.
>> 
>> Fixes: df652bcf1136 ("KVM: arm64: vgic-v3: Work around GICv3 locally 
>> generated SErrors")
>> Reported-by: Ard Biesheuvel <ardb@kernel.org>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Thanks for the fix.
> 
> Tested-by: Ard Biesheuvel <ardb@kernel.org>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Thanks for that.

> 
> One nit below.
> 
>> ---
>>  arch/arm64/kvm/hyp/vgic-v3-sr.c |  3 +++
>>  arch/arm64/kvm/vgic/vgic-v3.c   | 17 +++++++++++++++--
>>  2 files changed, 18 insertions(+), 2 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c 
>> b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> index 20db2f281cf2..4fb419f7b8b6 100644
>> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> @@ -983,6 +983,9 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu 
>> *vcpu, u32 vmcr, int rt)
>>         val = ((vtr >> 29) & 7) << ICC_CTLR_EL1_PRI_BITS_SHIFT;
>>         /* IDbits */
>>         val |= ((vtr >> 23) & 7) << ICC_CTLR_EL1_ID_BITS_SHIFT;
>> +       /* SEIS */
>> +       if (kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_SEIS_MASK)
>> +               val |= BIT(ICC_CTLR_EL1_SEIS_SHIFT);
>>         /* A3V */
>>         val |= ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
>>         /* EOImode */
>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c 
>> b/arch/arm64/kvm/vgic/vgic-v3.c
>> index 78cf674c1230..d34a795f730c 100644
>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>> @@ -609,6 +609,18 @@ static int __init early_gicv4_enable(char *buf)
>>  }
>>  early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
>> 
>> +static struct midr_range broken_seis[] = {
> 
> Can this be const?

Absolutely. I'll fold that in.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
