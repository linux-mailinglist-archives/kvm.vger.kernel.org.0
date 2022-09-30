Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2A45F08C7
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiI3KWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiI3KUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:20:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B661F8C05;
        Fri, 30 Sep 2022 03:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533153; x=1696069153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Igv22U9RXdZA7/q9wQNPPWJH+RI/ZzPv1pGdYvbYSTE=;
  b=jfs3mbF6cR+v8nMo9tE9pBhRJ7zPIDtnAI/4JEdlRAk7Ha31ki00opY2
   wVguD0wgLcdIAmKcsCc32yXth2LrLAGrGoowfM8hyIhXgYc+eOzQ1LF0V
   xTX//ye5k4Q9B0h07G+0AaoHca4wFP+nsQfqqL27/q/Ot4tG5OqaWXem/
   IWg9gywznl3CItMnwp6Osgm3V3CjapEmzsF8ZLHKvVuo8nohWJP58BOGk
   fWE5byIzQZorrwgpGIDASU+QKkRp4MHadkGutuTOFzMSUIqz8Amd/P9d8
   RyKjjWzrBskxvCHL8ldculFXXX0yfVG7Eeas/NpVmxhtjHCWQFsYV8tPw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870114"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870114"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:00 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807675"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807675"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:00 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 053/105] KVM: TDX: don't request KVM_REQ_APIC_PAGE_RELOAD
Date:   Fri, 30 Sep 2022 03:17:47 -0700
Message-Id: <6160295eb8f008fe5cd123f60c40a0dbf3ea9ecb.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 9060ca2b19ee..f6f0a4b56263 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10248,7 +10248,9 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
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

