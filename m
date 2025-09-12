Return-Path: <kvm+bounces-57465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7221B55A29
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 654F65A1934
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3E82DC348;
	Fri, 12 Sep 2025 23:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hncz5h2x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F282DAFBD
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719446; cv=none; b=op9atR4LSJiptC1j2M8IokvHTcbEhl0TR433S1p/V3b/MPP5bFcmRwn3c2daHP+1mRnxskiOfoQDQle8KBwPrVcuzLehhRG3XM5UjJEgpWGnyv8rNpvD1LmWLYCkP0WIjOvqJhZL8dWkxA6ZMdJ1v+nGEDjbzk8gUgecSmU7CBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719446; c=relaxed/simple;
	bh=+RVQicm4TK8MmrV33Gpsf9YCthCHWpRMM79XaOiiPK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TKaXqgIigHYdHDnIVCy1/dB2o+I98u8RFphtegmkw3fF+hlCR6OpAUMBIjAwyeslzoIX9uJf+JX9TAsf/SVm+zLDvnrbiMjfPXBSZ2MHL1SzS35gxYjrwO1eQhFuDm9X/PxdfwvmYRNLVE4OoxW3rOxKU+swAjdXd97IyqdzOao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hncz5h2x; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-244581953b8so27741765ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719444; x=1758324244; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fLo/SEqM2VBVejoE7ds3n2zise52/J9CjN3ZQw5EHn8=;
        b=Hncz5h2xZGe2PAnu1O5UjGIJHeeADLi6aJyi4xVlL3YhNwIBaEApiW3NBeVHvpntTc
         2fN+Giws4icktUhMXKG/0x4gvX6cVPhGZ5zha5COeFa3c3YtJ6m02I9KFg5cjIfewYnW
         TBgrlSFnOhM79pScXRQUhsQoUfE0KSP3rzUZ0mDu69lXvTu2JdQ23hXI4vuWbtsmsoMH
         srYZ+UHCkm9Jgap7nSk8H9LOrEx3JNJ2YshD4L8pVmt6BTpP0lvIqp4NehXIHyR99TyU
         2wkIJ5AsjTHabc8t1U3MO/8yMTl5GuPEd/Fqfif3GCwNAPpismPVB+WgRK1ibBbh6x0f
         IaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719444; x=1758324244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fLo/SEqM2VBVejoE7ds3n2zise52/J9CjN3ZQw5EHn8=;
        b=UrPhKDGElO8jMiEud2xcrxZriZHhz4CHN+CK0dVhsBWNoZITFiJLVz9Yod8NbXZsZ2
         br1ddFqmfTB2YOPoKq97OI/bB5UFUuihq76M2WWBtr5angE5MVZX77G3x02N1PaJvJr7
         OoLDI6zfroaY8cycWw8ZRn6aIX4wzlDCHUJ4Keu7IqiA0mb3Apx+cV/HsTpv9egakV52
         q8ppMM4Hx+jy9jl/EjXwc1yOt3oSrXioMnFNxPW3wTb3VL+jx6XWuKEgiJ7WxQ/BofJa
         07lU070jNr61OcMRwV++OBLclWbdLNLtslAW0oRpe5Lxejo4DPlUPgV/ixP2SYrmGTC5
         Xq2A==
X-Gm-Message-State: AOJu0Ywnj/LvteRaW4+82kMfA7W5CM+Z0/DMFJvwS34FgdNqGhse0ANF
	+LFBNQgWmzZh1DmAC+SxLNNNGiGvp2Q0v6Jscv7SF/6bKrDhc42ORkTZcksuRKMoSBcxlGxSlva
	Mk2UXLQ==
X-Google-Smtp-Source: AGHT+IFZ66G99jqjCPVcjm61uKkUswQxYM0js2Pq9O0QazFOGhxlaYFTFHswXm9x+i/mLtHDJdlNTlwG258=
X-Received: from pldr19.prod.google.com ([2002:a17:903:4113:b0:249:140e:945a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f85:b0:249:1f5f:f9a2
 with SMTP id d9443c01a7336-25d21112648mr41894805ad.0.1757719444289; Fri, 12
 Sep 2025 16:24:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:00 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-23-seanjc@google.com>
Subject: [PATCH v15 22/41] KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Chao Gao <chao.gao@intel.com>

Add consistency checks for CR4.CET and CR0.WP in guest-state or host-state
area in the VMCS12. This ensures that configurations with CR4.CET set and
CR0.WP not set result in VM-entry failure, aligning with architectural
behavior.

Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 51d69f368689..a73f38d7eea1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3111,6 +3111,9 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
+	if (CC(vmcs12->host_cr4 & X86_CR4_CET && !(vmcs12->host_cr0 & X86_CR0_WP)))
+		return -EINVAL;
+
 	if (CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
 	    CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
 		return -EINVAL;
@@ -3225,6 +3228,9 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
 		return -EINVAL;
 
+	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
+		return -EINVAL;
+
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
 	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
 	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
-- 
2.51.0.384.g4c02a37b29-goog


