Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE03563719
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 17:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiGAPlt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 11:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiGAPls (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 11:41:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18583FBF7
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 08:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C84DB83093
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 15:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50929C385A5;
        Fri,  1 Jul 2022 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656690103;
        bh=KtpcW/Ij79Xo4GJ+n802wbSYDEeHSXn8ShvdFzaWm2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExWPAZscdSHmU86zgOAGVKTzNkyQUySq20+/UNsDN9USyAVTM8wu1jjCUpZLK/keL
         nLrTYFXoN5kHae8RQY3w1XDTz9QbVlq6rav7d0/aFVyT9DGT7DCmEp28x/kx+xFs+K
         xrBPPQ27bApY2+pmIk3uAXygCVcAgdZMtcAyyyP+Vq7BP2T2jqwqLFYh5JysrAMlB1
         GAyR9wPucZeUb1S2SAaWViUGSVl3nzRdZ/SQiYE1FStGb9M0VMSUlfIe2RwIU+4Ukx
         Bao4AmQtPWJyO1ub6+8bXGRgPpAm3YYwFQjoR/pxDxteYq8PcBb4nSxrS+kzjZIRqN
         dr+pRI4mXdNiA==
From:   Will Deacon <will@kernel.org>
To:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andre Przywara <andre.przywara@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvmtool] arm: gic: fdt: fix PPI CPU mask calculation
Date:   Fri,  1 Jul 2022 16:41:25 +0100
Message-Id: <165668798833.3744902.12084627427900181326.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220616145526.3337196-1-andre.przywara@arm.com>
References: <20220616145526.3337196-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jun 2022 15:55:26 +0100, Andre Przywara wrote:
> The GICv2 DT binding describes the third cell in each interrupt
> descriptor as holding the trigger type, but also the CPU mask that this
> IRQ applies to, in bits [15:8]. However this is not the case for GICv3,
> where we don't use a CPU mask in the third cell: a simple mask wouldn't
> fit for the many more supported cores anyway.
> 
> At the moment we fill this CPU mask field regardless of the GIC type,
> for the PMU and arch timer DT nodes. This is not only the wrong thing to
> do in case of a GICv3, but also triggers UBSAN splats when using more
> than 30 cores, as we do shifting beyond what a u32 can hold:
> $ lkvm run -k Image -c 31 --pmu
> arm/timer.c:13:22: runtime error: left shift of 1 by 31 places cannot be represented in type 'int'
> arm/timer.c:13:38: runtime error: signed integer overflow: -2147483648 - 1 cannot be represented in type 'int'
> arm/timer.c:13:43: runtime error: left shift of 2147483647 by 8 places cannot be represented in type 'int'
> arm/aarch64/pmu.c:202:22: runtime error: left shift of 1 by 31 places cannot be represented in type 'int'
> arm/aarch64/pmu.c:202:38: runtime error: signed integer overflow: -2147483648 - 1 cannot be represented in type 'int'
> arm/aarch64/pmu.c:202:43: runtime error: left shift of 2147483647 by 8 places cannot be represented in type 'int'
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] arm: gic: fdt: fix PPI CPU mask calculation
      https://git.kernel.org/will/kvmtool/c/d9fdaad02dfd

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
