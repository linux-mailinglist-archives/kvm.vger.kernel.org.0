Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDAD3EFA2E
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 07:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237790AbhHRFjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 01:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbhHRFju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 01:39:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D458C0613D9
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 22:39:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p71-20020a25424a0000b029056092741626so1659829yba.19
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 22:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=EL7jI42wrcLkhbmMyq077rvusMQzj734dq/iBhF+pY4=;
        b=t1Oy7svnangJBn7uKTFsIDqALT7f36cJQs9eDhJj6+ACeFlU4o7xJas9Oxg0nOtfkM
         lz1fthLqySQlUaikmUMmxpqvlukB5gBWU7X+yxuTnAT2HcUXrjz/AWk00fd85QErNqh+
         MXo71I6MNGnf7HcEosKmjcyerhvgTaWpc3T0yaB1wb6jsY0ICBjQLuFYf4L2mvsfst3O
         EBsNWe+mHZQw+NGaNNTmq5h77lp77JUQWTp84Wovhl+4KOcIq/ozHtldBfmoeBuYza0+
         dtOSc40y6JczuK/cNtmgRZIfCv5wyTlIN5d4KrMW7b7SJ9wXNq2771EmSJdKXClwZozq
         WG7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=EL7jI42wrcLkhbmMyq077rvusMQzj734dq/iBhF+pY4=;
        b=TIJy2wvf5W6TakmDcRB56+0p3Ol5eF3ml3lRgYJX3pxcL3180/3ewHrx7s/LbqnOT2
         0Hthggc20vKFOZ4nBHFAsWkPzI9ffV8qxoJSEJIsFEW6mDw4cMw9rm2afAdNo71+1qDr
         AVgQkHP7xpQqc9PvUxmho9U1DFb0M59iw/IMEuskfI+7MynD23CI4XrIITZiqDRrOuV2
         t8AJL06pitBRTIShBLnuc/h9IgBmiHrqv+yTnOBS1hyxQ0DB/ZSzCAnzOpP8HJP1zDs2
         jIqeFTNnJOwCWLLZcu0qABn6wrtu/zseGuKpMMlB/GBZuUni2r+S+LI8Kn9ivLquQrTf
         wpLw==
X-Gm-Message-State: AOAM5308C1Sno7WsqbBS6l2juxn/ct+pGRs2ZJDyQjFTWfE7xKfJsSOj
        UWRRQn9Jnl30VyS/winqvO9bL7EODnjl
X-Google-Smtp-Source: ABdhPJzGOI7bhhcVw1EL0ejePMf38jIvDPpMHXEsV6CYhN1qr08tJkuKcbW4oDjkqO5s6KHVj+u+uxOoKWKq
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a25:a109:: with SMTP id
 z9mr9030673ybh.279.1629265155304; Tue, 17 Aug 2021 22:39:15 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 18 Aug 2021 05:39:04 +0000
Message-Id: <20210818053908.1907051-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 0/4] clean up interface between KVM and psp
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set starts from a minor fix patch by adding sev decommission;
the rest 3 patches are trying to help make the interface between KVM and
psp cleaner and simpler. In particular, these patches do the following
improvements:
 - avoid the requirement of psp data structures for some psp APIs.
 - hide error handling within psp API, eg., using sev_guest_decommission.
 - hide the serialization requirement between DF_FLUSH and DEACTIVATE.

v1 -> v2:
 - split the bug fixing patch as the 1st one.
 - fix the build error. [paolo]

Mingwei Zhang (3):
  KVM: SVM: move sev_decommission to psp driver
  KVM: SVM: move sev_bind_asid to psp
  KVM: SVM: move sev_unbind_asid and DF_FLUSH logic into psp

 arch/x86/kvm/svm/sev.c       | 69 ++++--------------------------------
 drivers/crypto/ccp/sev-dev.c | 57 +++++++++++++++++++++++++++--
 include/linux/psp-sev.h      | 44 ++++++++++++++++++++---
 3 files changed, 102 insertions(+), 68 deletions(-)

--
2.33.0.rc1.237.g0d66db33f3-goog

