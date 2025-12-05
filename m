Return-Path: <kvm+bounces-65389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C69D2CA99DB
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C87F431AD957
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FE9305055;
	Fri,  5 Dec 2025 23:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hq+ookEE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB402FFF87
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976776; cv=none; b=LfNlfpukNeE2ouiUu6qTfGEuOwGALALI+nqxUPzJC/RQ+CToPUxrWYfjfJ1cZgqO9vJZmN6JPUerIPFP6y0yXLcbYo5gzjMWss8xeTKjrtxbVO1UZBEZ6hQa8pLEID9/q6BbrrVudLL6bpWF/d8jZVBI0yoh0IhifUovW4z4MmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976776; c=relaxed/simple;
	bh=XbPk5Zu3tIL1j399oAQsxtB7EnPcWv++KAizvepSQe8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G+AXtYgEdBTVrWMlzffqK1JUn3U87amCl/IuswJAYubauPNSYgfHIZsf4nhX1zB7ia8rgynSE3ZBuU7XwC3tCZ6N25UYRt2iuzJ3kTLYUBjuz3i/f3i2Tjn/IT9G1l+dyn48fWrMojRa7DA7vmiC8hqad8XNXWnaWsmj86RxT1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hq+ookEE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295915934bfso36484785ad.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976772; x=1765581572; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lP72w5ANPVDKsXEE/wDJK3tXHkJNHOZxvL9A3UxnMuQ=;
        b=hq+ookEEOYL89/PbkmUhAMAMayac2mPlX7fXKvRwz3m59Ip3DVTFhj2pbN6W/88hJ5
         MCZdyTxG5D9dA2Q2UlB50UUo93Q1xH8gfCIYwWadBa2p/3UHOe+wZfln9CHpOCk3z4nI
         3AZTc/Ll1MqVKIcEUs/mMbWOpW8WFxkN/4AWeEKWztVTlUO+WX7qiryYYunWy3kZWq2+
         BplS99JTomyhDV1OKFCOfNBBJw3hj1TBhJu0Uf0DNe/nUYwzSKWg+x00YE4VxE3Ow3xR
         xPuMp+yOIbNubU/zkVc5C+HJSeBUh6OKImTCGVMLME+E/QySPLYrCMqlcbQYAEnGlKzp
         J9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976772; x=1765581572;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lP72w5ANPVDKsXEE/wDJK3tXHkJNHOZxvL9A3UxnMuQ=;
        b=bZPYwseM9C1V0q+hrTNxbAAtgpVzv0IQEUtzEIRMsLqAF+83YcRq6H2xa0dztisXDq
         3Cajx1GHprFf8LZN/qpCeBMGglgKfGOYdvv7WKinLOQF+29qAP7GZSDOW8zxiawgH95B
         kAq/5RKwtZWnJiYIKEEVuM/otcppfsBk4peYBELnARGcsCWAklp8IsXS4JKYY/VfRRLO
         1ipkXoqW/hDVquAQKcyvreL4WLAdHwcsPIyQ88BCH+99v1kjlKuXWnilEshTekor1sln
         EnFEIe248nlIEZVvzLUjFEzcl+AA3oNDSQEuzyhkitJxexAaUheMxkJSA1z0MktChh/+
         ofyw==
X-Gm-Message-State: AOJu0Yw1jGq0wySvUdBQK//8TY865xZYpS1bmvXGbhv4TT2CD7sqmzJL
	3DjhO7Cp/36MG7S3PsBOJETiFnM99xKdP+RsqTgZzfrmS2YUVzHis/790EmDgc/lh0tX0mvS2Cr
	0/H6QcA==
X-Google-Smtp-Source: AGHT+IEcncbfzY4bTcbh3luKcr7xp+BgCYnZ3O4gVPcdWIBEayevCgcT/VujQOwDhDSxPh7S+ZSKPXOjFXg=
X-Received: from plpo17.prod.google.com ([2002:a17:903:3e11:b0:29b:89b3:77b5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f8c:b0:294:9813:4512
 with SMTP id d9443c01a7336-29df5472d05mr5187925ad.3.1764976772004; Fri, 05
 Dec 2025 15:19:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:11 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-9-seanjc@google.com>
Subject: [PATCH v3 08/10] KVM: nVMX: Switch to vmcs01 to update APIC page
 on-demand if L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

If the KVM-owned APIC-access page is migrated while L2 is running,
temporarily load vmcs01 and immediately update APIC_ACCESS_ADDR instead
of deferring the update until the next nested VM-Exit.  Once changing
the virtual APIC mode is converted to always do on-demand updates, all
of the "defer until vmcs01 is active" logic will be gone.

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
2.52.0.223.gf5cc29aaa4-goog


