Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B9B2489AC
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 17:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgHRPYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 11:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRPYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 11:24:38 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9189C061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 08:24:37 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id t19so6686685plr.19
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 08:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=7RzMrCk4RpXzFZelAQn7ckmUoODhv+euE8W8ePc3K9Y=;
        b=wTWWWpxErHV4rTDzZdEPHoch/Y3kjxZKS/TcpKWrRyAj9lg0dWP/lbePzWDVf16vrN
         R4sgeryZ4+M6LxPHLeNMp5yVldYOda/o2yaWFqChb0O/uqmaJIpDUX+0LES+Cl853Al6
         lT5zLiXqgQvG3IHgPVIk5cwSMFLnVk0ER1v7s1Rl6vC0/EcEI3g71WLsC9did1Ln1hME
         P0F037PmwQ6IrQRjK+dAnTKYcJUDWn7liaz054jQqFTt4vjwmZmT6QESseFZ0gYyVI5U
         01oDN6rA/TQX4h15ONlhtksazri3PD/fm0Xu7tWOC2Mc3H6N/AFzNwCtRzx1bQwqk2kw
         7ksg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=7RzMrCk4RpXzFZelAQn7ckmUoODhv+euE8W8ePc3K9Y=;
        b=aS5fY4Mgcw3quKTou3FdUWLtzNswjyjAD//XVGafOPGgL4mwOHjQQc8Ofg2xmoisUG
         +MPGu8sQvXaNxiv3q+6n75xEZdxuayd1mU+XAzPr84/aXcZKwNvYIgp9hmOnK3dOJyY9
         sE1gmwT4kWpNchmIh57Csy47k2uTK0G9qjh0m9B69BwAIpf93sR0i+wNetXkGQiNiNIA
         tpqYtrYMo3BZCFJtyRKWDWc2MFeDBi8lBgWim3xVt3gcEZdCeLWXYBpecRnO4bxlLpV6
         9peWzjuUUYjONqAZqr81bL7eIsro/ioUgJR/fF4WbghebWk7zph2lc8ldAoUAgVjrT+F
         SaNw==
X-Gm-Message-State: AOAM533X+FrkHT/C7plsdFQp8bgr8aIMZ8+tbqQ7KTj8tE9Sl7Kn5IEw
        mU0KEpLTq4MaauametO25caF9rW2Cq4HQv5x86QzJR/QpCSaVRhiqvrFrMJv0sDNQ7sIQySkL/X
        afNGKMrYE0VR5CdJbs3Qrl1ueGjxXNvl1k6g3ZwQEnms5upV5PCuyqtD0sQ==
X-Google-Smtp-Source: ABdhPJyezA8CzUfjzn2SnNZXVouGoDRSNixAGDsfHrLr6ieTvrnir5XeVl6vhmqjG+uIIAQ8uhoXXlvd1+4=
X-Received: from oupton2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:518e])
 (user=oupton job=sendgmr) by 2002:a17:90a:f014:: with SMTP id
 bt20mr296476pjb.0.1597764276848; Tue, 18 Aug 2020 08:24:36 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:24:25 +0000
Message-Id: <20200818152429.1923996-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v4 0/4] Restrict PV features to only enabled guests
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To date, KVM has allowed guests to use paravirtual interfaces regardless
of the configured CPUID. While almost any guest will consult the
KVM_CPUID_FEATURES leaf _before_ using PV features, it is still
undesirable to have such interfaces silently present.

This series aims to address the issue by adding explicit checks against
the guest's CPUID when servicing any paravirtual feature. Since this
effectively changes the guest/hypervisor ABI, a KVM_CAP is warranted to
guard the new behavior.

Patches 1-2 refactor some of the PV code in anticipation of the change.
Patch 3 introduces the checks + KVM_CAP. Finally, patch 4 fixes some doc
typos that were noticed when working on this series.

v1 => v2:
 - Strip Change-Id footers (checkpatch is your friend!)

v2 => v3:
 - Mark kvm_write_system_time() as static

v3 => v4:
 - Address Wanpeng's concerns regarding cpuid lookup

Parent commit: e792415c5d3e ("KVM: MIPS/VZ: Fix build error caused by 'kvm_run' cleanup")

Oliver Upton (4):
  kvm: x86: encapsulate wrmsr(MSR_KVM_SYSTEM_TIME) emulation in helper
    fn
  kvm: x86: set wall_clock in kvm_write_wall_clock()
  kvm: x86: only provide PV features if enabled in guest's CPUID
  Documentation: kvm: fix some typos in cpuid.rst

 Documentation/virt/kvm/api.rst   |  11 +++
 Documentation/virt/kvm/cpuid.rst |  88 +++++++++++-----------
 arch/x86/include/asm/kvm_host.h  |  15 ++++
 arch/x86/kvm/cpuid.c             |   7 ++
 arch/x86/kvm/cpuid.h             |  10 +++
 arch/x86/kvm/x86.c               | 122 +++++++++++++++++++++++--------
 include/uapi/linux/kvm.h         |   1 +
 7 files changed, 181 insertions(+), 73 deletions(-)

-- 
2.28.0.220.ged08abb693-goog

