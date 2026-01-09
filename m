Return-Path: <kvm+bounces-67510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B0239D07075
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E3037301FD6B
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA34329C71;
	Fri,  9 Jan 2026 03:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jdftKX3b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1963C24A058
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930347; cv=none; b=V1f31O/EjtWx82SPEa+gThQrwSURiuo88VLzOsz8nwfjXE1JumwPZpLfK7WTdxPglqeRaFTKLYxZI6RnGAyYRUwCG9S1n+FrnxrUWhfo4XgPjeFA/FnVUSEJ6aQHu8xqMtgjXBIW++E1nS3kpZ95nK0f7SwkOk3vMTM3AevNdR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930347; c=relaxed/simple;
	bh=o1kKEv4y9G1l1AcUONDgAB0YJoa373EmyRiTlcErh/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QgGYy5I81ZE9hUY74pbtavDWzH//vtVa9QMv3btBvs0wbHvrkVWBtu0+C6PtCp3IJZ1t5XCqvd0ueNETjQyRfr0rI1HYsAMPM8HV67A8Ak4wEVGW1yczWpwG0BSRKT3I8XXdCQoWQnSC5xLODBHoc8mqFKgZF2AP+F3WeL05f/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jdftKX3b; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a351686c17so48083025ad.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767930345; x=1768535145; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J6s9SI/r2bnHM1n7Bm/zP7cWS7ymjW9gwaRGx74RRrI=;
        b=jdftKX3bPcP9Aatvy4S9m/0nOLlmJdi2RpXf3cqmBcpW121DWJLyiTgemnK//zuap9
         n10G6Lm+2FzzDUolhbvaPDApabreY+iwz5YfOnu5RngS2m7DzQO4vRPNSegcRr5vB4b5
         fNhbI155U3HP8VUmliScSlcEwW+v2J0v4Cu+VvmHHu8qx9qfmruVWUyTsYJEu9DWRklV
         CwIsUP221js2c80ejPdIudPiLiQBujFwtzXS/UP6AAkEcXze+qPORyDImQEaRIByefq2
         9M6uuWhsoCXy++syUN7I7B67GKOT/6j62C9Zj8zEcEQeL/U1cSPyRToLYQ8nCHO47biL
         d6jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930345; x=1768535145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J6s9SI/r2bnHM1n7Bm/zP7cWS7ymjW9gwaRGx74RRrI=;
        b=L0QmEC0IgvMXIwWtRD/DcY2ut3BhB0COENBoFYrE4dFlGEAFweLZMlCCrIFtdXZCA4
         RinfVun9XiUrzUlJMjGkEZQ8b81XWnrwMtYdslXJuZxLfgmdxSxF44tX/7liT2Dor/TJ
         Fdr62CLaKjuYWxKSa73xHT0gYAKgQHoSkQCk07IHKDG6VzAt6+bcMuYqK8P6b89gpMLh
         W2W0+/4P7g2MHjWoeehi71RSaCKoNdQtS+wrLKFt0kElcf+mWGOyEWNvIPdW6JTU4fkK
         vId33BBDWZ6ZCE+hHEFSR8ctMz5KVVkA+MrancJRk6HzRjyCpx/7VweHWvQDC5tG6RbU
         excA==
X-Gm-Message-State: AOJu0Yz4jFSQswnJkD4ntXyl/sbddPLvywvaYR4467yQzMcX+LmHxpBN
	NNUZhVcTnyLr8+xIzPDEom1hbud3XhUy2dmtdOeq1BqHdQMZB+M673F6ZhS176DQzBGqT+qXoVJ
	WhrA7bQ==
X-Google-Smtp-Source: AGHT+IGOKgPXbL3Nx4d+n28wqdscdI7eBJGYNqyaTNz7Nh7KHW8RUVrTgLfwaO8PWz8RoWeT5QsLFUa2oZs=
X-Received: from plkn7.prod.google.com ([2002:a17:902:6a87:b0:2a1:4291:bc8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:40c9:b0:298:3aa6:c03d
 with SMTP id d9443c01a7336-2a3ee51bdd6mr87464325ad.57.1767930345433; Thu, 08
 Jan 2026 19:45:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:45:30 -0800
In-Reply-To: <20260109034532.1012993-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109034532.1012993-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109034532.1012993-7-seanjc@google.com>
Subject: [PATCH v4 6/8] KVM: nVMX: Switch to vmcs01 to update APIC page
 on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

If the KVM-owned APIC-access page is migrated while L2 is running,
temporarily load vmcs01 and immediately update APIC_ACCESS_ADDR instead
of deferring the update until the next nested VM-Exit.  Once changing
the virtual APIC mode is converted to always do on-demand updates, all
of the "defer until vmcs01 is active" logic will be gone.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 5 -----
 arch/x86/kvm/vmx/vmx.c    | 7 ++-----
 arch/x86/kvm/vmx/vmx.h    | 1 -
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2b0702349aa1..8196a1ac22e1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5150,11 +5150,6 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 
 	nested_put_vmcs12_pages(vcpu);
 
-	if (vmx->nested.reload_vmcs01_apic_access_page) {
-		vmx->nested.reload_vmcs01_apic_access_page = false;
-		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
-	}
-
 	if ((vm_exit_reason != -1) &&
 	    (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx)))
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 90e167f296d0..af8ec72e8ebf 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6895,11 +6895,8 @@ void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	kvm_pfn_t pfn;
 	bool writable;
 
-	/* Defer reload until vmcs01 is the current VMCS. */
-	if (is_guest_mode(vcpu)) {
-		to_vmx(vcpu)->nested.reload_vmcs01_apic_access_page = true;
-		return;
-	}
+	/* Note, the VIRTUALIZE_APIC_ACCESSES check needs to query vmcs01. */
+	guard(vmx_vmcs01)(vcpu);
 
 	if (!(secondary_exec_controls_get(to_vmx(vcpu)) &
 	    SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index dfc9766a7fa3..078bc6fef7e6 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -132,7 +132,6 @@ struct nested_vmx {
 	bool vmcs02_initialized;
 
 	bool change_vmcs01_virtual_apic_mode;
-	bool reload_vmcs01_apic_access_page;
 
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
-- 
2.52.0.457.g6b5491de43-goog


