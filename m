Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5554128925
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 14:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfLUNMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 08:12:20 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:43494 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726583AbfLUNMT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 21 Dec 2019 08:12:19 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iieYK-0002tv-Gk; Sat, 21 Dec 2019 14:12:16 +0100
Date:   Sat, 21 Dec 2019 13:12:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Murray <andrew.murray@arm.com>
Cc:     will@kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/18] arm64: KVM: reset E2PB correctly in MDCR_EL2
 when exiting the guest(VHE)
Message-ID: <20191221131214.769a140e@why>
In-Reply-To: <20191220143025.33853-3-andrew.murray@arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
        <20191220143025.33853-3-andrew.murray@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: andrew.murray@arm.com, will@kernel.org, catalin.marinas@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, sudeep.holla@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Dec 2019 14:30:09 +0000
Andrew Murray <andrew.murray@arm.com> wrote:

> From: Sudeep Holla <sudeep.holla@arm.com>
> 
> On VHE systems, the reset value for MDCR_EL2.E2PB=b00 which defaults
> to profiling buffer using the EL2 stage 1 translations. 

Does the reset value actually matter here? I don't see it being
specific to VHE systems, and all we're trying to achieve is to restore
the SPE configuration to a state where it can be used by the host.

> However if the
> guest are allowed to use profiling buffers changing E2PB settings, we

How can the guest be allowed to change E2PB settings? Or do you mean
here that allowing the guest to use SPE will mandate changes of the
E2PB settings, and that we'd better restore the hypervisor state once
we exit?

> need to ensure we resume back MDCR_EL2.E2PB=b00. Currently we just
> do bitwise '&' with MDCR_EL2_E2PB_MASK which will retain the value.
> 
> So fix it by clearing all the bits in E2PB.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 72fbbd86eb5e..250f13910882 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -228,9 +228,7 @@ void deactivate_traps_vhe_put(void)
>  {
>  	u64 mdcr_el2 = read_sysreg(mdcr_el2);
>  
> -	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
> -		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
> -		    MDCR_EL2_TPMS;
> +	mdcr_el2 &= MDCR_EL2_HPMN_MASK | MDCR_EL2_TPMS;
>  
>  	write_sysreg(mdcr_el2, mdcr_el2);
>  

I'm OK with this change, but I believe the commit message could use
some tidying up.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
