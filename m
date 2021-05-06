Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2A5375276
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 12:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbhEFKhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 06:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhEFKhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 06:37:04 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756D5C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 03:36:06 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4FbVNg2hh0zQjbY;
        Thu,  6 May 2021 12:36:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        references:in-reply-to:message-id:date:date:subject:subject:from
        :from:received; s=mail20150812; t=1620297360; bh=e29jpvmer/acpDb
        QqKbpXa0yrElYTdMto7TSxUZZgIE=; b=pmSWLEk/YVJv5njdJQ9U1+pJy7CVF3O
        /wOcBdFDBlxfUqPxPUVbnW3RLwEDrV6Rq93RUiPCRzzWk94h80PipUd+qPSKLa0b
        3apfgUEBL0t5Sxz4QX+Si2N6V8yRBNcWAXN8biydv7/k4gkJnDYUyxrvKs/K0ZGa
        28hjgJW8OMcrQKYofvy+WyH4/mtjSh7/AaR4Qqb4GfEMLPuvGfZCLsRw07H6w8RE
        CnyF3i5Ijx5AkqkwvDkVb56Juv1kPHHY5LaliJDIy20Orr0slb+1t6mklXS7Cn8Z
        igQgHYWGQ7TuyUIJuuLb3bUnthNo5CCFaXZpiz+TPPd0DqZLyiTZ+jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1620297361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=KG8Ib7QmjQEA2cVDHwuNWahOx7A5Bg3pqP1KPdmf81s=;
        b=s1TbkhCGUd9B6raWXTg0wAI05loMxyHlzS+l+9yXRMxyOhOltKPTg+6+cgx0BP/E33xFAM
        OaBxp8AuBn0ea93TL36AtLkWAfob6yWjGyIRBM7h9+VjzFdK0Xh6TBA6c+YBNNwCug46DV
        ADHEow5auN4dNtVrnxXUbyI7k56gHp3ROYo6M7kw0mHotiAkKrJZlMjG4bfvbTYa8EXVgV
        eZWd4hAIlOSSFNdmnH08pp7Qu4NZJB5kR1Hmm7ViLWTF1fRjCmVksvHvcI16D9XssHpNHg
        bG9xA/uIAc9zvNwlKV01WURpVnykDzzzHO9seChbssMK/N6n84P04vV8n01H9w==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id McsdqunSiB4R; Thu,  6 May 2021 12:36:00 +0200 (CEST)
From:   ilstam@mailbox.org
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Subject: [PATCH 6/8] KVM: VMX: Make vmx_write_l1_tsc_offset() work with nested TSC scaling
Date:   Thu,  6 May 2021 10:32:26 +0000
Message-Id: <20210506103228.67864-7-ilstam@mailbox.org>
In-Reply-To: <20210506103228.67864-1-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.55 / 15.00 / 15.00
X-Rspamd-Queue-Id: 495101867
X-Rspamd-UID: a39cc6
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilias Stamatis <ilstam@amazon.com>

Calculating the current TSC offset is done differently when nested TSC
scaling is used.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 arch/x86/kvm/vmx/vmx.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 49241423b854..df7dc0e4c903 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1797,10 +1797,16 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 		vmx_update_msr_bitmap(&vmx->vcpu);
 }
 
-static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+/*
+ * This function receives the requested offset for L1 as an argument but it
+ * actually writes the "current" tsc offset to the VMCS and returns it. The
+ * current offset might be different in case an L2 guest is currently running
+ * and its VMCS02 is loaded.
+ */
+static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	u64 g_tsc_offset = 0;
+	u64 cur_offset = l1_offset;
 
 	/*
 	 * We're here if L1 chose not to trap WRMSR to TSC. According
@@ -1809,11 +1815,19 @@ static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	 * to the newly set TSC to get L2's TSC.
 	 */
 	if (is_guest_mode(vcpu) &&
-	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING))
-		g_tsc_offset = vmcs12->tsc_offset;
+	    (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)) {
+		if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING) {
+			cur_offset = kvm_compute_02_tsc_offset(
+					l1_offset,
+					vmcs12->tsc_multiplier,
+					vmcs12->tsc_offset);
+		} else {
+			cur_offset = l1_offset + vmcs12->tsc_offset;
+		}
+	}
 
-	vmcs_write64(TSC_OFFSET, offset + g_tsc_offset);
-	return offset + g_tsc_offset;
+	vmcs_write64(TSC_OFFSET, cur_offset);
+	return cur_offset;
 }
 
 /*
-- 
2.17.1

