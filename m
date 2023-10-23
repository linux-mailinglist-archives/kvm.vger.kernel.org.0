Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368BD7D434D
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 01:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjJWXkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 19:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjJWXkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 19:40:06 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77819CC
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:04 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7c97d5d5aso54692757b3.3
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 16:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698104403; x=1698709203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6neP5ivK010SBRb0ibXYexUf8ZRbqIGhikwLVX47+yQ=;
        b=xbElmHYFUhnIKBFb6so2aaj7in7ozZtHvbYUpgx1aq3YoHjpTd8sG3hqvzY+bwCcNC
         4zRIToRxvLzRG0ZRm6wTGa2fN9onLLWvJQOq12rq30fLGyulz46Lff4YJPLQ597aGPVP
         IrV9BY0JrNe0CPMTMTFkLtB1impi99Xz7gZRQSWTgNKRPEDUQUL9dCaA6zrWzrqrIC4A
         2mYNECP2cXguTNKmCde19jxMVo96p7CY5mbjxlgq3Oyan3zUduTUH85NxJCJMQqUhAQ+
         0mBE98r2YCX61pK9Y1LIHj2TaNadJ5rnL15/Fdy/0YfIbuQ2TLfHyekF0W7gdcCj+z+P
         eB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698104403; x=1698709203;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6neP5ivK010SBRb0ibXYexUf8ZRbqIGhikwLVX47+yQ=;
        b=wsKDw9CNBcgpU6QxoKMzlNZ4QwvuOlGWlBmrGE+w2Es9CcD/ne/Mulu7rAPxie7h25
         MqONVuqgGKxG/PXSePcXfcYBow0TCfmRJHFDURzvTZWCqMryX/CRzJJYeqGyCRdvgJeE
         0eL89syGnEP6VKkatcKvIG2Kv9gMo0Wiilkgp3afyGTM03hAYj+qpmtoqGNPHaJ5km/C
         TJZjhrdMPaIlffnAS8TlMoCXQcSm8NMtP5AnRwt3jtt2afy4MxFJoboU5fQm0o5NI26L
         ajb406GabWdJQH0NRoRcC8qg+jxbyItX4yZb2nE5GxFzbiR7MX5mOtXxuAvJESwBS/KF
         CwPQ==
X-Gm-Message-State: AOJu0YyxWhikm5fYoeUaeWNYFS1VNAuwU8WkO7lQ7n26VHgeEcD7xBwe
        RX3F0d/ar76ChscloOHqK/RYiMD+tWc=
X-Google-Smtp-Source: AGHT+IGZphk2LvJvNpVHYe9/KXoI/Dz3HTFp02JVRm24AJP58EGDg5NlbGnP028g0rTzqiiIYaCkkczfT9g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d50f:0:b0:59b:c811:a702 with SMTP id
 x15-20020a0dd50f000000b0059bc811a702mr237963ywd.6.1698104403721; Mon, 23 Oct
 2023 16:40:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 16:39:54 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231023234000.2499267-1-seanjc@google.com>
Subject: [PATCH 0/6] KVM: x86/pmu: Clean up emulated PMC event handling
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Jim Mattson <jmattson@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ultimate goal of this series is to track emulated counter events using
a dedicated variable instead of trying to track the previous counter value.
Tracking the previous counter value is flawed as it takes a snapshot at
every emulated event, but only checks for overflow prior to VM-Enter, i.e.
KVM could miss an overflow if KVM ever supports emulating event types that
can occur multiple times in a single VM-Exit.

Patches 1-5 are (some loosely, some tightly) related fixes and cleanups to
simplify the emulated counter approach implementation.  The fixes are
tagged for stable as usersepace could cause some weirdness around perf
events, but I doubt any real world VMM is actually affected.

Sean Christopherson (6):
  KVM: x86/pmu: Move PMU reset logic to common x86 code
  KVM: x86/pmu: Reset the PMU, i.e. stop counters, before refreshing
  KVM: x86/pmu: Stop calling kvm_pmu_reset() at RESET (it's redundant)
  KVM: x86/pmu: Remove manual clearing of fields in kvm_pmu_init()
  KVM: x86/pmu: Update sample period in pmc_write_counter()
  KVM: x86/pmu: Track emulated counter events instead of previous
    counter

 arch/x86/include/asm/kvm-x86-pmu-ops.h |   2 +-
 arch/x86/include/asm/kvm_host.h        |  17 +++-
 arch/x86/kvm/pmu.c                     | 128 +++++++++++++++++++++----
 arch/x86/kvm/pmu.h                     |  47 +--------
 arch/x86/kvm/svm/pmu.c                 |  17 ----
 arch/x86/kvm/vmx/pmu_intel.c           |  22 -----
 arch/x86/kvm/x86.c                     |   1 -
 7 files changed, 127 insertions(+), 107 deletions(-)


base-commit: ec2f1daad460c6201338dae606466220ccaa96d5
-- 
2.42.0.758.gaed0368e0e-goog

