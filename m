Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F5C7532C1
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbjGNHOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbjGNHOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:14:39 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D3F2D61;
        Fri, 14 Jul 2023 00:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689318870; x=1720854870;
  h=from:to:cc:subject:date:message-id;
  bh=O9jnJ5j3krm419hqh5DB2huVZuUSyj8Ki0+dAkw19FQ=;
  b=M8jfZbGDFHJEdm2A49IXsEQ9g/LfCBUoZ53xJMiVrzyiNfZqLoHud7E1
   Jp3EzOr+7GwQB+fgjPcAQRZQUJq6Y4L6JI/Z9R/RdVvgofBlUWdgi/WmC
   75nRrINr/tQuLxSBkn3HYzNO0ooYP1DHldB2/EVWlD6Tap8gZeese7oR5
   mFhXi9V+QjgimO9p9vv7rWwZxJEguSZVhOya4TIaaMiKga6kslrlB6Kfg
   Rxj9uBMa5bfS+RssySYZ0C1vDsSJygrOyIjeEqM8MVmZcROTBMiRyiV/E
   p6a8F2HUndJo5uAxDLqQpLiXF90IfeuHF6/r9R8XSUS8X/oMxhGpKAmPZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="355348168"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="355348168"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:14:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="757475076"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="757475076"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:14:27 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 00/12] KVM: x86/mmu: refine memtype related mmu zap
Date:   Fri, 14 Jul 2023 14:46:56 +0800
Message-Id: <20230714064656.20147-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series refines mmu zap caused by EPT memory type update when guest
MTRRs are honored.

Patches 1-5 revolve around utilizing helper functions to check if
KVM TDP honors guest MTRRs, TDP zaps and page fault max_level reduction
are now only targeted to TDPs that honor guest MTRRs.

-The 5th patch will trigger zapping of TDP leaf entries if non-coherent
 DMA devices count goes from 0 to 1 or from 1 to 0.

Patches 6-7 are fixes and patches 9-12 are optimizations for mmu zaps
when guest MTRRs are honored.
Those mmu zaps are intended to remove stale memtypes of TDP entries
caused by changes of guest MTRRs and CR0.CD and are usually triggered from
all vCPUs in bursts.

- The 6th patch places TDP zap to when CR0.CD toggles and when guest MTRRs
  update under CR0.CD=0.

- The 7th-8th patches refine KVM_X86_QUIRK_CD_NW_CLEARED by removing the
  IPAT bit in EPT memtype when CR0.CD=1 and guest MTRRs are honored.

- The 9th-11th patches are optimizations of the mmu zap when guest MTRRs
  are honored by serializing vCPUs' gfn zap requests and calculating of
  precise fine-grained ranges to zap.
  They are put in mtrr.c because the optimizations are related to when
  guest MTRRs are honored and because it requires to read guest MTRRs
  for fine-grained ranges.
  Calls to kvm_unmap_gfn_range() are not included into the optimization,
  because they are not triggered from all vCPUs in bursts and not all of
  them are blockable. They usually happen at memslot removal and thus do
  not affect the mmu zaps when guest MTRRs are honored. Also, current
  performance data shows that there's no observable performance difference
  to mmu zaps by turning on/off auto numa balancing triggered
  kvm_unmap_gfn_range().

- The 12th patch further convert kvm_zap_gfn_range() to use shared
  mmu_lock in TDP MMU. It can visibly help to reduce cost in contentions
  along with vCPUs number increases.

A reference performance data for last 7 patches as below:

Base1: base code before patch 6
Base2: Base 1 + patches 6 + 7 + 8
       patch 6: move TDP zaps from guest MTRRs update to CR0.CD toggling
       patch 7: drop IPAT in memtype when CD=1 for
                KVM_X86_QUIRK_CD_NW_CLEARED
       patch 8: entralize code to get CD=1 memtype when guest MTRRs are
                honored 

patch 9:  serialize gfn zap
patch 10: fine-grained gfn zap 
patch 11: split and zap in-slot gfn ranges only **
patch 12: convert gfn zap to use shared mmu_lock
_________________________________________________________________________
   guest bios: OVMF        | 8 vCPUs  memory=16G  | 16 vCPUs memory=16G  |
 CPU frequency: 3100 MHz   | zap cycles | zap cnt | zap cycles | zap cnt |
---------------------------|----------------------|----------------------|
Base1                      |  3506.37M  |    84   | 17683.24M  |   164   |
Base2                      |  4241.46M  |    74   | 25944.80M  |   146   |*
Base2 + Patch 9            |   319.23M  |    74   |  6183.92M  |   146   |
Base2 + Patches 9+10       |   128.34M  |    74   |  1735.13M  |   146   |
Base2 + Patches 9+10+11    |    37.17M  |    74   |   357.68M  |   146   |
Base2 + Patches 9+10+11+12 |    17.21M  |    74   |    39.85M  |   146   |
---------------------------|----------------------|----------------------|
Base2 + Patch 12           |    32.66M  |    74   |    74.77M  |   146   |
Base2 + Patches 9+10+12    |    15.01M  |    74   |    35.46M  |   146   |
___________________________|______________________|______________________|

_________________________________________________________________________
   guest bios: Seabios     | 8 vCPUs  memory=16G  | 16 vCPUs memory=16G  |
 CPU frequency: 3100 MHz   | zap cycles | zap cnt | zap cycles | zap cnt |
---------------------------|----------------------|----------------------|
Base1                      |    44.55M  |    50   |   532.71M  |    98   |
Base2                      |   526.65M  |    42   |  2138.80M  |    82   |*
Base2 + Patch 9            |   116.59M  |    42   |   922.68M  |    82   |
Base2 + Patches 9+10       |    62.09M  |    42   |   377.15M  |    82   |
Base2 + Patches 9+10+11    |    17.86M  |    42   |    49.88M  |    82   |
Base2 + Patches 9+10+11+12 |    16.98M  |    42   |    44.64M  |    82   |
---------------------------|----------------------|----------------------|
Base2 + Patch 12           |    24.65M  |    42   |    62.04M  |    82   |
Base2 + Patches 9+10+12    |    18.44M  |    42   |    41.88M  |    82   |
___________________________|______________________|______________________|


* With Base2, EPT zap cnt are reduced because there are some MTRR updates
  under CR0.CD=1.
  EPT zap cycles increases a bit (especially true in case of Seabios)
  because concurrency is more intense when CR0.CD toggles than when
  guest MTRRs update.
  (patch 7/8 are neglectable in performance)

** patch 11 splits a single gfn range that may cover out-of-slot ranges
   into several in-slot ranges and zap only those in-slot ranges.
   It essentially reduces the counts to check contentions and yileds
   when mmu_lock is held for write.
   However, if mmu_lock is held for read (i.e. with patch 12), the
   effect of reducing contention and yileds from patch 11 are not that
   obvious, whereas patch 11 may introduce more kmalloc() for splitting.
   So, I intend to drop patch 11 if patch 12 is acceptable. 


Changelog:
v3 --> v4:
1. Added patch 12 of converting gfn zap to use shared mmu_lock.
2. Updated commit messages of patch 3 and patch 4 to better describe
   patch intention. (Sean)
3. Updated commit message of patch 7 to explain the problem better.
   (Chao Gao, Xiaoyao Li, Yuan Yao)
4. Renamed kvm_mtrr_get_cd_memory_type() to
   kvm_honors_guest_mtrrs_get_cd_memtype() in patch 8.
5. Renamed kvm_zap_gfn_range_on_cd_toggle() to
   kvm_honors_guest_mtrrs_get_cd_memtype() in patch 9.
6. Move initialization of mtrr_zap_list_lock and mtrr_zap_list from
   kvm_vcpu_mtrr_init() to kvm_arch_init_vm(). (Sean)
7. Removed unnecesary kvm_clear_mtrr_zap_list() in patch 9 and moved it
   to patch 10. (Yuan Yao).
8. Added a table in comment for fine-grained zapping for
   kvm_honors_guest_mtrrs_zap_on_cd_toggle(). (Yuan Yao)

v2 --> v3:
1. Updated patch 1 about definition of honor guest MTRRs helper. (Sean)
2. Added patch 2 to use honor guest MTRRs helper in kvm_tdp_page_fault().
   (Sean)
3. Remove unnecessary calculation of MTRR ranges.
   (Chao Gao, Kai Huang, Sean)
4. Updated patches 3-5 to use the helper. (Chao Gao, Kai Huang, Sean)
5. Added patches 6,7 to reposition TDP zap and drop IPAT bit. (Sean)
6. Added patch 8 to prepare for patch 10's memtype calculation when
   CR0.CD=1.
7. Added patches 9-11 to speed up MTRR update /CD0 toggle when guest
   MTRRs are honored. (Sean)
8. Dropped per-VM based MTRRs in v2 (Sean)

v1 --> v2:
1. Added a helper to skip non EPT case in patch 1
2. Added patch 2 to skip mmu zap when guest CR0_CD changes if EPT is not
   enabled. (Chao Gao)
3. Added patch 3 to skip mmu zap when guest MTRR changes if EPT is not
   enabled.
4. Do not mention TDX in patch 4 as the code is not merged yet (Chao Gao)
5. Added patches 5-6 to reduce EPT zap during guest bootup.

v3:
https://lore.kernel.org/all/20230616023101.7019-1-yan.y.zhao@intel.com/

v2:
https://lore.kernel.org/all/20230509134825.1523-1-yan.y.zhao@intel.com/

v1:
https://lore.kernel.org/all/20230508034700.7686-1-yan.y.zhao@intel.com/

Yan Zhao (12):
  KVM: x86/mmu: helpers to return if KVM honors guest MTRRs
  KVM: x86/mmu: Use KVM honors guest MTRRs helper in
    kvm_tdp_page_fault()
  KVM: x86/mmu: Use KVM honors guest MTRRs helper when CR0.CD toggles
  KVM: x86/mmu: Use KVM honors guest MTRRs helper when update mtrr
  KVM: x86/mmu: zap KVM TDP when noncoherent DMA assignment starts/stops
  KVM: x86/mmu: move TDP zaps from guest MTRRs update to CR0.CD toggling
  KVM: VMX: drop IPAT in memtype when CD=1 for
    KVM_X86_QUIRK_CD_NW_CLEARED
  KVM: x86: centralize code to get CD=1 memtype when guest MTRRs are
    honored
  KVM: x86/mmu: serialize vCPUs to zap gfn when guest MTRRs are honored
  KVM: x86/mmu: fine-grained gfn zap when guest MTRRs are honored
  KVM: x86/mmu: split a single gfn zap range when guest MTRRs are
    honored
  KVM: x86/mmu: convert kvm_zap_gfn_range() to use shared mmu_lock in
    TDP MMU

 arch/x86/include/asm/kvm_host.h |   4 +
 arch/x86/kvm/mmu.h              |   7 +
 arch/x86/kvm/mmu/mmu.c          |  32 +++-
 arch/x86/kvm/mmu/tdp_mmu.c      |  50 +++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   1 +
 arch/x86/kvm/mtrr.c             | 328 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c          |  11 +-
 arch/x86/kvm/x86.c              |  28 ++-
 arch/x86/kvm/x86.h              |   3 +
 9 files changed, 439 insertions(+), 25 deletions(-)

-- 
2.17.1

