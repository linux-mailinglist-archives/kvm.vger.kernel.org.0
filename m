Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE65423D380
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 23:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgHEVQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 17:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEVQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 17:16:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6687EC061575
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 14:16:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u206so20906080ybb.8
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 14:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6YME6h3frh55VOhFAbXLI9InvDtCOC1i09SrGpWX2Gg=;
        b=Rl6YpFib0Dg8qz/g/d0nLv+Iu6+R6IdjY8jIpYyJEjWQRS79tXRrsqjjr1K7SVNDab
         5INS0mkjWMq9FJ+2rsX+bunqP5fFQhX+8bpgitkmtVuxhzDWy70iOouaW9O84OkjUFv6
         tF8PhFvxvP74FPoXqtMLNpgpQlXipV0m7XumoX9sC68JI4vTaLQY1JnVF2mxsVtoT1Xg
         sQABl8u4cy4r58Y2+hcQxCnQNtrMf0K1dFXET9uVikRp2CMruUZ9MEVP0KvY0979LED5
         GdlYb58GWCxTFVjoI5EAxFXd4K2TS6Bm1gsCFPkDRFVAYyKFuDy5DsBFNPcLt6/I8gWu
         SXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6YME6h3frh55VOhFAbXLI9InvDtCOC1i09SrGpWX2Gg=;
        b=nuNzqcCpLh8QsFKvtLYtlHIZqgyqabQvJAmLjPN99pKWHyfvj0UUkRZk+S6Y3vlQjX
         YFARfXrwdQ6X0iAr1+rj6r7kd0I0nb5ioDl7wCrxKDN5OPjP3Z33FwTadcm5dISZ15mu
         uvZpA+NlaxWkk7YSqE+pHezN7MGl9nVCUtTxjGiK5iDhjaDerPkaQhtqeb/euBh6wk2n
         5+9LWgcBeWYEDt+0PbT1Kv6EUT1gMQc9jt306VcTEKm31UK1Mvc8hhK6ieZpcSQNDrub
         s4K0AL5NzSStuJymCLqgTWWQlkqW4UPeniygsRfYp8d2dDx3y7bECE0d4zZaTZiiojVS
         xeOQ==
X-Gm-Message-State: AOAM5317Y3aABv1sAV13r6lqzi5qwNPJmfJVUg7kxKZwo8EezWn3Gf8O
        Si7Nwzge69xXLLwD51duxWWyGLfCn17n3DAvcLuFrgfnM75i6FH0CTeMYItwAsl9OsGFFuI1h9j
        eWK4iwySax3LSSA8WsJSoxkpO5V/696Qgu9u/AKe3Pyw9C6kwuTn4NCUKww==
X-Google-Smtp-Source: ABdhPJx1uczf46tedRc6MnjromBY3Kc2pRLCXPNzk6KKP/R0AddR72fEYUfkebpsd2HCOcZ22BHUAHDf2R4=
X-Received: by 2002:a25:a0c6:: with SMTP id i6mr7683961ybm.58.1596662174395;
 Wed, 05 Aug 2020 14:16:14 -0700 (PDT)
Date:   Wed,  5 Aug 2020 21:16:03 +0000
Message-Id: <20200805211607.2048862-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH 0/4] Restrict PV features to only enabled guests
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

