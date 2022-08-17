Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE5596C29
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 11:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbiHQJdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 05:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiHQJdo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 05:33:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A142CDCA
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 02:33:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C320FB81B73
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688E5C433C1;
        Wed, 17 Aug 2022 09:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660728820;
        bh=8W05Vg11+71pYOZwxRs2Q2L01sgUXY8xwN75MdQxdGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJzGYJd2+sXYIfFvHeub6vQvr2peqvmgb6DV1+U7bLJwkecH3ijh5UoCdFQG26LRQ
         CZ7UuKymsXIzRtmo2Kzo282VaBd70F+DHybYbWwZdTI6EhHW/ahesX62V+neTMIho2
         /vJzgpbAbaW1RsYC0vB7//54nZ55miCb9/UzolDQpF4OFXcHdb7y+RIH2WPKG8ESdB
         rNY2gWvUcZgKLf5TfF4ohNM/uvuondmCUDPj9PWTgk9HXkOvfZkGDchMWnbvDT1z0+
         jICXADqBn9I4FlPuxYASSoVOpUqAtczW/mJRYfQOu8+jV4aah9QPcnvOq4MyDUOPW+
         dyl6NYqZMcsfw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oOFQg-003hCO-4U;
        Wed, 17 Aug 2022 10:33:38 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Oliver Upton <oliver.upton@linux.dev>
Cc:     will@kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com
Subject: Re: [PATCH v2 0/2] KVM: arm64: Uphold 64bit-only behavior on asymmetric systems
Date:   Wed, 17 Aug 2022 10:33:35 +0100
Message-Id: <166072880531.274916.7682174772371767098.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220816192554.1455559-1-oliver.upton@linux.dev>
References: <20220816192554.1455559-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oliver.upton@linux.dev, will@kernel.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Aug 2022 19:25:52 +0000, Oliver Upton wrote:
> Small series to fix a couple issues around when 64bit-only behavior is
> applied. As KVM is more restrictive than the kernel in terms of 32bit
> support (no asymmetry), we really needed our own predicate when the
> meaning of system_supports_32bit_el0() changed in commit 2122a833316f
> ("arm64: Allow mismatched 32-bit EL0 support").
> 
> Lightly tested as I do not have any asymmetric systems on hand at the
> moment. Attention on patch 2 would be appreciated as it affects ABI.
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
      commit: f3c6efc72f3b20ec23566e768979802f0a398f04
[2/2] KVM: arm64: Reject 32bit user PSTATE on asymmetric systems
      commit: b10d86fb8e46cc812171728bcd326df2f34e9ed5

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

