Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D049655FCB4
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 11:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbiF2J7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 05:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbiF2J7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 05:59:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEF13BA7B
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 02:59:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA91161EAF
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 09:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CF9C34114;
        Wed, 29 Jun 2022 09:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656496741;
        bh=nY7o6DVvZ1bAaRA8HXKQAmY4gSEE88K0s1E72bjMaY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGNtKI9mPFmXhyYZUIreeQ/5jujAqtlde9QCb2FMmrH3bt/rvRPATrbgXa5zVSQYw
         w+gug1eogD7fa+n9Yt2Bu/Ip+QZgtxX/oFiN0XYQ89iHKUx4iNJC3mIwqZ9tbl5ahn
         u5Qr1nC4tMPaWWKiI+yjO2u4isWrVzwbIYCDWmzNelnkpKkiGgtKj9JyMNvo2GwFsP
         b7ho/q+kA3NIGXPjnp/xIfjmHzBFfnPejjUOK62fwbsPB+fBSgfBIm0xbo0p7et7Ce
         ioncavBYUf1V/j4Zq/bE2tfvuSKKe37Eu1DnP/oo/5Uu75RQhwUFqGRUhaJCE1cQem
         6L7c0624/NS+w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o6UTL-0041zc-1W;
        Wed, 29 Jun 2022 10:58:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org
Cc:     Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com,
        James Morse <james.morse@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH v2 00/19] KVM/arm64: Refactoring the vcpu flags
Date:   Wed, 29 Jun 2022 10:58:56 +0100
Message-Id: <165649672001.296498.9919845207061200295.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610092838.1205755-1-maz@kernel.org>
References: <20220610092838.1205755-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org, kvm@vger.kernel.org, tabba@google.com, reijiw@google.com, will@kernel.org, kernel-team@android.com, james.morse@arm.com, broonie@kernel.org, oupton@google.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jun 2022 10:28:19 +0100, Marc Zyngier wrote:
> This is a iteration on [1], which aims at making the vcpu flags suck a
> bit less.
> 
> * From v1 [1]:
>   - Rebased onto v5.19-rc1
>   - Took the first two patches into kvmarm-fixes, included here for
>     completeness
>   - Additional patch to move system_supports_fpsimd() outside of
>     the run path (Reiji)
>   - Expanded on comments (Reiji)
>   - New kvm_pend_exception() accessor (Fuad)
>   - Various bracketing fixups (Reiji)
>   - Some renaming (Reiji, Broonie)
>   - Collected RBs, with thanks
> 
> [...]

Applied to next, thanks!

[01/19] KVM: arm64: Always start with clearing SVE flag on load
        commit: d52d165d67c5aa26c8c89909003c94a66492d23d
[02/19] KVM: arm64: Always start with clearing SME flag on load
        commit: 039f49c4cafb785504c678f28664d088e0108d35
[03/19] KVM: arm64: Drop FP_FOREIGN_STATE from the hypervisor code
        commit: e9ada6c208c15c907afe5afb1aa82e23e81eb8ba
[04/19] KVM: arm64: Move FP state ownership from flag to a tristate
        commit: f8077b0d59230cbb58e0b98839e04b564529a5ac
[05/19] KVM: arm64: Add helpers to manipulate vcpu flags among a set
        commit: e87abb73e5946379896cf49b10f6b57e02937a4c
[06/19] KVM: arm64: Add three sets of flags to the vcpu state
        commit: 690bacb83bc30d14821bd32cac1c5839b4a9ac6c
[07/19] KVM: arm64: Move vcpu configuration flags into their own set
        commit: 4c0680d394d8a77868049931101e4a59372346b5
[08/19] KVM: arm64: Move vcpu PC/Exception flags to the input flag set
        commit: 699bb2e0c6f3796549dabac329501df7ffd99439
[09/19] KVM: arm64: Move vcpu debug/SPE/TRBE flags to the input flag set
        commit: b1da49088ac68a21c613efd734dada8272ec0b00
[10/19] KVM: arm64: Move vcpu SVE/SME flags to the state flag set
        commit: 0affa37fcd1d6f701a0fe805c4ceb7f348d377d5
[11/19] KVM: arm64: Move vcpu ON_UNSUPPORTED_CPU flag to the state flag set
        commit: aff3ccd7320eed5814d317fcb80244f474d66a84
[12/19] KVM: arm64: Move vcpu WFIT flag to the state flag set
        commit: eebc538d8e07e0ec759823664cbe2011a8bd885d
[13/19] KVM: arm64: Kill unused vcpu flags field
        commit: 781e3ae148fd2f9b0cf9b5b94f6c32f2361eb7c0
[14/19] KVM: arm64: Convert vcpu sysregs_loaded_on_cpu to a state flag
        commit: 30b6ab45f81334e83dcb440451b6a4c4a753a118
[15/19] KVM: arm64: Warn when PENDING_EXCEPTION and INCREMENT_PC are set together
        commit: e19f2c6cd14668c0d5b1cef280632b7ca5893118
[16/19] KVM: arm64: Add build-time sanity checks for flags
        commit: 5a3984f4ec73d1c7cf31a4cee46cca7d4c75deee
[17/19] KVM: arm64: Reduce the size of the vcpu flag members
        commit: 54ddda919c4bc37c113727034619c4e15c184334
[18/19] KVM: arm64: Document why pause cannot be turned into a flag
        commit: 0fa4a3137e943cd6acab386ff26cd8d5e94e9559
[19/19] KVM: arm64: Move the handling of !FP outside of the fast path
        commit: b4da91879e98bdd5998ee84f47f02426ac50a729

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

