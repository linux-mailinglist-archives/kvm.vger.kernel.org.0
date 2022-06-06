Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13FC53ED41
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiFFRxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 13:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiFFRxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 13:53:41 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2F614640D
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 10:53:39 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x128-20020a628686000000b0051bbf64668cso6954505pfd.23
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 10:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4auT6wLIBZL5tFbfEv7oXjy+Lji/X1yRo01RkLY/J9o=;
        b=pxmLVNW5ddfoLYYzpVB0mF1mbR8HaO9dIGFFEWNVVrPYTegZciXWRRnoHWiuEbOVen
         ClI+pCrC0nHiD1EepmIJaIhrl7iouUvGXbSnluXCSw92srshsAK3sU1lfwrNC/eDLhm7
         rsRV8DF6LAXUTfv8J8a8ZzYd4zI2ZGbS2up1lj1bs0HQohpgzHyp8F/B9alM2MiX+hA7
         QcFTrVXoWNU1qnDzkmOSAFhEcLwx8PiwhPzOogzKQgPyqjE6egCy6mu341s4D4+rJVVH
         q1XhDlhJrkMpdyL+TcBUyqrJ/mkZ9Vpe3KSDr1vRXTUXjADxyIjKMBhle2NGjF9GzYNv
         hRjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4auT6wLIBZL5tFbfEv7oXjy+Lji/X1yRo01RkLY/J9o=;
        b=hSRUcz4WREPJZhbtdtVSAT1pKvOZZ6PURlYCdGRCugs8Re1Bv61oK2qM2620qlvIId
         ZGLfzcZNYbyYemiKdZ/gWOzCzUPTGMPiEwII49DvdGYuxLB93F34heQKPRXz2V3AEXPR
         vg7W9VReDSCFeG9Pzsvy7QNKlT+O/qz2sRDiXhQJC++Ywi3F5zKcQVEhr5dC0FujNSC8
         Ghpo1xFB0Rrr+INky0mKubUJWcUQkMT8HCIjgxcos9N6ma0/LmEiW2VZ755qMNvTPg+u
         h7XCSSpwk/nKgdaAqgNPAXCYWWUPTdqJgyVIY1CIxakz/cXCDmv+puxB58bURNShj2Oq
         4aAw==
X-Gm-Message-State: AOAM5306AAWLxF2WqWDyAkl9lpHVRomQHSoZbkkznuEQnPnDW1XzuZK/
        rb1MdcIx+yWErNYssNVFbUepnBkBl9IZAxwMGJ4u3H+Lzym6iya12ibvW+5csMqMRwuoh1grWv6
        P83TNjwE+SIEA2umy72y9yCDRMFwKGtlY6gErBdl4CsCxRZM3WiBzk7uDpWbeHzkqmau4
X-Google-Smtp-Source: ABdhPJz7tAVwtpKx5FHDiSCklgvBsIZ2KfNp6yr0wqJNYgfPj0dT9hyTa5mfHvl7PLFVciSZHIgO+6KPUI9KgG2u
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:4b0f:b0:1e8:53ac:ec51 with SMTP
 id lx15-20020a17090b4b0f00b001e853acec51mr14860194pjb.78.1654538019291; Mon,
 06 Jun 2022 10:53:39 -0700 (PDT)
Date:   Mon,  6 Jun 2022 17:52:45 +0000
Message-Id: <20220606175248.1884041-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 0/4] kvm: x86/pmu: Introduce and test masked events
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

Aaron Lewis (4):
  kvm: x86/pmu: Introduce masked events to the pmu event filter
  selftests: kvm/x86: Add flags when creating a pmu event filter
  selftests: kvm/x86: Add testing for masked events
  selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER

 Documentation/virt/kvm/api.rst                |  46 +++++-
 arch/x86/include/asm/kvm-x86-pmu-ops.h        |   1 +
 arch/x86/include/uapi/asm/kvm.h               |   8 +
 arch/x86/kvm/pmu.c                            | 128 +++++++++++++--
 arch/x86/kvm/pmu.h                            |   1 +
 arch/x86/kvm/svm/pmu.c                        |  12 ++
 arch/x86/kvm/vmx/pmu_intel.c                  |  12 ++
 .../kvm/x86_64/pmu_event_filter_test.c        | 147 +++++++++++++++++-
 8 files changed, 333 insertions(+), 22 deletions(-)

-- 
2.36.1.255.ge46751e96f-goog

