Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860784A6349
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 19:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241824AbiBASMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 13:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241809AbiBASKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 13:10:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BB6C061749
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 10:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+bf43MZnan/HCENtniTD41UY434rYW0WKJuUBjs6a0s=; b=zGtjrKrtmYzyoKb62hxFk0ti+0
        2bCvlNm4hYUFNAWFPM0zymXH3TvEQt6Nky/vQflOSz7XASpsSf/Dr4P8nSF8QyM5PNeKchYeEMCWQ
        4ma+p7OiE1Fj1wEl5Cv2tf85LV/g/g4hRWyeSY3NBYrY7FOtiZka+gpxUkk6UPD6ameXHTPtqvUQs
        PkSxhATQZMKray0gW5j6kn2+qlrg2p6ekI9X+gzvUlAiir9kQf/COXgVxJd8gCno/N2bwb/L52oJd
        WdC6csx4+X37GybgrZq4QHjPZDd19yisjdT1Rx5CFXYaPBeBtdmxcDIwXfz8N2v6FY8K5G8yVV0VA
        UCp7emSA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56982)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nExaN-0000vh-8D; Tue, 01 Feb 2022 18:08:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nExaI-0002Gd-P8; Tue, 01 Feb 2022 18:08:54 +0000
Date:   Tue, 1 Feb 2022 18:08:54 +0000
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
Subject: Re: [PATCH v6 18/64] KVM: arm64: nv: Trap EL1 VM register accesses
 in virtual EL2
Message-ID: <Yfl3Nq4HydSakFS/@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-19-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-19-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 28, 2022 at 12:18:26PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> When running in virtual EL2 mode, we actually run the hardware in EL1
> and therefore have to use the EL1 registers to ensure correct operation.
> 
> By setting the HCR.TVM and HCR.TVRM we ensure that the virtual EL2 mode
> doesn't shoot itself in the foot when setting up what it believes to be
> a different mode's system register state (for example when preparing to
> switch to a VM).
> 
> We can leverage the existing sysregs infrastructure to support trapped
> accesses to these registers.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
