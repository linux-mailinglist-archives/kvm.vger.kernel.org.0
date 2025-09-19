Return-Path: <kvm+bounces-58260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CBF1B8B847
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:41:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FAEE1C23D18
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 136BF3016E7;
	Fri, 19 Sep 2025 22:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LKUDVmqh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F68C2D5C6A
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321245; cv=none; b=c7GI6MLqs3S+pyGY9ANFNaZusyk80+2QzpSzXxrCutvYrZ7emD6y58uhEjWUgnnraWlD2dgFAc0yA9JdT/aGI9AEDhSckVDJXAMrxlbC4tN1XYTadIHeiFbqvkBJIdbviHOyIxDpt5PRdGihYrMXtRfrjViGHaif6/G+6Q0OHDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321245; c=relaxed/simple;
	bh=liivkD2MsqpLwGCJVrNrxN8E7SwyK5C61MChMNINjOY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kZCAvFAEYZb7P3c8RelJ1z0PwGdf/0WCEZhRKxV2B5Yb7Wt68Gyj+fzJ5C63Ve4Hl/ZB4OrNXNvaLTfsK54KIIp3UJYnM5DFRuKvw1nRDWUen4rPQayfxCQmUQwBcQUHRwU+OVdl0ObwqqZyfXjQttihCl7rnHEJjW4Qy3aOLAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LKUDVmqh; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24456ebed7bso32558165ad.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321243; x=1758926043; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0u2emdWv4LJCkX3/GzXPUbBO/xRx/hEuovhR41KDWCg=;
        b=LKUDVmqhRvXlDCRmgC6TkwtyjADZyB9fk6eaa1CG5da7e6BNkqUT+JGzjtIjveB9HA
         bErBq1BGZNYrPFqO2Suvxt2WmsE+G8kv4bgEmsUx+deKTuy/tB1ajkEDY0xLqr5RIeqU
         ArCP9uJm1NJpOoPE5f2Av8Ylnem09yPqJteVEuPMaYA/KjwSHhJbIvsFftIpCcUWxujC
         fOcgNd9tSu3i3+Hc/nnng5SqOtxeQm/7ZUAPLBwEvESpiQx/RibEoIJ8tTBR6F+DOmZR
         mN1cWjdtfnH6G8Xw+7StHutcsa3ynUWhn3rn90JHfIjjHfb9r8MUPJ3GCeOGZcBxRDFX
         chRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321243; x=1758926043;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0u2emdWv4LJCkX3/GzXPUbBO/xRx/hEuovhR41KDWCg=;
        b=ovtn/JaZVnZbtxWXpR6FjxQWflmXB6iixt3dQ3ML3scsEQOcgkkEsjUlDz2gVll2q/
         EoeUjyacfr2cnwwavhsz9+fy0if1bNbfMG6XfAlTzugEnk0kyTFzmP0rIAUNHsDdY60j
         MEhAf1JR3kHOWDDhe8VgxQny/McmivrOGCtsqz89qBqjK84UCM2DUr1IF0Uu+Zkklkfg
         h5mvSsqB5gO8T+C8rT5vVmMdxgA52idwP5Xu603h4r3BXYfTEz+SVgNzBklvqXrRzffm
         /UbwMqykqyFPKeMag+O5gPRrBWKoKn9qj/BlweH1KtM2N362guOBfNZdDo5s1z/9cx0w
         00OQ==
X-Gm-Message-State: AOJu0Yx0TQWc+l3I4ap/eFR4MaRqNQz+cTGvK1FJVCgvPtBPSeU8KD2C
	0uDXtZZ1WXXfZbkRipOIyxi466kG84tk0FyetdRv26KlVMCr+jb5yALpmoJJwWajnRGKL0SsfDC
	91JHRWg==
X-Google-Smtp-Source: AGHT+IG5sdiBPwA2Lix0aE9raqNglr3WYY6sj3IuSv2sReZLDTfZVKav/7O5SaoZ8QFqPdo0OED04WXksHw=
X-Received: from plbix21.prod.google.com ([2002:a17:902:f815:b0:267:f10d:293d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ea91:b0:267:8b4f:df36
 with SMTP id d9443c01a7336-2697d7c0483mr83102665ad.29.1758321242906; Fri, 19
 Sep 2025 15:34:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:39 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-33-seanjc@google.com>
Subject: [PATCH v16 32/51] KVM: nVMX: Add consistency checks for CR0.WP and CR4.CET
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
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
index 11e5d3569933..51c50ce9e011 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3110,6 +3110,9 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(!kvm_vcpu_is_legal_cr3(vcpu, vmcs12->host_cr3)))
 		return -EINVAL;
 
+	if (CC(vmcs12->host_cr4 & X86_CR4_CET && !(vmcs12->host_cr0 & X86_CR0_WP)))
+		return -EINVAL;
+
 	if (CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_esp, vcpu)) ||
 	    CC(is_noncanonical_msr_address(vmcs12->host_ia32_sysenter_eip, vcpu)))
 		return -EINVAL;
@@ -3224,6 +3227,9 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	    CC(!nested_guest_cr4_valid(vcpu, vmcs12->guest_cr4)))
 		return -EINVAL;
 
+	if (CC(vmcs12->guest_cr4 & X86_CR4_CET && !(vmcs12->guest_cr0 & X86_CR0_WP)))
+		return -EINVAL;
+
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
 	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
 	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
-- 
2.51.0.470.ga7dc726c21-goog


