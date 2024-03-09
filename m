Return-Path: <kvm+bounces-11422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4195876E64
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 02:10:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92A611C20B97
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 01:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1336DEA4;
	Sat,  9 Mar 2024 01:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oafOSacE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32F2107B2
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 01:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709946584; cv=none; b=MRp/1NogShvHydZjM19lxFAkeFW6jh7Ss3tTpbywsj30DbKqTwWRlEEIP3za8P5ihecBzGWYUb/4SlPokUkWQ8BNLGH6OzREvo+P2FnWFEBRNwAsAiqN3628mLEktBiT/0Yg8f/bHzblK0dx+8sp1AYG719HMyNyia5hmn2iy1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709946584; c=relaxed/simple;
	bh=56l3qV2E5YVzJsQoDii+3QTD/H2MArANKbGDDmYY5so=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NhktvjQcoCZQe26ZYZTDlTWtSXCVkosI4amFEbq2o+voYK67qiwtxzqpPoUzYq5VT/UfY7XI8vIkla30ziIOl/eKzk6J4xoOCqwSrk4IBihtgFIjbNGQcEYXFvPC6SUlxneT6kXc7I4TOpCNwE3THvyi8iMxegF/fCcwG6wedqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oafOSacE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1dcfc3ae5d9so22985155ad.3
        for <kvm@vger.kernel.org>; Fri, 08 Mar 2024 17:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709946582; x=1710551382; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GtHnwYnueCwfZNon9qMZcoozTyyxAoukw9Anit3u7vs=;
        b=oafOSacEr89Bk3J5cq5t8nmdq41sepaBeNz8HU5f5vzRDN8BBvq4l/eaSDWpShrH5r
         OdvotphgRMvgz9qyqEspKdusQ0VPw74L0YH28DLOGSaaLOj5CJM/1sPk/lZ9ooGJCw9h
         IJ2pany68EbuPaO6bysK6e02QYsvuV0iLRxwBWe4Srf+K4AWuhSUbn2G/7kyYMvu5hN9
         pMIIp+kdWjINVBf107hWv/xjKMTKCDvz8sMSu04LOUb+9UsC4FPWTA2hQC2VNpNFSWEq
         1Ld0U9w1kv4WsYmxWs8NqKNRxR1uidiuqEq3rRXVo0ELYGWJX38zh9ZSHXiBM1yvk+f2
         0sLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709946582; x=1710551382;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GtHnwYnueCwfZNon9qMZcoozTyyxAoukw9Anit3u7vs=;
        b=IdPPPDlrTtxhx2oHNtod4UopNFtZn1lXUQZmL9OeDprGSYBy6hF/yxFX0xtpo0YBr6
         i9P1YILxgXnwjeCo6n5t77C4J+FiJkJfotGVdQGhenyzpGtldKOz61G7kzcZb8D9mdMD
         5QwcuRwd1tDV74YFeuKRtZ7j5g5N82lG2QLf4gBL+JU9VIfSDbfatuhet1oJw8n5bW9Q
         89PZDyss7+Y98Uqgsq2R7jiCluNCxbbsGrBv3nIGonvziGOQr/x285ME37grd6WOboKG
         7mZDIux/tjb3iYgGkFRxsH0EYw0L4VWK16Cts8O2KcOQLFuEg/tc9uduokTgzfcv2Qq8
         9gsw==
X-Gm-Message-State: AOJu0YxVgf28GcmA1NG8xV4pT4er2yVyIWKNYJoduJCI9EhdK1Wo7wdI
	GS/iz1inKWpKuSeUkUIT7sGgFPHHfylwbea0J4CU0/2MflJP4iZ7CrznNxtIBZwxZVi9ohhvUFf
	ovA==
X-Google-Smtp-Source: AGHT+IFcax0jBBlFuP0Y7Y0xcnqeeeJ7WiLfIus4V6pgH0oz7sMxr9KM4LErcwOoG2CptIvrKKjnya25r1o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4d0:b0:1dc:8da7:9d0b with SMTP id
 o16-20020a170902d4d000b001dc8da79d0bmr5416plg.9.1709946581833; Fri, 08 Mar
 2024 17:09:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  8 Mar 2024 17:09:26 -0800
In-Reply-To: <20240309010929.1403984-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309010929.1403984-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240309010929.1403984-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: VMX: Drop support for forcing UC memory when guest CR0.CD=1
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>
Cc: kvm@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop KVM's emulation of CR0.CD=1 on Intel CPUs now that KVM no longer
honors guest MTRR memtypes, as forcing UC memory for VMs with
non-coherent DMA only makes sense if the guest is using something other
than PAT to configure the memtype for the DMA region.

Furthermore, KVM has forced WB memory for CR0.CD=1 since commit
fb279950ba02 ("KVM: vmx: obey KVM_QUIRK_CD_NW_CLEARED"), and no known
VMM in existence disables KVM_X86_QUIRK_CD_NW_CLEARED, let alone does
so with non-coherent DMA.

Lastly, commit fb279950ba02 ("KVM: vmx: obey KVM_QUIRK_CD_NW_CLEARED") was
from the same author as commit b18d5431acc7 ("KVM: x86: fix CR0.CD
virtualization"), and followed by a mere month.  I.e. forcing UC memory
was likely the result of code inspection or perhaps misdiagnosed failures,
and not the necessitate by a concrete use case.

Update KVM's documentation to note that KVM_X86_QUIRK_CD_NW_CLEARED is now
AMD-only, and to take an erratum for lack of CR0.CD virtualization on
Intel.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst        |  6 +++++-
 Documentation/virt/kvm/x86/errata.rst | 19 +++++++++++++++----
 arch/x86/kvm/vmx/vmx.c                |  4 ----
 arch/x86/kvm/x86.c                    |  6 ------
 4 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..e85edd26ea5a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7946,7 +7946,11 @@ The valid bits in cap.args[0] are:
                                     When this quirk is disabled, the reset value
                                     is 0x10000 (APIC_LVT_MASKED).
 
- KVM_X86_QUIRK_CD_NW_CLEARED        By default, KVM clears CR0.CD and CR0.NW.
+ KVM_X86_QUIRK_CD_NW_CLEARED        By default, KVM clears CR0.CD and CR0.NW on
+                                    AMD CPUs to workaround buggy guest firmware
+                                    that runs in perpetuity with CR0.CD, i.e.
+                                    with caches in "no fill" mode.
+
                                     When this quirk is disabled, KVM does not
                                     change the value of CR0.CD and CR0.NW.
 
diff --git a/Documentation/virt/kvm/x86/errata.rst b/Documentation/virt/kvm/x86/errata.rst
index 1b70bad7325e..4116045a8744 100644
--- a/Documentation/virt/kvm/x86/errata.rst
+++ b/Documentation/virt/kvm/x86/errata.rst
@@ -51,7 +51,18 @@ matching the target APIC ID receive the interrupt).
 
 MTRRs
 -----
-KVM does not virtualization guest MTRR memory types.  KVM emulates accesses to
-MTRR MSRs, i.e. {RD,WR}MSR in the guest will behave as expected, but KVM does
-not honor guest MTRRs when determining the effective memory type, and instead
-treats all of guest memory as having Writeback (WB) MTRRs.
\ No newline at end of file
+KVM does not virtualize guest MTRR memory types.  KVM emulates accesses to MTRR
+MSRs, i.e. {RD,WR}MSR in the guest will behave as expected, but KVM does not
+honor guest MTRRs when determining the effective memory type, and instead
+treats all of guest memory as having Writeback (WB) MTRRs.
+
+CR0.CD
+------
+KVM does not virtualize CR0.CD on Intel CPUs.  Similar to MTRR MSRs, KVM
+emulates CR0.CD accesses so that loads and stores from/to CR0 behave as
+expected, but setting CR0.CD=1 has no impact on the cachaeability of guest
+memory.
+
+Note, this erratum does not affect AMD CPUs, which fully virtualize CR0.CD in
+hardware, i.e. put the CPU caches into "no fill" mode when CR0.CD=1, even when
+running in the guest.
\ No newline at end of file
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 66bf79decdad..17a8e4fdf9c4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7612,10 +7612,6 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
-	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD) &&
-	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-		return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
-
 	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2a38b4c26d35..276ae56dd888 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -960,12 +960,6 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 
 	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
-
-	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-	    kvm_mmu_may_ignore_guest_pat() &&
-	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
-	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
 
-- 
2.44.0.278.ge034bb2e1d-goog


