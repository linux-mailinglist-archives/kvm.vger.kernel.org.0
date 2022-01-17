Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2D9490B7E
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240508AbiAQPgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240510AbiAQPgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 10:36:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C37C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 07:36:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6wdb+RSfOYtXVx2QzAjSPlhmXyeOp04Xz18+mlcDwiY=; b=MAi5evp5V1emr8iC5rBW99L0Kd
        aYrxpLT61TZn/0Hc2idjx6aGbcXjB3PM12uzncY/pc2UqCWXrlWPD54bsBLZUpu2v/9gL7VuTQOVk
        DKOcWU5DSOuqVfODoMdkJxx7aX8+O6ZZ8Q87Y0vJ9wu4N0c6VTEnXnw2g95Ild0pmFU/4WBMW9le7
        1WQyUuxf9N0hHDc5cp6RlfdkjIQf8piKdoz4bXZK3yX4jr9JAaKgMbxupaPq7mAE1zvrF4+tXAc7x
        RIxs5IhegTeFvFFnF6nVQzvlE+m7PpElvBZhBZrSAPcOY3yk1u4wQFlAM/hojf67GDw0PHlNrWwPj
        7RZkDfKg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56726)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9U3J-0002ma-F8; Mon, 17 Jan 2022 15:36:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9U3F-0003Q2-4W; Mon, 17 Jan 2022 15:36:09 +0000
Date:   Mon, 17 Jan 2022 15:36:09 +0000
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
Subject: Re: [PATCH v5 01/69] KVM: arm64: Save PSTATE early on exit
Message-ID: <YeWM6YtDpmy3BL2j@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-2-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:42PM +0000, Marc Zyngier wrote:
> In order to be able to use primitives such as vcpu_mode_is_32bit(),
> we need to synchronize the guest PSTATE. However, this is currently
> done deep into the bowels of the world-switch code, and we do have
> helpers evaluating this much earlier (__vgic_v3_perform_cpuif_access
> and handle_aarch32_guest, for example).
> 
> Move the saving of the guest pstate into the early fixups, which
> cures the first issue. The second one will be addressed separately.
> 
> Tested-by: Fuad Tabba <tabba@google.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
