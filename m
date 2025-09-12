Return-Path: <kvm+bounces-57458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40963B55A1B
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:28:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F8671D63406
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:28:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38C57286897;
	Fri, 12 Sep 2025 23:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vwwtle6r"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17B02D73AB
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719433; cv=none; b=Q1FolFmxxZ028iDMEB3B8IudPZgdtjDwWeHUmfbcEoWvNdC9yWoO0blImqPwjzBNy6X8oGl6Xzd7aAh9GCBIR1mIcagz+cjVGl1yV/deYB18D/t/xFYrlU54UxBqN2WSgPTdSEAvilQM4kOAN7MdpnlAX5FScoOD5MQXBIqDJ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719433; c=relaxed/simple;
	bh=JEEiCFkCBP5ttonqiWIsRl8yCbVxEhdAgkHtYSFLdVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EP9l911UNxAz+eOouS1DeREgTcTPbDVSS2lbCZi2KHdWjv9R0EMqjydoLpmITxe8klKD2sIoD0otMrJTPVwOylKuqfXRvyJqry/KMql2FGOMlNWprQ5fMFjx72F2TphezcY2habLmkPbgN4mZtes2o3Pioh8X5oNAhpNDAaOwdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vwwtle6r; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-25db2a95f88so8215835ad.0
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719431; x=1758324231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=oNB6mEDZxyaqSYryMY9uR6ecFN+PIMonXdA8ZyarKi0=;
        b=Vwwtle6rTcDDy/09sHRRtrONQ9ZaaKagG4e/HKwA2TY1kywnzAXad52SNvQ7cyDOhP
         5HX+VlHSNJpNe7xIjdrAglbV/w3k/U4ECt141gv1Q8YIzvowxzfPM0oKHrGmtFCIhRsZ
         l7Dx7PMijQ5gzKq78ZMm+IIFvO8uO7PbYyYbOYf35rJIBusRQ7VQjfHcN7n6g15JGTwK
         DnkcfGzwoBxJvilU2iBTVtaXppxb8Vmk0yUVNMHh4n7UQVEZ7FR6MBTjuXCQUI1Vg2X8
         YoJNMHbyzUCZZya1PVLd5SJc6F8q2TV0qb3QZVJWqsFW3AlOWHgKaTZXCExMvvEILUCf
         qhzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719431; x=1758324231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oNB6mEDZxyaqSYryMY9uR6ecFN+PIMonXdA8ZyarKi0=;
        b=XF9CJHv5hajehQzzMC1XLuxdy8JotHaKpR+OBvvHxlH6JOKu7tQeITV/PjBOMGusYV
         qV7A3OMjOpy20fLV7KEq7Y/7QdqNP767Bk9HyUWq0NDe2n322l7uP+qLYoLXbM4AUMAj
         hHQW84IKfSR2jjGgAlRLZc8Nmf6vF262S2oq/AzWXDIw1wDftnUhfFuC/9PZvmVGVjQB
         ci1TJkK9QDmiEDmLbYZf9V8J8y5Lp77Q5vkrLxejPPSXbVenMdNFu/DPnDkHvbCRlgU5
         SCYTa0mOqWtIJ9HcYsXlJA2j5aQAfZVIia1Wwx5ccEzZELIKEk2rVDbs4rigO4JvCXUi
         HU/A==
X-Gm-Message-State: AOJu0YxTSjikJ2pDk8oEY9AfYj1xqt08dYNndMl9NZH2lWqpRoEdUS8R
	brKAWVqVC6WgFUMez8N5vwJ7yglNN8seo5MsM1rRahO9Tf1vUY24TUrML7gzt5IFbMSS1mC/Vue
	KxJxu0Q==
X-Google-Smtp-Source: AGHT+IGS+NoAkSIvkgqHUng4iiyhhkD7f5OcKeKYit5O8WCfjDkLzEvEzCprS1GK1c6HC/ZzIm4cvgzzR3k=
X-Received: from pjzz6.prod.google.com ([2002:a17:90b:58e6:b0:327:e172:e96])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c3:b0:24c:ea1c:1156
 with SMTP id d9443c01a7336-25bae1218abmr92927335ad.24.1757719431283; Fri, 12
 Sep 2025 16:23:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:53 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-16-seanjc@google.com>
Subject: [PATCH v15 15/41] KVM: x86: Save and reload SSP to/from SMRAM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
one of such registers on 64-bit Arch, and add the support for SSP.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/smm.c | 8 ++++++++
 arch/x86/kvm/smm.h | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 5dd8a1646800..b0b14ba37f9a 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -269,6 +269,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
 	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
 
 	smram->int_shadow = kvm_x86_call(get_interrupt_shadow)(vcpu);
+
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    kvm_msr_read(vcpu, MSR_KVM_INTERNAL_GUEST_SSP, &smram->ssp))
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 }
 #endif
 
@@ -558,6 +562,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 	kvm_x86_call(set_interrupt_shadow)(vcpu, 0);
 	ctxt->interruptibility = (u8)smstate->int_shadow;
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) &&
+	    kvm_msr_write(vcpu, MSR_KVM_INTERNAL_GUEST_SSP, smstate->ssp))
+		return X86EMUL_UNHANDLEABLE;
+
 	return X86EMUL_CONTINUE;
 }
 #endif
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index 551703fbe200..db3c88f16138 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
 	u32 smbase;
 	u32 reserved4[5];
 
-	/* ssp and svm_* fields below are not implemented by KVM */
 	u64 ssp;
+	/* svm_* fields below are not implemented by KVM */
 	u64 svm_guest_pat;
 	u64 svm_host_efer;
 	u64 svm_host_cr4;
-- 
2.51.0.384.g4c02a37b29-goog


