Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1DB58289F
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 16:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbiG0O33 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 10:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiG0O32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 10:29:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F382CCA0
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 07:29:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 665ADB82188
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 14:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C78C433D6;
        Wed, 27 Jul 2022 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658932164;
        bh=C0fFCqtOLRJbXlVkkLns9Pw1a9RaVmm9QzhFCj+FTOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjMTVfWWDiKQSqProKDRbhzNZSm6LlsyYqv7ARDwKr7/LZbDIMooFLHPyv1ZA7k3r
         s4M1h1mfVni0CwP+xhynwSA/e7dy6UNrWhnuAKdK5x7/OPudgDv4AZL5yIeQewF+C1
         F3JD5clTB5DWvWtcv2WxVJfRHr2YSUxAGunY7amprAgOw24RLK+N15GkvQ7SRajs2e
         /wIfUX53jEH70kFecHUEdOQXiEQyBTOz+gJmrl99yAcQFBG5Jn4CMphfQdbBnvUybv
         p2s3T0P4ENfUkAi16ztbu9C5WVbfWXdO/ZW7B9aKATrpwYf9JM5GxQbIgr7y6YOS2W
         Z45HYSIJ+DGdg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oGi2L-00APjL-TD;
        Wed, 27 Jul 2022 15:29:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, broonie@kernel.org,
        madvenka@linux.microsoft.com, tabba@google.com,
        oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, catalin.marinas@arm.com,
        andreyknvl@gmail.com, vincenzo.frascino@arm.com,
        mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com,
        elver@google.com, keirf@google.com, yuzenghui@huawei.com,
        ardb@kernel.org, oupton@google.com, kernel-team@android.com
Subject: [PATCH 0/6] KVM: arm64: nVHE stack unwinder rework
Date:   Wed, 27 Jul 2022 15:29:00 +0100
Message-Id: <20220727142906.1856759-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220726073750.3219117-18-kaleshsingh@google.com>
References: <20220726073750.3219117-18-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com, broonie@kernel.org, madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev, qperret@google.com, kaleshsingh@google.com, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, andreyknvl@gmail.com, vincenzo.frascino@arm.com, mhiramat@kernel.org, ast@kernel.org, wangkefeng.wang@huawei.com, elver@google.com, keirf@google.com, yuzenghui@huawei.com, ardb@kernel.org, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

As Kalesh's series[1] already went through quite a few rounds and that
it has proved to be an extremely useful debugging help, I'd like to
queue it for 5.20.

However, there is a couple of nits that I'd like to address:

- the code is extremely hard to follow, due to the include maze and
  the various levels of inline functions that have forward
  declarations...

- there is a subtle bug in the way the kernel on_accessible_stack()
  helper has been rewritten

- the config symbol for the protected unwinder is oddly placed

Instead of going for another round and missing the merge window, I
propose to stash the following patches on top, which IMHO result in
something much more readable.

This series directly applies on top of Kalesh's.

[1] https://lore.kernel.org/r/20220726073750.3219117-1-kaleshsingh@google.com

Marc Zyngier (5):
  KVM: arm64: Move PROTECTED_NVHE_STACKTRACE around
  KVM: arm64: Move nVHE stacktrace unwinding into its own compilation
    unit
  KVM: arm64: Make unwind()/on_accessible_stack() per-unwinder functions
  KVM: arm64: Move nVHE-only helpers into kvm/stacktrace.c
  arm64: Update 'unwinder howto'

Oliver Upton (1):
  KVM: arm64: Don't open code ARRAY_SIZE()

 arch/arm64/include/asm/stacktrace.h        |  74 -------
 arch/arm64/include/asm/stacktrace/common.h |  69 ++-----
 arch/arm64/include/asm/stacktrace/nvhe.h   | 125 +-----------
 arch/arm64/kernel/stacktrace.c             |  90 +++++++++
 arch/arm64/kvm/Kconfig                     |  24 ++-
 arch/arm64/kvm/Makefile                    |   2 +-
 arch/arm64/kvm/handle_exit.c               |  98 ---------
 arch/arm64/kvm/hyp/nvhe/stacktrace.c       |  55 +++++-
 arch/arm64/kvm/stacktrace.c                | 218 +++++++++++++++++++++
 9 files changed, 394 insertions(+), 361 deletions(-)
 create mode 100644 arch/arm64/kvm/stacktrace.c

-- 
2.34.1

