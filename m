Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9A22C572F
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 15:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390631AbgKZOeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 09:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390253AbgKZOeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 09:34:08 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B222065E;
        Thu, 26 Nov 2020 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606401247;
        bh=nW1sXw6H/dTIFX6V22eJXB6e4NbOKedFUzjyvGKSLr0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AVF+5GoOXLlh9O1yo+6ohnxF30UWvY9SJ1zSpeTqhKV2vB2D13tqP4WDCIcT11Fg+
         T7RGhk4R5jcoAUN0XifY1MVP1if9eAYPGaAUm87Q0Yuj4u+tImw79XfH21Q6bhhDZ5
         mWl3lYiZoIeTEq0ZJnfyoXUlh/kwCvkTxEg6Qcm4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kiILV-00DpZS-Dr; Thu, 26 Nov 2020 14:34:05 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 26 Nov 2020 14:34:05 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [PATCH 1/2] KVM: arm64: CSSELR_EL1 max is 13
In-Reply-To: <20201126143200.eezs474ks3xdlnsl@kamzik.brq.redhat.com>
References: <20201126134641.35231-1-drjones@redhat.com>
 <20201126134641.35231-2-drjones@redhat.com>
 <163d00024402dbb518a6f8d669579bfa@kernel.org>
 <20201126143200.eezs474ks3xdlnsl@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <5106d82b42174b86dd62bc9637b2b6a4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-26 14:32, Andrew Jones wrote:
> On Thu, Nov 26, 2020 at 02:13:44PM +0000, Marc Zyngier wrote:
>> On 2020-11-26 13:46, Andrew Jones wrote:
>> > Not counting TnD, which KVM doesn't currently consider, CSSELR_EL1
>> > can have a maximum value of 0b1101 (13), which corresponds to an
>> > instruction cache at level 7. With CSSELR_MAX set to 12 we can
>> > only select up to cache level 6. Change it to 14.
>> >
>> > Signed-off-by: Andrew Jones <drjones@redhat.com>
>> > ---
>> >  arch/arm64/kvm/sys_regs.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> > index c1fac9836af1..ef453f7827fa 100644
>> > --- a/arch/arm64/kvm/sys_regs.c
>> > +++ b/arch/arm64/kvm/sys_regs.c
>> > @@ -169,7 +169,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64
>> > val, int reg)
>> >  static u32 cache_levels;
>> >
>> >  /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
>> > -#define CSSELR_MAX 12
>> > +#define CSSELR_MAX 14
>> >
>> >  /* Which cache CCSIDR represents depends on CSSELR value. */
>> >  static u32 get_ccsidr(u32 csselr)
>> 
>> Huh, nice catch. Do we need a CC: stable tag for this?
>> 
> 
> Hi Marc,
> 
> I wasn't thinking so, because I'm not expecting there to actually
> be hardware with seven cache levels in the wild any time soon. You
> have more knowledge about what's out there and coming, though, so
> feel free CC stable if needed.

That's actually what I was wondering, whether you had seen that in the
wild already. Since you haven't (and I'm not aware of such a 
monstrosity),
I'll queue it for 5.11.

Do you want me to take the selftest stuff at the same time?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
