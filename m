Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C8721108A
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 18:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732154AbgGAQZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 12:25:48 -0400
Received: from disco-boy.misterjones.org ([51.254.78.96]:34616 "EHLO
        disco-boy.misterjones.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgGAQZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 12:25:47 -0400
X-Greylist: delayed 2619 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2020 12:25:47 EDT
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@misterjones.org>)
        id 1jqesA-0086wK-Eg; Wed, 01 Jul 2020 16:42:06 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 01 Jul 2020 16:42:06 +0100
From:   Marc Zyngier <maz@misterjones.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvm@vger.kernel.org, andre.przywara@arm.com,
        Sami Mujawar <sami.mujawar@arm.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] kvmtool: arm64: Report missing support for 32bit guests
In-Reply-To: <20200701142002.51654-1-suzuki.poulose@arm.com>
References: <20200701142002.51654-1-suzuki.poulose@arm.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <1aa7885c0d1554c8797e65b13bd05e82@misterjones.org>
X-Sender: maz@misterjones.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, kvm@vger.kernel.org, andre.przywara@arm.com, sami.mujawar@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-01 15:20, Suzuki K Poulose wrote:
> When the host doesn't support 32bit guests, the kvmtool fails
> without a proper message on what is wrong. i.e,
> 
>  $ lkvm run -c 1 Image --aarch32
>   # lkvm run -k Image -m 256 -c 1 --name guest-105618
>   Fatal: Unable to initialise vcpu
> 
> Given that there is no other easy way to check if the host supports 
> 32bit
> guests, it is always good to report this by checking the capability, 
> rather
> than leaving the users to hunt this down by looking at the code!
> 
> After this patch:
> 
>  $ lkvm run -c 1 Image --aarch32
>   # lkvm run -k Image -m 256 -c 1 --name guest-105695
>   Fatal: 32bit guests are not supported

Fancy!

> 
> Cc: Will Deacon <will@kernel.org>
> Reported-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arm/kvm-cpu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 554414f..2acecae 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -46,6 +46,10 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm,
> unsigned long cpu_id)
>  		.features = ARM_VCPU_FEATURE_FLAGS(kvm, cpu_id)
>  	};
> 
> +	if (kvm->cfg.arch.aarch32_guest &&
> +	    !kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))

Can you please check that this still compiles for 32bit host?

> +		die("32bit guests are not supported\n");
> +
>  	vcpu = calloc(1, sizeof(struct kvm_cpu));
>  	if (!vcpu)
>  		return NULL;

With the above detail checked,

Acked-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Who you jivin' with that Cosmik Debris?
