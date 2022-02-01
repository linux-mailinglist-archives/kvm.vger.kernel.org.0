Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94B364A617A
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 17:41:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbiBAQlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 11:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiBAQlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 11:41:04 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE8EC061714
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 08:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HaziVY/a7m42PwyMJxtHd5zkrN+5LX7dG2VEEOfmAqg=; b=jEMqOTHm3CVGHftsZwSu7s1bqd
        /LynMcTK3qzAh6vTH5VK/P0G/OcfxZVrV5YDR1xi/h+8Jy7KSSX9BPJ6dMFC6ehBLtcORNPsq+s51
        nXs5eBcqe13nzZcgegqrb4zzRn0cUG8j4Seeb/tYu7px4Bm6DK4xiwjxIB+yrm53ppSZyorZ2URlj
        LsuEvOJPxjWheGohQi2osBkm9S/y4v0S0vexSU2/8H+od5rgpnkBXrJj3dJUyF8e9c5FyfGmn1IjJ
        dkRmp/jWQOrDpz00xyrcNq/vBruZ0+XF4wG9vuKwjVY+LK0N4qici7+6KlJMyK27ktFG0bph9ytFC
        2YesVPyQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56970)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nEwD9-0000p2-Mo; Tue, 01 Feb 2022 16:40:55 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nEwD5-0002E0-2B; Tue, 01 Feb 2022 16:40:51 +0000
Date:   Tue, 1 Feb 2022 16:40:51 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 13/64] KVM: arm64: nv: Handle virtual EL2 registers in
 vcpu_read/write_sys_reg()
Message-ID: <Yflik8gWKjGDeim1@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-14-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-14-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 28, 2022 at 12:18:21PM +0000, Marc Zyngier wrote:
> KVM internally uses accessor functions when reading or writing the
> guest's system registers. This takes care of accessing either the stored
> copy or using the "live" EL1 system registers when the host uses VHE.
> 
> With the introduction of virtual EL2 we add a bunch of EL2 system
> registers, which now must also be taken care of:
> - If the guest is running in vEL2, and we access an EL1 sysreg, we must
>   revert to the stored version of that, and not use the CPU's copy.
> - If the guest is running in vEL1, and we access an EL2 sysreg, we must
>   also use the stored version, since the CPU carries the EL1 copy.
> - Some EL2 system registers are supposed to affect the current execution
>   of the system, so we need to put them into their respective EL1
>   counterparts. For this we need to define a mapping between the two.
>   This is done using the newly introduced struct el2_sysreg_map.
> - Some EL2 system registers have a different format than their EL1
>   counterpart, so we need to translate them before writing them to the
>   CPU. This is done using an (optional) translate function in the map.
> - There are the three special registers SP_EL2, SPSR_EL2 and ELR_EL2,
>   which need some separate handling (SPSR_EL2 is being handled in a
>   separate patch).
> 
> All of these cases are now wrapped into the existing accessor functions,
> so KVM users wouldn't need to care whether they access EL2 or EL1
> registers and also which state the guest is in.
> 
> This handles what was formerly known as the "shadow state" dynamically,
> without requiring a separate copy for each vCPU EL.
> 
> Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Co-developed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
