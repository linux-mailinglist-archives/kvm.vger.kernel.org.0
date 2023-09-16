Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAADB7A2CB7
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238505AbjIPArr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238612AbjIPArX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:47:23 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4683830D4
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:43:19 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5925fb6087bso34019447b3.2
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824758; x=1695429558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yZtAaYugiQBYsP7UK5NhW64OM+nEYMlgpbQrdmJ2hNk=;
        b=rH+/jU0dz/5fz2bFeh63ONbNdHyG9KSiwq9CleagzvVJ1jvfZWZomUTA4Tacb3sS9r
         3wH1Ig8pztf2XFBvVqnrx3EhvjBw9KSFP95F36TaT8UMjSIpoHnYHiRPhgAAYOI3DSZD
         /0ge3JM06L2hpIws4mGTc9mAfOz9UarwaInZ/dZG0AklHFmFRyG2Z8UAtFZJKSGqG7J7
         yPwfNf8zA8Q5f4+ZaKc2rgeHUSZ6gJUmZRI2XyIgcBsDBJphSPOHj5PQOeyYmAX4b6CC
         Lr9VxZkPYwvciKRA3NALCYy0+IeM0gYRGQdBvyiEaFTxJlI0iYMOjkKsmbJlNniObt7V
         epKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824758; x=1695429558;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yZtAaYugiQBYsP7UK5NhW64OM+nEYMlgpbQrdmJ2hNk=;
        b=U6xFCvE0SIDjfh4Vp2///kt5TBBWQPf9iWWTSizbfiWTO/4kz4OHMMsw04A3m5i++k
         Du5UsKrpriUg+eHSMcq4sAWDDl62R570GQe9FzTrW4eS9vNwDaXCS1tTghGS+e3QMzdz
         Sq0+aHHtIHn6czxBlec6eYISjaxoAjbX9l/7LOiItu1a3uhNmIOAvFOrFGhshTC/rrN6
         20ONqcdJtqQZGn41KElUoF9RizCRbU/0NoaxzVezlyayx+7acY/Ftfzy/xr9Zw5kksfV
         STivX7W0DZhNIUh5x7niO+LcdRJq+l/OjSGjQ+O5ixQvdPoeDp7mbHnuUVAMkdTjKNFI
         L5+A==
X-Gm-Message-State: AOJu0Yz87afBipUXO14uPusCTMN7HvsrmA/F0CCiXpbwvpciCOcdensU
        FxQdijKzwoHA+GZ18Dwx43B2o3grvsQ=
X-Google-Smtp-Source: AGHT+IH40DhVjGOeKZk8Yno6F6l4HquC48/xSTRtOWUnfPD0qH8togElbSSllar3XXKAsO80BzIquwuZoJI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af28:0:b0:584:3d8f:a425 with SMTP id
 n40-20020a81af28000000b005843d8fa425mr91792ywh.10.1694824758613; Fri, 15 Sep
 2023 17:39:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:39:13 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003916.2545000-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: x86/mmu: Drop async zapping of TDP MMU roots
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yank out the asynchronous zapping of TDP MMU roots.  In some setups, using
unbounded workqueues can consumes all CPUs for extended durations, and
create significant jitter in the system.

Specifically, the behavior causes audio glitches in ChromeOS VMs with
virtio-gpu when running games in the guest.  Gory details in patch 3.

I tagged all of this for stable so that this gets back to v6.1 (I already
did the backport to verify it's not awful).  This bug is bad enough that
the workaround for the ChromeOS usecase is to simply disable the TDP MMU,
which I really do not want to do for the v6.1 kernel (or the v6.6. kernel).

Sean Christopherson (3):
  KVM: x86/mmu: Open code walking TDP MMU roots for mmu_notifier's zap
    SPTEs
  KVM: x86/mmu: Take "shared" instead of "as_id" TDP MMU's yield-safe
    iterator
  KVM: x86/mmu: Stop zapping invalidated TDP MMU roots asynchronously

 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/mmu/mmu.c          |  21 ++---
 arch/x86/kvm/mmu/mmu_internal.h |  13 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 147 ++++++++++++++------------------
 arch/x86/kvm/mmu/tdp_mmu.h      |   5 +-
 arch/x86/kvm/x86.c              |   5 +-
 6 files changed, 80 insertions(+), 114 deletions(-)


base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
-- 
2.42.0.459.ge4e396fd5e-goog

