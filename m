Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EE11C667C
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 05:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgEFDyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 23:54:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:58810 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbgEFDyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 23:54:01 -0400
IronPort-SDR: Ii4BPnUjy6z8kDg9x5kQNoyGAQqpetxcqGgTuhEZRxCJ+rGjwW2dnR1pjJ7obW0HfGR46w2jum
 Ob6u1Fbm4adg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 20:53:56 -0700
IronPort-SDR: RnY/CkTVHGDllTWl3vsALQBX8FyOb9RmSDv/9J4Oj1pJg9ax+A6NZxcyLyU93gQX7ft9fjdsk6
 jV1WhhTCDb9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,357,1583222400"; 
   d="scan'208";a="461286084"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 05 May 2020 20:53:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] KVM: VMX: Explicitly clear RFLAGS.CF and RFLAGS.ZF in VM-Exit RSB path
Date:   Tue,  5 May 2020 20:53:55 -0700
Message-Id: <20200506035355.2242-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clear CF and ZF in the VM-Exit path after doing __FILL_RETURN_BUFFER so
that KVM doesn't interpret clobbered RFLAGS as a VM-Fail.  Filling the
RSB has always clobbered RFLAGS, its current incarnation just happens
clear CF and ZF in the processs.  Relying on the macro to clear CF and
ZF is extremely fragile, e.g. commit 089dd8e53126e ("x86/speculation:
Change FILL_RETURN_BUFFER to work with objtool") tweaks the loop such
that the ZF flag is always set.

Reported-by: Qian Cai <cai@lca.pw>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: stable@vger.kernel.org
Fixes: f2fde6a5bcfcf ("KVM: VMX: Move RSB stuffing to before the first RET after VM-Exit")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmenter.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 87f3f24fef37b..51d1a82742fd5 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -82,6 +82,9 @@ SYM_FUNC_START(vmx_vmexit)
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 
+	/* Clear RFLAGS.CF and RFLAGS.ZF to preserve VM-Exit, i.e. !VM-Fail. */
+	or $1, %_ASM_AX
+
 	pop %_ASM_AX
 .Lvmexit_skip_rsb:
 #endif
-- 
2.26.0

