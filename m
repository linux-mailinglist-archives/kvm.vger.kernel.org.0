Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286435A7223
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 02:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiHaAA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 20:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiHaAA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 20:00:56 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91DC65663
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:00:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-340a4dcb403so170756977b3.22
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 17:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc;
        bh=42ZKZUKEACOqOwxllrIMuiao4nS/i8OaBeFN19Oc9tA=;
        b=U9MfYgmHUpcD0sfp2E3bKFAs8HKOys/wJtjBHpS1Puv0v3v/DcKziJEm0azWwocwiz
         MdVT+/Dn2W0lpc4Y0FG16bxHJEdDzi9uUSrCzBaJHCwXXmGdeoilreHPc5SraBvlX9uu
         LuIZhqj34ku0RLajJ1xVE+o1lpFAguTSuHfoknphur/e4sTl47gI+JU2U32KbfjqQrzG
         PdtSYZp5rbSYAiBirzwzHJO4vd3KBZgpWUFzRu+Xr7oCQRGwWVnbDze35SOqzFA5D5mM
         3tU3e9GWEXzXUD+lTcz+Cpk/a60+4CzJke8hSWgZaYCAak7wISUTcJovBTa5jMVOmaCh
         vHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc;
        bh=42ZKZUKEACOqOwxllrIMuiao4nS/i8OaBeFN19Oc9tA=;
        b=2kS5imv1/tDIz5Xd6tN5y7wfp1TygTfED+DIIHawGLeFMlbrTRuPx/pKVeQaHBHikc
         CInNWvgBHnmJYUGvYs8L8t8A8tFSsgtf0y4BenqJQ454nH+7bViKs7zwcTGup/Pdcupu
         2stJjoqyRHlqsECeHGsJRdKQRC99K1ZuZ0FusiFERFAhAXA4OHsEXqyqJDZ0+cxpibA+
         hmFytwuFOVKgwu7ZjcZBjb1sqJd5u5LbQtK7U9IijdT8bGE0CznU4dTO0vCEuCY6FKXn
         /TMHEeTr/mx0Y9E6mCCZadFu7MoR7TRiDZU/PBb0yOavtongzCPwWxhletEmnJszSqX1
         DfvA==
X-Gm-Message-State: ACgBeo3e5GQf/242gKwx0uaHfRazMGUffZnq4uV21h8EjlUatvBn82SW
        aUBdTGnMWbU1MWnx3nXdR+DgJpo8yiw=
X-Google-Smtp-Source: AA6agR4U0RYmf+/+hhqGfCPdNyT5ysP871d7rjWcMFncp11hWOSvlwdHdt9ghc6Ey21VZmI9++rdgF7s2ps=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e650:0:b0:341:85d:f480 with SMTP id
 p77-20020a0de650000000b00341085df480mr10031151ywe.161.1661904054210; Tue, 30
 Aug 2022 17:00:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 31 Aug 2022 00:00:48 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831000051.4015031-1-seanjc@google.com>
Subject: [PATCH v3 0/3] KVM: x86: Intel LBR related perf cleanups.
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
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

WAS: Bug fixes and cleanups related to KVM's handling of PERF_CAPABILITIES.

Fix a bug where KVM incorrectly advertises PMU_CAP_LBR_FMT to userspace if
perf has disabled LBRs, e.g. because probing one or more LBR MSRs during
setup hit a #GP.

The non-KVM patches remove unnecessary stubs and unreachable error paths,
which allows for a cleaner fix for said bug.

v3:
 - Drop patches for bug #1 (already merged).
 - Drop misguided "clean up the capability check" patch. [Like]

v2:
 - https://lore.kernel.org/all/20220803192658.860033-1-seanjc@google.com
 - Add patches to fix bug #2. [Like]
 - Add a patch to clean up the capability check.
 - Tweak the changelog for the PMU refresh bug fix to call out that
   KVM should disallow changing feature MSRs after KVM_RUN. [Like]

v1: https://lore.kernel.org/all/20220727233424.2968356-1-seanjc@google.com

Sean Christopherson (3):
  perf/x86/core: Remove unnecessary stubs provided for KVM-only helpers
  perf/x86/core: Drop the unnecessary return value from
    x86_perf_get_lbr()
  KVM: VMX: Advertise PMU LBRs if and only if perf supports LBRs

 arch/x86/events/intel/lbr.c       |  6 +---
 arch/x86/include/asm/perf_event.h | 55 ++++++++-----------------------
 arch/x86/kvm/vmx/capabilities.h   |  5 ++-
 3 files changed, 19 insertions(+), 47 deletions(-)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
-- 
2.37.2.672.g94769d06f0-goog

