Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBCB47FCC5
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 13:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236758AbhL0MtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 07:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236732AbhL0MtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 07:49:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1B4C06173E
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 04:49:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E74A4B80E70
        for <kvm@vger.kernel.org>; Mon, 27 Dec 2021 12:48:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A52C36AEA;
        Mon, 27 Dec 2021 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640609337;
        bh=G9pqX101HZzCVMHkmDK5oW5uZColrbyZq8WIBa0OdmE=;
        h=From:To:Cc:Subject:Date:From;
        b=IUkJQfw/8/hFsDrv8MEe4us1nN9zzSDas/IBQ1D/jt9mp6n/BMWP0PHwQfS0QKjrL
         Uqv24TqzVLw44uvXmvnvhrQDd/zTUA+g79UOcas0G9g1m6299h4KFX0Rg33+IytAiv
         ETyKzY30VgaNnHUnbixfJvY1wVi5rQw3tQ6wVpjQndQmtY9Q7/ukVLWztShDMjN5RB
         vYN7S+RpTbsnbXZPCjCLNUNB22TNEPkUG8WE2rSuIznhdd+29CZsgD2x6yyHDCJ34R
         ZgAfgYe7Jmr/NgnHiWXy6dqxBusWbA7JPFKcQ13JWuJ2e/UBw4DbKVtFySV3t00oVP
         uqOHMucm+sEIg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n1pQt-00EYBY-QS; Mon, 27 Dec 2021 12:48:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: [PATCH v2 0/6] KVM: arm64: Selftest IPA fixes and 16kB support
Date:   Mon, 27 Dec 2021 12:48:03 +0000
Message-Id: <20211227124809.1335409-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the common variety of fruity arm64 systems makes a pretty
remarkable KVM host, I have decided to run the collection of selftests
on it.

Nothing works. Oh no!

As it turns out, the tests have a notion of "default mode" (40bit PA,
4kB), which cannot work in general on arm64 because there no such
thing as an IPA size that would be valid everywhere (apart from the
minimal 32bit), nor a guaranteed to be supported page size.

This small series is a first attempt at making these things computed
at runtime by making the default something else on systems that do not
support it. It also makes the supported page sizes dynamically
discovered, which allows us to implement support for 16kB pages.

With that, the selftests do run on the M1, with the exception of the
memslot tests that are freaked out by the use of 16kB pages on the
host and 4kB in the guest (these tests are hardcoded to use 4kB
pages even if the VM uses something else -- oh well...).

* From v1:
  - Rebased on 5.16-rc7 and dropped the initial patch, now that
    non-x86 systems are up and running again
  - Used Andrew's trick to initialise the default mode as a
    constructor instead of hacking every single test (I decided to
    make it an arm64-special instead of an all-arch thing though)
  - Reworked the way TCR_EL1 gets configured for easier integration of
    new modes
  - Added support for various 16kB modes
  - Various cleanups as requested by Andrew

Marc Zyngier (6):
  KVM: selftests: arm64: Initialise default guest mode at test startup
    time
  KVM: selftests: arm64: Introduce a variable default IPA size
  KVM: selftests: arm64: Check for supported page sizes
  KVM: selftests: arm64: Rework TCR_EL1 configuration
  KVM: selftests: arm64: Add support for VM_MODE_P36V48_{4K,64K}
  KVM: selftests: arm64: Add support for various modes with 16kB page
    size

 .../selftests/kvm/include/aarch64/processor.h |  3 +
 .../testing/selftests/kvm/include/kvm_util.h  | 10 ++-
 .../selftests/kvm/lib/aarch64/processor.c     | 82 +++++++++++++++++--
 tools/testing/selftests/kvm/lib/guest_modes.c | 49 +++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 22 +++++
 5 files changed, 152 insertions(+), 14 deletions(-)

-- 
2.30.2

