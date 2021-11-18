Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7374559A5
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343651AbhKRLLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbhKRLLR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 06:11:17 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D97C061767;
        Thu, 18 Nov 2021 03:08:18 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id u17so4927137plg.9;
        Thu, 18 Nov 2021 03:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iJYisT0ld7Chsu+T6PQppbIhzPNs7ZAW74mwSHZMRlU=;
        b=ZkAegnr+TE8L2A1TXLAmtpDoKg5Hj4vlATUKN/bFwRL/D3AN9XGwR8miHkZNq3tHgc
         xOAovwUa4vjtxJS3GgkTvsA0nRIN2qpkulMxM7hok1hbDChgIT/vmd6pEz2cohItvMmM
         jba9q0bVu09r9/cb7K9K1gJ9PgmuGbMpDm1VWb2CGH8dGUUfNlwwPiFGKYlbdEMpQWq5
         QLOxsmfN5WWUCceqhAdLDW2lYUX5p3OX8W2d+N3PoiUqQ5avv3ailA31qaZDxJ4V+hcu
         DfMABCMLWkej0wEti2JS+VQ2DkDOTlsnTvmdkG3LFeJtIWboU+tI81HdfyuH6zPTdz5U
         DKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iJYisT0ld7Chsu+T6PQppbIhzPNs7ZAW74mwSHZMRlU=;
        b=ciczWKqXJ4uz39Shc7OkO5+2EyRn9wu+ub+QHQpE6ZePdS1IHdOK1/JzC2fmtjxpzq
         6xhsO9E8j6JnLMpDXuXjZ/JpbjqNuR205YUp38ro+xlv6wKWyRyzaUGsD3gb9nfEUsVR
         t4YMyEDA6GEMaPNqhc1uC9PfYCzzs13jF7dav3a7l1wNwNTZF83xCKkUhX3DDm++hgHT
         H8FBjkv8guPfxlC1ysv6tSKd8CfWTp0S5zNLzaRcB4UcBPapJjW4IzBaQWkVaVJx1lHF
         Zw3vgEyNc4gUWtOKgfUyyOUexfQ1nsm9JrL578BqUws7brdgzLDDordQwfVK7g78rE71
         NW9g==
X-Gm-Message-State: AOAM531iFTO4Qi8+A2F47jXs9ucTODUweuyhAZbhqiBZF9Gzvxa7IsMx
        fzdG95K2N3h0k9/pH5V+0/K2Z5dtXhs=
X-Google-Smtp-Source: ABdhPJw7fXZRxSDyo2B3kKtdQsFm1FeAyBpoI5rb5SC7QfGA1PXqsNDz9ZV6o/Yz8qB7ajZpoXA1ow==
X-Received: by 2002:a17:90b:3887:: with SMTP id mu7mr9550436pjb.89.1637233697464;
        Thu, 18 Nov 2021 03:08:17 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id nv12sm2641449pjb.49.2021.11.18.03.08.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Nov 2021 03:08:17 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 02/15] KVM: VMX: Avoid to rdmsrl(MSR_IA32_SYSENTER_ESP)
Date:   Thu, 18 Nov 2021 19:08:01 +0800
Message-Id: <20211118110814.2568-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211118110814.2568-1-jiangshanlai@gmail.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

The value of host MSR_IA32_SYSENTER_ESP is known to be constant for
each CPU: (cpu_entry_stack(cpu) + 1) when 32 bit syscall is enabled or
NULL is 32 bit syscall is not enabled.

So rdmsrl() can be avoided for the first case and both rdmsrl() and
vmcs_writel() can be avoided for the second case.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 48a34d1a2989..4e4a33226edb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1271,7 +1271,6 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 
 	if (!already_loaded) {
 		void *gdt = get_current_gdt_ro();
-		unsigned long sysenter_esp;
 
 		/*
 		 * Flush all EPTP/VPID contexts, the new pCPU may have stale
@@ -1287,8 +1286,11 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 			    (unsigned long)&get_cpu_entry_area(cpu)->tss.x86_tss);
 		vmcs_writel(HOST_GDTR_BASE, (unsigned long)gdt);   /* 22.2.4 */
 
-		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
-		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
+		if (IS_ENABLED(CONFIG_IA32_EMULATION) || IS_ENABLED(CONFIG_X86_32)) {
+			/* 22.2.3 */
+			vmcs_writel(HOST_IA32_SYSENTER_ESP,
+				    (unsigned long)(cpu_entry_stack(cpu) + 1));
+		}
 
 		vmx->loaded_vmcs->cpu = cpu;
 	}
@@ -4021,6 +4023,8 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 	rdmsr(MSR_IA32_SYSENTER_CS, low32, high32);
 	vmcs_write32(HOST_IA32_SYSENTER_CS, low32);
+	rdmsrl(MSR_IA32_SYSENTER_ESP, tmpl);
+	vmcs_writel(HOST_IA32_SYSENTER_ESP, tmpl);
 	rdmsrl(MSR_IA32_SYSENTER_EIP, tmpl);
 	vmcs_writel(HOST_IA32_SYSENTER_EIP, tmpl);   /* 22.2.3 */
 
-- 
2.19.1.6.gb485710b

