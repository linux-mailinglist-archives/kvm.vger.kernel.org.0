Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1FA6632A2
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237479AbjAIVTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:19:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238198AbjAIVSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:18:03 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D2D3AB
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:17:57 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id z4-20020a17090ab10400b002195a146546so7887504pjq.9
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C+A/7tP9mvR5o1GtT1H6KbVlKl608UdMee+76BtuWKY=;
        b=NYrhvrbbfkSmHLJAY5CoZsw9Z3pb8ZX1ARyBNHXSy5UxUbbLAOboQMst98y0xabMqe
         muJWrH8SW/zai8ix/V5vd6Cvvd1FxWt2qsVrDAqaHmBhUC7E8K2daLlkiKTBZLmKRxts
         Y4sY6z61Q50T9kyRSJ9hReFHU2j8uWDaU3tdwAvts5+Op/7tQdP79goWGPgDMFXlEUvG
         mZluVz0K5AgRFjdLSJ1yyRBwriqOmg5Gd1XlQgnk8PvYQbVlC639wCpvg2lL29nylI2c
         HrsRFjRvlHfutZtzuOq8hXnm1DeeKK1aMK+sUlKxGsWeQ9GnYz3ewoJvu7z/ruRqZ8RX
         qS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C+A/7tP9mvR5o1GtT1H6KbVlKl608UdMee+76BtuWKY=;
        b=btLrrGJgYJGPAPwGgd/63W9hZ87T2qJBzCbqtJ+lkHEKiHetI1gLyi0pUoMSGbVbx6
         GgcP/dZU7lB8ILihf6qG42sdOOqGbGRq+rk/cLrMeIO1UxezLHumy2AjTBRNX+AH3YpZ
         t2vD8AbUmyyC8IqSpOy5p12ErJZNh0APr7X6aKg/CIt47ZUUt5u52SKssA5elqYrsk8C
         xbpR6wpv/u5bATuSbcXJoMfuKV6kdXlqyca4W9oXH2mvL9PxYEkO74+mnNkWgB/Xt2r6
         fBqxuLeczH6nUROAY5D3pp4uSRzz8FEj6Q1LWbr0L6b2hipHI8baG2JRwRe8Jd+lkjKf
         l00g==
X-Gm-Message-State: AFqh2kpM42eWfcMiM/wPBSzBYlEcrG69ogTp4Un2c5DwYQ/D1CdK4IRQ
        IZsZc9JEZtIDDNTEX5v7oM0KslB4uxYAl1UEO3d5tbiZ/6HMCrHAZmuHsDfi6yMGL/BcQVFjLSs
        XdRwhcIVpsMbRPe8W06cpFLsyk6EQgaAEvXtlHL2wwd88u1uxmAJMqapPrQq5X1k=
X-Google-Smtp-Source: AMrXdXsuzGhN57hreYNDB9W34vnllmBsMvmdjRf6dJryLCkM6AVR0IfSHN4dMqg2O1uk8SFEEXOTG7dfKPg2wg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a62:5f87:0:b0:57f:ef13:63aa with SMTP id
 t129-20020a625f87000000b0057fef1363aamr4334401pfb.42.1673299077120; Mon, 09
 Jan 2023 13:17:57 -0800 (PST)
Date:   Mon,  9 Jan 2023 21:17:50 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109211754.67144-1-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v3 0/4] arm: pmu: Add support for PMUv3p5
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     maz@kernel.org, alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first commit fixes the tests when running on PMUv3p5. The issue is that
PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
for overflowing at 32 or 64-bits. Tests are currently failing [0] on
PMUv3p5 because of this. They wrongly assume that values will be wrapped
around 32-bits, but they overflow into the other half of the 64-bit
counters.

The second and third commits add new tests for 64-bit overflows, a feature
added with PMUv3p5 (PMCR_EL0.LP == 1). This is done by running all
overflow-related tests in two modes: with 32-bit and 64-bit overflows.
The fourt commit changes the value reporting to use %lx instead of %ld.

This series was tested on PMUv3p5 and PMUv3p4 using the ARM Fast Model and
kvmtool.  All tests pass on both PMUv3p5 and PMUv3p4 when using Marc's
PMUv3p5 series [0], plus the suggestion made at [1]. Didn't test AArch32.

Changes from v2:
- used Oliver's suggestion of using pmevcntr_mask() for masking counters to
  32 or 64 bits, instead of casting to uint32_t or uint64_t.
- removed ALL_SET_AT() in favor of pmevcntr_mask(). (Oliver)
- moved the change to have odd counter overflows at 64-bits from first to
  third commit.
- renamed PRE_OVERFLOW macro to PRE_OVERFLOW_32, and PRE_OVERFLOW_AT() to
  PRE_OVERFLOW().

Changes from v1 (all suggested by Alexandru):
- report counter values in hexadecimal
- s/overflow_at_64bits/unused for all chained tests
- check that odd counters do not increment when using overflow_at_64bits
  (pmcr.LP=1)
- test 64-bit odd counters overflows
- switch confusing var names in test_chained_sw_incr(): cntr0 <-> cntr1

[0] https://lore.kernel.org/kvmarm/20221113163832.3154370-1-maz@kernel.org/
[1] https://lore.kernel.org/kvmarm/Y4jasyxvFRNvvmox@google.com/

Ricardo Koller (4):
  arm: pmu: Fix overflow checks for PMUv3p5 long counters
  arm: pmu: Prepare for testing 64-bit overflows
  arm: pmu: Add tests for 64-bit overflows
  arm: pmu: Print counter values as hexadecimals

 arm/pmu.c | 260 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 163 insertions(+), 97 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

