Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676413E359F
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 15:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhHGNuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Aug 2021 09:50:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40304 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232290AbhHGNuC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 7 Aug 2021 09:50:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628344184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AaBBtNAYhX+X64Q0FTJeD4fdcyTME+oaQEbI4zW7Bpc=;
        b=EFa8bRLe2dFE6oK0+f5l1tWFBVmVKlxZYVG7eeK7Z+PYaFJP7fwDLP8SCIss87GxuW994m
        5HQLZsfSR2wW8nO2cGaSksgneUsS+7Z7Lb4PzC5KdRu7Pa0s7fh36a/+P0iYudjle320z5
        9pduqN/eoTpvgT2NvajvmVG57E7lJdc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-JW6QHoQpPm-2ukZNNqvc8w-1; Sat, 07 Aug 2021 09:49:43 -0400
X-MC-Unique: JW6QHoQpPm-2ukZNNqvc8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFCD81835AC3;
        Sat,  7 Aug 2021 13:49:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 812CE27CA4;
        Sat,  7 Aug 2021 13:49:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        seanjc@google.com, peterx@redhat.com
Subject: [PATCH 00/16] KVM: x86: pass arguments on the page fault path via struct kvm_page_fault
Date:   Sat,  7 Aug 2021 09:49:20 -0400
Message-Id: <20210807134936.3083984-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a revival of Isaku's patches from
https://lore.kernel.org/kvm/cover.1618914692.git.isaku.yamahata@intel.com/.
The current kvm page fault handlers passes around many arguments to the
functions.  To simplify those arguments and local variables, introduce
a data structure, struct kvm_page_fault, to hold those arguments and
variables.  struct kvm_page_fault is allocated on stack on the caller
of kvm fault handler, kvm_mmu_do_page_fault(), and passed around.

The patches were redone from scratch based on the suggested struct layout
from the review (https://lore.kernel.org/kvm/YK65V++S2Kt1OLTu@google.com/)
and the subjects of Isaku's patches, so I kept authorship for myself
and gave him a "Suggested-by" tag.

The first two steps are unrelated cleanups that come in handy later on.

Paolo

Paolo Bonzini (16):
  KVM: MMU: pass unadulterated gpa to direct_page_fault
  KVM: x86: clamp host mapping level to max_level in
    kvm_mmu_max_mapping_level
  KVM: MMU: Introduce struct kvm_page_fault
  KVM: MMU: change mmu->page_fault() arguments to kvm_page_fault
  KVM: MMU: change direct_page_fault() arguments to kvm_page_fault
  KVM: MMU: change page_fault_handle_page_track() arguments to
    kvm_page_fault
  KVM: MMU: change try_async_pf() arguments to kvm_page_fault
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

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu.h              |  81 ++++++++++-
 arch/x86/kvm/mmu/mmu.c          | 241 ++++++++++++++------------------
 arch/x86/kvm/mmu/mmu_internal.h |  13 +-
 arch/x86/kvm/mmu/mmutrace.h     |  18 +--
 arch/x86/kvm/mmu/paging_tmpl.h  |  96 ++++++-------
 arch/x86/kvm/mmu/tdp_mmu.c      |  49 +++----
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +-
 8 files changed, 253 insertions(+), 253 deletions(-)

-- 
2.27.0

