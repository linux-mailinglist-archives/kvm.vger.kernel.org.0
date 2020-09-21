Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5F0272546
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 15:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgIUNTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 09:19:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727246AbgIUNTq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 09:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600694385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aZRXEEBcdUkBTuNUa992Y9cFQefmS06zzwszq8vVxP4=;
        b=a1iWjST9AH8b2bcuToCbY78oJHh6T1KZ/SrypjGxhqyDRLkkZl0jEczCTwRw94mWh6asZj
        8o2rw4Y7NUGZ1xoEhnM70mXTfYnXmrvfm97x4u8yOoTEJfCGmV2cNmKfMyA0np8poKCoGd
        VZZMDQ/QiMIrxRj7dwfORG5iBSvViHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-7Z3M2NVYPFmP3Yd2UTGZAw-1; Mon, 21 Sep 2020 09:19:41 -0400
X-MC-Unique: 7Z3M2NVYPFmP3Yd2UTGZAw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD5A581CBE5;
        Mon, 21 Sep 2020 13:19:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33BA83782;
        Mon, 21 Sep 2020 13:19:35 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v5 2/4] KVM: x86: report negative values from wrmsr to userspace
Date:   Mon, 21 Sep 2020 16:19:21 +0300
Message-Id: <20200921131923.120833-3-mlevitsk@redhat.com>
In-Reply-To: <20200921131923.120833-1-mlevitsk@redhat.com>
References: <20200921131923.120833-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This will allow us to make some MSR writes fatal to the guest
(e.g when out of memory condition occurs)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/emulate.c | 7 +++++--
 arch/x86/kvm/x86.c     | 5 +++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 1d450d7710d63..d855304f5a509 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3702,13 +3702,16 @@ static int em_dr_write(struct x86_emulate_ctxt *ctxt)
 static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
 {
 	u64 msr_data;
+	int ret;
 
 	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
 		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
-	if (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data))
+
+	ret = ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data);
+	if (ret > 0)
 		return emulate_gp(ctxt, 0);
 
-	return X86EMUL_CONTINUE;
+	return ret < 0 ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
 }
 
 static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 063d70e736f7f..b6c67ab7c4f34 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1612,15 +1612,16 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data = kvm_read_edx_eax(vcpu);
+	int ret = kvm_set_msr(vcpu, ecx, data);
 
-	if (kvm_set_msr(vcpu, ecx, data)) {
+	if (ret > 0) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
 
 	trace_kvm_msr_write(ecx, data);
-	return kvm_skip_emulated_instruction(vcpu);
+	return ret < 0 ? ret : kvm_skip_emulated_instruction(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
-- 
2.26.2

