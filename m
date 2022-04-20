Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7348650893B
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378994AbiDTN2O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378984AbiDTN2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:28:04 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E82015821;
        Wed, 20 Apr 2022 06:25:18 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id bg9so1603442pgb.9;
        Wed, 20 Apr 2022 06:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uw7hE+OpDQkdNr0uKGFZJ5vQVWL49z4s2WTRmwaQ05I=;
        b=YaLiP2hUxSk43v5wycBbgbuw54epFr//EDwKZMZqVaaXkWYBV04u8LyERu3YOAvA4q
         nBrMMPx7EfraBDUgjCJHCadWlrBtxmwKqtcVZgORyF467eE7wmk4CSOa6O5hyUsPaom5
         h9meZm536lpbJhAU0YRJJy59jGae3NLgnP3suOoYHjR4uGsxg2E67BkDqATTSwIqH+n2
         yu/dQKpmD419FSE/SiPJ4Cx+OGvyee/PAhWBOsqr6Q/epp4RSK0vNdXASXUAcAGCkIOq
         FGjHs/tXaxaslowH3R1o2rCskBwDxNBaMD879H9z8tFYwax1pm1YRFb2wJIyZy1V9ddT
         tc7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Uw7hE+OpDQkdNr0uKGFZJ5vQVWL49z4s2WTRmwaQ05I=;
        b=6uaZ8G4lg4Emmq/rjNthLgzo3dMmBhrSCnYXgLhlYc9KWnDB3CnN5bOhjWmwvcWJAJ
         Cy95J/caZJArvU86sSNqYaB3vHy4nv56lVrnReVi7W6jTp+Ps93FPJAufB1QflK9wWEz
         VtLBgJtPFM7Pamp0fusYQKDUvJNO0zrDJ45OQ9bax1C+KFO8IcBN2STv4UjKmToLfAj1
         vlr+Ld+ChAibcHyBptPUtAtKUmgELoDgvz3tRvdBu4HPNJz0DVpG8Uw0gE9e1Dc4FS1m
         lDarxF5S9FiY94lSx/ZJReS24M4hb38XT0pgK7cnEyz9k99iVlRwhxARmKxiIlkO72dr
         IF/A==
X-Gm-Message-State: AOAM530P46r0YOjvK55vq3f31bKKxdcZFYQI/V01CWKc2k6BhLB+NQ0o
        I9GYp2xHLlHrrcKDE96qNzJbUdSIlsc=
X-Google-Smtp-Source: ABdhPJySltv7rc/II4M/udcWI3xD4Wa4S92ymS+5C210i7zImcrX8IK2s9pIhTZIBTDu5BRi4DOAxg==
X-Received: by 2002:a63:780f:0:b0:386:5d6f:2153 with SMTP id t15-20020a63780f000000b003865d6f2153mr18767782pgc.555.1650461117971;
        Wed, 20 Apr 2022 06:25:17 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id w13-20020a17090a5e0d00b001c7d4099670sm19611329pjf.28.2022.04.20.06.25.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:25:17 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH 0/7] KVM: X86/MMU: Use one-off special shadow page for special roots
Date:   Wed, 20 Apr 2022 21:25:58 +0800
Message-Id: <20220420132605.3813-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Current code use mmu->pae_root, mmu->pml4_root, and mmu->pml5_root to
setup special roots.  The initialization code is complex and the roots
are not associated with struct kvm_mmu_page which causes the code more
complex.

So add new special shadow pages to simplify it.

The special shadow pages are associated with struct kvm_mmu_page and
VCPU-local.

The special shadow pages are created and freed when the roots are
changed (or one-off) which can be optimized but not in the patchset
since the re-creating is light way (in normal case only the struct
kvm_mmu_page needs to be re-allocated and sp->spt doens't)

Lai Jiangshan (7):
  KVM: X86/MMU: Add using_special_root_page()
  KVM: X86/MMU: Add special shadow pages
  KVM: X86/MMU: Link PAE root pagetable with its children
  KVM: X86/MMU: Activate special shadow pages and remove old logic
  KVM: X86/MMU: Remove the check of the return value of to_shadow_page()
  KVM: X86/MMU: Allocate mmu->pae_root for PAE paging on-demand
  KVM: X86/MMU: Remove mmu_alloc_special_roots()

 arch/x86/include/asm/kvm_host.h |   3 -
 arch/x86/kvm/mmu/mmu.c          | 486 ++++++++++----------------------
 arch/x86/kvm/mmu/mmu_internal.h |  10 -
 arch/x86/kvm/mmu/paging_tmpl.h  |  15 +-
 arch/x86/kvm/mmu/spte.c         |   7 +
 arch/x86/kvm/mmu/spte.h         |   1 +
 arch/x86/kvm/mmu/tdp_mmu.h      |   7 +-
 7 files changed, 179 insertions(+), 350 deletions(-)

-- 
2.19.1.6.gb485710b

