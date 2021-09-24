Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B706441788F
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347438AbhIXQde (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347409AbhIXQdb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=U2Y5/PxeGrVOyJwkORaGRMrwQ31fo9+n2UjUMf0sONY=;
        b=QGW+ANGZvSomtkKQdZRGl7kSAT+iwdPWZc5p8b9ZaP6RRoRXiUE6tnpooop+MeWU1C9hvY
        gKgeOWd66sxV7E24TbDjOgah4onVcIyaqOziASOzGOToqg7m0/7ql2fWwh3VzCGJmkRntJ
        03FdHMBn58XhXqzzJw+EtC/8CRETNBo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-rCwcw5UbOVazqux64Zzpxw-1; Fri, 24 Sep 2021 12:31:54 -0400
X-MC-Unique: rCwcw5UbOVazqux64Zzpxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91EE191272;
        Fri, 24 Sep 2021 16:31:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 29F305FCAE;
        Fri, 24 Sep 2021 16:31:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 00/31] KVM: x86: pass arguments on the page fault path via struct kvm_page_fault
Date:   Fri, 24 Sep 2021 12:31:21 -0400
Message-Id: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current kvm page fault handlers passes around many arguments to the
functions.  To simplify those arguments and local variables, introduce
a data structure, struct kvm_page_fault, to hold those arguments and
variables.  struct kvm_page_fault is allocated on stack on the caller
of kvm fault handler, kvm_mmu_do_page_fault(), and passed around.

Later in the series, my patches are interleaved with David's work to
add the memory slot to the struct and avoid repeated lookups.  Along the
way you will find some cleanups of functions with a ludicrous number of
arguments, so that they use struct kvm_page_fault as much as possible
or at least receive related information from a single argument.  make_spte
in particular goes from 11 to 10 arguments (yeah I know) despite gaining
two for kvm_mmu_page and kvm_memory_slot.

This can be sometimes a bit debatable (for example struct kvm_mmu_page
is used a little more on the TDP MMU paths), but overall I think the
result is an improvement.  For example the SET_SPTE_* constants go
away, and they absolutely didn't belong in the TDP MMU.  But if you
disagree with some of the changes, please speak up loudly!

Testing: survives kvm-unit-tests on Intel with all of ept=0, ept=1
tdp_mmu=0, ept=1.  Will do more before committing to it in kvm/next of
course.

Paolo

David Matlack (5):
  KVM: x86/mmu: Fold rmap_recycle into rmap_add
  KVM: x86/mmu: Pass the memslot around via struct kvm_page_fault
  KVM: x86/mmu: Avoid memslot lookup in page_fault_handle_page_track
  KVM: x86/mmu: Avoid memslot lookup in rmap_add
  KVM: x86/mmu: Avoid memslot lookup in make_spte and
    mmu_try_to_unsync_pages

Paolo Bonzini (25):
  KVM: MMU: pass unadulterated gpa to direct_page_fault
  KVM: MMU: Introduce struct kvm_page_fault
  KVM: MMU: change mmu->page_fault() arguments to kvm_page_fault
  KVM: MMU: change direct_page_fault() arguments to kvm_page_fault
  KVM: MMU: change page_fault_handle_page_track() arguments to
    kvm_page_fault
  KVM: MMU: change kvm_faultin_pfn() arguments to kvm_page_fault
  KVM: MMU: change handle_abnormal_pfn() arguments to kvm_page_fault
  KVM: MMU: change __direct_map() arguments to kvm_page_fault
  KVM: MMU: change FNAME(fetch)() arguments to kvm_page_fault
  KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault
  KVM: MMU: change tdp_mmu_map_handle_target_level() arguments to
    kvm_page_fault
  KVM: MMU: change fast_page_fault() arguments to kvm_page_fault
  KVM: MMU: change kvm_mmu_hugepage_adjust() arguments to kvm_page_fault
  KVM: MMU: change disallowed_hugepage_adjust() arguments to
    kvm_page_fault
  KVM: MMU: change tracepoints arguments to kvm_page_fault
  KVM: MMU: mark page dirty in make_spte
  KVM: MMU: unify tdp_mmu_map_set_spte_atomic and
    tdp_mmu_set_spte_atomic_no_dirty_log
  KVM: MMU: inline set_spte in mmu_set_spte
  KVM: MMU: inline set_spte in FNAME(sync_page)
  KVM: MMU: clean up make_spte return value
  KVM: MMU: remove unnecessary argument to mmu_set_spte
  KVM: MMU: set ad_disabled in TDP MMU role
  KVM: MMU: pass kvm_mmu_page struct to make_spte
  KVM: MMU: pass struct kvm_page_fault to mmu_set_spte
  KVM: MMU: make spte an in-out argument in make_spte

Sean Christopherson (1):
  KVM: x86/mmu: Verify shadow walk doesn't terminate early in page
    faults

 arch/x86/include/asm/kvm_host.h       |   4 +-
 arch/x86/include/asm/kvm_page_track.h |   4 +-
 arch/x86/kvm/mmu.h                    |  84 +++++-
 arch/x86/kvm/mmu/mmu.c                | 408 +++++++++++---------------
 arch/x86/kvm/mmu/mmu_internal.h       |  22 +-
 arch/x86/kvm/mmu/mmutrace.h           |  18 +-
 arch/x86/kvm/mmu/page_track.c         |   6 +-
 arch/x86/kvm/mmu/paging_tmpl.h        | 137 +++++----
 arch/x86/kvm/mmu/spte.c               |  29 +-
 arch/x86/kvm/mmu/spte.h               |  14 +-
 arch/x86/kvm/mmu/tdp_mmu.c            | 123 +++-----
 arch/x86/kvm/mmu/tdp_mmu.h            |   4 +-
 12 files changed, 390 insertions(+), 463 deletions(-)

-- 
2.27.0

