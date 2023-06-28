Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7B9741BCF
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 00:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjF1Wnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 18:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjF1WnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 18:43:22 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE841715;
        Wed, 28 Jun 2023 15:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687992200; x=1719528200;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x+1cfc/xmoFxBnLLgTcKrep1dUoeoXKUxnolji14RNc=;
  b=demIm3U0Dy3KSwiOehDB1LWzsy0oKoA6oT37rK1wTuFRYalpd3HJGnip
   UtYR1Zqr+QlIsDirgbARaPBFU1acRu3Iqw5aD5cmH1/W7G/h3jnzyN9vG
   K6vVbwrKbzIae+O7dA4zWTiv516eaHCeqQcWxHEjZT3C374iSOZCzQlN7
   SGfoOpaYNaOnZfkRdZlWb6qD0kYlYu8yPOAtZ0y4HjHWvUlTQzmo62hgx
   TudevnR1DlXD3WrOguya8EfZ9VPLOUBJWdpsdQ+Rg66ofsN5YbdBwSHqU
   chEfgWS4sJ1424bYreUruKQTbYC+fZ1xyu/MxTi80FeAwVlu6+RDRZf6B
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="392699110"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="392699110"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="830299976"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="830299976"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:19 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v3 00/11] KVM: guest memory: Misc enhacnement
Date:   Wed, 28 Jun 2023 15:42:59 -0700
Message-Id: <cover.1687991811.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Hello. I've updated the patch series based on the feedback. Here are the
discussion points.

- 06/11 KVM: x86: Introduce PFERR_GUEST_ENC_MASK to indicate fault is private
  Michael has his own opinion on how to indicate private fault.

- 09/11 KVM: Add new members to struct kvm_gfn_range to operate on

- 10/11 KVM: x86: Add gmem hook for initializing private memory
  SNP needs the callback. TDX won't use this one.

- 11/11 KVM: x86: Add gmem hook for invalidating private memory
  SNP needs the callback. TDX doesn't use this one at the moment, but would
  use it.
  
- VM type:
  I didn't rename KVM_X86_PROTECTED_VM to KVM_X86_SW_PROTECTED_VM  in this patch
  series.  It's easy to rename it if desired.

Thanks,

This is an RFC patch series based on KVM gmem [1] and [2] for the common use of
TDX and SEV-SNP.

[1] KVM gmem patches
https://github.com/sean-jc/linux/tree/x86/kvm_gmem_solo

[2] Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support
https://lore.kernel.org/lkml/20230612042559.375660-1-michael.roth@amd.com/

---
v3:
- Imported common patches from Michael Roth which can be useful for both SNP
  and TDX.  And reorder patches.
- Update struct kvm_gfn_range to drop flag, and add add only_private, and
  only_shared
- Update kvm_arch_set_memory_attributes() and added a x86 vendor callback for
  it.

v2:
https://lore.kernel.org/all/cover.1687474039.git.isaku.yamahata@intel.com/

v1:
https://lore.kernel.org/all/cover.1686858861.git.isaku.yamahata@intel.com/

Brijesh Singh (1):
  KVM: x86: Export the kvm_zap_gfn_range() for the SNP use

Isaku Yamahata (8):
  KVM: selftests: Fix test_add_overlapping_private_memory_regions()
  KVM: selftests: Fix guest_memfd()
  KVM: selftests: x86: typo in private_mem_conversions_test.c
  KVM: x86: Add is_vm_type_supported callback
  KVM: x86/mmu: Pass around full 64-bit error code for the KVM page
    fault
  KVM: x86: Introduce PFERR_GUEST_ENC_MASK to indicate fault is private
  KVM: Fix set_mem_attr ioctl when error case
  KVM: Add new members to struct kvm_gfn_range to operate on

Michael Roth (2):
  KVM: x86: Add gmem hook for initializing private memory
  KVM: x86: Add gmem hook for invalidating private memory

 arch/x86/include/asm/kvm-x86-ops.h            |  4 ++
 arch/x86/include/asm/kvm_host.h               | 12 +++++
 arch/x86/include/uapi/asm/kvm.h               |  1 +
 arch/x86/kvm/mmu.h                            |  2 -
 arch/x86/kvm/mmu/mmu.c                        | 51 ++++++++++++++-----
 arch/x86/kvm/mmu/mmu_internal.h               | 20 ++++++--
 arch/x86/kvm/mmu/mmutrace.h                   |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h                |  2 +-
 arch/x86/kvm/svm/svm.c                        |  7 +++
 arch/x86/kvm/vmx/vmx.c                        |  6 +++
 arch/x86/kvm/x86.c                            | 16 +++++-
 arch/x86/kvm/x86.h                            |  2 +
 include/linux/kvm_host.h                      | 16 ++++--
 .../testing/selftests/kvm/guest_memfd_test.c  |  4 +-
 .../selftests/kvm/set_memory_region_test.c    | 16 +++++-
 .../kvm/x86_64/private_mem_conversions_test.c |  2 +-
 virt/kvm/guest_mem.c                          | 50 +++++++++++++++++-
 virt/kvm/kvm_main.c                           | 24 +++++----
 18 files changed, 192 insertions(+), 45 deletions(-)


base-commit: be8abcec83c87d4e15ae04816b685fe260c4bcfd
-- 
2.25.1

