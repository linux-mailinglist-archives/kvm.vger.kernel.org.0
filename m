Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C461F7ADD45
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 18:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjIYQhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 12:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjIYQhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 12:37:01 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F343BE;
        Mon, 25 Sep 2023 09:36:53 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1qkoZi-0000e3-OE; Mon, 25 Sep 2023 18:36:46 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Ignore MSR_AMD64_BU_CFG access
Date:   Mon, 25 Sep 2023 18:36:40 +0200
Message-ID: <0ffde769702c6cdf6b6c18e1dcb28b25309af7f7.1695659717.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Hyper-V enabled Windows Server 2022 KVM VM cannot be started on Zen1 Ryzen
since it crashes at boot with SYSTEM_THREAD_EXCEPTION_NOT_HANDLED +
STATUS_PRIVILEGED_INSTRUCTION (in other words, because of an unexpected #GP
in the guest kernel).

This is because Windows tries to set bit 8 in MSR_AMD64_BU_CFG and can't
handle receiving a #GP when doing so.

Give this MSR the same treatment that commit 2e32b7190641
("x86, kvm: Add MSR_AMD64_BU_CFG2 to the list of ignored MSRs") gave
MSR_AMD64_BU_CFG2 under justification that this MSR is baremetal-relevant
only.
Although apparently it was then needed for Linux guests, not Windows as in
this case.

With this change, the aforementioned guest setup is able to finish booting
successfully.

This issue can be reproduced either on a Summit Ridge Ryzen (with
just "-cpu host") or on a Naples EPYC (with "-cpu host,stepping=1" since
EPYC is ordinarily stepping 2).

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 arch/x86/kvm/x86.c               | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d111350197f..c80a5cea80c4 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -553,6 +553,7 @@
 #define MSR_AMD64_CPUID_FN_1		0xc0011004
 #define MSR_AMD64_LS_CFG		0xc0011020
 #define MSR_AMD64_DC_CFG		0xc0011022
+#define MSR_AMD64_BU_CFG		0xc0011023
 
 #define MSR_AMD64_DE_CFG		0xc0011029
 #define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT	 1
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..2f3cdd798185 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3639,6 +3639,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_UCODE_WRITE:
 	case MSR_VM_HSAVE_PA:
 	case MSR_AMD64_PATCH_LOADER:
+	case MSR_AMD64_BU_CFG:
 	case MSR_AMD64_BU_CFG2:
 	case MSR_AMD64_DC_CFG:
 	case MSR_F15H_EX_CFG:
@@ -4062,6 +4063,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_K8_INT_PENDING_MSG:
 	case MSR_AMD64_NB_CFG:
 	case MSR_FAM10H_MMIO_CONF_BASE:
+	case MSR_AMD64_BU_CFG:
 	case MSR_AMD64_BU_CFG2:
 	case MSR_IA32_PERF_CTL:
 	case MSR_AMD64_DC_CFG:
