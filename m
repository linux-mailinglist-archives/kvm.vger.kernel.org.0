Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F6246DBDF
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 20:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhLHTUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 14:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhLHTUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 14:20:19 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B74C061746
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 11:16:47 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id e7-20020aa798c7000000b004a254db7946so2076824pfm.17
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 11:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IbHH1eM7+h5JA/Wq7qVMHPIVqo/1uljJ6CH0uHyrjD8=;
        b=C/Lkut5Vvd+odmZn3T7EImyPb9hSe/IbC+QLw/n/F8eMNrY9JgHnOANkktmMpsGv/P
         sMp1QEUPZOLesC+96+pkElI3ReolspbG9+E9HMqkohWgkz4Btdg5ggxwaFScVxhqcPAf
         KcuNJU3AuTQn9hZhyZm73AFW6WiMdZFXQ/lu6RKljVnrlepfv2/u910uDmYt5Ufyy6tc
         Pd6osWEBua0Rx4F0Ueul2Jf8i+liJ0VGKfRi4gL5FruVpiU44AT0BdtVD79/FnOnhgkz
         0gSK37HBDwzKopTpdYD6PZdbz/4Dnqn6QEhCvYl1/L7HLobGx7lV3us3CMgC4CqFdx+H
         MUWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IbHH1eM7+h5JA/Wq7qVMHPIVqo/1uljJ6CH0uHyrjD8=;
        b=d+hJiiII24FRvlBtI1qhPlQn9/vUSKI1M1xVeu2MsS8HYd8em8p/0G+XUSgPSLLJkm
         PDPQ67M+o31e7BgPIW9bJJ7MZ2/mldeRx/VPacSsn5ctTrWNLHBiU4DRoJ0uJNpVxyC8
         G+h4jFrcF7ZPiZENXy8UrzFlyA78Tld+fVLBaKLvzoi5WocV/J4Vywhg9H3eePdD3FQw
         dzadShcNc3kRSF1svwRSTx0eWMqfRV0FRW5LfziuHXmGjaHtFE+rEijuIXZjZTNWgFJp
         pKsz2rlkv3RuGLfawHDQOJAaklFp9NbX2r21FYnyKTgc25Py49sPzd5pdMAg79EdhXr2
         3d8g==
X-Gm-Message-State: AOAM533A9T7gzO+xtmhaBjdh5w5UaRM8tNnBGfFqzl61fl7qrcrqZC+k
        EuXen41d+JbMndcM3KY0u3QHAFUBGao=
X-Google-Smtp-Source: ABdhPJzbQwRn8BEp17nvsf8JcBg+qKR92YLHP49MnjCculnvJHOPbV/gUD1PpGVH3Bj77mJ+nx5lepeMuIA=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:ff20:12b0:c79e:3e6b])
 (user=pgonda job=sendgmr) by 2002:a17:90b:3849:: with SMTP id
 nl9mr9677376pjb.145.1638991006729; Wed, 08 Dec 2021 11:16:46 -0800 (PST)
Date:   Wed,  8 Dec 2021 11:16:39 -0800
Message-Id: <20211208191642.3792819-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 0/3] Fixes for SEV mirror VM tests
From:   Peter Gonda <pgonda@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updated patch series for fixing bug in sev_ioctl() which allowed test
to look like a mirror vm could call KVM_SEV_LAUNCH_START. Adds
additional testing to validate mirror vm can only call subset of
commands.

I could not add the patch Seanjc recommended due to issues with
sev_platform_init() not correctly setting the fw error. I'll work ontop
of the INIT_EX patch series to fix this issue with the PSP driver.

Peter Gonda (3):
  selftests: sev_migrate_tests: Fix test_sev_mirror()
  selftests: sev_migrate_tests: Fix sev_ioctl()
  selftests: sev_migrate_tests: Add mirror command tests

 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 59 ++++++++++++++++---
 1 file changed, 52 insertions(+), 7 deletions(-)

-- 
2.34.1.400.ga245620fadb-goog

