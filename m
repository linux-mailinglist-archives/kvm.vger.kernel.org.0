Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6008E4ADFCA
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 18:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384350AbiBHRhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 12:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384320AbiBHRha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 12:37:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B08C061578
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 09:37:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB8F5B81CA5
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 17:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D042C004E1;
        Tue,  8 Feb 2022 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644341847;
        bh=hLB0sYIRDmT6QfVgnPvR4+VTSPDkVrSFX6+peUwAxY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkWC+SEy7c5UGHjmleu74zI2RWFnEVHs4muVZ+Tx0KoeLTEf4oT6HikkvXbK1/NSB
         HUtJElm4OmrRmKT+EAitvOd/fCEyOqZa58hrwagzTF+dJdeNXKXuNZjRvqyypcmFbd
         gXUw7u3x4G+2/yBjhARDonZyBn8MpUb+pkojwyY5ZvIE3brS+IQHPxyTXjQjQHAcM/
         E6qi6nfwxxLcPFNHw8U23TZguW2UGX2bOkOpyeyxKSnb2+4BMEJ1ZFax87SKwBtbvX
         FtJYVgGoUSBSNRPLKcVZDD7T3brcLiD9TzqsGAOxAAgTuVzmeKPNVDB2jnKIWN8W6Y
         /79yiNWS4ebTQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nHUQf-006Ksa-Mk; Tue, 08 Feb 2022 17:37:25 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Cc:     Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Reiji Watanabe <reijiw@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH v5 0/6] KVM: arm64: Emulate the OS Lock
Date:   Tue,  8 Feb 2022 17:37:24 +0000
Message-Id: <164434147326.3931943.9332144598963779018.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203174159.2887882-1-oupton@google.com>
References: <20220203174159.2887882-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com, drjones@redhat.com, james.morse@arm.com, reijiw@google.com, suzuki.poulose@arm.com, ricarkol@google.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, pshier@google.com, mark.rutland@arm.com, alexandru.elisei@arm.com
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

On Thu, 3 Feb 2022 17:41:53 +0000, Oliver Upton wrote:
> KVM does not implement the debug architecture to the letter of the
> specification. One such issue is the fact that KVM treats the OS Lock as
> RAZ/WI, rather than emulating its behavior on hardware. This series adds
> emulation support for the OS Lock to KVM. Emulation is warranted as the
> OS Lock affects debug exceptions taken from all ELs, and is not limited
> to only the context of the guest.
> 
> [...]

Applied to next, thanks!

[1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
      commit: e2ffceaae50883c5064641167078e5720fd8b74a
[2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
      commit: d42e26716d038d9689a23c193b934cdf0e2a2117
[3/6] KVM: arm64: Allow guest to set the OSLK bit
      commit: f24adc65c5568a8d94e2693f5441de80f1ffe0d3
[4/6] KVM: arm64: Emulate the OS Lock
      commit: 7dabf02f43a1670d13282463fc0106f01dfd6f9c
[5/6] selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
      commit: d134998838ac217a8427c1ddc83cf48888bb3fa3
[6/6] selftests: KVM: Test OS lock behavior
      commit: 05c9324de1695b5e61dceca6d2ef0ab8c0f2f26b

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


