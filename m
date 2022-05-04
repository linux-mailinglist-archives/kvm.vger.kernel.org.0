Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABBF519EC3
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 14:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349203AbiEDMFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 08:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348784AbiEDMFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 08:05:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C37B15710;
        Wed,  4 May 2022 05:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5CB7B8256B;
        Wed,  4 May 2022 12:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2829BC385A5;
        Wed,  4 May 2022 12:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651665688;
        bh=f+/lmLtGAEtADfizlaMSjFSBhGJliHAhJYnmVX/pwXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IoENOsL2mNLTOvyCkNM0si/i5sXPPGtRTJzbw0oIRX58ddWU90O6JoYd+AaNb4EVe
         I0wRicuh/Gw47OZL2KyiBE0OPt4HItd+2iK4c0dfkblPA9mVOhglQKNPxwNbqCWD/T
         av5peQdL/Zc6aliMzmOyaJKdNmFdeveBduCk9KEP/Gg8fCFHjFUIzV4OnhtkAZowCk
         q6YBnl7qwCBvtTUSXJz4b75P5XDuWXJXuSdL2vw5RNsWCkl7YupBpwvfCxB7FktrZa
         03PqNaJiujRVIDo1DslR2WPyYJEhzOnCtHIHQrkpH6LQ9KmLgLC4N2pHYrElfFQgr3
         2A6paoxzxrD+g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nmDh7-008tMB-Ic; Wed, 04 May 2022 13:01:25 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/9] KVM: arm64: Add support for hypercall services selection
Date:   Wed,  4 May 2022 13:01:23 +0100
Message-Id: <165166565256.3774994.4350940683684541291.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220502233853.1233742-1-rananta@google.com>
References: <20220502233853.1233742-1-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: drjones@redhat.com, rananta@google.com, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, will@kernel.org, pbonzini@redhat.com, pshier@google.com, catalin.marinas@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2 May 2022 23:38:44 +0000, Raghavendra Rao Ananta wrote:
> Continuing the discussion from [1], the series tries to add support
> for the userspace to elect the hypercall services that it wishes
> to expose to the guest, rather than the guest discovering them
> unconditionally. The idea employed by the series was taken from
> [1] as suggested by Marc Z.
> 
> In a broad sense, the concept is similar to the current implementation
> of PSCI interface- create a 'firmware psuedo-register' to handle the
> firmware revisions. The series extends this idea to all the other
> hypercalls such as TRNG (True Random Number Generator), PV_TIME
> (Paravirtualized Time), and PTP (Precision Time protocol).
> 
> [...]

Applied to next, thanks!

[1/9] KVM: arm64: Factor out firmware register handling from psci.c
      commit: 85fbe08e4da862dc64fc10071c4a03e51b6361d0
[2/9] KVM: arm64: Setup a framework for hypercall bitmap firmware registers
      commit: 05714cab7d63b189894235cf310fae7d6ffc2e9b
[3/9] KVM: arm64: Add standard hypervisor firmware register
      commit: 428fd6788d4d0e0d390de9fb4486be3c1187310d
[4/9] KVM: arm64: Add vendor hypervisor firmware register
      commit: b22216e1a617ca55b41337cd1e057ebc784a65d4
[5/9] Docs: KVM: Rename psci.rst to hypercalls.rst
      commit: f1ced23a9be5727c6f4cac0e2262c5411038952f
[6/9] Docs: KVM: Add doc for the bitmap firmware registers
      commit: fa246c68a04d46c7af6953b47dba7e16d24efbe2
[7/9] tools: Import ARM SMCCC definitions
      commit: ea733263949646700977feeb662a92703f514351
[8/9] selftests: KVM: aarch64: Introduce hypercall ABI test
      commit: 5ca24697d54027c1c94c94a5b920a75448108ed0
[9/9] selftests: KVM: aarch64: Add the bitmap firmware registers to get-reg-list
      commit: 920f4a55fdaa6f68b31c50cca6e51fecac5857a0

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


