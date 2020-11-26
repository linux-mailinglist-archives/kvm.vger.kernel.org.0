Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C212C56CC
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 15:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390595AbgKZONs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 09:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389834AbgKZONr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Nov 2020 09:13:47 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA7D82053B;
        Thu, 26 Nov 2020 14:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606400026;
        bh=Nwf0LWOIlSxDboie5BRpCyT4HH+0qOYQLcXu5QovH7Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oYwMx6zrGmCrB+7GRYf+F0vDRHi9tDEldFtLwYFsX55AhxxED5Mby5AKpjXiJTcFR
         C0rYYdk3DyNunHQpOEomBg/MFi/2XGBuJHNFpXo153otiaGAGPpJPWcuRCw/0kAVwR
         T3Ednq1q53U7JpJXdBEmIGM86sfnuLUFGT0A05fM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kiI1o-00DpFw-LG; Thu, 26 Nov 2020 14:13:44 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 26 Nov 2020 14:13:44 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [PATCH 1/2] KVM: arm64: CSSELR_EL1 max is 13
In-Reply-To: <20201126134641.35231-2-drjones@redhat.com>
References: <20201126134641.35231-1-drjones@redhat.com>
 <20201126134641.35231-2-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <163d00024402dbb518a6f8d669579bfa@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-11-26 13:46, Andrew Jones wrote:
> Not counting TnD, which KVM doesn't currently consider, CSSELR_EL1
> can have a maximum value of 0b1101 (13), which corresponds to an
> instruction cache at level 7. With CSSELR_MAX set to 12 we can
> only select up to cache level 6. Change it to 14.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c1fac9836af1..ef453f7827fa 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -169,7 +169,7 @@ void vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64
> val, int reg)
>  static u32 cache_levels;
> 
>  /* CSSELR values; used to index KVM_REG_ARM_DEMUX_ID_CCSIDR */
> -#define CSSELR_MAX 12
> +#define CSSELR_MAX 14
> 
>  /* Which cache CCSIDR represents depends on CSSELR value. */
>  static u32 get_ccsidr(u32 csselr)

Huh, nice catch. Do we need a CC: stable tag for this?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
