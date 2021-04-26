Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A03A36C158
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 10:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhD0I4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 04:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235062AbhD0I4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 04:56:05 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9F7C061574;
        Tue, 27 Apr 2021 01:55:23 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id h20so30497884plr.4;
        Tue, 27 Apr 2021 01:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PzcggadyhDBPR7CkYxhgm2opVcnUll8pyqBD4JcyorE=;
        b=i+DQQFnEX+WO8dczKbJtcvwM9Ge3MHWQDobm2okSjgTjr1DwlhkC+2PMnHHJlzUVDm
         D+AhAlpfliuJMBKgI2F2fT1hwDkL/srtNNe8Z//OPpVcZqy/KMtOq5fG94rLTFbIaJQB
         6oL2WxwJiUvl+q1jiiP84TeE3S2EugTsGzCuAlWACJdRDsCbzAIZZQd3p0MhosI0ht66
         hwHGDYJbZWmWsJdR7sfiFhPh0KWNFMv+wjgxmXeefyRS5rGnMcS5Oe+q62RcE83DsW5o
         jegpCuPMr8VXHCENK+wTu8XQOun0C22cSkdi9XvOhMwDWYawYjlIEyJhW+A4on/xDdG/
         37uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PzcggadyhDBPR7CkYxhgm2opVcnUll8pyqBD4JcyorE=;
        b=b3LGY8VBG/Yd3k8qPXRNzECBRzGCVSdOT8BfmemoRnIso/GDY3T/ylo9nDvC/5D+qT
         LAAnsaToc6i9BbSIqsvOs51ug7zMeaWUIApXRn9hjKWYiqefceogPsLd/2O+yFqhIChs
         oYuqyOx9tYyGIGMJ6ZbmumLNznmfzjHor0my0BWEsDCubvUI8Z/zdGtrF9V1Vw8IutP2
         rDCuiaLoI3y8jNhNYVQIeVSSpIkwlFvU5Rpv4dcRSX7dK8xjnVliVJVi9IUxQXnBz2Kv
         ciKcnB0eihyy/XOSYfFcDGafpDzqTFDKEtQgNeGvOAqwNBOhqkD7VFr/cHHG1t17M6O5
         jLCw==
X-Gm-Message-State: AOAM5306GipJMJYhL23MxpScNb62Fu2ENR+0D8xLbgeZshKFQL6MAj6X
        Ry2U443eRik2UZS2by0inrmwCVdUFAQ=
X-Google-Smtp-Source: ABdhPJyOS6jgcGOoHxz9iMFlZYdGZEV1pN/pf/U6LGC8G2QVEYcaApYs5/cNBh0xMUv+XJfrulkQsQ==
X-Received: by 2002:a17:90a:352:: with SMTP id 18mr25304776pjf.223.1619513722745;
        Tue, 27 Apr 2021 01:55:22 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id e8sm1912910pfv.177.2021.04.27.01.55.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Apr 2021 01:55:22 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH 4/4] KVM/VMX: Fold handle_interrupt_nmi_irqoff() into its solo caller
Date:   Tue, 27 Apr 2021 07:09:49 +0800
Message-Id: <20210426230949.3561-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210426230949.3561-1-jiangshanlai@gmail.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The function handle_interrupt_nmi_irqoff() is called only once and
it doesn't handle for NMI, so its name is outdated.

Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 96e59d912637..92c22211203e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6396,16 +6396,6 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 
 void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
 
-static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
-{
-	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
-	gate_desc *desc = (gate_desc *)host_idt_base + vector;
-
-	kvm_before_interrupt(vcpu);
-	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
-	kvm_after_interrupt(vcpu);
-}
-
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
 	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
@@ -6427,12 +6417,19 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 intr_info = vmx_get_intr_info(vcpu);
+	unsigned int vector;
+	gate_desc *desc;
 
 	if (WARN_ONCE(!is_external_intr(intr_info),
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
-	handle_interrupt_nmi_irqoff(vcpu, intr_info);
+	vector = intr_info & INTR_INFO_VECTOR_MASK;
+	desc = (gate_desc *)host_idt_base + vector;
+
+	kvm_before_interrupt(vcpu);
+	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
+	kvm_after_interrupt(vcpu);
 }
 
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
-- 
2.19.1.6.gb485710b

