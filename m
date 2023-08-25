Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE3B787D87
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 04:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjHYCIB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 22:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240644AbjHYCHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 22:07:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF74319A
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 19:07:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d782a2ba9f9so1135411276.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 19:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692929255; x=1693534055;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xRRG6Dvz4UNA/2Id2uXE64v5NXdTgyTxkF4rPZTd+CA=;
        b=2EzDuNqevTD8BpwEFJve4ecpcLJRpsWKuyw5LZrlYQdC+XBVGIpe/lnk3izQe7JTux
         O6E8DpQCWe4bFvTCfe0k5TWhYWWWqHORvRczfjiefimTw/PQacTaFw5vPfD2JPPugiBM
         MaaZaOctiPsdYhyTZjbwNGCLbTfNHEHQub4CejTonQH4L7Uu1yPyWB2/lGI4qHAg8+8E
         WzrlfabiFus0Op/I3QWVBb43vX/ewgdcr59svsG2uqFrAXljFGDt2ESCJzBvOFVDijeC
         mnGKrHgTAGGLfAJrJuUuYeQnnOyx5b1Q6vN+LYmKHc5FaqsM2PVERuE7VW15WY3MWV2a
         5ZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692929255; x=1693534055;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xRRG6Dvz4UNA/2Id2uXE64v5NXdTgyTxkF4rPZTd+CA=;
        b=jXKukZbGFCeVyq8oyM3tZayIu31QI58QrRBn9UBkRarKPqffbb8grgt+UIPGJv6bXY
         qInGrcIz1dSQBr18GJ8WDL6dzHluPeVTNop5wdZpxAcKAwgyXPXl9dQNAomnAYhtmxZY
         mBzGKb2zbg0H/Q3FsnFKdYEGexMFyLycwPGPu4KW9+W222ATGXCVgtpa5SGv/V64U2Hx
         TLz8ISNC5y2BqyYH5pyVHIAS33V+0bFcxyKOSyKqsok6BflStMmeZnNo6/p1dGrnc5FM
         qYZ8aL1CHLqMRo+E0Ap0uw1q/QqMSnykGcGiEuRQbM22VyFn+xvccay+UpfBHla+nZZT
         akuw==
X-Gm-Message-State: AOJu0YygJV0rF7aRYsq+3DVBNbyPqNyDMuOOrwj6o2SS6t6d5JtmQ8dT
        4EDuGszQG6RxsQH5uTa4VWLGLZhoU+w=
X-Google-Smtp-Source: AGHT+IFOWTje1bBvYdZba8PkLXhB4oiKA1S1GbqcYqr62bV43+4ddMBY/fDwMOVZThrce7pduMM5XMZ75DA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3404:0:b0:d1c:57aa:d267 with SMTP id
 b4-20020a253404000000b00d1c57aad267mr404417yba.5.1692929255301; Thu, 24 Aug
 2023 19:07:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Aug 2023 19:07:31 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230825020733.2849862-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: Pre-check mmu_notifier retry on x86
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pre-check for an mmu_notifier retry on x86 to avoid contending mmu_lock,
which is quite problematic on preemptible kernels due to the way x86's TDP
MMU reacts to mmu_lock contentions.  If mmu_lock contention is detected when
zapping SPTEs for an mmu_notifier invalidation, the TDP MMU drops mmu_lock
and yields.

The idea behind yielding is to let vCPUs that are trying to fault-in memory
make forward progress while the invalidation is ongoing.  This works
because x86 uses the precise(ish) version of retry which checks for hva
overlap.  At least, it works so long as vCPUs are hitting the region that's
being zapped.

Yielding turns out to be really bad when the vCPU is trying to fault-in a
page that *is* covered by the invalidation, because the vCPU ends up
retrying over and over, which puts mmu_lock under constant contention, and
ultimately causes the invalidation to take much longer due to the zapping
task constantly yielding.  And in the worst case scenario, if the
invalidation is finding SPTEs to zap, every yield will trigger a remote
(*cough* VM-wide) TLB flush.

Sean Christopherson (2):
  KVM: Allow calling mmu_invalidate_retry_hva() without holding mmu_lock
  KVM: x86/mmu: Retry fault before acquiring mmu_lock if mapping is
    changing

 arch/x86/kvm/mmu/mmu.c   |  3 +++
 include/linux/kvm_host.h | 17 ++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)


base-commit: fff2e47e6c3b8050ca26656693caa857e3a8b740
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

