Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8C41509B5
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 16:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgBCPV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 10:21:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:32939 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728548AbgBCPVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 10:21:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 07:21:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="429473368"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by fmsmga005.fm.intel.com with ESMTP; 03 Feb 2020 07:21:21 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Laight <David.Laight@aculab.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 3/6] kvm: x86: Emulate split-lock access as a write
Date:   Mon,  3 Feb 2020 23:16:05 +0800
Message-Id: <20200203151608.28053-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200203151608.28053-1-xiaoyao.li@intel.com>
References: <20200203151608.28053-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If split lock detect is enabled (warn/fatal), #AC handler calls die()
when split lock happens in kernel.

A sane guest should never tigger emulation on a split-lock access, but
it cannot prevent malicous guest from doing this. So just emulating the
access as a write if it's a split-lock access to avoid malicous guest
polluting the kernel log.

More detail analysis can be found:
https://lkml.kernel.org/r/20200131200134.GD18946@linux.intel.com

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d3be7f3ad67..821b7404c0fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5847,6 +5847,13 @@ static int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
 	(cmpxchg64((u64 *)(ptr), *(u64 *)(old), *(u64 *)(new)) == *(u64 *)(old))
 #endif
 
+static inline bool across_cache_line_access(gpa_t gpa, unsigned int bytes)
+{
+	unsigned int cache_line_size = cache_line_size();
+
+	return (gpa & (cache_line_size - 1)) + bytes > cache_line_size;
+}
+
 static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 				     unsigned long addr,
 				     const void *old,
@@ -5873,6 +5880,10 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (((gpa + bytes - 1) & PAGE_MASK) != (gpa & PAGE_MASK))
 		goto emul_write;
 
+	if (get_split_lock_detect_state() != sld_off &&
+	    across_cache_line_access(gpa, bytes))
+		goto emul_write;
+
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(gpa), &map))
 		goto emul_write;
 
-- 
2.23.0

