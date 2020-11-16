Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3F12B4F9D
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388097AbgKPS2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:06 -0500
Received: from mga06.intel.com ([134.134.136.31]:20632 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388086AbgKPS2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:04 -0500
IronPort-SDR: +JsGjOS9Qt2iT8fBSSW0DBTECaxYSi2JPoak/1nKUGvpnAqCkIQfLHamzv15e0IF2R5PWIfXtG
 JxDnjdTKzRBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410031"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410031"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:03 -0800
IronPort-SDR: kmdBeUL4mdS0+jujBwt2ADTN0JowZGlBjbiaErA3r/ls19CNWuswZNlgUfjAmq523RLBg4SlcU
 1EbibhERw4fg==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527986"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:02 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 23/67] KVM: Add per-VM flag to disable dirty logging of memslots for TDs
Date:   Mon, 16 Nov 2020 10:26:08 -0800
Message-Id: <b8c847e84fd298abb25047b305ee76be13bea1b0.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a flag for TDX to mark dirty logging as unsupported.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 include/linux/kvm_host.h | 1 +
 virt/kvm/kvm_main.c      | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1a0df7b83fd0..9682282cb258 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -517,6 +517,7 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 
+	bool dirty_log_unsupported;
 #ifdef __KVM_HAVE_READONLY_MEM
 	bool readonly_mem_unsupported;
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 572a66a61c29..aa5f27753756 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1103,7 +1103,10 @@ static void update_memslots(struct kvm_memslots *slots,
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region *mem)
 {
-	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
+	u32 valid_flags = 0;
+
+	if (!kvm->dirty_log_unsupported)
+		valid_flags |= KVM_MEM_LOG_DIRTY_PAGES;
 
 #ifdef __KVM_HAVE_READONLY_MEM
 	if (!kvm->readonly_mem_unsupported)
-- 
2.17.1

