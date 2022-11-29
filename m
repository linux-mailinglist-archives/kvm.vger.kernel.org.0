Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE3C63BD03
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 10:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbiK2JeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 04:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiK2Jd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 04:33:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DF92AE2B
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 01:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E7FA61628
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 09:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7284C433B5;
        Tue, 29 Nov 2022 09:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669714436;
        bh=ytWdPWoB0JLE0rRUZJi+OM1M3Tzfp92cT1vL1sIg8v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6JH88oo4vC9v6ACmJS+9+NyoNhLVThp44OSn2zWEDbHiPU3tjy1NGI88c8Dik4+s
         e4LJ+fJz5twYy0FB0LwIDXO6T8xb5xDJHIBMcReDOSfTVwWYO8kc4czV9/2MH8MF4c
         8d3gi8ruxhHrgakpzA2JlUCDxGOTd7c9IO1DBJri9COdFMeTLh1Z+8+LmPFprlZxcR
         NR2+RynL7ufl+FiGNkikBmb1GYoqydCm/hfbe2kct7f+fk8e4xOf6W/xqlBTo8mbrx
         HYqaCIxCDd3Rv+6ltHolWJc9bOv09NJa9IP3Wo/Fw86SBdIRXkeILgagnYbAJOZqec
         mi7n0Ux4LNybg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ozwzy-009Jpu-AB;
        Tue, 29 Nov 2022 09:33:54 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Peter Collingbourne <pcc@google.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-mm <linux-mm@kvack.org>
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 0/8] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
Date:   Tue, 29 Nov 2022 09:33:51 +0000
Message-Id: <166971432264.1905185.15808052624158484529.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
References: <20221104011041.290951-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pcc@google.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, steven.price@arm.com, catalin.marinas@arm.com, eugenis@google.com, cohuck@redhat.com, kvm@vger.kernel.org, vincenzo.frascino@arm.com, will@kernel.org
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

On Thu, 3 Nov 2022 18:10:33 -0700, Peter Collingbourne wrote:
> This patch series allows VMMs to use shared mappings in MTE enabled
> guests. The first five patches were taken from Catalin's tree [1] which
> addressed some review feedback from when they were previously sent out
> as v3 of this series. The first patch from Catalin's tree makes room
> for an additional PG_arch_3 flag by making the newer PG_arch_* flags
> arch-dependent. The next four patches are based on a series that
> Catalin sent out prior to v3, whose cover letter [2] I quote from below:
> 
> [...]

No feedback has been received, so this code is obviously perfect.

Applied to next, thanks!

[1/8] mm: Do not enable PG_arch_2 for all 64-bit architectures
      commit: b0284cd29a957e62d60c2886fd663be93c56f9c0
[2/8] arm64: mte: Fix/clarify the PG_mte_tagged semantics
      commit: e059853d14ca4ed0f6a190d7109487918a22a976
[3/8] KVM: arm64: Simplify the sanitise_mte_tags() logic
      commit: 2dbf12ae132cc78048615cfa19c9be64baaf0ced
[4/8] mm: Add PG_arch_3 page flag
      commit: ef6458b1b6ca3fdb991ce4182e981a88d4c58c0f
[5/8] arm64: mte: Lock a page for MTE tag initialisation
      commit: d77e59a8fccde7fb5dd8c57594ed147b4291c970
[6/8] KVM: arm64: unify the tests for VMAs in memslots when MTE is enabled
      commit: d89585fbb30869011b326ef26c94c3137d228df9
[7/8] KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE enabled
      commit: c911f0d4687947915f04024aa01803247fcf7f1a
[8/8] Documentation: document the ABI changes for KVM_CAP_ARM_MTE
      commit: a4baf8d2639f24d4d31983ff67c01878e7a5393f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


