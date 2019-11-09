Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E615F5DC1
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 08:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbfKIHFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Nov 2019 02:05:42 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34428 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbfKIHFm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Nov 2019 02:05:42 -0500
Received: by mail-pg1-f193.google.com with SMTP id c9so966711pgc.1;
        Fri, 08 Nov 2019 23:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZCWySZwIFzo2R68xigCV0RDhtUpT4rtgzjsd95CcpwQ=;
        b=eNKAefhxCaa3zY6JByKGRa8WBVBBnoI0ZkPv9LLZz9qO3eYRoWbg5y6KdfqF9g+GLn
         9RGGyjCbTguezobMDVYXOKVD0JI8ABdKhSH1J1G0dTt6ULRGAWs+cRBLimdYjjhcAQun
         P+0tpsXw5sbWtnQgEb41Owm+8ehVY2p+KDcK7jpepDmNlfxoW2k+XPJfWdDtbtGMQIon
         fB9iiJMcHa/V97mEbISMdqcCIfokDoXrGd1FFlXKlriKrZeBgiBEigv4pGzPrk1Nt/4c
         g/IRf6I50Pf0yt/7jQ8anvaaQTaj3ZkCkyPnh6aY7r/Ugqq0Lb0X0B+6g9Tanrjbaq/5
         c1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZCWySZwIFzo2R68xigCV0RDhtUpT4rtgzjsd95CcpwQ=;
        b=CC0KAcYTGhhEfZi3CSYcOonrC+F9ubmRk5sfrAjdBIDLsHsmF/zswp1v6AeJZug8V2
         YUk1QK2YBbETor2PzVqoJRKmtoNu0XuGdnXIsRQFSoLf/RixuH0eel+M0AkdM+FvKLfO
         F5oo9mqAEK6aTWRoHI8yXxsFf6jSLJ8LZT+EF01nbFF0HeLy8wPcRq80DH6QGPM8wJoY
         CB09Q7kaWknNDrhhuiy44Ow2iXobC1UErO7OItGemPzdrTyFCyI1bssMB3aWB8feaF/+
         tpUsOx/w3tB0pjYnCyjMKMSR9kHredpdwAlmMLdtks+JdePAhg1/QuJ10dYeb/8xFSEe
         /Yzg==
X-Gm-Message-State: APjAAAWEP0Esf6uorwIj6ukoqNQqK8WdgqM1ymzixIprSkLZlkFonRAv
        y9HpHFVjjL3M2kpWyiMsVc/9sJ/N
X-Google-Smtp-Source: APXvYqzrHyFC3iNi9gdl0/Mi61B9vgmW5ATsn68KqWw+xYueR5oDvgvcOpJax3cgw4PCUgZt27Dxzg==
X-Received: by 2002:a63:1b41:: with SMTP id b1mr16833656pgm.335.1573283140988;
        Fri, 08 Nov 2019 23:05:40 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id b200sm8337991pfb.86.2019.11.08.23.05.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Nov 2019 23:05:40 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/2] KVM: X86: Single target IPI fastpath
Date:   Sat,  9 Nov 2019 15:05:34 +0800
Message-Id: <1573283135-5502-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

This patch tries to optimize x2apic physical destination mode, fixed delivery
mode single target IPI by delivering IPI to receiver immediately after sender
writes ICR vmexit to avoid various checks when possible.

Testing on Xeon Skylake server:

The virtual IPI latency from sender send to receiver receive reduces more than
330+ cpu cycles.

Running hackbench(reschedule ipi) in the guest, the avg handle time of MSR_WRITE
caused vmexit reduces more than 1000+ cpu cycles:

Before patch:

  VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg time
MSR_WRITE    5417390    90.01%    16.31%      0.69us    159.60us    1.08us

After patch:

  VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time   Avg time
MSR_WRITE    6726109    90.73%    62.18%      0.48us    191.27us    0.58us

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c   | 39 +++++++++++++++++++++++++++++++++++++--
 include/linux/kvm_host.h |  1 +
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d21a4a..5c67061 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5924,7 +5924,9 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (exit_reason < kvm_vmx_max_exit_handlers
+	if (vcpu->fast_vmexit)
+		return 1;
+	else if (exit_reason < kvm_vmx_max_exit_handlers
 	    && kvm_vmx_exit_handlers[exit_reason])
 		return kvm_vmx_exit_handlers[exit_reason](vcpu);
 	else {
@@ -6474,6 +6476,34 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
+static int handle_ipi_fastpath(struct kvm_vcpu *vcpu)
+{
+	u32 index;
+	u64 data;
+	int ret = 0;
+
+	if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic)) {
+		/*
+		 * fastpath to IPI target
+		 */
+		index = kvm_rcx_read(vcpu);
+		data = kvm_read_edx_eax(vcpu);
+
+		if (((index - APIC_BASE_MSR) << 4 == APIC_ICR) &&
+			((data & KVM_APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
+			((data & APIC_MODE_MASK) == APIC_DM_FIXED)) {
+
+			kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
+			ret = kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR, (u32)data);
+
+			if (ret == 0)
+				ret = kvm_skip_emulated_instruction(vcpu);
+		};
+	};
+
+	return ret;
+}
+
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6615,6 +6645,12 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 				  | (1 << VCPU_EXREG_CR3));
 	vcpu->arch.regs_dirty = 0;
 
+	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
+	vcpu->fast_vmexit = false;
+	if (!is_guest_mode(vcpu) &&
+		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
+		vcpu->fast_vmexit = handle_ipi_fastpath(vcpu);
+
 	pt_guest_exit(vmx);
 
 	/*
@@ -6634,7 +6670,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->nested.nested_run_pending = 0;
 	vmx->idt_vectoring_info = 0;
 
-	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
 	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
 		kvm_machine_check();
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 719fc3e..7a7358b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -319,6 +319,7 @@ struct kvm_vcpu {
 #endif
 	bool preempted;
 	bool ready;
+	bool fast_vmexit;
 	struct kvm_vcpu_arch arch;
 	struct dentry *debugfs_dentry;
 };
-- 
2.7.4

