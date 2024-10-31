Return-Path: <kvm+bounces-30244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4AF9B8442
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 21:20:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EC5B284D0C
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6592A1CC15B;
	Thu, 31 Oct 2024 20:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SQ69r03r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9824A1CB521
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 20:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730406019; cv=none; b=bKc/zmP+Ln96nsReyZJNvSziuPB2YB3tP77XWI4jpPdyYqk32vZVmOLIPSU7kDCR4Ax8FieQ5qPW9Bpvq2TV+C0he3q3gooJq4beekxApTeg5FffTCjo4gX9W+HKAFvaD5hLgi9i7CrljVsWyA3CdHBqA9gGpJMl6UYqWQQZj1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730406019; c=relaxed/simple;
	bh=ibguVxv5ys3EG+bTYwAwYyEFPl4BfLP061AdL88v55g=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=g/3LV28ZM7eO6GOZHgAh4NoGC0g6wTV4s4MKHu2VYf4V7tduQNS8Z79Oth/yG3lD2ZNAewpKrEai3EDhplLzKJ7KwBBMlwS8obXady+/8Or9PPz9WndeA0EwqtefQY/UMgCtNwBI13d5PIOFicCqLK96HgHD3LSo6xofreKhlCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SQ69r03r; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e7e0093018so26387477b3.3
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 13:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730406015; x=1731010815; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZhenKn3T1lSjjdyHpwG37r5ky1yYEV/H0p+NeciZMA=;
        b=SQ69r03rBEjwIP11WMj2DKbafqz46+LhQnb6q/iFVs3s6UJ2QfGS5qPNTyAQNAtMb/
         9o1AI00H0vylpQE2JDf1iTYVy8Vj8wNW7SEXCDBBABfmeOdVWqYNShOxeIloW3BKFW8Z
         FWEvRN3qwqf8Pw5MIMbNrvCdRAjag64sCDIRwQkO8Qjy9nlggo7YX1638nGvJFx4kIYZ
         nw99Yk7EuwMztnHEsqJv472BvPrJxEtvgmG25/8A58h3HcFIrYxUUgdid3oxGdsgm8dX
         gBm9BXUHrGUlABCRB7z9duLxpvrZlzW87uXeyx/4+q5G8gu6XXMYR/6jF9saNBCvW9LQ
         d5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730406015; x=1731010815;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZhenKn3T1lSjjdyHpwG37r5ky1yYEV/H0p+NeciZMA=;
        b=MEAalQOEJBt0pfa3zVji+VPuLBDNm2aPgLUAmoVQPOUJp0vPq7crjo8hjIgQOr8i9b
         Yh8HZghzhsIy4tmZNUjba/YM6mQdxbdDSCDViAKcxLkfs4eTSX0DxoGHuWxT47h3pXog
         4oYsxyIsO/nO+L+9kYwh6qNg0/n+vBtASLdaI5RgeAcuZYsGpgzgBMoQgdCIuJOLFk8B
         jmcApeLgzM+G9KxqPHIiES318446Mhxni4jvHtH2o+kNwGXW/Ge/iKPtsbfEQfQ393sx
         PUEp32C+CmwnZleJdVzckbTLJ3sde9sN78kGTo8rjAYx7809ujaJSm4+wz7h/0c0oete
         7Bew==
X-Gm-Message-State: AOJu0YyfalDMvvQOsqmt68ht05mY68HLtm0OiwetWF1GBEYT0HAblPrb
	EurZfmv52aaUmrjN9/DeBde+CFzGsbp31X8Nxud4fZzgc4vn6gDd7+QrlvVwBTNVJw8a16Fl0ag
	NMw==
X-Google-Smtp-Source: AGHT+IFrERFxys/nFxJS2UFqRSq8jptFMXlQLla0whmxS+Xa4ijJlHYJjILBUPjl0bRKEkidO9eZEYX5Z+E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a81:a888:0:b0:6db:c3b8:c4ce with SMTP id
 00721157ae682-6ea52557dffmr73077b3.7.1730406015706; Thu, 31 Oct 2024 13:20:15
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 31 Oct 2024 13:20:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <20241031202011.1580522-1-seanjc@google.com>
Subject: [PATCH] KVM: nVMX: Treat vpid01 as current if L2 is active, but with
 VPID disabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

When getting the current VPID, e.g. to emulate a guest TLB flush, return
vpid01 if L2 is running but with VPID disabled, i.e. if VPID is disabled
in vmcs12.  Architecturally, if VPID is disabled, then the guest and host
effectively share VPID=0.  KVM emulates this behavior by using vpid01 when
running an L2 with VPID disabled (see prepare_vmcs02_early_rare()), and so
KVM must also treat vpid01 as the current VPID while L2 is active.

Unconditionally treating vpid02 as the current VPID when L2 is active
causes KVM to flush TLB entries for vpid02 instead of vpid01, which
results in TLB entries from L1 being incorrectly preserved across nested
VM-Enter to L2 (L2=>L1 isn't problematic, because the TLB flush after
nested VM-Exit flushes vpid01).

The bug manifests as failures in the vmx_apicv_test KVM-Unit-Test, as KVM
incorrectly retains TLB entries for the APIC-access page across a nested
VM-Enter.

Opportunisticaly add comments at various touchpoints to explain the
architectural requirements, and also why KVM uses vpid01 instead of vpid02.

All credit goes to Chao, who root caused the issue and identified the fix.

Link: https://lore.kernel.org/all/ZwzczkIlYGX+QXJz@intel.com
Fixes: 2b4a5a5d5688 ("KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST")
Cc: stable@vger.kernel.org
Cc: Like Xu <like.xu.linux@gmail.com>
Debugged-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 30 +++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 746cb41c5b98..aa78b6f38dfe 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1197,11 +1197,14 @@ static void nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
 	kvm_hv_nested_transtion_tlb_flush(vcpu, enable_ept);
 
 	/*
-	 * If vmcs12 doesn't use VPID, L1 expects linear and combined mappings
-	 * for *all* contexts to be flushed on VM-Enter/VM-Exit, i.e. it's a
-	 * full TLB flush from the guest's perspective.  This is required even
-	 * if VPID is disabled in the host as KVM may need to synchronize the
-	 * MMU in response to the guest TLB flush.
+	 * If VPID is disabled, then guest TLB accesses use VPID=0, i.e. the
+	 * same VPID as the host, and so architecturally, linear and combined
+	 * mappings for VPID=0 must be flushed at VM-Enter and VM-Exit.  KVM
+	 * emulates L2 sharing L1's VPID=0 by using vpid01 while running L2,
+	 * and so KVM must also emulate TLB flush of VPID=0, i.e. vpid01.  This
+	 * is required if VPID is disabled in KVM, as a TLB flush (there are no
+	 * VPIDs) still occurs from L1's perspective, and KVM may need to
+	 * synchronize the MMU in response to the guest TLB flush.
 	 *
 	 * Note, using TLB_FLUSH_GUEST is correct even if nested EPT is in use.
 	 * EPT is a special snowflake, as guest-physical mappings aren't
@@ -2315,6 +2318,17 @@ static void prepare_vmcs02_early_rare(struct vcpu_vmx *vmx,
 
 	vmcs_write64(VMCS_LINK_POINTER, INVALID_GPA);
 
+	/*
+	 * If VPID is disabled, then guest TLB accesses use VPID=0, i.e. the
+	 * same VPID as the host.  Emulate this behavior by using vpid01 for L2
+	 * if VPID is disabled in vmcs12.  Note, if VPID is disabled, VM-Enter
+	 * and VM-Exit are architecturally required to flush VPID=0, but *only*
+	 * VPID=0.  I.e. using vpid02 would be ok (so long as KVM emulates the
+	 * required flushes), but doing so would cause KVM to over-flush.  E.g.
+	 * if L1 runs L2 X with VPID12=1, then runs L2 Y with VPID12 disabled,
+	 * and then runs L2 X again, then KVM can and should retain TLB entries
+	 * for VPID12=1.
+	 */
 	if (enable_vpid) {
 		if (nested_cpu_has_vpid(vmcs12) && vmx->nested.vpid02)
 			vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->nested.vpid02);
@@ -5957,6 +5971,12 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		return nested_vmx_fail(vcpu,
 			VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
+	/*
+	 * Always flush the effective vpid02, i.e. never flush the current VPID
+	 * and never explicitly flush vpid01.  INVVPID targets a VPID, not a
+	 * VMCS, and so whether or not the current vmcs12 has VPID enabled is
+	 * irrelevant (and there may not be a loaded vmcs12).
+	 */
 	vpid02 = nested_get_vpid02(vcpu);
 	switch (type) {
 	case VMX_VPID_EXTENT_INDIVIDUAL_ADDR:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6ed801ffe33f..3d4a8d5b0b80 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3213,7 +3213,7 @@ void vmx_flush_tlb_all(struct kvm_vcpu *vcpu)
 
 static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
 {
-	if (is_guest_mode(vcpu))
+	if (is_guest_mode(vcpu) && nested_cpu_has_vpid(get_vmcs12(vcpu)))
 		return nested_get_vpid02(vcpu);
 	return to_vmx(vcpu)->vpid;
 }

base-commit: e466901b947d529f7b091a3b00b19d2bdee206ee
-- 
2.47.0.163.g1226f6d8fa-goog


