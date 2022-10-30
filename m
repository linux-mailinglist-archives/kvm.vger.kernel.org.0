Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4501C612805
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiJ3G0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiJ3GZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:25:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F7B1DD;
        Sat, 29 Oct 2022 23:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111053; x=1698647053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=elmKS02WiygU5IrlA++TZV5oI8cDn28t+pY/4QpTrh0=;
  b=PTtuyg9CnidcTcQ70FemTdfk9KIJyp1nl+N8JoRCWwgWMjH6Aif+pY8x
   axuIwHsPh0q1UaFnkpwqVGl/wbaMVvzEUoAD6bgdQM4yE8gIc0YyiVXPD
   HCS6SUnkF/bC4p0xscUYSPCX7h7IBrPshxJ+uEQ7TLAInksCkJaRKDHgN
   WBWdlIdhAZ4SZMMwndjGdEigum6Xlyv9xIHVFAPmrW7keZcgRaCgg4Iiy
   JN077KBuuXFqxm7rfqubZIUtWo6QhPiTTV4t/6bnsz+jiBhRljdii/RM9
   YufRrkZLGwmk6ok7Zuuu9owDXU5jnLHnq2A7w7IHMab5vuGjkVm55hL63
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037169"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037169"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:06 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393027"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393027"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:06 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 056/108] KVM: TDX: don't request KVM_REQ_APIC_PAGE_RELOAD
Date:   Sat, 29 Oct 2022 23:22:57 -0700
Message-Id: <f0f134dcf59f901e4b8960c7b3f242dcd42b1c40.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 3868605462ed..5dadd0f9a10e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10487,7 +10487,9 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
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

