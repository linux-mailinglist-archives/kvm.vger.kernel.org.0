Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014ED75909F
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 10:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjGSIt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 04:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjGSItR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 04:49:17 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E50172115
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 01:48:55 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E44E42F4;
        Wed, 19 Jul 2023 01:49:38 -0700 (PDT)
Received: from [10.57.33.122] (unknown [10.57.33.122])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1281B3F67D;
        Wed, 19 Jul 2023 01:48:52 -0700 (PDT)
Message-ID: <4df25be4-d060-337e-f5b7-f7a13f0df85e@arm.com>
Date:   Wed, 19 Jul 2023 09:48:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 06/27] arm64: Add debug registers affected by HDFGxTR_EL2
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-7-maz@kernel.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230712145810.3864793-7-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/07/2023 15:57, Marc Zyngier wrote:
> The HDFGxTR_EL2 registers trap a (huge) set of debug and trace
> related registers. Add their encodings (and only that, because
> we really don't care about what these registers actually do at
> this stage).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   arch/arm64/include/asm/sysreg.h | 78 +++++++++++++++++++++++++++++++++
>   1 file changed, 78 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 76289339b43b..9dfd127be55a 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -194,6 +194,84 @@
>   #define SYS_DBGDTRTX_EL0		sys_reg(2, 3, 0, 5, 0)
>   #define SYS_DBGVCR32_EL2		sys_reg(2, 4, 0, 7, 0)
>   
> +#define SYS_BRBINF_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 0))
> +#define SYS_BRBINFINJ_EL1		sys_reg(2, 1, 9, 1, 0)
> +#define SYS_BRBSRC_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 1))
> +#define SYS_BRBSRCINJ_EL1		sys_reg(2, 1, 9, 1, 1)
> +#define SYS_BRBTGT_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 2))
> +#define SYS_BRBTGTINJ_EL1		sys_reg(2, 1, 9, 1, 2)
> +#define SYS_BRBTS_EL1			sys_reg(2, 1, 9, 0, 2)
> +
> +#define SYS_BRBCR_EL1			sys_reg(2, 1, 9, 0, 0)
> +#define SYS_BRBFCR_EL1			sys_reg(2, 1, 9, 0, 1)
> +#define SYS_BRBIDR0_EL1			sys_reg(2, 1, 9, 2, 0)
> +
> +#define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
> +#define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
> +#define SYS_TRCACATR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (2 | (m >> 3)))
> +#define SYS_TRCACVR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (0 | (m >> 3)))
> +#define SYS_TRCAUTHSTATUS		sys_reg(2, 1, 7, 14, 6)
> +#define SYS_TRCAUXCTLR			sys_reg(2, 1, 0, 6, 0)
> +#define SYS_TRCBBCTLR			sys_reg(2, 1, 0, 15, 0)
> +#define SYS_TRCCCCTLR			sys_reg(2, 1, 0, 14, 0)
> +#define SYS_TRCCIDCCTLR0		sys_reg(2, 1, 3, 0, 2)
> +#define SYS_TRCCIDCCTLR1		sys_reg(2, 1, 3, 1, 2)
> +#define SYS_TRCCIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 0)
> +#define SYS_TRCCLAIMCLR			sys_reg(2, 1, 7, 9, 6)
> +#define SYS_TRCCLAIMSET			sys_reg(2, 1, 7, 8, 6)
> +#define SYS_TRCCNTCTLR(m)		sys_reg(2, 1, 0, (4 | (m & 3)), 5)
> +#define SYS_TRCCNTRLDVR(m)		sys_reg(2, 1, 0, (0 | (m & 3)), 5)
> +#define SYS_TRCCNTVR(m)			sys_reg(2, 1, 0, (8 | (m & 3)), 5)
> +#define SYS_TRCCONFIGR			sys_reg(2, 1, 0, 4, 0)
> +#define SYS_TRCDEVARCH			sys_reg(2, 1, 7, 15, 6)
> +#define SYS_TRCDEVID			sys_reg(2, 1, 7, 2, 7)
> +#define SYS_TRCEVENTCTL0R		sys_reg(2, 1, 0, 8, 0)
> +#define SYS_TRCEVENTCTL1R		sys_reg(2, 1, 0, 9, 0)
> +#define SYS_TRCEXTINSELR(m)		sys_reg(2, 1, 0, (8 | (m & 3)), 4)
> +#define SYS_TRCIDR0			sys_reg(2, 1, 0, 8, 7)
> +#define SYS_TRCIDR10			sys_reg(2, 1, 0, 2, 6)
> +#define SYS_TRCIDR11			sys_reg(2, 1, 0, 3, 6)
> +#define SYS_TRCIDR12			sys_reg(2, 1, 0, 4, 6)
> +#define SYS_TRCIDR13			sys_reg(2, 1, 0, 5, 6)
> +#define SYS_TRCIDR1			sys_reg(2, 1, 0, 9, 7)
> +#define SYS_TRCIDR2			sys_reg(2, 1, 0, 10, 7)
> +#define SYS_TRCIDR3			sys_reg(2, 1, 0, 11, 7)
> +#define SYS_TRCIDR4			sys_reg(2, 1, 0, 12, 7)
> +#define SYS_TRCIDR5			sys_reg(2, 1, 0, 13, 7)
> +#define SYS_TRCIDR6			sys_reg(2, 1, 0, 14, 7)
> +#define SYS_TRCIDR7			sys_reg(2, 1, 0, 15, 7)
> +#define SYS_TRCIDR8			sys_reg(2, 1, 0, 0, 6)
> +#define SYS_TRCIDR9			sys_reg(2, 1, 0, 1, 6)
> +#define SYS_TRCIMSPEC0			sys_reg(2, 1, 0, 0, 7)
> +#define SYS_TRCIMSPEC(m)		sys_reg(2, 1, 0, (m & 7), 7)
> +#define SYS_TRCITEEDCR			sys_reg(2, 1, 0, 2, 1)
> +#define SYS_TRCOSLSR			sys_reg(2, 1, 1, 1, 4)
> +#define SYS_TRCPRGCTLR			sys_reg(2, 1, 0, 1, 0)
> +#define SYS_TRCQCTLR			sys_reg(2, 1, 0, 1, 1)
> +#define SYS_TRCRSCTLR(m)		sys_reg(2, 1, 1, (m & 15), (0 | (m >> 4)))
> +#define SYS_TRCRSR			sys_reg(2, 1, 0, 10, 0)
> +#define SYS_TRCSEQEVR(m)		sys_reg(2, 1, 0, (m & 3), 4)
> +#define SYS_TRCSEQRSTEVR		sys_reg(2, 1, 0, 6, 4)
> +#define SYS_TRCSEQSTR			sys_reg(2, 1, 0, 7, 4)
> +#define SYS_TRCSSCCR(m)			sys_reg(2, 1, 1, (m & 7), 2)
> +#define SYS_TRCSSCSR(m)			sys_reg(2, 1, 1, (8 | (m & 7)), 2)
> +#define SYS_TRCSSPCICR(m)		sys_reg(2, 1, 1, (m & 7), 3)
> +#define SYS_TRCSTALLCTLR		sys_reg(2, 1, 0, 11, 0)
> +#define SYS_TRCSTATR			sys_reg(2, 1, 0, 3, 0)
> +#define SYS_TRCSYNCPR			sys_reg(2, 1, 0, 13, 0)
> +#define SYS_TRCTRACEIDR			sys_reg(2, 1, 0, 0, 1)
> +#define SYS_TRCTSCTLR			sys_reg(2, 1, 0, 12, 0)
> +#define SYS_TRCVICTLR			sys_reg(2, 1, 0, 0, 2)
> +#define SYS_TRCVIIECTLR			sys_reg(2, 1, 0, 1, 2)
> +#define SYS_TRCVIPCSSCTLR		sys_reg(2, 1, 0, 3, 2)
> +#define SYS_TRCVISSCTLR			sys_reg(2, 1, 0, 2, 2)
> +#define SYS_TRCVMIDCCTLR0		sys_reg(2, 1, 3, 2, 2)
> +#define SYS_TRCVMIDCCTLR1		sys_reg(2, 1, 3, 3, 2)
> +#define SYS_TRCVMIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 1)
> +
> +/* ETM */
> +#define SYS_TRCOSLAR			sys_reg(2, 1, 1, 0, 4)

For all ETM Trace related registers. I compared them with the list
we have in ETM/ETE driver and used a script to generate sys_reg encoding
from the macros we have (which consumes an MMIO offset). The list
covers the registers accessible only via system instructions
and the encodings match.

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

