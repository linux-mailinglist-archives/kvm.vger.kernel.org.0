Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4C167258E
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 18:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjARRxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 12:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjARRxF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 12:53:05 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC254DE3D
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:05 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4dabfe825b4so189954737b3.16
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 09:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oOPPxsaZayll2gfGxBxIs+eT3CtjzuAHdpvn/rcbMAM=;
        b=IGBWxs91eLmZua46Di0WINWesIEBpGuXS16QwU3GhT4BC4qT+4Fq8tVaFlBHN59wlc
         siYz5sIDJY6VS8zzAk+LurQHt5i2TscSZaSCj4s4yfmPdIw5v+ubaXmqNndMdgTdXdfD
         1VwgA3qffbqHu/bMq5EdxKICjvvxUtUQmz3ecUClYxvgW2mm4AbeJ2rV8mVyi3X7/jwy
         Hw5ioiW8TuB+fFoiQ0kEzuwfbjA1RQMlp5rJl/utwTrzUN6c1HqroqpbtZcIi+13bi+u
         tE45/7HvUu8F8tvqvjM6w0OqnmTwxvCCa9jadsQab4aPyMl10fcvs9xs7iBBgcfwLe8v
         yo2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oOPPxsaZayll2gfGxBxIs+eT3CtjzuAHdpvn/rcbMAM=;
        b=7kkimOK48f8grYrErUfeJP6arWNJcR+1fXKchDYw7UTgC0scRFknuxCe+YsTZ8W+NT
         As07C72e9DPhDG2S0nE3rdq89iwhe/OBDiiCTFX2tAmxoEIpgIk+GGTwqPcKie5qV4zM
         9ECKArxc3vXstX0NQMs7a8VIsTq8bfm7fLzXGAS0Okpwq/1AUPoMtAzhgBzuMb/bkhzi
         tqznClJCiqvFocGLsp23Z0TEgzMcAvj8JRz8E4X9dg/9AbK4DDGSTYbrsfNZ7hgfP6++
         i5BXi5G2Q5QYAsqdwjzJehWtcvhOvvc4YnYxr7d45sAkY4nyTbpzN8g1YOxBV1OOemYk
         oT4Q==
X-Gm-Message-State: AFqh2kqoygVgaKVaXnr2DbnHAvxYcYsm8F+CopPW2ERidRa5s0q0/0//
        RrdUDgJlEoe2fGBW8TYle276BlN8Njolkg==
X-Google-Smtp-Source: AMrXdXu9T7Zd3cLVz54Bs6T3yQDnfXd3CzCSXuI/92BpguymCx39fc31it8sGzlwIT2KRQrZWrYTXFk82hOEDw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:a1d0:0:b0:4f5:c23d:4b06 with SMTP id
 y199-20020a81a1d0000000b004f5c23d4b06mr317648ywg.99.1674064384396; Wed, 18
 Jan 2023 09:53:04 -0800 (PST)
Date:   Wed, 18 Jan 2023 09:52:55 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230118175300.790835-1-dmatlack@google.com>
Subject: [PATCH 0/5] KVM: Refactor KVM stats macros to allow custom names
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series refactors the KVM stats macros to allow specifying custom
names, e.g.

  STATS_DESC_COUNTER(VM, foo),
  __STATS_DESC_COUNTER(VM, bar, "custom_name"),

Custom name makes it possible to decouple the userspace-visible stat
names from their internal representation in C. This can allow future
commits to refactor the various stats structs without impacting
userspace tools that read KVM stats.

This also allows stats to be stored in data structures such as arrays,
without needing unions to access specific stats. Case in point, the last
patch in this series removes the pages_{4k,2m,1g} union, which is a
useful cleanup to prepare for the Common MMU [1].

And for full transparency, another motivation for this series it that at
Google we have several out-of-tree stats that use arrays. Custom name
support is something we added internally and it reduces our technical
debt to get the support merged upstream.

Link: https://lore.kernel.org/kvm/20221208193857.4090582-1-dmatlack@google.com/

David Matlack (5):
  KVM: Consistently use "stat" name in stats macros
  KVM: Spell out parameter names in stats macros
  KVM: Fix indentation in stats macros
  KVM: Allow custom names for stats
  KVM: x86: Drop union for pages_{4k,2m,1g} stats

 arch/x86/include/asm/kvm_host.h |   9 +-
 arch/x86/kvm/x86.c              |   6 +-
 include/linux/kvm_host.h        | 170 +++++++++++++++++++-------------
 3 files changed, 107 insertions(+), 78 deletions(-)


base-commit: de60733246ff4545a0483140c1f21426b8d7cb7f
prerequisite-patch-id: 42a76ce7cec240776c21f674e99e893a3a6bee58
-- 
2.39.0.246.g2a6d74b583-goog

