Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC184767D2
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 03:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhLPCTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 21:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbhLPCTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 21:19:41 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C69C061574;
        Wed, 15 Dec 2021 18:19:41 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id x1-20020a17090a2b0100b001b103e48cfaso1007918pjc.0;
        Wed, 15 Dec 2021 18:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pktaRoivHLqlPVSRDLtKWw/CIWOPKT75Tjljvf3cVZQ=;
        b=HZgXliBCeQSnuIKh4uuASETbfd68v5a6wStHAG24cEOrIs6kZ9rpmvhtY6YDm1GN9j
         ovtZvmW5B7lZPHaIa1kVCk6e4U1xdvgLOdJxexCcG4+PvDKfI2Fh1DdLOoZgPIhelfQg
         jgbMNJ3QFsBA2Mi/CyjHyI3oB6TpZ8wXKln4w2sxii6O/otwRG0uLjMF3LOYwPjzP08J
         Q8MFRbqMAP2YIyP3DkFYCusyR5yaMB5TYbR2YGXn5291/cYj0A8TTMemB1/j0jHiAwyj
         MQjmgbSB2K2AAZZBk5MZ/xUhK7ND5c6YREV7X4Wa7LscWSArHMbSg8gOTw3Sb5uKHd+e
         SY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pktaRoivHLqlPVSRDLtKWw/CIWOPKT75Tjljvf3cVZQ=;
        b=qXRdNVI+YLocp1X/qS5VzxeaZ3+8Onbi9MKb6WcAZIPV+rnrCLf5RFgMoMnLcLAV2h
         j6K3pS1eYiD9A4GSXXp+aRINhhFpy/TBDyaCDj8GcSkxtCmzl7kAnmpHULWI0fEjnGE6
         trYFIGQcVm45zVAS+UElG2JkxeWbWQG912S/iVrosc/0a6D7gSP/+F8ksG43WLZYkRGu
         IaKG/TQSM/7G1YnPH6FNBV7jIJu19QGLtI09fGDd4vl1t9oHBR4fktFBRSok46tTNUwz
         /Hk6Z+hZbwVT48fNjcFJWZrokvFI7RqxOyGb2fcop85HHuwa383OYpA+83JBHa6IcWJh
         Ic0A==
X-Gm-Message-State: AOAM533catreZlwXOHnyaW830SAAOGcorPPmuXABFESqSR3b316JqJPR
        +v0TxAsg4hxJxphOxBcP2PdyAKqXSLCf8A==
X-Google-Smtp-Source: ABdhPJy8PYSku/AK+tpu8y/bod96nQDXh07wjbZX7/V8vck2RkCrmuS36c04rVMOT4GOSdwbL9WYaw==
X-Received: by 2002:a17:902:ab88:b0:148:a2e8:2c47 with SMTP id f8-20020a170902ab8800b00148a2e82c47mr7210325plr.150.1639621180909;
        Wed, 15 Dec 2021 18:19:40 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id m16sm4451065pfk.186.2021.12.15.18.19.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Dec 2021 18:19:40 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] KVM: VMX: Mark VCPU_EXREG_CR3 dirty when !CR0_PG -> CR0_PG if EPT + !URG
Date:   Thu, 16 Dec 2021 10:19:38 +0800
Message-Id: <20211216021938.11752-4-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211216021938.11752-1-jiangshanlai@gmail.com>
References: <20211216021938.11752-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

When !CR0_PG -> CR0_PG, vcpu->arch.cr3 becomes active, but GUEST_CR3 is
still vmx->ept_identity_map_addr if EPT + !URG.  So VCPU_EXREG_CR3 is
considered to be dirty and GUEST_CR3 needs to be updated in this case.

Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5f281f5ee961..e2d535fe0387 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3066,6 +3066,13 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		/* Note, vmx_set_cr4() consumes the new vcpu->arch.cr0. */
 		if ((old_cr0_pg ^ cr0) & X86_CR0_PG)
 			vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
+
+		/*
+		 * When !CR0_PG -> CR0_PG, vcpu->arch.cr3 becomes active, but
+		 * GUEST_CR3 is still vmx->ept_identity_map_addr if EPT + !URG.
+		 */
+		if (!(old_cr0_pg & X86_CR0_PG) && (cr0 & X86_CR0_PG))
+			kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
 	}
 
 	/* depends on vcpu->arch.cr0 to be set to a new value */
-- 
2.19.1.6.gb485710b

