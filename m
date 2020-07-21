Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034B32289B3
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 22:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbgGUUSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 16:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGUUSV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 16:18:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18CAC061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 13:18:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 8so26683126ybc.23
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 13:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TLYIx65uBhH8tKMZC20n1CzNlboYevH1hAYzToPXQyo=;
        b=sRXFES6q0Ey0/IU/nUy9UtsoyTTOrJ5vMzzf30Xx7HBy4yPhCiClOfbLXTSge3jGW4
         vd4/h+wvkflMMufw78SHihakxCqgrw0Lh0IAzftfaE+KbaGasqS+oufao0HVWtVgfTZ6
         7IUugwUAnDptaqm19MCiTNSKEJKjo5sMU0DcF3JtnU10sKLxOnwQVqK6SCoHFIz0gtmJ
         /5GwwZYWsygKYhB2qhvSQn4PU/yJ+Cpr9hRxMcx9Z3vTFaZeuNOmoBQaytE6+S9k+Eac
         et7GtpplD6WRZmVPOHcJAhvinaQFo5+FU+Xx2NnOgBgkRjDs13agKpaQbYoMWhttyrxO
         JE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TLYIx65uBhH8tKMZC20n1CzNlboYevH1hAYzToPXQyo=;
        b=C7Wi0H0fFuZZB42+FZwcWN4p9WZAGVoTc0Xs4Odja7mWpvsQ3xdrn83gD5ELYVyYcM
         pIxfRiYt3Jnwp6jHXQCNpxayQ8MOmT56bLbugnI9+FgKXliXKS8x11sw/2wz3cgKIrV/
         4obK4bqbanGLkMf+aLp0wXWSSfUEKQfgDbAwiF7yd2H2ODxvG64klTCBzCmNLNERoTWh
         nKBRj3d8mHtZSUXyJ1bYMHzkD3I8MhFwUEGr1S4LNUtoG4PgZFk87WyI3yD5Nh/CVYAN
         hbWDWuPk+4EuKP4LMs1Y2ly1uo8l6/I5IJHMq3xNyd8qyfAjg7toL0p9S7ItvesUWz2K
         lk/g==
X-Gm-Message-State: AOAM53242kkuX8QT/hyAzNUXx9dkkTzVqqPQM7XDqUImO8T1dEy8x0Ce
        x168WctY0w1pKr16wfxBh2UxiyaBIpRdsxo/kOTE8aOGezMxq7egxu5z0CmDf1cazdpOihOoKDe
        jjlYqLs53iTfT+gLuB5IxzYej+aTtFACDAN5K8bf4bCj+wR4HXFVAesTJXg==
X-Google-Smtp-Source: ABdhPJzvO8GTRdE8c2WMbR+gJ3+WIZYQ0HJzgJ1iT2yUDXY11NGWU5ddaeAjCanDq9QislIMkySk89cs+ts=
X-Received: by 2002:a25:ae4f:: with SMTP id g15mr45255291ybe.441.1595362699898;
 Tue, 21 Jul 2020 13:18:19 -0700 (PDT)
Date:   Tue, 21 Jul 2020 20:18:09 +0000
Message-Id: <20200721201814.2340705-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v2 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To date, VMMs have typically restored the guest's TSCs by value using
the KVM_SET_MSRS ioctl for each vCPU. However, restoring the TSCs by
value introduces some challenges with synchronization as the TSCs
continue to tick throughout the restoration process. As such, KVM has
some heuristics around TSC writes to infer whether or not the guest or
host is attempting to synchronize the TSCs.

Instead of guessing at the intentions of a VMM, it'd be better to
provide an interface that allows for explicit synchronization of the
guest's TSCs. To that end, this series introduces the
KVM_{GET,SET}_TSC_OFFSET ioctls, yielding control of the TSC offset to
userspace.

v1 => v2:
 - Added clarification to the documentation of KVM_SET_TSC_OFFSET to
   indicate that it can be used instead of an IA32_TSC MSR restore
   through KVM_SET_MSRS
 - Fixed KVM_SET_TSC_OFFSET to participate in the existing TSC
   synchronization heuristics, thereby enabling the KVM masterclock when
   all vCPUs are in phase.

Oliver Upton (4):
  kvm: x86: refactor masterclock sync heuristics out of kvm_write_tsc
  kvm: vmx: check tsc offsetting with nested_cpu_has()
  selftests: kvm: use a helper function for reading cpuid
  selftests: kvm: introduce tsc_offset_test

Peter Hornyack (1):
  kvm: x86: add KVM_{GET,SET}_TSC_OFFSET ioctls

 Documentation/virt/kvm/api.rst                |  31 ++
 arch/x86/include/asm/kvm_host.h               |   1 +
 arch/x86/kvm/vmx/vmx.c                        |   2 +-
 arch/x86/kvm/x86.c                            | 147 ++++---
 include/uapi/linux/kvm.h                      |   5 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/test_util.h |   3 +
 .../selftests/kvm/include/x86_64/processor.h  |  15 +
 .../selftests/kvm/include/x86_64/svm_util.h   |  10 +-
 .../selftests/kvm/include/x86_64/vmx.h        |   9 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  11 +
 .../selftests/kvm/x86_64/tsc_offset_test.c    | 362 ++++++++++++++++++
 14 files changed, 550 insertions(+), 49 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_offset_test.c

-- 
2.28.0.rc0.142.g3c755180ce-goog

