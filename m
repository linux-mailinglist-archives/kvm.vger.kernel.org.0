Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CE623DBC0
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 18:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbgHFQcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 12:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbgHFQbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 12:31:03 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3559C0086D4
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 08:14:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n21so41918646ybf.18
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 08:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=tlp9q0ruYxUy6K1Wv14LOld0/f3sQOHJP7F2snACgNU=;
        b=W05t8l8xySwHgO0u+OSgCEVI3iDQiF56QlWJqJaodjlhjBda9AFua7Tx5Dj44UGd5v
         PuJkTUdNO+OhFKmcFWbAT/+ysNG7J+JT+BAnUQqr4mlC9LWyBNlDOeEMFVGl5v6SOcCt
         ZKvqgS6U+Hp/laLUDEezpru2ftsJ/GW/kaMdAJjgxYpk1rIM/c1azH5Wf/ey/phx6tI4
         mlv+sMXvawAP4v9rzpyMgKCyF1pUTJlZqXzjyQ0fAov/jSZoW1vDhTeVychMw9vT9esU
         v2R8ARKFqvLr0nyWXlCBoK9HHiCfivAoB+/LzQHa19Zemfs1A3B4pYuF8p5BYRhGzi39
         9A4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=tlp9q0ruYxUy6K1Wv14LOld0/f3sQOHJP7F2snACgNU=;
        b=j7NLAL+bwBrvoadTfBVKCuGDdHN+HRbcMp40QSmEs69cReCDQ8x73DniLx2Fucugui
         YCmDZYF4ioiNdexH0I5InPW+sEKx4i7wZvn5KMtojMuRVqwoqzaKsxPbgFaWbDTJ0cdU
         EdCyLSMQ1K1gE4mO8pnbj7krHG7S9fJOAE70HCdG6OFOG9JJnvv5+FwbhxycFfp9+LSO
         73HnFGawCqFVM46YnVNpIczambTp0K6MdYZDkvzpJXsFYdINXCvR1s42e4k3eORE5tjJ
         luTYoifQZEPxHwiRD1qnQvN/p+r7slAMLpTjgXb4+m7/pDsNy2/RvdmWRq09ZrGy8JKi
         kyXA==
X-Gm-Message-State: AOAM530wh1n3UTKIbjDTrifyG7aBWDgEGmpRuIX1lLNOLH11fNXphG9H
        y7dTMQVlCHZnBq79w8ytyWatrDxH2gTnbVnYpKqURjP0rRqYjyN+lAzG4R2sdqKpvbpOuevDTzF
        hM7goZHkYL+hxnbn/g3Ekc1IqQrq5DkjDYwjC6icLRbXv6RQpn3dehtseVQ==
X-Google-Smtp-Source: ABdhPJyTK2QJ9GYTipDG3/WDK2rWv1Dn7ftTBrUYTRW1u8l701qwRaDHfnsbB/BPZHhU0nxZVFxPBpDrpSY=
X-Received: by 2002:a25:2314:: with SMTP id j20mr13312806ybj.508.1596726876527;
 Thu, 06 Aug 2020 08:14:36 -0700 (PDT)
Date:   Thu,  6 Aug 2020 15:14:29 +0000
Message-Id: <20200806151433.2747952-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v3 0/4] Restrict PV features to only enabled guests
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

Parent commit: f3633c268354 ("Merge tag 'kvm-s390-next-5.9-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-next-5.6")

Oliver Upton (4):
  kvm: x86: encapsulate wrmsr(MSR_KVM_SYSTEM_TIME) emulation in helper
    fn
  kvm: x86: set wall_clock in kvm_write_wall_clock()
  kvm: x86: only provide PV features if enabled in guest's CPUID
  Documentation: kvm: fix some typos in cpuid.rst

 Documentation/virt/kvm/api.rst   |  11 +++
 Documentation/virt/kvm/cpuid.rst |  88 +++++++++++-----------
 arch/x86/include/asm/kvm_host.h  |   6 ++
 arch/x86/kvm/cpuid.h             |  16 ++++
 arch/x86/kvm/x86.c               | 122 +++++++++++++++++++++++--------
 include/uapi/linux/kvm.h         |   1 +
 6 files changed, 171 insertions(+), 73 deletions(-)

-- 
2.28.0.236.gb10cc79966-goog

