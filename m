Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43B8434AC0
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhJTMHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhJTMHC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 08:07:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A06C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 05:04:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so2262844pjb.5
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 05:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BCKWEoi8FeeBRDvl5EymVEm69MjyykXFzH9HAs/kyO4=;
        b=cuiutl2QAAxfwD56hLItqR8kvhCEQ7NLO3pkxhfHS9+G/fMLr1/t8rKVJEqmHJiNpb
         CZ21EE6qwrk20h7kpm27tNC/c4jVdseWv2S9gIsftsOTHCsJLoVZJc0mJkI8+oObIRwY
         pMNdJZGPHl1m5HRFt9dwroghBaTQXLkVX66aE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BCKWEoi8FeeBRDvl5EymVEm69MjyykXFzH9HAs/kyO4=;
        b=TZojKUBtTXSfNUAGnh538WzouEdNagFY+9bm8Yo4/qZqwUZiRmqtsOA6MIZ/Pg67w4
         q0up0RSy5HikizRAEObT6HJMSnOJxhzLJOzgnQfro2RHL9j5YgSr6Yfe4NoXjE86FHGG
         xwmolZL2jKAyzy9iG8JGJyex58L+QcbCyLhbfwxbYQ02peibOA6MWcRuhd2T0bj13+Rx
         14X8A8x3ZY292WrCbiCvIAe6kSBx3gSeFwbCXF9IhQNlf5wCuhGDFlNPHXnrEv6VU0tN
         W0Uz6MA1mL2kqzR+F7Bn4IgpznQZdO/LbuAEGzjgxIBgAhDlAkGMpmzIYHg9QF6hEYVT
         cIjA==
X-Gm-Message-State: AOAM533XovAw+ejZ5+C9Mg/bjSwHIFBhFaHc8CTmZE8jQ8yg7m41E9r+
        7oyW5GRmIscAXVXxSkU1e0FkdQ==
X-Google-Smtp-Source: ABdhPJzr2LjWMqwdO+RhWupttHiFUwdUh98FJ2jVhkMKr665jMBIQfRoeEZuFCiB3w1/PLoDsOA18Q==
X-Received: by 2002:a17:90a:c206:: with SMTP id e6mr6827339pjt.193.1634731487726;
        Wed, 20 Oct 2021 05:04:47 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:e516:d575:e6f:a526])
        by smtp.gmail.com with UTF8SMTPSA id fh3sm5721784pjb.8.2021.10.20.05.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 05:04:47 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
        mlevitsk@redhat.com, linux@roeck-us.net, pbonzini@redhat.com,
        vkuznets@redhat.com, maz@kernel.org, will@kernel.org
Cc:     suleiman@google.com, senozhatsky@google.com,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Hikaru Nishida <hikalium@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, x86@kernel.org
Subject: [RFC PATCH v3 0/5] x86/kvm: Virtual suspend time injection support
Date:   Wed, 20 Oct 2021 21:04:25 +0900
Message-Id: <20211020120431.776494-1-hikalium@chromium.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi,

This patch series adds virtual suspend time injection support to KVM.
It is an updated version of the following series:
v2:
https://lore.kernel.org/kvm/20210806100710.2425336-1-hikalium@chromium.org/
v1:
https://lore.kernel.org/kvm/20210426090644.2218834-1-hikalium@chromium.org/

Please take a look again.

To kvm/arm64 folks:
I'm going to implement this mechanism to ARM64 as well but not
sure which function should be used to make an IRQ (like kvm_apic_set_irq
in x86) and if it is okay to use kvm_gfn_to_hva_cache /
kvm_write_guest_cached for sharing the suspend duration.
Please let me know if there is other suitable way or any suggestions.

Thanks,

Hikaru Nishida


Changes in v3:
- Used PM notifier instead of modifying timekeeping_resume()
  - This avoids holding kvm_lock under interrupt disabled context.
- Used KVM_REQ_* to make a request for vcpus.
- Reused HYPERVISOR_CALLBACK_VECTOR IRQ instead of adding a new one.
- Extracted arch-independent parts.
- Fixed other reviewed points.

Hikaru Nishida (5):
  timekeeping: Expose tk->offs_boot via ktime_get_offs_boot_ns
  kvm/x86: Include asm/pvclock.h in asm/kvmclock.h
  kvm/x86: virtual suspend time injection: Add common definitions
  kvm/x86: virtual suspend time injection: Implement host side
  kvm/x86: virtual suspend time injection: Implement guest side

 Documentation/virt/kvm/cpuid.rst     |   3 +
 Documentation/virt/kvm/msr.rst       |  30 ++++++++
 arch/x86/Kconfig                     |  13 ++++
 arch/x86/include/asm/idtentry.h      |   2 +-
 arch/x86/include/asm/kvm_host.h      |   2 +
 arch/x86/include/asm/kvmclock.h      |  11 +++
 arch/x86/include/uapi/asm/kvm_para.h |   6 ++
 arch/x86/kernel/kvm.c                |  14 +++-
 arch/x86/kernel/kvmclock.c           |  26 +++++++
 arch/x86/kvm/Kconfig                 |  13 ++++
 arch/x86/kvm/cpuid.c                 |   4 +
 arch/x86/kvm/x86.c                   | 109 +++++++++++++++++++++++++++
 arch/x86/mm/fault.c                  |   2 +-
 include/linux/kvm_host.h             |  48 ++++++++++++
 include/linux/timekeeper_internal.h  |   5 ++
 include/linux/timekeeping.h          |   6 ++
 kernel/time/timekeeping.c            |  56 ++++++++++++++
 virt/kvm/kvm_main.c                  |  88 +++++++++++++++++++++
 18 files changed, 432 insertions(+), 6 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

