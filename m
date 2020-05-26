Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5C1DA46B
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 00:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgESWWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 18:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESWWt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 18:22:49 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE783C061A0F
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 15:22:48 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id o16so1396730qto.12
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 15:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=f0KIoB0Jrpqy1aqVVHDit80BlunnGA67Z/eeJuQ0bUo=;
        b=Ky/vgy9iGi3NHsqz0CzOEKfHuhnFxOCWXWL9Q/t7SgvsSU+aPYy4EehBUG3ho4y6t5
         5sX/m5TLaGBtuE1jbNTfQvE0vHJG81D3Tp4DzqTAAt8rIEgZeDbke0eCLCHIQFMVdr+h
         M3Sgl2gGjMDxLCp/s14X7wofGzwfyfWzwcCzCtP/b0fc9RKLpe6iWeevRvjiPt15cwGU
         NrxBNYI/onaNU6TPv+T8Ndq3t7ZPXCeUYDpbtktJrK4GwCkFcaz795IqM+kTQNTW+Cbp
         dj9+kgZkq03IxYJk0eGGHpRkczwZEeVGhM5Y+EHzAMoy8gusCsk1nG4oCb/EUd4Ap4jc
         KVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=f0KIoB0Jrpqy1aqVVHDit80BlunnGA67Z/eeJuQ0bUo=;
        b=h4mQJMq6ZiNvZxHWPFU4XaUYMkSlRtzIK1To7RVjGAsgnFg2zNg/10d3wSIQeAZiAP
         7ZCvWVkPcg93j23moznPKDDPVPuEjOK1bn2yN22+QUM0HOep2iLEXJyJ/aLDxLgO/cpo
         q0j/lSVgpEamSC5eZN0+1p4gWYv9yoFaFYRtGYxj1f1lQEmtnypEfG84Anpy0nYB91XP
         Wxs/FjXaqCjMbmBNrS60jYysTXIfvALZDSm2yvnuO8tnFSmZt77Aflo6XMdFrEcMO7k1
         gUA4Wn5Q/E3M6zp12Dz3GsL2Cwigf5lOypnLo8n6o30HpMPzEL2iPjYUX1ug9X2cMQ0f
         j++A==
X-Gm-Message-State: AOAM532rObF9o7tUW8z9KWIht/++e9b8NofrCXQvYSyH8uX6I/uNwMas
        8dd4SpFTT4rfi40ck1JF56V8w1VXwbdwAMEyamZPj2qInjT2t8vKT+A+PhD96CGCkvyf8aM8pgz
        Ks1vrUaL+46NTKR2nfcGdTu8UXZsBBfYWGH9W8M5TFtrzii50AwA29x0ze8kczU3ry9M6aTznBl
        lK30M=
X-Google-Smtp-Source: ABdhPJyg6hgVvW1cYptCRecHaLVCkGCh/ihKSw22K1AJkzZ34y0RFD74sFGl+0d+LmH12jNTiM/ujlnQ0PV8sw7fECyBhg==
X-Received: by 2002:a05:6214:1422:: with SMTP id o2mr1981629qvx.13.1589926967823;
 Tue, 19 May 2020 15:22:47 -0700 (PDT)
Date:   Tue, 19 May 2020 15:22:36 -0700
Message-Id: <20200519222238.213574-1-makarandsonare@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH v2 0/2] Fix VMX preemption timer migration
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix VMX preemption timer migration. Add a selftest to ensure post migration
both L1 and L2 VM observe the VMX preemption timer exit close to the original
expiration deadline.

Makarand Sonare (1):
  KVM: selftests: VMX preemption timer migration test

Peter Shier (1):
  KVM: nVMX: Fix VMX preemption timer migration

 Documentation/virt/kvm/api.rst                |   4 +
 arch/x86/include/uapi/asm/kvm.h               |   3 +
 arch/x86/kvm/vmx/nested.c                     |  56 +++-
 arch/x86/kvm/vmx/vmx.h                        |   1 +
 arch/x86/kvm/x86.c                            |   3 +-
 include/uapi/linux/kvm.h                      |   1 +
 tools/arch/x86/include/uapi/asm/kvm.h         |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  11 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  27 ++
 .../kvm/x86_64/vmx_preemption_timer_test.c    | 257 ++++++++++++++++++
 13 files changed, 357 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c

--
2.26.2.761.g0e0b3e54be-goog

