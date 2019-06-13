Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58AC044845
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393332AbfFMRGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:06:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40931 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393320AbfFMRD4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so10887326wmj.5;
        Thu, 13 Jun 2019 10:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x14d8bwpbaYSOsqc0qxaw77GBnVeF84fkd3UjeGCouc=;
        b=N+SwuiQ4kBQtev/e/3Sgkc5BXxSacHOyyPMIgCd2F5EgEstvbr40sKac8p2o3h6MrY
         35JNXrrgasNcLtnoql0z7OMdoaYhJII5Rdma3zm8TcIbOXnHaCWehE0GCuSg6vnx4Uuf
         x0I1nPDZ8D3ysISkyY95VY5XRPbUSilP2ZMFr835FgHRPt0cl5y0kOv1XDCppvA0DD5B
         lGQbK1JBX00u8ZFXErOG8M+gDxtfPU72mPatqhcYXjS5B/0fr6TcbfAQMDUFY+mIdlUh
         Fhus7gWFkZYofyfOhLx+utYG034LJFrxUB+NiiFYKAwihunVS4lUlI2in9qxMKHgMGkf
         mWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=x14d8bwpbaYSOsqc0qxaw77GBnVeF84fkd3UjeGCouc=;
        b=axSdmobQc1p4BliltvkSYGTQPPUPRbYRFgAckGO4Ld7jL0PuAM8XASHrUsMfx8O78Z
         BkXEsnItpmV4tMupKZKVhIpmx1KfU2VBzAgeVhVQcUqcxqy9emYx6VIYm9JYPg9NUp7A
         3MzQpJ76DDkUFfjlBjmtjyHaarWHs7Khu1hM+DcooNjDg8zkwxVAmUcUGIelsN96XYlN
         abBu+c7B65mAPeto1LcZpFLum8Kth8uVFMVgxnFyjiXlt7OtCM05RwA9KtCG/SGPaiOT
         SZ8Mjp1HYspeub6/2ZYke7S00Tu7J4OSxhGjbNQkODiBoOmix/jzGkBHmJz8wsOajM0q
         I2BA==
X-Gm-Message-State: APjAAAU+N73dMatT6bkf+tduYh3uNKygQUOsyOE3KjKEmKJRtdzxXnRf
        7vXxRjaUzVo86u7N/VLP5H7EJLvT
X-Google-Smtp-Source: APXvYqyLfhpZddz5fngjDpWNzTwe2OoVhatVSfC8OlFohU9Cbn9qXF29BY55K3l5HS200YKUQB+4uw==
X-Received: by 2002:a1c:544d:: with SMTP id p13mr4822864wmi.78.1560445434214;
        Thu, 13 Jun 2019 10:03:54 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:53 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 20/43] KVM: nVMX: Don't "put" vCPU or host state when switching VMCS
Date:   Thu, 13 Jun 2019 19:03:06 +0200
Message-Id: <1560445409-17363-21-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

When switching between vmcs01 and vmcs02, KVM isn't actually switching
between guest and host.  If guest state is already loaded (the likely,
if not guaranteed, case), keep the guest state loaded and manually swap
the loaded_cpu_state pointer after propagating saved host state to the
new vmcs0{1,2}.

Avoiding the switch between guest and host reduces the latency of
switching between vmcs01 and vmcs02 by several hundred cycles, and
reduces the roundtrip time of a nested VM by upwards of 1000 cycles.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 23 +++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c    | 53 ++++++++++++++++++++++++++---------------------
 arch/x86/kvm/vmx/vmx.h    |  3 ++-
 3 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 01275cbd7478..f4415756ddd5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -248,18 +248,39 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(&vmx->nested.vmcs02);
 }
 
+static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
+				     struct loaded_vmcs *prev)
+{
+	struct vmcs_host_state *dest, *src;
+
+	if (unlikely(!vmx->guest_state_loaded))
+		return;
+
+	src = &prev->host_state;
+	dest = &vmx->loaded_vmcs->host_state;
+
+	vmx_set_host_fs_gs(dest, src->fs_sel, src->gs_sel, src->fs_base, src->gs_base);
+	dest->ldt_sel = src->ldt_sel;
+#ifdef CONFIG_X86_64
+	dest->ds_sel = src->ds_sel;
+	dest->es_sel = src->es_sel;
+#endif
+}
+
 static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct loaded_vmcs *prev;
 	int cpu;
 
 	if (vmx->loaded_vmcs == vmcs)
 		return;
 
 	cpu = get_cpu();
-	vmx_vcpu_put(vcpu);
+	prev = vmx->loaded_vmcs;
 	vmx->loaded_vmcs = vmcs;
 	vmx_vcpu_load(vcpu, cpu);
+	vmx_sync_vmcs_host_state(vmx, prev);
 	put_cpu();
 
 	vm_entry_controls_reset_shadow(vmx);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40a6235bc4d8..09632b8239de 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1039,6 +1039,33 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
 	wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
 }
 
+void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
+			unsigned long fs_base, unsigned long gs_base)
+{
+	if (unlikely(fs_sel != host->fs_sel)) {
+		if (!(fs_sel & 7))
+			vmcs_write16(HOST_FS_SELECTOR, fs_sel);
+		else
+			vmcs_write16(HOST_FS_SELECTOR, 0);
+		host->fs_sel = fs_sel;
+	}
+	if (unlikely(gs_sel != host->gs_sel)) {
+		if (!(gs_sel & 7))
+			vmcs_write16(HOST_GS_SELECTOR, gs_sel);
+		else
+			vmcs_write16(HOST_GS_SELECTOR, 0);
+		host->gs_sel = gs_sel;
+	}
+	if (unlikely(fs_base != host->fs_base)) {
+		vmcs_writel(HOST_FS_BASE, fs_base);
+		host->fs_base = fs_base;
+	}
+	if (unlikely(gs_base != host->gs_base)) {
+		vmcs_writel(HOST_GS_BASE, gs_base);
+		host->gs_base = gs_base;
+	}
+}
+
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1102,29 +1129,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	gs_base = segment_base(gs_sel);
 #endif
 
-	if (unlikely(fs_sel != host_state->fs_sel)) {
-		if (!(fs_sel & 7))
-			vmcs_write16(HOST_FS_SELECTOR, fs_sel);
-		else
-			vmcs_write16(HOST_FS_SELECTOR, 0);
-		host_state->fs_sel = fs_sel;
-	}
-	if (unlikely(gs_sel != host_state->gs_sel)) {
-		if (!(gs_sel & 7))
-			vmcs_write16(HOST_GS_SELECTOR, gs_sel);
-		else
-			vmcs_write16(HOST_GS_SELECTOR, 0);
-		host_state->gs_sel = gs_sel;
-	}
-	if (unlikely(fs_base != host_state->fs_base)) {
-		vmcs_writel(HOST_FS_BASE, fs_base);
-		host_state->fs_base = fs_base;
-	}
-	if (unlikely(gs_base != host_state->gs_base)) {
-		vmcs_writel(HOST_GS_BASE, gs_base);
-		host_state->gs_base = gs_base;
-	}
-
+	vmx_set_host_fs_gs(host_state, fs_sel, gs_sel, fs_base, gs_base);
 	vmx->guest_state_loaded = true;
 }
 
@@ -1314,7 +1319,7 @@ static void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 		pi_set_sn(pi_desc);
 }
 
-void vmx_vcpu_put(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vmx_vcpu_pi_put(vcpu);
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f35442093397..581f4039b346 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -303,11 +303,12 @@ struct kvm_vmx {
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
 void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
-void vmx_vcpu_put(struct kvm_vcpu *vcpu);
 int allocate_vpid(void);
 void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
+void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
+			unsigned long fs_base, unsigned long gs_base);
 int vmx_get_cpl(struct kvm_vcpu *vcpu);
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
 void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
-- 
1.8.3.1


