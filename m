Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839FE305D1C
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313549AbhAZWgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:36:22 -0500
Received: from foss.arm.com ([217.140.110.172]:49748 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391826AbhAZRdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:33:49 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B5A731B;
        Tue, 26 Jan 2021 09:33:00 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA6983F66E;
        Tue, 26 Jan 2021 09:32:58 -0800 (PST)
Subject: Re: [PATCH v2 1/7] KVM: arm64: Fix missing RES1 in emulation of
 DBGBIDR
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com,
        Peter Maydell <peter.maydell@linaro.org>
References: <20210125122638.2947058-1-maz@kernel.org>
 <20210125122638.2947058-2-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <61c1954a-57b5-35c6-a18d-cb5a1aae6049@arm.com>
Date:   Tue, 26 Jan 2021 17:32:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210125122638.2947058-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

The patch looks correct to me. Just to be on the safe side, I had a look at how
the other fields are generated and they match the architecture:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

On 1/25/21 12:26 PM, Marc Zyngier wrote:
> The AArch32 CP14 DBGDIDR has bit 15 set to RES1, which our current
> emulation doesn't set. Just add the missing bit.
>
> Reported-by: Peter Maydell <peter.maydell@linaro.org>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 3313dedfa505..0c0832472c4a 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1711,7 +1711,7 @@ static bool trap_dbgidr(struct kvm_vcpu *vcpu,
>  		p->regval = ((((dfr >> ID_AA64DFR0_WRPS_SHIFT) & 0xf) << 28) |
>  			     (((dfr >> ID_AA64DFR0_BRPS_SHIFT) & 0xf) << 24) |
>  			     (((dfr >> ID_AA64DFR0_CTX_CMPS_SHIFT) & 0xf) << 20)
> -			     | (6 << 16) | (el3 << 14) | (el3 << 12));
> +			     | (6 << 16) | (1 << 15) | (el3 << 14) | (el3 << 12));
>  		return true;
>  	}
>  }
