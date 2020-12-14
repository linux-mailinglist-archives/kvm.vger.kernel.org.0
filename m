Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6241D2D9F3F
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440940AbgLNSfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:35:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440910AbgLNSe0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 13:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607970777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=USNp54c4CGW4oD+PKyfbkSkCcQ2e4aS8DnesiYB6pyo=;
        b=ZRPsZGtnUyxnthgWDUw77ISi62MlUo3hPJqyprUGkEVoVTkQ9s97KdIFHXUF00LYsmsT4N
        +B23hQaeFiW6odG0FyDwEugjTQFBsM5wv1FzjDU1IYpaEZbKiw3+AB+Z3m8JKZ+opHywZp
        uQMNAHB8n/VLI14ackHdLIg2C5Tbx+8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-K_RamMgQPe6o9kQefbaNUQ-1; Mon, 14 Dec 2020 13:32:55 -0500
X-MC-Unique: K_RamMgQPe6o9kQefbaNUQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12399180A093;
        Mon, 14 Dec 2020 18:32:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F32C100AE36;
        Mon, 14 Dec 2020 18:32:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Alexander Graf <graf@amazon.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 3/3] KVM: x86: introduce complete_emulated_msr callback
Date:   Mon, 14 Dec 2020 13:32:50 -0500
Message-Id: <20201214183250.1034541-4-pbonzini@redhat.com>
In-Reply-To: <20201214183250.1034541-1-pbonzini@redhat.com>
References: <20201214183250.1034541-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will be used by SEV-ES to inject MSR failure via the GHCB.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm/svm.c          | 1 +
 arch/x86/kvm/vmx/vmx.c          | 1 +
 arch/x86/kvm/x86.c              | 8 ++++----
 4 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8cf6b0493d49..18aa15e6fadd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1285,6 +1285,7 @@ struct kvm_x86_ops {
 
 	void (*migrate_timers)(struct kvm_vcpu *vcpu);
 	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
+	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 801e0a641258..4067d511be08 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4306,6 +4306,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
 
 	.msr_filter_changed = svm_msr_filter_changed,
+	.complete_emulated_msr = kvm_complete_insn_gp,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 849be2a9f260..55fa51c0cd9d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7701,6 +7701,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.migrate_timers = vmx_migrate_timers,
 
 	.msr_filter_changed = vmx_msr_filter_changed,
+	.complete_emulated_msr = kvm_complete_insn_gp,
 	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
 };
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2f1bc52e70c0..6c4482b97c91 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1642,12 +1642,12 @@ static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
 		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
 	}
 
-	return kvm_complete_insn_gp(vcpu, err);
+	return kvm_x86_ops.complete_emulated_msr(vcpu, err);
 }
 
 static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
 {
-	return kvm_complete_insn_gp(vcpu, vcpu->run->msr.error);
+	return kvm_x86_ops.complete_emulated_msr(vcpu, vcpu->run->msr.error);
 }
 
 static u64 kvm_msr_reason(int r)
@@ -1720,7 +1720,7 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 		trace_kvm_msr_read_ex(ecx);
 	}
 
-	return kvm_complete_insn_gp(vcpu, r);
+	return kvm_x86_ops.complete_emulated_msr(vcpu, r);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
 
@@ -1747,7 +1747,7 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	else
 		trace_kvm_msr_write_ex(ecx, data);
 
-	return kvm_complete_insn_gp(vcpu, r);
+	return kvm_x86_ops.complete_emulated_msr(vcpu, r);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
-- 
2.26.2

