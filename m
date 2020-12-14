Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025E82D9F1F
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440924AbgLNSek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:34:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440908AbgLNSe0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 13:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607970777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQPbU8GdbnzOAorUym/8Nh50DXJaOVkOwZQhPivX8ig=;
        b=TfddmJNqCfrCfnnV7GbA9L4PezaVG5vXdneUxJAxH/u58Gd6tj0vHd33NAaLoMY8XNFvd1
        N1Rb4RFJOhyoHhkJY3eVpkQ3IyCRrv7VyrgZ6DdTfQAIbHRLt/xEQnmlfyPV2LxAISeyKY
        R0iE2cLNK5TTXb5wHE5H3DlXkEU9zgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-GWbl7I2-Nh-7Rb5DSeGttA-1; Mon, 14 Dec 2020 13:32:54 -0500
X-MC-Unique: GWbl7I2-Nh-7Rb5DSeGttA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E715180A092;
        Mon, 14 Dec 2020 18:32:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C884F100AE36;
        Mon, 14 Dec 2020 18:32:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Alexander Graf <graf@amazon.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 2/3] KVM: x86: use kvm_complete_insn_gp in emulating RDMSR/WRMSR
Date:   Mon, 14 Dec 2020 13:32:49 -0500
Message-Id: <20201214183250.1034541-3-pbonzini@redhat.com>
In-Reply-To: <20201214183250.1034541-1-pbonzini@redhat.com>
References: <20201214183250.1034541-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify the four functions that handle {kernel,user} {rd,wr}msr, there
is still some repetition between the two instances of rdmsr but the
whole business of calling kvm_inject_gp and kvm_skip_emulated_instruction
can be unified nicely.

Because complete_emulated_wrmsr now becomes essentially a call to
kvm_complete_insn_gp, remove complete_emulated_msr.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a3fdc16cfd6f..2f1bc52e70c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1634,27 +1634,20 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_set_msr);
 
-static int complete_emulated_msr(struct kvm_vcpu *vcpu, bool is_read)
+static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->run->msr.error) {
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	} else if (is_read) {
+	int err = vcpu->run->msr.error;
+	if (!err) {
 		kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
 		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
 	}
 
-	return kvm_skip_emulated_instruction(vcpu);
-}
-
-static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
-{
-	return complete_emulated_msr(vcpu, true);
+	return kvm_complete_insn_gp(vcpu, err);
 }
 
 static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
 {
-	return complete_emulated_msr(vcpu, false);
+	return kvm_complete_insn_gp(vcpu, vcpu->run->msr.error);
 }
 
 static u64 kvm_msr_reason(int r)
@@ -1718,17 +1711,16 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 	}
 
 	/* MSR read failed? Inject a #GP */
-	if (r) {
+	if (!r) {
+		trace_kvm_msr_read(ecx, data);
+
+		kvm_rax_write(vcpu, data & -1u);
+		kvm_rdx_write(vcpu, (data >> 32) & -1u);
+	} else {
 		trace_kvm_msr_read_ex(ecx);
-		kvm_inject_gp(vcpu, 0);
-		return 1;
 	}
 
-	trace_kvm_msr_read(ecx, data);
-
-	kvm_rax_write(vcpu, data & -1u);
-	kvm_rdx_write(vcpu, (data >> 32) & -1u);
-	return kvm_skip_emulated_instruction(vcpu);
+	return kvm_complete_insn_gp(vcpu, r);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_rdmsr);
 
@@ -1750,14 +1742,12 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 		return r;
 
 	/* MSR write failed? Inject a #GP */
-	if (r > 0) {
+	if (!r)
+		trace_kvm_msr_write(ecx, data);
+	else
 		trace_kvm_msr_write_ex(ecx, data);
-		kvm_inject_gp(vcpu, 0);
-		return 1;
-	}
 
-	trace_kvm_msr_write(ecx, data);
-	return kvm_skip_emulated_instruction(vcpu);
+	return kvm_complete_insn_gp(vcpu, r);
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
-- 
2.26.2


