Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0752973B9
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750701AbgJWQa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54738 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750673AbgJWQa3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=nWSnZNE5AMsZ/SnxNthTx2FSlmT82qW0XTqjQ2uPf6k=;
        b=SCQw1gyjHlIIw+ORYcT9BjLC9cECIyadlZ20GmDT+HzknKrGs29n+9D23+2G98ZzkJHf1E
        01uQZrcL67XlePHbyjTVdhJL6uHbkcaecGz68IfbaS/JipwEpSJplybs/RolEjo0opywr8
        1VygyiM7ozt038zZFYi1YCrPcavRFjk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-K6-NilGUNFiSFSA-qQXypQ-1; Fri, 23 Oct 2020 12:30:26 -0400
X-MC-Unique: K6-NilGUNFiSFSA-qQXypQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8ADB804B7E;
        Fri, 23 Oct 2020 16:30:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 722F25DA78;
        Fri, 23 Oct 2020 16:30:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 00/22] Introduce the TDP MMU
Date:   Fri, 23 Oct 2020 12:30:02 -0400
Message-Id: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I will just leave a link to Ben's detailed explanation

https://lore.kernel.org/kvm/20201014182700.2888246-1-bgardon@google.com/>

This series puts together all the small changes that were pointed out
on list; the only additions on my part are tracepoints and the introduction
of two source files spte.c and spte.h for code common to mmu.c and tdp_mmu.c.

Ben Gardon (19):
  kvm: mmu: Separate making non-leaf sptes from link_shadow_page
  kvm: x86/mmu: Separate making SPTEs from set_spte
  kvm: x86/mmu: Introduce tdp_iter
  kvm: x86/mmu: Init / Uninit the TDP MMU
  kvm: x86/mmu: Allocate and free TDP MMU roots
  kvm: x86/mmu: Add functions to handle changed TDP SPTEs
  kvm: x86/mmu: Support zapping SPTEs in the TDP MMU
  kvm: x86/mmu: Remove disallowed_hugepage_adjust shadow_walk_iterator
    arg
  kvm: x86/mmu: Add TDP MMU PF handler
  kvm: x86/mmu: Allocate struct kvm_mmu_pages for all pages in TDP MMU
  kvm: x86/mmu: Support invalidate range MMU notifier for TDP MMU
  kvm: x86/mmu: Add access tracking for tdp_mmu
  kvm: x86/mmu: Support changed pte notifier in tdp MMU
  kvm: x86/mmu: Support dirty logging for the TDP MMU
  kvm: x86/mmu: Support disabling dirty logging for the tdp MMU
  kvm: x86/mmu: Support write protection for nesting in tdp MMU
  kvm: x86/mmu: Support MMIO in the TDP MMU
  kvm: x86/mmu: Don't clear write flooding count for direct roots
  kvm: x86/mmu: NX largepage recovery for TDP MMU

Paolo Bonzini (2):
  KVM: mmu: Separate updating a PTE from kvm_set_pte_rmapp
  KVM: mmu: extract spte.h and spte.c

Peter Xu (1):
  KVM: Cache as_id in kvm_memory_slot

 arch/x86/include/asm/kvm_host.h |   14 +
 arch/x86/kvm/Makefile           |    3 +-
 arch/x86/kvm/mmu/mmu.c          |  785 ++++++---------------
 arch/x86/kvm/mmu/mmu_internal.h |   88 ++-
 arch/x86/kvm/mmu/mmutrace.h     |    8 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |    3 +-
 arch/x86/kvm/mmu/spte.c         |  318 +++++++++
 arch/x86/kvm/mmu/spte.h         |  252 +++++++
 arch/x86/kvm/mmu/tdp_iter.c     |  182 +++++
 arch/x86/kvm/mmu/tdp_iter.h     |   60 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 1157 +++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   48 ++
 include/linux/kvm_host.h        |    2 +
 virt/kvm/kvm_main.c             |   12 +-
 14 files changed, 2329 insertions(+), 603 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/spte.c
 create mode 100644 arch/x86/kvm/mmu/spte.h
 create mode 100644 arch/x86/kvm/mmu/tdp_iter.c
 create mode 100644 arch/x86/kvm/mmu/tdp_iter.h
 create mode 100644 arch/x86/kvm/mmu/tdp_mmu.c
 create mode 100644 arch/x86/kvm/mmu/tdp_mmu.h

-- 
2.26.2

