Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3858367D226
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 17:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbjAZQx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 11:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjAZQx4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 11:53:56 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF417A86
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:53:54 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id o1-20020a252801000000b0080b8600bdc9so2460964ybo.3
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 08:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=epBcuambf17d1PuUuyXKbaHvfLnz0Zdv1rlsdBONwcI=;
        b=DT5VFB0mDWJZLx00VsPU50OfcBBAaBDJAJZUPbXwCzc3/qKXaqJYoiL6cyunNbfSCx
         SRHCJEE45dCejOHYGbuXGRrEQUfFzZBTdWXxrntXsic9A+sLMxdcO1oGpxsiVGjLHDkv
         ujjKaqT/VRthMWj9VzasYsZpqHRbB5dbKJmErFOibXzvhBwEwdIqotcj+6j5RLSAIIso
         tv9Ab+crTFEtRoCuY3GDQlvM1LiU7+O8BGNVOYB2RwBMnJX3ucFXIPGlSH9T8IAKSFy9
         K1X+OoTV7GzqQFSJxv5jR5xCErKlDv6hiqsgCxaObDxxRwXoGuEKY68C3mB96NWx7AfH
         ZEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=epBcuambf17d1PuUuyXKbaHvfLnz0Zdv1rlsdBONwcI=;
        b=KGVOVMrJ9o6Na3HEEhJDr8XegHWzl2vpzPuIflFVmdNiR2jgKDs/5gpymqkIqpaegf
         u7vNwEbUvqKYgKisqFArYRRNVvGPjPH49PUCpS9mN+LZoElR9l+oMFiblVATldNgoHlh
         VCgBok9zUZQPwZemBQubS+EsaDsHbF/lrJPf50HVGbV1SwiUqEZhDp4y2DyZu3vLzxPR
         Tow+MPgEyvFAnYvY1LmV9diIeBZCdPDo/k4AZVj+cow+n/pqPiB15r6tfkinwfyeyv89
         I2VWmxxS1sWaGH4OiRAFVinp/lrjkYH3vQxN7u9nIsmDMTsVWeAUn8f4BHqQP6mLE/eX
         lJHA==
X-Gm-Message-State: AFqh2kqPl0kBA6z/CS4tG1mPKqEP4oedovwydjse4pbeRushfFYNxKVv
        iH3XQPEJL++Qfga04rXr2lSw41TndJjIoAvSFkq5ksQiuEjb7oVIKXJ6/sPbxiMhpyBZnikYYgD
        HyvlMrbZbDX6QhPVLw7t1x0fGfjvEqLLlM2ZRLRlE+ephvhgHGg1dQrZ5JR/tdQ8=
X-Google-Smtp-Source: AMrXdXvbmfT5pbJ0FBY7B6hBNsV45pYZbsBPZgTKAmCuwD4RYT7YUzrJWfpzk+e8xk8EIddj5wSqaUJxRh6atg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:98c3:0:b0:6ff:84be:717 with SMTP id
 m3-20020a2598c3000000b006ff84be0717mr4149755ybo.314.1674752034067; Thu, 26
 Jan 2023 08:53:54 -0800 (PST)
Date:   Thu, 26 Jan 2023 16:53:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126165351.2561582-1-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v4 0/6] arm: pmu: Add support for PMUv3p5
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

Changes from v3:
- Added commit to fix test_overflow_interrupt(). (Reiji and Eric)
- Separated s/ALL_SET/ALL_SET_32/ and s/PRE_OVERFLOW/PRE_OVERFLOW_32
  into its own commit. (Reiji and Eric)
- Fix s/200/20. (Eric)

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

Ricardo Koller (6):
  arm: pmu: Fix overflow checks for PMUv3p5 long counters
  arm: pmu: Prepare for testing 64-bit overflows
  arm: pmu: Rename ALL_SET and PRE_OVERFLOW
  arm: pmu: Add tests for 64-bit overflows
  arm: pmu: Print counter values as hexadecimals
  arm: pmu: Fix test_overflow_interrupt()

 arm/pmu.c | 298 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 188 insertions(+), 110 deletions(-)

-- 
2.39.1.456.gfc5497dd1b-goog

