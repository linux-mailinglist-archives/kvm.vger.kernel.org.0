Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7916963FF99
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 05:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiLBEze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 23:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiLBEzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 23:55:32 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85154D4257
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 20:55:31 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id x16-20020a63b210000000b0045f5c1e18d0so3663777pge.0
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 20:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ePSSoXiRCXLATVJ0brBTRlEDHpo+JqW+vLuJHQVEQoU=;
        b=BSDooaNj6M7Kvuy7OQ/0DLnUNn6HYbSz/gio2djUCKkrKrK9e4j7OZfNXRWH3mHGz0
         EXRWJ+j1+94AQR431HTsys4faQTpNRPJI9FjA6BFvNJdKQMaCKyh0OJQ/Kue1P+jHOIh
         /4yIeTXB/8SAl0d2UXW/2x5fc8A5HnV5Z7XAiGo2twWr4BWCGzpkXflZMdNVaFMdIBqN
         6Hj8urTTOqciV9VOB0p0+C8Rm8/a6kF0jgPVxx2TfBmp86conFVMDcnuBl1jOx5QmQ9l
         6iVvuHdSj+Z1lNQusHhNTonoUqntCvXLMREUNG0MWk1IsYGddSIku1073bkx2KxozYVi
         gC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ePSSoXiRCXLATVJ0brBTRlEDHpo+JqW+vLuJHQVEQoU=;
        b=rF9ff8BacipWSnWW+YcDl9RvAxN7aT5kTq0Jl6aptqYLmeruoK4lfZzED0wdmIDU5T
         EQKKyPczquuTkUei20+aD2WVLk12BQNgLibSSfo/nEnH5gJSVNQAQanLwUde1U56ytb5
         UA96/lzY6uzn8EyVnSMMKF7zQsAs4zQq1CUU2yPN238j0Q6xD0b75qavwnmBK/X44fhG
         czr7mRaX1ErK5L28R4n4hxjJiOdJd6FjwXAjVYZJraRWMVz1WtDqUBWgu1ltAc2R8Sig
         FhvG7i+UDROqOaOHChBNno/raAmWj92a/jEK0mVywvOWz1Us4T9msrifht5ABPeWASxd
         CtKA==
X-Gm-Message-State: ANoB5plGIyPH+3YTvnEL5M/Uwppx9syV4whkMJSVoHKm/ivrRnCDFVAt
        sZKH6eBro6WR9+FvWV/cRWXe1uydehv4UVZqlcU0/SBAU66v4OcFik7yQvC28iOqt9AN1dfsZrP
        gXxaxIt0OR2+cm/g/6aZsGOYC+PxLFnUMVNmykz/PWiCfP0kcX6/Cllyg/j2ptZo=
X-Google-Smtp-Source: AA0mqf7ulNAmYN++pr5vxkvvlrtyq6dsW+A+tWOuU1ZyqBRAIvazXv1Ygr0XNWZgsTfhU+/w6a8PciYu7N2SMg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:e09:b0:575:3e68:ffa0 with SMTP
 id bq9-20020a056a000e0900b005753e68ffa0mr21557649pfb.12.1669956930815; Thu,
 01 Dec 2022 20:55:30 -0800 (PST)
Date:   Fri,  2 Dec 2022 04:55:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202045527.3646838-1-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH 0/3] arm: pmu: Add support for PMUv3p5
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

This series was tested on PMUv3p5 and PMUv3p4 using the ARM Fast Model and
kvmtool.  All tests pass on both PMUv3p5 and PMUv3p4 when using Marc's
PMUv3p5 series [0], plus the suggestion made at [1]. Didn't test AArch32.

[0] https://lore.kernel.org/kvmarm/20221113163832.3154370-1-maz@kernel.org/
[1] https://lore.kernel.org/kvmarm/Y4jasyxvFRNvvmox@google.com/

Ricardo Koller (3):
  arm: pmu: Fix overflow checks for PMUv3p5 long counters
  arm: pmu: Prepare for testing 64-bit overflows
  arm: pmu: Add tests for 64-bit overflows

 arm/pmu.c | 217 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 133 insertions(+), 84 deletions(-)

-- 
2.39.0.rc0.267.gcb52ba06e7-goog

