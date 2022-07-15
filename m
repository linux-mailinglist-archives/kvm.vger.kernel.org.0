Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51AA575F21
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 12:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiGOKIs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 06:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233854AbiGOKIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 06:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9673887C18
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 03:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DC80621FD
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 10:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A744C34115;
        Fri, 15 Jul 2022 10:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657879611;
        bh=N6XR6hU9xbp0IA+LXBFd/F2FgKNUufttOOOMm1SU3Q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UoNAH789eMR64DTe+ttG2yQlzTFq3gbMozTd8BkU/iLEoU6DysqkPwzEji9ast5bQ
         +EyNVkNAQuH5VsDSqSgPb66le8PeGAF7gW+OGytvi/C2qevoTGwAOO8zId7FzVCWEB
         QeFDU68BBgp+QuL/LJ+pBbdJrMoNXTmatnigdGgxZY1ExEJveZMdAEOgaMyGKoa4GL
         rrDj5GLL1bzu8BD7+m+AqcRK37dZwP/pATBmRYEWo2NY77fr7UtiZZOzGmVkmvHsS4
         KuTDioF+oeRADMGFOt+qRl+Pqoa/mF1YMH7zZuCBVUgHoKHDWpXOAnZdq7NGoyUFH0
         QBelhk+NsCh9w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oCIDh-007edL-Bz;
        Fri, 15 Jul 2022 11:06:49 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Add support for GICv2 on v3
Date:   Fri, 15 Jul 2022 11:06:46 +0100
Message-Id: <165787958336.3532416.361922683569453134.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220714154108.3531213-1-maz@kernel.org>
References: <20220714154108.3531213-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, alexandru.elisei@arm.com, ricarkol@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jul 2022 16:41:08 +0100, Marc Zyngier wrote:
> The current vgic_init test wrongly assumes that the host cannot
> multiple versions of the GIC architecture, while v2 emulation
> on v3 has almost always been supported (it was supported before
> the standalone v3 emulation).
> 
> Tweak the test to support multiple GIC incarnations.

Applied to next, thanks!

[1/1] KVM: arm64: selftests: Add support for GICv2 on v3
      commit: 6a4f7fcd750497cb2fa870f799e8b23270bec6e3

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

