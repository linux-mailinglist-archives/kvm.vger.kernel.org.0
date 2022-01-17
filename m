Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78701490B6C
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 16:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240482AbiAQPeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 10:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240483AbiAQPeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 10:34:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C30C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 07:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ej0IsrWC2wCxA4GIW5OMKhB0FwAJ2NYQgBUaHHkunbo=; b=uJpWH1J1AgCOxNMnBvjBDztsCB
        YUFV5BjRYvdGp/e56S5SISDl8nB7K3fys4fgmMeu66sbU0GOoXuvvWqbwQR7paXNHCzmyupYvHrYd
        eqzwjYptt9C+cvqpDFPSr1UMHJ2cIoNPquOcMo2asAJeDFejZA3WWrtJ91ZZ25z2L6RakKYkOQLZn
        hsQmFcSh2Pv4TWjFiTXdFQrBh6vGIpD+e7vcSlua1hMs3fK/++DJA1gRJW/FqW5Fi/6QMOtFexdGb
        jNUfnvRh2oLlYDCHNL78tGNYc1lhu54LF3gX4iiTN+lQAiUZOlBswS1dxvn9e8wY2cBWLYrc0iuf7
        kNhN05vA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56724)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9U1K-0002m7-DJ; Mon, 17 Jan 2022 15:34:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9U1C-0003Pv-V1; Mon, 17 Jan 2022 15:34:02 +0000
Date:   Mon, 17 Jan 2022 15:34:02 +0000
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
Subject: Re: [PATCH v5 02/69] KVM: arm64: Move pkvm's special 32bit handling
 into a generic infrastructure
Message-ID: <YeWMaj2shSMVXgAE@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-3-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:43PM +0000, Marc Zyngier wrote:
> diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> index c0e3fed26d93..d13115a12434 100644
> --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> @@ -233,7 +233,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm_vcpu *vcpu)
>   * Returns false if the guest ran in AArch32 when it shouldn't have, and
>   * thus should exit to the host, or true if a the guest run loop can continue.
>   */
> -static bool handle_aarch32_guest(struct kvm_vcpu *vcpu, u64 *exit_code)
> +static void early_exit_filter(struct kvm_vcpu *vcpu, u64 *exit_code)

The comment above this function needs fixing up - it talks about the
return value, but this patch changes the return type to be void.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
