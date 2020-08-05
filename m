Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF57023D38A
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 23:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgHEVVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 17:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgHEVVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 17:21:35 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779BAC061575
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 14:21:35 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id d1so11596005pgn.11
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 14:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=A2zBYE4JiXe7P1RdEtYrh0UlIzax492Zsz/u2fr1/JI=;
        b=hrlTCk0JLM37eqUbn0GuG+7BNaEmJ45LEewsJ+6ngaPgcRmz7yxuhpqe5cN0X6NwCO
         vf+4J9HNw4c1m+NngZc4U6DESy7MEL26WmMwM/zaeK2TibV9Y7n67kPcTsKPZF6SwHfh
         Ntz1AYkxDWrdQNSkrm5a3GkVGwNEoqrMFpPvHbNyinKxcs+GVjFIODQbwtNjbKsVuwYX
         hzUzx5iY9V1ScOrBkhYvQMw+34Kplf3y68OSvocchxobBGNaZYIY9z1H28/nCjauHDbT
         R/jC1za9d+rMwAtQYDxHm1UP3L/8KexM2nFt227nkFmjkajhbrxF6VWUn5ZFaJVGELHz
         kbzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=A2zBYE4JiXe7P1RdEtYrh0UlIzax492Zsz/u2fr1/JI=;
        b=JzJysX9/5sl9ghdbxqb3RYixBjnSnzRb5nFVJN11ebBF33TS4ZofRVAF0emJYYKrJs
         4F782/egjlRmmG10OQi+Si9nxhWEYHqLC5cozu70/upQUnyOgANduA6nIxr0ddcyX1m8
         SmOPCQfnN09DjWZ3haUqsJfsUeYsKkftJT4bV2mbiUvTwpxiegjiJSwKPROU0amtvFQa
         7hWDIB93bnBzV5bzwaxAcLt3oJu7qn/o4GI6ANuZZqPKIjOtEjepC4kBhkbxlQshbDLl
         XE7N46lw7Q3xnKblyUnKq+kcyZK3YOv8VREFNKhPvW+Uj0HXFy6PXevK4RRq2WCkkzZq
         argw==
X-Gm-Message-State: AOAM530poj/YfQYSZ8lFcwlT8SzkSf+E8cytJ4N8tqdYwRtKJb/XNUXj
        kjyASbRGdFi4PkbiSy4ysnqS8pus+hyKceueFK2ApJoidYVtVZXxAhEiVGQLaFdCuXaaeRXqAa5
        P4O7Px4AdJWkee5sowZBlPAnQWciODs1mMHoJC63WqnOlbIVkx868eMt4jQ==
X-Google-Smtp-Source: ABdhPJz1YPcyRQUytsMWE18wuedIDmO9gzPSlezLeApOG/5uD6NLkw/fWQdNaUSbcQtOJJlc0mpRobFkfcs=
X-Received: by 2002:a62:7c4f:: with SMTP id x76mr5471614pfc.124.1596662493665;
 Wed, 05 Aug 2020 14:21:33 -0700 (PDT)
Date:   Wed,  5 Aug 2020 21:21:27 +0000
Message-Id: <20200805212131.2059634-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 0/4] Restrict PV features to only enabled guests
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

