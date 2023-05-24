Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1580270F6E5
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 14:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbjEXMuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 08:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234020AbjEXMuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 08:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B45191
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 05:49:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D71B63D09
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 12:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FA8C433D2;
        Wed, 24 May 2023 12:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684932592;
        bh=i/pALSACK00jme7nJY2ao5sElEqxR5OSYBsYtB/Ukcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/6Za7MDziW0WSQQF5nREo65zOu4kzq9ht5f/P8DXBjdDWjiKTyQ4jfr1ytuvDUb4
         2t+KOuv0bj8XXHZ+ElvVWZaLl3O5Kz8A4nXE7WWQNOGETGUi04O98YuX5X7uSdGQOz
         dHZfTTk2tolwO0aaUxXlNYkEWi2Cp6cp9Y3+1vkbEcJrn2fCdifHZq4k3ps9BbEHP9
         +ESrgU2rYGD6cB0xATiAx/jTpMq2kJ5d8RZFwPVyJecqeuEk8ykqxFTfkwQoLxM5JD
         sD8qxFMn3y9e9ajQNMNy0FouDUfd4FSCQR/4eWXfC826g99XD+V6IpmopoFFNvP8pD
         bjHDMuErA4F+g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q1nw5-0002Lh-Q7;
        Wed, 24 May 2023 13:49:49 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     steven.price@arm.com, Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] KVM: arm64: Handle MTE Set/Way CMOs
Date:   Wed, 24 May 2023 13:49:47 +0100
Message-Id: <168493254802.3630329.10412076653071886385.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515204601.1270428-1-maz@kernel.org>
References: <20230515204601.1270428-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, oliver.upton@linux.dev, suzuki.poulose@arm.com, yuzenghui@huawei.com, maz@kernel.org, steven.price@arm.com, catalin.marinas@arm.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 May 2023 21:45:59 +0100, Marc Zyngier wrote:
> When the MTE support was added, it seens the handling of MTE Set/Way
> was ommited, meaning that the guest will get an UNDEF if it tries to
> do something that is quite stupid, but still allowed by the
> architecture...
> 
> Found by inspection while writting the trap support for NV.
> 
> [...]

Applied to fixes, thanks!

[1/2] arm64: Add missing Set/Way CMO encodings
      commit: 8d0f019e4c4f2ee2de81efd9bf1c27e9fb3c0460
[2/2] KVM: arm64: Handle trap of tagged Set/Way CMOs
      commit: d282fa3c5ccb7a0029c418f358143689553b6447

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


