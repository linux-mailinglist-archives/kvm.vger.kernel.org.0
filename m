Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390F5375275
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 12:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhEFKgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 06:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhEFKgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 06:36:52 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F89C061761
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 03:35:54 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4FbVNS0pF8zQk1H;
        Thu,  6 May 2021 12:35:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        references:in-reply-to:message-id:date:date:subject:subject:from
        :from:received; s=mail20150812; t=1620297349; bh=tEybp2p8gf7yZ+6
        LkwoThST0HRw53MFcH7vdYU00HJw=; b=wzgn2nFq00MCUz95pLq5RL0DEwQy4lL
        7IMijFPXEpESm+2MDdvveYYwZrTmQJuvxqBE3/kWivcqT2P9FVYpcbAGuWp4Rw/6
        14DU9PLgztfelB+2y4Vijo0+nlGmOwm5v1lGt32NaCh7ftPxCNyuhiykuJD7B0J9
        IV9pyC+0vYxhKWK7wMr/AQvkaD4opwFdROX9G/Dxlo/NSbhaplAQj2GOA56nnHIs
        fCzzWz9Tb34bgJmWhVBxw+sMAZadHwo5DIF0Vcy4bX44uOMMbwWoXU3bnwDaYegR
        uVGNDNAniSSY1PmX7S92lAxQnpt8rFy4kejPGRwpO5ud02bTAA2telg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1620297350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=gZSRfLxHhC3FdVKaHb3Mg4nXEWDZswfrHVBWzXtiPxo=;
        b=QBmzz/smQt3uzBwJtPIBHOc/ZKuk8d8iX9kWRQZqro8vC2Ti8sLJs88tUXKbS+/9LSTRj4
        8N/u+xnLcBSsgqa00goLmOAsOgT/G8p51vpp3Qm/I3QeaImSR8t5NFPYjSau28BlV4cxdK
        2fvFda5NrMGyDaCGOYtXCFRafELiCjCSNwFPqO3PpNT+yDf0Rjd4/fpmcny7rx6YTDfjN9
        cxPn0VZX/uozCg/d8qw/YOQhGHwl7sjdX412NmnzP9Ay6animJCbkPTKRWEsiHVSKXYTiU
        DPAQjitwXsyvle2cqnm7HllcC6KoEzFRbLUlMUNPvO7OkMC1jAHYUVXzuMXMTg==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id 1-E47WGN_SHf; Thu,  6 May 2021 12:35:49 +0200 (CEST)
From:   ilstam@mailbox.org
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Subject: [PATCH 5/8] KVM: X86: Move tracing outside write_l1_tsc_offset()
Date:   Thu,  6 May 2021 10:32:25 +0000
Message-Id: <20210506103228.67864-6-ilstam@mailbox.org>
In-Reply-To: <20210506103228.67864-1-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.11 / 15.00 / 15.00
X-Rspamd-Queue-Id: 355691868
X-Rspamd-UID: 2bd5a9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilias Stamatis <ilstam@amazon.com>

A subsequent patch fixes write_l1_tsc_offset() to account for nested TSC
scaling. Calculating the L1 TSC for logging it with the trace call
becomes more complex then.

This patch moves the trace call to the caller and avoids code
duplication as a result too.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/kvm/svm/svm.c | 4 ----
 arch/x86/kvm/vmx/vmx.c | 3 ---
 arch/x86/kvm/x86.c     | 4 ++++
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9790c73f2a32..d2f9d6a9716f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1090,10 +1090,6 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 		svm->vmcb01.ptr->control.tsc_offset = offset;
 	}
 
-	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
-				   svm->vmcb->control.tsc_offset - g_tsc_offset,
-				   offset);
-
 	svm->vmcb->control.tsc_offset = offset + g_tsc_offset;
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cbe0cdade38a..49241423b854 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1812,9 +1812,6 @@ static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
 		g_tsc_offset = vmcs12->tsc_offset;
 
-	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
-				   vcpu->arch.tsc_offset - g_tsc_offset,
-				   offset);
 	vmcs_write64(TSC_OFFSET, offset + g_tsc_offset);
 	return offset + g_tsc_offset;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 87deb119c521..c08295bcf50e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2299,6 +2299,10 @@ EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
+	trace_kvm_write_tsc_offset(vcpu->vcpu_id,
+				   vcpu->arch.l1_tsc_offset,
+				   offset);
+
 	vcpu->arch.l1_tsc_offset = offset;
 	vcpu->arch.tsc_offset = static_call(kvm_x86_write_l1_tsc_offset)(vcpu, offset);
 }
-- 
2.17.1

