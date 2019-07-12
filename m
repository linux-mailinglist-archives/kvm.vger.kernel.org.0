Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177A067023
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 15:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfGLNeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 09:34:02 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:50129 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfGLNeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 09:34:02 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MpDRv-1iGMCu2szn-00qhJj; Fri, 12 Jul 2019 15:33:27 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Liran Alon <liran.alon@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] [v2] x86: kvm: avoid -Wsometimes-uninitized warning
Date:   Fri, 12 Jul 2019 15:32:43 +0200
Message-Id: <20190712133324.3934659-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:4qTu/galH0LnG6yIR0OsYJ+dLomxq+0RlUIYdobv6pAum7R6QII
 6hLy/bGPMpMuK+mmmqzXvq7HNXuiT1FW4FKRYfRUWFuTN2uRcXWjljXFfY3wB6qXXtc39Z+
 cFmMhICSMc1GEfVw/mE2lEdf0oYg9QgajoZnAz93joMZLV1G6wQgHG79nmTmXKqAIsgu/2a
 TyedC/s/hsXJGXbQgX4MQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KxZJQApMqxA=:hJewgg17Kss7epoF/82dC1
 yuqf5BudQv16UzWu2NWNWkAvlqIUi3mwy6eqYQ+3t0UDAU0KbSu78bRvCkwAUGVF9Zs5ccQZ0
 r8eZG89bdLGxUdHIi+u00KuV5cxyQGFtbf6rByn2MI/I9WbPIhvRxvo2n5Is3vbp1uuHd5syf
 UJC5EO2nXalrmHqdJ+kNVFdiqKX6Ju6iAKUN+wgfXjKV7NWgbFVNfWEL6DEIvYX0kmg3zsZh0
 NDjFZElAQ6PIKaxDszWDZfyG8DJElTsqIO9+djhlUMw+Lrfy1nr3msBXs2bRWjvRD8aLAnxzk
 5JjpY3xRiS8s8XqwII3McCFpBVNwJQWRaE+v2I9+HeT7xwlkzQVvBw1m7iZLD5g9kUjVvjDGS
 261YSqmlEtZ4AsQhJhkAb+eTTXAjiGAtNNrafW/f1ZnJXCnCVDuecoQAL4GAUfbI7pIxI9oo2
 p/Hm3TnWRgJjbHNhb52Fh0M978QFC35YCeHKj1IkPUBIZhKqzm5ayywi74AYLA209SAulYmBJ
 dohugrtJPQxWUgJ/2uj81F3RXWUm/oty3b/9j4nlmTJCke4HtDymGIdEUmhim6qxBg9oS0JE2
 N+d59SWF7R8Z+W+IdPXhd5p3t9FZqBSMHlLQ8VgItMp9aaa5RXrP3eVb41hidG4suxeIKD656
 JgNKEMeuq5lDH52herWOQlfOLZQWmTor396875Gv4JftjH1x2QfcIZNwKDUH+ZuX0smde/DNJ
 r9/m/8QYXxGzZVFkoKD0qx2ZN034bzctxGLVaA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clang points out that running a 64-bit guest on a 32-bit host
would lead to uninitialized variables:

arch/x86/kvm/hyperv.c:1610:6: error: variable 'ingpa' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        if (!longmode) {
            ^~~~~~~~~
arch/x86/kvm/hyperv.c:1632:55: note: uninitialized use occurs here
        trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgpa);
                                                             ^~~~~
arch/x86/kvm/hyperv.c:1610:2: note: remove the 'if' if its condition is always true
        if (!longmode) {
        ^~~~~~~~~~~~~~~
arch/x86/kvm/hyperv.c:1595:18: note: initialize the variable 'ingpa' to silence this warning
        u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
                        ^
                         = 0
arch/x86/kvm/hyperv.c:1610:6: error: variable 'outgpa' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
arch/x86/kvm/hyperv.c:1610:6: error: variable 'param' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]

Since that combination is not supported anyway, change the condition
to tell the compiler how the code is actually executed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: make the change inside of is_64_bit_mode().
---
 arch/x86/kvm/hyperv.c | 6 ++----
 arch/x86/kvm/x86.h    | 4 ++++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a39e38f13029..4c1c423a3d08 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1594,7 +1594,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 {
 	u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
 	uint16_t code, rep_idx, rep_cnt;
-	bool fast, longmode, rep;
+	bool fast, rep;
 
 	/*
 	 * hypercall generates UD from non zero cpl and real mode
@@ -1605,9 +1605,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
-	longmode = is_64_bit_mode(vcpu);
-
-	if (!longmode) {
+	if (!is_64_bit_mode(vcpu)) {
 		param = ((u64)kvm_rdx_read(vcpu) << 32) |
 			(kvm_rax_read(vcpu) & 0xffffffff);
 		ingpa = ((u64)kvm_rbx_read(vcpu) << 32) |
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e08a12892e8b..b457b3267296 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -90,6 +90,7 @@ static inline int is_long_mode(struct kvm_vcpu *vcpu)
 #endif
 }
 
+#ifdef CONFIG_X86_64
 static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
 {
 	int cs_db, cs_l;
@@ -99,6 +100,9 @@ static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
 	return cs_l;
 }
+#else
+#define is_64_bit_mode(vcpu) false
+#endif
 
 static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
 {
-- 
2.20.0

