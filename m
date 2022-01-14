Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F312948E214
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 02:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235998AbiANBVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 20:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiANBVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 20:21:18 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B072BC061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:18 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id b7-20020a639307000000b003428e51f24dso923013pge.15
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VNWleEEnwlAJHJK1Adhn4cP+JarFtGqoFJu3rQaTca4=;
        b=BjZka5iTsl4CakMqTbsvMr+MFCc63oLAJcgcPhRfGOlxu5lG24RP9RhwujxC3zgQ1C
         17ScRE/qHUF/Z9rg2N0wEpOxiJQ3f8Xhzz5NwegEQW5ixywRHVEGAPFHt7SzAJJjeptC
         NgP0HldJJVqoURgG8Rd6K5XmPUcGJRFBRqbILIxRfayDojwsAJUSWXf6y1Ae9MfivTA4
         VjsmrHXu/RbsrsEKu0W8LWQ+y1Sb43TC4VOnK++IZ6ECSYNq3rpnfm3Lg4kQlwzMqCcu
         lZuY9sN8G1lxgMYcQUXyQerU6eHkUG6W5GCarCSnEOX5lB7NGFT4Dak6Qcg5Dk2XV2dc
         Gkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VNWleEEnwlAJHJK1Adhn4cP+JarFtGqoFJu3rQaTca4=;
        b=Rc9h5EQMTJO3q7uPDNZh2qLMtyMkkU8VjKqoNVtPS4Dy8F2kSy7jehhjzMHXRJfC7D
         kzjGg32IKNGsTfxqPTTazah1JHUBA2ro3Fj8zST53OeeLFTL1wUUjbe626LUcaP4brHV
         z6kbnO1y9lT5pMJZ/CILBDHlSJngkwUoLgWFtzRVw7VH5S00ZAw4yOe6zQspnf694Ue6
         tmbaZ2iXngHXpymRH4Gezsqir+m+CGknNUwzM6QWTtW2GHGKqySs5iKIBZbOT+0so4xS
         MSx0u9uC4ycX/V1Pto6zz9BZnDtfTEj3vN2B9BGISVRJTwFLmKp+NiqDUlIuhyvs7Gp2
         fElA==
X-Gm-Message-State: AOAM53027NMl9Q5vX/+8U0RDEOChwKHDCZB4Jk+5c8HDfsOZNw+g4UOs
        MtvQWAFADkKBSIQALW6cqNHX0gk8R0/3030OVrGo+raJ2V6mj+6xajMw5rtaykDxnprEjTm6VXb
        HBnwGAmTewUutosg95SKm5b0xWW9mWuKYio9ZNcOKwprnwT8vcHkbTe88oQ8to6k=
X-Google-Smtp-Source: ABdhPJwkHzSbZjWddJYpev5zc9yNoQpovXjB61zNwCHBnSDTs3+5yg/EqhczoEbJln88dwVzGfvA7nSLDQ8+rw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90a:458d:: with SMTP id
 v13mr17015593pjg.202.1642123277905; Thu, 13 Jan 2022 17:21:17 -0800 (PST)
Date:   Thu, 13 Jan 2022 17:21:03 -0800
Message-Id: <20220114012109.153448-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 0/6] KVM: x86/pmu: Use binary search to check filtered events
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
virtualization is broken. And I don't just mean erratum 1292, though
that throws even more brokenness into the mix.

v1 -> v2
* Drop the check for "AMDisbetter!" in is_amd_cpu() [David Dunn]
* Drop the call to cpuid(0, 0) that fed the original check for
  CPU vendor string "AuthenticAMD" in vm_compute_max_gfn().
* Simplify the inline asm in the selftest by using the compound literal
  for both input & output.
  
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
 .../selftests/kvm/include/x86_64/processor.h  |  18 ++
 .../selftests/kvm/lib/x86_64/processor.c      |  40 +--
 .../kvm/x86_64/pmu_event_filter_test.c        | 306 ++++++++++++++++++
 6 files changed, 361 insertions(+), 35 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c

-- 
2.34.1.703.g22d0c6ccf7-goog

