Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD1077D0C6
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbjHORTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238026AbjHORTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:19:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F014D1BC7;
        Tue, 15 Aug 2023 10:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692119951; x=1723655951;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uyYQyYO29xSOQittSYVaOb6LhfmfeTlwG0zG2837vUA=;
  b=iYiBJRdV2O2/WAkHCzpCkiE7O5v00iD8UAjUD/ZVSjijNLoXEG+mq+IT
   ljaS/BbN7fWeCxn6Hw84t6Y/NAFcYQ5ryt7xBokzE7LwxWfynU0clLfZL
   sQEH0J3LbDEhhhWQFHylZD9eySpZYrTtljLAkm6hQhQAotqilE0v7u9cf
   g3YSrd8mjfOAGgy/E/1mh0DqTXqWwbfYQJxIWW5qILdwyce0p5CDhP6xY
   IUAKzrUl0GYtvvYMARayZb4BlLiqsfWrbfxfu3goJ/IDhpCN4kJR6BE4k
   262q2vUz+HSQ2DwwVs4rN8fOL5ae0WM2AOPE04k7ZEpbnnGdQnFPoI2FM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="362488580"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="362488580"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="848148964"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="848148964"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:03 -0700
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
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Subject: [PATCH 0/8] KVM: gmem: Adding hooks for SEV and TDX
Date:   Tue, 15 Aug 2023 10:18:47 -0700
Message-Id: <cover.1692119201.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This patch series for KVM guest memfd is to have common code base for SEV and
TDX.  Several minor fixes.  Based on this patch series, TDX KVM can defer page
clearing without mmu lock.

Isaku Yamahata (6):
  KVM: gmem: Make kvm_gmem_bind return EBADF on wrong fd
  KVM: gmem: removed duplicated kvm_gmem_init()
  KVM: gmem: Fix kvm_gmem_issue_arch_invalidate()
  KVM: gmem: protect kvm_mmu_invalidate_end()
  KVM: gmem: Avoid race with kvm_gmem_release and mmu notifier
  RFC: KVM: gmem: Guarantee the order of destruction

Michael Roth (2):
  KVM: gmem, x86: Add gmem hook for initializing private memory
  KVM: gmem, x86: Add gmem hook for invalidating private memory

 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    |  4 +++
 arch/x86/kvm/mmu/mmu.c             | 12 ++++++--
 arch/x86/kvm/x86.c                 |  6 ++++
 include/linux/kvm_host.h           | 27 ++++++++++++++++++
 virt/kvm/guest_mem.c               | 46 ++++++++++++++++++++++++++++--
 virt/kvm/kvm_main.c                | 46 ++++++++++++++++++++++++++++--
 7 files changed, 136 insertions(+), 7 deletions(-)


base-commit: 89b6a7b873d72280e85976bbb8fe4998b2ababa8
-- 
2.25.1

