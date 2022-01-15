Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA7A48F4EC
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 06:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiAOFYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jan 2022 00:24:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiAOFYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jan 2022 00:24:43 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80293C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:43 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id w195-20020a6282cc000000b004bdce57da98so3093725pfd.5
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1OOJjIJzsfYox4VRrNoUCp4CbcUM8/AlP6XykWkhfHU=;
        b=pY8+mpP8JLc3i6qsWvP/l5pbSHqAlqIGD4uBcV4b9tRBExy8l1AuGKgnfDGa6llWOg
         afhF+01Fyt67a3nEMynIcd3ZL7JS1QTQR1NU/UphfJCnUR92QnuxQUJAs+Mx0ljZSgyz
         uNbRI2mWmqeh+jQfxxOHN2aMqq9Y0utrZGhaJUxGKsDKME9mgSAnqK/8+RQwPbV26gUo
         7Wt/uvuJ9nQfTmVLp6aD3aCmfnnOLITEsMx0FUwpEGDl43aBzZ+oJc0l7XSsTXu1VOpx
         opMb4NIRt2GjhK7OgSxyVTtT1uBchaeKNOSF3mqS3EG3rQZwNJVBZEueOTUr3/8lNRbT
         78dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1OOJjIJzsfYox4VRrNoUCp4CbcUM8/AlP6XykWkhfHU=;
        b=mPbot0OFGQF1OejX+mmWxM/V8pyXD5T4Xh3OYuiCDIUe/Lbd4m47dzk2luKW/Oiijy
         42UObvOi5oZVe0O5vOk8gdec2PLXmUxHUdIFjUw2W8iYdlOAdrInWBJCByI8t0PIVBqx
         nssa6E0YETiNe21UdIJHE9XAuT5iBBSFkUdGGFzai4iuR4MmMbxcjD7c4/uF319NFe8X
         eEwx8Aao2xgvlINqMvQU03nTCroO+D0fTr7kftNNSxGP2uUnsslHhKwD5fvD94Z2KFFo
         25nCauvolGkiibCxGtyYrvysjvobjhN4Ga68Qfe2ZIy4piclsxBr5iEJPhw80G4IKf3q
         /SLA==
X-Gm-Message-State: AOAM532xiMs+7/k0wnKm8TRV5uSXKyJ7S4J+E3qjuYL/e3fAzDwqibKO
        8akL/XwYcSKFBqBydVdVkTUtBeGWF/nqHmn+yyZkZJsdFqzIeP/QinrucE/UnvSJtfHI9/8vtCT
        EkGRqCe66ZIWVoopfXkk4LbdDVFm6HaA2bkm16RGD5/x2hApmErnKdnmV2razDFE=
X-Google-Smtp-Source: ABdhPJwPuT/hCH3VMMGTySAsD1w+nCvgVYi+AqZJjmoxPvBPDgsyp2qsa1s3xWiGsZC+5CPWbOJVT3pe1shy7w==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90a:2a4e:: with SMTP id
 d14mr716493pjg.0.1642224281831; Fri, 14 Jan 2022 21:24:41 -0800 (PST)
Date:   Fri, 14 Jan 2022 21:24:25 -0800
Message-Id: <20220115052431.447232-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v3 0/6] KVM: x86/pmu: Use binary search to check filtered events
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        daviddunn@google.com, cloudliang@tencent.com
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

I'm not referring to erratum 1292, though that throws even more
brokenness into the mix. Apparently, a #VMEXIT counts as a "retired
branch instruction." The Zen family PPRs do say, "This includes all
types of architectural control flow changes, including exceptions and
interrupts," so apparently everything is working as intended. However,
this means that if the hypervisor doesn't adjust the counts, the
results are not only different from bare metal, but they are
non-deterministic as well (because a physical interrupt can occur at
any time and bump the count up).

v1 -> v2
* Drop the check for "AMDisbetter!" in is_amd_cpu() [David Dunn]
* Drop the call to cpuid(0, 0) that fed the original check for
  CPU vendor string "AuthenticAMD" in vm_compute_max_gfn().
* Simplify the inline asm in the selftest by using the compound literal
  for both input & output.

v2 -> v3 [only the selftest is modified]
* Literally copy ARCH_PERFMON_EVENTSEL_{OS,ENABLE} from perf_event.h,
  rather than defining semantic equivalents.
* Copy cpuid10_e[ab]x from perf_event.h for improved readability of the
  code that checks CPUID.0AH.
* Preface the guest code with a PMU sanity check, so that the test will
  skip rather than fail if the PMU is non-functional (disabled by module
  parameter, unimplemented or disabled by parent hypervisor, &c).
  [David Dunn]
* Refactor and rename the Intel and AMD PMU checks.
* Use the is_amd_cpu() code from an earlier commit in the series (as well
  as the is_intel_cpu() code).
* Add a check for at least one general-purpose counter on the Intel side.
* Change each of the Zen family/model checks to include the sixteen model
  number range specified in AMD's "Revision Guide" for each generation of CPU,
  rather than the single model number specified in the associated PPRs.

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
 .../selftests/kvm/lib/x86_64/processor.c      |  40 +-
 .../kvm/x86_64/pmu_event_filter_test.c        | 437 ++++++++++++++++++
 6 files changed, 492 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c

-- 
2.34.1.703.g22d0c6ccf7-goog

