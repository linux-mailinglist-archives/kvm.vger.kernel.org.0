Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5747ADDD6
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 19:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbjIYRfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 13:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjIYRfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 13:35:02 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FE810D
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:34:55 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-692ad939c8cso6564538b3a.0
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 10:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695663294; x=1696268094; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+fRgk1GXWHwlF4dpNW6mrZozuiwZl1grW/0QNwyM28U=;
        b=uF0CS2nx+a+rOpH2PJzzRfPj1Pia8oYK53zE0F57AY/Jcx7tmMXs5uLsXem+x0YWyn
         loU0oq1orpFDvTN2IV4f2ykJaNYm1U/KXHrYc9NDzPO01lm9RnXnVvZ0cpGZUdr8A+fs
         l3T7h1D6Y/iP1YQq93MwunIdXRI2LZDiH/KXKAn6OvsE6KADv7iKxIQTRtgUd37kWxev
         2fCmgMrgHHUr0KRRFh56/wUwAEVr3Wlbghe1OPfvX1KZ3fb2NCPx3h7/Ujk8FAc/2AWH
         Qg1rrj79In1nargCzXGr1CvGwtYVF43s8BvWsVJL28GWdY+G4Cydc0semJQwsRbRv/Gv
         Pm9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695663294; x=1696268094;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+fRgk1GXWHwlF4dpNW6mrZozuiwZl1grW/0QNwyM28U=;
        b=VvQ3FCr6UbuKhJ8grRdGpuVjpaV5SrXH63sVifq+Dpp4hhJbssJgQ7AWCW09eR+qPN
         bIGoenKJSdyr8Uk7G+AyHKkUQxWy3gPKUSXhnw1Q3bvb9jQdYDDPy+8slHY1AP3lSTl3
         937UNhq15X7YudKfrkGNKUYZySo8uz9CS5ZOjzm1Vpt7FsVUjEKIUJZrfmFfC89Ubmim
         b9wL3oEVjZtD9/x4IylGaAaUgQNUKkviqGE1HK00ZlA4avkBROroO+dchAYy54xfOvpm
         0cJVaiLWHJGfMBSaZQPxMzTf1sMQA2udJaavMRBLikOhncS9bRJgbV70ECTACLqXajXN
         L/bQ==
X-Gm-Message-State: AOJu0YwJLoLYpFSGskcDSxEPiK7Kp10/ZpOO1cGsPqKQLAU/zFSyH+Fh
        fttJNtN69T4gtNbPbZsHAZ3Rtcv/6LWr
X-Google-Smtp-Source: AGHT+IEIa67JHm4iGq6IbgmEn/O9A05ePGGUAl+33vpiM8knnCja047dfXJXmwFR+tsyhsegkC0w5pFB6gU4
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:3a27:b0:690:29c0:ef51 with SMTP id
 fj39-20020a056a003a2700b0069029c0ef51mr6884pfb.1.1695663294680; Mon, 25 Sep
 2023 10:34:54 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 25 Sep 2023 17:34:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230925173448.3518223-1-mizhang@google.com>
Subject: [PATCH 0/2] Fix the duplicate PMI injections in vPMU
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we do stress test on KVM vPMU using Intel vtune, we find the following
warning kernel message in the guest VM:

[ 1437.487320] Uhhuh. NMI received for unknown reason 20 on CPU 3.
[ 1437.487330] Dazed and confused, but trying to continue

The Problem
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The above issue indicates that there are more NMIs injected than guest
could recognize. After a month of investigation, we discovered that the
bug happened due to minor glitches in two separate parts of the KVM: 1)
KVM vPMU mistakenly fires a PMI due to emulated counter overflow even
though the overflow has already been fired by the PMI handler on the
host [1]. 2) KVM APIC allows multiple injections of PMI at one VM entry
which violates Intel SDM. Both glitches contributes to extra injection
of PMIs and thus confuses PMI handler in guest VM and causes the above
warning messages.

The Fixes
=3D=3D=3D=3D=3D=3D=3D=3D=3D

The patches disallow the multi-PMI injection fundamentally at APIC
level. In addition, they also simplify the PMI injection process by
removing irq_work and only use KVM_REQ_PMI.

The Testing
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

With the series applied, we do not see the above warning messages when
stress testing VM with Intel vtune. In addition, we add some kernel
printing, all emulated counter overflow happens when hardware counter
value is 0 and emulated counter value is 1 (prev_counter is -1). We
never observed unexpected prev_counter values we saw in [2].

Note that this series does break the upstream kvm-unit-tests/pmu with the
following error:

FAIL: Intel: emulated instruction: instruction counter overflow
FAIL: Intel: full-width writes: emulated instruction: instruction counter o=
verflow

This is a test bug and apply the following diff should fix the issue:

diff --git a/x86/pmu.c b/x86/pmu.c
index 0def2869..667e6233 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -68,6 +68,7 @@ volatile uint64_t irq_received;
 static void cnt_overflow(isr_regs_t *regs)
 {
 =C2=BB......irq_received++;
+=C2=BB......apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKE=
D);
 =C2=BB......apic_write(APIC_EOI, 0);
 }

We will post the above change soon.

[1] commit 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions=
")
[2] https://lore.kernel.org/all/CAL715WL9T8Ucnj_1AygwMgDjOJrttNZHRP9o-KUNfp=
x1aYZnog@mail.gmail.com/

Versioning
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The series is in v1. We made some changes:
 - drop Dapeng's reviewed-by, since code changes.
 - applies fix up in kvm_apic_local_deliver(). [seanjc]
 - remove pmc->prev_counter. [seanjc]

Previous version (v0) shown as follows:
 - [APIC patches v0]: https://lore.kernel.org/all/20230901185646.2823254-1-=
jmattson@google.com/
 - [vPMU patch v0]: https://lore.kernel.org/all/ZQ4A4KaSyygKHDUI@google.com=
/

Jim Mattson (2):
  KVM: x86: Synthesize at most one PMI per VM-exit
  KVM: x86: Mask LVTPC when handling a PMI

 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/lapic.c            |  8 ++++++--
 arch/x86/kvm/pmu.c              | 27 +--------------------------
 arch/x86/kvm/x86.c              |  3 +++
 4 files changed, 10 insertions(+), 29 deletions(-)


base-commit: 6de2ccc169683bf81feba163834dae7cdebdd826
--=20
2.42.0.515.g380fc7ccd1-goog

