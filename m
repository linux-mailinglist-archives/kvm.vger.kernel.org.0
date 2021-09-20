Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087A3411207
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 11:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhITJq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 05:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhITJq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 05:46:58 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4038C061574
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 02:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6WKcFj8KH5zmE3aTXCP6zwGUN8VgQpUtcVDHRQZ/pkI=; b=noZDo68Icsx4e76vM0o8uY9xWS
        tYFfDr0W4AgOEUQqoEChkEhZ7JiQ4i3H9lsLYGA310nQdTlsUeLroa11nZV+a9gy6QGVe2kW51e7x
        iDL3X97EpnhI4k4S/lpPy/yvOwEj3dz8539te0Pcr0T7pleb+XOL9mZAVZVZId9Bs34ggUzdN30uX
        g6sut84PQ6HGiI9yu867yks+CTNFrfydDOFzf5/TNsn2wkQWJ/74hCunVRQ1rlM1JqCtcDn2POQYB
        oqHwwxp9BoNDKO9i83dSzQmh8Ep/7tD2Y9C34oqZNSmv73VYuj+Hs9TmN4j9z0xGkXGNa0haAfkNO
        PArPtLWg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54662)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mSFrb-0001T7-S1; Mon, 20 Sep 2021 10:45:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mSFra-0002Bu-8S; Mon, 20 Sep 2021 10:45:26 +0100
Date:   Mon, 20 Sep 2021 10:45:26 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: REGRESSION: Upgrading host kernel from 5.11 to 5.13 breaks QEMU
 guests - perf/fw_devlink/kvm
Message-ID: <YUhYNnwaTt+5oMzh@shell.armlinux.org.uk>
References: <YUYRKVflRtUytzy5@shell.armlinux.org.uk>
 <877dfcwutt.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dfcwutt.wl-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:36:46PM +0100, Marc Zyngier wrote:
> Urgh. That's a bummer. T1he PMU driver only comes up once it has found
> its interrupt controller, which on the Armada 8040 is not the GIC, but
> some weird thing on the side that doesn't actually serve any real
> purpose. On HW where the PMU is directly wired into the GIC, it all
> works fine, though by luck rather than by design.
> 
> Anyway, rant over. This is a bug that needs addressing so that KVM can
> initialise correctly irrespective of the probing order. This probably
> means that the static key controlling KVM's behaviour wrt the PMU must
> be controlled by the PMU infrastructure itself, rather than KVM trying
> to probe for it.
> 
> Can you please give the following hack a go (on top of 5.15-rc1)? I've
> briefly tested it on my McBin, and it did the trick. I've also tested
> it on the M1 (which really doesn't have an architectural PMU) to
> verify that it was correctly failing.

My test program that derives the number of registers qemu uses now
reports 236 registers again and I see:

kvm [7]: PMU detected and enabled

in the kernel boot log.

Tested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
