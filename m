Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F0F633D25
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 14:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbiKVNJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 08:09:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbiKVNJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 08:09:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38D2F67
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 05:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D512616FA
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 13:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827C3C433D7;
        Tue, 22 Nov 2022 13:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669122554;
        bh=mZekFvAisY9mUBqWWd0bwjJiX/SlXVpaaCucM2Y0WS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3R4Xpbd5WZfbTTRLbYGZVOUrle7yVmLCu+m1E3nRXz4yguazPyfJF9ybgVZJKbZn
         y71fIeFGGmLe6jmdqNQ5bt1pUPO9j5aZqerujKm47K+tzTw1ZNA9qP8EVIS2kHOKF7
         /RRUV8JkodiHvHahwISd5DUu5c4NEZmaZRsFlxFmy/ypoA0/VqsX8UVGi+KGilgKIF
         vwF2u56HHWgnjTFGi0qjf38osk2+vYiGIeh+uLZsLP+UNoANFznlDlTCXpWHrP6596
         eDmJQ+y5BuaNI8OhmOk3U/2GSffIY/7l3nfPe8M2f9OVZYK83j2Rdr/Mby5pNsSFbX
         kGdLjRNpdfJvg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oxT1T-007rg0-VZ;
        Tue, 22 Nov 2022 13:09:12 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/3] KVM: arm64: Fixes for parallel faults series
Date:   Tue, 22 Nov 2022 13:09:06 +0000
Message-Id: <166912253823.898154.3075564690086280701.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118182222.3932898-1-oliver.upton@linux.dev>
References: <20221118182222.3932898-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: james.morse@arm.com, oliver.upton@linux.dev, alexandru.elisei@arm.com, will@kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Nov 2022 18:22:19 +0000, Oliver Upton wrote:
> Small set of fixes for the parallel faults series. Most importantly,
> stop taking the RCU read lock for walking hyp stage-1. For the sake of
> consistency, take a pointer to kvm_pgtable_walker in
> kvm_dereference_pteref() as well.
> 
> Tested on an Ampere Altra system with kvm-arm.mode={nvhe,protected} and
> lockdep. Applies on top of the parallel faults series picked up last
> week.
> 
> [...]

Applied to next, thanks!

[1/3] KVM: arm64: Take a pointer to walker data in kvm_dereference_pteref()
      commit: 3a5154c723ba5ceb9ce374a7307e03263c03fd29
[2/3] KVM: arm64: Don't acquire RCU read lock for exclusive table walks
      commit: b7833bf202e3068abb77c642a0843f696e9c8d38
[3/3] KVM: arm64: Reject shared table walks in the hyp code
      commit: 5e806c5812e8012a83496cf96bdba266b3aec428

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


