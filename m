Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B435621AE3
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 18:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiKHRjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 12:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234558AbiKHRjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 12:39:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D3E4FFB7
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 09:39:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8712161702
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 17:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E114C433C1;
        Tue,  8 Nov 2022 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667929153;
        bh=z1qKeQ+cE5vnV96AX3J/pSROl+r3AEqJG3/eU/eWrLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o3aOg/68JDZYcWhumm4WEvNH+uKVKWjbQBB6P1usFKpaNUN+MdgA3q+xn3L0yX5/w
         aCE38/oxqWs+tJT02RO+0tp3anjymnZlR0RvyxpFj5IiQjO2wLYk6SaMxNAg52cVCv
         ZbbIrMuCHG3vcyQE5bxVVY07rrYI82XQyeLXyy5+c9Vyrfw2gqvA1jn7zjGoQYEyuT
         VuiESDoMu/aS8Tsvsa8jVkmc3fQv5ud4HGuIfGgiboI0PQ5LYP/G7UoLVdCfL2giYL
         CWMl1cTHMKmKRgDfKvEAvep5U6qPN7qeEK5yda86Zjl/QNEOxSjYtmkAKm+MyicSTV
         b8KI7KsTaA86A==
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, andre.przywara@arm.com,
        alexandru.elisei@arm.com, kvm@vger.kernel.org,
        Pierre Gondois <pierre.gondois@arm.com>
Subject: Re: [PATCH kvmtool v2] pci: Disable writes to Status register
Date:   Tue,  8 Nov 2022 17:38:46 +0000
Message-Id: <166792148262.1914557.17127027491095744369.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221020173452.203043-1-jean-philippe@linaro.org>
References: <20221020173452.203043-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Oct 2022 18:34:53 +0100, Jean-Philippe Brucker wrote:
> Although the PCI Status register only contains read-only and
> write-1-to-clear bits, we currently keep anything written there, which
> can confuse a guest.
> 
> The problem was highlighted by recent Linux commit 6cd514e58f12 ("PCI:
> Clear PCI_STATUS when setting up device"), which unconditionally writes
> 0xffff to the Status register in order to clear pending errors. Then the
> EDAC driver sees the parity status bits set and attempts to clear them
> by writing 0xc100, which in turn clears the Capabilities List bit.
> Later on, when the virtio-pci driver starts probing, it assumes due to
> missing capabilities that the device is using the legacy transport, and
> fails to setup the device because of mismatched protocol.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] pci: Disable writes to Status register
      https://git.kernel.org/will/kvmtool/c/78771e779a3a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
