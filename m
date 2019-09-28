Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF74CC118F
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2019 19:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbfI1RYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Sep 2019 13:24:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728713AbfI1RXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Sep 2019 13:23:25 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6588C30ADBAD;
        Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
Received: from mail (ovpn-125-159.rdu2.redhat.com [10.10.125.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4386B5D9C3;
        Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 06/14] KVM: monolithic: x86: remove __exit section prefix from machine_unsetup
Date:   Sat, 28 Sep 2019 13:23:15 -0400
Message-Id: <20190928172323.14663-7-aarcange@redhat.com>
In-Reply-To: <20190928172323.14663-1-aarcange@redhat.com>
References: <20190928172323.14663-1-aarcange@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Sat, 28 Sep 2019 17:23:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adjusts the section prefixes of some KVM x86 code function because
with the monolithic KVM model the section checker can now do a more
accurate static analysis at build time and it found a potentially
kernel crashing bug. This also allows to build without
CONFIG_SECTION_MISMATCH_WARN_ONLY=n.

The __exit removed from machine_unsetup is because
kvm_arch_hardware_unsetup() is called by kvm_init() which is in the
__init section. It's not allowed to call a function located in the
__exit section and dropped during the kernel link from the __init
section or the kernel will crash if that call is made.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++--
 arch/x86/kvm/svm.c              | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 47eeb92d4b4a..0ae65148e5ed 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1008,7 +1008,7 @@ extern int kvm_x86_hardware_enable(void);
 extern void kvm_x86_hardware_disable(void);
 extern __init int kvm_x86_check_processor_compatibility(void);
 extern __init int kvm_x86_hardware_setup(void);
-extern __exit void kvm_x86_hardware_unsetup(void);
+extern void kvm_x86_hardware_unsetup(void);
 extern bool kvm_x86_cpu_has_accelerated_tpr(void);
 extern bool kvm_x86_has_emulated_msr(int index);
 extern void kvm_x86_cpuid_update(struct kvm_vcpu *vcpu);
@@ -1199,7 +1199,7 @@ struct kvm_x86_ops {
 	void (*hardware_disable)(void);
 	int (*check_processor_compatibility)(void);/* __init */
 	int (*hardware_setup)(void);               /* __init */
-	void (*hardware_unsetup)(void);            /* __exit */
+	void (*hardware_unsetup)(void);
 	bool (*cpu_has_accelerated_tpr)(void);
 	bool (*has_emulated_msr)(int index);
 	void (*cpuid_update)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index aa8c0efdc441..057ba1f8d7b3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1405,7 +1405,7 @@ __init int kvm_x86_hardware_setup(void)
 	return r;
 }
 
-__exit void kvm_x86_hardware_unsetup(void)
+void kvm_x86_hardware_unsetup(void)
 {
 	int cpu;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aad44e62b20a..2ae162eb082e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7645,7 +7645,7 @@ __init int kvm_x86_hardware_setup(void)
 	return r;
 }
 
-__exit void kvm_x86_hardware_unsetup(void)
+void kvm_x86_hardware_unsetup(void)
 {
 	if (nested)
 		nested_vmx_hardware_unsetup();
