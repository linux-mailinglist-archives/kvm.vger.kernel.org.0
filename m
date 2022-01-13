Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FD148D005
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 02:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiAMBPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 20:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbiAMBO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 20:14:58 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7453AC06173F
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:14:58 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id p8-20020a25bd48000000b00611be5dd7eeso293185ybm.19
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 17:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=02fxcquOFWiVZbyijUl6csyt+CrjnCUeboucPAYgnHw=;
        b=BKy4rXxLX1cWJpTvAff/I78KaJ/+Wj10obq3XLeXGXwk9VNRLJICzH5iLm+KghTHDj
         EqyRm4+q2Oiy8GigusXR59pgHFWhR6+8LQuQzLqd/uu9JoxIL3drPupyd7MBBSdLqQSR
         8Un+VDNDlbcomkzpyjsnHZSjxherMKz9MRGbbDxyC8bMAP67xbgK5Yv2AGjHuyzKoIn2
         rdLP24wyP8a842CXGxpeqG7+PGtILXu2VLhJ1n+4RTalXAFvgFQGjvzPhelA5sXDOwL0
         3m3/L2Fm8nyatYAA+UMUwbwUQ3bDvEbwC28LKxbufoJG7V0OYv1TrPwWW5cXGBPoua16
         iwsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=02fxcquOFWiVZbyijUl6csyt+CrjnCUeboucPAYgnHw=;
        b=e8Q0SN9+GmmsmCbvAvxtXFePEOfRgCBgLzpNIezxrM0+1nQLo1Zl7Kh60prtBkJ+tK
         mvpEw1EAtwdFAHJPtL6Vk8kZ4o8AXEDqnn7GWk5WaA2znoSJ96jDxEX7gswBHupE7NDU
         65xQLOO/gRlvxPcQIn04yFJyj+BPHrGf08Q1gTk+AegZT8XPPxYF1HUvSD4g8KD3+Sif
         zhnB1SKE2aezGvr/bPeJkf9W4EpSKmSbV9ICxAd0xcduMzqRxXF6mziCvzQWiW7v2u4d
         e3ujFgaYZx6EvBLGWhKrzHAEwD/+SzcRhSlRoERHKndlcjquLg3WoEnsbwkQReQ7+os6
         ACwA==
X-Gm-Message-State: AOAM532x6Q2063xqLwEphFt2VLsMM1g73FleeiaE/nZuROiO7c9Yif3A
        cyZRULwsdDDlG5eQ6VzXYP+ChTjbSUM9+yn/+QKqn6TP9znO+Xdge2G8wV3jyKte1227lBvBbc0
        8+8FvV62VnG2Nr5PA3QieCdiHxRVh0cqnWDBVFwalhQLVAzOR6SL/3mQ+x9clYT0=
X-Google-Smtp-Source: ABdhPJxoBqrexJToSuA7q8fDci85V6P31w3AEyTkgcWc4ymoli84Qm/WANqcSSqg0KFhUsvFntdpW5mQmeTcUw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a25:db93:: with SMTP id
 g141mr3150511ybf.131.1642036497572; Wed, 12 Jan 2022 17:14:57 -0800 (PST)
Date:   Wed, 12 Jan 2022 17:14:47 -0800
Message-Id: <20220113011453.3892612-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH 0/6] KVM: x86/pmu: Use binary search to check filtered events
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This started out as a simple change to sort the (up to 300 element)
PMU filtered event list and to use binary search rather than linear
search to see if an event is in the list.

I thought it would be nice to add a directed test for the PMU event
filter, and that's when things got complicated. The Intel side was
fine, but the AMD side was a bit ugly, until I did a few
refactorings. Imagine my dismay when I discovered that the PMU event
filter works fine on the AMD side, but that fundamental PMU
virtualization is broken.

Jim Mattson (6):
  KVM: x86/pmu: Use binary search to check filtered events
  selftests: kvm/x86: Parameterize the CPUID vendor string check
  selftests: kvm/x86: Introduce is_amd_cpu()
  selftests: kvm/x86: Export x86_family() for use outside of processor.c
  selftests: kvm/x86: Introduce x86_model()
  selftests: kvm/x86: Add test for KVM_SET_PMU_EVENT_FILTER

 arch/x86/kvm/pmu.c                            |  30 +-
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  18 +
 .../selftests/kvm/lib/x86_64/processor.c      |  36 +-
 .../kvm/x86_64/pmu_event_filter_test.c        | 310 ++++++++++++++++++
 6 files changed, 363 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c

-- 
2.34.1.575.g55b058a8bb-goog

