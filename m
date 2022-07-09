Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C9956C5A8
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 03:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiGIBRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 21:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIBRi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 21:17:38 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70537CB67
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 18:17:37 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e8-20020a17090301c800b0016a57150c37so165328plh.3
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 18:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4G6WciLlcFaaYzvm6o8m5nBzIy5T17V7u1v1KAey+vw=;
        b=tIlz4vC6WjJwBEcvU78FIO20cNPe2e8reeY1mNNZ49RwzNX4o32so3+h3UakX19YY3
         7nxk3twAIiCwHKBgC7UWDFaHjVPYN6vPt/GwL9HzEtsjHD1qIkPrNu7SCAhJHyM4lBZj
         zpQ0gJXMm7Az1D+D/rim5oX7jrMr1153w4YH8gwQCr0B7H2M2j1dpUK9HYNwtF6FtK46
         AdvdXfhmjGYY7YNxk16E/AZW4B2j2ALir6PFES/sPJSR3dKN3SB7BJ4qQ9uhlHs/zp/M
         dm5pZ6YD1BjYAzE0xqg6nevvg9fLZ8yJPLyvy3P2oIVnkr26qJNlqqb50zMMp32rF8y9
         zYxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4G6WciLlcFaaYzvm6o8m5nBzIy5T17V7u1v1KAey+vw=;
        b=numOOxk/CrtKUwY1W3IQEv2xJMBE4q/tgVkVkGowMYq2JLI2Aed4GEDCfgpxdPg3Vo
         o3daouAef/p2wMOtk7w/qo2TuMiWanna5jlEzShrYCb8oHLvI+pgIn5lAmwgE0+Vlvhp
         yaPdgWOwooy4a0PtRgUv39q0Lbcpkk1fyuSV6VbshvZJvwZVZQu6CGQP7Ex6l1J9bdRy
         FIlPtg6zjI0Ce9qsD0wLA/DWcOM3ZfVPejNkpTGkTg9CkVIVrpsrZWvcSlH//WG2mLO8
         dwM1OyQAYCBUtdVj4ATYaQrYISnZaJ8I6dy4ns0ElCrQmOvh5OSUMxHpRattDEb/nfbZ
         pM1A==
X-Gm-Message-State: AJIora/q0hj6Bwv0usV8h+WPUnYelYJGg/NuXWtJLVn/Mz1U2rRrm8cU
        /+tBlxGj9jETAYixAbFpNf0FVwd4RCJ1vReZliOro/B4OVdgZ84kgmdUUJNWbYi1lm+KxI2ATEi
        1E7hOdBY6nrvGanZlmdd6ZWZvp1F0KDiOEs++Yg+mSBOuKZ0cCar6OSA2Ir3g+SEfN2y2
X-Google-Smtp-Source: AGRyM1vUJCIB7e9JU47ZRq7G/DuIWF9kf6/U/yCLWV5xYKShwpXdAyG2JyvoglJRSS3Y6kbwcUtYMAsUKWukJVCp
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:148d:b0:528:3d32:f111 with
 SMTP id v13-20020a056a00148d00b005283d32f111mr6264104pfu.31.1657329457056;
 Fri, 08 Jul 2022 18:17:37 -0700 (PDT)
Date:   Sat,  9 Jul 2022 01:17:21 +0000
Message-Id: <20220709011726.1006267-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v3 0/5] kvm: x86/pmu: Introduce and test masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

This series introduces the concept of masked events to the pmu event
filter. Masked events can help reduce the number of events needed in the
events field of a pmu_event_filter by allowing a more generic matching
method to be used for the unit mask when filtering guest events in the
pmu.  With masked events, if an eventsel should be restricted from the
guest, instead of having to add a new eventsel for every unit mask, one
encoded event can be added that matches all possible unit masks.

v1 -> v2
 - Made has_invalid_event() static to fix warning.
 - Fixed checkpatch.pl errors and warnings.
 - Updated to account for KVM_X86_PMU_OP().

v2 -> v3
 - Reworked and documented the invert flag usage.  It was possible to
   get ambiguous results when using it.  That should not be possible
   now.
 - Added testing for inverted masked events to validate the updated
   implementation.
 - Removed testing for inverted masked events from the masked events test.
   They were meaningless with the updated implementation.  More meaning
   tests were added separately.

Aaron Lewis (5):
  kvm: x86/pmu: Introduce masked events to the pmu event filter
  selftests: kvm/x86: Add flags when creating a pmu event filter
  selftests: kvm/x86: Add testing for masked events
  selftests: kvm/x86: Add testing for inverted masked events
  selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER

 Documentation/virt/kvm/api.rst                |  52 ++++-
 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   1 +
 arch/x86/include/uapi/asm/kvm.h               |   8 +
 arch/x86/kvm/pmu.c                            | 135 +++++++++++-
 arch/x86/kvm/pmu.h                            |   1 +
 arch/x86/kvm/svm/pmu.c                        |  12 +
 arch/x86/kvm/vmx/pmu_intel.c                  |  12 +
 .../kvm/x86_64/pmu_event_filter_test.c        | 208 +++++++++++++++++-
 8 files changed, 407 insertions(+), 22 deletions(-)

-- 
2.37.0.144.g8ac04bfd2-goog

