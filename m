Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F3436768E
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 02:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbhDVA5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 20:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240981AbhDVA5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 20:57:11 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F9DC06138A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:56:37 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id e20-20020ad442b40000b029019aa511c767so14796670qvr.18
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 17:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NzxbZ+GAahgmxduXaRkOwY3LO03b4qVXF2kZFZVIV+M=;
        b=EY/Bkrwt7EOV0vOcFdHrNNLfJEudSb/z5dFRNAUDXJY6GzahV2RUbyBuxe43j5Ba/c
         37spJaQTJBA0XFya0TgE4ej7IfVEGU101kUiAdOEvipDBhjCIMth9aD+rTPMJIdwPaPg
         hcn7HCpOfL+gSOCUrgHTnzfsgYufCUfBlSF79muCJ7O3urR5Xr191bTTgniB/VglLH3B
         7qRpKMq8OMdWCjkovJKPox5LSfC4Y5RaQeKkigl3WkCVqvCdBVXtbk9dquRZ4wkt7QI+
         ZhKMowSwhzz2u/Ubd4zQWQK5WtVPcIQ9RxH4LaNWB/NCG6JRXIfsAmTifEaDku7qKosz
         RVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NzxbZ+GAahgmxduXaRkOwY3LO03b4qVXF2kZFZVIV+M=;
        b=VpMR/OIdTVx4BraOhfnTF2zICQoluoJaOWd+ntrLKBShklqsYns+Y/oEXFyQitUbBF
         ekv79GGzQ/9XXLNVBZacxoabfe1lK68xw0XHYWfgHoK/8yNbtshTmlqV7QAGYcC5o65E
         0n3f2NHu81md/JGxnX+onO6aqisI07c3/fW6jZSaWQYJiTZPhVqHVKS2dSvcoj6OAyar
         tOfu/A0XTCW3pXuV4EQdgYWekCHO0UqDBzlgb5l0jTEsWTonTMBV2cQBf4PC9VJRWBw1
         niUopfjHQuhipXafTd7ncA6Bb5DuI9aPBPti5oDs9d3thnm4Kb6fvUJkfA2Qa1JaQJqd
         4AMg==
X-Gm-Message-State: AOAM533IFuyeYe2+QaXTt9qejbdYjulcZ8ctx1gUeIG0cSiRhM2F5Jr5
        8TpH14Pypea81LwrVL4YwCN8WehtKDllzg==
X-Google-Smtp-Source: ABdhPJxAui1HQQb7EtOlgCHADfQilI+gHPBuOzi2tKt6XDOLsse2UiM5wVgrbw2fJk3VLdwlUNTHNMLXKlLN7Q==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a0c:9ad7:: with SMTP id
 k23mr702884qvf.24.1619052996218; Wed, 21 Apr 2021 17:56:36 -0700 (PDT)
Date:   Wed, 21 Apr 2021 17:56:21 -0700
Message-Id: <20210422005626.564163-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.368.gbe11c130af-goog
Subject: [PATCH 0/5] KVM: x86: Use kernel x86 cpuid utilities in KVM selftests
From:   Ricardo Koller <ricarkol@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kernel has a set of utilities and definitions to deal with x86 cpu
features.  The x86 KVM selftests don't use them, and instead have
evolved to use differing and ad-hoc methods for checking features. The
advantage of the kernel feature definitions is that they use a format
that embeds the info needed to extract them from cpuid (function, index,
and register to use).

The first 3 patches massage the related cpuid header files in the kernel
side, then copy them into tools/ so they can be included by selftests.
The last 2 patches replace the tests checking for cpu features to use
the definitions and utilities introduced from the kernel.

Thanks,
Ricardo

Ricardo Koller (5):
  KVM: x86: Move reverse CPUID helpers to separate header file
  x86/cpu: Expose CPUID regs, leaf and index definitions to tools
  tools headers x86: Copy cpuid helpers from the kernel
  KVM: selftests: Introduce utilities for checking x86 features
  KVM: selftests: Use kernel x86 cpuid features format

 arch/x86/events/intel/pt.c                    |   1 +
 arch/x86/include/asm/cpufeature.h             |  23 +-
 arch/x86/include/asm/processor.h              |  11 -
 arch/x86/kernel/cpu/scattered.c               |   2 +-
 arch/x86/kernel/cpuid.c                       |   2 +-
 arch/x86/kvm/cpuid.h                          | 177 +-----------
 arch/x86/kvm/reverse_cpuid.h                  | 185 +++++++++++++
 tools/arch/x86/include/asm/cpufeature.h       | 257 ++++++++++++++++++
 tools/arch/x86/include/asm/cpufeatures.h      |   3 +
 .../selftests/kvm/include/x86_64/cpuid.h      |  61 +++++
 .../selftests/kvm/include/x86_64/processor.h  |  16 --
 .../kvm/include/x86_64/reverse_cpuid.h        | 185 +++++++++++++
 .../selftests/kvm/include/x86_64/svm_util.h   |  11 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |   6 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |   5 +-
 tools/testing/selftests/kvm/steal_time.c      |   5 +-
 .../kvm/x86_64/cr4_cpuid_sync_test.c          |  23 +-
 .../selftests/kvm/x86_64/set_sregs_test.c     |  25 +-
 .../selftests/kvm/x86_64/vmx_pmu_msrs_test.c  |   8 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c    |   5 +-
 .../selftests/kvm/x86_64/xss_msr_test.c       |  10 +-
 21 files changed, 749 insertions(+), 272 deletions(-)
 create mode 100644 arch/x86/kvm/reverse_cpuid.h
 create mode 100644 tools/arch/x86/include/asm/cpufeature.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/cpuid.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/reverse_cpuid.h

-- 
2.31.1.368.gbe11c130af-goog

