Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6522B669B6
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 11:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfGLJNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 05:13:10 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:41875 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfGLJNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 05:13:10 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MeC1p-1iN7Ik04EJ-00bKOj; Fri, 12 Jul 2019 11:12:41 +0200
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
Subject: [PATCH 1/2] x86: kvm: avoid -Wsometimes-uninitized warning
Date:   Fri, 12 Jul 2019 11:12:29 +0200
Message-Id: <20190712091239.716978-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:jwYhgxUv0AqFLNDzVo6wysNnAi/KwXb/EoxoA0pMMuPkZD7WvpX
 SiHy+yF55QFjTCdbtQYSYvGz7fCvrCkf5Fglh7UrM2Z3T2fIMOrK+VxQNEOcar71gln41fT
 a0AcjmpKU0FFi9U/1kw9UuN38z7vudvXTKSFI3gNcKAgm+zdndz7cmKTmis62iY8kPINghL
 4jYB2F14QzSagGXw2O43w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4ze24aU6tjo=:rBuxHH89tgwq6563QiEIei
 cCbeMAuQXh3Rwudc8KuL66S7hExosHEdrkySheaJ17Aci6pm/ZmFiUvPKU1BPWzPC6wC+ioX9
 IAXHwOeqyJDFDaYWV53jAY7VJyt8QjaypiCMNHmWRL9S6qzYChL7f3dCrMqC+xZelZqkyfp14
 OPPvsOc1fc+0faGqCLqW54UBOFCMwYnKAavVDradaOw4DFfOycQ+/65LZ1PNVYBqje7LHK06X
 cbKpQUbLbCfkf+aWzup4lByTxUAJj/TbjozE/14E2HLKOOSNQZBE4feW75lm0NlnUJxM2JHVM
 F/nV45kAUtzl9/SYBlAzUzV5mTzE52Fu0LHd78H1ROC0E4vh3QI8qEOYXQYpihzvhtBPPitzU
 wwu8hRCQJK8/FJGUx9cy3SxvsUnH7VSpJqYcNuDacWEdZWv6ZrDirg/AWMCH0JtyP7YXxgzt9
 7jrlp6MOdemmD04ZNheEf9H+4QPtUM4ECEad9l4T2V0Gc5CzTdRmkcP2E/5FXdnIOuPHGJeVC
 18j/526Pngxu9IQqbzxMezvzP/ggjjwSA0KTSGhbLMnE56jpOMqNlaWd9cOGkaG6EvinfZIaJ
 +YiErd93+F99VFS+lIgAasBSEnNv/7BnT+LqDWBJts49RKcKV2oSqkl2N4S1lPtg5666ZYbPN
 e7R+iFYo9Gn5GdxqFw+Oql+rudlOgmMZVMZAjmsvnYFy1+i/M+drc2OeEH/f0W8sGE2Hmv6b/
 h3IlW5CBYeVHpAYxHR6aqQechRU/sgPtsCq4xw==
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
 arch/x86/kvm/hyperv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a39e38f13029..950436c502ba 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1607,7 +1607,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 
 	longmode = is_64_bit_mode(vcpu);
 
-	if (!longmode) {
+	if (!IS_ENABLED(CONFIG_X86_64) || !longmode) {
 		param = ((u64)kvm_rdx_read(vcpu) << 32) |
 			(kvm_rax_read(vcpu) & 0xffffffff);
 		ingpa = ((u64)kvm_rbx_read(vcpu) << 32) |
-- 
2.20.0

