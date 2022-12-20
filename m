Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740E665194B
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 04:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbiLTDKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 22:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLTDKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 22:10:36 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B6E1018
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 19:10:36 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3b48b605351so130670287b3.22
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 19:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DzRaMHQSWDMQOYLi4LFm681DO4wmsRsX9iZ+PyKDp9w=;
        b=Xd2gh5uphWzH0JvVshIjL4yLbft1N1zhzk/j+R3dvrbSuRZ2Bi3bUvuXNszDBBzX1O
         uzb7YfFeHiwGrDNjuB136VOPiz3jILGfMBqJYKdax/gU1HMqb4syORIzzufxsxuBsDA0
         FdQ/HULBUK7pcZADN7SGLQLFm4qSN8f3oGZ+UZTbzbHDQ27L8WAVpj24uil20T3heA1I
         ess0DIqMFqhCroAIJmQfdUsMCMVH+lLpH+AZFhP33UUnjsj+A6m1tU7RHq3kS+tdGpf+
         NVF6UMSG3XKG0U6M3MSvw1bSJ6pfZ01nW7vH9EItab4YRy9yz0Ik20gnCR+tHIsrh1Fz
         s4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DzRaMHQSWDMQOYLi4LFm681DO4wmsRsX9iZ+PyKDp9w=;
        b=NA782i3ZRpVGGBEWwTtbral2B7q/Gnee7lYpx0NU05JnD0KYv0YFIDMJPckNRR+X5f
         llMgqu4K4r5sVjG6BO+kaDfp52P7433RUJTmEdG14dml4rQtn8wRlEC/U4x/QpxGX20s
         clakYkpdbYfNqKLSrc4EKVM5q0/0MexdI9GKKhJFXtrNTLiylquSF8gu+BZE6lPQcUHD
         h72EQEOqYswmONNLlbhjxEPnYcSIC+BXJur0Kw/obh82cGEZW6LzBsk7b1xRUHR6vc9b
         R9ExnPAIqkf1UblOtOAaNihyHMqDbS1a5RL7sNSRWHnkNEj+9ZkMmDzW/586lEoUoi23
         /H3g==
X-Gm-Message-State: ANoB5pmK73QYoGU02PH1EEBdED+s8JWiIpn26nyJ+t5M2A1HM44w1h0t
        K/TQQqm3OsqjoBzYQxnJEBjLwMoh1Gkw+mPruikWLX31tZnLdBgbs6l1Iuc/cZVHENvlTeS3S2/
        fJgWmXgLpvQ8ISsdCOlZ+IMx609civThUhZsjZ0KgycCXTE34YoFoCGi0fTGiTV8=
X-Google-Smtp-Source: AA0mqf7EDF6fes8LHciDwQCSCvRrmAybFtC4iF1GFNihPx9pNIA8bFaGjJUUopTMZMk+NXfuSIFGwgko7t8mQw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:d4d5:0:b0:70d:f50c:29ad with SMTP id
 m204-20020a25d4d5000000b0070df50c29admr6202325ybf.265.1671505835190; Mon, 19
 Dec 2022 19:10:35 -0800 (PST)
Date:   Tue, 20 Dec 2022 03:10:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220031032.2648701-1-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v2 0/4] arm: pmu: Add support for PMUv3p5
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
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

 arm/pmu.c | 240 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 149 insertions(+), 91 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

