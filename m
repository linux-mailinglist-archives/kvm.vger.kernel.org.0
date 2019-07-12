Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0112667115
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 16:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfGLONz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 10:13:55 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:53403 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfGLONz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 10:13:55 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MrQN5-1iIXRL1mzv-00oVFL; Fri, 12 Jul 2019 16:13:24 +0200
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
Subject: [PATCH] [v3] x86: kvm: avoid -Wsometimes-uninitized warning
Date:   Fri, 12 Jul 2019 16:13:09 +0200
Message-Id: <20190712141322.1073650-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:mtFUcYRsvqsqU3QJWJ/dFFjF0Yd9wHzp908nlZK83caY6JGVHPq
 LXymdLgLCegnaDKfu159IL/7oAudJltdZwXMGK63ZUlU+Jfths5bnLOzEW07+2q31Yg0tT6
 1cg0EE/DQ8ump88F0paELKlusq6DBC2eUaOp+T4qfsjCs0IEYgQKtvAVQsTYQPgN5n/2fGp
 epCCJ0s3Sh3bwoaLinvzQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LWYzu/LtLb0=:xHUs4tdQHd3Ct6Bu0svRXv
 PmWzRBS+0m95DYX/F7E+rFe5/XtDhnWQ6Tgs4mINPckQyZ/6MVAUsj0Xa70FI5l4+ppmPC7/x
 giOslqyC74d2r5fkPb6oDzt2fRVBSXCuNrWuX0zVgaJ8lou8DmUMBtpNmk8aVUsNx8yrJSZOY
 Z1tTYNcbvtrD+HQbondlxipmdzbY/YPT41GN1PvvrAPBX/49/8SYq8//DsoC0n2G/R7UKhldk
 0zhoRK/WgQqBNPXo7nMihjnp5CzS2HerKKy+uMmt3IFZvWb6DQGKv+miSTTd3alE0t0t3FaCh
 9iN0q+VNyr8gK1uAyY3DBYcD7Sp+cnr+e+XQqiWZDYKWPpV/IQD8UpNmOE3vytPncDe9MiDdo
 4SJMRG1ZOVUcOoZOqBzR/hGq/qiRfDXfQXYMPfDl72JS2H8TOCL3kNkAj4IXZegf1ObSCy8KT
 ewuqXTfwJLV/Oxv2e7toe2Ge+4yujGs5LgcYjcGsvJiZwjxM1lVDSHqazN5juGS3rMADkCgb5
 m8z4SlBUMsfYz+4h2dNYGw/hywY3xv8nDSoidRF9FwTgnI2uPJSxS2sCOiPARtNXloGKVbItC
 zXlx7ENBiMSKBz4uXbwTiMFAB/v8mVFzK/y06yHdq/L6ki33fBO2mh7j/DF9pXkkZcV4tcd15
 597nbyjIn8WS3XkTo4GeBukcP3LM1eXUqx8Dr5MYxrBfNFwm4we/sFFBTFAItSvXfIpwJcCjQ
 CwHjsApxyYZYx8uOwIvBbUb/Wjm/ii7WpxJIlg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clang notices a code path in which some variables are never
initialized, but fails to figure out that this can never happen
on i386 because is_64_bit_mode() always returns false.

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

Flip the condition around to avoid the conditional execution on i386.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v3: reword commit log, simplify patch again
v2: make the change inside of is_64_bit_mode().
---
 arch/x86/kvm/hyperv.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a39e38f13029..c10a8b10b203 100644
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
@@ -1605,9 +1605,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
-	longmode = is_64_bit_mode(vcpu);
-
-	if (!longmode) {
+#ifdef CONFIG_X86_64
+	if (is_64_bit_mode(vcpu)) {
+		param = kvm_rcx_read(vcpu);
+		ingpa = kvm_rdx_read(vcpu);
+		outgpa = kvm_r8_read(vcpu);
+	} else
+#endif
+	{
 		param = ((u64)kvm_rdx_read(vcpu) << 32) |
 			(kvm_rax_read(vcpu) & 0xffffffff);
 		ingpa = ((u64)kvm_rbx_read(vcpu) << 32) |
@@ -1615,13 +1620,6 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 		outgpa = ((u64)kvm_rdi_read(vcpu) << 32) |
 			(kvm_rsi_read(vcpu) & 0xffffffff);
 	}
-#ifdef CONFIG_X86_64
-	else {
-		param = kvm_rcx_read(vcpu);
-		ingpa = kvm_rdx_read(vcpu);
-		outgpa = kvm_r8_read(vcpu);
-	}
-#endif
 
 	code = param & 0xffff;
 	fast = !!(param & HV_HYPERCALL_FAST_BIT);
-- 
2.20.0

