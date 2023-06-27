Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B50473EFBB
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 02:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjF0AdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 20:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjF0AdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 20:33:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048B91704
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-573d70da28fso53921367b3.3
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 17:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687825995; x=1690417995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9fqGtZIUUBbR6H7OY7ydnWLqg43w0WFqsDHH2de2eTg=;
        b=HJ91o5fHvs30JoXnR8K1n5WBne6dTcAfp7a2xTqfxgqfkwkxdQ7DsqBSnj52tgdPaF
         CszoJppo7MwPQCXPnlbCLCSIccTcHNGp8l4eYlbPtbQNr2+1y8RxbuKOyP9XEKSL3NNE
         HhjTGuntOP8B9CeBN28OuDIivmWAWbkjfh9OUDLnLFPqz1Je9m4M150NSQW98qcOPxMs
         9//2I4UBGXEcgYElfBBJihoagrETRETLCmyyFsHj8WGQiS/qmPBPux0XAtp5fGt4mmsf
         Gwg/EznP/YG4W4GmUgKQW/0Ym8GPUA6RPTxHIXtGCgfdOuXnYcWncDjhwouZVIjw2BXm
         hVfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687825995; x=1690417995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9fqGtZIUUBbR6H7OY7ydnWLqg43w0WFqsDHH2de2eTg=;
        b=Ab6i6iFcmademcWXkz5ZVWXqZ01hlP8+CPmcK2z36ffty+M9hVpRZXkcG5oT7A0xBl
         ZnwpTfhGkXKDKMihUUSv13/ZJPIRCbD/Iy56xGfS4Ua7TndxMfZ2dyWXkRHmWrMQ9GaY
         jj6SWpGdX9h8gRq6Ni8oqFIDGudb/zgGOGExjOMlwTxuS6QKa70xxbXyUc4ROWTQA3I9
         AWDllhI9D1LY0Dov92CmN9K/b6wX8VhGuV7l1N/WeGunJKU1ZZCfLpB75u8t6/1Z8/aA
         3l67oO7HqyMq5v+72+ppPEdhT9NyVwEN/5eq2HyOnnppjop3eLu9si5OFaH44rJt5Z0a
         V5CA==
X-Gm-Message-State: AC+VfDzD+YnaLJ8ApfFXMlkjPDqAEgT/1iheE0s4sO9yb3pinHPjioH3
        W0Nb2jYB3k6A1tFuSP+F0k1bLh5hmgU=
X-Google-Smtp-Source: ACHHUZ7+BHzfCfyr2nVkjrvCencUu9Aqh4HeZIC5FJ22aNhqGhKNdcewIL8+sjnXmZYJ9eDNChO7RtB61uQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1347:b0:c2c:1b68:99b7 with SMTP id
 g7-20020a056902134700b00c2c1b6899b7mr905564ybu.5.1687825995309; Mon, 26 Jun
 2023 17:33:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 26 Jun 2023 17:33:01 -0700
In-Reply-To: <20230627003306.2841058-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230627003306.2841058-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230627003306.2841058-3-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.5
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM x86/mmu changes for 6.5.  The new "never" option for nx_huge_pages is far
and away the most interesting change.  If you have an opinion on whether or not
KVM should default to "never" for CPUs that aren't affected by iTLB multi-hit,
now would be a wonderful time to speak up :-)

https://lore.kernel.org/all/168667299355.1927151.1998349801097712999.b4-ty@google.com

The following changes since commit b9846a698c9aff4eb2214a06ac83638ad098f33f:

  KVM: VMX: add MSR_IA32_TSX_CTRL into msrs_to_save (2023-05-21 04:05:51 -0400)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.5

for you to fetch changes up to 0b210faf337314e4bc88e796218bc70c72a51209:

  KVM: x86/mmu: Add "never" option to allow sticky disabling of nx_huge_pages (2023-06-13 09:16:03 -0700)

----------------------------------------------------------------
KVM x86/mmu changes for 6.5:

 - Add back a comment about the subtle side effect of try_cmpxchg64() in
   tdp_mmu_set_spte_atomic()

 - Add an assertion in __kvm_mmu_invalidate_addr() to verify that the target
   KVM MMU is the current MMU

 - Add a "never" option to effectively avoid creating NX hugepage recovery
   threads

----------------------------------------------------------------
Like Xu (1):
      KVM: x86/mmu: Assert on @mmu in the __kvm_mmu_invalidate_addr()

Sean Christopherson (1):
      KVM: x86/mmu: Add "never" option to allow sticky disabling of nx_huge_pages

Uros Bizjak (1):
      KVM: x86/mmu: Add comment on try_cmpxchg64 usage in tdp_mmu_set_spte_atomic

 arch/x86/kvm/mmu/mmu.c     | 49 +++++++++++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.c |  5 ++++-
 2 files changed, 48 insertions(+), 6 deletions(-)
