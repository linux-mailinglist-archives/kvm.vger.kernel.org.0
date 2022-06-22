Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152E7555450
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 21:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357484AbiFVT12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 15:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbiFVT1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 15:27:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C42B39686
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 12:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655926035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Xf2w4YFMBo/KqjwPtBP8STHhW74PSmVHW8ZoSdl5DBs=;
        b=N8qCoCy55iGa+j8ldeyMNZuBbpm8K1fXMXSgmpbccX/dber4yIRO4GbHvNzzIZvUYyPoCw
        OSGZZGzNBylzVE2jYDV+66+Zys1NGzGgTcp8uyoy3u1UqBBxSXCimTe2o77Wb0qFJesCyl
        CqKltdXit4uLFPygvYxmFTVpb9E+EaA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-gprVsIPsOwqRQYeDQd_oYA-1; Wed, 22 Jun 2022 15:27:12 -0400
X-MC-Unique: gprVsIPsOwqRQYeDQd_oYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E4E18001EA;
        Wed, 22 Jun 2022 19:27:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B71791121315;
        Wed, 22 Jun 2022 19:27:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     maz@kernel.org, anup@brainfault.org, seanjc@google.com,
        bgardon@google.com, peterx@redhat.com, maciej.szmigiero@oracle.com,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, pfeiner@google.com,
        jiangshanlai@gmail.com, dmatlack@google.com
Subject: [PATCH v7 00/23] KVM: Extend Eager Page Splitting to the shadow MMU
Date:   Wed, 22 Jun 2022 15:26:47 -0400
Message-Id: <20220622192710.2547152-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the description of the "why" of this patch, I'll just direct you to
David's excellent cover letter from v6, which can be found at
https://lore.kernel.org/r/20220516232138.1783324-1-dmatlack@google.com.

This version mostly does the following:

- apply the feedback from Sean and other reviewers, which is mostly
  aesthetic

- replace the refactoring of drop_large_spte()/__drop_large_spte()
  with my own version.  The insight there is that drop_large_spte()
  is always followed by {,__}link_shadow_page(), so the call is
  moved there

- split the TLB flush optimization into a separate patch, mostly
  to perform the previous refactoring independent of the optional
  TLB flush

- rename a few functions from *nested_mmu* to *shadow_mmu*

David Matlack (21):
  KVM: x86/mmu: Optimize MMU page cache lookup for all direct SPs
  KVM: x86/mmu: Use a bool for direct
  KVM: x86/mmu: Stop passing "direct" to mmu_alloc_root()
  KVM: x86/mmu: Derive shadow MMU page role from parent
  KVM: x86/mmu: Always pass 0 for @quadrant when gptes are 8 bytes
  KVM: x86/mmu: Decompose kvm_mmu_get_page() into separate functions
  KVM: x86/mmu: Consolidate shadow page allocation and initialization
  KVM: x86/mmu: Rename shadow MMU functions that deal with shadow pages
  KVM: x86/mmu: Move guest PT write-protection to account_shadowed()
  KVM: x86/mmu: Pass memory caches to allocate SPs separately
  KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()
  KVM: x86/mmu: Pass kvm pointer separately from vcpu to
    kvm_mmu_find_shadow_page()
  KVM: x86/mmu: Allow NULL @vcpu in kvm_mmu_find_shadow_page()
  KVM: x86/mmu: Pass const memslot to rmap_add()
  KVM: x86/mmu: Decouple rmap_add() and link_shadow_page() from kvm_vcpu
  KVM: x86/mmu: Update page stats in __rmap_add()
  KVM: x86/mmu: Cache the access bits of shadowed translations
  KVM: x86/mmu: Extend make_huge_page_split_spte() for the shadow MMU
  KVM: x86/mmu: Zap collapsible SPTEs in shadow MMU at all possible
    levels
  KVM: Allow for different capacities in kvm_mmu_memory_cache structs
  KVM: x86/mmu: Extend Eager Page Splitting to nested MMUs

Paolo Bonzini (2):
  KVM: x86/mmu: pull call to drop_large_spte() into __link_shadow_page()
  KVM: x86/mmu: Avoid unnecessary flush on eager page split

 .../admin-guide/kernel-parameters.txt         |   3 +-
 arch/arm64/kvm/mmu.c                          |   2 +-
 arch/riscv/kvm/mmu.c                          |   5 +-
 arch/x86/include/asm/kvm_host.h               |  24 +-
 arch/x86/kvm/mmu/mmu.c                        | 719 ++++++++++++++----
 arch/x86/kvm/mmu/mmu_internal.h               |  17 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  43 +-
 arch/x86/kvm/mmu/spte.c                       |  15 +-
 arch/x86/kvm/mmu/spte.h                       |   4 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 include/linux/kvm_host.h                      |   1 +
 include/linux/kvm_types.h                     |   6 +-
 virt/kvm/kvm_main.c                           |  33 +-
 13 files changed, 666 insertions(+), 208 deletions(-)

-- 
2.31.1

