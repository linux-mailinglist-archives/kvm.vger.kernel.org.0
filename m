Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04226D467D
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjDCOGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbjDCOGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:06:25 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2AB1BF62;
        Mon,  3 Apr 2023 07:05:58 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id f22so23983079plr.0;
        Mon, 03 Apr 2023 07:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680530752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZbI1OT962diLBE3c0UKswFvsxJYd8uxPutPjIi22EM=;
        b=gg73Vut+GV0UcPC6llRZsuyu5Jd6lVMMWidXcUhKCQkTFDjmB1I3CR7L7cv6npN6Bz
         TDGmMpIIwWIeRYqDPMTQmAMQ5eEmAODmuwuBWc2H1LVF9LKq9CrqC9+vIiljdTr8WwPu
         NiZPBDIyWqaGOujmiCVzwSviTwPZeWb7FPcC+Hz3Wwmo3qhQ8wM8gu7RH0bviObqDuiq
         0QoPQY1n73HM0oeDY9MlPIoumL7cTzZaWhdL0G5xHUXb1YXridFYBw+mSr7sC0X/01ng
         mvEP25mCX2fZR5qaR31SbLNAvEzicYlYxwRrf/4i5EoATXWtRrwq5I0q/dwRbf77bsEY
         hXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680530752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZbI1OT962diLBE3c0UKswFvsxJYd8uxPutPjIi22EM=;
        b=4pIhEUqjREUMtdAm2bu8lD0WXesF5mgW+NeA/+0HNUQWOpnF3QWDjP3eRW+qtY+g7M
         N8x80mNL5ZlAI5nmOAjAolDg9SF0kJ93FHRbd2WE/wCR4RuQvUHtc9RukwfFUqIRf4FX
         r7inn27+uC+2IGmbW0BWR+g+J0NsJYlvvB0orx+pHYbm0oBxjITkQRr9vOKN3YEgEiW4
         sJqPOA1+wszraxvkqN0mkELFEeAMwFzc8ehEbZSVuQEqPHCNAccxT6qJzZwOQ31/Jsay
         cU75hLxYwgNlGZlS6xcJd+iuqKkHgJ8lQIZNNWAg7ttoyZlMzUOGF49s7IDUqviuKWsQ
         nmAQ==
X-Gm-Message-State: AAQBX9ckv9+bgcUd8HrnRZkZqZIStr5CjjWvyj37sSGBd2QvvH+WBbjo
        CLKPq5ML/W4mS6TwGDY+RBnzz3J9K+Q=
X-Google-Smtp-Source: AKy350Z/M0G8DWcTbUz/MvEQPhAv0qICDkbBQNISY7ldpM63qmWEClM91zpv9zVNXlFsI5nLUkvEfQ==
X-Received: by 2002:a17:90a:1de:b0:234:b964:5703 with SMTP id 30-20020a17090a01de00b00234b9645703mr39198970pjd.18.1680530751086;
        Mon, 03 Apr 2023 07:05:51 -0700 (PDT)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902788900b001990028c0c9sm6626551pll.68.2023.04.03.07.05.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Apr 2023 07:05:50 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 7/7] x86/entry: Test atomic-IST-entry via KVM
Date:   Mon,  3 Apr 2023 22:06:05 +0800
Message-Id: <20230403140605.540512-8-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230403140605.540512-1-jiangshanlai@gmail.com>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Not for inclusion.
It is not part of the atomic-IST-entry patch.

Test it with a VM with only one vCPU.
Lauch the VM with the uncompressed vmlinux.

The test injects super exceptions (MCE NMI DB) randomly.

The test make the ratio of the occurence of nested exceptions
(different vectors) higher.

The test reables the nested of the same vector very hurry.
When the cpu reaches a commit_ip, all the events are reabled.

usage:

parameters="$parameters exc_nmi_handler=0x$(readelf -W -s vmlinux | awk '/ exc_nmi$/ { print $2}')"
parameters="$parameters asm_exc_nmi_handler=0x$(readelf -W -s vmlinux | awk '/ asm_exc_nmi$/ { print $2}')"
parameters="$parameters asm_exc_db_handler=0x$(readelf -W -s vmlinux | awk '/ asm_exc_debug$/ { print $2}')"
parameters="$parameters asm_exc_mce_handler=0x$(readelf -W -s vmlinux | awk '/ asm_exc_machine_check$/ { print $2}')"
parameters="$parameters exc_db_kernel_handler=0x$(readelf -W -s vmlinux | awk '/ exc_debug$/ { print $2}')"
parameters="$parameters exc_db_user_handler=0x$(readelf -W -s vmlinux | awk '/ noist_exc_debug$/ { print $2}')"
parameters="$parameters exc_mce_kernel_handler=0x$(readelf -W -s vmlinux | awk '/ exc_machine_check$/ { print $2}')"
parameters="$parameters exc_mce_user_handler=0x$(readelf -W -s vmlinux | awk '/ noist_exc_machine_check$/ { print $2}')"
parameters="$parameters asm_exc_nmi_commit_ip=0x$(readelf -W -s vmlinux | awk '/ commit_asm_exc_nmi$/ { print $2}')"
parameters="$parameters asm_exc_db_commit_ip=0x$(readelf -W -s vmlinux | awk '/ commit_asm_exc_debug$/ { print $2}')"
parameters="$parameters asm_exc_mce_commit_ip=0x$(readelf -W -s vmlinux | awk '/ commit_asm_exc_machine_check$/ { print $2}')"
parameters="$parameters native_irq_return_iret_ip=0x$(readelf -W -s vmlinux | awk '/ native_irq_return_iret$/ { print $2}')"
parameters="$parameters ist_emul_test=1"

insmod arch/x86/kvm/kvm.ko
insmod arch/x86/kvm/kvm-intel.ko $parameters

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/vmx/vmx.c | 441 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c     |  10 +-
 2 files changed, 447 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bcac3efcde41..6f0d574a137a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1252,6 +1252,441 @@ void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
 	}
 }
 
+#include <linux/prandom.h>
+
+// readelf -W -s vmlinux | awk '/ asm_exc_double_fault$/ { print $2}'
+static unsigned long asm_exc_df_handler;
+module_param(asm_exc_df_handler, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ asm_exc_nmi$/ { print $2}'
+static unsigned long asm_exc_nmi_handler;
+module_param(asm_exc_nmi_handler, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ asm_exc_debug$/ { print $2}'
+static unsigned long asm_exc_db_handler;
+module_param(asm_exc_db_handler, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ asm_exc_machine_check$/ { print $2}'
+static unsigned long asm_exc_mce_handler;
+module_param(asm_exc_mce_handler, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ exc_nmi$/ { print $2}'
+static unsigned long exc_nmi_handler;
+module_param(exc_nmi_handler, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ exc_debug$/ { print $2}'
+static unsigned long exc_db_kernel_handler;
+module_param(exc_db_kernel_handler, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ noist_exc_debug$/ { print $2}'
+static unsigned long exc_db_user_handler;
+module_param(exc_db_user_handler, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ exc_machine_check$/ { print $2}'
+static unsigned long exc_mce_kernel_handler;
+module_param(exc_mce_kernel_handler, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ noist_exc_machine_check$/ { print $2}'
+static unsigned long exc_mce_user_handler;
+module_param(exc_mce_user_handler, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ commit_asm_exc_nmi$/ { print $2}'
+static unsigned long asm_exc_nmi_commit_ip;
+module_param(asm_exc_nmi_commit_ip, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ commit_asm_exc_debug$/ { print $2}'
+static unsigned long asm_exc_db_commit_ip;
+module_param(asm_exc_db_commit_ip, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ commit_asm_exc_machine_check$/ { print $2}'
+static unsigned long asm_exc_mce_commit_ip;
+module_param(asm_exc_mce_commit_ip, ulong, S_IRUGO);
+
+// readelf -W -s vmlinux | awk '/ native_irq_return_iret$/ { print $2}'
+static unsigned long native_irq_return_iret_ip;
+module_param(native_irq_return_iret_ip, ulong, S_IRUGO);
+
+#define MAX_NESTING 50
+#define IST_START_RATE 512 /* rate of queuing an IST per vm-exit if no IST queued */
+#define IST_NESTED_RATE 256 /* rate of nesting an IST per instruction during handling IST */
+
+static int instruction_count;
+static int ist_depth, ist_atomic_depth;
+static int ist_nmi_blocking, ist_db_blocking, ist_mce_blocking;
+static u8 pending_vector[MAX_NESTING];
+static unsigned long ist_interrupted_rip[MAX_NESTING];
+static unsigned long commit_ip;
+
+#define TEST_STOPPED 0
+#define TEST_REQUESTED 1
+#define TEST_ONGOING 2
+static int ist_emul_test = TEST_STOPPED;
+// set ist_emul_test = 1 (TEST_REQUESTED) when loading the module to enable the test
+// in a script which also sets all the above symbol addresses
+module_param(ist_emul_test, int, S_IRUGO);
+
+static bool test_too_early_nesting_bug;
+module_param(test_too_early_nesting_bug, bool, S_IRUGO);
+
+extern int ist_emul_test_singlestep;
+
+static bool ist_emul_injecting;
+static bool ist_emul_returning;
+
+static void print_pending_vectors(void)
+{
+	int i;
+
+	pr_cont("current vectors:");
+	for (i = 0; i < ist_depth; i++) {
+		switch (pending_vector[i]) {
+		case MC_VECTOR: pr_cont(" #MC"); break;
+		case DB_VECTOR: pr_cont(" #DB"); break;
+		case 2: pr_cont(" NMI"); break;
+		default: WARN_ON(1);
+		}
+	}
+	pr_cont(";\n");
+}
+
+#define DR7_EN(i, type, len) (((type | len) & 0xf) << (DR_CONTROL_SHIFT + i * DR_CONTROL_SIZE)) |\
+		 (DR_GLOBAL_ENABLE << (i * DR_ENABLE_SIZE))
+
+#define DR7_X(i) DR7_EN(i, X86_BREAKPOINT_EXECUTE, X86_BREAKPOINT_LEN_X)
+
+static void watch_injecting(struct kvm_vcpu *vcpu)
+{
+	kvm_set_dr(vcpu, 0, asm_exc_nmi_handler);
+	kvm_set_dr(vcpu, 1, asm_exc_db_handler);
+	kvm_set_dr(vcpu, 2, asm_exc_mce_handler);
+	kvm_set_dr(vcpu, 3, asm_exc_df_handler);
+	kvm_set_dr(vcpu, 6, DR6_RESERVED);
+	kvm_set_dr(vcpu, 7, DR7_X(0) | DR7_X(1) | DR7_X(2) | DR7_X(3));
+}
+
+static void finish_watching_injecting(struct kvm_vcpu *vcpu)
+{
+	kvm_set_dr(vcpu, 0, 0);
+	kvm_set_dr(vcpu, 1, 0);
+	kvm_set_dr(vcpu, 2, 0);
+	kvm_set_dr(vcpu, 3, 0);
+	kvm_set_dr(vcpu, 6, DR6_RESERVED);
+	kvm_set_dr(vcpu, 7, 0);
+}
+
+static void watch_handler_done(struct kvm_vcpu *vcpu)
+{
+	kvm_set_dr(vcpu, 0, ist_interrupted_rip[ist_depth-1]);
+	kvm_set_dr(vcpu, 1, asm_exc_df_handler);
+	//kvm_set_dr(vcpu, 2, exc_nmi_handler);
+	//kvm_set_dr(vcpu, 3, native_irq_return_iret_ip);
+	kvm_set_dr(vcpu, 6, DR6_RESERVED);
+	kvm_set_dr(vcpu, 7, DR7_X(0) | DR7_X(1));
+	//kvm_set_dr(vcpu, 7, DR7_X(0) | DR7_X(1)  | DR7_X(2)  | DR7_X(3));
+}
+
+static void ist_emul_test_start_singlestep(struct kvm_vcpu *vcpu)
+{
+	ist_emul_test_singlestep = 1;
+}
+
+static void ist_emul_test_stop_singlestep(struct kvm_vcpu *vcpu)
+{
+	ist_emul_test_singlestep = 0;
+	watch_handler_done(vcpu);
+	finish_watching_injecting(vcpu);
+}
+
+static void ist_emul_test_stop(struct kvm_vcpu *vcpu)
+{
+	ist_emul_test = TEST_STOPPED;
+	ist_emul_test_stop_singlestep(vcpu);
+}
+
+static bool is_entering_ip(struct kvm_vcpu *vcpu)
+{
+	unsigned long rip = kvm_rip_read(vcpu);
+
+	return rip == asm_exc_mce_handler || rip == asm_exc_db_handler || rip == asm_exc_nmi_handler;
+}
+
+static void emul_ist_bug_in_singlestep(struct kvm_vcpu *vcpu)
+{
+	unsigned long rip = kvm_rip_read(vcpu);
+
+	if (WARN_ON_ONCE(!ist_depth)) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return;
+	}
+
+	if (rip == asm_exc_df_handler || instruction_count > 1000) {
+		ist_emul_test_stop(vcpu);
+		return;
+	}
+}
+
+static unsigned long read_one(struct kvm_vcpu *vcpu, unsigned long addr)
+{
+	unsigned long ret;
+	struct x86_exception e;
+	if (kvm_read_guest_virt(vcpu, addr, &ret, sizeof(ret), &e) != X86EMUL_CONTINUE)
+		return 0xf000f123f456f789;
+	return ret;
+}
+
+static void emul_ist_kctx_handler_return(struct kvm_vcpu *vcpu)
+{
+	unsigned long rsp = kvm_rsp_read(vcpu);
+	unsigned long ret_rip;
+	struct x86_exception e;
+
+	if (kvm_read_guest_virt(vcpu, rsp, &ret_rip, sizeof(ret_rip), &e) != X86EMUL_CONTINUE)
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
+	/* it is faked #MC #DB NMI, make the guest handle it as if the handler in kernel context was an NOP */
+	kvm_rsp_write(vcpu, rsp+8);
+	kvm_rip_write(vcpu, ret_rip);
+}
+
+static void emul_ist_kctx_handler_done(struct kvm_vcpu *vcpu)
+{
+	unsigned long rip = kvm_rip_read(vcpu);
+	int vector = -1;
+
+	if (rip == exc_nmi_handler)
+		vector = NMI_VECTOR;
+	if (rip == exc_db_kernel_handler || rip == exc_db_user_handler)
+		vector = DB_VECTOR;
+	if (rip == exc_mce_kernel_handler || rip == exc_mce_user_handler)
+		vector = MC_VECTOR;
+
+	if (vector > 0) {
+		if (WARN_ON(vector != pending_vector[ist_depth-1]))
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		pr_info("Enter the handler in kernel context; ");
+		print_pending_vectors();
+		emul_ist_kctx_handler_return(vcpu);
+	}
+}
+
+static void emul_ist_emul_enable_delivering(struct kvm_vcpu *vcpu)
+{
+	unsigned long rip = kvm_rip_read(vcpu);
+
+	if (rip == commit_ip) {
+		ist_atomic_depth = 0;
+		ist_nmi_blocking = 0;
+		ist_db_blocking = 0;
+		ist_mce_blocking = 0;
+	}
+}
+
+static bool test_nesting_bug(void)
+{
+	return test_too_early_nesting_bug && ((get_random_u32() % 1024) == 0);
+}
+
+static void __ist_emul_test_queue_one(struct kvm_vcpu *vcpu, int vector)
+{
+	if (!ist_atomic_depth)
+		ist_interrupted_rip[ist_depth] = kvm_rip_read(vcpu);
+	else
+		ist_interrupted_rip[ist_depth] = commit_ip;
+	pending_vector[ist_depth] = vector;
+	ist_depth++;
+	ist_atomic_depth++;
+	instruction_count = 0;
+	pr_info("queue an IST exception, depth:%d, atomic_depth:%d; ", ist_depth, ist_atomic_depth);
+	print_pending_vectors();
+
+	// per intel SDM, X86_EFLAGS_TF is cleared after the exception is diliverred.
+	// use hw breakpoint to force immediate exit
+	// and add X86_EFLAGS_TF after breakpoint hits
+	ist_emul_injecting = true;
+	watch_injecting(vcpu);
+	pr_info("interrupt ip: %lx return ip: %lx\n", kvm_rip_read(vcpu), ist_interrupted_rip[ist_depth-1]);
+}
+
+static void ist_emul_test_queue_one(struct kvm_vcpu *vcpu)
+{
+	u32 which = get_random_u32() % 3;
+
+	if (ist_depth >= MAX_NESTING)
+		return;
+
+	if (which <= 0 && (!ist_mce_blocking || test_nesting_bug())) {
+		kvm_queue_exception(vcpu, MC_VECTOR);
+		ist_mce_blocking = 1;
+		__ist_emul_test_queue_one(vcpu, MC_VECTOR);
+		commit_ip = asm_exc_mce_commit_ip;
+		return;
+	}
+
+	if (which <= 1 && (!ist_db_blocking || test_nesting_bug())) {
+		kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);
+		ist_db_blocking = 1;
+		__ist_emul_test_queue_one(vcpu, DB_VECTOR);
+		commit_ip = asm_exc_db_commit_ip;
+		return;
+	}
+
+	if (which <= 2 && (!ist_nmi_blocking || test_nesting_bug())) {
+		vmx_set_nmi_mask(vcpu, false);
+		kvm_inject_nmi(vcpu);
+		ist_nmi_blocking = 1;
+		__ist_emul_test_queue_one(vcpu, 2);
+		commit_ip = asm_exc_nmi_commit_ip;
+		return;
+	}
+}
+
+static void __handle_ist_emul_test_singlestep(struct kvm_vcpu *vcpu)
+{
+	instruction_count++;
+	//pr_info("singlestep ip: %lx\n", kvm_rip_read(vcpu));
+	emul_ist_emul_enable_delivering(vcpu);
+	emul_ist_kctx_handler_done(vcpu);
+	emul_ist_bug_in_singlestep(vcpu);
+
+	/* try to nest an IST exception if the previous is not done */
+	if (!ist_emul_test_singlestep)
+		return;
+
+	// no RF, the return rip need to be watched.
+	// #DB during a repeated string instruction will get RF (sync_regs())
+	if (vmx_get_rflags(vcpu) & X86_EFLAGS_RF)
+		return;
+
+	if (get_random_u32() % IST_NESTED_RATE)
+		return;
+
+	ist_emul_test_queue_one(vcpu);
+}
+
+static bool handle_ist_emul_test_singlestep(struct kvm_vcpu *vcpu, unsigned long dr6)
+{
+	unsigned long rip;
+
+	if (!ist_emul_test_singlestep)
+		return false;
+
+	//kvm_get_dr(vcpu, 6, &dr6);
+	//pr_info("singlestep rip %lx dr6 %lx\n", kvm_rip_read(vcpu), dr6);
+	//kvm_set_dr(vcpu, 6, DR6_RESERVED);
+	if (WARN_ON(!ist_emul_injecting && !ist_emul_returning && is_entering_ip(vcpu))) {
+		ist_emul_test_stop(vcpu);
+		return true;
+	}
+	if (ist_emul_injecting) {
+		//pr_info("xxx ip: %lx\n", kvm_rip_read(vcpu));
+		if (WARN_ON(!is_entering_ip(vcpu))) {
+			ist_emul_test_stop(vcpu);
+			return true;
+		}
+		ist_emul_injecting = false;
+		finish_watching_injecting(vcpu);
+		if (0)
+			read_one(vcpu, kvm_rsp_read(vcpu));
+		//pr_info("rip in ret %lx\n", read_one(vcpu, kvm_rsp_read(vcpu)));
+		//watch_handler_done(vcpu);
+		//if (vmx_get_rflags(vcpu) & X86_EFLAGS_TF)
+		//	pr_info("xxxxxxxxxxxxxxxxxxxxxx\n");
+		vmx_set_rflags(vcpu, vmx_get_rflags(vcpu) | X86_EFLAGS_TF);
+	}
+	if (ist_emul_returning) {
+		rip = kvm_rip_read(vcpu);
+		if (rip != ist_interrupted_rip[ist_depth-1]) {
+			pr_info("rip %lx expect rip %lx\n", rip, ist_interrupted_rip[ist_depth-1]);
+			WARN_ON(1);
+			ist_emul_test_stop(vcpu);
+			return true;
+		}
+		ist_depth--;
+		pr_info("IST exception returned, depth:%d; ", ist_depth);
+		print_pending_vectors();
+
+		// print instruction_count for adjusting IST_NESTED_RATE
+		// to contrl the average ist_depth for the the test.
+		//pr_info("instruction_count %d\n", instruction_count);
+		instruction_count = 0;
+		ist_emul_returning = false;
+
+		if (!ist_depth) {
+			ist_emul_test_stop_singlestep(vcpu);
+			return true;
+		}
+	}
+
+
+	__handle_ist_emul_test_singlestep(vcpu);
+
+	rip = kvm_rip_read(vcpu);
+	if (!ist_emul_injecting && rip == native_irq_return_iret_ip) {
+		pr_info("IST exception is going to return\n");
+		//watch_handler_done(vcpu);
+		ist_emul_returning = true;
+	}
+	return true;
+}
+
+static void handle_ist_emul_test(struct kvm_vcpu *vcpu)
+{
+	//if (ist_emul_test_singlestep)
+	//	pr_info("vmexit ip: %lx\n", kvm_rip_read(vcpu));
+
+	if (ist_emul_test == TEST_STOPPED)
+		return;
+
+	if (ist_emul_test == TEST_REQUESTED) {
+		/* the test can't only be started until the guest's booting process is done. */
+		if (vmx_get_cpl(vcpu))
+			ist_emul_test = TEST_ONGOING;
+		else
+			return;
+	}
+
+	/* Don't start the test if the test is already started or someone
+	 * else is using the X86_EFLAGS_TF */
+	// no RF, the return rip need to be watched.
+	if (vmx_get_rflags(vcpu) & (X86_EFLAGS_TF | X86_EFLAGS_RF))
+	       return;
+
+	if (ist_emul_test_singlestep) {
+		//kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return;
+	}
+
+	if (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
+		(GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS))
+		return;
+
+	if (vcpu->arch.nmi_injected || vcpu->arch.interrupt.injected ||
+	    vcpu->arch.exception.pending || vcpu->arch.exception.injected)
+		return;
+
+	pr_info_once("%lx %lx %lx %lx %lx %lx\n", vcpu->arch.eff_db[0], vcpu->arch.eff_db[1],
+			vcpu->arch.eff_db[2], vcpu->arch.eff_db[3], vcpu->arch.dr6, vcpu->arch.dr7);
+	if (vcpu->arch.eff_db[0] || vcpu->arch.eff_db[1] ||
+	    vcpu->arch.eff_db[2] || vcpu->arch.eff_db[3] ||
+	    ((vcpu->arch.dr6 | DR6_RESERVED) != DR6_RESERVED) ||
+	    ((vcpu->arch.dr7 | DR7_FIXED_1) != DR7_FIXED_1))
+		return;
+
+	if (WARN_ON_ONCE(ist_depth)) {
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		return;
+	}
+
+	/* XXX: don't start the testing when the guest is handling real #MC #DB NMI.
+	 * But how to detect it? Just skip the detecting since is a test. */
+
+	if (get_random_u32() % IST_START_RATE)
+		return;
+
+	ist_emul_test_start_singlestep(vcpu);
+	ist_emul_test_queue_one(vcpu);
+}
+
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -5258,6 +5693,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	switch (ex_no) {
 	case DB_VECTOR:
 		dr6 = vmx_get_exit_qual(vcpu);
+		if (handle_ist_emul_test_singlestep(vcpu, dr6))
+			return 1;
 		if (!(vcpu->guest_debug &
 		      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))) {
 			/*
@@ -6579,6 +7016,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
 
+	if (ret > 0)
+		handle_ist_emul_test(vcpu);
 	/*
 	 * Exit to user space when bus lock detected to inform that there is
 	 * a bus lock in guest.
@@ -7290,7 +7729,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * vmentry fails as it then expects bit 14 (BS) in pending debug
 	 * exceptions being set, but that's not correct for the guest debugging
 	 * case. */
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+	if (ist_emul_test_singlestep || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))
 		vmx_set_interrupt_shadow(vcpu, 0);
 
 	kvm_load_guest_xsave_state(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7713420abab0..205a4d989046 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -814,6 +814,7 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 	atomic_inc(&vcpu->arch.nmi_queued);
 	kvm_make_request(KVM_REQ_NMI, vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_inject_nmi);
 
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
@@ -12810,12 +12811,15 @@ bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip)
 }
 EXPORT_SYMBOL_GPL(kvm_is_linear_rip);
 
+int ist_emul_test_singlestep;
+EXPORT_SYMBOL_GPL(ist_emul_test_singlestep);
+
 unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
 {
 	unsigned long rflags;
 
 	rflags = static_call(kvm_x86_get_rflags)(vcpu);
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
+	if (ist_emul_test_singlestep || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))
 		rflags &= ~X86_EFLAGS_TF;
 	return rflags;
 }
@@ -12823,8 +12827,8 @@ EXPORT_SYMBOL_GPL(kvm_get_rflags);
 
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
-	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP &&
-	    kvm_is_linear_rip(vcpu, vcpu->arch.singlestep_rip))
+	if (ist_emul_test_singlestep || ((vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) &&
+	    kvm_is_linear_rip(vcpu, vcpu->arch.singlestep_rip)))
 		rflags |= X86_EFLAGS_TF;
 	static_call(kvm_x86_set_rflags)(vcpu, rflags);
 }
-- 
2.19.1.6.gb485710b

