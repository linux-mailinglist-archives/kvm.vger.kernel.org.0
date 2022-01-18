Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C103D4929E2
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 16:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346025AbiARPvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 10:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233324AbiARPvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 10:51:38 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7BEC061574
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 07:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=94ZQXWCY7fYDU0Qojps0SAMw026kGgIGVDyTCVVAHwg=; b=paFN6dnNi2hCRj15qqS1y35ChM
        xCzo3dA3mWI2DN8Mbp+cI0YTsvHhLJoLswLNpSNZJ56K64TDk/6GLvGknGp+Gj8DPfUaysNM7ab3s
        io1BtEWxnMQTJMyKvJ/GMWe61M/XhfJ6lTvqtOU9n5oGs9EIy2yEDDru/sgQHT2g5LtysJpHvnoWA
        gSSf9G6XlDd1B0P//5Wca6wi7BS9COEk2DtLyvZvoIDg9sID3+rQGzVmFRyqMq/gu+BKWW3fQbe1r
        OQgKEF8yQpza3twf+QhM67wL9usVYpN7wVDZPd8jYyP4UsnB/1bwS2GYkR4A58rx1Nf3LPW2aY3CK
        J7+q2exw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56760)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9qlh-0003w1-1m; Tue, 18 Jan 2022 15:51:33 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9qle-0004Pi-TT; Tue, 18 Jan 2022 15:51:30 +0000
Date:   Tue, 18 Jan 2022 15:51:30 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v5 12/69] KVM: arm64: nv: Handle HCR_EL2.NV system
 register traps
Message-ID: <YebiAjUTzVECLOun@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-13-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-13-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:53PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> ARM v8.3 introduces a new bit in the HCR_EL2, which is the NV bit. When
> this bit is set, accessing EL2 registers in EL1 traps to EL2. In
> addition, executing the following instructions in EL1 will trap to EL2:
> tlbi, at, eret, and msr/mrs instructions to access SP_EL1. Most of the
> instructions that trap to EL2 with the NV bit were undef at EL1 prior to
> ARM v8.3. The only instruction that was not undef is eret.
> 
> This patch sets up a handler for EL2 registers and SP_EL1 register
> accesses at EL1. The host hypervisor keeps those register values in
> memory, and will emulate their behavior.
> 
> This patch doesn't set the NV bit yet. It will be set in a later patch
> once nested virtualization support is completed.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: added SCTLR_EL2 RES0/RES1 handling]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
...
> @@ -1825,9 +1882,51 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ PMU_SYS_REG(SYS_PMCCFILTR_EL0), .access = access_pmu_evtyper,
>  	  .reset = reset_val, .reg = PMCCFILTR_EL0, .val = 0 },
>  
> +	{ SYS_DESC(SYS_VPIDR_EL2), access_rw, reset_val, VPIDR_EL2, 0 },
> +	{ SYS_DESC(SYS_VMPIDR_EL2), access_rw, reset_val, VMPIDR_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_SCTLR_EL2), access_sctlr_el2, reset_val, SCTLR_EL2, SCTLR_EL2_RES1 },
> +	{ SYS_DESC(SYS_ACTLR_EL2), access_rw, reset_val, ACTLR_EL2, 0 },
> +	{ SYS_DESC(SYS_HCR_EL2), access_rw, reset_val, HCR_EL2, 0 },
> +	{ SYS_DESC(SYS_MDCR_EL2), access_rw, reset_val, MDCR_EL2, 0 },
> +	{ SYS_DESC(SYS_CPTR_EL2), access_rw, reset_val, CPTR_EL2, CPTR_EL2_DEFAULT },
> +	{ SYS_DESC(SYS_HSTR_EL2), access_rw, reset_val, HSTR_EL2, 0 },
> +	{ SYS_DESC(SYS_HACR_EL2), access_rw, reset_val, HACR_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_TTBR0_EL2), access_rw, reset_val, TTBR0_EL2, 0 },
> +	{ SYS_DESC(SYS_TTBR1_EL2), access_rw, reset_val, TTBR1_EL2, 0 },
> +	{ SYS_DESC(SYS_TCR_EL2), access_rw, reset_val, TCR_EL2, TCR_EL2_RES1 },
> +	{ SYS_DESC(SYS_VTTBR_EL2), access_rw, reset_val, VTTBR_EL2, 0 },
> +	{ SYS_DESC(SYS_VTCR_EL2), access_rw, reset_val, VTCR_EL2, 0 },
> +
>  	{ SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
> +	{ SYS_DESC(SYS_SPSR_EL2), access_rw, reset_val, SPSR_EL2, 0 },
> +	{ SYS_DESC(SYS_ELR_EL2), access_rw, reset_val, ELR_EL2, 0 },
> +	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
> +
>  	{ SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
> +	{ SYS_DESC(SYS_AFSR0_EL2), access_rw, reset_val, AFSR0_EL2, 0 },
> +	{ SYS_DESC(SYS_AFSR1_EL2), access_rw, reset_val, AFSR1_EL2, 0 },
> +	{ SYS_DESC(SYS_ESR_EL2), access_rw, reset_val, ESR_EL2, 0 },
>  	{ SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
> +
> +	{ SYS_DESC(SYS_FAR_EL2), access_rw, reset_val, FAR_EL2, 0 },
> +	{ SYS_DESC(SYS_HPFAR_EL2), access_rw, reset_val, HPFAR_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_MAIR_EL2), access_rw, reset_val, MAIR_EL2, 0 },
> +	{ SYS_DESC(SYS_AMAIR_EL2), access_rw, reset_val, AMAIR_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_VBAR_EL2), access_rw, reset_val, VBAR_EL2, 0 },
> +	{ SYS_DESC(SYS_RVBAR_EL2), access_rw, reset_val, RVBAR_EL2, 0 },
> +	{ SYS_DESC(SYS_RMR_EL2), trap_undef },
> +
> +	{ SYS_DESC(SYS_CONTEXTIDR_EL2), access_rw, reset_val, CONTEXTIDR_EL2, 0 },
> +	{ SYS_DESC(SYS_TPIDR_EL2), access_rw, reset_val, TPIDR_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_CNTVOFF_EL2), access_rw, reset_val, CNTVOFF_EL2, 0 },
> +	{ SYS_DESC(SYS_CNTHCTL_EL2), access_rw, reset_val, CNTHCTL_EL2, 0 },
> +
> +	{ SYS_DESC(SYS_SP_EL2), NULL, reset_unknown, SP_EL2 },

Doesn't this have an effect on the ability to migrate guests between
identical hardware but running kernels with vs without this patch?
From what I remember, QEMU fails a migration if the migration target
has less system registers than the migration source.

If so, this should at the very least be spelt out in the commit
message - it's a user experience breaking change. Maybe also preventing
the exposure of these when NV is disabled would be a good idea?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
