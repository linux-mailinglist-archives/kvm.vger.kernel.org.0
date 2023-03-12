Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530946B64A4
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjCLKA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjCLKA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:26 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2781316AD1
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615174; x=1710151174;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WLBwEQjkQoCryRMUO8cY+cJTqmtKSazFq/By8a4QRBQ=;
  b=OJQYneTW6G7qwSibBMmjFtYTN9aAAlnBMk6qDjYZmbk0Ywbvl/6J/sRo
   N6QmttI5dQjHeAJjfEhYevrgxjgt2Cd9a7T+beGLVnT73/7Syr0WSZe/g
   jSA4Q3VoXx8v0hEKcoaojNMk1Q7mNkaTKx7g+8JmY3Xi1xVhUC7NiJk7p
   ELIhyaeczP5Cv0RCJmR4gfvis/Pwnfm4k6oEQmQ/YXQU2uFftzO9uoDNU
   9i8SWPsqfBY4mXtOaq5QkKfJEEbfveiGaRrGLiczRuAcyNe0CRh/OiorK
   rz1CHgAYI7N8wIgV5AVKk8OyRY4n4F0jjLKF8dYm0hHprnVAmA8mfJOzs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344748"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344748"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627478"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627478"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:19 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-7 00/12] Memory protection based on page state
Date:   Mon, 13 Mar 2023 02:04:03 +0800
Message-Id: <20230312180415.1778669-1-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DATE_IN_FUTURE_06_12,DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch set is part-7 of this RFC patches. It introduces memory
protection based on page state management for pKVM on Intel platform,
and enable running normal VM based on it.

Take use of ignored bits in EPT page table entry [1] to record page
state and owner id of a page:

 63 ... 58 |   57  56   |    ...    |  31 ... 12 | 11 ... 0
 ---------------------------------------------------------
 |  ...    | page state |    ...    | [owner_id] |    ...

Page state - bits[57,56]:
- PKVM_NOPAGE(00b):
	the page has no mapping in page table.
	under this page state, host EPT is using the pte ignored
	bits[31~12] to record owner_id.
- PKVM_PAGE_OWNED(01b):
	the page is owned exclusively by the page-table owner.
- PKVM_PAGE_SHARED_OWNED(10b):
	the page is owned by the page-table owner, but is shared
	with another.
- PKVM_PAGE_SHARED_BORROWED(11b):
	the page is shared with, but not owned by the page-table
	owner.

Owner_id - bits[31~12] (only valid in host EPT when PKVM_NOPAGE):
- 0: 	  PKVM_ID_HYP
- 1:      PKVM_ID_HOST
- others: PKVM_ID_GUEST

Below state machine defines how page states are transformed among
different entities (host EPT, and guest shadow EPT - which include
normal VM & protected VM):

                                            +------------------+
     +------------------+                   |  (Init state)    |
     |  host : NOPAGE   | <---------------- |  host* : OWNED   |
     |  guestA*: OWNED  | ----------------> |  guest: NOPAGE   |
     +------------------+       /           +------------------+
           |        ^          /                 |        ^
           |        |         /                  |        |
           |        |        /                   |        |
           |        |       /                    |        |
           |        |      /                     |        |
           v        |     /                      v        |
  +----------------------------+         +----------------------------+
  |   host : SHARED_BORROWED   |         |   host : SHARED_OWNED      |
  |   guestA: SHARED_OWNED     |         |   guestB*: SHARED_BORROWED |
  +----------------------------+         +----------------------------+

 [*] host:   EPT of host VM
 [*] guestA: shadow EPT of a protected VM
 [*] guestB: shadow EPT of a normal VM

Initially, all pages except pKVM owned ones are owned by host VM, so
these pages are marked with PKVM_PAGE_OWNED in host EPT. Meantime,
before guest first EPT_VIOLATION, there is no page mapped in guest
shadow EPT, so all page states in its shadow EPT are PKVM_NOPAGE.

When guest EPT_VIOLATION happen, pKVM needs to do EPT shadowing to
build shadow EPT page mapping based on virtual EPT. During it, the
corresponding page's state shall follow above state machine to do page
donation or page sharing.

- page donation

  For a protected VM (guestA), during EPT shadowing, the page assigned
  to guestA shall be donated from host VM. Which means the page's
  ownership is moved from host to guestA. So in host EPT, the mapping
  of corresponding page table entry (host_gpa to hpa(== host_gpa)) is
  removed and its page state is marked as PKVM_NOPAGE (meantime the
  guestA is recorded as owner_id). Meanwhile in guestA shadow EPT, the
  mapping of corresponding page table entry (gpa to hpa) is setup and
  its page state is marked as PKVM_PAGE_OWNED.

  Once a page is donated to a guest, it cannot be donated or shared to
  other guests before undonate back to host.

  Sometimes, host also need donate pages to the pKVM hypervisor (e.g.,
  when creating a VM, its shadow VM data strtucture is allocated in host
  then donated to the pKVM hypervisor).

  This patch set coveres page donation from host to the pKVM hypervisor,
  but does not include page dontation from host to a protected VM - it's
  essential to run a protected VM.

- page sharing

  For a normal VM (guestB), during EPT shadowing, the page assigned to
  guestB shall be shared from host VM. Which means both host VM and
  guestB can access this page. So in host EPT, the mapping of
  corresponding page table entry is kept and its page state is marked
  as PKVM_PAGE_SHARED_OWNED. Meanwhile in guestB shadow EPT, the mapping
  of corresponding page table entry is setup and its page state is marked
  as PKVM_PAGE_SHARED_BORROWED.

  Once a page is shared to a guest, it cannot be donated or shared to
  other guests before unshare back to host.

  For a protected VM (guestA), a page can be shared back to host VM after
  donated to this guest (e.g., to support virtio). For this case, in host
  EPT, the mapping of corresponding page table entry is setup again and
  its page state is marked as PKVM_PAGE_SHARED_BORROWED. Meanwhile in
  guestA shadow EPT, the mapping of corresponding page table entry is
  kept but its page state is changed to PKVM_PAGE_SHARED_OWNED.

  Once a page is shared back to host after donated, guestA is allowed to
  unshare it. And this page can also be returned back to host directly.

  [Note: above page sharing from a protected VM is not covered in the RFC]

Based on above, this patch set support page state APIs:

- __pkvm_host_donate_hyp/__pkvm_hyp_donate_host
  help to donate/undonate shadow VM/VCPU structure from host to pKVM
- __pkvm_host_share_guest/__pkvm_host_unshare_guest
  help to manage page state of a normal VM's memory, which in the future
  disallow protected VMs to allocate pages under such shared page state.

[1]: SDM: The Extended Page Table Mechanism (EPT) chapter

Jason Chen CJ (2):
  pkvm: x86: Add pgtable override helper functions for map/unmap/free
    leaf
  pkvm: x86: Use page state API in shadow EPT for normal VM

Shaoqin Huang (10):
  pkvm: x86: Introduce pkvm_pgtable_annotate
  pkvm: x86: Use host EPT to track page ownership
  pkvm: x86: Use SW bits to track page state
  pkvm: x86: Add the record of the page state into page table entry
  pkvm: x86: Expose host EPT lock
  pkvm: x86: Implement do_donate() helper for donating memory
  pkvm: x86: Implement __pkvm_hyp_donate_host()
  pkvm: x86: Donate shadow vm & vcpu pages to hypervisor
  pkvm: x86: Implement do_share() helper for sharing memory
  pkvm: x86: Implement do_unshare() helper for unsharing memory

 arch/x86/kvm/Kconfig                      |   1 +
 arch/x86/kvm/vmx/pkvm/hyp/Makefile        |   2 +-
 arch/x86/kvm/vmx/pkvm/hyp/ept.c           |  84 ++-
 arch/x86/kvm/vmx/pkvm/hyp/ept.h           |   3 +
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c |   6 +-
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c   | 593 ++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h   | 118 +++++
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c           |   5 +-
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.c       | 222 +++++---
 arch/x86/kvm/vmx/pkvm/hyp/pgtable.h       |  49 +-
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c          |  61 ++-
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h      |   6 +
 12 files changed, 1061 insertions(+), 89 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.c
 create mode 100644 arch/x86/kvm/vmx/pkvm/hyp/mem_protect.h

-- 
2.25.1

