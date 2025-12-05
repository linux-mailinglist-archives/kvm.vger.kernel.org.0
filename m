Return-Path: <kvm+bounces-65383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C45DCA99AE
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:20:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5AA8D302ABDE
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0AD12F9DB0;
	Fri,  5 Dec 2025 23:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q/1uz9Xi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B08B2FFDEB
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976766; cv=none; b=dIbRwA/gcE4fAlqetiArLtQUkjUBhkQomQTeBT/SJ/DKtm3gUlV1wJCJZ5QaxRMpr5A1n5RFbKH99aoUvddA3VHlSQ7JkRWiyJgXham1+Uw5EAFu0F7jA6TyrjehVgvRnQYsQFYNK9NKhsRbYmFgROCcOiprkp4qTy1USUOx5eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976766; c=relaxed/simple;
	bh=exo09ceDmXypfTxtCerCEjZOA8vfVIz2MO3bU0BfyqM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BRK5b643m0u7+ek/yqCxX/Q9KH1vgAf3GZh7iaPeGTo96fOK9S9nMF4yyad6iwb53dLuX73vc+4PKrUYMJ/b5f23Arc5soCxoUmv2AbDAzHgkSW0ewHttVI7R+8BfOynTB0k6+CzY8nsaaxkFnWLfTHc/yqX3ShkBZF2vXuEES4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q/1uz9Xi; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9090d9f2eso4850566b3a.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976761; x=1765581561; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZcJtGX0VmRX2lzBpy3LVmAgEJDoeGm/VKWbOEKmvPbc=;
        b=Q/1uz9XivDHtxidfZatlGz3AlOkrPxeNxWEOD8cuNTAKLc+PmwMHG0/1tldCQ54uQn
         gkIKuLpntMG766ZSjv0NhaNv5t7QfuvIoobCwaaMjunWUoWGOBr9CUmltTeo/RY9bd3M
         m/uHmzl4pGkM8f1K0jcaxE1XVEGz87MBvWx2c/hYWwhucBEfpuk1pHJayz0K9nfz10AI
         pwUDhSHVpj5Tu94Ulh+bfqmIacP4l2vBsNAXw1i0g003jKMyueZx/GqyGnT/Km8oC7IA
         cj8TsGWWR0TaIwj9BF/c+fpC/kf/KocyC486MOKFOCfmHdJRiGpMtRXHMUCsARtnzZT/
         IlVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976761; x=1765581561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZcJtGX0VmRX2lzBpy3LVmAgEJDoeGm/VKWbOEKmvPbc=;
        b=fA8XXX2Vunft5Lr4HJ1P55PPpVsl+IS4a6USD5iTEyouazz/UHU9sydnDUx3PQHPwd
         bTjSS4jg0ZYDiOYHpj886aB3G92tMmvndMhWDhmxCjnFp4hxpzduNe2PzD1ZlzSJScVJ
         2YoTASgwS2Y8QrsfdXGkT3A7BlwgSzuYgl9yE0cUVMcbPFf0fhHtREElnA3SBI0eA2r6
         +UpwuSY+9p56YBMNuS/zQ0oEnmpxBIUonL8TEGmRou/0LKjWEqKzbtBiE0qq4pvy/wZg
         8MsOpXodUy2uvJOewoZTZ23zFdd8/ED1m6efhQgjxaRRNgCkOtDED01SBJLg4wVnVUwV
         1CTw==
X-Gm-Message-State: AOJu0YxMjdAAYKsfwQva4CxmGfsrGTh1ZMj37N2GhnqQR4uxYCeabKqq
	yi3YeBNsdJzIZAAtq4W1u5uwOA51UuB2JLel8KIjtLhHEO+OJmVnh+SE4Hds6WxQhOr03KPQjle
	PLOAeew==
X-Google-Smtp-Source: AGHT+IH0SYz00lEf7HVPssFZvqoZIZN/mMz1YTgzQllfd0G4FhVaPgZKdiRo2+ZPkMMERZPCk7sSwMWCPk4=
X-Received: from pgam21.prod.google.com ([2002:a05:6a02:2b55:b0:bc1:99a7:3f1b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e211:b0:366:14af:9bb8
 with SMTP id adf61e73a8af0-36618017e9cmr908273637.66.1764976761202; Fri, 05
 Dec 2025 15:19:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:05 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-3-seanjc@google.com>
Subject: [PATCH v3 02/10] KVM: nVMX: Immediately refresh APICv controls as
 needed on nested VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dongli Zhang <dongli.zhang@oracle.com>

If an APICv status updated was pended while L2 was active, immediately
refresh vmcs01's controls instead of pending KVM_REQ_APICV_UPDATE as
kvm_vcpu_update_apicv() only calls into vendor code if a change is
necessary.

E.g. if APICv is inhibited, and then activated while L2 is running:

  kvm_vcpu_update_apicv()
  |
  -> __kvm_vcpu_update_apicv()
     |
     -> apic->apicv_active = true
      |
      -> vmx_refresh_apicv_exec_ctrl()
         |
         -> vmx->nested.update_vmcs01_apicv_status = true
          |
          -> return

Then L2 exits to L1:

  __nested_vmx_vmexit()
  |
  -> kvm_make_request(KVM_REQ_APICV_UPDATE)

  vcpu_enter_guest(): KVM_REQ_APICV_UPDATE
  -> kvm_vcpu_update_apicv()
     |
     -> __kvm_vcpu_update_apicv()
        |
        -> return // because if (apic->apicv_active == activate)

Reported-by: Chao Gao <chao.gao@intel.com>
Closes: https://lore.kernel.org/all/aQ2jmnN8wUYVEawF@intel.com
Fixes: 7c69661e225c ("KVM: nVMX: Defer APICv updates while L2 is active until L1 is active")
Cc: stable@vger.kernel.org
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
[sean: write changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 40777278eabb..6137e5307d0f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -19,6 +19,7 @@
 #include "trace.h"
 #include "vmx.h"
 #include "smm.h"
+#include "x86_ops.h"
 
 static bool __read_mostly enable_shadow_vmcs = 1;
 module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
@@ -5165,7 +5166,7 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	if (vmx->nested.update_vmcs01_apicv_status) {
 		vmx->nested.update_vmcs01_apicv_status = false;
-		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+		vmx_refresh_apicv_exec_ctrl(vcpu);
 	}
 
 	if (vmx->nested.update_vmcs01_hwapic_isr) {
-- 
2.52.0.223.gf5cc29aaa4-goog


