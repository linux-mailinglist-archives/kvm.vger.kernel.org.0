Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2BC75BB30
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 01:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjGTXdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 19:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGTXdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 19:33:12 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A918270D;
        Thu, 20 Jul 2023 16:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689895991; x=1721431991;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BrEbJ16MxVvOmFxYkJm66f3vE5Q8SWoOfsGomRcI7kg=;
  b=W7pxMsfjSnDH8feB6F+FuvumpQBU56St3GoyMBjkQ7xnkwJ5APGPT8Nu
   3UNaiQ5CgxtnPF6ndfnHvPvI7jpzrZ4ZQPgQS+ZZv1/H0J3/RE2bWaFs3
   YgO+GepqTcaE+CEBF3h9JA0wTBcxM7mUZlbluybZKqhJSlY2Lu9/uTpmk
   mRSkANbkzHQ7UpNNRqsPSQPSJCuI3+BurYgMJZIv0Si/nVD5ayGWHPc/l
   K+xyyc6VEyOYs2UOJO8iZ3FkuTcyWgypW9Uf9Nodtxi3kOdlXzWM16Byd
   y0DBOJqu73mZNwzRj1HmYS7Ygj226lxPA6Fu6TZeiiWmrMRA+M9GAoaFD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="364355895"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="364355895"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="727891775"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="727891775"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:10 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v4 00/10] KVM: guest_memfd(), X86: Common base for SNP and TDX (was KVM: guest memory: Misc enhancement)
Date:   Thu, 20 Jul 2023 16:32:46 -0700
Message-Id: <cover.1689893403.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Hello. I've updated KVM: guest memory: Misc enhancement patch series based
on "[RFC PATCH v11 00/29]  KVM: guest_memfd() and per-page attributes" [1].
I changed the subject to represent the patch series better.

The purpose is to get agreement on the common base patches both for SNP [2] and
TDX [3]. (And hopefully for other technology to protect guest memory.) Then, SNP
and TDX can make progress without stepping on each other.

The main change from the previous version is
- The rebased to v11 KVM guest_memfd()
- Introduce KVM_X86_SNP_VM and KVM_x86_TDX_VM
- Make KVM_MEM_ENC_OP uABI common for SNP and TDX

[1] https://lore.kernel.org/all/20230718234512.1690985-1-seanjc@google.com/

[2] https://lore.kernel.org/lkml/20230612042559.375660-1-michael.roth@amd.com/
Add AMD Secure Nested Paging (SEV-SNP) Hypervisor Support

[3] https://lore.kernel.org/all/cover.1685333727.git.isaku.yamahata@intel.com/
KVM TDX basic feature support

Changes:
v4:
- The rebased to v11 KVM guest_memfd()
- Introduce KVM_X86_SNP_VM and KVM_x86_TDX_VM
- Newly include a patch to make KVM_MEM_ENC_OP uABI common for SNP and TDX
- include a patch to address IMPLICIT_ACCESS

v3:
https://lore.kernel.org/all/cover.1687991811.git.isaku.yamahata@intel.com/

v2:
https://lore.kernel.org/all/cover.1687474039.git.isaku.yamahata@intel.com/

v1:
https://lore.kernel.org/all/cover.1686858861.git.isaku.yamahata@intel.com/

Brijesh Singh (1):
  KVM: x86: Export the kvm_zap_gfn_range() for the SNP use

Isaku Yamahata (6):
  KVM: x86: Add is_vm_type_supported callback
  KVM: x86/mmu: Pass around full 64-bit error code for the KVM page
    fault
  KVM: x86: Introduce PFERR_GUEST_ENC_MASK to indicate fault is private
  KVM: Add new members to struct kvm_gfn_range to operate on
  KVM: x86: Make struct sev_cmd common for KVM_MEM_ENC_OP
  KVM: X86: KVM_MEM_ENC_OP check if unused field (flags, error) is zero

Michael Roth (2):
  KVM: x86: Add gmem hook for initializing private memory
  KVM: x86: Add gmem hook for invalidating private memory

Sean Christopherson (1):
  KVM: x86/mmu: Guard against collision with KVM-defined
    PFERR_IMPLICIT_ACCESS

 arch/x86/include/asm/kvm-x86-ops.h |  3 ++
 arch/x86/include/asm/kvm_host.h    | 10 ++++-
 arch/x86/include/uapi/asm/kvm.h    | 35 +++++++++++++++
 arch/x86/kvm/mmu.h                 |  2 -
 arch/x86/kvm/mmu/mmu.c             | 37 +++++++++++++---
 arch/x86/kvm/mmu/mmu_internal.h    | 18 ++++++--
 arch/x86/kvm/mmu/mmutrace.h        |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h     |  2 +-
 arch/x86/kvm/svm/sev.c             | 68 ++++++++++++++++--------------
 arch/x86/kvm/svm/svm.c             |  7 +++
 arch/x86/kvm/svm/svm.h             |  2 +-
 arch/x86/kvm/vmx/vmx.c             |  7 +++
 arch/x86/kvm/x86.c                 | 50 +++++++++++++++++++++-
 arch/x86/kvm/x86.h                 |  2 +
 include/linux/kvm_host.h           |  5 +++
 virt/kvm/guest_mem.c               | 44 +++++++++++++++++++
 virt/kvm/kvm_main.c                |  4 ++
 17 files changed, 249 insertions(+), 49 deletions(-)


base-commit: bfa3037d828050896ae52f6467b6ca2489ae6fb1
prerequisite-patch-id: 3bd3037b3803e2d84f0ef98bb6c678be44eddd08
prerequisite-patch-id: b474cbf4f0ea21cf945036271f5286017e0efc84
prerequisite-patch-id: bd96a89fafe51956a55fdfc08a3ea2a37a2e55e4
prerequisite-patch-id: f15d178f9000430e0089c546756ab1d8d29341a7
prerequisite-patch-id: 5b34829d7433fa81ed574d724ee476b9cc2e6a50
prerequisite-patch-id: bf75388851ee37a83b37bfa7cb0084f27301f6bc
prerequisite-patch-id: 9d77fb0e8ce8c8c21e22ff3f26bd168eb5446df0
prerequisite-patch-id: 7152514149d4b4525a0057e3460ff78861e162f5
prerequisite-patch-id: a1d688257a210564ebeb23b1eef4b9ad1f5d7be3
prerequisite-patch-id: 0b1e771c370a03e1588ed97ee77cb0493d9304f4
prerequisite-patch-id: 313219882d617e4d4cb226760d1f071f52b3f882
prerequisite-patch-id: a8ebe373e3913fd0e0a55c57f55690f432975ec0
prerequisite-patch-id: 8b06f2333214e355b145113e33c65ade85d7eac4
prerequisite-patch-id: e739dd58995d35b0f888d02a6bf4ea144476f264
prerequisite-patch-id: 0e93d19cb59f3a052a377a56ff0a4399046818aa
prerequisite-patch-id: 4e0839abbfb8885154e278b4b0071a760199ad46
prerequisite-patch-id: be193bb3393ad8a16ea376a530df20a145145259
prerequisite-patch-id: 301dbdf8448175ea609664c890a3694750ecf740
prerequisite-patch-id: ba8e6068bcef7865bb5523065e19edd49fbc02de
prerequisite-patch-id: 81b25d13169b3617c12992dce85613a2730b0e1b
prerequisite-patch-id: b4526dee5b5a95da0a13116ae0c73d4e69efa3c6
prerequisite-patch-id: 8c62bacc52a75d4a9038a3f597fe436c50e07de3
prerequisite-patch-id: 5618d2414a1ef641b4c247b5e28076f67a765b24
prerequisite-patch-id: 022b4620f6ff729eca842192259e986d126e7fa6
prerequisite-patch-id: 73ebc581a3ce9a51167785d273fe69406ccccaed
prerequisite-patch-id: 1225df90aeae430a74354bc5ad0ddf508d0707db
prerequisite-patch-id: 1e38df398ee370ad7e457f4890d6e4457e8a83fa
prerequisite-patch-id: b8812b613f5674351565ea28354e91a756efd56e
prerequisite-patch-id: e231eff2baba07c2de984dd6cf83ad1a31b792b8
-- 
2.25.1

