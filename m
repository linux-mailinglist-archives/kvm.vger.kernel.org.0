Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDB72335CD
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 17:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgG3Pnu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 11:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728286AbgG3Pns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 11:43:48 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31982C061575;
        Thu, 30 Jul 2020 08:43:48 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id A2B939B5; Thu, 30 Jul 2020 17:43:44 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH v2 2/4] KVM: SVM: Add GHCB definitions
Date:   Thu, 30 Jul 2020 17:43:38 +0200
Message-Id: <20200730154340.14021-3-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730154340.14021-1-joro@8bytes.org>
References: <20200730154340.14021-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Extend the vmcb_safe_area with SEV-ES fields and add a new
'struct ghcb' which will be used for guest-hypervisor communication.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/svm.h | 45 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c     |  2 ++
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 8a1f5382a4ea..9a3e0b802716 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -200,13 +200,56 @@ struct __attribute__ ((__packed__)) vmcb_save_area {
 	u64 br_to;
 	u64 last_excp_from;
 	u64 last_excp_to;
+
+	/*
+	 * The following part of the save area is valid only for
+	 * SEV-ES guests when referenced through the GHCB.
+	 */
+	u8 reserved_7[104];
+	u64 reserved_8;		/* rax already available at 0x01f8 */
+	u64 rcx;
+	u64 rdx;
+	u64 rbx;
+	u64 reserved_9;		/* rsp already available at 0x01d8 */
+	u64 rbp;
+	u64 rsi;
+	u64 rdi;
+	u64 r8;
+	u64 r9;
+	u64 r10;
+	u64 r11;
+	u64 r12;
+	u64 r13;
+	u64 r14;
+	u64 r15;
+	u8 reserved_10[16];
+	u64 sw_exit_code;
+	u64 sw_exit_info_1;
+	u64 sw_exit_info_2;
+	u64 sw_scratch;
+	u8 reserved_11[56];
+	u64 xcr0;
+	u8 valid_bitmap[16];
+	u64 x87_state_gpa;
+};
+
+struct __attribute__ ((__packed__)) ghcb {
+	struct vmcb_save_area save;
+	u8 reserved_save[2048 - sizeof(struct vmcb_save_area)];
+
+	u8 shared_buffer[2032];
+
+	u8 reserved_1[10];
+	u16 protocol_version;	/* negotiated SEV-ES/GHCB protocol version */
+	u32 ghcb_usage;
 };
 
 
 static inline void __unused_size_checks(void)
 {
-	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != 0x298);
+	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != 1032);
 	BUILD_BUG_ON(sizeof(struct vmcb_control_area) != 256);
+	BUILD_BUG_ON(sizeof(struct ghcb) != 4096);
 }
 
 struct __attribute__ ((__packed__)) vmcb {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 783330d0e7b8..953cf947f022 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4161,6 +4161,8 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 
 static int __init svm_init(void)
 {
+	__unused_size_checks();
+
 	return kvm_init(&svm_init_ops, sizeof(struct vcpu_svm),
 			__alignof__(struct vcpu_svm), THIS_MODULE);
 }
-- 
2.17.1

