Return-Path: <kvm+bounces-63561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1735DC6ADF6
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:15:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 9FA692C414
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 422E23A79C0;
	Tue, 18 Nov 2025 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BvFGrTQ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BD53A79A2
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485884; cv=none; b=nE80iI5rwNOF/zw6vcW7LgEBwbLS582h440fMZYwUbrLrxx7JXYLFKu97gfPCfSh5JuySoJxbAPLXyiEoeKR0l7CKAz/OPoeoQQR2U5k23XMH4s8WChQMR2Y5c9ZFWBQrKOIl4WmQB0Rz8Z6uuLGYzsBADbq/+qi923Ux8pS4VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485884; c=relaxed/simple;
	bh=GTh03DnovL1IfXrIJWOOWsXVB4KulpyzdpPOxbFjAXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IeVDcSFbruvkJWcQoc/Tn9mNurXGWv8tQj9PfDPemquAIFR8XrpgvNICHDNXjeO0pSX3kNd/6cHEViGUNFcNaCVCAOEZJ92Xu6fY8OO9fkg4JMDWAL/rICtdLdgg5fB+AC3HC1NmtwkdJAq4c2NodL2CHokurCzqulI8wZyRPUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BvFGrTQ4; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47795f6f5c0so26422075e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763485880; x=1764090680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2msaF/pghuykVBiKeYLpA2uXeztIpV3HBLG8Kfba9b0=;
        b=BvFGrTQ4pfCkJK65Z3g55lBEsQMtMyGz69ZKdp69o9CBY3fJVWw4hKuJLPc7tniSFf
         IZZNuD1qJCkpht/w23hiHkZmloleFvxU+1uBZYhLt3MxilNGX+QIoNiHeFhh2eLzQ+tN
         1Q8Cj+BbRzXmht8P1idLA0gEnbhabA4+cXlpt1BIpZrIovBmmvZEr0/xu6TCtExfh2R7
         cMyFMC/LkB9+V6fmjeCQ1ySs2V0CX7TtC8uO16Foz8tSQ9RMcZRcBicJ1e0tUeA185Ql
         5fyQDPba8jatX0HUScKhXa+B73rSgOR3pWEgXK1Jhq/ztvdLtsBH3JYuRvOW/r7P/WL/
         JMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763485880; x=1764090680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2msaF/pghuykVBiKeYLpA2uXeztIpV3HBLG8Kfba9b0=;
        b=SwlRj4ZgyQt2VPqdE3k1CPR+/rtZYhmFLcVHjMaTrgTaKUxo6ExgO8umyiY/eiFpzJ
         Fqw/huFVVKEMSrute0Snnp+uiIFB80iHOhhM0dmeFH+ZAsgOXU7tZgL1lAzjbPnbuSX2
         R5uQy1hAK7A4ZZmNlbjR1/BS/N5O569vBVytqBUFqXHbfiSGJFn8zYTG/ZaACwpMtaEt
         1UR7n6Ck5zZVz6wdrl88foQHYl7dy3Td0wdknAm2dqGS3ViTGzaRJoX6UY29Zpgsja53
         oEHpIjTKQZcjyiLauSmDSFPudir4l4JSelsCHW4H6xGhG7Xtt9ZgPtheC7Zs/NbRpnMS
         72nQ==
X-Gm-Message-State: AOJu0YwT41+qXni0GOwWz6w7hEOMsAORrEVI+CmPngVFZY00+kENxNZA
	Tju17FBWHQDaQBC208gfbC7UCbM0+qWmDzDH1R5wAX2qD6bOs7bGuPNwimSEjSvcuA9BVA==
X-Gm-Gg: ASbGncu+3lp85qXjRwAvhHkQHDVv1qOyAW0mkO/j5s/bu74DIUJDUr4o6hg2n0m2YyL
	nxcvbVf2TeJICciV9UMLpHu3H8Ii+eK4eyNMtCQvVt6pAIUdd2NVzo3Nu4JUpE7ov2at8HPQXu9
	f5RF8hEKOqF5kN60GQ8PDTNMNJ+yeuCN47Zt9/jvh8Yu+KXjqA5KVRS6MBd2xUPXNq8+lz9Ib6s
	OTuvqzWhb1qERvxIzhub52NfSF4JX75lK3bZhp+h3USsmFyjhxzh7tVMRibDlXZ2hdiUGB5neLp
	1T69ybC2WD/6W2kG+IPQQvv1SpT/7D7JytBI0/Gdgky7Dd/R7d//TeFPey5cRWyIc5O+zgXrJyx
	iXN1zk9W2eNUgBZCe5OtTmevIXj130nJayUJxigLFWTKZq5BaPtW1D3ca4ysiSdtljWfeGgFjaG
	1dsp0kdFV3PFNvHXY8xBZdUYLY15J3O/3DepKW3COX5y3rGAhOkDKtow6RWdPbgep6FFgCSdz6a
	EYOeWPpVO+XBa9YMQvCmjqws1haWbGD/VIbZiQKjmI=
X-Google-Smtp-Source: AGHT+IHdXnNaex4ngSMgitg8wwk6Na5e/foyybWKk5KGf3oOduiN1nkUwKeEG02d7fZ9hcGJWmLqmg==
X-Received: by 2002:a05:600c:3baa:b0:477:54b3:3484 with SMTP id 5b1f17b1804b1-4778febd2eamr153120225e9.37.1763485879789;
        Tue, 18 Nov 2025 09:11:19 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b103d312sm706385e9.13.2025.11.18.09.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:11:19 -0800 (PST)
From: griffoul@gmail.com
X-Google-Original-From: griffoul@gmail.org
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v2 01/10] KVM: nVMX: Implement cache for L1 MSR bitmap
Date: Tue, 18 Nov 2025 17:11:04 +0000
Message-ID: <20251118171113.363528-2-griffoul@gmail.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251118171113.363528-1-griffoul@gmail.org>
References: <20251118171113.363528-1-griffoul@gmail.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

Introduce a gfn_to_pfn_cache to optimize L1 MSR bitmap access by
replacing map/unmap operations. This optimization reduces overhead
during L2 VM-entry where nested_vmx_prepare_msr_bitmap() merges L1's MSR
intercepts with L0's requirements.

Current implementation using kvm_vcpu_map_readonly() and
kvm_vcpu_unmap() creates significant performance impact, mostly with
unmanaged guest memory.

The cache is initialized when entering VMX operation and deactivated
when VMX operation ends.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/kvm/vmx/nested.c | 42 +++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.h    |  2 ++
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8b131780e981..0de84b30c41d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -315,6 +315,34 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vcpu->arch.regs_dirty = 0;
 }
 
+/*
+ * Maps a single guest page starting at @gpa and lock the cache for access.
+ */
+static int nested_gpc_lock(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
+{
+	int err;
+
+	if (!PAGE_ALIGNED(gpa))
+		return -EINVAL;
+retry:
+	read_lock(&gpc->lock);
+	if (!kvm_gpc_check(gpc, PAGE_SIZE) || (gpc->gpa != gpa)) {
+		read_unlock(&gpc->lock);
+		err = kvm_gpc_activate(gpc, gpa, PAGE_SIZE);
+		if (err)
+			return err;
+
+		goto retry;
+	}
+
+	return 0;
+}
+
+static void nested_gpc_unlock(struct gfn_to_pfn_cache *gpc)
+{
+	read_unlock(&gpc->lock);
+}
+
 static void nested_put_vmcs12_pages(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -344,6 +372,9 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
 	vmx->nested.vmxon_ptr = INVALID_GPA;
+
+	kvm_gpc_deactivate(&vmx->nested.msr_bitmap_cache);
+
 	free_vpid(vmx->nested.vpid02);
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = INVALID_GPA;
@@ -625,7 +656,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
-	struct kvm_host_map map;
+	struct gfn_to_pfn_cache *gpc;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -648,10 +679,11 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 			return true;
 	}
 
-	if (kvm_vcpu_map_readonly(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), &map))
+	gpc = &vmx->nested.msr_bitmap_cache;
+	if (nested_gpc_lock(gpc, vmcs12->msr_bitmap))
 		return false;
 
-	msr_bitmap_l1 = (unsigned long *)map.hva;
+	msr_bitmap_l1 = (unsigned long *)gpc->khva;
 
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
@@ -739,7 +771,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
 
-	kvm_vcpu_unmap(vcpu, &map);
+	nested_gpc_unlock(gpc);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
 
@@ -5490,6 +5522,8 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 
 	vmx->nested.vpid02 = allocate_vpid();
 
+	kvm_gpc_init(&vmx->nested.msr_bitmap_cache, vcpu->kvm);
+
 	vmx->nested.vmcs02_initialized = false;
 	vmx->nested.vmxon = true;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index ea93121029f9..d76621403c28 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -152,6 +152,8 @@ struct nested_vmx {
 
 	struct loaded_vmcs vmcs02;
 
+	struct gfn_to_pfn_cache msr_bitmap_cache;
+
 	/*
 	 * Guest pages referred to in the vmcs02 with host-physical
 	 * pointers, so we must keep them pinned while L2 runs.
-- 
2.43.0


