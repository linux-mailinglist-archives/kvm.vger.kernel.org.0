Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600F55C0554
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiIURfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiIURfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:35:54 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED0BA2624
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:35:51 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id d5-20020a63fd05000000b0043be829b589so1570789pgh.20
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=VX0FCtl1cwkKR6ZjHXk+oMQeOedSSfhlf0rCKZpagIg=;
        b=BJ9cwrWu5cptzsNBlXyje/rEcA5PGZFFuP13OP9ZGvHuBemLWiE56CJcN+W6+jRJuq
         Ngpb7aZQx4GAOUHLIJE1yLQZ3HiMdj27EK1QGyewWfQ6nBgPmyzu4qXU2ftE971aZMOB
         JUQFc7YQLJoSNET9SpZDDt8QGLXa4HP5btYE72lflDmuzTwgAkaCRGYhIBLG2MQRAsPk
         gK4eSbN1xLAHdYln9gwzfB0G1/fjJ5yPqPUC4Y6yb95ZUOOwGKc+u0Npk2Wr3xQuCIh2
         v7ILtYgCzptBWNPnhBkB7Nl+9yjG9dK9Ci8imBBezG92eC8N44+7qlreTn4i1xzgvBIo
         Avyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=VX0FCtl1cwkKR6ZjHXk+oMQeOedSSfhlf0rCKZpagIg=;
        b=ZRWP/fWqehUlbZwRWN9nSFK94Gc7KZMiytEiJInfEwGet5aohvs7DbbKhC/yhhEYq9
         Mj0pNWPXueg9mtyfJbup5RJG+fQgrrp6Gb1edzZfvfmzx5fKMqvy2BniW+6QSLsoIqq8
         6Z5mCmSKD5PMjc5x2ThXcOqkkHZSUCLVd7KFl9BAd2ECvYP6Re1SD9KXx+Yb2AgrSBgE
         Gg6cbouNoNRxfDLa4Cchb9zkFaJI9oYGSysaucm8zNnX1jQG9jAFsI1YXBLUAv9ltCPo
         CsZ6fvcqHWvhexpqlnbYhqpprJdm8Xr+Wd5yWC19f4GfqI3FTe7h51aNDs0BTUSPd8SL
         SePg==
X-Gm-Message-State: ACrzQf23FQyEbNvD/cwOmc+pLtUukSYO2uxnC2jVjUXG1KH8j0KuLwAW
        mJbRoxG4g27NzclDHEWEm8FCtob71sAhWg==
X-Google-Smtp-Source: AMsMyM4zPNKOwh2K9BlcAkwpGpMeDDs7gRLACe3A11l3xDLxlJax8+KpjXVqp+K/LkHUFst50qMvDknlQlfZ3w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:903:244b:b0:178:1c88:4a4c with SMTP
 id l11-20020a170903244b00b001781c884a4cmr5937639pls.95.1663781751269; Wed, 21
 Sep 2022 10:35:51 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:36 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-1-dmatlack@google.com>
Subject: [PATCH v3 00/10] KVM: x86/mmu: Make tdp_mmu read-only and clean up
 TPD MMU fault handler
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
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

This series changes the tdp_mmu module parameter to read-only so that
the TDP MMU can be tracked in a global variable instead of per-VM
state. Then it splits out a separate page fault handler for the TDP MMU
and makes some clean ups along the way.

v3:
 - Use __ro_after_init for tdp_mmu_allowed [Kai]
 - Use a macro instead of a const bool for 32-bit [Kai, Sean]
 - Drop unnecessary whitespace change [Isaku]
 - Make kvm_tdp_mmu_page_fault() static [Isaku]

v2: https://lore.kernel.org/kvm/20220826231227.4096391-1-dmatlack@google.com/
 - Make tdp_mmu read-only instead of deleting it entirely [Paolo]
 - Fix 32-bit compilation failures [kernel test robot]

v1: https://lore.kernel.org/kvm/20220815230110.2266741-1-dmatlack@google.com/

Cc: Kai Huang <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@gmail.com>
Cc: Peter Xu <peterx@redhat.com>

David Matlack (10):
  KVM: x86/mmu: Change tdp_mmu to a read-only parameter
  KVM: x86/mmu: Move TDP MMU VM init/uninit behind tdp_mmu_enabled
  KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faultin_pfn()
  KVM: x86/mmu: Handle error PFNs in kvm_faultin_pfn()
  KVM: x86/mmu: Avoid memslot lookup during KVM_PFN_ERR_HWPOISON
    handling
  KVM: x86/mmu: Handle no-slot faults in kvm_faultin_pfn()
  KVM: x86/mmu: Initialize fault.{gfn,slot} earlier for direct MMUs
  KVM: x86/mmu: Split out TDP MMU page fault handling
  KVM: x86/mmu: Stop needlessly making MMU pages available for TDP MMU
    faults
  KVM: x86/mmu: Rename __direct_map() to direct_map()

 arch/x86/include/asm/kvm_host.h |   9 --
 arch/x86/kvm/mmu.h              |   6 +-
 arch/x86/kvm/mmu/mmu.c          | 237 ++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h |   8 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  12 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  11 --
 arch/x86/kvm/mmu/tdp_mmu.h      |   7 +-
 7 files changed, 164 insertions(+), 126 deletions(-)


base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
-- 
2.37.3.998.g577e59143f-goog

