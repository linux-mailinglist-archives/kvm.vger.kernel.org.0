Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EA5490BAB
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240612AbiAQPnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiAQPnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 10:43:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DF2C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 07:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ht/XA4o6M7ptrMuQobE80T6P+r3p1d2fY/4emv7Mr6k=; b=gd+XESqH9MGjUcSRFv5QXODHDT
        9/s7SutHqkcuxPN5qijjYFs8D9zkKUxBVYGT9H7PbFND/lmSC9+YgPlp4/wyhZATtgD3Wp2y2c8vI
        lHbIBE9fVA1vQDM7uTPXPWSxo5cO2m+Qd5i/NDziUFyyEmRVmkrJ2VeF6PYMpvQB9iMmTGjLYAZO5
        IMh14SDuLbvQhaC4V79iTt2YaJZxmwtASION1qMdin2GEuAbsqzFuz8/ivF4iLwcWVeQAzD1zlxCn
        yfNisfnN08qjnztVYWYpSOgtEZspfzgWb8QJA51Phk3EBIXviWOz5Alg7y8qXzSfAiGQfUv2fXxn9
        PxJzDqsA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56730)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9UAW-0002nl-NM; Mon, 17 Jan 2022 15:43:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9UAQ-0003RO-UA; Mon, 17 Jan 2022 15:43:34 +0000
Date:   Mon, 17 Jan 2022 15:43:34 +0000
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
Subject: Re: [PATCH v5 04/69] KVM: arm64: Rework kvm_pgtable initialisation
Message-ID: <YeWOpnGxlRC4mCip@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-5-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:45PM +0000, Marc Zyngier wrote:
> Ganapatrao reported that the kvm_pgtable->mmu pointer is more or
> less hardcoded to the main S2 mmu structure, while the nested
> code needs it to point to other instances (as we have one instance
> per nested context).
> 
> Rework the initialisation of the kvm_pgtable structure so that
> this assumtion doesn't hold true anymore. This requires some
> minor changes to the order in which things are initialised
> (the mmu->arch pointer being the critical one).
> 
> Reported-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Looks fairly simple.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
