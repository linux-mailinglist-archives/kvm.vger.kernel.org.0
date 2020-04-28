Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466A51BB673
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 08:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgD1GXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 02:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726430AbgD1GXn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 02:23:43 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB202C03C1A9;
        Mon, 27 Apr 2020 23:23:42 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o15so9829103pgi.1;
        Mon, 27 Apr 2020 23:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pyGp7grSiZpObxZrTgZ2GmGoqZvme1lxk38SftFA0lc=;
        b=fECfBrBsZgxeek/QXB19YDGD3bP/vi62URcqoJCCJ5xd9hmkWUhcgCZoLFdi1Full4
         AGxSqhCBJ2KL700zuXaAxmVO+kGsiTMsJmHMLc02bCz06rivuJ0liO7jnqcylYvn0Fe/
         wtMANRLPEI36qRmGcYb3ZE9zGV5aVES+6GETcZt3qCIha0hf4c75VvGq5Ck6AspiLb4v
         dm+EB4lKPMUVv6eCoLY/IoLFXqAc1gpy2XChp5GOq48ZKaX6xhSQjXUqSk2IS7v/gfzo
         x3/HCRnQq7rRz7dD+3JqPvoD6xAO0DWBBWXF1oKulvsU1K3570Zxj1wOVg1P7fhKj8NJ
         j20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pyGp7grSiZpObxZrTgZ2GmGoqZvme1lxk38SftFA0lc=;
        b=XS3ScyHGkc9Iexm+R6U1OMUUd8GqvJyyzb9PGu/1XOIXFjOZrq6TMtAn2OoM55H5ys
         +9MT90OPeBenzbtNP5dmk73iLub3Fw6QEW5ewYnkLi32WoE7bXJgjRNXe099VTBOFCrr
         DWG9Z/vo2noxt0cQCwlUUa29KQbsfDuYSN8s5fK7nXFYMyQf7LpYbpyQE6Ax/jBB2IGW
         3Jr476DWsfTW9MUvRSrhWDLM00DSofwf0NkIjiFJwkufGDX4FG3CaZ2t9kcFZyDTZDBN
         l0x8SjLPgHSXFgZL+ut1JyA8WqS73gl0AJK9YTII46XtiTyOM6JQTa2P3g3QcA778H2z
         VdMA==
X-Gm-Message-State: AGi0PuZdp51mWWW9qcg8afCEtMNd2Pi9ASIbR8NZq6Sqbx6VtipvrckU
        Nd6psVRlLinVQv+J/kSL1MMYZneI
X-Google-Smtp-Source: APiQypJqZ0BVbucsAJwdJGRtBft0EMYZR73UQsT9HphY+32jtWyJpChDnKfKU38CrAV0Ime3auGDfA==
X-Received: by 2002:a63:e60a:: with SMTP id g10mr10237869pgh.51.1588055022101;
        Mon, 27 Apr 2020 23:23:42 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id u188sm14183071pfu.33.2020.04.27.23.23.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 23:23:41 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH v4 1/7] KVM: VMX: Introduce generic fastpath handler
Date:   Tue, 28 Apr 2020 14:23:23 +0800
Message-Id: <1588055009-12677-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Introduce generic fastpath handler to handle MSR fastpath, VMX-preemption
timer fastpath etc, move it after vmx_complete_interrupts() in order that
later patch can catch the case vmexit occurred while another event was
being delivered to guest. There is no obversed performance difference for
IPI fastpath testing after this move.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/vmx/vmx.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3ab6ca6..9b5adb4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6583,6 +6583,20 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
+static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+{
+	if (!is_guest_mode(vcpu)) {
+		switch (to_vmx(vcpu)->exit_reason) {
+		case EXIT_REASON_MSR_WRITE:
+			return handle_fastpath_set_msr_irqoff(vcpu);
+		default:
+			return EXIT_FASTPATH_NONE;
+		}
+	}
+
+	return EXIT_FASTPATH_NONE;
+}
+
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
 static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
@@ -6757,17 +6771,14 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return EXIT_FASTPATH_NONE;
 
-	if (!is_guest_mode(vcpu) && vmx->exit_reason == EXIT_REASON_MSR_WRITE)
-		exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
-	else
-		exit_fastpath = EXIT_FASTPATH_NONE;
-
 	vmx->loaded_vmcs->launched = 1;
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 
+	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
+
 	return exit_fastpath;
 }
 
-- 
2.7.4

