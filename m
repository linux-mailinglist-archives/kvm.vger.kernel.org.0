Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8275F88B8
	for <lists+kvm@lfdr.de>; Sun,  9 Oct 2022 03:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJIBhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Oct 2022 21:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiJIBg7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Oct 2022 21:36:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53492AE29
        for <kvm@vger.kernel.org>; Sat,  8 Oct 2022 18:36:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3629F60A39
        for <kvm@vger.kernel.org>; Sun,  9 Oct 2022 01:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C74EC433C1;
        Sun,  9 Oct 2022 01:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665279417;
        bh=HGJvbxw2MJ35hMazorht+KBKpy2FAeCse4OJqWityt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aR30/763frgO+vBid7LTGeYm+ND9XQJkz46/DA51ViZ4gXaDskcjfFLltR5iHNtw/
         bgv6FWRxBLkcJpk4GitRRpVzpJwiXDTO6CAWe1mDlpz+zxFZ8jPPIWHbg0DfmJGjSL
         /fR3dPxfAP6f/mo7IAsXpSmtvQZMvbeaTzsh9+5VgwnQXTQgp/R/VrGETsL3caoxBk
         1Vje6eWjnV3est3j0AByvLHVNwjrYwCKvEVZNfbPmnBKRb2oT3a9H8QVUyz2Q4kUtL
         0zg3LhkBXaxpNeXpZo9x8AJrOFXY0R7W9SbNe07fFMaOlqVNoyouONMPdS+IzG5Tdo
         t/HrXEOu2wpeg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ohLFP-00FKtd-98;
        Sun, 09 Oct 2022 02:36:55 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v3 0/2] KVM: arm64: Limit stage2_apply_range() batch size to largest block
Date:   Sun,  9 Oct 2022 02:36:43 +0100
Message-Id: <166527939508.254377.2666573949746347209.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221007234151.461779-1-oliver.upton@linux.dev>
References: <20221007234151.461779-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, james.morse@arm.com, oliver.upton@linux.dev, kvm@vger.kernel.org, ricarkol@google.com, dmatlack@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, qperret@google.com
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

On Fri, 7 Oct 2022 23:41:49 +0000, Oliver Upton wrote:
> Continuing with MMU patches to post, a small series fixing some soft
> lockups caused by stage2_apply_range(). Depending on the paging setup,
> we could walk a very large amount of memory before dropping the lock and
> rescheduling.
> 
> Applies to kvmarm-6.1. Tested with KVM selftests and kvm-unit-tests with
> all supported page sizes (4K, 16K, 64K). Additionally, I no longer saw
> soft lockups with the following:
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Work out supported block level at compile time
      commit: 3b5c082bbfa20d9a57924edd655bbe63fe98ab06
[2/2] KVM: arm64: Limit stage2_apply_range() batch size to largest block
      commit: 5994bc9e05c2f8811f233aa434e391cd2783f0f5

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


