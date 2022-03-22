Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AA54E4616
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 19:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbiCVShN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 14:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbiCVShM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 14:37:12 -0400
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2923C4BA
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:35:44 -0700 (PDT)
Received: by mail-oo1-xc49.google.com with SMTP id u13-20020a4ab5cd000000b002e021ad5bbcso12113183ooo.17
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 11:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5SgsMWfo3s1L8LtQzUYqsFC2nGQvlmxjA5TrVXlNF5o=;
        b=NX/BKlXFUX08TaXDOkYcmlRKl5vaPl5VlRDyAV1k+AuDKOzI1MZXJ5+22dygCqBHx0
         cndVmYMiBZ8nmrVLXS7wr6r6xMVjqUptm/oFwkxO8iNVzx+jkh9rRiaya/P07+3MpJ04
         PJViSnNZvSINYM+HXpkl74vp6GVfLa5lg8R/MzRO2JEF9yr9GzaPdDsd1M4R7DOnsPnL
         GY4FOgGYGPB1d8cgw93lNLO7qXMe/gl/08vQDPIOX1VpM1MxuhjQ7CPtWAeOg9CIuqab
         h8WEqyqK+VHesnwGBityrclGfO6IJCwPfj6gqm7TZCeFBV2aliXaT2f3+d6CEFOzHXMT
         ycVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5SgsMWfo3s1L8LtQzUYqsFC2nGQvlmxjA5TrVXlNF5o=;
        b=NH6FWIhtYK7c0mxXQpXvHNUaOKNwk33pKuz24FVeuGoySeCM46xQPeS18JMYRWMhDH
         xhN66JWCijgGz9b9zCgqRAo49aBvmy8s8DVyWZ/lachtClexkVgv316nWPs4c9oNn3Vi
         jU9Hitwtd/L6thA2r8rpRzjuoz6iTtDxlw7PXAgJwo6N1wCrGKjRFSZuk7YUfXu+dd/4
         ktRtnO/vJfteuvDDjovGUA53s0qTHww7bw8faTovU85EQva6BB1fc/bPgaJyCye7cI/R
         ywKYKYVfTKHTj6b5JzRvtGqJHXUxM2qHZ28Q/H9jGIq2ShfRxPENYCizaEuOoukgANC1
         q7rg==
X-Gm-Message-State: AOAM532JO2+FGqK6wdtiCJT+z5unhnkPsCFSCKCpa1n0D7IAkVMcFI9e
        4rTUoC20QWHS9XvShJ9bQf638R81PpI=
X-Google-Smtp-Source: ABdhPJzHEAq3Ahy4FlfkKxUuOF9jkElOWpjOAJdQhPLkwUNZPQY2dc71XrglzJC9u5kFBcUHDcv+k9hh18A=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6808:1a97:b0:2ec:a246:ad01 with SMTP id
 bm23-20020a0568081a9700b002eca246ad01mr2796378oib.54.1647974143817; Tue, 22
 Mar 2022 11:35:43 -0700 (PDT)
Date:   Tue, 22 Mar 2022 18:35:35 +0000
Message-Id: <20220322183538.2757758-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 0/3] KVM: arm64: Fixes for SMC64 SYSTEM_RESET2 calls
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series addresses a couple of issues with how KVM exposes SMC64
calls to its guest. It is currently possible for an AArch32 guest to
discover the SMC64 SYSTEM_RESET2 function (via
PSCI_1_0_FN_PSCI_FEATURES) and even make a call to it. SMCCC does not
allow for 64 bit calls to be made from a 32 bit state.

Patch 1 cleans up the way we filter SMC64 calls in PSCI. Using a switch
with case statements for each possibly-filtered function is asking for
trouble. Instead, pivot off of the bit that indicates the desired
calling convention. This plugs the PSCI_FEATURES hole for SYSTEM_RESET2.

Patch 2 adds a check to the PSCI v1.x call handler in KVM, bailing out
early if the guest is not allowed to use a particular function. This
closes the door on calls to 64-bit SYSTEM_RESET2 from AArch32.

Lastly, patch 3 is a nit to remove a superfluous check in the hopes of
avoiding trouble the next time we raise KVM's PSCI version.

Applies on top of kvmarm/next at commit:

  21ea45784275 ("KVM: arm64: fix typos in comments")

v1: http://lore.kernel.org/r/20220318193831.482349-1-oupton@google.com

v1 -> v2:
 - Collect Acks and Reviews (Reiji, Will)
 - Hoist SMC64 filtering all the way up to kvm_psci_call() (Reiji)

Oliver Upton (3):
  KVM: arm64: Generally disallow SMC64 for AArch32 guests
  KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32
  KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler

 arch/arm64/kvm/psci.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

-- 
2.35.1.894.gb6a874cedc-goog

