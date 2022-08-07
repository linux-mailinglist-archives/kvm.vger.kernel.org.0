Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A12658BD48
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiHGWDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbiHGWCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:50 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E762655A;
        Sun,  7 Aug 2022 15:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909759; x=1691445759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jbq8uk/D09akhy+HohrQaJR0uZ0edCiPIkvWLMuVXSw=;
  b=E+37i8I/3/TS9DplSoF1Gk5CZoziea437pB/y7zKCvBmMfwIP8ZgZpD9
   fnRPDuj7xPB8AdNqjcoK43gz8eWWh/bB86rG0jIJWzPJjiVIueeLzmfKZ
   MJlFnkYU5Hf3uvk/4pMxfpDHnLS+g7eqZi7DBqOlLcV3TgsfX2UdKvHVH
   ZK4asalN5MKTetB8B0XhkwwojYpyr2IP2SNXQn5hWB0QkapiJb58MX8zw
   tBgHapZdya5yeJl07ARrFrweUCh5vAWHg0sQDnIkliO8B6noqvTUIX/XU
   n1YwiP8f2HoNmtyl4h9EYI64j5DcQSFbKYk4b5C+U7oz7gAqr2Wnw6G0c
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="291695689"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="291695689"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:37 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682609"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:36 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 051/103] KVM: TDX: don't request KVM_REQ_APIC_PAGE_RELOAD
Date:   Sun,  7 Aug 2022 15:01:36 -0700
Message-Id: <ae52ed8626c8c3c8802030e7b366015d8efc49f5.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX doesn't need APIC page depending on vapic and its callback is
WARN_ON_ONCE(is_tdx).  To avoid unnecessary overhead and WARN_ON_ONCE(),
skip requesting KVM_REQ_APIC_PAGE_RELOAD when TD.

  WARNING: arch/x86/kvm/vmx/main.c:696 vt_set_apic_access_page_addr+0x3c/0x50 [kvm_intel]
  RIP: 0010:vt_set_apic_access_page_addr+0x3c/0x50 [kvm_intel]
  Call Trace:
   vcpu_enter_guest+0x145d/0x24d0 [kvm]
   kvm_arch_vcpu_ioctl_run+0x25d/0xcc0 [kvm]
   kvm_vcpu_ioctl+0x414/0xa30 [kvm]
   __x64_sys_ioctl+0xc0/0x100
   do_syscall_64+0x39/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 577f426ceb14..b126e407944f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10224,7 +10224,9 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 	 * Update it when it becomes invalid.
 	 */
 	apic_address = gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (start <= apic_address && apic_address < end)
+	/* TDX doesn't need APIC page. */
+	if (kvm->arch.vm_type != KVM_X86_TDX_VM &&
+	    start <= apic_address && apic_address < end)
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 }
 
-- 
2.25.1

