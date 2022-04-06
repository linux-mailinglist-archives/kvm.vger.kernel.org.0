Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50424F6468
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiDFP63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbiDFP4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:56:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A94532688
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 06:22:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD0E4B823BC
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 13:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E9AC385A3;
        Wed,  6 Apr 2022 13:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649251345;
        bh=9k56kW2D3yicG0k9iNteeTEcYhgp9gswCX5undOXTec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h5RMe+y/iK5Bf8ceKwFEK8f3MKQ+MSL0H+2A+mmXgaUxv2GtFA0DsWYoCohjISAXc
         SkbwYe0gg4/a1Be7sRv6j8BBkGQh3/MIA6Nt6FGS05RsUtIsXvwU/a7XjbzJZIcbq9
         ZF0gAHFpVyYxBbXhukEB1oah7onpsMUp8szFmq3PYgejudzgEQ6f2tEsbNgoLAG1Rv
         BBroAqOZyZX3LuRMfCkMbnQO7U5K4aF3wuo++3GQEz8B+hTNTiGzEPLBuLboEzzZLS
         aeg0tI6kTD576yfnXwUPXwpDMAzHhWXPB0WK1AyRLH2oDgp5sU40OvGZSkrlS6Xx49
         1n2XyUCuJWqVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nc5c7-002AfM-Fu; Wed, 06 Apr 2022 14:22:23 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Peter Shier <pshier@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Jing Zhang <jingzhangos@google.com>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2] KVM: arm64: Don't split hugepages outside of MMU write lock
Date:   Wed,  6 Apr 2022 14:22:20 +0100
Message-Id: <164925133305.3716042.2193504931691635811.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401194652.950240-1-oupton@google.com>
References: <20220401194652.950240-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com, reijiw@google.com, alexandru.elisei@arm.com, pshier@google.com, linux-arm-kernel@lists.infradead.org, jingzhangos@google.com, kvm@vger.kernel.org, suzuki.poulose@arm.com, james.morse@arm.com, ricarkol@google.com
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

On Fri, 1 Apr 2022 19:46:52 +0000, Oliver Upton wrote:
> It is possible to take a stage-2 permission fault on a page larger than
> PAGE_SIZE. For example, when running a guest backed by 2M HugeTLB, KVM
> eagerly maps at the largest possible block size. When dirty logging is
> enabled on a memslot, KVM does *not* eagerly split these 2M stage-2
> mappings and instead clears the write bit on the pte.
> 
> Since dirty logging is always performed at PAGE_SIZE granularity, KVM
> lazily splits these 2M block mappings down to PAGE_SIZE in the stage-2
> fault handler. This operation must be done under the write lock. Since
> commit f783ef1c0e82 ("KVM: arm64: Add fast path to handle permission
> relaxation during dirty logging"), the stage-2 fault handler
> conditionally takes the read lock on permission faults with dirty
> logging enabled. To that end, it is possible to split a 2M block mapping
> while only holding the read lock.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Don't split hugepages outside of MMU write lock
      commit: f587661f21eb9a38af52488bbe54ce61a64dfae8

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


