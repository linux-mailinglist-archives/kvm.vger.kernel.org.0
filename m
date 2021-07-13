Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47493C7430
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbhGMQSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhGMQSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:18:38 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7323AC0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LQoPboS23ZJWmSVy61Mm/NOINFZejZIfzYMHAqlDOS0=; b=w/jsQrSI7bJ1ZrydFotmRErPM
        drc4eD9/xShHE8IkaqogtxmHN5jecAuKJe1hm1GnJxVZI+Khij+VACmFAts2xIJmVbR3YB7dWeQtB
        rAVxHNnrVUqg8xcQbgoZtOWF2WuPgAMssSGfm1kTR6/ZCoOvD1TPh0lXcVW9wQN4saPSvme4wD6c4
        IWhlSFvcCRZabQU6yLCEsX3+oSmROYeyyGEvCiZ6o+Sn1TclIMwaEC7OBz/LvArxRyJq2JjtkKXYG
        6ogFP2ohLPG23VtH/DfY1wn4GMrcPdgCqLuri45n/qazASEiOX9EifgyxP5LWYTsAcCqYMf1+wUo7
        tz0a/f/FQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46060)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m3L4T-0006Iy-PN; Tue, 13 Jul 2021 17:15:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m3L4S-0000SA-Fi; Tue, 13 Jul 2021 17:15:44 +0100
Date:   Tue, 13 Jul 2021 17:15:44 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>, kernel-team@android.com
Subject: Re: [PATCH 1/3] KVM: arm64: Narrow PMU sysreg reset values to
 architectural requirements
Message-ID: <20210713161544.GL22278@shell.armlinux.org.uk>
References: <20210713135900.1473057-1-maz@kernel.org>
 <20210713135900.1473057-2-maz@kernel.org>
 <20210713143949.GJ22278@shell.armlinux.org.uk>
 <87mtqq6w75.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtqq6w75.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 04:59:58PM +0100, Marc Zyngier wrote:
> On Tue, 13 Jul 2021 15:39:49 +0100,
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> > 
> > On Tue, Jul 13, 2021 at 02:58:58PM +0100, Marc Zyngier wrote:
> > > +static void reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
> > > +{
> > > +	u64 n, mask;
> > > +
> > > +	/* No PMU available, any PMU reg may UNDEF... */
> > > +	if (!kvm_arm_support_pmu_v3())
> > > +		return;
> > > +
> > > +	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> > > +	n &= ARMV8_PMU_PMCR_N_MASK;
> > > +
> > > +	reset_unknown(vcpu, r);
> > > +
> > > +	mask = BIT(ARMV8_PMU_CYCLE_IDX);
> > > +	if (n)
> > > +		mask |= GENMASK(n - 1, 0);
> > > +
> > > +	__vcpu_sys_reg(vcpu, r->reg) &= mask;
> > 
> > Would this read more logically to structure it as:
> > 
> > 	mask = BIT(ARMV8_PMU_CYCLE_IDX);
> > 
> > 	n = read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> > 	n &= ARMV8_PMU_PMCR_N_MASK;
> > 	if (n)
> > 		mask |= GENMASK(n - 1, 0);
> > 
> > 	reset_unknown(vcpu, r);
> > 	__vcpu_sys_reg(vcpu, r->reg) &= mask;
> > 
> > ?
> 
> Yup, that's nicer. Amended locally.

Thanks Marc.

For the whole series:

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
