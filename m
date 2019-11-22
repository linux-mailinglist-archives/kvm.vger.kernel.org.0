Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B61107AB3
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKVWkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:61229 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbfKVWkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029696"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:04 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] KVM: x86: Shrink the usercopy region of the emulation context
Date:   Fri, 22 Nov 2019 14:39:56 -0800
Message-Id: <20191122223959.13545-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Shuffle a few operand structs to the end of struct x86_emulate_ctxt and
update the cache creation to whitelist only the region of the emulation
context that is expected to be copied to/from user memory, e.g. the
instruction operands, registers, and fetch/io/mem caches.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/kvm_emulate.h |  8 +++++---
 arch/x86/kvm/x86.c         | 12 ++++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 844e833609db..c25133080666 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -318,9 +318,6 @@ struct x86_emulate_ctxt {
 	u8 intercept;
 	u8 op_bytes;
 	u8 ad_bytes;
-	struct operand src;
-	struct operand src2;
-	struct operand dst;
 	int (*execute)(struct x86_emulate_ctxt *ctxt);
 	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
 	/*
@@ -345,6 +342,11 @@ struct x86_emulate_ctxt {
 	u8 seg_override;
 	u64 d;
 	unsigned long _eip;
+
+	/* Here begins the usercopy section. */
+	struct operand src;
+	struct operand src2;
+	struct operand dst;
 	struct operand memop;
 	/* Fields above regs are cleared together. */
 	unsigned long _regs[NR_VCPU_REGS];
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 548cf3b659f5..418717876ad0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -231,13 +231,13 @@ static struct kmem_cache *x86_emulator_cache;
 
 static struct kmem_cache *kvm_alloc_emulator_cache(void)
 {
-	return kmem_cache_create_usercopy("x86_emulator",
-					  sizeof(struct x86_emulate_ctxt),
+	unsigned int useroffset = offsetof(struct x86_emulate_ctxt, src);
+	unsigned int size = sizeof(struct x86_emulate_ctxt);
+
+	return kmem_cache_create_usercopy("x86_emulator", size,
 					  __alignof__(struct x86_emulate_ctxt),
-					  SLAB_ACCOUNT,
-					  0,
-					  sizeof(struct x86_emulate_ctxt),
-					  NULL);
+					  SLAB_ACCOUNT, useroffset,
+					  size - useroffset, NULL);
 }
 
 static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);
-- 
2.24.0

